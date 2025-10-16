
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
   c:	9e850513          	addi	a0,a0,-1560 # 9f0 <malloc+0xf2>
  10:	037000ef          	jal	846 <printf>

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
  38:	9e450513          	addi	a0,a0,-1564 # a18 <malloc+0x11a>
  3c:	00b000ef          	jal	846 <printf>
  40:	4481                	li	s1,0
  for (int i = 0; i < size; i += 4096) {
    // Print a dot for every 1MB touched to show progress
    if (i % (1024 * 1024) == 0) {
  42:	00100a37          	lui	s4,0x100
  46:	1a7d                	addi	s4,s4,-1 # fffff <base+0xfefef>
        write(1, ".", 1);
  48:	4b85                	li	s7,1
  4a:	00001c17          	auipc	s8,0x1
  4e:	9e6c0c13          	addi	s8,s8,-1562 # a30 <malloc+0x132>
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
  6e:	99e50513          	addi	a0,a0,-1634 # a08 <malloc+0x10a>
  72:	7d4000ef          	jal	846 <printf>
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
  a8:	99450513          	addi	a0,a0,-1644 # a38 <malloc+0x13a>
  ac:	79a000ef          	jal	846 <printf>

  // Re-touch pages to check if they are correctly loaded after eviction
  printf("re-touching pages to check correctness...\n");
  b0:	00001517          	auipc	a0,0x1
  b4:	99050513          	addi	a0,a0,-1648 # a40 <malloc+0x142>
  b8:	78e000ef          	jal	846 <printf>
  for (int i = 0; i < 20*4096; i += 4096) {
  bc:	4481                	li	s1,0
  be:	6905                	lui	s2,0x1
  c0:	6ad1                	lui	s5,0x14
  c2:	6a05                	lui	s4,0x1
    if (i % (1024 * 1024) == 0) {
        write(1, ".", 1);
  c4:	4b05                	li	s6,1
  c6:	00001b97          	auipc	s7,0x1
  ca:	96ab8b93          	addi	s7,s7,-1686 # a30 <malloc+0x132>
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
 116:	95e50513          	addi	a0,a0,-1698 # a70 <malloc+0x172>
 11a:	72c000ef          	jal	846 <printf>
      exit(1);
 11e:	4505                	li	a0,1
 120:	2d8000ef          	jal	3f8 <exit>
    }
  }
  printf("\n"); // Newline after progress dots
 124:	00001517          	auipc	a0,0x1
 128:	91450513          	addi	a0,a0,-1772 # a38 <malloc+0x13a>
 12c:	71a000ef          	jal	846 <printf>

  printf("evicttest finished successfully\n");
 130:	00001517          	auipc	a0,0x1
 134:	96850513          	addi	a0,a0,-1688 # a98 <malloc+0x19a>
 138:	70e000ef          	jal	846 <printf>
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

0000000000000498 <memstat>:
.global memstat
memstat:
 li a7, SYS_memstat
 498:	48d9                	li	a7,22
 ecall
 49a:	00000073          	ecall
 ret
 49e:	8082                	ret

00000000000004a0 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 4a0:	1101                	addi	sp,sp,-32
 4a2:	ec06                	sd	ra,24(sp)
 4a4:	e822                	sd	s0,16(sp)
 4a6:	1000                	addi	s0,sp,32
 4a8:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 4ac:	4605                	li	a2,1
 4ae:	fef40593          	addi	a1,s0,-17
 4b2:	f67ff0ef          	jal	418 <write>
}
 4b6:	60e2                	ld	ra,24(sp)
 4b8:	6442                	ld	s0,16(sp)
 4ba:	6105                	addi	sp,sp,32
 4bc:	8082                	ret

00000000000004be <printint>:

static void
printint(int fd, long long xx, int base, int sgn)
{
 4be:	715d                	addi	sp,sp,-80
 4c0:	e486                	sd	ra,72(sp)
 4c2:	e0a2                	sd	s0,64(sp)
 4c4:	f84a                	sd	s2,48(sp)
 4c6:	f44e                	sd	s3,40(sp)
 4c8:	0880                	addi	s0,sp,80
 4ca:	892a                	mv	s2,a0
  char buf[20];
  int i, neg;
  unsigned long long x;

  neg = 0;
  if(sgn && xx < 0){
 4cc:	c6d1                	beqz	a3,558 <printint+0x9a>
 4ce:	0805d563          	bgez	a1,558 <printint+0x9a>
    neg = 1;
    x = -xx;
 4d2:	40b005b3          	neg	a1,a1
    neg = 1;
 4d6:	4305                	li	t1,1
  } else {
    x = xx;
  }

  i = 0;
 4d8:	fb840993          	addi	s3,s0,-72
  neg = 0;
 4dc:	86ce                	mv	a3,s3
  i = 0;
 4de:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 4e0:	00000817          	auipc	a6,0x0
 4e4:	5e880813          	addi	a6,a6,1512 # ac8 <digits>
 4e8:	88ba                	mv	a7,a4
 4ea:	0017051b          	addiw	a0,a4,1
 4ee:	872a                	mv	a4,a0
 4f0:	02c5f7b3          	remu	a5,a1,a2
 4f4:	97c2                	add	a5,a5,a6
 4f6:	0007c783          	lbu	a5,0(a5)
 4fa:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 4fe:	87ae                	mv	a5,a1
 500:	02c5d5b3          	divu	a1,a1,a2
 504:	0685                	addi	a3,a3,1
 506:	fec7f1e3          	bgeu	a5,a2,4e8 <printint+0x2a>
  if(neg)
 50a:	00030c63          	beqz	t1,522 <printint+0x64>
    buf[i++] = '-';
 50e:	fd050793          	addi	a5,a0,-48
 512:	00878533          	add	a0,a5,s0
 516:	02d00793          	li	a5,45
 51a:	fef50423          	sb	a5,-24(a0)
 51e:	0028871b          	addiw	a4,a7,2

  while(--i >= 0)
 522:	02e05563          	blez	a4,54c <printint+0x8e>
 526:	fc26                	sd	s1,56(sp)
 528:	377d                	addiw	a4,a4,-1
 52a:	00e984b3          	add	s1,s3,a4
 52e:	19fd                	addi	s3,s3,-1
 530:	99ba                	add	s3,s3,a4
 532:	1702                	slli	a4,a4,0x20
 534:	9301                	srli	a4,a4,0x20
 536:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 53a:	0004c583          	lbu	a1,0(s1)
 53e:	854a                	mv	a0,s2
 540:	f61ff0ef          	jal	4a0 <putc>
  while(--i >= 0)
 544:	14fd                	addi	s1,s1,-1
 546:	ff349ae3          	bne	s1,s3,53a <printint+0x7c>
 54a:	74e2                	ld	s1,56(sp)
}
 54c:	60a6                	ld	ra,72(sp)
 54e:	6406                	ld	s0,64(sp)
 550:	7942                	ld	s2,48(sp)
 552:	79a2                	ld	s3,40(sp)
 554:	6161                	addi	sp,sp,80
 556:	8082                	ret
  neg = 0;
 558:	4301                	li	t1,0
 55a:	bfbd                	j	4d8 <printint+0x1a>

000000000000055c <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %c, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 55c:	711d                	addi	sp,sp,-96
 55e:	ec86                	sd	ra,88(sp)
 560:	e8a2                	sd	s0,80(sp)
 562:	e4a6                	sd	s1,72(sp)
 564:	1080                	addi	s0,sp,96
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 566:	0005c483          	lbu	s1,0(a1)
 56a:	22048363          	beqz	s1,790 <vprintf+0x234>
 56e:	e0ca                	sd	s2,64(sp)
 570:	fc4e                	sd	s3,56(sp)
 572:	f852                	sd	s4,48(sp)
 574:	f456                	sd	s5,40(sp)
 576:	f05a                	sd	s6,32(sp)
 578:	ec5e                	sd	s7,24(sp)
 57a:	e862                	sd	s8,16(sp)
 57c:	8b2a                	mv	s6,a0
 57e:	8a2e                	mv	s4,a1
 580:	8bb2                	mv	s7,a2
  state = 0;
 582:	4981                	li	s3,0
  for(i = 0; fmt[i]; i++){
 584:	4901                	li	s2,0
 586:	4701                	li	a4,0
      if(c0 == '%'){
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if(state == '%'){
 588:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if(c0) c1 = fmt[i+1] & 0xff;
      if(c1) c2 = fmt[i+2] & 0xff;
      if(c0 == 'd'){
 58c:	06400c13          	li	s8,100
 590:	a00d                	j	5b2 <vprintf+0x56>
        putc(fd, c0);
 592:	85a6                	mv	a1,s1
 594:	855a                	mv	a0,s6
 596:	f0bff0ef          	jal	4a0 <putc>
 59a:	a019                	j	5a0 <vprintf+0x44>
    } else if(state == '%'){
 59c:	03598363          	beq	s3,s5,5c2 <vprintf+0x66>
  for(i = 0; fmt[i]; i++){
 5a0:	0019079b          	addiw	a5,s2,1
 5a4:	893e                	mv	s2,a5
 5a6:	873e                	mv	a4,a5
 5a8:	97d2                	add	a5,a5,s4
 5aa:	0007c483          	lbu	s1,0(a5)
 5ae:	1c048a63          	beqz	s1,782 <vprintf+0x226>
    c0 = fmt[i] & 0xff;
 5b2:	0004879b          	sext.w	a5,s1
    if(state == 0){
 5b6:	fe0993e3          	bnez	s3,59c <vprintf+0x40>
      if(c0 == '%'){
 5ba:	fd579ce3          	bne	a5,s5,592 <vprintf+0x36>
        state = '%';
 5be:	89be                	mv	s3,a5
 5c0:	b7c5                	j	5a0 <vprintf+0x44>
      if(c0) c1 = fmt[i+1] & 0xff;
 5c2:	00ea06b3          	add	a3,s4,a4
 5c6:	0016c603          	lbu	a2,1(a3)
      if(c1) c2 = fmt[i+2] & 0xff;
 5ca:	1c060863          	beqz	a2,79a <vprintf+0x23e>
      if(c0 == 'd'){
 5ce:	03878763          	beq	a5,s8,5fc <vprintf+0xa0>
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c0 == 'l' && c1 == 'd'){
 5d2:	f9478693          	addi	a3,a5,-108
 5d6:	0016b693          	seqz	a3,a3
 5da:	f9c60593          	addi	a1,a2,-100
 5de:	e99d                	bnez	a1,614 <vprintf+0xb8>
 5e0:	ca95                	beqz	a3,614 <vprintf+0xb8>
        printint(fd, va_arg(ap, uint64), 10, 1);
 5e2:	008b8493          	addi	s1,s7,8
 5e6:	4685                	li	a3,1
 5e8:	4629                	li	a2,10
 5ea:	000bb583          	ld	a1,0(s7)
 5ee:	855a                	mv	a0,s6
 5f0:	ecfff0ef          	jal	4be <printint>
        i += 1;
 5f4:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 10, 1);
 5f6:	8ba6                	mv	s7,s1
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c0);
      }

      state = 0;
 5f8:	4981                	li	s3,0
 5fa:	b75d                	j	5a0 <vprintf+0x44>
        printint(fd, va_arg(ap, int), 10, 1);
 5fc:	008b8493          	addi	s1,s7,8
 600:	4685                	li	a3,1
 602:	4629                	li	a2,10
 604:	000ba583          	lw	a1,0(s7)
 608:	855a                	mv	a0,s6
 60a:	eb5ff0ef          	jal	4be <printint>
 60e:	8ba6                	mv	s7,s1
      state = 0;
 610:	4981                	li	s3,0
 612:	b779                	j	5a0 <vprintf+0x44>
      if(c1) c2 = fmt[i+2] & 0xff;
 614:	9752                	add	a4,a4,s4
 616:	00274583          	lbu	a1,2(a4)
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 61a:	f9460713          	addi	a4,a2,-108
 61e:	00173713          	seqz	a4,a4
 622:	8f75                	and	a4,a4,a3
 624:	f9c58513          	addi	a0,a1,-100
 628:	18051363          	bnez	a0,7ae <vprintf+0x252>
 62c:	18070163          	beqz	a4,7ae <vprintf+0x252>
        printint(fd, va_arg(ap, uint64), 10, 1);
 630:	008b8493          	addi	s1,s7,8
 634:	4685                	li	a3,1
 636:	4629                	li	a2,10
 638:	000bb583          	ld	a1,0(s7)
 63c:	855a                	mv	a0,s6
 63e:	e81ff0ef          	jal	4be <printint>
        i += 2;
 642:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 10, 1);
 644:	8ba6                	mv	s7,s1
      state = 0;
 646:	4981                	li	s3,0
        i += 2;
 648:	bfa1                	j	5a0 <vprintf+0x44>
        printint(fd, va_arg(ap, uint32), 10, 0);
 64a:	008b8493          	addi	s1,s7,8
 64e:	4681                	li	a3,0
 650:	4629                	li	a2,10
 652:	000be583          	lwu	a1,0(s7)
 656:	855a                	mv	a0,s6
 658:	e67ff0ef          	jal	4be <printint>
 65c:	8ba6                	mv	s7,s1
      state = 0;
 65e:	4981                	li	s3,0
 660:	b781                	j	5a0 <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 10, 0);
 662:	008b8493          	addi	s1,s7,8
 666:	4681                	li	a3,0
 668:	4629                	li	a2,10
 66a:	000bb583          	ld	a1,0(s7)
 66e:	855a                	mv	a0,s6
 670:	e4fff0ef          	jal	4be <printint>
        i += 1;
 674:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 10, 0);
 676:	8ba6                	mv	s7,s1
      state = 0;
 678:	4981                	li	s3,0
 67a:	b71d                	j	5a0 <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 10, 0);
 67c:	008b8493          	addi	s1,s7,8
 680:	4681                	li	a3,0
 682:	4629                	li	a2,10
 684:	000bb583          	ld	a1,0(s7)
 688:	855a                	mv	a0,s6
 68a:	e35ff0ef          	jal	4be <printint>
        i += 2;
 68e:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 10, 0);
 690:	8ba6                	mv	s7,s1
      state = 0;
 692:	4981                	li	s3,0
        i += 2;
 694:	b731                	j	5a0 <vprintf+0x44>
        printint(fd, va_arg(ap, uint32), 16, 0);
 696:	008b8493          	addi	s1,s7,8
 69a:	4681                	li	a3,0
 69c:	4641                	li	a2,16
 69e:	000be583          	lwu	a1,0(s7)
 6a2:	855a                	mv	a0,s6
 6a4:	e1bff0ef          	jal	4be <printint>
 6a8:	8ba6                	mv	s7,s1
      state = 0;
 6aa:	4981                	li	s3,0
 6ac:	bdd5                	j	5a0 <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 16, 0);
 6ae:	008b8493          	addi	s1,s7,8
 6b2:	4681                	li	a3,0
 6b4:	4641                	li	a2,16
 6b6:	000bb583          	ld	a1,0(s7)
 6ba:	855a                	mv	a0,s6
 6bc:	e03ff0ef          	jal	4be <printint>
        i += 1;
 6c0:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 16, 0);
 6c2:	8ba6                	mv	s7,s1
      state = 0;
 6c4:	4981                	li	s3,0
 6c6:	bde9                	j	5a0 <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 16, 0);
 6c8:	008b8493          	addi	s1,s7,8
 6cc:	4681                	li	a3,0
 6ce:	4641                	li	a2,16
 6d0:	000bb583          	ld	a1,0(s7)
 6d4:	855a                	mv	a0,s6
 6d6:	de9ff0ef          	jal	4be <printint>
        i += 2;
 6da:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 16, 0);
 6dc:	8ba6                	mv	s7,s1
      state = 0;
 6de:	4981                	li	s3,0
        i += 2;
 6e0:	b5c1                	j	5a0 <vprintf+0x44>
 6e2:	e466                	sd	s9,8(sp)
        printptr(fd, va_arg(ap, uint64));
 6e4:	008b8793          	addi	a5,s7,8
 6e8:	8cbe                	mv	s9,a5
 6ea:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 6ee:	03000593          	li	a1,48
 6f2:	855a                	mv	a0,s6
 6f4:	dadff0ef          	jal	4a0 <putc>
  putc(fd, 'x');
 6f8:	07800593          	li	a1,120
 6fc:	855a                	mv	a0,s6
 6fe:	da3ff0ef          	jal	4a0 <putc>
 702:	44c1                	li	s1,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 704:	00000b97          	auipc	s7,0x0
 708:	3c4b8b93          	addi	s7,s7,964 # ac8 <digits>
 70c:	03c9d793          	srli	a5,s3,0x3c
 710:	97de                	add	a5,a5,s7
 712:	0007c583          	lbu	a1,0(a5)
 716:	855a                	mv	a0,s6
 718:	d89ff0ef          	jal	4a0 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 71c:	0992                	slli	s3,s3,0x4
 71e:	34fd                	addiw	s1,s1,-1
 720:	f4f5                	bnez	s1,70c <vprintf+0x1b0>
        printptr(fd, va_arg(ap, uint64));
 722:	8be6                	mv	s7,s9
      state = 0;
 724:	4981                	li	s3,0
 726:	6ca2                	ld	s9,8(sp)
 728:	bda5                	j	5a0 <vprintf+0x44>
        putc(fd, va_arg(ap, uint32));
 72a:	008b8493          	addi	s1,s7,8
 72e:	000bc583          	lbu	a1,0(s7)
 732:	855a                	mv	a0,s6
 734:	d6dff0ef          	jal	4a0 <putc>
 738:	8ba6                	mv	s7,s1
      state = 0;
 73a:	4981                	li	s3,0
 73c:	b595                	j	5a0 <vprintf+0x44>
        if((s = va_arg(ap, char*)) == 0)
 73e:	008b8993          	addi	s3,s7,8
 742:	000bb483          	ld	s1,0(s7)
 746:	cc91                	beqz	s1,762 <vprintf+0x206>
        for(; *s; s++)
 748:	0004c583          	lbu	a1,0(s1)
 74c:	c985                	beqz	a1,77c <vprintf+0x220>
          putc(fd, *s);
 74e:	855a                	mv	a0,s6
 750:	d51ff0ef          	jal	4a0 <putc>
        for(; *s; s++)
 754:	0485                	addi	s1,s1,1
 756:	0004c583          	lbu	a1,0(s1)
 75a:	f9f5                	bnez	a1,74e <vprintf+0x1f2>
        if((s = va_arg(ap, char*)) == 0)
 75c:	8bce                	mv	s7,s3
      state = 0;
 75e:	4981                	li	s3,0
 760:	b581                	j	5a0 <vprintf+0x44>
          s = "(null)";
 762:	00000497          	auipc	s1,0x0
 766:	35e48493          	addi	s1,s1,862 # ac0 <malloc+0x1c2>
        for(; *s; s++)
 76a:	02800593          	li	a1,40
 76e:	b7c5                	j	74e <vprintf+0x1f2>
        putc(fd, '%');
 770:	85be                	mv	a1,a5
 772:	855a                	mv	a0,s6
 774:	d2dff0ef          	jal	4a0 <putc>
      state = 0;
 778:	4981                	li	s3,0
 77a:	b51d                	j	5a0 <vprintf+0x44>
        if((s = va_arg(ap, char*)) == 0)
 77c:	8bce                	mv	s7,s3
      state = 0;
 77e:	4981                	li	s3,0
 780:	b505                	j	5a0 <vprintf+0x44>
 782:	6906                	ld	s2,64(sp)
 784:	79e2                	ld	s3,56(sp)
 786:	7a42                	ld	s4,48(sp)
 788:	7aa2                	ld	s5,40(sp)
 78a:	7b02                	ld	s6,32(sp)
 78c:	6be2                	ld	s7,24(sp)
 78e:	6c42                	ld	s8,16(sp)
    }
  }
}
 790:	60e6                	ld	ra,88(sp)
 792:	6446                	ld	s0,80(sp)
 794:	64a6                	ld	s1,72(sp)
 796:	6125                	addi	sp,sp,96
 798:	8082                	ret
      if(c0 == 'd'){
 79a:	06400713          	li	a4,100
 79e:	e4e78fe3          	beq	a5,a4,5fc <vprintf+0xa0>
      } else if(c0 == 'l' && c1 == 'd'){
 7a2:	f9478693          	addi	a3,a5,-108
 7a6:	0016b693          	seqz	a3,a3
      c1 = c2 = 0;
 7aa:	85b2                	mv	a1,a2
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 7ac:	4701                	li	a4,0
      } else if(c0 == 'u'){
 7ae:	07500513          	li	a0,117
 7b2:	e8a78ce3          	beq	a5,a0,64a <vprintf+0xee>
      } else if(c0 == 'l' && c1 == 'u'){
 7b6:	f8b60513          	addi	a0,a2,-117
 7ba:	e119                	bnez	a0,7c0 <vprintf+0x264>
 7bc:	ea0693e3          	bnez	a3,662 <vprintf+0x106>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
 7c0:	f8b58513          	addi	a0,a1,-117
 7c4:	e119                	bnez	a0,7ca <vprintf+0x26e>
 7c6:	ea071be3          	bnez	a4,67c <vprintf+0x120>
      } else if(c0 == 'x'){
 7ca:	07800513          	li	a0,120
 7ce:	eca784e3          	beq	a5,a0,696 <vprintf+0x13a>
      } else if(c0 == 'l' && c1 == 'x'){
 7d2:	f8860613          	addi	a2,a2,-120
 7d6:	e219                	bnez	a2,7dc <vprintf+0x280>
 7d8:	ec069be3          	bnez	a3,6ae <vprintf+0x152>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
 7dc:	f8858593          	addi	a1,a1,-120
 7e0:	e199                	bnez	a1,7e6 <vprintf+0x28a>
 7e2:	ee0713e3          	bnez	a4,6c8 <vprintf+0x16c>
      } else if(c0 == 'p'){
 7e6:	07000713          	li	a4,112
 7ea:	eee78ce3          	beq	a5,a4,6e2 <vprintf+0x186>
      } else if(c0 == 'c'){
 7ee:	06300713          	li	a4,99
 7f2:	f2e78ce3          	beq	a5,a4,72a <vprintf+0x1ce>
      } else if(c0 == 's'){
 7f6:	07300713          	li	a4,115
 7fa:	f4e782e3          	beq	a5,a4,73e <vprintf+0x1e2>
      } else if(c0 == '%'){
 7fe:	02500713          	li	a4,37
 802:	f6e787e3          	beq	a5,a4,770 <vprintf+0x214>
        putc(fd, '%');
 806:	02500593          	li	a1,37
 80a:	855a                	mv	a0,s6
 80c:	c95ff0ef          	jal	4a0 <putc>
        putc(fd, c0);
 810:	85a6                	mv	a1,s1
 812:	855a                	mv	a0,s6
 814:	c8dff0ef          	jal	4a0 <putc>
      state = 0;
 818:	4981                	li	s3,0
 81a:	b359                	j	5a0 <vprintf+0x44>

000000000000081c <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 81c:	715d                	addi	sp,sp,-80
 81e:	ec06                	sd	ra,24(sp)
 820:	e822                	sd	s0,16(sp)
 822:	1000                	addi	s0,sp,32
 824:	e010                	sd	a2,0(s0)
 826:	e414                	sd	a3,8(s0)
 828:	e818                	sd	a4,16(s0)
 82a:	ec1c                	sd	a5,24(s0)
 82c:	03043023          	sd	a6,32(s0)
 830:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 834:	8622                	mv	a2,s0
 836:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 83a:	d23ff0ef          	jal	55c <vprintf>
}
 83e:	60e2                	ld	ra,24(sp)
 840:	6442                	ld	s0,16(sp)
 842:	6161                	addi	sp,sp,80
 844:	8082                	ret

0000000000000846 <printf>:

void
printf(const char *fmt, ...)
{
 846:	711d                	addi	sp,sp,-96
 848:	ec06                	sd	ra,24(sp)
 84a:	e822                	sd	s0,16(sp)
 84c:	1000                	addi	s0,sp,32
 84e:	e40c                	sd	a1,8(s0)
 850:	e810                	sd	a2,16(s0)
 852:	ec14                	sd	a3,24(s0)
 854:	f018                	sd	a4,32(s0)
 856:	f41c                	sd	a5,40(s0)
 858:	03043823          	sd	a6,48(s0)
 85c:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 860:	00840613          	addi	a2,s0,8
 864:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 868:	85aa                	mv	a1,a0
 86a:	4505                	li	a0,1
 86c:	cf1ff0ef          	jal	55c <vprintf>
}
 870:	60e2                	ld	ra,24(sp)
 872:	6442                	ld	s0,16(sp)
 874:	6125                	addi	sp,sp,96
 876:	8082                	ret

0000000000000878 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 878:	1141                	addi	sp,sp,-16
 87a:	e406                	sd	ra,8(sp)
 87c:	e022                	sd	s0,0(sp)
 87e:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 880:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 884:	00000797          	auipc	a5,0x0
 888:	77c7b783          	ld	a5,1916(a5) # 1000 <freep>
 88c:	a039                	j	89a <free+0x22>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 88e:	6398                	ld	a4,0(a5)
 890:	00e7e463          	bltu	a5,a4,898 <free+0x20>
 894:	00e6ea63          	bltu	a3,a4,8a8 <free+0x30>
{
 898:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 89a:	fed7fae3          	bgeu	a5,a3,88e <free+0x16>
 89e:	6398                	ld	a4,0(a5)
 8a0:	00e6e463          	bltu	a3,a4,8a8 <free+0x30>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 8a4:	fee7eae3          	bltu	a5,a4,898 <free+0x20>
      break;
  if(bp + bp->s.size == p->s.ptr){
 8a8:	ff852583          	lw	a1,-8(a0)
 8ac:	6390                	ld	a2,0(a5)
 8ae:	02059813          	slli	a6,a1,0x20
 8b2:	01c85713          	srli	a4,a6,0x1c
 8b6:	9736                	add	a4,a4,a3
 8b8:	02e60563          	beq	a2,a4,8e2 <free+0x6a>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
 8bc:	fec53823          	sd	a2,-16(a0)
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
 8c0:	4790                	lw	a2,8(a5)
 8c2:	02061593          	slli	a1,a2,0x20
 8c6:	01c5d713          	srli	a4,a1,0x1c
 8ca:	973e                	add	a4,a4,a5
 8cc:	02e68263          	beq	a3,a4,8f0 <free+0x78>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
 8d0:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 8d2:	00000717          	auipc	a4,0x0
 8d6:	72f73723          	sd	a5,1838(a4) # 1000 <freep>
}
 8da:	60a2                	ld	ra,8(sp)
 8dc:	6402                	ld	s0,0(sp)
 8de:	0141                	addi	sp,sp,16
 8e0:	8082                	ret
    bp->s.size += p->s.ptr->s.size;
 8e2:	4618                	lw	a4,8(a2)
 8e4:	9f2d                	addw	a4,a4,a1
 8e6:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 8ea:	6398                	ld	a4,0(a5)
 8ec:	6310                	ld	a2,0(a4)
 8ee:	b7f9                	j	8bc <free+0x44>
    p->s.size += bp->s.size;
 8f0:	ff852703          	lw	a4,-8(a0)
 8f4:	9f31                	addw	a4,a4,a2
 8f6:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 8f8:	ff053683          	ld	a3,-16(a0)
 8fc:	bfd1                	j	8d0 <free+0x58>

00000000000008fe <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 8fe:	7139                	addi	sp,sp,-64
 900:	fc06                	sd	ra,56(sp)
 902:	f822                	sd	s0,48(sp)
 904:	f04a                	sd	s2,32(sp)
 906:	ec4e                	sd	s3,24(sp)
 908:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 90a:	02051993          	slli	s3,a0,0x20
 90e:	0209d993          	srli	s3,s3,0x20
 912:	09bd                	addi	s3,s3,15
 914:	0049d993          	srli	s3,s3,0x4
 918:	2985                	addiw	s3,s3,1
 91a:	894e                	mv	s2,s3
  if((prevp = freep) == 0){
 91c:	00000517          	auipc	a0,0x0
 920:	6e453503          	ld	a0,1764(a0) # 1000 <freep>
 924:	c905                	beqz	a0,954 <malloc+0x56>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 926:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 928:	4798                	lw	a4,8(a5)
 92a:	09377663          	bgeu	a4,s3,9b6 <malloc+0xb8>
 92e:	f426                	sd	s1,40(sp)
 930:	e852                	sd	s4,16(sp)
 932:	e456                	sd	s5,8(sp)
 934:	e05a                	sd	s6,0(sp)
  if(nu < 4096)
 936:	8a4e                	mv	s4,s3
 938:	6705                	lui	a4,0x1
 93a:	00e9f363          	bgeu	s3,a4,940 <malloc+0x42>
 93e:	6a05                	lui	s4,0x1
 940:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 944:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 948:	00000497          	auipc	s1,0x0
 94c:	6b848493          	addi	s1,s1,1720 # 1000 <freep>
  if(p == SBRK_ERROR)
 950:	5afd                	li	s5,-1
 952:	a83d                	j	990 <malloc+0x92>
 954:	f426                	sd	s1,40(sp)
 956:	e852                	sd	s4,16(sp)
 958:	e456                	sd	s5,8(sp)
 95a:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
 95c:	00000797          	auipc	a5,0x0
 960:	6b478793          	addi	a5,a5,1716 # 1010 <base>
 964:	00000717          	auipc	a4,0x0
 968:	68f73e23          	sd	a5,1692(a4) # 1000 <freep>
 96c:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 96e:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 972:	b7d1                	j	936 <malloc+0x38>
        prevp->s.ptr = p->s.ptr;
 974:	6398                	ld	a4,0(a5)
 976:	e118                	sd	a4,0(a0)
 978:	a899                	j	9ce <malloc+0xd0>
  hp->s.size = nu;
 97a:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 97e:	0541                	addi	a0,a0,16
 980:	ef9ff0ef          	jal	878 <free>
  return freep;
 984:	6088                	ld	a0,0(s1)
      if((p = morecore(nunits)) == 0)
 986:	c125                	beqz	a0,9e6 <malloc+0xe8>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 988:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 98a:	4798                	lw	a4,8(a5)
 98c:	03277163          	bgeu	a4,s2,9ae <malloc+0xb0>
    if(p == freep)
 990:	6098                	ld	a4,0(s1)
 992:	853e                	mv	a0,a5
 994:	fef71ae3          	bne	a4,a5,988 <malloc+0x8a>
  p = sbrk(nu * sizeof(Header));
 998:	8552                	mv	a0,s4
 99a:	a2bff0ef          	jal	3c4 <sbrk>
  if(p == SBRK_ERROR)
 99e:	fd551ee3          	bne	a0,s5,97a <malloc+0x7c>
        return 0;
 9a2:	4501                	li	a0,0
 9a4:	74a2                	ld	s1,40(sp)
 9a6:	6a42                	ld	s4,16(sp)
 9a8:	6aa2                	ld	s5,8(sp)
 9aa:	6b02                	ld	s6,0(sp)
 9ac:	a03d                	j	9da <malloc+0xdc>
 9ae:	74a2                	ld	s1,40(sp)
 9b0:	6a42                	ld	s4,16(sp)
 9b2:	6aa2                	ld	s5,8(sp)
 9b4:	6b02                	ld	s6,0(sp)
      if(p->s.size == nunits)
 9b6:	fae90fe3          	beq	s2,a4,974 <malloc+0x76>
        p->s.size -= nunits;
 9ba:	4137073b          	subw	a4,a4,s3
 9be:	c798                	sw	a4,8(a5)
        p += p->s.size;
 9c0:	02071693          	slli	a3,a4,0x20
 9c4:	01c6d713          	srli	a4,a3,0x1c
 9c8:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 9ca:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 9ce:	00000717          	auipc	a4,0x0
 9d2:	62a73923          	sd	a0,1586(a4) # 1000 <freep>
      return (void*)(p + 1);
 9d6:	01078513          	addi	a0,a5,16
  }
}
 9da:	70e2                	ld	ra,56(sp)
 9dc:	7442                	ld	s0,48(sp)
 9de:	7902                	ld	s2,32(sp)
 9e0:	69e2                	ld	s3,24(sp)
 9e2:	6121                	addi	sp,sp,64
 9e4:	8082                	ret
 9e6:	74a2                	ld	s1,40(sp)
 9e8:	6a42                	ld	s4,16(sp)
 9ea:	6aa2                	ld	s5,8(sp)
 9ec:	6b02                	ld	s6,0(sp)
 9ee:	b7f5                	j	9da <malloc+0xdc>
