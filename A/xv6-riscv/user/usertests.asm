
user/_usertests:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <copyinstr1>:
}

// what if you pass ridiculous string pointers to system calls?
void
copyinstr1(char *s)
{
       0:	711d                	addi	sp,sp,-96
       2:	ec86                	sd	ra,88(sp)
       4:	e8a2                	sd	s0,80(sp)
       6:	e4a6                	sd	s1,72(sp)
       8:	e0ca                	sd	s2,64(sp)
       a:	fc4e                	sd	s3,56(sp)
       c:	f852                	sd	s4,48(sp)
       e:	1080                	addi	s0,sp,96
  uint64 addrs[] = { 0x80000000LL, 0x3fffffe000, 0x3ffffff000, 0x4000000000,
      10:	00008797          	auipc	a5,0x8
      14:	b4878793          	addi	a5,a5,-1208 # 7b58 <malloc+0x264c>
      18:	638c                	ld	a1,0(a5)
      1a:	6790                	ld	a2,8(a5)
      1c:	6b94                	ld	a3,16(a5)
      1e:	6f98                	ld	a4,24(a5)
      20:	fab43423          	sd	a1,-88(s0)
      24:	fac43823          	sd	a2,-80(s0)
      28:	fad43c23          	sd	a3,-72(s0)
      2c:	fce43023          	sd	a4,-64(s0)
      30:	739c                	ld	a5,32(a5)
      32:	fcf43423          	sd	a5,-56(s0)
                     0xffffffffffffffff };

  for(int ai = 0; ai < sizeof(addrs)/sizeof(addrs[0]); ai++){
      36:	fa840493          	addi	s1,s0,-88
      3a:	fd040a13          	addi	s4,s0,-48
    uint64 addr = addrs[ai];

    int fd = open((char *)addr, O_CREATE|O_WRONLY);
      3e:	20100993          	li	s3,513
      42:	0004b903          	ld	s2,0(s1)
      46:	85ce                	mv	a1,s3
      48:	854a                	mv	a0,s2
      4a:	7fd040ef          	jal	5046 <open>
    if(fd >= 0){
      4e:	00055d63          	bgez	a0,68 <copyinstr1+0x68>
  for(int ai = 0; ai < sizeof(addrs)/sizeof(addrs[0]); ai++){
      52:	04a1                	addi	s1,s1,8
      54:	ff4497e3          	bne	s1,s4,42 <copyinstr1+0x42>
      printf("open(%p) returned %d, not -1\n", (void*)addr, fd);
      exit(1);
    }
  }
}
      58:	60e6                	ld	ra,88(sp)
      5a:	6446                	ld	s0,80(sp)
      5c:	64a6                	ld	s1,72(sp)
      5e:	6906                	ld	s2,64(sp)
      60:	79e2                	ld	s3,56(sp)
      62:	7a42                	ld	s4,48(sp)
      64:	6125                	addi	sp,sp,96
      66:	8082                	ret
      printf("open(%p) returned %d, not -1\n", (void*)addr, fd);
      68:	862a                	mv	a2,a0
      6a:	85ca                	mv	a1,s2
      6c:	00005517          	auipc	a0,0x5
      70:	59450513          	addi	a0,a0,1428 # 5600 <malloc+0xf4>
      74:	3e0050ef          	jal	5454 <printf>
      exit(1);
      78:	4505                	li	a0,1
      7a:	78d040ef          	jal	5006 <exit>

000000000000007e <bsstest>:
void
bsstest(char *s)
{
  int i;

  for(i = 0; i < sizeof(uninit); i++){
      7e:	0000b797          	auipc	a5,0xb
      82:	4fa78793          	addi	a5,a5,1274 # b578 <uninit>
      86:	0000e697          	auipc	a3,0xe
      8a:	c0268693          	addi	a3,a3,-1022 # dc88 <buf>
    if(uninit[i] != '\0'){
      8e:	0007c703          	lbu	a4,0(a5)
      92:	e709                	bnez	a4,9c <bsstest+0x1e>
  for(i = 0; i < sizeof(uninit); i++){
      94:	0785                	addi	a5,a5,1
      96:	fed79ce3          	bne	a5,a3,8e <bsstest+0x10>
      9a:	8082                	ret
{
      9c:	1141                	addi	sp,sp,-16
      9e:	e406                	sd	ra,8(sp)
      a0:	e022                	sd	s0,0(sp)
      a2:	0800                	addi	s0,sp,16
      printf("%s: bss test failed\n", s);
      a4:	85aa                	mv	a1,a0
      a6:	00005517          	auipc	a0,0x5
      aa:	57a50513          	addi	a0,a0,1402 # 5620 <malloc+0x114>
      ae:	3a6050ef          	jal	5454 <printf>
      exit(1);
      b2:	4505                	li	a0,1
      b4:	753040ef          	jal	5006 <exit>

00000000000000b8 <opentest>:
{
      b8:	1101                	addi	sp,sp,-32
      ba:	ec06                	sd	ra,24(sp)
      bc:	e822                	sd	s0,16(sp)
      be:	e426                	sd	s1,8(sp)
      c0:	1000                	addi	s0,sp,32
      c2:	84aa                	mv	s1,a0
  fd = open("echo", 0);
      c4:	4581                	li	a1,0
      c6:	00005517          	auipc	a0,0x5
      ca:	57250513          	addi	a0,a0,1394 # 5638 <malloc+0x12c>
      ce:	779040ef          	jal	5046 <open>
  if(fd < 0){
      d2:	02054263          	bltz	a0,f6 <opentest+0x3e>
  close(fd);
      d6:	759040ef          	jal	502e <close>
  fd = open("doesnotexist", 0);
      da:	4581                	li	a1,0
      dc:	00005517          	auipc	a0,0x5
      e0:	57c50513          	addi	a0,a0,1404 # 5658 <malloc+0x14c>
      e4:	763040ef          	jal	5046 <open>
  if(fd >= 0){
      e8:	02055163          	bgez	a0,10a <opentest+0x52>
}
      ec:	60e2                	ld	ra,24(sp)
      ee:	6442                	ld	s0,16(sp)
      f0:	64a2                	ld	s1,8(sp)
      f2:	6105                	addi	sp,sp,32
      f4:	8082                	ret
    printf("%s: open echo failed!\n", s);
      f6:	85a6                	mv	a1,s1
      f8:	00005517          	auipc	a0,0x5
      fc:	54850513          	addi	a0,a0,1352 # 5640 <malloc+0x134>
     100:	354050ef          	jal	5454 <printf>
    exit(1);
     104:	4505                	li	a0,1
     106:	701040ef          	jal	5006 <exit>
    printf("%s: open doesnotexist succeeded!\n", s);
     10a:	85a6                	mv	a1,s1
     10c:	00005517          	auipc	a0,0x5
     110:	55c50513          	addi	a0,a0,1372 # 5668 <malloc+0x15c>
     114:	340050ef          	jal	5454 <printf>
    exit(1);
     118:	4505                	li	a0,1
     11a:	6ed040ef          	jal	5006 <exit>

000000000000011e <truncate2>:
{
     11e:	7179                	addi	sp,sp,-48
     120:	f406                	sd	ra,40(sp)
     122:	f022                	sd	s0,32(sp)
     124:	ec26                	sd	s1,24(sp)
     126:	e84a                	sd	s2,16(sp)
     128:	e44e                	sd	s3,8(sp)
     12a:	1800                	addi	s0,sp,48
     12c:	89aa                	mv	s3,a0
  unlink("truncfile");
     12e:	00005517          	auipc	a0,0x5
     132:	56250513          	addi	a0,a0,1378 # 5690 <malloc+0x184>
     136:	721040ef          	jal	5056 <unlink>
  int fd1 = open("truncfile", O_CREATE|O_TRUNC|O_WRONLY);
     13a:	60100593          	li	a1,1537
     13e:	00005517          	auipc	a0,0x5
     142:	55250513          	addi	a0,a0,1362 # 5690 <malloc+0x184>
     146:	701040ef          	jal	5046 <open>
     14a:	84aa                	mv	s1,a0
  write(fd1, "abcd", 4);
     14c:	4611                	li	a2,4
     14e:	00005597          	auipc	a1,0x5
     152:	55258593          	addi	a1,a1,1362 # 56a0 <malloc+0x194>
     156:	6d1040ef          	jal	5026 <write>
  int fd2 = open("truncfile", O_TRUNC|O_WRONLY);
     15a:	40100593          	li	a1,1025
     15e:	00005517          	auipc	a0,0x5
     162:	53250513          	addi	a0,a0,1330 # 5690 <malloc+0x184>
     166:	6e1040ef          	jal	5046 <open>
     16a:	892a                	mv	s2,a0
  int n = write(fd1, "x", 1);
     16c:	4605                	li	a2,1
     16e:	00005597          	auipc	a1,0x5
     172:	53a58593          	addi	a1,a1,1338 # 56a8 <malloc+0x19c>
     176:	8526                	mv	a0,s1
     178:	6af040ef          	jal	5026 <write>
  if(n != -1){
     17c:	57fd                	li	a5,-1
     17e:	02f51563          	bne	a0,a5,1a8 <truncate2+0x8a>
  unlink("truncfile");
     182:	00005517          	auipc	a0,0x5
     186:	50e50513          	addi	a0,a0,1294 # 5690 <malloc+0x184>
     18a:	6cd040ef          	jal	5056 <unlink>
  close(fd1);
     18e:	8526                	mv	a0,s1
     190:	69f040ef          	jal	502e <close>
  close(fd2);
     194:	854a                	mv	a0,s2
     196:	699040ef          	jal	502e <close>
}
     19a:	70a2                	ld	ra,40(sp)
     19c:	7402                	ld	s0,32(sp)
     19e:	64e2                	ld	s1,24(sp)
     1a0:	6942                	ld	s2,16(sp)
     1a2:	69a2                	ld	s3,8(sp)
     1a4:	6145                	addi	sp,sp,48
     1a6:	8082                	ret
    printf("%s: write returned %d, expected -1\n", s, n);
     1a8:	862a                	mv	a2,a0
     1aa:	85ce                	mv	a1,s3
     1ac:	00005517          	auipc	a0,0x5
     1b0:	50450513          	addi	a0,a0,1284 # 56b0 <malloc+0x1a4>
     1b4:	2a0050ef          	jal	5454 <printf>
    exit(1);
     1b8:	4505                	li	a0,1
     1ba:	64d040ef          	jal	5006 <exit>

00000000000001be <createtest>:
{
     1be:	7139                	addi	sp,sp,-64
     1c0:	fc06                	sd	ra,56(sp)
     1c2:	f822                	sd	s0,48(sp)
     1c4:	f426                	sd	s1,40(sp)
     1c6:	f04a                	sd	s2,32(sp)
     1c8:	ec4e                	sd	s3,24(sp)
     1ca:	e852                	sd	s4,16(sp)
     1cc:	0080                	addi	s0,sp,64
  name[0] = 'a';
     1ce:	06100793          	li	a5,97
     1d2:	fcf40423          	sb	a5,-56(s0)
  name[2] = '\0';
     1d6:	fc040523          	sb	zero,-54(s0)
     1da:	03000493          	li	s1,48
    fd = open(name, O_CREATE|O_RDWR);
     1de:	fc840a13          	addi	s4,s0,-56
     1e2:	20200993          	li	s3,514
  for(i = 0; i < N; i++){
     1e6:	06400913          	li	s2,100
    name[1] = '0' + i;
     1ea:	fc9404a3          	sb	s1,-55(s0)
    fd = open(name, O_CREATE|O_RDWR);
     1ee:	85ce                	mv	a1,s3
     1f0:	8552                	mv	a0,s4
     1f2:	655040ef          	jal	5046 <open>
    close(fd);
     1f6:	639040ef          	jal	502e <close>
  for(i = 0; i < N; i++){
     1fa:	2485                	addiw	s1,s1,1
     1fc:	0ff4f493          	zext.b	s1,s1
     200:	ff2495e3          	bne	s1,s2,1ea <createtest+0x2c>
  name[0] = 'a';
     204:	06100793          	li	a5,97
     208:	fcf40423          	sb	a5,-56(s0)
  name[2] = '\0';
     20c:	fc040523          	sb	zero,-54(s0)
     210:	03000493          	li	s1,48
    unlink(name);
     214:	fc840993          	addi	s3,s0,-56
  for(i = 0; i < N; i++){
     218:	06400913          	li	s2,100
    name[1] = '0' + i;
     21c:	fc9404a3          	sb	s1,-55(s0)
    unlink(name);
     220:	854e                	mv	a0,s3
     222:	635040ef          	jal	5056 <unlink>
  for(i = 0; i < N; i++){
     226:	2485                	addiw	s1,s1,1
     228:	0ff4f493          	zext.b	s1,s1
     22c:	ff2498e3          	bne	s1,s2,21c <createtest+0x5e>
}
     230:	70e2                	ld	ra,56(sp)
     232:	7442                	ld	s0,48(sp)
     234:	74a2                	ld	s1,40(sp)
     236:	7902                	ld	s2,32(sp)
     238:	69e2                	ld	s3,24(sp)
     23a:	6a42                	ld	s4,16(sp)
     23c:	6121                	addi	sp,sp,64
     23e:	8082                	ret

0000000000000240 <bigwrite>:
{
     240:	711d                	addi	sp,sp,-96
     242:	ec86                	sd	ra,88(sp)
     244:	e8a2                	sd	s0,80(sp)
     246:	e4a6                	sd	s1,72(sp)
     248:	e0ca                	sd	s2,64(sp)
     24a:	fc4e                	sd	s3,56(sp)
     24c:	f852                	sd	s4,48(sp)
     24e:	f456                	sd	s5,40(sp)
     250:	f05a                	sd	s6,32(sp)
     252:	ec5e                	sd	s7,24(sp)
     254:	e862                	sd	s8,16(sp)
     256:	e466                	sd	s9,8(sp)
     258:	1080                	addi	s0,sp,96
     25a:	8caa                	mv	s9,a0
  unlink("bigwrite");
     25c:	00005517          	auipc	a0,0x5
     260:	47c50513          	addi	a0,a0,1148 # 56d8 <malloc+0x1cc>
     264:	5f3040ef          	jal	5056 <unlink>
  for(sz = 499; sz < (MAXOPBLOCKS+2)*BSIZE; sz += 471){
     268:	1f300493          	li	s1,499
    fd = open("bigwrite", O_CREATE | O_RDWR);
     26c:	20200b93          	li	s7,514
     270:	00005a17          	auipc	s4,0x5
     274:	468a0a13          	addi	s4,s4,1128 # 56d8 <malloc+0x1cc>
     278:	4b09                	li	s6,2
      int cc = write(fd, buf, sz);
     27a:	0000e997          	auipc	s3,0xe
     27e:	a0e98993          	addi	s3,s3,-1522 # dc88 <buf>
  for(sz = 499; sz < (MAXOPBLOCKS+2)*BSIZE; sz += 471){
     282:	6a8d                	lui	s5,0x3
     284:	1c9a8a93          	addi	s5,s5,457 # 31c9 <iref+0x39>
    fd = open("bigwrite", O_CREATE | O_RDWR);
     288:	85de                	mv	a1,s7
     28a:	8552                	mv	a0,s4
     28c:	5bb040ef          	jal	5046 <open>
     290:	892a                	mv	s2,a0
    if(fd < 0){
     292:	04054463          	bltz	a0,2da <bigwrite+0x9a>
     296:	8c5a                	mv	s8,s6
      int cc = write(fd, buf, sz);
     298:	8626                	mv	a2,s1
     29a:	85ce                	mv	a1,s3
     29c:	854a                	mv	a0,s2
     29e:	589040ef          	jal	5026 <write>
      if(cc != sz){
     2a2:	04951663          	bne	a0,s1,2ee <bigwrite+0xae>
    for(i = 0; i < 2; i++){
     2a6:	3c7d                	addiw	s8,s8,-1
     2a8:	fe0c18e3          	bnez	s8,298 <bigwrite+0x58>
    close(fd);
     2ac:	854a                	mv	a0,s2
     2ae:	581040ef          	jal	502e <close>
    unlink("bigwrite");
     2b2:	8552                	mv	a0,s4
     2b4:	5a3040ef          	jal	5056 <unlink>
  for(sz = 499; sz < (MAXOPBLOCKS+2)*BSIZE; sz += 471){
     2b8:	1d74849b          	addiw	s1,s1,471
     2bc:	fd5496e3          	bne	s1,s5,288 <bigwrite+0x48>
}
     2c0:	60e6                	ld	ra,88(sp)
     2c2:	6446                	ld	s0,80(sp)
     2c4:	64a6                	ld	s1,72(sp)
     2c6:	6906                	ld	s2,64(sp)
     2c8:	79e2                	ld	s3,56(sp)
     2ca:	7a42                	ld	s4,48(sp)
     2cc:	7aa2                	ld	s5,40(sp)
     2ce:	7b02                	ld	s6,32(sp)
     2d0:	6be2                	ld	s7,24(sp)
     2d2:	6c42                	ld	s8,16(sp)
     2d4:	6ca2                	ld	s9,8(sp)
     2d6:	6125                	addi	sp,sp,96
     2d8:	8082                	ret
      printf("%s: cannot create bigwrite\n", s);
     2da:	85e6                	mv	a1,s9
     2dc:	00005517          	auipc	a0,0x5
     2e0:	40c50513          	addi	a0,a0,1036 # 56e8 <malloc+0x1dc>
     2e4:	170050ef          	jal	5454 <printf>
      exit(1);
     2e8:	4505                	li	a0,1
     2ea:	51d040ef          	jal	5006 <exit>
        printf("%s: write(%d) ret %d\n", s, sz, cc);
     2ee:	86aa                	mv	a3,a0
     2f0:	8626                	mv	a2,s1
     2f2:	85e6                	mv	a1,s9
     2f4:	00005517          	auipc	a0,0x5
     2f8:	41450513          	addi	a0,a0,1044 # 5708 <malloc+0x1fc>
     2fc:	158050ef          	jal	5454 <printf>
        exit(1);
     300:	4505                	li	a0,1
     302:	505040ef          	jal	5006 <exit>

0000000000000306 <badwrite>:
// file is deleted? if the kernel has this bug, it will panic: balloc:
// out of blocks. assumed_free may need to be raised to be more than
// the number of free blocks. this test takes a long time.
void
badwrite(char *s)
{
     306:	7139                	addi	sp,sp,-64
     308:	fc06                	sd	ra,56(sp)
     30a:	f822                	sd	s0,48(sp)
     30c:	f426                	sd	s1,40(sp)
     30e:	f04a                	sd	s2,32(sp)
     310:	ec4e                	sd	s3,24(sp)
     312:	e852                	sd	s4,16(sp)
     314:	e456                	sd	s5,8(sp)
     316:	e05a                	sd	s6,0(sp)
     318:	0080                	addi	s0,sp,64
  int assumed_free = 600;
  
  unlink("junk");
     31a:	00005517          	auipc	a0,0x5
     31e:	40650513          	addi	a0,a0,1030 # 5720 <malloc+0x214>
     322:	535040ef          	jal	5056 <unlink>
     326:	25800913          	li	s2,600
  for(int i = 0; i < assumed_free; i++){
    int fd = open("junk", O_CREATE|O_WRONLY);
     32a:	20100a93          	li	s5,513
     32e:	00005997          	auipc	s3,0x5
     332:	3f298993          	addi	s3,s3,1010 # 5720 <malloc+0x214>
    if(fd < 0){
      printf("open junk failed\n");
      exit(1);
    }
    write(fd, (char*)0xffffffffffL, 1);
     336:	4b05                	li	s6,1
     338:	5a7d                	li	s4,-1
     33a:	018a5a13          	srli	s4,s4,0x18
    int fd = open("junk", O_CREATE|O_WRONLY);
     33e:	85d6                	mv	a1,s5
     340:	854e                	mv	a0,s3
     342:	505040ef          	jal	5046 <open>
     346:	84aa                	mv	s1,a0
    if(fd < 0){
     348:	04054d63          	bltz	a0,3a2 <badwrite+0x9c>
    write(fd, (char*)0xffffffffffL, 1);
     34c:	865a                	mv	a2,s6
     34e:	85d2                	mv	a1,s4
     350:	4d7040ef          	jal	5026 <write>
    close(fd);
     354:	8526                	mv	a0,s1
     356:	4d9040ef          	jal	502e <close>
    unlink("junk");
     35a:	854e                	mv	a0,s3
     35c:	4fb040ef          	jal	5056 <unlink>
  for(int i = 0; i < assumed_free; i++){
     360:	397d                	addiw	s2,s2,-1
     362:	fc091ee3          	bnez	s2,33e <badwrite+0x38>
  }

  int fd = open("junk", O_CREATE|O_WRONLY);
     366:	20100593          	li	a1,513
     36a:	00005517          	auipc	a0,0x5
     36e:	3b650513          	addi	a0,a0,950 # 5720 <malloc+0x214>
     372:	4d5040ef          	jal	5046 <open>
     376:	84aa                	mv	s1,a0
  if(fd < 0){
     378:	02054e63          	bltz	a0,3b4 <badwrite+0xae>
    printf("open junk failed\n");
    exit(1);
  }
  if(write(fd, "x", 1) != 1){
     37c:	4605                	li	a2,1
     37e:	00005597          	auipc	a1,0x5
     382:	32a58593          	addi	a1,a1,810 # 56a8 <malloc+0x19c>
     386:	4a1040ef          	jal	5026 <write>
     38a:	4785                	li	a5,1
     38c:	02f50d63          	beq	a0,a5,3c6 <badwrite+0xc0>
    printf("write failed\n");
     390:	00005517          	auipc	a0,0x5
     394:	3b050513          	addi	a0,a0,944 # 5740 <malloc+0x234>
     398:	0bc050ef          	jal	5454 <printf>
    exit(1);
     39c:	4505                	li	a0,1
     39e:	469040ef          	jal	5006 <exit>
      printf("open junk failed\n");
     3a2:	00005517          	auipc	a0,0x5
     3a6:	38650513          	addi	a0,a0,902 # 5728 <malloc+0x21c>
     3aa:	0aa050ef          	jal	5454 <printf>
      exit(1);
     3ae:	4505                	li	a0,1
     3b0:	457040ef          	jal	5006 <exit>
    printf("open junk failed\n");
     3b4:	00005517          	auipc	a0,0x5
     3b8:	37450513          	addi	a0,a0,884 # 5728 <malloc+0x21c>
     3bc:	098050ef          	jal	5454 <printf>
    exit(1);
     3c0:	4505                	li	a0,1
     3c2:	445040ef          	jal	5006 <exit>
  }
  close(fd);
     3c6:	8526                	mv	a0,s1
     3c8:	467040ef          	jal	502e <close>
  unlink("junk");
     3cc:	00005517          	auipc	a0,0x5
     3d0:	35450513          	addi	a0,a0,852 # 5720 <malloc+0x214>
     3d4:	483040ef          	jal	5056 <unlink>

  exit(0);
     3d8:	4501                	li	a0,0
     3da:	42d040ef          	jal	5006 <exit>

00000000000003de <outofinodes>:
  }
}

void
outofinodes(char *s)
{
     3de:	711d                	addi	sp,sp,-96
     3e0:	ec86                	sd	ra,88(sp)
     3e2:	e8a2                	sd	s0,80(sp)
     3e4:	e4a6                	sd	s1,72(sp)
     3e6:	e0ca                	sd	s2,64(sp)
     3e8:	fc4e                	sd	s3,56(sp)
     3ea:	f852                	sd	s4,48(sp)
     3ec:	f456                	sd	s5,40(sp)
     3ee:	1080                	addi	s0,sp,96
  int nzz = 32*32;
  for(int i = 0; i < nzz; i++){
     3f0:	4481                	li	s1,0
    char name[32];
    name[0] = 'z';
     3f2:	07a00993          	li	s3,122
    name[1] = 'z';
    name[2] = '0' + (i / 32);
    name[3] = '0' + (i % 32);
    name[4] = '\0';
    unlink(name);
     3f6:	fa040913          	addi	s2,s0,-96
    int fd = open(name, O_CREATE|O_RDWR|O_TRUNC);
     3fa:	60200a13          	li	s4,1538
  for(int i = 0; i < nzz; i++){
     3fe:	40000a93          	li	s5,1024
    name[0] = 'z';
     402:	fb340023          	sb	s3,-96(s0)
    name[1] = 'z';
     406:	fb3400a3          	sb	s3,-95(s0)
    name[2] = '0' + (i / 32);
     40a:	41f4d71b          	sraiw	a4,s1,0x1f
     40e:	01b7571b          	srliw	a4,a4,0x1b
     412:	009707bb          	addw	a5,a4,s1
     416:	4057d69b          	sraiw	a3,a5,0x5
     41a:	0306869b          	addiw	a3,a3,48
     41e:	fad40123          	sb	a3,-94(s0)
    name[3] = '0' + (i % 32);
     422:	8bfd                	andi	a5,a5,31
     424:	9f99                	subw	a5,a5,a4
     426:	0307879b          	addiw	a5,a5,48
     42a:	faf401a3          	sb	a5,-93(s0)
    name[4] = '\0';
     42e:	fa040223          	sb	zero,-92(s0)
    unlink(name);
     432:	854a                	mv	a0,s2
     434:	423040ef          	jal	5056 <unlink>
    int fd = open(name, O_CREATE|O_RDWR|O_TRUNC);
     438:	85d2                	mv	a1,s4
     43a:	854a                	mv	a0,s2
     43c:	40b040ef          	jal	5046 <open>
    if(fd < 0){
     440:	00054763          	bltz	a0,44e <outofinodes+0x70>
      // failure is eventually expected.
      break;
    }
    close(fd);
     444:	3eb040ef          	jal	502e <close>
  for(int i = 0; i < nzz; i++){
     448:	2485                	addiw	s1,s1,1
     44a:	fb549ce3          	bne	s1,s5,402 <outofinodes+0x24>
     44e:	4481                	li	s1,0
  }

  for(int i = 0; i < nzz; i++){
    char name[32];
    name[0] = 'z';
     450:	07a00913          	li	s2,122
    name[1] = 'z';
    name[2] = '0' + (i / 32);
    name[3] = '0' + (i % 32);
    name[4] = '\0';
    unlink(name);
     454:	fa040a13          	addi	s4,s0,-96
  for(int i = 0; i < nzz; i++){
     458:	40000993          	li	s3,1024
    name[0] = 'z';
     45c:	fb240023          	sb	s2,-96(s0)
    name[1] = 'z';
     460:	fb2400a3          	sb	s2,-95(s0)
    name[2] = '0' + (i / 32);
     464:	41f4d71b          	sraiw	a4,s1,0x1f
     468:	01b7571b          	srliw	a4,a4,0x1b
     46c:	009707bb          	addw	a5,a4,s1
     470:	4057d69b          	sraiw	a3,a5,0x5
     474:	0306869b          	addiw	a3,a3,48
     478:	fad40123          	sb	a3,-94(s0)
    name[3] = '0' + (i % 32);
     47c:	8bfd                	andi	a5,a5,31
     47e:	9f99                	subw	a5,a5,a4
     480:	0307879b          	addiw	a5,a5,48
     484:	faf401a3          	sb	a5,-93(s0)
    name[4] = '\0';
     488:	fa040223          	sb	zero,-92(s0)
    unlink(name);
     48c:	8552                	mv	a0,s4
     48e:	3c9040ef          	jal	5056 <unlink>
  for(int i = 0; i < nzz; i++){
     492:	2485                	addiw	s1,s1,1
     494:	fd3494e3          	bne	s1,s3,45c <outofinodes+0x7e>
  }
}
     498:	60e6                	ld	ra,88(sp)
     49a:	6446                	ld	s0,80(sp)
     49c:	64a6                	ld	s1,72(sp)
     49e:	6906                	ld	s2,64(sp)
     4a0:	79e2                	ld	s3,56(sp)
     4a2:	7a42                	ld	s4,48(sp)
     4a4:	7aa2                	ld	s5,40(sp)
     4a6:	6125                	addi	sp,sp,96
     4a8:	8082                	ret

00000000000004aa <copyin>:
{
     4aa:	7175                	addi	sp,sp,-144
     4ac:	e506                	sd	ra,136(sp)
     4ae:	e122                	sd	s0,128(sp)
     4b0:	fca6                	sd	s1,120(sp)
     4b2:	f8ca                	sd	s2,112(sp)
     4b4:	f4ce                	sd	s3,104(sp)
     4b6:	f0d2                	sd	s4,96(sp)
     4b8:	ecd6                	sd	s5,88(sp)
     4ba:	e8da                	sd	s6,80(sp)
     4bc:	e4de                	sd	s7,72(sp)
     4be:	e0e2                	sd	s8,64(sp)
     4c0:	fc66                	sd	s9,56(sp)
     4c2:	0900                	addi	s0,sp,144
  uint64 addrs[] = { 0x80000000LL, 0x3fffffe000, 0x3ffffff000, 0x4000000000,
     4c4:	00007797          	auipc	a5,0x7
     4c8:	69478793          	addi	a5,a5,1684 # 7b58 <malloc+0x264c>
     4cc:	638c                	ld	a1,0(a5)
     4ce:	6790                	ld	a2,8(a5)
     4d0:	6b94                	ld	a3,16(a5)
     4d2:	6f98                	ld	a4,24(a5)
     4d4:	f6b43c23          	sd	a1,-136(s0)
     4d8:	f8c43023          	sd	a2,-128(s0)
     4dc:	f8d43423          	sd	a3,-120(s0)
     4e0:	f8e43823          	sd	a4,-112(s0)
     4e4:	739c                	ld	a5,32(a5)
     4e6:	f8f43c23          	sd	a5,-104(s0)
  for(int ai = 0; ai < sizeof(addrs)/sizeof(addrs[0]); ai++){
     4ea:	f7840913          	addi	s2,s0,-136
     4ee:	fa040c93          	addi	s9,s0,-96
    int fd = open("copyin1", O_CREATE|O_WRONLY);
     4f2:	20100b13          	li	s6,513
     4f6:	00005a97          	auipc	s5,0x5
     4fa:	25aa8a93          	addi	s5,s5,602 # 5750 <malloc+0x244>
    int n = write(fd, (void*)addr, 8192);
     4fe:	6a09                	lui	s4,0x2
    n = write(1, (char*)addr, 8192);
     500:	4c05                	li	s8,1
    if(pipe(fds) < 0){
     502:	f7040b93          	addi	s7,s0,-144
    uint64 addr = addrs[ai];
     506:	00093983          	ld	s3,0(s2)
    int fd = open("copyin1", O_CREATE|O_WRONLY);
     50a:	85da                	mv	a1,s6
     50c:	8556                	mv	a0,s5
     50e:	339040ef          	jal	5046 <open>
     512:	84aa                	mv	s1,a0
    if(fd < 0){
     514:	06054a63          	bltz	a0,588 <copyin+0xde>
    int n = write(fd, (void*)addr, 8192);
     518:	8652                	mv	a2,s4
     51a:	85ce                	mv	a1,s3
     51c:	30b040ef          	jal	5026 <write>
    if(n >= 0){
     520:	06055d63          	bgez	a0,59a <copyin+0xf0>
    close(fd);
     524:	8526                	mv	a0,s1
     526:	309040ef          	jal	502e <close>
    unlink("copyin1");
     52a:	8556                	mv	a0,s5
     52c:	32b040ef          	jal	5056 <unlink>
    n = write(1, (char*)addr, 8192);
     530:	8652                	mv	a2,s4
     532:	85ce                	mv	a1,s3
     534:	8562                	mv	a0,s8
     536:	2f1040ef          	jal	5026 <write>
    if(n > 0){
     53a:	06a04b63          	bgtz	a0,5b0 <copyin+0x106>
    if(pipe(fds) < 0){
     53e:	855e                	mv	a0,s7
     540:	2d7040ef          	jal	5016 <pipe>
     544:	08054163          	bltz	a0,5c6 <copyin+0x11c>
    n = write(fds[1], (char*)addr, 8192);
     548:	8652                	mv	a2,s4
     54a:	85ce                	mv	a1,s3
     54c:	f7442503          	lw	a0,-140(s0)
     550:	2d7040ef          	jal	5026 <write>
    if(n > 0){
     554:	08a04263          	bgtz	a0,5d8 <copyin+0x12e>
    close(fds[0]);
     558:	f7042503          	lw	a0,-144(s0)
     55c:	2d3040ef          	jal	502e <close>
    close(fds[1]);
     560:	f7442503          	lw	a0,-140(s0)
     564:	2cb040ef          	jal	502e <close>
  for(int ai = 0; ai < sizeof(addrs)/sizeof(addrs[0]); ai++){
     568:	0921                	addi	s2,s2,8
     56a:	f9991ee3          	bne	s2,s9,506 <copyin+0x5c>
}
     56e:	60aa                	ld	ra,136(sp)
     570:	640a                	ld	s0,128(sp)
     572:	74e6                	ld	s1,120(sp)
     574:	7946                	ld	s2,112(sp)
     576:	79a6                	ld	s3,104(sp)
     578:	7a06                	ld	s4,96(sp)
     57a:	6ae6                	ld	s5,88(sp)
     57c:	6b46                	ld	s6,80(sp)
     57e:	6ba6                	ld	s7,72(sp)
     580:	6c06                	ld	s8,64(sp)
     582:	7ce2                	ld	s9,56(sp)
     584:	6149                	addi	sp,sp,144
     586:	8082                	ret
      printf("open(copyin1) failed\n");
     588:	00005517          	auipc	a0,0x5
     58c:	1d050513          	addi	a0,a0,464 # 5758 <malloc+0x24c>
     590:	6c5040ef          	jal	5454 <printf>
      exit(1);
     594:	4505                	li	a0,1
     596:	271040ef          	jal	5006 <exit>
      printf("write(fd, %p, 8192) returned %d, not -1\n", (void*)addr, n);
     59a:	862a                	mv	a2,a0
     59c:	85ce                	mv	a1,s3
     59e:	00005517          	auipc	a0,0x5
     5a2:	1d250513          	addi	a0,a0,466 # 5770 <malloc+0x264>
     5a6:	6af040ef          	jal	5454 <printf>
      exit(1);
     5aa:	4505                	li	a0,1
     5ac:	25b040ef          	jal	5006 <exit>
      printf("write(1, %p, 8192) returned %d, not -1 or 0\n", (void*)addr, n);
     5b0:	862a                	mv	a2,a0
     5b2:	85ce                	mv	a1,s3
     5b4:	00005517          	auipc	a0,0x5
     5b8:	1ec50513          	addi	a0,a0,492 # 57a0 <malloc+0x294>
     5bc:	699040ef          	jal	5454 <printf>
      exit(1);
     5c0:	4505                	li	a0,1
     5c2:	245040ef          	jal	5006 <exit>
      printf("pipe() failed\n");
     5c6:	00005517          	auipc	a0,0x5
     5ca:	20a50513          	addi	a0,a0,522 # 57d0 <malloc+0x2c4>
     5ce:	687040ef          	jal	5454 <printf>
      exit(1);
     5d2:	4505                	li	a0,1
     5d4:	233040ef          	jal	5006 <exit>
      printf("write(pipe, %p, 8192) returned %d, not -1 or 0\n", (void*)addr, n);
     5d8:	862a                	mv	a2,a0
     5da:	85ce                	mv	a1,s3
     5dc:	00005517          	auipc	a0,0x5
     5e0:	20450513          	addi	a0,a0,516 # 57e0 <malloc+0x2d4>
     5e4:	671040ef          	jal	5454 <printf>
      exit(1);
     5e8:	4505                	li	a0,1
     5ea:	21d040ef          	jal	5006 <exit>

00000000000005ee <copyout>:
{
     5ee:	7135                	addi	sp,sp,-160
     5f0:	ed06                	sd	ra,152(sp)
     5f2:	e922                	sd	s0,144(sp)
     5f4:	e526                	sd	s1,136(sp)
     5f6:	e14a                	sd	s2,128(sp)
     5f8:	fcce                	sd	s3,120(sp)
     5fa:	f8d2                	sd	s4,112(sp)
     5fc:	f4d6                	sd	s5,104(sp)
     5fe:	f0da                	sd	s6,96(sp)
     600:	ecde                	sd	s7,88(sp)
     602:	e8e2                	sd	s8,80(sp)
     604:	e4e6                	sd	s9,72(sp)
     606:	1100                	addi	s0,sp,160
  uint64 addrs[] = { 0LL, 0x80000000LL, 0x3fffffe000, 0x3ffffff000, 0x4000000000,
     608:	00007797          	auipc	a5,0x7
     60c:	55078793          	addi	a5,a5,1360 # 7b58 <malloc+0x264c>
     610:	7788                	ld	a0,40(a5)
     612:	7b8c                	ld	a1,48(a5)
     614:	7f90                	ld	a2,56(a5)
     616:	63b4                	ld	a3,64(a5)
     618:	67b8                	ld	a4,72(a5)
     61a:	f6a43823          	sd	a0,-144(s0)
     61e:	f6b43c23          	sd	a1,-136(s0)
     622:	f8c43023          	sd	a2,-128(s0)
     626:	f8d43423          	sd	a3,-120(s0)
     62a:	f8e43823          	sd	a4,-112(s0)
     62e:	6bbc                	ld	a5,80(a5)
     630:	f8f43c23          	sd	a5,-104(s0)
  for(int ai = 0; ai < sizeof(addrs)/sizeof(addrs[0]); ai++){
     634:	f7040913          	addi	s2,s0,-144
     638:	fa040c93          	addi	s9,s0,-96
    int fd = open("README", 0);
     63c:	00005b17          	auipc	s6,0x5
     640:	1d4b0b13          	addi	s6,s6,468 # 5810 <malloc+0x304>
    int n = read(fd, (void*)addr, 8192);
     644:	6a89                	lui	s5,0x2
    if(pipe(fds) < 0){
     646:	f6840c13          	addi	s8,s0,-152
    n = write(fds[1], "x", 1);
     64a:	4a05                	li	s4,1
     64c:	00005b97          	auipc	s7,0x5
     650:	05cb8b93          	addi	s7,s7,92 # 56a8 <malloc+0x19c>
    uint64 addr = addrs[ai];
     654:	00093983          	ld	s3,0(s2)
    int fd = open("README", 0);
     658:	4581                	li	a1,0
     65a:	855a                	mv	a0,s6
     65c:	1eb040ef          	jal	5046 <open>
     660:	84aa                	mv	s1,a0
    if(fd < 0){
     662:	06054863          	bltz	a0,6d2 <copyout+0xe4>
    int n = read(fd, (void*)addr, 8192);
     666:	8656                	mv	a2,s5
     668:	85ce                	mv	a1,s3
     66a:	1b5040ef          	jal	501e <read>
    if(n > 0){
     66e:	06a04b63          	bgtz	a0,6e4 <copyout+0xf6>
    close(fd);
     672:	8526                	mv	a0,s1
     674:	1bb040ef          	jal	502e <close>
    if(pipe(fds) < 0){
     678:	8562                	mv	a0,s8
     67a:	19d040ef          	jal	5016 <pipe>
     67e:	06054e63          	bltz	a0,6fa <copyout+0x10c>
    n = write(fds[1], "x", 1);
     682:	8652                	mv	a2,s4
     684:	85de                	mv	a1,s7
     686:	f6c42503          	lw	a0,-148(s0)
     68a:	19d040ef          	jal	5026 <write>
    if(n != 1){
     68e:	07451f63          	bne	a0,s4,70c <copyout+0x11e>
    n = read(fds[0], (void*)addr, 8192);
     692:	8656                	mv	a2,s5
     694:	85ce                	mv	a1,s3
     696:	f6842503          	lw	a0,-152(s0)
     69a:	185040ef          	jal	501e <read>
    if(n > 0){
     69e:	08a04063          	bgtz	a0,71e <copyout+0x130>
    close(fds[0]);
     6a2:	f6842503          	lw	a0,-152(s0)
     6a6:	189040ef          	jal	502e <close>
    close(fds[1]);
     6aa:	f6c42503          	lw	a0,-148(s0)
     6ae:	181040ef          	jal	502e <close>
  for(int ai = 0; ai < sizeof(addrs)/sizeof(addrs[0]); ai++){
     6b2:	0921                	addi	s2,s2,8
     6b4:	fb9910e3          	bne	s2,s9,654 <copyout+0x66>
}
     6b8:	60ea                	ld	ra,152(sp)
     6ba:	644a                	ld	s0,144(sp)
     6bc:	64aa                	ld	s1,136(sp)
     6be:	690a                	ld	s2,128(sp)
     6c0:	79e6                	ld	s3,120(sp)
     6c2:	7a46                	ld	s4,112(sp)
     6c4:	7aa6                	ld	s5,104(sp)
     6c6:	7b06                	ld	s6,96(sp)
     6c8:	6be6                	ld	s7,88(sp)
     6ca:	6c46                	ld	s8,80(sp)
     6cc:	6ca6                	ld	s9,72(sp)
     6ce:	610d                	addi	sp,sp,160
     6d0:	8082                	ret
      printf("open(README) failed\n");
     6d2:	00005517          	auipc	a0,0x5
     6d6:	14650513          	addi	a0,a0,326 # 5818 <malloc+0x30c>
     6da:	57b040ef          	jal	5454 <printf>
      exit(1);
     6de:	4505                	li	a0,1
     6e0:	127040ef          	jal	5006 <exit>
      printf("read(fd, %p, 8192) returned %d, not -1 or 0\n", (void*)addr, n);
     6e4:	862a                	mv	a2,a0
     6e6:	85ce                	mv	a1,s3
     6e8:	00005517          	auipc	a0,0x5
     6ec:	14850513          	addi	a0,a0,328 # 5830 <malloc+0x324>
     6f0:	565040ef          	jal	5454 <printf>
      exit(1);
     6f4:	4505                	li	a0,1
     6f6:	111040ef          	jal	5006 <exit>
      printf("pipe() failed\n");
     6fa:	00005517          	auipc	a0,0x5
     6fe:	0d650513          	addi	a0,a0,214 # 57d0 <malloc+0x2c4>
     702:	553040ef          	jal	5454 <printf>
      exit(1);
     706:	4505                	li	a0,1
     708:	0ff040ef          	jal	5006 <exit>
      printf("pipe write failed\n");
     70c:	00005517          	auipc	a0,0x5
     710:	15450513          	addi	a0,a0,340 # 5860 <malloc+0x354>
     714:	541040ef          	jal	5454 <printf>
      exit(1);
     718:	4505                	li	a0,1
     71a:	0ed040ef          	jal	5006 <exit>
      printf("read(pipe, %p, 8192) returned %d, not -1 or 0\n", (void*)addr, n);
     71e:	862a                	mv	a2,a0
     720:	85ce                	mv	a1,s3
     722:	00005517          	auipc	a0,0x5
     726:	15650513          	addi	a0,a0,342 # 5878 <malloc+0x36c>
     72a:	52b040ef          	jal	5454 <printf>
      exit(1);
     72e:	4505                	li	a0,1
     730:	0d7040ef          	jal	5006 <exit>

0000000000000734 <truncate1>:
{
     734:	711d                	addi	sp,sp,-96
     736:	ec86                	sd	ra,88(sp)
     738:	e8a2                	sd	s0,80(sp)
     73a:	e4a6                	sd	s1,72(sp)
     73c:	e0ca                	sd	s2,64(sp)
     73e:	fc4e                	sd	s3,56(sp)
     740:	f852                	sd	s4,48(sp)
     742:	f456                	sd	s5,40(sp)
     744:	1080                	addi	s0,sp,96
     746:	8a2a                	mv	s4,a0
  unlink("truncfile");
     748:	00005517          	auipc	a0,0x5
     74c:	f4850513          	addi	a0,a0,-184 # 5690 <malloc+0x184>
     750:	107040ef          	jal	5056 <unlink>
  int fd1 = open("truncfile", O_CREATE|O_WRONLY|O_TRUNC);
     754:	60100593          	li	a1,1537
     758:	00005517          	auipc	a0,0x5
     75c:	f3850513          	addi	a0,a0,-200 # 5690 <malloc+0x184>
     760:	0e7040ef          	jal	5046 <open>
     764:	84aa                	mv	s1,a0
  write(fd1, "abcd", 4);
     766:	4611                	li	a2,4
     768:	00005597          	auipc	a1,0x5
     76c:	f3858593          	addi	a1,a1,-200 # 56a0 <malloc+0x194>
     770:	0b7040ef          	jal	5026 <write>
  close(fd1);
     774:	8526                	mv	a0,s1
     776:	0b9040ef          	jal	502e <close>
  int fd2 = open("truncfile", O_RDONLY);
     77a:	4581                	li	a1,0
     77c:	00005517          	auipc	a0,0x5
     780:	f1450513          	addi	a0,a0,-236 # 5690 <malloc+0x184>
     784:	0c3040ef          	jal	5046 <open>
     788:	84aa                	mv	s1,a0
  int n = read(fd2, buf, sizeof(buf));
     78a:	02000613          	li	a2,32
     78e:	fa040593          	addi	a1,s0,-96
     792:	08d040ef          	jal	501e <read>
  if(n != 4){
     796:	4791                	li	a5,4
     798:	0af51863          	bne	a0,a5,848 <truncate1+0x114>
  fd1 = open("truncfile", O_WRONLY|O_TRUNC);
     79c:	40100593          	li	a1,1025
     7a0:	00005517          	auipc	a0,0x5
     7a4:	ef050513          	addi	a0,a0,-272 # 5690 <malloc+0x184>
     7a8:	09f040ef          	jal	5046 <open>
     7ac:	89aa                	mv	s3,a0
  int fd3 = open("truncfile", O_RDONLY);
     7ae:	4581                	li	a1,0
     7b0:	00005517          	auipc	a0,0x5
     7b4:	ee050513          	addi	a0,a0,-288 # 5690 <malloc+0x184>
     7b8:	08f040ef          	jal	5046 <open>
     7bc:	892a                	mv	s2,a0
  n = read(fd3, buf, sizeof(buf));
     7be:	02000613          	li	a2,32
     7c2:	fa040593          	addi	a1,s0,-96
     7c6:	059040ef          	jal	501e <read>
     7ca:	8aaa                	mv	s5,a0
  if(n != 0){
     7cc:	e949                	bnez	a0,85e <truncate1+0x12a>
  n = read(fd2, buf, sizeof(buf));
     7ce:	02000613          	li	a2,32
     7d2:	fa040593          	addi	a1,s0,-96
     7d6:	8526                	mv	a0,s1
     7d8:	047040ef          	jal	501e <read>
     7dc:	8aaa                	mv	s5,a0
  if(n != 0){
     7de:	e155                	bnez	a0,882 <truncate1+0x14e>
  write(fd1, "abcdef", 6);
     7e0:	4619                	li	a2,6
     7e2:	00005597          	auipc	a1,0x5
     7e6:	12658593          	addi	a1,a1,294 # 5908 <malloc+0x3fc>
     7ea:	854e                	mv	a0,s3
     7ec:	03b040ef          	jal	5026 <write>
  n = read(fd3, buf, sizeof(buf));
     7f0:	02000613          	li	a2,32
     7f4:	fa040593          	addi	a1,s0,-96
     7f8:	854a                	mv	a0,s2
     7fa:	025040ef          	jal	501e <read>
  if(n != 6){
     7fe:	4799                	li	a5,6
     800:	0af51363          	bne	a0,a5,8a6 <truncate1+0x172>
  n = read(fd2, buf, sizeof(buf));
     804:	02000613          	li	a2,32
     808:	fa040593          	addi	a1,s0,-96
     80c:	8526                	mv	a0,s1
     80e:	011040ef          	jal	501e <read>
  if(n != 2){
     812:	4789                	li	a5,2
     814:	0af51463          	bne	a0,a5,8bc <truncate1+0x188>
  unlink("truncfile");
     818:	00005517          	auipc	a0,0x5
     81c:	e7850513          	addi	a0,a0,-392 # 5690 <malloc+0x184>
     820:	037040ef          	jal	5056 <unlink>
  close(fd1);
     824:	854e                	mv	a0,s3
     826:	009040ef          	jal	502e <close>
  close(fd2);
     82a:	8526                	mv	a0,s1
     82c:	003040ef          	jal	502e <close>
  close(fd3);
     830:	854a                	mv	a0,s2
     832:	7fc040ef          	jal	502e <close>
}
     836:	60e6                	ld	ra,88(sp)
     838:	6446                	ld	s0,80(sp)
     83a:	64a6                	ld	s1,72(sp)
     83c:	6906                	ld	s2,64(sp)
     83e:	79e2                	ld	s3,56(sp)
     840:	7a42                	ld	s4,48(sp)
     842:	7aa2                	ld	s5,40(sp)
     844:	6125                	addi	sp,sp,96
     846:	8082                	ret
    printf("%s: read %d bytes, wanted 4\n", s, n);
     848:	862a                	mv	a2,a0
     84a:	85d2                	mv	a1,s4
     84c:	00005517          	auipc	a0,0x5
     850:	05c50513          	addi	a0,a0,92 # 58a8 <malloc+0x39c>
     854:	401040ef          	jal	5454 <printf>
    exit(1);
     858:	4505                	li	a0,1
     85a:	7ac040ef          	jal	5006 <exit>
    printf("aaa fd3=%d\n", fd3);
     85e:	85ca                	mv	a1,s2
     860:	00005517          	auipc	a0,0x5
     864:	06850513          	addi	a0,a0,104 # 58c8 <malloc+0x3bc>
     868:	3ed040ef          	jal	5454 <printf>
    printf("%s: read %d bytes, wanted 0\n", s, n);
     86c:	8656                	mv	a2,s5
     86e:	85d2                	mv	a1,s4
     870:	00005517          	auipc	a0,0x5
     874:	06850513          	addi	a0,a0,104 # 58d8 <malloc+0x3cc>
     878:	3dd040ef          	jal	5454 <printf>
    exit(1);
     87c:	4505                	li	a0,1
     87e:	788040ef          	jal	5006 <exit>
    printf("bbb fd2=%d\n", fd2);
     882:	85a6                	mv	a1,s1
     884:	00005517          	auipc	a0,0x5
     888:	07450513          	addi	a0,a0,116 # 58f8 <malloc+0x3ec>
     88c:	3c9040ef          	jal	5454 <printf>
    printf("%s: read %d bytes, wanted 0\n", s, n);
     890:	8656                	mv	a2,s5
     892:	85d2                	mv	a1,s4
     894:	00005517          	auipc	a0,0x5
     898:	04450513          	addi	a0,a0,68 # 58d8 <malloc+0x3cc>
     89c:	3b9040ef          	jal	5454 <printf>
    exit(1);
     8a0:	4505                	li	a0,1
     8a2:	764040ef          	jal	5006 <exit>
    printf("%s: read %d bytes, wanted 6\n", s, n);
     8a6:	862a                	mv	a2,a0
     8a8:	85d2                	mv	a1,s4
     8aa:	00005517          	auipc	a0,0x5
     8ae:	06650513          	addi	a0,a0,102 # 5910 <malloc+0x404>
     8b2:	3a3040ef          	jal	5454 <printf>
    exit(1);
     8b6:	4505                	li	a0,1
     8b8:	74e040ef          	jal	5006 <exit>
    printf("%s: read %d bytes, wanted 2\n", s, n);
     8bc:	862a                	mv	a2,a0
     8be:	85d2                	mv	a1,s4
     8c0:	00005517          	auipc	a0,0x5
     8c4:	07050513          	addi	a0,a0,112 # 5930 <malloc+0x424>
     8c8:	38d040ef          	jal	5454 <printf>
    exit(1);
     8cc:	4505                	li	a0,1
     8ce:	738040ef          	jal	5006 <exit>

00000000000008d2 <unlinkread>:
{
     8d2:	7179                	addi	sp,sp,-48
     8d4:	f406                	sd	ra,40(sp)
     8d6:	f022                	sd	s0,32(sp)
     8d8:	ec26                	sd	s1,24(sp)
     8da:	e84a                	sd	s2,16(sp)
     8dc:	e44e                	sd	s3,8(sp)
     8de:	1800                	addi	s0,sp,48
     8e0:	89aa                	mv	s3,a0
  fd = open("unlinkread", O_CREATE | O_RDWR);
     8e2:	20200593          	li	a1,514
     8e6:	00005517          	auipc	a0,0x5
     8ea:	06a50513          	addi	a0,a0,106 # 5950 <malloc+0x444>
     8ee:	758040ef          	jal	5046 <open>
  if(fd < 0){
     8f2:	0a054f63          	bltz	a0,9b0 <unlinkread+0xde>
     8f6:	84aa                	mv	s1,a0
  write(fd, "hello", SZ);
     8f8:	4615                	li	a2,5
     8fa:	00005597          	auipc	a1,0x5
     8fe:	08658593          	addi	a1,a1,134 # 5980 <malloc+0x474>
     902:	724040ef          	jal	5026 <write>
  close(fd);
     906:	8526                	mv	a0,s1
     908:	726040ef          	jal	502e <close>
  fd = open("unlinkread", O_RDWR);
     90c:	4589                	li	a1,2
     90e:	00005517          	auipc	a0,0x5
     912:	04250513          	addi	a0,a0,66 # 5950 <malloc+0x444>
     916:	730040ef          	jal	5046 <open>
     91a:	84aa                	mv	s1,a0
  if(fd < 0){
     91c:	0a054463          	bltz	a0,9c4 <unlinkread+0xf2>
  if(unlink("unlinkread") != 0){
     920:	00005517          	auipc	a0,0x5
     924:	03050513          	addi	a0,a0,48 # 5950 <malloc+0x444>
     928:	72e040ef          	jal	5056 <unlink>
     92c:	e555                	bnez	a0,9d8 <unlinkread+0x106>
  fd1 = open("unlinkread", O_CREATE | O_RDWR);
     92e:	20200593          	li	a1,514
     932:	00005517          	auipc	a0,0x5
     936:	01e50513          	addi	a0,a0,30 # 5950 <malloc+0x444>
     93a:	70c040ef          	jal	5046 <open>
     93e:	892a                	mv	s2,a0
  write(fd1, "yyy", 3);
     940:	460d                	li	a2,3
     942:	00005597          	auipc	a1,0x5
     946:	08658593          	addi	a1,a1,134 # 59c8 <malloc+0x4bc>
     94a:	6dc040ef          	jal	5026 <write>
  close(fd1);
     94e:	854a                	mv	a0,s2
     950:	6de040ef          	jal	502e <close>
  if(read(fd, buf, sizeof(buf)) != SZ){
     954:	660d                	lui	a2,0x3
     956:	0000d597          	auipc	a1,0xd
     95a:	33258593          	addi	a1,a1,818 # dc88 <buf>
     95e:	8526                	mv	a0,s1
     960:	6be040ef          	jal	501e <read>
     964:	4795                	li	a5,5
     966:	08f51363          	bne	a0,a5,9ec <unlinkread+0x11a>
  if(buf[0] != 'h'){
     96a:	0000d717          	auipc	a4,0xd
     96e:	31e74703          	lbu	a4,798(a4) # dc88 <buf>
     972:	06800793          	li	a5,104
     976:	08f71563          	bne	a4,a5,a00 <unlinkread+0x12e>
  if(write(fd, buf, 10) != 10){
     97a:	4629                	li	a2,10
     97c:	0000d597          	auipc	a1,0xd
     980:	30c58593          	addi	a1,a1,780 # dc88 <buf>
     984:	8526                	mv	a0,s1
     986:	6a0040ef          	jal	5026 <write>
     98a:	47a9                	li	a5,10
     98c:	08f51463          	bne	a0,a5,a14 <unlinkread+0x142>
  close(fd);
     990:	8526                	mv	a0,s1
     992:	69c040ef          	jal	502e <close>
  unlink("unlinkread");
     996:	00005517          	auipc	a0,0x5
     99a:	fba50513          	addi	a0,a0,-70 # 5950 <malloc+0x444>
     99e:	6b8040ef          	jal	5056 <unlink>
}
     9a2:	70a2                	ld	ra,40(sp)
     9a4:	7402                	ld	s0,32(sp)
     9a6:	64e2                	ld	s1,24(sp)
     9a8:	6942                	ld	s2,16(sp)
     9aa:	69a2                	ld	s3,8(sp)
     9ac:	6145                	addi	sp,sp,48
     9ae:	8082                	ret
    printf("%s: create unlinkread failed\n", s);
     9b0:	85ce                	mv	a1,s3
     9b2:	00005517          	auipc	a0,0x5
     9b6:	fae50513          	addi	a0,a0,-82 # 5960 <malloc+0x454>
     9ba:	29b040ef          	jal	5454 <printf>
    exit(1);
     9be:	4505                	li	a0,1
     9c0:	646040ef          	jal	5006 <exit>
    printf("%s: open unlinkread failed\n", s);
     9c4:	85ce                	mv	a1,s3
     9c6:	00005517          	auipc	a0,0x5
     9ca:	fc250513          	addi	a0,a0,-62 # 5988 <malloc+0x47c>
     9ce:	287040ef          	jal	5454 <printf>
    exit(1);
     9d2:	4505                	li	a0,1
     9d4:	632040ef          	jal	5006 <exit>
    printf("%s: unlink unlinkread failed\n", s);
     9d8:	85ce                	mv	a1,s3
     9da:	00005517          	auipc	a0,0x5
     9de:	fce50513          	addi	a0,a0,-50 # 59a8 <malloc+0x49c>
     9e2:	273040ef          	jal	5454 <printf>
    exit(1);
     9e6:	4505                	li	a0,1
     9e8:	61e040ef          	jal	5006 <exit>
    printf("%s: unlinkread read failed", s);
     9ec:	85ce                	mv	a1,s3
     9ee:	00005517          	auipc	a0,0x5
     9f2:	fe250513          	addi	a0,a0,-30 # 59d0 <malloc+0x4c4>
     9f6:	25f040ef          	jal	5454 <printf>
    exit(1);
     9fa:	4505                	li	a0,1
     9fc:	60a040ef          	jal	5006 <exit>
    printf("%s: unlinkread wrong data\n", s);
     a00:	85ce                	mv	a1,s3
     a02:	00005517          	auipc	a0,0x5
     a06:	fee50513          	addi	a0,a0,-18 # 59f0 <malloc+0x4e4>
     a0a:	24b040ef          	jal	5454 <printf>
    exit(1);
     a0e:	4505                	li	a0,1
     a10:	5f6040ef          	jal	5006 <exit>
    printf("%s: unlinkread write failed\n", s);
     a14:	85ce                	mv	a1,s3
     a16:	00005517          	auipc	a0,0x5
     a1a:	ffa50513          	addi	a0,a0,-6 # 5a10 <malloc+0x504>
     a1e:	237040ef          	jal	5454 <printf>
    exit(1);
     a22:	4505                	li	a0,1
     a24:	5e2040ef          	jal	5006 <exit>

0000000000000a28 <linktest>:
{
     a28:	1101                	addi	sp,sp,-32
     a2a:	ec06                	sd	ra,24(sp)
     a2c:	e822                	sd	s0,16(sp)
     a2e:	e426                	sd	s1,8(sp)
     a30:	e04a                	sd	s2,0(sp)
     a32:	1000                	addi	s0,sp,32
     a34:	892a                	mv	s2,a0
  unlink("lf1");
     a36:	00005517          	auipc	a0,0x5
     a3a:	ffa50513          	addi	a0,a0,-6 # 5a30 <malloc+0x524>
     a3e:	618040ef          	jal	5056 <unlink>
  unlink("lf2");
     a42:	00005517          	auipc	a0,0x5
     a46:	ff650513          	addi	a0,a0,-10 # 5a38 <malloc+0x52c>
     a4a:	60c040ef          	jal	5056 <unlink>
  fd = open("lf1", O_CREATE|O_RDWR);
     a4e:	20200593          	li	a1,514
     a52:	00005517          	auipc	a0,0x5
     a56:	fde50513          	addi	a0,a0,-34 # 5a30 <malloc+0x524>
     a5a:	5ec040ef          	jal	5046 <open>
  if(fd < 0){
     a5e:	0c054f63          	bltz	a0,b3c <linktest+0x114>
     a62:	84aa                	mv	s1,a0
  if(write(fd, "hello", SZ) != SZ){
     a64:	4615                	li	a2,5
     a66:	00005597          	auipc	a1,0x5
     a6a:	f1a58593          	addi	a1,a1,-230 # 5980 <malloc+0x474>
     a6e:	5b8040ef          	jal	5026 <write>
     a72:	4795                	li	a5,5
     a74:	0cf51e63          	bne	a0,a5,b50 <linktest+0x128>
  close(fd);
     a78:	8526                	mv	a0,s1
     a7a:	5b4040ef          	jal	502e <close>
  if(link("lf1", "lf2") < 0){
     a7e:	00005597          	auipc	a1,0x5
     a82:	fba58593          	addi	a1,a1,-70 # 5a38 <malloc+0x52c>
     a86:	00005517          	auipc	a0,0x5
     a8a:	faa50513          	addi	a0,a0,-86 # 5a30 <malloc+0x524>
     a8e:	5d8040ef          	jal	5066 <link>
     a92:	0c054963          	bltz	a0,b64 <linktest+0x13c>
  unlink("lf1");
     a96:	00005517          	auipc	a0,0x5
     a9a:	f9a50513          	addi	a0,a0,-102 # 5a30 <malloc+0x524>
     a9e:	5b8040ef          	jal	5056 <unlink>
  if(open("lf1", 0) >= 0){
     aa2:	4581                	li	a1,0
     aa4:	00005517          	auipc	a0,0x5
     aa8:	f8c50513          	addi	a0,a0,-116 # 5a30 <malloc+0x524>
     aac:	59a040ef          	jal	5046 <open>
     ab0:	0c055463          	bgez	a0,b78 <linktest+0x150>
  fd = open("lf2", 0);
     ab4:	4581                	li	a1,0
     ab6:	00005517          	auipc	a0,0x5
     aba:	f8250513          	addi	a0,a0,-126 # 5a38 <malloc+0x52c>
     abe:	588040ef          	jal	5046 <open>
     ac2:	84aa                	mv	s1,a0
  if(fd < 0){
     ac4:	0c054463          	bltz	a0,b8c <linktest+0x164>
  if(read(fd, buf, sizeof(buf)) != SZ){
     ac8:	660d                	lui	a2,0x3
     aca:	0000d597          	auipc	a1,0xd
     ace:	1be58593          	addi	a1,a1,446 # dc88 <buf>
     ad2:	54c040ef          	jal	501e <read>
     ad6:	4795                	li	a5,5
     ad8:	0cf51463          	bne	a0,a5,ba0 <linktest+0x178>
  close(fd);
     adc:	8526                	mv	a0,s1
     ade:	550040ef          	jal	502e <close>
  if(link("lf2", "lf2") >= 0){
     ae2:	00005597          	auipc	a1,0x5
     ae6:	f5658593          	addi	a1,a1,-170 # 5a38 <malloc+0x52c>
     aea:	852e                	mv	a0,a1
     aec:	57a040ef          	jal	5066 <link>
     af0:	0c055263          	bgez	a0,bb4 <linktest+0x18c>
  unlink("lf2");
     af4:	00005517          	auipc	a0,0x5
     af8:	f4450513          	addi	a0,a0,-188 # 5a38 <malloc+0x52c>
     afc:	55a040ef          	jal	5056 <unlink>
  if(link("lf2", "lf1") >= 0){
     b00:	00005597          	auipc	a1,0x5
     b04:	f3058593          	addi	a1,a1,-208 # 5a30 <malloc+0x524>
     b08:	00005517          	auipc	a0,0x5
     b0c:	f3050513          	addi	a0,a0,-208 # 5a38 <malloc+0x52c>
     b10:	556040ef          	jal	5066 <link>
     b14:	0a055a63          	bgez	a0,bc8 <linktest+0x1a0>
  if(link(".", "lf1") >= 0){
     b18:	00005597          	auipc	a1,0x5
     b1c:	f1858593          	addi	a1,a1,-232 # 5a30 <malloc+0x524>
     b20:	00005517          	auipc	a0,0x5
     b24:	02050513          	addi	a0,a0,32 # 5b40 <malloc+0x634>
     b28:	53e040ef          	jal	5066 <link>
     b2c:	0a055863          	bgez	a0,bdc <linktest+0x1b4>
}
     b30:	60e2                	ld	ra,24(sp)
     b32:	6442                	ld	s0,16(sp)
     b34:	64a2                	ld	s1,8(sp)
     b36:	6902                	ld	s2,0(sp)
     b38:	6105                	addi	sp,sp,32
     b3a:	8082                	ret
    printf("%s: create lf1 failed\n", s);
     b3c:	85ca                	mv	a1,s2
     b3e:	00005517          	auipc	a0,0x5
     b42:	f0250513          	addi	a0,a0,-254 # 5a40 <malloc+0x534>
     b46:	10f040ef          	jal	5454 <printf>
    exit(1);
     b4a:	4505                	li	a0,1
     b4c:	4ba040ef          	jal	5006 <exit>
    printf("%s: write lf1 failed\n", s);
     b50:	85ca                	mv	a1,s2
     b52:	00005517          	auipc	a0,0x5
     b56:	f0650513          	addi	a0,a0,-250 # 5a58 <malloc+0x54c>
     b5a:	0fb040ef          	jal	5454 <printf>
    exit(1);
     b5e:	4505                	li	a0,1
     b60:	4a6040ef          	jal	5006 <exit>
    printf("%s: link lf1 lf2 failed\n", s);
     b64:	85ca                	mv	a1,s2
     b66:	00005517          	auipc	a0,0x5
     b6a:	f0a50513          	addi	a0,a0,-246 # 5a70 <malloc+0x564>
     b6e:	0e7040ef          	jal	5454 <printf>
    exit(1);
     b72:	4505                	li	a0,1
     b74:	492040ef          	jal	5006 <exit>
    printf("%s: unlinked lf1 but it is still there!\n", s);
     b78:	85ca                	mv	a1,s2
     b7a:	00005517          	auipc	a0,0x5
     b7e:	f1650513          	addi	a0,a0,-234 # 5a90 <malloc+0x584>
     b82:	0d3040ef          	jal	5454 <printf>
    exit(1);
     b86:	4505                	li	a0,1
     b88:	47e040ef          	jal	5006 <exit>
    printf("%s: open lf2 failed\n", s);
     b8c:	85ca                	mv	a1,s2
     b8e:	00005517          	auipc	a0,0x5
     b92:	f3250513          	addi	a0,a0,-206 # 5ac0 <malloc+0x5b4>
     b96:	0bf040ef          	jal	5454 <printf>
    exit(1);
     b9a:	4505                	li	a0,1
     b9c:	46a040ef          	jal	5006 <exit>
    printf("%s: read lf2 failed\n", s);
     ba0:	85ca                	mv	a1,s2
     ba2:	00005517          	auipc	a0,0x5
     ba6:	f3650513          	addi	a0,a0,-202 # 5ad8 <malloc+0x5cc>
     baa:	0ab040ef          	jal	5454 <printf>
    exit(1);
     bae:	4505                	li	a0,1
     bb0:	456040ef          	jal	5006 <exit>
    printf("%s: link lf2 lf2 succeeded! oops\n", s);
     bb4:	85ca                	mv	a1,s2
     bb6:	00005517          	auipc	a0,0x5
     bba:	f3a50513          	addi	a0,a0,-198 # 5af0 <malloc+0x5e4>
     bbe:	097040ef          	jal	5454 <printf>
    exit(1);
     bc2:	4505                	li	a0,1
     bc4:	442040ef          	jal	5006 <exit>
    printf("%s: link non-existent succeeded! oops\n", s);
     bc8:	85ca                	mv	a1,s2
     bca:	00005517          	auipc	a0,0x5
     bce:	f4e50513          	addi	a0,a0,-178 # 5b18 <malloc+0x60c>
     bd2:	083040ef          	jal	5454 <printf>
    exit(1);
     bd6:	4505                	li	a0,1
     bd8:	42e040ef          	jal	5006 <exit>
    printf("%s: link . lf1 succeeded! oops\n", s);
     bdc:	85ca                	mv	a1,s2
     bde:	00005517          	auipc	a0,0x5
     be2:	f6a50513          	addi	a0,a0,-150 # 5b48 <malloc+0x63c>
     be6:	06f040ef          	jal	5454 <printf>
    exit(1);
     bea:	4505                	li	a0,1
     bec:	41a040ef          	jal	5006 <exit>

0000000000000bf0 <validatetest>:
{
     bf0:	7139                	addi	sp,sp,-64
     bf2:	fc06                	sd	ra,56(sp)
     bf4:	f822                	sd	s0,48(sp)
     bf6:	f426                	sd	s1,40(sp)
     bf8:	f04a                	sd	s2,32(sp)
     bfa:	ec4e                	sd	s3,24(sp)
     bfc:	e852                	sd	s4,16(sp)
     bfe:	e456                	sd	s5,8(sp)
     c00:	e05a                	sd	s6,0(sp)
     c02:	0080                	addi	s0,sp,64
     c04:	8b2a                	mv	s6,a0
  for(p = 0; p <= (uint)hi; p += PGSIZE){
     c06:	4481                	li	s1,0
    if(link("nosuchfile", (char*)p) != -1){
     c08:	00005997          	auipc	s3,0x5
     c0c:	f6098993          	addi	s3,s3,-160 # 5b68 <malloc+0x65c>
     c10:	597d                	li	s2,-1
  for(p = 0; p <= (uint)hi; p += PGSIZE){
     c12:	6a85                	lui	s5,0x1
     c14:	00114a37          	lui	s4,0x114
    if(link("nosuchfile", (char*)p) != -1){
     c18:	85a6                	mv	a1,s1
     c1a:	854e                	mv	a0,s3
     c1c:	44a040ef          	jal	5066 <link>
     c20:	01251f63          	bne	a0,s2,c3e <validatetest+0x4e>
  for(p = 0; p <= (uint)hi; p += PGSIZE){
     c24:	94d6                	add	s1,s1,s5
     c26:	ff4499e3          	bne	s1,s4,c18 <validatetest+0x28>
}
     c2a:	70e2                	ld	ra,56(sp)
     c2c:	7442                	ld	s0,48(sp)
     c2e:	74a2                	ld	s1,40(sp)
     c30:	7902                	ld	s2,32(sp)
     c32:	69e2                	ld	s3,24(sp)
     c34:	6a42                	ld	s4,16(sp)
     c36:	6aa2                	ld	s5,8(sp)
     c38:	6b02                	ld	s6,0(sp)
     c3a:	6121                	addi	sp,sp,64
     c3c:	8082                	ret
      printf("%s: link should not succeed\n", s);
     c3e:	85da                	mv	a1,s6
     c40:	00005517          	auipc	a0,0x5
     c44:	f3850513          	addi	a0,a0,-200 # 5b78 <malloc+0x66c>
     c48:	00d040ef          	jal	5454 <printf>
      exit(1);
     c4c:	4505                	li	a0,1
     c4e:	3b8040ef          	jal	5006 <exit>

0000000000000c52 <bigdir>:
{
     c52:	711d                	addi	sp,sp,-96
     c54:	ec86                	sd	ra,88(sp)
     c56:	e8a2                	sd	s0,80(sp)
     c58:	e4a6                	sd	s1,72(sp)
     c5a:	e0ca                	sd	s2,64(sp)
     c5c:	fc4e                	sd	s3,56(sp)
     c5e:	f852                	sd	s4,48(sp)
     c60:	f456                	sd	s5,40(sp)
     c62:	f05a                	sd	s6,32(sp)
     c64:	ec5e                	sd	s7,24(sp)
     c66:	1080                	addi	s0,sp,96
     c68:	8baa                	mv	s7,a0
  unlink("bd");
     c6a:	00005517          	auipc	a0,0x5
     c6e:	f2e50513          	addi	a0,a0,-210 # 5b98 <malloc+0x68c>
     c72:	3e4040ef          	jal	5056 <unlink>
  fd = open("bd", O_CREATE);
     c76:	20000593          	li	a1,512
     c7a:	00005517          	auipc	a0,0x5
     c7e:	f1e50513          	addi	a0,a0,-226 # 5b98 <malloc+0x68c>
     c82:	3c4040ef          	jal	5046 <open>
  if(fd < 0){
     c86:	0c054463          	bltz	a0,d4e <bigdir+0xfc>
  close(fd);
     c8a:	3a4040ef          	jal	502e <close>
  for(i = 0; i < N; i++){
     c8e:	4901                	li	s2,0
    name[0] = 'x';
     c90:	07800a93          	li	s5,120
    if(link("bd", name) != 0){
     c94:	fa040a13          	addi	s4,s0,-96
     c98:	00005997          	auipc	s3,0x5
     c9c:	f0098993          	addi	s3,s3,-256 # 5b98 <malloc+0x68c>
  for(i = 0; i < N; i++){
     ca0:	1f400b13          	li	s6,500
    name[0] = 'x';
     ca4:	fb540023          	sb	s5,-96(s0)
    name[1] = '0' + (i / 64);
     ca8:	41f9571b          	sraiw	a4,s2,0x1f
     cac:	01a7571b          	srliw	a4,a4,0x1a
     cb0:	012707bb          	addw	a5,a4,s2
     cb4:	4067d69b          	sraiw	a3,a5,0x6
     cb8:	0306869b          	addiw	a3,a3,48
     cbc:	fad400a3          	sb	a3,-95(s0)
    name[2] = '0' + (i % 64);
     cc0:	03f7f793          	andi	a5,a5,63
     cc4:	9f99                	subw	a5,a5,a4
     cc6:	0307879b          	addiw	a5,a5,48
     cca:	faf40123          	sb	a5,-94(s0)
    name[3] = '\0';
     cce:	fa0401a3          	sb	zero,-93(s0)
    if(link("bd", name) != 0){
     cd2:	85d2                	mv	a1,s4
     cd4:	854e                	mv	a0,s3
     cd6:	390040ef          	jal	5066 <link>
     cda:	84aa                	mv	s1,a0
     cdc:	e159                	bnez	a0,d62 <bigdir+0x110>
  for(i = 0; i < N; i++){
     cde:	2905                	addiw	s2,s2,1
     ce0:	fd6912e3          	bne	s2,s6,ca4 <bigdir+0x52>
  unlink("bd");
     ce4:	00005517          	auipc	a0,0x5
     ce8:	eb450513          	addi	a0,a0,-332 # 5b98 <malloc+0x68c>
     cec:	36a040ef          	jal	5056 <unlink>
    name[0] = 'x';
     cf0:	07800993          	li	s3,120
    if(unlink(name) != 0){
     cf4:	fa040913          	addi	s2,s0,-96
  for(i = 0; i < N; i++){
     cf8:	1f400a13          	li	s4,500
    name[0] = 'x';
     cfc:	fb340023          	sb	s3,-96(s0)
    name[1] = '0' + (i / 64);
     d00:	41f4d71b          	sraiw	a4,s1,0x1f
     d04:	01a7571b          	srliw	a4,a4,0x1a
     d08:	009707bb          	addw	a5,a4,s1
     d0c:	4067d69b          	sraiw	a3,a5,0x6
     d10:	0306869b          	addiw	a3,a3,48
     d14:	fad400a3          	sb	a3,-95(s0)
    name[2] = '0' + (i % 64);
     d18:	03f7f793          	andi	a5,a5,63
     d1c:	9f99                	subw	a5,a5,a4
     d1e:	0307879b          	addiw	a5,a5,48
     d22:	faf40123          	sb	a5,-94(s0)
    name[3] = '\0';
     d26:	fa0401a3          	sb	zero,-93(s0)
    if(unlink(name) != 0){
     d2a:	854a                	mv	a0,s2
     d2c:	32a040ef          	jal	5056 <unlink>
     d30:	e531                	bnez	a0,d7c <bigdir+0x12a>
  for(i = 0; i < N; i++){
     d32:	2485                	addiw	s1,s1,1
     d34:	fd4494e3          	bne	s1,s4,cfc <bigdir+0xaa>
}
     d38:	60e6                	ld	ra,88(sp)
     d3a:	6446                	ld	s0,80(sp)
     d3c:	64a6                	ld	s1,72(sp)
     d3e:	6906                	ld	s2,64(sp)
     d40:	79e2                	ld	s3,56(sp)
     d42:	7a42                	ld	s4,48(sp)
     d44:	7aa2                	ld	s5,40(sp)
     d46:	7b02                	ld	s6,32(sp)
     d48:	6be2                	ld	s7,24(sp)
     d4a:	6125                	addi	sp,sp,96
     d4c:	8082                	ret
    printf("%s: bigdir create failed\n", s);
     d4e:	85de                	mv	a1,s7
     d50:	00005517          	auipc	a0,0x5
     d54:	e5050513          	addi	a0,a0,-432 # 5ba0 <malloc+0x694>
     d58:	6fc040ef          	jal	5454 <printf>
    exit(1);
     d5c:	4505                	li	a0,1
     d5e:	2a8040ef          	jal	5006 <exit>
      printf("%s: bigdir i=%d link(bd, %s) failed\n", s, i, name);
     d62:	fa040693          	addi	a3,s0,-96
     d66:	864a                	mv	a2,s2
     d68:	85de                	mv	a1,s7
     d6a:	00005517          	auipc	a0,0x5
     d6e:	e5650513          	addi	a0,a0,-426 # 5bc0 <malloc+0x6b4>
     d72:	6e2040ef          	jal	5454 <printf>
      exit(1);
     d76:	4505                	li	a0,1
     d78:	28e040ef          	jal	5006 <exit>
      printf("%s: bigdir unlink failed", s);
     d7c:	85de                	mv	a1,s7
     d7e:	00005517          	auipc	a0,0x5
     d82:	e6a50513          	addi	a0,a0,-406 # 5be8 <malloc+0x6dc>
     d86:	6ce040ef          	jal	5454 <printf>
      exit(1);
     d8a:	4505                	li	a0,1
     d8c:	27a040ef          	jal	5006 <exit>

0000000000000d90 <pgbug>:
{
     d90:	7179                	addi	sp,sp,-48
     d92:	f406                	sd	ra,40(sp)
     d94:	f022                	sd	s0,32(sp)
     d96:	ec26                	sd	s1,24(sp)
     d98:	1800                	addi	s0,sp,48
  argv[0] = 0;
     d9a:	fc043c23          	sd	zero,-40(s0)
  exec(big, argv);
     d9e:	00009497          	auipc	s1,0x9
     da2:	26248493          	addi	s1,s1,610 # a000 <big>
     da6:	fd840593          	addi	a1,s0,-40
     daa:	6088                	ld	a0,0(s1)
     dac:	292040ef          	jal	503e <exec>
  pipe(big);
     db0:	6088                	ld	a0,0(s1)
     db2:	264040ef          	jal	5016 <pipe>
  exit(0);
     db6:	4501                	li	a0,0
     db8:	24e040ef          	jal	5006 <exit>

0000000000000dbc <badarg>:
{
     dbc:	7139                	addi	sp,sp,-64
     dbe:	fc06                	sd	ra,56(sp)
     dc0:	f822                	sd	s0,48(sp)
     dc2:	f426                	sd	s1,40(sp)
     dc4:	f04a                	sd	s2,32(sp)
     dc6:	ec4e                	sd	s3,24(sp)
     dc8:	e852                	sd	s4,16(sp)
     dca:	0080                	addi	s0,sp,64
     dcc:	64b1                	lui	s1,0xc
     dce:	35048493          	addi	s1,s1,848 # c350 <uninit+0xdd8>
    argv[0] = (char*)0xffffffff;
     dd2:	597d                	li	s2,-1
     dd4:	02095913          	srli	s2,s2,0x20
    exec("echo", argv);
     dd8:	fc040a13          	addi	s4,s0,-64
     ddc:	00005997          	auipc	s3,0x5
     de0:	85c98993          	addi	s3,s3,-1956 # 5638 <malloc+0x12c>
    argv[0] = (char*)0xffffffff;
     de4:	fd243023          	sd	s2,-64(s0)
    argv[1] = 0;
     de8:	fc043423          	sd	zero,-56(s0)
    exec("echo", argv);
     dec:	85d2                	mv	a1,s4
     dee:	854e                	mv	a0,s3
     df0:	24e040ef          	jal	503e <exec>
  for(int i = 0; i < 50000; i++){
     df4:	34fd                	addiw	s1,s1,-1
     df6:	f4fd                	bnez	s1,de4 <badarg+0x28>
  exit(0);
     df8:	4501                	li	a0,0
     dfa:	20c040ef          	jal	5006 <exit>

0000000000000dfe <copyinstr2>:
{
     dfe:	7155                	addi	sp,sp,-208
     e00:	e586                	sd	ra,200(sp)
     e02:	e1a2                	sd	s0,192(sp)
     e04:	0980                	addi	s0,sp,208
  for(int i = 0; i < MAXPATH; i++)
     e06:	f6840793          	addi	a5,s0,-152
     e0a:	fe840693          	addi	a3,s0,-24
    b[i] = 'x';
     e0e:	07800713          	li	a4,120
     e12:	00e78023          	sb	a4,0(a5)
  for(int i = 0; i < MAXPATH; i++)
     e16:	0785                	addi	a5,a5,1
     e18:	fed79de3          	bne	a5,a3,e12 <copyinstr2+0x14>
  b[MAXPATH] = '\0';
     e1c:	fe040423          	sb	zero,-24(s0)
  int ret = unlink(b);
     e20:	f6840513          	addi	a0,s0,-152
     e24:	232040ef          	jal	5056 <unlink>
  if(ret != -1){
     e28:	57fd                	li	a5,-1
     e2a:	0cf51263          	bne	a0,a5,eee <copyinstr2+0xf0>
  int fd = open(b, O_CREATE | O_WRONLY);
     e2e:	20100593          	li	a1,513
     e32:	f6840513          	addi	a0,s0,-152
     e36:	210040ef          	jal	5046 <open>
  if(fd != -1){
     e3a:	57fd                	li	a5,-1
     e3c:	0cf51563          	bne	a0,a5,f06 <copyinstr2+0x108>
  ret = link(b, b);
     e40:	f6840513          	addi	a0,s0,-152
     e44:	85aa                	mv	a1,a0
     e46:	220040ef          	jal	5066 <link>
  if(ret != -1){
     e4a:	57fd                	li	a5,-1
     e4c:	0cf51963          	bne	a0,a5,f1e <copyinstr2+0x120>
  char *args[] = { "xx", 0 };
     e50:	00006797          	auipc	a5,0x6
     e54:	e9878793          	addi	a5,a5,-360 # 6ce8 <malloc+0x17dc>
     e58:	f4f43c23          	sd	a5,-168(s0)
     e5c:	f6043023          	sd	zero,-160(s0)
  ret = exec(b, args);
     e60:	f5840593          	addi	a1,s0,-168
     e64:	f6840513          	addi	a0,s0,-152
     e68:	1d6040ef          	jal	503e <exec>
  if(ret != -1){
     e6c:	57fd                	li	a5,-1
     e6e:	0cf51563          	bne	a0,a5,f38 <copyinstr2+0x13a>
  int pid = fork();
     e72:	18c040ef          	jal	4ffe <fork>
  if(pid < 0){
     e76:	0c054d63          	bltz	a0,f50 <copyinstr2+0x152>
  if(pid == 0){
     e7a:	0e051863          	bnez	a0,f6a <copyinstr2+0x16c>
     e7e:	00009797          	auipc	a5,0x9
     e82:	6f278793          	addi	a5,a5,1778 # a570 <big.0>
     e86:	0000a697          	auipc	a3,0xa
     e8a:	6ea68693          	addi	a3,a3,1770 # b570 <big.0+0x1000>
      big[i] = 'x';
     e8e:	07800713          	li	a4,120
     e92:	00e78023          	sb	a4,0(a5)
    for(int i = 0; i < PGSIZE; i++)
     e96:	0785                	addi	a5,a5,1
     e98:	fed79de3          	bne	a5,a3,e92 <copyinstr2+0x94>
    big[PGSIZE] = '\0';
     e9c:	0000a797          	auipc	a5,0xa
     ea0:	6c078a23          	sb	zero,1748(a5) # b570 <big.0+0x1000>
    char *args2[] = { big, big, big, 0 };
     ea4:	00007797          	auipc	a5,0x7
     ea8:	cb478793          	addi	a5,a5,-844 # 7b58 <malloc+0x264c>
     eac:	6fb0                	ld	a2,88(a5)
     eae:	73b4                	ld	a3,96(a5)
     eb0:	77b8                	ld	a4,104(a5)
     eb2:	f2c43823          	sd	a2,-208(s0)
     eb6:	f2d43c23          	sd	a3,-200(s0)
     eba:	f4e43023          	sd	a4,-192(s0)
     ebe:	7bbc                	ld	a5,112(a5)
     ec0:	f4f43423          	sd	a5,-184(s0)
    ret = exec("echo", args2);
     ec4:	f3040593          	addi	a1,s0,-208
     ec8:	00004517          	auipc	a0,0x4
     ecc:	77050513          	addi	a0,a0,1904 # 5638 <malloc+0x12c>
     ed0:	16e040ef          	jal	503e <exec>
    if(ret != -1){
     ed4:	57fd                	li	a5,-1
     ed6:	08f50663          	beq	a0,a5,f62 <copyinstr2+0x164>
      printf("exec(echo, BIG) returned %d, not -1\n", fd);
     eda:	85be                	mv	a1,a5
     edc:	00005517          	auipc	a0,0x5
     ee0:	db450513          	addi	a0,a0,-588 # 5c90 <malloc+0x784>
     ee4:	570040ef          	jal	5454 <printf>
      exit(1);
     ee8:	4505                	li	a0,1
     eea:	11c040ef          	jal	5006 <exit>
    printf("unlink(%s) returned %d, not -1\n", b, ret);
     eee:	862a                	mv	a2,a0
     ef0:	f6840593          	addi	a1,s0,-152
     ef4:	00005517          	auipc	a0,0x5
     ef8:	d1450513          	addi	a0,a0,-748 # 5c08 <malloc+0x6fc>
     efc:	558040ef          	jal	5454 <printf>
    exit(1);
     f00:	4505                	li	a0,1
     f02:	104040ef          	jal	5006 <exit>
    printf("open(%s) returned %d, not -1\n", b, fd);
     f06:	862a                	mv	a2,a0
     f08:	f6840593          	addi	a1,s0,-152
     f0c:	00005517          	auipc	a0,0x5
     f10:	d1c50513          	addi	a0,a0,-740 # 5c28 <malloc+0x71c>
     f14:	540040ef          	jal	5454 <printf>
    exit(1);
     f18:	4505                	li	a0,1
     f1a:	0ec040ef          	jal	5006 <exit>
    printf("link(%s, %s) returned %d, not -1\n", b, b, ret);
     f1e:	f6840593          	addi	a1,s0,-152
     f22:	86aa                	mv	a3,a0
     f24:	862e                	mv	a2,a1
     f26:	00005517          	auipc	a0,0x5
     f2a:	d2250513          	addi	a0,a0,-734 # 5c48 <malloc+0x73c>
     f2e:	526040ef          	jal	5454 <printf>
    exit(1);
     f32:	4505                	li	a0,1
     f34:	0d2040ef          	jal	5006 <exit>
    printf("exec(%s) returned %d, not -1\n", b, fd);
     f38:	863e                	mv	a2,a5
     f3a:	f6840593          	addi	a1,s0,-152
     f3e:	00005517          	auipc	a0,0x5
     f42:	d3250513          	addi	a0,a0,-718 # 5c70 <malloc+0x764>
     f46:	50e040ef          	jal	5454 <printf>
    exit(1);
     f4a:	4505                	li	a0,1
     f4c:	0ba040ef          	jal	5006 <exit>
    printf("fork failed\n");
     f50:	00006517          	auipc	a0,0x6
     f54:	2f050513          	addi	a0,a0,752 # 7240 <malloc+0x1d34>
     f58:	4fc040ef          	jal	5454 <printf>
    exit(1);
     f5c:	4505                	li	a0,1
     f5e:	0a8040ef          	jal	5006 <exit>
    exit(747); // OK
     f62:	2eb00513          	li	a0,747
     f66:	0a0040ef          	jal	5006 <exit>
  int st = 0;
     f6a:	f4042a23          	sw	zero,-172(s0)
  wait(&st);
     f6e:	f5440513          	addi	a0,s0,-172
     f72:	09c040ef          	jal	500e <wait>
  if(st != 747){
     f76:	f5442703          	lw	a4,-172(s0)
     f7a:	2eb00793          	li	a5,747
     f7e:	00f71663          	bne	a4,a5,f8a <copyinstr2+0x18c>
}
     f82:	60ae                	ld	ra,200(sp)
     f84:	640e                	ld	s0,192(sp)
     f86:	6169                	addi	sp,sp,208
     f88:	8082                	ret
    printf("exec(echo, BIG) succeeded, should have failed\n");
     f8a:	00005517          	auipc	a0,0x5
     f8e:	d2e50513          	addi	a0,a0,-722 # 5cb8 <malloc+0x7ac>
     f92:	4c2040ef          	jal	5454 <printf>
    exit(1);
     f96:	4505                	li	a0,1
     f98:	06e040ef          	jal	5006 <exit>

0000000000000f9c <truncate3>:
{
     f9c:	7175                	addi	sp,sp,-144
     f9e:	e506                	sd	ra,136(sp)
     fa0:	e122                	sd	s0,128(sp)
     fa2:	fc66                	sd	s9,56(sp)
     fa4:	0900                	addi	s0,sp,144
     fa6:	8caa                	mv	s9,a0
  close(open("truncfile", O_CREATE|O_TRUNC|O_WRONLY));
     fa8:	60100593          	li	a1,1537
     fac:	00004517          	auipc	a0,0x4
     fb0:	6e450513          	addi	a0,a0,1764 # 5690 <malloc+0x184>
     fb4:	092040ef          	jal	5046 <open>
     fb8:	076040ef          	jal	502e <close>
  pid = fork();
     fbc:	042040ef          	jal	4ffe <fork>
  if(pid < 0){
     fc0:	06054d63          	bltz	a0,103a <truncate3+0x9e>
  if(pid == 0){
     fc4:	e171                	bnez	a0,1088 <truncate3+0xec>
     fc6:	fca6                	sd	s1,120(sp)
     fc8:	f8ca                	sd	s2,112(sp)
     fca:	f4ce                	sd	s3,104(sp)
     fcc:	f0d2                	sd	s4,96(sp)
     fce:	ecd6                	sd	s5,88(sp)
     fd0:	e8da                	sd	s6,80(sp)
     fd2:	e4de                	sd	s7,72(sp)
     fd4:	e0e2                	sd	s8,64(sp)
     fd6:	06400913          	li	s2,100
      int fd = open("truncfile", O_WRONLY);
     fda:	4a85                	li	s5,1
     fdc:	00004997          	auipc	s3,0x4
     fe0:	6b498993          	addi	s3,s3,1716 # 5690 <malloc+0x184>
      int n = write(fd, "1234567890", 10);
     fe4:	4a29                	li	s4,10
     fe6:	00005b17          	auipc	s6,0x5
     fea:	d32b0b13          	addi	s6,s6,-718 # 5d18 <malloc+0x80c>
      read(fd, buf, sizeof(buf));
     fee:	f7840c13          	addi	s8,s0,-136
     ff2:	02000b93          	li	s7,32
      int fd = open("truncfile", O_WRONLY);
     ff6:	85d6                	mv	a1,s5
     ff8:	854e                	mv	a0,s3
     ffa:	04c040ef          	jal	5046 <open>
     ffe:	84aa                	mv	s1,a0
      if(fd < 0){
    1000:	04054f63          	bltz	a0,105e <truncate3+0xc2>
      int n = write(fd, "1234567890", 10);
    1004:	8652                	mv	a2,s4
    1006:	85da                	mv	a1,s6
    1008:	01e040ef          	jal	5026 <write>
      if(n != 10){
    100c:	07451363          	bne	a0,s4,1072 <truncate3+0xd6>
      close(fd);
    1010:	8526                	mv	a0,s1
    1012:	01c040ef          	jal	502e <close>
      fd = open("truncfile", O_RDONLY);
    1016:	4581                	li	a1,0
    1018:	854e                	mv	a0,s3
    101a:	02c040ef          	jal	5046 <open>
    101e:	84aa                	mv	s1,a0
      read(fd, buf, sizeof(buf));
    1020:	865e                	mv	a2,s7
    1022:	85e2                	mv	a1,s8
    1024:	7fb030ef          	jal	501e <read>
      close(fd);
    1028:	8526                	mv	a0,s1
    102a:	004040ef          	jal	502e <close>
    for(int i = 0; i < 100; i++){
    102e:	397d                	addiw	s2,s2,-1
    1030:	fc0913e3          	bnez	s2,ff6 <truncate3+0x5a>
    exit(0);
    1034:	4501                	li	a0,0
    1036:	7d1030ef          	jal	5006 <exit>
    103a:	fca6                	sd	s1,120(sp)
    103c:	f8ca                	sd	s2,112(sp)
    103e:	f4ce                	sd	s3,104(sp)
    1040:	f0d2                	sd	s4,96(sp)
    1042:	ecd6                	sd	s5,88(sp)
    1044:	e8da                	sd	s6,80(sp)
    1046:	e4de                	sd	s7,72(sp)
    1048:	e0e2                	sd	s8,64(sp)
    printf("%s: fork failed\n", s);
    104a:	85e6                	mv	a1,s9
    104c:	00005517          	auipc	a0,0x5
    1050:	c9c50513          	addi	a0,a0,-868 # 5ce8 <malloc+0x7dc>
    1054:	400040ef          	jal	5454 <printf>
    exit(1);
    1058:	4505                	li	a0,1
    105a:	7ad030ef          	jal	5006 <exit>
        printf("%s: open failed\n", s);
    105e:	85e6                	mv	a1,s9
    1060:	00005517          	auipc	a0,0x5
    1064:	ca050513          	addi	a0,a0,-864 # 5d00 <malloc+0x7f4>
    1068:	3ec040ef          	jal	5454 <printf>
        exit(1);
    106c:	4505                	li	a0,1
    106e:	799030ef          	jal	5006 <exit>
        printf("%s: write got %d, expected 10\n", s, n);
    1072:	862a                	mv	a2,a0
    1074:	85e6                	mv	a1,s9
    1076:	00005517          	auipc	a0,0x5
    107a:	cb250513          	addi	a0,a0,-846 # 5d28 <malloc+0x81c>
    107e:	3d6040ef          	jal	5454 <printf>
        exit(1);
    1082:	4505                	li	a0,1
    1084:	783030ef          	jal	5006 <exit>
    1088:	fca6                	sd	s1,120(sp)
    108a:	f8ca                	sd	s2,112(sp)
    108c:	f4ce                	sd	s3,104(sp)
    108e:	f0d2                	sd	s4,96(sp)
    1090:	ecd6                	sd	s5,88(sp)
    1092:	e8da                	sd	s6,80(sp)
    1094:	09600913          	li	s2,150
    int fd = open("truncfile", O_CREATE|O_WRONLY|O_TRUNC);
    1098:	60100a93          	li	s5,1537
    109c:	00004a17          	auipc	s4,0x4
    10a0:	5f4a0a13          	addi	s4,s4,1524 # 5690 <malloc+0x184>
    int n = write(fd, "xxx", 3);
    10a4:	498d                	li	s3,3
    10a6:	00005b17          	auipc	s6,0x5
    10aa:	ca2b0b13          	addi	s6,s6,-862 # 5d48 <malloc+0x83c>
    int fd = open("truncfile", O_CREATE|O_WRONLY|O_TRUNC);
    10ae:	85d6                	mv	a1,s5
    10b0:	8552                	mv	a0,s4
    10b2:	795030ef          	jal	5046 <open>
    10b6:	84aa                	mv	s1,a0
    if(fd < 0){
    10b8:	02054e63          	bltz	a0,10f4 <truncate3+0x158>
    int n = write(fd, "xxx", 3);
    10bc:	864e                	mv	a2,s3
    10be:	85da                	mv	a1,s6
    10c0:	767030ef          	jal	5026 <write>
    if(n != 3){
    10c4:	05351463          	bne	a0,s3,110c <truncate3+0x170>
    close(fd);
    10c8:	8526                	mv	a0,s1
    10ca:	765030ef          	jal	502e <close>
  for(int i = 0; i < 150; i++){
    10ce:	397d                	addiw	s2,s2,-1
    10d0:	fc091fe3          	bnez	s2,10ae <truncate3+0x112>
    10d4:	e4de                	sd	s7,72(sp)
    10d6:	e0e2                	sd	s8,64(sp)
  wait(&xstatus);
    10d8:	f9c40513          	addi	a0,s0,-100
    10dc:	733030ef          	jal	500e <wait>
  unlink("truncfile");
    10e0:	00004517          	auipc	a0,0x4
    10e4:	5b050513          	addi	a0,a0,1456 # 5690 <malloc+0x184>
    10e8:	76f030ef          	jal	5056 <unlink>
  exit(xstatus);
    10ec:	f9c42503          	lw	a0,-100(s0)
    10f0:	717030ef          	jal	5006 <exit>
    10f4:	e4de                	sd	s7,72(sp)
    10f6:	e0e2                	sd	s8,64(sp)
      printf("%s: open failed\n", s);
    10f8:	85e6                	mv	a1,s9
    10fa:	00005517          	auipc	a0,0x5
    10fe:	c0650513          	addi	a0,a0,-1018 # 5d00 <malloc+0x7f4>
    1102:	352040ef          	jal	5454 <printf>
      exit(1);
    1106:	4505                	li	a0,1
    1108:	6ff030ef          	jal	5006 <exit>
    110c:	e4de                	sd	s7,72(sp)
    110e:	e0e2                	sd	s8,64(sp)
      printf("%s: write got %d, expected 3\n", s, n);
    1110:	862a                	mv	a2,a0
    1112:	85e6                	mv	a1,s9
    1114:	00005517          	auipc	a0,0x5
    1118:	c3c50513          	addi	a0,a0,-964 # 5d50 <malloc+0x844>
    111c:	338040ef          	jal	5454 <printf>
      exit(1);
    1120:	4505                	li	a0,1
    1122:	6e5030ef          	jal	5006 <exit>

0000000000001126 <exectest>:
{
    1126:	715d                	addi	sp,sp,-80
    1128:	e486                	sd	ra,72(sp)
    112a:	e0a2                	sd	s0,64(sp)
    112c:	f84a                	sd	s2,48(sp)
    112e:	0880                	addi	s0,sp,80
    1130:	892a                	mv	s2,a0
  char *echoargv[] = { "echo", "OK", 0 };
    1132:	00004797          	auipc	a5,0x4
    1136:	50678793          	addi	a5,a5,1286 # 5638 <malloc+0x12c>
    113a:	fcf43023          	sd	a5,-64(s0)
    113e:	00005797          	auipc	a5,0x5
    1142:	c3278793          	addi	a5,a5,-974 # 5d70 <malloc+0x864>
    1146:	fcf43423          	sd	a5,-56(s0)
    114a:	fc043823          	sd	zero,-48(s0)
  unlink("echo-ok");
    114e:	00005517          	auipc	a0,0x5
    1152:	c2a50513          	addi	a0,a0,-982 # 5d78 <malloc+0x86c>
    1156:	701030ef          	jal	5056 <unlink>
  pid = fork();
    115a:	6a5030ef          	jal	4ffe <fork>
  if(pid < 0) {
    115e:	02054f63          	bltz	a0,119c <exectest+0x76>
    1162:	fc26                	sd	s1,56(sp)
    1164:	84aa                	mv	s1,a0
  if(pid == 0) {
    1166:	e935                	bnez	a0,11da <exectest+0xb4>
    close(1);
    1168:	4505                	li	a0,1
    116a:	6c5030ef          	jal	502e <close>
    fd = open("echo-ok", O_CREATE|O_WRONLY);
    116e:	20100593          	li	a1,513
    1172:	00005517          	auipc	a0,0x5
    1176:	c0650513          	addi	a0,a0,-1018 # 5d78 <malloc+0x86c>
    117a:	6cd030ef          	jal	5046 <open>
    if(fd < 0) {
    117e:	02054a63          	bltz	a0,11b2 <exectest+0x8c>
    if(fd != 1) {
    1182:	4785                	li	a5,1
    1184:	04f50163          	beq	a0,a5,11c6 <exectest+0xa0>
      printf("%s: wrong fd\n", s);
    1188:	85ca                	mv	a1,s2
    118a:	00005517          	auipc	a0,0x5
    118e:	c0e50513          	addi	a0,a0,-1010 # 5d98 <malloc+0x88c>
    1192:	2c2040ef          	jal	5454 <printf>
      exit(1);
    1196:	4505                	li	a0,1
    1198:	66f030ef          	jal	5006 <exit>
    119c:	fc26                	sd	s1,56(sp)
     printf("%s: fork failed\n", s);
    119e:	85ca                	mv	a1,s2
    11a0:	00005517          	auipc	a0,0x5
    11a4:	b4850513          	addi	a0,a0,-1208 # 5ce8 <malloc+0x7dc>
    11a8:	2ac040ef          	jal	5454 <printf>
     exit(1);
    11ac:	4505                	li	a0,1
    11ae:	659030ef          	jal	5006 <exit>
      printf("%s: create failed\n", s);
    11b2:	85ca                	mv	a1,s2
    11b4:	00005517          	auipc	a0,0x5
    11b8:	bcc50513          	addi	a0,a0,-1076 # 5d80 <malloc+0x874>
    11bc:	298040ef          	jal	5454 <printf>
      exit(1);
    11c0:	4505                	li	a0,1
    11c2:	645030ef          	jal	5006 <exit>
    if(exec("echo", echoargv) < 0){
    11c6:	fc040593          	addi	a1,s0,-64
    11ca:	00004517          	auipc	a0,0x4
    11ce:	46e50513          	addi	a0,a0,1134 # 5638 <malloc+0x12c>
    11d2:	66d030ef          	jal	503e <exec>
    11d6:	00054d63          	bltz	a0,11f0 <exectest+0xca>
  if (wait(&xstatus) != pid) {
    11da:	fdc40513          	addi	a0,s0,-36
    11de:	631030ef          	jal	500e <wait>
    11e2:	02951163          	bne	a0,s1,1204 <exectest+0xde>
  if(xstatus != 0)
    11e6:	fdc42503          	lw	a0,-36(s0)
    11ea:	c50d                	beqz	a0,1214 <exectest+0xee>
    exit(xstatus);
    11ec:	61b030ef          	jal	5006 <exit>
      printf("%s: exec echo failed\n", s);
    11f0:	85ca                	mv	a1,s2
    11f2:	00005517          	auipc	a0,0x5
    11f6:	bb650513          	addi	a0,a0,-1098 # 5da8 <malloc+0x89c>
    11fa:	25a040ef          	jal	5454 <printf>
      exit(1);
    11fe:	4505                	li	a0,1
    1200:	607030ef          	jal	5006 <exit>
    printf("%s: wait failed!\n", s);
    1204:	85ca                	mv	a1,s2
    1206:	00005517          	auipc	a0,0x5
    120a:	bba50513          	addi	a0,a0,-1094 # 5dc0 <malloc+0x8b4>
    120e:	246040ef          	jal	5454 <printf>
    1212:	bfd1                	j	11e6 <exectest+0xc0>
  fd = open("echo-ok", O_RDONLY);
    1214:	4581                	li	a1,0
    1216:	00005517          	auipc	a0,0x5
    121a:	b6250513          	addi	a0,a0,-1182 # 5d78 <malloc+0x86c>
    121e:	629030ef          	jal	5046 <open>
  if(fd < 0) {
    1222:	02054463          	bltz	a0,124a <exectest+0x124>
  if (read(fd, buf, 2) != 2) {
    1226:	4609                	li	a2,2
    1228:	fb840593          	addi	a1,s0,-72
    122c:	5f3030ef          	jal	501e <read>
    1230:	4789                	li	a5,2
    1232:	02f50663          	beq	a0,a5,125e <exectest+0x138>
    printf("%s: read failed\n", s);
    1236:	85ca                	mv	a1,s2
    1238:	00005517          	auipc	a0,0x5
    123c:	ba050513          	addi	a0,a0,-1120 # 5dd8 <malloc+0x8cc>
    1240:	214040ef          	jal	5454 <printf>
    exit(1);
    1244:	4505                	li	a0,1
    1246:	5c1030ef          	jal	5006 <exit>
    printf("%s: open failed\n", s);
    124a:	85ca                	mv	a1,s2
    124c:	00005517          	auipc	a0,0x5
    1250:	ab450513          	addi	a0,a0,-1356 # 5d00 <malloc+0x7f4>
    1254:	200040ef          	jal	5454 <printf>
    exit(1);
    1258:	4505                	li	a0,1
    125a:	5ad030ef          	jal	5006 <exit>
  unlink("echo-ok");
    125e:	00005517          	auipc	a0,0x5
    1262:	b1a50513          	addi	a0,a0,-1254 # 5d78 <malloc+0x86c>
    1266:	5f1030ef          	jal	5056 <unlink>
  if(buf[0] == 'O' && buf[1] == 'K')
    126a:	fb844703          	lbu	a4,-72(s0)
    126e:	04f00793          	li	a5,79
    1272:	00f71863          	bne	a4,a5,1282 <exectest+0x15c>
    1276:	fb944703          	lbu	a4,-71(s0)
    127a:	04b00793          	li	a5,75
    127e:	00f70c63          	beq	a4,a5,1296 <exectest+0x170>
    printf("%s: wrong output\n", s);
    1282:	85ca                	mv	a1,s2
    1284:	00005517          	auipc	a0,0x5
    1288:	b6c50513          	addi	a0,a0,-1172 # 5df0 <malloc+0x8e4>
    128c:	1c8040ef          	jal	5454 <printf>
    exit(1);
    1290:	4505                	li	a0,1
    1292:	575030ef          	jal	5006 <exit>
    exit(0);
    1296:	4501                	li	a0,0
    1298:	56f030ef          	jal	5006 <exit>

000000000000129c <exitwait>:
{
    129c:	715d                	addi	sp,sp,-80
    129e:	e486                	sd	ra,72(sp)
    12a0:	e0a2                	sd	s0,64(sp)
    12a2:	fc26                	sd	s1,56(sp)
    12a4:	f84a                	sd	s2,48(sp)
    12a6:	f44e                	sd	s3,40(sp)
    12a8:	f052                	sd	s4,32(sp)
    12aa:	ec56                	sd	s5,24(sp)
    12ac:	0880                	addi	s0,sp,80
    12ae:	8aaa                	mv	s5,a0
  for(i = 0; i < 100; i++){
    12b0:	4901                	li	s2,0
      if(wait(&xstate) != pid){
    12b2:	fbc40993          	addi	s3,s0,-68
  for(i = 0; i < 100; i++){
    12b6:	06400a13          	li	s4,100
    pid = fork();
    12ba:	545030ef          	jal	4ffe <fork>
    12be:	84aa                	mv	s1,a0
    if(pid < 0){
    12c0:	02054863          	bltz	a0,12f0 <exitwait+0x54>
    if(pid){
    12c4:	c525                	beqz	a0,132c <exitwait+0x90>
      if(wait(&xstate) != pid){
    12c6:	854e                	mv	a0,s3
    12c8:	547030ef          	jal	500e <wait>
    12cc:	02951c63          	bne	a0,s1,1304 <exitwait+0x68>
      if(i != xstate) {
    12d0:	fbc42783          	lw	a5,-68(s0)
    12d4:	05279263          	bne	a5,s2,1318 <exitwait+0x7c>
  for(i = 0; i < 100; i++){
    12d8:	2905                	addiw	s2,s2,1
    12da:	ff4910e3          	bne	s2,s4,12ba <exitwait+0x1e>
}
    12de:	60a6                	ld	ra,72(sp)
    12e0:	6406                	ld	s0,64(sp)
    12e2:	74e2                	ld	s1,56(sp)
    12e4:	7942                	ld	s2,48(sp)
    12e6:	79a2                	ld	s3,40(sp)
    12e8:	7a02                	ld	s4,32(sp)
    12ea:	6ae2                	ld	s5,24(sp)
    12ec:	6161                	addi	sp,sp,80
    12ee:	8082                	ret
      printf("%s: fork failed\n", s);
    12f0:	85d6                	mv	a1,s5
    12f2:	00005517          	auipc	a0,0x5
    12f6:	9f650513          	addi	a0,a0,-1546 # 5ce8 <malloc+0x7dc>
    12fa:	15a040ef          	jal	5454 <printf>
      exit(1);
    12fe:	4505                	li	a0,1
    1300:	507030ef          	jal	5006 <exit>
        printf("%s: wait wrong pid\n", s);
    1304:	85d6                	mv	a1,s5
    1306:	00005517          	auipc	a0,0x5
    130a:	b0250513          	addi	a0,a0,-1278 # 5e08 <malloc+0x8fc>
    130e:	146040ef          	jal	5454 <printf>
        exit(1);
    1312:	4505                	li	a0,1
    1314:	4f3030ef          	jal	5006 <exit>
        printf("%s: wait wrong exit status\n", s);
    1318:	85d6                	mv	a1,s5
    131a:	00005517          	auipc	a0,0x5
    131e:	b0650513          	addi	a0,a0,-1274 # 5e20 <malloc+0x914>
    1322:	132040ef          	jal	5454 <printf>
        exit(1);
    1326:	4505                	li	a0,1
    1328:	4df030ef          	jal	5006 <exit>
      exit(i);
    132c:	854a                	mv	a0,s2
    132e:	4d9030ef          	jal	5006 <exit>

0000000000001332 <twochildren>:
{
    1332:	1101                	addi	sp,sp,-32
    1334:	ec06                	sd	ra,24(sp)
    1336:	e822                	sd	s0,16(sp)
    1338:	e426                	sd	s1,8(sp)
    133a:	e04a                	sd	s2,0(sp)
    133c:	1000                	addi	s0,sp,32
    133e:	892a                	mv	s2,a0
    1340:	3e800493          	li	s1,1000
    int pid1 = fork();
    1344:	4bb030ef          	jal	4ffe <fork>
    if(pid1 < 0){
    1348:	02054663          	bltz	a0,1374 <twochildren+0x42>
    if(pid1 == 0){
    134c:	cd15                	beqz	a0,1388 <twochildren+0x56>
      int pid2 = fork();
    134e:	4b1030ef          	jal	4ffe <fork>
      if(pid2 < 0){
    1352:	02054d63          	bltz	a0,138c <twochildren+0x5a>
      if(pid2 == 0){
    1356:	c529                	beqz	a0,13a0 <twochildren+0x6e>
        wait(0);
    1358:	4501                	li	a0,0
    135a:	4b5030ef          	jal	500e <wait>
        wait(0);
    135e:	4501                	li	a0,0
    1360:	4af030ef          	jal	500e <wait>
  for(int i = 0; i < 1000; i++){
    1364:	34fd                	addiw	s1,s1,-1
    1366:	fcf9                	bnez	s1,1344 <twochildren+0x12>
}
    1368:	60e2                	ld	ra,24(sp)
    136a:	6442                	ld	s0,16(sp)
    136c:	64a2                	ld	s1,8(sp)
    136e:	6902                	ld	s2,0(sp)
    1370:	6105                	addi	sp,sp,32
    1372:	8082                	ret
      printf("%s: fork failed\n", s);
    1374:	85ca                	mv	a1,s2
    1376:	00005517          	auipc	a0,0x5
    137a:	97250513          	addi	a0,a0,-1678 # 5ce8 <malloc+0x7dc>
    137e:	0d6040ef          	jal	5454 <printf>
      exit(1);
    1382:	4505                	li	a0,1
    1384:	483030ef          	jal	5006 <exit>
      exit(0);
    1388:	47f030ef          	jal	5006 <exit>
        printf("%s: fork failed\n", s);
    138c:	85ca                	mv	a1,s2
    138e:	00005517          	auipc	a0,0x5
    1392:	95a50513          	addi	a0,a0,-1702 # 5ce8 <malloc+0x7dc>
    1396:	0be040ef          	jal	5454 <printf>
        exit(1);
    139a:	4505                	li	a0,1
    139c:	46b030ef          	jal	5006 <exit>
        exit(0);
    13a0:	467030ef          	jal	5006 <exit>

00000000000013a4 <forkfork>:
{
    13a4:	7179                	addi	sp,sp,-48
    13a6:	f406                	sd	ra,40(sp)
    13a8:	f022                	sd	s0,32(sp)
    13aa:	ec26                	sd	s1,24(sp)
    13ac:	1800                	addi	s0,sp,48
    13ae:	84aa                	mv	s1,a0
    int pid = fork();
    13b0:	44f030ef          	jal	4ffe <fork>
    if(pid < 0){
    13b4:	02054b63          	bltz	a0,13ea <forkfork+0x46>
    if(pid == 0){
    13b8:	c139                	beqz	a0,13fe <forkfork+0x5a>
    int pid = fork();
    13ba:	445030ef          	jal	4ffe <fork>
    if(pid < 0){
    13be:	02054663          	bltz	a0,13ea <forkfork+0x46>
    if(pid == 0){
    13c2:	cd15                	beqz	a0,13fe <forkfork+0x5a>
    wait(&xstatus);
    13c4:	fdc40513          	addi	a0,s0,-36
    13c8:	447030ef          	jal	500e <wait>
    if(xstatus != 0) {
    13cc:	fdc42783          	lw	a5,-36(s0)
    13d0:	ebb9                	bnez	a5,1426 <forkfork+0x82>
    wait(&xstatus);
    13d2:	fdc40513          	addi	a0,s0,-36
    13d6:	439030ef          	jal	500e <wait>
    if(xstatus != 0) {
    13da:	fdc42783          	lw	a5,-36(s0)
    13de:	e7a1                	bnez	a5,1426 <forkfork+0x82>
}
    13e0:	70a2                	ld	ra,40(sp)
    13e2:	7402                	ld	s0,32(sp)
    13e4:	64e2                	ld	s1,24(sp)
    13e6:	6145                	addi	sp,sp,48
    13e8:	8082                	ret
      printf("%s: fork failed", s);
    13ea:	85a6                	mv	a1,s1
    13ec:	00005517          	auipc	a0,0x5
    13f0:	a5450513          	addi	a0,a0,-1452 # 5e40 <malloc+0x934>
    13f4:	060040ef          	jal	5454 <printf>
      exit(1);
    13f8:	4505                	li	a0,1
    13fa:	40d030ef          	jal	5006 <exit>
{
    13fe:	0c800493          	li	s1,200
        int pid1 = fork();
    1402:	3fd030ef          	jal	4ffe <fork>
        if(pid1 < 0){
    1406:	00054b63          	bltz	a0,141c <forkfork+0x78>
        if(pid1 == 0){
    140a:	cd01                	beqz	a0,1422 <forkfork+0x7e>
        wait(0);
    140c:	4501                	li	a0,0
    140e:	401030ef          	jal	500e <wait>
      for(int j = 0; j < 200; j++){
    1412:	34fd                	addiw	s1,s1,-1
    1414:	f4fd                	bnez	s1,1402 <forkfork+0x5e>
      exit(0);
    1416:	4501                	li	a0,0
    1418:	3ef030ef          	jal	5006 <exit>
          exit(1);
    141c:	4505                	li	a0,1
    141e:	3e9030ef          	jal	5006 <exit>
          exit(0);
    1422:	3e5030ef          	jal	5006 <exit>
      printf("%s: fork in child failed", s);
    1426:	85a6                	mv	a1,s1
    1428:	00005517          	auipc	a0,0x5
    142c:	a2850513          	addi	a0,a0,-1496 # 5e50 <malloc+0x944>
    1430:	024040ef          	jal	5454 <printf>
      exit(1);
    1434:	4505                	li	a0,1
    1436:	3d1030ef          	jal	5006 <exit>

000000000000143a <reparent2>:
{
    143a:	1101                	addi	sp,sp,-32
    143c:	ec06                	sd	ra,24(sp)
    143e:	e822                	sd	s0,16(sp)
    1440:	e426                	sd	s1,8(sp)
    1442:	1000                	addi	s0,sp,32
    1444:	32000493          	li	s1,800
    int pid1 = fork();
    1448:	3b7030ef          	jal	4ffe <fork>
    if(pid1 < 0){
    144c:	00054b63          	bltz	a0,1462 <reparent2+0x28>
    if(pid1 == 0){
    1450:	c115                	beqz	a0,1474 <reparent2+0x3a>
    wait(0);
    1452:	4501                	li	a0,0
    1454:	3bb030ef          	jal	500e <wait>
  for(int i = 0; i < 800; i++){
    1458:	34fd                	addiw	s1,s1,-1
    145a:	f4fd                	bnez	s1,1448 <reparent2+0xe>
  exit(0);
    145c:	4501                	li	a0,0
    145e:	3a9030ef          	jal	5006 <exit>
      printf("fork failed\n");
    1462:	00006517          	auipc	a0,0x6
    1466:	dde50513          	addi	a0,a0,-546 # 7240 <malloc+0x1d34>
    146a:	7eb030ef          	jal	5454 <printf>
      exit(1);
    146e:	4505                	li	a0,1
    1470:	397030ef          	jal	5006 <exit>
      fork();
    1474:	38b030ef          	jal	4ffe <fork>
      fork();
    1478:	387030ef          	jal	4ffe <fork>
      exit(0);
    147c:	4501                	li	a0,0
    147e:	389030ef          	jal	5006 <exit>

0000000000001482 <createdelete>:
{
    1482:	7135                	addi	sp,sp,-160
    1484:	ed06                	sd	ra,152(sp)
    1486:	e922                	sd	s0,144(sp)
    1488:	e526                	sd	s1,136(sp)
    148a:	e14a                	sd	s2,128(sp)
    148c:	fcce                	sd	s3,120(sp)
    148e:	f8d2                	sd	s4,112(sp)
    1490:	f4d6                	sd	s5,104(sp)
    1492:	f0da                	sd	s6,96(sp)
    1494:	ecde                	sd	s7,88(sp)
    1496:	e8e2                	sd	s8,80(sp)
    1498:	e4e6                	sd	s9,72(sp)
    149a:	e0ea                	sd	s10,64(sp)
    149c:	fc6e                	sd	s11,56(sp)
    149e:	1100                	addi	s0,sp,160
    14a0:	8daa                	mv	s11,a0
  for(pi = 0; pi < NCHILD; pi++){
    14a2:	4901                	li	s2,0
    14a4:	4991                	li	s3,4
    pid = fork();
    14a6:	359030ef          	jal	4ffe <fork>
    14aa:	84aa                	mv	s1,a0
    if(pid < 0){
    14ac:	04054063          	bltz	a0,14ec <createdelete+0x6a>
    if(pid == 0){
    14b0:	c921                	beqz	a0,1500 <createdelete+0x7e>
  for(pi = 0; pi < NCHILD; pi++){
    14b2:	2905                	addiw	s2,s2,1
    14b4:	ff3919e3          	bne	s2,s3,14a6 <createdelete+0x24>
    14b8:	4491                	li	s1,4
    wait(&xstatus);
    14ba:	f6c40913          	addi	s2,s0,-148
    14be:	854a                	mv	a0,s2
    14c0:	34f030ef          	jal	500e <wait>
    if(xstatus != 0)
    14c4:	f6c42a83          	lw	s5,-148(s0)
    14c8:	0c0a9263          	bnez	s5,158c <createdelete+0x10a>
  for(pi = 0; pi < NCHILD; pi++){
    14cc:	34fd                	addiw	s1,s1,-1
    14ce:	f8e5                	bnez	s1,14be <createdelete+0x3c>
  name[0] = name[1] = name[2] = 0;
    14d0:	f6040923          	sb	zero,-142(s0)
    14d4:	03000913          	li	s2,48
    14d8:	5a7d                	li	s4,-1
      if((i == 0 || i >= N/2) && fd < 0){
    14da:	4d25                	li	s10,9
    14dc:	07000c93          	li	s9,112
      fd = open(name, 0);
    14e0:	f7040c13          	addi	s8,s0,-144
      } else if((i >= 1 && i < N/2) && fd >= 0){
    14e4:	4ba1                	li	s7,8
    for(pi = 0; pi < NCHILD; pi++){
    14e6:	07400b13          	li	s6,116
    14ea:	aa39                	j	1608 <createdelete+0x186>
      printf("%s: fork failed\n", s);
    14ec:	85ee                	mv	a1,s11
    14ee:	00004517          	auipc	a0,0x4
    14f2:	7fa50513          	addi	a0,a0,2042 # 5ce8 <malloc+0x7dc>
    14f6:	75f030ef          	jal	5454 <printf>
      exit(1);
    14fa:	4505                	li	a0,1
    14fc:	30b030ef          	jal	5006 <exit>
      name[0] = 'p' + pi;
    1500:	0709091b          	addiw	s2,s2,112
    1504:	f7240823          	sb	s2,-144(s0)
      name[2] = '\0';
    1508:	f6040923          	sb	zero,-142(s0)
        fd = open(name, O_CREATE | O_RDWR);
    150c:	f7040913          	addi	s2,s0,-144
    1510:	20200993          	li	s3,514
      for(i = 0; i < N; i++){
    1514:	4a51                	li	s4,20
    1516:	a815                	j	154a <createdelete+0xc8>
          printf("%s: create failed\n", s);
    1518:	85ee                	mv	a1,s11
    151a:	00005517          	auipc	a0,0x5
    151e:	86650513          	addi	a0,a0,-1946 # 5d80 <malloc+0x874>
    1522:	733030ef          	jal	5454 <printf>
          exit(1);
    1526:	4505                	li	a0,1
    1528:	2df030ef          	jal	5006 <exit>
          name[1] = '0' + (i / 2);
    152c:	01f4d79b          	srliw	a5,s1,0x1f
    1530:	9fa5                	addw	a5,a5,s1
    1532:	4017d79b          	sraiw	a5,a5,0x1
    1536:	0307879b          	addiw	a5,a5,48
    153a:	f6f408a3          	sb	a5,-143(s0)
          if(unlink(name) < 0){
    153e:	854a                	mv	a0,s2
    1540:	317030ef          	jal	5056 <unlink>
    1544:	02054a63          	bltz	a0,1578 <createdelete+0xf6>
      for(i = 0; i < N; i++){
    1548:	2485                	addiw	s1,s1,1
        name[1] = '0' + i;
    154a:	0304879b          	addiw	a5,s1,48
    154e:	f6f408a3          	sb	a5,-143(s0)
        fd = open(name, O_CREATE | O_RDWR);
    1552:	85ce                	mv	a1,s3
    1554:	854a                	mv	a0,s2
    1556:	2f1030ef          	jal	5046 <open>
        if(fd < 0){
    155a:	fa054fe3          	bltz	a0,1518 <createdelete+0x96>
        close(fd);
    155e:	2d1030ef          	jal	502e <close>
        if(i > 0 && (i % 2 ) == 0){
    1562:	fe9053e3          	blez	s1,1548 <createdelete+0xc6>
    1566:	0014f793          	andi	a5,s1,1
    156a:	d3e9                	beqz	a5,152c <createdelete+0xaa>
      for(i = 0; i < N; i++){
    156c:	2485                	addiw	s1,s1,1
    156e:	fd449ee3          	bne	s1,s4,154a <createdelete+0xc8>
      exit(0);
    1572:	4501                	li	a0,0
    1574:	293030ef          	jal	5006 <exit>
            printf("%s: unlink failed\n", s);
    1578:	85ee                	mv	a1,s11
    157a:	00005517          	auipc	a0,0x5
    157e:	8f650513          	addi	a0,a0,-1802 # 5e70 <malloc+0x964>
    1582:	6d3030ef          	jal	5454 <printf>
            exit(1);
    1586:	4505                	li	a0,1
    1588:	27f030ef          	jal	5006 <exit>
      exit(1);
    158c:	4505                	li	a0,1
    158e:	279030ef          	jal	5006 <exit>
      } else if((i >= 1 && i < N/2) && fd >= 0){
    1592:	054bf263          	bgeu	s7,s4,15d6 <createdelete+0x154>
      if(fd >= 0)
    1596:	04055e63          	bgez	a0,15f2 <createdelete+0x170>
    for(pi = 0; pi < NCHILD; pi++){
    159a:	2485                	addiw	s1,s1,1
    159c:	0ff4f493          	zext.b	s1,s1
    15a0:	05648c63          	beq	s1,s6,15f8 <createdelete+0x176>
      name[0] = 'p' + pi;
    15a4:	f6940823          	sb	s1,-144(s0)
      name[1] = '0' + i;
    15a8:	f72408a3          	sb	s2,-143(s0)
      fd = open(name, 0);
    15ac:	4581                	li	a1,0
    15ae:	8562                	mv	a0,s8
    15b0:	297030ef          	jal	5046 <open>
      if((i == 0 || i >= N/2) && fd < 0){
    15b4:	01f5579b          	srliw	a5,a0,0x1f
    15b8:	dfe9                	beqz	a5,1592 <createdelete+0x110>
    15ba:	fc098ce3          	beqz	s3,1592 <createdelete+0x110>
        printf("%s: oops createdelete %s didn't exist\n", s, name);
    15be:	f7040613          	addi	a2,s0,-144
    15c2:	85ee                	mv	a1,s11
    15c4:	00005517          	auipc	a0,0x5
    15c8:	8c450513          	addi	a0,a0,-1852 # 5e88 <malloc+0x97c>
    15cc:	689030ef          	jal	5454 <printf>
        exit(1);
    15d0:	4505                	li	a0,1
    15d2:	235030ef          	jal	5006 <exit>
      } else if((i >= 1 && i < N/2) && fd >= 0){
    15d6:	fc0542e3          	bltz	a0,159a <createdelete+0x118>
        printf("%s: oops createdelete %s did exist\n", s, name);
    15da:	f7040613          	addi	a2,s0,-144
    15de:	85ee                	mv	a1,s11
    15e0:	00005517          	auipc	a0,0x5
    15e4:	8d050513          	addi	a0,a0,-1840 # 5eb0 <malloc+0x9a4>
    15e8:	66d030ef          	jal	5454 <printf>
        exit(1);
    15ec:	4505                	li	a0,1
    15ee:	219030ef          	jal	5006 <exit>
        close(fd);
    15f2:	23d030ef          	jal	502e <close>
    15f6:	b755                	j	159a <createdelete+0x118>
  for(i = 0; i < N; i++){
    15f8:	2a85                	addiw	s5,s5,1 # 1001 <truncate3+0x65>
    15fa:	2a05                	addiw	s4,s4,1
    15fc:	2905                	addiw	s2,s2,1
    15fe:	0ff97913          	zext.b	s2,s2
    1602:	47d1                	li	a5,20
    1604:	00fa8a63          	beq	s5,a5,1618 <createdelete+0x196>
      if((i == 0 || i >= N/2) && fd < 0){
    1608:	001ab993          	seqz	s3,s5
    160c:	015d27b3          	slt	a5,s10,s5
    1610:	00f9e9b3          	or	s3,s3,a5
    1614:	84e6                	mv	s1,s9
    1616:	b779                	j	15a4 <createdelete+0x122>
    1618:	03000913          	li	s2,48
  name[0] = name[1] = name[2] = 0;
    161c:	07000b13          	li	s6,112
      unlink(name);
    1620:	f7040a13          	addi	s4,s0,-144
    for(pi = 0; pi < NCHILD; pi++){
    1624:	07400993          	li	s3,116
  for(i = 0; i < N; i++){
    1628:	04400a93          	li	s5,68
  name[0] = name[1] = name[2] = 0;
    162c:	84da                	mv	s1,s6
      name[0] = 'p' + pi;
    162e:	f6940823          	sb	s1,-144(s0)
      name[1] = '0' + i;
    1632:	f72408a3          	sb	s2,-143(s0)
      unlink(name);
    1636:	8552                	mv	a0,s4
    1638:	21f030ef          	jal	5056 <unlink>
    for(pi = 0; pi < NCHILD; pi++){
    163c:	2485                	addiw	s1,s1,1
    163e:	0ff4f493          	zext.b	s1,s1
    1642:	ff3496e3          	bne	s1,s3,162e <createdelete+0x1ac>
  for(i = 0; i < N; i++){
    1646:	2905                	addiw	s2,s2,1
    1648:	0ff97913          	zext.b	s2,s2
    164c:	ff5910e3          	bne	s2,s5,162c <createdelete+0x1aa>
}
    1650:	60ea                	ld	ra,152(sp)
    1652:	644a                	ld	s0,144(sp)
    1654:	64aa                	ld	s1,136(sp)
    1656:	690a                	ld	s2,128(sp)
    1658:	79e6                	ld	s3,120(sp)
    165a:	7a46                	ld	s4,112(sp)
    165c:	7aa6                	ld	s5,104(sp)
    165e:	7b06                	ld	s6,96(sp)
    1660:	6be6                	ld	s7,88(sp)
    1662:	6c46                	ld	s8,80(sp)
    1664:	6ca6                	ld	s9,72(sp)
    1666:	6d06                	ld	s10,64(sp)
    1668:	7de2                	ld	s11,56(sp)
    166a:	610d                	addi	sp,sp,160
    166c:	8082                	ret

000000000000166e <linkunlink>:
{
    166e:	711d                	addi	sp,sp,-96
    1670:	ec86                	sd	ra,88(sp)
    1672:	e8a2                	sd	s0,80(sp)
    1674:	e4a6                	sd	s1,72(sp)
    1676:	e0ca                	sd	s2,64(sp)
    1678:	fc4e                	sd	s3,56(sp)
    167a:	f852                	sd	s4,48(sp)
    167c:	f456                	sd	s5,40(sp)
    167e:	f05a                	sd	s6,32(sp)
    1680:	ec5e                	sd	s7,24(sp)
    1682:	e862                	sd	s8,16(sp)
    1684:	e466                	sd	s9,8(sp)
    1686:	e06a                	sd	s10,0(sp)
    1688:	1080                	addi	s0,sp,96
    168a:	84aa                	mv	s1,a0
  unlink("x");
    168c:	00004517          	auipc	a0,0x4
    1690:	01c50513          	addi	a0,a0,28 # 56a8 <malloc+0x19c>
    1694:	1c3030ef          	jal	5056 <unlink>
  pid = fork();
    1698:	167030ef          	jal	4ffe <fork>
  if(pid < 0){
    169c:	04054363          	bltz	a0,16e2 <linkunlink+0x74>
    16a0:	8d2a                	mv	s10,a0
  unsigned int x = (pid ? 1 : 97);
    16a2:	06100913          	li	s2,97
    16a6:	c111                	beqz	a0,16aa <linkunlink+0x3c>
    16a8:	4905                	li	s2,1
    16aa:	06400493          	li	s1,100
    x = x * 1103515245 + 12345;
    16ae:	41c65ab7          	lui	s5,0x41c65
    16b2:	e6da8a9b          	addiw	s5,s5,-403 # 41c64e6d <base+0x41c541e5>
    16b6:	6a0d                	lui	s4,0x3
    16b8:	039a0a1b          	addiw	s4,s4,57 # 3039 <dirfile+0x59>
    if((x % 3) == 0){
    16bc:	000ab9b7          	lui	s3,0xab
    16c0:	aab98993          	addi	s3,s3,-1365 # aaaab <base+0x99e23>
    16c4:	09b2                	slli	s3,s3,0xc
    16c6:	aab98993          	addi	s3,s3,-1365
    } else if((x % 3) == 1){
    16ca:	4b85                	li	s7,1
      unlink("x");
    16cc:	00004b17          	auipc	s6,0x4
    16d0:	fdcb0b13          	addi	s6,s6,-36 # 56a8 <malloc+0x19c>
      link("cat", "x");
    16d4:	00005c97          	auipc	s9,0x5
    16d8:	804c8c93          	addi	s9,s9,-2044 # 5ed8 <malloc+0x9cc>
      close(open("x", O_RDWR | O_CREATE));
    16dc:	20200c13          	li	s8,514
    16e0:	a03d                	j	170e <linkunlink+0xa0>
    printf("%s: fork failed\n", s);
    16e2:	85a6                	mv	a1,s1
    16e4:	00004517          	auipc	a0,0x4
    16e8:	60450513          	addi	a0,a0,1540 # 5ce8 <malloc+0x7dc>
    16ec:	569030ef          	jal	5454 <printf>
    exit(1);
    16f0:	4505                	li	a0,1
    16f2:	115030ef          	jal	5006 <exit>
      close(open("x", O_RDWR | O_CREATE));
    16f6:	85e2                	mv	a1,s8
    16f8:	855a                	mv	a0,s6
    16fa:	14d030ef          	jal	5046 <open>
    16fe:	131030ef          	jal	502e <close>
    1702:	a021                	j	170a <linkunlink+0x9c>
      unlink("x");
    1704:	855a                	mv	a0,s6
    1706:	151030ef          	jal	5056 <unlink>
  for(i = 0; i < 100; i++){
    170a:	34fd                	addiw	s1,s1,-1
    170c:	c885                	beqz	s1,173c <linkunlink+0xce>
    x = x * 1103515245 + 12345;
    170e:	035907bb          	mulw	a5,s2,s5
    1712:	00fa07bb          	addw	a5,s4,a5
    1716:	893e                	mv	s2,a5
    if((x % 3) == 0){
    1718:	02079713          	slli	a4,a5,0x20
    171c:	9301                	srli	a4,a4,0x20
    171e:	03370733          	mul	a4,a4,s3
    1722:	9305                	srli	a4,a4,0x21
    1724:	0017169b          	slliw	a3,a4,0x1
    1728:	9f35                	addw	a4,a4,a3
    172a:	9f99                	subw	a5,a5,a4
    172c:	d7e9                	beqz	a5,16f6 <linkunlink+0x88>
    } else if((x % 3) == 1){
    172e:	fd779be3          	bne	a5,s7,1704 <linkunlink+0x96>
      link("cat", "x");
    1732:	85da                	mv	a1,s6
    1734:	8566                	mv	a0,s9
    1736:	131030ef          	jal	5066 <link>
    173a:	bfc1                	j	170a <linkunlink+0x9c>
  if(pid)
    173c:	020d0363          	beqz	s10,1762 <linkunlink+0xf4>
    wait(0);
    1740:	4501                	li	a0,0
    1742:	0cd030ef          	jal	500e <wait>
}
    1746:	60e6                	ld	ra,88(sp)
    1748:	6446                	ld	s0,80(sp)
    174a:	64a6                	ld	s1,72(sp)
    174c:	6906                	ld	s2,64(sp)
    174e:	79e2                	ld	s3,56(sp)
    1750:	7a42                	ld	s4,48(sp)
    1752:	7aa2                	ld	s5,40(sp)
    1754:	7b02                	ld	s6,32(sp)
    1756:	6be2                	ld	s7,24(sp)
    1758:	6c42                	ld	s8,16(sp)
    175a:	6ca2                	ld	s9,8(sp)
    175c:	6d02                	ld	s10,0(sp)
    175e:	6125                	addi	sp,sp,96
    1760:	8082                	ret
    exit(0);
    1762:	4501                	li	a0,0
    1764:	0a3030ef          	jal	5006 <exit>

0000000000001768 <forktest>:
{
    1768:	7179                	addi	sp,sp,-48
    176a:	f406                	sd	ra,40(sp)
    176c:	f022                	sd	s0,32(sp)
    176e:	ec26                	sd	s1,24(sp)
    1770:	e84a                	sd	s2,16(sp)
    1772:	e44e                	sd	s3,8(sp)
    1774:	1800                	addi	s0,sp,48
    1776:	89aa                	mv	s3,a0
  for(n=0; n<N; n++){
    1778:	4481                	li	s1,0
    177a:	3e800913          	li	s2,1000
    pid = fork();
    177e:	081030ef          	jal	4ffe <fork>
    if(pid < 0)
    1782:	06054063          	bltz	a0,17e2 <forktest+0x7a>
    if(pid == 0)
    1786:	cd11                	beqz	a0,17a2 <forktest+0x3a>
  for(n=0; n<N; n++){
    1788:	2485                	addiw	s1,s1,1
    178a:	ff249ae3          	bne	s1,s2,177e <forktest+0x16>
    printf("%s: fork claimed to work 1000 times!\n", s);
    178e:	85ce                	mv	a1,s3
    1790:	00004517          	auipc	a0,0x4
    1794:	79850513          	addi	a0,a0,1944 # 5f28 <malloc+0xa1c>
    1798:	4bd030ef          	jal	5454 <printf>
    exit(1);
    179c:	4505                	li	a0,1
    179e:	069030ef          	jal	5006 <exit>
      exit(0);
    17a2:	065030ef          	jal	5006 <exit>
    printf("%s: no fork at all!\n", s);
    17a6:	85ce                	mv	a1,s3
    17a8:	00004517          	auipc	a0,0x4
    17ac:	73850513          	addi	a0,a0,1848 # 5ee0 <malloc+0x9d4>
    17b0:	4a5030ef          	jal	5454 <printf>
    exit(1);
    17b4:	4505                	li	a0,1
    17b6:	051030ef          	jal	5006 <exit>
      printf("%s: wait stopped early\n", s);
    17ba:	85ce                	mv	a1,s3
    17bc:	00004517          	auipc	a0,0x4
    17c0:	73c50513          	addi	a0,a0,1852 # 5ef8 <malloc+0x9ec>
    17c4:	491030ef          	jal	5454 <printf>
      exit(1);
    17c8:	4505                	li	a0,1
    17ca:	03d030ef          	jal	5006 <exit>
    printf("%s: wait got too many\n", s);
    17ce:	85ce                	mv	a1,s3
    17d0:	00004517          	auipc	a0,0x4
    17d4:	74050513          	addi	a0,a0,1856 # 5f10 <malloc+0xa04>
    17d8:	47d030ef          	jal	5454 <printf>
    exit(1);
    17dc:	4505                	li	a0,1
    17de:	029030ef          	jal	5006 <exit>
  if (n == 0) {
    17e2:	d0f1                	beqz	s1,17a6 <forktest+0x3e>
  for(; n > 0; n--){
    17e4:	00905963          	blez	s1,17f6 <forktest+0x8e>
    if(wait(0) < 0){
    17e8:	4501                	li	a0,0
    17ea:	025030ef          	jal	500e <wait>
    17ee:	fc0546e3          	bltz	a0,17ba <forktest+0x52>
  for(; n > 0; n--){
    17f2:	34fd                	addiw	s1,s1,-1
    17f4:	f8f5                	bnez	s1,17e8 <forktest+0x80>
  if(wait(0) != -1){
    17f6:	4501                	li	a0,0
    17f8:	017030ef          	jal	500e <wait>
    17fc:	57fd                	li	a5,-1
    17fe:	fcf518e3          	bne	a0,a5,17ce <forktest+0x66>
}
    1802:	70a2                	ld	ra,40(sp)
    1804:	7402                	ld	s0,32(sp)
    1806:	64e2                	ld	s1,24(sp)
    1808:	6942                	ld	s2,16(sp)
    180a:	69a2                	ld	s3,8(sp)
    180c:	6145                	addi	sp,sp,48
    180e:	8082                	ret

0000000000001810 <kernmem>:
{
    1810:	715d                	addi	sp,sp,-80
    1812:	e486                	sd	ra,72(sp)
    1814:	e0a2                	sd	s0,64(sp)
    1816:	fc26                	sd	s1,56(sp)
    1818:	f84a                	sd	s2,48(sp)
    181a:	f44e                	sd	s3,40(sp)
    181c:	f052                	sd	s4,32(sp)
    181e:	ec56                	sd	s5,24(sp)
    1820:	e85a                	sd	s6,16(sp)
    1822:	0880                	addi	s0,sp,80
    1824:	8b2a                	mv	s6,a0
  for(a = (char*)(KERNBASE); a < (char*) (KERNBASE+2000000); a += 50000){
    1826:	4485                	li	s1,1
    1828:	04fe                	slli	s1,s1,0x1f
    wait(&xstatus);
    182a:	fbc40a93          	addi	s5,s0,-68
    if(xstatus != -1)  // did kernel kill child?
    182e:	5a7d                	li	s4,-1
  for(a = (char*)(KERNBASE); a < (char*) (KERNBASE+2000000); a += 50000){
    1830:	69b1                	lui	s3,0xc
    1832:	35098993          	addi	s3,s3,848 # c350 <uninit+0xdd8>
    1836:	1003d937          	lui	s2,0x1003d
    183a:	090e                	slli	s2,s2,0x3
    183c:	48090913          	addi	s2,s2,1152 # 1003d480 <base+0x1002c7f8>
    pid = fork();
    1840:	7be030ef          	jal	4ffe <fork>
    if(pid < 0){
    1844:	02054763          	bltz	a0,1872 <kernmem+0x62>
    if(pid == 0){
    1848:	cd1d                	beqz	a0,1886 <kernmem+0x76>
    wait(&xstatus);
    184a:	8556                	mv	a0,s5
    184c:	7c2030ef          	jal	500e <wait>
    if(xstatus != -1)  // did kernel kill child?
    1850:	fbc42783          	lw	a5,-68(s0)
    1854:	05479663          	bne	a5,s4,18a0 <kernmem+0x90>
  for(a = (char*)(KERNBASE); a < (char*) (KERNBASE+2000000); a += 50000){
    1858:	94ce                	add	s1,s1,s3
    185a:	ff2493e3          	bne	s1,s2,1840 <kernmem+0x30>
}
    185e:	60a6                	ld	ra,72(sp)
    1860:	6406                	ld	s0,64(sp)
    1862:	74e2                	ld	s1,56(sp)
    1864:	7942                	ld	s2,48(sp)
    1866:	79a2                	ld	s3,40(sp)
    1868:	7a02                	ld	s4,32(sp)
    186a:	6ae2                	ld	s5,24(sp)
    186c:	6b42                	ld	s6,16(sp)
    186e:	6161                	addi	sp,sp,80
    1870:	8082                	ret
      printf("%s: fork failed\n", s);
    1872:	85da                	mv	a1,s6
    1874:	00004517          	auipc	a0,0x4
    1878:	47450513          	addi	a0,a0,1140 # 5ce8 <malloc+0x7dc>
    187c:	3d9030ef          	jal	5454 <printf>
      exit(1);
    1880:	4505                	li	a0,1
    1882:	784030ef          	jal	5006 <exit>
      printf("%s: oops could read %p = %x\n", s, a, *a);
    1886:	0004c683          	lbu	a3,0(s1)
    188a:	8626                	mv	a2,s1
    188c:	85da                	mv	a1,s6
    188e:	00004517          	auipc	a0,0x4
    1892:	6c250513          	addi	a0,a0,1730 # 5f50 <malloc+0xa44>
    1896:	3bf030ef          	jal	5454 <printf>
      exit(1);
    189a:	4505                	li	a0,1
    189c:	76a030ef          	jal	5006 <exit>
      exit(1);
    18a0:	4505                	li	a0,1
    18a2:	764030ef          	jal	5006 <exit>

00000000000018a6 <MAXVAplus>:
{
    18a6:	7139                	addi	sp,sp,-64
    18a8:	fc06                	sd	ra,56(sp)
    18aa:	f822                	sd	s0,48(sp)
    18ac:	0080                	addi	s0,sp,64
  volatile uint64 a = MAXVA;
    18ae:	4785                	li	a5,1
    18b0:	179a                	slli	a5,a5,0x26
    18b2:	fcf43423          	sd	a5,-56(s0)
  for( ; a != 0; a <<= 1){
    18b6:	fc843783          	ld	a5,-56(s0)
    18ba:	cf9d                	beqz	a5,18f8 <MAXVAplus+0x52>
    18bc:	f426                	sd	s1,40(sp)
    18be:	f04a                	sd	s2,32(sp)
    18c0:	ec4e                	sd	s3,24(sp)
    18c2:	89aa                	mv	s3,a0
    wait(&xstatus);
    18c4:	fc440913          	addi	s2,s0,-60
    if(xstatus != -1)  // did kernel kill child?
    18c8:	54fd                	li	s1,-1
    pid = fork();
    18ca:	734030ef          	jal	4ffe <fork>
    if(pid < 0){
    18ce:	02054963          	bltz	a0,1900 <MAXVAplus+0x5a>
    if(pid == 0){
    18d2:	c129                	beqz	a0,1914 <MAXVAplus+0x6e>
    wait(&xstatus);
    18d4:	854a                	mv	a0,s2
    18d6:	738030ef          	jal	500e <wait>
    if(xstatus != -1)  // did kernel kill child?
    18da:	fc442783          	lw	a5,-60(s0)
    18de:	04979d63          	bne	a5,s1,1938 <MAXVAplus+0x92>
  for( ; a != 0; a <<= 1){
    18e2:	fc843783          	ld	a5,-56(s0)
    18e6:	0786                	slli	a5,a5,0x1
    18e8:	fcf43423          	sd	a5,-56(s0)
    18ec:	fc843783          	ld	a5,-56(s0)
    18f0:	ffe9                	bnez	a5,18ca <MAXVAplus+0x24>
    18f2:	74a2                	ld	s1,40(sp)
    18f4:	7902                	ld	s2,32(sp)
    18f6:	69e2                	ld	s3,24(sp)
}
    18f8:	70e2                	ld	ra,56(sp)
    18fa:	7442                	ld	s0,48(sp)
    18fc:	6121                	addi	sp,sp,64
    18fe:	8082                	ret
      printf("%s: fork failed\n", s);
    1900:	85ce                	mv	a1,s3
    1902:	00004517          	auipc	a0,0x4
    1906:	3e650513          	addi	a0,a0,998 # 5ce8 <malloc+0x7dc>
    190a:	34b030ef          	jal	5454 <printf>
      exit(1);
    190e:	4505                	li	a0,1
    1910:	6f6030ef          	jal	5006 <exit>
      *(char*)a = 99;
    1914:	fc843783          	ld	a5,-56(s0)
    1918:	06300713          	li	a4,99
    191c:	00e78023          	sb	a4,0(a5)
      printf("%s: oops wrote %p\n", s, (void*)a);
    1920:	fc843603          	ld	a2,-56(s0)
    1924:	85ce                	mv	a1,s3
    1926:	00004517          	auipc	a0,0x4
    192a:	64a50513          	addi	a0,a0,1610 # 5f70 <malloc+0xa64>
    192e:	327030ef          	jal	5454 <printf>
      exit(1);
    1932:	4505                	li	a0,1
    1934:	6d2030ef          	jal	5006 <exit>
      exit(1);
    1938:	4505                	li	a0,1
    193a:	6cc030ef          	jal	5006 <exit>

000000000000193e <stacktest>:
{
    193e:	7179                	addi	sp,sp,-48
    1940:	f406                	sd	ra,40(sp)
    1942:	f022                	sd	s0,32(sp)
    1944:	ec26                	sd	s1,24(sp)
    1946:	1800                	addi	s0,sp,48
    1948:	84aa                	mv	s1,a0
  pid = fork();
    194a:	6b4030ef          	jal	4ffe <fork>
  if(pid == 0) {
    194e:	cd11                	beqz	a0,196a <stacktest+0x2c>
  } else if(pid < 0){
    1950:	02054c63          	bltz	a0,1988 <stacktest+0x4a>
  wait(&xstatus);
    1954:	fdc40513          	addi	a0,s0,-36
    1958:	6b6030ef          	jal	500e <wait>
  if(xstatus == -1)  // kernel killed child?
    195c:	fdc42503          	lw	a0,-36(s0)
    1960:	57fd                	li	a5,-1
    1962:	02f50d63          	beq	a0,a5,199c <stacktest+0x5e>
    exit(xstatus);
    1966:	6a0030ef          	jal	5006 <exit>

static inline uint64
r_sp()
{
  uint64 x;
  asm volatile("mv %0, sp" : "=r" (x) );
    196a:	878a                	mv	a5,sp
    printf("%s: stacktest: read below stack %d\n", s, *sp);
    196c:	80078793          	addi	a5,a5,-2048
    1970:	8007c603          	lbu	a2,-2048(a5)
    1974:	85a6                	mv	a1,s1
    1976:	00004517          	auipc	a0,0x4
    197a:	61250513          	addi	a0,a0,1554 # 5f88 <malloc+0xa7c>
    197e:	2d7030ef          	jal	5454 <printf>
    exit(1);
    1982:	4505                	li	a0,1
    1984:	682030ef          	jal	5006 <exit>
    printf("%s: fork failed\n", s);
    1988:	85a6                	mv	a1,s1
    198a:	00004517          	auipc	a0,0x4
    198e:	35e50513          	addi	a0,a0,862 # 5ce8 <malloc+0x7dc>
    1992:	2c3030ef          	jal	5454 <printf>
    exit(1);
    1996:	4505                	li	a0,1
    1998:	66e030ef          	jal	5006 <exit>
    exit(0);
    199c:	4501                	li	a0,0
    199e:	668030ef          	jal	5006 <exit>

00000000000019a2 <nowrite>:
{
    19a2:	7159                	addi	sp,sp,-112
    19a4:	f486                	sd	ra,104(sp)
    19a6:	f0a2                	sd	s0,96(sp)
    19a8:	eca6                	sd	s1,88(sp)
    19aa:	e8ca                	sd	s2,80(sp)
    19ac:	e4ce                	sd	s3,72(sp)
    19ae:	e0d2                	sd	s4,64(sp)
    19b0:	1880                	addi	s0,sp,112
    19b2:	8a2a                	mv	s4,a0
  uint64 addrs[] = { 0, 0x80000000LL, 0x3fffffe000, 0x3ffffff000, 0x4000000000,
    19b4:	00006797          	auipc	a5,0x6
    19b8:	1a478793          	addi	a5,a5,420 # 7b58 <malloc+0x264c>
    19bc:	7788                	ld	a0,40(a5)
    19be:	7b8c                	ld	a1,48(a5)
    19c0:	7f90                	ld	a2,56(a5)
    19c2:	63b4                	ld	a3,64(a5)
    19c4:	67b8                	ld	a4,72(a5)
    19c6:	f8a43c23          	sd	a0,-104(s0)
    19ca:	fab43023          	sd	a1,-96(s0)
    19ce:	fac43423          	sd	a2,-88(s0)
    19d2:	fad43823          	sd	a3,-80(s0)
    19d6:	fae43c23          	sd	a4,-72(s0)
    19da:	6bbc                	ld	a5,80(a5)
    19dc:	fcf43023          	sd	a5,-64(s0)
  for(int ai = 0; ai < sizeof(addrs)/sizeof(addrs[0]); ai++){
    19e0:	4481                	li	s1,0
    wait(&xstatus);
    19e2:	fcc40913          	addi	s2,s0,-52
  for(int ai = 0; ai < sizeof(addrs)/sizeof(addrs[0]); ai++){
    19e6:	4999                	li	s3,6
    pid = fork();
    19e8:	616030ef          	jal	4ffe <fork>
    if(pid == 0) {
    19ec:	cd19                	beqz	a0,1a0a <nowrite+0x68>
    } else if(pid < 0){
    19ee:	04054163          	bltz	a0,1a30 <nowrite+0x8e>
    wait(&xstatus);
    19f2:	854a                	mv	a0,s2
    19f4:	61a030ef          	jal	500e <wait>
    if(xstatus == 0){
    19f8:	fcc42783          	lw	a5,-52(s0)
    19fc:	c7a1                	beqz	a5,1a44 <nowrite+0xa2>
  for(int ai = 0; ai < sizeof(addrs)/sizeof(addrs[0]); ai++){
    19fe:	2485                	addiw	s1,s1,1
    1a00:	ff3494e3          	bne	s1,s3,19e8 <nowrite+0x46>
  exit(0);
    1a04:	4501                	li	a0,0
    1a06:	600030ef          	jal	5006 <exit>
      volatile int *addr = (int *) addrs[ai];
    1a0a:	048e                	slli	s1,s1,0x3
    1a0c:	fd048793          	addi	a5,s1,-48
    1a10:	008784b3          	add	s1,a5,s0
    1a14:	fc84b603          	ld	a2,-56(s1)
      *addr = 10;
    1a18:	47a9                	li	a5,10
    1a1a:	c21c                	sw	a5,0(a2)
      printf("%s: write to %p did not fail!\n", s, addr);
    1a1c:	85d2                	mv	a1,s4
    1a1e:	00004517          	auipc	a0,0x4
    1a22:	59250513          	addi	a0,a0,1426 # 5fb0 <malloc+0xaa4>
    1a26:	22f030ef          	jal	5454 <printf>
      exit(0);
    1a2a:	4501                	li	a0,0
    1a2c:	5da030ef          	jal	5006 <exit>
      printf("%s: fork failed\n", s);
    1a30:	85d2                	mv	a1,s4
    1a32:	00004517          	auipc	a0,0x4
    1a36:	2b650513          	addi	a0,a0,694 # 5ce8 <malloc+0x7dc>
    1a3a:	21b030ef          	jal	5454 <printf>
      exit(1);
    1a3e:	4505                	li	a0,1
    1a40:	5c6030ef          	jal	5006 <exit>
      exit(1);
    1a44:	4505                	li	a0,1
    1a46:	5c0030ef          	jal	5006 <exit>

0000000000001a4a <manywrites>:
{
    1a4a:	7159                	addi	sp,sp,-112
    1a4c:	f486                	sd	ra,104(sp)
    1a4e:	f0a2                	sd	s0,96(sp)
    1a50:	eca6                	sd	s1,88(sp)
    1a52:	e8ca                	sd	s2,80(sp)
    1a54:	e4ce                	sd	s3,72(sp)
    1a56:	ec66                	sd	s9,24(sp)
    1a58:	1880                	addi	s0,sp,112
    1a5a:	8caa                	mv	s9,a0
  for(int ci = 0; ci < nchildren; ci++){
    1a5c:	4901                	li	s2,0
    1a5e:	4991                	li	s3,4
    int pid = fork();
    1a60:	59e030ef          	jal	4ffe <fork>
    1a64:	84aa                	mv	s1,a0
    if(pid < 0){
    1a66:	02054c63          	bltz	a0,1a9e <manywrites+0x54>
    if(pid == 0){
    1a6a:	c929                	beqz	a0,1abc <manywrites+0x72>
  for(int ci = 0; ci < nchildren; ci++){
    1a6c:	2905                	addiw	s2,s2,1
    1a6e:	ff3919e3          	bne	s2,s3,1a60 <manywrites+0x16>
    1a72:	4491                	li	s1,4
    wait(&st);
    1a74:	f9840913          	addi	s2,s0,-104
    int st = 0;
    1a78:	f8042c23          	sw	zero,-104(s0)
    wait(&st);
    1a7c:	854a                	mv	a0,s2
    1a7e:	590030ef          	jal	500e <wait>
    if(st != 0)
    1a82:	f9842503          	lw	a0,-104(s0)
    1a86:	0e051763          	bnez	a0,1b74 <manywrites+0x12a>
  for(int ci = 0; ci < nchildren; ci++){
    1a8a:	34fd                	addiw	s1,s1,-1
    1a8c:	f4f5                	bnez	s1,1a78 <manywrites+0x2e>
    1a8e:	e0d2                	sd	s4,64(sp)
    1a90:	fc56                	sd	s5,56(sp)
    1a92:	f85a                	sd	s6,48(sp)
    1a94:	f45e                	sd	s7,40(sp)
    1a96:	f062                	sd	s8,32(sp)
    1a98:	e86a                	sd	s10,16(sp)
  exit(0);
    1a9a:	56c030ef          	jal	5006 <exit>
    1a9e:	e0d2                	sd	s4,64(sp)
    1aa0:	fc56                	sd	s5,56(sp)
    1aa2:	f85a                	sd	s6,48(sp)
    1aa4:	f45e                	sd	s7,40(sp)
    1aa6:	f062                	sd	s8,32(sp)
    1aa8:	e86a                	sd	s10,16(sp)
      printf("fork failed\n");
    1aaa:	00005517          	auipc	a0,0x5
    1aae:	79650513          	addi	a0,a0,1942 # 7240 <malloc+0x1d34>
    1ab2:	1a3030ef          	jal	5454 <printf>
      exit(1);
    1ab6:	4505                	li	a0,1
    1ab8:	54e030ef          	jal	5006 <exit>
    1abc:	e0d2                	sd	s4,64(sp)
    1abe:	fc56                	sd	s5,56(sp)
    1ac0:	f85a                	sd	s6,48(sp)
    1ac2:	f45e                	sd	s7,40(sp)
    1ac4:	f062                	sd	s8,32(sp)
    1ac6:	e86a                	sd	s10,16(sp)
      name[0] = 'b';
    1ac8:	06200793          	li	a5,98
    1acc:	f8f40c23          	sb	a5,-104(s0)
      name[1] = 'a' + ci;
    1ad0:	0619079b          	addiw	a5,s2,97
    1ad4:	f8f40ca3          	sb	a5,-103(s0)
      name[2] = '\0';
    1ad8:	f8040d23          	sb	zero,-102(s0)
      unlink(name);
    1adc:	f9840513          	addi	a0,s0,-104
    1ae0:	576030ef          	jal	5056 <unlink>
    1ae4:	47f9                	li	a5,30
    1ae6:	8d3e                	mv	s10,a5
          int fd = open(name, O_CREATE | O_RDWR);
    1ae8:	f9840b93          	addi	s7,s0,-104
    1aec:	20200b13          	li	s6,514
          int cc = write(fd, buf, sz);
    1af0:	6a8d                	lui	s5,0x3
    1af2:	0000cc17          	auipc	s8,0xc
    1af6:	196c0c13          	addi	s8,s8,406 # dc88 <buf>
        for(int i = 0; i < ci+1; i++){
    1afa:	8a26                	mv	s4,s1
    1afc:	02094563          	bltz	s2,1b26 <manywrites+0xdc>
          int fd = open(name, O_CREATE | O_RDWR);
    1b00:	85da                	mv	a1,s6
    1b02:	855e                	mv	a0,s7
    1b04:	542030ef          	jal	5046 <open>
    1b08:	89aa                	mv	s3,a0
          if(fd < 0){
    1b0a:	02054d63          	bltz	a0,1b44 <manywrites+0xfa>
          int cc = write(fd, buf, sz);
    1b0e:	8656                	mv	a2,s5
    1b10:	85e2                	mv	a1,s8
    1b12:	514030ef          	jal	5026 <write>
          if(cc != sz){
    1b16:	05551363          	bne	a0,s5,1b5c <manywrites+0x112>
          close(fd);
    1b1a:	854e                	mv	a0,s3
    1b1c:	512030ef          	jal	502e <close>
        for(int i = 0; i < ci+1; i++){
    1b20:	2a05                	addiw	s4,s4,1
    1b22:	fd495fe3          	bge	s2,s4,1b00 <manywrites+0xb6>
        unlink(name);
    1b26:	f9840513          	addi	a0,s0,-104
    1b2a:	52c030ef          	jal	5056 <unlink>
      for(int iters = 0; iters < howmany; iters++){
    1b2e:	fffd079b          	addiw	a5,s10,-1
    1b32:	8d3e                	mv	s10,a5
    1b34:	f3f9                	bnez	a5,1afa <manywrites+0xb0>
      unlink(name);
    1b36:	f9840513          	addi	a0,s0,-104
    1b3a:	51c030ef          	jal	5056 <unlink>
      exit(0);
    1b3e:	4501                	li	a0,0
    1b40:	4c6030ef          	jal	5006 <exit>
            printf("%s: cannot create %s\n", s, name);
    1b44:	f9840613          	addi	a2,s0,-104
    1b48:	85e6                	mv	a1,s9
    1b4a:	00004517          	auipc	a0,0x4
    1b4e:	48650513          	addi	a0,a0,1158 # 5fd0 <malloc+0xac4>
    1b52:	103030ef          	jal	5454 <printf>
            exit(1);
    1b56:	4505                	li	a0,1
    1b58:	4ae030ef          	jal	5006 <exit>
            printf("%s: write(%d) ret %d\n", s, sz, cc);
    1b5c:	86aa                	mv	a3,a0
    1b5e:	660d                	lui	a2,0x3
    1b60:	85e6                	mv	a1,s9
    1b62:	00004517          	auipc	a0,0x4
    1b66:	ba650513          	addi	a0,a0,-1114 # 5708 <malloc+0x1fc>
    1b6a:	0eb030ef          	jal	5454 <printf>
            exit(1);
    1b6e:	4505                	li	a0,1
    1b70:	496030ef          	jal	5006 <exit>
    1b74:	e0d2                	sd	s4,64(sp)
    1b76:	fc56                	sd	s5,56(sp)
    1b78:	f85a                	sd	s6,48(sp)
    1b7a:	f45e                	sd	s7,40(sp)
    1b7c:	f062                	sd	s8,32(sp)
    1b7e:	e86a                	sd	s10,16(sp)
      exit(st);
    1b80:	486030ef          	jal	5006 <exit>

0000000000001b84 <copyinstr3>:
{
    1b84:	7179                	addi	sp,sp,-48
    1b86:	f406                	sd	ra,40(sp)
    1b88:	f022                	sd	s0,32(sp)
    1b8a:	ec26                	sd	s1,24(sp)
    1b8c:	1800                	addi	s0,sp,48
  sbrk(8192);
    1b8e:	6509                	lui	a0,0x2
    1b90:	442030ef          	jal	4fd2 <sbrk>
  uint64 top = (uint64) sbrk(0);
    1b94:	4501                	li	a0,0
    1b96:	43c030ef          	jal	4fd2 <sbrk>
  if((top % PGSIZE) != 0){
    1b9a:	03451793          	slli	a5,a0,0x34
    1b9e:	e7bd                	bnez	a5,1c0c <copyinstr3+0x88>
  top = (uint64) sbrk(0);
    1ba0:	4501                	li	a0,0
    1ba2:	430030ef          	jal	4fd2 <sbrk>
  if(top % PGSIZE){
    1ba6:	03451793          	slli	a5,a0,0x34
    1baa:	ebad                	bnez	a5,1c1c <copyinstr3+0x98>
  char *b = (char *) (top - 1);
    1bac:	fff50493          	addi	s1,a0,-1 # 1fff <sbrkmuch+0x125>
  *b = 'x';
    1bb0:	07800793          	li	a5,120
    1bb4:	fef50fa3          	sb	a5,-1(a0)
  int ret = unlink(b);
    1bb8:	8526                	mv	a0,s1
    1bba:	49c030ef          	jal	5056 <unlink>
  if(ret != -1){
    1bbe:	57fd                	li	a5,-1
    1bc0:	06f51763          	bne	a0,a5,1c2e <copyinstr3+0xaa>
  int fd = open(b, O_CREATE | O_WRONLY);
    1bc4:	20100593          	li	a1,513
    1bc8:	8526                	mv	a0,s1
    1bca:	47c030ef          	jal	5046 <open>
  if(fd != -1){
    1bce:	57fd                	li	a5,-1
    1bd0:	06f51a63          	bne	a0,a5,1c44 <copyinstr3+0xc0>
  ret = link(b, b);
    1bd4:	85a6                	mv	a1,s1
    1bd6:	8526                	mv	a0,s1
    1bd8:	48e030ef          	jal	5066 <link>
  if(ret != -1){
    1bdc:	57fd                	li	a5,-1
    1bde:	06f51e63          	bne	a0,a5,1c5a <copyinstr3+0xd6>
  char *args[] = { "xx", 0 };
    1be2:	00005797          	auipc	a5,0x5
    1be6:	10678793          	addi	a5,a5,262 # 6ce8 <malloc+0x17dc>
    1bea:	fcf43823          	sd	a5,-48(s0)
    1bee:	fc043c23          	sd	zero,-40(s0)
  ret = exec(b, args);
    1bf2:	fd040593          	addi	a1,s0,-48
    1bf6:	8526                	mv	a0,s1
    1bf8:	446030ef          	jal	503e <exec>
  if(ret != -1){
    1bfc:	57fd                	li	a5,-1
    1bfe:	06f51a63          	bne	a0,a5,1c72 <copyinstr3+0xee>
}
    1c02:	70a2                	ld	ra,40(sp)
    1c04:	7402                	ld	s0,32(sp)
    1c06:	64e2                	ld	s1,24(sp)
    1c08:	6145                	addi	sp,sp,48
    1c0a:	8082                	ret
    sbrk(PGSIZE - (top % PGSIZE));
    1c0c:	0347d513          	srli	a0,a5,0x34
    1c10:	6785                	lui	a5,0x1
    1c12:	40a7853b          	subw	a0,a5,a0
    1c16:	3bc030ef          	jal	4fd2 <sbrk>
    1c1a:	b759                	j	1ba0 <copyinstr3+0x1c>
    printf("oops\n");
    1c1c:	00004517          	auipc	a0,0x4
    1c20:	3cc50513          	addi	a0,a0,972 # 5fe8 <malloc+0xadc>
    1c24:	031030ef          	jal	5454 <printf>
    exit(1);
    1c28:	4505                	li	a0,1
    1c2a:	3dc030ef          	jal	5006 <exit>
    printf("unlink(%s) returned %d, not -1\n", b, ret);
    1c2e:	862a                	mv	a2,a0
    1c30:	85a6                	mv	a1,s1
    1c32:	00004517          	auipc	a0,0x4
    1c36:	fd650513          	addi	a0,a0,-42 # 5c08 <malloc+0x6fc>
    1c3a:	01b030ef          	jal	5454 <printf>
    exit(1);
    1c3e:	4505                	li	a0,1
    1c40:	3c6030ef          	jal	5006 <exit>
    printf("open(%s) returned %d, not -1\n", b, fd);
    1c44:	862a                	mv	a2,a0
    1c46:	85a6                	mv	a1,s1
    1c48:	00004517          	auipc	a0,0x4
    1c4c:	fe050513          	addi	a0,a0,-32 # 5c28 <malloc+0x71c>
    1c50:	005030ef          	jal	5454 <printf>
    exit(1);
    1c54:	4505                	li	a0,1
    1c56:	3b0030ef          	jal	5006 <exit>
    printf("link(%s, %s) returned %d, not -1\n", b, b, ret);
    1c5a:	86aa                	mv	a3,a0
    1c5c:	8626                	mv	a2,s1
    1c5e:	85a6                	mv	a1,s1
    1c60:	00004517          	auipc	a0,0x4
    1c64:	fe850513          	addi	a0,a0,-24 # 5c48 <malloc+0x73c>
    1c68:	7ec030ef          	jal	5454 <printf>
    exit(1);
    1c6c:	4505                	li	a0,1
    1c6e:	398030ef          	jal	5006 <exit>
    printf("exec(%s) returned %d, not -1\n", b, fd);
    1c72:	863e                	mv	a2,a5
    1c74:	85a6                	mv	a1,s1
    1c76:	00004517          	auipc	a0,0x4
    1c7a:	ffa50513          	addi	a0,a0,-6 # 5c70 <malloc+0x764>
    1c7e:	7d6030ef          	jal	5454 <printf>
    exit(1);
    1c82:	4505                	li	a0,1
    1c84:	382030ef          	jal	5006 <exit>

0000000000001c88 <rwsbrk>:
{
    1c88:	1101                	addi	sp,sp,-32
    1c8a:	ec06                	sd	ra,24(sp)
    1c8c:	e822                	sd	s0,16(sp)
    1c8e:	1000                	addi	s0,sp,32
  uint64 a = (uint64) sbrk(8192);
    1c90:	6509                	lui	a0,0x2
    1c92:	340030ef          	jal	4fd2 <sbrk>
  if(a == (uint64) SBRK_ERROR) {
    1c96:	57fd                	li	a5,-1
    1c98:	04f50a63          	beq	a0,a5,1cec <rwsbrk+0x64>
    1c9c:	e426                	sd	s1,8(sp)
    1c9e:	84aa                	mv	s1,a0
  if (sbrk(-8192) == SBRK_ERROR) {
    1ca0:	7579                	lui	a0,0xffffe
    1ca2:	330030ef          	jal	4fd2 <sbrk>
    1ca6:	57fd                	li	a5,-1
    1ca8:	04f50d63          	beq	a0,a5,1d02 <rwsbrk+0x7a>
    1cac:	e04a                	sd	s2,0(sp)
  fd = open("rwsbrk", O_CREATE|O_WRONLY);
    1cae:	20100593          	li	a1,513
    1cb2:	00004517          	auipc	a0,0x4
    1cb6:	37650513          	addi	a0,a0,886 # 6028 <malloc+0xb1c>
    1cba:	38c030ef          	jal	5046 <open>
    1cbe:	892a                	mv	s2,a0
  if(fd < 0){
    1cc0:	04054b63          	bltz	a0,1d16 <rwsbrk+0x8e>
  n = write(fd, (void*)(a+PGSIZE), 1024);
    1cc4:	6785                	lui	a5,0x1
    1cc6:	94be                	add	s1,s1,a5
    1cc8:	40000613          	li	a2,1024
    1ccc:	85a6                	mv	a1,s1
    1cce:	358030ef          	jal	5026 <write>
    1cd2:	862a                	mv	a2,a0
  if(n >= 0){
    1cd4:	04054a63          	bltz	a0,1d28 <rwsbrk+0xa0>
    printf("write(fd, %p, 1024) returned %d, not -1\n", (void*)a+PGSIZE, n);
    1cd8:	85a6                	mv	a1,s1
    1cda:	00004517          	auipc	a0,0x4
    1cde:	36e50513          	addi	a0,a0,878 # 6048 <malloc+0xb3c>
    1ce2:	772030ef          	jal	5454 <printf>
    exit(1);
    1ce6:	4505                	li	a0,1
    1ce8:	31e030ef          	jal	5006 <exit>
    1cec:	e426                	sd	s1,8(sp)
    1cee:	e04a                	sd	s2,0(sp)
    printf("sbrk(rwsbrk) failed\n");
    1cf0:	00004517          	auipc	a0,0x4
    1cf4:	30050513          	addi	a0,a0,768 # 5ff0 <malloc+0xae4>
    1cf8:	75c030ef          	jal	5454 <printf>
    exit(1);
    1cfc:	4505                	li	a0,1
    1cfe:	308030ef          	jal	5006 <exit>
    1d02:	e04a                	sd	s2,0(sp)
    printf("sbrk(rwsbrk) shrink failed\n");
    1d04:	00004517          	auipc	a0,0x4
    1d08:	30450513          	addi	a0,a0,772 # 6008 <malloc+0xafc>
    1d0c:	748030ef          	jal	5454 <printf>
    exit(1);
    1d10:	4505                	li	a0,1
    1d12:	2f4030ef          	jal	5006 <exit>
    printf("open(rwsbrk) failed\n");
    1d16:	00004517          	auipc	a0,0x4
    1d1a:	31a50513          	addi	a0,a0,794 # 6030 <malloc+0xb24>
    1d1e:	736030ef          	jal	5454 <printf>
    exit(1);
    1d22:	4505                	li	a0,1
    1d24:	2e2030ef          	jal	5006 <exit>
  close(fd);
    1d28:	854a                	mv	a0,s2
    1d2a:	304030ef          	jal	502e <close>
  unlink("rwsbrk");
    1d2e:	00004517          	auipc	a0,0x4
    1d32:	2fa50513          	addi	a0,a0,762 # 6028 <malloc+0xb1c>
    1d36:	320030ef          	jal	5056 <unlink>
  fd = open("README", O_RDONLY);
    1d3a:	4581                	li	a1,0
    1d3c:	00004517          	auipc	a0,0x4
    1d40:	ad450513          	addi	a0,a0,-1324 # 5810 <malloc+0x304>
    1d44:	302030ef          	jal	5046 <open>
    1d48:	892a                	mv	s2,a0
  if(fd < 0){
    1d4a:	02054363          	bltz	a0,1d70 <rwsbrk+0xe8>
  n = read(fd, (void*)(a+PGSIZE), 10);
    1d4e:	4629                	li	a2,10
    1d50:	85a6                	mv	a1,s1
    1d52:	2cc030ef          	jal	501e <read>
    1d56:	862a                	mv	a2,a0
  if(n >= 0){
    1d58:	02054563          	bltz	a0,1d82 <rwsbrk+0xfa>
    printf("read(fd, %p, 10) returned %d, not -1\n", (void*)a+PGSIZE, n);
    1d5c:	85a6                	mv	a1,s1
    1d5e:	00004517          	auipc	a0,0x4
    1d62:	31a50513          	addi	a0,a0,794 # 6078 <malloc+0xb6c>
    1d66:	6ee030ef          	jal	5454 <printf>
    exit(1);
    1d6a:	4505                	li	a0,1
    1d6c:	29a030ef          	jal	5006 <exit>
    printf("open(README) failed\n");
    1d70:	00004517          	auipc	a0,0x4
    1d74:	aa850513          	addi	a0,a0,-1368 # 5818 <malloc+0x30c>
    1d78:	6dc030ef          	jal	5454 <printf>
    exit(1);
    1d7c:	4505                	li	a0,1
    1d7e:	288030ef          	jal	5006 <exit>
  close(fd);
    1d82:	854a                	mv	a0,s2
    1d84:	2aa030ef          	jal	502e <close>
  exit(0);
    1d88:	4501                	li	a0,0
    1d8a:	27c030ef          	jal	5006 <exit>

0000000000001d8e <sbrkbasic>:
{
    1d8e:	715d                	addi	sp,sp,-80
    1d90:	e486                	sd	ra,72(sp)
    1d92:	e0a2                	sd	s0,64(sp)
    1d94:	ec56                	sd	s5,24(sp)
    1d96:	0880                	addi	s0,sp,80
    1d98:	8aaa                	mv	s5,a0
  pid = fork();
    1d9a:	264030ef          	jal	4ffe <fork>
  if(pid < 0){
    1d9e:	02054c63          	bltz	a0,1dd6 <sbrkbasic+0x48>
  if(pid == 0){
    1da2:	ed31                	bnez	a0,1dfe <sbrkbasic+0x70>
    a = sbrk(TOOMUCH);
    1da4:	40000537          	lui	a0,0x40000
    1da8:	22a030ef          	jal	4fd2 <sbrk>
    if(a == (char*)SBRK_ERROR){
    1dac:	57fd                	li	a5,-1
    1dae:	04f50163          	beq	a0,a5,1df0 <sbrkbasic+0x62>
    1db2:	fc26                	sd	s1,56(sp)
    1db4:	f84a                	sd	s2,48(sp)
    1db6:	f44e                	sd	s3,40(sp)
    1db8:	f052                	sd	s4,32(sp)
    for(b = a; b < a+TOOMUCH; b += PGSIZE){
    1dba:	400007b7          	lui	a5,0x40000
    1dbe:	97aa                	add	a5,a5,a0
      *b = 99;
    1dc0:	06300693          	li	a3,99
    for(b = a; b < a+TOOMUCH; b += PGSIZE){
    1dc4:	6705                	lui	a4,0x1
      *b = 99;
    1dc6:	00d50023          	sb	a3,0(a0) # 40000000 <base+0x3ffef378>
    for(b = a; b < a+TOOMUCH; b += PGSIZE){
    1dca:	953a                	add	a0,a0,a4
    1dcc:	fef51de3          	bne	a0,a5,1dc6 <sbrkbasic+0x38>
    exit(1);
    1dd0:	4505                	li	a0,1
    1dd2:	234030ef          	jal	5006 <exit>
    1dd6:	fc26                	sd	s1,56(sp)
    1dd8:	f84a                	sd	s2,48(sp)
    1dda:	f44e                	sd	s3,40(sp)
    1ddc:	f052                	sd	s4,32(sp)
    printf("fork failed in sbrkbasic\n");
    1dde:	00004517          	auipc	a0,0x4
    1de2:	2c250513          	addi	a0,a0,706 # 60a0 <malloc+0xb94>
    1de6:	66e030ef          	jal	5454 <printf>
    exit(1);
    1dea:	4505                	li	a0,1
    1dec:	21a030ef          	jal	5006 <exit>
    1df0:	fc26                	sd	s1,56(sp)
    1df2:	f84a                	sd	s2,48(sp)
    1df4:	f44e                	sd	s3,40(sp)
    1df6:	f052                	sd	s4,32(sp)
      exit(0);
    1df8:	4501                	li	a0,0
    1dfa:	20c030ef          	jal	5006 <exit>
  wait(&xstatus);
    1dfe:	fbc40513          	addi	a0,s0,-68
    1e02:	20c030ef          	jal	500e <wait>
  if(xstatus == 1){
    1e06:	fbc42703          	lw	a4,-68(s0)
    1e0a:	4785                	li	a5,1
    1e0c:	02f70063          	beq	a4,a5,1e2c <sbrkbasic+0x9e>
    1e10:	fc26                	sd	s1,56(sp)
    1e12:	f84a                	sd	s2,48(sp)
    1e14:	f44e                	sd	s3,40(sp)
    1e16:	f052                	sd	s4,32(sp)
  a = sbrk(0);
    1e18:	4501                	li	a0,0
    1e1a:	1b8030ef          	jal	4fd2 <sbrk>
    1e1e:	84aa                	mv	s1,a0
  for(i = 0; i < 5000; i++){
    1e20:	4901                	li	s2,0
    b = sbrk(1);
    1e22:	4985                	li	s3,1
  for(i = 0; i < 5000; i++){
    1e24:	6a05                	lui	s4,0x1
    1e26:	388a0a13          	addi	s4,s4,904 # 1388 <twochildren+0x56>
    1e2a:	a005                	j	1e4a <sbrkbasic+0xbc>
    1e2c:	fc26                	sd	s1,56(sp)
    1e2e:	f84a                	sd	s2,48(sp)
    1e30:	f44e                	sd	s3,40(sp)
    1e32:	f052                	sd	s4,32(sp)
    printf("%s: too much memory allocated!\n", s);
    1e34:	85d6                	mv	a1,s5
    1e36:	00004517          	auipc	a0,0x4
    1e3a:	28a50513          	addi	a0,a0,650 # 60c0 <malloc+0xbb4>
    1e3e:	616030ef          	jal	5454 <printf>
    exit(1);
    1e42:	4505                	li	a0,1
    1e44:	1c2030ef          	jal	5006 <exit>
    1e48:	84be                	mv	s1,a5
    b = sbrk(1);
    1e4a:	854e                	mv	a0,s3
    1e4c:	186030ef          	jal	4fd2 <sbrk>
    if(b != a){
    1e50:	04951163          	bne	a0,s1,1e92 <sbrkbasic+0x104>
    *b = 1;
    1e54:	01348023          	sb	s3,0(s1)
    a = b + 1;
    1e58:	00148793          	addi	a5,s1,1
  for(i = 0; i < 5000; i++){
    1e5c:	2905                	addiw	s2,s2,1
    1e5e:	ff4915e3          	bne	s2,s4,1e48 <sbrkbasic+0xba>
  pid = fork();
    1e62:	19c030ef          	jal	4ffe <fork>
    1e66:	892a                	mv	s2,a0
  if(pid < 0){
    1e68:	04054263          	bltz	a0,1eac <sbrkbasic+0x11e>
  c = sbrk(1);
    1e6c:	4505                	li	a0,1
    1e6e:	164030ef          	jal	4fd2 <sbrk>
  c = sbrk(1);
    1e72:	4505                	li	a0,1
    1e74:	15e030ef          	jal	4fd2 <sbrk>
  if(c != a + 1){
    1e78:	0489                	addi	s1,s1,2
    1e7a:	04950363          	beq	a0,s1,1ec0 <sbrkbasic+0x132>
    printf("%s: sbrk test failed post-fork\n", s);
    1e7e:	85d6                	mv	a1,s5
    1e80:	00004517          	auipc	a0,0x4
    1e84:	2a050513          	addi	a0,a0,672 # 6120 <malloc+0xc14>
    1e88:	5cc030ef          	jal	5454 <printf>
    exit(1);
    1e8c:	4505                	li	a0,1
    1e8e:	178030ef          	jal	5006 <exit>
      printf("%s: sbrk test failed %d %p %p\n", s, i, a, b);
    1e92:	872a                	mv	a4,a0
    1e94:	86a6                	mv	a3,s1
    1e96:	864a                	mv	a2,s2
    1e98:	85d6                	mv	a1,s5
    1e9a:	00004517          	auipc	a0,0x4
    1e9e:	24650513          	addi	a0,a0,582 # 60e0 <malloc+0xbd4>
    1ea2:	5b2030ef          	jal	5454 <printf>
      exit(1);
    1ea6:	4505                	li	a0,1
    1ea8:	15e030ef          	jal	5006 <exit>
    printf("%s: sbrk test fork failed\n", s);
    1eac:	85d6                	mv	a1,s5
    1eae:	00004517          	auipc	a0,0x4
    1eb2:	25250513          	addi	a0,a0,594 # 6100 <malloc+0xbf4>
    1eb6:	59e030ef          	jal	5454 <printf>
    exit(1);
    1eba:	4505                	li	a0,1
    1ebc:	14a030ef          	jal	5006 <exit>
  if(pid == 0)
    1ec0:	00091563          	bnez	s2,1eca <sbrkbasic+0x13c>
    exit(0);
    1ec4:	4501                	li	a0,0
    1ec6:	140030ef          	jal	5006 <exit>
  wait(&xstatus);
    1eca:	fbc40513          	addi	a0,s0,-68
    1ece:	140030ef          	jal	500e <wait>
  exit(xstatus);
    1ed2:	fbc42503          	lw	a0,-68(s0)
    1ed6:	130030ef          	jal	5006 <exit>

0000000000001eda <sbrkmuch>:
{
    1eda:	7179                	addi	sp,sp,-48
    1edc:	f406                	sd	ra,40(sp)
    1ede:	f022                	sd	s0,32(sp)
    1ee0:	ec26                	sd	s1,24(sp)
    1ee2:	e84a                	sd	s2,16(sp)
    1ee4:	e44e                	sd	s3,8(sp)
    1ee6:	e052                	sd	s4,0(sp)
    1ee8:	1800                	addi	s0,sp,48
    1eea:	89aa                	mv	s3,a0
  oldbrk = sbrk(0);
    1eec:	4501                	li	a0,0
    1eee:	0e4030ef          	jal	4fd2 <sbrk>
    1ef2:	892a                	mv	s2,a0
  a = sbrk(0);
    1ef4:	4501                	li	a0,0
    1ef6:	0dc030ef          	jal	4fd2 <sbrk>
    1efa:	84aa                	mv	s1,a0
  p = sbrk(amt);
    1efc:	06400537          	lui	a0,0x6400
    1f00:	9d05                	subw	a0,a0,s1
    1f02:	0d0030ef          	jal	4fd2 <sbrk>
  if (p != a) {
    1f06:	08a49963          	bne	s1,a0,1f98 <sbrkmuch+0xbe>
  *lastaddr = 99;
    1f0a:	064007b7          	lui	a5,0x6400
    1f0e:	06300713          	li	a4,99
    1f12:	fee78fa3          	sb	a4,-1(a5) # 63fffff <base+0x63ef377>
  a = sbrk(0);
    1f16:	4501                	li	a0,0
    1f18:	0ba030ef          	jal	4fd2 <sbrk>
    1f1c:	84aa                	mv	s1,a0
  c = sbrk(-PGSIZE);
    1f1e:	757d                	lui	a0,0xfffff
    1f20:	0b2030ef          	jal	4fd2 <sbrk>
  if(c == (char*)SBRK_ERROR){
    1f24:	57fd                	li	a5,-1
    1f26:	08f50363          	beq	a0,a5,1fac <sbrkmuch+0xd2>
  c = sbrk(0);
    1f2a:	4501                	li	a0,0
    1f2c:	0a6030ef          	jal	4fd2 <sbrk>
  if(c != a - PGSIZE){
    1f30:	80048793          	addi	a5,s1,-2048
    1f34:	80078793          	addi	a5,a5,-2048
    1f38:	08f51463          	bne	a0,a5,1fc0 <sbrkmuch+0xe6>
  a = sbrk(0);
    1f3c:	4501                	li	a0,0
    1f3e:	094030ef          	jal	4fd2 <sbrk>
    1f42:	84aa                	mv	s1,a0
  c = sbrk(PGSIZE);
    1f44:	6505                	lui	a0,0x1
    1f46:	08c030ef          	jal	4fd2 <sbrk>
    1f4a:	8a2a                	mv	s4,a0
  if(c != a || sbrk(0) != a + PGSIZE){
    1f4c:	08a49663          	bne	s1,a0,1fd8 <sbrkmuch+0xfe>
    1f50:	4501                	li	a0,0
    1f52:	080030ef          	jal	4fd2 <sbrk>
    1f56:	6785                	lui	a5,0x1
    1f58:	97a6                	add	a5,a5,s1
    1f5a:	06f51f63          	bne	a0,a5,1fd8 <sbrkmuch+0xfe>
  if(*lastaddr == 99){
    1f5e:	064007b7          	lui	a5,0x6400
    1f62:	fff7c703          	lbu	a4,-1(a5) # 63fffff <base+0x63ef377>
    1f66:	06300793          	li	a5,99
    1f6a:	08f70363          	beq	a4,a5,1ff0 <sbrkmuch+0x116>
  a = sbrk(0);
    1f6e:	4501                	li	a0,0
    1f70:	062030ef          	jal	4fd2 <sbrk>
    1f74:	84aa                	mv	s1,a0
  c = sbrk(-(sbrk(0) - oldbrk));
    1f76:	4501                	li	a0,0
    1f78:	05a030ef          	jal	4fd2 <sbrk>
    1f7c:	40a9053b          	subw	a0,s2,a0
    1f80:	052030ef          	jal	4fd2 <sbrk>
  if(c != a){
    1f84:	08a49063          	bne	s1,a0,2004 <sbrkmuch+0x12a>
}
    1f88:	70a2                	ld	ra,40(sp)
    1f8a:	7402                	ld	s0,32(sp)
    1f8c:	64e2                	ld	s1,24(sp)
    1f8e:	6942                	ld	s2,16(sp)
    1f90:	69a2                	ld	s3,8(sp)
    1f92:	6a02                	ld	s4,0(sp)
    1f94:	6145                	addi	sp,sp,48
    1f96:	8082                	ret
    printf("%s: sbrk test failed to grow big address space; enough phys mem?\n", s);
    1f98:	85ce                	mv	a1,s3
    1f9a:	00004517          	auipc	a0,0x4
    1f9e:	1a650513          	addi	a0,a0,422 # 6140 <malloc+0xc34>
    1fa2:	4b2030ef          	jal	5454 <printf>
    exit(1);
    1fa6:	4505                	li	a0,1
    1fa8:	05e030ef          	jal	5006 <exit>
    printf("%s: sbrk could not deallocate\n", s);
    1fac:	85ce                	mv	a1,s3
    1fae:	00004517          	auipc	a0,0x4
    1fb2:	1da50513          	addi	a0,a0,474 # 6188 <malloc+0xc7c>
    1fb6:	49e030ef          	jal	5454 <printf>
    exit(1);
    1fba:	4505                	li	a0,1
    1fbc:	04a030ef          	jal	5006 <exit>
    printf("%s: sbrk deallocation produced wrong address, a %p c %p\n", s, a, c);
    1fc0:	86aa                	mv	a3,a0
    1fc2:	8626                	mv	a2,s1
    1fc4:	85ce                	mv	a1,s3
    1fc6:	00004517          	auipc	a0,0x4
    1fca:	1e250513          	addi	a0,a0,482 # 61a8 <malloc+0xc9c>
    1fce:	486030ef          	jal	5454 <printf>
    exit(1);
    1fd2:	4505                	li	a0,1
    1fd4:	032030ef          	jal	5006 <exit>
    printf("%s: sbrk re-allocation failed, a %p c %p\n", s, a, c);
    1fd8:	86d2                	mv	a3,s4
    1fda:	8626                	mv	a2,s1
    1fdc:	85ce                	mv	a1,s3
    1fde:	00004517          	auipc	a0,0x4
    1fe2:	20a50513          	addi	a0,a0,522 # 61e8 <malloc+0xcdc>
    1fe6:	46e030ef          	jal	5454 <printf>
    exit(1);
    1fea:	4505                	li	a0,1
    1fec:	01a030ef          	jal	5006 <exit>
    printf("%s: sbrk de-allocation didn't really deallocate\n", s);
    1ff0:	85ce                	mv	a1,s3
    1ff2:	00004517          	auipc	a0,0x4
    1ff6:	22650513          	addi	a0,a0,550 # 6218 <malloc+0xd0c>
    1ffa:	45a030ef          	jal	5454 <printf>
    exit(1);
    1ffe:	4505                	li	a0,1
    2000:	006030ef          	jal	5006 <exit>
    printf("%s: sbrk downsize failed, a %p c %p\n", s, a, c);
    2004:	86aa                	mv	a3,a0
    2006:	8626                	mv	a2,s1
    2008:	85ce                	mv	a1,s3
    200a:	00004517          	auipc	a0,0x4
    200e:	24650513          	addi	a0,a0,582 # 6250 <malloc+0xd44>
    2012:	442030ef          	jal	5454 <printf>
    exit(1);
    2016:	4505                	li	a0,1
    2018:	7ef020ef          	jal	5006 <exit>

000000000000201c <sbrkarg>:
{
    201c:	7179                	addi	sp,sp,-48
    201e:	f406                	sd	ra,40(sp)
    2020:	f022                	sd	s0,32(sp)
    2022:	ec26                	sd	s1,24(sp)
    2024:	e84a                	sd	s2,16(sp)
    2026:	e44e                	sd	s3,8(sp)
    2028:	1800                	addi	s0,sp,48
    202a:	89aa                	mv	s3,a0
  a = sbrk(PGSIZE);
    202c:	6505                	lui	a0,0x1
    202e:	7a5020ef          	jal	4fd2 <sbrk>
    2032:	892a                	mv	s2,a0
  fd = open("sbrk", O_CREATE|O_WRONLY);
    2034:	20100593          	li	a1,513
    2038:	00004517          	auipc	a0,0x4
    203c:	24050513          	addi	a0,a0,576 # 6278 <malloc+0xd6c>
    2040:	006030ef          	jal	5046 <open>
    2044:	84aa                	mv	s1,a0
  unlink("sbrk");
    2046:	00004517          	auipc	a0,0x4
    204a:	23250513          	addi	a0,a0,562 # 6278 <malloc+0xd6c>
    204e:	008030ef          	jal	5056 <unlink>
  if(fd < 0)  {
    2052:	0204c963          	bltz	s1,2084 <sbrkarg+0x68>
  if ((n = write(fd, a, PGSIZE)) < 0) {
    2056:	6605                	lui	a2,0x1
    2058:	85ca                	mv	a1,s2
    205a:	8526                	mv	a0,s1
    205c:	7cb020ef          	jal	5026 <write>
    2060:	02054c63          	bltz	a0,2098 <sbrkarg+0x7c>
  close(fd);
    2064:	8526                	mv	a0,s1
    2066:	7c9020ef          	jal	502e <close>
  a = sbrk(PGSIZE);
    206a:	6505                	lui	a0,0x1
    206c:	767020ef          	jal	4fd2 <sbrk>
  if(pipe((int *) a) != 0){
    2070:	7a7020ef          	jal	5016 <pipe>
    2074:	ed05                	bnez	a0,20ac <sbrkarg+0x90>
}
    2076:	70a2                	ld	ra,40(sp)
    2078:	7402                	ld	s0,32(sp)
    207a:	64e2                	ld	s1,24(sp)
    207c:	6942                	ld	s2,16(sp)
    207e:	69a2                	ld	s3,8(sp)
    2080:	6145                	addi	sp,sp,48
    2082:	8082                	ret
    printf("%s: open sbrk failed\n", s);
    2084:	85ce                	mv	a1,s3
    2086:	00004517          	auipc	a0,0x4
    208a:	1fa50513          	addi	a0,a0,506 # 6280 <malloc+0xd74>
    208e:	3c6030ef          	jal	5454 <printf>
    exit(1);
    2092:	4505                	li	a0,1
    2094:	773020ef          	jal	5006 <exit>
    printf("%s: write sbrk failed\n", s);
    2098:	85ce                	mv	a1,s3
    209a:	00004517          	auipc	a0,0x4
    209e:	1fe50513          	addi	a0,a0,510 # 6298 <malloc+0xd8c>
    20a2:	3b2030ef          	jal	5454 <printf>
    exit(1);
    20a6:	4505                	li	a0,1
    20a8:	75f020ef          	jal	5006 <exit>
    printf("%s: pipe() failed\n", s);
    20ac:	85ce                	mv	a1,s3
    20ae:	00004517          	auipc	a0,0x4
    20b2:	20250513          	addi	a0,a0,514 # 62b0 <malloc+0xda4>
    20b6:	39e030ef          	jal	5454 <printf>
    exit(1);
    20ba:	4505                	li	a0,1
    20bc:	74b020ef          	jal	5006 <exit>

00000000000020c0 <argptest>:
{
    20c0:	1101                	addi	sp,sp,-32
    20c2:	ec06                	sd	ra,24(sp)
    20c4:	e822                	sd	s0,16(sp)
    20c6:	e426                	sd	s1,8(sp)
    20c8:	e04a                	sd	s2,0(sp)
    20ca:	1000                	addi	s0,sp,32
    20cc:	892a                	mv	s2,a0
  fd = open("init", O_RDONLY);
    20ce:	4581                	li	a1,0
    20d0:	00004517          	auipc	a0,0x4
    20d4:	1f850513          	addi	a0,a0,504 # 62c8 <malloc+0xdbc>
    20d8:	76f020ef          	jal	5046 <open>
  if (fd < 0) {
    20dc:	02054563          	bltz	a0,2106 <argptest+0x46>
    20e0:	84aa                	mv	s1,a0
  read(fd, sbrk(0) - 1, -1);
    20e2:	4501                	li	a0,0
    20e4:	6ef020ef          	jal	4fd2 <sbrk>
    20e8:	567d                	li	a2,-1
    20ea:	00c505b3          	add	a1,a0,a2
    20ee:	8526                	mv	a0,s1
    20f0:	72f020ef          	jal	501e <read>
  close(fd);
    20f4:	8526                	mv	a0,s1
    20f6:	739020ef          	jal	502e <close>
}
    20fa:	60e2                	ld	ra,24(sp)
    20fc:	6442                	ld	s0,16(sp)
    20fe:	64a2                	ld	s1,8(sp)
    2100:	6902                	ld	s2,0(sp)
    2102:	6105                	addi	sp,sp,32
    2104:	8082                	ret
    printf("%s: open failed\n", s);
    2106:	85ca                	mv	a1,s2
    2108:	00004517          	auipc	a0,0x4
    210c:	bf850513          	addi	a0,a0,-1032 # 5d00 <malloc+0x7f4>
    2110:	344030ef          	jal	5454 <printf>
    exit(1);
    2114:	4505                	li	a0,1
    2116:	6f1020ef          	jal	5006 <exit>

000000000000211a <sbrkbugs>:
{
    211a:	1141                	addi	sp,sp,-16
    211c:	e406                	sd	ra,8(sp)
    211e:	e022                	sd	s0,0(sp)
    2120:	0800                	addi	s0,sp,16
  int pid = fork();
    2122:	6dd020ef          	jal	4ffe <fork>
  if(pid < 0){
    2126:	00054c63          	bltz	a0,213e <sbrkbugs+0x24>
  if(pid == 0){
    212a:	e11d                	bnez	a0,2150 <sbrkbugs+0x36>
    int sz = (uint64) sbrk(0);
    212c:	6a7020ef          	jal	4fd2 <sbrk>
    sbrk(-sz);
    2130:	40a0053b          	negw	a0,a0
    2134:	69f020ef          	jal	4fd2 <sbrk>
    exit(0);
    2138:	4501                	li	a0,0
    213a:	6cd020ef          	jal	5006 <exit>
    printf("fork failed\n");
    213e:	00005517          	auipc	a0,0x5
    2142:	10250513          	addi	a0,a0,258 # 7240 <malloc+0x1d34>
    2146:	30e030ef          	jal	5454 <printf>
    exit(1);
    214a:	4505                	li	a0,1
    214c:	6bb020ef          	jal	5006 <exit>
  wait(0);
    2150:	4501                	li	a0,0
    2152:	6bd020ef          	jal	500e <wait>
  pid = fork();
    2156:	6a9020ef          	jal	4ffe <fork>
  if(pid < 0){
    215a:	00054f63          	bltz	a0,2178 <sbrkbugs+0x5e>
  if(pid == 0){
    215e:	e515                	bnez	a0,218a <sbrkbugs+0x70>
    int sz = (uint64) sbrk(0);
    2160:	673020ef          	jal	4fd2 <sbrk>
    sbrk(-(sz - 3500));
    2164:	6785                	lui	a5,0x1
    2166:	dac7879b          	addiw	a5,a5,-596 # dac <pgbug+0x1c>
    216a:	40a7853b          	subw	a0,a5,a0
    216e:	665020ef          	jal	4fd2 <sbrk>
    exit(0);
    2172:	4501                	li	a0,0
    2174:	693020ef          	jal	5006 <exit>
    printf("fork failed\n");
    2178:	00005517          	auipc	a0,0x5
    217c:	0c850513          	addi	a0,a0,200 # 7240 <malloc+0x1d34>
    2180:	2d4030ef          	jal	5454 <printf>
    exit(1);
    2184:	4505                	li	a0,1
    2186:	681020ef          	jal	5006 <exit>
  wait(0);
    218a:	4501                	li	a0,0
    218c:	683020ef          	jal	500e <wait>
  pid = fork();
    2190:	66f020ef          	jal	4ffe <fork>
  if(pid < 0){
    2194:	02054263          	bltz	a0,21b8 <sbrkbugs+0x9e>
  if(pid == 0){
    2198:	e90d                	bnez	a0,21ca <sbrkbugs+0xb0>
    sbrk((10*PGSIZE + 2048) - (uint64)sbrk(0));
    219a:	639020ef          	jal	4fd2 <sbrk>
    219e:	67ad                	lui	a5,0xb
    21a0:	8007879b          	addiw	a5,a5,-2048 # a800 <big.0+0x290>
    21a4:	40a7853b          	subw	a0,a5,a0
    21a8:	62b020ef          	jal	4fd2 <sbrk>
    sbrk(-10);
    21ac:	5559                	li	a0,-10
    21ae:	625020ef          	jal	4fd2 <sbrk>
    exit(0);
    21b2:	4501                	li	a0,0
    21b4:	653020ef          	jal	5006 <exit>
    printf("fork failed\n");
    21b8:	00005517          	auipc	a0,0x5
    21bc:	08850513          	addi	a0,a0,136 # 7240 <malloc+0x1d34>
    21c0:	294030ef          	jal	5454 <printf>
    exit(1);
    21c4:	4505                	li	a0,1
    21c6:	641020ef          	jal	5006 <exit>
  wait(0);
    21ca:	4501                	li	a0,0
    21cc:	643020ef          	jal	500e <wait>
  exit(0);
    21d0:	4501                	li	a0,0
    21d2:	635020ef          	jal	5006 <exit>

00000000000021d6 <sbrklast>:
{
    21d6:	7179                	addi	sp,sp,-48
    21d8:	f406                	sd	ra,40(sp)
    21da:	f022                	sd	s0,32(sp)
    21dc:	ec26                	sd	s1,24(sp)
    21de:	e84a                	sd	s2,16(sp)
    21e0:	e44e                	sd	s3,8(sp)
    21e2:	e052                	sd	s4,0(sp)
    21e4:	1800                	addi	s0,sp,48
  uint64 top = (uint64) sbrk(0);
    21e6:	4501                	li	a0,0
    21e8:	5eb020ef          	jal	4fd2 <sbrk>
  if((top % PGSIZE) != 0)
    21ec:	03451793          	slli	a5,a0,0x34
    21f0:	ebad                	bnez	a5,2262 <sbrklast+0x8c>
  sbrk(PGSIZE);
    21f2:	6505                	lui	a0,0x1
    21f4:	5df020ef          	jal	4fd2 <sbrk>
  sbrk(10);
    21f8:	4529                	li	a0,10
    21fa:	5d9020ef          	jal	4fd2 <sbrk>
  sbrk(-20);
    21fe:	5531                	li	a0,-20
    2200:	5d3020ef          	jal	4fd2 <sbrk>
  top = (uint64) sbrk(0);
    2204:	4501                	li	a0,0
    2206:	5cd020ef          	jal	4fd2 <sbrk>
    220a:	84aa                	mv	s1,a0
  char *p = (char *) (top - 64);
    220c:	fc050913          	addi	s2,a0,-64 # fc0 <truncate3+0x24>
  p[0] = 'x';
    2210:	07800993          	li	s3,120
    2214:	fd350023          	sb	s3,-64(a0)
  p[1] = '\0';
    2218:	fc0500a3          	sb	zero,-63(a0)
  int fd = open(p, O_RDWR|O_CREATE);
    221c:	20200593          	li	a1,514
    2220:	854a                	mv	a0,s2
    2222:	625020ef          	jal	5046 <open>
    2226:	8a2a                	mv	s4,a0
  write(fd, p, 1);
    2228:	4605                	li	a2,1
    222a:	85ca                	mv	a1,s2
    222c:	5fb020ef          	jal	5026 <write>
  close(fd);
    2230:	8552                	mv	a0,s4
    2232:	5fd020ef          	jal	502e <close>
  fd = open(p, O_RDWR);
    2236:	4589                	li	a1,2
    2238:	854a                	mv	a0,s2
    223a:	60d020ef          	jal	5046 <open>
  p[0] = '\0';
    223e:	fc048023          	sb	zero,-64(s1)
  read(fd, p, 1);
    2242:	4605                	li	a2,1
    2244:	85ca                	mv	a1,s2
    2246:	5d9020ef          	jal	501e <read>
  if(p[0] != 'x')
    224a:	fc04c783          	lbu	a5,-64(s1)
    224e:	03379263          	bne	a5,s3,2272 <sbrklast+0x9c>
}
    2252:	70a2                	ld	ra,40(sp)
    2254:	7402                	ld	s0,32(sp)
    2256:	64e2                	ld	s1,24(sp)
    2258:	6942                	ld	s2,16(sp)
    225a:	69a2                	ld	s3,8(sp)
    225c:	6a02                	ld	s4,0(sp)
    225e:	6145                	addi	sp,sp,48
    2260:	8082                	ret
    sbrk(PGSIZE - (top % PGSIZE));
    2262:	0347d513          	srli	a0,a5,0x34
    2266:	6785                	lui	a5,0x1
    2268:	40a7853b          	subw	a0,a5,a0
    226c:	567020ef          	jal	4fd2 <sbrk>
    2270:	b749                	j	21f2 <sbrklast+0x1c>
    exit(1);
    2272:	4505                	li	a0,1
    2274:	593020ef          	jal	5006 <exit>

0000000000002278 <sbrk8000>:
{
    2278:	1141                	addi	sp,sp,-16
    227a:	e406                	sd	ra,8(sp)
    227c:	e022                	sd	s0,0(sp)
    227e:	0800                	addi	s0,sp,16
  sbrk(0x80000004);
    2280:	80000537          	lui	a0,0x80000
    2284:	0511                	addi	a0,a0,4 # ffffffff80000004 <base+0xffffffff7ffef37c>
    2286:	54d020ef          	jal	4fd2 <sbrk>
  volatile char *top = sbrk(0);
    228a:	4501                	li	a0,0
    228c:	547020ef          	jal	4fd2 <sbrk>
  *(top-1) = *(top-1) + 1;
    2290:	fff54783          	lbu	a5,-1(a0)
    2294:	0785                	addi	a5,a5,1 # 1001 <truncate3+0x65>
    2296:	0ff7f793          	zext.b	a5,a5
    229a:	fef50fa3          	sb	a5,-1(a0)
}
    229e:	60a2                	ld	ra,8(sp)
    22a0:	6402                	ld	s0,0(sp)
    22a2:	0141                	addi	sp,sp,16
    22a4:	8082                	ret

00000000000022a6 <execout>:
{
    22a6:	711d                	addi	sp,sp,-96
    22a8:	ec86                	sd	ra,88(sp)
    22aa:	e8a2                	sd	s0,80(sp)
    22ac:	e4a6                	sd	s1,72(sp)
    22ae:	e0ca                	sd	s2,64(sp)
    22b0:	fc4e                	sd	s3,56(sp)
    22b2:	1080                	addi	s0,sp,96
  for(int avail = 0; avail < 15; avail++){
    22b4:	4901                	li	s2,0
    22b6:	49bd                	li	s3,15
    int pid = fork();
    22b8:	547020ef          	jal	4ffe <fork>
    22bc:	84aa                	mv	s1,a0
    if(pid < 0){
    22be:	00054f63          	bltz	a0,22dc <execout+0x36>
    } else if(pid == 0){
    22c2:	c90d                	beqz	a0,22f4 <execout+0x4e>
      wait((int*)0);
    22c4:	4501                	li	a0,0
    22c6:	549020ef          	jal	500e <wait>
  for(int avail = 0; avail < 15; avail++){
    22ca:	2905                	addiw	s2,s2,1
    22cc:	ff3916e3          	bne	s2,s3,22b8 <execout+0x12>
    22d0:	f852                	sd	s4,48(sp)
    22d2:	f456                	sd	s5,40(sp)
    22d4:	f05a                	sd	s6,32(sp)
  exit(0);
    22d6:	4501                	li	a0,0
    22d8:	52f020ef          	jal	5006 <exit>
    22dc:	f852                	sd	s4,48(sp)
    22de:	f456                	sd	s5,40(sp)
    22e0:	f05a                	sd	s6,32(sp)
      printf("fork failed\n");
    22e2:	00005517          	auipc	a0,0x5
    22e6:	f5e50513          	addi	a0,a0,-162 # 7240 <malloc+0x1d34>
    22ea:	16a030ef          	jal	5454 <printf>
      exit(1);
    22ee:	4505                	li	a0,1
    22f0:	517020ef          	jal	5006 <exit>
    22f4:	f852                	sd	s4,48(sp)
    22f6:	f456                	sd	s5,40(sp)
    22f8:	f05a                	sd	s6,32(sp)
    22fa:	6999                	lui	s3,0x6
    22fc:	1a898993          	addi	s3,s3,424 # 61a8 <malloc+0xc9c>
        char *a = sbrk(PGSIZE);
    2300:	6a05                	lui	s4,0x1
        if(a == SBRK_ERROR)
    2302:	5afd                	li	s5,-1
        *(a + PGSIZE - 1) = 1;
    2304:	4b05                	li	s6,1
        char *a = sbrk(PGSIZE);
    2306:	8552                	mv	a0,s4
    2308:	4cb020ef          	jal	4fd2 <sbrk>
        if(a == SBRK_ERROR)
    230c:	01550863          	beq	a0,s5,231c <execout+0x76>
        *(a + PGSIZE - 1) = 1;
    2310:	9552                	add	a0,a0,s4
    2312:	ff650fa3          	sb	s6,-1(a0)
      while(n++ < max){
    2316:	39fd                	addiw	s3,s3,-1
    2318:	fe0997e3          	bnez	s3,2306 <execout+0x60>
      for(int i = 0; i < avail; i++)
    231c:	01205963          	blez	s2,232e <execout+0x88>
        sbrk(-PGSIZE);
    2320:	79fd                	lui	s3,0xfffff
    2322:	854e                	mv	a0,s3
    2324:	4af020ef          	jal	4fd2 <sbrk>
      for(int i = 0; i < avail; i++)
    2328:	2485                	addiw	s1,s1,1
    232a:	ff249ce3          	bne	s1,s2,2322 <execout+0x7c>
      close(1);
    232e:	4505                	li	a0,1
    2330:	4ff020ef          	jal	502e <close>
      char *args[] = { "echo", "x", 0 };
    2334:	00003797          	auipc	a5,0x3
    2338:	30478793          	addi	a5,a5,772 # 5638 <malloc+0x12c>
    233c:	faf43423          	sd	a5,-88(s0)
    2340:	00003797          	auipc	a5,0x3
    2344:	36878793          	addi	a5,a5,872 # 56a8 <malloc+0x19c>
    2348:	faf43823          	sd	a5,-80(s0)
    234c:	fa043c23          	sd	zero,-72(s0)
      exec("echo", args);
    2350:	fa840593          	addi	a1,s0,-88
    2354:	00003517          	auipc	a0,0x3
    2358:	2e450513          	addi	a0,a0,740 # 5638 <malloc+0x12c>
    235c:	4e3020ef          	jal	503e <exec>
      exit(0);
    2360:	4501                	li	a0,0
    2362:	4a5020ef          	jal	5006 <exit>

0000000000002366 <fourteen>:
{
    2366:	1101                	addi	sp,sp,-32
    2368:	ec06                	sd	ra,24(sp)
    236a:	e822                	sd	s0,16(sp)
    236c:	e426                	sd	s1,8(sp)
    236e:	1000                	addi	s0,sp,32
    2370:	84aa                	mv	s1,a0
  if(mkdir("12345678901234") != 0){
    2372:	00004517          	auipc	a0,0x4
    2376:	12e50513          	addi	a0,a0,302 # 64a0 <malloc+0xf94>
    237a:	4f5020ef          	jal	506e <mkdir>
    237e:	e555                	bnez	a0,242a <fourteen+0xc4>
  if(mkdir("12345678901234/123456789012345") != 0){
    2380:	00004517          	auipc	a0,0x4
    2384:	f7850513          	addi	a0,a0,-136 # 62f8 <malloc+0xdec>
    2388:	4e7020ef          	jal	506e <mkdir>
    238c:	e94d                	bnez	a0,243e <fourteen+0xd8>
  fd = open("123456789012345/123456789012345/123456789012345", O_CREATE);
    238e:	20000593          	li	a1,512
    2392:	00004517          	auipc	a0,0x4
    2396:	fbe50513          	addi	a0,a0,-66 # 6350 <malloc+0xe44>
    239a:	4ad020ef          	jal	5046 <open>
  if(fd < 0){
    239e:	0a054a63          	bltz	a0,2452 <fourteen+0xec>
  close(fd);
    23a2:	48d020ef          	jal	502e <close>
  fd = open("12345678901234/12345678901234/12345678901234", 0);
    23a6:	4581                	li	a1,0
    23a8:	00004517          	auipc	a0,0x4
    23ac:	02050513          	addi	a0,a0,32 # 63c8 <malloc+0xebc>
    23b0:	497020ef          	jal	5046 <open>
  if(fd < 0){
    23b4:	0a054963          	bltz	a0,2466 <fourteen+0x100>
  close(fd);
    23b8:	477020ef          	jal	502e <close>
  if(mkdir("12345678901234/12345678901234") == 0){
    23bc:	00004517          	auipc	a0,0x4
    23c0:	07c50513          	addi	a0,a0,124 # 6438 <malloc+0xf2c>
    23c4:	4ab020ef          	jal	506e <mkdir>
    23c8:	c94d                	beqz	a0,247a <fourteen+0x114>
  if(mkdir("123456789012345/12345678901234") == 0){
    23ca:	00004517          	auipc	a0,0x4
    23ce:	0c650513          	addi	a0,a0,198 # 6490 <malloc+0xf84>
    23d2:	49d020ef          	jal	506e <mkdir>
    23d6:	cd45                	beqz	a0,248e <fourteen+0x128>
  unlink("123456789012345/12345678901234");
    23d8:	00004517          	auipc	a0,0x4
    23dc:	0b850513          	addi	a0,a0,184 # 6490 <malloc+0xf84>
    23e0:	477020ef          	jal	5056 <unlink>
  unlink("12345678901234/12345678901234");
    23e4:	00004517          	auipc	a0,0x4
    23e8:	05450513          	addi	a0,a0,84 # 6438 <malloc+0xf2c>
    23ec:	46b020ef          	jal	5056 <unlink>
  unlink("12345678901234/12345678901234/12345678901234");
    23f0:	00004517          	auipc	a0,0x4
    23f4:	fd850513          	addi	a0,a0,-40 # 63c8 <malloc+0xebc>
    23f8:	45f020ef          	jal	5056 <unlink>
  unlink("123456789012345/123456789012345/123456789012345");
    23fc:	00004517          	auipc	a0,0x4
    2400:	f5450513          	addi	a0,a0,-172 # 6350 <malloc+0xe44>
    2404:	453020ef          	jal	5056 <unlink>
  unlink("12345678901234/123456789012345");
    2408:	00004517          	auipc	a0,0x4
    240c:	ef050513          	addi	a0,a0,-272 # 62f8 <malloc+0xdec>
    2410:	447020ef          	jal	5056 <unlink>
  unlink("12345678901234");
    2414:	00004517          	auipc	a0,0x4
    2418:	08c50513          	addi	a0,a0,140 # 64a0 <malloc+0xf94>
    241c:	43b020ef          	jal	5056 <unlink>
}
    2420:	60e2                	ld	ra,24(sp)
    2422:	6442                	ld	s0,16(sp)
    2424:	64a2                	ld	s1,8(sp)
    2426:	6105                	addi	sp,sp,32
    2428:	8082                	ret
    printf("%s: mkdir 12345678901234 failed\n", s);
    242a:	85a6                	mv	a1,s1
    242c:	00004517          	auipc	a0,0x4
    2430:	ea450513          	addi	a0,a0,-348 # 62d0 <malloc+0xdc4>
    2434:	020030ef          	jal	5454 <printf>
    exit(1);
    2438:	4505                	li	a0,1
    243a:	3cd020ef          	jal	5006 <exit>
    printf("%s: mkdir 12345678901234/123456789012345 failed\n", s);
    243e:	85a6                	mv	a1,s1
    2440:	00004517          	auipc	a0,0x4
    2444:	ed850513          	addi	a0,a0,-296 # 6318 <malloc+0xe0c>
    2448:	00c030ef          	jal	5454 <printf>
    exit(1);
    244c:	4505                	li	a0,1
    244e:	3b9020ef          	jal	5006 <exit>
    printf("%s: create 123456789012345/123456789012345/123456789012345 failed\n", s);
    2452:	85a6                	mv	a1,s1
    2454:	00004517          	auipc	a0,0x4
    2458:	f2c50513          	addi	a0,a0,-212 # 6380 <malloc+0xe74>
    245c:	7f9020ef          	jal	5454 <printf>
    exit(1);
    2460:	4505                	li	a0,1
    2462:	3a5020ef          	jal	5006 <exit>
    printf("%s: open 12345678901234/12345678901234/12345678901234 failed\n", s);
    2466:	85a6                	mv	a1,s1
    2468:	00004517          	auipc	a0,0x4
    246c:	f9050513          	addi	a0,a0,-112 # 63f8 <malloc+0xeec>
    2470:	7e5020ef          	jal	5454 <printf>
    exit(1);
    2474:	4505                	li	a0,1
    2476:	391020ef          	jal	5006 <exit>
    printf("%s: mkdir 12345678901234/12345678901234 succeeded!\n", s);
    247a:	85a6                	mv	a1,s1
    247c:	00004517          	auipc	a0,0x4
    2480:	fdc50513          	addi	a0,a0,-36 # 6458 <malloc+0xf4c>
    2484:	7d1020ef          	jal	5454 <printf>
    exit(1);
    2488:	4505                	li	a0,1
    248a:	37d020ef          	jal	5006 <exit>
    printf("%s: mkdir 12345678901234/123456789012345 succeeded!\n", s);
    248e:	85a6                	mv	a1,s1
    2490:	00004517          	auipc	a0,0x4
    2494:	02050513          	addi	a0,a0,32 # 64b0 <malloc+0xfa4>
    2498:	7bd020ef          	jal	5454 <printf>
    exit(1);
    249c:	4505                	li	a0,1
    249e:	369020ef          	jal	5006 <exit>

00000000000024a2 <diskfull>:
{
    24a2:	b6010113          	addi	sp,sp,-1184
    24a6:	48113c23          	sd	ra,1176(sp)
    24aa:	48813823          	sd	s0,1168(sp)
    24ae:	48913423          	sd	s1,1160(sp)
    24b2:	49213023          	sd	s2,1152(sp)
    24b6:	47313c23          	sd	s3,1144(sp)
    24ba:	47413823          	sd	s4,1136(sp)
    24be:	47513423          	sd	s5,1128(sp)
    24c2:	47613023          	sd	s6,1120(sp)
    24c6:	45713c23          	sd	s7,1112(sp)
    24ca:	45813823          	sd	s8,1104(sp)
    24ce:	45913423          	sd	s9,1096(sp)
    24d2:	45a13023          	sd	s10,1088(sp)
    24d6:	43b13c23          	sd	s11,1080(sp)
    24da:	4a010413          	addi	s0,sp,1184
    24de:	b6a43423          	sd	a0,-1176(s0)
  unlink("diskfulldir");
    24e2:	00004517          	auipc	a0,0x4
    24e6:	00650513          	addi	a0,a0,6 # 64e8 <malloc+0xfdc>
    24ea:	36d020ef          	jal	5056 <unlink>
    24ee:	03000a93          	li	s5,48
    name[0] = 'b';
    24f2:	06200d13          	li	s10,98
    name[1] = 'i';
    24f6:	06900c93          	li	s9,105
    name[2] = 'g';
    24fa:	06700c13          	li	s8,103
    unlink(name);
    24fe:	b7040b13          	addi	s6,s0,-1168
    int fd = open(name, O_CREATE|O_RDWR|O_TRUNC);
    2502:	60200b93          	li	s7,1538
    2506:	10c00d93          	li	s11,268
      if(write(fd, buf, BSIZE) != BSIZE){
    250a:	b9040a13          	addi	s4,s0,-1136
    250e:	aa8d                	j	2680 <diskfull+0x1de>
      printf("%s: could not create file %s\n", s, name);
    2510:	b7040613          	addi	a2,s0,-1168
    2514:	b6843583          	ld	a1,-1176(s0)
    2518:	00004517          	auipc	a0,0x4
    251c:	fe050513          	addi	a0,a0,-32 # 64f8 <malloc+0xfec>
    2520:	735020ef          	jal	5454 <printf>
      break;
    2524:	a039                	j	2532 <diskfull+0x90>
        close(fd);
    2526:	854e                	mv	a0,s3
    2528:	307020ef          	jal	502e <close>
    close(fd);
    252c:	854e                	mv	a0,s3
    252e:	301020ef          	jal	502e <close>
  for(int i = 0; i < nzz; i++){
    2532:	4481                	li	s1,0
    name[0] = 'z';
    2534:	07a00993          	li	s3,122
    unlink(name);
    2538:	b9040913          	addi	s2,s0,-1136
    int fd = open(name, O_CREATE|O_RDWR|O_TRUNC);
    253c:	60200a13          	li	s4,1538
  for(int i = 0; i < nzz; i++){
    2540:	08000a93          	li	s5,128
    name[0] = 'z';
    2544:	b9340823          	sb	s3,-1136(s0)
    name[1] = 'z';
    2548:	b93408a3          	sb	s3,-1135(s0)
    name[2] = '0' + (i / 32);
    254c:	41f4d71b          	sraiw	a4,s1,0x1f
    2550:	01b7571b          	srliw	a4,a4,0x1b
    2554:	009707bb          	addw	a5,a4,s1
    2558:	4057d69b          	sraiw	a3,a5,0x5
    255c:	0306869b          	addiw	a3,a3,48
    2560:	b8d40923          	sb	a3,-1134(s0)
    name[3] = '0' + (i % 32);
    2564:	8bfd                	andi	a5,a5,31
    2566:	9f99                	subw	a5,a5,a4
    2568:	0307879b          	addiw	a5,a5,48
    256c:	b8f409a3          	sb	a5,-1133(s0)
    name[4] = '\0';
    2570:	b8040a23          	sb	zero,-1132(s0)
    unlink(name);
    2574:	854a                	mv	a0,s2
    2576:	2e1020ef          	jal	5056 <unlink>
    int fd = open(name, O_CREATE|O_RDWR|O_TRUNC);
    257a:	85d2                	mv	a1,s4
    257c:	854a                	mv	a0,s2
    257e:	2c9020ef          	jal	5046 <open>
    if(fd < 0)
    2582:	00054763          	bltz	a0,2590 <diskfull+0xee>
    close(fd);
    2586:	2a9020ef          	jal	502e <close>
  for(int i = 0; i < nzz; i++){
    258a:	2485                	addiw	s1,s1,1
    258c:	fb549ce3          	bne	s1,s5,2544 <diskfull+0xa2>
  if(mkdir("diskfulldir") == 0)
    2590:	00004517          	auipc	a0,0x4
    2594:	f5850513          	addi	a0,a0,-168 # 64e8 <malloc+0xfdc>
    2598:	2d7020ef          	jal	506e <mkdir>
    259c:	12050363          	beqz	a0,26c2 <diskfull+0x220>
  unlink("diskfulldir");
    25a0:	00004517          	auipc	a0,0x4
    25a4:	f4850513          	addi	a0,a0,-184 # 64e8 <malloc+0xfdc>
    25a8:	2af020ef          	jal	5056 <unlink>
  for(int i = 0; i < nzz; i++){
    25ac:	4481                	li	s1,0
    name[0] = 'z';
    25ae:	07a00913          	li	s2,122
    unlink(name);
    25b2:	b9040a13          	addi	s4,s0,-1136
  for(int i = 0; i < nzz; i++){
    25b6:	08000993          	li	s3,128
    name[0] = 'z';
    25ba:	b9240823          	sb	s2,-1136(s0)
    name[1] = 'z';
    25be:	b92408a3          	sb	s2,-1135(s0)
    name[2] = '0' + (i / 32);
    25c2:	41f4d71b          	sraiw	a4,s1,0x1f
    25c6:	01b7571b          	srliw	a4,a4,0x1b
    25ca:	009707bb          	addw	a5,a4,s1
    25ce:	4057d69b          	sraiw	a3,a5,0x5
    25d2:	0306869b          	addiw	a3,a3,48
    25d6:	b8d40923          	sb	a3,-1134(s0)
    name[3] = '0' + (i % 32);
    25da:	8bfd                	andi	a5,a5,31
    25dc:	9f99                	subw	a5,a5,a4
    25de:	0307879b          	addiw	a5,a5,48
    25e2:	b8f409a3          	sb	a5,-1133(s0)
    name[4] = '\0';
    25e6:	b8040a23          	sb	zero,-1132(s0)
    unlink(name);
    25ea:	8552                	mv	a0,s4
    25ec:	26b020ef          	jal	5056 <unlink>
  for(int i = 0; i < nzz; i++){
    25f0:	2485                	addiw	s1,s1,1
    25f2:	fd3494e3          	bne	s1,s3,25ba <diskfull+0x118>
    25f6:	03000493          	li	s1,48
    name[0] = 'b';
    25fa:	06200b13          	li	s6,98
    name[1] = 'i';
    25fe:	06900a93          	li	s5,105
    name[2] = 'g';
    2602:	06700a13          	li	s4,103
    unlink(name);
    2606:	b9040993          	addi	s3,s0,-1136
  for(int i = 0; '0' + i < 0177; i++){
    260a:	07f00913          	li	s2,127
    name[0] = 'b';
    260e:	b9640823          	sb	s6,-1136(s0)
    name[1] = 'i';
    2612:	b95408a3          	sb	s5,-1135(s0)
    name[2] = 'g';
    2616:	b9440923          	sb	s4,-1134(s0)
    name[3] = '0' + i;
    261a:	b89409a3          	sb	s1,-1133(s0)
    name[4] = '\0';
    261e:	b8040a23          	sb	zero,-1132(s0)
    unlink(name);
    2622:	854e                	mv	a0,s3
    2624:	233020ef          	jal	5056 <unlink>
  for(int i = 0; '0' + i < 0177; i++){
    2628:	2485                	addiw	s1,s1,1
    262a:	0ff4f493          	zext.b	s1,s1
    262e:	ff2490e3          	bne	s1,s2,260e <diskfull+0x16c>
}
    2632:	49813083          	ld	ra,1176(sp)
    2636:	49013403          	ld	s0,1168(sp)
    263a:	48813483          	ld	s1,1160(sp)
    263e:	48013903          	ld	s2,1152(sp)
    2642:	47813983          	ld	s3,1144(sp)
    2646:	47013a03          	ld	s4,1136(sp)
    264a:	46813a83          	ld	s5,1128(sp)
    264e:	46013b03          	ld	s6,1120(sp)
    2652:	45813b83          	ld	s7,1112(sp)
    2656:	45013c03          	ld	s8,1104(sp)
    265a:	44813c83          	ld	s9,1096(sp)
    265e:	44013d03          	ld	s10,1088(sp)
    2662:	43813d83          	ld	s11,1080(sp)
    2666:	4a010113          	addi	sp,sp,1184
    266a:	8082                	ret
    close(fd);
    266c:	854e                	mv	a0,s3
    266e:	1c1020ef          	jal	502e <close>
  for(fi = 0; done == 0 && '0' + fi < 0177; fi++){
    2672:	2a85                	addiw	s5,s5,1 # 3001 <dirfile+0x21>
    2674:	0ffafa93          	zext.b	s5,s5
    2678:	07f00793          	li	a5,127
    267c:	eafa8be3          	beq	s5,a5,2532 <diskfull+0x90>
    name[0] = 'b';
    2680:	b7a40823          	sb	s10,-1168(s0)
    name[1] = 'i';
    2684:	b79408a3          	sb	s9,-1167(s0)
    name[2] = 'g';
    2688:	b7840923          	sb	s8,-1166(s0)
    name[3] = '0' + fi;
    268c:	b75409a3          	sb	s5,-1165(s0)
    name[4] = '\0';
    2690:	b6040a23          	sb	zero,-1164(s0)
    unlink(name);
    2694:	855a                	mv	a0,s6
    2696:	1c1020ef          	jal	5056 <unlink>
    int fd = open(name, O_CREATE|O_RDWR|O_TRUNC);
    269a:	85de                	mv	a1,s7
    269c:	855a                	mv	a0,s6
    269e:	1a9020ef          	jal	5046 <open>
    26a2:	89aa                	mv	s3,a0
    if(fd < 0){
    26a4:	e60546e3          	bltz	a0,2510 <diskfull+0x6e>
    26a8:	84ee                	mv	s1,s11
      if(write(fd, buf, BSIZE) != BSIZE){
    26aa:	40000913          	li	s2,1024
    26ae:	864a                	mv	a2,s2
    26b0:	85d2                	mv	a1,s4
    26b2:	854e                	mv	a0,s3
    26b4:	173020ef          	jal	5026 <write>
    26b8:	e72517e3          	bne	a0,s2,2526 <diskfull+0x84>
    for(int i = 0; i < MAXFILE; i++){
    26bc:	34fd                	addiw	s1,s1,-1
    26be:	f8e5                	bnez	s1,26ae <diskfull+0x20c>
    26c0:	b775                	j	266c <diskfull+0x1ca>
    printf("%s: mkdir(diskfulldir) unexpectedly succeeded!\n", s);
    26c2:	b6843583          	ld	a1,-1176(s0)
    26c6:	00004517          	auipc	a0,0x4
    26ca:	e5250513          	addi	a0,a0,-430 # 6518 <malloc+0x100c>
    26ce:	587020ef          	jal	5454 <printf>
    26d2:	b5f9                	j	25a0 <diskfull+0xfe>

00000000000026d4 <iputtest>:
{
    26d4:	1101                	addi	sp,sp,-32
    26d6:	ec06                	sd	ra,24(sp)
    26d8:	e822                	sd	s0,16(sp)
    26da:	e426                	sd	s1,8(sp)
    26dc:	1000                	addi	s0,sp,32
    26de:	84aa                	mv	s1,a0
  if(mkdir("iputdir") < 0){
    26e0:	00004517          	auipc	a0,0x4
    26e4:	e6850513          	addi	a0,a0,-408 # 6548 <malloc+0x103c>
    26e8:	187020ef          	jal	506e <mkdir>
    26ec:	02054f63          	bltz	a0,272a <iputtest+0x56>
  if(chdir("iputdir") < 0){
    26f0:	00004517          	auipc	a0,0x4
    26f4:	e5850513          	addi	a0,a0,-424 # 6548 <malloc+0x103c>
    26f8:	17f020ef          	jal	5076 <chdir>
    26fc:	04054163          	bltz	a0,273e <iputtest+0x6a>
  if(unlink("../iputdir") < 0){
    2700:	00004517          	auipc	a0,0x4
    2704:	e8850513          	addi	a0,a0,-376 # 6588 <malloc+0x107c>
    2708:	14f020ef          	jal	5056 <unlink>
    270c:	04054363          	bltz	a0,2752 <iputtest+0x7e>
  if(chdir("/") < 0){
    2710:	00004517          	auipc	a0,0x4
    2714:	ea850513          	addi	a0,a0,-344 # 65b8 <malloc+0x10ac>
    2718:	15f020ef          	jal	5076 <chdir>
    271c:	04054563          	bltz	a0,2766 <iputtest+0x92>
}
    2720:	60e2                	ld	ra,24(sp)
    2722:	6442                	ld	s0,16(sp)
    2724:	64a2                	ld	s1,8(sp)
    2726:	6105                	addi	sp,sp,32
    2728:	8082                	ret
    printf("%s: mkdir failed\n", s);
    272a:	85a6                	mv	a1,s1
    272c:	00004517          	auipc	a0,0x4
    2730:	e2450513          	addi	a0,a0,-476 # 6550 <malloc+0x1044>
    2734:	521020ef          	jal	5454 <printf>
    exit(1);
    2738:	4505                	li	a0,1
    273a:	0cd020ef          	jal	5006 <exit>
    printf("%s: chdir iputdir failed\n", s);
    273e:	85a6                	mv	a1,s1
    2740:	00004517          	auipc	a0,0x4
    2744:	e2850513          	addi	a0,a0,-472 # 6568 <malloc+0x105c>
    2748:	50d020ef          	jal	5454 <printf>
    exit(1);
    274c:	4505                	li	a0,1
    274e:	0b9020ef          	jal	5006 <exit>
    printf("%s: unlink ../iputdir failed\n", s);
    2752:	85a6                	mv	a1,s1
    2754:	00004517          	auipc	a0,0x4
    2758:	e4450513          	addi	a0,a0,-444 # 6598 <malloc+0x108c>
    275c:	4f9020ef          	jal	5454 <printf>
    exit(1);
    2760:	4505                	li	a0,1
    2762:	0a5020ef          	jal	5006 <exit>
    printf("%s: chdir / failed\n", s);
    2766:	85a6                	mv	a1,s1
    2768:	00004517          	auipc	a0,0x4
    276c:	e5850513          	addi	a0,a0,-424 # 65c0 <malloc+0x10b4>
    2770:	4e5020ef          	jal	5454 <printf>
    exit(1);
    2774:	4505                	li	a0,1
    2776:	091020ef          	jal	5006 <exit>

000000000000277a <exitiputtest>:
{
    277a:	7179                	addi	sp,sp,-48
    277c:	f406                	sd	ra,40(sp)
    277e:	f022                	sd	s0,32(sp)
    2780:	ec26                	sd	s1,24(sp)
    2782:	1800                	addi	s0,sp,48
    2784:	84aa                	mv	s1,a0
  pid = fork();
    2786:	079020ef          	jal	4ffe <fork>
  if(pid < 0){
    278a:	02054e63          	bltz	a0,27c6 <exitiputtest+0x4c>
  if(pid == 0){
    278e:	e541                	bnez	a0,2816 <exitiputtest+0x9c>
    if(mkdir("iputdir") < 0){
    2790:	00004517          	auipc	a0,0x4
    2794:	db850513          	addi	a0,a0,-584 # 6548 <malloc+0x103c>
    2798:	0d7020ef          	jal	506e <mkdir>
    279c:	02054f63          	bltz	a0,27da <exitiputtest+0x60>
    if(chdir("iputdir") < 0){
    27a0:	00004517          	auipc	a0,0x4
    27a4:	da850513          	addi	a0,a0,-600 # 6548 <malloc+0x103c>
    27a8:	0cf020ef          	jal	5076 <chdir>
    27ac:	04054163          	bltz	a0,27ee <exitiputtest+0x74>
    if(unlink("../iputdir") < 0){
    27b0:	00004517          	auipc	a0,0x4
    27b4:	dd850513          	addi	a0,a0,-552 # 6588 <malloc+0x107c>
    27b8:	09f020ef          	jal	5056 <unlink>
    27bc:	04054363          	bltz	a0,2802 <exitiputtest+0x88>
    exit(0);
    27c0:	4501                	li	a0,0
    27c2:	045020ef          	jal	5006 <exit>
    printf("%s: fork failed\n", s);
    27c6:	85a6                	mv	a1,s1
    27c8:	00003517          	auipc	a0,0x3
    27cc:	52050513          	addi	a0,a0,1312 # 5ce8 <malloc+0x7dc>
    27d0:	485020ef          	jal	5454 <printf>
    exit(1);
    27d4:	4505                	li	a0,1
    27d6:	031020ef          	jal	5006 <exit>
      printf("%s: mkdir failed\n", s);
    27da:	85a6                	mv	a1,s1
    27dc:	00004517          	auipc	a0,0x4
    27e0:	d7450513          	addi	a0,a0,-652 # 6550 <malloc+0x1044>
    27e4:	471020ef          	jal	5454 <printf>
      exit(1);
    27e8:	4505                	li	a0,1
    27ea:	01d020ef          	jal	5006 <exit>
      printf("%s: child chdir failed\n", s);
    27ee:	85a6                	mv	a1,s1
    27f0:	00004517          	auipc	a0,0x4
    27f4:	de850513          	addi	a0,a0,-536 # 65d8 <malloc+0x10cc>
    27f8:	45d020ef          	jal	5454 <printf>
      exit(1);
    27fc:	4505                	li	a0,1
    27fe:	009020ef          	jal	5006 <exit>
      printf("%s: unlink ../iputdir failed\n", s);
    2802:	85a6                	mv	a1,s1
    2804:	00004517          	auipc	a0,0x4
    2808:	d9450513          	addi	a0,a0,-620 # 6598 <malloc+0x108c>
    280c:	449020ef          	jal	5454 <printf>
      exit(1);
    2810:	4505                	li	a0,1
    2812:	7f4020ef          	jal	5006 <exit>
  wait(&xstatus);
    2816:	fdc40513          	addi	a0,s0,-36
    281a:	7f4020ef          	jal	500e <wait>
  exit(xstatus);
    281e:	fdc42503          	lw	a0,-36(s0)
    2822:	7e4020ef          	jal	5006 <exit>

0000000000002826 <dirtest>:
{
    2826:	1101                	addi	sp,sp,-32
    2828:	ec06                	sd	ra,24(sp)
    282a:	e822                	sd	s0,16(sp)
    282c:	e426                	sd	s1,8(sp)
    282e:	1000                	addi	s0,sp,32
    2830:	84aa                	mv	s1,a0
  if(mkdir("dir0") < 0){
    2832:	00004517          	auipc	a0,0x4
    2836:	dbe50513          	addi	a0,a0,-578 # 65f0 <malloc+0x10e4>
    283a:	035020ef          	jal	506e <mkdir>
    283e:	02054f63          	bltz	a0,287c <dirtest+0x56>
  if(chdir("dir0") < 0){
    2842:	00004517          	auipc	a0,0x4
    2846:	dae50513          	addi	a0,a0,-594 # 65f0 <malloc+0x10e4>
    284a:	02d020ef          	jal	5076 <chdir>
    284e:	04054163          	bltz	a0,2890 <dirtest+0x6a>
  if(chdir("..") < 0){
    2852:	00004517          	auipc	a0,0x4
    2856:	dbe50513          	addi	a0,a0,-578 # 6610 <malloc+0x1104>
    285a:	01d020ef          	jal	5076 <chdir>
    285e:	04054363          	bltz	a0,28a4 <dirtest+0x7e>
  if(unlink("dir0") < 0){
    2862:	00004517          	auipc	a0,0x4
    2866:	d8e50513          	addi	a0,a0,-626 # 65f0 <malloc+0x10e4>
    286a:	7ec020ef          	jal	5056 <unlink>
    286e:	04054563          	bltz	a0,28b8 <dirtest+0x92>
}
    2872:	60e2                	ld	ra,24(sp)
    2874:	6442                	ld	s0,16(sp)
    2876:	64a2                	ld	s1,8(sp)
    2878:	6105                	addi	sp,sp,32
    287a:	8082                	ret
    printf("%s: mkdir failed\n", s);
    287c:	85a6                	mv	a1,s1
    287e:	00004517          	auipc	a0,0x4
    2882:	cd250513          	addi	a0,a0,-814 # 6550 <malloc+0x1044>
    2886:	3cf020ef          	jal	5454 <printf>
    exit(1);
    288a:	4505                	li	a0,1
    288c:	77a020ef          	jal	5006 <exit>
    printf("%s: chdir dir0 failed\n", s);
    2890:	85a6                	mv	a1,s1
    2892:	00004517          	auipc	a0,0x4
    2896:	d6650513          	addi	a0,a0,-666 # 65f8 <malloc+0x10ec>
    289a:	3bb020ef          	jal	5454 <printf>
    exit(1);
    289e:	4505                	li	a0,1
    28a0:	766020ef          	jal	5006 <exit>
    printf("%s: chdir .. failed\n", s);
    28a4:	85a6                	mv	a1,s1
    28a6:	00004517          	auipc	a0,0x4
    28aa:	d7250513          	addi	a0,a0,-654 # 6618 <malloc+0x110c>
    28ae:	3a7020ef          	jal	5454 <printf>
    exit(1);
    28b2:	4505                	li	a0,1
    28b4:	752020ef          	jal	5006 <exit>
    printf("%s: unlink dir0 failed\n", s);
    28b8:	85a6                	mv	a1,s1
    28ba:	00004517          	auipc	a0,0x4
    28be:	d7650513          	addi	a0,a0,-650 # 6630 <malloc+0x1124>
    28c2:	393020ef          	jal	5454 <printf>
    exit(1);
    28c6:	4505                	li	a0,1
    28c8:	73e020ef          	jal	5006 <exit>

00000000000028cc <subdir>:
{
    28cc:	1101                	addi	sp,sp,-32
    28ce:	ec06                	sd	ra,24(sp)
    28d0:	e822                	sd	s0,16(sp)
    28d2:	e426                	sd	s1,8(sp)
    28d4:	e04a                	sd	s2,0(sp)
    28d6:	1000                	addi	s0,sp,32
    28d8:	892a                	mv	s2,a0
  unlink("ff");
    28da:	00004517          	auipc	a0,0x4
    28de:	e9e50513          	addi	a0,a0,-354 # 6778 <malloc+0x126c>
    28e2:	774020ef          	jal	5056 <unlink>
  if(mkdir("dd") != 0){
    28e6:	00004517          	auipc	a0,0x4
    28ea:	d6250513          	addi	a0,a0,-670 # 6648 <malloc+0x113c>
    28ee:	780020ef          	jal	506e <mkdir>
    28f2:	2e051263          	bnez	a0,2bd6 <subdir+0x30a>
  fd = open("dd/ff", O_CREATE | O_RDWR);
    28f6:	20200593          	li	a1,514
    28fa:	00004517          	auipc	a0,0x4
    28fe:	d6e50513          	addi	a0,a0,-658 # 6668 <malloc+0x115c>
    2902:	744020ef          	jal	5046 <open>
    2906:	84aa                	mv	s1,a0
  if(fd < 0){
    2908:	2e054163          	bltz	a0,2bea <subdir+0x31e>
  write(fd, "ff", 2);
    290c:	4609                	li	a2,2
    290e:	00004597          	auipc	a1,0x4
    2912:	e6a58593          	addi	a1,a1,-406 # 6778 <malloc+0x126c>
    2916:	710020ef          	jal	5026 <write>
  close(fd);
    291a:	8526                	mv	a0,s1
    291c:	712020ef          	jal	502e <close>
  if(unlink("dd") >= 0){
    2920:	00004517          	auipc	a0,0x4
    2924:	d2850513          	addi	a0,a0,-728 # 6648 <malloc+0x113c>
    2928:	72e020ef          	jal	5056 <unlink>
    292c:	2c055963          	bgez	a0,2bfe <subdir+0x332>
  if(mkdir("/dd/dd") != 0){
    2930:	00004517          	auipc	a0,0x4
    2934:	d9050513          	addi	a0,a0,-624 # 66c0 <malloc+0x11b4>
    2938:	736020ef          	jal	506e <mkdir>
    293c:	2c051b63          	bnez	a0,2c12 <subdir+0x346>
  fd = open("dd/dd/ff", O_CREATE | O_RDWR);
    2940:	20200593          	li	a1,514
    2944:	00004517          	auipc	a0,0x4
    2948:	da450513          	addi	a0,a0,-604 # 66e8 <malloc+0x11dc>
    294c:	6fa020ef          	jal	5046 <open>
    2950:	84aa                	mv	s1,a0
  if(fd < 0){
    2952:	2c054a63          	bltz	a0,2c26 <subdir+0x35a>
  write(fd, "FF", 2);
    2956:	4609                	li	a2,2
    2958:	00004597          	auipc	a1,0x4
    295c:	dc058593          	addi	a1,a1,-576 # 6718 <malloc+0x120c>
    2960:	6c6020ef          	jal	5026 <write>
  close(fd);
    2964:	8526                	mv	a0,s1
    2966:	6c8020ef          	jal	502e <close>
  fd = open("dd/dd/../ff", 0);
    296a:	4581                	li	a1,0
    296c:	00004517          	auipc	a0,0x4
    2970:	db450513          	addi	a0,a0,-588 # 6720 <malloc+0x1214>
    2974:	6d2020ef          	jal	5046 <open>
    2978:	84aa                	mv	s1,a0
  if(fd < 0){
    297a:	2c054063          	bltz	a0,2c3a <subdir+0x36e>
  cc = read(fd, buf, sizeof(buf));
    297e:	660d                	lui	a2,0x3
    2980:	0000b597          	auipc	a1,0xb
    2984:	30858593          	addi	a1,a1,776 # dc88 <buf>
    2988:	696020ef          	jal	501e <read>
  if(cc != 2 || buf[0] != 'f'){
    298c:	4789                	li	a5,2
    298e:	2cf51063          	bne	a0,a5,2c4e <subdir+0x382>
    2992:	0000b717          	auipc	a4,0xb
    2996:	2f674703          	lbu	a4,758(a4) # dc88 <buf>
    299a:	06600793          	li	a5,102
    299e:	2af71863          	bne	a4,a5,2c4e <subdir+0x382>
  close(fd);
    29a2:	8526                	mv	a0,s1
    29a4:	68a020ef          	jal	502e <close>
  if(link("dd/dd/ff", "dd/dd/ffff") != 0){
    29a8:	00004597          	auipc	a1,0x4
    29ac:	dc858593          	addi	a1,a1,-568 # 6770 <malloc+0x1264>
    29b0:	00004517          	auipc	a0,0x4
    29b4:	d3850513          	addi	a0,a0,-712 # 66e8 <malloc+0x11dc>
    29b8:	6ae020ef          	jal	5066 <link>
    29bc:	2a051363          	bnez	a0,2c62 <subdir+0x396>
  if(unlink("dd/dd/ff") != 0){
    29c0:	00004517          	auipc	a0,0x4
    29c4:	d2850513          	addi	a0,a0,-728 # 66e8 <malloc+0x11dc>
    29c8:	68e020ef          	jal	5056 <unlink>
    29cc:	2a051563          	bnez	a0,2c76 <subdir+0x3aa>
  if(open("dd/dd/ff", O_RDONLY) >= 0){
    29d0:	4581                	li	a1,0
    29d2:	00004517          	auipc	a0,0x4
    29d6:	d1650513          	addi	a0,a0,-746 # 66e8 <malloc+0x11dc>
    29da:	66c020ef          	jal	5046 <open>
    29de:	2a055663          	bgez	a0,2c8a <subdir+0x3be>
  if(chdir("dd") != 0){
    29e2:	00004517          	auipc	a0,0x4
    29e6:	c6650513          	addi	a0,a0,-922 # 6648 <malloc+0x113c>
    29ea:	68c020ef          	jal	5076 <chdir>
    29ee:	2a051863          	bnez	a0,2c9e <subdir+0x3d2>
  if(chdir("dd/../../dd") != 0){
    29f2:	00004517          	auipc	a0,0x4
    29f6:	e1650513          	addi	a0,a0,-490 # 6808 <malloc+0x12fc>
    29fa:	67c020ef          	jal	5076 <chdir>
    29fe:	2a051a63          	bnez	a0,2cb2 <subdir+0x3e6>
  if(chdir("dd/../../../dd") != 0){
    2a02:	00004517          	auipc	a0,0x4
    2a06:	e3650513          	addi	a0,a0,-458 # 6838 <malloc+0x132c>
    2a0a:	66c020ef          	jal	5076 <chdir>
    2a0e:	2a051c63          	bnez	a0,2cc6 <subdir+0x3fa>
  if(chdir("./..") != 0){
    2a12:	00004517          	auipc	a0,0x4
    2a16:	e5e50513          	addi	a0,a0,-418 # 6870 <malloc+0x1364>
    2a1a:	65c020ef          	jal	5076 <chdir>
    2a1e:	2a051e63          	bnez	a0,2cda <subdir+0x40e>
  fd = open("dd/dd/ffff", 0);
    2a22:	4581                	li	a1,0
    2a24:	00004517          	auipc	a0,0x4
    2a28:	d4c50513          	addi	a0,a0,-692 # 6770 <malloc+0x1264>
    2a2c:	61a020ef          	jal	5046 <open>
    2a30:	84aa                	mv	s1,a0
  if(fd < 0){
    2a32:	2a054e63          	bltz	a0,2cee <subdir+0x422>
  if(read(fd, buf, sizeof(buf)) != 2){
    2a36:	660d                	lui	a2,0x3
    2a38:	0000b597          	auipc	a1,0xb
    2a3c:	25058593          	addi	a1,a1,592 # dc88 <buf>
    2a40:	5de020ef          	jal	501e <read>
    2a44:	4789                	li	a5,2
    2a46:	2af51e63          	bne	a0,a5,2d02 <subdir+0x436>
  close(fd);
    2a4a:	8526                	mv	a0,s1
    2a4c:	5e2020ef          	jal	502e <close>
  if(open("dd/dd/ff", O_RDONLY) >= 0){
    2a50:	4581                	li	a1,0
    2a52:	00004517          	auipc	a0,0x4
    2a56:	c9650513          	addi	a0,a0,-874 # 66e8 <malloc+0x11dc>
    2a5a:	5ec020ef          	jal	5046 <open>
    2a5e:	2a055c63          	bgez	a0,2d16 <subdir+0x44a>
  if(open("dd/ff/ff", O_CREATE|O_RDWR) >= 0){
    2a62:	20200593          	li	a1,514
    2a66:	00004517          	auipc	a0,0x4
    2a6a:	e9a50513          	addi	a0,a0,-358 # 6900 <malloc+0x13f4>
    2a6e:	5d8020ef          	jal	5046 <open>
    2a72:	2a055c63          	bgez	a0,2d2a <subdir+0x45e>
  if(open("dd/xx/ff", O_CREATE|O_RDWR) >= 0){
    2a76:	20200593          	li	a1,514
    2a7a:	00004517          	auipc	a0,0x4
    2a7e:	eb650513          	addi	a0,a0,-330 # 6930 <malloc+0x1424>
    2a82:	5c4020ef          	jal	5046 <open>
    2a86:	2a055c63          	bgez	a0,2d3e <subdir+0x472>
  if(open("dd", O_CREATE) >= 0){
    2a8a:	20000593          	li	a1,512
    2a8e:	00004517          	auipc	a0,0x4
    2a92:	bba50513          	addi	a0,a0,-1094 # 6648 <malloc+0x113c>
    2a96:	5b0020ef          	jal	5046 <open>
    2a9a:	2a055c63          	bgez	a0,2d52 <subdir+0x486>
  if(open("dd", O_RDWR) >= 0){
    2a9e:	4589                	li	a1,2
    2aa0:	00004517          	auipc	a0,0x4
    2aa4:	ba850513          	addi	a0,a0,-1112 # 6648 <malloc+0x113c>
    2aa8:	59e020ef          	jal	5046 <open>
    2aac:	2a055d63          	bgez	a0,2d66 <subdir+0x49a>
  if(open("dd", O_WRONLY) >= 0){
    2ab0:	4585                	li	a1,1
    2ab2:	00004517          	auipc	a0,0x4
    2ab6:	b9650513          	addi	a0,a0,-1130 # 6648 <malloc+0x113c>
    2aba:	58c020ef          	jal	5046 <open>
    2abe:	2a055e63          	bgez	a0,2d7a <subdir+0x4ae>
  if(link("dd/ff/ff", "dd/dd/xx") == 0){
    2ac2:	00004597          	auipc	a1,0x4
    2ac6:	efe58593          	addi	a1,a1,-258 # 69c0 <malloc+0x14b4>
    2aca:	00004517          	auipc	a0,0x4
    2ace:	e3650513          	addi	a0,a0,-458 # 6900 <malloc+0x13f4>
    2ad2:	594020ef          	jal	5066 <link>
    2ad6:	2a050c63          	beqz	a0,2d8e <subdir+0x4c2>
  if(link("dd/xx/ff", "dd/dd/xx") == 0){
    2ada:	00004597          	auipc	a1,0x4
    2ade:	ee658593          	addi	a1,a1,-282 # 69c0 <malloc+0x14b4>
    2ae2:	00004517          	auipc	a0,0x4
    2ae6:	e4e50513          	addi	a0,a0,-434 # 6930 <malloc+0x1424>
    2aea:	57c020ef          	jal	5066 <link>
    2aee:	2a050a63          	beqz	a0,2da2 <subdir+0x4d6>
  if(link("dd/ff", "dd/dd/ffff") == 0){
    2af2:	00004597          	auipc	a1,0x4
    2af6:	c7e58593          	addi	a1,a1,-898 # 6770 <malloc+0x1264>
    2afa:	00004517          	auipc	a0,0x4
    2afe:	b6e50513          	addi	a0,a0,-1170 # 6668 <malloc+0x115c>
    2b02:	564020ef          	jal	5066 <link>
    2b06:	2a050863          	beqz	a0,2db6 <subdir+0x4ea>
  if(mkdir("dd/ff/ff") == 0){
    2b0a:	00004517          	auipc	a0,0x4
    2b0e:	df650513          	addi	a0,a0,-522 # 6900 <malloc+0x13f4>
    2b12:	55c020ef          	jal	506e <mkdir>
    2b16:	2a050a63          	beqz	a0,2dca <subdir+0x4fe>
  if(mkdir("dd/xx/ff") == 0){
    2b1a:	00004517          	auipc	a0,0x4
    2b1e:	e1650513          	addi	a0,a0,-490 # 6930 <malloc+0x1424>
    2b22:	54c020ef          	jal	506e <mkdir>
    2b26:	2a050c63          	beqz	a0,2dde <subdir+0x512>
  if(mkdir("dd/dd/ffff") == 0){
    2b2a:	00004517          	auipc	a0,0x4
    2b2e:	c4650513          	addi	a0,a0,-954 # 6770 <malloc+0x1264>
    2b32:	53c020ef          	jal	506e <mkdir>
    2b36:	2a050e63          	beqz	a0,2df2 <subdir+0x526>
  if(unlink("dd/xx/ff") == 0){
    2b3a:	00004517          	auipc	a0,0x4
    2b3e:	df650513          	addi	a0,a0,-522 # 6930 <malloc+0x1424>
    2b42:	514020ef          	jal	5056 <unlink>
    2b46:	2c050063          	beqz	a0,2e06 <subdir+0x53a>
  if(unlink("dd/ff/ff") == 0){
    2b4a:	00004517          	auipc	a0,0x4
    2b4e:	db650513          	addi	a0,a0,-586 # 6900 <malloc+0x13f4>
    2b52:	504020ef          	jal	5056 <unlink>
    2b56:	2c050263          	beqz	a0,2e1a <subdir+0x54e>
  if(chdir("dd/ff") == 0){
    2b5a:	00004517          	auipc	a0,0x4
    2b5e:	b0e50513          	addi	a0,a0,-1266 # 6668 <malloc+0x115c>
    2b62:	514020ef          	jal	5076 <chdir>
    2b66:	2c050463          	beqz	a0,2e2e <subdir+0x562>
  if(chdir("dd/xx") == 0){
    2b6a:	00004517          	auipc	a0,0x4
    2b6e:	fa650513          	addi	a0,a0,-90 # 6b10 <malloc+0x1604>
    2b72:	504020ef          	jal	5076 <chdir>
    2b76:	2c050663          	beqz	a0,2e42 <subdir+0x576>
  if(unlink("dd/dd/ffff") != 0){
    2b7a:	00004517          	auipc	a0,0x4
    2b7e:	bf650513          	addi	a0,a0,-1034 # 6770 <malloc+0x1264>
    2b82:	4d4020ef          	jal	5056 <unlink>
    2b86:	2c051863          	bnez	a0,2e56 <subdir+0x58a>
  if(unlink("dd/ff") != 0){
    2b8a:	00004517          	auipc	a0,0x4
    2b8e:	ade50513          	addi	a0,a0,-1314 # 6668 <malloc+0x115c>
    2b92:	4c4020ef          	jal	5056 <unlink>
    2b96:	2c051a63          	bnez	a0,2e6a <subdir+0x59e>
  if(unlink("dd") == 0){
    2b9a:	00004517          	auipc	a0,0x4
    2b9e:	aae50513          	addi	a0,a0,-1362 # 6648 <malloc+0x113c>
    2ba2:	4b4020ef          	jal	5056 <unlink>
    2ba6:	2c050c63          	beqz	a0,2e7e <subdir+0x5b2>
  if(unlink("dd/dd") < 0){
    2baa:	00004517          	auipc	a0,0x4
    2bae:	fd650513          	addi	a0,a0,-42 # 6b80 <malloc+0x1674>
    2bb2:	4a4020ef          	jal	5056 <unlink>
    2bb6:	2c054e63          	bltz	a0,2e92 <subdir+0x5c6>
  if(unlink("dd") < 0){
    2bba:	00004517          	auipc	a0,0x4
    2bbe:	a8e50513          	addi	a0,a0,-1394 # 6648 <malloc+0x113c>
    2bc2:	494020ef          	jal	5056 <unlink>
    2bc6:	2e054063          	bltz	a0,2ea6 <subdir+0x5da>
}
    2bca:	60e2                	ld	ra,24(sp)
    2bcc:	6442                	ld	s0,16(sp)
    2bce:	64a2                	ld	s1,8(sp)
    2bd0:	6902                	ld	s2,0(sp)
    2bd2:	6105                	addi	sp,sp,32
    2bd4:	8082                	ret
    printf("%s: mkdir dd failed\n", s);
    2bd6:	85ca                	mv	a1,s2
    2bd8:	00004517          	auipc	a0,0x4
    2bdc:	a7850513          	addi	a0,a0,-1416 # 6650 <malloc+0x1144>
    2be0:	075020ef          	jal	5454 <printf>
    exit(1);
    2be4:	4505                	li	a0,1
    2be6:	420020ef          	jal	5006 <exit>
    printf("%s: create dd/ff failed\n", s);
    2bea:	85ca                	mv	a1,s2
    2bec:	00004517          	auipc	a0,0x4
    2bf0:	a8450513          	addi	a0,a0,-1404 # 6670 <malloc+0x1164>
    2bf4:	061020ef          	jal	5454 <printf>
    exit(1);
    2bf8:	4505                	li	a0,1
    2bfa:	40c020ef          	jal	5006 <exit>
    printf("%s: unlink dd (non-empty dir) succeeded!\n", s);
    2bfe:	85ca                	mv	a1,s2
    2c00:	00004517          	auipc	a0,0x4
    2c04:	a9050513          	addi	a0,a0,-1392 # 6690 <malloc+0x1184>
    2c08:	04d020ef          	jal	5454 <printf>
    exit(1);
    2c0c:	4505                	li	a0,1
    2c0e:	3f8020ef          	jal	5006 <exit>
    printf("%s: subdir mkdir dd/dd failed\n", s);
    2c12:	85ca                	mv	a1,s2
    2c14:	00004517          	auipc	a0,0x4
    2c18:	ab450513          	addi	a0,a0,-1356 # 66c8 <malloc+0x11bc>
    2c1c:	039020ef          	jal	5454 <printf>
    exit(1);
    2c20:	4505                	li	a0,1
    2c22:	3e4020ef          	jal	5006 <exit>
    printf("%s: create dd/dd/ff failed\n", s);
    2c26:	85ca                	mv	a1,s2
    2c28:	00004517          	auipc	a0,0x4
    2c2c:	ad050513          	addi	a0,a0,-1328 # 66f8 <malloc+0x11ec>
    2c30:	025020ef          	jal	5454 <printf>
    exit(1);
    2c34:	4505                	li	a0,1
    2c36:	3d0020ef          	jal	5006 <exit>
    printf("%s: open dd/dd/../ff failed\n", s);
    2c3a:	85ca                	mv	a1,s2
    2c3c:	00004517          	auipc	a0,0x4
    2c40:	af450513          	addi	a0,a0,-1292 # 6730 <malloc+0x1224>
    2c44:	011020ef          	jal	5454 <printf>
    exit(1);
    2c48:	4505                	li	a0,1
    2c4a:	3bc020ef          	jal	5006 <exit>
    printf("%s: dd/dd/../ff wrong content\n", s);
    2c4e:	85ca                	mv	a1,s2
    2c50:	00004517          	auipc	a0,0x4
    2c54:	b0050513          	addi	a0,a0,-1280 # 6750 <malloc+0x1244>
    2c58:	7fc020ef          	jal	5454 <printf>
    exit(1);
    2c5c:	4505                	li	a0,1
    2c5e:	3a8020ef          	jal	5006 <exit>
    printf("%s: link dd/dd/ff dd/dd/ffff failed\n", s);
    2c62:	85ca                	mv	a1,s2
    2c64:	00004517          	auipc	a0,0x4
    2c68:	b1c50513          	addi	a0,a0,-1252 # 6780 <malloc+0x1274>
    2c6c:	7e8020ef          	jal	5454 <printf>
    exit(1);
    2c70:	4505                	li	a0,1
    2c72:	394020ef          	jal	5006 <exit>
    printf("%s: unlink dd/dd/ff failed\n", s);
    2c76:	85ca                	mv	a1,s2
    2c78:	00004517          	auipc	a0,0x4
    2c7c:	b3050513          	addi	a0,a0,-1232 # 67a8 <malloc+0x129c>
    2c80:	7d4020ef          	jal	5454 <printf>
    exit(1);
    2c84:	4505                	li	a0,1
    2c86:	380020ef          	jal	5006 <exit>
    printf("%s: open (unlinked) dd/dd/ff succeeded\n", s);
    2c8a:	85ca                	mv	a1,s2
    2c8c:	00004517          	auipc	a0,0x4
    2c90:	b3c50513          	addi	a0,a0,-1220 # 67c8 <malloc+0x12bc>
    2c94:	7c0020ef          	jal	5454 <printf>
    exit(1);
    2c98:	4505                	li	a0,1
    2c9a:	36c020ef          	jal	5006 <exit>
    printf("%s: chdir dd failed\n", s);
    2c9e:	85ca                	mv	a1,s2
    2ca0:	00004517          	auipc	a0,0x4
    2ca4:	b5050513          	addi	a0,a0,-1200 # 67f0 <malloc+0x12e4>
    2ca8:	7ac020ef          	jal	5454 <printf>
    exit(1);
    2cac:	4505                	li	a0,1
    2cae:	358020ef          	jal	5006 <exit>
    printf("%s: chdir dd/../../dd failed\n", s);
    2cb2:	85ca                	mv	a1,s2
    2cb4:	00004517          	auipc	a0,0x4
    2cb8:	b6450513          	addi	a0,a0,-1180 # 6818 <malloc+0x130c>
    2cbc:	798020ef          	jal	5454 <printf>
    exit(1);
    2cc0:	4505                	li	a0,1
    2cc2:	344020ef          	jal	5006 <exit>
    printf("%s: chdir dd/../../../dd failed\n", s);
    2cc6:	85ca                	mv	a1,s2
    2cc8:	00004517          	auipc	a0,0x4
    2ccc:	b8050513          	addi	a0,a0,-1152 # 6848 <malloc+0x133c>
    2cd0:	784020ef          	jal	5454 <printf>
    exit(1);
    2cd4:	4505                	li	a0,1
    2cd6:	330020ef          	jal	5006 <exit>
    printf("%s: chdir ./.. failed\n", s);
    2cda:	85ca                	mv	a1,s2
    2cdc:	00004517          	auipc	a0,0x4
    2ce0:	b9c50513          	addi	a0,a0,-1124 # 6878 <malloc+0x136c>
    2ce4:	770020ef          	jal	5454 <printf>
    exit(1);
    2ce8:	4505                	li	a0,1
    2cea:	31c020ef          	jal	5006 <exit>
    printf("%s: open dd/dd/ffff failed\n", s);
    2cee:	85ca                	mv	a1,s2
    2cf0:	00004517          	auipc	a0,0x4
    2cf4:	ba050513          	addi	a0,a0,-1120 # 6890 <malloc+0x1384>
    2cf8:	75c020ef          	jal	5454 <printf>
    exit(1);
    2cfc:	4505                	li	a0,1
    2cfe:	308020ef          	jal	5006 <exit>
    printf("%s: read dd/dd/ffff wrong len\n", s);
    2d02:	85ca                	mv	a1,s2
    2d04:	00004517          	auipc	a0,0x4
    2d08:	bac50513          	addi	a0,a0,-1108 # 68b0 <malloc+0x13a4>
    2d0c:	748020ef          	jal	5454 <printf>
    exit(1);
    2d10:	4505                	li	a0,1
    2d12:	2f4020ef          	jal	5006 <exit>
    printf("%s: open (unlinked) dd/dd/ff succeeded!\n", s);
    2d16:	85ca                	mv	a1,s2
    2d18:	00004517          	auipc	a0,0x4
    2d1c:	bb850513          	addi	a0,a0,-1096 # 68d0 <malloc+0x13c4>
    2d20:	734020ef          	jal	5454 <printf>
    exit(1);
    2d24:	4505                	li	a0,1
    2d26:	2e0020ef          	jal	5006 <exit>
    printf("%s: create dd/ff/ff succeeded!\n", s);
    2d2a:	85ca                	mv	a1,s2
    2d2c:	00004517          	auipc	a0,0x4
    2d30:	be450513          	addi	a0,a0,-1052 # 6910 <malloc+0x1404>
    2d34:	720020ef          	jal	5454 <printf>
    exit(1);
    2d38:	4505                	li	a0,1
    2d3a:	2cc020ef          	jal	5006 <exit>
    printf("%s: create dd/xx/ff succeeded!\n", s);
    2d3e:	85ca                	mv	a1,s2
    2d40:	00004517          	auipc	a0,0x4
    2d44:	c0050513          	addi	a0,a0,-1024 # 6940 <malloc+0x1434>
    2d48:	70c020ef          	jal	5454 <printf>
    exit(1);
    2d4c:	4505                	li	a0,1
    2d4e:	2b8020ef          	jal	5006 <exit>
    printf("%s: create dd succeeded!\n", s);
    2d52:	85ca                	mv	a1,s2
    2d54:	00004517          	auipc	a0,0x4
    2d58:	c0c50513          	addi	a0,a0,-1012 # 6960 <malloc+0x1454>
    2d5c:	6f8020ef          	jal	5454 <printf>
    exit(1);
    2d60:	4505                	li	a0,1
    2d62:	2a4020ef          	jal	5006 <exit>
    printf("%s: open dd rdwr succeeded!\n", s);
    2d66:	85ca                	mv	a1,s2
    2d68:	00004517          	auipc	a0,0x4
    2d6c:	c1850513          	addi	a0,a0,-1000 # 6980 <malloc+0x1474>
    2d70:	6e4020ef          	jal	5454 <printf>
    exit(1);
    2d74:	4505                	li	a0,1
    2d76:	290020ef          	jal	5006 <exit>
    printf("%s: open dd wronly succeeded!\n", s);
    2d7a:	85ca                	mv	a1,s2
    2d7c:	00004517          	auipc	a0,0x4
    2d80:	c2450513          	addi	a0,a0,-988 # 69a0 <malloc+0x1494>
    2d84:	6d0020ef          	jal	5454 <printf>
    exit(1);
    2d88:	4505                	li	a0,1
    2d8a:	27c020ef          	jal	5006 <exit>
    printf("%s: link dd/ff/ff dd/dd/xx succeeded!\n", s);
    2d8e:	85ca                	mv	a1,s2
    2d90:	00004517          	auipc	a0,0x4
    2d94:	c4050513          	addi	a0,a0,-960 # 69d0 <malloc+0x14c4>
    2d98:	6bc020ef          	jal	5454 <printf>
    exit(1);
    2d9c:	4505                	li	a0,1
    2d9e:	268020ef          	jal	5006 <exit>
    printf("%s: link dd/xx/ff dd/dd/xx succeeded!\n", s);
    2da2:	85ca                	mv	a1,s2
    2da4:	00004517          	auipc	a0,0x4
    2da8:	c5450513          	addi	a0,a0,-940 # 69f8 <malloc+0x14ec>
    2dac:	6a8020ef          	jal	5454 <printf>
    exit(1);
    2db0:	4505                	li	a0,1
    2db2:	254020ef          	jal	5006 <exit>
    printf("%s: link dd/ff dd/dd/ffff succeeded!\n", s);
    2db6:	85ca                	mv	a1,s2
    2db8:	00004517          	auipc	a0,0x4
    2dbc:	c6850513          	addi	a0,a0,-920 # 6a20 <malloc+0x1514>
    2dc0:	694020ef          	jal	5454 <printf>
    exit(1);
    2dc4:	4505                	li	a0,1
    2dc6:	240020ef          	jal	5006 <exit>
    printf("%s: mkdir dd/ff/ff succeeded!\n", s);
    2dca:	85ca                	mv	a1,s2
    2dcc:	00004517          	auipc	a0,0x4
    2dd0:	c7c50513          	addi	a0,a0,-900 # 6a48 <malloc+0x153c>
    2dd4:	680020ef          	jal	5454 <printf>
    exit(1);
    2dd8:	4505                	li	a0,1
    2dda:	22c020ef          	jal	5006 <exit>
    printf("%s: mkdir dd/xx/ff succeeded!\n", s);
    2dde:	85ca                	mv	a1,s2
    2de0:	00004517          	auipc	a0,0x4
    2de4:	c8850513          	addi	a0,a0,-888 # 6a68 <malloc+0x155c>
    2de8:	66c020ef          	jal	5454 <printf>
    exit(1);
    2dec:	4505                	li	a0,1
    2dee:	218020ef          	jal	5006 <exit>
    printf("%s: mkdir dd/dd/ffff succeeded!\n", s);
    2df2:	85ca                	mv	a1,s2
    2df4:	00004517          	auipc	a0,0x4
    2df8:	c9450513          	addi	a0,a0,-876 # 6a88 <malloc+0x157c>
    2dfc:	658020ef          	jal	5454 <printf>
    exit(1);
    2e00:	4505                	li	a0,1
    2e02:	204020ef          	jal	5006 <exit>
    printf("%s: unlink dd/xx/ff succeeded!\n", s);
    2e06:	85ca                	mv	a1,s2
    2e08:	00004517          	auipc	a0,0x4
    2e0c:	ca850513          	addi	a0,a0,-856 # 6ab0 <malloc+0x15a4>
    2e10:	644020ef          	jal	5454 <printf>
    exit(1);
    2e14:	4505                	li	a0,1
    2e16:	1f0020ef          	jal	5006 <exit>
    printf("%s: unlink dd/ff/ff succeeded!\n", s);
    2e1a:	85ca                	mv	a1,s2
    2e1c:	00004517          	auipc	a0,0x4
    2e20:	cb450513          	addi	a0,a0,-844 # 6ad0 <malloc+0x15c4>
    2e24:	630020ef          	jal	5454 <printf>
    exit(1);
    2e28:	4505                	li	a0,1
    2e2a:	1dc020ef          	jal	5006 <exit>
    printf("%s: chdir dd/ff succeeded!\n", s);
    2e2e:	85ca                	mv	a1,s2
    2e30:	00004517          	auipc	a0,0x4
    2e34:	cc050513          	addi	a0,a0,-832 # 6af0 <malloc+0x15e4>
    2e38:	61c020ef          	jal	5454 <printf>
    exit(1);
    2e3c:	4505                	li	a0,1
    2e3e:	1c8020ef          	jal	5006 <exit>
    printf("%s: chdir dd/xx succeeded!\n", s);
    2e42:	85ca                	mv	a1,s2
    2e44:	00004517          	auipc	a0,0x4
    2e48:	cd450513          	addi	a0,a0,-812 # 6b18 <malloc+0x160c>
    2e4c:	608020ef          	jal	5454 <printf>
    exit(1);
    2e50:	4505                	li	a0,1
    2e52:	1b4020ef          	jal	5006 <exit>
    printf("%s: unlink dd/dd/ff failed\n", s);
    2e56:	85ca                	mv	a1,s2
    2e58:	00004517          	auipc	a0,0x4
    2e5c:	95050513          	addi	a0,a0,-1712 # 67a8 <malloc+0x129c>
    2e60:	5f4020ef          	jal	5454 <printf>
    exit(1);
    2e64:	4505                	li	a0,1
    2e66:	1a0020ef          	jal	5006 <exit>
    printf("%s: unlink dd/ff failed\n", s);
    2e6a:	85ca                	mv	a1,s2
    2e6c:	00004517          	auipc	a0,0x4
    2e70:	ccc50513          	addi	a0,a0,-820 # 6b38 <malloc+0x162c>
    2e74:	5e0020ef          	jal	5454 <printf>
    exit(1);
    2e78:	4505                	li	a0,1
    2e7a:	18c020ef          	jal	5006 <exit>
    printf("%s: unlink non-empty dd succeeded!\n", s);
    2e7e:	85ca                	mv	a1,s2
    2e80:	00004517          	auipc	a0,0x4
    2e84:	cd850513          	addi	a0,a0,-808 # 6b58 <malloc+0x164c>
    2e88:	5cc020ef          	jal	5454 <printf>
    exit(1);
    2e8c:	4505                	li	a0,1
    2e8e:	178020ef          	jal	5006 <exit>
    printf("%s: unlink dd/dd failed\n", s);
    2e92:	85ca                	mv	a1,s2
    2e94:	00004517          	auipc	a0,0x4
    2e98:	cf450513          	addi	a0,a0,-780 # 6b88 <malloc+0x167c>
    2e9c:	5b8020ef          	jal	5454 <printf>
    exit(1);
    2ea0:	4505                	li	a0,1
    2ea2:	164020ef          	jal	5006 <exit>
    printf("%s: unlink dd failed\n", s);
    2ea6:	85ca                	mv	a1,s2
    2ea8:	00004517          	auipc	a0,0x4
    2eac:	d0050513          	addi	a0,a0,-768 # 6ba8 <malloc+0x169c>
    2eb0:	5a4020ef          	jal	5454 <printf>
    exit(1);
    2eb4:	4505                	li	a0,1
    2eb6:	150020ef          	jal	5006 <exit>

0000000000002eba <rmdot>:
{
    2eba:	1101                	addi	sp,sp,-32
    2ebc:	ec06                	sd	ra,24(sp)
    2ebe:	e822                	sd	s0,16(sp)
    2ec0:	e426                	sd	s1,8(sp)
    2ec2:	1000                	addi	s0,sp,32
    2ec4:	84aa                	mv	s1,a0
  if(mkdir("dots") != 0){
    2ec6:	00004517          	auipc	a0,0x4
    2eca:	cfa50513          	addi	a0,a0,-774 # 6bc0 <malloc+0x16b4>
    2ece:	1a0020ef          	jal	506e <mkdir>
    2ed2:	e53d                	bnez	a0,2f40 <rmdot+0x86>
  if(chdir("dots") != 0){
    2ed4:	00004517          	auipc	a0,0x4
    2ed8:	cec50513          	addi	a0,a0,-788 # 6bc0 <malloc+0x16b4>
    2edc:	19a020ef          	jal	5076 <chdir>
    2ee0:	e935                	bnez	a0,2f54 <rmdot+0x9a>
  if(unlink(".") == 0){
    2ee2:	00003517          	auipc	a0,0x3
    2ee6:	c5e50513          	addi	a0,a0,-930 # 5b40 <malloc+0x634>
    2eea:	16c020ef          	jal	5056 <unlink>
    2eee:	cd2d                	beqz	a0,2f68 <rmdot+0xae>
  if(unlink("..") == 0){
    2ef0:	00003517          	auipc	a0,0x3
    2ef4:	72050513          	addi	a0,a0,1824 # 6610 <malloc+0x1104>
    2ef8:	15e020ef          	jal	5056 <unlink>
    2efc:	c141                	beqz	a0,2f7c <rmdot+0xc2>
  if(chdir("/") != 0){
    2efe:	00003517          	auipc	a0,0x3
    2f02:	6ba50513          	addi	a0,a0,1722 # 65b8 <malloc+0x10ac>
    2f06:	170020ef          	jal	5076 <chdir>
    2f0a:	e159                	bnez	a0,2f90 <rmdot+0xd6>
  if(unlink("dots/.") == 0){
    2f0c:	00004517          	auipc	a0,0x4
    2f10:	d1c50513          	addi	a0,a0,-740 # 6c28 <malloc+0x171c>
    2f14:	142020ef          	jal	5056 <unlink>
    2f18:	c551                	beqz	a0,2fa4 <rmdot+0xea>
  if(unlink("dots/..") == 0){
    2f1a:	00004517          	auipc	a0,0x4
    2f1e:	d3650513          	addi	a0,a0,-714 # 6c50 <malloc+0x1744>
    2f22:	134020ef          	jal	5056 <unlink>
    2f26:	c949                	beqz	a0,2fb8 <rmdot+0xfe>
  if(unlink("dots") != 0){
    2f28:	00004517          	auipc	a0,0x4
    2f2c:	c9850513          	addi	a0,a0,-872 # 6bc0 <malloc+0x16b4>
    2f30:	126020ef          	jal	5056 <unlink>
    2f34:	ed41                	bnez	a0,2fcc <rmdot+0x112>
}
    2f36:	60e2                	ld	ra,24(sp)
    2f38:	6442                	ld	s0,16(sp)
    2f3a:	64a2                	ld	s1,8(sp)
    2f3c:	6105                	addi	sp,sp,32
    2f3e:	8082                	ret
    printf("%s: mkdir dots failed\n", s);
    2f40:	85a6                	mv	a1,s1
    2f42:	00004517          	auipc	a0,0x4
    2f46:	c8650513          	addi	a0,a0,-890 # 6bc8 <malloc+0x16bc>
    2f4a:	50a020ef          	jal	5454 <printf>
    exit(1);
    2f4e:	4505                	li	a0,1
    2f50:	0b6020ef          	jal	5006 <exit>
    printf("%s: chdir dots failed\n", s);
    2f54:	85a6                	mv	a1,s1
    2f56:	00004517          	auipc	a0,0x4
    2f5a:	c8a50513          	addi	a0,a0,-886 # 6be0 <malloc+0x16d4>
    2f5e:	4f6020ef          	jal	5454 <printf>
    exit(1);
    2f62:	4505                	li	a0,1
    2f64:	0a2020ef          	jal	5006 <exit>
    printf("%s: rm . worked!\n", s);
    2f68:	85a6                	mv	a1,s1
    2f6a:	00004517          	auipc	a0,0x4
    2f6e:	c8e50513          	addi	a0,a0,-882 # 6bf8 <malloc+0x16ec>
    2f72:	4e2020ef          	jal	5454 <printf>
    exit(1);
    2f76:	4505                	li	a0,1
    2f78:	08e020ef          	jal	5006 <exit>
    printf("%s: rm .. worked!\n", s);
    2f7c:	85a6                	mv	a1,s1
    2f7e:	00004517          	auipc	a0,0x4
    2f82:	c9250513          	addi	a0,a0,-878 # 6c10 <malloc+0x1704>
    2f86:	4ce020ef          	jal	5454 <printf>
    exit(1);
    2f8a:	4505                	li	a0,1
    2f8c:	07a020ef          	jal	5006 <exit>
    printf("%s: chdir / failed\n", s);
    2f90:	85a6                	mv	a1,s1
    2f92:	00003517          	auipc	a0,0x3
    2f96:	62e50513          	addi	a0,a0,1582 # 65c0 <malloc+0x10b4>
    2f9a:	4ba020ef          	jal	5454 <printf>
    exit(1);
    2f9e:	4505                	li	a0,1
    2fa0:	066020ef          	jal	5006 <exit>
    printf("%s: unlink dots/. worked!\n", s);
    2fa4:	85a6                	mv	a1,s1
    2fa6:	00004517          	auipc	a0,0x4
    2faa:	c8a50513          	addi	a0,a0,-886 # 6c30 <malloc+0x1724>
    2fae:	4a6020ef          	jal	5454 <printf>
    exit(1);
    2fb2:	4505                	li	a0,1
    2fb4:	052020ef          	jal	5006 <exit>
    printf("%s: unlink dots/.. worked!\n", s);
    2fb8:	85a6                	mv	a1,s1
    2fba:	00004517          	auipc	a0,0x4
    2fbe:	c9e50513          	addi	a0,a0,-866 # 6c58 <malloc+0x174c>
    2fc2:	492020ef          	jal	5454 <printf>
    exit(1);
    2fc6:	4505                	li	a0,1
    2fc8:	03e020ef          	jal	5006 <exit>
    printf("%s: unlink dots failed!\n", s);
    2fcc:	85a6                	mv	a1,s1
    2fce:	00004517          	auipc	a0,0x4
    2fd2:	caa50513          	addi	a0,a0,-854 # 6c78 <malloc+0x176c>
    2fd6:	47e020ef          	jal	5454 <printf>
    exit(1);
    2fda:	4505                	li	a0,1
    2fdc:	02a020ef          	jal	5006 <exit>

0000000000002fe0 <dirfile>:
{
    2fe0:	1101                	addi	sp,sp,-32
    2fe2:	ec06                	sd	ra,24(sp)
    2fe4:	e822                	sd	s0,16(sp)
    2fe6:	e426                	sd	s1,8(sp)
    2fe8:	e04a                	sd	s2,0(sp)
    2fea:	1000                	addi	s0,sp,32
    2fec:	892a                	mv	s2,a0
  fd = open("dirfile", O_CREATE);
    2fee:	20000593          	li	a1,512
    2ff2:	00004517          	auipc	a0,0x4
    2ff6:	ca650513          	addi	a0,a0,-858 # 6c98 <malloc+0x178c>
    2ffa:	04c020ef          	jal	5046 <open>
  if(fd < 0){
    2ffe:	0c054563          	bltz	a0,30c8 <dirfile+0xe8>
  close(fd);
    3002:	02c020ef          	jal	502e <close>
  if(chdir("dirfile") == 0){
    3006:	00004517          	auipc	a0,0x4
    300a:	c9250513          	addi	a0,a0,-878 # 6c98 <malloc+0x178c>
    300e:	068020ef          	jal	5076 <chdir>
    3012:	c569                	beqz	a0,30dc <dirfile+0xfc>
  fd = open("dirfile/xx", 0);
    3014:	4581                	li	a1,0
    3016:	00004517          	auipc	a0,0x4
    301a:	cca50513          	addi	a0,a0,-822 # 6ce0 <malloc+0x17d4>
    301e:	028020ef          	jal	5046 <open>
  if(fd >= 0){
    3022:	0c055763          	bgez	a0,30f0 <dirfile+0x110>
  fd = open("dirfile/xx", O_CREATE);
    3026:	20000593          	li	a1,512
    302a:	00004517          	auipc	a0,0x4
    302e:	cb650513          	addi	a0,a0,-842 # 6ce0 <malloc+0x17d4>
    3032:	014020ef          	jal	5046 <open>
  if(fd >= 0){
    3036:	0c055763          	bgez	a0,3104 <dirfile+0x124>
  if(mkdir("dirfile/xx") == 0){
    303a:	00004517          	auipc	a0,0x4
    303e:	ca650513          	addi	a0,a0,-858 # 6ce0 <malloc+0x17d4>
    3042:	02c020ef          	jal	506e <mkdir>
    3046:	0c050963          	beqz	a0,3118 <dirfile+0x138>
  if(unlink("dirfile/xx") == 0){
    304a:	00004517          	auipc	a0,0x4
    304e:	c9650513          	addi	a0,a0,-874 # 6ce0 <malloc+0x17d4>
    3052:	004020ef          	jal	5056 <unlink>
    3056:	0c050b63          	beqz	a0,312c <dirfile+0x14c>
  if(link("README", "dirfile/xx") == 0){
    305a:	00004597          	auipc	a1,0x4
    305e:	c8658593          	addi	a1,a1,-890 # 6ce0 <malloc+0x17d4>
    3062:	00002517          	auipc	a0,0x2
    3066:	7ae50513          	addi	a0,a0,1966 # 5810 <malloc+0x304>
    306a:	7fd010ef          	jal	5066 <link>
    306e:	0c050963          	beqz	a0,3140 <dirfile+0x160>
  if(unlink("dirfile") != 0){
    3072:	00004517          	auipc	a0,0x4
    3076:	c2650513          	addi	a0,a0,-986 # 6c98 <malloc+0x178c>
    307a:	7dd010ef          	jal	5056 <unlink>
    307e:	0c051b63          	bnez	a0,3154 <dirfile+0x174>
  fd = open(".", O_RDWR);
    3082:	4589                	li	a1,2
    3084:	00003517          	auipc	a0,0x3
    3088:	abc50513          	addi	a0,a0,-1348 # 5b40 <malloc+0x634>
    308c:	7bb010ef          	jal	5046 <open>
  if(fd >= 0){
    3090:	0c055c63          	bgez	a0,3168 <dirfile+0x188>
  fd = open(".", 0);
    3094:	4581                	li	a1,0
    3096:	00003517          	auipc	a0,0x3
    309a:	aaa50513          	addi	a0,a0,-1366 # 5b40 <malloc+0x634>
    309e:	7a9010ef          	jal	5046 <open>
    30a2:	84aa                	mv	s1,a0
  if(write(fd, "x", 1) > 0){
    30a4:	4605                	li	a2,1
    30a6:	00002597          	auipc	a1,0x2
    30aa:	60258593          	addi	a1,a1,1538 # 56a8 <malloc+0x19c>
    30ae:	779010ef          	jal	5026 <write>
    30b2:	0ca04563          	bgtz	a0,317c <dirfile+0x19c>
  close(fd);
    30b6:	8526                	mv	a0,s1
    30b8:	777010ef          	jal	502e <close>
}
    30bc:	60e2                	ld	ra,24(sp)
    30be:	6442                	ld	s0,16(sp)
    30c0:	64a2                	ld	s1,8(sp)
    30c2:	6902                	ld	s2,0(sp)
    30c4:	6105                	addi	sp,sp,32
    30c6:	8082                	ret
    printf("%s: create dirfile failed\n", s);
    30c8:	85ca                	mv	a1,s2
    30ca:	00004517          	auipc	a0,0x4
    30ce:	bd650513          	addi	a0,a0,-1066 # 6ca0 <malloc+0x1794>
    30d2:	382020ef          	jal	5454 <printf>
    exit(1);
    30d6:	4505                	li	a0,1
    30d8:	72f010ef          	jal	5006 <exit>
    printf("%s: chdir dirfile succeeded!\n", s);
    30dc:	85ca                	mv	a1,s2
    30de:	00004517          	auipc	a0,0x4
    30e2:	be250513          	addi	a0,a0,-1054 # 6cc0 <malloc+0x17b4>
    30e6:	36e020ef          	jal	5454 <printf>
    exit(1);
    30ea:	4505                	li	a0,1
    30ec:	71b010ef          	jal	5006 <exit>
    printf("%s: create dirfile/xx succeeded!\n", s);
    30f0:	85ca                	mv	a1,s2
    30f2:	00004517          	auipc	a0,0x4
    30f6:	bfe50513          	addi	a0,a0,-1026 # 6cf0 <malloc+0x17e4>
    30fa:	35a020ef          	jal	5454 <printf>
    exit(1);
    30fe:	4505                	li	a0,1
    3100:	707010ef          	jal	5006 <exit>
    printf("%s: create dirfile/xx succeeded!\n", s);
    3104:	85ca                	mv	a1,s2
    3106:	00004517          	auipc	a0,0x4
    310a:	bea50513          	addi	a0,a0,-1046 # 6cf0 <malloc+0x17e4>
    310e:	346020ef          	jal	5454 <printf>
    exit(1);
    3112:	4505                	li	a0,1
    3114:	6f3010ef          	jal	5006 <exit>
    printf("%s: mkdir dirfile/xx succeeded!\n", s);
    3118:	85ca                	mv	a1,s2
    311a:	00004517          	auipc	a0,0x4
    311e:	bfe50513          	addi	a0,a0,-1026 # 6d18 <malloc+0x180c>
    3122:	332020ef          	jal	5454 <printf>
    exit(1);
    3126:	4505                	li	a0,1
    3128:	6df010ef          	jal	5006 <exit>
    printf("%s: unlink dirfile/xx succeeded!\n", s);
    312c:	85ca                	mv	a1,s2
    312e:	00004517          	auipc	a0,0x4
    3132:	c1250513          	addi	a0,a0,-1006 # 6d40 <malloc+0x1834>
    3136:	31e020ef          	jal	5454 <printf>
    exit(1);
    313a:	4505                	li	a0,1
    313c:	6cb010ef          	jal	5006 <exit>
    printf("%s: link to dirfile/xx succeeded!\n", s);
    3140:	85ca                	mv	a1,s2
    3142:	00004517          	auipc	a0,0x4
    3146:	c2650513          	addi	a0,a0,-986 # 6d68 <malloc+0x185c>
    314a:	30a020ef          	jal	5454 <printf>
    exit(1);
    314e:	4505                	li	a0,1
    3150:	6b7010ef          	jal	5006 <exit>
    printf("%s: unlink dirfile failed!\n", s);
    3154:	85ca                	mv	a1,s2
    3156:	00004517          	auipc	a0,0x4
    315a:	c3a50513          	addi	a0,a0,-966 # 6d90 <malloc+0x1884>
    315e:	2f6020ef          	jal	5454 <printf>
    exit(1);
    3162:	4505                	li	a0,1
    3164:	6a3010ef          	jal	5006 <exit>
    printf("%s: open . for writing succeeded!\n", s);
    3168:	85ca                	mv	a1,s2
    316a:	00004517          	auipc	a0,0x4
    316e:	c4650513          	addi	a0,a0,-954 # 6db0 <malloc+0x18a4>
    3172:	2e2020ef          	jal	5454 <printf>
    exit(1);
    3176:	4505                	li	a0,1
    3178:	68f010ef          	jal	5006 <exit>
    printf("%s: write . succeeded!\n", s);
    317c:	85ca                	mv	a1,s2
    317e:	00004517          	auipc	a0,0x4
    3182:	c5a50513          	addi	a0,a0,-934 # 6dd8 <malloc+0x18cc>
    3186:	2ce020ef          	jal	5454 <printf>
    exit(1);
    318a:	4505                	li	a0,1
    318c:	67b010ef          	jal	5006 <exit>

0000000000003190 <iref>:
{
    3190:	715d                	addi	sp,sp,-80
    3192:	e486                	sd	ra,72(sp)
    3194:	e0a2                	sd	s0,64(sp)
    3196:	fc26                	sd	s1,56(sp)
    3198:	f84a                	sd	s2,48(sp)
    319a:	f44e                	sd	s3,40(sp)
    319c:	f052                	sd	s4,32(sp)
    319e:	ec56                	sd	s5,24(sp)
    31a0:	e85a                	sd	s6,16(sp)
    31a2:	e45e                	sd	s7,8(sp)
    31a4:	0880                	addi	s0,sp,80
    31a6:	8baa                	mv	s7,a0
    31a8:	03300913          	li	s2,51
    if(mkdir("irefd") != 0){
    31ac:	00004a97          	auipc	s5,0x4
    31b0:	c44a8a93          	addi	s5,s5,-956 # 6df0 <malloc+0x18e4>
    mkdir("");
    31b4:	00003497          	auipc	s1,0x3
    31b8:	74448493          	addi	s1,s1,1860 # 68f8 <malloc+0x13ec>
    link("README", "");
    31bc:	00002b17          	auipc	s6,0x2
    31c0:	654b0b13          	addi	s6,s6,1620 # 5810 <malloc+0x304>
    fd = open("", O_CREATE);
    31c4:	20000a13          	li	s4,512
    fd = open("xx", O_CREATE);
    31c8:	00004997          	auipc	s3,0x4
    31cc:	b2098993          	addi	s3,s3,-1248 # 6ce8 <malloc+0x17dc>
    31d0:	a835                	j	320c <iref+0x7c>
      printf("%s: mkdir irefd failed\n", s);
    31d2:	85de                	mv	a1,s7
    31d4:	00004517          	auipc	a0,0x4
    31d8:	c2450513          	addi	a0,a0,-988 # 6df8 <malloc+0x18ec>
    31dc:	278020ef          	jal	5454 <printf>
      exit(1);
    31e0:	4505                	li	a0,1
    31e2:	625010ef          	jal	5006 <exit>
      printf("%s: chdir irefd failed\n", s);
    31e6:	85de                	mv	a1,s7
    31e8:	00004517          	auipc	a0,0x4
    31ec:	c2850513          	addi	a0,a0,-984 # 6e10 <malloc+0x1904>
    31f0:	264020ef          	jal	5454 <printf>
      exit(1);
    31f4:	4505                	li	a0,1
    31f6:	611010ef          	jal	5006 <exit>
      close(fd);
    31fa:	635010ef          	jal	502e <close>
    31fe:	a825                	j	3236 <iref+0xa6>
    unlink("xx");
    3200:	854e                	mv	a0,s3
    3202:	655010ef          	jal	5056 <unlink>
  for(i = 0; i < NINODE + 1; i++){
    3206:	397d                	addiw	s2,s2,-1
    3208:	04090063          	beqz	s2,3248 <iref+0xb8>
    if(mkdir("irefd") != 0){
    320c:	8556                	mv	a0,s5
    320e:	661010ef          	jal	506e <mkdir>
    3212:	f161                	bnez	a0,31d2 <iref+0x42>
    if(chdir("irefd") != 0){
    3214:	8556                	mv	a0,s5
    3216:	661010ef          	jal	5076 <chdir>
    321a:	f571                	bnez	a0,31e6 <iref+0x56>
    mkdir("");
    321c:	8526                	mv	a0,s1
    321e:	651010ef          	jal	506e <mkdir>
    link("README", "");
    3222:	85a6                	mv	a1,s1
    3224:	855a                	mv	a0,s6
    3226:	641010ef          	jal	5066 <link>
    fd = open("", O_CREATE);
    322a:	85d2                	mv	a1,s4
    322c:	8526                	mv	a0,s1
    322e:	619010ef          	jal	5046 <open>
    if(fd >= 0)
    3232:	fc0554e3          	bgez	a0,31fa <iref+0x6a>
    fd = open("xx", O_CREATE);
    3236:	85d2                	mv	a1,s4
    3238:	854e                	mv	a0,s3
    323a:	60d010ef          	jal	5046 <open>
    if(fd >= 0)
    323e:	fc0541e3          	bltz	a0,3200 <iref+0x70>
      close(fd);
    3242:	5ed010ef          	jal	502e <close>
    3246:	bf6d                	j	3200 <iref+0x70>
    3248:	03300493          	li	s1,51
    chdir("..");
    324c:	00003997          	auipc	s3,0x3
    3250:	3c498993          	addi	s3,s3,964 # 6610 <malloc+0x1104>
    unlink("irefd");
    3254:	00004917          	auipc	s2,0x4
    3258:	b9c90913          	addi	s2,s2,-1124 # 6df0 <malloc+0x18e4>
    chdir("..");
    325c:	854e                	mv	a0,s3
    325e:	619010ef          	jal	5076 <chdir>
    unlink("irefd");
    3262:	854a                	mv	a0,s2
    3264:	5f3010ef          	jal	5056 <unlink>
  for(i = 0; i < NINODE + 1; i++){
    3268:	34fd                	addiw	s1,s1,-1
    326a:	f8ed                	bnez	s1,325c <iref+0xcc>
  chdir("/");
    326c:	00003517          	auipc	a0,0x3
    3270:	34c50513          	addi	a0,a0,844 # 65b8 <malloc+0x10ac>
    3274:	603010ef          	jal	5076 <chdir>
}
    3278:	60a6                	ld	ra,72(sp)
    327a:	6406                	ld	s0,64(sp)
    327c:	74e2                	ld	s1,56(sp)
    327e:	7942                	ld	s2,48(sp)
    3280:	79a2                	ld	s3,40(sp)
    3282:	7a02                	ld	s4,32(sp)
    3284:	6ae2                	ld	s5,24(sp)
    3286:	6b42                	ld	s6,16(sp)
    3288:	6ba2                	ld	s7,8(sp)
    328a:	6161                	addi	sp,sp,80
    328c:	8082                	ret

000000000000328e <openiputtest>:
{
    328e:	7179                	addi	sp,sp,-48
    3290:	f406                	sd	ra,40(sp)
    3292:	f022                	sd	s0,32(sp)
    3294:	ec26                	sd	s1,24(sp)
    3296:	1800                	addi	s0,sp,48
    3298:	84aa                	mv	s1,a0
  if(mkdir("oidir") < 0){
    329a:	00004517          	auipc	a0,0x4
    329e:	b8e50513          	addi	a0,a0,-1138 # 6e28 <malloc+0x191c>
    32a2:	5cd010ef          	jal	506e <mkdir>
    32a6:	02054a63          	bltz	a0,32da <openiputtest+0x4c>
  pid = fork();
    32aa:	555010ef          	jal	4ffe <fork>
  if(pid < 0){
    32ae:	04054063          	bltz	a0,32ee <openiputtest+0x60>
  if(pid == 0){
    32b2:	e939                	bnez	a0,3308 <openiputtest+0x7a>
    int fd = open("oidir", O_RDWR);
    32b4:	4589                	li	a1,2
    32b6:	00004517          	auipc	a0,0x4
    32ba:	b7250513          	addi	a0,a0,-1166 # 6e28 <malloc+0x191c>
    32be:	589010ef          	jal	5046 <open>
    if(fd >= 0){
    32c2:	04054063          	bltz	a0,3302 <openiputtest+0x74>
      printf("%s: open directory for write succeeded\n", s);
    32c6:	85a6                	mv	a1,s1
    32c8:	00004517          	auipc	a0,0x4
    32cc:	b8050513          	addi	a0,a0,-1152 # 6e48 <malloc+0x193c>
    32d0:	184020ef          	jal	5454 <printf>
      exit(1);
    32d4:	4505                	li	a0,1
    32d6:	531010ef          	jal	5006 <exit>
    printf("%s: mkdir oidir failed\n", s);
    32da:	85a6                	mv	a1,s1
    32dc:	00004517          	auipc	a0,0x4
    32e0:	b5450513          	addi	a0,a0,-1196 # 6e30 <malloc+0x1924>
    32e4:	170020ef          	jal	5454 <printf>
    exit(1);
    32e8:	4505                	li	a0,1
    32ea:	51d010ef          	jal	5006 <exit>
    printf("%s: fork failed\n", s);
    32ee:	85a6                	mv	a1,s1
    32f0:	00003517          	auipc	a0,0x3
    32f4:	9f850513          	addi	a0,a0,-1544 # 5ce8 <malloc+0x7dc>
    32f8:	15c020ef          	jal	5454 <printf>
    exit(1);
    32fc:	4505                	li	a0,1
    32fe:	509010ef          	jal	5006 <exit>
    exit(0);
    3302:	4501                	li	a0,0
    3304:	503010ef          	jal	5006 <exit>
  pause(1);
    3308:	4505                	li	a0,1
    330a:	58d010ef          	jal	5096 <pause>
  if(unlink("oidir") != 0){
    330e:	00004517          	auipc	a0,0x4
    3312:	b1a50513          	addi	a0,a0,-1254 # 6e28 <malloc+0x191c>
    3316:	541010ef          	jal	5056 <unlink>
    331a:	c919                	beqz	a0,3330 <openiputtest+0xa2>
    printf("%s: unlink failed\n", s);
    331c:	85a6                	mv	a1,s1
    331e:	00003517          	auipc	a0,0x3
    3322:	b5250513          	addi	a0,a0,-1198 # 5e70 <malloc+0x964>
    3326:	12e020ef          	jal	5454 <printf>
    exit(1);
    332a:	4505                	li	a0,1
    332c:	4db010ef          	jal	5006 <exit>
  wait(&xstatus);
    3330:	fdc40513          	addi	a0,s0,-36
    3334:	4db010ef          	jal	500e <wait>
  exit(xstatus);
    3338:	fdc42503          	lw	a0,-36(s0)
    333c:	4cb010ef          	jal	5006 <exit>

0000000000003340 <forkforkfork>:
{
    3340:	1101                	addi	sp,sp,-32
    3342:	ec06                	sd	ra,24(sp)
    3344:	e822                	sd	s0,16(sp)
    3346:	e426                	sd	s1,8(sp)
    3348:	1000                	addi	s0,sp,32
    334a:	84aa                	mv	s1,a0
  unlink("stopforking");
    334c:	00004517          	auipc	a0,0x4
    3350:	b2450513          	addi	a0,a0,-1244 # 6e70 <malloc+0x1964>
    3354:	503010ef          	jal	5056 <unlink>
  int pid = fork();
    3358:	4a7010ef          	jal	4ffe <fork>
  if(pid < 0){
    335c:	02054b63          	bltz	a0,3392 <forkforkfork+0x52>
  if(pid == 0){
    3360:	c139                	beqz	a0,33a6 <forkforkfork+0x66>
  pause(20); // two seconds
    3362:	4551                	li	a0,20
    3364:	533010ef          	jal	5096 <pause>
  close(open("stopforking", O_CREATE|O_RDWR));
    3368:	20200593          	li	a1,514
    336c:	00004517          	auipc	a0,0x4
    3370:	b0450513          	addi	a0,a0,-1276 # 6e70 <malloc+0x1964>
    3374:	4d3010ef          	jal	5046 <open>
    3378:	4b7010ef          	jal	502e <close>
  wait(0);
    337c:	4501                	li	a0,0
    337e:	491010ef          	jal	500e <wait>
  pause(10); // one second
    3382:	4529                	li	a0,10
    3384:	513010ef          	jal	5096 <pause>
}
    3388:	60e2                	ld	ra,24(sp)
    338a:	6442                	ld	s0,16(sp)
    338c:	64a2                	ld	s1,8(sp)
    338e:	6105                	addi	sp,sp,32
    3390:	8082                	ret
    printf("%s: fork failed", s);
    3392:	85a6                	mv	a1,s1
    3394:	00003517          	auipc	a0,0x3
    3398:	aac50513          	addi	a0,a0,-1364 # 5e40 <malloc+0x934>
    339c:	0b8020ef          	jal	5454 <printf>
    exit(1);
    33a0:	4505                	li	a0,1
    33a2:	465010ef          	jal	5006 <exit>
      int fd = open("stopforking", 0);
    33a6:	4581                	li	a1,0
    33a8:	00004517          	auipc	a0,0x4
    33ac:	ac850513          	addi	a0,a0,-1336 # 6e70 <malloc+0x1964>
    33b0:	497010ef          	jal	5046 <open>
      if(fd >= 0){
    33b4:	02055163          	bgez	a0,33d6 <forkforkfork+0x96>
      if(fork() < 0){
    33b8:	447010ef          	jal	4ffe <fork>
    33bc:	fe0555e3          	bgez	a0,33a6 <forkforkfork+0x66>
        close(open("stopforking", O_CREATE|O_RDWR));
    33c0:	20200593          	li	a1,514
    33c4:	00004517          	auipc	a0,0x4
    33c8:	aac50513          	addi	a0,a0,-1364 # 6e70 <malloc+0x1964>
    33cc:	47b010ef          	jal	5046 <open>
    33d0:	45f010ef          	jal	502e <close>
    33d4:	bfc9                	j	33a6 <forkforkfork+0x66>
        exit(0);
    33d6:	4501                	li	a0,0
    33d8:	42f010ef          	jal	5006 <exit>

00000000000033dc <killstatus>:
{
    33dc:	715d                	addi	sp,sp,-80
    33de:	e486                	sd	ra,72(sp)
    33e0:	e0a2                	sd	s0,64(sp)
    33e2:	fc26                	sd	s1,56(sp)
    33e4:	f84a                	sd	s2,48(sp)
    33e6:	f44e                	sd	s3,40(sp)
    33e8:	f052                	sd	s4,32(sp)
    33ea:	ec56                	sd	s5,24(sp)
    33ec:	e85a                	sd	s6,16(sp)
    33ee:	0880                	addi	s0,sp,80
    33f0:	8b2a                	mv	s6,a0
    33f2:	06400913          	li	s2,100
    pause(1);
    33f6:	4a85                	li	s5,1
    wait(&xst);
    33f8:	fbc40a13          	addi	s4,s0,-68
    if(xst != -1) {
    33fc:	59fd                	li	s3,-1
    int pid1 = fork();
    33fe:	401010ef          	jal	4ffe <fork>
    3402:	84aa                	mv	s1,a0
    if(pid1 < 0){
    3404:	02054663          	bltz	a0,3430 <killstatus+0x54>
    if(pid1 == 0){
    3408:	cd15                	beqz	a0,3444 <killstatus+0x68>
    pause(1);
    340a:	8556                	mv	a0,s5
    340c:	48b010ef          	jal	5096 <pause>
    kill(pid1);
    3410:	8526                	mv	a0,s1
    3412:	425010ef          	jal	5036 <kill>
    wait(&xst);
    3416:	8552                	mv	a0,s4
    3418:	3f7010ef          	jal	500e <wait>
    if(xst != -1) {
    341c:	fbc42783          	lw	a5,-68(s0)
    3420:	03379563          	bne	a5,s3,344a <killstatus+0x6e>
  for(int i = 0; i < 100; i++){
    3424:	397d                	addiw	s2,s2,-1
    3426:	fc091ce3          	bnez	s2,33fe <killstatus+0x22>
  exit(0);
    342a:	4501                	li	a0,0
    342c:	3db010ef          	jal	5006 <exit>
      printf("%s: fork failed\n", s);
    3430:	85da                	mv	a1,s6
    3432:	00003517          	auipc	a0,0x3
    3436:	8b650513          	addi	a0,a0,-1866 # 5ce8 <malloc+0x7dc>
    343a:	01a020ef          	jal	5454 <printf>
      exit(1);
    343e:	4505                	li	a0,1
    3440:	3c7010ef          	jal	5006 <exit>
        getpid();
    3444:	443010ef          	jal	5086 <getpid>
      while(1) {
    3448:	bff5                	j	3444 <killstatus+0x68>
       printf("%s: status should be -1\n", s);
    344a:	85da                	mv	a1,s6
    344c:	00004517          	auipc	a0,0x4
    3450:	a3450513          	addi	a0,a0,-1484 # 6e80 <malloc+0x1974>
    3454:	000020ef          	jal	5454 <printf>
       exit(1);
    3458:	4505                	li	a0,1
    345a:	3ad010ef          	jal	5006 <exit>

000000000000345e <preempt>:
{
    345e:	7139                	addi	sp,sp,-64
    3460:	fc06                	sd	ra,56(sp)
    3462:	f822                	sd	s0,48(sp)
    3464:	f426                	sd	s1,40(sp)
    3466:	f04a                	sd	s2,32(sp)
    3468:	ec4e                	sd	s3,24(sp)
    346a:	e852                	sd	s4,16(sp)
    346c:	0080                	addi	s0,sp,64
    346e:	892a                	mv	s2,a0
  pid1 = fork();
    3470:	38f010ef          	jal	4ffe <fork>
  if(pid1 < 0) {
    3474:	00054563          	bltz	a0,347e <preempt+0x20>
    3478:	84aa                	mv	s1,a0
  if(pid1 == 0)
    347a:	ed01                	bnez	a0,3492 <preempt+0x34>
    for(;;)
    347c:	a001                	j	347c <preempt+0x1e>
    printf("%s: fork failed", s);
    347e:	85ca                	mv	a1,s2
    3480:	00003517          	auipc	a0,0x3
    3484:	9c050513          	addi	a0,a0,-1600 # 5e40 <malloc+0x934>
    3488:	7cd010ef          	jal	5454 <printf>
    exit(1);
    348c:	4505                	li	a0,1
    348e:	379010ef          	jal	5006 <exit>
  pid2 = fork();
    3492:	36d010ef          	jal	4ffe <fork>
    3496:	89aa                	mv	s3,a0
  if(pid2 < 0) {
    3498:	00054463          	bltz	a0,34a0 <preempt+0x42>
  if(pid2 == 0)
    349c:	ed01                	bnez	a0,34b4 <preempt+0x56>
    for(;;)
    349e:	a001                	j	349e <preempt+0x40>
    printf("%s: fork failed\n", s);
    34a0:	85ca                	mv	a1,s2
    34a2:	00003517          	auipc	a0,0x3
    34a6:	84650513          	addi	a0,a0,-1978 # 5ce8 <malloc+0x7dc>
    34aa:	7ab010ef          	jal	5454 <printf>
    exit(1);
    34ae:	4505                	li	a0,1
    34b0:	357010ef          	jal	5006 <exit>
  pipe(pfds);
    34b4:	fc840513          	addi	a0,s0,-56
    34b8:	35f010ef          	jal	5016 <pipe>
  pid3 = fork();
    34bc:	343010ef          	jal	4ffe <fork>
    34c0:	8a2a                	mv	s4,a0
  if(pid3 < 0) {
    34c2:	02054863          	bltz	a0,34f2 <preempt+0x94>
  if(pid3 == 0){
    34c6:	e921                	bnez	a0,3516 <preempt+0xb8>
    close(pfds[0]);
    34c8:	fc842503          	lw	a0,-56(s0)
    34cc:	363010ef          	jal	502e <close>
    if(write(pfds[1], "x", 1) != 1)
    34d0:	4605                	li	a2,1
    34d2:	00002597          	auipc	a1,0x2
    34d6:	1d658593          	addi	a1,a1,470 # 56a8 <malloc+0x19c>
    34da:	fcc42503          	lw	a0,-52(s0)
    34de:	349010ef          	jal	5026 <write>
    34e2:	4785                	li	a5,1
    34e4:	02f51163          	bne	a0,a5,3506 <preempt+0xa8>
    close(pfds[1]);
    34e8:	fcc42503          	lw	a0,-52(s0)
    34ec:	343010ef          	jal	502e <close>
    for(;;)
    34f0:	a001                	j	34f0 <preempt+0x92>
     printf("%s: fork failed\n", s);
    34f2:	85ca                	mv	a1,s2
    34f4:	00002517          	auipc	a0,0x2
    34f8:	7f450513          	addi	a0,a0,2036 # 5ce8 <malloc+0x7dc>
    34fc:	759010ef          	jal	5454 <printf>
     exit(1);
    3500:	4505                	li	a0,1
    3502:	305010ef          	jal	5006 <exit>
      printf("%s: preempt write error", s);
    3506:	85ca                	mv	a1,s2
    3508:	00004517          	auipc	a0,0x4
    350c:	99850513          	addi	a0,a0,-1640 # 6ea0 <malloc+0x1994>
    3510:	745010ef          	jal	5454 <printf>
    3514:	bfd1                	j	34e8 <preempt+0x8a>
  close(pfds[1]);
    3516:	fcc42503          	lw	a0,-52(s0)
    351a:	315010ef          	jal	502e <close>
  if(read(pfds[0], buf, sizeof(buf)) != 1){
    351e:	660d                	lui	a2,0x3
    3520:	0000a597          	auipc	a1,0xa
    3524:	76858593          	addi	a1,a1,1896 # dc88 <buf>
    3528:	fc842503          	lw	a0,-56(s0)
    352c:	2f3010ef          	jal	501e <read>
    3530:	4785                	li	a5,1
    3532:	02f50163          	beq	a0,a5,3554 <preempt+0xf6>
    printf("%s: preempt read error", s);
    3536:	85ca                	mv	a1,s2
    3538:	00004517          	auipc	a0,0x4
    353c:	98050513          	addi	a0,a0,-1664 # 6eb8 <malloc+0x19ac>
    3540:	715010ef          	jal	5454 <printf>
}
    3544:	70e2                	ld	ra,56(sp)
    3546:	7442                	ld	s0,48(sp)
    3548:	74a2                	ld	s1,40(sp)
    354a:	7902                	ld	s2,32(sp)
    354c:	69e2                	ld	s3,24(sp)
    354e:	6a42                	ld	s4,16(sp)
    3550:	6121                	addi	sp,sp,64
    3552:	8082                	ret
  close(pfds[0]);
    3554:	fc842503          	lw	a0,-56(s0)
    3558:	2d7010ef          	jal	502e <close>
  printf("kill... ");
    355c:	00004517          	auipc	a0,0x4
    3560:	97450513          	addi	a0,a0,-1676 # 6ed0 <malloc+0x19c4>
    3564:	6f1010ef          	jal	5454 <printf>
  kill(pid1);
    3568:	8526                	mv	a0,s1
    356a:	2cd010ef          	jal	5036 <kill>
  kill(pid2);
    356e:	854e                	mv	a0,s3
    3570:	2c7010ef          	jal	5036 <kill>
  kill(pid3);
    3574:	8552                	mv	a0,s4
    3576:	2c1010ef          	jal	5036 <kill>
  printf("wait... ");
    357a:	00004517          	auipc	a0,0x4
    357e:	96650513          	addi	a0,a0,-1690 # 6ee0 <malloc+0x19d4>
    3582:	6d3010ef          	jal	5454 <printf>
  wait(0);
    3586:	4501                	li	a0,0
    3588:	287010ef          	jal	500e <wait>
  wait(0);
    358c:	4501                	li	a0,0
    358e:	281010ef          	jal	500e <wait>
  wait(0);
    3592:	4501                	li	a0,0
    3594:	27b010ef          	jal	500e <wait>
    3598:	b775                	j	3544 <preempt+0xe6>

000000000000359a <reparent>:
{
    359a:	7179                	addi	sp,sp,-48
    359c:	f406                	sd	ra,40(sp)
    359e:	f022                	sd	s0,32(sp)
    35a0:	ec26                	sd	s1,24(sp)
    35a2:	e84a                	sd	s2,16(sp)
    35a4:	e44e                	sd	s3,8(sp)
    35a6:	e052                	sd	s4,0(sp)
    35a8:	1800                	addi	s0,sp,48
    35aa:	89aa                	mv	s3,a0
  int master_pid = getpid();
    35ac:	2db010ef          	jal	5086 <getpid>
    35b0:	8a2a                	mv	s4,a0
    35b2:	0c800913          	li	s2,200
    int pid = fork();
    35b6:	249010ef          	jal	4ffe <fork>
    35ba:	84aa                	mv	s1,a0
    if(pid < 0){
    35bc:	00054e63          	bltz	a0,35d8 <reparent+0x3e>
    if(pid){
    35c0:	c121                	beqz	a0,3600 <reparent+0x66>
      if(wait(0) != pid){
    35c2:	4501                	li	a0,0
    35c4:	24b010ef          	jal	500e <wait>
    35c8:	02951263          	bne	a0,s1,35ec <reparent+0x52>
  for(int i = 0; i < 200; i++){
    35cc:	397d                	addiw	s2,s2,-1
    35ce:	fe0914e3          	bnez	s2,35b6 <reparent+0x1c>
  exit(0);
    35d2:	4501                	li	a0,0
    35d4:	233010ef          	jal	5006 <exit>
      printf("%s: fork failed\n", s);
    35d8:	85ce                	mv	a1,s3
    35da:	00002517          	auipc	a0,0x2
    35de:	70e50513          	addi	a0,a0,1806 # 5ce8 <malloc+0x7dc>
    35e2:	673010ef          	jal	5454 <printf>
      exit(1);
    35e6:	4505                	li	a0,1
    35e8:	21f010ef          	jal	5006 <exit>
        printf("%s: wait wrong pid\n", s);
    35ec:	85ce                	mv	a1,s3
    35ee:	00003517          	auipc	a0,0x3
    35f2:	81a50513          	addi	a0,a0,-2022 # 5e08 <malloc+0x8fc>
    35f6:	65f010ef          	jal	5454 <printf>
        exit(1);
    35fa:	4505                	li	a0,1
    35fc:	20b010ef          	jal	5006 <exit>
      int pid2 = fork();
    3600:	1ff010ef          	jal	4ffe <fork>
      if(pid2 < 0){
    3604:	00054563          	bltz	a0,360e <reparent+0x74>
      exit(0);
    3608:	4501                	li	a0,0
    360a:	1fd010ef          	jal	5006 <exit>
        kill(master_pid);
    360e:	8552                	mv	a0,s4
    3610:	227010ef          	jal	5036 <kill>
        exit(1);
    3614:	4505                	li	a0,1
    3616:	1f1010ef          	jal	5006 <exit>

000000000000361a <sbrkfail>:
{
    361a:	7175                	addi	sp,sp,-144
    361c:	e506                	sd	ra,136(sp)
    361e:	e122                	sd	s0,128(sp)
    3620:	fca6                	sd	s1,120(sp)
    3622:	f8ca                	sd	s2,112(sp)
    3624:	f4ce                	sd	s3,104(sp)
    3626:	f0d2                	sd	s4,96(sp)
    3628:	ecd6                	sd	s5,88(sp)
    362a:	e8da                	sd	s6,80(sp)
    362c:	e4de                	sd	s7,72(sp)
    362e:	e0e2                	sd	s8,64(sp)
    3630:	0900                	addi	s0,sp,144
    3632:	8c2a                	mv	s8,a0
  if(pipe(fds) != 0){
    3634:	fa040513          	addi	a0,s0,-96
    3638:	1df010ef          	jal	5016 <pipe>
    363c:	ed01                	bnez	a0,3654 <sbrkfail+0x3a>
    363e:	8baa                	mv	s7,a0
    3640:	f7040493          	addi	s1,s0,-144
    3644:	f9840993          	addi	s3,s0,-104
    3648:	8926                	mv	s2,s1
    if(pids[i] != -1) {
    364a:	5a7d                	li	s4,-1
      read(fds[0], &scratch, 1);
    364c:	f9f40b13          	addi	s6,s0,-97
    3650:	4a85                	li	s5,1
    3652:	a095                	j	36b6 <sbrkfail+0x9c>
    printf("%s: pipe() failed\n", s);
    3654:	85e2                	mv	a1,s8
    3656:	00003517          	auipc	a0,0x3
    365a:	c5a50513          	addi	a0,a0,-934 # 62b0 <malloc+0xda4>
    365e:	5f7010ef          	jal	5454 <printf>
    exit(1);
    3662:	4505                	li	a0,1
    3664:	1a3010ef          	jal	5006 <exit>
      if (sbrk(BIG - (uint64)sbrk(0)) ==  (char*)SBRK_ERROR)
    3668:	16b010ef          	jal	4fd2 <sbrk>
    366c:	064007b7          	lui	a5,0x6400
    3670:	40a7853b          	subw	a0,a5,a0
    3674:	15f010ef          	jal	4fd2 <sbrk>
    3678:	57fd                	li	a5,-1
    367a:	02f50163          	beq	a0,a5,369c <sbrkfail+0x82>
        write(fds[1], "1", 1);
    367e:	4605                	li	a2,1
    3680:	00004597          	auipc	a1,0x4
    3684:	21858593          	addi	a1,a1,536 # 7898 <malloc+0x238c>
    3688:	fa442503          	lw	a0,-92(s0)
    368c:	19b010ef          	jal	5026 <write>
      for(;;) pause(1000);
    3690:	3e800493          	li	s1,1000
    3694:	8526                	mv	a0,s1
    3696:	201010ef          	jal	5096 <pause>
    369a:	bfed                	j	3694 <sbrkfail+0x7a>
        write(fds[1], "0", 1);
    369c:	4605                	li	a2,1
    369e:	00004597          	auipc	a1,0x4
    36a2:	85258593          	addi	a1,a1,-1966 # 6ef0 <malloc+0x19e4>
    36a6:	fa442503          	lw	a0,-92(s0)
    36aa:	17d010ef          	jal	5026 <write>
    36ae:	b7cd                	j	3690 <sbrkfail+0x76>
  for(i = 0; i < sizeof(pids)/sizeof(pids[0]); i++){
    36b0:	0911                	addi	s2,s2,4
    36b2:	03390a63          	beq	s2,s3,36e6 <sbrkfail+0xcc>
    if((pids[i] = fork()) == 0){
    36b6:	149010ef          	jal	4ffe <fork>
    36ba:	00a92023          	sw	a0,0(s2)
    36be:	d54d                	beqz	a0,3668 <sbrkfail+0x4e>
    if(pids[i] != -1) {
    36c0:	ff4508e3          	beq	a0,s4,36b0 <sbrkfail+0x96>
      read(fds[0], &scratch, 1);
    36c4:	8656                	mv	a2,s5
    36c6:	85da                	mv	a1,s6
    36c8:	fa042503          	lw	a0,-96(s0)
    36cc:	153010ef          	jal	501e <read>
      if(scratch == '0')
    36d0:	f9f44783          	lbu	a5,-97(s0)
    36d4:	fd078793          	addi	a5,a5,-48 # 63fffd0 <base+0x63ef348>
    36d8:	0017b793          	seqz	a5,a5
    36dc:	00fbe7b3          	or	a5,s7,a5
    36e0:	00078b9b          	sext.w	s7,a5
    36e4:	b7f1                	j	36b0 <sbrkfail+0x96>
  if(!failed) {
    36e6:	000b8863          	beqz	s7,36f6 <sbrkfail+0xdc>
  c = sbrk(PGSIZE);
    36ea:	6505                	lui	a0,0x1
    36ec:	0e7010ef          	jal	4fd2 <sbrk>
    36f0:	8a2a                	mv	s4,a0
    if(pids[i] == -1)
    36f2:	597d                	li	s2,-1
    36f4:	a821                	j	370c <sbrkfail+0xf2>
    printf("%s: no allocation failed; allocate more?\n", s);
    36f6:	85e2                	mv	a1,s8
    36f8:	00004517          	auipc	a0,0x4
    36fc:	80050513          	addi	a0,a0,-2048 # 6ef8 <malloc+0x19ec>
    3700:	555010ef          	jal	5454 <printf>
    3704:	b7dd                	j	36ea <sbrkfail+0xd0>
  for(i = 0; i < sizeof(pids)/sizeof(pids[0]); i++){
    3706:	0491                	addi	s1,s1,4
    3708:	01348b63          	beq	s1,s3,371e <sbrkfail+0x104>
    if(pids[i] == -1)
    370c:	4088                	lw	a0,0(s1)
    370e:	ff250ce3          	beq	a0,s2,3706 <sbrkfail+0xec>
    kill(pids[i]);
    3712:	125010ef          	jal	5036 <kill>
    wait(0);
    3716:	4501                	li	a0,0
    3718:	0f7010ef          	jal	500e <wait>
    371c:	b7ed                	j	3706 <sbrkfail+0xec>
  if(c == (char*)SBRK_ERROR){
    371e:	57fd                	li	a5,-1
    3720:	02fa0a63          	beq	s4,a5,3754 <sbrkfail+0x13a>
  pid = fork();
    3724:	0db010ef          	jal	4ffe <fork>
  if(pid < 0){
    3728:	04054063          	bltz	a0,3768 <sbrkfail+0x14e>
  if(pid == 0){
    372c:	e939                	bnez	a0,3782 <sbrkfail+0x168>
    a = sbrk(10*BIG);
    372e:	3e800537          	lui	a0,0x3e800
    3732:	0a1010ef          	jal	4fd2 <sbrk>
    if(a == (char*)SBRK_ERROR){
    3736:	57fd                	li	a5,-1
    3738:	04f50263          	beq	a0,a5,377c <sbrkfail+0x162>
    printf("%s: allocate a lot of memory succeeded %d\n", s, 10*BIG);
    373c:	3e800637          	lui	a2,0x3e800
    3740:	85e2                	mv	a1,s8
    3742:	00004517          	auipc	a0,0x4
    3746:	80650513          	addi	a0,a0,-2042 # 6f48 <malloc+0x1a3c>
    374a:	50b010ef          	jal	5454 <printf>
    exit(1);
    374e:	4505                	li	a0,1
    3750:	0b7010ef          	jal	5006 <exit>
    printf("%s: failed sbrk leaked memory\n", s);
    3754:	85e2                	mv	a1,s8
    3756:	00003517          	auipc	a0,0x3
    375a:	7d250513          	addi	a0,a0,2002 # 6f28 <malloc+0x1a1c>
    375e:	4f7010ef          	jal	5454 <printf>
    exit(1);
    3762:	4505                	li	a0,1
    3764:	0a3010ef          	jal	5006 <exit>
    printf("%s: fork failed\n", s);
    3768:	85e2                	mv	a1,s8
    376a:	00002517          	auipc	a0,0x2
    376e:	57e50513          	addi	a0,a0,1406 # 5ce8 <malloc+0x7dc>
    3772:	4e3010ef          	jal	5454 <printf>
    exit(1);
    3776:	4505                	li	a0,1
    3778:	08f010ef          	jal	5006 <exit>
      exit(0);
    377c:	4501                	li	a0,0
    377e:	089010ef          	jal	5006 <exit>
  wait(&xstatus);
    3782:	fac40513          	addi	a0,s0,-84
    3786:	089010ef          	jal	500e <wait>
  if(xstatus != 0)
    378a:	fac42783          	lw	a5,-84(s0)
    378e:	ef89                	bnez	a5,37a8 <sbrkfail+0x18e>
}
    3790:	60aa                	ld	ra,136(sp)
    3792:	640a                	ld	s0,128(sp)
    3794:	74e6                	ld	s1,120(sp)
    3796:	7946                	ld	s2,112(sp)
    3798:	79a6                	ld	s3,104(sp)
    379a:	7a06                	ld	s4,96(sp)
    379c:	6ae6                	ld	s5,88(sp)
    379e:	6b46                	ld	s6,80(sp)
    37a0:	6ba6                	ld	s7,72(sp)
    37a2:	6c06                	ld	s8,64(sp)
    37a4:	6149                	addi	sp,sp,144
    37a6:	8082                	ret
    exit(1);
    37a8:	4505                	li	a0,1
    37aa:	05d010ef          	jal	5006 <exit>

00000000000037ae <mem>:
{
    37ae:	7139                	addi	sp,sp,-64
    37b0:	fc06                	sd	ra,56(sp)
    37b2:	f822                	sd	s0,48(sp)
    37b4:	f426                	sd	s1,40(sp)
    37b6:	f04a                	sd	s2,32(sp)
    37b8:	ec4e                	sd	s3,24(sp)
    37ba:	0080                	addi	s0,sp,64
    37bc:	89aa                	mv	s3,a0
  if((pid = fork()) == 0){
    37be:	041010ef          	jal	4ffe <fork>
    m1 = 0;
    37c2:	4481                	li	s1,0
    while((m2 = malloc(10001)) != 0){
    37c4:	6909                	lui	s2,0x2
    37c6:	71190913          	addi	s2,s2,1809 # 2711 <iputtest+0x3d>
  if((pid = fork()) == 0){
    37ca:	cd11                	beqz	a0,37e6 <mem+0x38>
    wait(&xstatus);
    37cc:	fcc40513          	addi	a0,s0,-52
    37d0:	03f010ef          	jal	500e <wait>
    if(xstatus == -1){
    37d4:	fcc42503          	lw	a0,-52(s0)
    37d8:	57fd                	li	a5,-1
    37da:	04f50363          	beq	a0,a5,3820 <mem+0x72>
    exit(xstatus);
    37de:	029010ef          	jal	5006 <exit>
      *(char**)m2 = m1;
    37e2:	e104                	sd	s1,0(a0)
      m1 = m2;
    37e4:	84aa                	mv	s1,a0
    while((m2 = malloc(10001)) != 0){
    37e6:	854a                	mv	a0,s2
    37e8:	525010ef          	jal	550c <malloc>
    37ec:	f97d                	bnez	a0,37e2 <mem+0x34>
    while(m1){
    37ee:	c491                	beqz	s1,37fa <mem+0x4c>
      m2 = *(char**)m1;
    37f0:	8526                	mv	a0,s1
    37f2:	6084                	ld	s1,0(s1)
      free(m1);
    37f4:	493010ef          	jal	5486 <free>
    while(m1){
    37f8:	fce5                	bnez	s1,37f0 <mem+0x42>
    m1 = malloc(1024*20);
    37fa:	6515                	lui	a0,0x5
    37fc:	511010ef          	jal	550c <malloc>
    if(m1 == 0){
    3800:	c511                	beqz	a0,380c <mem+0x5e>
    free(m1);
    3802:	485010ef          	jal	5486 <free>
    exit(0);
    3806:	4501                	li	a0,0
    3808:	7fe010ef          	jal	5006 <exit>
      printf("%s: couldn't allocate mem?!!\n", s);
    380c:	85ce                	mv	a1,s3
    380e:	00003517          	auipc	a0,0x3
    3812:	76a50513          	addi	a0,a0,1898 # 6f78 <malloc+0x1a6c>
    3816:	43f010ef          	jal	5454 <printf>
      exit(1);
    381a:	4505                	li	a0,1
    381c:	7ea010ef          	jal	5006 <exit>
      exit(0);
    3820:	4501                	li	a0,0
    3822:	7e4010ef          	jal	5006 <exit>

0000000000003826 <sharedfd>:
{
    3826:	7159                	addi	sp,sp,-112
    3828:	f486                	sd	ra,104(sp)
    382a:	f0a2                	sd	s0,96(sp)
    382c:	eca6                	sd	s1,88(sp)
    382e:	f85a                	sd	s6,48(sp)
    3830:	1880                	addi	s0,sp,112
    3832:	84aa                	mv	s1,a0
    3834:	8b2a                	mv	s6,a0
  unlink("sharedfd");
    3836:	00003517          	auipc	a0,0x3
    383a:	76250513          	addi	a0,a0,1890 # 6f98 <malloc+0x1a8c>
    383e:	019010ef          	jal	5056 <unlink>
  fd = open("sharedfd", O_CREATE|O_RDWR);
    3842:	20200593          	li	a1,514
    3846:	00003517          	auipc	a0,0x3
    384a:	75250513          	addi	a0,a0,1874 # 6f98 <malloc+0x1a8c>
    384e:	7f8010ef          	jal	5046 <open>
  if(fd < 0){
    3852:	04054863          	bltz	a0,38a2 <sharedfd+0x7c>
    3856:	e8ca                	sd	s2,80(sp)
    3858:	e4ce                	sd	s3,72(sp)
    385a:	e0d2                	sd	s4,64(sp)
    385c:	fc56                	sd	s5,56(sp)
    385e:	89aa                	mv	s3,a0
  pid = fork();
    3860:	79e010ef          	jal	4ffe <fork>
    3864:	8aaa                	mv	s5,a0
  memset(buf, pid==0?'c':'p', sizeof(buf));
    3866:	07000593          	li	a1,112
    386a:	e119                	bnez	a0,3870 <sharedfd+0x4a>
    386c:	06300593          	li	a1,99
    3870:	4629                	li	a2,10
    3872:	fa040513          	addi	a0,s0,-96
    3876:	566010ef          	jal	4ddc <memset>
    387a:	3e800493          	li	s1,1000
    if(write(fd, buf, sizeof(buf)) != sizeof(buf)){
    387e:	fa040a13          	addi	s4,s0,-96
    3882:	4929                	li	s2,10
    3884:	864a                	mv	a2,s2
    3886:	85d2                	mv	a1,s4
    3888:	854e                	mv	a0,s3
    388a:	79c010ef          	jal	5026 <write>
    388e:	03251963          	bne	a0,s2,38c0 <sharedfd+0x9a>
  for(i = 0; i < N; i++){
    3892:	34fd                	addiw	s1,s1,-1
    3894:	f8e5                	bnez	s1,3884 <sharedfd+0x5e>
  if(pid == 0) {
    3896:	040a9063          	bnez	s5,38d6 <sharedfd+0xb0>
    389a:	f45e                	sd	s7,40(sp)
    exit(0);
    389c:	4501                	li	a0,0
    389e:	768010ef          	jal	5006 <exit>
    38a2:	e8ca                	sd	s2,80(sp)
    38a4:	e4ce                	sd	s3,72(sp)
    38a6:	e0d2                	sd	s4,64(sp)
    38a8:	fc56                	sd	s5,56(sp)
    38aa:	f45e                	sd	s7,40(sp)
    printf("%s: cannot open sharedfd for writing", s);
    38ac:	85a6                	mv	a1,s1
    38ae:	00003517          	auipc	a0,0x3
    38b2:	6fa50513          	addi	a0,a0,1786 # 6fa8 <malloc+0x1a9c>
    38b6:	39f010ef          	jal	5454 <printf>
    exit(1);
    38ba:	4505                	li	a0,1
    38bc:	74a010ef          	jal	5006 <exit>
    38c0:	f45e                	sd	s7,40(sp)
      printf("%s: write sharedfd failed\n", s);
    38c2:	85da                	mv	a1,s6
    38c4:	00003517          	auipc	a0,0x3
    38c8:	70c50513          	addi	a0,a0,1804 # 6fd0 <malloc+0x1ac4>
    38cc:	389010ef          	jal	5454 <printf>
      exit(1);
    38d0:	4505                	li	a0,1
    38d2:	734010ef          	jal	5006 <exit>
    wait(&xstatus);
    38d6:	f9c40513          	addi	a0,s0,-100
    38da:	734010ef          	jal	500e <wait>
    if(xstatus != 0)
    38de:	f9c42a03          	lw	s4,-100(s0)
    38e2:	000a0663          	beqz	s4,38ee <sharedfd+0xc8>
    38e6:	f45e                	sd	s7,40(sp)
      exit(xstatus);
    38e8:	8552                	mv	a0,s4
    38ea:	71c010ef          	jal	5006 <exit>
    38ee:	f45e                	sd	s7,40(sp)
  close(fd);
    38f0:	854e                	mv	a0,s3
    38f2:	73c010ef          	jal	502e <close>
  fd = open("sharedfd", 0);
    38f6:	4581                	li	a1,0
    38f8:	00003517          	auipc	a0,0x3
    38fc:	6a050513          	addi	a0,a0,1696 # 6f98 <malloc+0x1a8c>
    3900:	746010ef          	jal	5046 <open>
    3904:	8baa                	mv	s7,a0
  nc = np = 0;
    3906:	89d2                	mv	s3,s4
  if(fd < 0){
    3908:	02054363          	bltz	a0,392e <sharedfd+0x108>
    390c:	faa40913          	addi	s2,s0,-86
      if(buf[i] == 'c')
    3910:	06300493          	li	s1,99
      if(buf[i] == 'p')
    3914:	07000a93          	li	s5,112
  while((n = read(fd, buf, sizeof(buf))) > 0){
    3918:	4629                	li	a2,10
    391a:	fa040593          	addi	a1,s0,-96
    391e:	855e                	mv	a0,s7
    3920:	6fe010ef          	jal	501e <read>
    3924:	02a05b63          	blez	a0,395a <sharedfd+0x134>
    3928:	fa040793          	addi	a5,s0,-96
    392c:	a839                	j	394a <sharedfd+0x124>
    printf("%s: cannot open sharedfd for reading\n", s);
    392e:	85da                	mv	a1,s6
    3930:	00003517          	auipc	a0,0x3
    3934:	6c050513          	addi	a0,a0,1728 # 6ff0 <malloc+0x1ae4>
    3938:	31d010ef          	jal	5454 <printf>
    exit(1);
    393c:	4505                	li	a0,1
    393e:	6c8010ef          	jal	5006 <exit>
        nc++;
    3942:	2a05                	addiw	s4,s4,1 # 1001 <truncate3+0x65>
    for(i = 0; i < sizeof(buf); i++){
    3944:	0785                	addi	a5,a5,1
    3946:	fd2789e3          	beq	a5,s2,3918 <sharedfd+0xf2>
      if(buf[i] == 'c')
    394a:	0007c703          	lbu	a4,0(a5)
    394e:	fe970ae3          	beq	a4,s1,3942 <sharedfd+0x11c>
      if(buf[i] == 'p')
    3952:	ff5719e3          	bne	a4,s5,3944 <sharedfd+0x11e>
        np++;
    3956:	2985                	addiw	s3,s3,1
    3958:	b7f5                	j	3944 <sharedfd+0x11e>
  close(fd);
    395a:	855e                	mv	a0,s7
    395c:	6d2010ef          	jal	502e <close>
  unlink("sharedfd");
    3960:	00003517          	auipc	a0,0x3
    3964:	63850513          	addi	a0,a0,1592 # 6f98 <malloc+0x1a8c>
    3968:	6ee010ef          	jal	5056 <unlink>
  if(nc == N*SZ && np == N*SZ){
    396c:	6789                	lui	a5,0x2
    396e:	71078793          	addi	a5,a5,1808 # 2710 <iputtest+0x3c>
    3972:	00fa1763          	bne	s4,a5,3980 <sharedfd+0x15a>
    3976:	01499563          	bne	s3,s4,3980 <sharedfd+0x15a>
    exit(0);
    397a:	4501                	li	a0,0
    397c:	68a010ef          	jal	5006 <exit>
    printf("%s: nc/np test fails\n", s);
    3980:	85da                	mv	a1,s6
    3982:	00003517          	auipc	a0,0x3
    3986:	69650513          	addi	a0,a0,1686 # 7018 <malloc+0x1b0c>
    398a:	2cb010ef          	jal	5454 <printf>
    exit(1);
    398e:	4505                	li	a0,1
    3990:	676010ef          	jal	5006 <exit>

0000000000003994 <fourfiles>:
{
    3994:	7135                	addi	sp,sp,-160
    3996:	ed06                	sd	ra,152(sp)
    3998:	e922                	sd	s0,144(sp)
    399a:	e526                	sd	s1,136(sp)
    399c:	e14a                	sd	s2,128(sp)
    399e:	fcce                	sd	s3,120(sp)
    39a0:	f8d2                	sd	s4,112(sp)
    39a2:	f4d6                	sd	s5,104(sp)
    39a4:	f0da                	sd	s6,96(sp)
    39a6:	ecde                	sd	s7,88(sp)
    39a8:	e8e2                	sd	s8,80(sp)
    39aa:	e4e6                	sd	s9,72(sp)
    39ac:	e0ea                	sd	s10,64(sp)
    39ae:	fc6e                	sd	s11,56(sp)
    39b0:	1100                	addi	s0,sp,160
    39b2:	8caa                	mv	s9,a0
  char *names[] = { "f0", "f1", "f2", "f3" };
    39b4:	00003797          	auipc	a5,0x3
    39b8:	67c78793          	addi	a5,a5,1660 # 7030 <malloc+0x1b24>
    39bc:	f6f43823          	sd	a5,-144(s0)
    39c0:	00003797          	auipc	a5,0x3
    39c4:	67878793          	addi	a5,a5,1656 # 7038 <malloc+0x1b2c>
    39c8:	f6f43c23          	sd	a5,-136(s0)
    39cc:	00003797          	auipc	a5,0x3
    39d0:	67478793          	addi	a5,a5,1652 # 7040 <malloc+0x1b34>
    39d4:	f8f43023          	sd	a5,-128(s0)
    39d8:	00003797          	auipc	a5,0x3
    39dc:	67078793          	addi	a5,a5,1648 # 7048 <malloc+0x1b3c>
    39e0:	f8f43423          	sd	a5,-120(s0)
  for(pi = 0; pi < NCHILD; pi++){
    39e4:	f7040b93          	addi	s7,s0,-144
  char *names[] = { "f0", "f1", "f2", "f3" };
    39e8:	895e                	mv	s2,s7
  for(pi = 0; pi < NCHILD; pi++){
    39ea:	4481                	li	s1,0
    39ec:	4a11                	li	s4,4
    fname = names[pi];
    39ee:	00093983          	ld	s3,0(s2)
    unlink(fname);
    39f2:	854e                	mv	a0,s3
    39f4:	662010ef          	jal	5056 <unlink>
    pid = fork();
    39f8:	606010ef          	jal	4ffe <fork>
    if(pid < 0){
    39fc:	04054063          	bltz	a0,3a3c <fourfiles+0xa8>
    if(pid == 0){
    3a00:	c921                	beqz	a0,3a50 <fourfiles+0xbc>
  for(pi = 0; pi < NCHILD; pi++){
    3a02:	2485                	addiw	s1,s1,1
    3a04:	0921                	addi	s2,s2,8
    3a06:	ff4494e3          	bne	s1,s4,39ee <fourfiles+0x5a>
    3a0a:	4491                	li	s1,4
    wait(&xstatus);
    3a0c:	f6c40913          	addi	s2,s0,-148
    3a10:	854a                	mv	a0,s2
    3a12:	5fc010ef          	jal	500e <wait>
    if(xstatus != 0)
    3a16:	f6c42b03          	lw	s6,-148(s0)
    3a1a:	0a0b1463          	bnez	s6,3ac2 <fourfiles+0x12e>
  for(pi = 0; pi < NCHILD; pi++){
    3a1e:	34fd                	addiw	s1,s1,-1
    3a20:	f8e5                	bnez	s1,3a10 <fourfiles+0x7c>
    3a22:	03000493          	li	s1,48
    while((n = read(fd, buf, sizeof(buf))) > 0){
    3a26:	6a8d                	lui	s5,0x3
    3a28:	0000aa17          	auipc	s4,0xa
    3a2c:	260a0a13          	addi	s4,s4,608 # dc88 <buf>
    if(total != N*SZ){
    3a30:	6d05                	lui	s10,0x1
    3a32:	770d0d13          	addi	s10,s10,1904 # 1770 <forktest+0x8>
  for(i = 0; i < NCHILD; i++){
    3a36:	03400d93          	li	s11,52
    3a3a:	a86d                	j	3af4 <fourfiles+0x160>
      printf("%s: fork failed\n", s);
    3a3c:	85e6                	mv	a1,s9
    3a3e:	00002517          	auipc	a0,0x2
    3a42:	2aa50513          	addi	a0,a0,682 # 5ce8 <malloc+0x7dc>
    3a46:	20f010ef          	jal	5454 <printf>
      exit(1);
    3a4a:	4505                	li	a0,1
    3a4c:	5ba010ef          	jal	5006 <exit>
      fd = open(fname, O_CREATE | O_RDWR);
    3a50:	20200593          	li	a1,514
    3a54:	854e                	mv	a0,s3
    3a56:	5f0010ef          	jal	5046 <open>
    3a5a:	892a                	mv	s2,a0
      if(fd < 0){
    3a5c:	04054063          	bltz	a0,3a9c <fourfiles+0x108>
      memset(buf, '0'+pi, SZ);
    3a60:	1f400613          	li	a2,500
    3a64:	0304859b          	addiw	a1,s1,48
    3a68:	0000a517          	auipc	a0,0xa
    3a6c:	22050513          	addi	a0,a0,544 # dc88 <buf>
    3a70:	36c010ef          	jal	4ddc <memset>
    3a74:	44b1                	li	s1,12
        if((n = write(fd, buf, SZ)) != SZ){
    3a76:	1f400993          	li	s3,500
    3a7a:	0000aa17          	auipc	s4,0xa
    3a7e:	20ea0a13          	addi	s4,s4,526 # dc88 <buf>
    3a82:	864e                	mv	a2,s3
    3a84:	85d2                	mv	a1,s4
    3a86:	854a                	mv	a0,s2
    3a88:	59e010ef          	jal	5026 <write>
    3a8c:	85aa                	mv	a1,a0
    3a8e:	03351163          	bne	a0,s3,3ab0 <fourfiles+0x11c>
      for(i = 0; i < N; i++){
    3a92:	34fd                	addiw	s1,s1,-1
    3a94:	f4fd                	bnez	s1,3a82 <fourfiles+0xee>
      exit(0);
    3a96:	4501                	li	a0,0
    3a98:	56e010ef          	jal	5006 <exit>
        printf("%s: create failed\n", s);
    3a9c:	85e6                	mv	a1,s9
    3a9e:	00002517          	auipc	a0,0x2
    3aa2:	2e250513          	addi	a0,a0,738 # 5d80 <malloc+0x874>
    3aa6:	1af010ef          	jal	5454 <printf>
        exit(1);
    3aaa:	4505                	li	a0,1
    3aac:	55a010ef          	jal	5006 <exit>
          printf("write failed %d\n", n);
    3ab0:	00003517          	auipc	a0,0x3
    3ab4:	5a050513          	addi	a0,a0,1440 # 7050 <malloc+0x1b44>
    3ab8:	19d010ef          	jal	5454 <printf>
          exit(1);
    3abc:	4505                	li	a0,1
    3abe:	548010ef          	jal	5006 <exit>
      exit(xstatus);
    3ac2:	855a                	mv	a0,s6
    3ac4:	542010ef          	jal	5006 <exit>
          printf("%s: wrong char\n", s);
    3ac8:	85e6                	mv	a1,s9
    3aca:	00003517          	auipc	a0,0x3
    3ace:	59e50513          	addi	a0,a0,1438 # 7068 <malloc+0x1b5c>
    3ad2:	183010ef          	jal	5454 <printf>
          exit(1);
    3ad6:	4505                	li	a0,1
    3ad8:	52e010ef          	jal	5006 <exit>
    close(fd);
    3adc:	854e                	mv	a0,s3
    3ade:	550010ef          	jal	502e <close>
    if(total != N*SZ){
    3ae2:	05a91863          	bne	s2,s10,3b32 <fourfiles+0x19e>
    unlink(fname);
    3ae6:	8562                	mv	a0,s8
    3ae8:	56e010ef          	jal	5056 <unlink>
  for(i = 0; i < NCHILD; i++){
    3aec:	0ba1                	addi	s7,s7,8
    3aee:	2485                	addiw	s1,s1,1
    3af0:	05b48b63          	beq	s1,s11,3b46 <fourfiles+0x1b2>
    fname = names[i];
    3af4:	000bbc03          	ld	s8,0(s7)
    fd = open(fname, 0);
    3af8:	4581                	li	a1,0
    3afa:	8562                	mv	a0,s8
    3afc:	54a010ef          	jal	5046 <open>
    3b00:	89aa                	mv	s3,a0
    total = 0;
    3b02:	895a                	mv	s2,s6
    while((n = read(fd, buf, sizeof(buf))) > 0){
    3b04:	8656                	mv	a2,s5
    3b06:	85d2                	mv	a1,s4
    3b08:	854e                	mv	a0,s3
    3b0a:	514010ef          	jal	501e <read>
    3b0e:	fca057e3          	blez	a0,3adc <fourfiles+0x148>
    3b12:	0000a797          	auipc	a5,0xa
    3b16:	17678793          	addi	a5,a5,374 # dc88 <buf>
    3b1a:	00f506b3          	add	a3,a0,a5
        if(buf[j] != '0'+i){
    3b1e:	0007c703          	lbu	a4,0(a5)
    3b22:	fa9713e3          	bne	a4,s1,3ac8 <fourfiles+0x134>
      for(j = 0; j < n; j++){
    3b26:	0785                	addi	a5,a5,1
    3b28:	fed79be3          	bne	a5,a3,3b1e <fourfiles+0x18a>
      total += n;
    3b2c:	00a9093b          	addw	s2,s2,a0
    3b30:	bfd1                	j	3b04 <fourfiles+0x170>
      printf("wrong length %d\n", total);
    3b32:	85ca                	mv	a1,s2
    3b34:	00003517          	auipc	a0,0x3
    3b38:	54450513          	addi	a0,a0,1348 # 7078 <malloc+0x1b6c>
    3b3c:	119010ef          	jal	5454 <printf>
      exit(1);
    3b40:	4505                	li	a0,1
    3b42:	4c4010ef          	jal	5006 <exit>
}
    3b46:	60ea                	ld	ra,152(sp)
    3b48:	644a                	ld	s0,144(sp)
    3b4a:	64aa                	ld	s1,136(sp)
    3b4c:	690a                	ld	s2,128(sp)
    3b4e:	79e6                	ld	s3,120(sp)
    3b50:	7a46                	ld	s4,112(sp)
    3b52:	7aa6                	ld	s5,104(sp)
    3b54:	7b06                	ld	s6,96(sp)
    3b56:	6be6                	ld	s7,88(sp)
    3b58:	6c46                	ld	s8,80(sp)
    3b5a:	6ca6                	ld	s9,72(sp)
    3b5c:	6d06                	ld	s10,64(sp)
    3b5e:	7de2                	ld	s11,56(sp)
    3b60:	610d                	addi	sp,sp,160
    3b62:	8082                	ret

0000000000003b64 <concreate>:
{
    3b64:	7171                	addi	sp,sp,-176
    3b66:	f506                	sd	ra,168(sp)
    3b68:	f122                	sd	s0,160(sp)
    3b6a:	ed26                	sd	s1,152(sp)
    3b6c:	e94a                	sd	s2,144(sp)
    3b6e:	e54e                	sd	s3,136(sp)
    3b70:	e152                	sd	s4,128(sp)
    3b72:	fcd6                	sd	s5,120(sp)
    3b74:	f8da                	sd	s6,112(sp)
    3b76:	f4de                	sd	s7,104(sp)
    3b78:	f0e2                	sd	s8,96(sp)
    3b7a:	ece6                	sd	s9,88(sp)
    3b7c:	e8ea                	sd	s10,80(sp)
    3b7e:	1900                	addi	s0,sp,176
    3b80:	8d2a                	mv	s10,a0
  file[0] = 'C';
    3b82:	04300793          	li	a5,67
    3b86:	f8f40c23          	sb	a5,-104(s0)
  file[2] = '\0';
    3b8a:	f8040d23          	sb	zero,-102(s0)
  for(i = 0; i < N; i++){
    3b8e:	4901                	li	s2,0
    unlink(file);
    3b90:	f9840993          	addi	s3,s0,-104
    if(pid && (i % 3) == 1){
    3b94:	55555b37          	lui	s6,0x55555
    3b98:	556b0b13          	addi	s6,s6,1366 # 55555556 <base+0x555448ce>
    3b9c:	4b85                	li	s7,1
      fd = open(file, O_CREATE | O_RDWR);
    3b9e:	20200c13          	li	s8,514
      link("C0", file);
    3ba2:	00003c97          	auipc	s9,0x3
    3ba6:	4eec8c93          	addi	s9,s9,1262 # 7090 <malloc+0x1b84>
      wait(&xstatus);
    3baa:	f5c40a93          	addi	s5,s0,-164
  for(i = 0; i < N; i++){
    3bae:	02800a13          	li	s4,40
    3bb2:	ac25                	j	3dea <concreate+0x286>
      link("C0", file);
    3bb4:	85ce                	mv	a1,s3
    3bb6:	8566                	mv	a0,s9
    3bb8:	4ae010ef          	jal	5066 <link>
    if(pid == 0) {
    3bbc:	ac29                	j	3dd6 <concreate+0x272>
    } else if(pid == 0 && (i % 5) == 1){
    3bbe:	666667b7          	lui	a5,0x66666
    3bc2:	66778793          	addi	a5,a5,1639 # 66666667 <base+0x666559df>
    3bc6:	02f907b3          	mul	a5,s2,a5
    3bca:	9785                	srai	a5,a5,0x21
    3bcc:	41f9571b          	sraiw	a4,s2,0x1f
    3bd0:	9f99                	subw	a5,a5,a4
    3bd2:	0027971b          	slliw	a4,a5,0x2
    3bd6:	9fb9                	addw	a5,a5,a4
    3bd8:	40f9093b          	subw	s2,s2,a5
    3bdc:	4785                	li	a5,1
    3bde:	02f90563          	beq	s2,a5,3c08 <concreate+0xa4>
      fd = open(file, O_CREATE | O_RDWR);
    3be2:	20200593          	li	a1,514
    3be6:	f9840513          	addi	a0,s0,-104
    3bea:	45c010ef          	jal	5046 <open>
      if(fd < 0){
    3bee:	1c055f63          	bgez	a0,3dcc <concreate+0x268>
        printf("concreate create %s failed\n", file);
    3bf2:	f9840593          	addi	a1,s0,-104
    3bf6:	00003517          	auipc	a0,0x3
    3bfa:	4a250513          	addi	a0,a0,1186 # 7098 <malloc+0x1b8c>
    3bfe:	057010ef          	jal	5454 <printf>
        exit(1);
    3c02:	4505                	li	a0,1
    3c04:	402010ef          	jal	5006 <exit>
      link("C0", file);
    3c08:	f9840593          	addi	a1,s0,-104
    3c0c:	00003517          	auipc	a0,0x3
    3c10:	48450513          	addi	a0,a0,1156 # 7090 <malloc+0x1b84>
    3c14:	452010ef          	jal	5066 <link>
      exit(0);
    3c18:	4501                	li	a0,0
    3c1a:	3ec010ef          	jal	5006 <exit>
        exit(1);
    3c1e:	4505                	li	a0,1
    3c20:	3e6010ef          	jal	5006 <exit>
  memset(fa, 0, sizeof(fa));
    3c24:	02800613          	li	a2,40
    3c28:	4581                	li	a1,0
    3c2a:	f7040513          	addi	a0,s0,-144
    3c2e:	1ae010ef          	jal	4ddc <memset>
  fd = open(".", 0);
    3c32:	4581                	li	a1,0
    3c34:	00002517          	auipc	a0,0x2
    3c38:	f0c50513          	addi	a0,a0,-244 # 5b40 <malloc+0x634>
    3c3c:	40a010ef          	jal	5046 <open>
    3c40:	892a                	mv	s2,a0
  n = 0;
    3c42:	8b26                	mv	s6,s1
  while(read(fd, &de, sizeof(de)) > 0){
    3c44:	f6040a13          	addi	s4,s0,-160
    3c48:	49c1                	li	s3,16
    if(de.name[0] == 'C' && de.name[2] == '\0'){
    3c4a:	04300a93          	li	s5,67
      if(i < 0 || i >= sizeof(fa)){
    3c4e:	02700b93          	li	s7,39
      fa[i] = 1;
    3c52:	4c05                	li	s8,1
  while(read(fd, &de, sizeof(de)) > 0){
    3c54:	864e                	mv	a2,s3
    3c56:	85d2                	mv	a1,s4
    3c58:	854a                	mv	a0,s2
    3c5a:	3c4010ef          	jal	501e <read>
    3c5e:	06a05763          	blez	a0,3ccc <concreate+0x168>
    if(de.inum == 0)
    3c62:	f6045783          	lhu	a5,-160(s0)
    3c66:	d7fd                	beqz	a5,3c54 <concreate+0xf0>
    if(de.name[0] == 'C' && de.name[2] == '\0'){
    3c68:	f6244783          	lbu	a5,-158(s0)
    3c6c:	ff5794e3          	bne	a5,s5,3c54 <concreate+0xf0>
    3c70:	f6444783          	lbu	a5,-156(s0)
    3c74:	f3e5                	bnez	a5,3c54 <concreate+0xf0>
      i = de.name[1] - '0';
    3c76:	f6344783          	lbu	a5,-157(s0)
    3c7a:	fd07879b          	addiw	a5,a5,-48
      if(i < 0 || i >= sizeof(fa)){
    3c7e:	00fbef63          	bltu	s7,a5,3c9c <concreate+0x138>
      if(fa[i]){
    3c82:	fa078713          	addi	a4,a5,-96
    3c86:	9722                	add	a4,a4,s0
    3c88:	fd074703          	lbu	a4,-48(a4)
    3c8c:	e705                	bnez	a4,3cb4 <concreate+0x150>
      fa[i] = 1;
    3c8e:	fa078793          	addi	a5,a5,-96
    3c92:	97a2                	add	a5,a5,s0
    3c94:	fd878823          	sb	s8,-48(a5)
      n++;
    3c98:	2b05                	addiw	s6,s6,1
    3c9a:	bf6d                	j	3c54 <concreate+0xf0>
        printf("%s: concreate weird file %s\n", s, de.name);
    3c9c:	f6240613          	addi	a2,s0,-158
    3ca0:	85ea                	mv	a1,s10
    3ca2:	00003517          	auipc	a0,0x3
    3ca6:	41650513          	addi	a0,a0,1046 # 70b8 <malloc+0x1bac>
    3caa:	7aa010ef          	jal	5454 <printf>
        exit(1);
    3cae:	4505                	li	a0,1
    3cb0:	356010ef          	jal	5006 <exit>
        printf("%s: concreate duplicate file %s\n", s, de.name);
    3cb4:	f6240613          	addi	a2,s0,-158
    3cb8:	85ea                	mv	a1,s10
    3cba:	00003517          	auipc	a0,0x3
    3cbe:	41e50513          	addi	a0,a0,1054 # 70d8 <malloc+0x1bcc>
    3cc2:	792010ef          	jal	5454 <printf>
        exit(1);
    3cc6:	4505                	li	a0,1
    3cc8:	33e010ef          	jal	5006 <exit>
  close(fd);
    3ccc:	854a                	mv	a0,s2
    3cce:	360010ef          	jal	502e <close>
  if(n != N){
    3cd2:	02800793          	li	a5,40
    3cd6:	00fb1a63          	bne	s6,a5,3cea <concreate+0x186>
    if(((i % 3) == 0 && pid == 0) ||
    3cda:	55555a37          	lui	s4,0x55555
    3cde:	556a0a13          	addi	s4,s4,1366 # 55555556 <base+0x555448ce>
      close(open(file, 0));
    3ce2:	f9840993          	addi	s3,s0,-104
  for(i = 0; i < N; i++){
    3ce6:	8ada                	mv	s5,s6
    3ce8:	a049                	j	3d6a <concreate+0x206>
    printf("%s: concreate not enough files in directory listing\n", s);
    3cea:	85ea                	mv	a1,s10
    3cec:	00003517          	auipc	a0,0x3
    3cf0:	41450513          	addi	a0,a0,1044 # 7100 <malloc+0x1bf4>
    3cf4:	760010ef          	jal	5454 <printf>
    exit(1);
    3cf8:	4505                	li	a0,1
    3cfa:	30c010ef          	jal	5006 <exit>
      printf("%s: fork failed\n", s);
    3cfe:	85ea                	mv	a1,s10
    3d00:	00002517          	auipc	a0,0x2
    3d04:	fe850513          	addi	a0,a0,-24 # 5ce8 <malloc+0x7dc>
    3d08:	74c010ef          	jal	5454 <printf>
      exit(1);
    3d0c:	4505                	li	a0,1
    3d0e:	2f8010ef          	jal	5006 <exit>
      close(open(file, 0));
    3d12:	4581                	li	a1,0
    3d14:	854e                	mv	a0,s3
    3d16:	330010ef          	jal	5046 <open>
    3d1a:	314010ef          	jal	502e <close>
      close(open(file, 0));
    3d1e:	4581                	li	a1,0
    3d20:	854e                	mv	a0,s3
    3d22:	324010ef          	jal	5046 <open>
    3d26:	308010ef          	jal	502e <close>
      close(open(file, 0));
    3d2a:	4581                	li	a1,0
    3d2c:	854e                	mv	a0,s3
    3d2e:	318010ef          	jal	5046 <open>
    3d32:	2fc010ef          	jal	502e <close>
      close(open(file, 0));
    3d36:	4581                	li	a1,0
    3d38:	854e                	mv	a0,s3
    3d3a:	30c010ef          	jal	5046 <open>
    3d3e:	2f0010ef          	jal	502e <close>
      close(open(file, 0));
    3d42:	4581                	li	a1,0
    3d44:	854e                	mv	a0,s3
    3d46:	300010ef          	jal	5046 <open>
    3d4a:	2e4010ef          	jal	502e <close>
      close(open(file, 0));
    3d4e:	4581                	li	a1,0
    3d50:	854e                	mv	a0,s3
    3d52:	2f4010ef          	jal	5046 <open>
    3d56:	2d8010ef          	jal	502e <close>
    if(pid == 0)
    3d5a:	06090663          	beqz	s2,3dc6 <concreate+0x262>
      wait(0);
    3d5e:	4501                	li	a0,0
    3d60:	2ae010ef          	jal	500e <wait>
  for(i = 0; i < N; i++){
    3d64:	2485                	addiw	s1,s1,1
    3d66:	0d548163          	beq	s1,s5,3e28 <concreate+0x2c4>
    file[1] = '0' + i;
    3d6a:	0304879b          	addiw	a5,s1,48
    3d6e:	f8f40ca3          	sb	a5,-103(s0)
    pid = fork();
    3d72:	28c010ef          	jal	4ffe <fork>
    3d76:	892a                	mv	s2,a0
    if(pid < 0){
    3d78:	f80543e3          	bltz	a0,3cfe <concreate+0x19a>
    if(((i % 3) == 0 && pid == 0) ||
    3d7c:	03448733          	mul	a4,s1,s4
    3d80:	9301                	srli	a4,a4,0x20
    3d82:	41f4d79b          	sraiw	a5,s1,0x1f
    3d86:	9f1d                	subw	a4,a4,a5
    3d88:	0017179b          	slliw	a5,a4,0x1
    3d8c:	9fb9                	addw	a5,a5,a4
    3d8e:	40f487bb          	subw	a5,s1,a5
    3d92:	00a7e733          	or	a4,a5,a0
    3d96:	2701                	sext.w	a4,a4
    3d98:	df2d                	beqz	a4,3d12 <concreate+0x1ae>
       ((i % 3) == 1 && pid != 0)){
    3d9a:	c119                	beqz	a0,3da0 <concreate+0x23c>
    if(((i % 3) == 0 && pid == 0) ||
    3d9c:	17fd                	addi	a5,a5,-1
       ((i % 3) == 1 && pid != 0)){
    3d9e:	dbb5                	beqz	a5,3d12 <concreate+0x1ae>
      unlink(file);
    3da0:	854e                	mv	a0,s3
    3da2:	2b4010ef          	jal	5056 <unlink>
      unlink(file);
    3da6:	854e                	mv	a0,s3
    3da8:	2ae010ef          	jal	5056 <unlink>
      unlink(file);
    3dac:	854e                	mv	a0,s3
    3dae:	2a8010ef          	jal	5056 <unlink>
      unlink(file);
    3db2:	854e                	mv	a0,s3
    3db4:	2a2010ef          	jal	5056 <unlink>
      unlink(file);
    3db8:	854e                	mv	a0,s3
    3dba:	29c010ef          	jal	5056 <unlink>
      unlink(file);
    3dbe:	854e                	mv	a0,s3
    3dc0:	296010ef          	jal	5056 <unlink>
    3dc4:	bf59                	j	3d5a <concreate+0x1f6>
      exit(0);
    3dc6:	4501                	li	a0,0
    3dc8:	23e010ef          	jal	5006 <exit>
      close(fd);
    3dcc:	262010ef          	jal	502e <close>
    if(pid == 0) {
    3dd0:	b5a1                	j	3c18 <concreate+0xb4>
      close(fd);
    3dd2:	25c010ef          	jal	502e <close>
      wait(&xstatus);
    3dd6:	8556                	mv	a0,s5
    3dd8:	236010ef          	jal	500e <wait>
      if(xstatus != 0)
    3ddc:	f5c42483          	lw	s1,-164(s0)
    3de0:	e2049fe3          	bnez	s1,3c1e <concreate+0xba>
  for(i = 0; i < N; i++){
    3de4:	2905                	addiw	s2,s2,1
    3de6:	e3490fe3          	beq	s2,s4,3c24 <concreate+0xc0>
    file[1] = '0' + i;
    3dea:	0309079b          	addiw	a5,s2,48
    3dee:	f8f40ca3          	sb	a5,-103(s0)
    unlink(file);
    3df2:	854e                	mv	a0,s3
    3df4:	262010ef          	jal	5056 <unlink>
    pid = fork();
    3df8:	206010ef          	jal	4ffe <fork>
    if(pid && (i % 3) == 1){
    3dfc:	dc0501e3          	beqz	a0,3bbe <concreate+0x5a>
    3e00:	036907b3          	mul	a5,s2,s6
    3e04:	9381                	srli	a5,a5,0x20
    3e06:	41f9571b          	sraiw	a4,s2,0x1f
    3e0a:	9f99                	subw	a5,a5,a4
    3e0c:	0017971b          	slliw	a4,a5,0x1
    3e10:	9fb9                	addw	a5,a5,a4
    3e12:	40f907bb          	subw	a5,s2,a5
    3e16:	d9778fe3          	beq	a5,s7,3bb4 <concreate+0x50>
      fd = open(file, O_CREATE | O_RDWR);
    3e1a:	85e2                	mv	a1,s8
    3e1c:	854e                	mv	a0,s3
    3e1e:	228010ef          	jal	5046 <open>
      if(fd < 0){
    3e22:	fa0558e3          	bgez	a0,3dd2 <concreate+0x26e>
    3e26:	b3f1                	j	3bf2 <concreate+0x8e>
}
    3e28:	70aa                	ld	ra,168(sp)
    3e2a:	740a                	ld	s0,160(sp)
    3e2c:	64ea                	ld	s1,152(sp)
    3e2e:	694a                	ld	s2,144(sp)
    3e30:	69aa                	ld	s3,136(sp)
    3e32:	6a0a                	ld	s4,128(sp)
    3e34:	7ae6                	ld	s5,120(sp)
    3e36:	7b46                	ld	s6,112(sp)
    3e38:	7ba6                	ld	s7,104(sp)
    3e3a:	7c06                	ld	s8,96(sp)
    3e3c:	6ce6                	ld	s9,88(sp)
    3e3e:	6d46                	ld	s10,80(sp)
    3e40:	614d                	addi	sp,sp,176
    3e42:	8082                	ret

0000000000003e44 <bigfile>:
{
    3e44:	7139                	addi	sp,sp,-64
    3e46:	fc06                	sd	ra,56(sp)
    3e48:	f822                	sd	s0,48(sp)
    3e4a:	f426                	sd	s1,40(sp)
    3e4c:	f04a                	sd	s2,32(sp)
    3e4e:	ec4e                	sd	s3,24(sp)
    3e50:	e852                	sd	s4,16(sp)
    3e52:	e456                	sd	s5,8(sp)
    3e54:	e05a                	sd	s6,0(sp)
    3e56:	0080                	addi	s0,sp,64
    3e58:	8b2a                	mv	s6,a0
  unlink("bigfile.dat");
    3e5a:	00003517          	auipc	a0,0x3
    3e5e:	2de50513          	addi	a0,a0,734 # 7138 <malloc+0x1c2c>
    3e62:	1f4010ef          	jal	5056 <unlink>
  fd = open("bigfile.dat", O_CREATE | O_RDWR);
    3e66:	20200593          	li	a1,514
    3e6a:	00003517          	auipc	a0,0x3
    3e6e:	2ce50513          	addi	a0,a0,718 # 7138 <malloc+0x1c2c>
    3e72:	1d4010ef          	jal	5046 <open>
  if(fd < 0){
    3e76:	08054a63          	bltz	a0,3f0a <bigfile+0xc6>
    3e7a:	8a2a                	mv	s4,a0
    3e7c:	4481                	li	s1,0
    memset(buf, i, SZ);
    3e7e:	25800913          	li	s2,600
    3e82:	0000a997          	auipc	s3,0xa
    3e86:	e0698993          	addi	s3,s3,-506 # dc88 <buf>
  for(i = 0; i < N; i++){
    3e8a:	4ad1                	li	s5,20
    memset(buf, i, SZ);
    3e8c:	864a                	mv	a2,s2
    3e8e:	85a6                	mv	a1,s1
    3e90:	854e                	mv	a0,s3
    3e92:	74b000ef          	jal	4ddc <memset>
    if(write(fd, buf, SZ) != SZ){
    3e96:	864a                	mv	a2,s2
    3e98:	85ce                	mv	a1,s3
    3e9a:	8552                	mv	a0,s4
    3e9c:	18a010ef          	jal	5026 <write>
    3ea0:	07251f63          	bne	a0,s2,3f1e <bigfile+0xda>
  for(i = 0; i < N; i++){
    3ea4:	2485                	addiw	s1,s1,1
    3ea6:	ff5493e3          	bne	s1,s5,3e8c <bigfile+0x48>
  close(fd);
    3eaa:	8552                	mv	a0,s4
    3eac:	182010ef          	jal	502e <close>
  fd = open("bigfile.dat", 0);
    3eb0:	4581                	li	a1,0
    3eb2:	00003517          	auipc	a0,0x3
    3eb6:	28650513          	addi	a0,a0,646 # 7138 <malloc+0x1c2c>
    3eba:	18c010ef          	jal	5046 <open>
    3ebe:	8aaa                	mv	s5,a0
  total = 0;
    3ec0:	4a01                	li	s4,0
  for(i = 0; ; i++){
    3ec2:	4481                	li	s1,0
    cc = read(fd, buf, SZ/2);
    3ec4:	12c00993          	li	s3,300
    3ec8:	0000a917          	auipc	s2,0xa
    3ecc:	dc090913          	addi	s2,s2,-576 # dc88 <buf>
  if(fd < 0){
    3ed0:	06054163          	bltz	a0,3f32 <bigfile+0xee>
    cc = read(fd, buf, SZ/2);
    3ed4:	864e                	mv	a2,s3
    3ed6:	85ca                	mv	a1,s2
    3ed8:	8556                	mv	a0,s5
    3eda:	144010ef          	jal	501e <read>
    if(cc < 0){
    3ede:	06054463          	bltz	a0,3f46 <bigfile+0x102>
    if(cc == 0)
    3ee2:	c145                	beqz	a0,3f82 <bigfile+0x13e>
    if(cc != SZ/2){
    3ee4:	07351b63          	bne	a0,s3,3f5a <bigfile+0x116>
    if(buf[0] != i/2 || buf[SZ/2-1] != i/2){
    3ee8:	01f4d79b          	srliw	a5,s1,0x1f
    3eec:	9fa5                	addw	a5,a5,s1
    3eee:	4017d79b          	sraiw	a5,a5,0x1
    3ef2:	00094703          	lbu	a4,0(s2)
    3ef6:	06f71c63          	bne	a4,a5,3f6e <bigfile+0x12a>
    3efa:	12b94703          	lbu	a4,299(s2)
    3efe:	06f71863          	bne	a4,a5,3f6e <bigfile+0x12a>
    total += cc;
    3f02:	12ca0a1b          	addiw	s4,s4,300
  for(i = 0; ; i++){
    3f06:	2485                	addiw	s1,s1,1
    cc = read(fd, buf, SZ/2);
    3f08:	b7f1                	j	3ed4 <bigfile+0x90>
    printf("%s: cannot create bigfile", s);
    3f0a:	85da                	mv	a1,s6
    3f0c:	00003517          	auipc	a0,0x3
    3f10:	23c50513          	addi	a0,a0,572 # 7148 <malloc+0x1c3c>
    3f14:	540010ef          	jal	5454 <printf>
    exit(1);
    3f18:	4505                	li	a0,1
    3f1a:	0ec010ef          	jal	5006 <exit>
      printf("%s: write bigfile failed\n", s);
    3f1e:	85da                	mv	a1,s6
    3f20:	00003517          	auipc	a0,0x3
    3f24:	24850513          	addi	a0,a0,584 # 7168 <malloc+0x1c5c>
    3f28:	52c010ef          	jal	5454 <printf>
      exit(1);
    3f2c:	4505                	li	a0,1
    3f2e:	0d8010ef          	jal	5006 <exit>
    printf("%s: cannot open bigfile\n", s);
    3f32:	85da                	mv	a1,s6
    3f34:	00003517          	auipc	a0,0x3
    3f38:	25450513          	addi	a0,a0,596 # 7188 <malloc+0x1c7c>
    3f3c:	518010ef          	jal	5454 <printf>
    exit(1);
    3f40:	4505                	li	a0,1
    3f42:	0c4010ef          	jal	5006 <exit>
      printf("%s: read bigfile failed\n", s);
    3f46:	85da                	mv	a1,s6
    3f48:	00003517          	auipc	a0,0x3
    3f4c:	26050513          	addi	a0,a0,608 # 71a8 <malloc+0x1c9c>
    3f50:	504010ef          	jal	5454 <printf>
      exit(1);
    3f54:	4505                	li	a0,1
    3f56:	0b0010ef          	jal	5006 <exit>
      printf("%s: short read bigfile\n", s);
    3f5a:	85da                	mv	a1,s6
    3f5c:	00003517          	auipc	a0,0x3
    3f60:	26c50513          	addi	a0,a0,620 # 71c8 <malloc+0x1cbc>
    3f64:	4f0010ef          	jal	5454 <printf>
      exit(1);
    3f68:	4505                	li	a0,1
    3f6a:	09c010ef          	jal	5006 <exit>
      printf("%s: read bigfile wrong data\n", s);
    3f6e:	85da                	mv	a1,s6
    3f70:	00003517          	auipc	a0,0x3
    3f74:	27050513          	addi	a0,a0,624 # 71e0 <malloc+0x1cd4>
    3f78:	4dc010ef          	jal	5454 <printf>
      exit(1);
    3f7c:	4505                	li	a0,1
    3f7e:	088010ef          	jal	5006 <exit>
  close(fd);
    3f82:	8556                	mv	a0,s5
    3f84:	0aa010ef          	jal	502e <close>
  if(total != N*SZ){
    3f88:	678d                	lui	a5,0x3
    3f8a:	ee078793          	addi	a5,a5,-288 # 2ee0 <rmdot+0x26>
    3f8e:	02fa1263          	bne	s4,a5,3fb2 <bigfile+0x16e>
  unlink("bigfile.dat");
    3f92:	00003517          	auipc	a0,0x3
    3f96:	1a650513          	addi	a0,a0,422 # 7138 <malloc+0x1c2c>
    3f9a:	0bc010ef          	jal	5056 <unlink>
}
    3f9e:	70e2                	ld	ra,56(sp)
    3fa0:	7442                	ld	s0,48(sp)
    3fa2:	74a2                	ld	s1,40(sp)
    3fa4:	7902                	ld	s2,32(sp)
    3fa6:	69e2                	ld	s3,24(sp)
    3fa8:	6a42                	ld	s4,16(sp)
    3faa:	6aa2                	ld	s5,8(sp)
    3fac:	6b02                	ld	s6,0(sp)
    3fae:	6121                	addi	sp,sp,64
    3fb0:	8082                	ret
    printf("%s: read bigfile wrong total\n", s);
    3fb2:	85da                	mv	a1,s6
    3fb4:	00003517          	auipc	a0,0x3
    3fb8:	24c50513          	addi	a0,a0,588 # 7200 <malloc+0x1cf4>
    3fbc:	498010ef          	jal	5454 <printf>
    exit(1);
    3fc0:	4505                	li	a0,1
    3fc2:	044010ef          	jal	5006 <exit>

0000000000003fc6 <bigargtest>:
{
    3fc6:	7121                	addi	sp,sp,-448
    3fc8:	ff06                	sd	ra,440(sp)
    3fca:	fb22                	sd	s0,432(sp)
    3fcc:	f726                	sd	s1,424(sp)
    3fce:	0380                	addi	s0,sp,448
    3fd0:	84aa                	mv	s1,a0
  unlink("bigarg-ok");
    3fd2:	00003517          	auipc	a0,0x3
    3fd6:	24e50513          	addi	a0,a0,590 # 7220 <malloc+0x1d14>
    3fda:	07c010ef          	jal	5056 <unlink>
  pid = fork();
    3fde:	020010ef          	jal	4ffe <fork>
  if(pid == 0){
    3fe2:	c915                	beqz	a0,4016 <bigargtest+0x50>
  } else if(pid < 0){
    3fe4:	08054c63          	bltz	a0,407c <bigargtest+0xb6>
  wait(&xstatus);
    3fe8:	fdc40513          	addi	a0,s0,-36
    3fec:	022010ef          	jal	500e <wait>
  if(xstatus != 0)
    3ff0:	fdc42503          	lw	a0,-36(s0)
    3ff4:	ed51                	bnez	a0,4090 <bigargtest+0xca>
  fd = open("bigarg-ok", 0);
    3ff6:	4581                	li	a1,0
    3ff8:	00003517          	auipc	a0,0x3
    3ffc:	22850513          	addi	a0,a0,552 # 7220 <malloc+0x1d14>
    4000:	046010ef          	jal	5046 <open>
  if(fd < 0){
    4004:	08054863          	bltz	a0,4094 <bigargtest+0xce>
  close(fd);
    4008:	026010ef          	jal	502e <close>
}
    400c:	70fa                	ld	ra,440(sp)
    400e:	745a                	ld	s0,432(sp)
    4010:	74ba                	ld	s1,424(sp)
    4012:	6139                	addi	sp,sp,448
    4014:	8082                	ret
    memset(big, ' ', sizeof(big));
    4016:	19000613          	li	a2,400
    401a:	02000593          	li	a1,32
    401e:	e4840513          	addi	a0,s0,-440
    4022:	5bb000ef          	jal	4ddc <memset>
    big[sizeof(big)-1] = '\0';
    4026:	fc040ba3          	sb	zero,-41(s0)
    for(i = 0; i < MAXARG-1; i++)
    402a:	00006797          	auipc	a5,0x6
    402e:	44678793          	addi	a5,a5,1094 # a470 <args.1>
    4032:	00006697          	auipc	a3,0x6
    4036:	53668693          	addi	a3,a3,1334 # a568 <args.1+0xf8>
      args[i] = big;
    403a:	e4840713          	addi	a4,s0,-440
    403e:	e398                	sd	a4,0(a5)
    for(i = 0; i < MAXARG-1; i++)
    4040:	07a1                	addi	a5,a5,8
    4042:	fed79ee3          	bne	a5,a3,403e <bigargtest+0x78>
    args[MAXARG-1] = 0;
    4046:	00006797          	auipc	a5,0x6
    404a:	5207b123          	sd	zero,1314(a5) # a568 <args.1+0xf8>
    exec("echo", args);
    404e:	00006597          	auipc	a1,0x6
    4052:	42258593          	addi	a1,a1,1058 # a470 <args.1>
    4056:	00001517          	auipc	a0,0x1
    405a:	5e250513          	addi	a0,a0,1506 # 5638 <malloc+0x12c>
    405e:	7e1000ef          	jal	503e <exec>
    fd = open("bigarg-ok", O_CREATE);
    4062:	20000593          	li	a1,512
    4066:	00003517          	auipc	a0,0x3
    406a:	1ba50513          	addi	a0,a0,442 # 7220 <malloc+0x1d14>
    406e:	7d9000ef          	jal	5046 <open>
    close(fd);
    4072:	7bd000ef          	jal	502e <close>
    exit(0);
    4076:	4501                	li	a0,0
    4078:	78f000ef          	jal	5006 <exit>
    printf("%s: bigargtest: fork failed\n", s);
    407c:	85a6                	mv	a1,s1
    407e:	00003517          	auipc	a0,0x3
    4082:	1b250513          	addi	a0,a0,434 # 7230 <malloc+0x1d24>
    4086:	3ce010ef          	jal	5454 <printf>
    exit(1);
    408a:	4505                	li	a0,1
    408c:	77b000ef          	jal	5006 <exit>
    exit(xstatus);
    4090:	777000ef          	jal	5006 <exit>
    printf("%s: bigarg test failed!\n", s);
    4094:	85a6                	mv	a1,s1
    4096:	00003517          	auipc	a0,0x3
    409a:	1ba50513          	addi	a0,a0,442 # 7250 <malloc+0x1d44>
    409e:	3b6010ef          	jal	5454 <printf>
    exit(1);
    40a2:	4505                	li	a0,1
    40a4:	763000ef          	jal	5006 <exit>

00000000000040a8 <lazy_alloc>:
{
    40a8:	1141                	addi	sp,sp,-16
    40aa:	e406                	sd	ra,8(sp)
    40ac:	e022                	sd	s0,0(sp)
    40ae:	0800                	addi	s0,sp,16
  prev_end = sbrklazy(REGION_SZ);
    40b0:	40000537          	lui	a0,0x40000
    40b4:	735000ef          	jal	4fe8 <sbrklazy>
  if (prev_end == (char *) SBRK_ERROR) {
    40b8:	57fd                	li	a5,-1
    40ba:	02f50a63          	beq	a0,a5,40ee <lazy_alloc+0x46>
  for (i = prev_end + PGSIZE; i < new_end; i += 64 * PGSIZE)
    40be:	6605                	lui	a2,0x1
    40c0:	962a                	add	a2,a2,a0
    40c2:	400017b7          	lui	a5,0x40001
    40c6:	00f50733          	add	a4,a0,a5
    40ca:	87b2                	mv	a5,a2
    40cc:	000406b7          	lui	a3,0x40
    *(char **)i = i;
    40d0:	e39c                	sd	a5,0(a5)
  for (i = prev_end + PGSIZE; i < new_end; i += 64 * PGSIZE)
    40d2:	97b6                	add	a5,a5,a3
    40d4:	fee79ee3          	bne	a5,a4,40d0 <lazy_alloc+0x28>
  for (i = prev_end + PGSIZE; i < new_end; i += 64 * PGSIZE) {
    40d8:	000406b7          	lui	a3,0x40
    if (*(char **)i != i) {
    40dc:	621c                	ld	a5,0(a2)
    40de:	02c79163          	bne	a5,a2,4100 <lazy_alloc+0x58>
  for (i = prev_end + PGSIZE; i < new_end; i += 64 * PGSIZE) {
    40e2:	9636                	add	a2,a2,a3
    40e4:	fee61ce3          	bne	a2,a4,40dc <lazy_alloc+0x34>
  exit(0);
    40e8:	4501                	li	a0,0
    40ea:	71d000ef          	jal	5006 <exit>
    printf("sbrklazy() failed\n");
    40ee:	00003517          	auipc	a0,0x3
    40f2:	18250513          	addi	a0,a0,386 # 7270 <malloc+0x1d64>
    40f6:	35e010ef          	jal	5454 <printf>
    exit(1);
    40fa:	4505                	li	a0,1
    40fc:	70b000ef          	jal	5006 <exit>
      printf("failed to read value from memory\n");
    4100:	00003517          	auipc	a0,0x3
    4104:	18850513          	addi	a0,a0,392 # 7288 <malloc+0x1d7c>
    4108:	34c010ef          	jal	5454 <printf>
      exit(1);
    410c:	4505                	li	a0,1
    410e:	6f9000ef          	jal	5006 <exit>

0000000000004112 <lazy_unmap>:
{
    4112:	7139                	addi	sp,sp,-64
    4114:	fc06                	sd	ra,56(sp)
    4116:	f822                	sd	s0,48(sp)
    4118:	0080                	addi	s0,sp,64
  prev_end = sbrklazy(REGION_SZ);
    411a:	40000537          	lui	a0,0x40000
    411e:	6cb000ef          	jal	4fe8 <sbrklazy>
  if (prev_end == (char*)SBRK_ERROR) {
    4122:	57fd                	li	a5,-1
    4124:	04f50863          	beq	a0,a5,4174 <lazy_unmap+0x62>
    4128:	f426                	sd	s1,40(sp)
    412a:	f04a                	sd	s2,32(sp)
    412c:	ec4e                	sd	s3,24(sp)
    412e:	e852                	sd	s4,16(sp)
  for (i = prev_end + PGSIZE; i < new_end; i += PGSIZE * PGSIZE)
    4130:	6905                	lui	s2,0x1
    4132:	992a                	add	s2,s2,a0
    4134:	400017b7          	lui	a5,0x40001
    4138:	00f504b3          	add	s1,a0,a5
    413c:	87ca                	mv	a5,s2
    413e:	01000737          	lui	a4,0x1000
    *(char **)i = i;
    4142:	e39c                	sd	a5,0(a5)
  for (i = prev_end + PGSIZE; i < new_end; i += PGSIZE * PGSIZE)
    4144:	97ba                	add	a5,a5,a4
    4146:	fe979ee3          	bne	a5,s1,4142 <lazy_unmap+0x30>
      wait(&status);
    414a:	fcc40993          	addi	s3,s0,-52
  for (i = prev_end + PGSIZE; i < new_end; i += PGSIZE * PGSIZE) {
    414e:	01000a37          	lui	s4,0x1000
    pid = fork();
    4152:	6ad000ef          	jal	4ffe <fork>
    if (pid < 0) {
    4156:	02054c63          	bltz	a0,418e <lazy_unmap+0x7c>
    } else if (pid == 0) {
    415a:	c139                	beqz	a0,41a0 <lazy_unmap+0x8e>
      wait(&status);
    415c:	854e                	mv	a0,s3
    415e:	6b1000ef          	jal	500e <wait>
      if (status == 0) {
    4162:	fcc42783          	lw	a5,-52(s0)
    4166:	c7b1                	beqz	a5,41b2 <lazy_unmap+0xa0>
  for (i = prev_end + PGSIZE; i < new_end; i += PGSIZE * PGSIZE) {
    4168:	9952                	add	s2,s2,s4
    416a:	fe9914e3          	bne	s2,s1,4152 <lazy_unmap+0x40>
  exit(0);
    416e:	4501                	li	a0,0
    4170:	697000ef          	jal	5006 <exit>
    4174:	f426                	sd	s1,40(sp)
    4176:	f04a                	sd	s2,32(sp)
    4178:	ec4e                	sd	s3,24(sp)
    417a:	e852                	sd	s4,16(sp)
    printf("sbrklazy() failed\n");
    417c:	00003517          	auipc	a0,0x3
    4180:	0f450513          	addi	a0,a0,244 # 7270 <malloc+0x1d64>
    4184:	2d0010ef          	jal	5454 <printf>
    exit(1);
    4188:	4505                	li	a0,1
    418a:	67d000ef          	jal	5006 <exit>
      printf("error forking\n");
    418e:	00003517          	auipc	a0,0x3
    4192:	12250513          	addi	a0,a0,290 # 72b0 <malloc+0x1da4>
    4196:	2be010ef          	jal	5454 <printf>
      exit(1);
    419a:	4505                	li	a0,1
    419c:	66b000ef          	jal	5006 <exit>
      sbrklazy(-1L * REGION_SZ);
    41a0:	c0000537          	lui	a0,0xc0000
    41a4:	645000ef          	jal	4fe8 <sbrklazy>
      *(char **)i = i;
    41a8:	01293023          	sd	s2,0(s2) # 1000 <truncate3+0x64>
      exit(0);
    41ac:	4501                	li	a0,0
    41ae:	659000ef          	jal	5006 <exit>
        printf("memory not unmapped\n");
    41b2:	00003517          	auipc	a0,0x3
    41b6:	10e50513          	addi	a0,a0,270 # 72c0 <malloc+0x1db4>
    41ba:	29a010ef          	jal	5454 <printf>
        exit(1);
    41be:	4505                	li	a0,1
    41c0:	647000ef          	jal	5006 <exit>

00000000000041c4 <lazy_copy>:
{
    41c4:	7119                	addi	sp,sp,-128
    41c6:	fc86                	sd	ra,120(sp)
    41c8:	f8a2                	sd	s0,112(sp)
    41ca:	f4a6                	sd	s1,104(sp)
    41cc:	f0ca                	sd	s2,96(sp)
    41ce:	ecce                	sd	s3,88(sp)
    41d0:	e8d2                	sd	s4,80(sp)
    41d2:	e4d6                	sd	s5,72(sp)
    41d4:	e0da                	sd	s6,64(sp)
    41d6:	fc5e                	sd	s7,56(sp)
    41d8:	0100                	addi	s0,sp,128
    char *p = sbrk(0);
    41da:	4501                	li	a0,0
    41dc:	5f7000ef          	jal	4fd2 <sbrk>
    41e0:	84aa                	mv	s1,a0
    sbrklazy(4*PGSIZE);
    41e2:	6511                	lui	a0,0x4
    41e4:	605000ef          	jal	4fe8 <sbrklazy>
    open(p + 8192, 0);
    41e8:	4581                	li	a1,0
    41ea:	6509                	lui	a0,0x2
    41ec:	9526                	add	a0,a0,s1
    41ee:	659000ef          	jal	5046 <open>
    void *xx = sbrk(0);
    41f2:	4501                	li	a0,0
    41f4:	5df000ef          	jal	4fd2 <sbrk>
    41f8:	84aa                	mv	s1,a0
    void *ret = sbrk(-(((uint64) xx)+1));
    41fa:	fff54513          	not	a0,a0
    41fe:	2501                	sext.w	a0,a0
    4200:	5d3000ef          	jal	4fd2 <sbrk>
    if(ret != xx){
    4204:	00a48c63          	beq	s1,a0,421c <lazy_copy+0x58>
    4208:	85aa                	mv	a1,a0
      printf("sbrk(sbrk(0)+1) returned %p, not old sz\n", ret);
    420a:	00003517          	auipc	a0,0x3
    420e:	0ce50513          	addi	a0,a0,206 # 72d8 <malloc+0x1dcc>
    4212:	242010ef          	jal	5454 <printf>
      exit(1);
    4216:	4505                	li	a0,1
    4218:	5ef000ef          	jal	5006 <exit>
  unsigned long bad[] = {
    421c:	00004797          	auipc	a5,0x4
    4220:	93c78793          	addi	a5,a5,-1732 # 7b58 <malloc+0x264c>
    4224:	7fa8                	ld	a0,120(a5)
    4226:	63cc                	ld	a1,128(a5)
    4228:	67d0                	ld	a2,136(a5)
    422a:	6bd4                	ld	a3,144(a5)
    422c:	6fd8                	ld	a4,152(a5)
    422e:	f8a43023          	sd	a0,-128(s0)
    4232:	f8b43423          	sd	a1,-120(s0)
    4236:	f8c43823          	sd	a2,-112(s0)
    423a:	f8d43c23          	sd	a3,-104(s0)
    423e:	fae43023          	sd	a4,-96(s0)
    4242:	73dc                	ld	a5,160(a5)
    4244:	faf43423          	sd	a5,-88(s0)
  for(int i = 0; i < sizeof(bad)/sizeof(bad[0]); i++){
    4248:	f8040913          	addi	s2,s0,-128
    int fd = open("README", 0);
    424c:	00001a97          	auipc	s5,0x1
    4250:	5c4a8a93          	addi	s5,s5,1476 # 5810 <malloc+0x304>
    if(read(fd, (char*)bad[i], 512) >= 0) { printf("read succeeded\n");  exit(1); }
    4254:	20000a13          	li	s4,512
    fd = open("junk", O_CREATE|O_RDWR|O_TRUNC);
    4258:	60200b93          	li	s7,1538
    425c:	00001b17          	auipc	s6,0x1
    4260:	4c4b0b13          	addi	s6,s6,1220 # 5720 <malloc+0x214>
    int fd = open("README", 0);
    4264:	4581                	li	a1,0
    4266:	8556                	mv	a0,s5
    4268:	5df000ef          	jal	5046 <open>
    426c:	84aa                	mv	s1,a0
    if(fd < 0) { printf("cannot open README\n"); exit(1); }
    426e:	04054563          	bltz	a0,42b8 <lazy_copy+0xf4>
    if(read(fd, (char*)bad[i], 512) >= 0) { printf("read succeeded\n");  exit(1); }
    4272:	00093983          	ld	s3,0(s2)
    4276:	8652                	mv	a2,s4
    4278:	85ce                	mv	a1,s3
    427a:	5a5000ef          	jal	501e <read>
    427e:	04055663          	bgez	a0,42ca <lazy_copy+0x106>
    close(fd);
    4282:	8526                	mv	a0,s1
    4284:	5ab000ef          	jal	502e <close>
    fd = open("junk", O_CREATE|O_RDWR|O_TRUNC);
    4288:	85de                	mv	a1,s7
    428a:	855a                	mv	a0,s6
    428c:	5bb000ef          	jal	5046 <open>
    4290:	84aa                	mv	s1,a0
    if(fd < 0) { printf("cannot open junk\n"); exit(1); }
    4292:	04054563          	bltz	a0,42dc <lazy_copy+0x118>
    if(write(fd, (char*)bad[i], 512) >= 0) { printf("write succeeded\n"); exit(1); }
    4296:	8652                	mv	a2,s4
    4298:	85ce                	mv	a1,s3
    429a:	58d000ef          	jal	5026 <write>
    429e:	04055863          	bgez	a0,42ee <lazy_copy+0x12a>
    close(fd);
    42a2:	8526                	mv	a0,s1
    42a4:	58b000ef          	jal	502e <close>
  for(int i = 0; i < sizeof(bad)/sizeof(bad[0]); i++){
    42a8:	0921                	addi	s2,s2,8
    42aa:	fb040793          	addi	a5,s0,-80
    42ae:	faf91be3          	bne	s2,a5,4264 <lazy_copy+0xa0>
  exit(0);
    42b2:	4501                	li	a0,0
    42b4:	553000ef          	jal	5006 <exit>
    if(fd < 0) { printf("cannot open README\n"); exit(1); }
    42b8:	00003517          	auipc	a0,0x3
    42bc:	05050513          	addi	a0,a0,80 # 7308 <malloc+0x1dfc>
    42c0:	194010ef          	jal	5454 <printf>
    42c4:	4505                	li	a0,1
    42c6:	541000ef          	jal	5006 <exit>
    if(read(fd, (char*)bad[i], 512) >= 0) { printf("read succeeded\n");  exit(1); }
    42ca:	00003517          	auipc	a0,0x3
    42ce:	05650513          	addi	a0,a0,86 # 7320 <malloc+0x1e14>
    42d2:	182010ef          	jal	5454 <printf>
    42d6:	4505                	li	a0,1
    42d8:	52f000ef          	jal	5006 <exit>
    if(fd < 0) { printf("cannot open junk\n"); exit(1); }
    42dc:	00003517          	auipc	a0,0x3
    42e0:	05450513          	addi	a0,a0,84 # 7330 <malloc+0x1e24>
    42e4:	170010ef          	jal	5454 <printf>
    42e8:	4505                	li	a0,1
    42ea:	51d000ef          	jal	5006 <exit>
    if(write(fd, (char*)bad[i], 512) >= 0) { printf("write succeeded\n"); exit(1); }
    42ee:	00003517          	auipc	a0,0x3
    42f2:	05a50513          	addi	a0,a0,90 # 7348 <malloc+0x1e3c>
    42f6:	15e010ef          	jal	5454 <printf>
    42fa:	4505                	li	a0,1
    42fc:	50b000ef          	jal	5006 <exit>

0000000000004300 <lazy_sbrk>:
{
    4300:	7179                	addi	sp,sp,-48
    4302:	f406                	sd	ra,40(sp)
    4304:	f022                	sd	s0,32(sp)
    4306:	ec26                	sd	s1,24(sp)
    4308:	e84a                	sd	s2,16(sp)
    430a:	e44e                	sd	s3,8(sp)
    430c:	1800                	addi	s0,sp,48
  char *p = sbrk(0);
    430e:	4501                	li	a0,0
    4310:	4c3000ef          	jal	4fd2 <sbrk>
    4314:	84aa                	mv	s1,a0
  while ((uint64)p < MAXVA-(1<<30)) {
    4316:	0ff00793          	li	a5,255
    431a:	07fa                	slli	a5,a5,0x1e
    431c:	00f57e63          	bgeu	a0,a5,4338 <lazy_sbrk+0x38>
    p = sbrklazy(1<<30);
    4320:	400009b7          	lui	s3,0x40000
  while ((uint64)p < MAXVA-(1<<30)) {
    4324:	893e                	mv	s2,a5
    p = sbrklazy(1<<30);
    4326:	854e                	mv	a0,s3
    4328:	4c1000ef          	jal	4fe8 <sbrklazy>
    p = sbrklazy(0);
    432c:	4501                	li	a0,0
    432e:	4bb000ef          	jal	4fe8 <sbrklazy>
    4332:	84aa                	mv	s1,a0
  while ((uint64)p < MAXVA-(1<<30)) {
    4334:	ff2569e3          	bltu	a0,s2,4326 <lazy_sbrk+0x26>
  int n = TRAPFRAME-PGSIZE-(uint64)p;
    4338:	7975                	lui	s2,0xffffd
    433a:	4099093b          	subw	s2,s2,s1
  char *p1 = sbrklazy(n);
    433e:	854a                	mv	a0,s2
    4340:	4a9000ef          	jal	4fe8 <sbrklazy>
    4344:	862a                	mv	a2,a0
  if (p1 < 0 || p1 != p) {
    4346:	00950d63          	beq	a0,s1,4360 <lazy_sbrk+0x60>
    printf("sbrklazy(%d) returned %p, not expected %p\n", n, p1, p);
    434a:	86a6                	mv	a3,s1
    434c:	85ca                	mv	a1,s2
    434e:	00003517          	auipc	a0,0x3
    4352:	01250513          	addi	a0,a0,18 # 7360 <malloc+0x1e54>
    4356:	0fe010ef          	jal	5454 <printf>
    exit(1);
    435a:	4505                	li	a0,1
    435c:	4ab000ef          	jal	5006 <exit>
  p = sbrk(PGSIZE);
    4360:	6505                	lui	a0,0x1
    4362:	471000ef          	jal	4fd2 <sbrk>
    4366:	862a                	mv	a2,a0
  if (p < 0 || (uint64)p != TRAPFRAME-PGSIZE) {
    4368:	040007b7          	lui	a5,0x4000
    436c:	17f5                	addi	a5,a5,-3 # 3fffffd <base+0x3fef375>
    436e:	07b2                	slli	a5,a5,0xc
    4370:	00f50c63          	beq	a0,a5,4388 <lazy_sbrk+0x88>
    printf("sbrk(%d) returned %p, not expected TRAPFRAME-PGSIZE\n", PGSIZE, p);
    4374:	6585                	lui	a1,0x1
    4376:	00003517          	auipc	a0,0x3
    437a:	01a50513          	addi	a0,a0,26 # 7390 <malloc+0x1e84>
    437e:	0d6010ef          	jal	5454 <printf>
    exit(1);
    4382:	4505                	li	a0,1
    4384:	483000ef          	jal	5006 <exit>
  p[0] = 1;
    4388:	040007b7          	lui	a5,0x4000
    438c:	17f5                	addi	a5,a5,-3 # 3fffffd <base+0x3fef375>
    438e:	07b2                	slli	a5,a5,0xc
    4390:	4705                	li	a4,1
    4392:	00e78023          	sb	a4,0(a5)
  if (p[1] != 0) {
    4396:	0017c783          	lbu	a5,1(a5)
    439a:	cb91                	beqz	a5,43ae <lazy_sbrk+0xae>
    printf("sbrk() returned non-zero-filled memory\n");
    439c:	00003517          	auipc	a0,0x3
    43a0:	02c50513          	addi	a0,a0,44 # 73c8 <malloc+0x1ebc>
    43a4:	0b0010ef          	jal	5454 <printf>
    exit(1);
    43a8:	4505                	li	a0,1
    43aa:	45d000ef          	jal	5006 <exit>
  p = sbrk(1);
    43ae:	4505                	li	a0,1
    43b0:	423000ef          	jal	4fd2 <sbrk>
    43b4:	85aa                	mv	a1,a0
  if ((uint64)p != -1) {
    43b6:	57fd                	li	a5,-1
    43b8:	00f50b63          	beq	a0,a5,43ce <lazy_sbrk+0xce>
    printf("sbrk(1) returned %p, expected error\n", p);
    43bc:	00003517          	auipc	a0,0x3
    43c0:	03450513          	addi	a0,a0,52 # 73f0 <malloc+0x1ee4>
    43c4:	090010ef          	jal	5454 <printf>
    exit(1);
    43c8:	4505                	li	a0,1
    43ca:	43d000ef          	jal	5006 <exit>
  p = sbrklazy(1);
    43ce:	4505                	li	a0,1
    43d0:	419000ef          	jal	4fe8 <sbrklazy>
    43d4:	85aa                	mv	a1,a0
  if ((uint64)p != -1) {
    43d6:	57fd                	li	a5,-1
    43d8:	00f50b63          	beq	a0,a5,43ee <lazy_sbrk+0xee>
    printf("sbrklazy(1) returned %p, expected error\n", p);
    43dc:	00003517          	auipc	a0,0x3
    43e0:	03c50513          	addi	a0,a0,60 # 7418 <malloc+0x1f0c>
    43e4:	070010ef          	jal	5454 <printf>
    exit(1);
    43e8:	4505                	li	a0,1
    43ea:	41d000ef          	jal	5006 <exit>
  exit(0);
    43ee:	4501                	li	a0,0
    43f0:	417000ef          	jal	5006 <exit>

00000000000043f4 <writetest>:
{
    43f4:	715d                	addi	sp,sp,-80
    43f6:	e486                	sd	ra,72(sp)
    43f8:	e0a2                	sd	s0,64(sp)
    43fa:	fc26                	sd	s1,56(sp)
    43fc:	f84a                	sd	s2,48(sp)
    43fe:	f44e                	sd	s3,40(sp)
    4400:	f052                	sd	s4,32(sp)
    4402:	ec56                	sd	s5,24(sp)
    4404:	e85a                	sd	s6,16(sp)
    4406:	e45e                	sd	s7,8(sp)
    4408:	0880                	addi	s0,sp,80
    440a:	8baa                	mv	s7,a0
  fd = open("small", O_CREATE|O_RDWR);
    440c:	20200593          	li	a1,514
    4410:	00003517          	auipc	a0,0x3
    4414:	03850513          	addi	a0,a0,56 # 7448 <malloc+0x1f3c>
    4418:	42f000ef          	jal	5046 <open>
  if(fd < 0){
    441c:	08054f63          	bltz	a0,44ba <writetest+0xc6>
    4420:	89aa                	mv	s3,a0
    4422:	4901                	li	s2,0
    if(write(fd, "aaaaaaaaaa", SZ) != SZ){
    4424:	44a9                	li	s1,10
    4426:	00003a17          	auipc	s4,0x3
    442a:	04aa0a13          	addi	s4,s4,74 # 7470 <malloc+0x1f64>
    if(write(fd, "bbbbbbbbbb", SZ) != SZ){
    442e:	00003b17          	auipc	s6,0x3
    4432:	07ab0b13          	addi	s6,s6,122 # 74a8 <malloc+0x1f9c>
  for(i = 0; i < N; i++){
    4436:	06400a93          	li	s5,100
    if(write(fd, "aaaaaaaaaa", SZ) != SZ){
    443a:	8626                	mv	a2,s1
    443c:	85d2                	mv	a1,s4
    443e:	854e                	mv	a0,s3
    4440:	3e7000ef          	jal	5026 <write>
    4444:	08951563          	bne	a0,s1,44ce <writetest+0xda>
    if(write(fd, "bbbbbbbbbb", SZ) != SZ){
    4448:	8626                	mv	a2,s1
    444a:	85da                	mv	a1,s6
    444c:	854e                	mv	a0,s3
    444e:	3d9000ef          	jal	5026 <write>
    4452:	08951963          	bne	a0,s1,44e4 <writetest+0xf0>
  for(i = 0; i < N; i++){
    4456:	2905                	addiw	s2,s2,1 # ffffffffffffd001 <base+0xfffffffffffec379>
    4458:	ff5911e3          	bne	s2,s5,443a <writetest+0x46>
  close(fd);
    445c:	854e                	mv	a0,s3
    445e:	3d1000ef          	jal	502e <close>
  fd = open("small", O_RDONLY);
    4462:	4581                	li	a1,0
    4464:	00003517          	auipc	a0,0x3
    4468:	fe450513          	addi	a0,a0,-28 # 7448 <malloc+0x1f3c>
    446c:	3db000ef          	jal	5046 <open>
    4470:	84aa                	mv	s1,a0
  if(fd < 0){
    4472:	08054463          	bltz	a0,44fa <writetest+0x106>
  i = read(fd, buf, N*SZ*2);
    4476:	7d000613          	li	a2,2000
    447a:	0000a597          	auipc	a1,0xa
    447e:	80e58593          	addi	a1,a1,-2034 # dc88 <buf>
    4482:	39d000ef          	jal	501e <read>
  if(i != N*SZ*2){
    4486:	7d000793          	li	a5,2000
    448a:	08f51263          	bne	a0,a5,450e <writetest+0x11a>
  close(fd);
    448e:	8526                	mv	a0,s1
    4490:	39f000ef          	jal	502e <close>
  if(unlink("small") < 0){
    4494:	00003517          	auipc	a0,0x3
    4498:	fb450513          	addi	a0,a0,-76 # 7448 <malloc+0x1f3c>
    449c:	3bb000ef          	jal	5056 <unlink>
    44a0:	08054163          	bltz	a0,4522 <writetest+0x12e>
}
    44a4:	60a6                	ld	ra,72(sp)
    44a6:	6406                	ld	s0,64(sp)
    44a8:	74e2                	ld	s1,56(sp)
    44aa:	7942                	ld	s2,48(sp)
    44ac:	79a2                	ld	s3,40(sp)
    44ae:	7a02                	ld	s4,32(sp)
    44b0:	6ae2                	ld	s5,24(sp)
    44b2:	6b42                	ld	s6,16(sp)
    44b4:	6ba2                	ld	s7,8(sp)
    44b6:	6161                	addi	sp,sp,80
    44b8:	8082                	ret
    printf("%s: error: creat small failed!\n", s);
    44ba:	85de                	mv	a1,s7
    44bc:	00003517          	auipc	a0,0x3
    44c0:	f9450513          	addi	a0,a0,-108 # 7450 <malloc+0x1f44>
    44c4:	791000ef          	jal	5454 <printf>
    exit(1);
    44c8:	4505                	li	a0,1
    44ca:	33d000ef          	jal	5006 <exit>
      printf("%s: error: write aa %d new file failed\n", s, i);
    44ce:	864a                	mv	a2,s2
    44d0:	85de                	mv	a1,s7
    44d2:	00003517          	auipc	a0,0x3
    44d6:	fae50513          	addi	a0,a0,-82 # 7480 <malloc+0x1f74>
    44da:	77b000ef          	jal	5454 <printf>
      exit(1);
    44de:	4505                	li	a0,1
    44e0:	327000ef          	jal	5006 <exit>
      printf("%s: error: write bb %d new file failed\n", s, i);
    44e4:	864a                	mv	a2,s2
    44e6:	85de                	mv	a1,s7
    44e8:	00003517          	auipc	a0,0x3
    44ec:	fd050513          	addi	a0,a0,-48 # 74b8 <malloc+0x1fac>
    44f0:	765000ef          	jal	5454 <printf>
      exit(1);
    44f4:	4505                	li	a0,1
    44f6:	311000ef          	jal	5006 <exit>
    printf("%s: error: open small failed!\n", s);
    44fa:	85de                	mv	a1,s7
    44fc:	00003517          	auipc	a0,0x3
    4500:	fe450513          	addi	a0,a0,-28 # 74e0 <malloc+0x1fd4>
    4504:	751000ef          	jal	5454 <printf>
    exit(1);
    4508:	4505                	li	a0,1
    450a:	2fd000ef          	jal	5006 <exit>
    printf("%s: read failed\n", s);
    450e:	85de                	mv	a1,s7
    4510:	00002517          	auipc	a0,0x2
    4514:	8c850513          	addi	a0,a0,-1848 # 5dd8 <malloc+0x8cc>
    4518:	73d000ef          	jal	5454 <printf>
    exit(1);
    451c:	4505                	li	a0,1
    451e:	2e9000ef          	jal	5006 <exit>
    printf("%s: unlink small failed\n", s);
    4522:	85de                	mv	a1,s7
    4524:	00003517          	auipc	a0,0x3
    4528:	fdc50513          	addi	a0,a0,-36 # 7500 <malloc+0x1ff4>
    452c:	729000ef          	jal	5454 <printf>
    exit(1);
    4530:	4505                	li	a0,1
    4532:	2d5000ef          	jal	5006 <exit>

0000000000004536 <writebig>:
{
    4536:	7139                	addi	sp,sp,-64
    4538:	fc06                	sd	ra,56(sp)
    453a:	f822                	sd	s0,48(sp)
    453c:	f426                	sd	s1,40(sp)
    453e:	f04a                	sd	s2,32(sp)
    4540:	ec4e                	sd	s3,24(sp)
    4542:	e852                	sd	s4,16(sp)
    4544:	e456                	sd	s5,8(sp)
    4546:	e05a                	sd	s6,0(sp)
    4548:	0080                	addi	s0,sp,64
    454a:	8b2a                	mv	s6,a0
  fd = open("big", O_CREATE|O_RDWR);
    454c:	20200593          	li	a1,514
    4550:	00003517          	auipc	a0,0x3
    4554:	fd050513          	addi	a0,a0,-48 # 7520 <malloc+0x2014>
    4558:	2ef000ef          	jal	5046 <open>
  if(fd < 0){
    455c:	06054a63          	bltz	a0,45d0 <writebig+0x9a>
    4560:	8a2a                	mv	s4,a0
    4562:	4481                	li	s1,0
    ((int*)buf)[0] = i;
    4564:	00009997          	auipc	s3,0x9
    4568:	72498993          	addi	s3,s3,1828 # dc88 <buf>
    if(write(fd, buf, BSIZE) != BSIZE){
    456c:	40000913          	li	s2,1024
  for(i = 0; i < MAXFILE; i++){
    4570:	10c00a93          	li	s5,268
    ((int*)buf)[0] = i;
    4574:	0099a023          	sw	s1,0(s3)
    if(write(fd, buf, BSIZE) != BSIZE){
    4578:	864a                	mv	a2,s2
    457a:	85ce                	mv	a1,s3
    457c:	8552                	mv	a0,s4
    457e:	2a9000ef          	jal	5026 <write>
    4582:	07251163          	bne	a0,s2,45e4 <writebig+0xae>
  for(i = 0; i < MAXFILE; i++){
    4586:	2485                	addiw	s1,s1,1
    4588:	ff5496e3          	bne	s1,s5,4574 <writebig+0x3e>
  close(fd);
    458c:	8552                	mv	a0,s4
    458e:	2a1000ef          	jal	502e <close>
  fd = open("big", O_RDONLY);
    4592:	4581                	li	a1,0
    4594:	00003517          	auipc	a0,0x3
    4598:	f8c50513          	addi	a0,a0,-116 # 7520 <malloc+0x2014>
    459c:	2ab000ef          	jal	5046 <open>
    45a0:	8a2a                	mv	s4,a0
  n = 0;
    45a2:	4481                	li	s1,0
    i = read(fd, buf, BSIZE);
    45a4:	40000993          	li	s3,1024
    45a8:	00009917          	auipc	s2,0x9
    45ac:	6e090913          	addi	s2,s2,1760 # dc88 <buf>
  if(fd < 0){
    45b0:	04054563          	bltz	a0,45fa <writebig+0xc4>
    i = read(fd, buf, BSIZE);
    45b4:	864e                	mv	a2,s3
    45b6:	85ca                	mv	a1,s2
    45b8:	8552                	mv	a0,s4
    45ba:	265000ef          	jal	501e <read>
    if(i == 0){
    45be:	c921                	beqz	a0,460e <writebig+0xd8>
    } else if(i != BSIZE){
    45c0:	09351b63          	bne	a0,s3,4656 <writebig+0x120>
    if(((int*)buf)[0] != n){
    45c4:	00092683          	lw	a3,0(s2)
    45c8:	0a969263          	bne	a3,s1,466c <writebig+0x136>
    n++;
    45cc:	2485                	addiw	s1,s1,1
    i = read(fd, buf, BSIZE);
    45ce:	b7dd                	j	45b4 <writebig+0x7e>
    printf("%s: error: creat big failed!\n", s);
    45d0:	85da                	mv	a1,s6
    45d2:	00003517          	auipc	a0,0x3
    45d6:	f5650513          	addi	a0,a0,-170 # 7528 <malloc+0x201c>
    45da:	67b000ef          	jal	5454 <printf>
    exit(1);
    45de:	4505                	li	a0,1
    45e0:	227000ef          	jal	5006 <exit>
      printf("%s: error: write big file failed i=%d\n", s, i);
    45e4:	8626                	mv	a2,s1
    45e6:	85da                	mv	a1,s6
    45e8:	00003517          	auipc	a0,0x3
    45ec:	f6050513          	addi	a0,a0,-160 # 7548 <malloc+0x203c>
    45f0:	665000ef          	jal	5454 <printf>
      exit(1);
    45f4:	4505                	li	a0,1
    45f6:	211000ef          	jal	5006 <exit>
    printf("%s: error: open big failed!\n", s);
    45fa:	85da                	mv	a1,s6
    45fc:	00003517          	auipc	a0,0x3
    4600:	f7450513          	addi	a0,a0,-140 # 7570 <malloc+0x2064>
    4604:	651000ef          	jal	5454 <printf>
    exit(1);
    4608:	4505                	li	a0,1
    460a:	1fd000ef          	jal	5006 <exit>
      if(n != MAXFILE){
    460e:	10c00793          	li	a5,268
    4612:	02f49763          	bne	s1,a5,4640 <writebig+0x10a>
  close(fd);
    4616:	8552                	mv	a0,s4
    4618:	217000ef          	jal	502e <close>
  if(unlink("big") < 0){
    461c:	00003517          	auipc	a0,0x3
    4620:	f0450513          	addi	a0,a0,-252 # 7520 <malloc+0x2014>
    4624:	233000ef          	jal	5056 <unlink>
    4628:	04054d63          	bltz	a0,4682 <writebig+0x14c>
}
    462c:	70e2                	ld	ra,56(sp)
    462e:	7442                	ld	s0,48(sp)
    4630:	74a2                	ld	s1,40(sp)
    4632:	7902                	ld	s2,32(sp)
    4634:	69e2                	ld	s3,24(sp)
    4636:	6a42                	ld	s4,16(sp)
    4638:	6aa2                	ld	s5,8(sp)
    463a:	6b02                	ld	s6,0(sp)
    463c:	6121                	addi	sp,sp,64
    463e:	8082                	ret
        printf("%s: read only %d blocks from big", s, n);
    4640:	8626                	mv	a2,s1
    4642:	85da                	mv	a1,s6
    4644:	00003517          	auipc	a0,0x3
    4648:	f4c50513          	addi	a0,a0,-180 # 7590 <malloc+0x2084>
    464c:	609000ef          	jal	5454 <printf>
        exit(1);
    4650:	4505                	li	a0,1
    4652:	1b5000ef          	jal	5006 <exit>
      printf("%s: read failed %d\n", s, i);
    4656:	862a                	mv	a2,a0
    4658:	85da                	mv	a1,s6
    465a:	00003517          	auipc	a0,0x3
    465e:	f5e50513          	addi	a0,a0,-162 # 75b8 <malloc+0x20ac>
    4662:	5f3000ef          	jal	5454 <printf>
      exit(1);
    4666:	4505                	li	a0,1
    4668:	19f000ef          	jal	5006 <exit>
      printf("%s: read content of block %d is %d\n", s,
    466c:	8626                	mv	a2,s1
    466e:	85da                	mv	a1,s6
    4670:	00003517          	auipc	a0,0x3
    4674:	f6050513          	addi	a0,a0,-160 # 75d0 <malloc+0x20c4>
    4678:	5dd000ef          	jal	5454 <printf>
      exit(1);
    467c:	4505                	li	a0,1
    467e:	189000ef          	jal	5006 <exit>
    printf("%s: unlink big failed\n", s);
    4682:	85da                	mv	a1,s6
    4684:	00003517          	auipc	a0,0x3
    4688:	f7450513          	addi	a0,a0,-140 # 75f8 <malloc+0x20ec>
    468c:	5c9000ef          	jal	5454 <printf>
    exit(1);
    4690:	4505                	li	a0,1
    4692:	175000ef          	jal	5006 <exit>

0000000000004696 <pipe1>:
{
    4696:	711d                	addi	sp,sp,-96
    4698:	ec86                	sd	ra,88(sp)
    469a:	e8a2                	sd	s0,80(sp)
    469c:	e862                	sd	s8,16(sp)
    469e:	1080                	addi	s0,sp,96
    46a0:	8c2a                	mv	s8,a0
  if(pipe(fds) != 0){
    46a2:	fa840513          	addi	a0,s0,-88
    46a6:	171000ef          	jal	5016 <pipe>
    46aa:	e925                	bnez	a0,471a <pipe1+0x84>
    46ac:	e4a6                	sd	s1,72(sp)
    46ae:	fc4e                	sd	s3,56(sp)
    46b0:	84aa                	mv	s1,a0
  pid = fork();
    46b2:	14d000ef          	jal	4ffe <fork>
    46b6:	89aa                	mv	s3,a0
  if(pid == 0){
    46b8:	c151                	beqz	a0,473c <pipe1+0xa6>
  } else if(pid > 0){
    46ba:	16a05063          	blez	a0,481a <pipe1+0x184>
    46be:	e0ca                	sd	s2,64(sp)
    46c0:	f852                	sd	s4,48(sp)
    close(fds[1]);
    46c2:	fac42503          	lw	a0,-84(s0)
    46c6:	169000ef          	jal	502e <close>
    total = 0;
    46ca:	89a6                	mv	s3,s1
    cc = 1;
    46cc:	4905                	li	s2,1
    while((n = read(fds[0], buf, cc)) > 0){
    46ce:	00009a17          	auipc	s4,0x9
    46d2:	5baa0a13          	addi	s4,s4,1466 # dc88 <buf>
    46d6:	864a                	mv	a2,s2
    46d8:	85d2                	mv	a1,s4
    46da:	fa842503          	lw	a0,-88(s0)
    46de:	141000ef          	jal	501e <read>
    46e2:	85aa                	mv	a1,a0
    46e4:	0ea05963          	blez	a0,47d6 <pipe1+0x140>
    46e8:	00009797          	auipc	a5,0x9
    46ec:	5a078793          	addi	a5,a5,1440 # dc88 <buf>
    46f0:	00b4863b          	addw	a2,s1,a1
        if((buf[i] & 0xff) != (seq++ & 0xff)){
    46f4:	0007c683          	lbu	a3,0(a5)
    46f8:	0ff4f713          	zext.b	a4,s1
    46fc:	0ae69d63          	bne	a3,a4,47b6 <pipe1+0x120>
    4700:	2485                	addiw	s1,s1,1
      for(i = 0; i < n; i++){
    4702:	0785                	addi	a5,a5,1
    4704:	fec498e3          	bne	s1,a2,46f4 <pipe1+0x5e>
      total += n;
    4708:	00b989bb          	addw	s3,s3,a1
      cc = cc * 2;
    470c:	0019191b          	slliw	s2,s2,0x1
      if(cc > sizeof(buf))
    4710:	678d                	lui	a5,0x3
    4712:	fd27f2e3          	bgeu	a5,s2,46d6 <pipe1+0x40>
        cc = sizeof(buf);
    4716:	893e                	mv	s2,a5
    4718:	bf7d                	j	46d6 <pipe1+0x40>
    471a:	e4a6                	sd	s1,72(sp)
    471c:	e0ca                	sd	s2,64(sp)
    471e:	fc4e                	sd	s3,56(sp)
    4720:	f852                	sd	s4,48(sp)
    4722:	f456                	sd	s5,40(sp)
    4724:	f05a                	sd	s6,32(sp)
    4726:	ec5e                	sd	s7,24(sp)
    printf("%s: pipe() failed\n", s);
    4728:	85e2                	mv	a1,s8
    472a:	00002517          	auipc	a0,0x2
    472e:	b8650513          	addi	a0,a0,-1146 # 62b0 <malloc+0xda4>
    4732:	523000ef          	jal	5454 <printf>
    exit(1);
    4736:	4505                	li	a0,1
    4738:	0cf000ef          	jal	5006 <exit>
    473c:	e0ca                	sd	s2,64(sp)
    473e:	f852                	sd	s4,48(sp)
    4740:	f456                	sd	s5,40(sp)
    4742:	f05a                	sd	s6,32(sp)
    4744:	ec5e                	sd	s7,24(sp)
    close(fds[0]);
    4746:	fa842503          	lw	a0,-88(s0)
    474a:	0e5000ef          	jal	502e <close>
    for(n = 0; n < N; n++){
    474e:	00009b17          	auipc	s6,0x9
    4752:	53ab0b13          	addi	s6,s6,1338 # dc88 <buf>
    4756:	416004bb          	negw	s1,s6
    475a:	0ff4f493          	zext.b	s1,s1
    475e:	409b0913          	addi	s2,s6,1033
      if(write(fds[1], buf, SZ) != SZ){
    4762:	40900a13          	li	s4,1033
    4766:	8bda                	mv	s7,s6
    for(n = 0; n < N; n++){
    4768:	6a85                	lui	s5,0x1
    476a:	42da8a93          	addi	s5,s5,1069 # 142d <forkfork+0x89>
{
    476e:	87da                	mv	a5,s6
        buf[i] = seq++;
    4770:	0097873b          	addw	a4,a5,s1
    4774:	00e78023          	sb	a4,0(a5) # 3000 <dirfile+0x20>
      for(i = 0; i < SZ; i++)
    4778:	0785                	addi	a5,a5,1
    477a:	ff279be3          	bne	a5,s2,4770 <pipe1+0xda>
      if(write(fds[1], buf, SZ) != SZ){
    477e:	8652                	mv	a2,s4
    4780:	85de                	mv	a1,s7
    4782:	fac42503          	lw	a0,-84(s0)
    4786:	0a1000ef          	jal	5026 <write>
    478a:	01451c63          	bne	a0,s4,47a2 <pipe1+0x10c>
    478e:	4099899b          	addiw	s3,s3,1033
    for(n = 0; n < N; n++){
    4792:	24a5                	addiw	s1,s1,9
    4794:	0ff4f493          	zext.b	s1,s1
    4798:	fd599be3          	bne	s3,s5,476e <pipe1+0xd8>
    exit(0);
    479c:	4501                	li	a0,0
    479e:	069000ef          	jal	5006 <exit>
        printf("%s: pipe1 oops 1\n", s);
    47a2:	85e2                	mv	a1,s8
    47a4:	00003517          	auipc	a0,0x3
    47a8:	e6c50513          	addi	a0,a0,-404 # 7610 <malloc+0x2104>
    47ac:	4a9000ef          	jal	5454 <printf>
        exit(1);
    47b0:	4505                	li	a0,1
    47b2:	055000ef          	jal	5006 <exit>
          printf("%s: pipe1 oops 2\n", s);
    47b6:	85e2                	mv	a1,s8
    47b8:	00003517          	auipc	a0,0x3
    47bc:	e7050513          	addi	a0,a0,-400 # 7628 <malloc+0x211c>
    47c0:	495000ef          	jal	5454 <printf>
          return;
    47c4:	64a6                	ld	s1,72(sp)
    47c6:	6906                	ld	s2,64(sp)
    47c8:	79e2                	ld	s3,56(sp)
    47ca:	7a42                	ld	s4,48(sp)
}
    47cc:	60e6                	ld	ra,88(sp)
    47ce:	6446                	ld	s0,80(sp)
    47d0:	6c42                	ld	s8,16(sp)
    47d2:	6125                	addi	sp,sp,96
    47d4:	8082                	ret
    if(total != N * SZ){
    47d6:	6785                	lui	a5,0x1
    47d8:	42d78793          	addi	a5,a5,1069 # 142d <forkfork+0x89>
    47dc:	02f98063          	beq	s3,a5,47fc <pipe1+0x166>
    47e0:	f456                	sd	s5,40(sp)
    47e2:	f05a                	sd	s6,32(sp)
    47e4:	ec5e                	sd	s7,24(sp)
      printf("%s: pipe1 oops 3 total %d\n", s, total);
    47e6:	864e                	mv	a2,s3
    47e8:	85e2                	mv	a1,s8
    47ea:	00003517          	auipc	a0,0x3
    47ee:	e5650513          	addi	a0,a0,-426 # 7640 <malloc+0x2134>
    47f2:	463000ef          	jal	5454 <printf>
      exit(1);
    47f6:	4505                	li	a0,1
    47f8:	00f000ef          	jal	5006 <exit>
    47fc:	f456                	sd	s5,40(sp)
    47fe:	f05a                	sd	s6,32(sp)
    4800:	ec5e                	sd	s7,24(sp)
    close(fds[0]);
    4802:	fa842503          	lw	a0,-88(s0)
    4806:	029000ef          	jal	502e <close>
    wait(&xstatus);
    480a:	fa440513          	addi	a0,s0,-92
    480e:	001000ef          	jal	500e <wait>
    exit(xstatus);
    4812:	fa442503          	lw	a0,-92(s0)
    4816:	7f0000ef          	jal	5006 <exit>
    481a:	e0ca                	sd	s2,64(sp)
    481c:	f852                	sd	s4,48(sp)
    481e:	f456                	sd	s5,40(sp)
    4820:	f05a                	sd	s6,32(sp)
    4822:	ec5e                	sd	s7,24(sp)
    printf("%s: fork() failed\n", s);
    4824:	85e2                	mv	a1,s8
    4826:	00003517          	auipc	a0,0x3
    482a:	e3a50513          	addi	a0,a0,-454 # 7660 <malloc+0x2154>
    482e:	427000ef          	jal	5454 <printf>
    exit(1);
    4832:	4505                	li	a0,1
    4834:	7d2000ef          	jal	5006 <exit>

0000000000004838 <fsfull>:
{
    4838:	7171                	addi	sp,sp,-176
    483a:	f506                	sd	ra,168(sp)
    483c:	f122                	sd	s0,160(sp)
    483e:	ed26                	sd	s1,152(sp)
    4840:	e94a                	sd	s2,144(sp)
    4842:	e54e                	sd	s3,136(sp)
    4844:	e152                	sd	s4,128(sp)
    4846:	fcd6                	sd	s5,120(sp)
    4848:	f8da                	sd	s6,112(sp)
    484a:	f4de                	sd	s7,104(sp)
    484c:	f0e2                	sd	s8,96(sp)
    484e:	ece6                	sd	s9,88(sp)
    4850:	e8ea                	sd	s10,80(sp)
    4852:	e4ee                	sd	s11,72(sp)
    4854:	1900                	addi	s0,sp,176
  printf("fsfull test\n");
    4856:	00003517          	auipc	a0,0x3
    485a:	e2250513          	addi	a0,a0,-478 # 7678 <malloc+0x216c>
    485e:	3f7000ef          	jal	5454 <printf>
  for(nfiles = 0; ; nfiles++){
    4862:	4481                	li	s1,0
    name[0] = 'f';
    4864:	06600d93          	li	s11,102
    name[1] = '0' + nfiles / 1000;
    4868:	10625cb7          	lui	s9,0x10625
    486c:	dd3c8c93          	addi	s9,s9,-557 # 10624dd3 <base+0x1061414b>
    name[2] = '0' + (nfiles % 1000) / 100;
    4870:	51eb8ab7          	lui	s5,0x51eb8
    4874:	51fa8a93          	addi	s5,s5,1311 # 51eb851f <base+0x51ea7897>
    name[3] = '0' + (nfiles % 100) / 10;
    4878:	66666a37          	lui	s4,0x66666
    487c:	667a0a13          	addi	s4,s4,1639 # 66666667 <base+0x666559df>
    printf("writing %s\n", name);
    4880:	f5040d13          	addi	s10,s0,-176
    name[0] = 'f';
    4884:	f5b40823          	sb	s11,-176(s0)
    name[1] = '0' + nfiles / 1000;
    4888:	039487b3          	mul	a5,s1,s9
    488c:	9799                	srai	a5,a5,0x26
    488e:	41f4d69b          	sraiw	a3,s1,0x1f
    4892:	9f95                	subw	a5,a5,a3
    4894:	0307871b          	addiw	a4,a5,48
    4898:	f4e408a3          	sb	a4,-175(s0)
    name[2] = '0' + (nfiles % 1000) / 100;
    489c:	3e800713          	li	a4,1000
    48a0:	02f707bb          	mulw	a5,a4,a5
    48a4:	40f487bb          	subw	a5,s1,a5
    48a8:	03578733          	mul	a4,a5,s5
    48ac:	9715                	srai	a4,a4,0x25
    48ae:	41f7d79b          	sraiw	a5,a5,0x1f
    48b2:	40f707bb          	subw	a5,a4,a5
    48b6:	0307879b          	addiw	a5,a5,48
    48ba:	f4f40923          	sb	a5,-174(s0)
    name[3] = '0' + (nfiles % 100) / 10;
    48be:	035487b3          	mul	a5,s1,s5
    48c2:	9795                	srai	a5,a5,0x25
    48c4:	9f95                	subw	a5,a5,a3
    48c6:	06400713          	li	a4,100
    48ca:	02f707bb          	mulw	a5,a4,a5
    48ce:	40f487bb          	subw	a5,s1,a5
    48d2:	03478733          	mul	a4,a5,s4
    48d6:	9709                	srai	a4,a4,0x22
    48d8:	41f7d79b          	sraiw	a5,a5,0x1f
    48dc:	40f707bb          	subw	a5,a4,a5
    48e0:	0307879b          	addiw	a5,a5,48
    48e4:	f4f409a3          	sb	a5,-173(s0)
    name[4] = '0' + (nfiles % 10);
    48e8:	03448733          	mul	a4,s1,s4
    48ec:	9709                	srai	a4,a4,0x22
    48ee:	9f15                	subw	a4,a4,a3
    48f0:	0027179b          	slliw	a5,a4,0x2
    48f4:	9fb9                	addw	a5,a5,a4
    48f6:	0017979b          	slliw	a5,a5,0x1
    48fa:	40f487bb          	subw	a5,s1,a5
    48fe:	0307879b          	addiw	a5,a5,48
    4902:	f4f40a23          	sb	a5,-172(s0)
    name[5] = '\0';
    4906:	f4040aa3          	sb	zero,-171(s0)
    printf("writing %s\n", name);
    490a:	85ea                	mv	a1,s10
    490c:	00003517          	auipc	a0,0x3
    4910:	d7c50513          	addi	a0,a0,-644 # 7688 <malloc+0x217c>
    4914:	341000ef          	jal	5454 <printf>
    int fd = open(name, O_CREATE|O_RDWR);
    4918:	20200593          	li	a1,514
    491c:	856a                	mv	a0,s10
    491e:	728000ef          	jal	5046 <open>
    4922:	892a                	mv	s2,a0
    if(fd < 0){
    4924:	0e055b63          	bgez	a0,4a1a <fsfull+0x1e2>
      printf("open %s failed\n", name);
    4928:	f5040593          	addi	a1,s0,-176
    492c:	00003517          	auipc	a0,0x3
    4930:	d6c50513          	addi	a0,a0,-660 # 7698 <malloc+0x218c>
    4934:	321000ef          	jal	5454 <printf>
  while(nfiles >= 0){
    4938:	0a04cc63          	bltz	s1,49f0 <fsfull+0x1b8>
    name[0] = 'f';
    493c:	06600c13          	li	s8,102
    name[1] = '0' + nfiles / 1000;
    4940:	10625a37          	lui	s4,0x10625
    4944:	dd3a0a13          	addi	s4,s4,-557 # 10624dd3 <base+0x1061414b>
    name[2] = '0' + (nfiles % 1000) / 100;
    4948:	3e800b93          	li	s7,1000
    494c:	51eb89b7          	lui	s3,0x51eb8
    4950:	51f98993          	addi	s3,s3,1311 # 51eb851f <base+0x51ea7897>
    name[3] = '0' + (nfiles % 100) / 10;
    4954:	06400b13          	li	s6,100
    4958:	66666937          	lui	s2,0x66666
    495c:	66790913          	addi	s2,s2,1639 # 66666667 <base+0x666559df>
    unlink(name);
    4960:	f5040a93          	addi	s5,s0,-176
    name[0] = 'f';
    4964:	f5840823          	sb	s8,-176(s0)
    name[1] = '0' + nfiles / 1000;
    4968:	034487b3          	mul	a5,s1,s4
    496c:	9799                	srai	a5,a5,0x26
    496e:	41f4d69b          	sraiw	a3,s1,0x1f
    4972:	9f95                	subw	a5,a5,a3
    4974:	0307871b          	addiw	a4,a5,48
    4978:	f4e408a3          	sb	a4,-175(s0)
    name[2] = '0' + (nfiles % 1000) / 100;
    497c:	02fb87bb          	mulw	a5,s7,a5
    4980:	40f487bb          	subw	a5,s1,a5
    4984:	03378733          	mul	a4,a5,s3
    4988:	9715                	srai	a4,a4,0x25
    498a:	41f7d79b          	sraiw	a5,a5,0x1f
    498e:	40f707bb          	subw	a5,a4,a5
    4992:	0307879b          	addiw	a5,a5,48
    4996:	f4f40923          	sb	a5,-174(s0)
    name[3] = '0' + (nfiles % 100) / 10;
    499a:	033487b3          	mul	a5,s1,s3
    499e:	9795                	srai	a5,a5,0x25
    49a0:	9f95                	subw	a5,a5,a3
    49a2:	02fb07bb          	mulw	a5,s6,a5
    49a6:	40f487bb          	subw	a5,s1,a5
    49aa:	03278733          	mul	a4,a5,s2
    49ae:	9709                	srai	a4,a4,0x22
    49b0:	41f7d79b          	sraiw	a5,a5,0x1f
    49b4:	40f707bb          	subw	a5,a4,a5
    49b8:	0307879b          	addiw	a5,a5,48
    49bc:	f4f409a3          	sb	a5,-173(s0)
    name[4] = '0' + (nfiles % 10);
    49c0:	03248733          	mul	a4,s1,s2
    49c4:	9709                	srai	a4,a4,0x22
    49c6:	9f15                	subw	a4,a4,a3
    49c8:	0027179b          	slliw	a5,a4,0x2
    49cc:	9fb9                	addw	a5,a5,a4
    49ce:	0017979b          	slliw	a5,a5,0x1
    49d2:	40f487bb          	subw	a5,s1,a5
    49d6:	0307879b          	addiw	a5,a5,48
    49da:	f4f40a23          	sb	a5,-172(s0)
    name[5] = '\0';
    49de:	f4040aa3          	sb	zero,-171(s0)
    unlink(name);
    49e2:	8556                	mv	a0,s5
    49e4:	672000ef          	jal	5056 <unlink>
    nfiles--;
    49e8:	34fd                	addiw	s1,s1,-1
  while(nfiles >= 0){
    49ea:	57fd                	li	a5,-1
    49ec:	f6f49ce3          	bne	s1,a5,4964 <fsfull+0x12c>
  printf("fsfull test finished\n");
    49f0:	00003517          	auipc	a0,0x3
    49f4:	cc850513          	addi	a0,a0,-824 # 76b8 <malloc+0x21ac>
    49f8:	25d000ef          	jal	5454 <printf>
}
    49fc:	70aa                	ld	ra,168(sp)
    49fe:	740a                	ld	s0,160(sp)
    4a00:	64ea                	ld	s1,152(sp)
    4a02:	694a                	ld	s2,144(sp)
    4a04:	69aa                	ld	s3,136(sp)
    4a06:	6a0a                	ld	s4,128(sp)
    4a08:	7ae6                	ld	s5,120(sp)
    4a0a:	7b46                	ld	s6,112(sp)
    4a0c:	7ba6                	ld	s7,104(sp)
    4a0e:	7c06                	ld	s8,96(sp)
    4a10:	6ce6                	ld	s9,88(sp)
    4a12:	6d46                	ld	s10,80(sp)
    4a14:	6da6                	ld	s11,72(sp)
    4a16:	614d                	addi	sp,sp,176
    4a18:	8082                	ret
    int total = 0;
    4a1a:	4981                	li	s3,0
      int cc = write(fd, buf, BSIZE);
    4a1c:	40000c13          	li	s8,1024
    4a20:	00009b97          	auipc	s7,0x9
    4a24:	268b8b93          	addi	s7,s7,616 # dc88 <buf>
      if(cc < BSIZE)
    4a28:	3ff00b13          	li	s6,1023
      int cc = write(fd, buf, BSIZE);
    4a2c:	8662                	mv	a2,s8
    4a2e:	85de                	mv	a1,s7
    4a30:	854a                	mv	a0,s2
    4a32:	5f4000ef          	jal	5026 <write>
      if(cc < BSIZE)
    4a36:	00ab5563          	bge	s6,a0,4a40 <fsfull+0x208>
      total += cc;
    4a3a:	00a989bb          	addw	s3,s3,a0
    while(1){
    4a3e:	b7fd                	j	4a2c <fsfull+0x1f4>
    printf("wrote %d bytes\n", total);
    4a40:	85ce                	mv	a1,s3
    4a42:	00003517          	auipc	a0,0x3
    4a46:	c6650513          	addi	a0,a0,-922 # 76a8 <malloc+0x219c>
    4a4a:	20b000ef          	jal	5454 <printf>
    close(fd);
    4a4e:	854a                	mv	a0,s2
    4a50:	5de000ef          	jal	502e <close>
    if(total == 0)
    4a54:	ee0982e3          	beqz	s3,4938 <fsfull+0x100>
  for(nfiles = 0; ; nfiles++){
    4a58:	2485                	addiw	s1,s1,1
    4a5a:	b52d                	j	4884 <fsfull+0x4c>

0000000000004a5c <run>:
//

// run each test in its own process. run returns 1 if child's exit()
// indicates success.
int
run(void f(char *), char *s) {
    4a5c:	7179                	addi	sp,sp,-48
    4a5e:	f406                	sd	ra,40(sp)
    4a60:	f022                	sd	s0,32(sp)
    4a62:	ec26                	sd	s1,24(sp)
    4a64:	e84a                	sd	s2,16(sp)
    4a66:	1800                	addi	s0,sp,48
    4a68:	84aa                	mv	s1,a0
    4a6a:	892e                	mv	s2,a1
  int pid;
  int xstatus;

  printf("test %s: ", s);
    4a6c:	00003517          	auipc	a0,0x3
    4a70:	c6450513          	addi	a0,a0,-924 # 76d0 <malloc+0x21c4>
    4a74:	1e1000ef          	jal	5454 <printf>
  if((pid = fork()) < 0) {
    4a78:	586000ef          	jal	4ffe <fork>
    4a7c:	02054a63          	bltz	a0,4ab0 <run+0x54>
    printf("runtest: fork error\n");
    exit(1);
  }
  if(pid == 0) {
    4a80:	c129                	beqz	a0,4ac2 <run+0x66>
    f(s);
    exit(0);
  } else {
    wait(&xstatus);
    4a82:	fdc40513          	addi	a0,s0,-36
    4a86:	588000ef          	jal	500e <wait>
    if(xstatus != 0) 
    4a8a:	fdc42783          	lw	a5,-36(s0)
    4a8e:	cf9d                	beqz	a5,4acc <run+0x70>
      printf("FAILED\n");
    4a90:	00003517          	auipc	a0,0x3
    4a94:	c6850513          	addi	a0,a0,-920 # 76f8 <malloc+0x21ec>
    4a98:	1bd000ef          	jal	5454 <printf>
    else
      printf("OK\n");
    return xstatus == 0;
    4a9c:	fdc42503          	lw	a0,-36(s0)
  }
}
    4aa0:	00153513          	seqz	a0,a0
    4aa4:	70a2                	ld	ra,40(sp)
    4aa6:	7402                	ld	s0,32(sp)
    4aa8:	64e2                	ld	s1,24(sp)
    4aaa:	6942                	ld	s2,16(sp)
    4aac:	6145                	addi	sp,sp,48
    4aae:	8082                	ret
    printf("runtest: fork error\n");
    4ab0:	00003517          	auipc	a0,0x3
    4ab4:	c3050513          	addi	a0,a0,-976 # 76e0 <malloc+0x21d4>
    4ab8:	19d000ef          	jal	5454 <printf>
    exit(1);
    4abc:	4505                	li	a0,1
    4abe:	548000ef          	jal	5006 <exit>
    f(s);
    4ac2:	854a                	mv	a0,s2
    4ac4:	9482                	jalr	s1
    exit(0);
    4ac6:	4501                	li	a0,0
    4ac8:	53e000ef          	jal	5006 <exit>
      printf("OK\n");
    4acc:	00003517          	auipc	a0,0x3
    4ad0:	c3450513          	addi	a0,a0,-972 # 7700 <malloc+0x21f4>
    4ad4:	181000ef          	jal	5454 <printf>
    4ad8:	b7d1                	j	4a9c <run+0x40>

0000000000004ada <runtests>:

int
runtests(struct test *tests, char *justone, int continuous) {
    4ada:	7179                	addi	sp,sp,-48
    4adc:	f406                	sd	ra,40(sp)
    4ade:	f022                	sd	s0,32(sp)
    4ae0:	ec26                	sd	s1,24(sp)
    4ae2:	e44e                	sd	s3,8(sp)
    4ae4:	1800                	addi	s0,sp,48
    4ae6:	84aa                	mv	s1,a0
  int ntests = 0;
  for (struct test *t = tests; t->s != 0; t++) {
    4ae8:	6508                	ld	a0,8(a0)
    4aea:	cd29                	beqz	a0,4b44 <runtests+0x6a>
    4aec:	e84a                	sd	s2,16(sp)
    4aee:	e052                	sd	s4,0(sp)
    4af0:	892e                	mv	s2,a1
    if((justone == 0) || strcmp(t->s, justone) == 0) {
      ntests++;
      if(!run(t->f, t->s)){
        if(continuous != 2){
    4af2:	1679                	addi	a2,a2,-2 # ffe <truncate3+0x62>
    4af4:	00c03a33          	snez	s4,a2
  int ntests = 0;
    4af8:	4981                	li	s3,0
    4afa:	a029                	j	4b04 <runtests+0x2a>
      ntests++;
    4afc:	2985                	addiw	s3,s3,1
  for (struct test *t = tests; t->s != 0; t++) {
    4afe:	04c1                	addi	s1,s1,16
    4b00:	6488                	ld	a0,8(s1)
    4b02:	c905                	beqz	a0,4b32 <runtests+0x58>
    if((justone == 0) || strcmp(t->s, justone) == 0) {
    4b04:	00090663          	beqz	s2,4b10 <runtests+0x36>
    4b08:	85ca                	mv	a1,s2
    4b0a:	276000ef          	jal	4d80 <strcmp>
    4b0e:	f965                	bnez	a0,4afe <runtests+0x24>
      if(!run(t->f, t->s)){
    4b10:	648c                	ld	a1,8(s1)
    4b12:	6088                	ld	a0,0(s1)
    4b14:	f49ff0ef          	jal	4a5c <run>
        if(continuous != 2){
    4b18:	f175                	bnez	a0,4afc <runtests+0x22>
    4b1a:	fe0a01e3          	beqz	s4,4afc <runtests+0x22>
          printf("SOME TESTS FAILED\n");
    4b1e:	00003517          	auipc	a0,0x3
    4b22:	bea50513          	addi	a0,a0,-1046 # 7708 <malloc+0x21fc>
    4b26:	12f000ef          	jal	5454 <printf>
          return -1;
    4b2a:	59fd                	li	s3,-1
    4b2c:	6942                	ld	s2,16(sp)
    4b2e:	6a02                	ld	s4,0(sp)
    4b30:	a019                	j	4b36 <runtests+0x5c>
    4b32:	6942                	ld	s2,16(sp)
    4b34:	6a02                	ld	s4,0(sp)
        }
      }
    }
  }
  return ntests;
}
    4b36:	854e                	mv	a0,s3
    4b38:	70a2                	ld	ra,40(sp)
    4b3a:	7402                	ld	s0,32(sp)
    4b3c:	64e2                	ld	s1,24(sp)
    4b3e:	69a2                	ld	s3,8(sp)
    4b40:	6145                	addi	sp,sp,48
    4b42:	8082                	ret
  return ntests;
    4b44:	4981                	li	s3,0
    4b46:	bfc5                	j	4b36 <runtests+0x5c>

0000000000004b48 <countfree>:


// use sbrk() to count how many free physical memory pages there are.
int
countfree()
{
    4b48:	7139                	addi	sp,sp,-64
    4b4a:	fc06                	sd	ra,56(sp)
    4b4c:	f822                	sd	s0,48(sp)
    4b4e:	f426                	sd	s1,40(sp)
    4b50:	f04a                	sd	s2,32(sp)
    4b52:	ec4e                	sd	s3,24(sp)
    4b54:	e852                	sd	s4,16(sp)
    4b56:	e456                	sd	s5,8(sp)
    4b58:	0080                	addi	s0,sp,64
  int n = 0;
  uint64 sz0 = (uint64)sbrk(0);
    4b5a:	4501                	li	a0,0
    4b5c:	476000ef          	jal	4fd2 <sbrk>
    4b60:	8aaa                	mv	s5,a0
  int n = 0;
    4b62:	4481                	li	s1,0
  while(n<max){
    char *a = sbrk(PGSIZE);
    4b64:	6a05                	lui	s4,0x1
    if(a == SBRK_ERROR){
    4b66:	59fd                	li	s3,-1
  while(n<max){
    4b68:	6919                	lui	s2,0x6
    4b6a:	1a890913          	addi	s2,s2,424 # 61a8 <malloc+0xc9c>
    char *a = sbrk(PGSIZE);
    4b6e:	8552                	mv	a0,s4
    4b70:	462000ef          	jal	4fd2 <sbrk>
    if(a == SBRK_ERROR){
    4b74:	01350563          	beq	a0,s3,4b7e <countfree+0x36>
      break;
    }
    n += 1;
    4b78:	2485                	addiw	s1,s1,1
  while(n<max){
    4b7a:	ff249ae3          	bne	s1,s2,4b6e <countfree+0x26>
  }
  sbrk(-((uint64)sbrk(0) - sz0));  
    4b7e:	4501                	li	a0,0
    4b80:	452000ef          	jal	4fd2 <sbrk>
    4b84:	40aa853b          	subw	a0,s5,a0
    4b88:	44a000ef          	jal	4fd2 <sbrk>
  return n;
}
    4b8c:	8526                	mv	a0,s1
    4b8e:	70e2                	ld	ra,56(sp)
    4b90:	7442                	ld	s0,48(sp)
    4b92:	74a2                	ld	s1,40(sp)
    4b94:	7902                	ld	s2,32(sp)
    4b96:	69e2                	ld	s3,24(sp)
    4b98:	6a42                	ld	s4,16(sp)
    4b9a:	6aa2                	ld	s5,8(sp)
    4b9c:	6121                	addi	sp,sp,64
    4b9e:	8082                	ret

0000000000004ba0 <drivetests>:

int
drivetests(int quick, int continuous, char *justone) {
    4ba0:	7159                	addi	sp,sp,-112
    4ba2:	f486                	sd	ra,104(sp)
    4ba4:	f0a2                	sd	s0,96(sp)
    4ba6:	eca6                	sd	s1,88(sp)
    4ba8:	e8ca                	sd	s2,80(sp)
    4baa:	e4ce                	sd	s3,72(sp)
    4bac:	e0d2                	sd	s4,64(sp)
    4bae:	fc56                	sd	s5,56(sp)
    4bb0:	f85a                	sd	s6,48(sp)
    4bb2:	f45e                	sd	s7,40(sp)
    4bb4:	f062                	sd	s8,32(sp)
    4bb6:	ec66                	sd	s9,24(sp)
    4bb8:	e86a                	sd	s10,16(sp)
    4bba:	e46e                	sd	s11,8(sp)
    4bbc:	1880                	addi	s0,sp,112
    4bbe:	8aaa                	mv	s5,a0
    4bc0:	89ae                	mv	s3,a1
    4bc2:	8a32                	mv	s4,a2
      printf("FAILED -- lost some free pages %d (out of %d)\n", free1, free0);
      if(continuous != 2) {
        return 1;
      }
    }
    if (justone != 0 && ntests == 0) {
    4bc4:	00c03d33          	snez	s10,a2
    printf("usertests starting\n");
    4bc8:	00003c17          	auipc	s8,0x3
    4bcc:	b58c0c13          	addi	s8,s8,-1192 # 7720 <malloc+0x2214>
    n = runtests(quicktests, justone, continuous);
    4bd0:	00005b97          	auipc	s7,0x5
    4bd4:	440b8b93          	addi	s7,s7,1088 # a010 <quicktests>
      if(continuous != 2) {
    4bd8:	4b09                	li	s6,2
      n = runtests(slowtests, justone, continuous);
    4bda:	00006c97          	auipc	s9,0x6
    4bde:	816c8c93          	addi	s9,s9,-2026 # a3f0 <slowtests>
      printf("FAILED -- lost some free pages %d (out of %d)\n", free1, free0);
    4be2:	00003d97          	auipc	s11,0x3
    4be6:	b76d8d93          	addi	s11,s11,-1162 # 7758 <malloc+0x224c>
    4bea:	a82d                	j	4c24 <drivetests+0x84>
      if(continuous != 2) {
    4bec:	0b699363          	bne	s3,s6,4c92 <drivetests+0xf2>
    int ntests = 0;
    4bf0:	4481                	li	s1,0
    4bf2:	a0b9                	j	4c40 <drivetests+0xa0>
        printf("usertests slow tests starting\n");
    4bf4:	00003517          	auipc	a0,0x3
    4bf8:	b4450513          	addi	a0,a0,-1212 # 7738 <malloc+0x222c>
    4bfc:	059000ef          	jal	5454 <printf>
    4c00:	a0a1                	j	4c48 <drivetests+0xa8>
        if(continuous != 2) {
    4c02:	05698b63          	beq	s3,s6,4c58 <drivetests+0xb8>
          return 1;
    4c06:	4505                	li	a0,1
    4c08:	a0b5                	j	4c74 <drivetests+0xd4>
      printf("FAILED -- lost some free pages %d (out of %d)\n", free1, free0);
    4c0a:	864a                	mv	a2,s2
    4c0c:	85aa                	mv	a1,a0
    4c0e:	856e                	mv	a0,s11
    4c10:	045000ef          	jal	5454 <printf>
      if(continuous != 2) {
    4c14:	09699163          	bne	s3,s6,4c96 <drivetests+0xf6>
    if (justone != 0 && ntests == 0) {
    4c18:	e491                	bnez	s1,4c24 <drivetests+0x84>
    4c1a:	000d0563          	beqz	s10,4c24 <drivetests+0x84>
    4c1e:	a0a1                	j	4c66 <drivetests+0xc6>
      printf("NO TESTS EXECUTED\n");
      return 1;
    }
  } while(continuous);
    4c20:	06098d63          	beqz	s3,4c9a <drivetests+0xfa>
    printf("usertests starting\n");
    4c24:	8562                	mv	a0,s8
    4c26:	02f000ef          	jal	5454 <printf>
    int free0 = countfree();
    4c2a:	f1fff0ef          	jal	4b48 <countfree>
    4c2e:	892a                	mv	s2,a0
    n = runtests(quicktests, justone, continuous);
    4c30:	864e                	mv	a2,s3
    4c32:	85d2                	mv	a1,s4
    4c34:	855e                	mv	a0,s7
    4c36:	ea5ff0ef          	jal	4ada <runtests>
    4c3a:	84aa                	mv	s1,a0
    if (n < 0) {
    4c3c:	fa0548e3          	bltz	a0,4bec <drivetests+0x4c>
    if(!quick) {
    4c40:	000a9c63          	bnez	s5,4c58 <drivetests+0xb8>
      if (justone == 0)
    4c44:	fa0a08e3          	beqz	s4,4bf4 <drivetests+0x54>
      n = runtests(slowtests, justone, continuous);
    4c48:	864e                	mv	a2,s3
    4c4a:	85d2                	mv	a1,s4
    4c4c:	8566                	mv	a0,s9
    4c4e:	e8dff0ef          	jal	4ada <runtests>
      if (n < 0) {
    4c52:	fa0548e3          	bltz	a0,4c02 <drivetests+0x62>
        ntests += n;
    4c56:	9ca9                	addw	s1,s1,a0
    if((free1 = countfree()) < free0) {
    4c58:	ef1ff0ef          	jal	4b48 <countfree>
    4c5c:	fb2547e3          	blt	a0,s2,4c0a <drivetests+0x6a>
    if (justone != 0 && ntests == 0) {
    4c60:	f0e1                	bnez	s1,4c20 <drivetests+0x80>
    4c62:	fa0d0fe3          	beqz	s10,4c20 <drivetests+0x80>
      printf("NO TESTS EXECUTED\n");
    4c66:	00003517          	auipc	a0,0x3
    4c6a:	b2250513          	addi	a0,a0,-1246 # 7788 <malloc+0x227c>
    4c6e:	7e6000ef          	jal	5454 <printf>
      return 1;
    4c72:	4505                	li	a0,1
  return 0;
}
    4c74:	70a6                	ld	ra,104(sp)
    4c76:	7406                	ld	s0,96(sp)
    4c78:	64e6                	ld	s1,88(sp)
    4c7a:	6946                	ld	s2,80(sp)
    4c7c:	69a6                	ld	s3,72(sp)
    4c7e:	6a06                	ld	s4,64(sp)
    4c80:	7ae2                	ld	s5,56(sp)
    4c82:	7b42                	ld	s6,48(sp)
    4c84:	7ba2                	ld	s7,40(sp)
    4c86:	7c02                	ld	s8,32(sp)
    4c88:	6ce2                	ld	s9,24(sp)
    4c8a:	6d42                	ld	s10,16(sp)
    4c8c:	6da2                	ld	s11,8(sp)
    4c8e:	6165                	addi	sp,sp,112
    4c90:	8082                	ret
        return 1;
    4c92:	4505                	li	a0,1
    4c94:	b7c5                	j	4c74 <drivetests+0xd4>
        return 1;
    4c96:	4505                	li	a0,1
    4c98:	bff1                	j	4c74 <drivetests+0xd4>
  return 0;
    4c9a:	854e                	mv	a0,s3
    4c9c:	bfe1                	j	4c74 <drivetests+0xd4>

0000000000004c9e <main>:

int
main(int argc, char *argv[])
{
    4c9e:	1101                	addi	sp,sp,-32
    4ca0:	ec06                	sd	ra,24(sp)
    4ca2:	e822                	sd	s0,16(sp)
    4ca4:	e426                	sd	s1,8(sp)
    4ca6:	e04a                	sd	s2,0(sp)
    4ca8:	1000                	addi	s0,sp,32
    4caa:	84aa                	mv	s1,a0
  int continuous = 0;
  int quick = 0;
  char *justone = 0;

  if(argc == 2 && strcmp(argv[1], "-q") == 0){
    4cac:	4789                	li	a5,2
    4cae:	00f50e63          	beq	a0,a5,4cca <main+0x2c>
    continuous = 1;
  } else if(argc == 2 && strcmp(argv[1], "-C") == 0){
    continuous = 2;
  } else if(argc == 2 && argv[1][0] != '-'){
    justone = argv[1];
  } else if(argc > 1){
    4cb2:	4785                	li	a5,1
    4cb4:	06a7c663          	blt	a5,a0,4d20 <main+0x82>
  char *justone = 0;
    4cb8:	4601                	li	a2,0
  int quick = 0;
    4cba:	4501                	li	a0,0
  int continuous = 0;
    4cbc:	4581                	li	a1,0
    printf("Usage: usertests [-c] [-C] [-q] [testname]\n");
    exit(1);
  }
  if (drivetests(quick, continuous, justone)) {
    4cbe:	ee3ff0ef          	jal	4ba0 <drivetests>
    4cc2:	cd35                	beqz	a0,4d3e <main+0xa0>
    exit(1);
    4cc4:	4505                	li	a0,1
    4cc6:	340000ef          	jal	5006 <exit>
    4cca:	892e                	mv	s2,a1
  if(argc == 2 && strcmp(argv[1], "-q") == 0){
    4ccc:	00003597          	auipc	a1,0x3
    4cd0:	ad458593          	addi	a1,a1,-1324 # 77a0 <malloc+0x2294>
    4cd4:	00893503          	ld	a0,8(s2)
    4cd8:	0a8000ef          	jal	4d80 <strcmp>
    4cdc:	85aa                	mv	a1,a0
    4cde:	e501                	bnez	a0,4ce6 <main+0x48>
  char *justone = 0;
    4ce0:	4601                	li	a2,0
    quick = 1;
    4ce2:	4505                	li	a0,1
    4ce4:	bfe9                	j	4cbe <main+0x20>
  } else if(argc == 2 && strcmp(argv[1], "-c") == 0){
    4ce6:	00003597          	auipc	a1,0x3
    4cea:	ac258593          	addi	a1,a1,-1342 # 77a8 <malloc+0x229c>
    4cee:	00893503          	ld	a0,8(s2)
    4cf2:	08e000ef          	jal	4d80 <strcmp>
    4cf6:	cd15                	beqz	a0,4d32 <main+0x94>
  } else if(argc == 2 && strcmp(argv[1], "-C") == 0){
    4cf8:	00003597          	auipc	a1,0x3
    4cfc:	b0058593          	addi	a1,a1,-1280 # 77f8 <malloc+0x22ec>
    4d00:	00893503          	ld	a0,8(s2)
    4d04:	07c000ef          	jal	4d80 <strcmp>
    4d08:	c905                	beqz	a0,4d38 <main+0x9a>
  } else if(argc == 2 && argv[1][0] != '-'){
    4d0a:	00893603          	ld	a2,8(s2)
    4d0e:	00064703          	lbu	a4,0(a2)
    4d12:	02d00793          	li	a5,45
    4d16:	00f70563          	beq	a4,a5,4d20 <main+0x82>
  int quick = 0;
    4d1a:	4501                	li	a0,0
  int continuous = 0;
    4d1c:	4581                	li	a1,0
    4d1e:	b745                	j	4cbe <main+0x20>
    printf("Usage: usertests [-c] [-C] [-q] [testname]\n");
    4d20:	00003517          	auipc	a0,0x3
    4d24:	a9050513          	addi	a0,a0,-1392 # 77b0 <malloc+0x22a4>
    4d28:	72c000ef          	jal	5454 <printf>
    exit(1);
    4d2c:	4505                	li	a0,1
    4d2e:	2d8000ef          	jal	5006 <exit>
  char *justone = 0;
    4d32:	4601                	li	a2,0
    continuous = 1;
    4d34:	4585                	li	a1,1
    4d36:	b761                	j	4cbe <main+0x20>
    continuous = 2;
    4d38:	85a6                	mv	a1,s1
  char *justone = 0;
    4d3a:	4601                	li	a2,0
    4d3c:	b749                	j	4cbe <main+0x20>
  }
  printf("ALL TESTS PASSED\n");
    4d3e:	00003517          	auipc	a0,0x3
    4d42:	aa250513          	addi	a0,a0,-1374 # 77e0 <malloc+0x22d4>
    4d46:	70e000ef          	jal	5454 <printf>
  exit(0);
    4d4a:	4501                	li	a0,0
    4d4c:	2ba000ef          	jal	5006 <exit>

0000000000004d50 <start>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
start(int argc, char **argv)
{
    4d50:	1141                	addi	sp,sp,-16
    4d52:	e406                	sd	ra,8(sp)
    4d54:	e022                	sd	s0,0(sp)
    4d56:	0800                	addi	s0,sp,16
  int r;
  extern int main(int argc, char **argv);
  r = main(argc, argv);
    4d58:	f47ff0ef          	jal	4c9e <main>
  exit(r);
    4d5c:	2aa000ef          	jal	5006 <exit>

0000000000004d60 <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
    4d60:	1141                	addi	sp,sp,-16
    4d62:	e406                	sd	ra,8(sp)
    4d64:	e022                	sd	s0,0(sp)
    4d66:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
    4d68:	87aa                	mv	a5,a0
    4d6a:	0585                	addi	a1,a1,1
    4d6c:	0785                	addi	a5,a5,1
    4d6e:	fff5c703          	lbu	a4,-1(a1)
    4d72:	fee78fa3          	sb	a4,-1(a5)
    4d76:	fb75                	bnez	a4,4d6a <strcpy+0xa>
    ;
  return os;
}
    4d78:	60a2                	ld	ra,8(sp)
    4d7a:	6402                	ld	s0,0(sp)
    4d7c:	0141                	addi	sp,sp,16
    4d7e:	8082                	ret

0000000000004d80 <strcmp>:

int
strcmp(const char *p, const char *q)
{
    4d80:	1141                	addi	sp,sp,-16
    4d82:	e406                	sd	ra,8(sp)
    4d84:	e022                	sd	s0,0(sp)
    4d86:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
    4d88:	00054783          	lbu	a5,0(a0)
    4d8c:	cb91                	beqz	a5,4da0 <strcmp+0x20>
    4d8e:	0005c703          	lbu	a4,0(a1)
    4d92:	00f71763          	bne	a4,a5,4da0 <strcmp+0x20>
    p++, q++;
    4d96:	0505                	addi	a0,a0,1
    4d98:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
    4d9a:	00054783          	lbu	a5,0(a0)
    4d9e:	fbe5                	bnez	a5,4d8e <strcmp+0xe>
  return (uchar)*p - (uchar)*q;
    4da0:	0005c503          	lbu	a0,0(a1)
}
    4da4:	40a7853b          	subw	a0,a5,a0
    4da8:	60a2                	ld	ra,8(sp)
    4daa:	6402                	ld	s0,0(sp)
    4dac:	0141                	addi	sp,sp,16
    4dae:	8082                	ret

0000000000004db0 <strlen>:

uint
strlen(const char *s)
{
    4db0:	1141                	addi	sp,sp,-16
    4db2:	e406                	sd	ra,8(sp)
    4db4:	e022                	sd	s0,0(sp)
    4db6:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
    4db8:	00054783          	lbu	a5,0(a0)
    4dbc:	cf91                	beqz	a5,4dd8 <strlen+0x28>
    4dbe:	00150793          	addi	a5,a0,1
    4dc2:	86be                	mv	a3,a5
    4dc4:	0785                	addi	a5,a5,1
    4dc6:	fff7c703          	lbu	a4,-1(a5)
    4dca:	ff65                	bnez	a4,4dc2 <strlen+0x12>
    4dcc:	40a6853b          	subw	a0,a3,a0
    ;
  return n;
}
    4dd0:	60a2                	ld	ra,8(sp)
    4dd2:	6402                	ld	s0,0(sp)
    4dd4:	0141                	addi	sp,sp,16
    4dd6:	8082                	ret
  for(n = 0; s[n]; n++)
    4dd8:	4501                	li	a0,0
    4dda:	bfdd                	j	4dd0 <strlen+0x20>

0000000000004ddc <memset>:

void*
memset(void *dst, int c, uint n)
{
    4ddc:	1141                	addi	sp,sp,-16
    4dde:	e406                	sd	ra,8(sp)
    4de0:	e022                	sd	s0,0(sp)
    4de2:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
    4de4:	ca19                	beqz	a2,4dfa <memset+0x1e>
    4de6:	87aa                	mv	a5,a0
    4de8:	1602                	slli	a2,a2,0x20
    4dea:	9201                	srli	a2,a2,0x20
    4dec:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
    4df0:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
    4df4:	0785                	addi	a5,a5,1
    4df6:	fee79de3          	bne	a5,a4,4df0 <memset+0x14>
  }
  return dst;
}
    4dfa:	60a2                	ld	ra,8(sp)
    4dfc:	6402                	ld	s0,0(sp)
    4dfe:	0141                	addi	sp,sp,16
    4e00:	8082                	ret

0000000000004e02 <strchr>:

char*
strchr(const char *s, char c)
{
    4e02:	1141                	addi	sp,sp,-16
    4e04:	e406                	sd	ra,8(sp)
    4e06:	e022                	sd	s0,0(sp)
    4e08:	0800                	addi	s0,sp,16
  for(; *s; s++)
    4e0a:	00054783          	lbu	a5,0(a0)
    4e0e:	cf81                	beqz	a5,4e26 <strchr+0x24>
    if(*s == c)
    4e10:	00f58763          	beq	a1,a5,4e1e <strchr+0x1c>
  for(; *s; s++)
    4e14:	0505                	addi	a0,a0,1
    4e16:	00054783          	lbu	a5,0(a0)
    4e1a:	fbfd                	bnez	a5,4e10 <strchr+0xe>
      return (char*)s;
  return 0;
    4e1c:	4501                	li	a0,0
}
    4e1e:	60a2                	ld	ra,8(sp)
    4e20:	6402                	ld	s0,0(sp)
    4e22:	0141                	addi	sp,sp,16
    4e24:	8082                	ret
  return 0;
    4e26:	4501                	li	a0,0
    4e28:	bfdd                	j	4e1e <strchr+0x1c>

0000000000004e2a <gets>:

char*
gets(char *buf, int max)
{
    4e2a:	711d                	addi	sp,sp,-96
    4e2c:	ec86                	sd	ra,88(sp)
    4e2e:	e8a2                	sd	s0,80(sp)
    4e30:	e4a6                	sd	s1,72(sp)
    4e32:	e0ca                	sd	s2,64(sp)
    4e34:	fc4e                	sd	s3,56(sp)
    4e36:	f852                	sd	s4,48(sp)
    4e38:	f456                	sd	s5,40(sp)
    4e3a:	f05a                	sd	s6,32(sp)
    4e3c:	ec5e                	sd	s7,24(sp)
    4e3e:	e862                	sd	s8,16(sp)
    4e40:	1080                	addi	s0,sp,96
    4e42:	8baa                	mv	s7,a0
    4e44:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
    4e46:	892a                	mv	s2,a0
    4e48:	4481                	li	s1,0
    cc = read(0, &c, 1);
    4e4a:	faf40b13          	addi	s6,s0,-81
    4e4e:	4a85                	li	s5,1
  for(i=0; i+1 < max; ){
    4e50:	8c26                	mv	s8,s1
    4e52:	0014899b          	addiw	s3,s1,1
    4e56:	84ce                	mv	s1,s3
    4e58:	0349d463          	bge	s3,s4,4e80 <gets+0x56>
    cc = read(0, &c, 1);
    4e5c:	8656                	mv	a2,s5
    4e5e:	85da                	mv	a1,s6
    4e60:	4501                	li	a0,0
    4e62:	1bc000ef          	jal	501e <read>
    if(cc < 1)
    4e66:	00a05d63          	blez	a0,4e80 <gets+0x56>
      break;
    buf[i++] = c;
    4e6a:	faf44783          	lbu	a5,-81(s0)
    4e6e:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
    4e72:	0905                	addi	s2,s2,1
    4e74:	ff678713          	addi	a4,a5,-10
    4e78:	c319                	beqz	a4,4e7e <gets+0x54>
    4e7a:	17cd                	addi	a5,a5,-13
    4e7c:	fbf1                	bnez	a5,4e50 <gets+0x26>
    buf[i++] = c;
    4e7e:	8c4e                	mv	s8,s3
      break;
  }
  buf[i] = '\0';
    4e80:	9c5e                	add	s8,s8,s7
    4e82:	000c0023          	sb	zero,0(s8)
  return buf;
}
    4e86:	855e                	mv	a0,s7
    4e88:	60e6                	ld	ra,88(sp)
    4e8a:	6446                	ld	s0,80(sp)
    4e8c:	64a6                	ld	s1,72(sp)
    4e8e:	6906                	ld	s2,64(sp)
    4e90:	79e2                	ld	s3,56(sp)
    4e92:	7a42                	ld	s4,48(sp)
    4e94:	7aa2                	ld	s5,40(sp)
    4e96:	7b02                	ld	s6,32(sp)
    4e98:	6be2                	ld	s7,24(sp)
    4e9a:	6c42                	ld	s8,16(sp)
    4e9c:	6125                	addi	sp,sp,96
    4e9e:	8082                	ret

0000000000004ea0 <stat>:

int
stat(const char *n, struct stat *st)
{
    4ea0:	1101                	addi	sp,sp,-32
    4ea2:	ec06                	sd	ra,24(sp)
    4ea4:	e822                	sd	s0,16(sp)
    4ea6:	e04a                	sd	s2,0(sp)
    4ea8:	1000                	addi	s0,sp,32
    4eaa:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
    4eac:	4581                	li	a1,0
    4eae:	198000ef          	jal	5046 <open>
  if(fd < 0)
    4eb2:	02054263          	bltz	a0,4ed6 <stat+0x36>
    4eb6:	e426                	sd	s1,8(sp)
    4eb8:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
    4eba:	85ca                	mv	a1,s2
    4ebc:	1a2000ef          	jal	505e <fstat>
    4ec0:	892a                	mv	s2,a0
  close(fd);
    4ec2:	8526                	mv	a0,s1
    4ec4:	16a000ef          	jal	502e <close>
  return r;
    4ec8:	64a2                	ld	s1,8(sp)
}
    4eca:	854a                	mv	a0,s2
    4ecc:	60e2                	ld	ra,24(sp)
    4ece:	6442                	ld	s0,16(sp)
    4ed0:	6902                	ld	s2,0(sp)
    4ed2:	6105                	addi	sp,sp,32
    4ed4:	8082                	ret
    return -1;
    4ed6:	57fd                	li	a5,-1
    4ed8:	893e                	mv	s2,a5
    4eda:	bfc5                	j	4eca <stat+0x2a>

0000000000004edc <atoi>:

int
atoi(const char *s)
{
    4edc:	1141                	addi	sp,sp,-16
    4ede:	e406                	sd	ra,8(sp)
    4ee0:	e022                	sd	s0,0(sp)
    4ee2:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
    4ee4:	00054683          	lbu	a3,0(a0)
    4ee8:	fd06879b          	addiw	a5,a3,-48 # 3ffd0 <base+0x2f348>
    4eec:	0ff7f793          	zext.b	a5,a5
    4ef0:	4625                	li	a2,9
    4ef2:	02f66963          	bltu	a2,a5,4f24 <atoi+0x48>
    4ef6:	872a                	mv	a4,a0
  n = 0;
    4ef8:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
    4efa:	0705                	addi	a4,a4,1 # 1000001 <base+0xfef379>
    4efc:	0025179b          	slliw	a5,a0,0x2
    4f00:	9fa9                	addw	a5,a5,a0
    4f02:	0017979b          	slliw	a5,a5,0x1
    4f06:	9fb5                	addw	a5,a5,a3
    4f08:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
    4f0c:	00074683          	lbu	a3,0(a4)
    4f10:	fd06879b          	addiw	a5,a3,-48
    4f14:	0ff7f793          	zext.b	a5,a5
    4f18:	fef671e3          	bgeu	a2,a5,4efa <atoi+0x1e>
  return n;
}
    4f1c:	60a2                	ld	ra,8(sp)
    4f1e:	6402                	ld	s0,0(sp)
    4f20:	0141                	addi	sp,sp,16
    4f22:	8082                	ret
  n = 0;
    4f24:	4501                	li	a0,0
    4f26:	bfdd                	j	4f1c <atoi+0x40>

0000000000004f28 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
    4f28:	1141                	addi	sp,sp,-16
    4f2a:	e406                	sd	ra,8(sp)
    4f2c:	e022                	sd	s0,0(sp)
    4f2e:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
    4f30:	02b57563          	bgeu	a0,a1,4f5a <memmove+0x32>
    while(n-- > 0)
    4f34:	00c05f63          	blez	a2,4f52 <memmove+0x2a>
    4f38:	1602                	slli	a2,a2,0x20
    4f3a:	9201                	srli	a2,a2,0x20
    4f3c:	00c507b3          	add	a5,a0,a2
  dst = vdst;
    4f40:	872a                	mv	a4,a0
      *dst++ = *src++;
    4f42:	0585                	addi	a1,a1,1
    4f44:	0705                	addi	a4,a4,1
    4f46:	fff5c683          	lbu	a3,-1(a1)
    4f4a:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
    4f4e:	fee79ae3          	bne	a5,a4,4f42 <memmove+0x1a>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
    4f52:	60a2                	ld	ra,8(sp)
    4f54:	6402                	ld	s0,0(sp)
    4f56:	0141                	addi	sp,sp,16
    4f58:	8082                	ret
    while(n-- > 0)
    4f5a:	fec05ce3          	blez	a2,4f52 <memmove+0x2a>
    dst += n;
    4f5e:	00c50733          	add	a4,a0,a2
    src += n;
    4f62:	95b2                	add	a1,a1,a2
    4f64:	fff6079b          	addiw	a5,a2,-1
    4f68:	1782                	slli	a5,a5,0x20
    4f6a:	9381                	srli	a5,a5,0x20
    4f6c:	fff7c793          	not	a5,a5
    4f70:	97ba                	add	a5,a5,a4
      *--dst = *--src;
    4f72:	15fd                	addi	a1,a1,-1
    4f74:	177d                	addi	a4,a4,-1
    4f76:	0005c683          	lbu	a3,0(a1)
    4f7a:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
    4f7e:	fef71ae3          	bne	a4,a5,4f72 <memmove+0x4a>
    4f82:	bfc1                	j	4f52 <memmove+0x2a>

0000000000004f84 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
    4f84:	1141                	addi	sp,sp,-16
    4f86:	e406                	sd	ra,8(sp)
    4f88:	e022                	sd	s0,0(sp)
    4f8a:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
    4f8c:	c61d                	beqz	a2,4fba <memcmp+0x36>
    4f8e:	1602                	slli	a2,a2,0x20
    4f90:	9201                	srli	a2,a2,0x20
    4f92:	00c506b3          	add	a3,a0,a2
    if (*p1 != *p2) {
    4f96:	00054783          	lbu	a5,0(a0)
    4f9a:	0005c703          	lbu	a4,0(a1)
    4f9e:	00e79863          	bne	a5,a4,4fae <memcmp+0x2a>
      return *p1 - *p2;
    }
    p1++;
    4fa2:	0505                	addi	a0,a0,1
    p2++;
    4fa4:	0585                	addi	a1,a1,1
  while (n-- > 0) {
    4fa6:	fed518e3          	bne	a0,a3,4f96 <memcmp+0x12>
  }
  return 0;
    4faa:	4501                	li	a0,0
    4fac:	a019                	j	4fb2 <memcmp+0x2e>
      return *p1 - *p2;
    4fae:	40e7853b          	subw	a0,a5,a4
}
    4fb2:	60a2                	ld	ra,8(sp)
    4fb4:	6402                	ld	s0,0(sp)
    4fb6:	0141                	addi	sp,sp,16
    4fb8:	8082                	ret
  return 0;
    4fba:	4501                	li	a0,0
    4fbc:	bfdd                	j	4fb2 <memcmp+0x2e>

0000000000004fbe <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
    4fbe:	1141                	addi	sp,sp,-16
    4fc0:	e406                	sd	ra,8(sp)
    4fc2:	e022                	sd	s0,0(sp)
    4fc4:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
    4fc6:	f63ff0ef          	jal	4f28 <memmove>
}
    4fca:	60a2                	ld	ra,8(sp)
    4fcc:	6402                	ld	s0,0(sp)
    4fce:	0141                	addi	sp,sp,16
    4fd0:	8082                	ret

0000000000004fd2 <sbrk>:

char *
sbrk(int n) {
    4fd2:	1141                	addi	sp,sp,-16
    4fd4:	e406                	sd	ra,8(sp)
    4fd6:	e022                	sd	s0,0(sp)
    4fd8:	0800                	addi	s0,sp,16
  return sys_sbrk(n, SBRK_EAGER);
    4fda:	4585                	li	a1,1
    4fdc:	0b2000ef          	jal	508e <sys_sbrk>
}
    4fe0:	60a2                	ld	ra,8(sp)
    4fe2:	6402                	ld	s0,0(sp)
    4fe4:	0141                	addi	sp,sp,16
    4fe6:	8082                	ret

0000000000004fe8 <sbrklazy>:

char *
sbrklazy(int n) {
    4fe8:	1141                	addi	sp,sp,-16
    4fea:	e406                	sd	ra,8(sp)
    4fec:	e022                	sd	s0,0(sp)
    4fee:	0800                	addi	s0,sp,16
  return sys_sbrk(n, SBRK_LAZY);
    4ff0:	4589                	li	a1,2
    4ff2:	09c000ef          	jal	508e <sys_sbrk>
}
    4ff6:	60a2                	ld	ra,8(sp)
    4ff8:	6402                	ld	s0,0(sp)
    4ffa:	0141                	addi	sp,sp,16
    4ffc:	8082                	ret

0000000000004ffe <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
    4ffe:	4885                	li	a7,1
 ecall
    5000:	00000073          	ecall
 ret
    5004:	8082                	ret

0000000000005006 <exit>:
.global exit
exit:
 li a7, SYS_exit
    5006:	4889                	li	a7,2
 ecall
    5008:	00000073          	ecall
 ret
    500c:	8082                	ret

000000000000500e <wait>:
.global wait
wait:
 li a7, SYS_wait
    500e:	488d                	li	a7,3
 ecall
    5010:	00000073          	ecall
 ret
    5014:	8082                	ret

0000000000005016 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
    5016:	4891                	li	a7,4
 ecall
    5018:	00000073          	ecall
 ret
    501c:	8082                	ret

000000000000501e <read>:
.global read
read:
 li a7, SYS_read
    501e:	4895                	li	a7,5
 ecall
    5020:	00000073          	ecall
 ret
    5024:	8082                	ret

0000000000005026 <write>:
.global write
write:
 li a7, SYS_write
    5026:	48c1                	li	a7,16
 ecall
    5028:	00000073          	ecall
 ret
    502c:	8082                	ret

000000000000502e <close>:
.global close
close:
 li a7, SYS_close
    502e:	48d5                	li	a7,21
 ecall
    5030:	00000073          	ecall
 ret
    5034:	8082                	ret

0000000000005036 <kill>:
.global kill
kill:
 li a7, SYS_kill
    5036:	4899                	li	a7,6
 ecall
    5038:	00000073          	ecall
 ret
    503c:	8082                	ret

000000000000503e <exec>:
.global exec
exec:
 li a7, SYS_exec
    503e:	489d                	li	a7,7
 ecall
    5040:	00000073          	ecall
 ret
    5044:	8082                	ret

0000000000005046 <open>:
.global open
open:
 li a7, SYS_open
    5046:	48bd                	li	a7,15
 ecall
    5048:	00000073          	ecall
 ret
    504c:	8082                	ret

000000000000504e <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
    504e:	48c5                	li	a7,17
 ecall
    5050:	00000073          	ecall
 ret
    5054:	8082                	ret

0000000000005056 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
    5056:	48c9                	li	a7,18
 ecall
    5058:	00000073          	ecall
 ret
    505c:	8082                	ret

000000000000505e <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
    505e:	48a1                	li	a7,8
 ecall
    5060:	00000073          	ecall
 ret
    5064:	8082                	ret

0000000000005066 <link>:
.global link
link:
 li a7, SYS_link
    5066:	48cd                	li	a7,19
 ecall
    5068:	00000073          	ecall
 ret
    506c:	8082                	ret

000000000000506e <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
    506e:	48d1                	li	a7,20
 ecall
    5070:	00000073          	ecall
 ret
    5074:	8082                	ret

0000000000005076 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
    5076:	48a5                	li	a7,9
 ecall
    5078:	00000073          	ecall
 ret
    507c:	8082                	ret

000000000000507e <dup>:
.global dup
dup:
 li a7, SYS_dup
    507e:	48a9                	li	a7,10
 ecall
    5080:	00000073          	ecall
 ret
    5084:	8082                	ret

0000000000005086 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
    5086:	48ad                	li	a7,11
 ecall
    5088:	00000073          	ecall
 ret
    508c:	8082                	ret

000000000000508e <sys_sbrk>:
.global sys_sbrk
sys_sbrk:
 li a7, SYS_sbrk
    508e:	48b1                	li	a7,12
 ecall
    5090:	00000073          	ecall
 ret
    5094:	8082                	ret

0000000000005096 <pause>:
.global pause
pause:
 li a7, SYS_pause
    5096:	48b5                	li	a7,13
 ecall
    5098:	00000073          	ecall
 ret
    509c:	8082                	ret

000000000000509e <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
    509e:	48b9                	li	a7,14
 ecall
    50a0:	00000073          	ecall
 ret
    50a4:	8082                	ret

00000000000050a6 <memstat>:
.global memstat
memstat:
 li a7, SYS_memstat
    50a6:	48d9                	li	a7,22
 ecall
    50a8:	00000073          	ecall
 ret
    50ac:	8082                	ret

00000000000050ae <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
    50ae:	1101                	addi	sp,sp,-32
    50b0:	ec06                	sd	ra,24(sp)
    50b2:	e822                	sd	s0,16(sp)
    50b4:	1000                	addi	s0,sp,32
    50b6:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
    50ba:	4605                	li	a2,1
    50bc:	fef40593          	addi	a1,s0,-17
    50c0:	f67ff0ef          	jal	5026 <write>
}
    50c4:	60e2                	ld	ra,24(sp)
    50c6:	6442                	ld	s0,16(sp)
    50c8:	6105                	addi	sp,sp,32
    50ca:	8082                	ret

00000000000050cc <printint>:

static void
printint(int fd, long long xx, int base, int sgn)
{
    50cc:	715d                	addi	sp,sp,-80
    50ce:	e486                	sd	ra,72(sp)
    50d0:	e0a2                	sd	s0,64(sp)
    50d2:	f84a                	sd	s2,48(sp)
    50d4:	f44e                	sd	s3,40(sp)
    50d6:	0880                	addi	s0,sp,80
    50d8:	892a                	mv	s2,a0
  char buf[20];
  int i, neg;
  unsigned long long x;

  neg = 0;
  if(sgn && xx < 0){
    50da:	c6d1                	beqz	a3,5166 <printint+0x9a>
    50dc:	0805d563          	bgez	a1,5166 <printint+0x9a>
    neg = 1;
    x = -xx;
    50e0:	40b005b3          	neg	a1,a1
    neg = 1;
    50e4:	4305                	li	t1,1
  } else {
    x = xx;
  }

  i = 0;
    50e6:	fb840993          	addi	s3,s0,-72
  neg = 0;
    50ea:	86ce                	mv	a3,s3
  i = 0;
    50ec:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
    50ee:	00003817          	auipc	a6,0x3
    50f2:	b1280813          	addi	a6,a6,-1262 # 7c00 <digits>
    50f6:	88ba                	mv	a7,a4
    50f8:	0017051b          	addiw	a0,a4,1
    50fc:	872a                	mv	a4,a0
    50fe:	02c5f7b3          	remu	a5,a1,a2
    5102:	97c2                	add	a5,a5,a6
    5104:	0007c783          	lbu	a5,0(a5)
    5108:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
    510c:	87ae                	mv	a5,a1
    510e:	02c5d5b3          	divu	a1,a1,a2
    5112:	0685                	addi	a3,a3,1
    5114:	fec7f1e3          	bgeu	a5,a2,50f6 <printint+0x2a>
  if(neg)
    5118:	00030c63          	beqz	t1,5130 <printint+0x64>
    buf[i++] = '-';
    511c:	fd050793          	addi	a5,a0,-48
    5120:	00878533          	add	a0,a5,s0
    5124:	02d00793          	li	a5,45
    5128:	fef50423          	sb	a5,-24(a0)
    512c:	0028871b          	addiw	a4,a7,2

  while(--i >= 0)
    5130:	02e05563          	blez	a4,515a <printint+0x8e>
    5134:	fc26                	sd	s1,56(sp)
    5136:	377d                	addiw	a4,a4,-1
    5138:	00e984b3          	add	s1,s3,a4
    513c:	19fd                	addi	s3,s3,-1
    513e:	99ba                	add	s3,s3,a4
    5140:	1702                	slli	a4,a4,0x20
    5142:	9301                	srli	a4,a4,0x20
    5144:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
    5148:	0004c583          	lbu	a1,0(s1)
    514c:	854a                	mv	a0,s2
    514e:	f61ff0ef          	jal	50ae <putc>
  while(--i >= 0)
    5152:	14fd                	addi	s1,s1,-1
    5154:	ff349ae3          	bne	s1,s3,5148 <printint+0x7c>
    5158:	74e2                	ld	s1,56(sp)
}
    515a:	60a6                	ld	ra,72(sp)
    515c:	6406                	ld	s0,64(sp)
    515e:	7942                	ld	s2,48(sp)
    5160:	79a2                	ld	s3,40(sp)
    5162:	6161                	addi	sp,sp,80
    5164:	8082                	ret
  neg = 0;
    5166:	4301                	li	t1,0
    5168:	bfbd                	j	50e6 <printint+0x1a>

000000000000516a <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %c, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
    516a:	711d                	addi	sp,sp,-96
    516c:	ec86                	sd	ra,88(sp)
    516e:	e8a2                	sd	s0,80(sp)
    5170:	e4a6                	sd	s1,72(sp)
    5172:	1080                	addi	s0,sp,96
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
    5174:	0005c483          	lbu	s1,0(a1)
    5178:	22048363          	beqz	s1,539e <vprintf+0x234>
    517c:	e0ca                	sd	s2,64(sp)
    517e:	fc4e                	sd	s3,56(sp)
    5180:	f852                	sd	s4,48(sp)
    5182:	f456                	sd	s5,40(sp)
    5184:	f05a                	sd	s6,32(sp)
    5186:	ec5e                	sd	s7,24(sp)
    5188:	e862                	sd	s8,16(sp)
    518a:	8b2a                	mv	s6,a0
    518c:	8a2e                	mv	s4,a1
    518e:	8bb2                	mv	s7,a2
  state = 0;
    5190:	4981                	li	s3,0
  for(i = 0; fmt[i]; i++){
    5192:	4901                	li	s2,0
    5194:	4701                	li	a4,0
      if(c0 == '%'){
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if(state == '%'){
    5196:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if(c0) c1 = fmt[i+1] & 0xff;
      if(c1) c2 = fmt[i+2] & 0xff;
      if(c0 == 'd'){
    519a:	06400c13          	li	s8,100
    519e:	a00d                	j	51c0 <vprintf+0x56>
        putc(fd, c0);
    51a0:	85a6                	mv	a1,s1
    51a2:	855a                	mv	a0,s6
    51a4:	f0bff0ef          	jal	50ae <putc>
    51a8:	a019                	j	51ae <vprintf+0x44>
    } else if(state == '%'){
    51aa:	03598363          	beq	s3,s5,51d0 <vprintf+0x66>
  for(i = 0; fmt[i]; i++){
    51ae:	0019079b          	addiw	a5,s2,1
    51b2:	893e                	mv	s2,a5
    51b4:	873e                	mv	a4,a5
    51b6:	97d2                	add	a5,a5,s4
    51b8:	0007c483          	lbu	s1,0(a5)
    51bc:	1c048a63          	beqz	s1,5390 <vprintf+0x226>
    c0 = fmt[i] & 0xff;
    51c0:	0004879b          	sext.w	a5,s1
    if(state == 0){
    51c4:	fe0993e3          	bnez	s3,51aa <vprintf+0x40>
      if(c0 == '%'){
    51c8:	fd579ce3          	bne	a5,s5,51a0 <vprintf+0x36>
        state = '%';
    51cc:	89be                	mv	s3,a5
    51ce:	b7c5                	j	51ae <vprintf+0x44>
      if(c0) c1 = fmt[i+1] & 0xff;
    51d0:	00ea06b3          	add	a3,s4,a4
    51d4:	0016c603          	lbu	a2,1(a3)
      if(c1) c2 = fmt[i+2] & 0xff;
    51d8:	1c060863          	beqz	a2,53a8 <vprintf+0x23e>
      if(c0 == 'd'){
    51dc:	03878763          	beq	a5,s8,520a <vprintf+0xa0>
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c0 == 'l' && c1 == 'd'){
    51e0:	f9478693          	addi	a3,a5,-108
    51e4:	0016b693          	seqz	a3,a3
    51e8:	f9c60593          	addi	a1,a2,-100
    51ec:	e99d                	bnez	a1,5222 <vprintf+0xb8>
    51ee:	ca95                	beqz	a3,5222 <vprintf+0xb8>
        printint(fd, va_arg(ap, uint64), 10, 1);
    51f0:	008b8493          	addi	s1,s7,8
    51f4:	4685                	li	a3,1
    51f6:	4629                	li	a2,10
    51f8:	000bb583          	ld	a1,0(s7)
    51fc:	855a                	mv	a0,s6
    51fe:	ecfff0ef          	jal	50cc <printint>
        i += 1;
    5202:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 10, 1);
    5204:	8ba6                	mv	s7,s1
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c0);
      }

      state = 0;
    5206:	4981                	li	s3,0
    5208:	b75d                	j	51ae <vprintf+0x44>
        printint(fd, va_arg(ap, int), 10, 1);
    520a:	008b8493          	addi	s1,s7,8
    520e:	4685                	li	a3,1
    5210:	4629                	li	a2,10
    5212:	000ba583          	lw	a1,0(s7)
    5216:	855a                	mv	a0,s6
    5218:	eb5ff0ef          	jal	50cc <printint>
    521c:	8ba6                	mv	s7,s1
      state = 0;
    521e:	4981                	li	s3,0
    5220:	b779                	j	51ae <vprintf+0x44>
      if(c1) c2 = fmt[i+2] & 0xff;
    5222:	9752                	add	a4,a4,s4
    5224:	00274583          	lbu	a1,2(a4)
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
    5228:	f9460713          	addi	a4,a2,-108
    522c:	00173713          	seqz	a4,a4
    5230:	8f75                	and	a4,a4,a3
    5232:	f9c58513          	addi	a0,a1,-100
    5236:	18051363          	bnez	a0,53bc <vprintf+0x252>
    523a:	18070163          	beqz	a4,53bc <vprintf+0x252>
        printint(fd, va_arg(ap, uint64), 10, 1);
    523e:	008b8493          	addi	s1,s7,8
    5242:	4685                	li	a3,1
    5244:	4629                	li	a2,10
    5246:	000bb583          	ld	a1,0(s7)
    524a:	855a                	mv	a0,s6
    524c:	e81ff0ef          	jal	50cc <printint>
        i += 2;
    5250:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 10, 1);
    5252:	8ba6                	mv	s7,s1
      state = 0;
    5254:	4981                	li	s3,0
        i += 2;
    5256:	bfa1                	j	51ae <vprintf+0x44>
        printint(fd, va_arg(ap, uint32), 10, 0);
    5258:	008b8493          	addi	s1,s7,8
    525c:	4681                	li	a3,0
    525e:	4629                	li	a2,10
    5260:	000be583          	lwu	a1,0(s7)
    5264:	855a                	mv	a0,s6
    5266:	e67ff0ef          	jal	50cc <printint>
    526a:	8ba6                	mv	s7,s1
      state = 0;
    526c:	4981                	li	s3,0
    526e:	b781                	j	51ae <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 10, 0);
    5270:	008b8493          	addi	s1,s7,8
    5274:	4681                	li	a3,0
    5276:	4629                	li	a2,10
    5278:	000bb583          	ld	a1,0(s7)
    527c:	855a                	mv	a0,s6
    527e:	e4fff0ef          	jal	50cc <printint>
        i += 1;
    5282:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 10, 0);
    5284:	8ba6                	mv	s7,s1
      state = 0;
    5286:	4981                	li	s3,0
    5288:	b71d                	j	51ae <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 10, 0);
    528a:	008b8493          	addi	s1,s7,8
    528e:	4681                	li	a3,0
    5290:	4629                	li	a2,10
    5292:	000bb583          	ld	a1,0(s7)
    5296:	855a                	mv	a0,s6
    5298:	e35ff0ef          	jal	50cc <printint>
        i += 2;
    529c:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 10, 0);
    529e:	8ba6                	mv	s7,s1
      state = 0;
    52a0:	4981                	li	s3,0
        i += 2;
    52a2:	b731                	j	51ae <vprintf+0x44>
        printint(fd, va_arg(ap, uint32), 16, 0);
    52a4:	008b8493          	addi	s1,s7,8
    52a8:	4681                	li	a3,0
    52aa:	4641                	li	a2,16
    52ac:	000be583          	lwu	a1,0(s7)
    52b0:	855a                	mv	a0,s6
    52b2:	e1bff0ef          	jal	50cc <printint>
    52b6:	8ba6                	mv	s7,s1
      state = 0;
    52b8:	4981                	li	s3,0
    52ba:	bdd5                	j	51ae <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 16, 0);
    52bc:	008b8493          	addi	s1,s7,8
    52c0:	4681                	li	a3,0
    52c2:	4641                	li	a2,16
    52c4:	000bb583          	ld	a1,0(s7)
    52c8:	855a                	mv	a0,s6
    52ca:	e03ff0ef          	jal	50cc <printint>
        i += 1;
    52ce:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 16, 0);
    52d0:	8ba6                	mv	s7,s1
      state = 0;
    52d2:	4981                	li	s3,0
    52d4:	bde9                	j	51ae <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 16, 0);
    52d6:	008b8493          	addi	s1,s7,8
    52da:	4681                	li	a3,0
    52dc:	4641                	li	a2,16
    52de:	000bb583          	ld	a1,0(s7)
    52e2:	855a                	mv	a0,s6
    52e4:	de9ff0ef          	jal	50cc <printint>
        i += 2;
    52e8:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 16, 0);
    52ea:	8ba6                	mv	s7,s1
      state = 0;
    52ec:	4981                	li	s3,0
        i += 2;
    52ee:	b5c1                	j	51ae <vprintf+0x44>
    52f0:	e466                	sd	s9,8(sp)
        printptr(fd, va_arg(ap, uint64));
    52f2:	008b8793          	addi	a5,s7,8
    52f6:	8cbe                	mv	s9,a5
    52f8:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
    52fc:	03000593          	li	a1,48
    5300:	855a                	mv	a0,s6
    5302:	dadff0ef          	jal	50ae <putc>
  putc(fd, 'x');
    5306:	07800593          	li	a1,120
    530a:	855a                	mv	a0,s6
    530c:	da3ff0ef          	jal	50ae <putc>
    5310:	44c1                	li	s1,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
    5312:	00003b97          	auipc	s7,0x3
    5316:	8eeb8b93          	addi	s7,s7,-1810 # 7c00 <digits>
    531a:	03c9d793          	srli	a5,s3,0x3c
    531e:	97de                	add	a5,a5,s7
    5320:	0007c583          	lbu	a1,0(a5)
    5324:	855a                	mv	a0,s6
    5326:	d89ff0ef          	jal	50ae <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
    532a:	0992                	slli	s3,s3,0x4
    532c:	34fd                	addiw	s1,s1,-1
    532e:	f4f5                	bnez	s1,531a <vprintf+0x1b0>
        printptr(fd, va_arg(ap, uint64));
    5330:	8be6                	mv	s7,s9
      state = 0;
    5332:	4981                	li	s3,0
    5334:	6ca2                	ld	s9,8(sp)
    5336:	bda5                	j	51ae <vprintf+0x44>
        putc(fd, va_arg(ap, uint32));
    5338:	008b8493          	addi	s1,s7,8
    533c:	000bc583          	lbu	a1,0(s7)
    5340:	855a                	mv	a0,s6
    5342:	d6dff0ef          	jal	50ae <putc>
    5346:	8ba6                	mv	s7,s1
      state = 0;
    5348:	4981                	li	s3,0
    534a:	b595                	j	51ae <vprintf+0x44>
        if((s = va_arg(ap, char*)) == 0)
    534c:	008b8993          	addi	s3,s7,8
    5350:	000bb483          	ld	s1,0(s7)
    5354:	cc91                	beqz	s1,5370 <vprintf+0x206>
        for(; *s; s++)
    5356:	0004c583          	lbu	a1,0(s1)
    535a:	c985                	beqz	a1,538a <vprintf+0x220>
          putc(fd, *s);
    535c:	855a                	mv	a0,s6
    535e:	d51ff0ef          	jal	50ae <putc>
        for(; *s; s++)
    5362:	0485                	addi	s1,s1,1
    5364:	0004c583          	lbu	a1,0(s1)
    5368:	f9f5                	bnez	a1,535c <vprintf+0x1f2>
        if((s = va_arg(ap, char*)) == 0)
    536a:	8bce                	mv	s7,s3
      state = 0;
    536c:	4981                	li	s3,0
    536e:	b581                	j	51ae <vprintf+0x44>
          s = "(null)";
    5370:	00002497          	auipc	s1,0x2
    5374:	7e048493          	addi	s1,s1,2016 # 7b50 <malloc+0x2644>
        for(; *s; s++)
    5378:	02800593          	li	a1,40
    537c:	b7c5                	j	535c <vprintf+0x1f2>
        putc(fd, '%');
    537e:	85be                	mv	a1,a5
    5380:	855a                	mv	a0,s6
    5382:	d2dff0ef          	jal	50ae <putc>
      state = 0;
    5386:	4981                	li	s3,0
    5388:	b51d                	j	51ae <vprintf+0x44>
        if((s = va_arg(ap, char*)) == 0)
    538a:	8bce                	mv	s7,s3
      state = 0;
    538c:	4981                	li	s3,0
    538e:	b505                	j	51ae <vprintf+0x44>
    5390:	6906                	ld	s2,64(sp)
    5392:	79e2                	ld	s3,56(sp)
    5394:	7a42                	ld	s4,48(sp)
    5396:	7aa2                	ld	s5,40(sp)
    5398:	7b02                	ld	s6,32(sp)
    539a:	6be2                	ld	s7,24(sp)
    539c:	6c42                	ld	s8,16(sp)
    }
  }
}
    539e:	60e6                	ld	ra,88(sp)
    53a0:	6446                	ld	s0,80(sp)
    53a2:	64a6                	ld	s1,72(sp)
    53a4:	6125                	addi	sp,sp,96
    53a6:	8082                	ret
      if(c0 == 'd'){
    53a8:	06400713          	li	a4,100
    53ac:	e4e78fe3          	beq	a5,a4,520a <vprintf+0xa0>
      } else if(c0 == 'l' && c1 == 'd'){
    53b0:	f9478693          	addi	a3,a5,-108
    53b4:	0016b693          	seqz	a3,a3
      c1 = c2 = 0;
    53b8:	85b2                	mv	a1,a2
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
    53ba:	4701                	li	a4,0
      } else if(c0 == 'u'){
    53bc:	07500513          	li	a0,117
    53c0:	e8a78ce3          	beq	a5,a0,5258 <vprintf+0xee>
      } else if(c0 == 'l' && c1 == 'u'){
    53c4:	f8b60513          	addi	a0,a2,-117
    53c8:	e119                	bnez	a0,53ce <vprintf+0x264>
    53ca:	ea0693e3          	bnez	a3,5270 <vprintf+0x106>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
    53ce:	f8b58513          	addi	a0,a1,-117
    53d2:	e119                	bnez	a0,53d8 <vprintf+0x26e>
    53d4:	ea071be3          	bnez	a4,528a <vprintf+0x120>
      } else if(c0 == 'x'){
    53d8:	07800513          	li	a0,120
    53dc:	eca784e3          	beq	a5,a0,52a4 <vprintf+0x13a>
      } else if(c0 == 'l' && c1 == 'x'){
    53e0:	f8860613          	addi	a2,a2,-120
    53e4:	e219                	bnez	a2,53ea <vprintf+0x280>
    53e6:	ec069be3          	bnez	a3,52bc <vprintf+0x152>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
    53ea:	f8858593          	addi	a1,a1,-120
    53ee:	e199                	bnez	a1,53f4 <vprintf+0x28a>
    53f0:	ee0713e3          	bnez	a4,52d6 <vprintf+0x16c>
      } else if(c0 == 'p'){
    53f4:	07000713          	li	a4,112
    53f8:	eee78ce3          	beq	a5,a4,52f0 <vprintf+0x186>
      } else if(c0 == 'c'){
    53fc:	06300713          	li	a4,99
    5400:	f2e78ce3          	beq	a5,a4,5338 <vprintf+0x1ce>
      } else if(c0 == 's'){
    5404:	07300713          	li	a4,115
    5408:	f4e782e3          	beq	a5,a4,534c <vprintf+0x1e2>
      } else if(c0 == '%'){
    540c:	02500713          	li	a4,37
    5410:	f6e787e3          	beq	a5,a4,537e <vprintf+0x214>
        putc(fd, '%');
    5414:	02500593          	li	a1,37
    5418:	855a                	mv	a0,s6
    541a:	c95ff0ef          	jal	50ae <putc>
        putc(fd, c0);
    541e:	85a6                	mv	a1,s1
    5420:	855a                	mv	a0,s6
    5422:	c8dff0ef          	jal	50ae <putc>
      state = 0;
    5426:	4981                	li	s3,0
    5428:	b359                	j	51ae <vprintf+0x44>

000000000000542a <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
    542a:	715d                	addi	sp,sp,-80
    542c:	ec06                	sd	ra,24(sp)
    542e:	e822                	sd	s0,16(sp)
    5430:	1000                	addi	s0,sp,32
    5432:	e010                	sd	a2,0(s0)
    5434:	e414                	sd	a3,8(s0)
    5436:	e818                	sd	a4,16(s0)
    5438:	ec1c                	sd	a5,24(s0)
    543a:	03043023          	sd	a6,32(s0)
    543e:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
    5442:	8622                	mv	a2,s0
    5444:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
    5448:	d23ff0ef          	jal	516a <vprintf>
}
    544c:	60e2                	ld	ra,24(sp)
    544e:	6442                	ld	s0,16(sp)
    5450:	6161                	addi	sp,sp,80
    5452:	8082                	ret

0000000000005454 <printf>:

void
printf(const char *fmt, ...)
{
    5454:	711d                	addi	sp,sp,-96
    5456:	ec06                	sd	ra,24(sp)
    5458:	e822                	sd	s0,16(sp)
    545a:	1000                	addi	s0,sp,32
    545c:	e40c                	sd	a1,8(s0)
    545e:	e810                	sd	a2,16(s0)
    5460:	ec14                	sd	a3,24(s0)
    5462:	f018                	sd	a4,32(s0)
    5464:	f41c                	sd	a5,40(s0)
    5466:	03043823          	sd	a6,48(s0)
    546a:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
    546e:	00840613          	addi	a2,s0,8
    5472:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
    5476:	85aa                	mv	a1,a0
    5478:	4505                	li	a0,1
    547a:	cf1ff0ef          	jal	516a <vprintf>
}
    547e:	60e2                	ld	ra,24(sp)
    5480:	6442                	ld	s0,16(sp)
    5482:	6125                	addi	sp,sp,96
    5484:	8082                	ret

0000000000005486 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
    5486:	1141                	addi	sp,sp,-16
    5488:	e406                	sd	ra,8(sp)
    548a:	e022                	sd	s0,0(sp)
    548c:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
    548e:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    5492:	00005797          	auipc	a5,0x5
    5496:	fce7b783          	ld	a5,-50(a5) # a460 <freep>
    549a:	a039                	j	54a8 <free+0x22>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    549c:	6398                	ld	a4,0(a5)
    549e:	00e7e463          	bltu	a5,a4,54a6 <free+0x20>
    54a2:	00e6ea63          	bltu	a3,a4,54b6 <free+0x30>
{
    54a6:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    54a8:	fed7fae3          	bgeu	a5,a3,549c <free+0x16>
    54ac:	6398                	ld	a4,0(a5)
    54ae:	00e6e463          	bltu	a3,a4,54b6 <free+0x30>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    54b2:	fee7eae3          	bltu	a5,a4,54a6 <free+0x20>
      break;
  if(bp + bp->s.size == p->s.ptr){
    54b6:	ff852583          	lw	a1,-8(a0)
    54ba:	6390                	ld	a2,0(a5)
    54bc:	02059813          	slli	a6,a1,0x20
    54c0:	01c85713          	srli	a4,a6,0x1c
    54c4:	9736                	add	a4,a4,a3
    54c6:	02e60563          	beq	a2,a4,54f0 <free+0x6a>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
    54ca:	fec53823          	sd	a2,-16(a0)
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    54ce:	4790                	lw	a2,8(a5)
    54d0:	02061593          	slli	a1,a2,0x20
    54d4:	01c5d713          	srli	a4,a1,0x1c
    54d8:	973e                	add	a4,a4,a5
    54da:	02e68263          	beq	a3,a4,54fe <free+0x78>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
    54de:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
    54e0:	00005717          	auipc	a4,0x5
    54e4:	f8f73023          	sd	a5,-128(a4) # a460 <freep>
}
    54e8:	60a2                	ld	ra,8(sp)
    54ea:	6402                	ld	s0,0(sp)
    54ec:	0141                	addi	sp,sp,16
    54ee:	8082                	ret
    bp->s.size += p->s.ptr->s.size;
    54f0:	4618                	lw	a4,8(a2)
    54f2:	9f2d                	addw	a4,a4,a1
    54f4:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
    54f8:	6398                	ld	a4,0(a5)
    54fa:	6310                	ld	a2,0(a4)
    54fc:	b7f9                	j	54ca <free+0x44>
    p->s.size += bp->s.size;
    54fe:	ff852703          	lw	a4,-8(a0)
    5502:	9f31                	addw	a4,a4,a2
    5504:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
    5506:	ff053683          	ld	a3,-16(a0)
    550a:	bfd1                	j	54de <free+0x58>

000000000000550c <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
    550c:	7139                	addi	sp,sp,-64
    550e:	fc06                	sd	ra,56(sp)
    5510:	f822                	sd	s0,48(sp)
    5512:	f04a                	sd	s2,32(sp)
    5514:	ec4e                	sd	s3,24(sp)
    5516:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
    5518:	02051993          	slli	s3,a0,0x20
    551c:	0209d993          	srli	s3,s3,0x20
    5520:	09bd                	addi	s3,s3,15
    5522:	0049d993          	srli	s3,s3,0x4
    5526:	2985                	addiw	s3,s3,1
    5528:	894e                	mv	s2,s3
  if((prevp = freep) == 0){
    552a:	00005517          	auipc	a0,0x5
    552e:	f3653503          	ld	a0,-202(a0) # a460 <freep>
    5532:	c905                	beqz	a0,5562 <malloc+0x56>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    5534:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
    5536:	4798                	lw	a4,8(a5)
    5538:	09377663          	bgeu	a4,s3,55c4 <malloc+0xb8>
    553c:	f426                	sd	s1,40(sp)
    553e:	e852                	sd	s4,16(sp)
    5540:	e456                	sd	s5,8(sp)
    5542:	e05a                	sd	s6,0(sp)
  if(nu < 4096)
    5544:	8a4e                	mv	s4,s3
    5546:	6705                	lui	a4,0x1
    5548:	00e9f363          	bgeu	s3,a4,554e <malloc+0x42>
    554c:	6a05                	lui	s4,0x1
    554e:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
    5552:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
    5556:	00005497          	auipc	s1,0x5
    555a:	f0a48493          	addi	s1,s1,-246 # a460 <freep>
  if(p == SBRK_ERROR)
    555e:	5afd                	li	s5,-1
    5560:	a83d                	j	559e <malloc+0x92>
    5562:	f426                	sd	s1,40(sp)
    5564:	e852                	sd	s4,16(sp)
    5566:	e456                	sd	s5,8(sp)
    5568:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
    556a:	0000b797          	auipc	a5,0xb
    556e:	71e78793          	addi	a5,a5,1822 # 10c88 <base>
    5572:	00005717          	auipc	a4,0x5
    5576:	eef73723          	sd	a5,-274(a4) # a460 <freep>
    557a:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
    557c:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
    5580:	b7d1                	j	5544 <malloc+0x38>
        prevp->s.ptr = p->s.ptr;
    5582:	6398                	ld	a4,0(a5)
    5584:	e118                	sd	a4,0(a0)
    5586:	a899                	j	55dc <malloc+0xd0>
  hp->s.size = nu;
    5588:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
    558c:	0541                	addi	a0,a0,16
    558e:	ef9ff0ef          	jal	5486 <free>
  return freep;
    5592:	6088                	ld	a0,0(s1)
      if((p = morecore(nunits)) == 0)
    5594:	c125                	beqz	a0,55f4 <malloc+0xe8>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    5596:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
    5598:	4798                	lw	a4,8(a5)
    559a:	03277163          	bgeu	a4,s2,55bc <malloc+0xb0>
    if(p == freep)
    559e:	6098                	ld	a4,0(s1)
    55a0:	853e                	mv	a0,a5
    55a2:	fef71ae3          	bne	a4,a5,5596 <malloc+0x8a>
  p = sbrk(nu * sizeof(Header));
    55a6:	8552                	mv	a0,s4
    55a8:	a2bff0ef          	jal	4fd2 <sbrk>
  if(p == SBRK_ERROR)
    55ac:	fd551ee3          	bne	a0,s5,5588 <malloc+0x7c>
        return 0;
    55b0:	4501                	li	a0,0
    55b2:	74a2                	ld	s1,40(sp)
    55b4:	6a42                	ld	s4,16(sp)
    55b6:	6aa2                	ld	s5,8(sp)
    55b8:	6b02                	ld	s6,0(sp)
    55ba:	a03d                	j	55e8 <malloc+0xdc>
    55bc:	74a2                	ld	s1,40(sp)
    55be:	6a42                	ld	s4,16(sp)
    55c0:	6aa2                	ld	s5,8(sp)
    55c2:	6b02                	ld	s6,0(sp)
      if(p->s.size == nunits)
    55c4:	fae90fe3          	beq	s2,a4,5582 <malloc+0x76>
        p->s.size -= nunits;
    55c8:	4137073b          	subw	a4,a4,s3
    55cc:	c798                	sw	a4,8(a5)
        p += p->s.size;
    55ce:	02071693          	slli	a3,a4,0x20
    55d2:	01c6d713          	srli	a4,a3,0x1c
    55d6:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
    55d8:	0137a423          	sw	s3,8(a5)
      freep = prevp;
    55dc:	00005717          	auipc	a4,0x5
    55e0:	e8a73223          	sd	a0,-380(a4) # a460 <freep>
      return (void*)(p + 1);
    55e4:	01078513          	addi	a0,a5,16
  }
}
    55e8:	70e2                	ld	ra,56(sp)
    55ea:	7442                	ld	s0,48(sp)
    55ec:	7902                	ld	s2,32(sp)
    55ee:	69e2                	ld	s3,24(sp)
    55f0:	6121                	addi	sp,sp,64
    55f2:	8082                	ret
    55f4:	74a2                	ld	s1,40(sp)
    55f6:	6a42                	ld	s4,16(sp)
    55f8:	6aa2                	ld	s5,8(sp)
    55fa:	6b02                	ld	s6,0(sp)
    55fc:	b7f5                	j	55e8 <malloc+0xdc>
