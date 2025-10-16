
user/_evicttest:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <main>:

// A program that allocates more memory than available to test page replacement.
// A program that allocates more memory than available to test page replacement.
int
main(int argc, char *argv[])
{
   0:	715d                	addi	sp,sp,-80
   2:	e486                	sd	ra,72(sp)
   4:	e0a2                	sd	s0,64(sp)
   6:	0880                	addi	s0,sp,80
  printf("evicttest starting\n");
   8:	00001517          	auipc	a0,0x1
   c:	9e850513          	addi	a0,a0,-1560 # 9f0 <malloc+0xfa>
  10:	02f000ef          	jal	83e <printf>

  // Allocate a very large amount of memory to exceed physical memory
  // This will be more than enough to trigger eviction with 128MB RAM.
  int size = 23770 * 4096; 
  char *mem = sbrk(size);
  14:	05cda537          	lui	a0,0x5cda
  18:	3ac000ef          	jal	3c4 <sbrk>
  if (mem == (char*)-1) {
  1c:	57fd                	li	a5,-1
  1e:	02f50e63          	beq	a0,a5,5a <main+0x5a>
  22:	fc26                	sd	s1,56(sp)
  24:	f84a                	sd	s2,48(sp)
  26:	f44e                	sd	s3,40(sp)
  28:	f052                	sd	s4,32(sp)
  2a:	ec56                	sd	s5,24(sp)
  2c:	e85a                	sd	s6,16(sp)
  2e:	e45e                	sd	s7,8(sp)
  30:	e062                	sd	s8,0(sp)
  32:	89aa                	mv	s3,a0
    exit(1);
  }

  // Touch pages in a simple, predictable order
  // This will fill up memory and then trigger evictions
  printf("touching pages...\n");
  34:	00001517          	auipc	a0,0x1
  38:	9e450513          	addi	a0,a0,-1564 # a18 <malloc+0x122>
  3c:	003000ef          	jal	83e <printf>
  40:	4481                	li	s1,0
  for (int i = 0; i < size; i += 4096) {
    // Print a dot for every 1MB touched to show progress
    if (i % (1024 * 1024) == 0) {
  42:	00100a37          	lui	s4,0x100
  46:	1a7d                	addi	s4,s4,-1 # fffff <base+0xfefef>
        write(1, ".", 1);
  48:	4b85                	li	s7,1
  4a:	00001c17          	auipc	s8,0x1
  4e:	9e6c0c13          	addi	s8,s8,-1562 # a30 <malloc+0x13a>
  for (int i = 0; i < size; i += 4096) {
  52:	6b05                	lui	s6,0x1
  54:	05cdaab7          	lui	s5,0x5cda
  58:	a81d                	j	8e <main+0x8e>
  5a:	fc26                	sd	s1,56(sp)
  5c:	f84a                	sd	s2,48(sp)
  5e:	f44e                	sd	s3,40(sp)
  60:	f052                	sd	s4,32(sp)
  62:	ec56                	sd	s5,24(sp)
  64:	e85a                	sd	s6,16(sp)
  66:	e45e                	sd	s7,8(sp)
  68:	e062                	sd	s8,0(sp)
    printf("sbrk failed\n");
  6a:	00001517          	auipc	a0,0x1
  6e:	99e50513          	addi	a0,a0,-1634 # a08 <malloc+0x112>
  72:	7cc000ef          	jal	83e <printf>
    exit(1);
  76:	4505                	li	a0,1
  78:	380000ef          	jal	3f8 <exit>
    }
    mem[i] = (char)(i / 4096);
  7c:	009987b3          	add	a5,s3,s1
  80:	40c9591b          	sraiw	s2,s2,0xc
  84:	01278023          	sb	s2,0(a5)
  for (int i = 0; i < size; i += 4096) {
  88:	94da                	add	s1,s1,s6
  8a:	01548d63          	beq	s1,s5,a4 <main+0xa4>
  8e:	0004891b          	sext.w	s2,s1
    if (i % (1024 * 1024) == 0) {
  92:	014977b3          	and	a5,s2,s4
  96:	f3fd                	bnez	a5,7c <main+0x7c>
        write(1, ".", 1);
  98:	865e                	mv	a2,s7
  9a:	85e2                	mv	a1,s8
  9c:	855e                	mv	a0,s7
  9e:	37a000ef          	jal	418 <write>
  a2:	bfe9                	j	7c <main+0x7c>
  }
  printf("\n"); // Newline after progress dots
  a4:	00001517          	auipc	a0,0x1
  a8:	99450513          	addi	a0,a0,-1644 # a38 <malloc+0x142>
  ac:	792000ef          	jal	83e <printf>

  // Re-touch pages to check if they are correctly loaded after eviction
  printf("re-touching pages to check correctness...\n");
  b0:	00001517          	auipc	a0,0x1
  b4:	99050513          	addi	a0,a0,-1648 # a40 <malloc+0x14a>
  b8:	786000ef          	jal	83e <printf>
  for (int i = 0; i < 20*4096; i += 4096) {
  bc:	4481                	li	s1,0
  be:	6905                	lui	s2,0x1
  c0:	6ad1                	lui	s5,0x14
  c2:	6a05                	lui	s4,0x1
    if (i % (1024 * 1024) == 0) {
        write(1, ".", 1);
  c4:	4b05                	li	s6,1
  c6:	00001b97          	auipc	s7,0x1
  ca:	96ab8b93          	addi	s7,s7,-1686 # a30 <malloc+0x13a>
  ce:	a015                	j	f2 <main+0xf2>
  d0:	865a                	mv	a2,s6
  d2:	85de                	mv	a1,s7
  d4:	855a                	mv	a0,s6
  d6:	342000ef          	jal	418 <write>
    }
    if (mem[i] != (char)(i / 4096)) {
  da:	85ce                	mv	a1,s3
  dc:	0009c703          	lbu	a4,0(s3)
  e0:	02c49693          	slli	a3,s1,0x2c
  e4:	0386d793          	srli	a5,a3,0x38
  e8:	02f71563          	bne	a4,a5,112 <main+0x112>
  for (int i = 0; i < 20*4096; i += 4096) {
  ec:	009904bb          	addw	s1,s2,s1
  f0:	99d2                	add	s3,s3,s4
    if (i % (1024 * 1024) == 0) {
  f2:	dcf9                	beqz	s1,d0 <main+0xd0>
    if (mem[i] != (char)(i / 4096)) {
  f4:	85ce                	mv	a1,s3
  f6:	0009c703          	lbu	a4,0(s3)
  fa:	02c49693          	slli	a3,s1,0x2c
  fe:	0386d793          	srli	a5,a3,0x38
 102:	00f71863          	bne	a4,a5,112 <main+0x112>
  for (int i = 0; i < 20*4096; i += 4096) {
 106:	009904bb          	addw	s1,s2,s1
 10a:	01548d63          	beq	s1,s5,124 <main+0x124>
 10e:	99d2                	add	s3,s3,s4
 110:	b7cd                	j	f2 <main+0xf2>
      printf("error: incorrect data at address %p\n", &mem[i]);
 112:	00001517          	auipc	a0,0x1
 116:	95e50513          	addi	a0,a0,-1698 # a70 <malloc+0x17a>
 11a:	724000ef          	jal	83e <printf>
      exit(1);
 11e:	4505                	li	a0,1
 120:	2d8000ef          	jal	3f8 <exit>
    }
  }
  printf("\n"); // Newline after progress dots
 124:	00001517          	auipc	a0,0x1
 128:	91450513          	addi	a0,a0,-1772 # a38 <malloc+0x142>
 12c:	712000ef          	jal	83e <printf>

  printf("evicttest finished successfully\n");
 130:	00001517          	auipc	a0,0x1
 134:	96850513          	addi	a0,a0,-1688 # a98 <malloc+0x1a2>
 138:	706000ef          	jal	83e <printf>
  exit(0);
 13c:	4501                	li	a0,0
 13e:	2ba000ef          	jal	3f8 <exit>

0000000000000142 <start>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
start(int argc, char **argv)
{
 142:	1141                	addi	sp,sp,-16
 144:	e406                	sd	ra,8(sp)
 146:	e022                	sd	s0,0(sp)
 148:	0800                	addi	s0,sp,16
  int r;
  extern int main(int argc, char **argv);
  r = main(argc, argv);
 14a:	eb7ff0ef          	jal	0 <main>
  exit(r);
 14e:	2aa000ef          	jal	3f8 <exit>

0000000000000152 <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
 152:	1141                	addi	sp,sp,-16
 154:	e406                	sd	ra,8(sp)
 156:	e022                	sd	s0,0(sp)
 158:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 15a:	87aa                	mv	a5,a0
 15c:	0585                	addi	a1,a1,1
 15e:	0785                	addi	a5,a5,1
 160:	fff5c703          	lbu	a4,-1(a1)
 164:	fee78fa3          	sb	a4,-1(a5)
 168:	fb75                	bnez	a4,15c <strcpy+0xa>
    ;
  return os;
}
 16a:	60a2                	ld	ra,8(sp)
 16c:	6402                	ld	s0,0(sp)
 16e:	0141                	addi	sp,sp,16
 170:	8082                	ret

0000000000000172 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 172:	1141                	addi	sp,sp,-16
 174:	e406                	sd	ra,8(sp)
 176:	e022                	sd	s0,0(sp)
 178:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
 17a:	00054783          	lbu	a5,0(a0)
 17e:	cb91                	beqz	a5,192 <strcmp+0x20>
 180:	0005c703          	lbu	a4,0(a1)
 184:	00f71763          	bne	a4,a5,192 <strcmp+0x20>
    p++, q++;
 188:	0505                	addi	a0,a0,1
 18a:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
 18c:	00054783          	lbu	a5,0(a0)
 190:	fbe5                	bnez	a5,180 <strcmp+0xe>
  return (uchar)*p - (uchar)*q;
 192:	0005c503          	lbu	a0,0(a1)
}
 196:	40a7853b          	subw	a0,a5,a0
 19a:	60a2                	ld	ra,8(sp)
 19c:	6402                	ld	s0,0(sp)
 19e:	0141                	addi	sp,sp,16
 1a0:	8082                	ret

00000000000001a2 <strlen>:

uint
strlen(const char *s)
{
 1a2:	1141                	addi	sp,sp,-16
 1a4:	e406                	sd	ra,8(sp)
 1a6:	e022                	sd	s0,0(sp)
 1a8:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 1aa:	00054783          	lbu	a5,0(a0)
 1ae:	cf91                	beqz	a5,1ca <strlen+0x28>
 1b0:	00150793          	addi	a5,a0,1
 1b4:	86be                	mv	a3,a5
 1b6:	0785                	addi	a5,a5,1
 1b8:	fff7c703          	lbu	a4,-1(a5)
 1bc:	ff65                	bnez	a4,1b4 <strlen+0x12>
 1be:	40a6853b          	subw	a0,a3,a0
    ;
  return n;
}
 1c2:	60a2                	ld	ra,8(sp)
 1c4:	6402                	ld	s0,0(sp)
 1c6:	0141                	addi	sp,sp,16
 1c8:	8082                	ret
  for(n = 0; s[n]; n++)
 1ca:	4501                	li	a0,0
 1cc:	bfdd                	j	1c2 <strlen+0x20>

00000000000001ce <memset>:

void*
memset(void *dst, int c, uint n)
{
 1ce:	1141                	addi	sp,sp,-16
 1d0:	e406                	sd	ra,8(sp)
 1d2:	e022                	sd	s0,0(sp)
 1d4:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 1d6:	ca19                	beqz	a2,1ec <memset+0x1e>
 1d8:	87aa                	mv	a5,a0
 1da:	1602                	slli	a2,a2,0x20
 1dc:	9201                	srli	a2,a2,0x20
 1de:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 1e2:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 1e6:	0785                	addi	a5,a5,1
 1e8:	fee79de3          	bne	a5,a4,1e2 <memset+0x14>
  }
  return dst;
}
 1ec:	60a2                	ld	ra,8(sp)
 1ee:	6402                	ld	s0,0(sp)
 1f0:	0141                	addi	sp,sp,16
 1f2:	8082                	ret

00000000000001f4 <strchr>:

char*
strchr(const char *s, char c)
{
 1f4:	1141                	addi	sp,sp,-16
 1f6:	e406                	sd	ra,8(sp)
 1f8:	e022                	sd	s0,0(sp)
 1fa:	0800                	addi	s0,sp,16
  for(; *s; s++)
 1fc:	00054783          	lbu	a5,0(a0)
 200:	cf81                	beqz	a5,218 <strchr+0x24>
    if(*s == c)
 202:	00f58763          	beq	a1,a5,210 <strchr+0x1c>
  for(; *s; s++)
 206:	0505                	addi	a0,a0,1
 208:	00054783          	lbu	a5,0(a0)
 20c:	fbfd                	bnez	a5,202 <strchr+0xe>
      return (char*)s;
  return 0;
 20e:	4501                	li	a0,0
}
 210:	60a2                	ld	ra,8(sp)
 212:	6402                	ld	s0,0(sp)
 214:	0141                	addi	sp,sp,16
 216:	8082                	ret
  return 0;
 218:	4501                	li	a0,0
 21a:	bfdd                	j	210 <strchr+0x1c>

000000000000021c <gets>:

char*
gets(char *buf, int max)
{
 21c:	711d                	addi	sp,sp,-96
 21e:	ec86                	sd	ra,88(sp)
 220:	e8a2                	sd	s0,80(sp)
 222:	e4a6                	sd	s1,72(sp)
 224:	e0ca                	sd	s2,64(sp)
 226:	fc4e                	sd	s3,56(sp)
 228:	f852                	sd	s4,48(sp)
 22a:	f456                	sd	s5,40(sp)
 22c:	f05a                	sd	s6,32(sp)
 22e:	ec5e                	sd	s7,24(sp)
 230:	e862                	sd	s8,16(sp)
 232:	1080                	addi	s0,sp,96
 234:	8baa                	mv	s7,a0
 236:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 238:	892a                	mv	s2,a0
 23a:	4481                	li	s1,0
    cc = read(0, &c, 1);
 23c:	faf40b13          	addi	s6,s0,-81
 240:	4a85                	li	s5,1
  for(i=0; i+1 < max; ){
 242:	8c26                	mv	s8,s1
 244:	0014899b          	addiw	s3,s1,1
 248:	84ce                	mv	s1,s3
 24a:	0349d463          	bge	s3,s4,272 <gets+0x56>
    cc = read(0, &c, 1);
 24e:	8656                	mv	a2,s5
 250:	85da                	mv	a1,s6
 252:	4501                	li	a0,0
 254:	1bc000ef          	jal	410 <read>
    if(cc < 1)
 258:	00a05d63          	blez	a0,272 <gets+0x56>
      break;
    buf[i++] = c;
 25c:	faf44783          	lbu	a5,-81(s0)
 260:	00f90023          	sb	a5,0(s2) # 1000 <freep>
    if(c == '\n' || c == '\r')
 264:	0905                	addi	s2,s2,1
 266:	ff678713          	addi	a4,a5,-10
 26a:	c319                	beqz	a4,270 <gets+0x54>
 26c:	17cd                	addi	a5,a5,-13
 26e:	fbf1                	bnez	a5,242 <gets+0x26>
    buf[i++] = c;
 270:	8c4e                	mv	s8,s3
      break;
  }
  buf[i] = '\0';
 272:	9c5e                	add	s8,s8,s7
 274:	000c0023          	sb	zero,0(s8)
  return buf;
}
 278:	855e                	mv	a0,s7
 27a:	60e6                	ld	ra,88(sp)
 27c:	6446                	ld	s0,80(sp)
 27e:	64a6                	ld	s1,72(sp)
 280:	6906                	ld	s2,64(sp)
 282:	79e2                	ld	s3,56(sp)
 284:	7a42                	ld	s4,48(sp)
 286:	7aa2                	ld	s5,40(sp)
 288:	7b02                	ld	s6,32(sp)
 28a:	6be2                	ld	s7,24(sp)
 28c:	6c42                	ld	s8,16(sp)
 28e:	6125                	addi	sp,sp,96
 290:	8082                	ret

0000000000000292 <stat>:

int
stat(const char *n, struct stat *st)
{
 292:	1101                	addi	sp,sp,-32
 294:	ec06                	sd	ra,24(sp)
 296:	e822                	sd	s0,16(sp)
 298:	e04a                	sd	s2,0(sp)
 29a:	1000                	addi	s0,sp,32
 29c:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 29e:	4581                	li	a1,0
 2a0:	198000ef          	jal	438 <open>
  if(fd < 0)
 2a4:	02054263          	bltz	a0,2c8 <stat+0x36>
 2a8:	e426                	sd	s1,8(sp)
 2aa:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 2ac:	85ca                	mv	a1,s2
 2ae:	1a2000ef          	jal	450 <fstat>
 2b2:	892a                	mv	s2,a0
  close(fd);
 2b4:	8526                	mv	a0,s1
 2b6:	16a000ef          	jal	420 <close>
  return r;
 2ba:	64a2                	ld	s1,8(sp)
}
 2bc:	854a                	mv	a0,s2
 2be:	60e2                	ld	ra,24(sp)
 2c0:	6442                	ld	s0,16(sp)
 2c2:	6902                	ld	s2,0(sp)
 2c4:	6105                	addi	sp,sp,32
 2c6:	8082                	ret
    return -1;
 2c8:	57fd                	li	a5,-1
 2ca:	893e                	mv	s2,a5
 2cc:	bfc5                	j	2bc <stat+0x2a>

00000000000002ce <atoi>:

int
atoi(const char *s)
{
 2ce:	1141                	addi	sp,sp,-16
 2d0:	e406                	sd	ra,8(sp)
 2d2:	e022                	sd	s0,0(sp)
 2d4:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 2d6:	00054683          	lbu	a3,0(a0)
 2da:	fd06879b          	addiw	a5,a3,-48
 2de:	0ff7f793          	zext.b	a5,a5
 2e2:	4625                	li	a2,9
 2e4:	02f66963          	bltu	a2,a5,316 <atoi+0x48>
 2e8:	872a                	mv	a4,a0
  n = 0;
 2ea:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
 2ec:	0705                	addi	a4,a4,1
 2ee:	0025179b          	slliw	a5,a0,0x2
 2f2:	9fa9                	addw	a5,a5,a0
 2f4:	0017979b          	slliw	a5,a5,0x1
 2f8:	9fb5                	addw	a5,a5,a3
 2fa:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 2fe:	00074683          	lbu	a3,0(a4)
 302:	fd06879b          	addiw	a5,a3,-48
 306:	0ff7f793          	zext.b	a5,a5
 30a:	fef671e3          	bgeu	a2,a5,2ec <atoi+0x1e>
  return n;
}
 30e:	60a2                	ld	ra,8(sp)
 310:	6402                	ld	s0,0(sp)
 312:	0141                	addi	sp,sp,16
 314:	8082                	ret
  n = 0;
 316:	4501                	li	a0,0
 318:	bfdd                	j	30e <atoi+0x40>

000000000000031a <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 31a:	1141                	addi	sp,sp,-16
 31c:	e406                	sd	ra,8(sp)
 31e:	e022                	sd	s0,0(sp)
 320:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 322:	02b57563          	bgeu	a0,a1,34c <memmove+0x32>
    while(n-- > 0)
 326:	00c05f63          	blez	a2,344 <memmove+0x2a>
 32a:	1602                	slli	a2,a2,0x20
 32c:	9201                	srli	a2,a2,0x20
 32e:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 332:	872a                	mv	a4,a0
      *dst++ = *src++;
 334:	0585                	addi	a1,a1,1
 336:	0705                	addi	a4,a4,1
 338:	fff5c683          	lbu	a3,-1(a1)
 33c:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 340:	fee79ae3          	bne	a5,a4,334 <memmove+0x1a>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 344:	60a2                	ld	ra,8(sp)
 346:	6402                	ld	s0,0(sp)
 348:	0141                	addi	sp,sp,16
 34a:	8082                	ret
    while(n-- > 0)
 34c:	fec05ce3          	blez	a2,344 <memmove+0x2a>
    dst += n;
 350:	00c50733          	add	a4,a0,a2
    src += n;
 354:	95b2                	add	a1,a1,a2
 356:	fff6079b          	addiw	a5,a2,-1
 35a:	1782                	slli	a5,a5,0x20
 35c:	9381                	srli	a5,a5,0x20
 35e:	fff7c793          	not	a5,a5
 362:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 364:	15fd                	addi	a1,a1,-1
 366:	177d                	addi	a4,a4,-1
 368:	0005c683          	lbu	a3,0(a1)
 36c:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 370:	fef71ae3          	bne	a4,a5,364 <memmove+0x4a>
 374:	bfc1                	j	344 <memmove+0x2a>

0000000000000376 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 376:	1141                	addi	sp,sp,-16
 378:	e406                	sd	ra,8(sp)
 37a:	e022                	sd	s0,0(sp)
 37c:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 37e:	c61d                	beqz	a2,3ac <memcmp+0x36>
 380:	1602                	slli	a2,a2,0x20
 382:	9201                	srli	a2,a2,0x20
 384:	00c506b3          	add	a3,a0,a2
    if (*p1 != *p2) {
 388:	00054783          	lbu	a5,0(a0)
 38c:	0005c703          	lbu	a4,0(a1)
 390:	00e79863          	bne	a5,a4,3a0 <memcmp+0x2a>
      return *p1 - *p2;
    }
    p1++;
 394:	0505                	addi	a0,a0,1
    p2++;
 396:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 398:	fed518e3          	bne	a0,a3,388 <memcmp+0x12>
  }
  return 0;
 39c:	4501                	li	a0,0
 39e:	a019                	j	3a4 <memcmp+0x2e>
      return *p1 - *p2;
 3a0:	40e7853b          	subw	a0,a5,a4
}
 3a4:	60a2                	ld	ra,8(sp)
 3a6:	6402                	ld	s0,0(sp)
 3a8:	0141                	addi	sp,sp,16
 3aa:	8082                	ret
  return 0;
 3ac:	4501                	li	a0,0
 3ae:	bfdd                	j	3a4 <memcmp+0x2e>

00000000000003b0 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 3b0:	1141                	addi	sp,sp,-16
 3b2:	e406                	sd	ra,8(sp)
 3b4:	e022                	sd	s0,0(sp)
 3b6:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 3b8:	f63ff0ef          	jal	31a <memmove>
}
 3bc:	60a2                	ld	ra,8(sp)
 3be:	6402                	ld	s0,0(sp)
 3c0:	0141                	addi	sp,sp,16
 3c2:	8082                	ret

00000000000003c4 <sbrk>:

char *
sbrk(int n) {
 3c4:	1141                	addi	sp,sp,-16
 3c6:	e406                	sd	ra,8(sp)
 3c8:	e022                	sd	s0,0(sp)
 3ca:	0800                	addi	s0,sp,16
  return sys_sbrk(n, SBRK_EAGER);
 3cc:	4585                	li	a1,1
 3ce:	0b2000ef          	jal	480 <sys_sbrk>
}
 3d2:	60a2                	ld	ra,8(sp)
 3d4:	6402                	ld	s0,0(sp)
 3d6:	0141                	addi	sp,sp,16
 3d8:	8082                	ret

00000000000003da <sbrklazy>:

char *
sbrklazy(int n) {
 3da:	1141                	addi	sp,sp,-16
 3dc:	e406                	sd	ra,8(sp)
 3de:	e022                	sd	s0,0(sp)
 3e0:	0800                	addi	s0,sp,16
  return sys_sbrk(n, SBRK_LAZY);
 3e2:	4589                	li	a1,2
 3e4:	09c000ef          	jal	480 <sys_sbrk>
}
 3e8:	60a2                	ld	ra,8(sp)
 3ea:	6402                	ld	s0,0(sp)
 3ec:	0141                	addi	sp,sp,16
 3ee:	8082                	ret

00000000000003f0 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 3f0:	4885                	li	a7,1
 ecall
 3f2:	00000073          	ecall
 ret
 3f6:	8082                	ret

00000000000003f8 <exit>:
.global exit
exit:
 li a7, SYS_exit
 3f8:	4889                	li	a7,2
 ecall
 3fa:	00000073          	ecall
 ret
 3fe:	8082                	ret

0000000000000400 <wait>:
.global wait
wait:
 li a7, SYS_wait
 400:	488d                	li	a7,3
 ecall
 402:	00000073          	ecall
 ret
 406:	8082                	ret

0000000000000408 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 408:	4891                	li	a7,4
 ecall
 40a:	00000073          	ecall
 ret
 40e:	8082                	ret

0000000000000410 <read>:
.global read
read:
 li a7, SYS_read
 410:	4895                	li	a7,5
 ecall
 412:	00000073          	ecall
 ret
 416:	8082                	ret

0000000000000418 <write>:
.global write
write:
 li a7, SYS_write
 418:	48c1                	li	a7,16
 ecall
 41a:	00000073          	ecall
 ret
 41e:	8082                	ret

0000000000000420 <close>:
.global close
close:
 li a7, SYS_close
 420:	48d5                	li	a7,21
 ecall
 422:	00000073          	ecall
 ret
 426:	8082                	ret

0000000000000428 <kill>:
.global kill
kill:
 li a7, SYS_kill
 428:	4899                	li	a7,6
 ecall
 42a:	00000073          	ecall
 ret
 42e:	8082                	ret

0000000000000430 <exec>:
.global exec
exec:
 li a7, SYS_exec
 430:	489d                	li	a7,7
 ecall
 432:	00000073          	ecall
 ret
 436:	8082                	ret

0000000000000438 <open>:
.global open
open:
 li a7, SYS_open
 438:	48bd                	li	a7,15
 ecall
 43a:	00000073          	ecall
 ret
 43e:	8082                	ret

0000000000000440 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 440:	48c5                	li	a7,17
 ecall
 442:	00000073          	ecall
 ret
 446:	8082                	ret

0000000000000448 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 448:	48c9                	li	a7,18
 ecall
 44a:	00000073          	ecall
 ret
 44e:	8082                	ret

0000000000000450 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 450:	48a1                	li	a7,8
 ecall
 452:	00000073          	ecall
 ret
 456:	8082                	ret

0000000000000458 <link>:
.global link
link:
 li a7, SYS_link
 458:	48cd                	li	a7,19
 ecall
 45a:	00000073          	ecall
 ret
 45e:	8082                	ret

0000000000000460 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 460:	48d1                	li	a7,20
 ecall
 462:	00000073          	ecall
 ret
 466:	8082                	ret

0000000000000468 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 468:	48a5                	li	a7,9
 ecall
 46a:	00000073          	ecall
 ret
 46e:	8082                	ret

0000000000000470 <dup>:
.global dup
dup:
 li a7, SYS_dup
 470:	48a9                	li	a7,10
 ecall
 472:	00000073          	ecall
 ret
 476:	8082                	ret

0000000000000478 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 478:	48ad                	li	a7,11
 ecall
 47a:	00000073          	ecall
 ret
 47e:	8082                	ret

0000000000000480 <sys_sbrk>:
.global sys_sbrk
sys_sbrk:
 li a7, SYS_sbrk
 480:	48b1                	li	a7,12
 ecall
 482:	00000073          	ecall
 ret
 486:	8082                	ret

0000000000000488 <pause>:
.global pause
pause:
 li a7, SYS_pause
 488:	48b5                	li	a7,13
 ecall
 48a:	00000073          	ecall
 ret
 48e:	8082                	ret

0000000000000490 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 490:	48b9                	li	a7,14
 ecall
 492:	00000073          	ecall
 ret
 496:	8082                	ret

0000000000000498 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 498:	1101                	addi	sp,sp,-32
 49a:	ec06                	sd	ra,24(sp)
 49c:	e822                	sd	s0,16(sp)
 49e:	1000                	addi	s0,sp,32
 4a0:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 4a4:	4605                	li	a2,1
 4a6:	fef40593          	addi	a1,s0,-17
 4aa:	f6fff0ef          	jal	418 <write>
}
 4ae:	60e2                	ld	ra,24(sp)
 4b0:	6442                	ld	s0,16(sp)
 4b2:	6105                	addi	sp,sp,32
 4b4:	8082                	ret

00000000000004b6 <printint>:

static void
printint(int fd, long long xx, int base, int sgn)
{
 4b6:	715d                	addi	sp,sp,-80
 4b8:	e486                	sd	ra,72(sp)
 4ba:	e0a2                	sd	s0,64(sp)
 4bc:	f84a                	sd	s2,48(sp)
 4be:	f44e                	sd	s3,40(sp)
 4c0:	0880                	addi	s0,sp,80
 4c2:	892a                	mv	s2,a0
  char buf[20];
  int i, neg;
  unsigned long long x;

  neg = 0;
  if(sgn && xx < 0){
 4c4:	c6d1                	beqz	a3,550 <printint+0x9a>
 4c6:	0805d563          	bgez	a1,550 <printint+0x9a>
    neg = 1;
    x = -xx;
 4ca:	40b005b3          	neg	a1,a1
    neg = 1;
 4ce:	4305                	li	t1,1
  } else {
    x = xx;
  }

  i = 0;
 4d0:	fb840993          	addi	s3,s0,-72
  neg = 0;
 4d4:	86ce                	mv	a3,s3
  i = 0;
 4d6:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 4d8:	00000817          	auipc	a6,0x0
 4dc:	5f080813          	addi	a6,a6,1520 # ac8 <digits>
 4e0:	88ba                	mv	a7,a4
 4e2:	0017051b          	addiw	a0,a4,1
 4e6:	872a                	mv	a4,a0
 4e8:	02c5f7b3          	remu	a5,a1,a2
 4ec:	97c2                	add	a5,a5,a6
 4ee:	0007c783          	lbu	a5,0(a5)
 4f2:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 4f6:	87ae                	mv	a5,a1
 4f8:	02c5d5b3          	divu	a1,a1,a2
 4fc:	0685                	addi	a3,a3,1
 4fe:	fec7f1e3          	bgeu	a5,a2,4e0 <printint+0x2a>
  if(neg)
 502:	00030c63          	beqz	t1,51a <printint+0x64>
    buf[i++] = '-';
 506:	fd050793          	addi	a5,a0,-48
 50a:	00878533          	add	a0,a5,s0
 50e:	02d00793          	li	a5,45
 512:	fef50423          	sb	a5,-24(a0)
 516:	0028871b          	addiw	a4,a7,2

  while(--i >= 0)
 51a:	02e05563          	blez	a4,544 <printint+0x8e>
 51e:	fc26                	sd	s1,56(sp)
 520:	377d                	addiw	a4,a4,-1
 522:	00e984b3          	add	s1,s3,a4
 526:	19fd                	addi	s3,s3,-1
 528:	99ba                	add	s3,s3,a4
 52a:	1702                	slli	a4,a4,0x20
 52c:	9301                	srli	a4,a4,0x20
 52e:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 532:	0004c583          	lbu	a1,0(s1)
 536:	854a                	mv	a0,s2
 538:	f61ff0ef          	jal	498 <putc>
  while(--i >= 0)
 53c:	14fd                	addi	s1,s1,-1
 53e:	ff349ae3          	bne	s1,s3,532 <printint+0x7c>
 542:	74e2                	ld	s1,56(sp)
}
 544:	60a6                	ld	ra,72(sp)
 546:	6406                	ld	s0,64(sp)
 548:	7942                	ld	s2,48(sp)
 54a:	79a2                	ld	s3,40(sp)
 54c:	6161                	addi	sp,sp,80
 54e:	8082                	ret
  neg = 0;
 550:	4301                	li	t1,0
 552:	bfbd                	j	4d0 <printint+0x1a>

0000000000000554 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %c, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 554:	711d                	addi	sp,sp,-96
 556:	ec86                	sd	ra,88(sp)
 558:	e8a2                	sd	s0,80(sp)
 55a:	e4a6                	sd	s1,72(sp)
 55c:	1080                	addi	s0,sp,96
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 55e:	0005c483          	lbu	s1,0(a1)
 562:	22048363          	beqz	s1,788 <vprintf+0x234>
 566:	e0ca                	sd	s2,64(sp)
 568:	fc4e                	sd	s3,56(sp)
 56a:	f852                	sd	s4,48(sp)
 56c:	f456                	sd	s5,40(sp)
 56e:	f05a                	sd	s6,32(sp)
 570:	ec5e                	sd	s7,24(sp)
 572:	e862                	sd	s8,16(sp)
 574:	8b2a                	mv	s6,a0
 576:	8a2e                	mv	s4,a1
 578:	8bb2                	mv	s7,a2
  state = 0;
 57a:	4981                	li	s3,0
  for(i = 0; fmt[i]; i++){
 57c:	4901                	li	s2,0
 57e:	4701                	li	a4,0
      if(c0 == '%'){
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if(state == '%'){
 580:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if(c0) c1 = fmt[i+1] & 0xff;
      if(c1) c2 = fmt[i+2] & 0xff;
      if(c0 == 'd'){
 584:	06400c13          	li	s8,100
 588:	a00d                	j	5aa <vprintf+0x56>
        putc(fd, c0);
 58a:	85a6                	mv	a1,s1
 58c:	855a                	mv	a0,s6
 58e:	f0bff0ef          	jal	498 <putc>
 592:	a019                	j	598 <vprintf+0x44>
    } else if(state == '%'){
 594:	03598363          	beq	s3,s5,5ba <vprintf+0x66>
  for(i = 0; fmt[i]; i++){
 598:	0019079b          	addiw	a5,s2,1
 59c:	893e                	mv	s2,a5
 59e:	873e                	mv	a4,a5
 5a0:	97d2                	add	a5,a5,s4
 5a2:	0007c483          	lbu	s1,0(a5)
 5a6:	1c048a63          	beqz	s1,77a <vprintf+0x226>
    c0 = fmt[i] & 0xff;
 5aa:	0004879b          	sext.w	a5,s1
    if(state == 0){
 5ae:	fe0993e3          	bnez	s3,594 <vprintf+0x40>
      if(c0 == '%'){
 5b2:	fd579ce3          	bne	a5,s5,58a <vprintf+0x36>
        state = '%';
 5b6:	89be                	mv	s3,a5
 5b8:	b7c5                	j	598 <vprintf+0x44>
      if(c0) c1 = fmt[i+1] & 0xff;
 5ba:	00ea06b3          	add	a3,s4,a4
 5be:	0016c603          	lbu	a2,1(a3)
      if(c1) c2 = fmt[i+2] & 0xff;
 5c2:	1c060863          	beqz	a2,792 <vprintf+0x23e>
      if(c0 == 'd'){
 5c6:	03878763          	beq	a5,s8,5f4 <vprintf+0xa0>
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c0 == 'l' && c1 == 'd'){
 5ca:	f9478693          	addi	a3,a5,-108
 5ce:	0016b693          	seqz	a3,a3
 5d2:	f9c60593          	addi	a1,a2,-100
 5d6:	e99d                	bnez	a1,60c <vprintf+0xb8>
 5d8:	ca95                	beqz	a3,60c <vprintf+0xb8>
        printint(fd, va_arg(ap, uint64), 10, 1);
 5da:	008b8493          	addi	s1,s7,8
 5de:	4685                	li	a3,1
 5e0:	4629                	li	a2,10
 5e2:	000bb583          	ld	a1,0(s7)
 5e6:	855a                	mv	a0,s6
 5e8:	ecfff0ef          	jal	4b6 <printint>
        i += 1;
 5ec:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 10, 1);
 5ee:	8ba6                	mv	s7,s1
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c0);
      }

      state = 0;
 5f0:	4981                	li	s3,0
 5f2:	b75d                	j	598 <vprintf+0x44>
        printint(fd, va_arg(ap, int), 10, 1);
 5f4:	008b8493          	addi	s1,s7,8
 5f8:	4685                	li	a3,1
 5fa:	4629                	li	a2,10
 5fc:	000ba583          	lw	a1,0(s7)
 600:	855a                	mv	a0,s6
 602:	eb5ff0ef          	jal	4b6 <printint>
 606:	8ba6                	mv	s7,s1
      state = 0;
 608:	4981                	li	s3,0
 60a:	b779                	j	598 <vprintf+0x44>
      if(c1) c2 = fmt[i+2] & 0xff;
 60c:	9752                	add	a4,a4,s4
 60e:	00274583          	lbu	a1,2(a4)
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 612:	f9460713          	addi	a4,a2,-108
 616:	00173713          	seqz	a4,a4
 61a:	8f75                	and	a4,a4,a3
 61c:	f9c58513          	addi	a0,a1,-100
 620:	18051363          	bnez	a0,7a6 <vprintf+0x252>
 624:	18070163          	beqz	a4,7a6 <vprintf+0x252>
        printint(fd, va_arg(ap, uint64), 10, 1);
 628:	008b8493          	addi	s1,s7,8
 62c:	4685                	li	a3,1
 62e:	4629                	li	a2,10
 630:	000bb583          	ld	a1,0(s7)
 634:	855a                	mv	a0,s6
 636:	e81ff0ef          	jal	4b6 <printint>
        i += 2;
 63a:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 10, 1);
 63c:	8ba6                	mv	s7,s1
      state = 0;
 63e:	4981                	li	s3,0
        i += 2;
 640:	bfa1                	j	598 <vprintf+0x44>
        printint(fd, va_arg(ap, uint32), 10, 0);
 642:	008b8493          	addi	s1,s7,8
 646:	4681                	li	a3,0
 648:	4629                	li	a2,10
 64a:	000be583          	lwu	a1,0(s7)
 64e:	855a                	mv	a0,s6
 650:	e67ff0ef          	jal	4b6 <printint>
 654:	8ba6                	mv	s7,s1
      state = 0;
 656:	4981                	li	s3,0
 658:	b781                	j	598 <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 10, 0);
 65a:	008b8493          	addi	s1,s7,8
 65e:	4681                	li	a3,0
 660:	4629                	li	a2,10
 662:	000bb583          	ld	a1,0(s7)
 666:	855a                	mv	a0,s6
 668:	e4fff0ef          	jal	4b6 <printint>
        i += 1;
 66c:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 10, 0);
 66e:	8ba6                	mv	s7,s1
      state = 0;
 670:	4981                	li	s3,0
 672:	b71d                	j	598 <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 10, 0);
 674:	008b8493          	addi	s1,s7,8
 678:	4681                	li	a3,0
 67a:	4629                	li	a2,10
 67c:	000bb583          	ld	a1,0(s7)
 680:	855a                	mv	a0,s6
 682:	e35ff0ef          	jal	4b6 <printint>
        i += 2;
 686:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 10, 0);
 688:	8ba6                	mv	s7,s1
      state = 0;
 68a:	4981                	li	s3,0
        i += 2;
 68c:	b731                	j	598 <vprintf+0x44>
        printint(fd, va_arg(ap, uint32), 16, 0);
 68e:	008b8493          	addi	s1,s7,8
 692:	4681                	li	a3,0
 694:	4641                	li	a2,16
 696:	000be583          	lwu	a1,0(s7)
 69a:	855a                	mv	a0,s6
 69c:	e1bff0ef          	jal	4b6 <printint>
 6a0:	8ba6                	mv	s7,s1
      state = 0;
 6a2:	4981                	li	s3,0
 6a4:	bdd5                	j	598 <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 16, 0);
 6a6:	008b8493          	addi	s1,s7,8
 6aa:	4681                	li	a3,0
 6ac:	4641                	li	a2,16
 6ae:	000bb583          	ld	a1,0(s7)
 6b2:	855a                	mv	a0,s6
 6b4:	e03ff0ef          	jal	4b6 <printint>
        i += 1;
 6b8:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 16, 0);
 6ba:	8ba6                	mv	s7,s1
      state = 0;
 6bc:	4981                	li	s3,0
 6be:	bde9                	j	598 <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 16, 0);
 6c0:	008b8493          	addi	s1,s7,8
 6c4:	4681                	li	a3,0
 6c6:	4641                	li	a2,16
 6c8:	000bb583          	ld	a1,0(s7)
 6cc:	855a                	mv	a0,s6
 6ce:	de9ff0ef          	jal	4b6 <printint>
        i += 2;
 6d2:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 16, 0);
 6d4:	8ba6                	mv	s7,s1
      state = 0;
 6d6:	4981                	li	s3,0
        i += 2;
 6d8:	b5c1                	j	598 <vprintf+0x44>
 6da:	e466                	sd	s9,8(sp)
        printptr(fd, va_arg(ap, uint64));
 6dc:	008b8793          	addi	a5,s7,8
 6e0:	8cbe                	mv	s9,a5
 6e2:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 6e6:	03000593          	li	a1,48
 6ea:	855a                	mv	a0,s6
 6ec:	dadff0ef          	jal	498 <putc>
  putc(fd, 'x');
 6f0:	07800593          	li	a1,120
 6f4:	855a                	mv	a0,s6
 6f6:	da3ff0ef          	jal	498 <putc>
 6fa:	44c1                	li	s1,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 6fc:	00000b97          	auipc	s7,0x0
 700:	3ccb8b93          	addi	s7,s7,972 # ac8 <digits>
 704:	03c9d793          	srli	a5,s3,0x3c
 708:	97de                	add	a5,a5,s7
 70a:	0007c583          	lbu	a1,0(a5)
 70e:	855a                	mv	a0,s6
 710:	d89ff0ef          	jal	498 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 714:	0992                	slli	s3,s3,0x4
 716:	34fd                	addiw	s1,s1,-1
 718:	f4f5                	bnez	s1,704 <vprintf+0x1b0>
        printptr(fd, va_arg(ap, uint64));
 71a:	8be6                	mv	s7,s9
      state = 0;
 71c:	4981                	li	s3,0
 71e:	6ca2                	ld	s9,8(sp)
 720:	bda5                	j	598 <vprintf+0x44>
        putc(fd, va_arg(ap, uint32));
 722:	008b8493          	addi	s1,s7,8
 726:	000bc583          	lbu	a1,0(s7)
 72a:	855a                	mv	a0,s6
 72c:	d6dff0ef          	jal	498 <putc>
 730:	8ba6                	mv	s7,s1
      state = 0;
 732:	4981                	li	s3,0
 734:	b595                	j	598 <vprintf+0x44>
        if((s = va_arg(ap, char*)) == 0)
 736:	008b8993          	addi	s3,s7,8
 73a:	000bb483          	ld	s1,0(s7)
 73e:	cc91                	beqz	s1,75a <vprintf+0x206>
        for(; *s; s++)
 740:	0004c583          	lbu	a1,0(s1)
 744:	c985                	beqz	a1,774 <vprintf+0x220>
          putc(fd, *s);
 746:	855a                	mv	a0,s6
 748:	d51ff0ef          	jal	498 <putc>
        for(; *s; s++)
 74c:	0485                	addi	s1,s1,1
 74e:	0004c583          	lbu	a1,0(s1)
 752:	f9f5                	bnez	a1,746 <vprintf+0x1f2>
        if((s = va_arg(ap, char*)) == 0)
 754:	8bce                	mv	s7,s3
      state = 0;
 756:	4981                	li	s3,0
 758:	b581                	j	598 <vprintf+0x44>
          s = "(null)";
 75a:	00000497          	auipc	s1,0x0
 75e:	36648493          	addi	s1,s1,870 # ac0 <malloc+0x1ca>
        for(; *s; s++)
 762:	02800593          	li	a1,40
 766:	b7c5                	j	746 <vprintf+0x1f2>
        putc(fd, '%');
 768:	85be                	mv	a1,a5
 76a:	855a                	mv	a0,s6
 76c:	d2dff0ef          	jal	498 <putc>
      state = 0;
 770:	4981                	li	s3,0
 772:	b51d                	j	598 <vprintf+0x44>
        if((s = va_arg(ap, char*)) == 0)
 774:	8bce                	mv	s7,s3
      state = 0;
 776:	4981                	li	s3,0
 778:	b505                	j	598 <vprintf+0x44>
 77a:	6906                	ld	s2,64(sp)
 77c:	79e2                	ld	s3,56(sp)
 77e:	7a42                	ld	s4,48(sp)
 780:	7aa2                	ld	s5,40(sp)
 782:	7b02                	ld	s6,32(sp)
 784:	6be2                	ld	s7,24(sp)
 786:	6c42                	ld	s8,16(sp)
    }
  }
}
 788:	60e6                	ld	ra,88(sp)
 78a:	6446                	ld	s0,80(sp)
 78c:	64a6                	ld	s1,72(sp)
 78e:	6125                	addi	sp,sp,96
 790:	8082                	ret
      if(c0 == 'd'){
 792:	06400713          	li	a4,100
 796:	e4e78fe3          	beq	a5,a4,5f4 <vprintf+0xa0>
      } else if(c0 == 'l' && c1 == 'd'){
 79a:	f9478693          	addi	a3,a5,-108
 79e:	0016b693          	seqz	a3,a3
      c1 = c2 = 0;
 7a2:	85b2                	mv	a1,a2
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 7a4:	4701                	li	a4,0
      } else if(c0 == 'u'){
 7a6:	07500513          	li	a0,117
 7aa:	e8a78ce3          	beq	a5,a0,642 <vprintf+0xee>
      } else if(c0 == 'l' && c1 == 'u'){
 7ae:	f8b60513          	addi	a0,a2,-117
 7b2:	e119                	bnez	a0,7b8 <vprintf+0x264>
 7b4:	ea0693e3          	bnez	a3,65a <vprintf+0x106>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
 7b8:	f8b58513          	addi	a0,a1,-117
 7bc:	e119                	bnez	a0,7c2 <vprintf+0x26e>
 7be:	ea071be3          	bnez	a4,674 <vprintf+0x120>
      } else if(c0 == 'x'){
 7c2:	07800513          	li	a0,120
 7c6:	eca784e3          	beq	a5,a0,68e <vprintf+0x13a>
      } else if(c0 == 'l' && c1 == 'x'){
 7ca:	f8860613          	addi	a2,a2,-120
 7ce:	e219                	bnez	a2,7d4 <vprintf+0x280>
 7d0:	ec069be3          	bnez	a3,6a6 <vprintf+0x152>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
 7d4:	f8858593          	addi	a1,a1,-120
 7d8:	e199                	bnez	a1,7de <vprintf+0x28a>
 7da:	ee0713e3          	bnez	a4,6c0 <vprintf+0x16c>
      } else if(c0 == 'p'){
 7de:	07000713          	li	a4,112
 7e2:	eee78ce3          	beq	a5,a4,6da <vprintf+0x186>
      } else if(c0 == 'c'){
 7e6:	06300713          	li	a4,99
 7ea:	f2e78ce3          	beq	a5,a4,722 <vprintf+0x1ce>
      } else if(c0 == 's'){
 7ee:	07300713          	li	a4,115
 7f2:	f4e782e3          	beq	a5,a4,736 <vprintf+0x1e2>
      } else if(c0 == '%'){
 7f6:	02500713          	li	a4,37
 7fa:	f6e787e3          	beq	a5,a4,768 <vprintf+0x214>
        putc(fd, '%');
 7fe:	02500593          	li	a1,37
 802:	855a                	mv	a0,s6
 804:	c95ff0ef          	jal	498 <putc>
        putc(fd, c0);
 808:	85a6                	mv	a1,s1
 80a:	855a                	mv	a0,s6
 80c:	c8dff0ef          	jal	498 <putc>
      state = 0;
 810:	4981                	li	s3,0
 812:	b359                	j	598 <vprintf+0x44>

0000000000000814 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 814:	715d                	addi	sp,sp,-80
 816:	ec06                	sd	ra,24(sp)
 818:	e822                	sd	s0,16(sp)
 81a:	1000                	addi	s0,sp,32
 81c:	e010                	sd	a2,0(s0)
 81e:	e414                	sd	a3,8(s0)
 820:	e818                	sd	a4,16(s0)
 822:	ec1c                	sd	a5,24(s0)
 824:	03043023          	sd	a6,32(s0)
 828:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 82c:	8622                	mv	a2,s0
 82e:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 832:	d23ff0ef          	jal	554 <vprintf>
}
 836:	60e2                	ld	ra,24(sp)
 838:	6442                	ld	s0,16(sp)
 83a:	6161                	addi	sp,sp,80
 83c:	8082                	ret

000000000000083e <printf>:

void
printf(const char *fmt, ...)
{
 83e:	711d                	addi	sp,sp,-96
 840:	ec06                	sd	ra,24(sp)
 842:	e822                	sd	s0,16(sp)
 844:	1000                	addi	s0,sp,32
 846:	e40c                	sd	a1,8(s0)
 848:	e810                	sd	a2,16(s0)
 84a:	ec14                	sd	a3,24(s0)
 84c:	f018                	sd	a4,32(s0)
 84e:	f41c                	sd	a5,40(s0)
 850:	03043823          	sd	a6,48(s0)
 854:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 858:	00840613          	addi	a2,s0,8
 85c:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 860:	85aa                	mv	a1,a0
 862:	4505                	li	a0,1
 864:	cf1ff0ef          	jal	554 <vprintf>
}
 868:	60e2                	ld	ra,24(sp)
 86a:	6442                	ld	s0,16(sp)
 86c:	6125                	addi	sp,sp,96
 86e:	8082                	ret

0000000000000870 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 870:	1141                	addi	sp,sp,-16
 872:	e406                	sd	ra,8(sp)
 874:	e022                	sd	s0,0(sp)
 876:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 878:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 87c:	00000797          	auipc	a5,0x0
 880:	7847b783          	ld	a5,1924(a5) # 1000 <freep>
 884:	a039                	j	892 <free+0x22>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 886:	6398                	ld	a4,0(a5)
 888:	00e7e463          	bltu	a5,a4,890 <free+0x20>
 88c:	00e6ea63          	bltu	a3,a4,8a0 <free+0x30>
{
 890:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 892:	fed7fae3          	bgeu	a5,a3,886 <free+0x16>
 896:	6398                	ld	a4,0(a5)
 898:	00e6e463          	bltu	a3,a4,8a0 <free+0x30>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 89c:	fee7eae3          	bltu	a5,a4,890 <free+0x20>
      break;
  if(bp + bp->s.size == p->s.ptr){
 8a0:	ff852583          	lw	a1,-8(a0)
 8a4:	6390                	ld	a2,0(a5)
 8a6:	02059813          	slli	a6,a1,0x20
 8aa:	01c85713          	srli	a4,a6,0x1c
 8ae:	9736                	add	a4,a4,a3
 8b0:	02e60563          	beq	a2,a4,8da <free+0x6a>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
 8b4:	fec53823          	sd	a2,-16(a0)
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
 8b8:	4790                	lw	a2,8(a5)
 8ba:	02061593          	slli	a1,a2,0x20
 8be:	01c5d713          	srli	a4,a1,0x1c
 8c2:	973e                	add	a4,a4,a5
 8c4:	02e68263          	beq	a3,a4,8e8 <free+0x78>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
 8c8:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 8ca:	00000717          	auipc	a4,0x0
 8ce:	72f73b23          	sd	a5,1846(a4) # 1000 <freep>
}
 8d2:	60a2                	ld	ra,8(sp)
 8d4:	6402                	ld	s0,0(sp)
 8d6:	0141                	addi	sp,sp,16
 8d8:	8082                	ret
    bp->s.size += p->s.ptr->s.size;
 8da:	4618                	lw	a4,8(a2)
 8dc:	9f2d                	addw	a4,a4,a1
 8de:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 8e2:	6398                	ld	a4,0(a5)
 8e4:	6310                	ld	a2,0(a4)
 8e6:	b7f9                	j	8b4 <free+0x44>
    p->s.size += bp->s.size;
 8e8:	ff852703          	lw	a4,-8(a0)
 8ec:	9f31                	addw	a4,a4,a2
 8ee:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 8f0:	ff053683          	ld	a3,-16(a0)
 8f4:	bfd1                	j	8c8 <free+0x58>

00000000000008f6 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 8f6:	7139                	addi	sp,sp,-64
 8f8:	fc06                	sd	ra,56(sp)
 8fa:	f822                	sd	s0,48(sp)
 8fc:	f04a                	sd	s2,32(sp)
 8fe:	ec4e                	sd	s3,24(sp)
 900:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 902:	02051993          	slli	s3,a0,0x20
 906:	0209d993          	srli	s3,s3,0x20
 90a:	09bd                	addi	s3,s3,15
 90c:	0049d993          	srli	s3,s3,0x4
 910:	2985                	addiw	s3,s3,1
 912:	894e                	mv	s2,s3
  if((prevp = freep) == 0){
 914:	00000517          	auipc	a0,0x0
 918:	6ec53503          	ld	a0,1772(a0) # 1000 <freep>
 91c:	c905                	beqz	a0,94c <malloc+0x56>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 91e:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 920:	4798                	lw	a4,8(a5)
 922:	09377663          	bgeu	a4,s3,9ae <malloc+0xb8>
 926:	f426                	sd	s1,40(sp)
 928:	e852                	sd	s4,16(sp)
 92a:	e456                	sd	s5,8(sp)
 92c:	e05a                	sd	s6,0(sp)
  if(nu < 4096)
 92e:	8a4e                	mv	s4,s3
 930:	6705                	lui	a4,0x1
 932:	00e9f363          	bgeu	s3,a4,938 <malloc+0x42>
 936:	6a05                	lui	s4,0x1
 938:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 93c:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 940:	00000497          	auipc	s1,0x0
 944:	6c048493          	addi	s1,s1,1728 # 1000 <freep>
  if(p == SBRK_ERROR)
 948:	5afd                	li	s5,-1
 94a:	a83d                	j	988 <malloc+0x92>
 94c:	f426                	sd	s1,40(sp)
 94e:	e852                	sd	s4,16(sp)
 950:	e456                	sd	s5,8(sp)
 952:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
 954:	00000797          	auipc	a5,0x0
 958:	6bc78793          	addi	a5,a5,1724 # 1010 <base>
 95c:	00000717          	auipc	a4,0x0
 960:	6af73223          	sd	a5,1700(a4) # 1000 <freep>
 964:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 966:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 96a:	b7d1                	j	92e <malloc+0x38>
        prevp->s.ptr = p->s.ptr;
 96c:	6398                	ld	a4,0(a5)
 96e:	e118                	sd	a4,0(a0)
 970:	a899                	j	9c6 <malloc+0xd0>
  hp->s.size = nu;
 972:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 976:	0541                	addi	a0,a0,16
 978:	ef9ff0ef          	jal	870 <free>
  return freep;
 97c:	6088                	ld	a0,0(s1)
      if((p = morecore(nunits)) == 0)
 97e:	c125                	beqz	a0,9de <malloc+0xe8>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 980:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 982:	4798                	lw	a4,8(a5)
 984:	03277163          	bgeu	a4,s2,9a6 <malloc+0xb0>
    if(p == freep)
 988:	6098                	ld	a4,0(s1)
 98a:	853e                	mv	a0,a5
 98c:	fef71ae3          	bne	a4,a5,980 <malloc+0x8a>
  p = sbrk(nu * sizeof(Header));
 990:	8552                	mv	a0,s4
 992:	a33ff0ef          	jal	3c4 <sbrk>
  if(p == SBRK_ERROR)
 996:	fd551ee3          	bne	a0,s5,972 <malloc+0x7c>
        return 0;
 99a:	4501                	li	a0,0
 99c:	74a2                	ld	s1,40(sp)
 99e:	6a42                	ld	s4,16(sp)
 9a0:	6aa2                	ld	s5,8(sp)
 9a2:	6b02                	ld	s6,0(sp)
 9a4:	a03d                	j	9d2 <malloc+0xdc>
 9a6:	74a2                	ld	s1,40(sp)
 9a8:	6a42                	ld	s4,16(sp)
 9aa:	6aa2                	ld	s5,8(sp)
 9ac:	6b02                	ld	s6,0(sp)
      if(p->s.size == nunits)
 9ae:	fae90fe3          	beq	s2,a4,96c <malloc+0x76>
        p->s.size -= nunits;
 9b2:	4137073b          	subw	a4,a4,s3
 9b6:	c798                	sw	a4,8(a5)
        p += p->s.size;
 9b8:	02071693          	slli	a3,a4,0x20
 9bc:	01c6d713          	srli	a4,a3,0x1c
 9c0:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 9c2:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 9c6:	00000717          	auipc	a4,0x0
 9ca:	62a73d23          	sd	a0,1594(a4) # 1000 <freep>
      return (void*)(p + 1);
 9ce:	01078513          	addi	a0,a5,16
  }
}
 9d2:	70e2                	ld	ra,56(sp)
 9d4:	7442                	ld	s0,48(sp)
 9d6:	7902                	ld	s2,32(sp)
 9d8:	69e2                	ld	s3,24(sp)
 9da:	6121                	addi	sp,sp,64
 9dc:	8082                	ret
 9de:	74a2                	ld	s1,40(sp)
 9e0:	6a42                	ld	s4,16(sp)
 9e2:	6aa2                	ld	s5,8(sp)
 9e4:	6b02                	ld	s6,0(sp)
 9e6:	b7f5                	j	9d2 <malloc+0xdc>
