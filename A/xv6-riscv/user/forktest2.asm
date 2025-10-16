
user/_forktest2:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <forktest2>:
#include "../kernel/param.h"

// Tests that fork correctly copies the parent's memory.
void
forktest2(void)
{
   0:	7179                	addi	sp,sp,-48
   2:	f406                	sd	ra,40(sp)
   4:	f022                	sd	s0,32(sp)
   6:	ec26                	sd	s1,24(sp)
   8:	1800                	addi	s0,sp,48
  printf("starting fork test 2\n");
   a:	00001517          	auipc	a0,0x1
   e:	9d650513          	addi	a0,a0,-1578 # 9e0 <malloc+0xfc>
  12:	01b000ef          	jal	82c <printf>

  // Allocate one page of memory.
  char *mem = sbrk(4096);
  16:	6505                	lui	a0,0x1
  18:	392000ef          	jal	3aa <sbrk>
  1c:	84aa                	mv	s1,a0
  if(mem == (char*)-1){
  1e:	577d                	li	a4,-1
  20:	4781                	li	a5,0
    printf("sbrk failed\n");
    exit(1);
  }

  // Write a pattern to the parent's memory.
  for(int i = 0; i < 4096; i++){
  22:	6685                	lui	a3,0x1
  if(mem == (char*)-1){
  24:	06e50c63          	beq	a0,a4,9c <forktest2+0x9c>
    mem[i] = (char)(i % 256);
  28:	00f48733          	add	a4,s1,a5
  2c:	00f70023          	sb	a5,0(a4)
  for(int i = 0; i < 4096; i++){
  30:	0785                	addi	a5,a5,1
  32:	fed79be3          	bne	a5,a3,28 <forktest2+0x28>
  }

  printf("parent finished writing memory\n");
  36:	00001517          	auipc	a0,0x1
  3a:	9da50513          	addi	a0,a0,-1574 # a10 <malloc+0x12c>
  3e:	7ee000ef          	jal	82c <printf>

  int pid = fork();
  42:	394000ef          	jal	3d6 <fork>
  if(pid < 0){
  46:	06054563          	bltz	a0,b0 <forktest2+0xb0>
    printf("fork failed\n");
    exit(1);
  }

  if(pid == 0){
  4a:	ed49                	bnez	a0,e4 <forktest2+0xe4>
  4c:	e84a                	sd	s2,16(sp)
    // --- Child Process ---
    char *mem2 = sbrk(4096);
  4e:	6505                	lui	a0,0x1
  50:	35a000ef          	jal	3aa <sbrk>
  54:	892a                	mv	s2,a0
    if(mem2 == 0){
  56:	c53d                	beqz	a0,c4 <forktest2+0xc4>
        printf("MEM NOT Allocated\n");
    }
    mem2[0] = 'A'; 
  58:	04100793          	li	a5,65
  5c:	00f90023          	sb	a5,0(s2)
    printf("child started, checking memory...\n");
  60:	00001517          	auipc	a0,0x1
  64:	9f850513          	addi	a0,a0,-1544 # a58 <malloc+0x174>
  68:	7c4000ef          	jal	82c <printf>
  6c:	4781                	li	a5,0

    // Check if the child can see the parent's data.
    for(int i = 0; i < 4096; i++){
  6e:	6605                	lui	a2,0x1
  70:	0007859b          	sext.w	a1,a5
      if(mem[i] != (char)(i % 256)){
  74:	00f48733          	add	a4,s1,a5
  78:	00074683          	lbu	a3,0(a4)
  7c:	0ff7f713          	zext.b	a4,a5
  80:	04e69963          	bne	a3,a4,d2 <forktest2+0xd2>
    for(int i = 0; i < 4096; i++){
  84:	0785                	addi	a5,a5,1
  86:	fec795e3          	bne	a5,a2,70 <forktest2+0x70>
        printf("fork test 2 failed: incorrect data in child at index %d\n", i);
        exit(1); // Exit with a failure code.
      }
    }

    printf("child finished checking, memory is correct.\n");
  8a:	00001517          	auipc	a0,0x1
  8e:	a3650513          	addi	a0,a0,-1482 # ac0 <malloc+0x1dc>
  92:	79a000ef          	jal	82c <printf>
    exit(0); // Exit with a success code.
  96:	4501                	li	a0,0
  98:	346000ef          	jal	3de <exit>
  9c:	e84a                	sd	s2,16(sp)
    printf("sbrk failed\n");
  9e:	00001517          	auipc	a0,0x1
  a2:	96250513          	addi	a0,a0,-1694 # a00 <malloc+0x11c>
  a6:	786000ef          	jal	82c <printf>
    exit(1);
  aa:	4505                	li	a0,1
  ac:	332000ef          	jal	3de <exit>
  b0:	e84a                	sd	s2,16(sp)
    printf("fork failed\n");
  b2:	00001517          	auipc	a0,0x1
  b6:	97e50513          	addi	a0,a0,-1666 # a30 <malloc+0x14c>
  ba:	772000ef          	jal	82c <printf>
    exit(1);
  be:	4505                	li	a0,1
  c0:	31e000ef          	jal	3de <exit>
        printf("MEM NOT Allocated\n");
  c4:	00001517          	auipc	a0,0x1
  c8:	97c50513          	addi	a0,a0,-1668 # a40 <malloc+0x15c>
  cc:	760000ef          	jal	82c <printf>
  d0:	b761                	j	58 <forktest2+0x58>
        printf("fork test 2 failed: incorrect data in child at index %d\n", i);
  d2:	00001517          	auipc	a0,0x1
  d6:	9ae50513          	addi	a0,a0,-1618 # a80 <malloc+0x19c>
  da:	752000ef          	jal	82c <printf>
        exit(1); // Exit with a failure code.
  de:	4505                	li	a0,1
  e0:	2fe000ef          	jal	3de <exit>

  } else {
    // --- Parent Process ---
    int status;
    wait(&status);
  e4:	fdc40513          	addi	a0,s0,-36
  e8:	2fe000ef          	jal	3e6 <wait>

    if(status == 0){
  ec:	fdc42783          	lw	a5,-36(s0)
  f0:	ef81                	bnez	a5,108 <forktest2+0x108>
      printf("fork test 2 OK\n");
  f2:	00001517          	auipc	a0,0x1
  f6:	9fe50513          	addi	a0,a0,-1538 # af0 <malloc+0x20c>
  fa:	732000ef          	jal	82c <printf>
    } else {
      printf("fork test 2 FAILED\n");
    }
  }
}
  fe:	70a2                	ld	ra,40(sp)
 100:	7402                	ld	s0,32(sp)
 102:	64e2                	ld	s1,24(sp)
 104:	6145                	addi	sp,sp,48
 106:	8082                	ret
      printf("fork test 2 FAILED\n");
 108:	00001517          	auipc	a0,0x1
 10c:	9f850513          	addi	a0,a0,-1544 # b00 <malloc+0x21c>
 110:	71c000ef          	jal	82c <printf>
}
 114:	b7ed                	j	fe <forktest2+0xfe>

0000000000000116 <main>:

int
main(void)
{
 116:	1141                	addi	sp,sp,-16
 118:	e406                	sd	ra,8(sp)
 11a:	e022                	sd	s0,0(sp)
 11c:	0800                	addi	s0,sp,16
  forktest2();
 11e:	ee3ff0ef          	jal	0 <forktest2>
  exit(0);
 122:	4501                	li	a0,0
 124:	2ba000ef          	jal	3de <exit>

0000000000000128 <start>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
start(int argc, char **argv)
{
 128:	1141                	addi	sp,sp,-16
 12a:	e406                	sd	ra,8(sp)
 12c:	e022                	sd	s0,0(sp)
 12e:	0800                	addi	s0,sp,16
  int r;
  extern int main(int argc, char **argv);
  r = main(argc, argv);
 130:	fe7ff0ef          	jal	116 <main>
  exit(r);
 134:	2aa000ef          	jal	3de <exit>

0000000000000138 <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
 138:	1141                	addi	sp,sp,-16
 13a:	e406                	sd	ra,8(sp)
 13c:	e022                	sd	s0,0(sp)
 13e:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 140:	87aa                	mv	a5,a0
 142:	0585                	addi	a1,a1,1
 144:	0785                	addi	a5,a5,1
 146:	fff5c703          	lbu	a4,-1(a1)
 14a:	fee78fa3          	sb	a4,-1(a5)
 14e:	fb75                	bnez	a4,142 <strcpy+0xa>
    ;
  return os;
}
 150:	60a2                	ld	ra,8(sp)
 152:	6402                	ld	s0,0(sp)
 154:	0141                	addi	sp,sp,16
 156:	8082                	ret

0000000000000158 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 158:	1141                	addi	sp,sp,-16
 15a:	e406                	sd	ra,8(sp)
 15c:	e022                	sd	s0,0(sp)
 15e:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
 160:	00054783          	lbu	a5,0(a0)
 164:	cb91                	beqz	a5,178 <strcmp+0x20>
 166:	0005c703          	lbu	a4,0(a1)
 16a:	00f71763          	bne	a4,a5,178 <strcmp+0x20>
    p++, q++;
 16e:	0505                	addi	a0,a0,1
 170:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
 172:	00054783          	lbu	a5,0(a0)
 176:	fbe5                	bnez	a5,166 <strcmp+0xe>
  return (uchar)*p - (uchar)*q;
 178:	0005c503          	lbu	a0,0(a1)
}
 17c:	40a7853b          	subw	a0,a5,a0
 180:	60a2                	ld	ra,8(sp)
 182:	6402                	ld	s0,0(sp)
 184:	0141                	addi	sp,sp,16
 186:	8082                	ret

0000000000000188 <strlen>:

uint
strlen(const char *s)
{
 188:	1141                	addi	sp,sp,-16
 18a:	e406                	sd	ra,8(sp)
 18c:	e022                	sd	s0,0(sp)
 18e:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 190:	00054783          	lbu	a5,0(a0)
 194:	cf91                	beqz	a5,1b0 <strlen+0x28>
 196:	00150793          	addi	a5,a0,1
 19a:	86be                	mv	a3,a5
 19c:	0785                	addi	a5,a5,1
 19e:	fff7c703          	lbu	a4,-1(a5)
 1a2:	ff65                	bnez	a4,19a <strlen+0x12>
 1a4:	40a6853b          	subw	a0,a3,a0
    ;
  return n;
}
 1a8:	60a2                	ld	ra,8(sp)
 1aa:	6402                	ld	s0,0(sp)
 1ac:	0141                	addi	sp,sp,16
 1ae:	8082                	ret
  for(n = 0; s[n]; n++)
 1b0:	4501                	li	a0,0
 1b2:	bfdd                	j	1a8 <strlen+0x20>

00000000000001b4 <memset>:

void*
memset(void *dst, int c, uint n)
{
 1b4:	1141                	addi	sp,sp,-16
 1b6:	e406                	sd	ra,8(sp)
 1b8:	e022                	sd	s0,0(sp)
 1ba:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 1bc:	ca19                	beqz	a2,1d2 <memset+0x1e>
 1be:	87aa                	mv	a5,a0
 1c0:	1602                	slli	a2,a2,0x20
 1c2:	9201                	srli	a2,a2,0x20
 1c4:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 1c8:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 1cc:	0785                	addi	a5,a5,1
 1ce:	fee79de3          	bne	a5,a4,1c8 <memset+0x14>
  }
  return dst;
}
 1d2:	60a2                	ld	ra,8(sp)
 1d4:	6402                	ld	s0,0(sp)
 1d6:	0141                	addi	sp,sp,16
 1d8:	8082                	ret

00000000000001da <strchr>:

char*
strchr(const char *s, char c)
{
 1da:	1141                	addi	sp,sp,-16
 1dc:	e406                	sd	ra,8(sp)
 1de:	e022                	sd	s0,0(sp)
 1e0:	0800                	addi	s0,sp,16
  for(; *s; s++)
 1e2:	00054783          	lbu	a5,0(a0)
 1e6:	cf81                	beqz	a5,1fe <strchr+0x24>
    if(*s == c)
 1e8:	00f58763          	beq	a1,a5,1f6 <strchr+0x1c>
  for(; *s; s++)
 1ec:	0505                	addi	a0,a0,1
 1ee:	00054783          	lbu	a5,0(a0)
 1f2:	fbfd                	bnez	a5,1e8 <strchr+0xe>
      return (char*)s;
  return 0;
 1f4:	4501                	li	a0,0
}
 1f6:	60a2                	ld	ra,8(sp)
 1f8:	6402                	ld	s0,0(sp)
 1fa:	0141                	addi	sp,sp,16
 1fc:	8082                	ret
  return 0;
 1fe:	4501                	li	a0,0
 200:	bfdd                	j	1f6 <strchr+0x1c>

0000000000000202 <gets>:

char*
gets(char *buf, int max)
{
 202:	711d                	addi	sp,sp,-96
 204:	ec86                	sd	ra,88(sp)
 206:	e8a2                	sd	s0,80(sp)
 208:	e4a6                	sd	s1,72(sp)
 20a:	e0ca                	sd	s2,64(sp)
 20c:	fc4e                	sd	s3,56(sp)
 20e:	f852                	sd	s4,48(sp)
 210:	f456                	sd	s5,40(sp)
 212:	f05a                	sd	s6,32(sp)
 214:	ec5e                	sd	s7,24(sp)
 216:	e862                	sd	s8,16(sp)
 218:	1080                	addi	s0,sp,96
 21a:	8baa                	mv	s7,a0
 21c:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 21e:	892a                	mv	s2,a0
 220:	4481                	li	s1,0
    cc = read(0, &c, 1);
 222:	faf40b13          	addi	s6,s0,-81
 226:	4a85                	li	s5,1
  for(i=0; i+1 < max; ){
 228:	8c26                	mv	s8,s1
 22a:	0014899b          	addiw	s3,s1,1
 22e:	84ce                	mv	s1,s3
 230:	0349d463          	bge	s3,s4,258 <gets+0x56>
    cc = read(0, &c, 1);
 234:	8656                	mv	a2,s5
 236:	85da                	mv	a1,s6
 238:	4501                	li	a0,0
 23a:	1bc000ef          	jal	3f6 <read>
    if(cc < 1)
 23e:	00a05d63          	blez	a0,258 <gets+0x56>
      break;
    buf[i++] = c;
 242:	faf44783          	lbu	a5,-81(s0)
 246:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 24a:	0905                	addi	s2,s2,1
 24c:	ff678713          	addi	a4,a5,-10
 250:	c319                	beqz	a4,256 <gets+0x54>
 252:	17cd                	addi	a5,a5,-13
 254:	fbf1                	bnez	a5,228 <gets+0x26>
    buf[i++] = c;
 256:	8c4e                	mv	s8,s3
      break;
  }
  buf[i] = '\0';
 258:	9c5e                	add	s8,s8,s7
 25a:	000c0023          	sb	zero,0(s8)
  return buf;
}
 25e:	855e                	mv	a0,s7
 260:	60e6                	ld	ra,88(sp)
 262:	6446                	ld	s0,80(sp)
 264:	64a6                	ld	s1,72(sp)
 266:	6906                	ld	s2,64(sp)
 268:	79e2                	ld	s3,56(sp)
 26a:	7a42                	ld	s4,48(sp)
 26c:	7aa2                	ld	s5,40(sp)
 26e:	7b02                	ld	s6,32(sp)
 270:	6be2                	ld	s7,24(sp)
 272:	6c42                	ld	s8,16(sp)
 274:	6125                	addi	sp,sp,96
 276:	8082                	ret

0000000000000278 <stat>:

int
stat(const char *n, struct stat *st)
{
 278:	1101                	addi	sp,sp,-32
 27a:	ec06                	sd	ra,24(sp)
 27c:	e822                	sd	s0,16(sp)
 27e:	e04a                	sd	s2,0(sp)
 280:	1000                	addi	s0,sp,32
 282:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 284:	4581                	li	a1,0
 286:	198000ef          	jal	41e <open>
  if(fd < 0)
 28a:	02054263          	bltz	a0,2ae <stat+0x36>
 28e:	e426                	sd	s1,8(sp)
 290:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 292:	85ca                	mv	a1,s2
 294:	1a2000ef          	jal	436 <fstat>
 298:	892a                	mv	s2,a0
  close(fd);
 29a:	8526                	mv	a0,s1
 29c:	16a000ef          	jal	406 <close>
  return r;
 2a0:	64a2                	ld	s1,8(sp)
}
 2a2:	854a                	mv	a0,s2
 2a4:	60e2                	ld	ra,24(sp)
 2a6:	6442                	ld	s0,16(sp)
 2a8:	6902                	ld	s2,0(sp)
 2aa:	6105                	addi	sp,sp,32
 2ac:	8082                	ret
    return -1;
 2ae:	57fd                	li	a5,-1
 2b0:	893e                	mv	s2,a5
 2b2:	bfc5                	j	2a2 <stat+0x2a>

00000000000002b4 <atoi>:

int
atoi(const char *s)
{
 2b4:	1141                	addi	sp,sp,-16
 2b6:	e406                	sd	ra,8(sp)
 2b8:	e022                	sd	s0,0(sp)
 2ba:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 2bc:	00054683          	lbu	a3,0(a0)
 2c0:	fd06879b          	addiw	a5,a3,-48 # fd0 <digits+0x4b0>
 2c4:	0ff7f793          	zext.b	a5,a5
 2c8:	4625                	li	a2,9
 2ca:	02f66963          	bltu	a2,a5,2fc <atoi+0x48>
 2ce:	872a                	mv	a4,a0
  n = 0;
 2d0:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
 2d2:	0705                	addi	a4,a4,1
 2d4:	0025179b          	slliw	a5,a0,0x2
 2d8:	9fa9                	addw	a5,a5,a0
 2da:	0017979b          	slliw	a5,a5,0x1
 2de:	9fb5                	addw	a5,a5,a3
 2e0:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 2e4:	00074683          	lbu	a3,0(a4)
 2e8:	fd06879b          	addiw	a5,a3,-48
 2ec:	0ff7f793          	zext.b	a5,a5
 2f0:	fef671e3          	bgeu	a2,a5,2d2 <atoi+0x1e>
  return n;
}
 2f4:	60a2                	ld	ra,8(sp)
 2f6:	6402                	ld	s0,0(sp)
 2f8:	0141                	addi	sp,sp,16
 2fa:	8082                	ret
  n = 0;
 2fc:	4501                	li	a0,0
 2fe:	bfdd                	j	2f4 <atoi+0x40>

0000000000000300 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 300:	1141                	addi	sp,sp,-16
 302:	e406                	sd	ra,8(sp)
 304:	e022                	sd	s0,0(sp)
 306:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 308:	02b57563          	bgeu	a0,a1,332 <memmove+0x32>
    while(n-- > 0)
 30c:	00c05f63          	blez	a2,32a <memmove+0x2a>
 310:	1602                	slli	a2,a2,0x20
 312:	9201                	srli	a2,a2,0x20
 314:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 318:	872a                	mv	a4,a0
      *dst++ = *src++;
 31a:	0585                	addi	a1,a1,1
 31c:	0705                	addi	a4,a4,1
 31e:	fff5c683          	lbu	a3,-1(a1)
 322:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 326:	fee79ae3          	bne	a5,a4,31a <memmove+0x1a>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 32a:	60a2                	ld	ra,8(sp)
 32c:	6402                	ld	s0,0(sp)
 32e:	0141                	addi	sp,sp,16
 330:	8082                	ret
    while(n-- > 0)
 332:	fec05ce3          	blez	a2,32a <memmove+0x2a>
    dst += n;
 336:	00c50733          	add	a4,a0,a2
    src += n;
 33a:	95b2                	add	a1,a1,a2
 33c:	fff6079b          	addiw	a5,a2,-1 # fff <digits+0x4df>
 340:	1782                	slli	a5,a5,0x20
 342:	9381                	srli	a5,a5,0x20
 344:	fff7c793          	not	a5,a5
 348:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 34a:	15fd                	addi	a1,a1,-1
 34c:	177d                	addi	a4,a4,-1
 34e:	0005c683          	lbu	a3,0(a1)
 352:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 356:	fef71ae3          	bne	a4,a5,34a <memmove+0x4a>
 35a:	bfc1                	j	32a <memmove+0x2a>

000000000000035c <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 35c:	1141                	addi	sp,sp,-16
 35e:	e406                	sd	ra,8(sp)
 360:	e022                	sd	s0,0(sp)
 362:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 364:	c61d                	beqz	a2,392 <memcmp+0x36>
 366:	1602                	slli	a2,a2,0x20
 368:	9201                	srli	a2,a2,0x20
 36a:	00c506b3          	add	a3,a0,a2
    if (*p1 != *p2) {
 36e:	00054783          	lbu	a5,0(a0)
 372:	0005c703          	lbu	a4,0(a1)
 376:	00e79863          	bne	a5,a4,386 <memcmp+0x2a>
      return *p1 - *p2;
    }
    p1++;
 37a:	0505                	addi	a0,a0,1
    p2++;
 37c:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 37e:	fed518e3          	bne	a0,a3,36e <memcmp+0x12>
  }
  return 0;
 382:	4501                	li	a0,0
 384:	a019                	j	38a <memcmp+0x2e>
      return *p1 - *p2;
 386:	40e7853b          	subw	a0,a5,a4
}
 38a:	60a2                	ld	ra,8(sp)
 38c:	6402                	ld	s0,0(sp)
 38e:	0141                	addi	sp,sp,16
 390:	8082                	ret
  return 0;
 392:	4501                	li	a0,0
 394:	bfdd                	j	38a <memcmp+0x2e>

0000000000000396 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 396:	1141                	addi	sp,sp,-16
 398:	e406                	sd	ra,8(sp)
 39a:	e022                	sd	s0,0(sp)
 39c:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 39e:	f63ff0ef          	jal	300 <memmove>
}
 3a2:	60a2                	ld	ra,8(sp)
 3a4:	6402                	ld	s0,0(sp)
 3a6:	0141                	addi	sp,sp,16
 3a8:	8082                	ret

00000000000003aa <sbrk>:

char *
sbrk(int n) {
 3aa:	1141                	addi	sp,sp,-16
 3ac:	e406                	sd	ra,8(sp)
 3ae:	e022                	sd	s0,0(sp)
 3b0:	0800                	addi	s0,sp,16
  return sys_sbrk(n, SBRK_EAGER);
 3b2:	4585                	li	a1,1
 3b4:	0b2000ef          	jal	466 <sys_sbrk>
}
 3b8:	60a2                	ld	ra,8(sp)
 3ba:	6402                	ld	s0,0(sp)
 3bc:	0141                	addi	sp,sp,16
 3be:	8082                	ret

00000000000003c0 <sbrklazy>:

char *
sbrklazy(int n) {
 3c0:	1141                	addi	sp,sp,-16
 3c2:	e406                	sd	ra,8(sp)
 3c4:	e022                	sd	s0,0(sp)
 3c6:	0800                	addi	s0,sp,16
  return sys_sbrk(n, SBRK_LAZY);
 3c8:	4589                	li	a1,2
 3ca:	09c000ef          	jal	466 <sys_sbrk>
}
 3ce:	60a2                	ld	ra,8(sp)
 3d0:	6402                	ld	s0,0(sp)
 3d2:	0141                	addi	sp,sp,16
 3d4:	8082                	ret

00000000000003d6 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 3d6:	4885                	li	a7,1
 ecall
 3d8:	00000073          	ecall
 ret
 3dc:	8082                	ret

00000000000003de <exit>:
.global exit
exit:
 li a7, SYS_exit
 3de:	4889                	li	a7,2
 ecall
 3e0:	00000073          	ecall
 ret
 3e4:	8082                	ret

00000000000003e6 <wait>:
.global wait
wait:
 li a7, SYS_wait
 3e6:	488d                	li	a7,3
 ecall
 3e8:	00000073          	ecall
 ret
 3ec:	8082                	ret

00000000000003ee <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 3ee:	4891                	li	a7,4
 ecall
 3f0:	00000073          	ecall
 ret
 3f4:	8082                	ret

00000000000003f6 <read>:
.global read
read:
 li a7, SYS_read
 3f6:	4895                	li	a7,5
 ecall
 3f8:	00000073          	ecall
 ret
 3fc:	8082                	ret

00000000000003fe <write>:
.global write
write:
 li a7, SYS_write
 3fe:	48c1                	li	a7,16
 ecall
 400:	00000073          	ecall
 ret
 404:	8082                	ret

0000000000000406 <close>:
.global close
close:
 li a7, SYS_close
 406:	48d5                	li	a7,21
 ecall
 408:	00000073          	ecall
 ret
 40c:	8082                	ret

000000000000040e <kill>:
.global kill
kill:
 li a7, SYS_kill
 40e:	4899                	li	a7,6
 ecall
 410:	00000073          	ecall
 ret
 414:	8082                	ret

0000000000000416 <exec>:
.global exec
exec:
 li a7, SYS_exec
 416:	489d                	li	a7,7
 ecall
 418:	00000073          	ecall
 ret
 41c:	8082                	ret

000000000000041e <open>:
.global open
open:
 li a7, SYS_open
 41e:	48bd                	li	a7,15
 ecall
 420:	00000073          	ecall
 ret
 424:	8082                	ret

0000000000000426 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 426:	48c5                	li	a7,17
 ecall
 428:	00000073          	ecall
 ret
 42c:	8082                	ret

000000000000042e <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 42e:	48c9                	li	a7,18
 ecall
 430:	00000073          	ecall
 ret
 434:	8082                	ret

0000000000000436 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 436:	48a1                	li	a7,8
 ecall
 438:	00000073          	ecall
 ret
 43c:	8082                	ret

000000000000043e <link>:
.global link
link:
 li a7, SYS_link
 43e:	48cd                	li	a7,19
 ecall
 440:	00000073          	ecall
 ret
 444:	8082                	ret

0000000000000446 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 446:	48d1                	li	a7,20
 ecall
 448:	00000073          	ecall
 ret
 44c:	8082                	ret

000000000000044e <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 44e:	48a5                	li	a7,9
 ecall
 450:	00000073          	ecall
 ret
 454:	8082                	ret

0000000000000456 <dup>:
.global dup
dup:
 li a7, SYS_dup
 456:	48a9                	li	a7,10
 ecall
 458:	00000073          	ecall
 ret
 45c:	8082                	ret

000000000000045e <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 45e:	48ad                	li	a7,11
 ecall
 460:	00000073          	ecall
 ret
 464:	8082                	ret

0000000000000466 <sys_sbrk>:
.global sys_sbrk
sys_sbrk:
 li a7, SYS_sbrk
 466:	48b1                	li	a7,12
 ecall
 468:	00000073          	ecall
 ret
 46c:	8082                	ret

000000000000046e <pause>:
.global pause
pause:
 li a7, SYS_pause
 46e:	48b5                	li	a7,13
 ecall
 470:	00000073          	ecall
 ret
 474:	8082                	ret

0000000000000476 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 476:	48b9                	li	a7,14
 ecall
 478:	00000073          	ecall
 ret
 47c:	8082                	ret

000000000000047e <memstat>:
.global memstat
memstat:
 li a7, SYS_memstat
 47e:	48d9                	li	a7,22
 ecall
 480:	00000073          	ecall
 ret
 484:	8082                	ret

0000000000000486 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 486:	1101                	addi	sp,sp,-32
 488:	ec06                	sd	ra,24(sp)
 48a:	e822                	sd	s0,16(sp)
 48c:	1000                	addi	s0,sp,32
 48e:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 492:	4605                	li	a2,1
 494:	fef40593          	addi	a1,s0,-17
 498:	f67ff0ef          	jal	3fe <write>
}
 49c:	60e2                	ld	ra,24(sp)
 49e:	6442                	ld	s0,16(sp)
 4a0:	6105                	addi	sp,sp,32
 4a2:	8082                	ret

00000000000004a4 <printint>:

static void
printint(int fd, long long xx, int base, int sgn)
{
 4a4:	715d                	addi	sp,sp,-80
 4a6:	e486                	sd	ra,72(sp)
 4a8:	e0a2                	sd	s0,64(sp)
 4aa:	f84a                	sd	s2,48(sp)
 4ac:	f44e                	sd	s3,40(sp)
 4ae:	0880                	addi	s0,sp,80
 4b0:	892a                	mv	s2,a0
  char buf[20];
  int i, neg;
  unsigned long long x;

  neg = 0;
  if(sgn && xx < 0){
 4b2:	c6d1                	beqz	a3,53e <printint+0x9a>
 4b4:	0805d563          	bgez	a1,53e <printint+0x9a>
    neg = 1;
    x = -xx;
 4b8:	40b005b3          	neg	a1,a1
    neg = 1;
 4bc:	4305                	li	t1,1
  } else {
    x = xx;
  }

  i = 0;
 4be:	fb840993          	addi	s3,s0,-72
  neg = 0;
 4c2:	86ce                	mv	a3,s3
  i = 0;
 4c4:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 4c6:	00000817          	auipc	a6,0x0
 4ca:	65a80813          	addi	a6,a6,1626 # b20 <digits>
 4ce:	88ba                	mv	a7,a4
 4d0:	0017051b          	addiw	a0,a4,1
 4d4:	872a                	mv	a4,a0
 4d6:	02c5f7b3          	remu	a5,a1,a2
 4da:	97c2                	add	a5,a5,a6
 4dc:	0007c783          	lbu	a5,0(a5)
 4e0:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 4e4:	87ae                	mv	a5,a1
 4e6:	02c5d5b3          	divu	a1,a1,a2
 4ea:	0685                	addi	a3,a3,1
 4ec:	fec7f1e3          	bgeu	a5,a2,4ce <printint+0x2a>
  if(neg)
 4f0:	00030c63          	beqz	t1,508 <printint+0x64>
    buf[i++] = '-';
 4f4:	fd050793          	addi	a5,a0,-48
 4f8:	00878533          	add	a0,a5,s0
 4fc:	02d00793          	li	a5,45
 500:	fef50423          	sb	a5,-24(a0)
 504:	0028871b          	addiw	a4,a7,2

  while(--i >= 0)
 508:	02e05563          	blez	a4,532 <printint+0x8e>
 50c:	fc26                	sd	s1,56(sp)
 50e:	377d                	addiw	a4,a4,-1
 510:	00e984b3          	add	s1,s3,a4
 514:	19fd                	addi	s3,s3,-1
 516:	99ba                	add	s3,s3,a4
 518:	1702                	slli	a4,a4,0x20
 51a:	9301                	srli	a4,a4,0x20
 51c:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 520:	0004c583          	lbu	a1,0(s1)
 524:	854a                	mv	a0,s2
 526:	f61ff0ef          	jal	486 <putc>
  while(--i >= 0)
 52a:	14fd                	addi	s1,s1,-1
 52c:	ff349ae3          	bne	s1,s3,520 <printint+0x7c>
 530:	74e2                	ld	s1,56(sp)
}
 532:	60a6                	ld	ra,72(sp)
 534:	6406                	ld	s0,64(sp)
 536:	7942                	ld	s2,48(sp)
 538:	79a2                	ld	s3,40(sp)
 53a:	6161                	addi	sp,sp,80
 53c:	8082                	ret
  neg = 0;
 53e:	4301                	li	t1,0
 540:	bfbd                	j	4be <printint+0x1a>

0000000000000542 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %c, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 542:	711d                	addi	sp,sp,-96
 544:	ec86                	sd	ra,88(sp)
 546:	e8a2                	sd	s0,80(sp)
 548:	e4a6                	sd	s1,72(sp)
 54a:	1080                	addi	s0,sp,96
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 54c:	0005c483          	lbu	s1,0(a1)
 550:	22048363          	beqz	s1,776 <vprintf+0x234>
 554:	e0ca                	sd	s2,64(sp)
 556:	fc4e                	sd	s3,56(sp)
 558:	f852                	sd	s4,48(sp)
 55a:	f456                	sd	s5,40(sp)
 55c:	f05a                	sd	s6,32(sp)
 55e:	ec5e                	sd	s7,24(sp)
 560:	e862                	sd	s8,16(sp)
 562:	8b2a                	mv	s6,a0
 564:	8a2e                	mv	s4,a1
 566:	8bb2                	mv	s7,a2
  state = 0;
 568:	4981                	li	s3,0
  for(i = 0; fmt[i]; i++){
 56a:	4901                	li	s2,0
 56c:	4701                	li	a4,0
      if(c0 == '%'){
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if(state == '%'){
 56e:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if(c0) c1 = fmt[i+1] & 0xff;
      if(c1) c2 = fmt[i+2] & 0xff;
      if(c0 == 'd'){
 572:	06400c13          	li	s8,100
 576:	a00d                	j	598 <vprintf+0x56>
        putc(fd, c0);
 578:	85a6                	mv	a1,s1
 57a:	855a                	mv	a0,s6
 57c:	f0bff0ef          	jal	486 <putc>
 580:	a019                	j	586 <vprintf+0x44>
    } else if(state == '%'){
 582:	03598363          	beq	s3,s5,5a8 <vprintf+0x66>
  for(i = 0; fmt[i]; i++){
 586:	0019079b          	addiw	a5,s2,1
 58a:	893e                	mv	s2,a5
 58c:	873e                	mv	a4,a5
 58e:	97d2                	add	a5,a5,s4
 590:	0007c483          	lbu	s1,0(a5)
 594:	1c048a63          	beqz	s1,768 <vprintf+0x226>
    c0 = fmt[i] & 0xff;
 598:	0004879b          	sext.w	a5,s1
    if(state == 0){
 59c:	fe0993e3          	bnez	s3,582 <vprintf+0x40>
      if(c0 == '%'){
 5a0:	fd579ce3          	bne	a5,s5,578 <vprintf+0x36>
        state = '%';
 5a4:	89be                	mv	s3,a5
 5a6:	b7c5                	j	586 <vprintf+0x44>
      if(c0) c1 = fmt[i+1] & 0xff;
 5a8:	00ea06b3          	add	a3,s4,a4
 5ac:	0016c603          	lbu	a2,1(a3)
      if(c1) c2 = fmt[i+2] & 0xff;
 5b0:	1c060863          	beqz	a2,780 <vprintf+0x23e>
      if(c0 == 'd'){
 5b4:	03878763          	beq	a5,s8,5e2 <vprintf+0xa0>
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c0 == 'l' && c1 == 'd'){
 5b8:	f9478693          	addi	a3,a5,-108
 5bc:	0016b693          	seqz	a3,a3
 5c0:	f9c60593          	addi	a1,a2,-100
 5c4:	e99d                	bnez	a1,5fa <vprintf+0xb8>
 5c6:	ca95                	beqz	a3,5fa <vprintf+0xb8>
        printint(fd, va_arg(ap, uint64), 10, 1);
 5c8:	008b8493          	addi	s1,s7,8
 5cc:	4685                	li	a3,1
 5ce:	4629                	li	a2,10
 5d0:	000bb583          	ld	a1,0(s7)
 5d4:	855a                	mv	a0,s6
 5d6:	ecfff0ef          	jal	4a4 <printint>
        i += 1;
 5da:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 10, 1);
 5dc:	8ba6                	mv	s7,s1
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c0);
      }

      state = 0;
 5de:	4981                	li	s3,0
 5e0:	b75d                	j	586 <vprintf+0x44>
        printint(fd, va_arg(ap, int), 10, 1);
 5e2:	008b8493          	addi	s1,s7,8
 5e6:	4685                	li	a3,1
 5e8:	4629                	li	a2,10
 5ea:	000ba583          	lw	a1,0(s7)
 5ee:	855a                	mv	a0,s6
 5f0:	eb5ff0ef          	jal	4a4 <printint>
 5f4:	8ba6                	mv	s7,s1
      state = 0;
 5f6:	4981                	li	s3,0
 5f8:	b779                	j	586 <vprintf+0x44>
      if(c1) c2 = fmt[i+2] & 0xff;
 5fa:	9752                	add	a4,a4,s4
 5fc:	00274583          	lbu	a1,2(a4)
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 600:	f9460713          	addi	a4,a2,-108
 604:	00173713          	seqz	a4,a4
 608:	8f75                	and	a4,a4,a3
 60a:	f9c58513          	addi	a0,a1,-100
 60e:	18051363          	bnez	a0,794 <vprintf+0x252>
 612:	18070163          	beqz	a4,794 <vprintf+0x252>
        printint(fd, va_arg(ap, uint64), 10, 1);
 616:	008b8493          	addi	s1,s7,8
 61a:	4685                	li	a3,1
 61c:	4629                	li	a2,10
 61e:	000bb583          	ld	a1,0(s7)
 622:	855a                	mv	a0,s6
 624:	e81ff0ef          	jal	4a4 <printint>
        i += 2;
 628:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 10, 1);
 62a:	8ba6                	mv	s7,s1
      state = 0;
 62c:	4981                	li	s3,0
        i += 2;
 62e:	bfa1                	j	586 <vprintf+0x44>
        printint(fd, va_arg(ap, uint32), 10, 0);
 630:	008b8493          	addi	s1,s7,8
 634:	4681                	li	a3,0
 636:	4629                	li	a2,10
 638:	000be583          	lwu	a1,0(s7)
 63c:	855a                	mv	a0,s6
 63e:	e67ff0ef          	jal	4a4 <printint>
 642:	8ba6                	mv	s7,s1
      state = 0;
 644:	4981                	li	s3,0
 646:	b781                	j	586 <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 10, 0);
 648:	008b8493          	addi	s1,s7,8
 64c:	4681                	li	a3,0
 64e:	4629                	li	a2,10
 650:	000bb583          	ld	a1,0(s7)
 654:	855a                	mv	a0,s6
 656:	e4fff0ef          	jal	4a4 <printint>
        i += 1;
 65a:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 10, 0);
 65c:	8ba6                	mv	s7,s1
      state = 0;
 65e:	4981                	li	s3,0
 660:	b71d                	j	586 <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 10, 0);
 662:	008b8493          	addi	s1,s7,8
 666:	4681                	li	a3,0
 668:	4629                	li	a2,10
 66a:	000bb583          	ld	a1,0(s7)
 66e:	855a                	mv	a0,s6
 670:	e35ff0ef          	jal	4a4 <printint>
        i += 2;
 674:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 10, 0);
 676:	8ba6                	mv	s7,s1
      state = 0;
 678:	4981                	li	s3,0
        i += 2;
 67a:	b731                	j	586 <vprintf+0x44>
        printint(fd, va_arg(ap, uint32), 16, 0);
 67c:	008b8493          	addi	s1,s7,8
 680:	4681                	li	a3,0
 682:	4641                	li	a2,16
 684:	000be583          	lwu	a1,0(s7)
 688:	855a                	mv	a0,s6
 68a:	e1bff0ef          	jal	4a4 <printint>
 68e:	8ba6                	mv	s7,s1
      state = 0;
 690:	4981                	li	s3,0
 692:	bdd5                	j	586 <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 16, 0);
 694:	008b8493          	addi	s1,s7,8
 698:	4681                	li	a3,0
 69a:	4641                	li	a2,16
 69c:	000bb583          	ld	a1,0(s7)
 6a0:	855a                	mv	a0,s6
 6a2:	e03ff0ef          	jal	4a4 <printint>
        i += 1;
 6a6:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 16, 0);
 6a8:	8ba6                	mv	s7,s1
      state = 0;
 6aa:	4981                	li	s3,0
 6ac:	bde9                	j	586 <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 16, 0);
 6ae:	008b8493          	addi	s1,s7,8
 6b2:	4681                	li	a3,0
 6b4:	4641                	li	a2,16
 6b6:	000bb583          	ld	a1,0(s7)
 6ba:	855a                	mv	a0,s6
 6bc:	de9ff0ef          	jal	4a4 <printint>
        i += 2;
 6c0:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 16, 0);
 6c2:	8ba6                	mv	s7,s1
      state = 0;
 6c4:	4981                	li	s3,0
        i += 2;
 6c6:	b5c1                	j	586 <vprintf+0x44>
 6c8:	e466                	sd	s9,8(sp)
        printptr(fd, va_arg(ap, uint64));
 6ca:	008b8793          	addi	a5,s7,8
 6ce:	8cbe                	mv	s9,a5
 6d0:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 6d4:	03000593          	li	a1,48
 6d8:	855a                	mv	a0,s6
 6da:	dadff0ef          	jal	486 <putc>
  putc(fd, 'x');
 6de:	07800593          	li	a1,120
 6e2:	855a                	mv	a0,s6
 6e4:	da3ff0ef          	jal	486 <putc>
 6e8:	44c1                	li	s1,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 6ea:	00000b97          	auipc	s7,0x0
 6ee:	436b8b93          	addi	s7,s7,1078 # b20 <digits>
 6f2:	03c9d793          	srli	a5,s3,0x3c
 6f6:	97de                	add	a5,a5,s7
 6f8:	0007c583          	lbu	a1,0(a5)
 6fc:	855a                	mv	a0,s6
 6fe:	d89ff0ef          	jal	486 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 702:	0992                	slli	s3,s3,0x4
 704:	34fd                	addiw	s1,s1,-1
 706:	f4f5                	bnez	s1,6f2 <vprintf+0x1b0>
        printptr(fd, va_arg(ap, uint64));
 708:	8be6                	mv	s7,s9
      state = 0;
 70a:	4981                	li	s3,0
 70c:	6ca2                	ld	s9,8(sp)
 70e:	bda5                	j	586 <vprintf+0x44>
        putc(fd, va_arg(ap, uint32));
 710:	008b8493          	addi	s1,s7,8
 714:	000bc583          	lbu	a1,0(s7)
 718:	855a                	mv	a0,s6
 71a:	d6dff0ef          	jal	486 <putc>
 71e:	8ba6                	mv	s7,s1
      state = 0;
 720:	4981                	li	s3,0
 722:	b595                	j	586 <vprintf+0x44>
        if((s = va_arg(ap, char*)) == 0)
 724:	008b8993          	addi	s3,s7,8
 728:	000bb483          	ld	s1,0(s7)
 72c:	cc91                	beqz	s1,748 <vprintf+0x206>
        for(; *s; s++)
 72e:	0004c583          	lbu	a1,0(s1)
 732:	c985                	beqz	a1,762 <vprintf+0x220>
          putc(fd, *s);
 734:	855a                	mv	a0,s6
 736:	d51ff0ef          	jal	486 <putc>
        for(; *s; s++)
 73a:	0485                	addi	s1,s1,1
 73c:	0004c583          	lbu	a1,0(s1)
 740:	f9f5                	bnez	a1,734 <vprintf+0x1f2>
        if((s = va_arg(ap, char*)) == 0)
 742:	8bce                	mv	s7,s3
      state = 0;
 744:	4981                	li	s3,0
 746:	b581                	j	586 <vprintf+0x44>
          s = "(null)";
 748:	00000497          	auipc	s1,0x0
 74c:	3d048493          	addi	s1,s1,976 # b18 <malloc+0x234>
        for(; *s; s++)
 750:	02800593          	li	a1,40
 754:	b7c5                	j	734 <vprintf+0x1f2>
        putc(fd, '%');
 756:	85be                	mv	a1,a5
 758:	855a                	mv	a0,s6
 75a:	d2dff0ef          	jal	486 <putc>
      state = 0;
 75e:	4981                	li	s3,0
 760:	b51d                	j	586 <vprintf+0x44>
        if((s = va_arg(ap, char*)) == 0)
 762:	8bce                	mv	s7,s3
      state = 0;
 764:	4981                	li	s3,0
 766:	b505                	j	586 <vprintf+0x44>
 768:	6906                	ld	s2,64(sp)
 76a:	79e2                	ld	s3,56(sp)
 76c:	7a42                	ld	s4,48(sp)
 76e:	7aa2                	ld	s5,40(sp)
 770:	7b02                	ld	s6,32(sp)
 772:	6be2                	ld	s7,24(sp)
 774:	6c42                	ld	s8,16(sp)
    }
  }
}
 776:	60e6                	ld	ra,88(sp)
 778:	6446                	ld	s0,80(sp)
 77a:	64a6                	ld	s1,72(sp)
 77c:	6125                	addi	sp,sp,96
 77e:	8082                	ret
      if(c0 == 'd'){
 780:	06400713          	li	a4,100
 784:	e4e78fe3          	beq	a5,a4,5e2 <vprintf+0xa0>
      } else if(c0 == 'l' && c1 == 'd'){
 788:	f9478693          	addi	a3,a5,-108
 78c:	0016b693          	seqz	a3,a3
      c1 = c2 = 0;
 790:	85b2                	mv	a1,a2
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 792:	4701                	li	a4,0
      } else if(c0 == 'u'){
 794:	07500513          	li	a0,117
 798:	e8a78ce3          	beq	a5,a0,630 <vprintf+0xee>
      } else if(c0 == 'l' && c1 == 'u'){
 79c:	f8b60513          	addi	a0,a2,-117
 7a0:	e119                	bnez	a0,7a6 <vprintf+0x264>
 7a2:	ea0693e3          	bnez	a3,648 <vprintf+0x106>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
 7a6:	f8b58513          	addi	a0,a1,-117
 7aa:	e119                	bnez	a0,7b0 <vprintf+0x26e>
 7ac:	ea071be3          	bnez	a4,662 <vprintf+0x120>
      } else if(c0 == 'x'){
 7b0:	07800513          	li	a0,120
 7b4:	eca784e3          	beq	a5,a0,67c <vprintf+0x13a>
      } else if(c0 == 'l' && c1 == 'x'){
 7b8:	f8860613          	addi	a2,a2,-120
 7bc:	e219                	bnez	a2,7c2 <vprintf+0x280>
 7be:	ec069be3          	bnez	a3,694 <vprintf+0x152>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
 7c2:	f8858593          	addi	a1,a1,-120
 7c6:	e199                	bnez	a1,7cc <vprintf+0x28a>
 7c8:	ee0713e3          	bnez	a4,6ae <vprintf+0x16c>
      } else if(c0 == 'p'){
 7cc:	07000713          	li	a4,112
 7d0:	eee78ce3          	beq	a5,a4,6c8 <vprintf+0x186>
      } else if(c0 == 'c'){
 7d4:	06300713          	li	a4,99
 7d8:	f2e78ce3          	beq	a5,a4,710 <vprintf+0x1ce>
      } else if(c0 == 's'){
 7dc:	07300713          	li	a4,115
 7e0:	f4e782e3          	beq	a5,a4,724 <vprintf+0x1e2>
      } else if(c0 == '%'){
 7e4:	02500713          	li	a4,37
 7e8:	f6e787e3          	beq	a5,a4,756 <vprintf+0x214>
        putc(fd, '%');
 7ec:	02500593          	li	a1,37
 7f0:	855a                	mv	a0,s6
 7f2:	c95ff0ef          	jal	486 <putc>
        putc(fd, c0);
 7f6:	85a6                	mv	a1,s1
 7f8:	855a                	mv	a0,s6
 7fa:	c8dff0ef          	jal	486 <putc>
      state = 0;
 7fe:	4981                	li	s3,0
 800:	b359                	j	586 <vprintf+0x44>

0000000000000802 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 802:	715d                	addi	sp,sp,-80
 804:	ec06                	sd	ra,24(sp)
 806:	e822                	sd	s0,16(sp)
 808:	1000                	addi	s0,sp,32
 80a:	e010                	sd	a2,0(s0)
 80c:	e414                	sd	a3,8(s0)
 80e:	e818                	sd	a4,16(s0)
 810:	ec1c                	sd	a5,24(s0)
 812:	03043023          	sd	a6,32(s0)
 816:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 81a:	8622                	mv	a2,s0
 81c:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 820:	d23ff0ef          	jal	542 <vprintf>
}
 824:	60e2                	ld	ra,24(sp)
 826:	6442                	ld	s0,16(sp)
 828:	6161                	addi	sp,sp,80
 82a:	8082                	ret

000000000000082c <printf>:

void
printf(const char *fmt, ...)
{
 82c:	711d                	addi	sp,sp,-96
 82e:	ec06                	sd	ra,24(sp)
 830:	e822                	sd	s0,16(sp)
 832:	1000                	addi	s0,sp,32
 834:	e40c                	sd	a1,8(s0)
 836:	e810                	sd	a2,16(s0)
 838:	ec14                	sd	a3,24(s0)
 83a:	f018                	sd	a4,32(s0)
 83c:	f41c                	sd	a5,40(s0)
 83e:	03043823          	sd	a6,48(s0)
 842:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 846:	00840613          	addi	a2,s0,8
 84a:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 84e:	85aa                	mv	a1,a0
 850:	4505                	li	a0,1
 852:	cf1ff0ef          	jal	542 <vprintf>
}
 856:	60e2                	ld	ra,24(sp)
 858:	6442                	ld	s0,16(sp)
 85a:	6125                	addi	sp,sp,96
 85c:	8082                	ret

000000000000085e <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 85e:	1141                	addi	sp,sp,-16
 860:	e406                	sd	ra,8(sp)
 862:	e022                	sd	s0,0(sp)
 864:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 866:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 86a:	00000797          	auipc	a5,0x0
 86e:	7967b783          	ld	a5,1942(a5) # 1000 <freep>
 872:	a039                	j	880 <free+0x22>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 874:	6398                	ld	a4,0(a5)
 876:	00e7e463          	bltu	a5,a4,87e <free+0x20>
 87a:	00e6ea63          	bltu	a3,a4,88e <free+0x30>
{
 87e:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 880:	fed7fae3          	bgeu	a5,a3,874 <free+0x16>
 884:	6398                	ld	a4,0(a5)
 886:	00e6e463          	bltu	a3,a4,88e <free+0x30>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 88a:	fee7eae3          	bltu	a5,a4,87e <free+0x20>
      break;
  if(bp + bp->s.size == p->s.ptr){
 88e:	ff852583          	lw	a1,-8(a0)
 892:	6390                	ld	a2,0(a5)
 894:	02059813          	slli	a6,a1,0x20
 898:	01c85713          	srli	a4,a6,0x1c
 89c:	9736                	add	a4,a4,a3
 89e:	02e60563          	beq	a2,a4,8c8 <free+0x6a>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
 8a2:	fec53823          	sd	a2,-16(a0)
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
 8a6:	4790                	lw	a2,8(a5)
 8a8:	02061593          	slli	a1,a2,0x20
 8ac:	01c5d713          	srli	a4,a1,0x1c
 8b0:	973e                	add	a4,a4,a5
 8b2:	02e68263          	beq	a3,a4,8d6 <free+0x78>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
 8b6:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 8b8:	00000717          	auipc	a4,0x0
 8bc:	74f73423          	sd	a5,1864(a4) # 1000 <freep>
}
 8c0:	60a2                	ld	ra,8(sp)
 8c2:	6402                	ld	s0,0(sp)
 8c4:	0141                	addi	sp,sp,16
 8c6:	8082                	ret
    bp->s.size += p->s.ptr->s.size;
 8c8:	4618                	lw	a4,8(a2)
 8ca:	9f2d                	addw	a4,a4,a1
 8cc:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 8d0:	6398                	ld	a4,0(a5)
 8d2:	6310                	ld	a2,0(a4)
 8d4:	b7f9                	j	8a2 <free+0x44>
    p->s.size += bp->s.size;
 8d6:	ff852703          	lw	a4,-8(a0)
 8da:	9f31                	addw	a4,a4,a2
 8dc:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 8de:	ff053683          	ld	a3,-16(a0)
 8e2:	bfd1                	j	8b6 <free+0x58>

00000000000008e4 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 8e4:	7139                	addi	sp,sp,-64
 8e6:	fc06                	sd	ra,56(sp)
 8e8:	f822                	sd	s0,48(sp)
 8ea:	f04a                	sd	s2,32(sp)
 8ec:	ec4e                	sd	s3,24(sp)
 8ee:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 8f0:	02051993          	slli	s3,a0,0x20
 8f4:	0209d993          	srli	s3,s3,0x20
 8f8:	09bd                	addi	s3,s3,15
 8fa:	0049d993          	srli	s3,s3,0x4
 8fe:	2985                	addiw	s3,s3,1
 900:	894e                	mv	s2,s3
  if((prevp = freep) == 0){
 902:	00000517          	auipc	a0,0x0
 906:	6fe53503          	ld	a0,1790(a0) # 1000 <freep>
 90a:	c905                	beqz	a0,93a <malloc+0x56>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 90c:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 90e:	4798                	lw	a4,8(a5)
 910:	09377663          	bgeu	a4,s3,99c <malloc+0xb8>
 914:	f426                	sd	s1,40(sp)
 916:	e852                	sd	s4,16(sp)
 918:	e456                	sd	s5,8(sp)
 91a:	e05a                	sd	s6,0(sp)
  if(nu < 4096)
 91c:	8a4e                	mv	s4,s3
 91e:	6705                	lui	a4,0x1
 920:	00e9f363          	bgeu	s3,a4,926 <malloc+0x42>
 924:	6a05                	lui	s4,0x1
 926:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 92a:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 92e:	00000497          	auipc	s1,0x0
 932:	6d248493          	addi	s1,s1,1746 # 1000 <freep>
  if(p == SBRK_ERROR)
 936:	5afd                	li	s5,-1
 938:	a83d                	j	976 <malloc+0x92>
 93a:	f426                	sd	s1,40(sp)
 93c:	e852                	sd	s4,16(sp)
 93e:	e456                	sd	s5,8(sp)
 940:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
 942:	00000797          	auipc	a5,0x0
 946:	6ce78793          	addi	a5,a5,1742 # 1010 <base>
 94a:	00000717          	auipc	a4,0x0
 94e:	6af73b23          	sd	a5,1718(a4) # 1000 <freep>
 952:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 954:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 958:	b7d1                	j	91c <malloc+0x38>
        prevp->s.ptr = p->s.ptr;
 95a:	6398                	ld	a4,0(a5)
 95c:	e118                	sd	a4,0(a0)
 95e:	a899                	j	9b4 <malloc+0xd0>
  hp->s.size = nu;
 960:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 964:	0541                	addi	a0,a0,16
 966:	ef9ff0ef          	jal	85e <free>
  return freep;
 96a:	6088                	ld	a0,0(s1)
      if((p = morecore(nunits)) == 0)
 96c:	c125                	beqz	a0,9cc <malloc+0xe8>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 96e:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 970:	4798                	lw	a4,8(a5)
 972:	03277163          	bgeu	a4,s2,994 <malloc+0xb0>
    if(p == freep)
 976:	6098                	ld	a4,0(s1)
 978:	853e                	mv	a0,a5
 97a:	fef71ae3          	bne	a4,a5,96e <malloc+0x8a>
  p = sbrk(nu * sizeof(Header));
 97e:	8552                	mv	a0,s4
 980:	a2bff0ef          	jal	3aa <sbrk>
  if(p == SBRK_ERROR)
 984:	fd551ee3          	bne	a0,s5,960 <malloc+0x7c>
        return 0;
 988:	4501                	li	a0,0
 98a:	74a2                	ld	s1,40(sp)
 98c:	6a42                	ld	s4,16(sp)
 98e:	6aa2                	ld	s5,8(sp)
 990:	6b02                	ld	s6,0(sp)
 992:	a03d                	j	9c0 <malloc+0xdc>
 994:	74a2                	ld	s1,40(sp)
 996:	6a42                	ld	s4,16(sp)
 998:	6aa2                	ld	s5,8(sp)
 99a:	6b02                	ld	s6,0(sp)
      if(p->s.size == nunits)
 99c:	fae90fe3          	beq	s2,a4,95a <malloc+0x76>
        p->s.size -= nunits;
 9a0:	4137073b          	subw	a4,a4,s3
 9a4:	c798                	sw	a4,8(a5)
        p += p->s.size;
 9a6:	02071693          	slli	a3,a4,0x20
 9aa:	01c6d713          	srli	a4,a3,0x1c
 9ae:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 9b0:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 9b4:	00000717          	auipc	a4,0x0
 9b8:	64a73623          	sd	a0,1612(a4) # 1000 <freep>
      return (void*)(p + 1);
 9bc:	01078513          	addi	a0,a5,16
  }
}
 9c0:	70e2                	ld	ra,56(sp)
 9c2:	7442                	ld	s0,48(sp)
 9c4:	7902                	ld	s2,32(sp)
 9c6:	69e2                	ld	s3,24(sp)
 9c8:	6121                	addi	sp,sp,64
 9ca:	8082                	ret
 9cc:	74a2                	ld	s1,40(sp)
 9ce:	6a42                	ld	s4,16(sp)
 9d0:	6aa2                	ld	s5,8(sp)
 9d2:	6b02                	ld	s6,0(sp)
 9d4:	b7f5                	j	9c0 <malloc+0xdc>
