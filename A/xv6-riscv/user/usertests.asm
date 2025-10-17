
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
      14:	b7078793          	addi	a5,a5,-1168 # 7b80 <malloc+0x2674>
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
      82:	52a78793          	addi	a5,a5,1322 # b5a8 <uninit>
      86:	0000e697          	auipc	a3,0xe
      8a:	c3268693          	addi	a3,a3,-974 # dcb8 <buf>
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
     27e:	a3e98993          	addi	s3,s3,-1474 # dcb8 <buf>
  for(sz = 499; sz < (MAXOPBLOCKS+2)*BSIZE; sz += 471){
     282:	6a8d                	lui	s5,0x3
     284:	1c9a8a93          	addi	s5,s5,457 # 31c9 <subdir+0x4b9>
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
     4c8:	6bc78793          	addi	a5,a5,1724 # 7b80 <malloc+0x2674>
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
     60c:	57878793          	addi	a5,a5,1400 # 7b80 <malloc+0x2674>
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

00000000000008d2 <writetest>:
{
     8d2:	715d                	addi	sp,sp,-80
     8d4:	e486                	sd	ra,72(sp)
     8d6:	e0a2                	sd	s0,64(sp)
     8d8:	fc26                	sd	s1,56(sp)
     8da:	f84a                	sd	s2,48(sp)
     8dc:	f44e                	sd	s3,40(sp)
     8de:	f052                	sd	s4,32(sp)
     8e0:	ec56                	sd	s5,24(sp)
     8e2:	e85a                	sd	s6,16(sp)
     8e4:	e45e                	sd	s7,8(sp)
     8e6:	0880                	addi	s0,sp,80
     8e8:	8baa                	mv	s7,a0
  fd = open("small", O_CREATE|O_RDWR);
     8ea:	20200593          	li	a1,514
     8ee:	00005517          	auipc	a0,0x5
     8f2:	06250513          	addi	a0,a0,98 # 5950 <malloc+0x444>
     8f6:	750040ef          	jal	5046 <open>
  if(fd < 0){
     8fa:	08054f63          	bltz	a0,998 <writetest+0xc6>
     8fe:	89aa                	mv	s3,a0
     900:	4901                	li	s2,0
    if(write(fd, "aaaaaaaaaa", SZ) != SZ){
     902:	44a9                	li	s1,10
     904:	00005a17          	auipc	s4,0x5
     908:	074a0a13          	addi	s4,s4,116 # 5978 <malloc+0x46c>
    if(write(fd, "bbbbbbbbbb", SZ) != SZ){
     90c:	00005b17          	auipc	s6,0x5
     910:	0a4b0b13          	addi	s6,s6,164 # 59b0 <malloc+0x4a4>
  for(i = 0; i < N; i++){
     914:	06400a93          	li	s5,100
    if(write(fd, "aaaaaaaaaa", SZ) != SZ){
     918:	8626                	mv	a2,s1
     91a:	85d2                	mv	a1,s4
     91c:	854e                	mv	a0,s3
     91e:	708040ef          	jal	5026 <write>
     922:	08951563          	bne	a0,s1,9ac <writetest+0xda>
    if(write(fd, "bbbbbbbbbb", SZ) != SZ){
     926:	8626                	mv	a2,s1
     928:	85da                	mv	a1,s6
     92a:	854e                	mv	a0,s3
     92c:	6fa040ef          	jal	5026 <write>
     930:	08951963          	bne	a0,s1,9c2 <writetest+0xf0>
  for(i = 0; i < N; i++){
     934:	2905                	addiw	s2,s2,1
     936:	ff5911e3          	bne	s2,s5,918 <writetest+0x46>
  close(fd);
     93a:	854e                	mv	a0,s3
     93c:	6f2040ef          	jal	502e <close>
  fd = open("small", O_RDONLY);
     940:	4581                	li	a1,0
     942:	00005517          	auipc	a0,0x5
     946:	00e50513          	addi	a0,a0,14 # 5950 <malloc+0x444>
     94a:	6fc040ef          	jal	5046 <open>
     94e:	84aa                	mv	s1,a0
  if(fd < 0){
     950:	08054463          	bltz	a0,9d8 <writetest+0x106>
  i = read(fd, buf, N*SZ*2);
     954:	7d000613          	li	a2,2000
     958:	0000d597          	auipc	a1,0xd
     95c:	36058593          	addi	a1,a1,864 # dcb8 <buf>
     960:	6be040ef          	jal	501e <read>
  if(i != N*SZ*2){
     964:	7d000793          	li	a5,2000
     968:	08f51263          	bne	a0,a5,9ec <writetest+0x11a>
  close(fd);
     96c:	8526                	mv	a0,s1
     96e:	6c0040ef          	jal	502e <close>
  if(unlink("small") < 0){
     972:	00005517          	auipc	a0,0x5
     976:	fde50513          	addi	a0,a0,-34 # 5950 <malloc+0x444>
     97a:	6dc040ef          	jal	5056 <unlink>
     97e:	08054163          	bltz	a0,a00 <writetest+0x12e>
}
     982:	60a6                	ld	ra,72(sp)
     984:	6406                	ld	s0,64(sp)
     986:	74e2                	ld	s1,56(sp)
     988:	7942                	ld	s2,48(sp)
     98a:	79a2                	ld	s3,40(sp)
     98c:	7a02                	ld	s4,32(sp)
     98e:	6ae2                	ld	s5,24(sp)
     990:	6b42                	ld	s6,16(sp)
     992:	6ba2                	ld	s7,8(sp)
     994:	6161                	addi	sp,sp,80
     996:	8082                	ret
    printf("%s: error: creat small failed!\n", s);
     998:	85de                	mv	a1,s7
     99a:	00005517          	auipc	a0,0x5
     99e:	fbe50513          	addi	a0,a0,-66 # 5958 <malloc+0x44c>
     9a2:	2b3040ef          	jal	5454 <printf>
    exit(1);
     9a6:	4505                	li	a0,1
     9a8:	65e040ef          	jal	5006 <exit>
      printf("%s: error: write aa %d new file failed\n", s, i);
     9ac:	864a                	mv	a2,s2
     9ae:	85de                	mv	a1,s7
     9b0:	00005517          	auipc	a0,0x5
     9b4:	fd850513          	addi	a0,a0,-40 # 5988 <malloc+0x47c>
     9b8:	29d040ef          	jal	5454 <printf>
      exit(1);
     9bc:	4505                	li	a0,1
     9be:	648040ef          	jal	5006 <exit>
      printf("%s: error: write bb %d new file failed\n", s, i);
     9c2:	864a                	mv	a2,s2
     9c4:	85de                	mv	a1,s7
     9c6:	00005517          	auipc	a0,0x5
     9ca:	ffa50513          	addi	a0,a0,-6 # 59c0 <malloc+0x4b4>
     9ce:	287040ef          	jal	5454 <printf>
      exit(1);
     9d2:	4505                	li	a0,1
     9d4:	632040ef          	jal	5006 <exit>
    printf("%s: error: open small failed!\n", s);
     9d8:	85de                	mv	a1,s7
     9da:	00005517          	auipc	a0,0x5
     9de:	00e50513          	addi	a0,a0,14 # 59e8 <malloc+0x4dc>
     9e2:	273040ef          	jal	5454 <printf>
    exit(1);
     9e6:	4505                	li	a0,1
     9e8:	61e040ef          	jal	5006 <exit>
    printf("%s: read failed\n", s);
     9ec:	85de                	mv	a1,s7
     9ee:	00005517          	auipc	a0,0x5
     9f2:	01a50513          	addi	a0,a0,26 # 5a08 <malloc+0x4fc>
     9f6:	25f040ef          	jal	5454 <printf>
    exit(1);
     9fa:	4505                	li	a0,1
     9fc:	60a040ef          	jal	5006 <exit>
    printf("%s: unlink small failed\n", s);
     a00:	85de                	mv	a1,s7
     a02:	00005517          	auipc	a0,0x5
     a06:	01e50513          	addi	a0,a0,30 # 5a20 <malloc+0x514>
     a0a:	24b040ef          	jal	5454 <printf>
    exit(1);
     a0e:	4505                	li	a0,1
     a10:	5f6040ef          	jal	5006 <exit>

0000000000000a14 <writebig>:
{
     a14:	7139                	addi	sp,sp,-64
     a16:	fc06                	sd	ra,56(sp)
     a18:	f822                	sd	s0,48(sp)
     a1a:	f426                	sd	s1,40(sp)
     a1c:	f04a                	sd	s2,32(sp)
     a1e:	ec4e                	sd	s3,24(sp)
     a20:	e852                	sd	s4,16(sp)
     a22:	e456                	sd	s5,8(sp)
     a24:	e05a                	sd	s6,0(sp)
     a26:	0080                	addi	s0,sp,64
     a28:	8b2a                	mv	s6,a0
  fd = open("big", O_CREATE|O_RDWR);
     a2a:	20200593          	li	a1,514
     a2e:	00005517          	auipc	a0,0x5
     a32:	01250513          	addi	a0,a0,18 # 5a40 <malloc+0x534>
     a36:	610040ef          	jal	5046 <open>
  if(fd < 0){
     a3a:	06054a63          	bltz	a0,aae <writebig+0x9a>
     a3e:	8a2a                	mv	s4,a0
     a40:	4481                	li	s1,0
    ((int*)buf)[0] = i;
     a42:	0000d997          	auipc	s3,0xd
     a46:	27698993          	addi	s3,s3,630 # dcb8 <buf>
    if(write(fd, buf, BSIZE) != BSIZE){
     a4a:	40000913          	li	s2,1024
  for(i = 0; i < MAXFILE; i++){
     a4e:	10c00a93          	li	s5,268
    ((int*)buf)[0] = i;
     a52:	0099a023          	sw	s1,0(s3)
    if(write(fd, buf, BSIZE) != BSIZE){
     a56:	864a                	mv	a2,s2
     a58:	85ce                	mv	a1,s3
     a5a:	8552                	mv	a0,s4
     a5c:	5ca040ef          	jal	5026 <write>
     a60:	07251163          	bne	a0,s2,ac2 <writebig+0xae>
  for(i = 0; i < MAXFILE; i++){
     a64:	2485                	addiw	s1,s1,1
     a66:	ff5496e3          	bne	s1,s5,a52 <writebig+0x3e>
  close(fd);
     a6a:	8552                	mv	a0,s4
     a6c:	5c2040ef          	jal	502e <close>
  fd = open("big", O_RDONLY);
     a70:	4581                	li	a1,0
     a72:	00005517          	auipc	a0,0x5
     a76:	fce50513          	addi	a0,a0,-50 # 5a40 <malloc+0x534>
     a7a:	5cc040ef          	jal	5046 <open>
     a7e:	8a2a                	mv	s4,a0
  n = 0;
     a80:	4481                	li	s1,0
    i = read(fd, buf, BSIZE);
     a82:	40000993          	li	s3,1024
     a86:	0000d917          	auipc	s2,0xd
     a8a:	23290913          	addi	s2,s2,562 # dcb8 <buf>
  if(fd < 0){
     a8e:	04054563          	bltz	a0,ad8 <writebig+0xc4>
    i = read(fd, buf, BSIZE);
     a92:	864e                	mv	a2,s3
     a94:	85ca                	mv	a1,s2
     a96:	8552                	mv	a0,s4
     a98:	586040ef          	jal	501e <read>
    if(i == 0){
     a9c:	c921                	beqz	a0,aec <writebig+0xd8>
    } else if(i != BSIZE){
     a9e:	09351b63          	bne	a0,s3,b34 <writebig+0x120>
    if(((int*)buf)[0] != n){
     aa2:	00092683          	lw	a3,0(s2)
     aa6:	0a969263          	bne	a3,s1,b4a <writebig+0x136>
    n++;
     aaa:	2485                	addiw	s1,s1,1
    i = read(fd, buf, BSIZE);
     aac:	b7dd                	j	a92 <writebig+0x7e>
    printf("%s: error: creat big failed!\n", s);
     aae:	85da                	mv	a1,s6
     ab0:	00005517          	auipc	a0,0x5
     ab4:	f9850513          	addi	a0,a0,-104 # 5a48 <malloc+0x53c>
     ab8:	19d040ef          	jal	5454 <printf>
    exit(1);
     abc:	4505                	li	a0,1
     abe:	548040ef          	jal	5006 <exit>
      printf("%s: error: write big file failed i=%d\n", s, i);
     ac2:	8626                	mv	a2,s1
     ac4:	85da                	mv	a1,s6
     ac6:	00005517          	auipc	a0,0x5
     aca:	fa250513          	addi	a0,a0,-94 # 5a68 <malloc+0x55c>
     ace:	187040ef          	jal	5454 <printf>
      exit(1);
     ad2:	4505                	li	a0,1
     ad4:	532040ef          	jal	5006 <exit>
    printf("%s: error: open big failed!\n", s);
     ad8:	85da                	mv	a1,s6
     ada:	00005517          	auipc	a0,0x5
     ade:	fb650513          	addi	a0,a0,-74 # 5a90 <malloc+0x584>
     ae2:	173040ef          	jal	5454 <printf>
    exit(1);
     ae6:	4505                	li	a0,1
     ae8:	51e040ef          	jal	5006 <exit>
      if(n != MAXFILE){
     aec:	10c00793          	li	a5,268
     af0:	02f49763          	bne	s1,a5,b1e <writebig+0x10a>
  close(fd);
     af4:	8552                	mv	a0,s4
     af6:	538040ef          	jal	502e <close>
  if(unlink("big") < 0){
     afa:	00005517          	auipc	a0,0x5
     afe:	f4650513          	addi	a0,a0,-186 # 5a40 <malloc+0x534>
     b02:	554040ef          	jal	5056 <unlink>
     b06:	04054d63          	bltz	a0,b60 <writebig+0x14c>
}
     b0a:	70e2                	ld	ra,56(sp)
     b0c:	7442                	ld	s0,48(sp)
     b0e:	74a2                	ld	s1,40(sp)
     b10:	7902                	ld	s2,32(sp)
     b12:	69e2                	ld	s3,24(sp)
     b14:	6a42                	ld	s4,16(sp)
     b16:	6aa2                	ld	s5,8(sp)
     b18:	6b02                	ld	s6,0(sp)
     b1a:	6121                	addi	sp,sp,64
     b1c:	8082                	ret
        printf("%s: read only %d blocks from big", s, n);
     b1e:	8626                	mv	a2,s1
     b20:	85da                	mv	a1,s6
     b22:	00005517          	auipc	a0,0x5
     b26:	f8e50513          	addi	a0,a0,-114 # 5ab0 <malloc+0x5a4>
     b2a:	12b040ef          	jal	5454 <printf>
        exit(1);
     b2e:	4505                	li	a0,1
     b30:	4d6040ef          	jal	5006 <exit>
      printf("%s: read failed %d\n", s, i);
     b34:	862a                	mv	a2,a0
     b36:	85da                	mv	a1,s6
     b38:	00005517          	auipc	a0,0x5
     b3c:	fa050513          	addi	a0,a0,-96 # 5ad8 <malloc+0x5cc>
     b40:	115040ef          	jal	5454 <printf>
      exit(1);
     b44:	4505                	li	a0,1
     b46:	4c0040ef          	jal	5006 <exit>
      printf("%s: read content of block %d is %d\n", s,
     b4a:	8626                	mv	a2,s1
     b4c:	85da                	mv	a1,s6
     b4e:	00005517          	auipc	a0,0x5
     b52:	fa250513          	addi	a0,a0,-94 # 5af0 <malloc+0x5e4>
     b56:	0ff040ef          	jal	5454 <printf>
      exit(1);
     b5a:	4505                	li	a0,1
     b5c:	4aa040ef          	jal	5006 <exit>
    printf("%s: unlink big failed\n", s);
     b60:	85da                	mv	a1,s6
     b62:	00005517          	auipc	a0,0x5
     b66:	fb650513          	addi	a0,a0,-74 # 5b18 <malloc+0x60c>
     b6a:	0eb040ef          	jal	5454 <printf>
    exit(1);
     b6e:	4505                	li	a0,1
     b70:	496040ef          	jal	5006 <exit>

0000000000000b74 <unlinkread>:
{
     b74:	7179                	addi	sp,sp,-48
     b76:	f406                	sd	ra,40(sp)
     b78:	f022                	sd	s0,32(sp)
     b7a:	ec26                	sd	s1,24(sp)
     b7c:	e84a                	sd	s2,16(sp)
     b7e:	e44e                	sd	s3,8(sp)
     b80:	1800                	addi	s0,sp,48
     b82:	89aa                	mv	s3,a0
  fd = open("unlinkread", O_CREATE | O_RDWR);
     b84:	20200593          	li	a1,514
     b88:	00005517          	auipc	a0,0x5
     b8c:	fa850513          	addi	a0,a0,-88 # 5b30 <malloc+0x624>
     b90:	4b6040ef          	jal	5046 <open>
  if(fd < 0){
     b94:	0a054f63          	bltz	a0,c52 <unlinkread+0xde>
     b98:	84aa                	mv	s1,a0
  write(fd, "hello", SZ);
     b9a:	4615                	li	a2,5
     b9c:	00005597          	auipc	a1,0x5
     ba0:	fc458593          	addi	a1,a1,-60 # 5b60 <malloc+0x654>
     ba4:	482040ef          	jal	5026 <write>
  close(fd);
     ba8:	8526                	mv	a0,s1
     baa:	484040ef          	jal	502e <close>
  fd = open("unlinkread", O_RDWR);
     bae:	4589                	li	a1,2
     bb0:	00005517          	auipc	a0,0x5
     bb4:	f8050513          	addi	a0,a0,-128 # 5b30 <malloc+0x624>
     bb8:	48e040ef          	jal	5046 <open>
     bbc:	84aa                	mv	s1,a0
  if(fd < 0){
     bbe:	0a054463          	bltz	a0,c66 <unlinkread+0xf2>
  if(unlink("unlinkread") != 0){
     bc2:	00005517          	auipc	a0,0x5
     bc6:	f6e50513          	addi	a0,a0,-146 # 5b30 <malloc+0x624>
     bca:	48c040ef          	jal	5056 <unlink>
     bce:	e555                	bnez	a0,c7a <unlinkread+0x106>
  fd1 = open("unlinkread", O_CREATE | O_RDWR);
     bd0:	20200593          	li	a1,514
     bd4:	00005517          	auipc	a0,0x5
     bd8:	f5c50513          	addi	a0,a0,-164 # 5b30 <malloc+0x624>
     bdc:	46a040ef          	jal	5046 <open>
     be0:	892a                	mv	s2,a0
  write(fd1, "yyy", 3);
     be2:	460d                	li	a2,3
     be4:	00005597          	auipc	a1,0x5
     be8:	fc458593          	addi	a1,a1,-60 # 5ba8 <malloc+0x69c>
     bec:	43a040ef          	jal	5026 <write>
  close(fd1);
     bf0:	854a                	mv	a0,s2
     bf2:	43c040ef          	jal	502e <close>
  if(read(fd, buf, sizeof(buf)) != SZ){
     bf6:	660d                	lui	a2,0x3
     bf8:	0000d597          	auipc	a1,0xd
     bfc:	0c058593          	addi	a1,a1,192 # dcb8 <buf>
     c00:	8526                	mv	a0,s1
     c02:	41c040ef          	jal	501e <read>
     c06:	4795                	li	a5,5
     c08:	08f51363          	bne	a0,a5,c8e <unlinkread+0x11a>
  if(buf[0] != 'h'){
     c0c:	0000d717          	auipc	a4,0xd
     c10:	0ac74703          	lbu	a4,172(a4) # dcb8 <buf>
     c14:	06800793          	li	a5,104
     c18:	08f71563          	bne	a4,a5,ca2 <unlinkread+0x12e>
  if(write(fd, buf, 10) != 10){
     c1c:	4629                	li	a2,10
     c1e:	0000d597          	auipc	a1,0xd
     c22:	09a58593          	addi	a1,a1,154 # dcb8 <buf>
     c26:	8526                	mv	a0,s1
     c28:	3fe040ef          	jal	5026 <write>
     c2c:	47a9                	li	a5,10
     c2e:	08f51463          	bne	a0,a5,cb6 <unlinkread+0x142>
  close(fd);
     c32:	8526                	mv	a0,s1
     c34:	3fa040ef          	jal	502e <close>
  unlink("unlinkread");
     c38:	00005517          	auipc	a0,0x5
     c3c:	ef850513          	addi	a0,a0,-264 # 5b30 <malloc+0x624>
     c40:	416040ef          	jal	5056 <unlink>
}
     c44:	70a2                	ld	ra,40(sp)
     c46:	7402                	ld	s0,32(sp)
     c48:	64e2                	ld	s1,24(sp)
     c4a:	6942                	ld	s2,16(sp)
     c4c:	69a2                	ld	s3,8(sp)
     c4e:	6145                	addi	sp,sp,48
     c50:	8082                	ret
    printf("%s: create unlinkread failed\n", s);
     c52:	85ce                	mv	a1,s3
     c54:	00005517          	auipc	a0,0x5
     c58:	eec50513          	addi	a0,a0,-276 # 5b40 <malloc+0x634>
     c5c:	7f8040ef          	jal	5454 <printf>
    exit(1);
     c60:	4505                	li	a0,1
     c62:	3a4040ef          	jal	5006 <exit>
    printf("%s: open unlinkread failed\n", s);
     c66:	85ce                	mv	a1,s3
     c68:	00005517          	auipc	a0,0x5
     c6c:	f0050513          	addi	a0,a0,-256 # 5b68 <malloc+0x65c>
     c70:	7e4040ef          	jal	5454 <printf>
    exit(1);
     c74:	4505                	li	a0,1
     c76:	390040ef          	jal	5006 <exit>
    printf("%s: unlink unlinkread failed\n", s);
     c7a:	85ce                	mv	a1,s3
     c7c:	00005517          	auipc	a0,0x5
     c80:	f0c50513          	addi	a0,a0,-244 # 5b88 <malloc+0x67c>
     c84:	7d0040ef          	jal	5454 <printf>
    exit(1);
     c88:	4505                	li	a0,1
     c8a:	37c040ef          	jal	5006 <exit>
    printf("%s: unlinkread read failed", s);
     c8e:	85ce                	mv	a1,s3
     c90:	00005517          	auipc	a0,0x5
     c94:	f2050513          	addi	a0,a0,-224 # 5bb0 <malloc+0x6a4>
     c98:	7bc040ef          	jal	5454 <printf>
    exit(1);
     c9c:	4505                	li	a0,1
     c9e:	368040ef          	jal	5006 <exit>
    printf("%s: unlinkread wrong data\n", s);
     ca2:	85ce                	mv	a1,s3
     ca4:	00005517          	auipc	a0,0x5
     ca8:	f2c50513          	addi	a0,a0,-212 # 5bd0 <malloc+0x6c4>
     cac:	7a8040ef          	jal	5454 <printf>
    exit(1);
     cb0:	4505                	li	a0,1
     cb2:	354040ef          	jal	5006 <exit>
    printf("%s: unlinkread write failed\n", s);
     cb6:	85ce                	mv	a1,s3
     cb8:	00005517          	auipc	a0,0x5
     cbc:	f3850513          	addi	a0,a0,-200 # 5bf0 <malloc+0x6e4>
     cc0:	794040ef          	jal	5454 <printf>
    exit(1);
     cc4:	4505                	li	a0,1
     cc6:	340040ef          	jal	5006 <exit>

0000000000000cca <linktest>:
{
     cca:	1101                	addi	sp,sp,-32
     ccc:	ec06                	sd	ra,24(sp)
     cce:	e822                	sd	s0,16(sp)
     cd0:	e426                	sd	s1,8(sp)
     cd2:	e04a                	sd	s2,0(sp)
     cd4:	1000                	addi	s0,sp,32
     cd6:	892a                	mv	s2,a0
  unlink("lf1");
     cd8:	00005517          	auipc	a0,0x5
     cdc:	f3850513          	addi	a0,a0,-200 # 5c10 <malloc+0x704>
     ce0:	376040ef          	jal	5056 <unlink>
  unlink("lf2");
     ce4:	00005517          	auipc	a0,0x5
     ce8:	f3450513          	addi	a0,a0,-204 # 5c18 <malloc+0x70c>
     cec:	36a040ef          	jal	5056 <unlink>
  fd = open("lf1", O_CREATE|O_RDWR);
     cf0:	20200593          	li	a1,514
     cf4:	00005517          	auipc	a0,0x5
     cf8:	f1c50513          	addi	a0,a0,-228 # 5c10 <malloc+0x704>
     cfc:	34a040ef          	jal	5046 <open>
  if(fd < 0){
     d00:	0c054f63          	bltz	a0,dde <linktest+0x114>
     d04:	84aa                	mv	s1,a0
  if(write(fd, "hello", SZ) != SZ){
     d06:	4615                	li	a2,5
     d08:	00005597          	auipc	a1,0x5
     d0c:	e5858593          	addi	a1,a1,-424 # 5b60 <malloc+0x654>
     d10:	316040ef          	jal	5026 <write>
     d14:	4795                	li	a5,5
     d16:	0cf51e63          	bne	a0,a5,df2 <linktest+0x128>
  close(fd);
     d1a:	8526                	mv	a0,s1
     d1c:	312040ef          	jal	502e <close>
  if(link("lf1", "lf2") < 0){
     d20:	00005597          	auipc	a1,0x5
     d24:	ef858593          	addi	a1,a1,-264 # 5c18 <malloc+0x70c>
     d28:	00005517          	auipc	a0,0x5
     d2c:	ee850513          	addi	a0,a0,-280 # 5c10 <malloc+0x704>
     d30:	336040ef          	jal	5066 <link>
     d34:	0c054963          	bltz	a0,e06 <linktest+0x13c>
  unlink("lf1");
     d38:	00005517          	auipc	a0,0x5
     d3c:	ed850513          	addi	a0,a0,-296 # 5c10 <malloc+0x704>
     d40:	316040ef          	jal	5056 <unlink>
  if(open("lf1", 0) >= 0){
     d44:	4581                	li	a1,0
     d46:	00005517          	auipc	a0,0x5
     d4a:	eca50513          	addi	a0,a0,-310 # 5c10 <malloc+0x704>
     d4e:	2f8040ef          	jal	5046 <open>
     d52:	0c055463          	bgez	a0,e1a <linktest+0x150>
  fd = open("lf2", 0);
     d56:	4581                	li	a1,0
     d58:	00005517          	auipc	a0,0x5
     d5c:	ec050513          	addi	a0,a0,-320 # 5c18 <malloc+0x70c>
     d60:	2e6040ef          	jal	5046 <open>
     d64:	84aa                	mv	s1,a0
  if(fd < 0){
     d66:	0c054463          	bltz	a0,e2e <linktest+0x164>
  if(read(fd, buf, sizeof(buf)) != SZ){
     d6a:	660d                	lui	a2,0x3
     d6c:	0000d597          	auipc	a1,0xd
     d70:	f4c58593          	addi	a1,a1,-180 # dcb8 <buf>
     d74:	2aa040ef          	jal	501e <read>
     d78:	4795                	li	a5,5
     d7a:	0cf51463          	bne	a0,a5,e42 <linktest+0x178>
  close(fd);
     d7e:	8526                	mv	a0,s1
     d80:	2ae040ef          	jal	502e <close>
  if(link("lf2", "lf2") >= 0){
     d84:	00005597          	auipc	a1,0x5
     d88:	e9458593          	addi	a1,a1,-364 # 5c18 <malloc+0x70c>
     d8c:	852e                	mv	a0,a1
     d8e:	2d8040ef          	jal	5066 <link>
     d92:	0c055263          	bgez	a0,e56 <linktest+0x18c>
  unlink("lf2");
     d96:	00005517          	auipc	a0,0x5
     d9a:	e8250513          	addi	a0,a0,-382 # 5c18 <malloc+0x70c>
     d9e:	2b8040ef          	jal	5056 <unlink>
  if(link("lf2", "lf1") >= 0){
     da2:	00005597          	auipc	a1,0x5
     da6:	e6e58593          	addi	a1,a1,-402 # 5c10 <malloc+0x704>
     daa:	00005517          	auipc	a0,0x5
     dae:	e6e50513          	addi	a0,a0,-402 # 5c18 <malloc+0x70c>
     db2:	2b4040ef          	jal	5066 <link>
     db6:	0a055a63          	bgez	a0,e6a <linktest+0x1a0>
  if(link(".", "lf1") >= 0){
     dba:	00005597          	auipc	a1,0x5
     dbe:	e5658593          	addi	a1,a1,-426 # 5c10 <malloc+0x704>
     dc2:	00005517          	auipc	a0,0x5
     dc6:	f5e50513          	addi	a0,a0,-162 # 5d20 <malloc+0x814>
     dca:	29c040ef          	jal	5066 <link>
     dce:	0a055863          	bgez	a0,e7e <linktest+0x1b4>
}
     dd2:	60e2                	ld	ra,24(sp)
     dd4:	6442                	ld	s0,16(sp)
     dd6:	64a2                	ld	s1,8(sp)
     dd8:	6902                	ld	s2,0(sp)
     dda:	6105                	addi	sp,sp,32
     ddc:	8082                	ret
    printf("%s: create lf1 failed\n", s);
     dde:	85ca                	mv	a1,s2
     de0:	00005517          	auipc	a0,0x5
     de4:	e4050513          	addi	a0,a0,-448 # 5c20 <malloc+0x714>
     de8:	66c040ef          	jal	5454 <printf>
    exit(1);
     dec:	4505                	li	a0,1
     dee:	218040ef          	jal	5006 <exit>
    printf("%s: write lf1 failed\n", s);
     df2:	85ca                	mv	a1,s2
     df4:	00005517          	auipc	a0,0x5
     df8:	e4450513          	addi	a0,a0,-444 # 5c38 <malloc+0x72c>
     dfc:	658040ef          	jal	5454 <printf>
    exit(1);
     e00:	4505                	li	a0,1
     e02:	204040ef          	jal	5006 <exit>
    printf("%s: link lf1 lf2 failed\n", s);
     e06:	85ca                	mv	a1,s2
     e08:	00005517          	auipc	a0,0x5
     e0c:	e4850513          	addi	a0,a0,-440 # 5c50 <malloc+0x744>
     e10:	644040ef          	jal	5454 <printf>
    exit(1);
     e14:	4505                	li	a0,1
     e16:	1f0040ef          	jal	5006 <exit>
    printf("%s: unlinked lf1 but it is still there!\n", s);
     e1a:	85ca                	mv	a1,s2
     e1c:	00005517          	auipc	a0,0x5
     e20:	e5450513          	addi	a0,a0,-428 # 5c70 <malloc+0x764>
     e24:	630040ef          	jal	5454 <printf>
    exit(1);
     e28:	4505                	li	a0,1
     e2a:	1dc040ef          	jal	5006 <exit>
    printf("%s: open lf2 failed\n", s);
     e2e:	85ca                	mv	a1,s2
     e30:	00005517          	auipc	a0,0x5
     e34:	e7050513          	addi	a0,a0,-400 # 5ca0 <malloc+0x794>
     e38:	61c040ef          	jal	5454 <printf>
    exit(1);
     e3c:	4505                	li	a0,1
     e3e:	1c8040ef          	jal	5006 <exit>
    printf("%s: read lf2 failed\n", s);
     e42:	85ca                	mv	a1,s2
     e44:	00005517          	auipc	a0,0x5
     e48:	e7450513          	addi	a0,a0,-396 # 5cb8 <malloc+0x7ac>
     e4c:	608040ef          	jal	5454 <printf>
    exit(1);
     e50:	4505                	li	a0,1
     e52:	1b4040ef          	jal	5006 <exit>
    printf("%s: link lf2 lf2 succeeded! oops\n", s);
     e56:	85ca                	mv	a1,s2
     e58:	00005517          	auipc	a0,0x5
     e5c:	e7850513          	addi	a0,a0,-392 # 5cd0 <malloc+0x7c4>
     e60:	5f4040ef          	jal	5454 <printf>
    exit(1);
     e64:	4505                	li	a0,1
     e66:	1a0040ef          	jal	5006 <exit>
    printf("%s: link non-existent succeeded! oops\n", s);
     e6a:	85ca                	mv	a1,s2
     e6c:	00005517          	auipc	a0,0x5
     e70:	e8c50513          	addi	a0,a0,-372 # 5cf8 <malloc+0x7ec>
     e74:	5e0040ef          	jal	5454 <printf>
    exit(1);
     e78:	4505                	li	a0,1
     e7a:	18c040ef          	jal	5006 <exit>
    printf("%s: link . lf1 succeeded! oops\n", s);
     e7e:	85ca                	mv	a1,s2
     e80:	00005517          	auipc	a0,0x5
     e84:	ea850513          	addi	a0,a0,-344 # 5d28 <malloc+0x81c>
     e88:	5cc040ef          	jal	5454 <printf>
    exit(1);
     e8c:	4505                	li	a0,1
     e8e:	178040ef          	jal	5006 <exit>

0000000000000e92 <validatetest>:
{
     e92:	7139                	addi	sp,sp,-64
     e94:	fc06                	sd	ra,56(sp)
     e96:	f822                	sd	s0,48(sp)
     e98:	f426                	sd	s1,40(sp)
     e9a:	f04a                	sd	s2,32(sp)
     e9c:	ec4e                	sd	s3,24(sp)
     e9e:	e852                	sd	s4,16(sp)
     ea0:	e456                	sd	s5,8(sp)
     ea2:	e05a                	sd	s6,0(sp)
     ea4:	0080                	addi	s0,sp,64
     ea6:	8b2a                	mv	s6,a0
  for(p = 0; p <= (uint)hi; p += PGSIZE){
     ea8:	4481                	li	s1,0
    if(link("nosuchfile", (char*)p) != -1){
     eaa:	00005997          	auipc	s3,0x5
     eae:	e9e98993          	addi	s3,s3,-354 # 5d48 <malloc+0x83c>
     eb2:	597d                	li	s2,-1
  for(p = 0; p <= (uint)hi; p += PGSIZE){
     eb4:	6a85                	lui	s5,0x1
     eb6:	00114a37          	lui	s4,0x114
    if(link("nosuchfile", (char*)p) != -1){
     eba:	85a6                	mv	a1,s1
     ebc:	854e                	mv	a0,s3
     ebe:	1a8040ef          	jal	5066 <link>
     ec2:	01251f63          	bne	a0,s2,ee0 <validatetest+0x4e>
  for(p = 0; p <= (uint)hi; p += PGSIZE){
     ec6:	94d6                	add	s1,s1,s5
     ec8:	ff4499e3          	bne	s1,s4,eba <validatetest+0x28>
}
     ecc:	70e2                	ld	ra,56(sp)
     ece:	7442                	ld	s0,48(sp)
     ed0:	74a2                	ld	s1,40(sp)
     ed2:	7902                	ld	s2,32(sp)
     ed4:	69e2                	ld	s3,24(sp)
     ed6:	6a42                	ld	s4,16(sp)
     ed8:	6aa2                	ld	s5,8(sp)
     eda:	6b02                	ld	s6,0(sp)
     edc:	6121                	addi	sp,sp,64
     ede:	8082                	ret
      printf("%s: link should not succeed\n", s);
     ee0:	85da                	mv	a1,s6
     ee2:	00005517          	auipc	a0,0x5
     ee6:	e7650513          	addi	a0,a0,-394 # 5d58 <malloc+0x84c>
     eea:	56a040ef          	jal	5454 <printf>
      exit(1);
     eee:	4505                	li	a0,1
     ef0:	116040ef          	jal	5006 <exit>

0000000000000ef4 <bigdir>:
{
     ef4:	711d                	addi	sp,sp,-96
     ef6:	ec86                	sd	ra,88(sp)
     ef8:	e8a2                	sd	s0,80(sp)
     efa:	e4a6                	sd	s1,72(sp)
     efc:	e0ca                	sd	s2,64(sp)
     efe:	fc4e                	sd	s3,56(sp)
     f00:	f852                	sd	s4,48(sp)
     f02:	f456                	sd	s5,40(sp)
     f04:	f05a                	sd	s6,32(sp)
     f06:	ec5e                	sd	s7,24(sp)
     f08:	1080                	addi	s0,sp,96
     f0a:	8baa                	mv	s7,a0
  unlink("bd");
     f0c:	00005517          	auipc	a0,0x5
     f10:	e6c50513          	addi	a0,a0,-404 # 5d78 <malloc+0x86c>
     f14:	142040ef          	jal	5056 <unlink>
  fd = open("bd", O_CREATE);
     f18:	20000593          	li	a1,512
     f1c:	00005517          	auipc	a0,0x5
     f20:	e5c50513          	addi	a0,a0,-420 # 5d78 <malloc+0x86c>
     f24:	122040ef          	jal	5046 <open>
  if(fd < 0){
     f28:	0c054463          	bltz	a0,ff0 <bigdir+0xfc>
  close(fd);
     f2c:	102040ef          	jal	502e <close>
  for(i = 0; i < N; i++){
     f30:	4901                	li	s2,0
    name[0] = 'x';
     f32:	07800a93          	li	s5,120
    if(link("bd", name) != 0){
     f36:	fa040a13          	addi	s4,s0,-96
     f3a:	00005997          	auipc	s3,0x5
     f3e:	e3e98993          	addi	s3,s3,-450 # 5d78 <malloc+0x86c>
  for(i = 0; i < N; i++){
     f42:	1f400b13          	li	s6,500
    name[0] = 'x';
     f46:	fb540023          	sb	s5,-96(s0)
    name[1] = '0' + (i / 64);
     f4a:	41f9571b          	sraiw	a4,s2,0x1f
     f4e:	01a7571b          	srliw	a4,a4,0x1a
     f52:	012707bb          	addw	a5,a4,s2
     f56:	4067d69b          	sraiw	a3,a5,0x6
     f5a:	0306869b          	addiw	a3,a3,48
     f5e:	fad400a3          	sb	a3,-95(s0)
    name[2] = '0' + (i % 64);
     f62:	03f7f793          	andi	a5,a5,63
     f66:	9f99                	subw	a5,a5,a4
     f68:	0307879b          	addiw	a5,a5,48
     f6c:	faf40123          	sb	a5,-94(s0)
    name[3] = '\0';
     f70:	fa0401a3          	sb	zero,-93(s0)
    if(link("bd", name) != 0){
     f74:	85d2                	mv	a1,s4
     f76:	854e                	mv	a0,s3
     f78:	0ee040ef          	jal	5066 <link>
     f7c:	84aa                	mv	s1,a0
     f7e:	e159                	bnez	a0,1004 <bigdir+0x110>
  for(i = 0; i < N; i++){
     f80:	2905                	addiw	s2,s2,1
     f82:	fd6912e3          	bne	s2,s6,f46 <bigdir+0x52>
  unlink("bd");
     f86:	00005517          	auipc	a0,0x5
     f8a:	df250513          	addi	a0,a0,-526 # 5d78 <malloc+0x86c>
     f8e:	0c8040ef          	jal	5056 <unlink>
    name[0] = 'x';
     f92:	07800993          	li	s3,120
    if(unlink(name) != 0){
     f96:	fa040913          	addi	s2,s0,-96
  for(i = 0; i < N; i++){
     f9a:	1f400a13          	li	s4,500
    name[0] = 'x';
     f9e:	fb340023          	sb	s3,-96(s0)
    name[1] = '0' + (i / 64);
     fa2:	41f4d71b          	sraiw	a4,s1,0x1f
     fa6:	01a7571b          	srliw	a4,a4,0x1a
     faa:	009707bb          	addw	a5,a4,s1
     fae:	4067d69b          	sraiw	a3,a5,0x6
     fb2:	0306869b          	addiw	a3,a3,48
     fb6:	fad400a3          	sb	a3,-95(s0)
    name[2] = '0' + (i % 64);
     fba:	03f7f793          	andi	a5,a5,63
     fbe:	9f99                	subw	a5,a5,a4
     fc0:	0307879b          	addiw	a5,a5,48
     fc4:	faf40123          	sb	a5,-94(s0)
    name[3] = '\0';
     fc8:	fa0401a3          	sb	zero,-93(s0)
    if(unlink(name) != 0){
     fcc:	854a                	mv	a0,s2
     fce:	088040ef          	jal	5056 <unlink>
     fd2:	e531                	bnez	a0,101e <bigdir+0x12a>
  for(i = 0; i < N; i++){
     fd4:	2485                	addiw	s1,s1,1
     fd6:	fd4494e3          	bne	s1,s4,f9e <bigdir+0xaa>
}
     fda:	60e6                	ld	ra,88(sp)
     fdc:	6446                	ld	s0,80(sp)
     fde:	64a6                	ld	s1,72(sp)
     fe0:	6906                	ld	s2,64(sp)
     fe2:	79e2                	ld	s3,56(sp)
     fe4:	7a42                	ld	s4,48(sp)
     fe6:	7aa2                	ld	s5,40(sp)
     fe8:	7b02                	ld	s6,32(sp)
     fea:	6be2                	ld	s7,24(sp)
     fec:	6125                	addi	sp,sp,96
     fee:	8082                	ret
    printf("%s: bigdir create failed\n", s);
     ff0:	85de                	mv	a1,s7
     ff2:	00005517          	auipc	a0,0x5
     ff6:	d8e50513          	addi	a0,a0,-626 # 5d80 <malloc+0x874>
     ffa:	45a040ef          	jal	5454 <printf>
    exit(1);
     ffe:	4505                	li	a0,1
    1000:	006040ef          	jal	5006 <exit>
      printf("%s: bigdir i=%d link(bd, %s) failed\n", s, i, name);
    1004:	fa040693          	addi	a3,s0,-96
    1008:	864a                	mv	a2,s2
    100a:	85de                	mv	a1,s7
    100c:	00005517          	auipc	a0,0x5
    1010:	d9450513          	addi	a0,a0,-620 # 5da0 <malloc+0x894>
    1014:	440040ef          	jal	5454 <printf>
      exit(1);
    1018:	4505                	li	a0,1
    101a:	7ed030ef          	jal	5006 <exit>
      printf("%s: bigdir unlink failed", s);
    101e:	85de                	mv	a1,s7
    1020:	00005517          	auipc	a0,0x5
    1024:	da850513          	addi	a0,a0,-600 # 5dc8 <malloc+0x8bc>
    1028:	42c040ef          	jal	5454 <printf>
      exit(1);
    102c:	4505                	li	a0,1
    102e:	7d9030ef          	jal	5006 <exit>

0000000000001032 <pgbug>:
{
    1032:	7179                	addi	sp,sp,-48
    1034:	f406                	sd	ra,40(sp)
    1036:	f022                	sd	s0,32(sp)
    1038:	ec26                	sd	s1,24(sp)
    103a:	1800                	addi	s0,sp,48
  argv[0] = 0;
    103c:	fc043c23          	sd	zero,-40(s0)
  exec(big, argv);
    1040:	00009497          	auipc	s1,0x9
    1044:	fc048493          	addi	s1,s1,-64 # a000 <big>
    1048:	fd840593          	addi	a1,s0,-40
    104c:	6088                	ld	a0,0(s1)
    104e:	7f1030ef          	jal	503e <exec>
  pipe(big);
    1052:	6088                	ld	a0,0(s1)
    1054:	7c3030ef          	jal	5016 <pipe>
  exit(0);
    1058:	4501                	li	a0,0
    105a:	7ad030ef          	jal	5006 <exit>

000000000000105e <badarg>:
{
    105e:	7139                	addi	sp,sp,-64
    1060:	fc06                	sd	ra,56(sp)
    1062:	f822                	sd	s0,48(sp)
    1064:	f426                	sd	s1,40(sp)
    1066:	f04a                	sd	s2,32(sp)
    1068:	ec4e                	sd	s3,24(sp)
    106a:	e852                	sd	s4,16(sp)
    106c:	0080                	addi	s0,sp,64
    106e:	64b1                	lui	s1,0xc
    1070:	35048493          	addi	s1,s1,848 # c350 <uninit+0xda8>
    argv[0] = (char*)0xffffffff;
    1074:	597d                	li	s2,-1
    1076:	02095913          	srli	s2,s2,0x20
    exec("echo", argv);
    107a:	fc040a13          	addi	s4,s0,-64
    107e:	00004997          	auipc	s3,0x4
    1082:	5ba98993          	addi	s3,s3,1466 # 5638 <malloc+0x12c>
    argv[0] = (char*)0xffffffff;
    1086:	fd243023          	sd	s2,-64(s0)
    argv[1] = 0;
    108a:	fc043423          	sd	zero,-56(s0)
    exec("echo", argv);
    108e:	85d2                	mv	a1,s4
    1090:	854e                	mv	a0,s3
    1092:	7ad030ef          	jal	503e <exec>
  for(int i = 0; i < 50000; i++){
    1096:	34fd                	addiw	s1,s1,-1
    1098:	f4fd                	bnez	s1,1086 <badarg+0x28>
  exit(0);
    109a:	4501                	li	a0,0
    109c:	76b030ef          	jal	5006 <exit>

00000000000010a0 <copyinstr2>:
{
    10a0:	7155                	addi	sp,sp,-208
    10a2:	e586                	sd	ra,200(sp)
    10a4:	e1a2                	sd	s0,192(sp)
    10a6:	0980                	addi	s0,sp,208
  for(int i = 0; i < MAXPATH; i++)
    10a8:	f6840793          	addi	a5,s0,-152
    10ac:	fe840693          	addi	a3,s0,-24
    b[i] = 'x';
    10b0:	07800713          	li	a4,120
    10b4:	00e78023          	sb	a4,0(a5)
  for(int i = 0; i < MAXPATH; i++)
    10b8:	0785                	addi	a5,a5,1
    10ba:	fed79de3          	bne	a5,a3,10b4 <copyinstr2+0x14>
  b[MAXPATH] = '\0';
    10be:	fe040423          	sb	zero,-24(s0)
  int ret = unlink(b);
    10c2:	f6840513          	addi	a0,s0,-152
    10c6:	791030ef          	jal	5056 <unlink>
  if(ret != -1){
    10ca:	57fd                	li	a5,-1
    10cc:	0cf51263          	bne	a0,a5,1190 <copyinstr2+0xf0>
  int fd = open(b, O_CREATE | O_WRONLY);
    10d0:	20100593          	li	a1,513
    10d4:	f6840513          	addi	a0,s0,-152
    10d8:	76f030ef          	jal	5046 <open>
  if(fd != -1){
    10dc:	57fd                	li	a5,-1
    10de:	0cf51563          	bne	a0,a5,11a8 <copyinstr2+0x108>
  ret = link(b, b);
    10e2:	f6840513          	addi	a0,s0,-152
    10e6:	85aa                	mv	a1,a0
    10e8:	77f030ef          	jal	5066 <link>
  if(ret != -1){
    10ec:	57fd                	li	a5,-1
    10ee:	0cf51963          	bne	a0,a5,11c0 <copyinstr2+0x120>
  char *args[] = { "xx", 0 };
    10f2:	00006797          	auipc	a5,0x6
    10f6:	e2678793          	addi	a5,a5,-474 # 6f18 <malloc+0x1a0c>
    10fa:	f4f43c23          	sd	a5,-168(s0)
    10fe:	f6043023          	sd	zero,-160(s0)
  ret = exec(b, args);
    1102:	f5840593          	addi	a1,s0,-168
    1106:	f6840513          	addi	a0,s0,-152
    110a:	735030ef          	jal	503e <exec>
  if(ret != -1){
    110e:	57fd                	li	a5,-1
    1110:	0cf51563          	bne	a0,a5,11da <copyinstr2+0x13a>
  int pid = fork();
    1114:	6eb030ef          	jal	4ffe <fork>
  if(pid < 0){
    1118:	0c054d63          	bltz	a0,11f2 <copyinstr2+0x152>
  if(pid == 0){
    111c:	0e051863          	bnez	a0,120c <copyinstr2+0x16c>
    1120:	00009797          	auipc	a5,0x9
    1124:	48078793          	addi	a5,a5,1152 # a5a0 <big.0>
    1128:	0000a697          	auipc	a3,0xa
    112c:	47868693          	addi	a3,a3,1144 # b5a0 <big.0+0x1000>
      big[i] = 'x';
    1130:	07800713          	li	a4,120
    1134:	00e78023          	sb	a4,0(a5)
    for(int i = 0; i < PGSIZE; i++)
    1138:	0785                	addi	a5,a5,1
    113a:	fed79de3          	bne	a5,a3,1134 <copyinstr2+0x94>
    big[PGSIZE] = '\0';
    113e:	0000a797          	auipc	a5,0xa
    1142:	46078123          	sb	zero,1122(a5) # b5a0 <big.0+0x1000>
    char *args2[] = { big, big, big, 0 };
    1146:	00007797          	auipc	a5,0x7
    114a:	a3a78793          	addi	a5,a5,-1478 # 7b80 <malloc+0x2674>
    114e:	6fb0                	ld	a2,88(a5)
    1150:	73b4                	ld	a3,96(a5)
    1152:	77b8                	ld	a4,104(a5)
    1154:	f2c43823          	sd	a2,-208(s0)
    1158:	f2d43c23          	sd	a3,-200(s0)
    115c:	f4e43023          	sd	a4,-192(s0)
    1160:	7bbc                	ld	a5,112(a5)
    1162:	f4f43423          	sd	a5,-184(s0)
    ret = exec("echo", args2);
    1166:	f3040593          	addi	a1,s0,-208
    116a:	00004517          	auipc	a0,0x4
    116e:	4ce50513          	addi	a0,a0,1230 # 5638 <malloc+0x12c>
    1172:	6cd030ef          	jal	503e <exec>
    if(ret != -1){
    1176:	57fd                	li	a5,-1
    1178:	08f50663          	beq	a0,a5,1204 <copyinstr2+0x164>
      printf("exec(echo, BIG) returned %d, not -1\n", fd);
    117c:	85be                	mv	a1,a5
    117e:	00005517          	auipc	a0,0x5
    1182:	cf250513          	addi	a0,a0,-782 # 5e70 <malloc+0x964>
    1186:	2ce040ef          	jal	5454 <printf>
      exit(1);
    118a:	4505                	li	a0,1
    118c:	67b030ef          	jal	5006 <exit>
    printf("unlink(%s) returned %d, not -1\n", b, ret);
    1190:	862a                	mv	a2,a0
    1192:	f6840593          	addi	a1,s0,-152
    1196:	00005517          	auipc	a0,0x5
    119a:	c5250513          	addi	a0,a0,-942 # 5de8 <malloc+0x8dc>
    119e:	2b6040ef          	jal	5454 <printf>
    exit(1);
    11a2:	4505                	li	a0,1
    11a4:	663030ef          	jal	5006 <exit>
    printf("open(%s) returned %d, not -1\n", b, fd);
    11a8:	862a                	mv	a2,a0
    11aa:	f6840593          	addi	a1,s0,-152
    11ae:	00005517          	auipc	a0,0x5
    11b2:	c5a50513          	addi	a0,a0,-934 # 5e08 <malloc+0x8fc>
    11b6:	29e040ef          	jal	5454 <printf>
    exit(1);
    11ba:	4505                	li	a0,1
    11bc:	64b030ef          	jal	5006 <exit>
    printf("link(%s, %s) returned %d, not -1\n", b, b, ret);
    11c0:	f6840593          	addi	a1,s0,-152
    11c4:	86aa                	mv	a3,a0
    11c6:	862e                	mv	a2,a1
    11c8:	00005517          	auipc	a0,0x5
    11cc:	c6050513          	addi	a0,a0,-928 # 5e28 <malloc+0x91c>
    11d0:	284040ef          	jal	5454 <printf>
    exit(1);
    11d4:	4505                	li	a0,1
    11d6:	631030ef          	jal	5006 <exit>
    printf("exec(%s) returned %d, not -1\n", b, fd);
    11da:	863e                	mv	a2,a5
    11dc:	f6840593          	addi	a1,s0,-152
    11e0:	00005517          	auipc	a0,0x5
    11e4:	c7050513          	addi	a0,a0,-912 # 5e50 <malloc+0x944>
    11e8:	26c040ef          	jal	5454 <printf>
    exit(1);
    11ec:	4505                	li	a0,1
    11ee:	619030ef          	jal	5006 <exit>
    printf("fork failed\n");
    11f2:	00006517          	auipc	a0,0x6
    11f6:	27e50513          	addi	a0,a0,638 # 7470 <malloc+0x1f64>
    11fa:	25a040ef          	jal	5454 <printf>
    exit(1);
    11fe:	4505                	li	a0,1
    1200:	607030ef          	jal	5006 <exit>
    exit(747); // OK
    1204:	2eb00513          	li	a0,747
    1208:	5ff030ef          	jal	5006 <exit>
  int st = 0;
    120c:	f4042a23          	sw	zero,-172(s0)
  wait(&st);
    1210:	f5440513          	addi	a0,s0,-172
    1214:	5fb030ef          	jal	500e <wait>
  if(st != 747){
    1218:	f5442703          	lw	a4,-172(s0)
    121c:	2eb00793          	li	a5,747
    1220:	00f71663          	bne	a4,a5,122c <copyinstr2+0x18c>
}
    1224:	60ae                	ld	ra,200(sp)
    1226:	640e                	ld	s0,192(sp)
    1228:	6169                	addi	sp,sp,208
    122a:	8082                	ret
    printf("exec(echo, BIG) succeeded, should have failed\n");
    122c:	00005517          	auipc	a0,0x5
    1230:	c6c50513          	addi	a0,a0,-916 # 5e98 <malloc+0x98c>
    1234:	220040ef          	jal	5454 <printf>
    exit(1);
    1238:	4505                	li	a0,1
    123a:	5cd030ef          	jal	5006 <exit>

000000000000123e <truncate3>:
{
    123e:	7175                	addi	sp,sp,-144
    1240:	e506                	sd	ra,136(sp)
    1242:	e122                	sd	s0,128(sp)
    1244:	fc66                	sd	s9,56(sp)
    1246:	0900                	addi	s0,sp,144
    1248:	8caa                	mv	s9,a0
  close(open("truncfile", O_CREATE|O_TRUNC|O_WRONLY));
    124a:	60100593          	li	a1,1537
    124e:	00004517          	auipc	a0,0x4
    1252:	44250513          	addi	a0,a0,1090 # 5690 <malloc+0x184>
    1256:	5f1030ef          	jal	5046 <open>
    125a:	5d5030ef          	jal	502e <close>
  pid = fork();
    125e:	5a1030ef          	jal	4ffe <fork>
  if(pid < 0){
    1262:	06054d63          	bltz	a0,12dc <truncate3+0x9e>
  if(pid == 0){
    1266:	e171                	bnez	a0,132a <truncate3+0xec>
    1268:	fca6                	sd	s1,120(sp)
    126a:	f8ca                	sd	s2,112(sp)
    126c:	f4ce                	sd	s3,104(sp)
    126e:	f0d2                	sd	s4,96(sp)
    1270:	ecd6                	sd	s5,88(sp)
    1272:	e8da                	sd	s6,80(sp)
    1274:	e4de                	sd	s7,72(sp)
    1276:	e0e2                	sd	s8,64(sp)
    1278:	06400913          	li	s2,100
      int fd = open("truncfile", O_WRONLY);
    127c:	4a85                	li	s5,1
    127e:	00004997          	auipc	s3,0x4
    1282:	41298993          	addi	s3,s3,1042 # 5690 <malloc+0x184>
      int n = write(fd, "1234567890", 10);
    1286:	4a29                	li	s4,10
    1288:	00005b17          	auipc	s6,0x5
    128c:	c70b0b13          	addi	s6,s6,-912 # 5ef8 <malloc+0x9ec>
      read(fd, buf, sizeof(buf));
    1290:	f7840c13          	addi	s8,s0,-136
    1294:	02000b93          	li	s7,32
      int fd = open("truncfile", O_WRONLY);
    1298:	85d6                	mv	a1,s5
    129a:	854e                	mv	a0,s3
    129c:	5ab030ef          	jal	5046 <open>
    12a0:	84aa                	mv	s1,a0
      if(fd < 0){
    12a2:	04054f63          	bltz	a0,1300 <truncate3+0xc2>
      int n = write(fd, "1234567890", 10);
    12a6:	8652                	mv	a2,s4
    12a8:	85da                	mv	a1,s6
    12aa:	57d030ef          	jal	5026 <write>
      if(n != 10){
    12ae:	07451363          	bne	a0,s4,1314 <truncate3+0xd6>
      close(fd);
    12b2:	8526                	mv	a0,s1
    12b4:	57b030ef          	jal	502e <close>
      fd = open("truncfile", O_RDONLY);
    12b8:	4581                	li	a1,0
    12ba:	854e                	mv	a0,s3
    12bc:	58b030ef          	jal	5046 <open>
    12c0:	84aa                	mv	s1,a0
      read(fd, buf, sizeof(buf));
    12c2:	865e                	mv	a2,s7
    12c4:	85e2                	mv	a1,s8
    12c6:	559030ef          	jal	501e <read>
      close(fd);
    12ca:	8526                	mv	a0,s1
    12cc:	563030ef          	jal	502e <close>
    for(int i = 0; i < 100; i++){
    12d0:	397d                	addiw	s2,s2,-1
    12d2:	fc0913e3          	bnez	s2,1298 <truncate3+0x5a>
    exit(0);
    12d6:	4501                	li	a0,0
    12d8:	52f030ef          	jal	5006 <exit>
    12dc:	fca6                	sd	s1,120(sp)
    12de:	f8ca                	sd	s2,112(sp)
    12e0:	f4ce                	sd	s3,104(sp)
    12e2:	f0d2                	sd	s4,96(sp)
    12e4:	ecd6                	sd	s5,88(sp)
    12e6:	e8da                	sd	s6,80(sp)
    12e8:	e4de                	sd	s7,72(sp)
    12ea:	e0e2                	sd	s8,64(sp)
    printf("%s: fork failed\n", s);
    12ec:	85e6                	mv	a1,s9
    12ee:	00005517          	auipc	a0,0x5
    12f2:	bda50513          	addi	a0,a0,-1062 # 5ec8 <malloc+0x9bc>
    12f6:	15e040ef          	jal	5454 <printf>
    exit(1);
    12fa:	4505                	li	a0,1
    12fc:	50b030ef          	jal	5006 <exit>
        printf("%s: open failed\n", s);
    1300:	85e6                	mv	a1,s9
    1302:	00005517          	auipc	a0,0x5
    1306:	bde50513          	addi	a0,a0,-1058 # 5ee0 <malloc+0x9d4>
    130a:	14a040ef          	jal	5454 <printf>
        exit(1);
    130e:	4505                	li	a0,1
    1310:	4f7030ef          	jal	5006 <exit>
        printf("%s: write got %d, expected 10\n", s, n);
    1314:	862a                	mv	a2,a0
    1316:	85e6                	mv	a1,s9
    1318:	00005517          	auipc	a0,0x5
    131c:	bf050513          	addi	a0,a0,-1040 # 5f08 <malloc+0x9fc>
    1320:	134040ef          	jal	5454 <printf>
        exit(1);
    1324:	4505                	li	a0,1
    1326:	4e1030ef          	jal	5006 <exit>
    132a:	fca6                	sd	s1,120(sp)
    132c:	f8ca                	sd	s2,112(sp)
    132e:	f4ce                	sd	s3,104(sp)
    1330:	f0d2                	sd	s4,96(sp)
    1332:	ecd6                	sd	s5,88(sp)
    1334:	e8da                	sd	s6,80(sp)
    1336:	09600913          	li	s2,150
    int fd = open("truncfile", O_CREATE|O_WRONLY|O_TRUNC);
    133a:	60100a93          	li	s5,1537
    133e:	00004a17          	auipc	s4,0x4
    1342:	352a0a13          	addi	s4,s4,850 # 5690 <malloc+0x184>
    int n = write(fd, "xxx", 3);
    1346:	498d                	li	s3,3
    1348:	00005b17          	auipc	s6,0x5
    134c:	be0b0b13          	addi	s6,s6,-1056 # 5f28 <malloc+0xa1c>
    int fd = open("truncfile", O_CREATE|O_WRONLY|O_TRUNC);
    1350:	85d6                	mv	a1,s5
    1352:	8552                	mv	a0,s4
    1354:	4f3030ef          	jal	5046 <open>
    1358:	84aa                	mv	s1,a0
    if(fd < 0){
    135a:	02054e63          	bltz	a0,1396 <truncate3+0x158>
    int n = write(fd, "xxx", 3);
    135e:	864e                	mv	a2,s3
    1360:	85da                	mv	a1,s6
    1362:	4c5030ef          	jal	5026 <write>
    if(n != 3){
    1366:	05351463          	bne	a0,s3,13ae <truncate3+0x170>
    close(fd);
    136a:	8526                	mv	a0,s1
    136c:	4c3030ef          	jal	502e <close>
  for(int i = 0; i < 150; i++){
    1370:	397d                	addiw	s2,s2,-1
    1372:	fc091fe3          	bnez	s2,1350 <truncate3+0x112>
    1376:	e4de                	sd	s7,72(sp)
    1378:	e0e2                	sd	s8,64(sp)
  wait(&xstatus);
    137a:	f9c40513          	addi	a0,s0,-100
    137e:	491030ef          	jal	500e <wait>
  unlink("truncfile");
    1382:	00004517          	auipc	a0,0x4
    1386:	30e50513          	addi	a0,a0,782 # 5690 <malloc+0x184>
    138a:	4cd030ef          	jal	5056 <unlink>
  exit(xstatus);
    138e:	f9c42503          	lw	a0,-100(s0)
    1392:	475030ef          	jal	5006 <exit>
    1396:	e4de                	sd	s7,72(sp)
    1398:	e0e2                	sd	s8,64(sp)
      printf("%s: open failed\n", s);
    139a:	85e6                	mv	a1,s9
    139c:	00005517          	auipc	a0,0x5
    13a0:	b4450513          	addi	a0,a0,-1212 # 5ee0 <malloc+0x9d4>
    13a4:	0b0040ef          	jal	5454 <printf>
      exit(1);
    13a8:	4505                	li	a0,1
    13aa:	45d030ef          	jal	5006 <exit>
    13ae:	e4de                	sd	s7,72(sp)
    13b0:	e0e2                	sd	s8,64(sp)
      printf("%s: write got %d, expected 3\n", s, n);
    13b2:	862a                	mv	a2,a0
    13b4:	85e6                	mv	a1,s9
    13b6:	00005517          	auipc	a0,0x5
    13ba:	b7a50513          	addi	a0,a0,-1158 # 5f30 <malloc+0xa24>
    13be:	096040ef          	jal	5454 <printf>
      exit(1);
    13c2:	4505                	li	a0,1
    13c4:	443030ef          	jal	5006 <exit>

00000000000013c8 <exectest>:
{
    13c8:	715d                	addi	sp,sp,-80
    13ca:	e486                	sd	ra,72(sp)
    13cc:	e0a2                	sd	s0,64(sp)
    13ce:	f84a                	sd	s2,48(sp)
    13d0:	0880                	addi	s0,sp,80
    13d2:	892a                	mv	s2,a0
  char *echoargv[] = { "echo", "OK", 0 };
    13d4:	00004797          	auipc	a5,0x4
    13d8:	26478793          	addi	a5,a5,612 # 5638 <malloc+0x12c>
    13dc:	fcf43023          	sd	a5,-64(s0)
    13e0:	00005797          	auipc	a5,0x5
    13e4:	b7078793          	addi	a5,a5,-1168 # 5f50 <malloc+0xa44>
    13e8:	fcf43423          	sd	a5,-56(s0)
    13ec:	fc043823          	sd	zero,-48(s0)
  unlink("echo-ok");
    13f0:	00005517          	auipc	a0,0x5
    13f4:	b6850513          	addi	a0,a0,-1176 # 5f58 <malloc+0xa4c>
    13f8:	45f030ef          	jal	5056 <unlink>
  pid = fork();
    13fc:	403030ef          	jal	4ffe <fork>
  if(pid < 0) {
    1400:	02054f63          	bltz	a0,143e <exectest+0x76>
    1404:	fc26                	sd	s1,56(sp)
    1406:	84aa                	mv	s1,a0
  if(pid == 0) {
    1408:	e935                	bnez	a0,147c <exectest+0xb4>
    close(1);
    140a:	4505                	li	a0,1
    140c:	423030ef          	jal	502e <close>
    fd = open("echo-ok", O_CREATE|O_WRONLY);
    1410:	20100593          	li	a1,513
    1414:	00005517          	auipc	a0,0x5
    1418:	b4450513          	addi	a0,a0,-1212 # 5f58 <malloc+0xa4c>
    141c:	42b030ef          	jal	5046 <open>
    if(fd < 0) {
    1420:	02054a63          	bltz	a0,1454 <exectest+0x8c>
    if(fd != 1) {
    1424:	4785                	li	a5,1
    1426:	04f50163          	beq	a0,a5,1468 <exectest+0xa0>
      printf("%s: wrong fd\n", s);
    142a:	85ca                	mv	a1,s2
    142c:	00005517          	auipc	a0,0x5
    1430:	b4c50513          	addi	a0,a0,-1204 # 5f78 <malloc+0xa6c>
    1434:	020040ef          	jal	5454 <printf>
      exit(1);
    1438:	4505                	li	a0,1
    143a:	3cd030ef          	jal	5006 <exit>
    143e:	fc26                	sd	s1,56(sp)
     printf("%s: fork failed\n", s);
    1440:	85ca                	mv	a1,s2
    1442:	00005517          	auipc	a0,0x5
    1446:	a8650513          	addi	a0,a0,-1402 # 5ec8 <malloc+0x9bc>
    144a:	00a040ef          	jal	5454 <printf>
     exit(1);
    144e:	4505                	li	a0,1
    1450:	3b7030ef          	jal	5006 <exit>
      printf("%s: create failed\n", s);
    1454:	85ca                	mv	a1,s2
    1456:	00005517          	auipc	a0,0x5
    145a:	b0a50513          	addi	a0,a0,-1270 # 5f60 <malloc+0xa54>
    145e:	7f7030ef          	jal	5454 <printf>
      exit(1);
    1462:	4505                	li	a0,1
    1464:	3a3030ef          	jal	5006 <exit>
    if(exec("echo", echoargv) < 0){
    1468:	fc040593          	addi	a1,s0,-64
    146c:	00004517          	auipc	a0,0x4
    1470:	1cc50513          	addi	a0,a0,460 # 5638 <malloc+0x12c>
    1474:	3cb030ef          	jal	503e <exec>
    1478:	00054d63          	bltz	a0,1492 <exectest+0xca>
  if (wait(&xstatus) != pid) {
    147c:	fdc40513          	addi	a0,s0,-36
    1480:	38f030ef          	jal	500e <wait>
    1484:	02951163          	bne	a0,s1,14a6 <exectest+0xde>
  if(xstatus != 0)
    1488:	fdc42503          	lw	a0,-36(s0)
    148c:	c50d                	beqz	a0,14b6 <exectest+0xee>
    exit(xstatus);
    148e:	379030ef          	jal	5006 <exit>
      printf("%s: exec echo failed\n", s);
    1492:	85ca                	mv	a1,s2
    1494:	00005517          	auipc	a0,0x5
    1498:	af450513          	addi	a0,a0,-1292 # 5f88 <malloc+0xa7c>
    149c:	7b9030ef          	jal	5454 <printf>
      exit(1);
    14a0:	4505                	li	a0,1
    14a2:	365030ef          	jal	5006 <exit>
    printf("%s: wait failed!\n", s);
    14a6:	85ca                	mv	a1,s2
    14a8:	00005517          	auipc	a0,0x5
    14ac:	af850513          	addi	a0,a0,-1288 # 5fa0 <malloc+0xa94>
    14b0:	7a5030ef          	jal	5454 <printf>
    14b4:	bfd1                	j	1488 <exectest+0xc0>
  fd = open("echo-ok", O_RDONLY);
    14b6:	4581                	li	a1,0
    14b8:	00005517          	auipc	a0,0x5
    14bc:	aa050513          	addi	a0,a0,-1376 # 5f58 <malloc+0xa4c>
    14c0:	387030ef          	jal	5046 <open>
  if(fd < 0) {
    14c4:	02054463          	bltz	a0,14ec <exectest+0x124>
  if (read(fd, buf, 2) != 2) {
    14c8:	4609                	li	a2,2
    14ca:	fb840593          	addi	a1,s0,-72
    14ce:	351030ef          	jal	501e <read>
    14d2:	4789                	li	a5,2
    14d4:	02f50663          	beq	a0,a5,1500 <exectest+0x138>
    printf("%s: read failed\n", s);
    14d8:	85ca                	mv	a1,s2
    14da:	00004517          	auipc	a0,0x4
    14de:	52e50513          	addi	a0,a0,1326 # 5a08 <malloc+0x4fc>
    14e2:	773030ef          	jal	5454 <printf>
    exit(1);
    14e6:	4505                	li	a0,1
    14e8:	31f030ef          	jal	5006 <exit>
    printf("%s: open failed\n", s);
    14ec:	85ca                	mv	a1,s2
    14ee:	00005517          	auipc	a0,0x5
    14f2:	9f250513          	addi	a0,a0,-1550 # 5ee0 <malloc+0x9d4>
    14f6:	75f030ef          	jal	5454 <printf>
    exit(1);
    14fa:	4505                	li	a0,1
    14fc:	30b030ef          	jal	5006 <exit>
  unlink("echo-ok");
    1500:	00005517          	auipc	a0,0x5
    1504:	a5850513          	addi	a0,a0,-1448 # 5f58 <malloc+0xa4c>
    1508:	34f030ef          	jal	5056 <unlink>
  if(buf[0] == 'O' && buf[1] == 'K')
    150c:	fb844703          	lbu	a4,-72(s0)
    1510:	04f00793          	li	a5,79
    1514:	00f71863          	bne	a4,a5,1524 <exectest+0x15c>
    1518:	fb944703          	lbu	a4,-71(s0)
    151c:	04b00793          	li	a5,75
    1520:	00f70c63          	beq	a4,a5,1538 <exectest+0x170>
    printf("%s: wrong output\n", s);
    1524:	85ca                	mv	a1,s2
    1526:	00005517          	auipc	a0,0x5
    152a:	a9250513          	addi	a0,a0,-1390 # 5fb8 <malloc+0xaac>
    152e:	727030ef          	jal	5454 <printf>
    exit(1);
    1532:	4505                	li	a0,1
    1534:	2d3030ef          	jal	5006 <exit>
    exit(0);
    1538:	4501                	li	a0,0
    153a:	2cd030ef          	jal	5006 <exit>

000000000000153e <pipe1>:
{
    153e:	711d                	addi	sp,sp,-96
    1540:	ec86                	sd	ra,88(sp)
    1542:	e8a2                	sd	s0,80(sp)
    1544:	e862                	sd	s8,16(sp)
    1546:	1080                	addi	s0,sp,96
    1548:	8c2a                	mv	s8,a0
  if(pipe(fds) != 0){
    154a:	fa840513          	addi	a0,s0,-88
    154e:	2c9030ef          	jal	5016 <pipe>
    1552:	e925                	bnez	a0,15c2 <pipe1+0x84>
    1554:	e4a6                	sd	s1,72(sp)
    1556:	fc4e                	sd	s3,56(sp)
    1558:	84aa                	mv	s1,a0
  pid = fork();
    155a:	2a5030ef          	jal	4ffe <fork>
    155e:	89aa                	mv	s3,a0
  if(pid == 0){
    1560:	c151                	beqz	a0,15e4 <pipe1+0xa6>
  } else if(pid > 0){
    1562:	16a05063          	blez	a0,16c2 <pipe1+0x184>
    1566:	e0ca                	sd	s2,64(sp)
    1568:	f852                	sd	s4,48(sp)
    close(fds[1]);
    156a:	fac42503          	lw	a0,-84(s0)
    156e:	2c1030ef          	jal	502e <close>
    total = 0;
    1572:	89a6                	mv	s3,s1
    cc = 1;
    1574:	4905                	li	s2,1
    while((n = read(fds[0], buf, cc)) > 0){
    1576:	0000ca17          	auipc	s4,0xc
    157a:	742a0a13          	addi	s4,s4,1858 # dcb8 <buf>
    157e:	864a                	mv	a2,s2
    1580:	85d2                	mv	a1,s4
    1582:	fa842503          	lw	a0,-88(s0)
    1586:	299030ef          	jal	501e <read>
    158a:	85aa                	mv	a1,a0
    158c:	0ea05963          	blez	a0,167e <pipe1+0x140>
    1590:	0000c797          	auipc	a5,0xc
    1594:	72878793          	addi	a5,a5,1832 # dcb8 <buf>
    1598:	00b4863b          	addw	a2,s1,a1
        if((buf[i] & 0xff) != (seq++ & 0xff)){
    159c:	0007c683          	lbu	a3,0(a5)
    15a0:	0ff4f713          	zext.b	a4,s1
    15a4:	0ae69d63          	bne	a3,a4,165e <pipe1+0x120>
    15a8:	2485                	addiw	s1,s1,1
      for(i = 0; i < n; i++){
    15aa:	0785                	addi	a5,a5,1
    15ac:	fec498e3          	bne	s1,a2,159c <pipe1+0x5e>
      total += n;
    15b0:	00b989bb          	addw	s3,s3,a1
      cc = cc * 2;
    15b4:	0019191b          	slliw	s2,s2,0x1
      if(cc > sizeof(buf))
    15b8:	678d                	lui	a5,0x3
    15ba:	fd27f2e3          	bgeu	a5,s2,157e <pipe1+0x40>
        cc = sizeof(buf);
    15be:	893e                	mv	s2,a5
    15c0:	bf7d                	j	157e <pipe1+0x40>
    15c2:	e4a6                	sd	s1,72(sp)
    15c4:	e0ca                	sd	s2,64(sp)
    15c6:	fc4e                	sd	s3,56(sp)
    15c8:	f852                	sd	s4,48(sp)
    15ca:	f456                	sd	s5,40(sp)
    15cc:	f05a                	sd	s6,32(sp)
    15ce:	ec5e                	sd	s7,24(sp)
    printf("%s: pipe() failed\n", s);
    15d0:	85e2                	mv	a1,s8
    15d2:	00005517          	auipc	a0,0x5
    15d6:	9fe50513          	addi	a0,a0,-1538 # 5fd0 <malloc+0xac4>
    15da:	67b030ef          	jal	5454 <printf>
    exit(1);
    15de:	4505                	li	a0,1
    15e0:	227030ef          	jal	5006 <exit>
    15e4:	e0ca                	sd	s2,64(sp)
    15e6:	f852                	sd	s4,48(sp)
    15e8:	f456                	sd	s5,40(sp)
    15ea:	f05a                	sd	s6,32(sp)
    15ec:	ec5e                	sd	s7,24(sp)
    close(fds[0]);
    15ee:	fa842503          	lw	a0,-88(s0)
    15f2:	23d030ef          	jal	502e <close>
    for(n = 0; n < N; n++){
    15f6:	0000cb17          	auipc	s6,0xc
    15fa:	6c2b0b13          	addi	s6,s6,1730 # dcb8 <buf>
    15fe:	416004bb          	negw	s1,s6
    1602:	0ff4f493          	zext.b	s1,s1
    1606:	409b0913          	addi	s2,s6,1033
      if(write(fds[1], buf, SZ) != SZ){
    160a:	40900a13          	li	s4,1033
    160e:	8bda                	mv	s7,s6
    for(n = 0; n < N; n++){
    1610:	6a85                	lui	s5,0x1
    1612:	42da8a93          	addi	s5,s5,1069 # 142d <exectest+0x65>
{
    1616:	87da                	mv	a5,s6
        buf[i] = seq++;
    1618:	0097873b          	addw	a4,a5,s1
    161c:	00e78023          	sb	a4,0(a5) # 3000 <subdir+0x2f0>
      for(i = 0; i < SZ; i++)
    1620:	0785                	addi	a5,a5,1
    1622:	ff279be3          	bne	a5,s2,1618 <pipe1+0xda>
      if(write(fds[1], buf, SZ) != SZ){
    1626:	8652                	mv	a2,s4
    1628:	85de                	mv	a1,s7
    162a:	fac42503          	lw	a0,-84(s0)
    162e:	1f9030ef          	jal	5026 <write>
    1632:	01451c63          	bne	a0,s4,164a <pipe1+0x10c>
    1636:	4099899b          	addiw	s3,s3,1033
    for(n = 0; n < N; n++){
    163a:	24a5                	addiw	s1,s1,9
    163c:	0ff4f493          	zext.b	s1,s1
    1640:	fd599be3          	bne	s3,s5,1616 <pipe1+0xd8>
    exit(0);
    1644:	4501                	li	a0,0
    1646:	1c1030ef          	jal	5006 <exit>
        printf("%s: pipe1 oops 1\n", s);
    164a:	85e2                	mv	a1,s8
    164c:	00005517          	auipc	a0,0x5
    1650:	99c50513          	addi	a0,a0,-1636 # 5fe8 <malloc+0xadc>
    1654:	601030ef          	jal	5454 <printf>
        exit(1);
    1658:	4505                	li	a0,1
    165a:	1ad030ef          	jal	5006 <exit>
          printf("%s: pipe1 oops 2\n", s);
    165e:	85e2                	mv	a1,s8
    1660:	00005517          	auipc	a0,0x5
    1664:	9a050513          	addi	a0,a0,-1632 # 6000 <malloc+0xaf4>
    1668:	5ed030ef          	jal	5454 <printf>
          return;
    166c:	64a6                	ld	s1,72(sp)
    166e:	6906                	ld	s2,64(sp)
    1670:	79e2                	ld	s3,56(sp)
    1672:	7a42                	ld	s4,48(sp)
}
    1674:	60e6                	ld	ra,88(sp)
    1676:	6446                	ld	s0,80(sp)
    1678:	6c42                	ld	s8,16(sp)
    167a:	6125                	addi	sp,sp,96
    167c:	8082                	ret
    if(total != N * SZ){
    167e:	6785                	lui	a5,0x1
    1680:	42d78793          	addi	a5,a5,1069 # 142d <exectest+0x65>
    1684:	02f98063          	beq	s3,a5,16a4 <pipe1+0x166>
    1688:	f456                	sd	s5,40(sp)
    168a:	f05a                	sd	s6,32(sp)
    168c:	ec5e                	sd	s7,24(sp)
      printf("%s: pipe1 oops 3 total %d\n", s, total);
    168e:	864e                	mv	a2,s3
    1690:	85e2                	mv	a1,s8
    1692:	00005517          	auipc	a0,0x5
    1696:	98650513          	addi	a0,a0,-1658 # 6018 <malloc+0xb0c>
    169a:	5bb030ef          	jal	5454 <printf>
      exit(1);
    169e:	4505                	li	a0,1
    16a0:	167030ef          	jal	5006 <exit>
    16a4:	f456                	sd	s5,40(sp)
    16a6:	f05a                	sd	s6,32(sp)
    16a8:	ec5e                	sd	s7,24(sp)
    close(fds[0]);
    16aa:	fa842503          	lw	a0,-88(s0)
    16ae:	181030ef          	jal	502e <close>
    wait(&xstatus);
    16b2:	fa440513          	addi	a0,s0,-92
    16b6:	159030ef          	jal	500e <wait>
    exit(xstatus);
    16ba:	fa442503          	lw	a0,-92(s0)
    16be:	149030ef          	jal	5006 <exit>
    16c2:	e0ca                	sd	s2,64(sp)
    16c4:	f852                	sd	s4,48(sp)
    16c6:	f456                	sd	s5,40(sp)
    16c8:	f05a                	sd	s6,32(sp)
    16ca:	ec5e                	sd	s7,24(sp)
    printf("%s: fork() failed\n", s);
    16cc:	85e2                	mv	a1,s8
    16ce:	00005517          	auipc	a0,0x5
    16d2:	96a50513          	addi	a0,a0,-1686 # 6038 <malloc+0xb2c>
    16d6:	57f030ef          	jal	5454 <printf>
    exit(1);
    16da:	4505                	li	a0,1
    16dc:	12b030ef          	jal	5006 <exit>

00000000000016e0 <exitwait>:
{
    16e0:	715d                	addi	sp,sp,-80
    16e2:	e486                	sd	ra,72(sp)
    16e4:	e0a2                	sd	s0,64(sp)
    16e6:	fc26                	sd	s1,56(sp)
    16e8:	f84a                	sd	s2,48(sp)
    16ea:	f44e                	sd	s3,40(sp)
    16ec:	f052                	sd	s4,32(sp)
    16ee:	ec56                	sd	s5,24(sp)
    16f0:	0880                	addi	s0,sp,80
    16f2:	8aaa                	mv	s5,a0
  for(i = 0; i < 100; i++){
    16f4:	4901                	li	s2,0
      if(wait(&xstate) != pid){
    16f6:	fbc40993          	addi	s3,s0,-68
  for(i = 0; i < 100; i++){
    16fa:	06400a13          	li	s4,100
    pid = fork();
    16fe:	101030ef          	jal	4ffe <fork>
    1702:	84aa                	mv	s1,a0
    if(pid < 0){
    1704:	02054863          	bltz	a0,1734 <exitwait+0x54>
    if(pid){
    1708:	c525                	beqz	a0,1770 <exitwait+0x90>
      if(wait(&xstate) != pid){
    170a:	854e                	mv	a0,s3
    170c:	103030ef          	jal	500e <wait>
    1710:	02951c63          	bne	a0,s1,1748 <exitwait+0x68>
      if(i != xstate) {
    1714:	fbc42783          	lw	a5,-68(s0)
    1718:	05279263          	bne	a5,s2,175c <exitwait+0x7c>
  for(i = 0; i < 100; i++){
    171c:	2905                	addiw	s2,s2,1
    171e:	ff4910e3          	bne	s2,s4,16fe <exitwait+0x1e>
}
    1722:	60a6                	ld	ra,72(sp)
    1724:	6406                	ld	s0,64(sp)
    1726:	74e2                	ld	s1,56(sp)
    1728:	7942                	ld	s2,48(sp)
    172a:	79a2                	ld	s3,40(sp)
    172c:	7a02                	ld	s4,32(sp)
    172e:	6ae2                	ld	s5,24(sp)
    1730:	6161                	addi	sp,sp,80
    1732:	8082                	ret
      printf("%s: fork failed\n", s);
    1734:	85d6                	mv	a1,s5
    1736:	00004517          	auipc	a0,0x4
    173a:	79250513          	addi	a0,a0,1938 # 5ec8 <malloc+0x9bc>
    173e:	517030ef          	jal	5454 <printf>
      exit(1);
    1742:	4505                	li	a0,1
    1744:	0c3030ef          	jal	5006 <exit>
        printf("%s: wait wrong pid\n", s);
    1748:	85d6                	mv	a1,s5
    174a:	00005517          	auipc	a0,0x5
    174e:	90650513          	addi	a0,a0,-1786 # 6050 <malloc+0xb44>
    1752:	503030ef          	jal	5454 <printf>
        exit(1);
    1756:	4505                	li	a0,1
    1758:	0af030ef          	jal	5006 <exit>
        printf("%s: wait wrong exit status\n", s);
    175c:	85d6                	mv	a1,s5
    175e:	00005517          	auipc	a0,0x5
    1762:	90a50513          	addi	a0,a0,-1782 # 6068 <malloc+0xb5c>
    1766:	4ef030ef          	jal	5454 <printf>
        exit(1);
    176a:	4505                	li	a0,1
    176c:	09b030ef          	jal	5006 <exit>
      exit(i);
    1770:	854a                	mv	a0,s2
    1772:	095030ef          	jal	5006 <exit>

0000000000001776 <twochildren>:
{
    1776:	1101                	addi	sp,sp,-32
    1778:	ec06                	sd	ra,24(sp)
    177a:	e822                	sd	s0,16(sp)
    177c:	e426                	sd	s1,8(sp)
    177e:	e04a                	sd	s2,0(sp)
    1780:	1000                	addi	s0,sp,32
    1782:	892a                	mv	s2,a0
    1784:	3e800493          	li	s1,1000
    int pid1 = fork();
    1788:	077030ef          	jal	4ffe <fork>
    if(pid1 < 0){
    178c:	02054663          	bltz	a0,17b8 <twochildren+0x42>
    if(pid1 == 0){
    1790:	cd15                	beqz	a0,17cc <twochildren+0x56>
      int pid2 = fork();
    1792:	06d030ef          	jal	4ffe <fork>
      if(pid2 < 0){
    1796:	02054d63          	bltz	a0,17d0 <twochildren+0x5a>
      if(pid2 == 0){
    179a:	c529                	beqz	a0,17e4 <twochildren+0x6e>
        wait(0);
    179c:	4501                	li	a0,0
    179e:	071030ef          	jal	500e <wait>
        wait(0);
    17a2:	4501                	li	a0,0
    17a4:	06b030ef          	jal	500e <wait>
  for(int i = 0; i < 1000; i++){
    17a8:	34fd                	addiw	s1,s1,-1
    17aa:	fcf9                	bnez	s1,1788 <twochildren+0x12>
}
    17ac:	60e2                	ld	ra,24(sp)
    17ae:	6442                	ld	s0,16(sp)
    17b0:	64a2                	ld	s1,8(sp)
    17b2:	6902                	ld	s2,0(sp)
    17b4:	6105                	addi	sp,sp,32
    17b6:	8082                	ret
      printf("%s: fork failed\n", s);
    17b8:	85ca                	mv	a1,s2
    17ba:	00004517          	auipc	a0,0x4
    17be:	70e50513          	addi	a0,a0,1806 # 5ec8 <malloc+0x9bc>
    17c2:	493030ef          	jal	5454 <printf>
      exit(1);
    17c6:	4505                	li	a0,1
    17c8:	03f030ef          	jal	5006 <exit>
      exit(0);
    17cc:	03b030ef          	jal	5006 <exit>
        printf("%s: fork failed\n", s);
    17d0:	85ca                	mv	a1,s2
    17d2:	00004517          	auipc	a0,0x4
    17d6:	6f650513          	addi	a0,a0,1782 # 5ec8 <malloc+0x9bc>
    17da:	47b030ef          	jal	5454 <printf>
        exit(1);
    17de:	4505                	li	a0,1
    17e0:	027030ef          	jal	5006 <exit>
        exit(0);
    17e4:	023030ef          	jal	5006 <exit>

00000000000017e8 <forkfork>:
{
    17e8:	7179                	addi	sp,sp,-48
    17ea:	f406                	sd	ra,40(sp)
    17ec:	f022                	sd	s0,32(sp)
    17ee:	ec26                	sd	s1,24(sp)
    17f0:	1800                	addi	s0,sp,48
    17f2:	84aa                	mv	s1,a0
    int pid = fork();
    17f4:	00b030ef          	jal	4ffe <fork>
    if(pid < 0){
    17f8:	02054b63          	bltz	a0,182e <forkfork+0x46>
    if(pid == 0){
    17fc:	c139                	beqz	a0,1842 <forkfork+0x5a>
    int pid = fork();
    17fe:	001030ef          	jal	4ffe <fork>
    if(pid < 0){
    1802:	02054663          	bltz	a0,182e <forkfork+0x46>
    if(pid == 0){
    1806:	cd15                	beqz	a0,1842 <forkfork+0x5a>
    wait(&xstatus);
    1808:	fdc40513          	addi	a0,s0,-36
    180c:	003030ef          	jal	500e <wait>
    if(xstatus != 0) {
    1810:	fdc42783          	lw	a5,-36(s0)
    1814:	ebb9                	bnez	a5,186a <forkfork+0x82>
    wait(&xstatus);
    1816:	fdc40513          	addi	a0,s0,-36
    181a:	7f4030ef          	jal	500e <wait>
    if(xstatus != 0) {
    181e:	fdc42783          	lw	a5,-36(s0)
    1822:	e7a1                	bnez	a5,186a <forkfork+0x82>
}
    1824:	70a2                	ld	ra,40(sp)
    1826:	7402                	ld	s0,32(sp)
    1828:	64e2                	ld	s1,24(sp)
    182a:	6145                	addi	sp,sp,48
    182c:	8082                	ret
      printf("%s: fork failed", s);
    182e:	85a6                	mv	a1,s1
    1830:	00005517          	auipc	a0,0x5
    1834:	85850513          	addi	a0,a0,-1960 # 6088 <malloc+0xb7c>
    1838:	41d030ef          	jal	5454 <printf>
      exit(1);
    183c:	4505                	li	a0,1
    183e:	7c8030ef          	jal	5006 <exit>
{
    1842:	0c800493          	li	s1,200
        int pid1 = fork();
    1846:	7b8030ef          	jal	4ffe <fork>
        if(pid1 < 0){
    184a:	00054b63          	bltz	a0,1860 <forkfork+0x78>
        if(pid1 == 0){
    184e:	cd01                	beqz	a0,1866 <forkfork+0x7e>
        wait(0);
    1850:	4501                	li	a0,0
    1852:	7bc030ef          	jal	500e <wait>
      for(int j = 0; j < 200; j++){
    1856:	34fd                	addiw	s1,s1,-1
    1858:	f4fd                	bnez	s1,1846 <forkfork+0x5e>
      exit(0);
    185a:	4501                	li	a0,0
    185c:	7aa030ef          	jal	5006 <exit>
          exit(1);
    1860:	4505                	li	a0,1
    1862:	7a4030ef          	jal	5006 <exit>
          exit(0);
    1866:	7a0030ef          	jal	5006 <exit>
      printf("%s: fork in child failed", s);
    186a:	85a6                	mv	a1,s1
    186c:	00005517          	auipc	a0,0x5
    1870:	82c50513          	addi	a0,a0,-2004 # 6098 <malloc+0xb8c>
    1874:	3e1030ef          	jal	5454 <printf>
      exit(1);
    1878:	4505                	li	a0,1
    187a:	78c030ef          	jal	5006 <exit>

000000000000187e <reparent2>:
{
    187e:	1101                	addi	sp,sp,-32
    1880:	ec06                	sd	ra,24(sp)
    1882:	e822                	sd	s0,16(sp)
    1884:	e426                	sd	s1,8(sp)
    1886:	1000                	addi	s0,sp,32
    1888:	32000493          	li	s1,800
    int pid1 = fork();
    188c:	772030ef          	jal	4ffe <fork>
    if(pid1 < 0){
    1890:	00054b63          	bltz	a0,18a6 <reparent2+0x28>
    if(pid1 == 0){
    1894:	c115                	beqz	a0,18b8 <reparent2+0x3a>
    wait(0);
    1896:	4501                	li	a0,0
    1898:	776030ef          	jal	500e <wait>
  for(int i = 0; i < 800; i++){
    189c:	34fd                	addiw	s1,s1,-1
    189e:	f4fd                	bnez	s1,188c <reparent2+0xe>
  exit(0);
    18a0:	4501                	li	a0,0
    18a2:	764030ef          	jal	5006 <exit>
      printf("fork failed\n");
    18a6:	00006517          	auipc	a0,0x6
    18aa:	bca50513          	addi	a0,a0,-1078 # 7470 <malloc+0x1f64>
    18ae:	3a7030ef          	jal	5454 <printf>
      exit(1);
    18b2:	4505                	li	a0,1
    18b4:	752030ef          	jal	5006 <exit>
      fork();
    18b8:	746030ef          	jal	4ffe <fork>
      fork();
    18bc:	742030ef          	jal	4ffe <fork>
      exit(0);
    18c0:	4501                	li	a0,0
    18c2:	744030ef          	jal	5006 <exit>

00000000000018c6 <createdelete>:
{
    18c6:	7135                	addi	sp,sp,-160
    18c8:	ed06                	sd	ra,152(sp)
    18ca:	e922                	sd	s0,144(sp)
    18cc:	e526                	sd	s1,136(sp)
    18ce:	e14a                	sd	s2,128(sp)
    18d0:	fcce                	sd	s3,120(sp)
    18d2:	f8d2                	sd	s4,112(sp)
    18d4:	f4d6                	sd	s5,104(sp)
    18d6:	f0da                	sd	s6,96(sp)
    18d8:	ecde                	sd	s7,88(sp)
    18da:	e8e2                	sd	s8,80(sp)
    18dc:	e4e6                	sd	s9,72(sp)
    18de:	e0ea                	sd	s10,64(sp)
    18e0:	fc6e                	sd	s11,56(sp)
    18e2:	1100                	addi	s0,sp,160
    18e4:	8daa                	mv	s11,a0
  for(pi = 0; pi < NCHILD; pi++){
    18e6:	4901                	li	s2,0
    18e8:	4991                	li	s3,4
    pid = fork();
    18ea:	714030ef          	jal	4ffe <fork>
    18ee:	84aa                	mv	s1,a0
    if(pid < 0){
    18f0:	04054063          	bltz	a0,1930 <createdelete+0x6a>
    if(pid == 0){
    18f4:	c921                	beqz	a0,1944 <createdelete+0x7e>
  for(pi = 0; pi < NCHILD; pi++){
    18f6:	2905                	addiw	s2,s2,1
    18f8:	ff3919e3          	bne	s2,s3,18ea <createdelete+0x24>
    18fc:	4491                	li	s1,4
    wait(&xstatus);
    18fe:	f6c40913          	addi	s2,s0,-148
    1902:	854a                	mv	a0,s2
    1904:	70a030ef          	jal	500e <wait>
    if(xstatus != 0)
    1908:	f6c42a83          	lw	s5,-148(s0)
    190c:	0c0a9263          	bnez	s5,19d0 <createdelete+0x10a>
  for(pi = 0; pi < NCHILD; pi++){
    1910:	34fd                	addiw	s1,s1,-1
    1912:	f8e5                	bnez	s1,1902 <createdelete+0x3c>
  name[0] = name[1] = name[2] = 0;
    1914:	f6040923          	sb	zero,-142(s0)
    1918:	03000913          	li	s2,48
    191c:	5a7d                	li	s4,-1
      if((i == 0 || i >= N/2) && fd < 0){
    191e:	4d25                	li	s10,9
    1920:	07000c93          	li	s9,112
      fd = open(name, 0);
    1924:	f7040c13          	addi	s8,s0,-144
      } else if((i >= 1 && i < N/2) && fd >= 0){
    1928:	4ba1                	li	s7,8
    for(pi = 0; pi < NCHILD; pi++){
    192a:	07400b13          	li	s6,116
    192e:	aa39                	j	1a4c <createdelete+0x186>
      printf("%s: fork failed\n", s);
    1930:	85ee                	mv	a1,s11
    1932:	00004517          	auipc	a0,0x4
    1936:	59650513          	addi	a0,a0,1430 # 5ec8 <malloc+0x9bc>
    193a:	31b030ef          	jal	5454 <printf>
      exit(1);
    193e:	4505                	li	a0,1
    1940:	6c6030ef          	jal	5006 <exit>
      name[0] = 'p' + pi;
    1944:	0709091b          	addiw	s2,s2,112
    1948:	f7240823          	sb	s2,-144(s0)
      name[2] = '\0';
    194c:	f6040923          	sb	zero,-142(s0)
        fd = open(name, O_CREATE | O_RDWR);
    1950:	f7040913          	addi	s2,s0,-144
    1954:	20200993          	li	s3,514
      for(i = 0; i < N; i++){
    1958:	4a51                	li	s4,20
    195a:	a815                	j	198e <createdelete+0xc8>
          printf("%s: create failed\n", s);
    195c:	85ee                	mv	a1,s11
    195e:	00004517          	auipc	a0,0x4
    1962:	60250513          	addi	a0,a0,1538 # 5f60 <malloc+0xa54>
    1966:	2ef030ef          	jal	5454 <printf>
          exit(1);
    196a:	4505                	li	a0,1
    196c:	69a030ef          	jal	5006 <exit>
          name[1] = '0' + (i / 2);
    1970:	01f4d79b          	srliw	a5,s1,0x1f
    1974:	9fa5                	addw	a5,a5,s1
    1976:	4017d79b          	sraiw	a5,a5,0x1
    197a:	0307879b          	addiw	a5,a5,48
    197e:	f6f408a3          	sb	a5,-143(s0)
          if(unlink(name) < 0){
    1982:	854a                	mv	a0,s2
    1984:	6d2030ef          	jal	5056 <unlink>
    1988:	02054a63          	bltz	a0,19bc <createdelete+0xf6>
      for(i = 0; i < N; i++){
    198c:	2485                	addiw	s1,s1,1
        name[1] = '0' + i;
    198e:	0304879b          	addiw	a5,s1,48
    1992:	f6f408a3          	sb	a5,-143(s0)
        fd = open(name, O_CREATE | O_RDWR);
    1996:	85ce                	mv	a1,s3
    1998:	854a                	mv	a0,s2
    199a:	6ac030ef          	jal	5046 <open>
        if(fd < 0){
    199e:	fa054fe3          	bltz	a0,195c <createdelete+0x96>
        close(fd);
    19a2:	68c030ef          	jal	502e <close>
        if(i > 0 && (i % 2 ) == 0){
    19a6:	fe9053e3          	blez	s1,198c <createdelete+0xc6>
    19aa:	0014f793          	andi	a5,s1,1
    19ae:	d3e9                	beqz	a5,1970 <createdelete+0xaa>
      for(i = 0; i < N; i++){
    19b0:	2485                	addiw	s1,s1,1
    19b2:	fd449ee3          	bne	s1,s4,198e <createdelete+0xc8>
      exit(0);
    19b6:	4501                	li	a0,0
    19b8:	64e030ef          	jal	5006 <exit>
            printf("%s: unlink failed\n", s);
    19bc:	85ee                	mv	a1,s11
    19be:	00004517          	auipc	a0,0x4
    19c2:	6fa50513          	addi	a0,a0,1786 # 60b8 <malloc+0xbac>
    19c6:	28f030ef          	jal	5454 <printf>
            exit(1);
    19ca:	4505                	li	a0,1
    19cc:	63a030ef          	jal	5006 <exit>
      exit(1);
    19d0:	4505                	li	a0,1
    19d2:	634030ef          	jal	5006 <exit>
      } else if((i >= 1 && i < N/2) && fd >= 0){
    19d6:	054bf263          	bgeu	s7,s4,1a1a <createdelete+0x154>
      if(fd >= 0)
    19da:	04055e63          	bgez	a0,1a36 <createdelete+0x170>
    for(pi = 0; pi < NCHILD; pi++){
    19de:	2485                	addiw	s1,s1,1
    19e0:	0ff4f493          	zext.b	s1,s1
    19e4:	05648c63          	beq	s1,s6,1a3c <createdelete+0x176>
      name[0] = 'p' + pi;
    19e8:	f6940823          	sb	s1,-144(s0)
      name[1] = '0' + i;
    19ec:	f72408a3          	sb	s2,-143(s0)
      fd = open(name, 0);
    19f0:	4581                	li	a1,0
    19f2:	8562                	mv	a0,s8
    19f4:	652030ef          	jal	5046 <open>
      if((i == 0 || i >= N/2) && fd < 0){
    19f8:	01f5579b          	srliw	a5,a0,0x1f
    19fc:	dfe9                	beqz	a5,19d6 <createdelete+0x110>
    19fe:	fc098ce3          	beqz	s3,19d6 <createdelete+0x110>
        printf("%s: oops createdelete %s didn't exist\n", s, name);
    1a02:	f7040613          	addi	a2,s0,-144
    1a06:	85ee                	mv	a1,s11
    1a08:	00004517          	auipc	a0,0x4
    1a0c:	6c850513          	addi	a0,a0,1736 # 60d0 <malloc+0xbc4>
    1a10:	245030ef          	jal	5454 <printf>
        exit(1);
    1a14:	4505                	li	a0,1
    1a16:	5f0030ef          	jal	5006 <exit>
      } else if((i >= 1 && i < N/2) && fd >= 0){
    1a1a:	fc0542e3          	bltz	a0,19de <createdelete+0x118>
        printf("%s: oops createdelete %s did exist\n", s, name);
    1a1e:	f7040613          	addi	a2,s0,-144
    1a22:	85ee                	mv	a1,s11
    1a24:	00004517          	auipc	a0,0x4
    1a28:	6d450513          	addi	a0,a0,1748 # 60f8 <malloc+0xbec>
    1a2c:	229030ef          	jal	5454 <printf>
        exit(1);
    1a30:	4505                	li	a0,1
    1a32:	5d4030ef          	jal	5006 <exit>
        close(fd);
    1a36:	5f8030ef          	jal	502e <close>
    1a3a:	b755                	j	19de <createdelete+0x118>
  for(i = 0; i < N; i++){
    1a3c:	2a85                	addiw	s5,s5,1
    1a3e:	2a05                	addiw	s4,s4,1
    1a40:	2905                	addiw	s2,s2,1
    1a42:	0ff97913          	zext.b	s2,s2
    1a46:	47d1                	li	a5,20
    1a48:	00fa8a63          	beq	s5,a5,1a5c <createdelete+0x196>
      if((i == 0 || i >= N/2) && fd < 0){
    1a4c:	001ab993          	seqz	s3,s5
    1a50:	015d27b3          	slt	a5,s10,s5
    1a54:	00f9e9b3          	or	s3,s3,a5
    1a58:	84e6                	mv	s1,s9
    1a5a:	b779                	j	19e8 <createdelete+0x122>
    1a5c:	03000913          	li	s2,48
  name[0] = name[1] = name[2] = 0;
    1a60:	07000b13          	li	s6,112
      unlink(name);
    1a64:	f7040a13          	addi	s4,s0,-144
    for(pi = 0; pi < NCHILD; pi++){
    1a68:	07400993          	li	s3,116
  for(i = 0; i < N; i++){
    1a6c:	04400a93          	li	s5,68
  name[0] = name[1] = name[2] = 0;
    1a70:	84da                	mv	s1,s6
      name[0] = 'p' + pi;
    1a72:	f6940823          	sb	s1,-144(s0)
      name[1] = '0' + i;
    1a76:	f72408a3          	sb	s2,-143(s0)
      unlink(name);
    1a7a:	8552                	mv	a0,s4
    1a7c:	5da030ef          	jal	5056 <unlink>
    for(pi = 0; pi < NCHILD; pi++){
    1a80:	2485                	addiw	s1,s1,1
    1a82:	0ff4f493          	zext.b	s1,s1
    1a86:	ff3496e3          	bne	s1,s3,1a72 <createdelete+0x1ac>
  for(i = 0; i < N; i++){
    1a8a:	2905                	addiw	s2,s2,1
    1a8c:	0ff97913          	zext.b	s2,s2
    1a90:	ff5910e3          	bne	s2,s5,1a70 <createdelete+0x1aa>
}
    1a94:	60ea                	ld	ra,152(sp)
    1a96:	644a                	ld	s0,144(sp)
    1a98:	64aa                	ld	s1,136(sp)
    1a9a:	690a                	ld	s2,128(sp)
    1a9c:	79e6                	ld	s3,120(sp)
    1a9e:	7a46                	ld	s4,112(sp)
    1aa0:	7aa6                	ld	s5,104(sp)
    1aa2:	7b06                	ld	s6,96(sp)
    1aa4:	6be6                	ld	s7,88(sp)
    1aa6:	6c46                	ld	s8,80(sp)
    1aa8:	6ca6                	ld	s9,72(sp)
    1aaa:	6d06                	ld	s10,64(sp)
    1aac:	7de2                	ld	s11,56(sp)
    1aae:	610d                	addi	sp,sp,160
    1ab0:	8082                	ret

0000000000001ab2 <linkunlink>:
{
    1ab2:	711d                	addi	sp,sp,-96
    1ab4:	ec86                	sd	ra,88(sp)
    1ab6:	e8a2                	sd	s0,80(sp)
    1ab8:	e4a6                	sd	s1,72(sp)
    1aba:	e0ca                	sd	s2,64(sp)
    1abc:	fc4e                	sd	s3,56(sp)
    1abe:	f852                	sd	s4,48(sp)
    1ac0:	f456                	sd	s5,40(sp)
    1ac2:	f05a                	sd	s6,32(sp)
    1ac4:	ec5e                	sd	s7,24(sp)
    1ac6:	e862                	sd	s8,16(sp)
    1ac8:	e466                	sd	s9,8(sp)
    1aca:	e06a                	sd	s10,0(sp)
    1acc:	1080                	addi	s0,sp,96
    1ace:	84aa                	mv	s1,a0
  unlink("x");
    1ad0:	00004517          	auipc	a0,0x4
    1ad4:	bd850513          	addi	a0,a0,-1064 # 56a8 <malloc+0x19c>
    1ad8:	57e030ef          	jal	5056 <unlink>
  pid = fork();
    1adc:	522030ef          	jal	4ffe <fork>
  if(pid < 0){
    1ae0:	04054363          	bltz	a0,1b26 <linkunlink+0x74>
    1ae4:	8d2a                	mv	s10,a0
  unsigned int x = (pid ? 1 : 97);
    1ae6:	06100913          	li	s2,97
    1aea:	c111                	beqz	a0,1aee <linkunlink+0x3c>
    1aec:	4905                	li	s2,1
    1aee:	06400493          	li	s1,100
    x = x * 1103515245 + 12345;
    1af2:	41c65ab7          	lui	s5,0x41c65
    1af6:	e6da8a9b          	addiw	s5,s5,-403 # 41c64e6d <base+0x41c541b5>
    1afa:	6a0d                	lui	s4,0x3
    1afc:	039a0a1b          	addiw	s4,s4,57 # 3039 <subdir+0x329>
    if((x % 3) == 0){
    1b00:	000ab9b7          	lui	s3,0xab
    1b04:	aab98993          	addi	s3,s3,-1365 # aaaab <base+0x99df3>
    1b08:	09b2                	slli	s3,s3,0xc
    1b0a:	aab98993          	addi	s3,s3,-1365
    } else if((x % 3) == 1){
    1b0e:	4b85                	li	s7,1
      unlink("x");
    1b10:	00004b17          	auipc	s6,0x4
    1b14:	b98b0b13          	addi	s6,s6,-1128 # 56a8 <malloc+0x19c>
      link("cat", "x");
    1b18:	00004c97          	auipc	s9,0x4
    1b1c:	608c8c93          	addi	s9,s9,1544 # 6120 <malloc+0xc14>
      close(open("x", O_RDWR | O_CREATE));
    1b20:	20200c13          	li	s8,514
    1b24:	a03d                	j	1b52 <linkunlink+0xa0>
    printf("%s: fork failed\n", s);
    1b26:	85a6                	mv	a1,s1
    1b28:	00004517          	auipc	a0,0x4
    1b2c:	3a050513          	addi	a0,a0,928 # 5ec8 <malloc+0x9bc>
    1b30:	125030ef          	jal	5454 <printf>
    exit(1);
    1b34:	4505                	li	a0,1
    1b36:	4d0030ef          	jal	5006 <exit>
      close(open("x", O_RDWR | O_CREATE));
    1b3a:	85e2                	mv	a1,s8
    1b3c:	855a                	mv	a0,s6
    1b3e:	508030ef          	jal	5046 <open>
    1b42:	4ec030ef          	jal	502e <close>
    1b46:	a021                	j	1b4e <linkunlink+0x9c>
      unlink("x");
    1b48:	855a                	mv	a0,s6
    1b4a:	50c030ef          	jal	5056 <unlink>
  for(i = 0; i < 100; i++){
    1b4e:	34fd                	addiw	s1,s1,-1
    1b50:	c885                	beqz	s1,1b80 <linkunlink+0xce>
    x = x * 1103515245 + 12345;
    1b52:	035907bb          	mulw	a5,s2,s5
    1b56:	00fa07bb          	addw	a5,s4,a5
    1b5a:	893e                	mv	s2,a5
    if((x % 3) == 0){
    1b5c:	02079713          	slli	a4,a5,0x20
    1b60:	9301                	srli	a4,a4,0x20
    1b62:	03370733          	mul	a4,a4,s3
    1b66:	9305                	srli	a4,a4,0x21
    1b68:	0017169b          	slliw	a3,a4,0x1
    1b6c:	9f35                	addw	a4,a4,a3
    1b6e:	9f99                	subw	a5,a5,a4
    1b70:	d7e9                	beqz	a5,1b3a <linkunlink+0x88>
    } else if((x % 3) == 1){
    1b72:	fd779be3          	bne	a5,s7,1b48 <linkunlink+0x96>
      link("cat", "x");
    1b76:	85da                	mv	a1,s6
    1b78:	8566                	mv	a0,s9
    1b7a:	4ec030ef          	jal	5066 <link>
    1b7e:	bfc1                	j	1b4e <linkunlink+0x9c>
  if(pid)
    1b80:	020d0363          	beqz	s10,1ba6 <linkunlink+0xf4>
    wait(0);
    1b84:	4501                	li	a0,0
    1b86:	488030ef          	jal	500e <wait>
}
    1b8a:	60e6                	ld	ra,88(sp)
    1b8c:	6446                	ld	s0,80(sp)
    1b8e:	64a6                	ld	s1,72(sp)
    1b90:	6906                	ld	s2,64(sp)
    1b92:	79e2                	ld	s3,56(sp)
    1b94:	7a42                	ld	s4,48(sp)
    1b96:	7aa2                	ld	s5,40(sp)
    1b98:	7b02                	ld	s6,32(sp)
    1b9a:	6be2                	ld	s7,24(sp)
    1b9c:	6c42                	ld	s8,16(sp)
    1b9e:	6ca2                	ld	s9,8(sp)
    1ba0:	6d02                	ld	s10,0(sp)
    1ba2:	6125                	addi	sp,sp,96
    1ba4:	8082                	ret
    exit(0);
    1ba6:	4501                	li	a0,0
    1ba8:	45e030ef          	jal	5006 <exit>

0000000000001bac <forktest>:
{
    1bac:	7179                	addi	sp,sp,-48
    1bae:	f406                	sd	ra,40(sp)
    1bb0:	f022                	sd	s0,32(sp)
    1bb2:	ec26                	sd	s1,24(sp)
    1bb4:	e84a                	sd	s2,16(sp)
    1bb6:	e44e                	sd	s3,8(sp)
    1bb8:	1800                	addi	s0,sp,48
    1bba:	89aa                	mv	s3,a0
  for(n=0; n<N; n++){
    1bbc:	4481                	li	s1,0
    1bbe:	3e800913          	li	s2,1000
    pid = fork();
    1bc2:	43c030ef          	jal	4ffe <fork>
    if(pid < 0)
    1bc6:	06054063          	bltz	a0,1c26 <forktest+0x7a>
    if(pid == 0)
    1bca:	cd11                	beqz	a0,1be6 <forktest+0x3a>
  for(n=0; n<N; n++){
    1bcc:	2485                	addiw	s1,s1,1
    1bce:	ff249ae3          	bne	s1,s2,1bc2 <forktest+0x16>
    printf("%s: fork claimed to work 1000 times!\n", s);
    1bd2:	85ce                	mv	a1,s3
    1bd4:	00004517          	auipc	a0,0x4
    1bd8:	59c50513          	addi	a0,a0,1436 # 6170 <malloc+0xc64>
    1bdc:	079030ef          	jal	5454 <printf>
    exit(1);
    1be0:	4505                	li	a0,1
    1be2:	424030ef          	jal	5006 <exit>
      exit(0);
    1be6:	420030ef          	jal	5006 <exit>
    printf("%s: no fork at all!\n", s);
    1bea:	85ce                	mv	a1,s3
    1bec:	00004517          	auipc	a0,0x4
    1bf0:	53c50513          	addi	a0,a0,1340 # 6128 <malloc+0xc1c>
    1bf4:	061030ef          	jal	5454 <printf>
    exit(1);
    1bf8:	4505                	li	a0,1
    1bfa:	40c030ef          	jal	5006 <exit>
      printf("%s: wait stopped early\n", s);
    1bfe:	85ce                	mv	a1,s3
    1c00:	00004517          	auipc	a0,0x4
    1c04:	54050513          	addi	a0,a0,1344 # 6140 <malloc+0xc34>
    1c08:	04d030ef          	jal	5454 <printf>
      exit(1);
    1c0c:	4505                	li	a0,1
    1c0e:	3f8030ef          	jal	5006 <exit>
    printf("%s: wait got too many\n", s);
    1c12:	85ce                	mv	a1,s3
    1c14:	00004517          	auipc	a0,0x4
    1c18:	54450513          	addi	a0,a0,1348 # 6158 <malloc+0xc4c>
    1c1c:	039030ef          	jal	5454 <printf>
    exit(1);
    1c20:	4505                	li	a0,1
    1c22:	3e4030ef          	jal	5006 <exit>
  if (n == 0) {
    1c26:	d0f1                	beqz	s1,1bea <forktest+0x3e>
  for(; n > 0; n--){
    1c28:	00905963          	blez	s1,1c3a <forktest+0x8e>
    if(wait(0) < 0){
    1c2c:	4501                	li	a0,0
    1c2e:	3e0030ef          	jal	500e <wait>
    1c32:	fc0546e3          	bltz	a0,1bfe <forktest+0x52>
  for(; n > 0; n--){
    1c36:	34fd                	addiw	s1,s1,-1
    1c38:	f8f5                	bnez	s1,1c2c <forktest+0x80>
  if(wait(0) != -1){
    1c3a:	4501                	li	a0,0
    1c3c:	3d2030ef          	jal	500e <wait>
    1c40:	57fd                	li	a5,-1
    1c42:	fcf518e3          	bne	a0,a5,1c12 <forktest+0x66>
}
    1c46:	70a2                	ld	ra,40(sp)
    1c48:	7402                	ld	s0,32(sp)
    1c4a:	64e2                	ld	s1,24(sp)
    1c4c:	6942                	ld	s2,16(sp)
    1c4e:	69a2                	ld	s3,8(sp)
    1c50:	6145                	addi	sp,sp,48
    1c52:	8082                	ret

0000000000001c54 <kernmem>:
{
    1c54:	715d                	addi	sp,sp,-80
    1c56:	e486                	sd	ra,72(sp)
    1c58:	e0a2                	sd	s0,64(sp)
    1c5a:	fc26                	sd	s1,56(sp)
    1c5c:	f84a                	sd	s2,48(sp)
    1c5e:	f44e                	sd	s3,40(sp)
    1c60:	f052                	sd	s4,32(sp)
    1c62:	ec56                	sd	s5,24(sp)
    1c64:	e85a                	sd	s6,16(sp)
    1c66:	0880                	addi	s0,sp,80
    1c68:	8b2a                	mv	s6,a0
  for(a = (char*)(KERNBASE); a < (char*) (KERNBASE+2000000); a += 50000){
    1c6a:	4485                	li	s1,1
    1c6c:	04fe                	slli	s1,s1,0x1f
    wait(&xstatus);
    1c6e:	fbc40a93          	addi	s5,s0,-68
    if(xstatus != -1)  // did kernel kill child?
    1c72:	5a7d                	li	s4,-1
  for(a = (char*)(KERNBASE); a < (char*) (KERNBASE+2000000); a += 50000){
    1c74:	69b1                	lui	s3,0xc
    1c76:	35098993          	addi	s3,s3,848 # c350 <uninit+0xda8>
    1c7a:	1003d937          	lui	s2,0x1003d
    1c7e:	090e                	slli	s2,s2,0x3
    1c80:	48090913          	addi	s2,s2,1152 # 1003d480 <base+0x1002c7c8>
    pid = fork();
    1c84:	37a030ef          	jal	4ffe <fork>
    if(pid < 0){
    1c88:	02054763          	bltz	a0,1cb6 <kernmem+0x62>
    if(pid == 0){
    1c8c:	cd1d                	beqz	a0,1cca <kernmem+0x76>
    wait(&xstatus);
    1c8e:	8556                	mv	a0,s5
    1c90:	37e030ef          	jal	500e <wait>
    if(xstatus != -1)  // did kernel kill child?
    1c94:	fbc42783          	lw	a5,-68(s0)
    1c98:	05479663          	bne	a5,s4,1ce4 <kernmem+0x90>
  for(a = (char*)(KERNBASE); a < (char*) (KERNBASE+2000000); a += 50000){
    1c9c:	94ce                	add	s1,s1,s3
    1c9e:	ff2493e3          	bne	s1,s2,1c84 <kernmem+0x30>
}
    1ca2:	60a6                	ld	ra,72(sp)
    1ca4:	6406                	ld	s0,64(sp)
    1ca6:	74e2                	ld	s1,56(sp)
    1ca8:	7942                	ld	s2,48(sp)
    1caa:	79a2                	ld	s3,40(sp)
    1cac:	7a02                	ld	s4,32(sp)
    1cae:	6ae2                	ld	s5,24(sp)
    1cb0:	6b42                	ld	s6,16(sp)
    1cb2:	6161                	addi	sp,sp,80
    1cb4:	8082                	ret
      printf("%s: fork failed\n", s);
    1cb6:	85da                	mv	a1,s6
    1cb8:	00004517          	auipc	a0,0x4
    1cbc:	21050513          	addi	a0,a0,528 # 5ec8 <malloc+0x9bc>
    1cc0:	794030ef          	jal	5454 <printf>
      exit(1);
    1cc4:	4505                	li	a0,1
    1cc6:	340030ef          	jal	5006 <exit>
      printf("%s: oops could read %p = %x\n", s, a, *a);
    1cca:	0004c683          	lbu	a3,0(s1)
    1cce:	8626                	mv	a2,s1
    1cd0:	85da                	mv	a1,s6
    1cd2:	00004517          	auipc	a0,0x4
    1cd6:	4c650513          	addi	a0,a0,1222 # 6198 <malloc+0xc8c>
    1cda:	77a030ef          	jal	5454 <printf>
      exit(1);
    1cde:	4505                	li	a0,1
    1ce0:	326030ef          	jal	5006 <exit>
      exit(1);
    1ce4:	4505                	li	a0,1
    1ce6:	320030ef          	jal	5006 <exit>

0000000000001cea <MAXVAplus>:
{
    1cea:	7139                	addi	sp,sp,-64
    1cec:	fc06                	sd	ra,56(sp)
    1cee:	f822                	sd	s0,48(sp)
    1cf0:	0080                	addi	s0,sp,64
  volatile uint64 a = MAXVA;
    1cf2:	4785                	li	a5,1
    1cf4:	179a                	slli	a5,a5,0x26
    1cf6:	fcf43423          	sd	a5,-56(s0)
  for( ; a != 0; a <<= 1){
    1cfa:	fc843783          	ld	a5,-56(s0)
    1cfe:	cf9d                	beqz	a5,1d3c <MAXVAplus+0x52>
    1d00:	f426                	sd	s1,40(sp)
    1d02:	f04a                	sd	s2,32(sp)
    1d04:	ec4e                	sd	s3,24(sp)
    1d06:	89aa                	mv	s3,a0
    wait(&xstatus);
    1d08:	fc440913          	addi	s2,s0,-60
    if(xstatus != -1)  // did kernel kill child?
    1d0c:	54fd                	li	s1,-1
    pid = fork();
    1d0e:	2f0030ef          	jal	4ffe <fork>
    if(pid < 0){
    1d12:	02054963          	bltz	a0,1d44 <MAXVAplus+0x5a>
    if(pid == 0){
    1d16:	c129                	beqz	a0,1d58 <MAXVAplus+0x6e>
    wait(&xstatus);
    1d18:	854a                	mv	a0,s2
    1d1a:	2f4030ef          	jal	500e <wait>
    if(xstatus != -1)  // did kernel kill child?
    1d1e:	fc442783          	lw	a5,-60(s0)
    1d22:	04979d63          	bne	a5,s1,1d7c <MAXVAplus+0x92>
  for( ; a != 0; a <<= 1){
    1d26:	fc843783          	ld	a5,-56(s0)
    1d2a:	0786                	slli	a5,a5,0x1
    1d2c:	fcf43423          	sd	a5,-56(s0)
    1d30:	fc843783          	ld	a5,-56(s0)
    1d34:	ffe9                	bnez	a5,1d0e <MAXVAplus+0x24>
    1d36:	74a2                	ld	s1,40(sp)
    1d38:	7902                	ld	s2,32(sp)
    1d3a:	69e2                	ld	s3,24(sp)
}
    1d3c:	70e2                	ld	ra,56(sp)
    1d3e:	7442                	ld	s0,48(sp)
    1d40:	6121                	addi	sp,sp,64
    1d42:	8082                	ret
      printf("%s: fork failed\n", s);
    1d44:	85ce                	mv	a1,s3
    1d46:	00004517          	auipc	a0,0x4
    1d4a:	18250513          	addi	a0,a0,386 # 5ec8 <malloc+0x9bc>
    1d4e:	706030ef          	jal	5454 <printf>
      exit(1);
    1d52:	4505                	li	a0,1
    1d54:	2b2030ef          	jal	5006 <exit>
      *(char*)a = 99;
    1d58:	fc843783          	ld	a5,-56(s0)
    1d5c:	06300713          	li	a4,99
    1d60:	00e78023          	sb	a4,0(a5)
      printf("%s: oops wrote %p\n", s, (void*)a);
    1d64:	fc843603          	ld	a2,-56(s0)
    1d68:	85ce                	mv	a1,s3
    1d6a:	00004517          	auipc	a0,0x4
    1d6e:	44e50513          	addi	a0,a0,1102 # 61b8 <malloc+0xcac>
    1d72:	6e2030ef          	jal	5454 <printf>
      exit(1);
    1d76:	4505                	li	a0,1
    1d78:	28e030ef          	jal	5006 <exit>
      exit(1);
    1d7c:	4505                	li	a0,1
    1d7e:	288030ef          	jal	5006 <exit>

0000000000001d82 <stacktest>:
{
    1d82:	7179                	addi	sp,sp,-48
    1d84:	f406                	sd	ra,40(sp)
    1d86:	f022                	sd	s0,32(sp)
    1d88:	ec26                	sd	s1,24(sp)
    1d8a:	1800                	addi	s0,sp,48
    1d8c:	84aa                	mv	s1,a0
  pid = fork();
    1d8e:	270030ef          	jal	4ffe <fork>
  if(pid == 0) {
    1d92:	cd11                	beqz	a0,1dae <stacktest+0x2c>
  } else if(pid < 0){
    1d94:	02054c63          	bltz	a0,1dcc <stacktest+0x4a>
  wait(&xstatus);
    1d98:	fdc40513          	addi	a0,s0,-36
    1d9c:	272030ef          	jal	500e <wait>
  if(xstatus == -1)  // kernel killed child?
    1da0:	fdc42503          	lw	a0,-36(s0)
    1da4:	57fd                	li	a5,-1
    1da6:	02f50d63          	beq	a0,a5,1de0 <stacktest+0x5e>
    exit(xstatus);
    1daa:	25c030ef          	jal	5006 <exit>

static inline uint64
r_sp()
{
  uint64 x;
  asm volatile("mv %0, sp" : "=r" (x) );
    1dae:	878a                	mv	a5,sp
    printf("%s: stacktest: read below stack %d\n", s, *sp);
    1db0:	80078793          	addi	a5,a5,-2048
    1db4:	8007c603          	lbu	a2,-2048(a5)
    1db8:	85a6                	mv	a1,s1
    1dba:	00004517          	auipc	a0,0x4
    1dbe:	41650513          	addi	a0,a0,1046 # 61d0 <malloc+0xcc4>
    1dc2:	692030ef          	jal	5454 <printf>
    exit(1);
    1dc6:	4505                	li	a0,1
    1dc8:	23e030ef          	jal	5006 <exit>
    printf("%s: fork failed\n", s);
    1dcc:	85a6                	mv	a1,s1
    1dce:	00004517          	auipc	a0,0x4
    1dd2:	0fa50513          	addi	a0,a0,250 # 5ec8 <malloc+0x9bc>
    1dd6:	67e030ef          	jal	5454 <printf>
    exit(1);
    1dda:	4505                	li	a0,1
    1ddc:	22a030ef          	jal	5006 <exit>
    exit(0);
    1de0:	4501                	li	a0,0
    1de2:	224030ef          	jal	5006 <exit>

0000000000001de6 <nowrite>:
{
    1de6:	7159                	addi	sp,sp,-112
    1de8:	f486                	sd	ra,104(sp)
    1dea:	f0a2                	sd	s0,96(sp)
    1dec:	eca6                	sd	s1,88(sp)
    1dee:	e8ca                	sd	s2,80(sp)
    1df0:	e4ce                	sd	s3,72(sp)
    1df2:	e0d2                	sd	s4,64(sp)
    1df4:	1880                	addi	s0,sp,112
    1df6:	8a2a                	mv	s4,a0
  uint64 addrs[] = { 0, 0x80000000LL, 0x3fffffe000, 0x3ffffff000, 0x4000000000,
    1df8:	00006797          	auipc	a5,0x6
    1dfc:	d8878793          	addi	a5,a5,-632 # 7b80 <malloc+0x2674>
    1e00:	7788                	ld	a0,40(a5)
    1e02:	7b8c                	ld	a1,48(a5)
    1e04:	7f90                	ld	a2,56(a5)
    1e06:	63b4                	ld	a3,64(a5)
    1e08:	67b8                	ld	a4,72(a5)
    1e0a:	f8a43c23          	sd	a0,-104(s0)
    1e0e:	fab43023          	sd	a1,-96(s0)
    1e12:	fac43423          	sd	a2,-88(s0)
    1e16:	fad43823          	sd	a3,-80(s0)
    1e1a:	fae43c23          	sd	a4,-72(s0)
    1e1e:	6bbc                	ld	a5,80(a5)
    1e20:	fcf43023          	sd	a5,-64(s0)
  for(int ai = 0; ai < sizeof(addrs)/sizeof(addrs[0]); ai++){
    1e24:	4481                	li	s1,0
    wait(&xstatus);
    1e26:	fcc40913          	addi	s2,s0,-52
  for(int ai = 0; ai < sizeof(addrs)/sizeof(addrs[0]); ai++){
    1e2a:	4999                	li	s3,6
    pid = fork();
    1e2c:	1d2030ef          	jal	4ffe <fork>
    if(pid == 0) {
    1e30:	cd19                	beqz	a0,1e4e <nowrite+0x68>
    } else if(pid < 0){
    1e32:	04054163          	bltz	a0,1e74 <nowrite+0x8e>
    wait(&xstatus);
    1e36:	854a                	mv	a0,s2
    1e38:	1d6030ef          	jal	500e <wait>
    if(xstatus == 0){
    1e3c:	fcc42783          	lw	a5,-52(s0)
    1e40:	c7a1                	beqz	a5,1e88 <nowrite+0xa2>
  for(int ai = 0; ai < sizeof(addrs)/sizeof(addrs[0]); ai++){
    1e42:	2485                	addiw	s1,s1,1
    1e44:	ff3494e3          	bne	s1,s3,1e2c <nowrite+0x46>
  exit(0);
    1e48:	4501                	li	a0,0
    1e4a:	1bc030ef          	jal	5006 <exit>
      volatile int *addr = (int *) addrs[ai];
    1e4e:	048e                	slli	s1,s1,0x3
    1e50:	fd048793          	addi	a5,s1,-48
    1e54:	008784b3          	add	s1,a5,s0
    1e58:	fc84b603          	ld	a2,-56(s1)
      *addr = 10;
    1e5c:	47a9                	li	a5,10
    1e5e:	c21c                	sw	a5,0(a2)
      printf("%s: write to %p did not fail!\n", s, addr);
    1e60:	85d2                	mv	a1,s4
    1e62:	00004517          	auipc	a0,0x4
    1e66:	39650513          	addi	a0,a0,918 # 61f8 <malloc+0xcec>
    1e6a:	5ea030ef          	jal	5454 <printf>
      exit(0);
    1e6e:	4501                	li	a0,0
    1e70:	196030ef          	jal	5006 <exit>
      printf("%s: fork failed\n", s);
    1e74:	85d2                	mv	a1,s4
    1e76:	00004517          	auipc	a0,0x4
    1e7a:	05250513          	addi	a0,a0,82 # 5ec8 <malloc+0x9bc>
    1e7e:	5d6030ef          	jal	5454 <printf>
      exit(1);
    1e82:	4505                	li	a0,1
    1e84:	182030ef          	jal	5006 <exit>
      exit(1);
    1e88:	4505                	li	a0,1
    1e8a:	17c030ef          	jal	5006 <exit>

0000000000001e8e <manywrites>:
{
    1e8e:	7159                	addi	sp,sp,-112
    1e90:	f486                	sd	ra,104(sp)
    1e92:	f0a2                	sd	s0,96(sp)
    1e94:	eca6                	sd	s1,88(sp)
    1e96:	e8ca                	sd	s2,80(sp)
    1e98:	e4ce                	sd	s3,72(sp)
    1e9a:	ec66                	sd	s9,24(sp)
    1e9c:	1880                	addi	s0,sp,112
    1e9e:	8caa                	mv	s9,a0
  for(int ci = 0; ci < nchildren; ci++){
    1ea0:	4901                	li	s2,0
    1ea2:	4991                	li	s3,4
    int pid = fork();
    1ea4:	15a030ef          	jal	4ffe <fork>
    1ea8:	84aa                	mv	s1,a0
    if(pid < 0){
    1eaa:	02054c63          	bltz	a0,1ee2 <manywrites+0x54>
    if(pid == 0){
    1eae:	c929                	beqz	a0,1f00 <manywrites+0x72>
  for(int ci = 0; ci < nchildren; ci++){
    1eb0:	2905                	addiw	s2,s2,1
    1eb2:	ff3919e3          	bne	s2,s3,1ea4 <manywrites+0x16>
    1eb6:	4491                	li	s1,4
    wait(&st);
    1eb8:	f9840913          	addi	s2,s0,-104
    int st = 0;
    1ebc:	f8042c23          	sw	zero,-104(s0)
    wait(&st);
    1ec0:	854a                	mv	a0,s2
    1ec2:	14c030ef          	jal	500e <wait>
    if(st != 0)
    1ec6:	f9842503          	lw	a0,-104(s0)
    1eca:	0e051763          	bnez	a0,1fb8 <manywrites+0x12a>
  for(int ci = 0; ci < nchildren; ci++){
    1ece:	34fd                	addiw	s1,s1,-1
    1ed0:	f4f5                	bnez	s1,1ebc <manywrites+0x2e>
    1ed2:	e0d2                	sd	s4,64(sp)
    1ed4:	fc56                	sd	s5,56(sp)
    1ed6:	f85a                	sd	s6,48(sp)
    1ed8:	f45e                	sd	s7,40(sp)
    1eda:	f062                	sd	s8,32(sp)
    1edc:	e86a                	sd	s10,16(sp)
  exit(0);
    1ede:	128030ef          	jal	5006 <exit>
    1ee2:	e0d2                	sd	s4,64(sp)
    1ee4:	fc56                	sd	s5,56(sp)
    1ee6:	f85a                	sd	s6,48(sp)
    1ee8:	f45e                	sd	s7,40(sp)
    1eea:	f062                	sd	s8,32(sp)
    1eec:	e86a                	sd	s10,16(sp)
      printf("fork failed\n");
    1eee:	00005517          	auipc	a0,0x5
    1ef2:	58250513          	addi	a0,a0,1410 # 7470 <malloc+0x1f64>
    1ef6:	55e030ef          	jal	5454 <printf>
      exit(1);
    1efa:	4505                	li	a0,1
    1efc:	10a030ef          	jal	5006 <exit>
    1f00:	e0d2                	sd	s4,64(sp)
    1f02:	fc56                	sd	s5,56(sp)
    1f04:	f85a                	sd	s6,48(sp)
    1f06:	f45e                	sd	s7,40(sp)
    1f08:	f062                	sd	s8,32(sp)
    1f0a:	e86a                	sd	s10,16(sp)
      name[0] = 'b';
    1f0c:	06200793          	li	a5,98
    1f10:	f8f40c23          	sb	a5,-104(s0)
      name[1] = 'a' + ci;
    1f14:	0619079b          	addiw	a5,s2,97
    1f18:	f8f40ca3          	sb	a5,-103(s0)
      name[2] = '\0';
    1f1c:	f8040d23          	sb	zero,-102(s0)
      unlink(name);
    1f20:	f9840513          	addi	a0,s0,-104
    1f24:	132030ef          	jal	5056 <unlink>
    1f28:	47f9                	li	a5,30
    1f2a:	8d3e                	mv	s10,a5
          int fd = open(name, O_CREATE | O_RDWR);
    1f2c:	f9840b93          	addi	s7,s0,-104
    1f30:	20200b13          	li	s6,514
          int cc = write(fd, buf, sz);
    1f34:	6a8d                	lui	s5,0x3
    1f36:	0000cc17          	auipc	s8,0xc
    1f3a:	d82c0c13          	addi	s8,s8,-638 # dcb8 <buf>
        for(int i = 0; i < ci+1; i++){
    1f3e:	8a26                	mv	s4,s1
    1f40:	02094563          	bltz	s2,1f6a <manywrites+0xdc>
          int fd = open(name, O_CREATE | O_RDWR);
    1f44:	85da                	mv	a1,s6
    1f46:	855e                	mv	a0,s7
    1f48:	0fe030ef          	jal	5046 <open>
    1f4c:	89aa                	mv	s3,a0
          if(fd < 0){
    1f4e:	02054d63          	bltz	a0,1f88 <manywrites+0xfa>
          int cc = write(fd, buf, sz);
    1f52:	8656                	mv	a2,s5
    1f54:	85e2                	mv	a1,s8
    1f56:	0d0030ef          	jal	5026 <write>
          if(cc != sz){
    1f5a:	05551363          	bne	a0,s5,1fa0 <manywrites+0x112>
          close(fd);
    1f5e:	854e                	mv	a0,s3
    1f60:	0ce030ef          	jal	502e <close>
        for(int i = 0; i < ci+1; i++){
    1f64:	2a05                	addiw	s4,s4,1
    1f66:	fd495fe3          	bge	s2,s4,1f44 <manywrites+0xb6>
        unlink(name);
    1f6a:	f9840513          	addi	a0,s0,-104
    1f6e:	0e8030ef          	jal	5056 <unlink>
      for(int iters = 0; iters < howmany; iters++){
    1f72:	fffd079b          	addiw	a5,s10,-1
    1f76:	8d3e                	mv	s10,a5
    1f78:	f3f9                	bnez	a5,1f3e <manywrites+0xb0>
      unlink(name);
    1f7a:	f9840513          	addi	a0,s0,-104
    1f7e:	0d8030ef          	jal	5056 <unlink>
      exit(0);
    1f82:	4501                	li	a0,0
    1f84:	082030ef          	jal	5006 <exit>
            printf("%s: cannot create %s\n", s, name);
    1f88:	f9840613          	addi	a2,s0,-104
    1f8c:	85e6                	mv	a1,s9
    1f8e:	00004517          	auipc	a0,0x4
    1f92:	28a50513          	addi	a0,a0,650 # 6218 <malloc+0xd0c>
    1f96:	4be030ef          	jal	5454 <printf>
            exit(1);
    1f9a:	4505                	li	a0,1
    1f9c:	06a030ef          	jal	5006 <exit>
            printf("%s: write(%d) ret %d\n", s, sz, cc);
    1fa0:	86aa                	mv	a3,a0
    1fa2:	660d                	lui	a2,0x3
    1fa4:	85e6                	mv	a1,s9
    1fa6:	00003517          	auipc	a0,0x3
    1faa:	76250513          	addi	a0,a0,1890 # 5708 <malloc+0x1fc>
    1fae:	4a6030ef          	jal	5454 <printf>
            exit(1);
    1fb2:	4505                	li	a0,1
    1fb4:	052030ef          	jal	5006 <exit>
    1fb8:	e0d2                	sd	s4,64(sp)
    1fba:	fc56                	sd	s5,56(sp)
    1fbc:	f85a                	sd	s6,48(sp)
    1fbe:	f45e                	sd	s7,40(sp)
    1fc0:	f062                	sd	s8,32(sp)
    1fc2:	e86a                	sd	s10,16(sp)
      exit(st);
    1fc4:	042030ef          	jal	5006 <exit>

0000000000001fc8 <copyinstr3>:
{
    1fc8:	7179                	addi	sp,sp,-48
    1fca:	f406                	sd	ra,40(sp)
    1fcc:	f022                	sd	s0,32(sp)
    1fce:	ec26                	sd	s1,24(sp)
    1fd0:	1800                	addi	s0,sp,48
  sbrk(8192);
    1fd2:	6509                	lui	a0,0x2
    1fd4:	7ff020ef          	jal	4fd2 <sbrk>
  uint64 top = (uint64) sbrk(0);
    1fd8:	4501                	li	a0,0
    1fda:	7f9020ef          	jal	4fd2 <sbrk>
  if((top % PGSIZE) != 0){
    1fde:	03451793          	slli	a5,a0,0x34
    1fe2:	e7bd                	bnez	a5,2050 <copyinstr3+0x88>
  top = (uint64) sbrk(0);
    1fe4:	4501                	li	a0,0
    1fe6:	7ed020ef          	jal	4fd2 <sbrk>
  if(top % PGSIZE){
    1fea:	03451793          	slli	a5,a0,0x34
    1fee:	ebad                	bnez	a5,2060 <copyinstr3+0x98>
  char *b = (char *) (top - 1);
    1ff0:	fff50493          	addi	s1,a0,-1 # 1fff <copyinstr3+0x37>
  *b = 'x';
    1ff4:	07800793          	li	a5,120
    1ff8:	fef50fa3          	sb	a5,-1(a0)
  int ret = unlink(b);
    1ffc:	8526                	mv	a0,s1
    1ffe:	058030ef          	jal	5056 <unlink>
  if(ret != -1){
    2002:	57fd                	li	a5,-1
    2004:	06f51763          	bne	a0,a5,2072 <copyinstr3+0xaa>
  int fd = open(b, O_CREATE | O_WRONLY);
    2008:	20100593          	li	a1,513
    200c:	8526                	mv	a0,s1
    200e:	038030ef          	jal	5046 <open>
  if(fd != -1){
    2012:	57fd                	li	a5,-1
    2014:	06f51a63          	bne	a0,a5,2088 <copyinstr3+0xc0>
  ret = link(b, b);
    2018:	85a6                	mv	a1,s1
    201a:	8526                	mv	a0,s1
    201c:	04a030ef          	jal	5066 <link>
  if(ret != -1){
    2020:	57fd                	li	a5,-1
    2022:	06f51e63          	bne	a0,a5,209e <copyinstr3+0xd6>
  char *args[] = { "xx", 0 };
    2026:	00005797          	auipc	a5,0x5
    202a:	ef278793          	addi	a5,a5,-270 # 6f18 <malloc+0x1a0c>
    202e:	fcf43823          	sd	a5,-48(s0)
    2032:	fc043c23          	sd	zero,-40(s0)
  ret = exec(b, args);
    2036:	fd040593          	addi	a1,s0,-48
    203a:	8526                	mv	a0,s1
    203c:	002030ef          	jal	503e <exec>
  if(ret != -1){
    2040:	57fd                	li	a5,-1
    2042:	06f51a63          	bne	a0,a5,20b6 <copyinstr3+0xee>
}
    2046:	70a2                	ld	ra,40(sp)
    2048:	7402                	ld	s0,32(sp)
    204a:	64e2                	ld	s1,24(sp)
    204c:	6145                	addi	sp,sp,48
    204e:	8082                	ret
    sbrk(PGSIZE - (top % PGSIZE));
    2050:	0347d513          	srli	a0,a5,0x34
    2054:	6785                	lui	a5,0x1
    2056:	40a7853b          	subw	a0,a5,a0
    205a:	779020ef          	jal	4fd2 <sbrk>
    205e:	b759                	j	1fe4 <copyinstr3+0x1c>
    printf("oops\n");
    2060:	00004517          	auipc	a0,0x4
    2064:	1d050513          	addi	a0,a0,464 # 6230 <malloc+0xd24>
    2068:	3ec030ef          	jal	5454 <printf>
    exit(1);
    206c:	4505                	li	a0,1
    206e:	799020ef          	jal	5006 <exit>
    printf("unlink(%s) returned %d, not -1\n", b, ret);
    2072:	862a                	mv	a2,a0
    2074:	85a6                	mv	a1,s1
    2076:	00004517          	auipc	a0,0x4
    207a:	d7250513          	addi	a0,a0,-654 # 5de8 <malloc+0x8dc>
    207e:	3d6030ef          	jal	5454 <printf>
    exit(1);
    2082:	4505                	li	a0,1
    2084:	783020ef          	jal	5006 <exit>
    printf("open(%s) returned %d, not -1\n", b, fd);
    2088:	862a                	mv	a2,a0
    208a:	85a6                	mv	a1,s1
    208c:	00004517          	auipc	a0,0x4
    2090:	d7c50513          	addi	a0,a0,-644 # 5e08 <malloc+0x8fc>
    2094:	3c0030ef          	jal	5454 <printf>
    exit(1);
    2098:	4505                	li	a0,1
    209a:	76d020ef          	jal	5006 <exit>
    printf("link(%s, %s) returned %d, not -1\n", b, b, ret);
    209e:	86aa                	mv	a3,a0
    20a0:	8626                	mv	a2,s1
    20a2:	85a6                	mv	a1,s1
    20a4:	00004517          	auipc	a0,0x4
    20a8:	d8450513          	addi	a0,a0,-636 # 5e28 <malloc+0x91c>
    20ac:	3a8030ef          	jal	5454 <printf>
    exit(1);
    20b0:	4505                	li	a0,1
    20b2:	755020ef          	jal	5006 <exit>
    printf("exec(%s) returned %d, not -1\n", b, fd);
    20b6:	863e                	mv	a2,a5
    20b8:	85a6                	mv	a1,s1
    20ba:	00004517          	auipc	a0,0x4
    20be:	d9650513          	addi	a0,a0,-618 # 5e50 <malloc+0x944>
    20c2:	392030ef          	jal	5454 <printf>
    exit(1);
    20c6:	4505                	li	a0,1
    20c8:	73f020ef          	jal	5006 <exit>

00000000000020cc <rwsbrk>:
{
    20cc:	1101                	addi	sp,sp,-32
    20ce:	ec06                	sd	ra,24(sp)
    20d0:	e822                	sd	s0,16(sp)
    20d2:	1000                	addi	s0,sp,32
  uint64 a = (uint64) sbrk(8192);
    20d4:	6509                	lui	a0,0x2
    20d6:	6fd020ef          	jal	4fd2 <sbrk>
  if(a == (uint64) SBRK_ERROR) {
    20da:	57fd                	li	a5,-1
    20dc:	04f50a63          	beq	a0,a5,2130 <rwsbrk+0x64>
    20e0:	e426                	sd	s1,8(sp)
    20e2:	84aa                	mv	s1,a0
  if (sbrk(-8192) == SBRK_ERROR) {
    20e4:	7579                	lui	a0,0xffffe
    20e6:	6ed020ef          	jal	4fd2 <sbrk>
    20ea:	57fd                	li	a5,-1
    20ec:	04f50d63          	beq	a0,a5,2146 <rwsbrk+0x7a>
    20f0:	e04a                	sd	s2,0(sp)
  fd = open("rwsbrk", O_CREATE|O_WRONLY);
    20f2:	20100593          	li	a1,513
    20f6:	00004517          	auipc	a0,0x4
    20fa:	17a50513          	addi	a0,a0,378 # 6270 <malloc+0xd64>
    20fe:	749020ef          	jal	5046 <open>
    2102:	892a                	mv	s2,a0
  if(fd < 0){
    2104:	04054b63          	bltz	a0,215a <rwsbrk+0x8e>
  n = write(fd, (void*)(a+PGSIZE), 1024);
    2108:	6785                	lui	a5,0x1
    210a:	94be                	add	s1,s1,a5
    210c:	40000613          	li	a2,1024
    2110:	85a6                	mv	a1,s1
    2112:	715020ef          	jal	5026 <write>
    2116:	862a                	mv	a2,a0
  if(n >= 0){
    2118:	04054a63          	bltz	a0,216c <rwsbrk+0xa0>
    printf("write(fd, %p, 1024) returned %d, not -1\n", (void*)a+PGSIZE, n);
    211c:	85a6                	mv	a1,s1
    211e:	00004517          	auipc	a0,0x4
    2122:	17250513          	addi	a0,a0,370 # 6290 <malloc+0xd84>
    2126:	32e030ef          	jal	5454 <printf>
    exit(1);
    212a:	4505                	li	a0,1
    212c:	6db020ef          	jal	5006 <exit>
    2130:	e426                	sd	s1,8(sp)
    2132:	e04a                	sd	s2,0(sp)
    printf("sbrk(rwsbrk) failed\n");
    2134:	00004517          	auipc	a0,0x4
    2138:	10450513          	addi	a0,a0,260 # 6238 <malloc+0xd2c>
    213c:	318030ef          	jal	5454 <printf>
    exit(1);
    2140:	4505                	li	a0,1
    2142:	6c5020ef          	jal	5006 <exit>
    2146:	e04a                	sd	s2,0(sp)
    printf("sbrk(rwsbrk) shrink failed\n");
    2148:	00004517          	auipc	a0,0x4
    214c:	10850513          	addi	a0,a0,264 # 6250 <malloc+0xd44>
    2150:	304030ef          	jal	5454 <printf>
    exit(1);
    2154:	4505                	li	a0,1
    2156:	6b1020ef          	jal	5006 <exit>
    printf("open(rwsbrk) failed\n");
    215a:	00004517          	auipc	a0,0x4
    215e:	11e50513          	addi	a0,a0,286 # 6278 <malloc+0xd6c>
    2162:	2f2030ef          	jal	5454 <printf>
    exit(1);
    2166:	4505                	li	a0,1
    2168:	69f020ef          	jal	5006 <exit>
  close(fd);
    216c:	854a                	mv	a0,s2
    216e:	6c1020ef          	jal	502e <close>
  unlink("rwsbrk");
    2172:	00004517          	auipc	a0,0x4
    2176:	0fe50513          	addi	a0,a0,254 # 6270 <malloc+0xd64>
    217a:	6dd020ef          	jal	5056 <unlink>
  fd = open("README", O_RDONLY);
    217e:	4581                	li	a1,0
    2180:	00003517          	auipc	a0,0x3
    2184:	69050513          	addi	a0,a0,1680 # 5810 <malloc+0x304>
    2188:	6bf020ef          	jal	5046 <open>
    218c:	892a                	mv	s2,a0
  if(fd < 0){
    218e:	02054363          	bltz	a0,21b4 <rwsbrk+0xe8>
  n = read(fd, (void*)(a+PGSIZE), 10);
    2192:	4629                	li	a2,10
    2194:	85a6                	mv	a1,s1
    2196:	689020ef          	jal	501e <read>
    219a:	862a                	mv	a2,a0
  if(n >= 0){
    219c:	02054563          	bltz	a0,21c6 <rwsbrk+0xfa>
    printf("read(fd, %p, 10) returned %d, not -1\n", (void*)a+PGSIZE, n);
    21a0:	85a6                	mv	a1,s1
    21a2:	00004517          	auipc	a0,0x4
    21a6:	11e50513          	addi	a0,a0,286 # 62c0 <malloc+0xdb4>
    21aa:	2aa030ef          	jal	5454 <printf>
    exit(1);
    21ae:	4505                	li	a0,1
    21b0:	657020ef          	jal	5006 <exit>
    printf("open(README) failed\n");
    21b4:	00003517          	auipc	a0,0x3
    21b8:	66450513          	addi	a0,a0,1636 # 5818 <malloc+0x30c>
    21bc:	298030ef          	jal	5454 <printf>
    exit(1);
    21c0:	4505                	li	a0,1
    21c2:	645020ef          	jal	5006 <exit>
  close(fd);
    21c6:	854a                	mv	a0,s2
    21c8:	667020ef          	jal	502e <close>
  exit(0);
    21cc:	4501                	li	a0,0
    21ce:	639020ef          	jal	5006 <exit>

00000000000021d2 <sbrkbasic>:
{
    21d2:	715d                	addi	sp,sp,-80
    21d4:	e486                	sd	ra,72(sp)
    21d6:	e0a2                	sd	s0,64(sp)
    21d8:	ec56                	sd	s5,24(sp)
    21da:	0880                	addi	s0,sp,80
    21dc:	8aaa                	mv	s5,a0
  pid = fork();
    21de:	621020ef          	jal	4ffe <fork>
  if(pid < 0){
    21e2:	02054c63          	bltz	a0,221a <sbrkbasic+0x48>
  if(pid == 0){
    21e6:	ed31                	bnez	a0,2242 <sbrkbasic+0x70>
    a = sbrk(TOOMUCH);
    21e8:	40000537          	lui	a0,0x40000
    21ec:	5e7020ef          	jal	4fd2 <sbrk>
    if(a == (char*)SBRK_ERROR){
    21f0:	57fd                	li	a5,-1
    21f2:	04f50163          	beq	a0,a5,2234 <sbrkbasic+0x62>
    21f6:	fc26                	sd	s1,56(sp)
    21f8:	f84a                	sd	s2,48(sp)
    21fa:	f44e                	sd	s3,40(sp)
    21fc:	f052                	sd	s4,32(sp)
    for(b = a; b < a+TOOMUCH; b += PGSIZE){
    21fe:	400007b7          	lui	a5,0x40000
    2202:	97aa                	add	a5,a5,a0
      *b = 99;
    2204:	06300693          	li	a3,99
    for(b = a; b < a+TOOMUCH; b += PGSIZE){
    2208:	6705                	lui	a4,0x1
      *b = 99;
    220a:	00d50023          	sb	a3,0(a0) # 40000000 <base+0x3ffef348>
    for(b = a; b < a+TOOMUCH; b += PGSIZE){
    220e:	953a                	add	a0,a0,a4
    2210:	fef51de3          	bne	a0,a5,220a <sbrkbasic+0x38>
    exit(1);
    2214:	4505                	li	a0,1
    2216:	5f1020ef          	jal	5006 <exit>
    221a:	fc26                	sd	s1,56(sp)
    221c:	f84a                	sd	s2,48(sp)
    221e:	f44e                	sd	s3,40(sp)
    2220:	f052                	sd	s4,32(sp)
    printf("fork failed in sbrkbasic\n");
    2222:	00004517          	auipc	a0,0x4
    2226:	0c650513          	addi	a0,a0,198 # 62e8 <malloc+0xddc>
    222a:	22a030ef          	jal	5454 <printf>
    exit(1);
    222e:	4505                	li	a0,1
    2230:	5d7020ef          	jal	5006 <exit>
    2234:	fc26                	sd	s1,56(sp)
    2236:	f84a                	sd	s2,48(sp)
    2238:	f44e                	sd	s3,40(sp)
    223a:	f052                	sd	s4,32(sp)
      exit(0);
    223c:	4501                	li	a0,0
    223e:	5c9020ef          	jal	5006 <exit>
  wait(&xstatus);
    2242:	fbc40513          	addi	a0,s0,-68
    2246:	5c9020ef          	jal	500e <wait>
  if(xstatus == 1){
    224a:	fbc42703          	lw	a4,-68(s0)
    224e:	4785                	li	a5,1
    2250:	02f70063          	beq	a4,a5,2270 <sbrkbasic+0x9e>
    2254:	fc26                	sd	s1,56(sp)
    2256:	f84a                	sd	s2,48(sp)
    2258:	f44e                	sd	s3,40(sp)
    225a:	f052                	sd	s4,32(sp)
  a = sbrk(0);
    225c:	4501                	li	a0,0
    225e:	575020ef          	jal	4fd2 <sbrk>
    2262:	84aa                	mv	s1,a0
  for(i = 0; i < 5000; i++){
    2264:	4901                	li	s2,0
    b = sbrk(1);
    2266:	4985                	li	s3,1
  for(i = 0; i < 5000; i++){
    2268:	6a05                	lui	s4,0x1
    226a:	388a0a13          	addi	s4,s4,904 # 1388 <truncate3+0x14a>
    226e:	a005                	j	228e <sbrkbasic+0xbc>
    2270:	fc26                	sd	s1,56(sp)
    2272:	f84a                	sd	s2,48(sp)
    2274:	f44e                	sd	s3,40(sp)
    2276:	f052                	sd	s4,32(sp)
    printf("%s: too much memory allocated!\n", s);
    2278:	85d6                	mv	a1,s5
    227a:	00004517          	auipc	a0,0x4
    227e:	08e50513          	addi	a0,a0,142 # 6308 <malloc+0xdfc>
    2282:	1d2030ef          	jal	5454 <printf>
    exit(1);
    2286:	4505                	li	a0,1
    2288:	57f020ef          	jal	5006 <exit>
    228c:	84be                	mv	s1,a5
    b = sbrk(1);
    228e:	854e                	mv	a0,s3
    2290:	543020ef          	jal	4fd2 <sbrk>
    if(b != a){
    2294:	04951163          	bne	a0,s1,22d6 <sbrkbasic+0x104>
    *b = 1;
    2298:	01348023          	sb	s3,0(s1)
    a = b + 1;
    229c:	00148793          	addi	a5,s1,1
  for(i = 0; i < 5000; i++){
    22a0:	2905                	addiw	s2,s2,1
    22a2:	ff4915e3          	bne	s2,s4,228c <sbrkbasic+0xba>
  pid = fork();
    22a6:	559020ef          	jal	4ffe <fork>
    22aa:	892a                	mv	s2,a0
  if(pid < 0){
    22ac:	04054263          	bltz	a0,22f0 <sbrkbasic+0x11e>
  c = sbrk(1);
    22b0:	4505                	li	a0,1
    22b2:	521020ef          	jal	4fd2 <sbrk>
  c = sbrk(1);
    22b6:	4505                	li	a0,1
    22b8:	51b020ef          	jal	4fd2 <sbrk>
  if(c != a + 1){
    22bc:	0489                	addi	s1,s1,2
    22be:	04950363          	beq	a0,s1,2304 <sbrkbasic+0x132>
    printf("%s: sbrk test failed post-fork\n", s);
    22c2:	85d6                	mv	a1,s5
    22c4:	00004517          	auipc	a0,0x4
    22c8:	0a450513          	addi	a0,a0,164 # 6368 <malloc+0xe5c>
    22cc:	188030ef          	jal	5454 <printf>
    exit(1);
    22d0:	4505                	li	a0,1
    22d2:	535020ef          	jal	5006 <exit>
      printf("%s: sbrk test failed %d %p %p\n", s, i, a, b);
    22d6:	872a                	mv	a4,a0
    22d8:	86a6                	mv	a3,s1
    22da:	864a                	mv	a2,s2
    22dc:	85d6                	mv	a1,s5
    22de:	00004517          	auipc	a0,0x4
    22e2:	04a50513          	addi	a0,a0,74 # 6328 <malloc+0xe1c>
    22e6:	16e030ef          	jal	5454 <printf>
      exit(1);
    22ea:	4505                	li	a0,1
    22ec:	51b020ef          	jal	5006 <exit>
    printf("%s: sbrk test fork failed\n", s);
    22f0:	85d6                	mv	a1,s5
    22f2:	00004517          	auipc	a0,0x4
    22f6:	05650513          	addi	a0,a0,86 # 6348 <malloc+0xe3c>
    22fa:	15a030ef          	jal	5454 <printf>
    exit(1);
    22fe:	4505                	li	a0,1
    2300:	507020ef          	jal	5006 <exit>
  if(pid == 0)
    2304:	00091563          	bnez	s2,230e <sbrkbasic+0x13c>
    exit(0);
    2308:	4501                	li	a0,0
    230a:	4fd020ef          	jal	5006 <exit>
  wait(&xstatus);
    230e:	fbc40513          	addi	a0,s0,-68
    2312:	4fd020ef          	jal	500e <wait>
  exit(xstatus);
    2316:	fbc42503          	lw	a0,-68(s0)
    231a:	4ed020ef          	jal	5006 <exit>

000000000000231e <sbrkmuch>:
{
    231e:	7179                	addi	sp,sp,-48
    2320:	f406                	sd	ra,40(sp)
    2322:	f022                	sd	s0,32(sp)
    2324:	ec26                	sd	s1,24(sp)
    2326:	e84a                	sd	s2,16(sp)
    2328:	e44e                	sd	s3,8(sp)
    232a:	e052                	sd	s4,0(sp)
    232c:	1800                	addi	s0,sp,48
    232e:	89aa                	mv	s3,a0
  oldbrk = sbrk(0);
    2330:	4501                	li	a0,0
    2332:	4a1020ef          	jal	4fd2 <sbrk>
    2336:	892a                	mv	s2,a0
  a = sbrk(0);
    2338:	4501                	li	a0,0
    233a:	499020ef          	jal	4fd2 <sbrk>
    233e:	84aa                	mv	s1,a0
  p = sbrk(amt);
    2340:	06400537          	lui	a0,0x6400
    2344:	9d05                	subw	a0,a0,s1
    2346:	48d020ef          	jal	4fd2 <sbrk>
  if (p != a) {
    234a:	08a49963          	bne	s1,a0,23dc <sbrkmuch+0xbe>
  *lastaddr = 99;
    234e:	064007b7          	lui	a5,0x6400
    2352:	06300713          	li	a4,99
    2356:	fee78fa3          	sb	a4,-1(a5) # 63fffff <base+0x63ef347>
  a = sbrk(0);
    235a:	4501                	li	a0,0
    235c:	477020ef          	jal	4fd2 <sbrk>
    2360:	84aa                	mv	s1,a0
  c = sbrk(-PGSIZE);
    2362:	757d                	lui	a0,0xfffff
    2364:	46f020ef          	jal	4fd2 <sbrk>
  if(c == (char*)SBRK_ERROR){
    2368:	57fd                	li	a5,-1
    236a:	08f50363          	beq	a0,a5,23f0 <sbrkmuch+0xd2>
  c = sbrk(0);
    236e:	4501                	li	a0,0
    2370:	463020ef          	jal	4fd2 <sbrk>
  if(c != a - PGSIZE){
    2374:	80048793          	addi	a5,s1,-2048
    2378:	80078793          	addi	a5,a5,-2048
    237c:	08f51463          	bne	a0,a5,2404 <sbrkmuch+0xe6>
  a = sbrk(0);
    2380:	4501                	li	a0,0
    2382:	451020ef          	jal	4fd2 <sbrk>
    2386:	84aa                	mv	s1,a0
  c = sbrk(PGSIZE);
    2388:	6505                	lui	a0,0x1
    238a:	449020ef          	jal	4fd2 <sbrk>
    238e:	8a2a                	mv	s4,a0
  if(c != a || sbrk(0) != a + PGSIZE){
    2390:	08a49663          	bne	s1,a0,241c <sbrkmuch+0xfe>
    2394:	4501                	li	a0,0
    2396:	43d020ef          	jal	4fd2 <sbrk>
    239a:	6785                	lui	a5,0x1
    239c:	97a6                	add	a5,a5,s1
    239e:	06f51f63          	bne	a0,a5,241c <sbrkmuch+0xfe>
  if(*lastaddr == 99){
    23a2:	064007b7          	lui	a5,0x6400
    23a6:	fff7c703          	lbu	a4,-1(a5) # 63fffff <base+0x63ef347>
    23aa:	06300793          	li	a5,99
    23ae:	08f70363          	beq	a4,a5,2434 <sbrkmuch+0x116>
  a = sbrk(0);
    23b2:	4501                	li	a0,0
    23b4:	41f020ef          	jal	4fd2 <sbrk>
    23b8:	84aa                	mv	s1,a0
  c = sbrk(-(sbrk(0) - oldbrk));
    23ba:	4501                	li	a0,0
    23bc:	417020ef          	jal	4fd2 <sbrk>
    23c0:	40a9053b          	subw	a0,s2,a0
    23c4:	40f020ef          	jal	4fd2 <sbrk>
  if(c != a){
    23c8:	08a49063          	bne	s1,a0,2448 <sbrkmuch+0x12a>
}
    23cc:	70a2                	ld	ra,40(sp)
    23ce:	7402                	ld	s0,32(sp)
    23d0:	64e2                	ld	s1,24(sp)
    23d2:	6942                	ld	s2,16(sp)
    23d4:	69a2                	ld	s3,8(sp)
    23d6:	6a02                	ld	s4,0(sp)
    23d8:	6145                	addi	sp,sp,48
    23da:	8082                	ret
    printf("%s: sbrk test failed to grow big address space; enough phys mem?\n", s);
    23dc:	85ce                	mv	a1,s3
    23de:	00004517          	auipc	a0,0x4
    23e2:	faa50513          	addi	a0,a0,-86 # 6388 <malloc+0xe7c>
    23e6:	06e030ef          	jal	5454 <printf>
    exit(1);
    23ea:	4505                	li	a0,1
    23ec:	41b020ef          	jal	5006 <exit>
    printf("%s: sbrk could not deallocate\n", s);
    23f0:	85ce                	mv	a1,s3
    23f2:	00004517          	auipc	a0,0x4
    23f6:	fde50513          	addi	a0,a0,-34 # 63d0 <malloc+0xec4>
    23fa:	05a030ef          	jal	5454 <printf>
    exit(1);
    23fe:	4505                	li	a0,1
    2400:	407020ef          	jal	5006 <exit>
    printf("%s: sbrk deallocation produced wrong address, a %p c %p\n", s, a, c);
    2404:	86aa                	mv	a3,a0
    2406:	8626                	mv	a2,s1
    2408:	85ce                	mv	a1,s3
    240a:	00004517          	auipc	a0,0x4
    240e:	fe650513          	addi	a0,a0,-26 # 63f0 <malloc+0xee4>
    2412:	042030ef          	jal	5454 <printf>
    exit(1);
    2416:	4505                	li	a0,1
    2418:	3ef020ef          	jal	5006 <exit>
    printf("%s: sbrk re-allocation failed, a %p c %p\n", s, a, c);
    241c:	86d2                	mv	a3,s4
    241e:	8626                	mv	a2,s1
    2420:	85ce                	mv	a1,s3
    2422:	00004517          	auipc	a0,0x4
    2426:	00e50513          	addi	a0,a0,14 # 6430 <malloc+0xf24>
    242a:	02a030ef          	jal	5454 <printf>
    exit(1);
    242e:	4505                	li	a0,1
    2430:	3d7020ef          	jal	5006 <exit>
    printf("%s: sbrk de-allocation didn't really deallocate\n", s);
    2434:	85ce                	mv	a1,s3
    2436:	00004517          	auipc	a0,0x4
    243a:	02a50513          	addi	a0,a0,42 # 6460 <malloc+0xf54>
    243e:	016030ef          	jal	5454 <printf>
    exit(1);
    2442:	4505                	li	a0,1
    2444:	3c3020ef          	jal	5006 <exit>
    printf("%s: sbrk downsize failed, a %p c %p\n", s, a, c);
    2448:	86aa                	mv	a3,a0
    244a:	8626                	mv	a2,s1
    244c:	85ce                	mv	a1,s3
    244e:	00004517          	auipc	a0,0x4
    2452:	04a50513          	addi	a0,a0,74 # 6498 <malloc+0xf8c>
    2456:	7ff020ef          	jal	5454 <printf>
    exit(1);
    245a:	4505                	li	a0,1
    245c:	3ab020ef          	jal	5006 <exit>

0000000000002460 <sbrkarg>:
{
    2460:	7179                	addi	sp,sp,-48
    2462:	f406                	sd	ra,40(sp)
    2464:	f022                	sd	s0,32(sp)
    2466:	ec26                	sd	s1,24(sp)
    2468:	e84a                	sd	s2,16(sp)
    246a:	e44e                	sd	s3,8(sp)
    246c:	1800                	addi	s0,sp,48
    246e:	89aa                	mv	s3,a0
  a = sbrk(PGSIZE);
    2470:	6505                	lui	a0,0x1
    2472:	361020ef          	jal	4fd2 <sbrk>
    2476:	892a                	mv	s2,a0
  fd = open("sbrk", O_CREATE|O_WRONLY);
    2478:	20100593          	li	a1,513
    247c:	00004517          	auipc	a0,0x4
    2480:	04450513          	addi	a0,a0,68 # 64c0 <malloc+0xfb4>
    2484:	3c3020ef          	jal	5046 <open>
    2488:	84aa                	mv	s1,a0
  unlink("sbrk");
    248a:	00004517          	auipc	a0,0x4
    248e:	03650513          	addi	a0,a0,54 # 64c0 <malloc+0xfb4>
    2492:	3c5020ef          	jal	5056 <unlink>
  if(fd < 0)  {
    2496:	0204c963          	bltz	s1,24c8 <sbrkarg+0x68>
  if ((n = write(fd, a, PGSIZE)) < 0) {
    249a:	6605                	lui	a2,0x1
    249c:	85ca                	mv	a1,s2
    249e:	8526                	mv	a0,s1
    24a0:	387020ef          	jal	5026 <write>
    24a4:	02054c63          	bltz	a0,24dc <sbrkarg+0x7c>
  close(fd);
    24a8:	8526                	mv	a0,s1
    24aa:	385020ef          	jal	502e <close>
  a = sbrk(PGSIZE);
    24ae:	6505                	lui	a0,0x1
    24b0:	323020ef          	jal	4fd2 <sbrk>
  if(pipe((int *) a) != 0){
    24b4:	363020ef          	jal	5016 <pipe>
    24b8:	ed05                	bnez	a0,24f0 <sbrkarg+0x90>
}
    24ba:	70a2                	ld	ra,40(sp)
    24bc:	7402                	ld	s0,32(sp)
    24be:	64e2                	ld	s1,24(sp)
    24c0:	6942                	ld	s2,16(sp)
    24c2:	69a2                	ld	s3,8(sp)
    24c4:	6145                	addi	sp,sp,48
    24c6:	8082                	ret
    printf("%s: open sbrk failed\n", s);
    24c8:	85ce                	mv	a1,s3
    24ca:	00004517          	auipc	a0,0x4
    24ce:	ffe50513          	addi	a0,a0,-2 # 64c8 <malloc+0xfbc>
    24d2:	783020ef          	jal	5454 <printf>
    exit(1);
    24d6:	4505                	li	a0,1
    24d8:	32f020ef          	jal	5006 <exit>
    printf("%s: write sbrk failed\n", s);
    24dc:	85ce                	mv	a1,s3
    24de:	00004517          	auipc	a0,0x4
    24e2:	00250513          	addi	a0,a0,2 # 64e0 <malloc+0xfd4>
    24e6:	76f020ef          	jal	5454 <printf>
    exit(1);
    24ea:	4505                	li	a0,1
    24ec:	31b020ef          	jal	5006 <exit>
    printf("%s: pipe() failed\n", s);
    24f0:	85ce                	mv	a1,s3
    24f2:	00004517          	auipc	a0,0x4
    24f6:	ade50513          	addi	a0,a0,-1314 # 5fd0 <malloc+0xac4>
    24fa:	75b020ef          	jal	5454 <printf>
    exit(1);
    24fe:	4505                	li	a0,1
    2500:	307020ef          	jal	5006 <exit>

0000000000002504 <argptest>:
{
    2504:	1101                	addi	sp,sp,-32
    2506:	ec06                	sd	ra,24(sp)
    2508:	e822                	sd	s0,16(sp)
    250a:	e426                	sd	s1,8(sp)
    250c:	e04a                	sd	s2,0(sp)
    250e:	1000                	addi	s0,sp,32
    2510:	892a                	mv	s2,a0
  fd = open("init", O_RDONLY);
    2512:	4581                	li	a1,0
    2514:	00004517          	auipc	a0,0x4
    2518:	fe450513          	addi	a0,a0,-28 # 64f8 <malloc+0xfec>
    251c:	32b020ef          	jal	5046 <open>
  if (fd < 0) {
    2520:	02054563          	bltz	a0,254a <argptest+0x46>
    2524:	84aa                	mv	s1,a0
  read(fd, sbrk(0) - 1, -1);
    2526:	4501                	li	a0,0
    2528:	2ab020ef          	jal	4fd2 <sbrk>
    252c:	567d                	li	a2,-1
    252e:	00c505b3          	add	a1,a0,a2
    2532:	8526                	mv	a0,s1
    2534:	2eb020ef          	jal	501e <read>
  close(fd);
    2538:	8526                	mv	a0,s1
    253a:	2f5020ef          	jal	502e <close>
}
    253e:	60e2                	ld	ra,24(sp)
    2540:	6442                	ld	s0,16(sp)
    2542:	64a2                	ld	s1,8(sp)
    2544:	6902                	ld	s2,0(sp)
    2546:	6105                	addi	sp,sp,32
    2548:	8082                	ret
    printf("%s: open failed\n", s);
    254a:	85ca                	mv	a1,s2
    254c:	00004517          	auipc	a0,0x4
    2550:	99450513          	addi	a0,a0,-1644 # 5ee0 <malloc+0x9d4>
    2554:	701020ef          	jal	5454 <printf>
    exit(1);
    2558:	4505                	li	a0,1
    255a:	2ad020ef          	jal	5006 <exit>

000000000000255e <sbrkbugs>:
{
    255e:	1141                	addi	sp,sp,-16
    2560:	e406                	sd	ra,8(sp)
    2562:	e022                	sd	s0,0(sp)
    2564:	0800                	addi	s0,sp,16
  int pid = fork();
    2566:	299020ef          	jal	4ffe <fork>
  if(pid < 0){
    256a:	00054c63          	bltz	a0,2582 <sbrkbugs+0x24>
  if(pid == 0){
    256e:	e11d                	bnez	a0,2594 <sbrkbugs+0x36>
    int sz = (uint64) sbrk(0);
    2570:	263020ef          	jal	4fd2 <sbrk>
    sbrk(-sz);
    2574:	40a0053b          	negw	a0,a0
    2578:	25b020ef          	jal	4fd2 <sbrk>
    exit(0);
    257c:	4501                	li	a0,0
    257e:	289020ef          	jal	5006 <exit>
    printf("fork failed\n");
    2582:	00005517          	auipc	a0,0x5
    2586:	eee50513          	addi	a0,a0,-274 # 7470 <malloc+0x1f64>
    258a:	6cb020ef          	jal	5454 <printf>
    exit(1);
    258e:	4505                	li	a0,1
    2590:	277020ef          	jal	5006 <exit>
  wait(0);
    2594:	4501                	li	a0,0
    2596:	279020ef          	jal	500e <wait>
  pid = fork();
    259a:	265020ef          	jal	4ffe <fork>
  if(pid < 0){
    259e:	00054f63          	bltz	a0,25bc <sbrkbugs+0x5e>
  if(pid == 0){
    25a2:	e515                	bnez	a0,25ce <sbrkbugs+0x70>
    int sz = (uint64) sbrk(0);
    25a4:	22f020ef          	jal	4fd2 <sbrk>
    sbrk(-(sz - 3500));
    25a8:	6785                	lui	a5,0x1
    25aa:	dac7879b          	addiw	a5,a5,-596 # dac <linktest+0xe2>
    25ae:	40a7853b          	subw	a0,a5,a0
    25b2:	221020ef          	jal	4fd2 <sbrk>
    exit(0);
    25b6:	4501                	li	a0,0
    25b8:	24f020ef          	jal	5006 <exit>
    printf("fork failed\n");
    25bc:	00005517          	auipc	a0,0x5
    25c0:	eb450513          	addi	a0,a0,-332 # 7470 <malloc+0x1f64>
    25c4:	691020ef          	jal	5454 <printf>
    exit(1);
    25c8:	4505                	li	a0,1
    25ca:	23d020ef          	jal	5006 <exit>
  wait(0);
    25ce:	4501                	li	a0,0
    25d0:	23f020ef          	jal	500e <wait>
  pid = fork();
    25d4:	22b020ef          	jal	4ffe <fork>
  if(pid < 0){
    25d8:	02054263          	bltz	a0,25fc <sbrkbugs+0x9e>
  if(pid == 0){
    25dc:	e90d                	bnez	a0,260e <sbrkbugs+0xb0>
    sbrk((10*PGSIZE + 2048) - (uint64)sbrk(0));
    25de:	1f5020ef          	jal	4fd2 <sbrk>
    25e2:	67ad                	lui	a5,0xb
    25e4:	8007879b          	addiw	a5,a5,-2048 # a800 <big.0+0x260>
    25e8:	40a7853b          	subw	a0,a5,a0
    25ec:	1e7020ef          	jal	4fd2 <sbrk>
    sbrk(-10);
    25f0:	5559                	li	a0,-10
    25f2:	1e1020ef          	jal	4fd2 <sbrk>
    exit(0);
    25f6:	4501                	li	a0,0
    25f8:	20f020ef          	jal	5006 <exit>
    printf("fork failed\n");
    25fc:	00005517          	auipc	a0,0x5
    2600:	e7450513          	addi	a0,a0,-396 # 7470 <malloc+0x1f64>
    2604:	651020ef          	jal	5454 <printf>
    exit(1);
    2608:	4505                	li	a0,1
    260a:	1fd020ef          	jal	5006 <exit>
  wait(0);
    260e:	4501                	li	a0,0
    2610:	1ff020ef          	jal	500e <wait>
  exit(0);
    2614:	4501                	li	a0,0
    2616:	1f1020ef          	jal	5006 <exit>

000000000000261a <sbrklast>:
{
    261a:	7179                	addi	sp,sp,-48
    261c:	f406                	sd	ra,40(sp)
    261e:	f022                	sd	s0,32(sp)
    2620:	ec26                	sd	s1,24(sp)
    2622:	e84a                	sd	s2,16(sp)
    2624:	e44e                	sd	s3,8(sp)
    2626:	e052                	sd	s4,0(sp)
    2628:	1800                	addi	s0,sp,48
  uint64 top = (uint64) sbrk(0);
    262a:	4501                	li	a0,0
    262c:	1a7020ef          	jal	4fd2 <sbrk>
  if((top % PGSIZE) != 0)
    2630:	03451793          	slli	a5,a0,0x34
    2634:	ebad                	bnez	a5,26a6 <sbrklast+0x8c>
  sbrk(PGSIZE);
    2636:	6505                	lui	a0,0x1
    2638:	19b020ef          	jal	4fd2 <sbrk>
  sbrk(10);
    263c:	4529                	li	a0,10
    263e:	195020ef          	jal	4fd2 <sbrk>
  sbrk(-20);
    2642:	5531                	li	a0,-20
    2644:	18f020ef          	jal	4fd2 <sbrk>
  top = (uint64) sbrk(0);
    2648:	4501                	li	a0,0
    264a:	189020ef          	jal	4fd2 <sbrk>
    264e:	84aa                	mv	s1,a0
  char *p = (char *) (top - 64);
    2650:	fc050913          	addi	s2,a0,-64 # fc0 <bigdir+0xcc>
  p[0] = 'x';
    2654:	07800993          	li	s3,120
    2658:	fd350023          	sb	s3,-64(a0)
  p[1] = '\0';
    265c:	fc0500a3          	sb	zero,-63(a0)
  int fd = open(p, O_RDWR|O_CREATE);
    2660:	20200593          	li	a1,514
    2664:	854a                	mv	a0,s2
    2666:	1e1020ef          	jal	5046 <open>
    266a:	8a2a                	mv	s4,a0
  write(fd, p, 1);
    266c:	4605                	li	a2,1
    266e:	85ca                	mv	a1,s2
    2670:	1b7020ef          	jal	5026 <write>
  close(fd);
    2674:	8552                	mv	a0,s4
    2676:	1b9020ef          	jal	502e <close>
  fd = open(p, O_RDWR);
    267a:	4589                	li	a1,2
    267c:	854a                	mv	a0,s2
    267e:	1c9020ef          	jal	5046 <open>
  p[0] = '\0';
    2682:	fc048023          	sb	zero,-64(s1)
  read(fd, p, 1);
    2686:	4605                	li	a2,1
    2688:	85ca                	mv	a1,s2
    268a:	195020ef          	jal	501e <read>
  if(p[0] != 'x')
    268e:	fc04c783          	lbu	a5,-64(s1)
    2692:	03379263          	bne	a5,s3,26b6 <sbrklast+0x9c>
}
    2696:	70a2                	ld	ra,40(sp)
    2698:	7402                	ld	s0,32(sp)
    269a:	64e2                	ld	s1,24(sp)
    269c:	6942                	ld	s2,16(sp)
    269e:	69a2                	ld	s3,8(sp)
    26a0:	6a02                	ld	s4,0(sp)
    26a2:	6145                	addi	sp,sp,48
    26a4:	8082                	ret
    sbrk(PGSIZE - (top % PGSIZE));
    26a6:	0347d513          	srli	a0,a5,0x34
    26aa:	6785                	lui	a5,0x1
    26ac:	40a7853b          	subw	a0,a5,a0
    26b0:	123020ef          	jal	4fd2 <sbrk>
    26b4:	b749                	j	2636 <sbrklast+0x1c>
    exit(1);
    26b6:	4505                	li	a0,1
    26b8:	14f020ef          	jal	5006 <exit>

00000000000026bc <sbrk8000>:
{
    26bc:	1141                	addi	sp,sp,-16
    26be:	e406                	sd	ra,8(sp)
    26c0:	e022                	sd	s0,0(sp)
    26c2:	0800                	addi	s0,sp,16
  sbrk(0x80000004);
    26c4:	80000537          	lui	a0,0x80000
    26c8:	0511                	addi	a0,a0,4 # ffffffff80000004 <base+0xffffffff7ffef34c>
    26ca:	109020ef          	jal	4fd2 <sbrk>
  volatile char *top = sbrk(0);
    26ce:	4501                	li	a0,0
    26d0:	103020ef          	jal	4fd2 <sbrk>
  *(top-1) = *(top-1) + 1;
    26d4:	fff54783          	lbu	a5,-1(a0)
    26d8:	0785                	addi	a5,a5,1 # 1001 <bigdir+0x10d>
    26da:	0ff7f793          	zext.b	a5,a5
    26de:	fef50fa3          	sb	a5,-1(a0)
}
    26e2:	60a2                	ld	ra,8(sp)
    26e4:	6402                	ld	s0,0(sp)
    26e6:	0141                	addi	sp,sp,16
    26e8:	8082                	ret

00000000000026ea <execout>:
{
    26ea:	711d                	addi	sp,sp,-96
    26ec:	ec86                	sd	ra,88(sp)
    26ee:	e8a2                	sd	s0,80(sp)
    26f0:	e4a6                	sd	s1,72(sp)
    26f2:	e0ca                	sd	s2,64(sp)
    26f4:	fc4e                	sd	s3,56(sp)
    26f6:	1080                	addi	s0,sp,96
  for(int avail = 0; avail < 15; avail++){
    26f8:	4901                	li	s2,0
    26fa:	49bd                	li	s3,15
    int pid = fork();
    26fc:	103020ef          	jal	4ffe <fork>
    2700:	84aa                	mv	s1,a0
    if(pid < 0){
    2702:	00054f63          	bltz	a0,2720 <execout+0x36>
    } else if(pid == 0){
    2706:	c90d                	beqz	a0,2738 <execout+0x4e>
      wait((int*)0);
    2708:	4501                	li	a0,0
    270a:	105020ef          	jal	500e <wait>
  for(int avail = 0; avail < 15; avail++){
    270e:	2905                	addiw	s2,s2,1
    2710:	ff3916e3          	bne	s2,s3,26fc <execout+0x12>
    2714:	f852                	sd	s4,48(sp)
    2716:	f456                	sd	s5,40(sp)
    2718:	f05a                	sd	s6,32(sp)
  exit(0);
    271a:	4501                	li	a0,0
    271c:	0eb020ef          	jal	5006 <exit>
    2720:	f852                	sd	s4,48(sp)
    2722:	f456                	sd	s5,40(sp)
    2724:	f05a                	sd	s6,32(sp)
      printf("fork failed\n");
    2726:	00005517          	auipc	a0,0x5
    272a:	d4a50513          	addi	a0,a0,-694 # 7470 <malloc+0x1f64>
    272e:	527020ef          	jal	5454 <printf>
      exit(1);
    2732:	4505                	li	a0,1
    2734:	0d3020ef          	jal	5006 <exit>
    2738:	f852                	sd	s4,48(sp)
    273a:	f456                	sd	s5,40(sp)
    273c:	f05a                	sd	s6,32(sp)
    273e:	6999                	lui	s3,0x6
    2740:	1a898993          	addi	s3,s3,424 # 61a8 <malloc+0xc9c>
        char *a = sbrk(PGSIZE);
    2744:	6a05                	lui	s4,0x1
        if(a == SBRK_ERROR)
    2746:	5afd                	li	s5,-1
        *(a + PGSIZE - 1) = 1;
    2748:	4b05                	li	s6,1
        char *a = sbrk(PGSIZE);
    274a:	8552                	mv	a0,s4
    274c:	087020ef          	jal	4fd2 <sbrk>
        if(a == SBRK_ERROR)
    2750:	01550863          	beq	a0,s5,2760 <execout+0x76>
        *(a + PGSIZE - 1) = 1;
    2754:	9552                	add	a0,a0,s4
    2756:	ff650fa3          	sb	s6,-1(a0)
      while(n++ < max){
    275a:	39fd                	addiw	s3,s3,-1
    275c:	fe0997e3          	bnez	s3,274a <execout+0x60>
      for(int i = 0; i < avail; i++)
    2760:	01205963          	blez	s2,2772 <execout+0x88>
        sbrk(-PGSIZE);
    2764:	79fd                	lui	s3,0xfffff
    2766:	854e                	mv	a0,s3
    2768:	06b020ef          	jal	4fd2 <sbrk>
      for(int i = 0; i < avail; i++)
    276c:	2485                	addiw	s1,s1,1
    276e:	ff249ce3          	bne	s1,s2,2766 <execout+0x7c>
      close(1);
    2772:	4505                	li	a0,1
    2774:	0bb020ef          	jal	502e <close>
      char *args[] = { "echo", "x", 0 };
    2778:	00003797          	auipc	a5,0x3
    277c:	ec078793          	addi	a5,a5,-320 # 5638 <malloc+0x12c>
    2780:	faf43423          	sd	a5,-88(s0)
    2784:	00003797          	auipc	a5,0x3
    2788:	f2478793          	addi	a5,a5,-220 # 56a8 <malloc+0x19c>
    278c:	faf43823          	sd	a5,-80(s0)
    2790:	fa043c23          	sd	zero,-72(s0)
      exec("echo", args);
    2794:	fa840593          	addi	a1,s0,-88
    2798:	00003517          	auipc	a0,0x3
    279c:	ea050513          	addi	a0,a0,-352 # 5638 <malloc+0x12c>
    27a0:	09f020ef          	jal	503e <exec>
      exit(0);
    27a4:	4501                	li	a0,0
    27a6:	061020ef          	jal	5006 <exit>

00000000000027aa <fourteen>:
{
    27aa:	1101                	addi	sp,sp,-32
    27ac:	ec06                	sd	ra,24(sp)
    27ae:	e822                	sd	s0,16(sp)
    27b0:	e426                	sd	s1,8(sp)
    27b2:	1000                	addi	s0,sp,32
    27b4:	84aa                	mv	s1,a0
  if(mkdir("12345678901234") != 0){
    27b6:	00004517          	auipc	a0,0x4
    27ba:	f1a50513          	addi	a0,a0,-230 # 66d0 <malloc+0x11c4>
    27be:	0b1020ef          	jal	506e <mkdir>
    27c2:	e555                	bnez	a0,286e <fourteen+0xc4>
  if(mkdir("12345678901234/123456789012345") != 0){
    27c4:	00004517          	auipc	a0,0x4
    27c8:	d6450513          	addi	a0,a0,-668 # 6528 <malloc+0x101c>
    27cc:	0a3020ef          	jal	506e <mkdir>
    27d0:	e94d                	bnez	a0,2882 <fourteen+0xd8>
  fd = open("123456789012345/123456789012345/123456789012345", O_CREATE);
    27d2:	20000593          	li	a1,512
    27d6:	00004517          	auipc	a0,0x4
    27da:	daa50513          	addi	a0,a0,-598 # 6580 <malloc+0x1074>
    27de:	069020ef          	jal	5046 <open>
  if(fd < 0){
    27e2:	0a054a63          	bltz	a0,2896 <fourteen+0xec>
  close(fd);
    27e6:	049020ef          	jal	502e <close>
  fd = open("12345678901234/12345678901234/12345678901234", 0);
    27ea:	4581                	li	a1,0
    27ec:	00004517          	auipc	a0,0x4
    27f0:	e0c50513          	addi	a0,a0,-500 # 65f8 <malloc+0x10ec>
    27f4:	053020ef          	jal	5046 <open>
  if(fd < 0){
    27f8:	0a054963          	bltz	a0,28aa <fourteen+0x100>
  close(fd);
    27fc:	033020ef          	jal	502e <close>
  if(mkdir("12345678901234/12345678901234") == 0){
    2800:	00004517          	auipc	a0,0x4
    2804:	e6850513          	addi	a0,a0,-408 # 6668 <malloc+0x115c>
    2808:	067020ef          	jal	506e <mkdir>
    280c:	c94d                	beqz	a0,28be <fourteen+0x114>
  if(mkdir("123456789012345/12345678901234") == 0){
    280e:	00004517          	auipc	a0,0x4
    2812:	eb250513          	addi	a0,a0,-334 # 66c0 <malloc+0x11b4>
    2816:	059020ef          	jal	506e <mkdir>
    281a:	cd45                	beqz	a0,28d2 <fourteen+0x128>
  unlink("123456789012345/12345678901234");
    281c:	00004517          	auipc	a0,0x4
    2820:	ea450513          	addi	a0,a0,-348 # 66c0 <malloc+0x11b4>
    2824:	033020ef          	jal	5056 <unlink>
  unlink("12345678901234/12345678901234");
    2828:	00004517          	auipc	a0,0x4
    282c:	e4050513          	addi	a0,a0,-448 # 6668 <malloc+0x115c>
    2830:	027020ef          	jal	5056 <unlink>
  unlink("12345678901234/12345678901234/12345678901234");
    2834:	00004517          	auipc	a0,0x4
    2838:	dc450513          	addi	a0,a0,-572 # 65f8 <malloc+0x10ec>
    283c:	01b020ef          	jal	5056 <unlink>
  unlink("123456789012345/123456789012345/123456789012345");
    2840:	00004517          	auipc	a0,0x4
    2844:	d4050513          	addi	a0,a0,-704 # 6580 <malloc+0x1074>
    2848:	00f020ef          	jal	5056 <unlink>
  unlink("12345678901234/123456789012345");
    284c:	00004517          	auipc	a0,0x4
    2850:	cdc50513          	addi	a0,a0,-804 # 6528 <malloc+0x101c>
    2854:	003020ef          	jal	5056 <unlink>
  unlink("12345678901234");
    2858:	00004517          	auipc	a0,0x4
    285c:	e7850513          	addi	a0,a0,-392 # 66d0 <malloc+0x11c4>
    2860:	7f6020ef          	jal	5056 <unlink>
}
    2864:	60e2                	ld	ra,24(sp)
    2866:	6442                	ld	s0,16(sp)
    2868:	64a2                	ld	s1,8(sp)
    286a:	6105                	addi	sp,sp,32
    286c:	8082                	ret
    printf("%s: mkdir 12345678901234 failed\n", s);
    286e:	85a6                	mv	a1,s1
    2870:	00004517          	auipc	a0,0x4
    2874:	c9050513          	addi	a0,a0,-880 # 6500 <malloc+0xff4>
    2878:	3dd020ef          	jal	5454 <printf>
    exit(1);
    287c:	4505                	li	a0,1
    287e:	788020ef          	jal	5006 <exit>
    printf("%s: mkdir 12345678901234/123456789012345 failed\n", s);
    2882:	85a6                	mv	a1,s1
    2884:	00004517          	auipc	a0,0x4
    2888:	cc450513          	addi	a0,a0,-828 # 6548 <malloc+0x103c>
    288c:	3c9020ef          	jal	5454 <printf>
    exit(1);
    2890:	4505                	li	a0,1
    2892:	774020ef          	jal	5006 <exit>
    printf("%s: create 123456789012345/123456789012345/123456789012345 failed\n", s);
    2896:	85a6                	mv	a1,s1
    2898:	00004517          	auipc	a0,0x4
    289c:	d1850513          	addi	a0,a0,-744 # 65b0 <malloc+0x10a4>
    28a0:	3b5020ef          	jal	5454 <printf>
    exit(1);
    28a4:	4505                	li	a0,1
    28a6:	760020ef          	jal	5006 <exit>
    printf("%s: open 12345678901234/12345678901234/12345678901234 failed\n", s);
    28aa:	85a6                	mv	a1,s1
    28ac:	00004517          	auipc	a0,0x4
    28b0:	d7c50513          	addi	a0,a0,-644 # 6628 <malloc+0x111c>
    28b4:	3a1020ef          	jal	5454 <printf>
    exit(1);
    28b8:	4505                	li	a0,1
    28ba:	74c020ef          	jal	5006 <exit>
    printf("%s: mkdir 12345678901234/12345678901234 succeeded!\n", s);
    28be:	85a6                	mv	a1,s1
    28c0:	00004517          	auipc	a0,0x4
    28c4:	dc850513          	addi	a0,a0,-568 # 6688 <malloc+0x117c>
    28c8:	38d020ef          	jal	5454 <printf>
    exit(1);
    28cc:	4505                	li	a0,1
    28ce:	738020ef          	jal	5006 <exit>
    printf("%s: mkdir 12345678901234/123456789012345 succeeded!\n", s);
    28d2:	85a6                	mv	a1,s1
    28d4:	00004517          	auipc	a0,0x4
    28d8:	e0c50513          	addi	a0,a0,-500 # 66e0 <malloc+0x11d4>
    28dc:	379020ef          	jal	5454 <printf>
    exit(1);
    28e0:	4505                	li	a0,1
    28e2:	724020ef          	jal	5006 <exit>

00000000000028e6 <diskfull>:
{
    28e6:	b6010113          	addi	sp,sp,-1184
    28ea:	48113c23          	sd	ra,1176(sp)
    28ee:	48813823          	sd	s0,1168(sp)
    28f2:	48913423          	sd	s1,1160(sp)
    28f6:	49213023          	sd	s2,1152(sp)
    28fa:	47313c23          	sd	s3,1144(sp)
    28fe:	47413823          	sd	s4,1136(sp)
    2902:	47513423          	sd	s5,1128(sp)
    2906:	47613023          	sd	s6,1120(sp)
    290a:	45713c23          	sd	s7,1112(sp)
    290e:	45813823          	sd	s8,1104(sp)
    2912:	45913423          	sd	s9,1096(sp)
    2916:	45a13023          	sd	s10,1088(sp)
    291a:	43b13c23          	sd	s11,1080(sp)
    291e:	4a010413          	addi	s0,sp,1184
    2922:	b6a43423          	sd	a0,-1176(s0)
  unlink("diskfulldir");
    2926:	00004517          	auipc	a0,0x4
    292a:	df250513          	addi	a0,a0,-526 # 6718 <malloc+0x120c>
    292e:	728020ef          	jal	5056 <unlink>
    2932:	03000a93          	li	s5,48
    name[0] = 'b';
    2936:	06200d13          	li	s10,98
    name[1] = 'i';
    293a:	06900c93          	li	s9,105
    name[2] = 'g';
    293e:	06700c13          	li	s8,103
    unlink(name);
    2942:	b7040b13          	addi	s6,s0,-1168
    int fd = open(name, O_CREATE|O_RDWR|O_TRUNC);
    2946:	60200b93          	li	s7,1538
    294a:	10c00d93          	li	s11,268
      if(write(fd, buf, BSIZE) != BSIZE){
    294e:	b9040a13          	addi	s4,s0,-1136
    2952:	aa8d                	j	2ac4 <diskfull+0x1de>
      printf("%s: could not create file %s\n", s, name);
    2954:	b7040613          	addi	a2,s0,-1168
    2958:	b6843583          	ld	a1,-1176(s0)
    295c:	00004517          	auipc	a0,0x4
    2960:	dcc50513          	addi	a0,a0,-564 # 6728 <malloc+0x121c>
    2964:	2f1020ef          	jal	5454 <printf>
      break;
    2968:	a039                	j	2976 <diskfull+0x90>
        close(fd);
    296a:	854e                	mv	a0,s3
    296c:	6c2020ef          	jal	502e <close>
    close(fd);
    2970:	854e                	mv	a0,s3
    2972:	6bc020ef          	jal	502e <close>
  for(int i = 0; i < nzz; i++){
    2976:	4481                	li	s1,0
    name[0] = 'z';
    2978:	07a00993          	li	s3,122
    unlink(name);
    297c:	b9040913          	addi	s2,s0,-1136
    int fd = open(name, O_CREATE|O_RDWR|O_TRUNC);
    2980:	60200a13          	li	s4,1538
  for(int i = 0; i < nzz; i++){
    2984:	08000a93          	li	s5,128
    name[0] = 'z';
    2988:	b9340823          	sb	s3,-1136(s0)
    name[1] = 'z';
    298c:	b93408a3          	sb	s3,-1135(s0)
    name[2] = '0' + (i / 32);
    2990:	41f4d71b          	sraiw	a4,s1,0x1f
    2994:	01b7571b          	srliw	a4,a4,0x1b
    2998:	009707bb          	addw	a5,a4,s1
    299c:	4057d69b          	sraiw	a3,a5,0x5
    29a0:	0306869b          	addiw	a3,a3,48
    29a4:	b8d40923          	sb	a3,-1134(s0)
    name[3] = '0' + (i % 32);
    29a8:	8bfd                	andi	a5,a5,31
    29aa:	9f99                	subw	a5,a5,a4
    29ac:	0307879b          	addiw	a5,a5,48
    29b0:	b8f409a3          	sb	a5,-1133(s0)
    name[4] = '\0';
    29b4:	b8040a23          	sb	zero,-1132(s0)
    unlink(name);
    29b8:	854a                	mv	a0,s2
    29ba:	69c020ef          	jal	5056 <unlink>
    int fd = open(name, O_CREATE|O_RDWR|O_TRUNC);
    29be:	85d2                	mv	a1,s4
    29c0:	854a                	mv	a0,s2
    29c2:	684020ef          	jal	5046 <open>
    if(fd < 0)
    29c6:	00054763          	bltz	a0,29d4 <diskfull+0xee>
    close(fd);
    29ca:	664020ef          	jal	502e <close>
  for(int i = 0; i < nzz; i++){
    29ce:	2485                	addiw	s1,s1,1
    29d0:	fb549ce3          	bne	s1,s5,2988 <diskfull+0xa2>
  if(mkdir("diskfulldir") == 0)
    29d4:	00004517          	auipc	a0,0x4
    29d8:	d4450513          	addi	a0,a0,-700 # 6718 <malloc+0x120c>
    29dc:	692020ef          	jal	506e <mkdir>
    29e0:	12050363          	beqz	a0,2b06 <diskfull+0x220>
  unlink("diskfulldir");
    29e4:	00004517          	auipc	a0,0x4
    29e8:	d3450513          	addi	a0,a0,-716 # 6718 <malloc+0x120c>
    29ec:	66a020ef          	jal	5056 <unlink>
  for(int i = 0; i < nzz; i++){
    29f0:	4481                	li	s1,0
    name[0] = 'z';
    29f2:	07a00913          	li	s2,122
    unlink(name);
    29f6:	b9040a13          	addi	s4,s0,-1136
  for(int i = 0; i < nzz; i++){
    29fa:	08000993          	li	s3,128
    name[0] = 'z';
    29fe:	b9240823          	sb	s2,-1136(s0)
    name[1] = 'z';
    2a02:	b92408a3          	sb	s2,-1135(s0)
    name[2] = '0' + (i / 32);
    2a06:	41f4d71b          	sraiw	a4,s1,0x1f
    2a0a:	01b7571b          	srliw	a4,a4,0x1b
    2a0e:	009707bb          	addw	a5,a4,s1
    2a12:	4057d69b          	sraiw	a3,a5,0x5
    2a16:	0306869b          	addiw	a3,a3,48
    2a1a:	b8d40923          	sb	a3,-1134(s0)
    name[3] = '0' + (i % 32);
    2a1e:	8bfd                	andi	a5,a5,31
    2a20:	9f99                	subw	a5,a5,a4
    2a22:	0307879b          	addiw	a5,a5,48
    2a26:	b8f409a3          	sb	a5,-1133(s0)
    name[4] = '\0';
    2a2a:	b8040a23          	sb	zero,-1132(s0)
    unlink(name);
    2a2e:	8552                	mv	a0,s4
    2a30:	626020ef          	jal	5056 <unlink>
  for(int i = 0; i < nzz; i++){
    2a34:	2485                	addiw	s1,s1,1
    2a36:	fd3494e3          	bne	s1,s3,29fe <diskfull+0x118>
    2a3a:	03000493          	li	s1,48
    name[0] = 'b';
    2a3e:	06200b13          	li	s6,98
    name[1] = 'i';
    2a42:	06900a93          	li	s5,105
    name[2] = 'g';
    2a46:	06700a13          	li	s4,103
    unlink(name);
    2a4a:	b9040993          	addi	s3,s0,-1136
  for(int i = 0; '0' + i < 0177; i++){
    2a4e:	07f00913          	li	s2,127
    name[0] = 'b';
    2a52:	b9640823          	sb	s6,-1136(s0)
    name[1] = 'i';
    2a56:	b95408a3          	sb	s5,-1135(s0)
    name[2] = 'g';
    2a5a:	b9440923          	sb	s4,-1134(s0)
    name[3] = '0' + i;
    2a5e:	b89409a3          	sb	s1,-1133(s0)
    name[4] = '\0';
    2a62:	b8040a23          	sb	zero,-1132(s0)
    unlink(name);
    2a66:	854e                	mv	a0,s3
    2a68:	5ee020ef          	jal	5056 <unlink>
  for(int i = 0; '0' + i < 0177; i++){
    2a6c:	2485                	addiw	s1,s1,1
    2a6e:	0ff4f493          	zext.b	s1,s1
    2a72:	ff2490e3          	bne	s1,s2,2a52 <diskfull+0x16c>
}
    2a76:	49813083          	ld	ra,1176(sp)
    2a7a:	49013403          	ld	s0,1168(sp)
    2a7e:	48813483          	ld	s1,1160(sp)
    2a82:	48013903          	ld	s2,1152(sp)
    2a86:	47813983          	ld	s3,1144(sp)
    2a8a:	47013a03          	ld	s4,1136(sp)
    2a8e:	46813a83          	ld	s5,1128(sp)
    2a92:	46013b03          	ld	s6,1120(sp)
    2a96:	45813b83          	ld	s7,1112(sp)
    2a9a:	45013c03          	ld	s8,1104(sp)
    2a9e:	44813c83          	ld	s9,1096(sp)
    2aa2:	44013d03          	ld	s10,1088(sp)
    2aa6:	43813d83          	ld	s11,1080(sp)
    2aaa:	4a010113          	addi	sp,sp,1184
    2aae:	8082                	ret
    close(fd);
    2ab0:	854e                	mv	a0,s3
    2ab2:	57c020ef          	jal	502e <close>
  for(fi = 0; done == 0 && '0' + fi < 0177; fi++){
    2ab6:	2a85                	addiw	s5,s5,1 # 3001 <subdir+0x2f1>
    2ab8:	0ffafa93          	zext.b	s5,s5
    2abc:	07f00793          	li	a5,127
    2ac0:	eafa8be3          	beq	s5,a5,2976 <diskfull+0x90>
    name[0] = 'b';
    2ac4:	b7a40823          	sb	s10,-1168(s0)
    name[1] = 'i';
    2ac8:	b79408a3          	sb	s9,-1167(s0)
    name[2] = 'g';
    2acc:	b7840923          	sb	s8,-1166(s0)
    name[3] = '0' + fi;
    2ad0:	b75409a3          	sb	s5,-1165(s0)
    name[4] = '\0';
    2ad4:	b6040a23          	sb	zero,-1164(s0)
    unlink(name);
    2ad8:	855a                	mv	a0,s6
    2ada:	57c020ef          	jal	5056 <unlink>
    int fd = open(name, O_CREATE|O_RDWR|O_TRUNC);
    2ade:	85de                	mv	a1,s7
    2ae0:	855a                	mv	a0,s6
    2ae2:	564020ef          	jal	5046 <open>
    2ae6:	89aa                	mv	s3,a0
    if(fd < 0){
    2ae8:	e60546e3          	bltz	a0,2954 <diskfull+0x6e>
    2aec:	84ee                	mv	s1,s11
      if(write(fd, buf, BSIZE) != BSIZE){
    2aee:	40000913          	li	s2,1024
    2af2:	864a                	mv	a2,s2
    2af4:	85d2                	mv	a1,s4
    2af6:	854e                	mv	a0,s3
    2af8:	52e020ef          	jal	5026 <write>
    2afc:	e72517e3          	bne	a0,s2,296a <diskfull+0x84>
    for(int i = 0; i < MAXFILE; i++){
    2b00:	34fd                	addiw	s1,s1,-1
    2b02:	f8e5                	bnez	s1,2af2 <diskfull+0x20c>
    2b04:	b775                	j	2ab0 <diskfull+0x1ca>
    printf("%s: mkdir(diskfulldir) unexpectedly succeeded!\n", s);
    2b06:	b6843583          	ld	a1,-1176(s0)
    2b0a:	00004517          	auipc	a0,0x4
    2b0e:	c3e50513          	addi	a0,a0,-962 # 6748 <malloc+0x123c>
    2b12:	143020ef          	jal	5454 <printf>
    2b16:	b5f9                	j	29e4 <diskfull+0xfe>

0000000000002b18 <iputtest>:
{
    2b18:	1101                	addi	sp,sp,-32
    2b1a:	ec06                	sd	ra,24(sp)
    2b1c:	e822                	sd	s0,16(sp)
    2b1e:	e426                	sd	s1,8(sp)
    2b20:	1000                	addi	s0,sp,32
    2b22:	84aa                	mv	s1,a0
  if(mkdir("iputdir") < 0){
    2b24:	00004517          	auipc	a0,0x4
    2b28:	c5450513          	addi	a0,a0,-940 # 6778 <malloc+0x126c>
    2b2c:	542020ef          	jal	506e <mkdir>
    2b30:	02054f63          	bltz	a0,2b6e <iputtest+0x56>
  if(chdir("iputdir") < 0){
    2b34:	00004517          	auipc	a0,0x4
    2b38:	c4450513          	addi	a0,a0,-956 # 6778 <malloc+0x126c>
    2b3c:	53a020ef          	jal	5076 <chdir>
    2b40:	04054163          	bltz	a0,2b82 <iputtest+0x6a>
  if(unlink("../iputdir") < 0){
    2b44:	00004517          	auipc	a0,0x4
    2b48:	c7450513          	addi	a0,a0,-908 # 67b8 <malloc+0x12ac>
    2b4c:	50a020ef          	jal	5056 <unlink>
    2b50:	04054363          	bltz	a0,2b96 <iputtest+0x7e>
  if(chdir("/") < 0){
    2b54:	00004517          	auipc	a0,0x4
    2b58:	c9450513          	addi	a0,a0,-876 # 67e8 <malloc+0x12dc>
    2b5c:	51a020ef          	jal	5076 <chdir>
    2b60:	04054563          	bltz	a0,2baa <iputtest+0x92>
}
    2b64:	60e2                	ld	ra,24(sp)
    2b66:	6442                	ld	s0,16(sp)
    2b68:	64a2                	ld	s1,8(sp)
    2b6a:	6105                	addi	sp,sp,32
    2b6c:	8082                	ret
    printf("%s: mkdir failed\n", s);
    2b6e:	85a6                	mv	a1,s1
    2b70:	00004517          	auipc	a0,0x4
    2b74:	c1050513          	addi	a0,a0,-1008 # 6780 <malloc+0x1274>
    2b78:	0dd020ef          	jal	5454 <printf>
    exit(1);
    2b7c:	4505                	li	a0,1
    2b7e:	488020ef          	jal	5006 <exit>
    printf("%s: chdir iputdir failed\n", s);
    2b82:	85a6                	mv	a1,s1
    2b84:	00004517          	auipc	a0,0x4
    2b88:	c1450513          	addi	a0,a0,-1004 # 6798 <malloc+0x128c>
    2b8c:	0c9020ef          	jal	5454 <printf>
    exit(1);
    2b90:	4505                	li	a0,1
    2b92:	474020ef          	jal	5006 <exit>
    printf("%s: unlink ../iputdir failed\n", s);
    2b96:	85a6                	mv	a1,s1
    2b98:	00004517          	auipc	a0,0x4
    2b9c:	c3050513          	addi	a0,a0,-976 # 67c8 <malloc+0x12bc>
    2ba0:	0b5020ef          	jal	5454 <printf>
    exit(1);
    2ba4:	4505                	li	a0,1
    2ba6:	460020ef          	jal	5006 <exit>
    printf("%s: chdir / failed\n", s);
    2baa:	85a6                	mv	a1,s1
    2bac:	00004517          	auipc	a0,0x4
    2bb0:	c4450513          	addi	a0,a0,-956 # 67f0 <malloc+0x12e4>
    2bb4:	0a1020ef          	jal	5454 <printf>
    exit(1);
    2bb8:	4505                	li	a0,1
    2bba:	44c020ef          	jal	5006 <exit>

0000000000002bbe <exitiputtest>:
{
    2bbe:	7179                	addi	sp,sp,-48
    2bc0:	f406                	sd	ra,40(sp)
    2bc2:	f022                	sd	s0,32(sp)
    2bc4:	ec26                	sd	s1,24(sp)
    2bc6:	1800                	addi	s0,sp,48
    2bc8:	84aa                	mv	s1,a0
  pid = fork();
    2bca:	434020ef          	jal	4ffe <fork>
  if(pid < 0){
    2bce:	02054e63          	bltz	a0,2c0a <exitiputtest+0x4c>
  if(pid == 0){
    2bd2:	e541                	bnez	a0,2c5a <exitiputtest+0x9c>
    if(mkdir("iputdir") < 0){
    2bd4:	00004517          	auipc	a0,0x4
    2bd8:	ba450513          	addi	a0,a0,-1116 # 6778 <malloc+0x126c>
    2bdc:	492020ef          	jal	506e <mkdir>
    2be0:	02054f63          	bltz	a0,2c1e <exitiputtest+0x60>
    if(chdir("iputdir") < 0){
    2be4:	00004517          	auipc	a0,0x4
    2be8:	b9450513          	addi	a0,a0,-1132 # 6778 <malloc+0x126c>
    2bec:	48a020ef          	jal	5076 <chdir>
    2bf0:	04054163          	bltz	a0,2c32 <exitiputtest+0x74>
    if(unlink("../iputdir") < 0){
    2bf4:	00004517          	auipc	a0,0x4
    2bf8:	bc450513          	addi	a0,a0,-1084 # 67b8 <malloc+0x12ac>
    2bfc:	45a020ef          	jal	5056 <unlink>
    2c00:	04054363          	bltz	a0,2c46 <exitiputtest+0x88>
    exit(0);
    2c04:	4501                	li	a0,0
    2c06:	400020ef          	jal	5006 <exit>
    printf("%s: fork failed\n", s);
    2c0a:	85a6                	mv	a1,s1
    2c0c:	00003517          	auipc	a0,0x3
    2c10:	2bc50513          	addi	a0,a0,700 # 5ec8 <malloc+0x9bc>
    2c14:	041020ef          	jal	5454 <printf>
    exit(1);
    2c18:	4505                	li	a0,1
    2c1a:	3ec020ef          	jal	5006 <exit>
      printf("%s: mkdir failed\n", s);
    2c1e:	85a6                	mv	a1,s1
    2c20:	00004517          	auipc	a0,0x4
    2c24:	b6050513          	addi	a0,a0,-1184 # 6780 <malloc+0x1274>
    2c28:	02d020ef          	jal	5454 <printf>
      exit(1);
    2c2c:	4505                	li	a0,1
    2c2e:	3d8020ef          	jal	5006 <exit>
      printf("%s: child chdir failed\n", s);
    2c32:	85a6                	mv	a1,s1
    2c34:	00004517          	auipc	a0,0x4
    2c38:	bd450513          	addi	a0,a0,-1068 # 6808 <malloc+0x12fc>
    2c3c:	019020ef          	jal	5454 <printf>
      exit(1);
    2c40:	4505                	li	a0,1
    2c42:	3c4020ef          	jal	5006 <exit>
      printf("%s: unlink ../iputdir failed\n", s);
    2c46:	85a6                	mv	a1,s1
    2c48:	00004517          	auipc	a0,0x4
    2c4c:	b8050513          	addi	a0,a0,-1152 # 67c8 <malloc+0x12bc>
    2c50:	005020ef          	jal	5454 <printf>
      exit(1);
    2c54:	4505                	li	a0,1
    2c56:	3b0020ef          	jal	5006 <exit>
  wait(&xstatus);
    2c5a:	fdc40513          	addi	a0,s0,-36
    2c5e:	3b0020ef          	jal	500e <wait>
  exit(xstatus);
    2c62:	fdc42503          	lw	a0,-36(s0)
    2c66:	3a0020ef          	jal	5006 <exit>

0000000000002c6a <dirtest>:
{
    2c6a:	1101                	addi	sp,sp,-32
    2c6c:	ec06                	sd	ra,24(sp)
    2c6e:	e822                	sd	s0,16(sp)
    2c70:	e426                	sd	s1,8(sp)
    2c72:	1000                	addi	s0,sp,32
    2c74:	84aa                	mv	s1,a0
  if(mkdir("dir0") < 0){
    2c76:	00004517          	auipc	a0,0x4
    2c7a:	baa50513          	addi	a0,a0,-1110 # 6820 <malloc+0x1314>
    2c7e:	3f0020ef          	jal	506e <mkdir>
    2c82:	02054f63          	bltz	a0,2cc0 <dirtest+0x56>
  if(chdir("dir0") < 0){
    2c86:	00004517          	auipc	a0,0x4
    2c8a:	b9a50513          	addi	a0,a0,-1126 # 6820 <malloc+0x1314>
    2c8e:	3e8020ef          	jal	5076 <chdir>
    2c92:	04054163          	bltz	a0,2cd4 <dirtest+0x6a>
  if(chdir("..") < 0){
    2c96:	00004517          	auipc	a0,0x4
    2c9a:	baa50513          	addi	a0,a0,-1110 # 6840 <malloc+0x1334>
    2c9e:	3d8020ef          	jal	5076 <chdir>
    2ca2:	04054363          	bltz	a0,2ce8 <dirtest+0x7e>
  if(unlink("dir0") < 0){
    2ca6:	00004517          	auipc	a0,0x4
    2caa:	b7a50513          	addi	a0,a0,-1158 # 6820 <malloc+0x1314>
    2cae:	3a8020ef          	jal	5056 <unlink>
    2cb2:	04054563          	bltz	a0,2cfc <dirtest+0x92>
}
    2cb6:	60e2                	ld	ra,24(sp)
    2cb8:	6442                	ld	s0,16(sp)
    2cba:	64a2                	ld	s1,8(sp)
    2cbc:	6105                	addi	sp,sp,32
    2cbe:	8082                	ret
    printf("%s: mkdir failed\n", s);
    2cc0:	85a6                	mv	a1,s1
    2cc2:	00004517          	auipc	a0,0x4
    2cc6:	abe50513          	addi	a0,a0,-1346 # 6780 <malloc+0x1274>
    2cca:	78a020ef          	jal	5454 <printf>
    exit(1);
    2cce:	4505                	li	a0,1
    2cd0:	336020ef          	jal	5006 <exit>
    printf("%s: chdir dir0 failed\n", s);
    2cd4:	85a6                	mv	a1,s1
    2cd6:	00004517          	auipc	a0,0x4
    2cda:	b5250513          	addi	a0,a0,-1198 # 6828 <malloc+0x131c>
    2cde:	776020ef          	jal	5454 <printf>
    exit(1);
    2ce2:	4505                	li	a0,1
    2ce4:	322020ef          	jal	5006 <exit>
    printf("%s: chdir .. failed\n", s);
    2ce8:	85a6                	mv	a1,s1
    2cea:	00004517          	auipc	a0,0x4
    2cee:	b5e50513          	addi	a0,a0,-1186 # 6848 <malloc+0x133c>
    2cf2:	762020ef          	jal	5454 <printf>
    exit(1);
    2cf6:	4505                	li	a0,1
    2cf8:	30e020ef          	jal	5006 <exit>
    printf("%s: unlink dir0 failed\n", s);
    2cfc:	85a6                	mv	a1,s1
    2cfe:	00004517          	auipc	a0,0x4
    2d02:	b6250513          	addi	a0,a0,-1182 # 6860 <malloc+0x1354>
    2d06:	74e020ef          	jal	5454 <printf>
    exit(1);
    2d0a:	4505                	li	a0,1
    2d0c:	2fa020ef          	jal	5006 <exit>

0000000000002d10 <subdir>:
{
    2d10:	1101                	addi	sp,sp,-32
    2d12:	ec06                	sd	ra,24(sp)
    2d14:	e822                	sd	s0,16(sp)
    2d16:	e426                	sd	s1,8(sp)
    2d18:	e04a                	sd	s2,0(sp)
    2d1a:	1000                	addi	s0,sp,32
    2d1c:	892a                	mv	s2,a0
  unlink("ff");
    2d1e:	00004517          	auipc	a0,0x4
    2d22:	c8a50513          	addi	a0,a0,-886 # 69a8 <malloc+0x149c>
    2d26:	330020ef          	jal	5056 <unlink>
  if(mkdir("dd") != 0){
    2d2a:	00004517          	auipc	a0,0x4
    2d2e:	b4e50513          	addi	a0,a0,-1202 # 6878 <malloc+0x136c>
    2d32:	33c020ef          	jal	506e <mkdir>
    2d36:	2e051263          	bnez	a0,301a <subdir+0x30a>
  fd = open("dd/ff", O_CREATE | O_RDWR);
    2d3a:	20200593          	li	a1,514
    2d3e:	00004517          	auipc	a0,0x4
    2d42:	b5a50513          	addi	a0,a0,-1190 # 6898 <malloc+0x138c>
    2d46:	300020ef          	jal	5046 <open>
    2d4a:	84aa                	mv	s1,a0
  if(fd < 0){
    2d4c:	2e054163          	bltz	a0,302e <subdir+0x31e>
  write(fd, "ff", 2);
    2d50:	4609                	li	a2,2
    2d52:	00004597          	auipc	a1,0x4
    2d56:	c5658593          	addi	a1,a1,-938 # 69a8 <malloc+0x149c>
    2d5a:	2cc020ef          	jal	5026 <write>
  close(fd);
    2d5e:	8526                	mv	a0,s1
    2d60:	2ce020ef          	jal	502e <close>
  if(unlink("dd") >= 0){
    2d64:	00004517          	auipc	a0,0x4
    2d68:	b1450513          	addi	a0,a0,-1260 # 6878 <malloc+0x136c>
    2d6c:	2ea020ef          	jal	5056 <unlink>
    2d70:	2c055963          	bgez	a0,3042 <subdir+0x332>
  if(mkdir("/dd/dd") != 0){
    2d74:	00004517          	auipc	a0,0x4
    2d78:	b7c50513          	addi	a0,a0,-1156 # 68f0 <malloc+0x13e4>
    2d7c:	2f2020ef          	jal	506e <mkdir>
    2d80:	2c051b63          	bnez	a0,3056 <subdir+0x346>
  fd = open("dd/dd/ff", O_CREATE | O_RDWR);
    2d84:	20200593          	li	a1,514
    2d88:	00004517          	auipc	a0,0x4
    2d8c:	b9050513          	addi	a0,a0,-1136 # 6918 <malloc+0x140c>
    2d90:	2b6020ef          	jal	5046 <open>
    2d94:	84aa                	mv	s1,a0
  if(fd < 0){
    2d96:	2c054a63          	bltz	a0,306a <subdir+0x35a>
  write(fd, "FF", 2);
    2d9a:	4609                	li	a2,2
    2d9c:	00004597          	auipc	a1,0x4
    2da0:	bac58593          	addi	a1,a1,-1108 # 6948 <malloc+0x143c>
    2da4:	282020ef          	jal	5026 <write>
  close(fd);
    2da8:	8526                	mv	a0,s1
    2daa:	284020ef          	jal	502e <close>
  fd = open("dd/dd/../ff", 0);
    2dae:	4581                	li	a1,0
    2db0:	00004517          	auipc	a0,0x4
    2db4:	ba050513          	addi	a0,a0,-1120 # 6950 <malloc+0x1444>
    2db8:	28e020ef          	jal	5046 <open>
    2dbc:	84aa                	mv	s1,a0
  if(fd < 0){
    2dbe:	2c054063          	bltz	a0,307e <subdir+0x36e>
  cc = read(fd, buf, sizeof(buf));
    2dc2:	660d                	lui	a2,0x3
    2dc4:	0000b597          	auipc	a1,0xb
    2dc8:	ef458593          	addi	a1,a1,-268 # dcb8 <buf>
    2dcc:	252020ef          	jal	501e <read>
  if(cc != 2 || buf[0] != 'f'){
    2dd0:	4789                	li	a5,2
    2dd2:	2cf51063          	bne	a0,a5,3092 <subdir+0x382>
    2dd6:	0000b717          	auipc	a4,0xb
    2dda:	ee274703          	lbu	a4,-286(a4) # dcb8 <buf>
    2dde:	06600793          	li	a5,102
    2de2:	2af71863          	bne	a4,a5,3092 <subdir+0x382>
  close(fd);
    2de6:	8526                	mv	a0,s1
    2de8:	246020ef          	jal	502e <close>
  if(link("dd/dd/ff", "dd/dd/ffff") != 0){
    2dec:	00004597          	auipc	a1,0x4
    2df0:	bb458593          	addi	a1,a1,-1100 # 69a0 <malloc+0x1494>
    2df4:	00004517          	auipc	a0,0x4
    2df8:	b2450513          	addi	a0,a0,-1244 # 6918 <malloc+0x140c>
    2dfc:	26a020ef          	jal	5066 <link>
    2e00:	2a051363          	bnez	a0,30a6 <subdir+0x396>
  if(unlink("dd/dd/ff") != 0){
    2e04:	00004517          	auipc	a0,0x4
    2e08:	b1450513          	addi	a0,a0,-1260 # 6918 <malloc+0x140c>
    2e0c:	24a020ef          	jal	5056 <unlink>
    2e10:	2a051563          	bnez	a0,30ba <subdir+0x3aa>
  if(open("dd/dd/ff", O_RDONLY) >= 0){
    2e14:	4581                	li	a1,0
    2e16:	00004517          	auipc	a0,0x4
    2e1a:	b0250513          	addi	a0,a0,-1278 # 6918 <malloc+0x140c>
    2e1e:	228020ef          	jal	5046 <open>
    2e22:	2a055663          	bgez	a0,30ce <subdir+0x3be>
  if(chdir("dd") != 0){
    2e26:	00004517          	auipc	a0,0x4
    2e2a:	a5250513          	addi	a0,a0,-1454 # 6878 <malloc+0x136c>
    2e2e:	248020ef          	jal	5076 <chdir>
    2e32:	2a051863          	bnez	a0,30e2 <subdir+0x3d2>
  if(chdir("dd/../../dd") != 0){
    2e36:	00004517          	auipc	a0,0x4
    2e3a:	c0250513          	addi	a0,a0,-1022 # 6a38 <malloc+0x152c>
    2e3e:	238020ef          	jal	5076 <chdir>
    2e42:	2a051a63          	bnez	a0,30f6 <subdir+0x3e6>
  if(chdir("dd/../../../dd") != 0){
    2e46:	00004517          	auipc	a0,0x4
    2e4a:	c2250513          	addi	a0,a0,-990 # 6a68 <malloc+0x155c>
    2e4e:	228020ef          	jal	5076 <chdir>
    2e52:	2a051c63          	bnez	a0,310a <subdir+0x3fa>
  if(chdir("./..") != 0){
    2e56:	00004517          	auipc	a0,0x4
    2e5a:	c4a50513          	addi	a0,a0,-950 # 6aa0 <malloc+0x1594>
    2e5e:	218020ef          	jal	5076 <chdir>
    2e62:	2a051e63          	bnez	a0,311e <subdir+0x40e>
  fd = open("dd/dd/ffff", 0);
    2e66:	4581                	li	a1,0
    2e68:	00004517          	auipc	a0,0x4
    2e6c:	b3850513          	addi	a0,a0,-1224 # 69a0 <malloc+0x1494>
    2e70:	1d6020ef          	jal	5046 <open>
    2e74:	84aa                	mv	s1,a0
  if(fd < 0){
    2e76:	2a054e63          	bltz	a0,3132 <subdir+0x422>
  if(read(fd, buf, sizeof(buf)) != 2){
    2e7a:	660d                	lui	a2,0x3
    2e7c:	0000b597          	auipc	a1,0xb
    2e80:	e3c58593          	addi	a1,a1,-452 # dcb8 <buf>
    2e84:	19a020ef          	jal	501e <read>
    2e88:	4789                	li	a5,2
    2e8a:	2af51e63          	bne	a0,a5,3146 <subdir+0x436>
  close(fd);
    2e8e:	8526                	mv	a0,s1
    2e90:	19e020ef          	jal	502e <close>
  if(open("dd/dd/ff", O_RDONLY) >= 0){
    2e94:	4581                	li	a1,0
    2e96:	00004517          	auipc	a0,0x4
    2e9a:	a8250513          	addi	a0,a0,-1406 # 6918 <malloc+0x140c>
    2e9e:	1a8020ef          	jal	5046 <open>
    2ea2:	2a055c63          	bgez	a0,315a <subdir+0x44a>
  if(open("dd/ff/ff", O_CREATE|O_RDWR) >= 0){
    2ea6:	20200593          	li	a1,514
    2eaa:	00004517          	auipc	a0,0x4
    2eae:	c8650513          	addi	a0,a0,-890 # 6b30 <malloc+0x1624>
    2eb2:	194020ef          	jal	5046 <open>
    2eb6:	2a055c63          	bgez	a0,316e <subdir+0x45e>
  if(open("dd/xx/ff", O_CREATE|O_RDWR) >= 0){
    2eba:	20200593          	li	a1,514
    2ebe:	00004517          	auipc	a0,0x4
    2ec2:	ca250513          	addi	a0,a0,-862 # 6b60 <malloc+0x1654>
    2ec6:	180020ef          	jal	5046 <open>
    2eca:	2a055c63          	bgez	a0,3182 <subdir+0x472>
  if(open("dd", O_CREATE) >= 0){
    2ece:	20000593          	li	a1,512
    2ed2:	00004517          	auipc	a0,0x4
    2ed6:	9a650513          	addi	a0,a0,-1626 # 6878 <malloc+0x136c>
    2eda:	16c020ef          	jal	5046 <open>
    2ede:	2a055c63          	bgez	a0,3196 <subdir+0x486>
  if(open("dd", O_RDWR) >= 0){
    2ee2:	4589                	li	a1,2
    2ee4:	00004517          	auipc	a0,0x4
    2ee8:	99450513          	addi	a0,a0,-1644 # 6878 <malloc+0x136c>
    2eec:	15a020ef          	jal	5046 <open>
    2ef0:	2a055d63          	bgez	a0,31aa <subdir+0x49a>
  if(open("dd", O_WRONLY) >= 0){
    2ef4:	4585                	li	a1,1
    2ef6:	00004517          	auipc	a0,0x4
    2efa:	98250513          	addi	a0,a0,-1662 # 6878 <malloc+0x136c>
    2efe:	148020ef          	jal	5046 <open>
    2f02:	2a055e63          	bgez	a0,31be <subdir+0x4ae>
  if(link("dd/ff/ff", "dd/dd/xx") == 0){
    2f06:	00004597          	auipc	a1,0x4
    2f0a:	cea58593          	addi	a1,a1,-790 # 6bf0 <malloc+0x16e4>
    2f0e:	00004517          	auipc	a0,0x4
    2f12:	c2250513          	addi	a0,a0,-990 # 6b30 <malloc+0x1624>
    2f16:	150020ef          	jal	5066 <link>
    2f1a:	2a050c63          	beqz	a0,31d2 <subdir+0x4c2>
  if(link("dd/xx/ff", "dd/dd/xx") == 0){
    2f1e:	00004597          	auipc	a1,0x4
    2f22:	cd258593          	addi	a1,a1,-814 # 6bf0 <malloc+0x16e4>
    2f26:	00004517          	auipc	a0,0x4
    2f2a:	c3a50513          	addi	a0,a0,-966 # 6b60 <malloc+0x1654>
    2f2e:	138020ef          	jal	5066 <link>
    2f32:	2a050a63          	beqz	a0,31e6 <subdir+0x4d6>
  if(link("dd/ff", "dd/dd/ffff") == 0){
    2f36:	00004597          	auipc	a1,0x4
    2f3a:	a6a58593          	addi	a1,a1,-1430 # 69a0 <malloc+0x1494>
    2f3e:	00004517          	auipc	a0,0x4
    2f42:	95a50513          	addi	a0,a0,-1702 # 6898 <malloc+0x138c>
    2f46:	120020ef          	jal	5066 <link>
    2f4a:	2a050863          	beqz	a0,31fa <subdir+0x4ea>
  if(mkdir("dd/ff/ff") == 0){
    2f4e:	00004517          	auipc	a0,0x4
    2f52:	be250513          	addi	a0,a0,-1054 # 6b30 <malloc+0x1624>
    2f56:	118020ef          	jal	506e <mkdir>
    2f5a:	2a050a63          	beqz	a0,320e <subdir+0x4fe>
  if(mkdir("dd/xx/ff") == 0){
    2f5e:	00004517          	auipc	a0,0x4
    2f62:	c0250513          	addi	a0,a0,-1022 # 6b60 <malloc+0x1654>
    2f66:	108020ef          	jal	506e <mkdir>
    2f6a:	2a050c63          	beqz	a0,3222 <subdir+0x512>
  if(mkdir("dd/dd/ffff") == 0){
    2f6e:	00004517          	auipc	a0,0x4
    2f72:	a3250513          	addi	a0,a0,-1486 # 69a0 <malloc+0x1494>
    2f76:	0f8020ef          	jal	506e <mkdir>
    2f7a:	2a050e63          	beqz	a0,3236 <subdir+0x526>
  if(unlink("dd/xx/ff") == 0){
    2f7e:	00004517          	auipc	a0,0x4
    2f82:	be250513          	addi	a0,a0,-1054 # 6b60 <malloc+0x1654>
    2f86:	0d0020ef          	jal	5056 <unlink>
    2f8a:	2c050063          	beqz	a0,324a <subdir+0x53a>
  if(unlink("dd/ff/ff") == 0){
    2f8e:	00004517          	auipc	a0,0x4
    2f92:	ba250513          	addi	a0,a0,-1118 # 6b30 <malloc+0x1624>
    2f96:	0c0020ef          	jal	5056 <unlink>
    2f9a:	2c050263          	beqz	a0,325e <subdir+0x54e>
  if(chdir("dd/ff") == 0){
    2f9e:	00004517          	auipc	a0,0x4
    2fa2:	8fa50513          	addi	a0,a0,-1798 # 6898 <malloc+0x138c>
    2fa6:	0d0020ef          	jal	5076 <chdir>
    2faa:	2c050463          	beqz	a0,3272 <subdir+0x562>
  if(chdir("dd/xx") == 0){
    2fae:	00004517          	auipc	a0,0x4
    2fb2:	d9250513          	addi	a0,a0,-622 # 6d40 <malloc+0x1834>
    2fb6:	0c0020ef          	jal	5076 <chdir>
    2fba:	2c050663          	beqz	a0,3286 <subdir+0x576>
  if(unlink("dd/dd/ffff") != 0){
    2fbe:	00004517          	auipc	a0,0x4
    2fc2:	9e250513          	addi	a0,a0,-1566 # 69a0 <malloc+0x1494>
    2fc6:	090020ef          	jal	5056 <unlink>
    2fca:	2c051863          	bnez	a0,329a <subdir+0x58a>
  if(unlink("dd/ff") != 0){
    2fce:	00004517          	auipc	a0,0x4
    2fd2:	8ca50513          	addi	a0,a0,-1846 # 6898 <malloc+0x138c>
    2fd6:	080020ef          	jal	5056 <unlink>
    2fda:	2c051a63          	bnez	a0,32ae <subdir+0x59e>
  if(unlink("dd") == 0){
    2fde:	00004517          	auipc	a0,0x4
    2fe2:	89a50513          	addi	a0,a0,-1894 # 6878 <malloc+0x136c>
    2fe6:	070020ef          	jal	5056 <unlink>
    2fea:	2c050c63          	beqz	a0,32c2 <subdir+0x5b2>
  if(unlink("dd/dd") < 0){
    2fee:	00004517          	auipc	a0,0x4
    2ff2:	dc250513          	addi	a0,a0,-574 # 6db0 <malloc+0x18a4>
    2ff6:	060020ef          	jal	5056 <unlink>
    2ffa:	2c054e63          	bltz	a0,32d6 <subdir+0x5c6>
  if(unlink("dd") < 0){
    2ffe:	00004517          	auipc	a0,0x4
    3002:	87a50513          	addi	a0,a0,-1926 # 6878 <malloc+0x136c>
    3006:	050020ef          	jal	5056 <unlink>
    300a:	2e054063          	bltz	a0,32ea <subdir+0x5da>
}
    300e:	60e2                	ld	ra,24(sp)
    3010:	6442                	ld	s0,16(sp)
    3012:	64a2                	ld	s1,8(sp)
    3014:	6902                	ld	s2,0(sp)
    3016:	6105                	addi	sp,sp,32
    3018:	8082                	ret
    printf("%s: mkdir dd failed\n", s);
    301a:	85ca                	mv	a1,s2
    301c:	00004517          	auipc	a0,0x4
    3020:	86450513          	addi	a0,a0,-1948 # 6880 <malloc+0x1374>
    3024:	430020ef          	jal	5454 <printf>
    exit(1);
    3028:	4505                	li	a0,1
    302a:	7dd010ef          	jal	5006 <exit>
    printf("%s: create dd/ff failed\n", s);
    302e:	85ca                	mv	a1,s2
    3030:	00004517          	auipc	a0,0x4
    3034:	87050513          	addi	a0,a0,-1936 # 68a0 <malloc+0x1394>
    3038:	41c020ef          	jal	5454 <printf>
    exit(1);
    303c:	4505                	li	a0,1
    303e:	7c9010ef          	jal	5006 <exit>
    printf("%s: unlink dd (non-empty dir) succeeded!\n", s);
    3042:	85ca                	mv	a1,s2
    3044:	00004517          	auipc	a0,0x4
    3048:	87c50513          	addi	a0,a0,-1924 # 68c0 <malloc+0x13b4>
    304c:	408020ef          	jal	5454 <printf>
    exit(1);
    3050:	4505                	li	a0,1
    3052:	7b5010ef          	jal	5006 <exit>
    printf("%s: subdir mkdir dd/dd failed\n", s);
    3056:	85ca                	mv	a1,s2
    3058:	00004517          	auipc	a0,0x4
    305c:	8a050513          	addi	a0,a0,-1888 # 68f8 <malloc+0x13ec>
    3060:	3f4020ef          	jal	5454 <printf>
    exit(1);
    3064:	4505                	li	a0,1
    3066:	7a1010ef          	jal	5006 <exit>
    printf("%s: create dd/dd/ff failed\n", s);
    306a:	85ca                	mv	a1,s2
    306c:	00004517          	auipc	a0,0x4
    3070:	8bc50513          	addi	a0,a0,-1860 # 6928 <malloc+0x141c>
    3074:	3e0020ef          	jal	5454 <printf>
    exit(1);
    3078:	4505                	li	a0,1
    307a:	78d010ef          	jal	5006 <exit>
    printf("%s: open dd/dd/../ff failed\n", s);
    307e:	85ca                	mv	a1,s2
    3080:	00004517          	auipc	a0,0x4
    3084:	8e050513          	addi	a0,a0,-1824 # 6960 <malloc+0x1454>
    3088:	3cc020ef          	jal	5454 <printf>
    exit(1);
    308c:	4505                	li	a0,1
    308e:	779010ef          	jal	5006 <exit>
    printf("%s: dd/dd/../ff wrong content\n", s);
    3092:	85ca                	mv	a1,s2
    3094:	00004517          	auipc	a0,0x4
    3098:	8ec50513          	addi	a0,a0,-1812 # 6980 <malloc+0x1474>
    309c:	3b8020ef          	jal	5454 <printf>
    exit(1);
    30a0:	4505                	li	a0,1
    30a2:	765010ef          	jal	5006 <exit>
    printf("%s: link dd/dd/ff dd/dd/ffff failed\n", s);
    30a6:	85ca                	mv	a1,s2
    30a8:	00004517          	auipc	a0,0x4
    30ac:	90850513          	addi	a0,a0,-1784 # 69b0 <malloc+0x14a4>
    30b0:	3a4020ef          	jal	5454 <printf>
    exit(1);
    30b4:	4505                	li	a0,1
    30b6:	751010ef          	jal	5006 <exit>
    printf("%s: unlink dd/dd/ff failed\n", s);
    30ba:	85ca                	mv	a1,s2
    30bc:	00004517          	auipc	a0,0x4
    30c0:	91c50513          	addi	a0,a0,-1764 # 69d8 <malloc+0x14cc>
    30c4:	390020ef          	jal	5454 <printf>
    exit(1);
    30c8:	4505                	li	a0,1
    30ca:	73d010ef          	jal	5006 <exit>
    printf("%s: open (unlinked) dd/dd/ff succeeded\n", s);
    30ce:	85ca                	mv	a1,s2
    30d0:	00004517          	auipc	a0,0x4
    30d4:	92850513          	addi	a0,a0,-1752 # 69f8 <malloc+0x14ec>
    30d8:	37c020ef          	jal	5454 <printf>
    exit(1);
    30dc:	4505                	li	a0,1
    30de:	729010ef          	jal	5006 <exit>
    printf("%s: chdir dd failed\n", s);
    30e2:	85ca                	mv	a1,s2
    30e4:	00004517          	auipc	a0,0x4
    30e8:	93c50513          	addi	a0,a0,-1732 # 6a20 <malloc+0x1514>
    30ec:	368020ef          	jal	5454 <printf>
    exit(1);
    30f0:	4505                	li	a0,1
    30f2:	715010ef          	jal	5006 <exit>
    printf("%s: chdir dd/../../dd failed\n", s);
    30f6:	85ca                	mv	a1,s2
    30f8:	00004517          	auipc	a0,0x4
    30fc:	95050513          	addi	a0,a0,-1712 # 6a48 <malloc+0x153c>
    3100:	354020ef          	jal	5454 <printf>
    exit(1);
    3104:	4505                	li	a0,1
    3106:	701010ef          	jal	5006 <exit>
    printf("%s: chdir dd/../../../dd failed\n", s);
    310a:	85ca                	mv	a1,s2
    310c:	00004517          	auipc	a0,0x4
    3110:	96c50513          	addi	a0,a0,-1684 # 6a78 <malloc+0x156c>
    3114:	340020ef          	jal	5454 <printf>
    exit(1);
    3118:	4505                	li	a0,1
    311a:	6ed010ef          	jal	5006 <exit>
    printf("%s: chdir ./.. failed\n", s);
    311e:	85ca                	mv	a1,s2
    3120:	00004517          	auipc	a0,0x4
    3124:	98850513          	addi	a0,a0,-1656 # 6aa8 <malloc+0x159c>
    3128:	32c020ef          	jal	5454 <printf>
    exit(1);
    312c:	4505                	li	a0,1
    312e:	6d9010ef          	jal	5006 <exit>
    printf("%s: open dd/dd/ffff failed\n", s);
    3132:	85ca                	mv	a1,s2
    3134:	00004517          	auipc	a0,0x4
    3138:	98c50513          	addi	a0,a0,-1652 # 6ac0 <malloc+0x15b4>
    313c:	318020ef          	jal	5454 <printf>
    exit(1);
    3140:	4505                	li	a0,1
    3142:	6c5010ef          	jal	5006 <exit>
    printf("%s: read dd/dd/ffff wrong len\n", s);
    3146:	85ca                	mv	a1,s2
    3148:	00004517          	auipc	a0,0x4
    314c:	99850513          	addi	a0,a0,-1640 # 6ae0 <malloc+0x15d4>
    3150:	304020ef          	jal	5454 <printf>
    exit(1);
    3154:	4505                	li	a0,1
    3156:	6b1010ef          	jal	5006 <exit>
    printf("%s: open (unlinked) dd/dd/ff succeeded!\n", s);
    315a:	85ca                	mv	a1,s2
    315c:	00004517          	auipc	a0,0x4
    3160:	9a450513          	addi	a0,a0,-1628 # 6b00 <malloc+0x15f4>
    3164:	2f0020ef          	jal	5454 <printf>
    exit(1);
    3168:	4505                	li	a0,1
    316a:	69d010ef          	jal	5006 <exit>
    printf("%s: create dd/ff/ff succeeded!\n", s);
    316e:	85ca                	mv	a1,s2
    3170:	00004517          	auipc	a0,0x4
    3174:	9d050513          	addi	a0,a0,-1584 # 6b40 <malloc+0x1634>
    3178:	2dc020ef          	jal	5454 <printf>
    exit(1);
    317c:	4505                	li	a0,1
    317e:	689010ef          	jal	5006 <exit>
    printf("%s: create dd/xx/ff succeeded!\n", s);
    3182:	85ca                	mv	a1,s2
    3184:	00004517          	auipc	a0,0x4
    3188:	9ec50513          	addi	a0,a0,-1556 # 6b70 <malloc+0x1664>
    318c:	2c8020ef          	jal	5454 <printf>
    exit(1);
    3190:	4505                	li	a0,1
    3192:	675010ef          	jal	5006 <exit>
    printf("%s: create dd succeeded!\n", s);
    3196:	85ca                	mv	a1,s2
    3198:	00004517          	auipc	a0,0x4
    319c:	9f850513          	addi	a0,a0,-1544 # 6b90 <malloc+0x1684>
    31a0:	2b4020ef          	jal	5454 <printf>
    exit(1);
    31a4:	4505                	li	a0,1
    31a6:	661010ef          	jal	5006 <exit>
    printf("%s: open dd rdwr succeeded!\n", s);
    31aa:	85ca                	mv	a1,s2
    31ac:	00004517          	auipc	a0,0x4
    31b0:	a0450513          	addi	a0,a0,-1532 # 6bb0 <malloc+0x16a4>
    31b4:	2a0020ef          	jal	5454 <printf>
    exit(1);
    31b8:	4505                	li	a0,1
    31ba:	64d010ef          	jal	5006 <exit>
    printf("%s: open dd wronly succeeded!\n", s);
    31be:	85ca                	mv	a1,s2
    31c0:	00004517          	auipc	a0,0x4
    31c4:	a1050513          	addi	a0,a0,-1520 # 6bd0 <malloc+0x16c4>
    31c8:	28c020ef          	jal	5454 <printf>
    exit(1);
    31cc:	4505                	li	a0,1
    31ce:	639010ef          	jal	5006 <exit>
    printf("%s: link dd/ff/ff dd/dd/xx succeeded!\n", s);
    31d2:	85ca                	mv	a1,s2
    31d4:	00004517          	auipc	a0,0x4
    31d8:	a2c50513          	addi	a0,a0,-1492 # 6c00 <malloc+0x16f4>
    31dc:	278020ef          	jal	5454 <printf>
    exit(1);
    31e0:	4505                	li	a0,1
    31e2:	625010ef          	jal	5006 <exit>
    printf("%s: link dd/xx/ff dd/dd/xx succeeded!\n", s);
    31e6:	85ca                	mv	a1,s2
    31e8:	00004517          	auipc	a0,0x4
    31ec:	a4050513          	addi	a0,a0,-1472 # 6c28 <malloc+0x171c>
    31f0:	264020ef          	jal	5454 <printf>
    exit(1);
    31f4:	4505                	li	a0,1
    31f6:	611010ef          	jal	5006 <exit>
    printf("%s: link dd/ff dd/dd/ffff succeeded!\n", s);
    31fa:	85ca                	mv	a1,s2
    31fc:	00004517          	auipc	a0,0x4
    3200:	a5450513          	addi	a0,a0,-1452 # 6c50 <malloc+0x1744>
    3204:	250020ef          	jal	5454 <printf>
    exit(1);
    3208:	4505                	li	a0,1
    320a:	5fd010ef          	jal	5006 <exit>
    printf("%s: mkdir dd/ff/ff succeeded!\n", s);
    320e:	85ca                	mv	a1,s2
    3210:	00004517          	auipc	a0,0x4
    3214:	a6850513          	addi	a0,a0,-1432 # 6c78 <malloc+0x176c>
    3218:	23c020ef          	jal	5454 <printf>
    exit(1);
    321c:	4505                	li	a0,1
    321e:	5e9010ef          	jal	5006 <exit>
    printf("%s: mkdir dd/xx/ff succeeded!\n", s);
    3222:	85ca                	mv	a1,s2
    3224:	00004517          	auipc	a0,0x4
    3228:	a7450513          	addi	a0,a0,-1420 # 6c98 <malloc+0x178c>
    322c:	228020ef          	jal	5454 <printf>
    exit(1);
    3230:	4505                	li	a0,1
    3232:	5d5010ef          	jal	5006 <exit>
    printf("%s: mkdir dd/dd/ffff succeeded!\n", s);
    3236:	85ca                	mv	a1,s2
    3238:	00004517          	auipc	a0,0x4
    323c:	a8050513          	addi	a0,a0,-1408 # 6cb8 <malloc+0x17ac>
    3240:	214020ef          	jal	5454 <printf>
    exit(1);
    3244:	4505                	li	a0,1
    3246:	5c1010ef          	jal	5006 <exit>
    printf("%s: unlink dd/xx/ff succeeded!\n", s);
    324a:	85ca                	mv	a1,s2
    324c:	00004517          	auipc	a0,0x4
    3250:	a9450513          	addi	a0,a0,-1388 # 6ce0 <malloc+0x17d4>
    3254:	200020ef          	jal	5454 <printf>
    exit(1);
    3258:	4505                	li	a0,1
    325a:	5ad010ef          	jal	5006 <exit>
    printf("%s: unlink dd/ff/ff succeeded!\n", s);
    325e:	85ca                	mv	a1,s2
    3260:	00004517          	auipc	a0,0x4
    3264:	aa050513          	addi	a0,a0,-1376 # 6d00 <malloc+0x17f4>
    3268:	1ec020ef          	jal	5454 <printf>
    exit(1);
    326c:	4505                	li	a0,1
    326e:	599010ef          	jal	5006 <exit>
    printf("%s: chdir dd/ff succeeded!\n", s);
    3272:	85ca                	mv	a1,s2
    3274:	00004517          	auipc	a0,0x4
    3278:	aac50513          	addi	a0,a0,-1364 # 6d20 <malloc+0x1814>
    327c:	1d8020ef          	jal	5454 <printf>
    exit(1);
    3280:	4505                	li	a0,1
    3282:	585010ef          	jal	5006 <exit>
    printf("%s: chdir dd/xx succeeded!\n", s);
    3286:	85ca                	mv	a1,s2
    3288:	00004517          	auipc	a0,0x4
    328c:	ac050513          	addi	a0,a0,-1344 # 6d48 <malloc+0x183c>
    3290:	1c4020ef          	jal	5454 <printf>
    exit(1);
    3294:	4505                	li	a0,1
    3296:	571010ef          	jal	5006 <exit>
    printf("%s: unlink dd/dd/ff failed\n", s);
    329a:	85ca                	mv	a1,s2
    329c:	00003517          	auipc	a0,0x3
    32a0:	73c50513          	addi	a0,a0,1852 # 69d8 <malloc+0x14cc>
    32a4:	1b0020ef          	jal	5454 <printf>
    exit(1);
    32a8:	4505                	li	a0,1
    32aa:	55d010ef          	jal	5006 <exit>
    printf("%s: unlink dd/ff failed\n", s);
    32ae:	85ca                	mv	a1,s2
    32b0:	00004517          	auipc	a0,0x4
    32b4:	ab850513          	addi	a0,a0,-1352 # 6d68 <malloc+0x185c>
    32b8:	19c020ef          	jal	5454 <printf>
    exit(1);
    32bc:	4505                	li	a0,1
    32be:	549010ef          	jal	5006 <exit>
    printf("%s: unlink non-empty dd succeeded!\n", s);
    32c2:	85ca                	mv	a1,s2
    32c4:	00004517          	auipc	a0,0x4
    32c8:	ac450513          	addi	a0,a0,-1340 # 6d88 <malloc+0x187c>
    32cc:	188020ef          	jal	5454 <printf>
    exit(1);
    32d0:	4505                	li	a0,1
    32d2:	535010ef          	jal	5006 <exit>
    printf("%s: unlink dd/dd failed\n", s);
    32d6:	85ca                	mv	a1,s2
    32d8:	00004517          	auipc	a0,0x4
    32dc:	ae050513          	addi	a0,a0,-1312 # 6db8 <malloc+0x18ac>
    32e0:	174020ef          	jal	5454 <printf>
    exit(1);
    32e4:	4505                	li	a0,1
    32e6:	521010ef          	jal	5006 <exit>
    printf("%s: unlink dd failed\n", s);
    32ea:	85ca                	mv	a1,s2
    32ec:	00004517          	auipc	a0,0x4
    32f0:	aec50513          	addi	a0,a0,-1300 # 6dd8 <malloc+0x18cc>
    32f4:	160020ef          	jal	5454 <printf>
    exit(1);
    32f8:	4505                	li	a0,1
    32fa:	50d010ef          	jal	5006 <exit>

00000000000032fe <rmdot>:
{
    32fe:	1101                	addi	sp,sp,-32
    3300:	ec06                	sd	ra,24(sp)
    3302:	e822                	sd	s0,16(sp)
    3304:	e426                	sd	s1,8(sp)
    3306:	1000                	addi	s0,sp,32
    3308:	84aa                	mv	s1,a0
  if(mkdir("dots") != 0){
    330a:	00004517          	auipc	a0,0x4
    330e:	ae650513          	addi	a0,a0,-1306 # 6df0 <malloc+0x18e4>
    3312:	55d010ef          	jal	506e <mkdir>
    3316:	e53d                	bnez	a0,3384 <rmdot+0x86>
  if(chdir("dots") != 0){
    3318:	00004517          	auipc	a0,0x4
    331c:	ad850513          	addi	a0,a0,-1320 # 6df0 <malloc+0x18e4>
    3320:	557010ef          	jal	5076 <chdir>
    3324:	e935                	bnez	a0,3398 <rmdot+0x9a>
  if(unlink(".") == 0){
    3326:	00003517          	auipc	a0,0x3
    332a:	9fa50513          	addi	a0,a0,-1542 # 5d20 <malloc+0x814>
    332e:	529010ef          	jal	5056 <unlink>
    3332:	cd2d                	beqz	a0,33ac <rmdot+0xae>
  if(unlink("..") == 0){
    3334:	00003517          	auipc	a0,0x3
    3338:	50c50513          	addi	a0,a0,1292 # 6840 <malloc+0x1334>
    333c:	51b010ef          	jal	5056 <unlink>
    3340:	c141                	beqz	a0,33c0 <rmdot+0xc2>
  if(chdir("/") != 0){
    3342:	00003517          	auipc	a0,0x3
    3346:	4a650513          	addi	a0,a0,1190 # 67e8 <malloc+0x12dc>
    334a:	52d010ef          	jal	5076 <chdir>
    334e:	e159                	bnez	a0,33d4 <rmdot+0xd6>
  if(unlink("dots/.") == 0){
    3350:	00004517          	auipc	a0,0x4
    3354:	b0850513          	addi	a0,a0,-1272 # 6e58 <malloc+0x194c>
    3358:	4ff010ef          	jal	5056 <unlink>
    335c:	c551                	beqz	a0,33e8 <rmdot+0xea>
  if(unlink("dots/..") == 0){
    335e:	00004517          	auipc	a0,0x4
    3362:	b2250513          	addi	a0,a0,-1246 # 6e80 <malloc+0x1974>
    3366:	4f1010ef          	jal	5056 <unlink>
    336a:	c949                	beqz	a0,33fc <rmdot+0xfe>
  if(unlink("dots") != 0){
    336c:	00004517          	auipc	a0,0x4
    3370:	a8450513          	addi	a0,a0,-1404 # 6df0 <malloc+0x18e4>
    3374:	4e3010ef          	jal	5056 <unlink>
    3378:	ed41                	bnez	a0,3410 <rmdot+0x112>
}
    337a:	60e2                	ld	ra,24(sp)
    337c:	6442                	ld	s0,16(sp)
    337e:	64a2                	ld	s1,8(sp)
    3380:	6105                	addi	sp,sp,32
    3382:	8082                	ret
    printf("%s: mkdir dots failed\n", s);
    3384:	85a6                	mv	a1,s1
    3386:	00004517          	auipc	a0,0x4
    338a:	a7250513          	addi	a0,a0,-1422 # 6df8 <malloc+0x18ec>
    338e:	0c6020ef          	jal	5454 <printf>
    exit(1);
    3392:	4505                	li	a0,1
    3394:	473010ef          	jal	5006 <exit>
    printf("%s: chdir dots failed\n", s);
    3398:	85a6                	mv	a1,s1
    339a:	00004517          	auipc	a0,0x4
    339e:	a7650513          	addi	a0,a0,-1418 # 6e10 <malloc+0x1904>
    33a2:	0b2020ef          	jal	5454 <printf>
    exit(1);
    33a6:	4505                	li	a0,1
    33a8:	45f010ef          	jal	5006 <exit>
    printf("%s: rm . worked!\n", s);
    33ac:	85a6                	mv	a1,s1
    33ae:	00004517          	auipc	a0,0x4
    33b2:	a7a50513          	addi	a0,a0,-1414 # 6e28 <malloc+0x191c>
    33b6:	09e020ef          	jal	5454 <printf>
    exit(1);
    33ba:	4505                	li	a0,1
    33bc:	44b010ef          	jal	5006 <exit>
    printf("%s: rm .. worked!\n", s);
    33c0:	85a6                	mv	a1,s1
    33c2:	00004517          	auipc	a0,0x4
    33c6:	a7e50513          	addi	a0,a0,-1410 # 6e40 <malloc+0x1934>
    33ca:	08a020ef          	jal	5454 <printf>
    exit(1);
    33ce:	4505                	li	a0,1
    33d0:	437010ef          	jal	5006 <exit>
    printf("%s: chdir / failed\n", s);
    33d4:	85a6                	mv	a1,s1
    33d6:	00003517          	auipc	a0,0x3
    33da:	41a50513          	addi	a0,a0,1050 # 67f0 <malloc+0x12e4>
    33de:	076020ef          	jal	5454 <printf>
    exit(1);
    33e2:	4505                	li	a0,1
    33e4:	423010ef          	jal	5006 <exit>
    printf("%s: unlink dots/. worked!\n", s);
    33e8:	85a6                	mv	a1,s1
    33ea:	00004517          	auipc	a0,0x4
    33ee:	a7650513          	addi	a0,a0,-1418 # 6e60 <malloc+0x1954>
    33f2:	062020ef          	jal	5454 <printf>
    exit(1);
    33f6:	4505                	li	a0,1
    33f8:	40f010ef          	jal	5006 <exit>
    printf("%s: unlink dots/.. worked!\n", s);
    33fc:	85a6                	mv	a1,s1
    33fe:	00004517          	auipc	a0,0x4
    3402:	a8a50513          	addi	a0,a0,-1398 # 6e88 <malloc+0x197c>
    3406:	04e020ef          	jal	5454 <printf>
    exit(1);
    340a:	4505                	li	a0,1
    340c:	3fb010ef          	jal	5006 <exit>
    printf("%s: unlink dots failed!\n", s);
    3410:	85a6                	mv	a1,s1
    3412:	00004517          	auipc	a0,0x4
    3416:	a9650513          	addi	a0,a0,-1386 # 6ea8 <malloc+0x199c>
    341a:	03a020ef          	jal	5454 <printf>
    exit(1);
    341e:	4505                	li	a0,1
    3420:	3e7010ef          	jal	5006 <exit>

0000000000003424 <dirfile>:
{
    3424:	1101                	addi	sp,sp,-32
    3426:	ec06                	sd	ra,24(sp)
    3428:	e822                	sd	s0,16(sp)
    342a:	e426                	sd	s1,8(sp)
    342c:	e04a                	sd	s2,0(sp)
    342e:	1000                	addi	s0,sp,32
    3430:	892a                	mv	s2,a0
  fd = open("dirfile", O_CREATE);
    3432:	20000593          	li	a1,512
    3436:	00004517          	auipc	a0,0x4
    343a:	a9250513          	addi	a0,a0,-1390 # 6ec8 <malloc+0x19bc>
    343e:	409010ef          	jal	5046 <open>
  if(fd < 0){
    3442:	0c054563          	bltz	a0,350c <dirfile+0xe8>
  close(fd);
    3446:	3e9010ef          	jal	502e <close>
  if(chdir("dirfile") == 0){
    344a:	00004517          	auipc	a0,0x4
    344e:	a7e50513          	addi	a0,a0,-1410 # 6ec8 <malloc+0x19bc>
    3452:	425010ef          	jal	5076 <chdir>
    3456:	c569                	beqz	a0,3520 <dirfile+0xfc>
  fd = open("dirfile/xx", 0);
    3458:	4581                	li	a1,0
    345a:	00004517          	auipc	a0,0x4
    345e:	ab650513          	addi	a0,a0,-1354 # 6f10 <malloc+0x1a04>
    3462:	3e5010ef          	jal	5046 <open>
  if(fd >= 0){
    3466:	0c055763          	bgez	a0,3534 <dirfile+0x110>
  fd = open("dirfile/xx", O_CREATE);
    346a:	20000593          	li	a1,512
    346e:	00004517          	auipc	a0,0x4
    3472:	aa250513          	addi	a0,a0,-1374 # 6f10 <malloc+0x1a04>
    3476:	3d1010ef          	jal	5046 <open>
  if(fd >= 0){
    347a:	0c055763          	bgez	a0,3548 <dirfile+0x124>
  if(mkdir("dirfile/xx") == 0){
    347e:	00004517          	auipc	a0,0x4
    3482:	a9250513          	addi	a0,a0,-1390 # 6f10 <malloc+0x1a04>
    3486:	3e9010ef          	jal	506e <mkdir>
    348a:	0c050963          	beqz	a0,355c <dirfile+0x138>
  if(unlink("dirfile/xx") == 0){
    348e:	00004517          	auipc	a0,0x4
    3492:	a8250513          	addi	a0,a0,-1406 # 6f10 <malloc+0x1a04>
    3496:	3c1010ef          	jal	5056 <unlink>
    349a:	0c050b63          	beqz	a0,3570 <dirfile+0x14c>
  if(link("README", "dirfile/xx") == 0){
    349e:	00004597          	auipc	a1,0x4
    34a2:	a7258593          	addi	a1,a1,-1422 # 6f10 <malloc+0x1a04>
    34a6:	00002517          	auipc	a0,0x2
    34aa:	36a50513          	addi	a0,a0,874 # 5810 <malloc+0x304>
    34ae:	3b9010ef          	jal	5066 <link>
    34b2:	0c050963          	beqz	a0,3584 <dirfile+0x160>
  if(unlink("dirfile") != 0){
    34b6:	00004517          	auipc	a0,0x4
    34ba:	a1250513          	addi	a0,a0,-1518 # 6ec8 <malloc+0x19bc>
    34be:	399010ef          	jal	5056 <unlink>
    34c2:	0c051b63          	bnez	a0,3598 <dirfile+0x174>
  fd = open(".", O_RDWR);
    34c6:	4589                	li	a1,2
    34c8:	00003517          	auipc	a0,0x3
    34cc:	85850513          	addi	a0,a0,-1960 # 5d20 <malloc+0x814>
    34d0:	377010ef          	jal	5046 <open>
  if(fd >= 0){
    34d4:	0c055c63          	bgez	a0,35ac <dirfile+0x188>
  fd = open(".", 0);
    34d8:	4581                	li	a1,0
    34da:	00003517          	auipc	a0,0x3
    34de:	84650513          	addi	a0,a0,-1978 # 5d20 <malloc+0x814>
    34e2:	365010ef          	jal	5046 <open>
    34e6:	84aa                	mv	s1,a0
  if(write(fd, "x", 1) > 0){
    34e8:	4605                	li	a2,1
    34ea:	00002597          	auipc	a1,0x2
    34ee:	1be58593          	addi	a1,a1,446 # 56a8 <malloc+0x19c>
    34f2:	335010ef          	jal	5026 <write>
    34f6:	0ca04563          	bgtz	a0,35c0 <dirfile+0x19c>
  close(fd);
    34fa:	8526                	mv	a0,s1
    34fc:	333010ef          	jal	502e <close>
}
    3500:	60e2                	ld	ra,24(sp)
    3502:	6442                	ld	s0,16(sp)
    3504:	64a2                	ld	s1,8(sp)
    3506:	6902                	ld	s2,0(sp)
    3508:	6105                	addi	sp,sp,32
    350a:	8082                	ret
    printf("%s: create dirfile failed\n", s);
    350c:	85ca                	mv	a1,s2
    350e:	00004517          	auipc	a0,0x4
    3512:	9c250513          	addi	a0,a0,-1598 # 6ed0 <malloc+0x19c4>
    3516:	73f010ef          	jal	5454 <printf>
    exit(1);
    351a:	4505                	li	a0,1
    351c:	2eb010ef          	jal	5006 <exit>
    printf("%s: chdir dirfile succeeded!\n", s);
    3520:	85ca                	mv	a1,s2
    3522:	00004517          	auipc	a0,0x4
    3526:	9ce50513          	addi	a0,a0,-1586 # 6ef0 <malloc+0x19e4>
    352a:	72b010ef          	jal	5454 <printf>
    exit(1);
    352e:	4505                	li	a0,1
    3530:	2d7010ef          	jal	5006 <exit>
    printf("%s: create dirfile/xx succeeded!\n", s);
    3534:	85ca                	mv	a1,s2
    3536:	00004517          	auipc	a0,0x4
    353a:	9ea50513          	addi	a0,a0,-1558 # 6f20 <malloc+0x1a14>
    353e:	717010ef          	jal	5454 <printf>
    exit(1);
    3542:	4505                	li	a0,1
    3544:	2c3010ef          	jal	5006 <exit>
    printf("%s: create dirfile/xx succeeded!\n", s);
    3548:	85ca                	mv	a1,s2
    354a:	00004517          	auipc	a0,0x4
    354e:	9d650513          	addi	a0,a0,-1578 # 6f20 <malloc+0x1a14>
    3552:	703010ef          	jal	5454 <printf>
    exit(1);
    3556:	4505                	li	a0,1
    3558:	2af010ef          	jal	5006 <exit>
    printf("%s: mkdir dirfile/xx succeeded!\n", s);
    355c:	85ca                	mv	a1,s2
    355e:	00004517          	auipc	a0,0x4
    3562:	9ea50513          	addi	a0,a0,-1558 # 6f48 <malloc+0x1a3c>
    3566:	6ef010ef          	jal	5454 <printf>
    exit(1);
    356a:	4505                	li	a0,1
    356c:	29b010ef          	jal	5006 <exit>
    printf("%s: unlink dirfile/xx succeeded!\n", s);
    3570:	85ca                	mv	a1,s2
    3572:	00004517          	auipc	a0,0x4
    3576:	9fe50513          	addi	a0,a0,-1538 # 6f70 <malloc+0x1a64>
    357a:	6db010ef          	jal	5454 <printf>
    exit(1);
    357e:	4505                	li	a0,1
    3580:	287010ef          	jal	5006 <exit>
    printf("%s: link to dirfile/xx succeeded!\n", s);
    3584:	85ca                	mv	a1,s2
    3586:	00004517          	auipc	a0,0x4
    358a:	a1250513          	addi	a0,a0,-1518 # 6f98 <malloc+0x1a8c>
    358e:	6c7010ef          	jal	5454 <printf>
    exit(1);
    3592:	4505                	li	a0,1
    3594:	273010ef          	jal	5006 <exit>
    printf("%s: unlink dirfile failed!\n", s);
    3598:	85ca                	mv	a1,s2
    359a:	00004517          	auipc	a0,0x4
    359e:	a2650513          	addi	a0,a0,-1498 # 6fc0 <malloc+0x1ab4>
    35a2:	6b3010ef          	jal	5454 <printf>
    exit(1);
    35a6:	4505                	li	a0,1
    35a8:	25f010ef          	jal	5006 <exit>
    printf("%s: open . for writing succeeded!\n", s);
    35ac:	85ca                	mv	a1,s2
    35ae:	00004517          	auipc	a0,0x4
    35b2:	a3250513          	addi	a0,a0,-1486 # 6fe0 <malloc+0x1ad4>
    35b6:	69f010ef          	jal	5454 <printf>
    exit(1);
    35ba:	4505                	li	a0,1
    35bc:	24b010ef          	jal	5006 <exit>
    printf("%s: write . succeeded!\n", s);
    35c0:	85ca                	mv	a1,s2
    35c2:	00004517          	auipc	a0,0x4
    35c6:	a4650513          	addi	a0,a0,-1466 # 7008 <malloc+0x1afc>
    35ca:	68b010ef          	jal	5454 <printf>
    exit(1);
    35ce:	4505                	li	a0,1
    35d0:	237010ef          	jal	5006 <exit>

00000000000035d4 <iref>:
{
    35d4:	715d                	addi	sp,sp,-80
    35d6:	e486                	sd	ra,72(sp)
    35d8:	e0a2                	sd	s0,64(sp)
    35da:	fc26                	sd	s1,56(sp)
    35dc:	f84a                	sd	s2,48(sp)
    35de:	f44e                	sd	s3,40(sp)
    35e0:	f052                	sd	s4,32(sp)
    35e2:	ec56                	sd	s5,24(sp)
    35e4:	e85a                	sd	s6,16(sp)
    35e6:	e45e                	sd	s7,8(sp)
    35e8:	0880                	addi	s0,sp,80
    35ea:	8baa                	mv	s7,a0
    35ec:	03300913          	li	s2,51
    if(mkdir("irefd") != 0){
    35f0:	00004a97          	auipc	s5,0x4
    35f4:	a30a8a93          	addi	s5,s5,-1488 # 7020 <malloc+0x1b14>
    mkdir("");
    35f8:	00003497          	auipc	s1,0x3
    35fc:	53048493          	addi	s1,s1,1328 # 6b28 <malloc+0x161c>
    link("README", "");
    3600:	00002b17          	auipc	s6,0x2
    3604:	210b0b13          	addi	s6,s6,528 # 5810 <malloc+0x304>
    fd = open("", O_CREATE);
    3608:	20000a13          	li	s4,512
    fd = open("xx", O_CREATE);
    360c:	00004997          	auipc	s3,0x4
    3610:	90c98993          	addi	s3,s3,-1780 # 6f18 <malloc+0x1a0c>
    3614:	a835                	j	3650 <iref+0x7c>
      printf("%s: mkdir irefd failed\n", s);
    3616:	85de                	mv	a1,s7
    3618:	00004517          	auipc	a0,0x4
    361c:	a1050513          	addi	a0,a0,-1520 # 7028 <malloc+0x1b1c>
    3620:	635010ef          	jal	5454 <printf>
      exit(1);
    3624:	4505                	li	a0,1
    3626:	1e1010ef          	jal	5006 <exit>
      printf("%s: chdir irefd failed\n", s);
    362a:	85de                	mv	a1,s7
    362c:	00004517          	auipc	a0,0x4
    3630:	a1450513          	addi	a0,a0,-1516 # 7040 <malloc+0x1b34>
    3634:	621010ef          	jal	5454 <printf>
      exit(1);
    3638:	4505                	li	a0,1
    363a:	1cd010ef          	jal	5006 <exit>
      close(fd);
    363e:	1f1010ef          	jal	502e <close>
    3642:	a825                	j	367a <iref+0xa6>
    unlink("xx");
    3644:	854e                	mv	a0,s3
    3646:	211010ef          	jal	5056 <unlink>
  for(i = 0; i < NINODE + 1; i++){
    364a:	397d                	addiw	s2,s2,-1
    364c:	04090063          	beqz	s2,368c <iref+0xb8>
    if(mkdir("irefd") != 0){
    3650:	8556                	mv	a0,s5
    3652:	21d010ef          	jal	506e <mkdir>
    3656:	f161                	bnez	a0,3616 <iref+0x42>
    if(chdir("irefd") != 0){
    3658:	8556                	mv	a0,s5
    365a:	21d010ef          	jal	5076 <chdir>
    365e:	f571                	bnez	a0,362a <iref+0x56>
    mkdir("");
    3660:	8526                	mv	a0,s1
    3662:	20d010ef          	jal	506e <mkdir>
    link("README", "");
    3666:	85a6                	mv	a1,s1
    3668:	855a                	mv	a0,s6
    366a:	1fd010ef          	jal	5066 <link>
    fd = open("", O_CREATE);
    366e:	85d2                	mv	a1,s4
    3670:	8526                	mv	a0,s1
    3672:	1d5010ef          	jal	5046 <open>
    if(fd >= 0)
    3676:	fc0554e3          	bgez	a0,363e <iref+0x6a>
    fd = open("xx", O_CREATE);
    367a:	85d2                	mv	a1,s4
    367c:	854e                	mv	a0,s3
    367e:	1c9010ef          	jal	5046 <open>
    if(fd >= 0)
    3682:	fc0541e3          	bltz	a0,3644 <iref+0x70>
      close(fd);
    3686:	1a9010ef          	jal	502e <close>
    368a:	bf6d                	j	3644 <iref+0x70>
    368c:	03300493          	li	s1,51
    chdir("..");
    3690:	00003997          	auipc	s3,0x3
    3694:	1b098993          	addi	s3,s3,432 # 6840 <malloc+0x1334>
    unlink("irefd");
    3698:	00004917          	auipc	s2,0x4
    369c:	98890913          	addi	s2,s2,-1656 # 7020 <malloc+0x1b14>
    chdir("..");
    36a0:	854e                	mv	a0,s3
    36a2:	1d5010ef          	jal	5076 <chdir>
    unlink("irefd");
    36a6:	854a                	mv	a0,s2
    36a8:	1af010ef          	jal	5056 <unlink>
  for(i = 0; i < NINODE + 1; i++){
    36ac:	34fd                	addiw	s1,s1,-1
    36ae:	f8ed                	bnez	s1,36a0 <iref+0xcc>
  chdir("/");
    36b0:	00003517          	auipc	a0,0x3
    36b4:	13850513          	addi	a0,a0,312 # 67e8 <malloc+0x12dc>
    36b8:	1bf010ef          	jal	5076 <chdir>
}
    36bc:	60a6                	ld	ra,72(sp)
    36be:	6406                	ld	s0,64(sp)
    36c0:	74e2                	ld	s1,56(sp)
    36c2:	7942                	ld	s2,48(sp)
    36c4:	79a2                	ld	s3,40(sp)
    36c6:	7a02                	ld	s4,32(sp)
    36c8:	6ae2                	ld	s5,24(sp)
    36ca:	6b42                	ld	s6,16(sp)
    36cc:	6ba2                	ld	s7,8(sp)
    36ce:	6161                	addi	sp,sp,80
    36d0:	8082                	ret

00000000000036d2 <openiputtest>:
{
    36d2:	7179                	addi	sp,sp,-48
    36d4:	f406                	sd	ra,40(sp)
    36d6:	f022                	sd	s0,32(sp)
    36d8:	ec26                	sd	s1,24(sp)
    36da:	1800                	addi	s0,sp,48
    36dc:	84aa                	mv	s1,a0
  if(mkdir("oidir") < 0){
    36de:	00004517          	auipc	a0,0x4
    36e2:	97a50513          	addi	a0,a0,-1670 # 7058 <malloc+0x1b4c>
    36e6:	189010ef          	jal	506e <mkdir>
    36ea:	02054a63          	bltz	a0,371e <openiputtest+0x4c>
  pid = fork();
    36ee:	111010ef          	jal	4ffe <fork>
  if(pid < 0){
    36f2:	04054063          	bltz	a0,3732 <openiputtest+0x60>
  if(pid == 0){
    36f6:	e939                	bnez	a0,374c <openiputtest+0x7a>
    int fd = open("oidir", O_RDWR);
    36f8:	4589                	li	a1,2
    36fa:	00004517          	auipc	a0,0x4
    36fe:	95e50513          	addi	a0,a0,-1698 # 7058 <malloc+0x1b4c>
    3702:	145010ef          	jal	5046 <open>
    if(fd >= 0){
    3706:	04054063          	bltz	a0,3746 <openiputtest+0x74>
      printf("%s: open directory for write succeeded\n", s);
    370a:	85a6                	mv	a1,s1
    370c:	00004517          	auipc	a0,0x4
    3710:	96c50513          	addi	a0,a0,-1684 # 7078 <malloc+0x1b6c>
    3714:	541010ef          	jal	5454 <printf>
      exit(1);
    3718:	4505                	li	a0,1
    371a:	0ed010ef          	jal	5006 <exit>
    printf("%s: mkdir oidir failed\n", s);
    371e:	85a6                	mv	a1,s1
    3720:	00004517          	auipc	a0,0x4
    3724:	94050513          	addi	a0,a0,-1728 # 7060 <malloc+0x1b54>
    3728:	52d010ef          	jal	5454 <printf>
    exit(1);
    372c:	4505                	li	a0,1
    372e:	0d9010ef          	jal	5006 <exit>
    printf("%s: fork failed\n", s);
    3732:	85a6                	mv	a1,s1
    3734:	00002517          	auipc	a0,0x2
    3738:	79450513          	addi	a0,a0,1940 # 5ec8 <malloc+0x9bc>
    373c:	519010ef          	jal	5454 <printf>
    exit(1);
    3740:	4505                	li	a0,1
    3742:	0c5010ef          	jal	5006 <exit>
    exit(0);
    3746:	4501                	li	a0,0
    3748:	0bf010ef          	jal	5006 <exit>
  pause(1);
    374c:	4505                	li	a0,1
    374e:	149010ef          	jal	5096 <pause>
  if(unlink("oidir") != 0){
    3752:	00004517          	auipc	a0,0x4
    3756:	90650513          	addi	a0,a0,-1786 # 7058 <malloc+0x1b4c>
    375a:	0fd010ef          	jal	5056 <unlink>
    375e:	c919                	beqz	a0,3774 <openiputtest+0xa2>
    printf("%s: unlink failed\n", s);
    3760:	85a6                	mv	a1,s1
    3762:	00003517          	auipc	a0,0x3
    3766:	95650513          	addi	a0,a0,-1706 # 60b8 <malloc+0xbac>
    376a:	4eb010ef          	jal	5454 <printf>
    exit(1);
    376e:	4505                	li	a0,1
    3770:	097010ef          	jal	5006 <exit>
  wait(&xstatus);
    3774:	fdc40513          	addi	a0,s0,-36
    3778:	097010ef          	jal	500e <wait>
  exit(xstatus);
    377c:	fdc42503          	lw	a0,-36(s0)
    3780:	087010ef          	jal	5006 <exit>

0000000000003784 <forkforkfork>:
{
    3784:	1101                	addi	sp,sp,-32
    3786:	ec06                	sd	ra,24(sp)
    3788:	e822                	sd	s0,16(sp)
    378a:	e426                	sd	s1,8(sp)
    378c:	1000                	addi	s0,sp,32
    378e:	84aa                	mv	s1,a0
  unlink("stopforking");
    3790:	00004517          	auipc	a0,0x4
    3794:	91050513          	addi	a0,a0,-1776 # 70a0 <malloc+0x1b94>
    3798:	0bf010ef          	jal	5056 <unlink>
  int pid = fork();
    379c:	063010ef          	jal	4ffe <fork>
  if(pid < 0){
    37a0:	02054b63          	bltz	a0,37d6 <forkforkfork+0x52>
  if(pid == 0){
    37a4:	c139                	beqz	a0,37ea <forkforkfork+0x66>
  pause(20); // two seconds
    37a6:	4551                	li	a0,20
    37a8:	0ef010ef          	jal	5096 <pause>
  close(open("stopforking", O_CREATE|O_RDWR));
    37ac:	20200593          	li	a1,514
    37b0:	00004517          	auipc	a0,0x4
    37b4:	8f050513          	addi	a0,a0,-1808 # 70a0 <malloc+0x1b94>
    37b8:	08f010ef          	jal	5046 <open>
    37bc:	073010ef          	jal	502e <close>
  wait(0);
    37c0:	4501                	li	a0,0
    37c2:	04d010ef          	jal	500e <wait>
  pause(10); // one second
    37c6:	4529                	li	a0,10
    37c8:	0cf010ef          	jal	5096 <pause>
}
    37cc:	60e2                	ld	ra,24(sp)
    37ce:	6442                	ld	s0,16(sp)
    37d0:	64a2                	ld	s1,8(sp)
    37d2:	6105                	addi	sp,sp,32
    37d4:	8082                	ret
    printf("%s: fork failed", s);
    37d6:	85a6                	mv	a1,s1
    37d8:	00003517          	auipc	a0,0x3
    37dc:	8b050513          	addi	a0,a0,-1872 # 6088 <malloc+0xb7c>
    37e0:	475010ef          	jal	5454 <printf>
    exit(1);
    37e4:	4505                	li	a0,1
    37e6:	021010ef          	jal	5006 <exit>
      int fd = open("stopforking", 0);
    37ea:	4581                	li	a1,0
    37ec:	00004517          	auipc	a0,0x4
    37f0:	8b450513          	addi	a0,a0,-1868 # 70a0 <malloc+0x1b94>
    37f4:	053010ef          	jal	5046 <open>
      if(fd >= 0){
    37f8:	02055163          	bgez	a0,381a <forkforkfork+0x96>
      if(fork() < 0){
    37fc:	003010ef          	jal	4ffe <fork>
    3800:	fe0555e3          	bgez	a0,37ea <forkforkfork+0x66>
        close(open("stopforking", O_CREATE|O_RDWR));
    3804:	20200593          	li	a1,514
    3808:	00004517          	auipc	a0,0x4
    380c:	89850513          	addi	a0,a0,-1896 # 70a0 <malloc+0x1b94>
    3810:	037010ef          	jal	5046 <open>
    3814:	01b010ef          	jal	502e <close>
    3818:	bfc9                	j	37ea <forkforkfork+0x66>
        exit(0);
    381a:	4501                	li	a0,0
    381c:	7ea010ef          	jal	5006 <exit>

0000000000003820 <killstatus>:
{
    3820:	715d                	addi	sp,sp,-80
    3822:	e486                	sd	ra,72(sp)
    3824:	e0a2                	sd	s0,64(sp)
    3826:	fc26                	sd	s1,56(sp)
    3828:	f84a                	sd	s2,48(sp)
    382a:	f44e                	sd	s3,40(sp)
    382c:	f052                	sd	s4,32(sp)
    382e:	ec56                	sd	s5,24(sp)
    3830:	e85a                	sd	s6,16(sp)
    3832:	0880                	addi	s0,sp,80
    3834:	8b2a                	mv	s6,a0
    3836:	06400913          	li	s2,100
    pause(1);
    383a:	4a85                	li	s5,1
    wait(&xst);
    383c:	fbc40a13          	addi	s4,s0,-68
    if(xst != -1) {
    3840:	59fd                	li	s3,-1
    int pid1 = fork();
    3842:	7bc010ef          	jal	4ffe <fork>
    3846:	84aa                	mv	s1,a0
    if(pid1 < 0){
    3848:	02054663          	bltz	a0,3874 <killstatus+0x54>
    if(pid1 == 0){
    384c:	cd15                	beqz	a0,3888 <killstatus+0x68>
    pause(1);
    384e:	8556                	mv	a0,s5
    3850:	047010ef          	jal	5096 <pause>
    kill(pid1);
    3854:	8526                	mv	a0,s1
    3856:	7e0010ef          	jal	5036 <kill>
    wait(&xst);
    385a:	8552                	mv	a0,s4
    385c:	7b2010ef          	jal	500e <wait>
    if(xst != -1) {
    3860:	fbc42783          	lw	a5,-68(s0)
    3864:	03379563          	bne	a5,s3,388e <killstatus+0x6e>
  for(int i = 0; i < 100; i++){
    3868:	397d                	addiw	s2,s2,-1
    386a:	fc091ce3          	bnez	s2,3842 <killstatus+0x22>
  exit(0);
    386e:	4501                	li	a0,0
    3870:	796010ef          	jal	5006 <exit>
      printf("%s: fork failed\n", s);
    3874:	85da                	mv	a1,s6
    3876:	00002517          	auipc	a0,0x2
    387a:	65250513          	addi	a0,a0,1618 # 5ec8 <malloc+0x9bc>
    387e:	3d7010ef          	jal	5454 <printf>
      exit(1);
    3882:	4505                	li	a0,1
    3884:	782010ef          	jal	5006 <exit>
        getpid();
    3888:	7fe010ef          	jal	5086 <getpid>
      while(1) {
    388c:	bff5                	j	3888 <killstatus+0x68>
       printf("%s: status should be -1\n", s);
    388e:	85da                	mv	a1,s6
    3890:	00004517          	auipc	a0,0x4
    3894:	82050513          	addi	a0,a0,-2016 # 70b0 <malloc+0x1ba4>
    3898:	3bd010ef          	jal	5454 <printf>
       exit(1);
    389c:	4505                	li	a0,1
    389e:	768010ef          	jal	5006 <exit>

00000000000038a2 <preempt>:
{
    38a2:	7139                	addi	sp,sp,-64
    38a4:	fc06                	sd	ra,56(sp)
    38a6:	f822                	sd	s0,48(sp)
    38a8:	f426                	sd	s1,40(sp)
    38aa:	f04a                	sd	s2,32(sp)
    38ac:	ec4e                	sd	s3,24(sp)
    38ae:	e852                	sd	s4,16(sp)
    38b0:	0080                	addi	s0,sp,64
    38b2:	892a                	mv	s2,a0
  pid1 = fork();
    38b4:	74a010ef          	jal	4ffe <fork>
  if(pid1 < 0) {
    38b8:	00054563          	bltz	a0,38c2 <preempt+0x20>
    38bc:	84aa                	mv	s1,a0
  if(pid1 == 0)
    38be:	ed01                	bnez	a0,38d6 <preempt+0x34>
    for(;;)
    38c0:	a001                	j	38c0 <preempt+0x1e>
    printf("%s: fork failed", s);
    38c2:	85ca                	mv	a1,s2
    38c4:	00002517          	auipc	a0,0x2
    38c8:	7c450513          	addi	a0,a0,1988 # 6088 <malloc+0xb7c>
    38cc:	389010ef          	jal	5454 <printf>
    exit(1);
    38d0:	4505                	li	a0,1
    38d2:	734010ef          	jal	5006 <exit>
  pid2 = fork();
    38d6:	728010ef          	jal	4ffe <fork>
    38da:	89aa                	mv	s3,a0
  if(pid2 < 0) {
    38dc:	00054463          	bltz	a0,38e4 <preempt+0x42>
  if(pid2 == 0)
    38e0:	ed01                	bnez	a0,38f8 <preempt+0x56>
    for(;;)
    38e2:	a001                	j	38e2 <preempt+0x40>
    printf("%s: fork failed\n", s);
    38e4:	85ca                	mv	a1,s2
    38e6:	00002517          	auipc	a0,0x2
    38ea:	5e250513          	addi	a0,a0,1506 # 5ec8 <malloc+0x9bc>
    38ee:	367010ef          	jal	5454 <printf>
    exit(1);
    38f2:	4505                	li	a0,1
    38f4:	712010ef          	jal	5006 <exit>
  pipe(pfds);
    38f8:	fc840513          	addi	a0,s0,-56
    38fc:	71a010ef          	jal	5016 <pipe>
  pid3 = fork();
    3900:	6fe010ef          	jal	4ffe <fork>
    3904:	8a2a                	mv	s4,a0
  if(pid3 < 0) {
    3906:	02054863          	bltz	a0,3936 <preempt+0x94>
  if(pid3 == 0){
    390a:	e921                	bnez	a0,395a <preempt+0xb8>
    close(pfds[0]);
    390c:	fc842503          	lw	a0,-56(s0)
    3910:	71e010ef          	jal	502e <close>
    if(write(pfds[1], "x", 1) != 1)
    3914:	4605                	li	a2,1
    3916:	00002597          	auipc	a1,0x2
    391a:	d9258593          	addi	a1,a1,-622 # 56a8 <malloc+0x19c>
    391e:	fcc42503          	lw	a0,-52(s0)
    3922:	704010ef          	jal	5026 <write>
    3926:	4785                	li	a5,1
    3928:	02f51163          	bne	a0,a5,394a <preempt+0xa8>
    close(pfds[1]);
    392c:	fcc42503          	lw	a0,-52(s0)
    3930:	6fe010ef          	jal	502e <close>
    for(;;)
    3934:	a001                	j	3934 <preempt+0x92>
     printf("%s: fork failed\n", s);
    3936:	85ca                	mv	a1,s2
    3938:	00002517          	auipc	a0,0x2
    393c:	59050513          	addi	a0,a0,1424 # 5ec8 <malloc+0x9bc>
    3940:	315010ef          	jal	5454 <printf>
     exit(1);
    3944:	4505                	li	a0,1
    3946:	6c0010ef          	jal	5006 <exit>
      printf("%s: preempt write error", s);
    394a:	85ca                	mv	a1,s2
    394c:	00003517          	auipc	a0,0x3
    3950:	78450513          	addi	a0,a0,1924 # 70d0 <malloc+0x1bc4>
    3954:	301010ef          	jal	5454 <printf>
    3958:	bfd1                	j	392c <preempt+0x8a>
  close(pfds[1]);
    395a:	fcc42503          	lw	a0,-52(s0)
    395e:	6d0010ef          	jal	502e <close>
  if(read(pfds[0], buf, sizeof(buf)) != 1){
    3962:	660d                	lui	a2,0x3
    3964:	0000a597          	auipc	a1,0xa
    3968:	35458593          	addi	a1,a1,852 # dcb8 <buf>
    396c:	fc842503          	lw	a0,-56(s0)
    3970:	6ae010ef          	jal	501e <read>
    3974:	4785                	li	a5,1
    3976:	02f50163          	beq	a0,a5,3998 <preempt+0xf6>
    printf("%s: preempt read error", s);
    397a:	85ca                	mv	a1,s2
    397c:	00003517          	auipc	a0,0x3
    3980:	76c50513          	addi	a0,a0,1900 # 70e8 <malloc+0x1bdc>
    3984:	2d1010ef          	jal	5454 <printf>
}
    3988:	70e2                	ld	ra,56(sp)
    398a:	7442                	ld	s0,48(sp)
    398c:	74a2                	ld	s1,40(sp)
    398e:	7902                	ld	s2,32(sp)
    3990:	69e2                	ld	s3,24(sp)
    3992:	6a42                	ld	s4,16(sp)
    3994:	6121                	addi	sp,sp,64
    3996:	8082                	ret
  close(pfds[0]);
    3998:	fc842503          	lw	a0,-56(s0)
    399c:	692010ef          	jal	502e <close>
  printf("kill... ");
    39a0:	00003517          	auipc	a0,0x3
    39a4:	76050513          	addi	a0,a0,1888 # 7100 <malloc+0x1bf4>
    39a8:	2ad010ef          	jal	5454 <printf>
  kill(pid1);
    39ac:	8526                	mv	a0,s1
    39ae:	688010ef          	jal	5036 <kill>
  kill(pid2);
    39b2:	854e                	mv	a0,s3
    39b4:	682010ef          	jal	5036 <kill>
  kill(pid3);
    39b8:	8552                	mv	a0,s4
    39ba:	67c010ef          	jal	5036 <kill>
  printf("wait... ");
    39be:	00003517          	auipc	a0,0x3
    39c2:	75250513          	addi	a0,a0,1874 # 7110 <malloc+0x1c04>
    39c6:	28f010ef          	jal	5454 <printf>
  wait(0);
    39ca:	4501                	li	a0,0
    39cc:	642010ef          	jal	500e <wait>
  wait(0);
    39d0:	4501                	li	a0,0
    39d2:	63c010ef          	jal	500e <wait>
  wait(0);
    39d6:	4501                	li	a0,0
    39d8:	636010ef          	jal	500e <wait>
    39dc:	b775                	j	3988 <preempt+0xe6>

00000000000039de <reparent>:
{
    39de:	7179                	addi	sp,sp,-48
    39e0:	f406                	sd	ra,40(sp)
    39e2:	f022                	sd	s0,32(sp)
    39e4:	ec26                	sd	s1,24(sp)
    39e6:	e84a                	sd	s2,16(sp)
    39e8:	e44e                	sd	s3,8(sp)
    39ea:	e052                	sd	s4,0(sp)
    39ec:	1800                	addi	s0,sp,48
    39ee:	89aa                	mv	s3,a0
  int master_pid = getpid();
    39f0:	696010ef          	jal	5086 <getpid>
    39f4:	8a2a                	mv	s4,a0
    39f6:	0c800913          	li	s2,200
    int pid = fork();
    39fa:	604010ef          	jal	4ffe <fork>
    39fe:	84aa                	mv	s1,a0
    if(pid < 0){
    3a00:	00054e63          	bltz	a0,3a1c <reparent+0x3e>
    if(pid){
    3a04:	c121                	beqz	a0,3a44 <reparent+0x66>
      if(wait(0) != pid){
    3a06:	4501                	li	a0,0
    3a08:	606010ef          	jal	500e <wait>
    3a0c:	02951263          	bne	a0,s1,3a30 <reparent+0x52>
  for(int i = 0; i < 200; i++){
    3a10:	397d                	addiw	s2,s2,-1
    3a12:	fe0914e3          	bnez	s2,39fa <reparent+0x1c>
  exit(0);
    3a16:	4501                	li	a0,0
    3a18:	5ee010ef          	jal	5006 <exit>
      printf("%s: fork failed\n", s);
    3a1c:	85ce                	mv	a1,s3
    3a1e:	00002517          	auipc	a0,0x2
    3a22:	4aa50513          	addi	a0,a0,1194 # 5ec8 <malloc+0x9bc>
    3a26:	22f010ef          	jal	5454 <printf>
      exit(1);
    3a2a:	4505                	li	a0,1
    3a2c:	5da010ef          	jal	5006 <exit>
        printf("%s: wait wrong pid\n", s);
    3a30:	85ce                	mv	a1,s3
    3a32:	00002517          	auipc	a0,0x2
    3a36:	61e50513          	addi	a0,a0,1566 # 6050 <malloc+0xb44>
    3a3a:	21b010ef          	jal	5454 <printf>
        exit(1);
    3a3e:	4505                	li	a0,1
    3a40:	5c6010ef          	jal	5006 <exit>
      int pid2 = fork();
    3a44:	5ba010ef          	jal	4ffe <fork>
      if(pid2 < 0){
    3a48:	00054563          	bltz	a0,3a52 <reparent+0x74>
      exit(0);
    3a4c:	4501                	li	a0,0
    3a4e:	5b8010ef          	jal	5006 <exit>
        kill(master_pid);
    3a52:	8552                	mv	a0,s4
    3a54:	5e2010ef          	jal	5036 <kill>
        exit(1);
    3a58:	4505                	li	a0,1
    3a5a:	5ac010ef          	jal	5006 <exit>

0000000000003a5e <sbrkfail>:
{
    3a5e:	7175                	addi	sp,sp,-144
    3a60:	e506                	sd	ra,136(sp)
    3a62:	e122                	sd	s0,128(sp)
    3a64:	fca6                	sd	s1,120(sp)
    3a66:	f8ca                	sd	s2,112(sp)
    3a68:	f4ce                	sd	s3,104(sp)
    3a6a:	f0d2                	sd	s4,96(sp)
    3a6c:	ecd6                	sd	s5,88(sp)
    3a6e:	e8da                	sd	s6,80(sp)
    3a70:	e4de                	sd	s7,72(sp)
    3a72:	e0e2                	sd	s8,64(sp)
    3a74:	0900                	addi	s0,sp,144
    3a76:	8c2a                	mv	s8,a0
  if(pipe(fds) != 0){
    3a78:	fa040513          	addi	a0,s0,-96
    3a7c:	59a010ef          	jal	5016 <pipe>
    3a80:	ed01                	bnez	a0,3a98 <sbrkfail+0x3a>
    3a82:	8baa                	mv	s7,a0
    3a84:	f7040493          	addi	s1,s0,-144
    3a88:	f9840993          	addi	s3,s0,-104
    3a8c:	8926                	mv	s2,s1
    if(pids[i] != -1) {
    3a8e:	5a7d                	li	s4,-1
      read(fds[0], &scratch, 1);
    3a90:	f9f40b13          	addi	s6,s0,-97
    3a94:	4a85                	li	s5,1
    3a96:	a095                	j	3afa <sbrkfail+0x9c>
    printf("%s: pipe() failed\n", s);
    3a98:	85e2                	mv	a1,s8
    3a9a:	00002517          	auipc	a0,0x2
    3a9e:	53650513          	addi	a0,a0,1334 # 5fd0 <malloc+0xac4>
    3aa2:	1b3010ef          	jal	5454 <printf>
    exit(1);
    3aa6:	4505                	li	a0,1
    3aa8:	55e010ef          	jal	5006 <exit>
      if (sbrk(BIG - (uint64)sbrk(0)) ==  (char*)SBRK_ERROR)
    3aac:	526010ef          	jal	4fd2 <sbrk>
    3ab0:	064007b7          	lui	a5,0x6400
    3ab4:	40a7853b          	subw	a0,a5,a0
    3ab8:	51a010ef          	jal	4fd2 <sbrk>
    3abc:	57fd                	li	a5,-1
    3abe:	02f50163          	beq	a0,a5,3ae0 <sbrkfail+0x82>
        write(fds[1], "1", 1);
    3ac2:	4605                	li	a2,1
    3ac4:	00004597          	auipc	a1,0x4
    3ac8:	dd458593          	addi	a1,a1,-556 # 7898 <malloc+0x238c>
    3acc:	fa442503          	lw	a0,-92(s0)
    3ad0:	556010ef          	jal	5026 <write>
      for(;;) pause(1000);
    3ad4:	3e800493          	li	s1,1000
    3ad8:	8526                	mv	a0,s1
    3ada:	5bc010ef          	jal	5096 <pause>
    3ade:	bfed                	j	3ad8 <sbrkfail+0x7a>
        write(fds[1], "0", 1);
    3ae0:	4605                	li	a2,1
    3ae2:	00003597          	auipc	a1,0x3
    3ae6:	63e58593          	addi	a1,a1,1598 # 7120 <malloc+0x1c14>
    3aea:	fa442503          	lw	a0,-92(s0)
    3aee:	538010ef          	jal	5026 <write>
    3af2:	b7cd                	j	3ad4 <sbrkfail+0x76>
  for(i = 0; i < sizeof(pids)/sizeof(pids[0]); i++){
    3af4:	0911                	addi	s2,s2,4
    3af6:	03390a63          	beq	s2,s3,3b2a <sbrkfail+0xcc>
    if((pids[i] = fork()) == 0){
    3afa:	504010ef          	jal	4ffe <fork>
    3afe:	00a92023          	sw	a0,0(s2)
    3b02:	d54d                	beqz	a0,3aac <sbrkfail+0x4e>
    if(pids[i] != -1) {
    3b04:	ff4508e3          	beq	a0,s4,3af4 <sbrkfail+0x96>
      read(fds[0], &scratch, 1);
    3b08:	8656                	mv	a2,s5
    3b0a:	85da                	mv	a1,s6
    3b0c:	fa042503          	lw	a0,-96(s0)
    3b10:	50e010ef          	jal	501e <read>
      if(scratch == '0')
    3b14:	f9f44783          	lbu	a5,-97(s0)
    3b18:	fd078793          	addi	a5,a5,-48 # 63fffd0 <base+0x63ef318>
    3b1c:	0017b793          	seqz	a5,a5
    3b20:	00fbe7b3          	or	a5,s7,a5
    3b24:	00078b9b          	sext.w	s7,a5
    3b28:	b7f1                	j	3af4 <sbrkfail+0x96>
  if(!failed) {
    3b2a:	000b8863          	beqz	s7,3b3a <sbrkfail+0xdc>
  c = sbrk(PGSIZE);
    3b2e:	6505                	lui	a0,0x1
    3b30:	4a2010ef          	jal	4fd2 <sbrk>
    3b34:	8a2a                	mv	s4,a0
    if(pids[i] == -1)
    3b36:	597d                	li	s2,-1
    3b38:	a821                	j	3b50 <sbrkfail+0xf2>
    printf("%s: no allocation failed; allocate more?\n", s);
    3b3a:	85e2                	mv	a1,s8
    3b3c:	00003517          	auipc	a0,0x3
    3b40:	5ec50513          	addi	a0,a0,1516 # 7128 <malloc+0x1c1c>
    3b44:	111010ef          	jal	5454 <printf>
    3b48:	b7dd                	j	3b2e <sbrkfail+0xd0>
  for(i = 0; i < sizeof(pids)/sizeof(pids[0]); i++){
    3b4a:	0491                	addi	s1,s1,4
    3b4c:	01348b63          	beq	s1,s3,3b62 <sbrkfail+0x104>
    if(pids[i] == -1)
    3b50:	4088                	lw	a0,0(s1)
    3b52:	ff250ce3          	beq	a0,s2,3b4a <sbrkfail+0xec>
    kill(pids[i]);
    3b56:	4e0010ef          	jal	5036 <kill>
    wait(0);
    3b5a:	4501                	li	a0,0
    3b5c:	4b2010ef          	jal	500e <wait>
    3b60:	b7ed                	j	3b4a <sbrkfail+0xec>
  if(c == (char*)SBRK_ERROR){
    3b62:	57fd                	li	a5,-1
    3b64:	02fa0a63          	beq	s4,a5,3b98 <sbrkfail+0x13a>
  pid = fork();
    3b68:	496010ef          	jal	4ffe <fork>
  if(pid < 0){
    3b6c:	04054063          	bltz	a0,3bac <sbrkfail+0x14e>
  if(pid == 0){
    3b70:	e939                	bnez	a0,3bc6 <sbrkfail+0x168>
    a = sbrk(10*BIG);
    3b72:	3e800537          	lui	a0,0x3e800
    3b76:	45c010ef          	jal	4fd2 <sbrk>
    if(a == (char*)SBRK_ERROR){
    3b7a:	57fd                	li	a5,-1
    3b7c:	04f50263          	beq	a0,a5,3bc0 <sbrkfail+0x162>
    printf("%s: allocate a lot of memory succeeded %d\n", s, 10*BIG);
    3b80:	3e800637          	lui	a2,0x3e800
    3b84:	85e2                	mv	a1,s8
    3b86:	00003517          	auipc	a0,0x3
    3b8a:	5f250513          	addi	a0,a0,1522 # 7178 <malloc+0x1c6c>
    3b8e:	0c7010ef          	jal	5454 <printf>
    exit(1);
    3b92:	4505                	li	a0,1
    3b94:	472010ef          	jal	5006 <exit>
    printf("%s: failed sbrk leaked memory\n", s);
    3b98:	85e2                	mv	a1,s8
    3b9a:	00003517          	auipc	a0,0x3
    3b9e:	5be50513          	addi	a0,a0,1470 # 7158 <malloc+0x1c4c>
    3ba2:	0b3010ef          	jal	5454 <printf>
    exit(1);
    3ba6:	4505                	li	a0,1
    3ba8:	45e010ef          	jal	5006 <exit>
    printf("%s: fork failed\n", s);
    3bac:	85e2                	mv	a1,s8
    3bae:	00002517          	auipc	a0,0x2
    3bb2:	31a50513          	addi	a0,a0,794 # 5ec8 <malloc+0x9bc>
    3bb6:	09f010ef          	jal	5454 <printf>
    exit(1);
    3bba:	4505                	li	a0,1
    3bbc:	44a010ef          	jal	5006 <exit>
      exit(0);
    3bc0:	4501                	li	a0,0
    3bc2:	444010ef          	jal	5006 <exit>
  wait(&xstatus);
    3bc6:	fac40513          	addi	a0,s0,-84
    3bca:	444010ef          	jal	500e <wait>
  if(xstatus != 0)
    3bce:	fac42783          	lw	a5,-84(s0)
    3bd2:	ef89                	bnez	a5,3bec <sbrkfail+0x18e>
}
    3bd4:	60aa                	ld	ra,136(sp)
    3bd6:	640a                	ld	s0,128(sp)
    3bd8:	74e6                	ld	s1,120(sp)
    3bda:	7946                	ld	s2,112(sp)
    3bdc:	79a6                	ld	s3,104(sp)
    3bde:	7a06                	ld	s4,96(sp)
    3be0:	6ae6                	ld	s5,88(sp)
    3be2:	6b46                	ld	s6,80(sp)
    3be4:	6ba6                	ld	s7,72(sp)
    3be6:	6c06                	ld	s8,64(sp)
    3be8:	6149                	addi	sp,sp,144
    3bea:	8082                	ret
    exit(1);
    3bec:	4505                	li	a0,1
    3bee:	418010ef          	jal	5006 <exit>

0000000000003bf2 <mem>:
{
    3bf2:	7139                	addi	sp,sp,-64
    3bf4:	fc06                	sd	ra,56(sp)
    3bf6:	f822                	sd	s0,48(sp)
    3bf8:	f426                	sd	s1,40(sp)
    3bfa:	f04a                	sd	s2,32(sp)
    3bfc:	ec4e                	sd	s3,24(sp)
    3bfe:	0080                	addi	s0,sp,64
    3c00:	89aa                	mv	s3,a0
  if((pid = fork()) == 0){
    3c02:	3fc010ef          	jal	4ffe <fork>
    m1 = 0;
    3c06:	4481                	li	s1,0
    while((m2 = malloc(10001)) != 0){
    3c08:	6909                	lui	s2,0x2
    3c0a:	71190913          	addi	s2,s2,1809 # 2711 <execout+0x27>
  if((pid = fork()) == 0){
    3c0e:	cd11                	beqz	a0,3c2a <mem+0x38>
    wait(&xstatus);
    3c10:	fcc40513          	addi	a0,s0,-52
    3c14:	3fa010ef          	jal	500e <wait>
    if(xstatus == -1){
    3c18:	fcc42503          	lw	a0,-52(s0)
    3c1c:	57fd                	li	a5,-1
    3c1e:	04f50363          	beq	a0,a5,3c64 <mem+0x72>
    exit(xstatus);
    3c22:	3e4010ef          	jal	5006 <exit>
      *(char**)m2 = m1;
    3c26:	e104                	sd	s1,0(a0)
      m1 = m2;
    3c28:	84aa                	mv	s1,a0
    while((m2 = malloc(10001)) != 0){
    3c2a:	854a                	mv	a0,s2
    3c2c:	0e1010ef          	jal	550c <malloc>
    3c30:	f97d                	bnez	a0,3c26 <mem+0x34>
    while(m1){
    3c32:	c491                	beqz	s1,3c3e <mem+0x4c>
      m2 = *(char**)m1;
    3c34:	8526                	mv	a0,s1
    3c36:	6084                	ld	s1,0(s1)
      free(m1);
    3c38:	04f010ef          	jal	5486 <free>
    while(m1){
    3c3c:	fce5                	bnez	s1,3c34 <mem+0x42>
    m1 = malloc(1024*20);
    3c3e:	6515                	lui	a0,0x5
    3c40:	0cd010ef          	jal	550c <malloc>
    if(m1 == 0){
    3c44:	c511                	beqz	a0,3c50 <mem+0x5e>
    free(m1);
    3c46:	041010ef          	jal	5486 <free>
    exit(0);
    3c4a:	4501                	li	a0,0
    3c4c:	3ba010ef          	jal	5006 <exit>
      printf("%s: couldn't allocate mem?!!\n", s);
    3c50:	85ce                	mv	a1,s3
    3c52:	00003517          	auipc	a0,0x3
    3c56:	55650513          	addi	a0,a0,1366 # 71a8 <malloc+0x1c9c>
    3c5a:	7fa010ef          	jal	5454 <printf>
      exit(1);
    3c5e:	4505                	li	a0,1
    3c60:	3a6010ef          	jal	5006 <exit>
      exit(0);
    3c64:	4501                	li	a0,0
    3c66:	3a0010ef          	jal	5006 <exit>

0000000000003c6a <sharedfd>:
{
    3c6a:	7159                	addi	sp,sp,-112
    3c6c:	f486                	sd	ra,104(sp)
    3c6e:	f0a2                	sd	s0,96(sp)
    3c70:	eca6                	sd	s1,88(sp)
    3c72:	f85a                	sd	s6,48(sp)
    3c74:	1880                	addi	s0,sp,112
    3c76:	84aa                	mv	s1,a0
    3c78:	8b2a                	mv	s6,a0
  unlink("sharedfd");
    3c7a:	00003517          	auipc	a0,0x3
    3c7e:	54e50513          	addi	a0,a0,1358 # 71c8 <malloc+0x1cbc>
    3c82:	3d4010ef          	jal	5056 <unlink>
  fd = open("sharedfd", O_CREATE|O_RDWR);
    3c86:	20200593          	li	a1,514
    3c8a:	00003517          	auipc	a0,0x3
    3c8e:	53e50513          	addi	a0,a0,1342 # 71c8 <malloc+0x1cbc>
    3c92:	3b4010ef          	jal	5046 <open>
  if(fd < 0){
    3c96:	04054863          	bltz	a0,3ce6 <sharedfd+0x7c>
    3c9a:	e8ca                	sd	s2,80(sp)
    3c9c:	e4ce                	sd	s3,72(sp)
    3c9e:	e0d2                	sd	s4,64(sp)
    3ca0:	fc56                	sd	s5,56(sp)
    3ca2:	89aa                	mv	s3,a0
  pid = fork();
    3ca4:	35a010ef          	jal	4ffe <fork>
    3ca8:	8aaa                	mv	s5,a0
  memset(buf, pid==0?'c':'p', sizeof(buf));
    3caa:	07000593          	li	a1,112
    3cae:	e119                	bnez	a0,3cb4 <sharedfd+0x4a>
    3cb0:	06300593          	li	a1,99
    3cb4:	4629                	li	a2,10
    3cb6:	fa040513          	addi	a0,s0,-96
    3cba:	122010ef          	jal	4ddc <memset>
    3cbe:	3e800493          	li	s1,1000
    if(write(fd, buf, sizeof(buf)) != sizeof(buf)){
    3cc2:	fa040a13          	addi	s4,s0,-96
    3cc6:	4929                	li	s2,10
    3cc8:	864a                	mv	a2,s2
    3cca:	85d2                	mv	a1,s4
    3ccc:	854e                	mv	a0,s3
    3cce:	358010ef          	jal	5026 <write>
    3cd2:	03251963          	bne	a0,s2,3d04 <sharedfd+0x9a>
  for(i = 0; i < N; i++){
    3cd6:	34fd                	addiw	s1,s1,-1
    3cd8:	f8e5                	bnez	s1,3cc8 <sharedfd+0x5e>
  if(pid == 0) {
    3cda:	040a9063          	bnez	s5,3d1a <sharedfd+0xb0>
    3cde:	f45e                	sd	s7,40(sp)
    exit(0);
    3ce0:	4501                	li	a0,0
    3ce2:	324010ef          	jal	5006 <exit>
    3ce6:	e8ca                	sd	s2,80(sp)
    3ce8:	e4ce                	sd	s3,72(sp)
    3cea:	e0d2                	sd	s4,64(sp)
    3cec:	fc56                	sd	s5,56(sp)
    3cee:	f45e                	sd	s7,40(sp)
    printf("%s: cannot open sharedfd for writing", s);
    3cf0:	85a6                	mv	a1,s1
    3cf2:	00003517          	auipc	a0,0x3
    3cf6:	4e650513          	addi	a0,a0,1254 # 71d8 <malloc+0x1ccc>
    3cfa:	75a010ef          	jal	5454 <printf>
    exit(1);
    3cfe:	4505                	li	a0,1
    3d00:	306010ef          	jal	5006 <exit>
    3d04:	f45e                	sd	s7,40(sp)
      printf("%s: write sharedfd failed\n", s);
    3d06:	85da                	mv	a1,s6
    3d08:	00003517          	auipc	a0,0x3
    3d0c:	4f850513          	addi	a0,a0,1272 # 7200 <malloc+0x1cf4>
    3d10:	744010ef          	jal	5454 <printf>
      exit(1);
    3d14:	4505                	li	a0,1
    3d16:	2f0010ef          	jal	5006 <exit>
    wait(&xstatus);
    3d1a:	f9c40513          	addi	a0,s0,-100
    3d1e:	2f0010ef          	jal	500e <wait>
    if(xstatus != 0)
    3d22:	f9c42a03          	lw	s4,-100(s0)
    3d26:	000a0663          	beqz	s4,3d32 <sharedfd+0xc8>
    3d2a:	f45e                	sd	s7,40(sp)
      exit(xstatus);
    3d2c:	8552                	mv	a0,s4
    3d2e:	2d8010ef          	jal	5006 <exit>
    3d32:	f45e                	sd	s7,40(sp)
  close(fd);
    3d34:	854e                	mv	a0,s3
    3d36:	2f8010ef          	jal	502e <close>
  fd = open("sharedfd", 0);
    3d3a:	4581                	li	a1,0
    3d3c:	00003517          	auipc	a0,0x3
    3d40:	48c50513          	addi	a0,a0,1164 # 71c8 <malloc+0x1cbc>
    3d44:	302010ef          	jal	5046 <open>
    3d48:	8baa                	mv	s7,a0
  nc = np = 0;
    3d4a:	89d2                	mv	s3,s4
  if(fd < 0){
    3d4c:	02054363          	bltz	a0,3d72 <sharedfd+0x108>
    3d50:	faa40913          	addi	s2,s0,-86
      if(buf[i] == 'c')
    3d54:	06300493          	li	s1,99
      if(buf[i] == 'p')
    3d58:	07000a93          	li	s5,112
  while((n = read(fd, buf, sizeof(buf))) > 0){
    3d5c:	4629                	li	a2,10
    3d5e:	fa040593          	addi	a1,s0,-96
    3d62:	855e                	mv	a0,s7
    3d64:	2ba010ef          	jal	501e <read>
    3d68:	02a05b63          	blez	a0,3d9e <sharedfd+0x134>
    3d6c:	fa040793          	addi	a5,s0,-96
    3d70:	a839                	j	3d8e <sharedfd+0x124>
    printf("%s: cannot open sharedfd for reading\n", s);
    3d72:	85da                	mv	a1,s6
    3d74:	00003517          	auipc	a0,0x3
    3d78:	4ac50513          	addi	a0,a0,1196 # 7220 <malloc+0x1d14>
    3d7c:	6d8010ef          	jal	5454 <printf>
    exit(1);
    3d80:	4505                	li	a0,1
    3d82:	284010ef          	jal	5006 <exit>
        nc++;
    3d86:	2a05                	addiw	s4,s4,1 # 1001 <bigdir+0x10d>
    for(i = 0; i < sizeof(buf); i++){
    3d88:	0785                	addi	a5,a5,1
    3d8a:	fd2789e3          	beq	a5,s2,3d5c <sharedfd+0xf2>
      if(buf[i] == 'c')
    3d8e:	0007c703          	lbu	a4,0(a5)
    3d92:	fe970ae3          	beq	a4,s1,3d86 <sharedfd+0x11c>
      if(buf[i] == 'p')
    3d96:	ff5719e3          	bne	a4,s5,3d88 <sharedfd+0x11e>
        np++;
    3d9a:	2985                	addiw	s3,s3,1
    3d9c:	b7f5                	j	3d88 <sharedfd+0x11e>
  close(fd);
    3d9e:	855e                	mv	a0,s7
    3da0:	28e010ef          	jal	502e <close>
  unlink("sharedfd");
    3da4:	00003517          	auipc	a0,0x3
    3da8:	42450513          	addi	a0,a0,1060 # 71c8 <malloc+0x1cbc>
    3dac:	2aa010ef          	jal	5056 <unlink>
  if(nc == N*SZ && np == N*SZ){
    3db0:	6789                	lui	a5,0x2
    3db2:	71078793          	addi	a5,a5,1808 # 2710 <execout+0x26>
    3db6:	00fa1763          	bne	s4,a5,3dc4 <sharedfd+0x15a>
    3dba:	01499563          	bne	s3,s4,3dc4 <sharedfd+0x15a>
    exit(0);
    3dbe:	4501                	li	a0,0
    3dc0:	246010ef          	jal	5006 <exit>
    printf("%s: nc/np test fails\n", s);
    3dc4:	85da                	mv	a1,s6
    3dc6:	00003517          	auipc	a0,0x3
    3dca:	48250513          	addi	a0,a0,1154 # 7248 <malloc+0x1d3c>
    3dce:	686010ef          	jal	5454 <printf>
    exit(1);
    3dd2:	4505                	li	a0,1
    3dd4:	232010ef          	jal	5006 <exit>

0000000000003dd8 <fourfiles>:
{
    3dd8:	7135                	addi	sp,sp,-160
    3dda:	ed06                	sd	ra,152(sp)
    3ddc:	e922                	sd	s0,144(sp)
    3dde:	e526                	sd	s1,136(sp)
    3de0:	e14a                	sd	s2,128(sp)
    3de2:	fcce                	sd	s3,120(sp)
    3de4:	f8d2                	sd	s4,112(sp)
    3de6:	f4d6                	sd	s5,104(sp)
    3de8:	f0da                	sd	s6,96(sp)
    3dea:	ecde                	sd	s7,88(sp)
    3dec:	e8e2                	sd	s8,80(sp)
    3dee:	e4e6                	sd	s9,72(sp)
    3df0:	e0ea                	sd	s10,64(sp)
    3df2:	fc6e                	sd	s11,56(sp)
    3df4:	1100                	addi	s0,sp,160
    3df6:	8caa                	mv	s9,a0
  char *names[] = { "f0", "f1", "f2", "f3" };
    3df8:	00003797          	auipc	a5,0x3
    3dfc:	46878793          	addi	a5,a5,1128 # 7260 <malloc+0x1d54>
    3e00:	f6f43823          	sd	a5,-144(s0)
    3e04:	00003797          	auipc	a5,0x3
    3e08:	46478793          	addi	a5,a5,1124 # 7268 <malloc+0x1d5c>
    3e0c:	f6f43c23          	sd	a5,-136(s0)
    3e10:	00003797          	auipc	a5,0x3
    3e14:	46078793          	addi	a5,a5,1120 # 7270 <malloc+0x1d64>
    3e18:	f8f43023          	sd	a5,-128(s0)
    3e1c:	00003797          	auipc	a5,0x3
    3e20:	45c78793          	addi	a5,a5,1116 # 7278 <malloc+0x1d6c>
    3e24:	f8f43423          	sd	a5,-120(s0)
  for(pi = 0; pi < NCHILD; pi++){
    3e28:	f7040b93          	addi	s7,s0,-144
  char *names[] = { "f0", "f1", "f2", "f3" };
    3e2c:	895e                	mv	s2,s7
  for(pi = 0; pi < NCHILD; pi++){
    3e2e:	4481                	li	s1,0
    3e30:	4a11                	li	s4,4
    fname = names[pi];
    3e32:	00093983          	ld	s3,0(s2)
    unlink(fname);
    3e36:	854e                	mv	a0,s3
    3e38:	21e010ef          	jal	5056 <unlink>
    pid = fork();
    3e3c:	1c2010ef          	jal	4ffe <fork>
    if(pid < 0){
    3e40:	04054063          	bltz	a0,3e80 <fourfiles+0xa8>
    if(pid == 0){
    3e44:	c921                	beqz	a0,3e94 <fourfiles+0xbc>
  for(pi = 0; pi < NCHILD; pi++){
    3e46:	2485                	addiw	s1,s1,1
    3e48:	0921                	addi	s2,s2,8
    3e4a:	ff4494e3          	bne	s1,s4,3e32 <fourfiles+0x5a>
    3e4e:	4491                	li	s1,4
    wait(&xstatus);
    3e50:	f6c40913          	addi	s2,s0,-148
    3e54:	854a                	mv	a0,s2
    3e56:	1b8010ef          	jal	500e <wait>
    if(xstatus != 0)
    3e5a:	f6c42b03          	lw	s6,-148(s0)
    3e5e:	0a0b1463          	bnez	s6,3f06 <fourfiles+0x12e>
  for(pi = 0; pi < NCHILD; pi++){
    3e62:	34fd                	addiw	s1,s1,-1
    3e64:	f8e5                	bnez	s1,3e54 <fourfiles+0x7c>
    3e66:	03000493          	li	s1,48
    while((n = read(fd, buf, sizeof(buf))) > 0){
    3e6a:	6a8d                	lui	s5,0x3
    3e6c:	0000aa17          	auipc	s4,0xa
    3e70:	e4ca0a13          	addi	s4,s4,-436 # dcb8 <buf>
    if(total != N*SZ){
    3e74:	6d05                	lui	s10,0x1
    3e76:	770d0d13          	addi	s10,s10,1904 # 1770 <exitwait+0x90>
  for(i = 0; i < NCHILD; i++){
    3e7a:	03400d93          	li	s11,52
    3e7e:	a86d                	j	3f38 <fourfiles+0x160>
      printf("%s: fork failed\n", s);
    3e80:	85e6                	mv	a1,s9
    3e82:	00002517          	auipc	a0,0x2
    3e86:	04650513          	addi	a0,a0,70 # 5ec8 <malloc+0x9bc>
    3e8a:	5ca010ef          	jal	5454 <printf>
      exit(1);
    3e8e:	4505                	li	a0,1
    3e90:	176010ef          	jal	5006 <exit>
      fd = open(fname, O_CREATE | O_RDWR);
    3e94:	20200593          	li	a1,514
    3e98:	854e                	mv	a0,s3
    3e9a:	1ac010ef          	jal	5046 <open>
    3e9e:	892a                	mv	s2,a0
      if(fd < 0){
    3ea0:	04054063          	bltz	a0,3ee0 <fourfiles+0x108>
      memset(buf, '0'+pi, SZ);
    3ea4:	1f400613          	li	a2,500
    3ea8:	0304859b          	addiw	a1,s1,48
    3eac:	0000a517          	auipc	a0,0xa
    3eb0:	e0c50513          	addi	a0,a0,-500 # dcb8 <buf>
    3eb4:	729000ef          	jal	4ddc <memset>
    3eb8:	44b1                	li	s1,12
        if((n = write(fd, buf, SZ)) != SZ){
    3eba:	1f400993          	li	s3,500
    3ebe:	0000aa17          	auipc	s4,0xa
    3ec2:	dfaa0a13          	addi	s4,s4,-518 # dcb8 <buf>
    3ec6:	864e                	mv	a2,s3
    3ec8:	85d2                	mv	a1,s4
    3eca:	854a                	mv	a0,s2
    3ecc:	15a010ef          	jal	5026 <write>
    3ed0:	85aa                	mv	a1,a0
    3ed2:	03351163          	bne	a0,s3,3ef4 <fourfiles+0x11c>
      for(i = 0; i < N; i++){
    3ed6:	34fd                	addiw	s1,s1,-1
    3ed8:	f4fd                	bnez	s1,3ec6 <fourfiles+0xee>
      exit(0);
    3eda:	4501                	li	a0,0
    3edc:	12a010ef          	jal	5006 <exit>
        printf("%s: create failed\n", s);
    3ee0:	85e6                	mv	a1,s9
    3ee2:	00002517          	auipc	a0,0x2
    3ee6:	07e50513          	addi	a0,a0,126 # 5f60 <malloc+0xa54>
    3eea:	56a010ef          	jal	5454 <printf>
        exit(1);
    3eee:	4505                	li	a0,1
    3ef0:	116010ef          	jal	5006 <exit>
          printf("write failed %d\n", n);
    3ef4:	00003517          	auipc	a0,0x3
    3ef8:	38c50513          	addi	a0,a0,908 # 7280 <malloc+0x1d74>
    3efc:	558010ef          	jal	5454 <printf>
          exit(1);
    3f00:	4505                	li	a0,1
    3f02:	104010ef          	jal	5006 <exit>
      exit(xstatus);
    3f06:	855a                	mv	a0,s6
    3f08:	0fe010ef          	jal	5006 <exit>
          printf("%s: wrong char\n", s);
    3f0c:	85e6                	mv	a1,s9
    3f0e:	00003517          	auipc	a0,0x3
    3f12:	38a50513          	addi	a0,a0,906 # 7298 <malloc+0x1d8c>
    3f16:	53e010ef          	jal	5454 <printf>
          exit(1);
    3f1a:	4505                	li	a0,1
    3f1c:	0ea010ef          	jal	5006 <exit>
    close(fd);
    3f20:	854e                	mv	a0,s3
    3f22:	10c010ef          	jal	502e <close>
    if(total != N*SZ){
    3f26:	05a91863          	bne	s2,s10,3f76 <fourfiles+0x19e>
    unlink(fname);
    3f2a:	8562                	mv	a0,s8
    3f2c:	12a010ef          	jal	5056 <unlink>
  for(i = 0; i < NCHILD; i++){
    3f30:	0ba1                	addi	s7,s7,8
    3f32:	2485                	addiw	s1,s1,1
    3f34:	05b48b63          	beq	s1,s11,3f8a <fourfiles+0x1b2>
    fname = names[i];
    3f38:	000bbc03          	ld	s8,0(s7)
    fd = open(fname, 0);
    3f3c:	4581                	li	a1,0
    3f3e:	8562                	mv	a0,s8
    3f40:	106010ef          	jal	5046 <open>
    3f44:	89aa                	mv	s3,a0
    total = 0;
    3f46:	895a                	mv	s2,s6
    while((n = read(fd, buf, sizeof(buf))) > 0){
    3f48:	8656                	mv	a2,s5
    3f4a:	85d2                	mv	a1,s4
    3f4c:	854e                	mv	a0,s3
    3f4e:	0d0010ef          	jal	501e <read>
    3f52:	fca057e3          	blez	a0,3f20 <fourfiles+0x148>
    3f56:	0000a797          	auipc	a5,0xa
    3f5a:	d6278793          	addi	a5,a5,-670 # dcb8 <buf>
    3f5e:	00f506b3          	add	a3,a0,a5
        if(buf[j] != '0'+i){
    3f62:	0007c703          	lbu	a4,0(a5)
    3f66:	fa9713e3          	bne	a4,s1,3f0c <fourfiles+0x134>
      for(j = 0; j < n; j++){
    3f6a:	0785                	addi	a5,a5,1
    3f6c:	fed79be3          	bne	a5,a3,3f62 <fourfiles+0x18a>
      total += n;
    3f70:	00a9093b          	addw	s2,s2,a0
    3f74:	bfd1                	j	3f48 <fourfiles+0x170>
      printf("wrong length %d\n", total);
    3f76:	85ca                	mv	a1,s2
    3f78:	00003517          	auipc	a0,0x3
    3f7c:	33050513          	addi	a0,a0,816 # 72a8 <malloc+0x1d9c>
    3f80:	4d4010ef          	jal	5454 <printf>
      exit(1);
    3f84:	4505                	li	a0,1
    3f86:	080010ef          	jal	5006 <exit>
}
    3f8a:	60ea                	ld	ra,152(sp)
    3f8c:	644a                	ld	s0,144(sp)
    3f8e:	64aa                	ld	s1,136(sp)
    3f90:	690a                	ld	s2,128(sp)
    3f92:	79e6                	ld	s3,120(sp)
    3f94:	7a46                	ld	s4,112(sp)
    3f96:	7aa6                	ld	s5,104(sp)
    3f98:	7b06                	ld	s6,96(sp)
    3f9a:	6be6                	ld	s7,88(sp)
    3f9c:	6c46                	ld	s8,80(sp)
    3f9e:	6ca6                	ld	s9,72(sp)
    3fa0:	6d06                	ld	s10,64(sp)
    3fa2:	7de2                	ld	s11,56(sp)
    3fa4:	610d                	addi	sp,sp,160
    3fa6:	8082                	ret

0000000000003fa8 <concreate>:
{
    3fa8:	7171                	addi	sp,sp,-176
    3faa:	f506                	sd	ra,168(sp)
    3fac:	f122                	sd	s0,160(sp)
    3fae:	ed26                	sd	s1,152(sp)
    3fb0:	e94a                	sd	s2,144(sp)
    3fb2:	e54e                	sd	s3,136(sp)
    3fb4:	e152                	sd	s4,128(sp)
    3fb6:	fcd6                	sd	s5,120(sp)
    3fb8:	f8da                	sd	s6,112(sp)
    3fba:	f4de                	sd	s7,104(sp)
    3fbc:	f0e2                	sd	s8,96(sp)
    3fbe:	ece6                	sd	s9,88(sp)
    3fc0:	e8ea                	sd	s10,80(sp)
    3fc2:	1900                	addi	s0,sp,176
    3fc4:	8d2a                	mv	s10,a0
  file[0] = 'C';
    3fc6:	04300793          	li	a5,67
    3fca:	f8f40c23          	sb	a5,-104(s0)
  file[2] = '\0';
    3fce:	f8040d23          	sb	zero,-102(s0)
  for(i = 0; i < N; i++){
    3fd2:	4901                	li	s2,0
    unlink(file);
    3fd4:	f9840993          	addi	s3,s0,-104
    if(pid && (i % 3) == 1){
    3fd8:	55555b37          	lui	s6,0x55555
    3fdc:	556b0b13          	addi	s6,s6,1366 # 55555556 <base+0x5554489e>
    3fe0:	4b85                	li	s7,1
      fd = open(file, O_CREATE | O_RDWR);
    3fe2:	20200c13          	li	s8,514
      link("C0", file);
    3fe6:	00003c97          	auipc	s9,0x3
    3fea:	2dac8c93          	addi	s9,s9,730 # 72c0 <malloc+0x1db4>
      wait(&xstatus);
    3fee:	f5c40a93          	addi	s5,s0,-164
  for(i = 0; i < N; i++){
    3ff2:	02800a13          	li	s4,40
    3ff6:	ac25                	j	422e <concreate+0x286>
      link("C0", file);
    3ff8:	85ce                	mv	a1,s3
    3ffa:	8566                	mv	a0,s9
    3ffc:	06a010ef          	jal	5066 <link>
    if(pid == 0) {
    4000:	ac29                	j	421a <concreate+0x272>
    } else if(pid == 0 && (i % 5) == 1){
    4002:	666667b7          	lui	a5,0x66666
    4006:	66778793          	addi	a5,a5,1639 # 66666667 <base+0x666559af>
    400a:	02f907b3          	mul	a5,s2,a5
    400e:	9785                	srai	a5,a5,0x21
    4010:	41f9571b          	sraiw	a4,s2,0x1f
    4014:	9f99                	subw	a5,a5,a4
    4016:	0027971b          	slliw	a4,a5,0x2
    401a:	9fb9                	addw	a5,a5,a4
    401c:	40f9093b          	subw	s2,s2,a5
    4020:	4785                	li	a5,1
    4022:	02f90563          	beq	s2,a5,404c <concreate+0xa4>
      fd = open(file, O_CREATE | O_RDWR);
    4026:	20200593          	li	a1,514
    402a:	f9840513          	addi	a0,s0,-104
    402e:	018010ef          	jal	5046 <open>
      if(fd < 0){
    4032:	1c055f63          	bgez	a0,4210 <concreate+0x268>
        printf("concreate create %s failed\n", file);
    4036:	f9840593          	addi	a1,s0,-104
    403a:	00003517          	auipc	a0,0x3
    403e:	28e50513          	addi	a0,a0,654 # 72c8 <malloc+0x1dbc>
    4042:	412010ef          	jal	5454 <printf>
        exit(1);
    4046:	4505                	li	a0,1
    4048:	7bf000ef          	jal	5006 <exit>
      link("C0", file);
    404c:	f9840593          	addi	a1,s0,-104
    4050:	00003517          	auipc	a0,0x3
    4054:	27050513          	addi	a0,a0,624 # 72c0 <malloc+0x1db4>
    4058:	00e010ef          	jal	5066 <link>
      exit(0);
    405c:	4501                	li	a0,0
    405e:	7a9000ef          	jal	5006 <exit>
        exit(1);
    4062:	4505                	li	a0,1
    4064:	7a3000ef          	jal	5006 <exit>
  memset(fa, 0, sizeof(fa));
    4068:	02800613          	li	a2,40
    406c:	4581                	li	a1,0
    406e:	f7040513          	addi	a0,s0,-144
    4072:	56b000ef          	jal	4ddc <memset>
  fd = open(".", 0);
    4076:	4581                	li	a1,0
    4078:	00002517          	auipc	a0,0x2
    407c:	ca850513          	addi	a0,a0,-856 # 5d20 <malloc+0x814>
    4080:	7c7000ef          	jal	5046 <open>
    4084:	892a                	mv	s2,a0
  n = 0;
    4086:	8b26                	mv	s6,s1
  while(read(fd, &de, sizeof(de)) > 0){
    4088:	f6040a13          	addi	s4,s0,-160
    408c:	49c1                	li	s3,16
    if(de.name[0] == 'C' && de.name[2] == '\0'){
    408e:	04300a93          	li	s5,67
      if(i < 0 || i >= sizeof(fa)){
    4092:	02700b93          	li	s7,39
      fa[i] = 1;
    4096:	4c05                	li	s8,1
  while(read(fd, &de, sizeof(de)) > 0){
    4098:	864e                	mv	a2,s3
    409a:	85d2                	mv	a1,s4
    409c:	854a                	mv	a0,s2
    409e:	781000ef          	jal	501e <read>
    40a2:	06a05763          	blez	a0,4110 <concreate+0x168>
    if(de.inum == 0)
    40a6:	f6045783          	lhu	a5,-160(s0)
    40aa:	d7fd                	beqz	a5,4098 <concreate+0xf0>
    if(de.name[0] == 'C' && de.name[2] == '\0'){
    40ac:	f6244783          	lbu	a5,-158(s0)
    40b0:	ff5794e3          	bne	a5,s5,4098 <concreate+0xf0>
    40b4:	f6444783          	lbu	a5,-156(s0)
    40b8:	f3e5                	bnez	a5,4098 <concreate+0xf0>
      i = de.name[1] - '0';
    40ba:	f6344783          	lbu	a5,-157(s0)
    40be:	fd07879b          	addiw	a5,a5,-48
      if(i < 0 || i >= sizeof(fa)){
    40c2:	00fbef63          	bltu	s7,a5,40e0 <concreate+0x138>
      if(fa[i]){
    40c6:	fa078713          	addi	a4,a5,-96
    40ca:	9722                	add	a4,a4,s0
    40cc:	fd074703          	lbu	a4,-48(a4)
    40d0:	e705                	bnez	a4,40f8 <concreate+0x150>
      fa[i] = 1;
    40d2:	fa078793          	addi	a5,a5,-96
    40d6:	97a2                	add	a5,a5,s0
    40d8:	fd878823          	sb	s8,-48(a5)
      n++;
    40dc:	2b05                	addiw	s6,s6,1
    40de:	bf6d                	j	4098 <concreate+0xf0>
        printf("%s: concreate weird file %s\n", s, de.name);
    40e0:	f6240613          	addi	a2,s0,-158
    40e4:	85ea                	mv	a1,s10
    40e6:	00003517          	auipc	a0,0x3
    40ea:	20250513          	addi	a0,a0,514 # 72e8 <malloc+0x1ddc>
    40ee:	366010ef          	jal	5454 <printf>
        exit(1);
    40f2:	4505                	li	a0,1
    40f4:	713000ef          	jal	5006 <exit>
        printf("%s: concreate duplicate file %s\n", s, de.name);
    40f8:	f6240613          	addi	a2,s0,-158
    40fc:	85ea                	mv	a1,s10
    40fe:	00003517          	auipc	a0,0x3
    4102:	20a50513          	addi	a0,a0,522 # 7308 <malloc+0x1dfc>
    4106:	34e010ef          	jal	5454 <printf>
        exit(1);
    410a:	4505                	li	a0,1
    410c:	6fb000ef          	jal	5006 <exit>
  close(fd);
    4110:	854a                	mv	a0,s2
    4112:	71d000ef          	jal	502e <close>
  if(n != N){
    4116:	02800793          	li	a5,40
    411a:	00fb1a63          	bne	s6,a5,412e <concreate+0x186>
    if(((i % 3) == 0 && pid == 0) ||
    411e:	55555a37          	lui	s4,0x55555
    4122:	556a0a13          	addi	s4,s4,1366 # 55555556 <base+0x5554489e>
      close(open(file, 0));
    4126:	f9840993          	addi	s3,s0,-104
  for(i = 0; i < N; i++){
    412a:	8ada                	mv	s5,s6
    412c:	a049                	j	41ae <concreate+0x206>
    printf("%s: concreate not enough files in directory listing\n", s);
    412e:	85ea                	mv	a1,s10
    4130:	00003517          	auipc	a0,0x3
    4134:	20050513          	addi	a0,a0,512 # 7330 <malloc+0x1e24>
    4138:	31c010ef          	jal	5454 <printf>
    exit(1);
    413c:	4505                	li	a0,1
    413e:	6c9000ef          	jal	5006 <exit>
      printf("%s: fork failed\n", s);
    4142:	85ea                	mv	a1,s10
    4144:	00002517          	auipc	a0,0x2
    4148:	d8450513          	addi	a0,a0,-636 # 5ec8 <malloc+0x9bc>
    414c:	308010ef          	jal	5454 <printf>
      exit(1);
    4150:	4505                	li	a0,1
    4152:	6b5000ef          	jal	5006 <exit>
      close(open(file, 0));
    4156:	4581                	li	a1,0
    4158:	854e                	mv	a0,s3
    415a:	6ed000ef          	jal	5046 <open>
    415e:	6d1000ef          	jal	502e <close>
      close(open(file, 0));
    4162:	4581                	li	a1,0
    4164:	854e                	mv	a0,s3
    4166:	6e1000ef          	jal	5046 <open>
    416a:	6c5000ef          	jal	502e <close>
      close(open(file, 0));
    416e:	4581                	li	a1,0
    4170:	854e                	mv	a0,s3
    4172:	6d5000ef          	jal	5046 <open>
    4176:	6b9000ef          	jal	502e <close>
      close(open(file, 0));
    417a:	4581                	li	a1,0
    417c:	854e                	mv	a0,s3
    417e:	6c9000ef          	jal	5046 <open>
    4182:	6ad000ef          	jal	502e <close>
      close(open(file, 0));
    4186:	4581                	li	a1,0
    4188:	854e                	mv	a0,s3
    418a:	6bd000ef          	jal	5046 <open>
    418e:	6a1000ef          	jal	502e <close>
      close(open(file, 0));
    4192:	4581                	li	a1,0
    4194:	854e                	mv	a0,s3
    4196:	6b1000ef          	jal	5046 <open>
    419a:	695000ef          	jal	502e <close>
    if(pid == 0)
    419e:	06090663          	beqz	s2,420a <concreate+0x262>
      wait(0);
    41a2:	4501                	li	a0,0
    41a4:	66b000ef          	jal	500e <wait>
  for(i = 0; i < N; i++){
    41a8:	2485                	addiw	s1,s1,1
    41aa:	0d548163          	beq	s1,s5,426c <concreate+0x2c4>
    file[1] = '0' + i;
    41ae:	0304879b          	addiw	a5,s1,48
    41b2:	f8f40ca3          	sb	a5,-103(s0)
    pid = fork();
    41b6:	649000ef          	jal	4ffe <fork>
    41ba:	892a                	mv	s2,a0
    if(pid < 0){
    41bc:	f80543e3          	bltz	a0,4142 <concreate+0x19a>
    if(((i % 3) == 0 && pid == 0) ||
    41c0:	03448733          	mul	a4,s1,s4
    41c4:	9301                	srli	a4,a4,0x20
    41c6:	41f4d79b          	sraiw	a5,s1,0x1f
    41ca:	9f1d                	subw	a4,a4,a5
    41cc:	0017179b          	slliw	a5,a4,0x1
    41d0:	9fb9                	addw	a5,a5,a4
    41d2:	40f487bb          	subw	a5,s1,a5
    41d6:	00a7e733          	or	a4,a5,a0
    41da:	2701                	sext.w	a4,a4
    41dc:	df2d                	beqz	a4,4156 <concreate+0x1ae>
       ((i % 3) == 1 && pid != 0)){
    41de:	c119                	beqz	a0,41e4 <concreate+0x23c>
    if(((i % 3) == 0 && pid == 0) ||
    41e0:	17fd                	addi	a5,a5,-1
       ((i % 3) == 1 && pid != 0)){
    41e2:	dbb5                	beqz	a5,4156 <concreate+0x1ae>
      unlink(file);
    41e4:	854e                	mv	a0,s3
    41e6:	671000ef          	jal	5056 <unlink>
      unlink(file);
    41ea:	854e                	mv	a0,s3
    41ec:	66b000ef          	jal	5056 <unlink>
      unlink(file);
    41f0:	854e                	mv	a0,s3
    41f2:	665000ef          	jal	5056 <unlink>
      unlink(file);
    41f6:	854e                	mv	a0,s3
    41f8:	65f000ef          	jal	5056 <unlink>
      unlink(file);
    41fc:	854e                	mv	a0,s3
    41fe:	659000ef          	jal	5056 <unlink>
      unlink(file);
    4202:	854e                	mv	a0,s3
    4204:	653000ef          	jal	5056 <unlink>
    4208:	bf59                	j	419e <concreate+0x1f6>
      exit(0);
    420a:	4501                	li	a0,0
    420c:	5fb000ef          	jal	5006 <exit>
      close(fd);
    4210:	61f000ef          	jal	502e <close>
    if(pid == 0) {
    4214:	b5a1                	j	405c <concreate+0xb4>
      close(fd);
    4216:	619000ef          	jal	502e <close>
      wait(&xstatus);
    421a:	8556                	mv	a0,s5
    421c:	5f3000ef          	jal	500e <wait>
      if(xstatus != 0)
    4220:	f5c42483          	lw	s1,-164(s0)
    4224:	e2049fe3          	bnez	s1,4062 <concreate+0xba>
  for(i = 0; i < N; i++){
    4228:	2905                	addiw	s2,s2,1
    422a:	e3490fe3          	beq	s2,s4,4068 <concreate+0xc0>
    file[1] = '0' + i;
    422e:	0309079b          	addiw	a5,s2,48
    4232:	f8f40ca3          	sb	a5,-103(s0)
    unlink(file);
    4236:	854e                	mv	a0,s3
    4238:	61f000ef          	jal	5056 <unlink>
    pid = fork();
    423c:	5c3000ef          	jal	4ffe <fork>
    if(pid && (i % 3) == 1){
    4240:	dc0501e3          	beqz	a0,4002 <concreate+0x5a>
    4244:	036907b3          	mul	a5,s2,s6
    4248:	9381                	srli	a5,a5,0x20
    424a:	41f9571b          	sraiw	a4,s2,0x1f
    424e:	9f99                	subw	a5,a5,a4
    4250:	0017971b          	slliw	a4,a5,0x1
    4254:	9fb9                	addw	a5,a5,a4
    4256:	40f907bb          	subw	a5,s2,a5
    425a:	d9778fe3          	beq	a5,s7,3ff8 <concreate+0x50>
      fd = open(file, O_CREATE | O_RDWR);
    425e:	85e2                	mv	a1,s8
    4260:	854e                	mv	a0,s3
    4262:	5e5000ef          	jal	5046 <open>
      if(fd < 0){
    4266:	fa0558e3          	bgez	a0,4216 <concreate+0x26e>
    426a:	b3f1                	j	4036 <concreate+0x8e>
}
    426c:	70aa                	ld	ra,168(sp)
    426e:	740a                	ld	s0,160(sp)
    4270:	64ea                	ld	s1,152(sp)
    4272:	694a                	ld	s2,144(sp)
    4274:	69aa                	ld	s3,136(sp)
    4276:	6a0a                	ld	s4,128(sp)
    4278:	7ae6                	ld	s5,120(sp)
    427a:	7b46                	ld	s6,112(sp)
    427c:	7ba6                	ld	s7,104(sp)
    427e:	7c06                	ld	s8,96(sp)
    4280:	6ce6                	ld	s9,88(sp)
    4282:	6d46                	ld	s10,80(sp)
    4284:	614d                	addi	sp,sp,176
    4286:	8082                	ret

0000000000004288 <bigfile>:
{
    4288:	7139                	addi	sp,sp,-64
    428a:	fc06                	sd	ra,56(sp)
    428c:	f822                	sd	s0,48(sp)
    428e:	f426                	sd	s1,40(sp)
    4290:	f04a                	sd	s2,32(sp)
    4292:	ec4e                	sd	s3,24(sp)
    4294:	e852                	sd	s4,16(sp)
    4296:	e456                	sd	s5,8(sp)
    4298:	e05a                	sd	s6,0(sp)
    429a:	0080                	addi	s0,sp,64
    429c:	8b2a                	mv	s6,a0
  unlink("bigfile.dat");
    429e:	00003517          	auipc	a0,0x3
    42a2:	0ca50513          	addi	a0,a0,202 # 7368 <malloc+0x1e5c>
    42a6:	5b1000ef          	jal	5056 <unlink>
  fd = open("bigfile.dat", O_CREATE | O_RDWR);
    42aa:	20200593          	li	a1,514
    42ae:	00003517          	auipc	a0,0x3
    42b2:	0ba50513          	addi	a0,a0,186 # 7368 <malloc+0x1e5c>
    42b6:	591000ef          	jal	5046 <open>
  if(fd < 0){
    42ba:	08054a63          	bltz	a0,434e <bigfile+0xc6>
    42be:	8a2a                	mv	s4,a0
    42c0:	4481                	li	s1,0
    memset(buf, i, SZ);
    42c2:	25800913          	li	s2,600
    42c6:	0000a997          	auipc	s3,0xa
    42ca:	9f298993          	addi	s3,s3,-1550 # dcb8 <buf>
  for(i = 0; i < N; i++){
    42ce:	4ad1                	li	s5,20
    memset(buf, i, SZ);
    42d0:	864a                	mv	a2,s2
    42d2:	85a6                	mv	a1,s1
    42d4:	854e                	mv	a0,s3
    42d6:	307000ef          	jal	4ddc <memset>
    if(write(fd, buf, SZ) != SZ){
    42da:	864a                	mv	a2,s2
    42dc:	85ce                	mv	a1,s3
    42de:	8552                	mv	a0,s4
    42e0:	547000ef          	jal	5026 <write>
    42e4:	07251f63          	bne	a0,s2,4362 <bigfile+0xda>
  for(i = 0; i < N; i++){
    42e8:	2485                	addiw	s1,s1,1
    42ea:	ff5493e3          	bne	s1,s5,42d0 <bigfile+0x48>
  close(fd);
    42ee:	8552                	mv	a0,s4
    42f0:	53f000ef          	jal	502e <close>
  fd = open("bigfile.dat", 0);
    42f4:	4581                	li	a1,0
    42f6:	00003517          	auipc	a0,0x3
    42fa:	07250513          	addi	a0,a0,114 # 7368 <malloc+0x1e5c>
    42fe:	549000ef          	jal	5046 <open>
    4302:	8aaa                	mv	s5,a0
  total = 0;
    4304:	4a01                	li	s4,0
  for(i = 0; ; i++){
    4306:	4481                	li	s1,0
    cc = read(fd, buf, SZ/2);
    4308:	12c00993          	li	s3,300
    430c:	0000a917          	auipc	s2,0xa
    4310:	9ac90913          	addi	s2,s2,-1620 # dcb8 <buf>
  if(fd < 0){
    4314:	06054163          	bltz	a0,4376 <bigfile+0xee>
    cc = read(fd, buf, SZ/2);
    4318:	864e                	mv	a2,s3
    431a:	85ca                	mv	a1,s2
    431c:	8556                	mv	a0,s5
    431e:	501000ef          	jal	501e <read>
    if(cc < 0){
    4322:	06054463          	bltz	a0,438a <bigfile+0x102>
    if(cc == 0)
    4326:	c145                	beqz	a0,43c6 <bigfile+0x13e>
    if(cc != SZ/2){
    4328:	07351b63          	bne	a0,s3,439e <bigfile+0x116>
    if(buf[0] != i/2 || buf[SZ/2-1] != i/2){
    432c:	01f4d79b          	srliw	a5,s1,0x1f
    4330:	9fa5                	addw	a5,a5,s1
    4332:	4017d79b          	sraiw	a5,a5,0x1
    4336:	00094703          	lbu	a4,0(s2)
    433a:	06f71c63          	bne	a4,a5,43b2 <bigfile+0x12a>
    433e:	12b94703          	lbu	a4,299(s2)
    4342:	06f71863          	bne	a4,a5,43b2 <bigfile+0x12a>
    total += cc;
    4346:	12ca0a1b          	addiw	s4,s4,300
  for(i = 0; ; i++){
    434a:	2485                	addiw	s1,s1,1
    cc = read(fd, buf, SZ/2);
    434c:	b7f1                	j	4318 <bigfile+0x90>
    printf("%s: cannot create bigfile", s);
    434e:	85da                	mv	a1,s6
    4350:	00003517          	auipc	a0,0x3
    4354:	02850513          	addi	a0,a0,40 # 7378 <malloc+0x1e6c>
    4358:	0fc010ef          	jal	5454 <printf>
    exit(1);
    435c:	4505                	li	a0,1
    435e:	4a9000ef          	jal	5006 <exit>
      printf("%s: write bigfile failed\n", s);
    4362:	85da                	mv	a1,s6
    4364:	00003517          	auipc	a0,0x3
    4368:	03450513          	addi	a0,a0,52 # 7398 <malloc+0x1e8c>
    436c:	0e8010ef          	jal	5454 <printf>
      exit(1);
    4370:	4505                	li	a0,1
    4372:	495000ef          	jal	5006 <exit>
    printf("%s: cannot open bigfile\n", s);
    4376:	85da                	mv	a1,s6
    4378:	00003517          	auipc	a0,0x3
    437c:	04050513          	addi	a0,a0,64 # 73b8 <malloc+0x1eac>
    4380:	0d4010ef          	jal	5454 <printf>
    exit(1);
    4384:	4505                	li	a0,1
    4386:	481000ef          	jal	5006 <exit>
      printf("%s: read bigfile failed\n", s);
    438a:	85da                	mv	a1,s6
    438c:	00003517          	auipc	a0,0x3
    4390:	04c50513          	addi	a0,a0,76 # 73d8 <malloc+0x1ecc>
    4394:	0c0010ef          	jal	5454 <printf>
      exit(1);
    4398:	4505                	li	a0,1
    439a:	46d000ef          	jal	5006 <exit>
      printf("%s: short read bigfile\n", s);
    439e:	85da                	mv	a1,s6
    43a0:	00003517          	auipc	a0,0x3
    43a4:	05850513          	addi	a0,a0,88 # 73f8 <malloc+0x1eec>
    43a8:	0ac010ef          	jal	5454 <printf>
      exit(1);
    43ac:	4505                	li	a0,1
    43ae:	459000ef          	jal	5006 <exit>
      printf("%s: read bigfile wrong data\n", s);
    43b2:	85da                	mv	a1,s6
    43b4:	00003517          	auipc	a0,0x3
    43b8:	05c50513          	addi	a0,a0,92 # 7410 <malloc+0x1f04>
    43bc:	098010ef          	jal	5454 <printf>
      exit(1);
    43c0:	4505                	li	a0,1
    43c2:	445000ef          	jal	5006 <exit>
  close(fd);
    43c6:	8556                	mv	a0,s5
    43c8:	467000ef          	jal	502e <close>
  if(total != N*SZ){
    43cc:	678d                	lui	a5,0x3
    43ce:	ee078793          	addi	a5,a5,-288 # 2ee0 <subdir+0x1d0>
    43d2:	02fa1263          	bne	s4,a5,43f6 <bigfile+0x16e>
  unlink("bigfile.dat");
    43d6:	00003517          	auipc	a0,0x3
    43da:	f9250513          	addi	a0,a0,-110 # 7368 <malloc+0x1e5c>
    43de:	479000ef          	jal	5056 <unlink>
}
    43e2:	70e2                	ld	ra,56(sp)
    43e4:	7442                	ld	s0,48(sp)
    43e6:	74a2                	ld	s1,40(sp)
    43e8:	7902                	ld	s2,32(sp)
    43ea:	69e2                	ld	s3,24(sp)
    43ec:	6a42                	ld	s4,16(sp)
    43ee:	6aa2                	ld	s5,8(sp)
    43f0:	6b02                	ld	s6,0(sp)
    43f2:	6121                	addi	sp,sp,64
    43f4:	8082                	ret
    printf("%s: read bigfile wrong total\n", s);
    43f6:	85da                	mv	a1,s6
    43f8:	00003517          	auipc	a0,0x3
    43fc:	03850513          	addi	a0,a0,56 # 7430 <malloc+0x1f24>
    4400:	054010ef          	jal	5454 <printf>
    exit(1);
    4404:	4505                	li	a0,1
    4406:	401000ef          	jal	5006 <exit>

000000000000440a <bigargtest>:
{
    440a:	7121                	addi	sp,sp,-448
    440c:	ff06                	sd	ra,440(sp)
    440e:	fb22                	sd	s0,432(sp)
    4410:	f726                	sd	s1,424(sp)
    4412:	0380                	addi	s0,sp,448
    4414:	84aa                	mv	s1,a0
  unlink("bigarg-ok");
    4416:	00003517          	auipc	a0,0x3
    441a:	03a50513          	addi	a0,a0,58 # 7450 <malloc+0x1f44>
    441e:	439000ef          	jal	5056 <unlink>
  pid = fork();
    4422:	3dd000ef          	jal	4ffe <fork>
  if(pid == 0){
    4426:	c915                	beqz	a0,445a <bigargtest+0x50>
  } else if(pid < 0){
    4428:	08054c63          	bltz	a0,44c0 <bigargtest+0xb6>
  wait(&xstatus);
    442c:	fdc40513          	addi	a0,s0,-36
    4430:	3df000ef          	jal	500e <wait>
  if(xstatus != 0)
    4434:	fdc42503          	lw	a0,-36(s0)
    4438:	ed51                	bnez	a0,44d4 <bigargtest+0xca>
  fd = open("bigarg-ok", 0);
    443a:	4581                	li	a1,0
    443c:	00003517          	auipc	a0,0x3
    4440:	01450513          	addi	a0,a0,20 # 7450 <malloc+0x1f44>
    4444:	403000ef          	jal	5046 <open>
  if(fd < 0){
    4448:	08054863          	bltz	a0,44d8 <bigargtest+0xce>
  close(fd);
    444c:	3e3000ef          	jal	502e <close>
}
    4450:	70fa                	ld	ra,440(sp)
    4452:	745a                	ld	s0,432(sp)
    4454:	74ba                	ld	s1,424(sp)
    4456:	6139                	addi	sp,sp,448
    4458:	8082                	ret
    memset(big, ' ', sizeof(big));
    445a:	19000613          	li	a2,400
    445e:	02000593          	li	a1,32
    4462:	e4840513          	addi	a0,s0,-440
    4466:	177000ef          	jal	4ddc <memset>
    big[sizeof(big)-1] = '\0';
    446a:	fc040ba3          	sb	zero,-41(s0)
    for(i = 0; i < MAXARG-1; i++)
    446e:	00006797          	auipc	a5,0x6
    4472:	03278793          	addi	a5,a5,50 # a4a0 <args.1>
    4476:	00006697          	auipc	a3,0x6
    447a:	12268693          	addi	a3,a3,290 # a598 <args.1+0xf8>
      args[i] = big;
    447e:	e4840713          	addi	a4,s0,-440
    4482:	e398                	sd	a4,0(a5)
    for(i = 0; i < MAXARG-1; i++)
    4484:	07a1                	addi	a5,a5,8
    4486:	fed79ee3          	bne	a5,a3,4482 <bigargtest+0x78>
    args[MAXARG-1] = 0;
    448a:	00006797          	auipc	a5,0x6
    448e:	1007b723          	sd	zero,270(a5) # a598 <args.1+0xf8>
    exec("echo", args);
    4492:	00006597          	auipc	a1,0x6
    4496:	00e58593          	addi	a1,a1,14 # a4a0 <args.1>
    449a:	00001517          	auipc	a0,0x1
    449e:	19e50513          	addi	a0,a0,414 # 5638 <malloc+0x12c>
    44a2:	39d000ef          	jal	503e <exec>
    fd = open("bigarg-ok", O_CREATE);
    44a6:	20000593          	li	a1,512
    44aa:	00003517          	auipc	a0,0x3
    44ae:	fa650513          	addi	a0,a0,-90 # 7450 <malloc+0x1f44>
    44b2:	395000ef          	jal	5046 <open>
    close(fd);
    44b6:	379000ef          	jal	502e <close>
    exit(0);
    44ba:	4501                	li	a0,0
    44bc:	34b000ef          	jal	5006 <exit>
    printf("%s: bigargtest: fork failed\n", s);
    44c0:	85a6                	mv	a1,s1
    44c2:	00003517          	auipc	a0,0x3
    44c6:	f9e50513          	addi	a0,a0,-98 # 7460 <malloc+0x1f54>
    44ca:	78b000ef          	jal	5454 <printf>
    exit(1);
    44ce:	4505                	li	a0,1
    44d0:	337000ef          	jal	5006 <exit>
    exit(xstatus);
    44d4:	333000ef          	jal	5006 <exit>
    printf("%s: bigarg test failed!\n", s);
    44d8:	85a6                	mv	a1,s1
    44da:	00003517          	auipc	a0,0x3
    44de:	fa650513          	addi	a0,a0,-90 # 7480 <malloc+0x1f74>
    44e2:	773000ef          	jal	5454 <printf>
    exit(1);
    44e6:	4505                	li	a0,1
    44e8:	31f000ef          	jal	5006 <exit>

00000000000044ec <lazy_alloc>:
{
    44ec:	1141                	addi	sp,sp,-16
    44ee:	e406                	sd	ra,8(sp)
    44f0:	e022                	sd	s0,0(sp)
    44f2:	0800                	addi	s0,sp,16
  prev_end = sbrklazy(REGION_SZ);
    44f4:	40000537          	lui	a0,0x40000
    44f8:	2f1000ef          	jal	4fe8 <sbrklazy>
  if (prev_end == (char *) SBRK_ERROR) {
    44fc:	57fd                	li	a5,-1
    44fe:	02f50a63          	beq	a0,a5,4532 <lazy_alloc+0x46>
  for (i = prev_end + PGSIZE; i < new_end; i += 64 * PGSIZE)
    4502:	6605                	lui	a2,0x1
    4504:	962a                	add	a2,a2,a0
    4506:	400017b7          	lui	a5,0x40001
    450a:	00f50733          	add	a4,a0,a5
    450e:	87b2                	mv	a5,a2
    4510:	000406b7          	lui	a3,0x40
    *(char **)i = i;
    4514:	e39c                	sd	a5,0(a5)
  for (i = prev_end + PGSIZE; i < new_end; i += 64 * PGSIZE)
    4516:	97b6                	add	a5,a5,a3
    4518:	fee79ee3          	bne	a5,a4,4514 <lazy_alloc+0x28>
  for (i = prev_end + PGSIZE; i < new_end; i += 64 * PGSIZE) {
    451c:	000406b7          	lui	a3,0x40
    if (*(char **)i != i) {
    4520:	621c                	ld	a5,0(a2)
    4522:	02c79163          	bne	a5,a2,4544 <lazy_alloc+0x58>
  for (i = prev_end + PGSIZE; i < new_end; i += 64 * PGSIZE) {
    4526:	9636                	add	a2,a2,a3
    4528:	fee61ce3          	bne	a2,a4,4520 <lazy_alloc+0x34>
  exit(0);
    452c:	4501                	li	a0,0
    452e:	2d9000ef          	jal	5006 <exit>
    printf("sbrklazy() failed\n");
    4532:	00003517          	auipc	a0,0x3
    4536:	f6e50513          	addi	a0,a0,-146 # 74a0 <malloc+0x1f94>
    453a:	71b000ef          	jal	5454 <printf>
    exit(1);
    453e:	4505                	li	a0,1
    4540:	2c7000ef          	jal	5006 <exit>
      printf("failed to read value from memory\n");
    4544:	00003517          	auipc	a0,0x3
    4548:	f7450513          	addi	a0,a0,-140 # 74b8 <malloc+0x1fac>
    454c:	709000ef          	jal	5454 <printf>
      exit(1);
    4550:	4505                	li	a0,1
    4552:	2b5000ef          	jal	5006 <exit>

0000000000004556 <lazy_unmap>:
{
    4556:	7139                	addi	sp,sp,-64
    4558:	fc06                	sd	ra,56(sp)
    455a:	f822                	sd	s0,48(sp)
    455c:	0080                	addi	s0,sp,64
  prev_end = sbrklazy(REGION_SZ);
    455e:	40000537          	lui	a0,0x40000
    4562:	287000ef          	jal	4fe8 <sbrklazy>
  if (prev_end == (char*)SBRK_ERROR) {
    4566:	57fd                	li	a5,-1
    4568:	04f50863          	beq	a0,a5,45b8 <lazy_unmap+0x62>
    456c:	f426                	sd	s1,40(sp)
    456e:	f04a                	sd	s2,32(sp)
    4570:	ec4e                	sd	s3,24(sp)
    4572:	e852                	sd	s4,16(sp)
  for (i = prev_end + PGSIZE; i < new_end; i += PGSIZE * PGSIZE)
    4574:	6905                	lui	s2,0x1
    4576:	992a                	add	s2,s2,a0
    4578:	400017b7          	lui	a5,0x40001
    457c:	00f504b3          	add	s1,a0,a5
    4580:	87ca                	mv	a5,s2
    4582:	01000737          	lui	a4,0x1000
    *(char **)i = i;
    4586:	e39c                	sd	a5,0(a5)
  for (i = prev_end + PGSIZE; i < new_end; i += PGSIZE * PGSIZE)
    4588:	97ba                	add	a5,a5,a4
    458a:	fe979ee3          	bne	a5,s1,4586 <lazy_unmap+0x30>
      wait(&status);
    458e:	fcc40993          	addi	s3,s0,-52
  for (i = prev_end + PGSIZE; i < new_end; i += PGSIZE * PGSIZE) {
    4592:	01000a37          	lui	s4,0x1000
    pid = fork();
    4596:	269000ef          	jal	4ffe <fork>
    if (pid < 0) {
    459a:	02054c63          	bltz	a0,45d2 <lazy_unmap+0x7c>
    } else if (pid == 0) {
    459e:	c139                	beqz	a0,45e4 <lazy_unmap+0x8e>
      wait(&status);
    45a0:	854e                	mv	a0,s3
    45a2:	26d000ef          	jal	500e <wait>
      if (status == 0) {
    45a6:	fcc42783          	lw	a5,-52(s0)
    45aa:	c7b1                	beqz	a5,45f6 <lazy_unmap+0xa0>
  for (i = prev_end + PGSIZE; i < new_end; i += PGSIZE * PGSIZE) {
    45ac:	9952                	add	s2,s2,s4
    45ae:	fe9914e3          	bne	s2,s1,4596 <lazy_unmap+0x40>
  exit(0);
    45b2:	4501                	li	a0,0
    45b4:	253000ef          	jal	5006 <exit>
    45b8:	f426                	sd	s1,40(sp)
    45ba:	f04a                	sd	s2,32(sp)
    45bc:	ec4e                	sd	s3,24(sp)
    45be:	e852                	sd	s4,16(sp)
    printf("sbrklazy() failed\n");
    45c0:	00003517          	auipc	a0,0x3
    45c4:	ee050513          	addi	a0,a0,-288 # 74a0 <malloc+0x1f94>
    45c8:	68d000ef          	jal	5454 <printf>
    exit(1);
    45cc:	4505                	li	a0,1
    45ce:	239000ef          	jal	5006 <exit>
      printf("error forking\n");
    45d2:	00003517          	auipc	a0,0x3
    45d6:	f0e50513          	addi	a0,a0,-242 # 74e0 <malloc+0x1fd4>
    45da:	67b000ef          	jal	5454 <printf>
      exit(1);
    45de:	4505                	li	a0,1
    45e0:	227000ef          	jal	5006 <exit>
      sbrklazy(-1L * REGION_SZ);
    45e4:	c0000537          	lui	a0,0xc0000
    45e8:	201000ef          	jal	4fe8 <sbrklazy>
      *(char **)i = i;
    45ec:	01293023          	sd	s2,0(s2) # 1000 <bigdir+0x10c>
      exit(0);
    45f0:	4501                	li	a0,0
    45f2:	215000ef          	jal	5006 <exit>
        printf("memory not unmapped\n");
    45f6:	00003517          	auipc	a0,0x3
    45fa:	efa50513          	addi	a0,a0,-262 # 74f0 <malloc+0x1fe4>
    45fe:	657000ef          	jal	5454 <printf>
        exit(1);
    4602:	4505                	li	a0,1
    4604:	203000ef          	jal	5006 <exit>

0000000000004608 <lazy_copy>:
{
    4608:	7119                	addi	sp,sp,-128
    460a:	fc86                	sd	ra,120(sp)
    460c:	f8a2                	sd	s0,112(sp)
    460e:	f4a6                	sd	s1,104(sp)
    4610:	f0ca                	sd	s2,96(sp)
    4612:	ecce                	sd	s3,88(sp)
    4614:	e8d2                	sd	s4,80(sp)
    4616:	e4d6                	sd	s5,72(sp)
    4618:	e0da                	sd	s6,64(sp)
    461a:	fc5e                	sd	s7,56(sp)
    461c:	0100                	addi	s0,sp,128
    char *p = sbrk(0);
    461e:	4501                	li	a0,0
    4620:	1b3000ef          	jal	4fd2 <sbrk>
    4624:	84aa                	mv	s1,a0
    sbrklazy(4*PGSIZE);
    4626:	6511                	lui	a0,0x4
    4628:	1c1000ef          	jal	4fe8 <sbrklazy>
    open(p + 8192, 0);
    462c:	4581                	li	a1,0
    462e:	6509                	lui	a0,0x2
    4630:	9526                	add	a0,a0,s1
    4632:	215000ef          	jal	5046 <open>
    void *xx = sbrk(0);
    4636:	4501                	li	a0,0
    4638:	19b000ef          	jal	4fd2 <sbrk>
    463c:	84aa                	mv	s1,a0
    void *ret = sbrk(-(((uint64) xx)+1));
    463e:	fff54513          	not	a0,a0
    4642:	2501                	sext.w	a0,a0
    4644:	18f000ef          	jal	4fd2 <sbrk>
    if(ret != xx){
    4648:	00a48c63          	beq	s1,a0,4660 <lazy_copy+0x58>
    464c:	85aa                	mv	a1,a0
      printf("sbrk(sbrk(0)+1) returned %p, not old sz\n", ret);
    464e:	00003517          	auipc	a0,0x3
    4652:	eba50513          	addi	a0,a0,-326 # 7508 <malloc+0x1ffc>
    4656:	5ff000ef          	jal	5454 <printf>
      exit(1);
    465a:	4505                	li	a0,1
    465c:	1ab000ef          	jal	5006 <exit>
  unsigned long bad[] = {
    4660:	00003797          	auipc	a5,0x3
    4664:	52078793          	addi	a5,a5,1312 # 7b80 <malloc+0x2674>
    4668:	7fa8                	ld	a0,120(a5)
    466a:	63cc                	ld	a1,128(a5)
    466c:	67d0                	ld	a2,136(a5)
    466e:	6bd4                	ld	a3,144(a5)
    4670:	6fd8                	ld	a4,152(a5)
    4672:	f8a43023          	sd	a0,-128(s0)
    4676:	f8b43423          	sd	a1,-120(s0)
    467a:	f8c43823          	sd	a2,-112(s0)
    467e:	f8d43c23          	sd	a3,-104(s0)
    4682:	fae43023          	sd	a4,-96(s0)
    4686:	73dc                	ld	a5,160(a5)
    4688:	faf43423          	sd	a5,-88(s0)
  for(int i = 0; i < sizeof(bad)/sizeof(bad[0]); i++){
    468c:	f8040913          	addi	s2,s0,-128
    int fd = open("README", 0);
    4690:	00001a97          	auipc	s5,0x1
    4694:	180a8a93          	addi	s5,s5,384 # 5810 <malloc+0x304>
    if(read(fd, (char*)bad[i], 512) >= 0) { printf("read succeeded\n");  exit(1); }
    4698:	20000a13          	li	s4,512
    fd = open("junk", O_CREATE|O_RDWR|O_TRUNC);
    469c:	60200b93          	li	s7,1538
    46a0:	00001b17          	auipc	s6,0x1
    46a4:	080b0b13          	addi	s6,s6,128 # 5720 <malloc+0x214>
    int fd = open("README", 0);
    46a8:	4581                	li	a1,0
    46aa:	8556                	mv	a0,s5
    46ac:	19b000ef          	jal	5046 <open>
    46b0:	84aa                	mv	s1,a0
    if(fd < 0) { printf("cannot open README\n"); exit(1); }
    46b2:	04054563          	bltz	a0,46fc <lazy_copy+0xf4>
    if(read(fd, (char*)bad[i], 512) >= 0) { printf("read succeeded\n");  exit(1); }
    46b6:	00093983          	ld	s3,0(s2)
    46ba:	8652                	mv	a2,s4
    46bc:	85ce                	mv	a1,s3
    46be:	161000ef          	jal	501e <read>
    46c2:	04055663          	bgez	a0,470e <lazy_copy+0x106>
    close(fd);
    46c6:	8526                	mv	a0,s1
    46c8:	167000ef          	jal	502e <close>
    fd = open("junk", O_CREATE|O_RDWR|O_TRUNC);
    46cc:	85de                	mv	a1,s7
    46ce:	855a                	mv	a0,s6
    46d0:	177000ef          	jal	5046 <open>
    46d4:	84aa                	mv	s1,a0
    if(fd < 0) { printf("cannot open junk\n"); exit(1); }
    46d6:	04054563          	bltz	a0,4720 <lazy_copy+0x118>
    if(write(fd, (char*)bad[i], 512) >= 0) { printf("write succeeded\n"); exit(1); }
    46da:	8652                	mv	a2,s4
    46dc:	85ce                	mv	a1,s3
    46de:	149000ef          	jal	5026 <write>
    46e2:	04055863          	bgez	a0,4732 <lazy_copy+0x12a>
    close(fd);
    46e6:	8526                	mv	a0,s1
    46e8:	147000ef          	jal	502e <close>
  for(int i = 0; i < sizeof(bad)/sizeof(bad[0]); i++){
    46ec:	0921                	addi	s2,s2,8
    46ee:	fb040793          	addi	a5,s0,-80
    46f2:	faf91be3          	bne	s2,a5,46a8 <lazy_copy+0xa0>
  exit(0);
    46f6:	4501                	li	a0,0
    46f8:	10f000ef          	jal	5006 <exit>
    if(fd < 0) { printf("cannot open README\n"); exit(1); }
    46fc:	00003517          	auipc	a0,0x3
    4700:	e3c50513          	addi	a0,a0,-452 # 7538 <malloc+0x202c>
    4704:	551000ef          	jal	5454 <printf>
    4708:	4505                	li	a0,1
    470a:	0fd000ef          	jal	5006 <exit>
    if(read(fd, (char*)bad[i], 512) >= 0) { printf("read succeeded\n");  exit(1); }
    470e:	00003517          	auipc	a0,0x3
    4712:	e4250513          	addi	a0,a0,-446 # 7550 <malloc+0x2044>
    4716:	53f000ef          	jal	5454 <printf>
    471a:	4505                	li	a0,1
    471c:	0eb000ef          	jal	5006 <exit>
    if(fd < 0) { printf("cannot open junk\n"); exit(1); }
    4720:	00003517          	auipc	a0,0x3
    4724:	e4050513          	addi	a0,a0,-448 # 7560 <malloc+0x2054>
    4728:	52d000ef          	jal	5454 <printf>
    472c:	4505                	li	a0,1
    472e:	0d9000ef          	jal	5006 <exit>
    if(write(fd, (char*)bad[i], 512) >= 0) { printf("write succeeded\n"); exit(1); }
    4732:	00003517          	auipc	a0,0x3
    4736:	e4650513          	addi	a0,a0,-442 # 7578 <malloc+0x206c>
    473a:	51b000ef          	jal	5454 <printf>
    473e:	4505                	li	a0,1
    4740:	0c7000ef          	jal	5006 <exit>

0000000000004744 <lazy_sbrk>:
{
    4744:	7179                	addi	sp,sp,-48
    4746:	f406                	sd	ra,40(sp)
    4748:	f022                	sd	s0,32(sp)
    474a:	ec26                	sd	s1,24(sp)
    474c:	e84a                	sd	s2,16(sp)
    474e:	e44e                	sd	s3,8(sp)
    4750:	1800                	addi	s0,sp,48
  char *p = sbrk(0);
    4752:	4501                	li	a0,0
    4754:	07f000ef          	jal	4fd2 <sbrk>
    4758:	84aa                	mv	s1,a0
  while ((uint64)p < MAXVA-(1<<30)) {
    475a:	0ff00793          	li	a5,255
    475e:	07fa                	slli	a5,a5,0x1e
    4760:	00f57e63          	bgeu	a0,a5,477c <lazy_sbrk+0x38>
    p = sbrklazy(1<<30);
    4764:	400009b7          	lui	s3,0x40000
  while ((uint64)p < MAXVA-(1<<30)) {
    4768:	893e                	mv	s2,a5
    p = sbrklazy(1<<30);
    476a:	854e                	mv	a0,s3
    476c:	07d000ef          	jal	4fe8 <sbrklazy>
    p = sbrklazy(0);
    4770:	4501                	li	a0,0
    4772:	077000ef          	jal	4fe8 <sbrklazy>
    4776:	84aa                	mv	s1,a0
  while ((uint64)p < MAXVA-(1<<30)) {
    4778:	ff2569e3          	bltu	a0,s2,476a <lazy_sbrk+0x26>
  int n = TRAPFRAME-PGSIZE-(uint64)p;
    477c:	7975                	lui	s2,0xffffd
    477e:	4099093b          	subw	s2,s2,s1
  char *p1 = sbrklazy(n);
    4782:	854a                	mv	a0,s2
    4784:	065000ef          	jal	4fe8 <sbrklazy>
    4788:	862a                	mv	a2,a0
  if (p1 < 0 || p1 != p) {
    478a:	00950d63          	beq	a0,s1,47a4 <lazy_sbrk+0x60>
    printf("sbrklazy(%d) returned %p, not expected %p\n", n, p1, p);
    478e:	86a6                	mv	a3,s1
    4790:	85ca                	mv	a1,s2
    4792:	00003517          	auipc	a0,0x3
    4796:	dfe50513          	addi	a0,a0,-514 # 7590 <malloc+0x2084>
    479a:	4bb000ef          	jal	5454 <printf>
    exit(1);
    479e:	4505                	li	a0,1
    47a0:	067000ef          	jal	5006 <exit>
  p = sbrk(PGSIZE);
    47a4:	6505                	lui	a0,0x1
    47a6:	02d000ef          	jal	4fd2 <sbrk>
    47aa:	862a                	mv	a2,a0
  if (p < 0 || (uint64)p != TRAPFRAME-PGSIZE) {
    47ac:	040007b7          	lui	a5,0x4000
    47b0:	17f5                	addi	a5,a5,-3 # 3fffffd <base+0x3fef345>
    47b2:	07b2                	slli	a5,a5,0xc
    47b4:	00f50c63          	beq	a0,a5,47cc <lazy_sbrk+0x88>
    printf("sbrk(%d) returned %p, not expected TRAPFRAME-PGSIZE\n", PGSIZE, p);
    47b8:	6585                	lui	a1,0x1
    47ba:	00003517          	auipc	a0,0x3
    47be:	e0650513          	addi	a0,a0,-506 # 75c0 <malloc+0x20b4>
    47c2:	493000ef          	jal	5454 <printf>
    exit(1);
    47c6:	4505                	li	a0,1
    47c8:	03f000ef          	jal	5006 <exit>
  p[0] = 1;
    47cc:	040007b7          	lui	a5,0x4000
    47d0:	17f5                	addi	a5,a5,-3 # 3fffffd <base+0x3fef345>
    47d2:	07b2                	slli	a5,a5,0xc
    47d4:	4705                	li	a4,1
    47d6:	00e78023          	sb	a4,0(a5)
  if (p[1] != 0) {
    47da:	0017c783          	lbu	a5,1(a5)
    47de:	cb91                	beqz	a5,47f2 <lazy_sbrk+0xae>
    printf("sbrk() returned non-zero-filled memory\n");
    47e0:	00003517          	auipc	a0,0x3
    47e4:	e1850513          	addi	a0,a0,-488 # 75f8 <malloc+0x20ec>
    47e8:	46d000ef          	jal	5454 <printf>
    exit(1);
    47ec:	4505                	li	a0,1
    47ee:	019000ef          	jal	5006 <exit>
  p = sbrk(1);
    47f2:	4505                	li	a0,1
    47f4:	7de000ef          	jal	4fd2 <sbrk>
    47f8:	85aa                	mv	a1,a0
  if ((uint64)p != -1) {
    47fa:	57fd                	li	a5,-1
    47fc:	00f50b63          	beq	a0,a5,4812 <lazy_sbrk+0xce>
    printf("sbrk(1) returned %p, expected error\n", p);
    4800:	00003517          	auipc	a0,0x3
    4804:	e2050513          	addi	a0,a0,-480 # 7620 <malloc+0x2114>
    4808:	44d000ef          	jal	5454 <printf>
    exit(1);
    480c:	4505                	li	a0,1
    480e:	7f8000ef          	jal	5006 <exit>
  p = sbrklazy(1);
    4812:	4505                	li	a0,1
    4814:	7d4000ef          	jal	4fe8 <sbrklazy>
    4818:	85aa                	mv	a1,a0
  if ((uint64)p != -1) {
    481a:	57fd                	li	a5,-1
    481c:	00f50b63          	beq	a0,a5,4832 <lazy_sbrk+0xee>
    printf("sbrklazy(1) returned %p, expected error\n", p);
    4820:	00003517          	auipc	a0,0x3
    4824:	e2850513          	addi	a0,a0,-472 # 7648 <malloc+0x213c>
    4828:	42d000ef          	jal	5454 <printf>
    exit(1);
    482c:	4505                	li	a0,1
    482e:	7d8000ef          	jal	5006 <exit>
  exit(0);
    4832:	4501                	li	a0,0
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
    486c:	dd3c8c93          	addi	s9,s9,-557 # 10624dd3 <base+0x1061411b>
    name[2] = '0' + (nfiles % 1000) / 100;
    4870:	51eb8ab7          	lui	s5,0x51eb8
    4874:	51fa8a93          	addi	s5,s5,1311 # 51eb851f <base+0x51ea7867>
    name[3] = '0' + (nfiles % 100) / 10;
    4878:	66666a37          	lui	s4,0x66666
    487c:	667a0a13          	addi	s4,s4,1639 # 66666667 <base+0x666559af>
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
    4944:	dd3a0a13          	addi	s4,s4,-557 # 10624dd3 <base+0x1061411b>
    name[2] = '0' + (nfiles % 1000) / 100;
    4948:	3e800b93          	li	s7,1000
    494c:	51eb89b7          	lui	s3,0x51eb8
    4950:	51f98993          	addi	s3,s3,1311 # 51eb851f <base+0x51ea7867>
    name[3] = '0' + (nfiles % 100) / 10;
    4954:	06400b13          	li	s6,100
    4958:	66666937          	lui	s2,0x66666
    495c:	66790913          	addi	s2,s2,1639 # 66666667 <base+0x666559af>
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
    4a24:	298b8b93          	addi	s7,s7,664 # dcb8 <buf>
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
    4af2:	1679                	addi	a2,a2,-2 # ffe <bigdir+0x10a>
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
    4bde:	846c8c93          	addi	s9,s9,-1978 # a420 <slowtests>
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
    4ee8:	fd06879b          	addiw	a5,a3,-48 # 3ffd0 <base+0x2f318>
    4eec:	0ff7f793          	zext.b	a5,a5
    4ef0:	4625                	li	a2,9
    4ef2:	02f66963          	bltu	a2,a5,4f24 <atoi+0x48>
    4ef6:	872a                	mv	a4,a0
  n = 0;
    4ef8:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
    4efa:	0705                	addi	a4,a4,1 # 1000001 <base+0xfef349>
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
    50f2:	b3a80813          	addi	a6,a6,-1222 # 7c28 <digits>
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
    5316:	916b8b93          	addi	s7,s7,-1770 # 7c28 <digits>
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
    5370:	00003497          	auipc	s1,0x3
    5374:	80848493          	addi	s1,s1,-2040 # 7b78 <malloc+0x266c>
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
    5496:	ffe7b783          	ld	a5,-2(a5) # a490 <freep>
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
    54e4:	faf73823          	sd	a5,-80(a4) # a490 <freep>
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
    552e:	f6653503          	ld	a0,-154(a0) # a490 <freep>
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
    555a:	f3a48493          	addi	s1,s1,-198 # a490 <freep>
  if(p == SBRK_ERROR)
    555e:	5afd                	li	s5,-1
    5560:	a83d                	j	559e <malloc+0x92>
    5562:	f426                	sd	s1,40(sp)
    5564:	e852                	sd	s4,16(sp)
    5566:	e456                	sd	s5,8(sp)
    5568:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
    556a:	0000b797          	auipc	a5,0xb
    556e:	74e78793          	addi	a5,a5,1870 # 10cb8 <base>
    5572:	00005717          	auipc	a4,0x5
    5576:	f0f73f23          	sd	a5,-226(a4) # a490 <freep>
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
    55e0:	eaa73a23          	sd	a0,-332(a4) # a490 <freep>
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
