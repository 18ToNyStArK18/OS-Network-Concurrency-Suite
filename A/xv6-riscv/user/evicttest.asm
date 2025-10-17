
user/_evicttest:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <main>:

// A program that allocates more memory than available to test page replacement.
// A program that allocates more memory than available to test page replacement.
int
main(int argc, char *argv[])
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
  2c:	7f010413          	addi	s0,sp,2032
  30:	d8010113          	addi	sp,sp,-640
  printf("evicttest starting\n");
  34:	00001517          	auipc	a0,0x1
  38:	b1c50513          	addi	a0,a0,-1252 # b50 <malloc+0x12c>
  3c:	131000ef          	jal	96c <printf>

  // Allocate a very large amount of memory to exceed physical memory
  // This will be more than enough to trigger eviction with 128MB RAM.
  int size = 23770 * 4096; 
  char *mem = sbrk(size);
  40:	05cda537          	lui	a0,0x5cda
  44:	4a6000ef          	jal	4ea <sbrk>
  if (mem == (char*)-1) {
  48:	57fd                	li	a5,-1
  4a:	02f50663          	beq	a0,a5,76 <main+0x76>
  4e:	89aa                	mv	s3,a0
    exit(1);
  }

  // Touch pages in a simple, predictable order
  // This will fill up memory and then trigger evictions
  printf("touching pages...\n");
  50:	00001517          	auipc	a0,0x1
  54:	b2850513          	addi	a0,a0,-1240 # b78 <malloc+0x154>
  58:	115000ef          	jal	96c <printf>
  5c:	4481                	li	s1,0
  for (int i = 0; i < size; i += 4096) {
    // Print a dot for every 1MB touched to show progress
    if (i % (1024 * 1024) == 0) {
  5e:	00100a37          	lui	s4,0x100
  62:	1a7d                	addi	s4,s4,-1 # fffff <base+0xfdfef>
        write(1, ".", 1);
  64:	4b85                	li	s7,1
  66:	00001c17          	auipc	s8,0x1
  6a:	b2ac0c13          	addi	s8,s8,-1238 # b90 <malloc+0x16c>
  for (int i = 0; i < size; i += 4096) {
  6e:	6b05                	lui	s6,0x1
  70:	05cdaab7          	lui	s5,0x5cda
  74:	a01d                	j	9a <main+0x9a>
    printf("sbrk failed\n");
  76:	00001517          	auipc	a0,0x1
  7a:	af250513          	addi	a0,a0,-1294 # b68 <malloc+0x144>
  7e:	0ef000ef          	jal	96c <printf>
    exit(1);
  82:	4505                	li	a0,1
  84:	49a000ef          	jal	51e <exit>
    }
    mem[i] = (char)(i / 4096);
  88:	009987b3          	add	a5,s3,s1
  8c:	40c9591b          	sraiw	s2,s2,0xc
  90:	01278023          	sb	s2,0(a5)
  for (int i = 0; i < size; i += 4096) {
  94:	94da                	add	s1,s1,s6
  96:	01548d63          	beq	s1,s5,b0 <main+0xb0>
  9a:	0004891b          	sext.w	s2,s1
    if (i % (1024 * 1024) == 0) {
  9e:	014977b3          	and	a5,s2,s4
  a2:	f3fd                	bnez	a5,88 <main+0x88>
        write(1, ".", 1);
  a4:	865e                	mv	a2,s7
  a6:	85e2                	mv	a1,s8
  a8:	855e                	mv	a0,s7
  aa:	494000ef          	jal	53e <write>
  ae:	bfe9                	j	88 <main+0x88>
  }
  printf("\n"); // Newline after progress dots
  b0:	00001517          	auipc	a0,0x1
  b4:	ae850513          	addi	a0,a0,-1304 # b98 <malloc+0x174>
  b8:	0b5000ef          	jal	96c <printf>

  // Re-touch pages to check if they are correctly loaded after eviction
  printf("re-touching pages to check correctness...\n");
  bc:	00001517          	auipc	a0,0x1
  c0:	ae450513          	addi	a0,a0,-1308 # ba0 <malloc+0x17c>
  c4:	0a9000ef          	jal	96c <printf>
  for (int i = 0; i < 20*4096; i += 4096) {
  c8:	4481                	li	s1,0
  ca:	6905                	lui	s2,0x1
  cc:	6ad1                	lui	s5,0x14
  ce:	6a05                	lui	s4,0x1
    if (i % (1024 * 1024) == 0) {
        write(1, ".", 1);
  d0:	4b05                	li	s6,1
  d2:	00001b97          	auipc	s7,0x1
  d6:	abeb8b93          	addi	s7,s7,-1346 # b90 <malloc+0x16c>
  da:	a015                	j	fe <main+0xfe>
  dc:	865a                	mv	a2,s6
  de:	85de                	mv	a1,s7
  e0:	855a                	mv	a0,s6
  e2:	45c000ef          	jal	53e <write>
    }
    if (mem[i] != (char)(i / 4096)) {
  e6:	85ce                	mv	a1,s3
  e8:	0009c703          	lbu	a4,0(s3)
  ec:	02c49693          	slli	a3,s1,0x2c
  f0:	0386d793          	srli	a5,a3,0x38
  f4:	02f71563          	bne	a4,a5,11e <main+0x11e>
  for (int i = 0; i < 20*4096; i += 4096) {
  f8:	009904bb          	addw	s1,s2,s1
  fc:	99d2                	add	s3,s3,s4
    if (i % (1024 * 1024) == 0) {
  fe:	dcf9                	beqz	s1,dc <main+0xdc>
    if (mem[i] != (char)(i / 4096)) {
 100:	85ce                	mv	a1,s3
 102:	0009c703          	lbu	a4,0(s3)
 106:	02c49693          	slli	a3,s1,0x2c
 10a:	0386d793          	srli	a5,a3,0x38
 10e:	00f71863          	bne	a4,a5,11e <main+0x11e>
  for (int i = 0; i < 20*4096; i += 4096) {
 112:	009904bb          	addw	s1,s2,s1
 116:	01548d63          	beq	s1,s5,130 <main+0x130>
 11a:	99d2                	add	s3,s3,s4
 11c:	b7cd                	j	fe <main+0xfe>
      printf("error: incorrect data at address %p\n", &mem[i]);
 11e:	00001517          	auipc	a0,0x1
 122:	ab250513          	addi	a0,a0,-1358 # bd0 <malloc+0x1ac>
 126:	047000ef          	jal	96c <printf>
      exit(1);
 12a:	4505                	li	a0,1
 12c:	3f2000ef          	jal	51e <exit>
    }
  }
  printf("\n"); // Newline after progress dots
 130:	00001517          	auipc	a0,0x1
 134:	a6850513          	addi	a0,a0,-1432 # b98 <malloc+0x174>
 138:	035000ef          	jal	96c <printf>
  struct proc_mem_stat info;
  memstat(&info);
 13c:	80040513          	addi	a0,s0,-2048
 140:	fb050513          	addi	a0,a0,-80
 144:	de850513          	addi	a0,a0,-536
 148:	476000ef          	jal	5be <memstat>
  printf("--- Process Memory Stats ---\n");
 14c:	00001517          	auipc	a0,0x1
 150:	aac50513          	addi	a0,a0,-1364 # bf8 <malloc+0x1d4>
 154:	019000ef          	jal	96c <printf>
  printf("PID: %d\n", info.pid);
 158:	80040493          	addi	s1,s0,-2048
 15c:	fb048493          	addi	s1,s1,-80
 160:	de84a583          	lw	a1,-536(s1)
 164:	00001517          	auipc	a0,0x1
 168:	ab450513          	addi	a0,a0,-1356 # c18 <malloc+0x1f4>
 16c:	001000ef          	jal	96c <printf>
  printf("Total Pages: %d\n", info.num_pages_total);
 170:	dec4a583          	lw	a1,-532(s1)
 174:	00001517          	auipc	a0,0x1
 178:	ab450513          	addi	a0,a0,-1356 # c28 <malloc+0x204>
 17c:	7f0000ef          	jal	96c <printf>
  printf("Resident Pages: %d\n", info.num_resident_pages);
 180:	df04a583          	lw	a1,-528(s1)
 184:	00001517          	auipc	a0,0x1
 188:	abc50513          	addi	a0,a0,-1348 # c40 <malloc+0x21c>
 18c:	7e0000ef          	jal	96c <printf>
  printf("Swapped Pages: %d\n", info.num_swapped_pages);
 190:	df44a583          	lw	a1,-524(s1)
 194:	00001517          	auipc	a0,0x1
 198:	ac450513          	addi	a0,a0,-1340 # c58 <malloc+0x234>
 19c:	7d0000ef          	jal	96c <printf>
  printf("Next FIFO Seq: %d\n\n", info.next_fifo_seq);
 1a0:	df84a583          	lw	a1,-520(s1)
 1a4:	00001517          	auipc	a0,0x1
 1a8:	acc50513          	addi	a0,a0,-1332 # c70 <malloc+0x24c>
 1ac:	7c0000ef          	jal	96c <printf>
  
  printf("--- Page Details (up to %d) ---\n", MAX_PAGES_INFO);
 1b0:	08000593          	li	a1,128
 1b4:	00001517          	auipc	a0,0x1
 1b8:	ad450513          	addi	a0,a0,-1324 # c88 <malloc+0x264>
 1bc:	7b0000ef          	jal	96c <printf>
  printf("VA         | STATE    | DIRTY | SEQ   | SLOT\n");
 1c0:	00001517          	auipc	a0,0x1
 1c4:	af050513          	addi	a0,a0,-1296 # cb0 <malloc+0x28c>
 1c8:	7a4000ef          	jal	96c <printf>
  printf("--------------------------------------------\n");
 1cc:	00001517          	auipc	a0,0x1
 1d0:	b1450513          	addi	a0,a0,-1260 # ce0 <malloc+0x2bc>
 1d4:	798000ef          	jal	96c <printf>
  
  for (int i = 0; i < info.num_pages_total && i < MAX_PAGES_INFO; i++) {
 1d8:	dec4a783          	lw	a5,-532(s1)
 1dc:	06f05d63          	blez	a5,256 <main+0x256>
 1e0:	80040493          	addi	s1,s0,-2048
 1e4:	fb048493          	addi	s1,s1,-80
 1e8:	dfc48493          	addi	s1,s1,-516
 1ec:	4901                	li	s2,0
    char *state_str = "UNMAPPED";
    if (info.pages[i].state == RESIDENT) state_str = "RESIDENT";
 1ee:	4b05                	li	s6,1
 1f0:	00001a97          	auipc	s5,0x1
 1f4:	950a8a93          	addi	s5,s5,-1712 # b40 <malloc+0x11c>
    if (info.pages[i].state == SWAPPED) state_str = "SWAPPED ";
 1f8:	4c09                	li	s8,2
 1fa:	00001b97          	auipc	s7,0x1
 1fe:	936b8b93          	addi	s7,s7,-1738 # b30 <malloc+0x10c>
    
    printf("0x%x | %s | %d     | %d    | %d\n",
 202:	00001a17          	auipc	s4,0x1
 206:	b0ea0a13          	addi	s4,s4,-1266 # d10 <malloc+0x2ec>
  for (int i = 0; i < info.num_pages_total && i < MAX_PAGES_INFO; i++) {
 20a:	80040993          	addi	s3,s0,-2048
 20e:	fb098993          	addi	s3,s3,-80
 212:	80098993          	addi	s3,s3,-2048
 216:	a01d                	j	23c <main+0x23c>
    printf("0x%x | %s | %d     | %d    | %d\n",
 218:	499c                	lw	a5,16(a1)
 21a:	45d8                	lw	a4,12(a1)
 21c:	4594                	lw	a3,8(a1)
 21e:	418c                	lw	a1,0(a1)
 220:	8552                	mv	a0,s4
 222:	74a000ef          	jal	96c <printf>
  for (int i = 0; i < info.num_pages_total && i < MAX_PAGES_INFO; i++) {
 226:	0019079b          	addiw	a5,s2,1 # 1001 <digits+0x299>
 22a:	893e                	mv	s2,a5
 22c:	04d1                	addi	s1,s1,20
 22e:	5ec9a703          	lw	a4,1516(s3)
 232:	02e7d263          	bge	a5,a4,256 <main+0x256>
 236:	0807a793          	slti	a5,a5,128
 23a:	cf91                	beqz	a5,256 <main+0x256>
    if (info.pages[i].state == RESIDENT) state_str = "RESIDENT";
 23c:	85a6                	mv	a1,s1
 23e:	40dc                	lw	a5,4(s1)
 240:	8656                	mv	a2,s5
 242:	fd678be3          	beq	a5,s6,218 <main+0x218>
    if (info.pages[i].state == SWAPPED) state_str = "SWAPPED ";
 246:	865e                	mv	a2,s7
 248:	fd8788e3          	beq	a5,s8,218 <main+0x218>
 24c:	00001617          	auipc	a2,0x1
 250:	8d460613          	addi	a2,a2,-1836 # b20 <malloc+0xfc>
 254:	b7d1                	j	218 <main+0x218>
           state_str,
           info.pages[i].is_dirty,
           info.pages[i].seq,
           info.pages[i].swap_slot);
  }
  printf("evicttest finished successfully\n");
 256:	00001517          	auipc	a0,0x1
 25a:	ae250513          	addi	a0,a0,-1310 # d38 <malloc+0x314>
 25e:	70e000ef          	jal	96c <printf>
  exit(0);
 262:	4501                	li	a0,0
 264:	2ba000ef          	jal	51e <exit>

0000000000000268 <start>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
start(int argc, char **argv)
{
 268:	1141                	addi	sp,sp,-16
 26a:	e406                	sd	ra,8(sp)
 26c:	e022                	sd	s0,0(sp)
 26e:	0800                	addi	s0,sp,16
  int r;
  extern int main(int argc, char **argv);
  r = main(argc, argv);
 270:	d91ff0ef          	jal	0 <main>
  exit(r);
 274:	2aa000ef          	jal	51e <exit>

0000000000000278 <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
 278:	1141                	addi	sp,sp,-16
 27a:	e406                	sd	ra,8(sp)
 27c:	e022                	sd	s0,0(sp)
 27e:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 280:	87aa                	mv	a5,a0
 282:	0585                	addi	a1,a1,1
 284:	0785                	addi	a5,a5,1
 286:	fff5c703          	lbu	a4,-1(a1)
 28a:	fee78fa3          	sb	a4,-1(a5)
 28e:	fb75                	bnez	a4,282 <strcpy+0xa>
    ;
  return os;
}
 290:	60a2                	ld	ra,8(sp)
 292:	6402                	ld	s0,0(sp)
 294:	0141                	addi	sp,sp,16
 296:	8082                	ret

0000000000000298 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 298:	1141                	addi	sp,sp,-16
 29a:	e406                	sd	ra,8(sp)
 29c:	e022                	sd	s0,0(sp)
 29e:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
 2a0:	00054783          	lbu	a5,0(a0)
 2a4:	cb91                	beqz	a5,2b8 <strcmp+0x20>
 2a6:	0005c703          	lbu	a4,0(a1)
 2aa:	00f71763          	bne	a4,a5,2b8 <strcmp+0x20>
    p++, q++;
 2ae:	0505                	addi	a0,a0,1
 2b0:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
 2b2:	00054783          	lbu	a5,0(a0)
 2b6:	fbe5                	bnez	a5,2a6 <strcmp+0xe>
  return (uchar)*p - (uchar)*q;
 2b8:	0005c503          	lbu	a0,0(a1)
}
 2bc:	40a7853b          	subw	a0,a5,a0
 2c0:	60a2                	ld	ra,8(sp)
 2c2:	6402                	ld	s0,0(sp)
 2c4:	0141                	addi	sp,sp,16
 2c6:	8082                	ret

00000000000002c8 <strlen>:

uint
strlen(const char *s)
{
 2c8:	1141                	addi	sp,sp,-16
 2ca:	e406                	sd	ra,8(sp)
 2cc:	e022                	sd	s0,0(sp)
 2ce:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 2d0:	00054783          	lbu	a5,0(a0)
 2d4:	cf91                	beqz	a5,2f0 <strlen+0x28>
 2d6:	00150793          	addi	a5,a0,1
 2da:	86be                	mv	a3,a5
 2dc:	0785                	addi	a5,a5,1
 2de:	fff7c703          	lbu	a4,-1(a5)
 2e2:	ff65                	bnez	a4,2da <strlen+0x12>
 2e4:	40a6853b          	subw	a0,a3,a0
    ;
  return n;
}
 2e8:	60a2                	ld	ra,8(sp)
 2ea:	6402                	ld	s0,0(sp)
 2ec:	0141                	addi	sp,sp,16
 2ee:	8082                	ret
  for(n = 0; s[n]; n++)
 2f0:	4501                	li	a0,0
 2f2:	bfdd                	j	2e8 <strlen+0x20>

00000000000002f4 <memset>:

void*
memset(void *dst, int c, uint n)
{
 2f4:	1141                	addi	sp,sp,-16
 2f6:	e406                	sd	ra,8(sp)
 2f8:	e022                	sd	s0,0(sp)
 2fa:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 2fc:	ca19                	beqz	a2,312 <memset+0x1e>
 2fe:	87aa                	mv	a5,a0
 300:	1602                	slli	a2,a2,0x20
 302:	9201                	srli	a2,a2,0x20
 304:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 308:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 30c:	0785                	addi	a5,a5,1
 30e:	fee79de3          	bne	a5,a4,308 <memset+0x14>
  }
  return dst;
}
 312:	60a2                	ld	ra,8(sp)
 314:	6402                	ld	s0,0(sp)
 316:	0141                	addi	sp,sp,16
 318:	8082                	ret

000000000000031a <strchr>:

char*
strchr(const char *s, char c)
{
 31a:	1141                	addi	sp,sp,-16
 31c:	e406                	sd	ra,8(sp)
 31e:	e022                	sd	s0,0(sp)
 320:	0800                	addi	s0,sp,16
  for(; *s; s++)
 322:	00054783          	lbu	a5,0(a0)
 326:	cf81                	beqz	a5,33e <strchr+0x24>
    if(*s == c)
 328:	00f58763          	beq	a1,a5,336 <strchr+0x1c>
  for(; *s; s++)
 32c:	0505                	addi	a0,a0,1
 32e:	00054783          	lbu	a5,0(a0)
 332:	fbfd                	bnez	a5,328 <strchr+0xe>
      return (char*)s;
  return 0;
 334:	4501                	li	a0,0
}
 336:	60a2                	ld	ra,8(sp)
 338:	6402                	ld	s0,0(sp)
 33a:	0141                	addi	sp,sp,16
 33c:	8082                	ret
  return 0;
 33e:	4501                	li	a0,0
 340:	bfdd                	j	336 <strchr+0x1c>

0000000000000342 <gets>:

char*
gets(char *buf, int max)
{
 342:	711d                	addi	sp,sp,-96
 344:	ec86                	sd	ra,88(sp)
 346:	e8a2                	sd	s0,80(sp)
 348:	e4a6                	sd	s1,72(sp)
 34a:	e0ca                	sd	s2,64(sp)
 34c:	fc4e                	sd	s3,56(sp)
 34e:	f852                	sd	s4,48(sp)
 350:	f456                	sd	s5,40(sp)
 352:	f05a                	sd	s6,32(sp)
 354:	ec5e                	sd	s7,24(sp)
 356:	e862                	sd	s8,16(sp)
 358:	1080                	addi	s0,sp,96
 35a:	8baa                	mv	s7,a0
 35c:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 35e:	892a                	mv	s2,a0
 360:	4481                	li	s1,0
    cc = read(0, &c, 1);
 362:	faf40b13          	addi	s6,s0,-81
 366:	4a85                	li	s5,1
  for(i=0; i+1 < max; ){
 368:	8c26                	mv	s8,s1
 36a:	0014899b          	addiw	s3,s1,1
 36e:	84ce                	mv	s1,s3
 370:	0349d463          	bge	s3,s4,398 <gets+0x56>
    cc = read(0, &c, 1);
 374:	8656                	mv	a2,s5
 376:	85da                	mv	a1,s6
 378:	4501                	li	a0,0
 37a:	1bc000ef          	jal	536 <read>
    if(cc < 1)
 37e:	00a05d63          	blez	a0,398 <gets+0x56>
      break;
    buf[i++] = c;
 382:	faf44783          	lbu	a5,-81(s0)
 386:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 38a:	0905                	addi	s2,s2,1
 38c:	ff678713          	addi	a4,a5,-10
 390:	c319                	beqz	a4,396 <gets+0x54>
 392:	17cd                	addi	a5,a5,-13
 394:	fbf1                	bnez	a5,368 <gets+0x26>
    buf[i++] = c;
 396:	8c4e                	mv	s8,s3
      break;
  }
  buf[i] = '\0';
 398:	9c5e                	add	s8,s8,s7
 39a:	000c0023          	sb	zero,0(s8)
  return buf;
}
 39e:	855e                	mv	a0,s7
 3a0:	60e6                	ld	ra,88(sp)
 3a2:	6446                	ld	s0,80(sp)
 3a4:	64a6                	ld	s1,72(sp)
 3a6:	6906                	ld	s2,64(sp)
 3a8:	79e2                	ld	s3,56(sp)
 3aa:	7a42                	ld	s4,48(sp)
 3ac:	7aa2                	ld	s5,40(sp)
 3ae:	7b02                	ld	s6,32(sp)
 3b0:	6be2                	ld	s7,24(sp)
 3b2:	6c42                	ld	s8,16(sp)
 3b4:	6125                	addi	sp,sp,96
 3b6:	8082                	ret

00000000000003b8 <stat>:

int
stat(const char *n, struct stat *st)
{
 3b8:	1101                	addi	sp,sp,-32
 3ba:	ec06                	sd	ra,24(sp)
 3bc:	e822                	sd	s0,16(sp)
 3be:	e04a                	sd	s2,0(sp)
 3c0:	1000                	addi	s0,sp,32
 3c2:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 3c4:	4581                	li	a1,0
 3c6:	198000ef          	jal	55e <open>
  if(fd < 0)
 3ca:	02054263          	bltz	a0,3ee <stat+0x36>
 3ce:	e426                	sd	s1,8(sp)
 3d0:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 3d2:	85ca                	mv	a1,s2
 3d4:	1a2000ef          	jal	576 <fstat>
 3d8:	892a                	mv	s2,a0
  close(fd);
 3da:	8526                	mv	a0,s1
 3dc:	16a000ef          	jal	546 <close>
  return r;
 3e0:	64a2                	ld	s1,8(sp)
}
 3e2:	854a                	mv	a0,s2
 3e4:	60e2                	ld	ra,24(sp)
 3e6:	6442                	ld	s0,16(sp)
 3e8:	6902                	ld	s2,0(sp)
 3ea:	6105                	addi	sp,sp,32
 3ec:	8082                	ret
    return -1;
 3ee:	57fd                	li	a5,-1
 3f0:	893e                	mv	s2,a5
 3f2:	bfc5                	j	3e2 <stat+0x2a>

00000000000003f4 <atoi>:

int
atoi(const char *s)
{
 3f4:	1141                	addi	sp,sp,-16
 3f6:	e406                	sd	ra,8(sp)
 3f8:	e022                	sd	s0,0(sp)
 3fa:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 3fc:	00054683          	lbu	a3,0(a0)
 400:	fd06879b          	addiw	a5,a3,-48
 404:	0ff7f793          	zext.b	a5,a5
 408:	4625                	li	a2,9
 40a:	02f66963          	bltu	a2,a5,43c <atoi+0x48>
 40e:	872a                	mv	a4,a0
  n = 0;
 410:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
 412:	0705                	addi	a4,a4,1
 414:	0025179b          	slliw	a5,a0,0x2
 418:	9fa9                	addw	a5,a5,a0
 41a:	0017979b          	slliw	a5,a5,0x1
 41e:	9fb5                	addw	a5,a5,a3
 420:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 424:	00074683          	lbu	a3,0(a4)
 428:	fd06879b          	addiw	a5,a3,-48
 42c:	0ff7f793          	zext.b	a5,a5
 430:	fef671e3          	bgeu	a2,a5,412 <atoi+0x1e>
  return n;
}
 434:	60a2                	ld	ra,8(sp)
 436:	6402                	ld	s0,0(sp)
 438:	0141                	addi	sp,sp,16
 43a:	8082                	ret
  n = 0;
 43c:	4501                	li	a0,0
 43e:	bfdd                	j	434 <atoi+0x40>

0000000000000440 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 440:	1141                	addi	sp,sp,-16
 442:	e406                	sd	ra,8(sp)
 444:	e022                	sd	s0,0(sp)
 446:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 448:	02b57563          	bgeu	a0,a1,472 <memmove+0x32>
    while(n-- > 0)
 44c:	00c05f63          	blez	a2,46a <memmove+0x2a>
 450:	1602                	slli	a2,a2,0x20
 452:	9201                	srli	a2,a2,0x20
 454:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 458:	872a                	mv	a4,a0
      *dst++ = *src++;
 45a:	0585                	addi	a1,a1,1
 45c:	0705                	addi	a4,a4,1
 45e:	fff5c683          	lbu	a3,-1(a1)
 462:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 466:	fee79ae3          	bne	a5,a4,45a <memmove+0x1a>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 46a:	60a2                	ld	ra,8(sp)
 46c:	6402                	ld	s0,0(sp)
 46e:	0141                	addi	sp,sp,16
 470:	8082                	ret
    while(n-- > 0)
 472:	fec05ce3          	blez	a2,46a <memmove+0x2a>
    dst += n;
 476:	00c50733          	add	a4,a0,a2
    src += n;
 47a:	95b2                	add	a1,a1,a2
 47c:	fff6079b          	addiw	a5,a2,-1
 480:	1782                	slli	a5,a5,0x20
 482:	9381                	srli	a5,a5,0x20
 484:	fff7c793          	not	a5,a5
 488:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 48a:	15fd                	addi	a1,a1,-1
 48c:	177d                	addi	a4,a4,-1
 48e:	0005c683          	lbu	a3,0(a1)
 492:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 496:	fef71ae3          	bne	a4,a5,48a <memmove+0x4a>
 49a:	bfc1                	j	46a <memmove+0x2a>

000000000000049c <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 49c:	1141                	addi	sp,sp,-16
 49e:	e406                	sd	ra,8(sp)
 4a0:	e022                	sd	s0,0(sp)
 4a2:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 4a4:	c61d                	beqz	a2,4d2 <memcmp+0x36>
 4a6:	1602                	slli	a2,a2,0x20
 4a8:	9201                	srli	a2,a2,0x20
 4aa:	00c506b3          	add	a3,a0,a2
    if (*p1 != *p2) {
 4ae:	00054783          	lbu	a5,0(a0)
 4b2:	0005c703          	lbu	a4,0(a1)
 4b6:	00e79863          	bne	a5,a4,4c6 <memcmp+0x2a>
      return *p1 - *p2;
    }
    p1++;
 4ba:	0505                	addi	a0,a0,1
    p2++;
 4bc:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 4be:	fed518e3          	bne	a0,a3,4ae <memcmp+0x12>
  }
  return 0;
 4c2:	4501                	li	a0,0
 4c4:	a019                	j	4ca <memcmp+0x2e>
      return *p1 - *p2;
 4c6:	40e7853b          	subw	a0,a5,a4
}
 4ca:	60a2                	ld	ra,8(sp)
 4cc:	6402                	ld	s0,0(sp)
 4ce:	0141                	addi	sp,sp,16
 4d0:	8082                	ret
  return 0;
 4d2:	4501                	li	a0,0
 4d4:	bfdd                	j	4ca <memcmp+0x2e>

00000000000004d6 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 4d6:	1141                	addi	sp,sp,-16
 4d8:	e406                	sd	ra,8(sp)
 4da:	e022                	sd	s0,0(sp)
 4dc:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 4de:	f63ff0ef          	jal	440 <memmove>
}
 4e2:	60a2                	ld	ra,8(sp)
 4e4:	6402                	ld	s0,0(sp)
 4e6:	0141                	addi	sp,sp,16
 4e8:	8082                	ret

00000000000004ea <sbrk>:

char *
sbrk(int n) {
 4ea:	1141                	addi	sp,sp,-16
 4ec:	e406                	sd	ra,8(sp)
 4ee:	e022                	sd	s0,0(sp)
 4f0:	0800                	addi	s0,sp,16
  return sys_sbrk(n, SBRK_EAGER);
 4f2:	4585                	li	a1,1
 4f4:	0b2000ef          	jal	5a6 <sys_sbrk>
}
 4f8:	60a2                	ld	ra,8(sp)
 4fa:	6402                	ld	s0,0(sp)
 4fc:	0141                	addi	sp,sp,16
 4fe:	8082                	ret

0000000000000500 <sbrklazy>:

char *
sbrklazy(int n) {
 500:	1141                	addi	sp,sp,-16
 502:	e406                	sd	ra,8(sp)
 504:	e022                	sd	s0,0(sp)
 506:	0800                	addi	s0,sp,16
  return sys_sbrk(n, SBRK_LAZY);
 508:	4589                	li	a1,2
 50a:	09c000ef          	jal	5a6 <sys_sbrk>
}
 50e:	60a2                	ld	ra,8(sp)
 510:	6402                	ld	s0,0(sp)
 512:	0141                	addi	sp,sp,16
 514:	8082                	ret

0000000000000516 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 516:	4885                	li	a7,1
 ecall
 518:	00000073          	ecall
 ret
 51c:	8082                	ret

000000000000051e <exit>:
.global exit
exit:
 li a7, SYS_exit
 51e:	4889                	li	a7,2
 ecall
 520:	00000073          	ecall
 ret
 524:	8082                	ret

0000000000000526 <wait>:
.global wait
wait:
 li a7, SYS_wait
 526:	488d                	li	a7,3
 ecall
 528:	00000073          	ecall
 ret
 52c:	8082                	ret

000000000000052e <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 52e:	4891                	li	a7,4
 ecall
 530:	00000073          	ecall
 ret
 534:	8082                	ret

0000000000000536 <read>:
.global read
read:
 li a7, SYS_read
 536:	4895                	li	a7,5
 ecall
 538:	00000073          	ecall
 ret
 53c:	8082                	ret

000000000000053e <write>:
.global write
write:
 li a7, SYS_write
 53e:	48c1                	li	a7,16
 ecall
 540:	00000073          	ecall
 ret
 544:	8082                	ret

0000000000000546 <close>:
.global close
close:
 li a7, SYS_close
 546:	48d5                	li	a7,21
 ecall
 548:	00000073          	ecall
 ret
 54c:	8082                	ret

000000000000054e <kill>:
.global kill
kill:
 li a7, SYS_kill
 54e:	4899                	li	a7,6
 ecall
 550:	00000073          	ecall
 ret
 554:	8082                	ret

0000000000000556 <exec>:
.global exec
exec:
 li a7, SYS_exec
 556:	489d                	li	a7,7
 ecall
 558:	00000073          	ecall
 ret
 55c:	8082                	ret

000000000000055e <open>:
.global open
open:
 li a7, SYS_open
 55e:	48bd                	li	a7,15
 ecall
 560:	00000073          	ecall
 ret
 564:	8082                	ret

0000000000000566 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 566:	48c5                	li	a7,17
 ecall
 568:	00000073          	ecall
 ret
 56c:	8082                	ret

000000000000056e <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 56e:	48c9                	li	a7,18
 ecall
 570:	00000073          	ecall
 ret
 574:	8082                	ret

0000000000000576 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 576:	48a1                	li	a7,8
 ecall
 578:	00000073          	ecall
 ret
 57c:	8082                	ret

000000000000057e <link>:
.global link
link:
 li a7, SYS_link
 57e:	48cd                	li	a7,19
 ecall
 580:	00000073          	ecall
 ret
 584:	8082                	ret

0000000000000586 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 586:	48d1                	li	a7,20
 ecall
 588:	00000073          	ecall
 ret
 58c:	8082                	ret

000000000000058e <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 58e:	48a5                	li	a7,9
 ecall
 590:	00000073          	ecall
 ret
 594:	8082                	ret

0000000000000596 <dup>:
.global dup
dup:
 li a7, SYS_dup
 596:	48a9                	li	a7,10
 ecall
 598:	00000073          	ecall
 ret
 59c:	8082                	ret

000000000000059e <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 59e:	48ad                	li	a7,11
 ecall
 5a0:	00000073          	ecall
 ret
 5a4:	8082                	ret

00000000000005a6 <sys_sbrk>:
.global sys_sbrk
sys_sbrk:
 li a7, SYS_sbrk
 5a6:	48b1                	li	a7,12
 ecall
 5a8:	00000073          	ecall
 ret
 5ac:	8082                	ret

00000000000005ae <pause>:
.global pause
pause:
 li a7, SYS_pause
 5ae:	48b5                	li	a7,13
 ecall
 5b0:	00000073          	ecall
 ret
 5b4:	8082                	ret

00000000000005b6 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 5b6:	48b9                	li	a7,14
 ecall
 5b8:	00000073          	ecall
 ret
 5bc:	8082                	ret

00000000000005be <memstat>:
.global memstat
memstat:
 li a7, SYS_memstat
 5be:	48d9                	li	a7,22
 ecall
 5c0:	00000073          	ecall
 ret
 5c4:	8082                	ret

00000000000005c6 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 5c6:	1101                	addi	sp,sp,-32
 5c8:	ec06                	sd	ra,24(sp)
 5ca:	e822                	sd	s0,16(sp)
 5cc:	1000                	addi	s0,sp,32
 5ce:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 5d2:	4605                	li	a2,1
 5d4:	fef40593          	addi	a1,s0,-17
 5d8:	f67ff0ef          	jal	53e <write>
}
 5dc:	60e2                	ld	ra,24(sp)
 5de:	6442                	ld	s0,16(sp)
 5e0:	6105                	addi	sp,sp,32
 5e2:	8082                	ret

00000000000005e4 <printint>:

static void
printint(int fd, long long xx, int base, int sgn)
{
 5e4:	715d                	addi	sp,sp,-80
 5e6:	e486                	sd	ra,72(sp)
 5e8:	e0a2                	sd	s0,64(sp)
 5ea:	f84a                	sd	s2,48(sp)
 5ec:	f44e                	sd	s3,40(sp)
 5ee:	0880                	addi	s0,sp,80
 5f0:	892a                	mv	s2,a0
  char buf[20];
  int i, neg;
  unsigned long long x;

  neg = 0;
  if(sgn && xx < 0){
 5f2:	c6d1                	beqz	a3,67e <printint+0x9a>
 5f4:	0805d563          	bgez	a1,67e <printint+0x9a>
    neg = 1;
    x = -xx;
 5f8:	40b005b3          	neg	a1,a1
    neg = 1;
 5fc:	4305                	li	t1,1
  } else {
    x = xx;
  }

  i = 0;
 5fe:	fb840993          	addi	s3,s0,-72
  neg = 0;
 602:	86ce                	mv	a3,s3
  i = 0;
 604:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 606:	00000817          	auipc	a6,0x0
 60a:	76280813          	addi	a6,a6,1890 # d68 <digits>
 60e:	88ba                	mv	a7,a4
 610:	0017051b          	addiw	a0,a4,1
 614:	872a                	mv	a4,a0
 616:	02c5f7b3          	remu	a5,a1,a2
 61a:	97c2                	add	a5,a5,a6
 61c:	0007c783          	lbu	a5,0(a5)
 620:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 624:	87ae                	mv	a5,a1
 626:	02c5d5b3          	divu	a1,a1,a2
 62a:	0685                	addi	a3,a3,1
 62c:	fec7f1e3          	bgeu	a5,a2,60e <printint+0x2a>
  if(neg)
 630:	00030c63          	beqz	t1,648 <printint+0x64>
    buf[i++] = '-';
 634:	fd050793          	addi	a5,a0,-48
 638:	00878533          	add	a0,a5,s0
 63c:	02d00793          	li	a5,45
 640:	fef50423          	sb	a5,-24(a0)
 644:	0028871b          	addiw	a4,a7,2

  while(--i >= 0)
 648:	02e05563          	blez	a4,672 <printint+0x8e>
 64c:	fc26                	sd	s1,56(sp)
 64e:	377d                	addiw	a4,a4,-1
 650:	00e984b3          	add	s1,s3,a4
 654:	19fd                	addi	s3,s3,-1
 656:	99ba                	add	s3,s3,a4
 658:	1702                	slli	a4,a4,0x20
 65a:	9301                	srli	a4,a4,0x20
 65c:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 660:	0004c583          	lbu	a1,0(s1)
 664:	854a                	mv	a0,s2
 666:	f61ff0ef          	jal	5c6 <putc>
  while(--i >= 0)
 66a:	14fd                	addi	s1,s1,-1
 66c:	ff349ae3          	bne	s1,s3,660 <printint+0x7c>
 670:	74e2                	ld	s1,56(sp)
}
 672:	60a6                	ld	ra,72(sp)
 674:	6406                	ld	s0,64(sp)
 676:	7942                	ld	s2,48(sp)
 678:	79a2                	ld	s3,40(sp)
 67a:	6161                	addi	sp,sp,80
 67c:	8082                	ret
  neg = 0;
 67e:	4301                	li	t1,0
 680:	bfbd                	j	5fe <printint+0x1a>

0000000000000682 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %c, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 682:	711d                	addi	sp,sp,-96
 684:	ec86                	sd	ra,88(sp)
 686:	e8a2                	sd	s0,80(sp)
 688:	e4a6                	sd	s1,72(sp)
 68a:	1080                	addi	s0,sp,96
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 68c:	0005c483          	lbu	s1,0(a1)
 690:	22048363          	beqz	s1,8b6 <vprintf+0x234>
 694:	e0ca                	sd	s2,64(sp)
 696:	fc4e                	sd	s3,56(sp)
 698:	f852                	sd	s4,48(sp)
 69a:	f456                	sd	s5,40(sp)
 69c:	f05a                	sd	s6,32(sp)
 69e:	ec5e                	sd	s7,24(sp)
 6a0:	e862                	sd	s8,16(sp)
 6a2:	8b2a                	mv	s6,a0
 6a4:	8a2e                	mv	s4,a1
 6a6:	8bb2                	mv	s7,a2
  state = 0;
 6a8:	4981                	li	s3,0
  for(i = 0; fmt[i]; i++){
 6aa:	4901                	li	s2,0
 6ac:	4701                	li	a4,0
      if(c0 == '%'){
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if(state == '%'){
 6ae:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if(c0) c1 = fmt[i+1] & 0xff;
      if(c1) c2 = fmt[i+2] & 0xff;
      if(c0 == 'd'){
 6b2:	06400c13          	li	s8,100
 6b6:	a00d                	j	6d8 <vprintf+0x56>
        putc(fd, c0);
 6b8:	85a6                	mv	a1,s1
 6ba:	855a                	mv	a0,s6
 6bc:	f0bff0ef          	jal	5c6 <putc>
 6c0:	a019                	j	6c6 <vprintf+0x44>
    } else if(state == '%'){
 6c2:	03598363          	beq	s3,s5,6e8 <vprintf+0x66>
  for(i = 0; fmt[i]; i++){
 6c6:	0019079b          	addiw	a5,s2,1
 6ca:	893e                	mv	s2,a5
 6cc:	873e                	mv	a4,a5
 6ce:	97d2                	add	a5,a5,s4
 6d0:	0007c483          	lbu	s1,0(a5)
 6d4:	1c048a63          	beqz	s1,8a8 <vprintf+0x226>
    c0 = fmt[i] & 0xff;
 6d8:	0004879b          	sext.w	a5,s1
    if(state == 0){
 6dc:	fe0993e3          	bnez	s3,6c2 <vprintf+0x40>
      if(c0 == '%'){
 6e0:	fd579ce3          	bne	a5,s5,6b8 <vprintf+0x36>
        state = '%';
 6e4:	89be                	mv	s3,a5
 6e6:	b7c5                	j	6c6 <vprintf+0x44>
      if(c0) c1 = fmt[i+1] & 0xff;
 6e8:	00ea06b3          	add	a3,s4,a4
 6ec:	0016c603          	lbu	a2,1(a3)
      if(c1) c2 = fmt[i+2] & 0xff;
 6f0:	1c060863          	beqz	a2,8c0 <vprintf+0x23e>
      if(c0 == 'd'){
 6f4:	03878763          	beq	a5,s8,722 <vprintf+0xa0>
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c0 == 'l' && c1 == 'd'){
 6f8:	f9478693          	addi	a3,a5,-108
 6fc:	0016b693          	seqz	a3,a3
 700:	f9c60593          	addi	a1,a2,-100
 704:	e99d                	bnez	a1,73a <vprintf+0xb8>
 706:	ca95                	beqz	a3,73a <vprintf+0xb8>
        printint(fd, va_arg(ap, uint64), 10, 1);
 708:	008b8493          	addi	s1,s7,8
 70c:	4685                	li	a3,1
 70e:	4629                	li	a2,10
 710:	000bb583          	ld	a1,0(s7)
 714:	855a                	mv	a0,s6
 716:	ecfff0ef          	jal	5e4 <printint>
        i += 1;
 71a:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 10, 1);
 71c:	8ba6                	mv	s7,s1
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c0);
      }

      state = 0;
 71e:	4981                	li	s3,0
 720:	b75d                	j	6c6 <vprintf+0x44>
        printint(fd, va_arg(ap, int), 10, 1);
 722:	008b8493          	addi	s1,s7,8
 726:	4685                	li	a3,1
 728:	4629                	li	a2,10
 72a:	000ba583          	lw	a1,0(s7)
 72e:	855a                	mv	a0,s6
 730:	eb5ff0ef          	jal	5e4 <printint>
 734:	8ba6                	mv	s7,s1
      state = 0;
 736:	4981                	li	s3,0
 738:	b779                	j	6c6 <vprintf+0x44>
      if(c1) c2 = fmt[i+2] & 0xff;
 73a:	9752                	add	a4,a4,s4
 73c:	00274583          	lbu	a1,2(a4)
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 740:	f9460713          	addi	a4,a2,-108
 744:	00173713          	seqz	a4,a4
 748:	8f75                	and	a4,a4,a3
 74a:	f9c58513          	addi	a0,a1,-100
 74e:	18051363          	bnez	a0,8d4 <vprintf+0x252>
 752:	18070163          	beqz	a4,8d4 <vprintf+0x252>
        printint(fd, va_arg(ap, uint64), 10, 1);
 756:	008b8493          	addi	s1,s7,8
 75a:	4685                	li	a3,1
 75c:	4629                	li	a2,10
 75e:	000bb583          	ld	a1,0(s7)
 762:	855a                	mv	a0,s6
 764:	e81ff0ef          	jal	5e4 <printint>
        i += 2;
 768:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 10, 1);
 76a:	8ba6                	mv	s7,s1
      state = 0;
 76c:	4981                	li	s3,0
        i += 2;
 76e:	bfa1                	j	6c6 <vprintf+0x44>
        printint(fd, va_arg(ap, uint32), 10, 0);
 770:	008b8493          	addi	s1,s7,8
 774:	4681                	li	a3,0
 776:	4629                	li	a2,10
 778:	000be583          	lwu	a1,0(s7)
 77c:	855a                	mv	a0,s6
 77e:	e67ff0ef          	jal	5e4 <printint>
 782:	8ba6                	mv	s7,s1
      state = 0;
 784:	4981                	li	s3,0
 786:	b781                	j	6c6 <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 10, 0);
 788:	008b8493          	addi	s1,s7,8
 78c:	4681                	li	a3,0
 78e:	4629                	li	a2,10
 790:	000bb583          	ld	a1,0(s7)
 794:	855a                	mv	a0,s6
 796:	e4fff0ef          	jal	5e4 <printint>
        i += 1;
 79a:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 10, 0);
 79c:	8ba6                	mv	s7,s1
      state = 0;
 79e:	4981                	li	s3,0
 7a0:	b71d                	j	6c6 <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 10, 0);
 7a2:	008b8493          	addi	s1,s7,8
 7a6:	4681                	li	a3,0
 7a8:	4629                	li	a2,10
 7aa:	000bb583          	ld	a1,0(s7)
 7ae:	855a                	mv	a0,s6
 7b0:	e35ff0ef          	jal	5e4 <printint>
        i += 2;
 7b4:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 10, 0);
 7b6:	8ba6                	mv	s7,s1
      state = 0;
 7b8:	4981                	li	s3,0
        i += 2;
 7ba:	b731                	j	6c6 <vprintf+0x44>
        printint(fd, va_arg(ap, uint32), 16, 0);
 7bc:	008b8493          	addi	s1,s7,8
 7c0:	4681                	li	a3,0
 7c2:	4641                	li	a2,16
 7c4:	000be583          	lwu	a1,0(s7)
 7c8:	855a                	mv	a0,s6
 7ca:	e1bff0ef          	jal	5e4 <printint>
 7ce:	8ba6                	mv	s7,s1
      state = 0;
 7d0:	4981                	li	s3,0
 7d2:	bdd5                	j	6c6 <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 16, 0);
 7d4:	008b8493          	addi	s1,s7,8
 7d8:	4681                	li	a3,0
 7da:	4641                	li	a2,16
 7dc:	000bb583          	ld	a1,0(s7)
 7e0:	855a                	mv	a0,s6
 7e2:	e03ff0ef          	jal	5e4 <printint>
        i += 1;
 7e6:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 16, 0);
 7e8:	8ba6                	mv	s7,s1
      state = 0;
 7ea:	4981                	li	s3,0
 7ec:	bde9                	j	6c6 <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 16, 0);
 7ee:	008b8493          	addi	s1,s7,8
 7f2:	4681                	li	a3,0
 7f4:	4641                	li	a2,16
 7f6:	000bb583          	ld	a1,0(s7)
 7fa:	855a                	mv	a0,s6
 7fc:	de9ff0ef          	jal	5e4 <printint>
        i += 2;
 800:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 16, 0);
 802:	8ba6                	mv	s7,s1
      state = 0;
 804:	4981                	li	s3,0
        i += 2;
 806:	b5c1                	j	6c6 <vprintf+0x44>
 808:	e466                	sd	s9,8(sp)
        printptr(fd, va_arg(ap, uint64));
 80a:	008b8793          	addi	a5,s7,8
 80e:	8cbe                	mv	s9,a5
 810:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 814:	03000593          	li	a1,48
 818:	855a                	mv	a0,s6
 81a:	dadff0ef          	jal	5c6 <putc>
  putc(fd, 'x');
 81e:	07800593          	li	a1,120
 822:	855a                	mv	a0,s6
 824:	da3ff0ef          	jal	5c6 <putc>
 828:	44c1                	li	s1,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 82a:	00000b97          	auipc	s7,0x0
 82e:	53eb8b93          	addi	s7,s7,1342 # d68 <digits>
 832:	03c9d793          	srli	a5,s3,0x3c
 836:	97de                	add	a5,a5,s7
 838:	0007c583          	lbu	a1,0(a5)
 83c:	855a                	mv	a0,s6
 83e:	d89ff0ef          	jal	5c6 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 842:	0992                	slli	s3,s3,0x4
 844:	34fd                	addiw	s1,s1,-1
 846:	f4f5                	bnez	s1,832 <vprintf+0x1b0>
        printptr(fd, va_arg(ap, uint64));
 848:	8be6                	mv	s7,s9
      state = 0;
 84a:	4981                	li	s3,0
 84c:	6ca2                	ld	s9,8(sp)
 84e:	bda5                	j	6c6 <vprintf+0x44>
        putc(fd, va_arg(ap, uint32));
 850:	008b8493          	addi	s1,s7,8
 854:	000bc583          	lbu	a1,0(s7)
 858:	855a                	mv	a0,s6
 85a:	d6dff0ef          	jal	5c6 <putc>
 85e:	8ba6                	mv	s7,s1
      state = 0;
 860:	4981                	li	s3,0
 862:	b595                	j	6c6 <vprintf+0x44>
        if((s = va_arg(ap, char*)) == 0)
 864:	008b8993          	addi	s3,s7,8
 868:	000bb483          	ld	s1,0(s7)
 86c:	cc91                	beqz	s1,888 <vprintf+0x206>
        for(; *s; s++)
 86e:	0004c583          	lbu	a1,0(s1)
 872:	c985                	beqz	a1,8a2 <vprintf+0x220>
          putc(fd, *s);
 874:	855a                	mv	a0,s6
 876:	d51ff0ef          	jal	5c6 <putc>
        for(; *s; s++)
 87a:	0485                	addi	s1,s1,1
 87c:	0004c583          	lbu	a1,0(s1)
 880:	f9f5                	bnez	a1,874 <vprintf+0x1f2>
        if((s = va_arg(ap, char*)) == 0)
 882:	8bce                	mv	s7,s3
      state = 0;
 884:	4981                	li	s3,0
 886:	b581                	j	6c6 <vprintf+0x44>
          s = "(null)";
 888:	00000497          	auipc	s1,0x0
 88c:	4d848493          	addi	s1,s1,1240 # d60 <malloc+0x33c>
        for(; *s; s++)
 890:	02800593          	li	a1,40
 894:	b7c5                	j	874 <vprintf+0x1f2>
        putc(fd, '%');
 896:	85be                	mv	a1,a5
 898:	855a                	mv	a0,s6
 89a:	d2dff0ef          	jal	5c6 <putc>
      state = 0;
 89e:	4981                	li	s3,0
 8a0:	b51d                	j	6c6 <vprintf+0x44>
        if((s = va_arg(ap, char*)) == 0)
 8a2:	8bce                	mv	s7,s3
      state = 0;
 8a4:	4981                	li	s3,0
 8a6:	b505                	j	6c6 <vprintf+0x44>
 8a8:	6906                	ld	s2,64(sp)
 8aa:	79e2                	ld	s3,56(sp)
 8ac:	7a42                	ld	s4,48(sp)
 8ae:	7aa2                	ld	s5,40(sp)
 8b0:	7b02                	ld	s6,32(sp)
 8b2:	6be2                	ld	s7,24(sp)
 8b4:	6c42                	ld	s8,16(sp)
    }
  }
}
 8b6:	60e6                	ld	ra,88(sp)
 8b8:	6446                	ld	s0,80(sp)
 8ba:	64a6                	ld	s1,72(sp)
 8bc:	6125                	addi	sp,sp,96
 8be:	8082                	ret
      if(c0 == 'd'){
 8c0:	06400713          	li	a4,100
 8c4:	e4e78fe3          	beq	a5,a4,722 <vprintf+0xa0>
      } else if(c0 == 'l' && c1 == 'd'){
 8c8:	f9478693          	addi	a3,a5,-108
 8cc:	0016b693          	seqz	a3,a3
      c1 = c2 = 0;
 8d0:	85b2                	mv	a1,a2
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 8d2:	4701                	li	a4,0
      } else if(c0 == 'u'){
 8d4:	07500513          	li	a0,117
 8d8:	e8a78ce3          	beq	a5,a0,770 <vprintf+0xee>
      } else if(c0 == 'l' && c1 == 'u'){
 8dc:	f8b60513          	addi	a0,a2,-117
 8e0:	e119                	bnez	a0,8e6 <vprintf+0x264>
 8e2:	ea0693e3          	bnez	a3,788 <vprintf+0x106>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
 8e6:	f8b58513          	addi	a0,a1,-117
 8ea:	e119                	bnez	a0,8f0 <vprintf+0x26e>
 8ec:	ea071be3          	bnez	a4,7a2 <vprintf+0x120>
      } else if(c0 == 'x'){
 8f0:	07800513          	li	a0,120
 8f4:	eca784e3          	beq	a5,a0,7bc <vprintf+0x13a>
      } else if(c0 == 'l' && c1 == 'x'){
 8f8:	f8860613          	addi	a2,a2,-120
 8fc:	e219                	bnez	a2,902 <vprintf+0x280>
 8fe:	ec069be3          	bnez	a3,7d4 <vprintf+0x152>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
 902:	f8858593          	addi	a1,a1,-120
 906:	e199                	bnez	a1,90c <vprintf+0x28a>
 908:	ee0713e3          	bnez	a4,7ee <vprintf+0x16c>
      } else if(c0 == 'p'){
 90c:	07000713          	li	a4,112
 910:	eee78ce3          	beq	a5,a4,808 <vprintf+0x186>
      } else if(c0 == 'c'){
 914:	06300713          	li	a4,99
 918:	f2e78ce3          	beq	a5,a4,850 <vprintf+0x1ce>
      } else if(c0 == 's'){
 91c:	07300713          	li	a4,115
 920:	f4e782e3          	beq	a5,a4,864 <vprintf+0x1e2>
      } else if(c0 == '%'){
 924:	02500713          	li	a4,37
 928:	f6e787e3          	beq	a5,a4,896 <vprintf+0x214>
        putc(fd, '%');
 92c:	02500593          	li	a1,37
 930:	855a                	mv	a0,s6
 932:	c95ff0ef          	jal	5c6 <putc>
        putc(fd, c0);
 936:	85a6                	mv	a1,s1
 938:	855a                	mv	a0,s6
 93a:	c8dff0ef          	jal	5c6 <putc>
      state = 0;
 93e:	4981                	li	s3,0
 940:	b359                	j	6c6 <vprintf+0x44>

0000000000000942 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 942:	715d                	addi	sp,sp,-80
 944:	ec06                	sd	ra,24(sp)
 946:	e822                	sd	s0,16(sp)
 948:	1000                	addi	s0,sp,32
 94a:	e010                	sd	a2,0(s0)
 94c:	e414                	sd	a3,8(s0)
 94e:	e818                	sd	a4,16(s0)
 950:	ec1c                	sd	a5,24(s0)
 952:	03043023          	sd	a6,32(s0)
 956:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 95a:	8622                	mv	a2,s0
 95c:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 960:	d23ff0ef          	jal	682 <vprintf>
}
 964:	60e2                	ld	ra,24(sp)
 966:	6442                	ld	s0,16(sp)
 968:	6161                	addi	sp,sp,80
 96a:	8082                	ret

000000000000096c <printf>:

void
printf(const char *fmt, ...)
{
 96c:	711d                	addi	sp,sp,-96
 96e:	ec06                	sd	ra,24(sp)
 970:	e822                	sd	s0,16(sp)
 972:	1000                	addi	s0,sp,32
 974:	e40c                	sd	a1,8(s0)
 976:	e810                	sd	a2,16(s0)
 978:	ec14                	sd	a3,24(s0)
 97a:	f018                	sd	a4,32(s0)
 97c:	f41c                	sd	a5,40(s0)
 97e:	03043823          	sd	a6,48(s0)
 982:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 986:	00840613          	addi	a2,s0,8
 98a:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 98e:	85aa                	mv	a1,a0
 990:	4505                	li	a0,1
 992:	cf1ff0ef          	jal	682 <vprintf>
}
 996:	60e2                	ld	ra,24(sp)
 998:	6442                	ld	s0,16(sp)
 99a:	6125                	addi	sp,sp,96
 99c:	8082                	ret

000000000000099e <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 99e:	1141                	addi	sp,sp,-16
 9a0:	e406                	sd	ra,8(sp)
 9a2:	e022                	sd	s0,0(sp)
 9a4:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 9a6:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 9aa:	00001797          	auipc	a5,0x1
 9ae:	6567b783          	ld	a5,1622(a5) # 2000 <freep>
 9b2:	a039                	j	9c0 <free+0x22>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 9b4:	6398                	ld	a4,0(a5)
 9b6:	00e7e463          	bltu	a5,a4,9be <free+0x20>
 9ba:	00e6ea63          	bltu	a3,a4,9ce <free+0x30>
{
 9be:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 9c0:	fed7fae3          	bgeu	a5,a3,9b4 <free+0x16>
 9c4:	6398                	ld	a4,0(a5)
 9c6:	00e6e463          	bltu	a3,a4,9ce <free+0x30>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 9ca:	fee7eae3          	bltu	a5,a4,9be <free+0x20>
      break;
  if(bp + bp->s.size == p->s.ptr){
 9ce:	ff852583          	lw	a1,-8(a0)
 9d2:	6390                	ld	a2,0(a5)
 9d4:	02059813          	slli	a6,a1,0x20
 9d8:	01c85713          	srli	a4,a6,0x1c
 9dc:	9736                	add	a4,a4,a3
 9de:	02e60563          	beq	a2,a4,a08 <free+0x6a>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
 9e2:	fec53823          	sd	a2,-16(a0)
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
 9e6:	4790                	lw	a2,8(a5)
 9e8:	02061593          	slli	a1,a2,0x20
 9ec:	01c5d713          	srli	a4,a1,0x1c
 9f0:	973e                	add	a4,a4,a5
 9f2:	02e68263          	beq	a3,a4,a16 <free+0x78>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
 9f6:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 9f8:	00001717          	auipc	a4,0x1
 9fc:	60f73423          	sd	a5,1544(a4) # 2000 <freep>
}
 a00:	60a2                	ld	ra,8(sp)
 a02:	6402                	ld	s0,0(sp)
 a04:	0141                	addi	sp,sp,16
 a06:	8082                	ret
    bp->s.size += p->s.ptr->s.size;
 a08:	4618                	lw	a4,8(a2)
 a0a:	9f2d                	addw	a4,a4,a1
 a0c:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 a10:	6398                	ld	a4,0(a5)
 a12:	6310                	ld	a2,0(a4)
 a14:	b7f9                	j	9e2 <free+0x44>
    p->s.size += bp->s.size;
 a16:	ff852703          	lw	a4,-8(a0)
 a1a:	9f31                	addw	a4,a4,a2
 a1c:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 a1e:	ff053683          	ld	a3,-16(a0)
 a22:	bfd1                	j	9f6 <free+0x58>

0000000000000a24 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 a24:	7139                	addi	sp,sp,-64
 a26:	fc06                	sd	ra,56(sp)
 a28:	f822                	sd	s0,48(sp)
 a2a:	f04a                	sd	s2,32(sp)
 a2c:	ec4e                	sd	s3,24(sp)
 a2e:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 a30:	02051993          	slli	s3,a0,0x20
 a34:	0209d993          	srli	s3,s3,0x20
 a38:	09bd                	addi	s3,s3,15
 a3a:	0049d993          	srli	s3,s3,0x4
 a3e:	2985                	addiw	s3,s3,1
 a40:	894e                	mv	s2,s3
  if((prevp = freep) == 0){
 a42:	00001517          	auipc	a0,0x1
 a46:	5be53503          	ld	a0,1470(a0) # 2000 <freep>
 a4a:	c905                	beqz	a0,a7a <malloc+0x56>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 a4c:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 a4e:	4798                	lw	a4,8(a5)
 a50:	09377663          	bgeu	a4,s3,adc <malloc+0xb8>
 a54:	f426                	sd	s1,40(sp)
 a56:	e852                	sd	s4,16(sp)
 a58:	e456                	sd	s5,8(sp)
 a5a:	e05a                	sd	s6,0(sp)
  if(nu < 4096)
 a5c:	8a4e                	mv	s4,s3
 a5e:	6705                	lui	a4,0x1
 a60:	00e9f363          	bgeu	s3,a4,a66 <malloc+0x42>
 a64:	6a05                	lui	s4,0x1
 a66:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 a6a:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 a6e:	00001497          	auipc	s1,0x1
 a72:	59248493          	addi	s1,s1,1426 # 2000 <freep>
  if(p == SBRK_ERROR)
 a76:	5afd                	li	s5,-1
 a78:	a83d                	j	ab6 <malloc+0x92>
 a7a:	f426                	sd	s1,40(sp)
 a7c:	e852                	sd	s4,16(sp)
 a7e:	e456                	sd	s5,8(sp)
 a80:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
 a82:	00001797          	auipc	a5,0x1
 a86:	58e78793          	addi	a5,a5,1422 # 2010 <base>
 a8a:	00001717          	auipc	a4,0x1
 a8e:	56f73b23          	sd	a5,1398(a4) # 2000 <freep>
 a92:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 a94:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 a98:	b7d1                	j	a5c <malloc+0x38>
        prevp->s.ptr = p->s.ptr;
 a9a:	6398                	ld	a4,0(a5)
 a9c:	e118                	sd	a4,0(a0)
 a9e:	a899                	j	af4 <malloc+0xd0>
  hp->s.size = nu;
 aa0:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 aa4:	0541                	addi	a0,a0,16
 aa6:	ef9ff0ef          	jal	99e <free>
  return freep;
 aaa:	6088                	ld	a0,0(s1)
      if((p = morecore(nunits)) == 0)
 aac:	c125                	beqz	a0,b0c <malloc+0xe8>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 aae:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 ab0:	4798                	lw	a4,8(a5)
 ab2:	03277163          	bgeu	a4,s2,ad4 <malloc+0xb0>
    if(p == freep)
 ab6:	6098                	ld	a4,0(s1)
 ab8:	853e                	mv	a0,a5
 aba:	fef71ae3          	bne	a4,a5,aae <malloc+0x8a>
  p = sbrk(nu * sizeof(Header));
 abe:	8552                	mv	a0,s4
 ac0:	a2bff0ef          	jal	4ea <sbrk>
  if(p == SBRK_ERROR)
 ac4:	fd551ee3          	bne	a0,s5,aa0 <malloc+0x7c>
        return 0;
 ac8:	4501                	li	a0,0
 aca:	74a2                	ld	s1,40(sp)
 acc:	6a42                	ld	s4,16(sp)
 ace:	6aa2                	ld	s5,8(sp)
 ad0:	6b02                	ld	s6,0(sp)
 ad2:	a03d                	j	b00 <malloc+0xdc>
 ad4:	74a2                	ld	s1,40(sp)
 ad6:	6a42                	ld	s4,16(sp)
 ad8:	6aa2                	ld	s5,8(sp)
 ada:	6b02                	ld	s6,0(sp)
      if(p->s.size == nunits)
 adc:	fae90fe3          	beq	s2,a4,a9a <malloc+0x76>
        p->s.size -= nunits;
 ae0:	4137073b          	subw	a4,a4,s3
 ae4:	c798                	sw	a4,8(a5)
        p += p->s.size;
 ae6:	02071693          	slli	a3,a4,0x20
 aea:	01c6d713          	srli	a4,a3,0x1c
 aee:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 af0:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 af4:	00001717          	auipc	a4,0x1
 af8:	50a73623          	sd	a0,1292(a4) # 2000 <freep>
      return (void*)(p + 1);
 afc:	01078513          	addi	a0,a5,16
  }
}
 b00:	70e2                	ld	ra,56(sp)
 b02:	7442                	ld	s0,48(sp)
 b04:	7902                	ld	s2,32(sp)
 b06:	69e2                	ld	s3,24(sp)
 b08:	6121                	addi	sp,sp,64
 b0a:	8082                	ret
 b0c:	74a2                	ld	s1,40(sp)
 b0e:	6a42                	ld	s4,16(sp)
 b10:	6aa2                	ld	s5,8(sp)
 b12:	6b02                	ld	s6,0(sp)
 b14:	b7f5                	j	b00 <malloc+0xdc>
