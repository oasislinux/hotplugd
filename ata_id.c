#define _POSIX_C_SOURCE 200809L
#include <errno.h>
#include <stdio.h>
#include <string.h>
#include <fcntl.h>
#include <sys/ioctl.h>
#include <scsi/sg.h>

static void
stringfield(const unsigned char *buf, char *str, size_t len)
{
	const unsigned char *end;

	end = buf + len;
	while (buf < end && *buf == ' ')
		++buf;
	if (end - buf >= 2 && buf[1] == ' ')
		*str++ = buf[0], buf += 2;
	while (end - buf >= 2) {
		if (buf[1] == ' ')
			break;
		*str++ = buf[1];
		if (buf[0] == ' ')
			break;
		*str++ = buf[0];
		buf += 2;
	}
	*str = '\0';
}

int
main(int argc, char *argv[])
{
	static const unsigned char cmd[16] = {
		[0] = 0x85, 0x08, 0x0e,
		[6] = 1,
		[14] = 0xec,
	};
	unsigned char buf[512];
	sg_io_hdr_t hdr = {
		.interface_id = 'S',
		.dxfer_direction = SG_DXFER_FROM_DEV,
		.cmd_len = sizeof cmd,
		.dxfer_len = sizeof buf,
		.dxferp = buf,
		.cmdp = (void *)cmd,
		.timeout = 5000,
	};
	const char *dev;
	char model[41], serial[21];
	int fd;

	if (argc != 2) {
		fputs("usage: ata_id device\n", stderr);
		return 1;
	}
	dev = argv[1];

	fd = open(dev, O_RDONLY);
	if (fd < 0) {
		fprintf(stderr, "open %s: %s", dev, strerror(errno));
		return 1;
	}
	if (ioctl(fd, SG_IO, &hdr) < 0) {
		perror(NULL);
		return 1;
	}
	if (hdr.status != 0 || hdr.host_status != 0 || hdr.driver_status != 0) {
		fprintf(stderr, "IDENTIFY DEVICE failed\n");
		return 1;
	}

	stringfield(buf + 52, model, 40);
	stringfield(buf + 20, serial, 20);
	printf("%s_%s\n", model, serial);
	fflush(stdout);
	if (ferror(stdout)) {
		fprintf(stderr, "write failed\n");
		return 1;
	}
}
