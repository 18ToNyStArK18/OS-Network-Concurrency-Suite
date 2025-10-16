
user/_ln:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <main>:
#include "kernel/stat.h"
#include "user/user.h"

int
main(int argc, char *argv[])
{
   0:	1101                	addi	sp,sp,-32
   2:	ec06                	sd	ra,24(sp)
   4:	e822                	sd	s0,16(sp)
   6:	1000                	addi	s0,sp,32
  if(argc != 3){
   8:	478d                	li	a5,3
   a:	00f50d63          	beq	a0,a5,24 <main+0x24>
   e:	e426                	sd	s1,8(sp)
    fprintf(2, "Usage: ln old new\n");
  10:	00001597          	auipc	a1,0x1
  14:	8f058593          	addi	a1,a1,-1808 # 900 <malloc+0xf6>
  18:	4509                	li	a0,2
  1a:	70e000ef          	jal	728 <fprintf>
    exit(1);
  1e:	4505                	li	a0,1
  20:	2e4000ef          	jal	304 <exit>
  24:	e426                	sd	s1,8(sp)
  26:	84ae                	mv	s1,a1
  }
  if(link(argv[1], argv[2]) < 0)
  28:	698c                	ld	a1,16(a1)
  2a:	6488                	ld	a0,8(s1)
  2c:	338000ef          	jal	364 <link>
  30:	00054563          	bltz	a0,3a <main+0x3a>
    fprintf(2, "link %s %s: failed\n", argv[1], argv[2]);
  exit(0);
  34:	4501                	li	a0,0
  36:	2ce000ef          	jal	304 <exit>
    fprintf(2, "link %s %s: failed\n", argv[1], argv[2]);
  3a:	6894                	ld	a3,16(s1)
  3c:	6490                	ld	a2,8(s1)
  3e:	00001597          	auipc	a1,0x1
  42:	8da58593          	addi	a1,a1,-1830 # 918 <malloc+0x10e>
  46:	4509                	li	a0,2
  48:	6e0000ef          	jal	728 <fprintf>
  4c:	b7e5                	j	34 <main+0x34>

000000000000004e <start>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
start(int argc, char **argv)
{
  4e:	1141                	addi	sp,sp,-16
  50:	e406                	sd	ra,8(sp)
  52:	e022                	sd	s0,0(sp)
  54:	0800                	addi	s0,sp,16
  int r;
  extern int main(int argc, char **argv);
  r = main(argc, argv);
  56:	fabff0ef          	jal	0 <main>
  exit(r);
  5a:	2aa000ef          	jal	304 <exit>

000000000000005e <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
  5e:	1141                	addi	sp,sp,-16
  60:	e406                	sd	ra,8(sp)
  62:	e022                	sd	s0,0(sp)
  64:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
  66:	87aa                	mv	a5,a0
  68:	0585                	addi	a1,a1,1
  6a:	0785                	addi	a5,a5,1
  6c:	fff5c703          	lbu	a4,-1(a1)
  70:	fee78fa3          	sb	a4,-1(a5)
  74:	fb75                	bnez	a4,68 <strcpy+0xa>
    ;
  return os;
}
  76:	60a2                	ld	ra,8(sp)
  78:	6402                	ld	s0,0(sp)
  7a:	0141                	addi	sp,sp,16
  7c:	8082                	ret

000000000000007e <strcmp>:

int
strcmp(const char *p, const char *q)
{
  7e:	1141                	addi	sp,sp,-16
  80:	e406                	sd	ra,8(sp)
  82:	e022                	sd	s0,0(sp)
  84:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
  86:	00054783          	lbu	a5,0(a0)
  8a:	cb91                	beqz	a5,9e <strcmp+0x20>
  8c:	0005c703          	lbu	a4,0(a1)
  90:	00f71763          	bne	a4,a5,9e <strcmp+0x20>
    p++, q++;
  94:	0505                	addi	a0,a0,1
  96:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
  98:	00054783          	lbu	a5,0(a0)
  9c:	fbe5                	bnez	a5,8c <strcmp+0xe>
  return (uchar)*p - (uchar)*q;
  9e:	0005c503          	lbu	a0,0(a1)
}
  a2:	40a7853b          	subw	a0,a5,a0
  a6:	60a2                	ld	ra,8(sp)
  a8:	6402                	ld	s0,0(sp)
  aa:	0141                	addi	sp,sp,16
  ac:	8082                	ret

00000000000000ae <strlen>:

uint
strlen(const char *s)
{
  ae:	1141                	addi	sp,sp,-16
  b0:	e406                	sd	ra,8(sp)
  b2:	e022                	sd	s0,0(sp)
  b4:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
  b6:	00054783          	lbu	a5,0(a0)
  ba:	cf91                	beqz	a5,d6 <strlen+0x28>
  bc:	00150793          	addi	a5,a0,1
  c0:	86be                	mv	a3,a5
  c2:	0785                	addi	a5,a5,1
  c4:	fff7c703          	lbu	a4,-1(a5)
  c8:	ff65                	bnez	a4,c0 <strlen+0x12>
  ca:	40a6853b          	subw	a0,a3,a0
    ;
  return n;
}
  ce:	60a2                	ld	ra,8(sp)
  d0:	6402                	ld	s0,0(sp)
  d2:	0141                	addi	sp,sp,16
  d4:	8082                	ret
  for(n = 0; s[n]; n++)
  d6:	4501                	li	a0,0
  d8:	bfdd                	j	ce <strlen+0x20>

00000000000000da <memset>:

void*
memset(void *dst, int c, uint n)
{
  da:	1141                	addi	sp,sp,-16
  dc:	e406                	sd	ra,8(sp)
  de:	e022                	sd	s0,0(sp)
  e0:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
  e2:	ca19                	beqz	a2,f8 <memset+0x1e>
  e4:	87aa                	mv	a5,a0
  e6:	1602                	slli	a2,a2,0x20
  e8:	9201                	srli	a2,a2,0x20
  ea:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
  ee:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
  f2:	0785                	addi	a5,a5,1
  f4:	fee79de3          	bne	a5,a4,ee <memset+0x14>
  }
  return dst;
}
  f8:	60a2                	ld	ra,8(sp)
  fa:	6402                	ld	s0,0(sp)
  fc:	0141                	addi	sp,sp,16
  fe:	8082                	ret

0000000000000100 <strchr>:

char*
strchr(const char *s, char c)
{
 100:	1141                	addi	sp,sp,-16
 102:	e406                	sd	ra,8(sp)
 104:	e022                	sd	s0,0(sp)
 106:	0800                	addi	s0,sp,16
  for(; *s; s++)
 108:	00054783          	lbu	a5,0(a0)
 10c:	cf81                	beqz	a5,124 <strchr+0x24>
    if(*s == c)
 10e:	00f58763          	beq	a1,a5,11c <strchr+0x1c>
  for(; *s; s++)
 112:	0505                	addi	a0,a0,1
 114:	00054783          	lbu	a5,0(a0)
 118:	fbfd                	bnez	a5,10e <strchr+0xe>
      return (char*)s;
  return 0;
 11a:	4501                	li	a0,0
}
 11c:	60a2                	ld	ra,8(sp)
 11e:	6402                	ld	s0,0(sp)
 120:	0141                	addi	sp,sp,16
 122:	8082                	ret
  return 0;
 124:	4501                	li	a0,0
 126:	bfdd                	j	11c <strchr+0x1c>

0000000000000128 <gets>:

char*
gets(char *buf, int max)
{
 128:	711d                	addi	sp,sp,-96
 12a:	ec86                	sd	ra,88(sp)
 12c:	e8a2                	sd	s0,80(sp)
 12e:	e4a6                	sd	s1,72(sp)
 130:	e0ca                	sd	s2,64(sp)
 132:	fc4e                	sd	s3,56(sp)
 134:	f852                	sd	s4,48(sp)
 136:	f456                	sd	s5,40(sp)
 138:	f05a                	sd	s6,32(sp)
 13a:	ec5e                	sd	s7,24(sp)
 13c:	e862                	sd	s8,16(sp)
 13e:	1080                	addi	s0,sp,96
 140:	8baa                	mv	s7,a0
 142:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 144:	892a                	mv	s2,a0
 146:	4481                	li	s1,0
    cc = read(0, &c, 1);
 148:	faf40b13          	addi	s6,s0,-81
 14c:	4a85                	li	s5,1
  for(i=0; i+1 < max; ){
 14e:	8c26                	mv	s8,s1
 150:	0014899b          	addiw	s3,s1,1
 154:	84ce                	mv	s1,s3
 156:	0349d463          	bge	s3,s4,17e <gets+0x56>
    cc = read(0, &c, 1);
 15a:	8656                	mv	a2,s5
 15c:	85da                	mv	a1,s6
 15e:	4501                	li	a0,0
 160:	1bc000ef          	jal	31c <read>
    if(cc < 1)
 164:	00a05d63          	blez	a0,17e <gets+0x56>
      break;
    buf[i++] = c;
 168:	faf44783          	lbu	a5,-81(s0)
 16c:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 170:	0905                	addi	s2,s2,1
 172:	ff678713          	addi	a4,a5,-10
 176:	c319                	beqz	a4,17c <gets+0x54>
 178:	17cd                	addi	a5,a5,-13
 17a:	fbf1                	bnez	a5,14e <gets+0x26>
    buf[i++] = c;
 17c:	8c4e                	mv	s8,s3
      break;
  }
  buf[i] = '\0';
 17e:	9c5e                	add	s8,s8,s7
 180:	000c0023          	sb	zero,0(s8)
  return buf;
}
 184:	855e                	mv	a0,s7
 186:	60e6                	ld	ra,88(sp)
 188:	6446                	ld	s0,80(sp)
 18a:	64a6                	ld	s1,72(sp)
 18c:	6906                	ld	s2,64(sp)
 18e:	79e2                	ld	s3,56(sp)
 190:	7a42                	ld	s4,48(sp)
 192:	7aa2                	ld	s5,40(sp)
 194:	7b02                	ld	s6,32(sp)
 196:	6be2                	ld	s7,24(sp)
 198:	6c42                	ld	s8,16(sp)
 19a:	6125                	addi	sp,sp,96
 19c:	8082                	ret

000000000000019e <stat>:

int
stat(const char *n, struct stat *st)
{
 19e:	1101                	addi	sp,sp,-32
 1a0:	ec06                	sd	ra,24(sp)
 1a2:	e822                	sd	s0,16(sp)
 1a4:	e04a                	sd	s2,0(sp)
 1a6:	1000                	addi	s0,sp,32
 1a8:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 1aa:	4581                	li	a1,0
 1ac:	198000ef          	jal	344 <open>
  if(fd < 0)
 1b0:	02054263          	bltz	a0,1d4 <stat+0x36>
 1b4:	e426                	sd	s1,8(sp)
 1b6:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 1b8:	85ca                	mv	a1,s2
 1ba:	1a2000ef          	jal	35c <fstat>
 1be:	892a                	mv	s2,a0
  close(fd);
 1c0:	8526                	mv	a0,s1
 1c2:	16a000ef          	jal	32c <close>
  return r;
 1c6:	64a2                	ld	s1,8(sp)
}
 1c8:	854a                	mv	a0,s2
 1ca:	60e2                	ld	ra,24(sp)
 1cc:	6442                	ld	s0,16(sp)
 1ce:	6902                	ld	s2,0(sp)
 1d0:	6105                	addi	sp,sp,32
 1d2:	8082                	ret
    return -1;
 1d4:	57fd                	li	a5,-1
 1d6:	893e                	mv	s2,a5
 1d8:	bfc5                	j	1c8 <stat+0x2a>

00000000000001da <atoi>:

int
atoi(const char *s)
{
 1da:	1141                	addi	sp,sp,-16
 1dc:	e406                	sd	ra,8(sp)
 1de:	e022                	sd	s0,0(sp)
 1e0:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 1e2:	00054683          	lbu	a3,0(a0)
 1e6:	fd06879b          	addiw	a5,a3,-48
 1ea:	0ff7f793          	zext.b	a5,a5
 1ee:	4625                	li	a2,9
 1f0:	02f66963          	bltu	a2,a5,222 <atoi+0x48>
 1f4:	872a                	mv	a4,a0
  n = 0;
 1f6:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
 1f8:	0705                	addi	a4,a4,1
 1fa:	0025179b          	slliw	a5,a0,0x2
 1fe:	9fa9                	addw	a5,a5,a0
 200:	0017979b          	slliw	a5,a5,0x1
 204:	9fb5                	addw	a5,a5,a3
 206:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 20a:	00074683          	lbu	a3,0(a4)
 20e:	fd06879b          	addiw	a5,a3,-48
 212:	0ff7f793          	zext.b	a5,a5
 216:	fef671e3          	bgeu	a2,a5,1f8 <atoi+0x1e>
  return n;
}
 21a:	60a2                	ld	ra,8(sp)
 21c:	6402                	ld	s0,0(sp)
 21e:	0141                	addi	sp,sp,16
 220:	8082                	ret
  n = 0;
 222:	4501                	li	a0,0
 224:	bfdd                	j	21a <atoi+0x40>

0000000000000226 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 226:	1141                	addi	sp,sp,-16
 228:	e406                	sd	ra,8(sp)
 22a:	e022                	sd	s0,0(sp)
 22c:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 22e:	02b57563          	bgeu	a0,a1,258 <memmove+0x32>
    while(n-- > 0)
 232:	00c05f63          	blez	a2,250 <memmove+0x2a>
 236:	1602                	slli	a2,a2,0x20
 238:	9201                	srli	a2,a2,0x20
 23a:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 23e:	872a                	mv	a4,a0
      *dst++ = *src++;
 240:	0585                	addi	a1,a1,1
 242:	0705                	addi	a4,a4,1
 244:	fff5c683          	lbu	a3,-1(a1)
 248:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 24c:	fee79ae3          	bne	a5,a4,240 <memmove+0x1a>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 250:	60a2                	ld	ra,8(sp)
 252:	6402                	ld	s0,0(sp)
 254:	0141                	addi	sp,sp,16
 256:	8082                	ret
    while(n-- > 0)
 258:	fec05ce3          	blez	a2,250 <memmove+0x2a>
    dst += n;
 25c:	00c50733          	add	a4,a0,a2
    src += n;
 260:	95b2                	add	a1,a1,a2
 262:	fff6079b          	addiw	a5,a2,-1
 266:	1782                	slli	a5,a5,0x20
 268:	9381                	srli	a5,a5,0x20
 26a:	fff7c793          	not	a5,a5
 26e:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 270:	15fd                	addi	a1,a1,-1
 272:	177d                	addi	a4,a4,-1
 274:	0005c683          	lbu	a3,0(a1)
 278:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 27c:	fef71ae3          	bne	a4,a5,270 <memmove+0x4a>
 280:	bfc1                	j	250 <memmove+0x2a>

0000000000000282 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 282:	1141                	addi	sp,sp,-16
 284:	e406                	sd	ra,8(sp)
 286:	e022                	sd	s0,0(sp)
 288:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 28a:	c61d                	beqz	a2,2b8 <memcmp+0x36>
 28c:	1602                	slli	a2,a2,0x20
 28e:	9201                	srli	a2,a2,0x20
 290:	00c506b3          	add	a3,a0,a2
    if (*p1 != *p2) {
 294:	00054783          	lbu	a5,0(a0)
 298:	0005c703          	lbu	a4,0(a1)
 29c:	00e79863          	bne	a5,a4,2ac <memcmp+0x2a>
      return *p1 - *p2;
    }
    p1++;
 2a0:	0505                	addi	a0,a0,1
    p2++;
 2a2:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 2a4:	fed518e3          	bne	a0,a3,294 <memcmp+0x12>
  }
  return 0;
 2a8:	4501                	li	a0,0
 2aa:	a019                	j	2b0 <memcmp+0x2e>
      return *p1 - *p2;
 2ac:	40e7853b          	subw	a0,a5,a4
}
 2b0:	60a2                	ld	ra,8(sp)
 2b2:	6402                	ld	s0,0(sp)
 2b4:	0141                	addi	sp,sp,16
 2b6:	8082                	ret
  return 0;
 2b8:	4501                	li	a0,0
 2ba:	bfdd                	j	2b0 <memcmp+0x2e>

00000000000002bc <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 2bc:	1141                	addi	sp,sp,-16
 2be:	e406                	sd	ra,8(sp)
 2c0:	e022                	sd	s0,0(sp)
 2c2:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 2c4:	f63ff0ef          	jal	226 <memmove>
}
 2c8:	60a2                	ld	ra,8(sp)
 2ca:	6402                	ld	s0,0(sp)
 2cc:	0141                	addi	sp,sp,16
 2ce:	8082                	ret

00000000000002d0 <sbrk>:

char *
sbrk(int n) {
 2d0:	1141                	addi	sp,sp,-16
 2d2:	e406                	sd	ra,8(sp)
 2d4:	e022                	sd	s0,0(sp)
 2d6:	0800                	addi	s0,sp,16
  return sys_sbrk(n, SBRK_EAGER);
 2d8:	4585                	li	a1,1
 2da:	0b2000ef          	jal	38c <sys_sbrk>
}
 2de:	60a2                	ld	ra,8(sp)
 2e0:	6402                	ld	s0,0(sp)
 2e2:	0141                	addi	sp,sp,16
 2e4:	8082                	ret

00000000000002e6 <sbrklazy>:

char *
sbrklazy(int n) {
 2e6:	1141                	addi	sp,sp,-16
 2e8:	e406                	sd	ra,8(sp)
 2ea:	e022                	sd	s0,0(sp)
 2ec:	0800                	addi	s0,sp,16
  return sys_sbrk(n, SBRK_LAZY);
 2ee:	4589                	li	a1,2
 2f0:	09c000ef          	jal	38c <sys_sbrk>
}
 2f4:	60a2                	ld	ra,8(sp)
 2f6:	6402                	ld	s0,0(sp)
 2f8:	0141                	addi	sp,sp,16
 2fa:	8082                	ret

00000000000002fc <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 2fc:	4885                	li	a7,1
 ecall
 2fe:	00000073          	ecall
 ret
 302:	8082                	ret

0000000000000304 <exit>:
.global exit
exit:
 li a7, SYS_exit
 304:	4889                	li	a7,2
 ecall
 306:	00000073          	ecall
 ret
 30a:	8082                	ret

000000000000030c <wait>:
.global wait
wait:
 li a7, SYS_wait
 30c:	488d                	li	a7,3
 ecall
 30e:	00000073          	ecall
 ret
 312:	8082                	ret

0000000000000314 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 314:	4891                	li	a7,4
 ecall
 316:	00000073          	ecall
 ret
 31a:	8082                	ret

000000000000031c <read>:
.global read
read:
 li a7, SYS_read
 31c:	4895                	li	a7,5
 ecall
 31e:	00000073          	ecall
 ret
 322:	8082                	ret

0000000000000324 <write>:
.global write
write:
 li a7, SYS_write
 324:	48c1                	li	a7,16
 ecall
 326:	00000073          	ecall
 ret
 32a:	8082                	ret

000000000000032c <close>:
.global close
close:
 li a7, SYS_close
 32c:	48d5                	li	a7,21
 ecall
 32e:	00000073          	ecall
 ret
 332:	8082                	ret

0000000000000334 <kill>:
.global kill
kill:
 li a7, SYS_kill
 334:	4899                	li	a7,6
 ecall
 336:	00000073          	ecall
 ret
 33a:	8082                	ret

000000000000033c <exec>:
.global exec
exec:
 li a7, SYS_exec
 33c:	489d                	li	a7,7
 ecall
 33e:	00000073          	ecall
 ret
 342:	8082                	ret

0000000000000344 <open>:
.global open
open:
 li a7, SYS_open
 344:	48bd                	li	a7,15
 ecall
 346:	00000073          	ecall
 ret
 34a:	8082                	ret

000000000000034c <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 34c:	48c5                	li	a7,17
 ecall
 34e:	00000073          	ecall
 ret
 352:	8082                	ret

0000000000000354 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 354:	48c9                	li	a7,18
 ecall
 356:	00000073          	ecall
 ret
 35a:	8082                	ret

000000000000035c <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 35c:	48a1                	li	a7,8
 ecall
 35e:	00000073          	ecall
 ret
 362:	8082                	ret

0000000000000364 <link>:
.global link
link:
 li a7, SYS_link
 364:	48cd                	li	a7,19
 ecall
 366:	00000073          	ecall
 ret
 36a:	8082                	ret

000000000000036c <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 36c:	48d1                	li	a7,20
 ecall
 36e:	00000073          	ecall
 ret
 372:	8082                	ret

0000000000000374 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 374:	48a5                	li	a7,9
 ecall
 376:	00000073          	ecall
 ret
 37a:	8082                	ret

000000000000037c <dup>:
.global dup
dup:
 li a7, SYS_dup
 37c:	48a9                	li	a7,10
 ecall
 37e:	00000073          	ecall
 ret
 382:	8082                	ret

0000000000000384 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 384:	48ad                	li	a7,11
 ecall
 386:	00000073          	ecall
 ret
 38a:	8082                	ret

000000000000038c <sys_sbrk>:
.global sys_sbrk
sys_sbrk:
 li a7, SYS_sbrk
 38c:	48b1                	li	a7,12
 ecall
 38e:	00000073          	ecall
 ret
 392:	8082                	ret

0000000000000394 <pause>:
.global pause
pause:
 li a7, SYS_pause
 394:	48b5                	li	a7,13
 ecall
 396:	00000073          	ecall
 ret
 39a:	8082                	ret

000000000000039c <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 39c:	48b9                	li	a7,14
 ecall
 39e:	00000073          	ecall
 ret
 3a2:	8082                	ret

00000000000003a4 <memstat>:
.global memstat
memstat:
 li a7, SYS_memstat
 3a4:	48d9                	li	a7,22
 ecall
 3a6:	00000073          	ecall
 ret
 3aa:	8082                	ret

00000000000003ac <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 3ac:	1101                	addi	sp,sp,-32
 3ae:	ec06                	sd	ra,24(sp)
 3b0:	e822                	sd	s0,16(sp)
 3b2:	1000                	addi	s0,sp,32
 3b4:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 3b8:	4605                	li	a2,1
 3ba:	fef40593          	addi	a1,s0,-17
 3be:	f67ff0ef          	jal	324 <write>
}
 3c2:	60e2                	ld	ra,24(sp)
 3c4:	6442                	ld	s0,16(sp)
 3c6:	6105                	addi	sp,sp,32
 3c8:	8082                	ret

00000000000003ca <printint>:

static void
printint(int fd, long long xx, int base, int sgn)
{
 3ca:	715d                	addi	sp,sp,-80
 3cc:	e486                	sd	ra,72(sp)
 3ce:	e0a2                	sd	s0,64(sp)
 3d0:	f84a                	sd	s2,48(sp)
 3d2:	f44e                	sd	s3,40(sp)
 3d4:	0880                	addi	s0,sp,80
 3d6:	892a                	mv	s2,a0
  char buf[20];
  int i, neg;
  unsigned long long x;

  neg = 0;
  if(sgn && xx < 0){
 3d8:	c6d1                	beqz	a3,464 <printint+0x9a>
 3da:	0805d563          	bgez	a1,464 <printint+0x9a>
    neg = 1;
    x = -xx;
 3de:	40b005b3          	neg	a1,a1
    neg = 1;
 3e2:	4305                	li	t1,1
  } else {
    x = xx;
  }

  i = 0;
 3e4:	fb840993          	addi	s3,s0,-72
  neg = 0;
 3e8:	86ce                	mv	a3,s3
  i = 0;
 3ea:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 3ec:	00000817          	auipc	a6,0x0
 3f0:	54c80813          	addi	a6,a6,1356 # 938 <digits>
 3f4:	88ba                	mv	a7,a4
 3f6:	0017051b          	addiw	a0,a4,1
 3fa:	872a                	mv	a4,a0
 3fc:	02c5f7b3          	remu	a5,a1,a2
 400:	97c2                	add	a5,a5,a6
 402:	0007c783          	lbu	a5,0(a5)
 406:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 40a:	87ae                	mv	a5,a1
 40c:	02c5d5b3          	divu	a1,a1,a2
 410:	0685                	addi	a3,a3,1
 412:	fec7f1e3          	bgeu	a5,a2,3f4 <printint+0x2a>
  if(neg)
 416:	00030c63          	beqz	t1,42e <printint+0x64>
    buf[i++] = '-';
 41a:	fd050793          	addi	a5,a0,-48
 41e:	00878533          	add	a0,a5,s0
 422:	02d00793          	li	a5,45
 426:	fef50423          	sb	a5,-24(a0)
 42a:	0028871b          	addiw	a4,a7,2

  while(--i >= 0)
 42e:	02e05563          	blez	a4,458 <printint+0x8e>
 432:	fc26                	sd	s1,56(sp)
 434:	377d                	addiw	a4,a4,-1
 436:	00e984b3          	add	s1,s3,a4
 43a:	19fd                	addi	s3,s3,-1
 43c:	99ba                	add	s3,s3,a4
 43e:	1702                	slli	a4,a4,0x20
 440:	9301                	srli	a4,a4,0x20
 442:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 446:	0004c583          	lbu	a1,0(s1)
 44a:	854a                	mv	a0,s2
 44c:	f61ff0ef          	jal	3ac <putc>
  while(--i >= 0)
 450:	14fd                	addi	s1,s1,-1
 452:	ff349ae3          	bne	s1,s3,446 <printint+0x7c>
 456:	74e2                	ld	s1,56(sp)
}
 458:	60a6                	ld	ra,72(sp)
 45a:	6406                	ld	s0,64(sp)
 45c:	7942                	ld	s2,48(sp)
 45e:	79a2                	ld	s3,40(sp)
 460:	6161                	addi	sp,sp,80
 462:	8082                	ret
  neg = 0;
 464:	4301                	li	t1,0
 466:	bfbd                	j	3e4 <printint+0x1a>

0000000000000468 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %c, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 468:	711d                	addi	sp,sp,-96
 46a:	ec86                	sd	ra,88(sp)
 46c:	e8a2                	sd	s0,80(sp)
 46e:	e4a6                	sd	s1,72(sp)
 470:	1080                	addi	s0,sp,96
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 472:	0005c483          	lbu	s1,0(a1)
 476:	22048363          	beqz	s1,69c <vprintf+0x234>
 47a:	e0ca                	sd	s2,64(sp)
 47c:	fc4e                	sd	s3,56(sp)
 47e:	f852                	sd	s4,48(sp)
 480:	f456                	sd	s5,40(sp)
 482:	f05a                	sd	s6,32(sp)
 484:	ec5e                	sd	s7,24(sp)
 486:	e862                	sd	s8,16(sp)
 488:	8b2a                	mv	s6,a0
 48a:	8a2e                	mv	s4,a1
 48c:	8bb2                	mv	s7,a2
  state = 0;
 48e:	4981                	li	s3,0
  for(i = 0; fmt[i]; i++){
 490:	4901                	li	s2,0
 492:	4701                	li	a4,0
      if(c0 == '%'){
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if(state == '%'){
 494:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if(c0) c1 = fmt[i+1] & 0xff;
      if(c1) c2 = fmt[i+2] & 0xff;
      if(c0 == 'd'){
 498:	06400c13          	li	s8,100
 49c:	a00d                	j	4be <vprintf+0x56>
        putc(fd, c0);
 49e:	85a6                	mv	a1,s1
 4a0:	855a                	mv	a0,s6
 4a2:	f0bff0ef          	jal	3ac <putc>
 4a6:	a019                	j	4ac <vprintf+0x44>
    } else if(state == '%'){
 4a8:	03598363          	beq	s3,s5,4ce <vprintf+0x66>
  for(i = 0; fmt[i]; i++){
 4ac:	0019079b          	addiw	a5,s2,1
 4b0:	893e                	mv	s2,a5
 4b2:	873e                	mv	a4,a5
 4b4:	97d2                	add	a5,a5,s4
 4b6:	0007c483          	lbu	s1,0(a5)
 4ba:	1c048a63          	beqz	s1,68e <vprintf+0x226>
    c0 = fmt[i] & 0xff;
 4be:	0004879b          	sext.w	a5,s1
    if(state == 0){
 4c2:	fe0993e3          	bnez	s3,4a8 <vprintf+0x40>
      if(c0 == '%'){
 4c6:	fd579ce3          	bne	a5,s5,49e <vprintf+0x36>
        state = '%';
 4ca:	89be                	mv	s3,a5
 4cc:	b7c5                	j	4ac <vprintf+0x44>
      if(c0) c1 = fmt[i+1] & 0xff;
 4ce:	00ea06b3          	add	a3,s4,a4
 4d2:	0016c603          	lbu	a2,1(a3)
      if(c1) c2 = fmt[i+2] & 0xff;
 4d6:	1c060863          	beqz	a2,6a6 <vprintf+0x23e>
      if(c0 == 'd'){
 4da:	03878763          	beq	a5,s8,508 <vprintf+0xa0>
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c0 == 'l' && c1 == 'd'){
 4de:	f9478693          	addi	a3,a5,-108
 4e2:	0016b693          	seqz	a3,a3
 4e6:	f9c60593          	addi	a1,a2,-100
 4ea:	e99d                	bnez	a1,520 <vprintf+0xb8>
 4ec:	ca95                	beqz	a3,520 <vprintf+0xb8>
        printint(fd, va_arg(ap, uint64), 10, 1);
 4ee:	008b8493          	addi	s1,s7,8
 4f2:	4685                	li	a3,1
 4f4:	4629                	li	a2,10
 4f6:	000bb583          	ld	a1,0(s7)
 4fa:	855a                	mv	a0,s6
 4fc:	ecfff0ef          	jal	3ca <printint>
        i += 1;
 500:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 10, 1);
 502:	8ba6                	mv	s7,s1
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c0);
      }

      state = 0;
 504:	4981                	li	s3,0
 506:	b75d                	j	4ac <vprintf+0x44>
        printint(fd, va_arg(ap, int), 10, 1);
 508:	008b8493          	addi	s1,s7,8
 50c:	4685                	li	a3,1
 50e:	4629                	li	a2,10
 510:	000ba583          	lw	a1,0(s7)
 514:	855a                	mv	a0,s6
 516:	eb5ff0ef          	jal	3ca <printint>
 51a:	8ba6                	mv	s7,s1
      state = 0;
 51c:	4981                	li	s3,0
 51e:	b779                	j	4ac <vprintf+0x44>
      if(c1) c2 = fmt[i+2] & 0xff;
 520:	9752                	add	a4,a4,s4
 522:	00274583          	lbu	a1,2(a4)
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 526:	f9460713          	addi	a4,a2,-108
 52a:	00173713          	seqz	a4,a4
 52e:	8f75                	and	a4,a4,a3
 530:	f9c58513          	addi	a0,a1,-100
 534:	18051363          	bnez	a0,6ba <vprintf+0x252>
 538:	18070163          	beqz	a4,6ba <vprintf+0x252>
        printint(fd, va_arg(ap, uint64), 10, 1);
 53c:	008b8493          	addi	s1,s7,8
 540:	4685                	li	a3,1
 542:	4629                	li	a2,10
 544:	000bb583          	ld	a1,0(s7)
 548:	855a                	mv	a0,s6
 54a:	e81ff0ef          	jal	3ca <printint>
        i += 2;
 54e:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 10, 1);
 550:	8ba6                	mv	s7,s1
      state = 0;
 552:	4981                	li	s3,0
        i += 2;
 554:	bfa1                	j	4ac <vprintf+0x44>
        printint(fd, va_arg(ap, uint32), 10, 0);
 556:	008b8493          	addi	s1,s7,8
 55a:	4681                	li	a3,0
 55c:	4629                	li	a2,10
 55e:	000be583          	lwu	a1,0(s7)
 562:	855a                	mv	a0,s6
 564:	e67ff0ef          	jal	3ca <printint>
 568:	8ba6                	mv	s7,s1
      state = 0;
 56a:	4981                	li	s3,0
 56c:	b781                	j	4ac <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 10, 0);
 56e:	008b8493          	addi	s1,s7,8
 572:	4681                	li	a3,0
 574:	4629                	li	a2,10
 576:	000bb583          	ld	a1,0(s7)
 57a:	855a                	mv	a0,s6
 57c:	e4fff0ef          	jal	3ca <printint>
        i += 1;
 580:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 10, 0);
 582:	8ba6                	mv	s7,s1
      state = 0;
 584:	4981                	li	s3,0
 586:	b71d                	j	4ac <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 10, 0);
 588:	008b8493          	addi	s1,s7,8
 58c:	4681                	li	a3,0
 58e:	4629                	li	a2,10
 590:	000bb583          	ld	a1,0(s7)
 594:	855a                	mv	a0,s6
 596:	e35ff0ef          	jal	3ca <printint>
        i += 2;
 59a:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 10, 0);
 59c:	8ba6                	mv	s7,s1
      state = 0;
 59e:	4981                	li	s3,0
        i += 2;
 5a0:	b731                	j	4ac <vprintf+0x44>
        printint(fd, va_arg(ap, uint32), 16, 0);
 5a2:	008b8493          	addi	s1,s7,8
 5a6:	4681                	li	a3,0
 5a8:	4641                	li	a2,16
 5aa:	000be583          	lwu	a1,0(s7)
 5ae:	855a                	mv	a0,s6
 5b0:	e1bff0ef          	jal	3ca <printint>
 5b4:	8ba6                	mv	s7,s1
      state = 0;
 5b6:	4981                	li	s3,0
 5b8:	bdd5                	j	4ac <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 16, 0);
 5ba:	008b8493          	addi	s1,s7,8
 5be:	4681                	li	a3,0
 5c0:	4641                	li	a2,16
 5c2:	000bb583          	ld	a1,0(s7)
 5c6:	855a                	mv	a0,s6
 5c8:	e03ff0ef          	jal	3ca <printint>
        i += 1;
 5cc:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 16, 0);
 5ce:	8ba6                	mv	s7,s1
      state = 0;
 5d0:	4981                	li	s3,0
 5d2:	bde9                	j	4ac <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 16, 0);
 5d4:	008b8493          	addi	s1,s7,8
 5d8:	4681                	li	a3,0
 5da:	4641                	li	a2,16
 5dc:	000bb583          	ld	a1,0(s7)
 5e0:	855a                	mv	a0,s6
 5e2:	de9ff0ef          	jal	3ca <printint>
        i += 2;
 5e6:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 16, 0);
 5e8:	8ba6                	mv	s7,s1
      state = 0;
 5ea:	4981                	li	s3,0
        i += 2;
 5ec:	b5c1                	j	4ac <vprintf+0x44>
 5ee:	e466                	sd	s9,8(sp)
        printptr(fd, va_arg(ap, uint64));
 5f0:	008b8793          	addi	a5,s7,8
 5f4:	8cbe                	mv	s9,a5
 5f6:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 5fa:	03000593          	li	a1,48
 5fe:	855a                	mv	a0,s6
 600:	dadff0ef          	jal	3ac <putc>
  putc(fd, 'x');
 604:	07800593          	li	a1,120
 608:	855a                	mv	a0,s6
 60a:	da3ff0ef          	jal	3ac <putc>
 60e:	44c1                	li	s1,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 610:	00000b97          	auipc	s7,0x0
 614:	328b8b93          	addi	s7,s7,808 # 938 <digits>
 618:	03c9d793          	srli	a5,s3,0x3c
 61c:	97de                	add	a5,a5,s7
 61e:	0007c583          	lbu	a1,0(a5)
 622:	855a                	mv	a0,s6
 624:	d89ff0ef          	jal	3ac <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 628:	0992                	slli	s3,s3,0x4
 62a:	34fd                	addiw	s1,s1,-1
 62c:	f4f5                	bnez	s1,618 <vprintf+0x1b0>
        printptr(fd, va_arg(ap, uint64));
 62e:	8be6                	mv	s7,s9
      state = 0;
 630:	4981                	li	s3,0
 632:	6ca2                	ld	s9,8(sp)
 634:	bda5                	j	4ac <vprintf+0x44>
        putc(fd, va_arg(ap, uint32));
 636:	008b8493          	addi	s1,s7,8
 63a:	000bc583          	lbu	a1,0(s7)
 63e:	855a                	mv	a0,s6
 640:	d6dff0ef          	jal	3ac <putc>
 644:	8ba6                	mv	s7,s1
      state = 0;
 646:	4981                	li	s3,0
 648:	b595                	j	4ac <vprintf+0x44>
        if((s = va_arg(ap, char*)) == 0)
 64a:	008b8993          	addi	s3,s7,8
 64e:	000bb483          	ld	s1,0(s7)
 652:	cc91                	beqz	s1,66e <vprintf+0x206>
        for(; *s; s++)
 654:	0004c583          	lbu	a1,0(s1)
 658:	c985                	beqz	a1,688 <vprintf+0x220>
          putc(fd, *s);
 65a:	855a                	mv	a0,s6
 65c:	d51ff0ef          	jal	3ac <putc>
        for(; *s; s++)
 660:	0485                	addi	s1,s1,1
 662:	0004c583          	lbu	a1,0(s1)
 666:	f9f5                	bnez	a1,65a <vprintf+0x1f2>
        if((s = va_arg(ap, char*)) == 0)
 668:	8bce                	mv	s7,s3
      state = 0;
 66a:	4981                	li	s3,0
 66c:	b581                	j	4ac <vprintf+0x44>
          s = "(null)";
 66e:	00000497          	auipc	s1,0x0
 672:	2c248493          	addi	s1,s1,706 # 930 <malloc+0x126>
        for(; *s; s++)
 676:	02800593          	li	a1,40
 67a:	b7c5                	j	65a <vprintf+0x1f2>
        putc(fd, '%');
 67c:	85be                	mv	a1,a5
 67e:	855a                	mv	a0,s6
 680:	d2dff0ef          	jal	3ac <putc>
      state = 0;
 684:	4981                	li	s3,0
 686:	b51d                	j	4ac <vprintf+0x44>
        if((s = va_arg(ap, char*)) == 0)
 688:	8bce                	mv	s7,s3
      state = 0;
 68a:	4981                	li	s3,0
 68c:	b505                	j	4ac <vprintf+0x44>
 68e:	6906                	ld	s2,64(sp)
 690:	79e2                	ld	s3,56(sp)
 692:	7a42                	ld	s4,48(sp)
 694:	7aa2                	ld	s5,40(sp)
 696:	7b02                	ld	s6,32(sp)
 698:	6be2                	ld	s7,24(sp)
 69a:	6c42                	ld	s8,16(sp)
    }
  }
}
 69c:	60e6                	ld	ra,88(sp)
 69e:	6446                	ld	s0,80(sp)
 6a0:	64a6                	ld	s1,72(sp)
 6a2:	6125                	addi	sp,sp,96
 6a4:	8082                	ret
      if(c0 == 'd'){
 6a6:	06400713          	li	a4,100
 6aa:	e4e78fe3          	beq	a5,a4,508 <vprintf+0xa0>
      } else if(c0 == 'l' && c1 == 'd'){
 6ae:	f9478693          	addi	a3,a5,-108
 6b2:	0016b693          	seqz	a3,a3
      c1 = c2 = 0;
 6b6:	85b2                	mv	a1,a2
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 6b8:	4701                	li	a4,0
      } else if(c0 == 'u'){
 6ba:	07500513          	li	a0,117
 6be:	e8a78ce3          	beq	a5,a0,556 <vprintf+0xee>
      } else if(c0 == 'l' && c1 == 'u'){
 6c2:	f8b60513          	addi	a0,a2,-117
 6c6:	e119                	bnez	a0,6cc <vprintf+0x264>
 6c8:	ea0693e3          	bnez	a3,56e <vprintf+0x106>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
 6cc:	f8b58513          	addi	a0,a1,-117
 6d0:	e119                	bnez	a0,6d6 <vprintf+0x26e>
 6d2:	ea071be3          	bnez	a4,588 <vprintf+0x120>
      } else if(c0 == 'x'){
 6d6:	07800513          	li	a0,120
 6da:	eca784e3          	beq	a5,a0,5a2 <vprintf+0x13a>
      } else if(c0 == 'l' && c1 == 'x'){
 6de:	f8860613          	addi	a2,a2,-120
 6e2:	e219                	bnez	a2,6e8 <vprintf+0x280>
 6e4:	ec069be3          	bnez	a3,5ba <vprintf+0x152>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
 6e8:	f8858593          	addi	a1,a1,-120
 6ec:	e199                	bnez	a1,6f2 <vprintf+0x28a>
 6ee:	ee0713e3          	bnez	a4,5d4 <vprintf+0x16c>
      } else if(c0 == 'p'){
 6f2:	07000713          	li	a4,112
 6f6:	eee78ce3          	beq	a5,a4,5ee <vprintf+0x186>
      } else if(c0 == 'c'){
 6fa:	06300713          	li	a4,99
 6fe:	f2e78ce3          	beq	a5,a4,636 <vprintf+0x1ce>
      } else if(c0 == 's'){
 702:	07300713          	li	a4,115
 706:	f4e782e3          	beq	a5,a4,64a <vprintf+0x1e2>
      } else if(c0 == '%'){
 70a:	02500713          	li	a4,37
 70e:	f6e787e3          	beq	a5,a4,67c <vprintf+0x214>
        putc(fd, '%');
 712:	02500593          	li	a1,37
 716:	855a                	mv	a0,s6
 718:	c95ff0ef          	jal	3ac <putc>
        putc(fd, c0);
 71c:	85a6                	mv	a1,s1
 71e:	855a                	mv	a0,s6
 720:	c8dff0ef          	jal	3ac <putc>
      state = 0;
 724:	4981                	li	s3,0
 726:	b359                	j	4ac <vprintf+0x44>

0000000000000728 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 728:	715d                	addi	sp,sp,-80
 72a:	ec06                	sd	ra,24(sp)
 72c:	e822                	sd	s0,16(sp)
 72e:	1000                	addi	s0,sp,32
 730:	e010                	sd	a2,0(s0)
 732:	e414                	sd	a3,8(s0)
 734:	e818                	sd	a4,16(s0)
 736:	ec1c                	sd	a5,24(s0)
 738:	03043023          	sd	a6,32(s0)
 73c:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 740:	8622                	mv	a2,s0
 742:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 746:	d23ff0ef          	jal	468 <vprintf>
}
 74a:	60e2                	ld	ra,24(sp)
 74c:	6442                	ld	s0,16(sp)
 74e:	6161                	addi	sp,sp,80
 750:	8082                	ret

0000000000000752 <printf>:

void
printf(const char *fmt, ...)
{
 752:	711d                	addi	sp,sp,-96
 754:	ec06                	sd	ra,24(sp)
 756:	e822                	sd	s0,16(sp)
 758:	1000                	addi	s0,sp,32
 75a:	e40c                	sd	a1,8(s0)
 75c:	e810                	sd	a2,16(s0)
 75e:	ec14                	sd	a3,24(s0)
 760:	f018                	sd	a4,32(s0)
 762:	f41c                	sd	a5,40(s0)
 764:	03043823          	sd	a6,48(s0)
 768:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 76c:	00840613          	addi	a2,s0,8
 770:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 774:	85aa                	mv	a1,a0
 776:	4505                	li	a0,1
 778:	cf1ff0ef          	jal	468 <vprintf>
}
 77c:	60e2                	ld	ra,24(sp)
 77e:	6442                	ld	s0,16(sp)
 780:	6125                	addi	sp,sp,96
 782:	8082                	ret

0000000000000784 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 784:	1141                	addi	sp,sp,-16
 786:	e406                	sd	ra,8(sp)
 788:	e022                	sd	s0,0(sp)
 78a:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 78c:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 790:	00001797          	auipc	a5,0x1
 794:	8707b783          	ld	a5,-1936(a5) # 1000 <freep>
 798:	a039                	j	7a6 <free+0x22>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 79a:	6398                	ld	a4,0(a5)
 79c:	00e7e463          	bltu	a5,a4,7a4 <free+0x20>
 7a0:	00e6ea63          	bltu	a3,a4,7b4 <free+0x30>
{
 7a4:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 7a6:	fed7fae3          	bgeu	a5,a3,79a <free+0x16>
 7aa:	6398                	ld	a4,0(a5)
 7ac:	00e6e463          	bltu	a3,a4,7b4 <free+0x30>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 7b0:	fee7eae3          	bltu	a5,a4,7a4 <free+0x20>
      break;
  if(bp + bp->s.size == p->s.ptr){
 7b4:	ff852583          	lw	a1,-8(a0)
 7b8:	6390                	ld	a2,0(a5)
 7ba:	02059813          	slli	a6,a1,0x20
 7be:	01c85713          	srli	a4,a6,0x1c
 7c2:	9736                	add	a4,a4,a3
 7c4:	02e60563          	beq	a2,a4,7ee <free+0x6a>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
 7c8:	fec53823          	sd	a2,-16(a0)
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
 7cc:	4790                	lw	a2,8(a5)
 7ce:	02061593          	slli	a1,a2,0x20
 7d2:	01c5d713          	srli	a4,a1,0x1c
 7d6:	973e                	add	a4,a4,a5
 7d8:	02e68263          	beq	a3,a4,7fc <free+0x78>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
 7dc:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 7de:	00001717          	auipc	a4,0x1
 7e2:	82f73123          	sd	a5,-2014(a4) # 1000 <freep>
}
 7e6:	60a2                	ld	ra,8(sp)
 7e8:	6402                	ld	s0,0(sp)
 7ea:	0141                	addi	sp,sp,16
 7ec:	8082                	ret
    bp->s.size += p->s.ptr->s.size;
 7ee:	4618                	lw	a4,8(a2)
 7f0:	9f2d                	addw	a4,a4,a1
 7f2:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 7f6:	6398                	ld	a4,0(a5)
 7f8:	6310                	ld	a2,0(a4)
 7fa:	b7f9                	j	7c8 <free+0x44>
    p->s.size += bp->s.size;
 7fc:	ff852703          	lw	a4,-8(a0)
 800:	9f31                	addw	a4,a4,a2
 802:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 804:	ff053683          	ld	a3,-16(a0)
 808:	bfd1                	j	7dc <free+0x58>

000000000000080a <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 80a:	7139                	addi	sp,sp,-64
 80c:	fc06                	sd	ra,56(sp)
 80e:	f822                	sd	s0,48(sp)
 810:	f04a                	sd	s2,32(sp)
 812:	ec4e                	sd	s3,24(sp)
 814:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 816:	02051993          	slli	s3,a0,0x20
 81a:	0209d993          	srli	s3,s3,0x20
 81e:	09bd                	addi	s3,s3,15
 820:	0049d993          	srli	s3,s3,0x4
 824:	2985                	addiw	s3,s3,1
 826:	894e                	mv	s2,s3
  if((prevp = freep) == 0){
 828:	00000517          	auipc	a0,0x0
 82c:	7d853503          	ld	a0,2008(a0) # 1000 <freep>
 830:	c905                	beqz	a0,860 <malloc+0x56>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 832:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 834:	4798                	lw	a4,8(a5)
 836:	09377663          	bgeu	a4,s3,8c2 <malloc+0xb8>
 83a:	f426                	sd	s1,40(sp)
 83c:	e852                	sd	s4,16(sp)
 83e:	e456                	sd	s5,8(sp)
 840:	e05a                	sd	s6,0(sp)
  if(nu < 4096)
 842:	8a4e                	mv	s4,s3
 844:	6705                	lui	a4,0x1
 846:	00e9f363          	bgeu	s3,a4,84c <malloc+0x42>
 84a:	6a05                	lui	s4,0x1
 84c:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 850:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 854:	00000497          	auipc	s1,0x0
 858:	7ac48493          	addi	s1,s1,1964 # 1000 <freep>
  if(p == SBRK_ERROR)
 85c:	5afd                	li	s5,-1
 85e:	a83d                	j	89c <malloc+0x92>
 860:	f426                	sd	s1,40(sp)
 862:	e852                	sd	s4,16(sp)
 864:	e456                	sd	s5,8(sp)
 866:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
 868:	00000797          	auipc	a5,0x0
 86c:	7a878793          	addi	a5,a5,1960 # 1010 <base>
 870:	00000717          	auipc	a4,0x0
 874:	78f73823          	sd	a5,1936(a4) # 1000 <freep>
 878:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 87a:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 87e:	b7d1                	j	842 <malloc+0x38>
        prevp->s.ptr = p->s.ptr;
 880:	6398                	ld	a4,0(a5)
 882:	e118                	sd	a4,0(a0)
 884:	a899                	j	8da <malloc+0xd0>
  hp->s.size = nu;
 886:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 88a:	0541                	addi	a0,a0,16
 88c:	ef9ff0ef          	jal	784 <free>
  return freep;
 890:	6088                	ld	a0,0(s1)
      if((p = morecore(nunits)) == 0)
 892:	c125                	beqz	a0,8f2 <malloc+0xe8>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 894:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 896:	4798                	lw	a4,8(a5)
 898:	03277163          	bgeu	a4,s2,8ba <malloc+0xb0>
    if(p == freep)
 89c:	6098                	ld	a4,0(s1)
 89e:	853e                	mv	a0,a5
 8a0:	fef71ae3          	bne	a4,a5,894 <malloc+0x8a>
  p = sbrk(nu * sizeof(Header));
 8a4:	8552                	mv	a0,s4
 8a6:	a2bff0ef          	jal	2d0 <sbrk>
  if(p == SBRK_ERROR)
 8aa:	fd551ee3          	bne	a0,s5,886 <malloc+0x7c>
        return 0;
 8ae:	4501                	li	a0,0
 8b0:	74a2                	ld	s1,40(sp)
 8b2:	6a42                	ld	s4,16(sp)
 8b4:	6aa2                	ld	s5,8(sp)
 8b6:	6b02                	ld	s6,0(sp)
 8b8:	a03d                	j	8e6 <malloc+0xdc>
 8ba:	74a2                	ld	s1,40(sp)
 8bc:	6a42                	ld	s4,16(sp)
 8be:	6aa2                	ld	s5,8(sp)
 8c0:	6b02                	ld	s6,0(sp)
      if(p->s.size == nunits)
 8c2:	fae90fe3          	beq	s2,a4,880 <malloc+0x76>
        p->s.size -= nunits;
 8c6:	4137073b          	subw	a4,a4,s3
 8ca:	c798                	sw	a4,8(a5)
        p += p->s.size;
 8cc:	02071693          	slli	a3,a4,0x20
 8d0:	01c6d713          	srli	a4,a3,0x1c
 8d4:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 8d6:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 8da:	00000717          	auipc	a4,0x0
 8de:	72a73323          	sd	a0,1830(a4) # 1000 <freep>
      return (void*)(p + 1);
 8e2:	01078513          	addi	a0,a5,16
  }
}
 8e6:	70e2                	ld	ra,56(sp)
 8e8:	7442                	ld	s0,48(sp)
 8ea:	7902                	ld	s2,32(sp)
 8ec:	69e2                	ld	s3,24(sp)
 8ee:	6121                	addi	sp,sp,64
 8f0:	8082                	ret
 8f2:	74a2                	ld	s1,40(sp)
 8f4:	6a42                	ld	s4,16(sp)
 8f6:	6aa2                	ld	s5,8(sp)
 8f8:	6b02                	ld	s6,0(sp)
 8fa:	b7f5                	j	8e6 <malloc+0xdc>
