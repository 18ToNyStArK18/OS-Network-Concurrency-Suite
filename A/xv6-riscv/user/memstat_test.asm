
user/_memstat_test:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <main>:
#include "user.h"
#include "../kernel/memstat.h" // Include your new header in user-space

int
main()
{
   0:	81010113          	addi	sp,sp,-2032
   4:	7e113423          	sd	ra,2024(sp)
   8:	7e813023          	sd	s0,2016(sp)
   c:	7c913c23          	sd	s1,2008(sp)
  10:	7d213823          	sd	s2,2000(sp)
  14:	7d313423          	sd	s3,1992(sp)
  18:	7d413023          	sd	s4,1984(sp)
  1c:	7b513c23          	sd	s5,1976(sp)
  20:	7b613823          	sd	s6,1968(sp)
  24:	7b713423          	sd	s7,1960(sp)
  28:	7b813023          	sd	s8,1952(sp)
  2c:	79913c23          	sd	s9,1944(sp)
  30:	7f010413          	addi	s0,sp,2032
  34:	d7010113          	addi	sp,sp,-656
  struct proc_mem_stat info;

  // Allocate some memory and touch it to make it resident
  sbrk(4096 * 5);
  38:	6515                	lui	a0,0x5
  3a:	3e4000ef          	jal	41e <sbrk>
  char *p = (char *)0;
  p[0] = 'A';
  3e:	04100793          	li	a5,65
  42:	00f00023          	sb	a5,0(zero) # 0 <main>
  p[4096] = 'B';
  46:	6785                	lui	a5,0x1
  48:	04200713          	li	a4,66
  4c:	00e78023          	sb	a4,0(a5) # 1000 <digits+0x428>
  p[8192] = 'C';
  50:	6789                	lui	a5,0x2
  52:	04300713          	li	a4,67
  56:	00e78023          	sb	a4,0(a5) # 2000 <freep>
  p[4096*3]='D';
  5a:	678d                	lui	a5,0x3
  5c:	04400713          	li	a4,68
  60:	00e78023          	sb	a4,0(a5) # 3000 <base+0xff0>

  // Call the new system call
  if (memstat(&info) < 0) {
  64:	80040513          	addi	a0,s0,-2048
  68:	fa050513          	addi	a0,a0,-96 # 4fa0 <base+0x2f90>
  6c:	de850513          	addi	a0,a0,-536
  70:	482000ef          	jal	4f2 <memstat>
  74:	0c054c63          	bltz	a0,14c <main+0x14c>
    printf("memstat failed\n");
    exit(1);
  }

  printf("--- Process Memory Stats ---\n");
  78:	00001517          	auipc	a0,0x1
  7c:	a1850513          	addi	a0,a0,-1512 # a90 <malloc+0x138>
  80:	021000ef          	jal	8a0 <printf>
  printf("PID: %d\n", info.pid);
  84:	80040493          	addi	s1,s0,-2048
  88:	fa048493          	addi	s1,s1,-96
  8c:	de84a583          	lw	a1,-536(s1)
  90:	00001517          	auipc	a0,0x1
  94:	a2050513          	addi	a0,a0,-1504 # ab0 <malloc+0x158>
  98:	009000ef          	jal	8a0 <printf>
  printf("Total Pages: %d\n", info.num_pages_total);
  9c:	dec4a583          	lw	a1,-532(s1)
  a0:	00001517          	auipc	a0,0x1
  a4:	a2050513          	addi	a0,a0,-1504 # ac0 <malloc+0x168>
  a8:	7f8000ef          	jal	8a0 <printf>
  printf("Resident Pages: %d\n", info.num_resident_pages);
  ac:	df04a583          	lw	a1,-528(s1)
  b0:	00001517          	auipc	a0,0x1
  b4:	a2850513          	addi	a0,a0,-1496 # ad8 <malloc+0x180>
  b8:	7e8000ef          	jal	8a0 <printf>
  printf("Swapped Pages: %d\n", info.num_swapped_pages);
  bc:	df44a583          	lw	a1,-524(s1)
  c0:	00001517          	auipc	a0,0x1
  c4:	a3050513          	addi	a0,a0,-1488 # af0 <malloc+0x198>
  c8:	7d8000ef          	jal	8a0 <printf>
  printf("Next FIFO Seq: %d\n\n", info.next_fifo_seq);
  cc:	df84a583          	lw	a1,-520(s1)
  d0:	00001517          	auipc	a0,0x1
  d4:	a3850513          	addi	a0,a0,-1480 # b08 <malloc+0x1b0>
  d8:	7c8000ef          	jal	8a0 <printf>
  
  printf("--- Page Details (up to %d) ---\n", MAX_PAGES_INFO);
  dc:	08000593          	li	a1,128
  e0:	00001517          	auipc	a0,0x1
  e4:	a4050513          	addi	a0,a0,-1472 # b20 <malloc+0x1c8>
  e8:	7b8000ef          	jal	8a0 <printf>
  printf("VA         | STATE    | DIRTY | SEQ   | SLOT\n");
  ec:	00001517          	auipc	a0,0x1
  f0:	a5c50513          	addi	a0,a0,-1444 # b48 <malloc+0x1f0>
  f4:	7ac000ef          	jal	8a0 <printf>
  printf("--------------------------------------------\n");
  f8:	00001517          	auipc	a0,0x1
  fc:	a8050513          	addi	a0,a0,-1408 # b78 <malloc+0x220>
 100:	7a0000ef          	jal	8a0 <printf>
  
  for (int i = 0; i < info.num_pages_total && i < MAX_PAGES_INFO; i++) {
 104:	dec4a783          	lw	a5,-532(s1)
 108:	08f05763          	blez	a5,196 <main+0x196>
 10c:	80040493          	addi	s1,s0,-2048
 110:	fa048493          	addi	s1,s1,-96
 114:	dfc48493          	addi	s1,s1,-516
 118:	4901                	li	s2,0
    char *state_str = "UNMAPPED";
    if (info.pages[i].state == RESIDENT) state_str = "RESIDENT";
 11a:	4b05                	li	s6,1
 11c:	00001a97          	auipc	s5,0x1
 120:	954a8a93          	addi	s5,s5,-1708 # a70 <malloc+0x118>
    if (info.pages[i].state == SWAPPED) state_str = "SWAPPED ";
 124:	4c09                	li	s8,2
 126:	00001b97          	auipc	s7,0x1
 12a:	93ab8b93          	addi	s7,s7,-1734 # a60 <malloc+0x108>
 12e:	00001c97          	auipc	s9,0x1
 132:	922c8c93          	addi	s9,s9,-1758 # a50 <malloc+0xf8>
    
    printf("0x%x | %s | %d     | %d    | %d\n",
 136:	00001a17          	auipc	s4,0x1
 13a:	a72a0a13          	addi	s4,s4,-1422 # ba8 <malloc+0x250>
  for (int i = 0; i < info.num_pages_total && i < MAX_PAGES_INFO; i++) {
 13e:	80040993          	addi	s3,s0,-2048
 142:	fa098993          	addi	s3,s3,-96
 146:	80098993          	addi	s3,s3,-2048
 14a:	a825                	j	182 <main+0x182>
    printf("memstat failed\n");
 14c:	00001517          	auipc	a0,0x1
 150:	93450513          	addi	a0,a0,-1740 # a80 <malloc+0x128>
 154:	74c000ef          	jal	8a0 <printf>
    exit(1);
 158:	4505                	li	a0,1
 15a:	2f8000ef          	jal	452 <exit>
    printf("0x%x | %s | %d     | %d    | %d\n",
 15e:	499c                	lw	a5,16(a1)
 160:	45d8                	lw	a4,12(a1)
 162:	4594                	lw	a3,8(a1)
 164:	418c                	lw	a1,0(a1)
 166:	8552                	mv	a0,s4
 168:	738000ef          	jal	8a0 <printf>
  for (int i = 0; i < info.num_pages_total && i < MAX_PAGES_INFO; i++) {
 16c:	0019079b          	addiw	a5,s2,1
 170:	893e                	mv	s2,a5
 172:	04d1                	addi	s1,s1,20
 174:	5ec9a703          	lw	a4,1516(s3)
 178:	00e7df63          	bge	a5,a4,196 <main+0x196>
 17c:	0807a793          	slti	a5,a5,128
 180:	cb99                	beqz	a5,196 <main+0x196>
    if (info.pages[i].state == RESIDENT) state_str = "RESIDENT";
 182:	85a6                	mv	a1,s1
 184:	40dc                	lw	a5,4(s1)
 186:	8656                	mv	a2,s5
 188:	fd678be3          	beq	a5,s6,15e <main+0x15e>
    if (info.pages[i].state == SWAPPED) state_str = "SWAPPED ";
 18c:	865e                	mv	a2,s7
 18e:	fd8788e3          	beq	a5,s8,15e <main+0x15e>
 192:	8666                	mv	a2,s9
 194:	b7e9                	j	15e <main+0x15e>
           info.pages[i].is_dirty,
           info.pages[i].seq,
           info.pages[i].swap_slot);
  }

  exit(0);
 196:	4501                	li	a0,0
 198:	2ba000ef          	jal	452 <exit>

000000000000019c <start>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
start(int argc, char **argv)
{
 19c:	1141                	addi	sp,sp,-16
 19e:	e406                	sd	ra,8(sp)
 1a0:	e022                	sd	s0,0(sp)
 1a2:	0800                	addi	s0,sp,16
  int r;
  extern int main(int argc, char **argv);
  r = main(argc, argv);
 1a4:	e5dff0ef          	jal	0 <main>
  exit(r);
 1a8:	2aa000ef          	jal	452 <exit>

00000000000001ac <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
 1ac:	1141                	addi	sp,sp,-16
 1ae:	e406                	sd	ra,8(sp)
 1b0:	e022                	sd	s0,0(sp)
 1b2:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 1b4:	87aa                	mv	a5,a0
 1b6:	0585                	addi	a1,a1,1
 1b8:	0785                	addi	a5,a5,1
 1ba:	fff5c703          	lbu	a4,-1(a1)
 1be:	fee78fa3          	sb	a4,-1(a5)
 1c2:	fb75                	bnez	a4,1b6 <strcpy+0xa>
    ;
  return os;
}
 1c4:	60a2                	ld	ra,8(sp)
 1c6:	6402                	ld	s0,0(sp)
 1c8:	0141                	addi	sp,sp,16
 1ca:	8082                	ret

00000000000001cc <strcmp>:

int
strcmp(const char *p, const char *q)
{
 1cc:	1141                	addi	sp,sp,-16
 1ce:	e406                	sd	ra,8(sp)
 1d0:	e022                	sd	s0,0(sp)
 1d2:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
 1d4:	00054783          	lbu	a5,0(a0)
 1d8:	cb91                	beqz	a5,1ec <strcmp+0x20>
 1da:	0005c703          	lbu	a4,0(a1)
 1de:	00f71763          	bne	a4,a5,1ec <strcmp+0x20>
    p++, q++;
 1e2:	0505                	addi	a0,a0,1
 1e4:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
 1e6:	00054783          	lbu	a5,0(a0)
 1ea:	fbe5                	bnez	a5,1da <strcmp+0xe>
  return (uchar)*p - (uchar)*q;
 1ec:	0005c503          	lbu	a0,0(a1)
}
 1f0:	40a7853b          	subw	a0,a5,a0
 1f4:	60a2                	ld	ra,8(sp)
 1f6:	6402                	ld	s0,0(sp)
 1f8:	0141                	addi	sp,sp,16
 1fa:	8082                	ret

00000000000001fc <strlen>:

uint
strlen(const char *s)
{
 1fc:	1141                	addi	sp,sp,-16
 1fe:	e406                	sd	ra,8(sp)
 200:	e022                	sd	s0,0(sp)
 202:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 204:	00054783          	lbu	a5,0(a0)
 208:	cf91                	beqz	a5,224 <strlen+0x28>
 20a:	00150793          	addi	a5,a0,1
 20e:	86be                	mv	a3,a5
 210:	0785                	addi	a5,a5,1
 212:	fff7c703          	lbu	a4,-1(a5)
 216:	ff65                	bnez	a4,20e <strlen+0x12>
 218:	40a6853b          	subw	a0,a3,a0
    ;
  return n;
}
 21c:	60a2                	ld	ra,8(sp)
 21e:	6402                	ld	s0,0(sp)
 220:	0141                	addi	sp,sp,16
 222:	8082                	ret
  for(n = 0; s[n]; n++)
 224:	4501                	li	a0,0
 226:	bfdd                	j	21c <strlen+0x20>

0000000000000228 <memset>:

void*
memset(void *dst, int c, uint n)
{
 228:	1141                	addi	sp,sp,-16
 22a:	e406                	sd	ra,8(sp)
 22c:	e022                	sd	s0,0(sp)
 22e:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 230:	ca19                	beqz	a2,246 <memset+0x1e>
 232:	87aa                	mv	a5,a0
 234:	1602                	slli	a2,a2,0x20
 236:	9201                	srli	a2,a2,0x20
 238:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 23c:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 240:	0785                	addi	a5,a5,1
 242:	fee79de3          	bne	a5,a4,23c <memset+0x14>
  }
  return dst;
}
 246:	60a2                	ld	ra,8(sp)
 248:	6402                	ld	s0,0(sp)
 24a:	0141                	addi	sp,sp,16
 24c:	8082                	ret

000000000000024e <strchr>:

char*
strchr(const char *s, char c)
{
 24e:	1141                	addi	sp,sp,-16
 250:	e406                	sd	ra,8(sp)
 252:	e022                	sd	s0,0(sp)
 254:	0800                	addi	s0,sp,16
  for(; *s; s++)
 256:	00054783          	lbu	a5,0(a0)
 25a:	cf81                	beqz	a5,272 <strchr+0x24>
    if(*s == c)
 25c:	00f58763          	beq	a1,a5,26a <strchr+0x1c>
  for(; *s; s++)
 260:	0505                	addi	a0,a0,1
 262:	00054783          	lbu	a5,0(a0)
 266:	fbfd                	bnez	a5,25c <strchr+0xe>
      return (char*)s;
  return 0;
 268:	4501                	li	a0,0
}
 26a:	60a2                	ld	ra,8(sp)
 26c:	6402                	ld	s0,0(sp)
 26e:	0141                	addi	sp,sp,16
 270:	8082                	ret
  return 0;
 272:	4501                	li	a0,0
 274:	bfdd                	j	26a <strchr+0x1c>

0000000000000276 <gets>:

char*
gets(char *buf, int max)
{
 276:	711d                	addi	sp,sp,-96
 278:	ec86                	sd	ra,88(sp)
 27a:	e8a2                	sd	s0,80(sp)
 27c:	e4a6                	sd	s1,72(sp)
 27e:	e0ca                	sd	s2,64(sp)
 280:	fc4e                	sd	s3,56(sp)
 282:	f852                	sd	s4,48(sp)
 284:	f456                	sd	s5,40(sp)
 286:	f05a                	sd	s6,32(sp)
 288:	ec5e                	sd	s7,24(sp)
 28a:	e862                	sd	s8,16(sp)
 28c:	1080                	addi	s0,sp,96
 28e:	8baa                	mv	s7,a0
 290:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 292:	892a                	mv	s2,a0
 294:	4481                	li	s1,0
    cc = read(0, &c, 1);
 296:	faf40b13          	addi	s6,s0,-81
 29a:	4a85                	li	s5,1
  for(i=0; i+1 < max; ){
 29c:	8c26                	mv	s8,s1
 29e:	0014899b          	addiw	s3,s1,1
 2a2:	84ce                	mv	s1,s3
 2a4:	0349d463          	bge	s3,s4,2cc <gets+0x56>
    cc = read(0, &c, 1);
 2a8:	8656                	mv	a2,s5
 2aa:	85da                	mv	a1,s6
 2ac:	4501                	li	a0,0
 2ae:	1bc000ef          	jal	46a <read>
    if(cc < 1)
 2b2:	00a05d63          	blez	a0,2cc <gets+0x56>
      break;
    buf[i++] = c;
 2b6:	faf44783          	lbu	a5,-81(s0)
 2ba:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 2be:	0905                	addi	s2,s2,1
 2c0:	ff678713          	addi	a4,a5,-10
 2c4:	c319                	beqz	a4,2ca <gets+0x54>
 2c6:	17cd                	addi	a5,a5,-13
 2c8:	fbf1                	bnez	a5,29c <gets+0x26>
    buf[i++] = c;
 2ca:	8c4e                	mv	s8,s3
      break;
  }
  buf[i] = '\0';
 2cc:	9c5e                	add	s8,s8,s7
 2ce:	000c0023          	sb	zero,0(s8)
  return buf;
}
 2d2:	855e                	mv	a0,s7
 2d4:	60e6                	ld	ra,88(sp)
 2d6:	6446                	ld	s0,80(sp)
 2d8:	64a6                	ld	s1,72(sp)
 2da:	6906                	ld	s2,64(sp)
 2dc:	79e2                	ld	s3,56(sp)
 2de:	7a42                	ld	s4,48(sp)
 2e0:	7aa2                	ld	s5,40(sp)
 2e2:	7b02                	ld	s6,32(sp)
 2e4:	6be2                	ld	s7,24(sp)
 2e6:	6c42                	ld	s8,16(sp)
 2e8:	6125                	addi	sp,sp,96
 2ea:	8082                	ret

00000000000002ec <stat>:

int
stat(const char *n, struct stat *st)
{
 2ec:	1101                	addi	sp,sp,-32
 2ee:	ec06                	sd	ra,24(sp)
 2f0:	e822                	sd	s0,16(sp)
 2f2:	e04a                	sd	s2,0(sp)
 2f4:	1000                	addi	s0,sp,32
 2f6:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 2f8:	4581                	li	a1,0
 2fa:	198000ef          	jal	492 <open>
  if(fd < 0)
 2fe:	02054263          	bltz	a0,322 <stat+0x36>
 302:	e426                	sd	s1,8(sp)
 304:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 306:	85ca                	mv	a1,s2
 308:	1a2000ef          	jal	4aa <fstat>
 30c:	892a                	mv	s2,a0
  close(fd);
 30e:	8526                	mv	a0,s1
 310:	16a000ef          	jal	47a <close>
  return r;
 314:	64a2                	ld	s1,8(sp)
}
 316:	854a                	mv	a0,s2
 318:	60e2                	ld	ra,24(sp)
 31a:	6442                	ld	s0,16(sp)
 31c:	6902                	ld	s2,0(sp)
 31e:	6105                	addi	sp,sp,32
 320:	8082                	ret
    return -1;
 322:	57fd                	li	a5,-1
 324:	893e                	mv	s2,a5
 326:	bfc5                	j	316 <stat+0x2a>

0000000000000328 <atoi>:

int
atoi(const char *s)
{
 328:	1141                	addi	sp,sp,-16
 32a:	e406                	sd	ra,8(sp)
 32c:	e022                	sd	s0,0(sp)
 32e:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 330:	00054683          	lbu	a3,0(a0)
 334:	fd06879b          	addiw	a5,a3,-48
 338:	0ff7f793          	zext.b	a5,a5
 33c:	4625                	li	a2,9
 33e:	02f66963          	bltu	a2,a5,370 <atoi+0x48>
 342:	872a                	mv	a4,a0
  n = 0;
 344:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
 346:	0705                	addi	a4,a4,1
 348:	0025179b          	slliw	a5,a0,0x2
 34c:	9fa9                	addw	a5,a5,a0
 34e:	0017979b          	slliw	a5,a5,0x1
 352:	9fb5                	addw	a5,a5,a3
 354:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 358:	00074683          	lbu	a3,0(a4)
 35c:	fd06879b          	addiw	a5,a3,-48
 360:	0ff7f793          	zext.b	a5,a5
 364:	fef671e3          	bgeu	a2,a5,346 <atoi+0x1e>
  return n;
}
 368:	60a2                	ld	ra,8(sp)
 36a:	6402                	ld	s0,0(sp)
 36c:	0141                	addi	sp,sp,16
 36e:	8082                	ret
  n = 0;
 370:	4501                	li	a0,0
 372:	bfdd                	j	368 <atoi+0x40>

0000000000000374 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 374:	1141                	addi	sp,sp,-16
 376:	e406                	sd	ra,8(sp)
 378:	e022                	sd	s0,0(sp)
 37a:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 37c:	02b57563          	bgeu	a0,a1,3a6 <memmove+0x32>
    while(n-- > 0)
 380:	00c05f63          	blez	a2,39e <memmove+0x2a>
 384:	1602                	slli	a2,a2,0x20
 386:	9201                	srli	a2,a2,0x20
 388:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 38c:	872a                	mv	a4,a0
      *dst++ = *src++;
 38e:	0585                	addi	a1,a1,1
 390:	0705                	addi	a4,a4,1
 392:	fff5c683          	lbu	a3,-1(a1)
 396:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 39a:	fee79ae3          	bne	a5,a4,38e <memmove+0x1a>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 39e:	60a2                	ld	ra,8(sp)
 3a0:	6402                	ld	s0,0(sp)
 3a2:	0141                	addi	sp,sp,16
 3a4:	8082                	ret
    while(n-- > 0)
 3a6:	fec05ce3          	blez	a2,39e <memmove+0x2a>
    dst += n;
 3aa:	00c50733          	add	a4,a0,a2
    src += n;
 3ae:	95b2                	add	a1,a1,a2
 3b0:	fff6079b          	addiw	a5,a2,-1
 3b4:	1782                	slli	a5,a5,0x20
 3b6:	9381                	srli	a5,a5,0x20
 3b8:	fff7c793          	not	a5,a5
 3bc:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 3be:	15fd                	addi	a1,a1,-1
 3c0:	177d                	addi	a4,a4,-1
 3c2:	0005c683          	lbu	a3,0(a1)
 3c6:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 3ca:	fef71ae3          	bne	a4,a5,3be <memmove+0x4a>
 3ce:	bfc1                	j	39e <memmove+0x2a>

00000000000003d0 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 3d0:	1141                	addi	sp,sp,-16
 3d2:	e406                	sd	ra,8(sp)
 3d4:	e022                	sd	s0,0(sp)
 3d6:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 3d8:	c61d                	beqz	a2,406 <memcmp+0x36>
 3da:	1602                	slli	a2,a2,0x20
 3dc:	9201                	srli	a2,a2,0x20
 3de:	00c506b3          	add	a3,a0,a2
    if (*p1 != *p2) {
 3e2:	00054783          	lbu	a5,0(a0)
 3e6:	0005c703          	lbu	a4,0(a1)
 3ea:	00e79863          	bne	a5,a4,3fa <memcmp+0x2a>
      return *p1 - *p2;
    }
    p1++;
 3ee:	0505                	addi	a0,a0,1
    p2++;
 3f0:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 3f2:	fed518e3          	bne	a0,a3,3e2 <memcmp+0x12>
  }
  return 0;
 3f6:	4501                	li	a0,0
 3f8:	a019                	j	3fe <memcmp+0x2e>
      return *p1 - *p2;
 3fa:	40e7853b          	subw	a0,a5,a4
}
 3fe:	60a2                	ld	ra,8(sp)
 400:	6402                	ld	s0,0(sp)
 402:	0141                	addi	sp,sp,16
 404:	8082                	ret
  return 0;
 406:	4501                	li	a0,0
 408:	bfdd                	j	3fe <memcmp+0x2e>

000000000000040a <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 40a:	1141                	addi	sp,sp,-16
 40c:	e406                	sd	ra,8(sp)
 40e:	e022                	sd	s0,0(sp)
 410:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 412:	f63ff0ef          	jal	374 <memmove>
}
 416:	60a2                	ld	ra,8(sp)
 418:	6402                	ld	s0,0(sp)
 41a:	0141                	addi	sp,sp,16
 41c:	8082                	ret

000000000000041e <sbrk>:

char *
sbrk(int n) {
 41e:	1141                	addi	sp,sp,-16
 420:	e406                	sd	ra,8(sp)
 422:	e022                	sd	s0,0(sp)
 424:	0800                	addi	s0,sp,16
  return sys_sbrk(n, SBRK_EAGER);
 426:	4585                	li	a1,1
 428:	0b2000ef          	jal	4da <sys_sbrk>
}
 42c:	60a2                	ld	ra,8(sp)
 42e:	6402                	ld	s0,0(sp)
 430:	0141                	addi	sp,sp,16
 432:	8082                	ret

0000000000000434 <sbrklazy>:

char *
sbrklazy(int n) {
 434:	1141                	addi	sp,sp,-16
 436:	e406                	sd	ra,8(sp)
 438:	e022                	sd	s0,0(sp)
 43a:	0800                	addi	s0,sp,16
  return sys_sbrk(n, SBRK_LAZY);
 43c:	4589                	li	a1,2
 43e:	09c000ef          	jal	4da <sys_sbrk>
}
 442:	60a2                	ld	ra,8(sp)
 444:	6402                	ld	s0,0(sp)
 446:	0141                	addi	sp,sp,16
 448:	8082                	ret

000000000000044a <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 44a:	4885                	li	a7,1
 ecall
 44c:	00000073          	ecall
 ret
 450:	8082                	ret

0000000000000452 <exit>:
.global exit
exit:
 li a7, SYS_exit
 452:	4889                	li	a7,2
 ecall
 454:	00000073          	ecall
 ret
 458:	8082                	ret

000000000000045a <wait>:
.global wait
wait:
 li a7, SYS_wait
 45a:	488d                	li	a7,3
 ecall
 45c:	00000073          	ecall
 ret
 460:	8082                	ret

0000000000000462 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 462:	4891                	li	a7,4
 ecall
 464:	00000073          	ecall
 ret
 468:	8082                	ret

000000000000046a <read>:
.global read
read:
 li a7, SYS_read
 46a:	4895                	li	a7,5
 ecall
 46c:	00000073          	ecall
 ret
 470:	8082                	ret

0000000000000472 <write>:
.global write
write:
 li a7, SYS_write
 472:	48c1                	li	a7,16
 ecall
 474:	00000073          	ecall
 ret
 478:	8082                	ret

000000000000047a <close>:
.global close
close:
 li a7, SYS_close
 47a:	48d5                	li	a7,21
 ecall
 47c:	00000073          	ecall
 ret
 480:	8082                	ret

0000000000000482 <kill>:
.global kill
kill:
 li a7, SYS_kill
 482:	4899                	li	a7,6
 ecall
 484:	00000073          	ecall
 ret
 488:	8082                	ret

000000000000048a <exec>:
.global exec
exec:
 li a7, SYS_exec
 48a:	489d                	li	a7,7
 ecall
 48c:	00000073          	ecall
 ret
 490:	8082                	ret

0000000000000492 <open>:
.global open
open:
 li a7, SYS_open
 492:	48bd                	li	a7,15
 ecall
 494:	00000073          	ecall
 ret
 498:	8082                	ret

000000000000049a <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 49a:	48c5                	li	a7,17
 ecall
 49c:	00000073          	ecall
 ret
 4a0:	8082                	ret

00000000000004a2 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 4a2:	48c9                	li	a7,18
 ecall
 4a4:	00000073          	ecall
 ret
 4a8:	8082                	ret

00000000000004aa <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 4aa:	48a1                	li	a7,8
 ecall
 4ac:	00000073          	ecall
 ret
 4b0:	8082                	ret

00000000000004b2 <link>:
.global link
link:
 li a7, SYS_link
 4b2:	48cd                	li	a7,19
 ecall
 4b4:	00000073          	ecall
 ret
 4b8:	8082                	ret

00000000000004ba <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 4ba:	48d1                	li	a7,20
 ecall
 4bc:	00000073          	ecall
 ret
 4c0:	8082                	ret

00000000000004c2 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 4c2:	48a5                	li	a7,9
 ecall
 4c4:	00000073          	ecall
 ret
 4c8:	8082                	ret

00000000000004ca <dup>:
.global dup
dup:
 li a7, SYS_dup
 4ca:	48a9                	li	a7,10
 ecall
 4cc:	00000073          	ecall
 ret
 4d0:	8082                	ret

00000000000004d2 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 4d2:	48ad                	li	a7,11
 ecall
 4d4:	00000073          	ecall
 ret
 4d8:	8082                	ret

00000000000004da <sys_sbrk>:
.global sys_sbrk
sys_sbrk:
 li a7, SYS_sbrk
 4da:	48b1                	li	a7,12
 ecall
 4dc:	00000073          	ecall
 ret
 4e0:	8082                	ret

00000000000004e2 <pause>:
.global pause
pause:
 li a7, SYS_pause
 4e2:	48b5                	li	a7,13
 ecall
 4e4:	00000073          	ecall
 ret
 4e8:	8082                	ret

00000000000004ea <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 4ea:	48b9                	li	a7,14
 ecall
 4ec:	00000073          	ecall
 ret
 4f0:	8082                	ret

00000000000004f2 <memstat>:
.global memstat
memstat:
 li a7, SYS_memstat
 4f2:	48d9                	li	a7,22
 ecall
 4f4:	00000073          	ecall
 ret
 4f8:	8082                	ret

00000000000004fa <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 4fa:	1101                	addi	sp,sp,-32
 4fc:	ec06                	sd	ra,24(sp)
 4fe:	e822                	sd	s0,16(sp)
 500:	1000                	addi	s0,sp,32
 502:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 506:	4605                	li	a2,1
 508:	fef40593          	addi	a1,s0,-17
 50c:	f67ff0ef          	jal	472 <write>
}
 510:	60e2                	ld	ra,24(sp)
 512:	6442                	ld	s0,16(sp)
 514:	6105                	addi	sp,sp,32
 516:	8082                	ret

0000000000000518 <printint>:

static void
printint(int fd, long long xx, int base, int sgn)
{
 518:	715d                	addi	sp,sp,-80
 51a:	e486                	sd	ra,72(sp)
 51c:	e0a2                	sd	s0,64(sp)
 51e:	f84a                	sd	s2,48(sp)
 520:	f44e                	sd	s3,40(sp)
 522:	0880                	addi	s0,sp,80
 524:	892a                	mv	s2,a0
  char buf[20];
  int i, neg;
  unsigned long long x;

  neg = 0;
  if(sgn && xx < 0){
 526:	c6d1                	beqz	a3,5b2 <printint+0x9a>
 528:	0805d563          	bgez	a1,5b2 <printint+0x9a>
    neg = 1;
    x = -xx;
 52c:	40b005b3          	neg	a1,a1
    neg = 1;
 530:	4305                	li	t1,1
  } else {
    x = xx;
  }

  i = 0;
 532:	fb840993          	addi	s3,s0,-72
  neg = 0;
 536:	86ce                	mv	a3,s3
  i = 0;
 538:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 53a:	00000817          	auipc	a6,0x0
 53e:	69e80813          	addi	a6,a6,1694 # bd8 <digits>
 542:	88ba                	mv	a7,a4
 544:	0017051b          	addiw	a0,a4,1
 548:	872a                	mv	a4,a0
 54a:	02c5f7b3          	remu	a5,a1,a2
 54e:	97c2                	add	a5,a5,a6
 550:	0007c783          	lbu	a5,0(a5)
 554:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 558:	87ae                	mv	a5,a1
 55a:	02c5d5b3          	divu	a1,a1,a2
 55e:	0685                	addi	a3,a3,1
 560:	fec7f1e3          	bgeu	a5,a2,542 <printint+0x2a>
  if(neg)
 564:	00030c63          	beqz	t1,57c <printint+0x64>
    buf[i++] = '-';
 568:	fd050793          	addi	a5,a0,-48
 56c:	00878533          	add	a0,a5,s0
 570:	02d00793          	li	a5,45
 574:	fef50423          	sb	a5,-24(a0)
 578:	0028871b          	addiw	a4,a7,2

  while(--i >= 0)
 57c:	02e05563          	blez	a4,5a6 <printint+0x8e>
 580:	fc26                	sd	s1,56(sp)
 582:	377d                	addiw	a4,a4,-1
 584:	00e984b3          	add	s1,s3,a4
 588:	19fd                	addi	s3,s3,-1
 58a:	99ba                	add	s3,s3,a4
 58c:	1702                	slli	a4,a4,0x20
 58e:	9301                	srli	a4,a4,0x20
 590:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 594:	0004c583          	lbu	a1,0(s1)
 598:	854a                	mv	a0,s2
 59a:	f61ff0ef          	jal	4fa <putc>
  while(--i >= 0)
 59e:	14fd                	addi	s1,s1,-1
 5a0:	ff349ae3          	bne	s1,s3,594 <printint+0x7c>
 5a4:	74e2                	ld	s1,56(sp)
}
 5a6:	60a6                	ld	ra,72(sp)
 5a8:	6406                	ld	s0,64(sp)
 5aa:	7942                	ld	s2,48(sp)
 5ac:	79a2                	ld	s3,40(sp)
 5ae:	6161                	addi	sp,sp,80
 5b0:	8082                	ret
  neg = 0;
 5b2:	4301                	li	t1,0
 5b4:	bfbd                	j	532 <printint+0x1a>

00000000000005b6 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %c, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 5b6:	711d                	addi	sp,sp,-96
 5b8:	ec86                	sd	ra,88(sp)
 5ba:	e8a2                	sd	s0,80(sp)
 5bc:	e4a6                	sd	s1,72(sp)
 5be:	1080                	addi	s0,sp,96
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 5c0:	0005c483          	lbu	s1,0(a1)
 5c4:	22048363          	beqz	s1,7ea <vprintf+0x234>
 5c8:	e0ca                	sd	s2,64(sp)
 5ca:	fc4e                	sd	s3,56(sp)
 5cc:	f852                	sd	s4,48(sp)
 5ce:	f456                	sd	s5,40(sp)
 5d0:	f05a                	sd	s6,32(sp)
 5d2:	ec5e                	sd	s7,24(sp)
 5d4:	e862                	sd	s8,16(sp)
 5d6:	8b2a                	mv	s6,a0
 5d8:	8a2e                	mv	s4,a1
 5da:	8bb2                	mv	s7,a2
  state = 0;
 5dc:	4981                	li	s3,0
  for(i = 0; fmt[i]; i++){
 5de:	4901                	li	s2,0
 5e0:	4701                	li	a4,0
      if(c0 == '%'){
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if(state == '%'){
 5e2:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if(c0) c1 = fmt[i+1] & 0xff;
      if(c1) c2 = fmt[i+2] & 0xff;
      if(c0 == 'd'){
 5e6:	06400c13          	li	s8,100
 5ea:	a00d                	j	60c <vprintf+0x56>
        putc(fd, c0);
 5ec:	85a6                	mv	a1,s1
 5ee:	855a                	mv	a0,s6
 5f0:	f0bff0ef          	jal	4fa <putc>
 5f4:	a019                	j	5fa <vprintf+0x44>
    } else if(state == '%'){
 5f6:	03598363          	beq	s3,s5,61c <vprintf+0x66>
  for(i = 0; fmt[i]; i++){
 5fa:	0019079b          	addiw	a5,s2,1
 5fe:	893e                	mv	s2,a5
 600:	873e                	mv	a4,a5
 602:	97d2                	add	a5,a5,s4
 604:	0007c483          	lbu	s1,0(a5)
 608:	1c048a63          	beqz	s1,7dc <vprintf+0x226>
    c0 = fmt[i] & 0xff;
 60c:	0004879b          	sext.w	a5,s1
    if(state == 0){
 610:	fe0993e3          	bnez	s3,5f6 <vprintf+0x40>
      if(c0 == '%'){
 614:	fd579ce3          	bne	a5,s5,5ec <vprintf+0x36>
        state = '%';
 618:	89be                	mv	s3,a5
 61a:	b7c5                	j	5fa <vprintf+0x44>
      if(c0) c1 = fmt[i+1] & 0xff;
 61c:	00ea06b3          	add	a3,s4,a4
 620:	0016c603          	lbu	a2,1(a3)
      if(c1) c2 = fmt[i+2] & 0xff;
 624:	1c060863          	beqz	a2,7f4 <vprintf+0x23e>
      if(c0 == 'd'){
 628:	03878763          	beq	a5,s8,656 <vprintf+0xa0>
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c0 == 'l' && c1 == 'd'){
 62c:	f9478693          	addi	a3,a5,-108
 630:	0016b693          	seqz	a3,a3
 634:	f9c60593          	addi	a1,a2,-100
 638:	e99d                	bnez	a1,66e <vprintf+0xb8>
 63a:	ca95                	beqz	a3,66e <vprintf+0xb8>
        printint(fd, va_arg(ap, uint64), 10, 1);
 63c:	008b8493          	addi	s1,s7,8
 640:	4685                	li	a3,1
 642:	4629                	li	a2,10
 644:	000bb583          	ld	a1,0(s7)
 648:	855a                	mv	a0,s6
 64a:	ecfff0ef          	jal	518 <printint>
        i += 1;
 64e:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 10, 1);
 650:	8ba6                	mv	s7,s1
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c0);
      }

      state = 0;
 652:	4981                	li	s3,0
 654:	b75d                	j	5fa <vprintf+0x44>
        printint(fd, va_arg(ap, int), 10, 1);
 656:	008b8493          	addi	s1,s7,8
 65a:	4685                	li	a3,1
 65c:	4629                	li	a2,10
 65e:	000ba583          	lw	a1,0(s7)
 662:	855a                	mv	a0,s6
 664:	eb5ff0ef          	jal	518 <printint>
 668:	8ba6                	mv	s7,s1
      state = 0;
 66a:	4981                	li	s3,0
 66c:	b779                	j	5fa <vprintf+0x44>
      if(c1) c2 = fmt[i+2] & 0xff;
 66e:	9752                	add	a4,a4,s4
 670:	00274583          	lbu	a1,2(a4)
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 674:	f9460713          	addi	a4,a2,-108
 678:	00173713          	seqz	a4,a4
 67c:	8f75                	and	a4,a4,a3
 67e:	f9c58513          	addi	a0,a1,-100
 682:	18051363          	bnez	a0,808 <vprintf+0x252>
 686:	18070163          	beqz	a4,808 <vprintf+0x252>
        printint(fd, va_arg(ap, uint64), 10, 1);
 68a:	008b8493          	addi	s1,s7,8
 68e:	4685                	li	a3,1
 690:	4629                	li	a2,10
 692:	000bb583          	ld	a1,0(s7)
 696:	855a                	mv	a0,s6
 698:	e81ff0ef          	jal	518 <printint>
        i += 2;
 69c:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 10, 1);
 69e:	8ba6                	mv	s7,s1
      state = 0;
 6a0:	4981                	li	s3,0
        i += 2;
 6a2:	bfa1                	j	5fa <vprintf+0x44>
        printint(fd, va_arg(ap, uint32), 10, 0);
 6a4:	008b8493          	addi	s1,s7,8
 6a8:	4681                	li	a3,0
 6aa:	4629                	li	a2,10
 6ac:	000be583          	lwu	a1,0(s7)
 6b0:	855a                	mv	a0,s6
 6b2:	e67ff0ef          	jal	518 <printint>
 6b6:	8ba6                	mv	s7,s1
      state = 0;
 6b8:	4981                	li	s3,0
 6ba:	b781                	j	5fa <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 10, 0);
 6bc:	008b8493          	addi	s1,s7,8
 6c0:	4681                	li	a3,0
 6c2:	4629                	li	a2,10
 6c4:	000bb583          	ld	a1,0(s7)
 6c8:	855a                	mv	a0,s6
 6ca:	e4fff0ef          	jal	518 <printint>
        i += 1;
 6ce:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 10, 0);
 6d0:	8ba6                	mv	s7,s1
      state = 0;
 6d2:	4981                	li	s3,0
 6d4:	b71d                	j	5fa <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 10, 0);
 6d6:	008b8493          	addi	s1,s7,8
 6da:	4681                	li	a3,0
 6dc:	4629                	li	a2,10
 6de:	000bb583          	ld	a1,0(s7)
 6e2:	855a                	mv	a0,s6
 6e4:	e35ff0ef          	jal	518 <printint>
        i += 2;
 6e8:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 10, 0);
 6ea:	8ba6                	mv	s7,s1
      state = 0;
 6ec:	4981                	li	s3,0
        i += 2;
 6ee:	b731                	j	5fa <vprintf+0x44>
        printint(fd, va_arg(ap, uint32), 16, 0);
 6f0:	008b8493          	addi	s1,s7,8
 6f4:	4681                	li	a3,0
 6f6:	4641                	li	a2,16
 6f8:	000be583          	lwu	a1,0(s7)
 6fc:	855a                	mv	a0,s6
 6fe:	e1bff0ef          	jal	518 <printint>
 702:	8ba6                	mv	s7,s1
      state = 0;
 704:	4981                	li	s3,0
 706:	bdd5                	j	5fa <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 16, 0);
 708:	008b8493          	addi	s1,s7,8
 70c:	4681                	li	a3,0
 70e:	4641                	li	a2,16
 710:	000bb583          	ld	a1,0(s7)
 714:	855a                	mv	a0,s6
 716:	e03ff0ef          	jal	518 <printint>
        i += 1;
 71a:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 16, 0);
 71c:	8ba6                	mv	s7,s1
      state = 0;
 71e:	4981                	li	s3,0
 720:	bde9                	j	5fa <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 16, 0);
 722:	008b8493          	addi	s1,s7,8
 726:	4681                	li	a3,0
 728:	4641                	li	a2,16
 72a:	000bb583          	ld	a1,0(s7)
 72e:	855a                	mv	a0,s6
 730:	de9ff0ef          	jal	518 <printint>
        i += 2;
 734:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 16, 0);
 736:	8ba6                	mv	s7,s1
      state = 0;
 738:	4981                	li	s3,0
        i += 2;
 73a:	b5c1                	j	5fa <vprintf+0x44>
 73c:	e466                	sd	s9,8(sp)
        printptr(fd, va_arg(ap, uint64));
 73e:	008b8793          	addi	a5,s7,8
 742:	8cbe                	mv	s9,a5
 744:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 748:	03000593          	li	a1,48
 74c:	855a                	mv	a0,s6
 74e:	dadff0ef          	jal	4fa <putc>
  putc(fd, 'x');
 752:	07800593          	li	a1,120
 756:	855a                	mv	a0,s6
 758:	da3ff0ef          	jal	4fa <putc>
 75c:	44c1                	li	s1,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 75e:	00000b97          	auipc	s7,0x0
 762:	47ab8b93          	addi	s7,s7,1146 # bd8 <digits>
 766:	03c9d793          	srli	a5,s3,0x3c
 76a:	97de                	add	a5,a5,s7
 76c:	0007c583          	lbu	a1,0(a5)
 770:	855a                	mv	a0,s6
 772:	d89ff0ef          	jal	4fa <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 776:	0992                	slli	s3,s3,0x4
 778:	34fd                	addiw	s1,s1,-1
 77a:	f4f5                	bnez	s1,766 <vprintf+0x1b0>
        printptr(fd, va_arg(ap, uint64));
 77c:	8be6                	mv	s7,s9
      state = 0;
 77e:	4981                	li	s3,0
 780:	6ca2                	ld	s9,8(sp)
 782:	bda5                	j	5fa <vprintf+0x44>
        putc(fd, va_arg(ap, uint32));
 784:	008b8493          	addi	s1,s7,8
 788:	000bc583          	lbu	a1,0(s7)
 78c:	855a                	mv	a0,s6
 78e:	d6dff0ef          	jal	4fa <putc>
 792:	8ba6                	mv	s7,s1
      state = 0;
 794:	4981                	li	s3,0
 796:	b595                	j	5fa <vprintf+0x44>
        if((s = va_arg(ap, char*)) == 0)
 798:	008b8993          	addi	s3,s7,8
 79c:	000bb483          	ld	s1,0(s7)
 7a0:	cc91                	beqz	s1,7bc <vprintf+0x206>
        for(; *s; s++)
 7a2:	0004c583          	lbu	a1,0(s1)
 7a6:	c985                	beqz	a1,7d6 <vprintf+0x220>
          putc(fd, *s);
 7a8:	855a                	mv	a0,s6
 7aa:	d51ff0ef          	jal	4fa <putc>
        for(; *s; s++)
 7ae:	0485                	addi	s1,s1,1
 7b0:	0004c583          	lbu	a1,0(s1)
 7b4:	f9f5                	bnez	a1,7a8 <vprintf+0x1f2>
        if((s = va_arg(ap, char*)) == 0)
 7b6:	8bce                	mv	s7,s3
      state = 0;
 7b8:	4981                	li	s3,0
 7ba:	b581                	j	5fa <vprintf+0x44>
          s = "(null)";
 7bc:	00000497          	auipc	s1,0x0
 7c0:	41448493          	addi	s1,s1,1044 # bd0 <malloc+0x278>
        for(; *s; s++)
 7c4:	02800593          	li	a1,40
 7c8:	b7c5                	j	7a8 <vprintf+0x1f2>
        putc(fd, '%');
 7ca:	85be                	mv	a1,a5
 7cc:	855a                	mv	a0,s6
 7ce:	d2dff0ef          	jal	4fa <putc>
      state = 0;
 7d2:	4981                	li	s3,0
 7d4:	b51d                	j	5fa <vprintf+0x44>
        if((s = va_arg(ap, char*)) == 0)
 7d6:	8bce                	mv	s7,s3
      state = 0;
 7d8:	4981                	li	s3,0
 7da:	b505                	j	5fa <vprintf+0x44>
 7dc:	6906                	ld	s2,64(sp)
 7de:	79e2                	ld	s3,56(sp)
 7e0:	7a42                	ld	s4,48(sp)
 7e2:	7aa2                	ld	s5,40(sp)
 7e4:	7b02                	ld	s6,32(sp)
 7e6:	6be2                	ld	s7,24(sp)
 7e8:	6c42                	ld	s8,16(sp)
    }
  }
}
 7ea:	60e6                	ld	ra,88(sp)
 7ec:	6446                	ld	s0,80(sp)
 7ee:	64a6                	ld	s1,72(sp)
 7f0:	6125                	addi	sp,sp,96
 7f2:	8082                	ret
      if(c0 == 'd'){
 7f4:	06400713          	li	a4,100
 7f8:	e4e78fe3          	beq	a5,a4,656 <vprintf+0xa0>
      } else if(c0 == 'l' && c1 == 'd'){
 7fc:	f9478693          	addi	a3,a5,-108
 800:	0016b693          	seqz	a3,a3
      c1 = c2 = 0;
 804:	85b2                	mv	a1,a2
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 806:	4701                	li	a4,0
      } else if(c0 == 'u'){
 808:	07500513          	li	a0,117
 80c:	e8a78ce3          	beq	a5,a0,6a4 <vprintf+0xee>
      } else if(c0 == 'l' && c1 == 'u'){
 810:	f8b60513          	addi	a0,a2,-117
 814:	e119                	bnez	a0,81a <vprintf+0x264>
 816:	ea0693e3          	bnez	a3,6bc <vprintf+0x106>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
 81a:	f8b58513          	addi	a0,a1,-117
 81e:	e119                	bnez	a0,824 <vprintf+0x26e>
 820:	ea071be3          	bnez	a4,6d6 <vprintf+0x120>
      } else if(c0 == 'x'){
 824:	07800513          	li	a0,120
 828:	eca784e3          	beq	a5,a0,6f0 <vprintf+0x13a>
      } else if(c0 == 'l' && c1 == 'x'){
 82c:	f8860613          	addi	a2,a2,-120
 830:	e219                	bnez	a2,836 <vprintf+0x280>
 832:	ec069be3          	bnez	a3,708 <vprintf+0x152>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
 836:	f8858593          	addi	a1,a1,-120
 83a:	e199                	bnez	a1,840 <vprintf+0x28a>
 83c:	ee0713e3          	bnez	a4,722 <vprintf+0x16c>
      } else if(c0 == 'p'){
 840:	07000713          	li	a4,112
 844:	eee78ce3          	beq	a5,a4,73c <vprintf+0x186>
      } else if(c0 == 'c'){
 848:	06300713          	li	a4,99
 84c:	f2e78ce3          	beq	a5,a4,784 <vprintf+0x1ce>
      } else if(c0 == 's'){
 850:	07300713          	li	a4,115
 854:	f4e782e3          	beq	a5,a4,798 <vprintf+0x1e2>
      } else if(c0 == '%'){
 858:	02500713          	li	a4,37
 85c:	f6e787e3          	beq	a5,a4,7ca <vprintf+0x214>
        putc(fd, '%');
 860:	02500593          	li	a1,37
 864:	855a                	mv	a0,s6
 866:	c95ff0ef          	jal	4fa <putc>
        putc(fd, c0);
 86a:	85a6                	mv	a1,s1
 86c:	855a                	mv	a0,s6
 86e:	c8dff0ef          	jal	4fa <putc>
      state = 0;
 872:	4981                	li	s3,0
 874:	b359                	j	5fa <vprintf+0x44>

0000000000000876 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 876:	715d                	addi	sp,sp,-80
 878:	ec06                	sd	ra,24(sp)
 87a:	e822                	sd	s0,16(sp)
 87c:	1000                	addi	s0,sp,32
 87e:	e010                	sd	a2,0(s0)
 880:	e414                	sd	a3,8(s0)
 882:	e818                	sd	a4,16(s0)
 884:	ec1c                	sd	a5,24(s0)
 886:	03043023          	sd	a6,32(s0)
 88a:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 88e:	8622                	mv	a2,s0
 890:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 894:	d23ff0ef          	jal	5b6 <vprintf>
}
 898:	60e2                	ld	ra,24(sp)
 89a:	6442                	ld	s0,16(sp)
 89c:	6161                	addi	sp,sp,80
 89e:	8082                	ret

00000000000008a0 <printf>:

void
printf(const char *fmt, ...)
{
 8a0:	711d                	addi	sp,sp,-96
 8a2:	ec06                	sd	ra,24(sp)
 8a4:	e822                	sd	s0,16(sp)
 8a6:	1000                	addi	s0,sp,32
 8a8:	e40c                	sd	a1,8(s0)
 8aa:	e810                	sd	a2,16(s0)
 8ac:	ec14                	sd	a3,24(s0)
 8ae:	f018                	sd	a4,32(s0)
 8b0:	f41c                	sd	a5,40(s0)
 8b2:	03043823          	sd	a6,48(s0)
 8b6:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 8ba:	00840613          	addi	a2,s0,8
 8be:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 8c2:	85aa                	mv	a1,a0
 8c4:	4505                	li	a0,1
 8c6:	cf1ff0ef          	jal	5b6 <vprintf>
}
 8ca:	60e2                	ld	ra,24(sp)
 8cc:	6442                	ld	s0,16(sp)
 8ce:	6125                	addi	sp,sp,96
 8d0:	8082                	ret

00000000000008d2 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 8d2:	1141                	addi	sp,sp,-16
 8d4:	e406                	sd	ra,8(sp)
 8d6:	e022                	sd	s0,0(sp)
 8d8:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 8da:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 8de:	00001797          	auipc	a5,0x1
 8e2:	7227b783          	ld	a5,1826(a5) # 2000 <freep>
 8e6:	a039                	j	8f4 <free+0x22>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 8e8:	6398                	ld	a4,0(a5)
 8ea:	00e7e463          	bltu	a5,a4,8f2 <free+0x20>
 8ee:	00e6ea63          	bltu	a3,a4,902 <free+0x30>
{
 8f2:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 8f4:	fed7fae3          	bgeu	a5,a3,8e8 <free+0x16>
 8f8:	6398                	ld	a4,0(a5)
 8fa:	00e6e463          	bltu	a3,a4,902 <free+0x30>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 8fe:	fee7eae3          	bltu	a5,a4,8f2 <free+0x20>
      break;
  if(bp + bp->s.size == p->s.ptr){
 902:	ff852583          	lw	a1,-8(a0)
 906:	6390                	ld	a2,0(a5)
 908:	02059813          	slli	a6,a1,0x20
 90c:	01c85713          	srli	a4,a6,0x1c
 910:	9736                	add	a4,a4,a3
 912:	02e60563          	beq	a2,a4,93c <free+0x6a>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
 916:	fec53823          	sd	a2,-16(a0)
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
 91a:	4790                	lw	a2,8(a5)
 91c:	02061593          	slli	a1,a2,0x20
 920:	01c5d713          	srli	a4,a1,0x1c
 924:	973e                	add	a4,a4,a5
 926:	02e68263          	beq	a3,a4,94a <free+0x78>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
 92a:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 92c:	00001717          	auipc	a4,0x1
 930:	6cf73a23          	sd	a5,1748(a4) # 2000 <freep>
}
 934:	60a2                	ld	ra,8(sp)
 936:	6402                	ld	s0,0(sp)
 938:	0141                	addi	sp,sp,16
 93a:	8082                	ret
    bp->s.size += p->s.ptr->s.size;
 93c:	4618                	lw	a4,8(a2)
 93e:	9f2d                	addw	a4,a4,a1
 940:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 944:	6398                	ld	a4,0(a5)
 946:	6310                	ld	a2,0(a4)
 948:	b7f9                	j	916 <free+0x44>
    p->s.size += bp->s.size;
 94a:	ff852703          	lw	a4,-8(a0)
 94e:	9f31                	addw	a4,a4,a2
 950:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 952:	ff053683          	ld	a3,-16(a0)
 956:	bfd1                	j	92a <free+0x58>

0000000000000958 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 958:	7139                	addi	sp,sp,-64
 95a:	fc06                	sd	ra,56(sp)
 95c:	f822                	sd	s0,48(sp)
 95e:	f04a                	sd	s2,32(sp)
 960:	ec4e                	sd	s3,24(sp)
 962:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 964:	02051993          	slli	s3,a0,0x20
 968:	0209d993          	srli	s3,s3,0x20
 96c:	09bd                	addi	s3,s3,15
 96e:	0049d993          	srli	s3,s3,0x4
 972:	2985                	addiw	s3,s3,1
 974:	894e                	mv	s2,s3
  if((prevp = freep) == 0){
 976:	00001517          	auipc	a0,0x1
 97a:	68a53503          	ld	a0,1674(a0) # 2000 <freep>
 97e:	c905                	beqz	a0,9ae <malloc+0x56>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 980:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 982:	4798                	lw	a4,8(a5)
 984:	09377663          	bgeu	a4,s3,a10 <malloc+0xb8>
 988:	f426                	sd	s1,40(sp)
 98a:	e852                	sd	s4,16(sp)
 98c:	e456                	sd	s5,8(sp)
 98e:	e05a                	sd	s6,0(sp)
  if(nu < 4096)
 990:	8a4e                	mv	s4,s3
 992:	6705                	lui	a4,0x1
 994:	00e9f363          	bgeu	s3,a4,99a <malloc+0x42>
 998:	6a05                	lui	s4,0x1
 99a:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 99e:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 9a2:	00001497          	auipc	s1,0x1
 9a6:	65e48493          	addi	s1,s1,1630 # 2000 <freep>
  if(p == SBRK_ERROR)
 9aa:	5afd                	li	s5,-1
 9ac:	a83d                	j	9ea <malloc+0x92>
 9ae:	f426                	sd	s1,40(sp)
 9b0:	e852                	sd	s4,16(sp)
 9b2:	e456                	sd	s5,8(sp)
 9b4:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
 9b6:	00001797          	auipc	a5,0x1
 9ba:	65a78793          	addi	a5,a5,1626 # 2010 <base>
 9be:	00001717          	auipc	a4,0x1
 9c2:	64f73123          	sd	a5,1602(a4) # 2000 <freep>
 9c6:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 9c8:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 9cc:	b7d1                	j	990 <malloc+0x38>
        prevp->s.ptr = p->s.ptr;
 9ce:	6398                	ld	a4,0(a5)
 9d0:	e118                	sd	a4,0(a0)
 9d2:	a899                	j	a28 <malloc+0xd0>
  hp->s.size = nu;
 9d4:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 9d8:	0541                	addi	a0,a0,16
 9da:	ef9ff0ef          	jal	8d2 <free>
  return freep;
 9de:	6088                	ld	a0,0(s1)
      if((p = morecore(nunits)) == 0)
 9e0:	c125                	beqz	a0,a40 <malloc+0xe8>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 9e2:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 9e4:	4798                	lw	a4,8(a5)
 9e6:	03277163          	bgeu	a4,s2,a08 <malloc+0xb0>
    if(p == freep)
 9ea:	6098                	ld	a4,0(s1)
 9ec:	853e                	mv	a0,a5
 9ee:	fef71ae3          	bne	a4,a5,9e2 <malloc+0x8a>
  p = sbrk(nu * sizeof(Header));
 9f2:	8552                	mv	a0,s4
 9f4:	a2bff0ef          	jal	41e <sbrk>
  if(p == SBRK_ERROR)
 9f8:	fd551ee3          	bne	a0,s5,9d4 <malloc+0x7c>
        return 0;
 9fc:	4501                	li	a0,0
 9fe:	74a2                	ld	s1,40(sp)
 a00:	6a42                	ld	s4,16(sp)
 a02:	6aa2                	ld	s5,8(sp)
 a04:	6b02                	ld	s6,0(sp)
 a06:	a03d                	j	a34 <malloc+0xdc>
 a08:	74a2                	ld	s1,40(sp)
 a0a:	6a42                	ld	s4,16(sp)
 a0c:	6aa2                	ld	s5,8(sp)
 a0e:	6b02                	ld	s6,0(sp)
      if(p->s.size == nunits)
 a10:	fae90fe3          	beq	s2,a4,9ce <malloc+0x76>
        p->s.size -= nunits;
 a14:	4137073b          	subw	a4,a4,s3
 a18:	c798                	sw	a4,8(a5)
        p += p->s.size;
 a1a:	02071693          	slli	a3,a4,0x20
 a1e:	01c6d713          	srli	a4,a3,0x1c
 a22:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 a24:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 a28:	00001717          	auipc	a4,0x1
 a2c:	5ca73c23          	sd	a0,1496(a4) # 2000 <freep>
      return (void*)(p + 1);
 a30:	01078513          	addi	a0,a5,16
  }
}
 a34:	70e2                	ld	ra,56(sp)
 a36:	7442                	ld	s0,48(sp)
 a38:	7902                	ld	s2,32(sp)
 a3a:	69e2                	ld	s3,24(sp)
 a3c:	6121                	addi	sp,sp,64
 a3e:	8082                	ret
 a40:	74a2                	ld	s1,40(sp)
 a42:	6a42                	ld	s4,16(sp)
 a44:	6aa2                	ld	s5,8(sp)
 a46:	6b02                	ld	s6,0(sp)
 a48:	b7f5                	j	a34 <malloc+0xdc>
