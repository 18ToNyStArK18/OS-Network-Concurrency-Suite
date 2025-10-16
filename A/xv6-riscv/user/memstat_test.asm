
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
  3a:	3da000ef          	jal	414 <sbrk>
  char *p = (char *)0;
  p[0] = 'A';
  3e:	04100793          	li	a5,65
  42:	00f00023          	sb	a5,0(zero) # 0 <main>
  p[4096] = 'B';
  46:	6785                	lui	a5,0x1
  48:	04200713          	li	a4,66
  4c:	00e78023          	sb	a4,0(a5) # 1000 <digits+0x438>
  p[8192] = 'C';
  50:	6789                	lui	a5,0x2
  52:	04300713          	li	a4,67
  56:	00e78023          	sb	a4,0(a5) # 2000 <freep>

  // Call the new system call
  if (memstat(&info) < 0) {
  5a:	80040513          	addi	a0,s0,-2048
  5e:	fa050513          	addi	a0,a0,-96 # 4fa0 <base+0x2f90>
  62:	de850513          	addi	a0,a0,-536
  66:	482000ef          	jal	4e8 <memstat>
  6a:	0c054c63          	bltz	a0,142 <main+0x142>
    printf("memstat failed\n");
    exit(1);
  }

  printf("--- Process Memory Stats ---\n");
  6e:	00001517          	auipc	a0,0x1
  72:	a1250513          	addi	a0,a0,-1518 # a80 <malloc+0x132>
  76:	021000ef          	jal	896 <printf>
  printf("PID: %d\n", info.pid);
  7a:	80040493          	addi	s1,s0,-2048
  7e:	fa048493          	addi	s1,s1,-96
  82:	de84a583          	lw	a1,-536(s1)
  86:	00001517          	auipc	a0,0x1
  8a:	a1a50513          	addi	a0,a0,-1510 # aa0 <malloc+0x152>
  8e:	009000ef          	jal	896 <printf>
  printf("Total Pages: %d\n", info.num_pages_total);
  92:	dec4a583          	lw	a1,-532(s1)
  96:	00001517          	auipc	a0,0x1
  9a:	a1a50513          	addi	a0,a0,-1510 # ab0 <malloc+0x162>
  9e:	7f8000ef          	jal	896 <printf>
  printf("Resident Pages: %d\n", info.num_resident_pages);
  a2:	df04a583          	lw	a1,-528(s1)
  a6:	00001517          	auipc	a0,0x1
  aa:	a2250513          	addi	a0,a0,-1502 # ac8 <malloc+0x17a>
  ae:	7e8000ef          	jal	896 <printf>
  printf("Swapped Pages: %d\n", info.num_swapped_pages);
  b2:	df44a583          	lw	a1,-524(s1)
  b6:	00001517          	auipc	a0,0x1
  ba:	a2a50513          	addi	a0,a0,-1494 # ae0 <malloc+0x192>
  be:	7d8000ef          	jal	896 <printf>
  printf("Next FIFO Seq: %d\n\n", info.next_fifo_seq);
  c2:	df84a583          	lw	a1,-520(s1)
  c6:	00001517          	auipc	a0,0x1
  ca:	a3250513          	addi	a0,a0,-1486 # af8 <malloc+0x1aa>
  ce:	7c8000ef          	jal	896 <printf>
  
  printf("--- Page Details (up to %d) ---\n", MAX_PAGES_INFO);
  d2:	08000593          	li	a1,128
  d6:	00001517          	auipc	a0,0x1
  da:	a3a50513          	addi	a0,a0,-1478 # b10 <malloc+0x1c2>
  de:	7b8000ef          	jal	896 <printf>
  printf("VA         | STATE    | DIRTY | SEQ   | SLOT\n");
  e2:	00001517          	auipc	a0,0x1
  e6:	a5650513          	addi	a0,a0,-1450 # b38 <malloc+0x1ea>
  ea:	7ac000ef          	jal	896 <printf>
  printf("--------------------------------------------\n");
  ee:	00001517          	auipc	a0,0x1
  f2:	a7a50513          	addi	a0,a0,-1414 # b68 <malloc+0x21a>
  f6:	7a0000ef          	jal	896 <printf>
  
  for (int i = 0; i < info.num_pages_total && i < MAX_PAGES_INFO; i++) {
  fa:	dec4a783          	lw	a5,-532(s1)
  fe:	08f05763          	blez	a5,18c <main+0x18c>
 102:	80040493          	addi	s1,s0,-2048
 106:	fa048493          	addi	s1,s1,-96
 10a:	dfc48493          	addi	s1,s1,-516
 10e:	4901                	li	s2,0
    char *state_str = "UNMAPPED";
    if (info.pages[i].state == RESIDENT) state_str = "RESIDENT";
 110:	4b05                	li	s6,1
 112:	00001a97          	auipc	s5,0x1
 116:	94ea8a93          	addi	s5,s5,-1714 # a60 <malloc+0x112>
    if (info.pages[i].state == SWAPPED) state_str = "SWAPPED ";
 11a:	4c09                	li	s8,2
 11c:	00001b97          	auipc	s7,0x1
 120:	934b8b93          	addi	s7,s7,-1740 # a50 <malloc+0x102>
 124:	00001c97          	auipc	s9,0x1
 128:	91cc8c93          	addi	s9,s9,-1764 # a40 <malloc+0xf2>
    
    printf("0x%x | %s | %d     | %d    | %d\n",
 12c:	00001a17          	auipc	s4,0x1
 130:	a6ca0a13          	addi	s4,s4,-1428 # b98 <malloc+0x24a>
  for (int i = 0; i < info.num_pages_total && i < MAX_PAGES_INFO; i++) {
 134:	80040993          	addi	s3,s0,-2048
 138:	fa098993          	addi	s3,s3,-96
 13c:	80098993          	addi	s3,s3,-2048
 140:	a825                	j	178 <main+0x178>
    printf("memstat failed\n");
 142:	00001517          	auipc	a0,0x1
 146:	92e50513          	addi	a0,a0,-1746 # a70 <malloc+0x122>
 14a:	74c000ef          	jal	896 <printf>
    exit(1);
 14e:	4505                	li	a0,1
 150:	2f8000ef          	jal	448 <exit>
    printf("0x%x | %s | %d     | %d    | %d\n",
 154:	499c                	lw	a5,16(a1)
 156:	45d8                	lw	a4,12(a1)
 158:	4594                	lw	a3,8(a1)
 15a:	418c                	lw	a1,0(a1)
 15c:	8552                	mv	a0,s4
 15e:	738000ef          	jal	896 <printf>
  for (int i = 0; i < info.num_pages_total && i < MAX_PAGES_INFO; i++) {
 162:	0019079b          	addiw	a5,s2,1
 166:	893e                	mv	s2,a5
 168:	04d1                	addi	s1,s1,20
 16a:	5ec9a703          	lw	a4,1516(s3)
 16e:	00e7df63          	bge	a5,a4,18c <main+0x18c>
 172:	0807a793          	slti	a5,a5,128
 176:	cb99                	beqz	a5,18c <main+0x18c>
    if (info.pages[i].state == RESIDENT) state_str = "RESIDENT";
 178:	85a6                	mv	a1,s1
 17a:	40dc                	lw	a5,4(s1)
 17c:	8656                	mv	a2,s5
 17e:	fd678be3          	beq	a5,s6,154 <main+0x154>
    if (info.pages[i].state == SWAPPED) state_str = "SWAPPED ";
 182:	865e                	mv	a2,s7
 184:	fd8788e3          	beq	a5,s8,154 <main+0x154>
 188:	8666                	mv	a2,s9
 18a:	b7e9                	j	154 <main+0x154>
           info.pages[i].is_dirty,
           info.pages[i].seq,
           info.pages[i].swap_slot);
  }

  exit(0);
 18c:	4501                	li	a0,0
 18e:	2ba000ef          	jal	448 <exit>

0000000000000192 <start>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
start(int argc, char **argv)
{
 192:	1141                	addi	sp,sp,-16
 194:	e406                	sd	ra,8(sp)
 196:	e022                	sd	s0,0(sp)
 198:	0800                	addi	s0,sp,16
  int r;
  extern int main(int argc, char **argv);
  r = main(argc, argv);
 19a:	e67ff0ef          	jal	0 <main>
  exit(r);
 19e:	2aa000ef          	jal	448 <exit>

00000000000001a2 <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
 1a2:	1141                	addi	sp,sp,-16
 1a4:	e406                	sd	ra,8(sp)
 1a6:	e022                	sd	s0,0(sp)
 1a8:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 1aa:	87aa                	mv	a5,a0
 1ac:	0585                	addi	a1,a1,1
 1ae:	0785                	addi	a5,a5,1
 1b0:	fff5c703          	lbu	a4,-1(a1)
 1b4:	fee78fa3          	sb	a4,-1(a5)
 1b8:	fb75                	bnez	a4,1ac <strcpy+0xa>
    ;
  return os;
}
 1ba:	60a2                	ld	ra,8(sp)
 1bc:	6402                	ld	s0,0(sp)
 1be:	0141                	addi	sp,sp,16
 1c0:	8082                	ret

00000000000001c2 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 1c2:	1141                	addi	sp,sp,-16
 1c4:	e406                	sd	ra,8(sp)
 1c6:	e022                	sd	s0,0(sp)
 1c8:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
 1ca:	00054783          	lbu	a5,0(a0)
 1ce:	cb91                	beqz	a5,1e2 <strcmp+0x20>
 1d0:	0005c703          	lbu	a4,0(a1)
 1d4:	00f71763          	bne	a4,a5,1e2 <strcmp+0x20>
    p++, q++;
 1d8:	0505                	addi	a0,a0,1
 1da:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
 1dc:	00054783          	lbu	a5,0(a0)
 1e0:	fbe5                	bnez	a5,1d0 <strcmp+0xe>
  return (uchar)*p - (uchar)*q;
 1e2:	0005c503          	lbu	a0,0(a1)
}
 1e6:	40a7853b          	subw	a0,a5,a0
 1ea:	60a2                	ld	ra,8(sp)
 1ec:	6402                	ld	s0,0(sp)
 1ee:	0141                	addi	sp,sp,16
 1f0:	8082                	ret

00000000000001f2 <strlen>:

uint
strlen(const char *s)
{
 1f2:	1141                	addi	sp,sp,-16
 1f4:	e406                	sd	ra,8(sp)
 1f6:	e022                	sd	s0,0(sp)
 1f8:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 1fa:	00054783          	lbu	a5,0(a0)
 1fe:	cf91                	beqz	a5,21a <strlen+0x28>
 200:	00150793          	addi	a5,a0,1
 204:	86be                	mv	a3,a5
 206:	0785                	addi	a5,a5,1
 208:	fff7c703          	lbu	a4,-1(a5)
 20c:	ff65                	bnez	a4,204 <strlen+0x12>
 20e:	40a6853b          	subw	a0,a3,a0
    ;
  return n;
}
 212:	60a2                	ld	ra,8(sp)
 214:	6402                	ld	s0,0(sp)
 216:	0141                	addi	sp,sp,16
 218:	8082                	ret
  for(n = 0; s[n]; n++)
 21a:	4501                	li	a0,0
 21c:	bfdd                	j	212 <strlen+0x20>

000000000000021e <memset>:

void*
memset(void *dst, int c, uint n)
{
 21e:	1141                	addi	sp,sp,-16
 220:	e406                	sd	ra,8(sp)
 222:	e022                	sd	s0,0(sp)
 224:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 226:	ca19                	beqz	a2,23c <memset+0x1e>
 228:	87aa                	mv	a5,a0
 22a:	1602                	slli	a2,a2,0x20
 22c:	9201                	srli	a2,a2,0x20
 22e:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 232:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 236:	0785                	addi	a5,a5,1
 238:	fee79de3          	bne	a5,a4,232 <memset+0x14>
  }
  return dst;
}
 23c:	60a2                	ld	ra,8(sp)
 23e:	6402                	ld	s0,0(sp)
 240:	0141                	addi	sp,sp,16
 242:	8082                	ret

0000000000000244 <strchr>:

char*
strchr(const char *s, char c)
{
 244:	1141                	addi	sp,sp,-16
 246:	e406                	sd	ra,8(sp)
 248:	e022                	sd	s0,0(sp)
 24a:	0800                	addi	s0,sp,16
  for(; *s; s++)
 24c:	00054783          	lbu	a5,0(a0)
 250:	cf81                	beqz	a5,268 <strchr+0x24>
    if(*s == c)
 252:	00f58763          	beq	a1,a5,260 <strchr+0x1c>
  for(; *s; s++)
 256:	0505                	addi	a0,a0,1
 258:	00054783          	lbu	a5,0(a0)
 25c:	fbfd                	bnez	a5,252 <strchr+0xe>
      return (char*)s;
  return 0;
 25e:	4501                	li	a0,0
}
 260:	60a2                	ld	ra,8(sp)
 262:	6402                	ld	s0,0(sp)
 264:	0141                	addi	sp,sp,16
 266:	8082                	ret
  return 0;
 268:	4501                	li	a0,0
 26a:	bfdd                	j	260 <strchr+0x1c>

000000000000026c <gets>:

char*
gets(char *buf, int max)
{
 26c:	711d                	addi	sp,sp,-96
 26e:	ec86                	sd	ra,88(sp)
 270:	e8a2                	sd	s0,80(sp)
 272:	e4a6                	sd	s1,72(sp)
 274:	e0ca                	sd	s2,64(sp)
 276:	fc4e                	sd	s3,56(sp)
 278:	f852                	sd	s4,48(sp)
 27a:	f456                	sd	s5,40(sp)
 27c:	f05a                	sd	s6,32(sp)
 27e:	ec5e                	sd	s7,24(sp)
 280:	e862                	sd	s8,16(sp)
 282:	1080                	addi	s0,sp,96
 284:	8baa                	mv	s7,a0
 286:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 288:	892a                	mv	s2,a0
 28a:	4481                	li	s1,0
    cc = read(0, &c, 1);
 28c:	faf40b13          	addi	s6,s0,-81
 290:	4a85                	li	s5,1
  for(i=0; i+1 < max; ){
 292:	8c26                	mv	s8,s1
 294:	0014899b          	addiw	s3,s1,1
 298:	84ce                	mv	s1,s3
 29a:	0349d463          	bge	s3,s4,2c2 <gets+0x56>
    cc = read(0, &c, 1);
 29e:	8656                	mv	a2,s5
 2a0:	85da                	mv	a1,s6
 2a2:	4501                	li	a0,0
 2a4:	1bc000ef          	jal	460 <read>
    if(cc < 1)
 2a8:	00a05d63          	blez	a0,2c2 <gets+0x56>
      break;
    buf[i++] = c;
 2ac:	faf44783          	lbu	a5,-81(s0)
 2b0:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 2b4:	0905                	addi	s2,s2,1
 2b6:	ff678713          	addi	a4,a5,-10
 2ba:	c319                	beqz	a4,2c0 <gets+0x54>
 2bc:	17cd                	addi	a5,a5,-13
 2be:	fbf1                	bnez	a5,292 <gets+0x26>
    buf[i++] = c;
 2c0:	8c4e                	mv	s8,s3
      break;
  }
  buf[i] = '\0';
 2c2:	9c5e                	add	s8,s8,s7
 2c4:	000c0023          	sb	zero,0(s8)
  return buf;
}
 2c8:	855e                	mv	a0,s7
 2ca:	60e6                	ld	ra,88(sp)
 2cc:	6446                	ld	s0,80(sp)
 2ce:	64a6                	ld	s1,72(sp)
 2d0:	6906                	ld	s2,64(sp)
 2d2:	79e2                	ld	s3,56(sp)
 2d4:	7a42                	ld	s4,48(sp)
 2d6:	7aa2                	ld	s5,40(sp)
 2d8:	7b02                	ld	s6,32(sp)
 2da:	6be2                	ld	s7,24(sp)
 2dc:	6c42                	ld	s8,16(sp)
 2de:	6125                	addi	sp,sp,96
 2e0:	8082                	ret

00000000000002e2 <stat>:

int
stat(const char *n, struct stat *st)
{
 2e2:	1101                	addi	sp,sp,-32
 2e4:	ec06                	sd	ra,24(sp)
 2e6:	e822                	sd	s0,16(sp)
 2e8:	e04a                	sd	s2,0(sp)
 2ea:	1000                	addi	s0,sp,32
 2ec:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 2ee:	4581                	li	a1,0
 2f0:	198000ef          	jal	488 <open>
  if(fd < 0)
 2f4:	02054263          	bltz	a0,318 <stat+0x36>
 2f8:	e426                	sd	s1,8(sp)
 2fa:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 2fc:	85ca                	mv	a1,s2
 2fe:	1a2000ef          	jal	4a0 <fstat>
 302:	892a                	mv	s2,a0
  close(fd);
 304:	8526                	mv	a0,s1
 306:	16a000ef          	jal	470 <close>
  return r;
 30a:	64a2                	ld	s1,8(sp)
}
 30c:	854a                	mv	a0,s2
 30e:	60e2                	ld	ra,24(sp)
 310:	6442                	ld	s0,16(sp)
 312:	6902                	ld	s2,0(sp)
 314:	6105                	addi	sp,sp,32
 316:	8082                	ret
    return -1;
 318:	57fd                	li	a5,-1
 31a:	893e                	mv	s2,a5
 31c:	bfc5                	j	30c <stat+0x2a>

000000000000031e <atoi>:

int
atoi(const char *s)
{
 31e:	1141                	addi	sp,sp,-16
 320:	e406                	sd	ra,8(sp)
 322:	e022                	sd	s0,0(sp)
 324:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 326:	00054683          	lbu	a3,0(a0)
 32a:	fd06879b          	addiw	a5,a3,-48
 32e:	0ff7f793          	zext.b	a5,a5
 332:	4625                	li	a2,9
 334:	02f66963          	bltu	a2,a5,366 <atoi+0x48>
 338:	872a                	mv	a4,a0
  n = 0;
 33a:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
 33c:	0705                	addi	a4,a4,1
 33e:	0025179b          	slliw	a5,a0,0x2
 342:	9fa9                	addw	a5,a5,a0
 344:	0017979b          	slliw	a5,a5,0x1
 348:	9fb5                	addw	a5,a5,a3
 34a:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 34e:	00074683          	lbu	a3,0(a4)
 352:	fd06879b          	addiw	a5,a3,-48
 356:	0ff7f793          	zext.b	a5,a5
 35a:	fef671e3          	bgeu	a2,a5,33c <atoi+0x1e>
  return n;
}
 35e:	60a2                	ld	ra,8(sp)
 360:	6402                	ld	s0,0(sp)
 362:	0141                	addi	sp,sp,16
 364:	8082                	ret
  n = 0;
 366:	4501                	li	a0,0
 368:	bfdd                	j	35e <atoi+0x40>

000000000000036a <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 36a:	1141                	addi	sp,sp,-16
 36c:	e406                	sd	ra,8(sp)
 36e:	e022                	sd	s0,0(sp)
 370:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 372:	02b57563          	bgeu	a0,a1,39c <memmove+0x32>
    while(n-- > 0)
 376:	00c05f63          	blez	a2,394 <memmove+0x2a>
 37a:	1602                	slli	a2,a2,0x20
 37c:	9201                	srli	a2,a2,0x20
 37e:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 382:	872a                	mv	a4,a0
      *dst++ = *src++;
 384:	0585                	addi	a1,a1,1
 386:	0705                	addi	a4,a4,1
 388:	fff5c683          	lbu	a3,-1(a1)
 38c:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 390:	fee79ae3          	bne	a5,a4,384 <memmove+0x1a>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 394:	60a2                	ld	ra,8(sp)
 396:	6402                	ld	s0,0(sp)
 398:	0141                	addi	sp,sp,16
 39a:	8082                	ret
    while(n-- > 0)
 39c:	fec05ce3          	blez	a2,394 <memmove+0x2a>
    dst += n;
 3a0:	00c50733          	add	a4,a0,a2
    src += n;
 3a4:	95b2                	add	a1,a1,a2
 3a6:	fff6079b          	addiw	a5,a2,-1
 3aa:	1782                	slli	a5,a5,0x20
 3ac:	9381                	srli	a5,a5,0x20
 3ae:	fff7c793          	not	a5,a5
 3b2:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 3b4:	15fd                	addi	a1,a1,-1
 3b6:	177d                	addi	a4,a4,-1
 3b8:	0005c683          	lbu	a3,0(a1)
 3bc:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 3c0:	fef71ae3          	bne	a4,a5,3b4 <memmove+0x4a>
 3c4:	bfc1                	j	394 <memmove+0x2a>

00000000000003c6 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 3c6:	1141                	addi	sp,sp,-16
 3c8:	e406                	sd	ra,8(sp)
 3ca:	e022                	sd	s0,0(sp)
 3cc:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 3ce:	c61d                	beqz	a2,3fc <memcmp+0x36>
 3d0:	1602                	slli	a2,a2,0x20
 3d2:	9201                	srli	a2,a2,0x20
 3d4:	00c506b3          	add	a3,a0,a2
    if (*p1 != *p2) {
 3d8:	00054783          	lbu	a5,0(a0)
 3dc:	0005c703          	lbu	a4,0(a1)
 3e0:	00e79863          	bne	a5,a4,3f0 <memcmp+0x2a>
      return *p1 - *p2;
    }
    p1++;
 3e4:	0505                	addi	a0,a0,1
    p2++;
 3e6:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 3e8:	fed518e3          	bne	a0,a3,3d8 <memcmp+0x12>
  }
  return 0;
 3ec:	4501                	li	a0,0
 3ee:	a019                	j	3f4 <memcmp+0x2e>
      return *p1 - *p2;
 3f0:	40e7853b          	subw	a0,a5,a4
}
 3f4:	60a2                	ld	ra,8(sp)
 3f6:	6402                	ld	s0,0(sp)
 3f8:	0141                	addi	sp,sp,16
 3fa:	8082                	ret
  return 0;
 3fc:	4501                	li	a0,0
 3fe:	bfdd                	j	3f4 <memcmp+0x2e>

0000000000000400 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 400:	1141                	addi	sp,sp,-16
 402:	e406                	sd	ra,8(sp)
 404:	e022                	sd	s0,0(sp)
 406:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 408:	f63ff0ef          	jal	36a <memmove>
}
 40c:	60a2                	ld	ra,8(sp)
 40e:	6402                	ld	s0,0(sp)
 410:	0141                	addi	sp,sp,16
 412:	8082                	ret

0000000000000414 <sbrk>:

char *
sbrk(int n) {
 414:	1141                	addi	sp,sp,-16
 416:	e406                	sd	ra,8(sp)
 418:	e022                	sd	s0,0(sp)
 41a:	0800                	addi	s0,sp,16
  return sys_sbrk(n, SBRK_EAGER);
 41c:	4585                	li	a1,1
 41e:	0b2000ef          	jal	4d0 <sys_sbrk>
}
 422:	60a2                	ld	ra,8(sp)
 424:	6402                	ld	s0,0(sp)
 426:	0141                	addi	sp,sp,16
 428:	8082                	ret

000000000000042a <sbrklazy>:

char *
sbrklazy(int n) {
 42a:	1141                	addi	sp,sp,-16
 42c:	e406                	sd	ra,8(sp)
 42e:	e022                	sd	s0,0(sp)
 430:	0800                	addi	s0,sp,16
  return sys_sbrk(n, SBRK_LAZY);
 432:	4589                	li	a1,2
 434:	09c000ef          	jal	4d0 <sys_sbrk>
}
 438:	60a2                	ld	ra,8(sp)
 43a:	6402                	ld	s0,0(sp)
 43c:	0141                	addi	sp,sp,16
 43e:	8082                	ret

0000000000000440 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 440:	4885                	li	a7,1
 ecall
 442:	00000073          	ecall
 ret
 446:	8082                	ret

0000000000000448 <exit>:
.global exit
exit:
 li a7, SYS_exit
 448:	4889                	li	a7,2
 ecall
 44a:	00000073          	ecall
 ret
 44e:	8082                	ret

0000000000000450 <wait>:
.global wait
wait:
 li a7, SYS_wait
 450:	488d                	li	a7,3
 ecall
 452:	00000073          	ecall
 ret
 456:	8082                	ret

0000000000000458 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 458:	4891                	li	a7,4
 ecall
 45a:	00000073          	ecall
 ret
 45e:	8082                	ret

0000000000000460 <read>:
.global read
read:
 li a7, SYS_read
 460:	4895                	li	a7,5
 ecall
 462:	00000073          	ecall
 ret
 466:	8082                	ret

0000000000000468 <write>:
.global write
write:
 li a7, SYS_write
 468:	48c1                	li	a7,16
 ecall
 46a:	00000073          	ecall
 ret
 46e:	8082                	ret

0000000000000470 <close>:
.global close
close:
 li a7, SYS_close
 470:	48d5                	li	a7,21
 ecall
 472:	00000073          	ecall
 ret
 476:	8082                	ret

0000000000000478 <kill>:
.global kill
kill:
 li a7, SYS_kill
 478:	4899                	li	a7,6
 ecall
 47a:	00000073          	ecall
 ret
 47e:	8082                	ret

0000000000000480 <exec>:
.global exec
exec:
 li a7, SYS_exec
 480:	489d                	li	a7,7
 ecall
 482:	00000073          	ecall
 ret
 486:	8082                	ret

0000000000000488 <open>:
.global open
open:
 li a7, SYS_open
 488:	48bd                	li	a7,15
 ecall
 48a:	00000073          	ecall
 ret
 48e:	8082                	ret

0000000000000490 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 490:	48c5                	li	a7,17
 ecall
 492:	00000073          	ecall
 ret
 496:	8082                	ret

0000000000000498 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 498:	48c9                	li	a7,18
 ecall
 49a:	00000073          	ecall
 ret
 49e:	8082                	ret

00000000000004a0 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 4a0:	48a1                	li	a7,8
 ecall
 4a2:	00000073          	ecall
 ret
 4a6:	8082                	ret

00000000000004a8 <link>:
.global link
link:
 li a7, SYS_link
 4a8:	48cd                	li	a7,19
 ecall
 4aa:	00000073          	ecall
 ret
 4ae:	8082                	ret

00000000000004b0 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 4b0:	48d1                	li	a7,20
 ecall
 4b2:	00000073          	ecall
 ret
 4b6:	8082                	ret

00000000000004b8 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 4b8:	48a5                	li	a7,9
 ecall
 4ba:	00000073          	ecall
 ret
 4be:	8082                	ret

00000000000004c0 <dup>:
.global dup
dup:
 li a7, SYS_dup
 4c0:	48a9                	li	a7,10
 ecall
 4c2:	00000073          	ecall
 ret
 4c6:	8082                	ret

00000000000004c8 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 4c8:	48ad                	li	a7,11
 ecall
 4ca:	00000073          	ecall
 ret
 4ce:	8082                	ret

00000000000004d0 <sys_sbrk>:
.global sys_sbrk
sys_sbrk:
 li a7, SYS_sbrk
 4d0:	48b1                	li	a7,12
 ecall
 4d2:	00000073          	ecall
 ret
 4d6:	8082                	ret

00000000000004d8 <pause>:
.global pause
pause:
 li a7, SYS_pause
 4d8:	48b5                	li	a7,13
 ecall
 4da:	00000073          	ecall
 ret
 4de:	8082                	ret

00000000000004e0 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 4e0:	48b9                	li	a7,14
 ecall
 4e2:	00000073          	ecall
 ret
 4e6:	8082                	ret

00000000000004e8 <memstat>:
.global memstat
memstat:
 li a7, SYS_memstat
 4e8:	48d9                	li	a7,22
 ecall
 4ea:	00000073          	ecall
 ret
 4ee:	8082                	ret

00000000000004f0 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 4f0:	1101                	addi	sp,sp,-32
 4f2:	ec06                	sd	ra,24(sp)
 4f4:	e822                	sd	s0,16(sp)
 4f6:	1000                	addi	s0,sp,32
 4f8:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 4fc:	4605                	li	a2,1
 4fe:	fef40593          	addi	a1,s0,-17
 502:	f67ff0ef          	jal	468 <write>
}
 506:	60e2                	ld	ra,24(sp)
 508:	6442                	ld	s0,16(sp)
 50a:	6105                	addi	sp,sp,32
 50c:	8082                	ret

000000000000050e <printint>:

static void
printint(int fd, long long xx, int base, int sgn)
{
 50e:	715d                	addi	sp,sp,-80
 510:	e486                	sd	ra,72(sp)
 512:	e0a2                	sd	s0,64(sp)
 514:	f84a                	sd	s2,48(sp)
 516:	f44e                	sd	s3,40(sp)
 518:	0880                	addi	s0,sp,80
 51a:	892a                	mv	s2,a0
  char buf[20];
  int i, neg;
  unsigned long long x;

  neg = 0;
  if(sgn && xx < 0){
 51c:	c6d1                	beqz	a3,5a8 <printint+0x9a>
 51e:	0805d563          	bgez	a1,5a8 <printint+0x9a>
    neg = 1;
    x = -xx;
 522:	40b005b3          	neg	a1,a1
    neg = 1;
 526:	4305                	li	t1,1
  } else {
    x = xx;
  }

  i = 0;
 528:	fb840993          	addi	s3,s0,-72
  neg = 0;
 52c:	86ce                	mv	a3,s3
  i = 0;
 52e:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 530:	00000817          	auipc	a6,0x0
 534:	69880813          	addi	a6,a6,1688 # bc8 <digits>
 538:	88ba                	mv	a7,a4
 53a:	0017051b          	addiw	a0,a4,1
 53e:	872a                	mv	a4,a0
 540:	02c5f7b3          	remu	a5,a1,a2
 544:	97c2                	add	a5,a5,a6
 546:	0007c783          	lbu	a5,0(a5)
 54a:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 54e:	87ae                	mv	a5,a1
 550:	02c5d5b3          	divu	a1,a1,a2
 554:	0685                	addi	a3,a3,1
 556:	fec7f1e3          	bgeu	a5,a2,538 <printint+0x2a>
  if(neg)
 55a:	00030c63          	beqz	t1,572 <printint+0x64>
    buf[i++] = '-';
 55e:	fd050793          	addi	a5,a0,-48
 562:	00878533          	add	a0,a5,s0
 566:	02d00793          	li	a5,45
 56a:	fef50423          	sb	a5,-24(a0)
 56e:	0028871b          	addiw	a4,a7,2

  while(--i >= 0)
 572:	02e05563          	blez	a4,59c <printint+0x8e>
 576:	fc26                	sd	s1,56(sp)
 578:	377d                	addiw	a4,a4,-1
 57a:	00e984b3          	add	s1,s3,a4
 57e:	19fd                	addi	s3,s3,-1
 580:	99ba                	add	s3,s3,a4
 582:	1702                	slli	a4,a4,0x20
 584:	9301                	srli	a4,a4,0x20
 586:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 58a:	0004c583          	lbu	a1,0(s1)
 58e:	854a                	mv	a0,s2
 590:	f61ff0ef          	jal	4f0 <putc>
  while(--i >= 0)
 594:	14fd                	addi	s1,s1,-1
 596:	ff349ae3          	bne	s1,s3,58a <printint+0x7c>
 59a:	74e2                	ld	s1,56(sp)
}
 59c:	60a6                	ld	ra,72(sp)
 59e:	6406                	ld	s0,64(sp)
 5a0:	7942                	ld	s2,48(sp)
 5a2:	79a2                	ld	s3,40(sp)
 5a4:	6161                	addi	sp,sp,80
 5a6:	8082                	ret
  neg = 0;
 5a8:	4301                	li	t1,0
 5aa:	bfbd                	j	528 <printint+0x1a>

00000000000005ac <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %c, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 5ac:	711d                	addi	sp,sp,-96
 5ae:	ec86                	sd	ra,88(sp)
 5b0:	e8a2                	sd	s0,80(sp)
 5b2:	e4a6                	sd	s1,72(sp)
 5b4:	1080                	addi	s0,sp,96
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 5b6:	0005c483          	lbu	s1,0(a1)
 5ba:	22048363          	beqz	s1,7e0 <vprintf+0x234>
 5be:	e0ca                	sd	s2,64(sp)
 5c0:	fc4e                	sd	s3,56(sp)
 5c2:	f852                	sd	s4,48(sp)
 5c4:	f456                	sd	s5,40(sp)
 5c6:	f05a                	sd	s6,32(sp)
 5c8:	ec5e                	sd	s7,24(sp)
 5ca:	e862                	sd	s8,16(sp)
 5cc:	8b2a                	mv	s6,a0
 5ce:	8a2e                	mv	s4,a1
 5d0:	8bb2                	mv	s7,a2
  state = 0;
 5d2:	4981                	li	s3,0
  for(i = 0; fmt[i]; i++){
 5d4:	4901                	li	s2,0
 5d6:	4701                	li	a4,0
      if(c0 == '%'){
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if(state == '%'){
 5d8:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if(c0) c1 = fmt[i+1] & 0xff;
      if(c1) c2 = fmt[i+2] & 0xff;
      if(c0 == 'd'){
 5dc:	06400c13          	li	s8,100
 5e0:	a00d                	j	602 <vprintf+0x56>
        putc(fd, c0);
 5e2:	85a6                	mv	a1,s1
 5e4:	855a                	mv	a0,s6
 5e6:	f0bff0ef          	jal	4f0 <putc>
 5ea:	a019                	j	5f0 <vprintf+0x44>
    } else if(state == '%'){
 5ec:	03598363          	beq	s3,s5,612 <vprintf+0x66>
  for(i = 0; fmt[i]; i++){
 5f0:	0019079b          	addiw	a5,s2,1
 5f4:	893e                	mv	s2,a5
 5f6:	873e                	mv	a4,a5
 5f8:	97d2                	add	a5,a5,s4
 5fa:	0007c483          	lbu	s1,0(a5)
 5fe:	1c048a63          	beqz	s1,7d2 <vprintf+0x226>
    c0 = fmt[i] & 0xff;
 602:	0004879b          	sext.w	a5,s1
    if(state == 0){
 606:	fe0993e3          	bnez	s3,5ec <vprintf+0x40>
      if(c0 == '%'){
 60a:	fd579ce3          	bne	a5,s5,5e2 <vprintf+0x36>
        state = '%';
 60e:	89be                	mv	s3,a5
 610:	b7c5                	j	5f0 <vprintf+0x44>
      if(c0) c1 = fmt[i+1] & 0xff;
 612:	00ea06b3          	add	a3,s4,a4
 616:	0016c603          	lbu	a2,1(a3)
      if(c1) c2 = fmt[i+2] & 0xff;
 61a:	1c060863          	beqz	a2,7ea <vprintf+0x23e>
      if(c0 == 'd'){
 61e:	03878763          	beq	a5,s8,64c <vprintf+0xa0>
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c0 == 'l' && c1 == 'd'){
 622:	f9478693          	addi	a3,a5,-108
 626:	0016b693          	seqz	a3,a3
 62a:	f9c60593          	addi	a1,a2,-100
 62e:	e99d                	bnez	a1,664 <vprintf+0xb8>
 630:	ca95                	beqz	a3,664 <vprintf+0xb8>
        printint(fd, va_arg(ap, uint64), 10, 1);
 632:	008b8493          	addi	s1,s7,8
 636:	4685                	li	a3,1
 638:	4629                	li	a2,10
 63a:	000bb583          	ld	a1,0(s7)
 63e:	855a                	mv	a0,s6
 640:	ecfff0ef          	jal	50e <printint>
        i += 1;
 644:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 10, 1);
 646:	8ba6                	mv	s7,s1
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c0);
      }

      state = 0;
 648:	4981                	li	s3,0
 64a:	b75d                	j	5f0 <vprintf+0x44>
        printint(fd, va_arg(ap, int), 10, 1);
 64c:	008b8493          	addi	s1,s7,8
 650:	4685                	li	a3,1
 652:	4629                	li	a2,10
 654:	000ba583          	lw	a1,0(s7)
 658:	855a                	mv	a0,s6
 65a:	eb5ff0ef          	jal	50e <printint>
 65e:	8ba6                	mv	s7,s1
      state = 0;
 660:	4981                	li	s3,0
 662:	b779                	j	5f0 <vprintf+0x44>
      if(c1) c2 = fmt[i+2] & 0xff;
 664:	9752                	add	a4,a4,s4
 666:	00274583          	lbu	a1,2(a4)
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 66a:	f9460713          	addi	a4,a2,-108
 66e:	00173713          	seqz	a4,a4
 672:	8f75                	and	a4,a4,a3
 674:	f9c58513          	addi	a0,a1,-100
 678:	18051363          	bnez	a0,7fe <vprintf+0x252>
 67c:	18070163          	beqz	a4,7fe <vprintf+0x252>
        printint(fd, va_arg(ap, uint64), 10, 1);
 680:	008b8493          	addi	s1,s7,8
 684:	4685                	li	a3,1
 686:	4629                	li	a2,10
 688:	000bb583          	ld	a1,0(s7)
 68c:	855a                	mv	a0,s6
 68e:	e81ff0ef          	jal	50e <printint>
        i += 2;
 692:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 10, 1);
 694:	8ba6                	mv	s7,s1
      state = 0;
 696:	4981                	li	s3,0
        i += 2;
 698:	bfa1                	j	5f0 <vprintf+0x44>
        printint(fd, va_arg(ap, uint32), 10, 0);
 69a:	008b8493          	addi	s1,s7,8
 69e:	4681                	li	a3,0
 6a0:	4629                	li	a2,10
 6a2:	000be583          	lwu	a1,0(s7)
 6a6:	855a                	mv	a0,s6
 6a8:	e67ff0ef          	jal	50e <printint>
 6ac:	8ba6                	mv	s7,s1
      state = 0;
 6ae:	4981                	li	s3,0
 6b0:	b781                	j	5f0 <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 10, 0);
 6b2:	008b8493          	addi	s1,s7,8
 6b6:	4681                	li	a3,0
 6b8:	4629                	li	a2,10
 6ba:	000bb583          	ld	a1,0(s7)
 6be:	855a                	mv	a0,s6
 6c0:	e4fff0ef          	jal	50e <printint>
        i += 1;
 6c4:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 10, 0);
 6c6:	8ba6                	mv	s7,s1
      state = 0;
 6c8:	4981                	li	s3,0
 6ca:	b71d                	j	5f0 <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 10, 0);
 6cc:	008b8493          	addi	s1,s7,8
 6d0:	4681                	li	a3,0
 6d2:	4629                	li	a2,10
 6d4:	000bb583          	ld	a1,0(s7)
 6d8:	855a                	mv	a0,s6
 6da:	e35ff0ef          	jal	50e <printint>
        i += 2;
 6de:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 10, 0);
 6e0:	8ba6                	mv	s7,s1
      state = 0;
 6e2:	4981                	li	s3,0
        i += 2;
 6e4:	b731                	j	5f0 <vprintf+0x44>
        printint(fd, va_arg(ap, uint32), 16, 0);
 6e6:	008b8493          	addi	s1,s7,8
 6ea:	4681                	li	a3,0
 6ec:	4641                	li	a2,16
 6ee:	000be583          	lwu	a1,0(s7)
 6f2:	855a                	mv	a0,s6
 6f4:	e1bff0ef          	jal	50e <printint>
 6f8:	8ba6                	mv	s7,s1
      state = 0;
 6fa:	4981                	li	s3,0
 6fc:	bdd5                	j	5f0 <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 16, 0);
 6fe:	008b8493          	addi	s1,s7,8
 702:	4681                	li	a3,0
 704:	4641                	li	a2,16
 706:	000bb583          	ld	a1,0(s7)
 70a:	855a                	mv	a0,s6
 70c:	e03ff0ef          	jal	50e <printint>
        i += 1;
 710:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 16, 0);
 712:	8ba6                	mv	s7,s1
      state = 0;
 714:	4981                	li	s3,0
 716:	bde9                	j	5f0 <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 16, 0);
 718:	008b8493          	addi	s1,s7,8
 71c:	4681                	li	a3,0
 71e:	4641                	li	a2,16
 720:	000bb583          	ld	a1,0(s7)
 724:	855a                	mv	a0,s6
 726:	de9ff0ef          	jal	50e <printint>
        i += 2;
 72a:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 16, 0);
 72c:	8ba6                	mv	s7,s1
      state = 0;
 72e:	4981                	li	s3,0
        i += 2;
 730:	b5c1                	j	5f0 <vprintf+0x44>
 732:	e466                	sd	s9,8(sp)
        printptr(fd, va_arg(ap, uint64));
 734:	008b8793          	addi	a5,s7,8
 738:	8cbe                	mv	s9,a5
 73a:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 73e:	03000593          	li	a1,48
 742:	855a                	mv	a0,s6
 744:	dadff0ef          	jal	4f0 <putc>
  putc(fd, 'x');
 748:	07800593          	li	a1,120
 74c:	855a                	mv	a0,s6
 74e:	da3ff0ef          	jal	4f0 <putc>
 752:	44c1                	li	s1,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 754:	00000b97          	auipc	s7,0x0
 758:	474b8b93          	addi	s7,s7,1140 # bc8 <digits>
 75c:	03c9d793          	srli	a5,s3,0x3c
 760:	97de                	add	a5,a5,s7
 762:	0007c583          	lbu	a1,0(a5)
 766:	855a                	mv	a0,s6
 768:	d89ff0ef          	jal	4f0 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 76c:	0992                	slli	s3,s3,0x4
 76e:	34fd                	addiw	s1,s1,-1
 770:	f4f5                	bnez	s1,75c <vprintf+0x1b0>
        printptr(fd, va_arg(ap, uint64));
 772:	8be6                	mv	s7,s9
      state = 0;
 774:	4981                	li	s3,0
 776:	6ca2                	ld	s9,8(sp)
 778:	bda5                	j	5f0 <vprintf+0x44>
        putc(fd, va_arg(ap, uint32));
 77a:	008b8493          	addi	s1,s7,8
 77e:	000bc583          	lbu	a1,0(s7)
 782:	855a                	mv	a0,s6
 784:	d6dff0ef          	jal	4f0 <putc>
 788:	8ba6                	mv	s7,s1
      state = 0;
 78a:	4981                	li	s3,0
 78c:	b595                	j	5f0 <vprintf+0x44>
        if((s = va_arg(ap, char*)) == 0)
 78e:	008b8993          	addi	s3,s7,8
 792:	000bb483          	ld	s1,0(s7)
 796:	cc91                	beqz	s1,7b2 <vprintf+0x206>
        for(; *s; s++)
 798:	0004c583          	lbu	a1,0(s1)
 79c:	c985                	beqz	a1,7cc <vprintf+0x220>
          putc(fd, *s);
 79e:	855a                	mv	a0,s6
 7a0:	d51ff0ef          	jal	4f0 <putc>
        for(; *s; s++)
 7a4:	0485                	addi	s1,s1,1
 7a6:	0004c583          	lbu	a1,0(s1)
 7aa:	f9f5                	bnez	a1,79e <vprintf+0x1f2>
        if((s = va_arg(ap, char*)) == 0)
 7ac:	8bce                	mv	s7,s3
      state = 0;
 7ae:	4981                	li	s3,0
 7b0:	b581                	j	5f0 <vprintf+0x44>
          s = "(null)";
 7b2:	00000497          	auipc	s1,0x0
 7b6:	40e48493          	addi	s1,s1,1038 # bc0 <malloc+0x272>
        for(; *s; s++)
 7ba:	02800593          	li	a1,40
 7be:	b7c5                	j	79e <vprintf+0x1f2>
        putc(fd, '%');
 7c0:	85be                	mv	a1,a5
 7c2:	855a                	mv	a0,s6
 7c4:	d2dff0ef          	jal	4f0 <putc>
      state = 0;
 7c8:	4981                	li	s3,0
 7ca:	b51d                	j	5f0 <vprintf+0x44>
        if((s = va_arg(ap, char*)) == 0)
 7cc:	8bce                	mv	s7,s3
      state = 0;
 7ce:	4981                	li	s3,0
 7d0:	b505                	j	5f0 <vprintf+0x44>
 7d2:	6906                	ld	s2,64(sp)
 7d4:	79e2                	ld	s3,56(sp)
 7d6:	7a42                	ld	s4,48(sp)
 7d8:	7aa2                	ld	s5,40(sp)
 7da:	7b02                	ld	s6,32(sp)
 7dc:	6be2                	ld	s7,24(sp)
 7de:	6c42                	ld	s8,16(sp)
    }
  }
}
 7e0:	60e6                	ld	ra,88(sp)
 7e2:	6446                	ld	s0,80(sp)
 7e4:	64a6                	ld	s1,72(sp)
 7e6:	6125                	addi	sp,sp,96
 7e8:	8082                	ret
      if(c0 == 'd'){
 7ea:	06400713          	li	a4,100
 7ee:	e4e78fe3          	beq	a5,a4,64c <vprintf+0xa0>
      } else if(c0 == 'l' && c1 == 'd'){
 7f2:	f9478693          	addi	a3,a5,-108
 7f6:	0016b693          	seqz	a3,a3
      c1 = c2 = 0;
 7fa:	85b2                	mv	a1,a2
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 7fc:	4701                	li	a4,0
      } else if(c0 == 'u'){
 7fe:	07500513          	li	a0,117
 802:	e8a78ce3          	beq	a5,a0,69a <vprintf+0xee>
      } else if(c0 == 'l' && c1 == 'u'){
 806:	f8b60513          	addi	a0,a2,-117
 80a:	e119                	bnez	a0,810 <vprintf+0x264>
 80c:	ea0693e3          	bnez	a3,6b2 <vprintf+0x106>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
 810:	f8b58513          	addi	a0,a1,-117
 814:	e119                	bnez	a0,81a <vprintf+0x26e>
 816:	ea071be3          	bnez	a4,6cc <vprintf+0x120>
      } else if(c0 == 'x'){
 81a:	07800513          	li	a0,120
 81e:	eca784e3          	beq	a5,a0,6e6 <vprintf+0x13a>
      } else if(c0 == 'l' && c1 == 'x'){
 822:	f8860613          	addi	a2,a2,-120
 826:	e219                	bnez	a2,82c <vprintf+0x280>
 828:	ec069be3          	bnez	a3,6fe <vprintf+0x152>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
 82c:	f8858593          	addi	a1,a1,-120
 830:	e199                	bnez	a1,836 <vprintf+0x28a>
 832:	ee0713e3          	bnez	a4,718 <vprintf+0x16c>
      } else if(c0 == 'p'){
 836:	07000713          	li	a4,112
 83a:	eee78ce3          	beq	a5,a4,732 <vprintf+0x186>
      } else if(c0 == 'c'){
 83e:	06300713          	li	a4,99
 842:	f2e78ce3          	beq	a5,a4,77a <vprintf+0x1ce>
      } else if(c0 == 's'){
 846:	07300713          	li	a4,115
 84a:	f4e782e3          	beq	a5,a4,78e <vprintf+0x1e2>
      } else if(c0 == '%'){
 84e:	02500713          	li	a4,37
 852:	f6e787e3          	beq	a5,a4,7c0 <vprintf+0x214>
        putc(fd, '%');
 856:	02500593          	li	a1,37
 85a:	855a                	mv	a0,s6
 85c:	c95ff0ef          	jal	4f0 <putc>
        putc(fd, c0);
 860:	85a6                	mv	a1,s1
 862:	855a                	mv	a0,s6
 864:	c8dff0ef          	jal	4f0 <putc>
      state = 0;
 868:	4981                	li	s3,0
 86a:	b359                	j	5f0 <vprintf+0x44>

000000000000086c <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 86c:	715d                	addi	sp,sp,-80
 86e:	ec06                	sd	ra,24(sp)
 870:	e822                	sd	s0,16(sp)
 872:	1000                	addi	s0,sp,32
 874:	e010                	sd	a2,0(s0)
 876:	e414                	sd	a3,8(s0)
 878:	e818                	sd	a4,16(s0)
 87a:	ec1c                	sd	a5,24(s0)
 87c:	03043023          	sd	a6,32(s0)
 880:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 884:	8622                	mv	a2,s0
 886:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 88a:	d23ff0ef          	jal	5ac <vprintf>
}
 88e:	60e2                	ld	ra,24(sp)
 890:	6442                	ld	s0,16(sp)
 892:	6161                	addi	sp,sp,80
 894:	8082                	ret

0000000000000896 <printf>:

void
printf(const char *fmt, ...)
{
 896:	711d                	addi	sp,sp,-96
 898:	ec06                	sd	ra,24(sp)
 89a:	e822                	sd	s0,16(sp)
 89c:	1000                	addi	s0,sp,32
 89e:	e40c                	sd	a1,8(s0)
 8a0:	e810                	sd	a2,16(s0)
 8a2:	ec14                	sd	a3,24(s0)
 8a4:	f018                	sd	a4,32(s0)
 8a6:	f41c                	sd	a5,40(s0)
 8a8:	03043823          	sd	a6,48(s0)
 8ac:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 8b0:	00840613          	addi	a2,s0,8
 8b4:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 8b8:	85aa                	mv	a1,a0
 8ba:	4505                	li	a0,1
 8bc:	cf1ff0ef          	jal	5ac <vprintf>
}
 8c0:	60e2                	ld	ra,24(sp)
 8c2:	6442                	ld	s0,16(sp)
 8c4:	6125                	addi	sp,sp,96
 8c6:	8082                	ret

00000000000008c8 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 8c8:	1141                	addi	sp,sp,-16
 8ca:	e406                	sd	ra,8(sp)
 8cc:	e022                	sd	s0,0(sp)
 8ce:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 8d0:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 8d4:	00001797          	auipc	a5,0x1
 8d8:	72c7b783          	ld	a5,1836(a5) # 2000 <freep>
 8dc:	a039                	j	8ea <free+0x22>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 8de:	6398                	ld	a4,0(a5)
 8e0:	00e7e463          	bltu	a5,a4,8e8 <free+0x20>
 8e4:	00e6ea63          	bltu	a3,a4,8f8 <free+0x30>
{
 8e8:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 8ea:	fed7fae3          	bgeu	a5,a3,8de <free+0x16>
 8ee:	6398                	ld	a4,0(a5)
 8f0:	00e6e463          	bltu	a3,a4,8f8 <free+0x30>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 8f4:	fee7eae3          	bltu	a5,a4,8e8 <free+0x20>
      break;
  if(bp + bp->s.size == p->s.ptr){
 8f8:	ff852583          	lw	a1,-8(a0)
 8fc:	6390                	ld	a2,0(a5)
 8fe:	02059813          	slli	a6,a1,0x20
 902:	01c85713          	srli	a4,a6,0x1c
 906:	9736                	add	a4,a4,a3
 908:	02e60563          	beq	a2,a4,932 <free+0x6a>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
 90c:	fec53823          	sd	a2,-16(a0)
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
 910:	4790                	lw	a2,8(a5)
 912:	02061593          	slli	a1,a2,0x20
 916:	01c5d713          	srli	a4,a1,0x1c
 91a:	973e                	add	a4,a4,a5
 91c:	02e68263          	beq	a3,a4,940 <free+0x78>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
 920:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 922:	00001717          	auipc	a4,0x1
 926:	6cf73f23          	sd	a5,1758(a4) # 2000 <freep>
}
 92a:	60a2                	ld	ra,8(sp)
 92c:	6402                	ld	s0,0(sp)
 92e:	0141                	addi	sp,sp,16
 930:	8082                	ret
    bp->s.size += p->s.ptr->s.size;
 932:	4618                	lw	a4,8(a2)
 934:	9f2d                	addw	a4,a4,a1
 936:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 93a:	6398                	ld	a4,0(a5)
 93c:	6310                	ld	a2,0(a4)
 93e:	b7f9                	j	90c <free+0x44>
    p->s.size += bp->s.size;
 940:	ff852703          	lw	a4,-8(a0)
 944:	9f31                	addw	a4,a4,a2
 946:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 948:	ff053683          	ld	a3,-16(a0)
 94c:	bfd1                	j	920 <free+0x58>

000000000000094e <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 94e:	7139                	addi	sp,sp,-64
 950:	fc06                	sd	ra,56(sp)
 952:	f822                	sd	s0,48(sp)
 954:	f04a                	sd	s2,32(sp)
 956:	ec4e                	sd	s3,24(sp)
 958:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 95a:	02051993          	slli	s3,a0,0x20
 95e:	0209d993          	srli	s3,s3,0x20
 962:	09bd                	addi	s3,s3,15
 964:	0049d993          	srli	s3,s3,0x4
 968:	2985                	addiw	s3,s3,1
 96a:	894e                	mv	s2,s3
  if((prevp = freep) == 0){
 96c:	00001517          	auipc	a0,0x1
 970:	69453503          	ld	a0,1684(a0) # 2000 <freep>
 974:	c905                	beqz	a0,9a4 <malloc+0x56>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 976:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 978:	4798                	lw	a4,8(a5)
 97a:	09377663          	bgeu	a4,s3,a06 <malloc+0xb8>
 97e:	f426                	sd	s1,40(sp)
 980:	e852                	sd	s4,16(sp)
 982:	e456                	sd	s5,8(sp)
 984:	e05a                	sd	s6,0(sp)
  if(nu < 4096)
 986:	8a4e                	mv	s4,s3
 988:	6705                	lui	a4,0x1
 98a:	00e9f363          	bgeu	s3,a4,990 <malloc+0x42>
 98e:	6a05                	lui	s4,0x1
 990:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 994:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 998:	00001497          	auipc	s1,0x1
 99c:	66848493          	addi	s1,s1,1640 # 2000 <freep>
  if(p == SBRK_ERROR)
 9a0:	5afd                	li	s5,-1
 9a2:	a83d                	j	9e0 <malloc+0x92>
 9a4:	f426                	sd	s1,40(sp)
 9a6:	e852                	sd	s4,16(sp)
 9a8:	e456                	sd	s5,8(sp)
 9aa:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
 9ac:	00001797          	auipc	a5,0x1
 9b0:	66478793          	addi	a5,a5,1636 # 2010 <base>
 9b4:	00001717          	auipc	a4,0x1
 9b8:	64f73623          	sd	a5,1612(a4) # 2000 <freep>
 9bc:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 9be:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 9c2:	b7d1                	j	986 <malloc+0x38>
        prevp->s.ptr = p->s.ptr;
 9c4:	6398                	ld	a4,0(a5)
 9c6:	e118                	sd	a4,0(a0)
 9c8:	a899                	j	a1e <malloc+0xd0>
  hp->s.size = nu;
 9ca:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 9ce:	0541                	addi	a0,a0,16
 9d0:	ef9ff0ef          	jal	8c8 <free>
  return freep;
 9d4:	6088                	ld	a0,0(s1)
      if((p = morecore(nunits)) == 0)
 9d6:	c125                	beqz	a0,a36 <malloc+0xe8>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 9d8:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 9da:	4798                	lw	a4,8(a5)
 9dc:	03277163          	bgeu	a4,s2,9fe <malloc+0xb0>
    if(p == freep)
 9e0:	6098                	ld	a4,0(s1)
 9e2:	853e                	mv	a0,a5
 9e4:	fef71ae3          	bne	a4,a5,9d8 <malloc+0x8a>
  p = sbrk(nu * sizeof(Header));
 9e8:	8552                	mv	a0,s4
 9ea:	a2bff0ef          	jal	414 <sbrk>
  if(p == SBRK_ERROR)
 9ee:	fd551ee3          	bne	a0,s5,9ca <malloc+0x7c>
        return 0;
 9f2:	4501                	li	a0,0
 9f4:	74a2                	ld	s1,40(sp)
 9f6:	6a42                	ld	s4,16(sp)
 9f8:	6aa2                	ld	s5,8(sp)
 9fa:	6b02                	ld	s6,0(sp)
 9fc:	a03d                	j	a2a <malloc+0xdc>
 9fe:	74a2                	ld	s1,40(sp)
 a00:	6a42                	ld	s4,16(sp)
 a02:	6aa2                	ld	s5,8(sp)
 a04:	6b02                	ld	s6,0(sp)
      if(p->s.size == nunits)
 a06:	fae90fe3          	beq	s2,a4,9c4 <malloc+0x76>
        p->s.size -= nunits;
 a0a:	4137073b          	subw	a4,a4,s3
 a0e:	c798                	sw	a4,8(a5)
        p += p->s.size;
 a10:	02071693          	slli	a3,a4,0x20
 a14:	01c6d713          	srli	a4,a3,0x1c
 a18:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 a1a:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 a1e:	00001717          	auipc	a4,0x1
 a22:	5ea73123          	sd	a0,1506(a4) # 2000 <freep>
      return (void*)(p + 1);
 a26:	01078513          	addi	a0,a5,16
  }
}
 a2a:	70e2                	ld	ra,56(sp)
 a2c:	7442                	ld	s0,48(sp)
 a2e:	7902                	ld	s2,32(sp)
 a30:	69e2                	ld	s3,24(sp)
 a32:	6121                	addi	sp,sp,64
 a34:	8082                	ret
 a36:	74a2                	ld	s1,40(sp)
 a38:	6a42                	ld	s4,16(sp)
 a3a:	6aa2                	ld	s5,8(sp)
 a3c:	6b02                	ld	s6,0(sp)
 a3e:	b7f5                	j	a2a <malloc+0xdc>
