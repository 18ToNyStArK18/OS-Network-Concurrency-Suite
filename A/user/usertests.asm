
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
      14:	92078793          	addi	a5,a5,-1760 # 7930 <malloc+0x25d6>
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
      4a:	64b040ef          	jal	4e94 <open>
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
      70:	3e450513          	addi	a0,a0,996 # 5450 <malloc+0xf6>
      74:	22e050ef          	jal	52a2 <printf>
      exit(1);
      78:	4505                	li	a0,1
      7a:	5db040ef          	jal	4e54 <exit>

000000000000007e <bsstest>:
void
bsstest(char *s)
{
  int i;

  for(i = 0; i < sizeof(uninit); i++){
      7e:	0000a797          	auipc	a5,0xa
      82:	50a78793          	addi	a5,a5,1290 # a588 <uninit>
      86:	0000d697          	auipc	a3,0xd
      8a:	c1268693          	addi	a3,a3,-1006 # cc98 <buf>
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
      aa:	3ca50513          	addi	a0,a0,970 # 5470 <malloc+0x116>
      ae:	1f4050ef          	jal	52a2 <printf>
      exit(1);
      b2:	4505                	li	a0,1
      b4:	5a1040ef          	jal	4e54 <exit>

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
      ca:	3c250513          	addi	a0,a0,962 # 5488 <malloc+0x12e>
      ce:	5c7040ef          	jal	4e94 <open>
  if(fd < 0){
      d2:	02054263          	bltz	a0,f6 <opentest+0x3e>
  close(fd);
      d6:	5a7040ef          	jal	4e7c <close>
  fd = open("doesnotexist", 0);
      da:	4581                	li	a1,0
      dc:	00005517          	auipc	a0,0x5
      e0:	3cc50513          	addi	a0,a0,972 # 54a8 <malloc+0x14e>
      e4:	5b1040ef          	jal	4e94 <open>
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
      fc:	39850513          	addi	a0,a0,920 # 5490 <malloc+0x136>
     100:	1a2050ef          	jal	52a2 <printf>
    exit(1);
     104:	4505                	li	a0,1
     106:	54f040ef          	jal	4e54 <exit>
    printf("%s: open doesnotexist succeeded!\n", s);
     10a:	85a6                	mv	a1,s1
     10c:	00005517          	auipc	a0,0x5
     110:	3ac50513          	addi	a0,a0,940 # 54b8 <malloc+0x15e>
     114:	18e050ef          	jal	52a2 <printf>
    exit(1);
     118:	4505                	li	a0,1
     11a:	53b040ef          	jal	4e54 <exit>

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
     132:	3b250513          	addi	a0,a0,946 # 54e0 <malloc+0x186>
     136:	56f040ef          	jal	4ea4 <unlink>
  int fd1 = open("truncfile", O_CREATE|O_TRUNC|O_WRONLY);
     13a:	60100593          	li	a1,1537
     13e:	00005517          	auipc	a0,0x5
     142:	3a250513          	addi	a0,a0,930 # 54e0 <malloc+0x186>
     146:	54f040ef          	jal	4e94 <open>
     14a:	84aa                	mv	s1,a0
  write(fd1, "abcd", 4);
     14c:	4611                	li	a2,4
     14e:	00005597          	auipc	a1,0x5
     152:	3a258593          	addi	a1,a1,930 # 54f0 <malloc+0x196>
     156:	51f040ef          	jal	4e74 <write>
  int fd2 = open("truncfile", O_TRUNC|O_WRONLY);
     15a:	40100593          	li	a1,1025
     15e:	00005517          	auipc	a0,0x5
     162:	38250513          	addi	a0,a0,898 # 54e0 <malloc+0x186>
     166:	52f040ef          	jal	4e94 <open>
     16a:	892a                	mv	s2,a0
  int n = write(fd1, "x", 1);
     16c:	4605                	li	a2,1
     16e:	00005597          	auipc	a1,0x5
     172:	38a58593          	addi	a1,a1,906 # 54f8 <malloc+0x19e>
     176:	8526                	mv	a0,s1
     178:	4fd040ef          	jal	4e74 <write>
  if(n != -1){
     17c:	57fd                	li	a5,-1
     17e:	02f51563          	bne	a0,a5,1a8 <truncate2+0x8a>
  unlink("truncfile");
     182:	00005517          	auipc	a0,0x5
     186:	35e50513          	addi	a0,a0,862 # 54e0 <malloc+0x186>
     18a:	51b040ef          	jal	4ea4 <unlink>
  close(fd1);
     18e:	8526                	mv	a0,s1
     190:	4ed040ef          	jal	4e7c <close>
  close(fd2);
     194:	854a                	mv	a0,s2
     196:	4e7040ef          	jal	4e7c <close>
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
     1b0:	35450513          	addi	a0,a0,852 # 5500 <malloc+0x1a6>
     1b4:	0ee050ef          	jal	52a2 <printf>
    exit(1);
     1b8:	4505                	li	a0,1
     1ba:	49b040ef          	jal	4e54 <exit>

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
     1f2:	4a3040ef          	jal	4e94 <open>
    close(fd);
     1f6:	487040ef          	jal	4e7c <close>
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
     222:	483040ef          	jal	4ea4 <unlink>
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
     260:	2cc50513          	addi	a0,a0,716 # 5528 <malloc+0x1ce>
     264:	441040ef          	jal	4ea4 <unlink>
  for(sz = 499; sz < (MAXOPBLOCKS+2)*BSIZE; sz += 471){
     268:	1f300493          	li	s1,499
    fd = open("bigwrite", O_CREATE | O_RDWR);
     26c:	20200b93          	li	s7,514
     270:	00005a17          	auipc	s4,0x5
     274:	2b8a0a13          	addi	s4,s4,696 # 5528 <malloc+0x1ce>
     278:	4b09                	li	s6,2
      int cc = write(fd, buf, sz);
     27a:	0000d997          	auipc	s3,0xd
     27e:	a1e98993          	addi	s3,s3,-1506 # cc98 <buf>
  for(sz = 499; sz < (MAXOPBLOCKS+2)*BSIZE; sz += 471){
     282:	6a8d                	lui	s5,0x3
     284:	1c9a8a93          	addi	s5,s5,457 # 31c9 <subdir+0x589>
    fd = open("bigwrite", O_CREATE | O_RDWR);
     288:	85de                	mv	a1,s7
     28a:	8552                	mv	a0,s4
     28c:	409040ef          	jal	4e94 <open>
     290:	892a                	mv	s2,a0
    if(fd < 0){
     292:	04054463          	bltz	a0,2da <bigwrite+0x9a>
     296:	8c5a                	mv	s8,s6
      int cc = write(fd, buf, sz);
     298:	8626                	mv	a2,s1
     29a:	85ce                	mv	a1,s3
     29c:	854a                	mv	a0,s2
     29e:	3d7040ef          	jal	4e74 <write>
      if(cc != sz){
     2a2:	04951663          	bne	a0,s1,2ee <bigwrite+0xae>
    for(i = 0; i < 2; i++){
     2a6:	3c7d                	addiw	s8,s8,-1
     2a8:	fe0c18e3          	bnez	s8,298 <bigwrite+0x58>
    close(fd);
     2ac:	854a                	mv	a0,s2
     2ae:	3cf040ef          	jal	4e7c <close>
    unlink("bigwrite");
     2b2:	8552                	mv	a0,s4
     2b4:	3f1040ef          	jal	4ea4 <unlink>
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
     2e0:	25c50513          	addi	a0,a0,604 # 5538 <malloc+0x1de>
     2e4:	7bf040ef          	jal	52a2 <printf>
      exit(1);
     2e8:	4505                	li	a0,1
     2ea:	36b040ef          	jal	4e54 <exit>
        printf("%s: write(%d) ret %d\n", s, sz, cc);
     2ee:	86aa                	mv	a3,a0
     2f0:	8626                	mv	a2,s1
     2f2:	85e6                	mv	a1,s9
     2f4:	00005517          	auipc	a0,0x5
     2f8:	26450513          	addi	a0,a0,612 # 5558 <malloc+0x1fe>
     2fc:	7a7040ef          	jal	52a2 <printf>
        exit(1);
     300:	4505                	li	a0,1
     302:	353040ef          	jal	4e54 <exit>

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
     31e:	25650513          	addi	a0,a0,598 # 5570 <malloc+0x216>
     322:	383040ef          	jal	4ea4 <unlink>
     326:	25800913          	li	s2,600
  for(int i = 0; i < assumed_free; i++){
    int fd = open("junk", O_CREATE|O_WRONLY);
     32a:	20100a93          	li	s5,513
     32e:	00005997          	auipc	s3,0x5
     332:	24298993          	addi	s3,s3,578 # 5570 <malloc+0x216>
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
     342:	353040ef          	jal	4e94 <open>
     346:	84aa                	mv	s1,a0
    if(fd < 0){
     348:	04054d63          	bltz	a0,3a2 <badwrite+0x9c>
    write(fd, (char*)0xffffffffffL, 1);
     34c:	865a                	mv	a2,s6
     34e:	85d2                	mv	a1,s4
     350:	325040ef          	jal	4e74 <write>
    close(fd);
     354:	8526                	mv	a0,s1
     356:	327040ef          	jal	4e7c <close>
    unlink("junk");
     35a:	854e                	mv	a0,s3
     35c:	349040ef          	jal	4ea4 <unlink>
  for(int i = 0; i < assumed_free; i++){
     360:	397d                	addiw	s2,s2,-1
     362:	fc091ee3          	bnez	s2,33e <badwrite+0x38>
  }

  int fd = open("junk", O_CREATE|O_WRONLY);
     366:	20100593          	li	a1,513
     36a:	00005517          	auipc	a0,0x5
     36e:	20650513          	addi	a0,a0,518 # 5570 <malloc+0x216>
     372:	323040ef          	jal	4e94 <open>
     376:	84aa                	mv	s1,a0
  if(fd < 0){
     378:	02054e63          	bltz	a0,3b4 <badwrite+0xae>
    printf("open junk failed\n");
    exit(1);
  }
  if(write(fd, "x", 1) != 1){
     37c:	4605                	li	a2,1
     37e:	00005597          	auipc	a1,0x5
     382:	17a58593          	addi	a1,a1,378 # 54f8 <malloc+0x19e>
     386:	2ef040ef          	jal	4e74 <write>
     38a:	4785                	li	a5,1
     38c:	02f50d63          	beq	a0,a5,3c6 <badwrite+0xc0>
    printf("write failed\n");
     390:	00005517          	auipc	a0,0x5
     394:	20050513          	addi	a0,a0,512 # 5590 <malloc+0x236>
     398:	70b040ef          	jal	52a2 <printf>
    exit(1);
     39c:	4505                	li	a0,1
     39e:	2b7040ef          	jal	4e54 <exit>
      printf("open junk failed\n");
     3a2:	00005517          	auipc	a0,0x5
     3a6:	1d650513          	addi	a0,a0,470 # 5578 <malloc+0x21e>
     3aa:	6f9040ef          	jal	52a2 <printf>
      exit(1);
     3ae:	4505                	li	a0,1
     3b0:	2a5040ef          	jal	4e54 <exit>
    printf("open junk failed\n");
     3b4:	00005517          	auipc	a0,0x5
     3b8:	1c450513          	addi	a0,a0,452 # 5578 <malloc+0x21e>
     3bc:	6e7040ef          	jal	52a2 <printf>
    exit(1);
     3c0:	4505                	li	a0,1
     3c2:	293040ef          	jal	4e54 <exit>
  }
  close(fd);
     3c6:	8526                	mv	a0,s1
     3c8:	2b5040ef          	jal	4e7c <close>
  unlink("junk");
     3cc:	00005517          	auipc	a0,0x5
     3d0:	1a450513          	addi	a0,a0,420 # 5570 <malloc+0x216>
     3d4:	2d1040ef          	jal	4ea4 <unlink>

  exit(0);
     3d8:	4501                	li	a0,0
     3da:	27b040ef          	jal	4e54 <exit>

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
     434:	271040ef          	jal	4ea4 <unlink>
    int fd = open(name, O_CREATE|O_RDWR|O_TRUNC);
     438:	85d2                	mv	a1,s4
     43a:	854a                	mv	a0,s2
     43c:	259040ef          	jal	4e94 <open>
    if(fd < 0){
     440:	00054763          	bltz	a0,44e <outofinodes+0x70>
      // failure is eventually expected.
      break;
    }
    close(fd);
     444:	239040ef          	jal	4e7c <close>
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
     48e:	217040ef          	jal	4ea4 <unlink>
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
     4c8:	46c78793          	addi	a5,a5,1132 # 7930 <malloc+0x25d6>
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
     4fa:	0aaa8a93          	addi	s5,s5,170 # 55a0 <malloc+0x246>
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
     50e:	187040ef          	jal	4e94 <open>
     512:	84aa                	mv	s1,a0
    if(fd < 0){
     514:	06054a63          	bltz	a0,588 <copyin+0xde>
    int n = write(fd, (void*)addr, 8192);
     518:	8652                	mv	a2,s4
     51a:	85ce                	mv	a1,s3
     51c:	159040ef          	jal	4e74 <write>
    if(n >= 0){
     520:	06055d63          	bgez	a0,59a <copyin+0xf0>
    close(fd);
     524:	8526                	mv	a0,s1
     526:	157040ef          	jal	4e7c <close>
    unlink("copyin1");
     52a:	8556                	mv	a0,s5
     52c:	179040ef          	jal	4ea4 <unlink>
    n = write(1, (char*)addr, 8192);
     530:	8652                	mv	a2,s4
     532:	85ce                	mv	a1,s3
     534:	8562                	mv	a0,s8
     536:	13f040ef          	jal	4e74 <write>
    if(n > 0){
     53a:	06a04b63          	bgtz	a0,5b0 <copyin+0x106>
    if(pipe(fds) < 0){
     53e:	855e                	mv	a0,s7
     540:	125040ef          	jal	4e64 <pipe>
     544:	08054163          	bltz	a0,5c6 <copyin+0x11c>
    n = write(fds[1], (char*)addr, 8192);
     548:	8652                	mv	a2,s4
     54a:	85ce                	mv	a1,s3
     54c:	f7442503          	lw	a0,-140(s0)
     550:	125040ef          	jal	4e74 <write>
    if(n > 0){
     554:	08a04263          	bgtz	a0,5d8 <copyin+0x12e>
    close(fds[0]);
     558:	f7042503          	lw	a0,-144(s0)
     55c:	121040ef          	jal	4e7c <close>
    close(fds[1]);
     560:	f7442503          	lw	a0,-140(s0)
     564:	119040ef          	jal	4e7c <close>
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
     58c:	02050513          	addi	a0,a0,32 # 55a8 <malloc+0x24e>
     590:	513040ef          	jal	52a2 <printf>
      exit(1);
     594:	4505                	li	a0,1
     596:	0bf040ef          	jal	4e54 <exit>
      printf("write(fd, %p, 8192) returned %d, not -1\n", (void*)addr, n);
     59a:	862a                	mv	a2,a0
     59c:	85ce                	mv	a1,s3
     59e:	00005517          	auipc	a0,0x5
     5a2:	02250513          	addi	a0,a0,34 # 55c0 <malloc+0x266>
     5a6:	4fd040ef          	jal	52a2 <printf>
      exit(1);
     5aa:	4505                	li	a0,1
     5ac:	0a9040ef          	jal	4e54 <exit>
      printf("write(1, %p, 8192) returned %d, not -1 or 0\n", (void*)addr, n);
     5b0:	862a                	mv	a2,a0
     5b2:	85ce                	mv	a1,s3
     5b4:	00005517          	auipc	a0,0x5
     5b8:	03c50513          	addi	a0,a0,60 # 55f0 <malloc+0x296>
     5bc:	4e7040ef          	jal	52a2 <printf>
      exit(1);
     5c0:	4505                	li	a0,1
     5c2:	093040ef          	jal	4e54 <exit>
      printf("pipe() failed\n");
     5c6:	00005517          	auipc	a0,0x5
     5ca:	05a50513          	addi	a0,a0,90 # 5620 <malloc+0x2c6>
     5ce:	4d5040ef          	jal	52a2 <printf>
      exit(1);
     5d2:	4505                	li	a0,1
     5d4:	081040ef          	jal	4e54 <exit>
      printf("write(pipe, %p, 8192) returned %d, not -1 or 0\n", (void*)addr, n);
     5d8:	862a                	mv	a2,a0
     5da:	85ce                	mv	a1,s3
     5dc:	00005517          	auipc	a0,0x5
     5e0:	05450513          	addi	a0,a0,84 # 5630 <malloc+0x2d6>
     5e4:	4bf040ef          	jal	52a2 <printf>
      exit(1);
     5e8:	4505                	li	a0,1
     5ea:	06b040ef          	jal	4e54 <exit>

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
     60c:	32878793          	addi	a5,a5,808 # 7930 <malloc+0x25d6>
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
     640:	024b0b13          	addi	s6,s6,36 # 5660 <malloc+0x306>
    int n = read(fd, (void*)addr, 8192);
     644:	6a89                	lui	s5,0x2
    if(pipe(fds) < 0){
     646:	f6840c13          	addi	s8,s0,-152
    n = write(fds[1], "x", 1);
     64a:	4a05                	li	s4,1
     64c:	00005b97          	auipc	s7,0x5
     650:	eacb8b93          	addi	s7,s7,-340 # 54f8 <malloc+0x19e>
    uint64 addr = addrs[ai];
     654:	00093983          	ld	s3,0(s2)
    int fd = open("README", 0);
     658:	4581                	li	a1,0
     65a:	855a                	mv	a0,s6
     65c:	039040ef          	jal	4e94 <open>
     660:	84aa                	mv	s1,a0
    if(fd < 0){
     662:	06054863          	bltz	a0,6d2 <copyout+0xe4>
    int n = read(fd, (void*)addr, 8192);
     666:	8656                	mv	a2,s5
     668:	85ce                	mv	a1,s3
     66a:	003040ef          	jal	4e6c <read>
    if(n > 0){
     66e:	06a04b63          	bgtz	a0,6e4 <copyout+0xf6>
    close(fd);
     672:	8526                	mv	a0,s1
     674:	009040ef          	jal	4e7c <close>
    if(pipe(fds) < 0){
     678:	8562                	mv	a0,s8
     67a:	7ea040ef          	jal	4e64 <pipe>
     67e:	06054e63          	bltz	a0,6fa <copyout+0x10c>
    n = write(fds[1], "x", 1);
     682:	8652                	mv	a2,s4
     684:	85de                	mv	a1,s7
     686:	f6c42503          	lw	a0,-148(s0)
     68a:	7ea040ef          	jal	4e74 <write>
    if(n != 1){
     68e:	07451f63          	bne	a0,s4,70c <copyout+0x11e>
    n = read(fds[0], (void*)addr, 8192);
     692:	8656                	mv	a2,s5
     694:	85ce                	mv	a1,s3
     696:	f6842503          	lw	a0,-152(s0)
     69a:	7d2040ef          	jal	4e6c <read>
    if(n > 0){
     69e:	08a04063          	bgtz	a0,71e <copyout+0x130>
    close(fds[0]);
     6a2:	f6842503          	lw	a0,-152(s0)
     6a6:	7d6040ef          	jal	4e7c <close>
    close(fds[1]);
     6aa:	f6c42503          	lw	a0,-148(s0)
     6ae:	7ce040ef          	jal	4e7c <close>
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
     6d6:	f9650513          	addi	a0,a0,-106 # 5668 <malloc+0x30e>
     6da:	3c9040ef          	jal	52a2 <printf>
      exit(1);
     6de:	4505                	li	a0,1
     6e0:	774040ef          	jal	4e54 <exit>
      printf("read(fd, %p, 8192) returned %d, not -1 or 0\n", (void*)addr, n);
     6e4:	862a                	mv	a2,a0
     6e6:	85ce                	mv	a1,s3
     6e8:	00005517          	auipc	a0,0x5
     6ec:	f9850513          	addi	a0,a0,-104 # 5680 <malloc+0x326>
     6f0:	3b3040ef          	jal	52a2 <printf>
      exit(1);
     6f4:	4505                	li	a0,1
     6f6:	75e040ef          	jal	4e54 <exit>
      printf("pipe() failed\n");
     6fa:	00005517          	auipc	a0,0x5
     6fe:	f2650513          	addi	a0,a0,-218 # 5620 <malloc+0x2c6>
     702:	3a1040ef          	jal	52a2 <printf>
      exit(1);
     706:	4505                	li	a0,1
     708:	74c040ef          	jal	4e54 <exit>
      printf("pipe write failed\n");
     70c:	00005517          	auipc	a0,0x5
     710:	fa450513          	addi	a0,a0,-92 # 56b0 <malloc+0x356>
     714:	38f040ef          	jal	52a2 <printf>
      exit(1);
     718:	4505                	li	a0,1
     71a:	73a040ef          	jal	4e54 <exit>
      printf("read(pipe, %p, 8192) returned %d, not -1 or 0\n", (void*)addr, n);
     71e:	862a                	mv	a2,a0
     720:	85ce                	mv	a1,s3
     722:	00005517          	auipc	a0,0x5
     726:	fa650513          	addi	a0,a0,-90 # 56c8 <malloc+0x36e>
     72a:	379040ef          	jal	52a2 <printf>
      exit(1);
     72e:	4505                	li	a0,1
     730:	724040ef          	jal	4e54 <exit>

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
     74c:	d9850513          	addi	a0,a0,-616 # 54e0 <malloc+0x186>
     750:	754040ef          	jal	4ea4 <unlink>
  int fd1 = open("truncfile", O_CREATE|O_WRONLY|O_TRUNC);
     754:	60100593          	li	a1,1537
     758:	00005517          	auipc	a0,0x5
     75c:	d8850513          	addi	a0,a0,-632 # 54e0 <malloc+0x186>
     760:	734040ef          	jal	4e94 <open>
     764:	84aa                	mv	s1,a0
  write(fd1, "abcd", 4);
     766:	4611                	li	a2,4
     768:	00005597          	auipc	a1,0x5
     76c:	d8858593          	addi	a1,a1,-632 # 54f0 <malloc+0x196>
     770:	704040ef          	jal	4e74 <write>
  close(fd1);
     774:	8526                	mv	a0,s1
     776:	706040ef          	jal	4e7c <close>
  int fd2 = open("truncfile", O_RDONLY);
     77a:	4581                	li	a1,0
     77c:	00005517          	auipc	a0,0x5
     780:	d6450513          	addi	a0,a0,-668 # 54e0 <malloc+0x186>
     784:	710040ef          	jal	4e94 <open>
     788:	84aa                	mv	s1,a0
  int n = read(fd2, buf, sizeof(buf));
     78a:	02000613          	li	a2,32
     78e:	fa040593          	addi	a1,s0,-96
     792:	6da040ef          	jal	4e6c <read>
  if(n != 4){
     796:	4791                	li	a5,4
     798:	0af51863          	bne	a0,a5,848 <truncate1+0x114>
  fd1 = open("truncfile", O_WRONLY|O_TRUNC);
     79c:	40100593          	li	a1,1025
     7a0:	00005517          	auipc	a0,0x5
     7a4:	d4050513          	addi	a0,a0,-704 # 54e0 <malloc+0x186>
     7a8:	6ec040ef          	jal	4e94 <open>
     7ac:	89aa                	mv	s3,a0
  int fd3 = open("truncfile", O_RDONLY);
     7ae:	4581                	li	a1,0
     7b0:	00005517          	auipc	a0,0x5
     7b4:	d3050513          	addi	a0,a0,-720 # 54e0 <malloc+0x186>
     7b8:	6dc040ef          	jal	4e94 <open>
     7bc:	892a                	mv	s2,a0
  n = read(fd3, buf, sizeof(buf));
     7be:	02000613          	li	a2,32
     7c2:	fa040593          	addi	a1,s0,-96
     7c6:	6a6040ef          	jal	4e6c <read>
     7ca:	8aaa                	mv	s5,a0
  if(n != 0){
     7cc:	e949                	bnez	a0,85e <truncate1+0x12a>
  n = read(fd2, buf, sizeof(buf));
     7ce:	02000613          	li	a2,32
     7d2:	fa040593          	addi	a1,s0,-96
     7d6:	8526                	mv	a0,s1
     7d8:	694040ef          	jal	4e6c <read>
     7dc:	8aaa                	mv	s5,a0
  if(n != 0){
     7de:	e155                	bnez	a0,882 <truncate1+0x14e>
  write(fd1, "abcdef", 6);
     7e0:	4619                	li	a2,6
     7e2:	00005597          	auipc	a1,0x5
     7e6:	f7658593          	addi	a1,a1,-138 # 5758 <malloc+0x3fe>
     7ea:	854e                	mv	a0,s3
     7ec:	688040ef          	jal	4e74 <write>
  n = read(fd3, buf, sizeof(buf));
     7f0:	02000613          	li	a2,32
     7f4:	fa040593          	addi	a1,s0,-96
     7f8:	854a                	mv	a0,s2
     7fa:	672040ef          	jal	4e6c <read>
  if(n != 6){
     7fe:	4799                	li	a5,6
     800:	0af51363          	bne	a0,a5,8a6 <truncate1+0x172>
  n = read(fd2, buf, sizeof(buf));
     804:	02000613          	li	a2,32
     808:	fa040593          	addi	a1,s0,-96
     80c:	8526                	mv	a0,s1
     80e:	65e040ef          	jal	4e6c <read>
  if(n != 2){
     812:	4789                	li	a5,2
     814:	0af51463          	bne	a0,a5,8bc <truncate1+0x188>
  unlink("truncfile");
     818:	00005517          	auipc	a0,0x5
     81c:	cc850513          	addi	a0,a0,-824 # 54e0 <malloc+0x186>
     820:	684040ef          	jal	4ea4 <unlink>
  close(fd1);
     824:	854e                	mv	a0,s3
     826:	656040ef          	jal	4e7c <close>
  close(fd2);
     82a:	8526                	mv	a0,s1
     82c:	650040ef          	jal	4e7c <close>
  close(fd3);
     830:	854a                	mv	a0,s2
     832:	64a040ef          	jal	4e7c <close>
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
     850:	eac50513          	addi	a0,a0,-340 # 56f8 <malloc+0x39e>
     854:	24f040ef          	jal	52a2 <printf>
    exit(1);
     858:	4505                	li	a0,1
     85a:	5fa040ef          	jal	4e54 <exit>
    printf("aaa fd3=%d\n", fd3);
     85e:	85ca                	mv	a1,s2
     860:	00005517          	auipc	a0,0x5
     864:	eb850513          	addi	a0,a0,-328 # 5718 <malloc+0x3be>
     868:	23b040ef          	jal	52a2 <printf>
    printf("%s: read %d bytes, wanted 0\n", s, n);
     86c:	8656                	mv	a2,s5
     86e:	85d2                	mv	a1,s4
     870:	00005517          	auipc	a0,0x5
     874:	eb850513          	addi	a0,a0,-328 # 5728 <malloc+0x3ce>
     878:	22b040ef          	jal	52a2 <printf>
    exit(1);
     87c:	4505                	li	a0,1
     87e:	5d6040ef          	jal	4e54 <exit>
    printf("bbb fd2=%d\n", fd2);
     882:	85a6                	mv	a1,s1
     884:	00005517          	auipc	a0,0x5
     888:	ec450513          	addi	a0,a0,-316 # 5748 <malloc+0x3ee>
     88c:	217040ef          	jal	52a2 <printf>
    printf("%s: read %d bytes, wanted 0\n", s, n);
     890:	8656                	mv	a2,s5
     892:	85d2                	mv	a1,s4
     894:	00005517          	auipc	a0,0x5
     898:	e9450513          	addi	a0,a0,-364 # 5728 <malloc+0x3ce>
     89c:	207040ef          	jal	52a2 <printf>
    exit(1);
     8a0:	4505                	li	a0,1
     8a2:	5b2040ef          	jal	4e54 <exit>
    printf("%s: read %d bytes, wanted 6\n", s, n);
     8a6:	862a                	mv	a2,a0
     8a8:	85d2                	mv	a1,s4
     8aa:	00005517          	auipc	a0,0x5
     8ae:	eb650513          	addi	a0,a0,-330 # 5760 <malloc+0x406>
     8b2:	1f1040ef          	jal	52a2 <printf>
    exit(1);
     8b6:	4505                	li	a0,1
     8b8:	59c040ef          	jal	4e54 <exit>
    printf("%s: read %d bytes, wanted 2\n", s, n);
     8bc:	862a                	mv	a2,a0
     8be:	85d2                	mv	a1,s4
     8c0:	00005517          	auipc	a0,0x5
     8c4:	ec050513          	addi	a0,a0,-320 # 5780 <malloc+0x426>
     8c8:	1db040ef          	jal	52a2 <printf>
    exit(1);
     8cc:	4505                	li	a0,1
     8ce:	586040ef          	jal	4e54 <exit>

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
     8f2:	eb250513          	addi	a0,a0,-334 # 57a0 <malloc+0x446>
     8f6:	59e040ef          	jal	4e94 <open>
  if(fd < 0){
     8fa:	08054f63          	bltz	a0,998 <writetest+0xc6>
     8fe:	89aa                	mv	s3,a0
     900:	4901                	li	s2,0
    if(write(fd, "aaaaaaaaaa", SZ) != SZ){
     902:	44a9                	li	s1,10
     904:	00005a17          	auipc	s4,0x5
     908:	ec4a0a13          	addi	s4,s4,-316 # 57c8 <malloc+0x46e>
    if(write(fd, "bbbbbbbbbb", SZ) != SZ){
     90c:	00005b17          	auipc	s6,0x5
     910:	ef4b0b13          	addi	s6,s6,-268 # 5800 <malloc+0x4a6>
  for(i = 0; i < N; i++){
     914:	06400a93          	li	s5,100
    if(write(fd, "aaaaaaaaaa", SZ) != SZ){
     918:	8626                	mv	a2,s1
     91a:	85d2                	mv	a1,s4
     91c:	854e                	mv	a0,s3
     91e:	556040ef          	jal	4e74 <write>
     922:	08951563          	bne	a0,s1,9ac <writetest+0xda>
    if(write(fd, "bbbbbbbbbb", SZ) != SZ){
     926:	8626                	mv	a2,s1
     928:	85da                	mv	a1,s6
     92a:	854e                	mv	a0,s3
     92c:	548040ef          	jal	4e74 <write>
     930:	08951963          	bne	a0,s1,9c2 <writetest+0xf0>
  for(i = 0; i < N; i++){
     934:	2905                	addiw	s2,s2,1
     936:	ff5911e3          	bne	s2,s5,918 <writetest+0x46>
  close(fd);
     93a:	854e                	mv	a0,s3
     93c:	540040ef          	jal	4e7c <close>
  fd = open("small", O_RDONLY);
     940:	4581                	li	a1,0
     942:	00005517          	auipc	a0,0x5
     946:	e5e50513          	addi	a0,a0,-418 # 57a0 <malloc+0x446>
     94a:	54a040ef          	jal	4e94 <open>
     94e:	84aa                	mv	s1,a0
  if(fd < 0){
     950:	08054463          	bltz	a0,9d8 <writetest+0x106>
  i = read(fd, buf, N*SZ*2);
     954:	7d000613          	li	a2,2000
     958:	0000c597          	auipc	a1,0xc
     95c:	34058593          	addi	a1,a1,832 # cc98 <buf>
     960:	50c040ef          	jal	4e6c <read>
  if(i != N*SZ*2){
     964:	7d000793          	li	a5,2000
     968:	08f51263          	bne	a0,a5,9ec <writetest+0x11a>
  close(fd);
     96c:	8526                	mv	a0,s1
     96e:	50e040ef          	jal	4e7c <close>
  if(unlink("small") < 0){
     972:	00005517          	auipc	a0,0x5
     976:	e2e50513          	addi	a0,a0,-466 # 57a0 <malloc+0x446>
     97a:	52a040ef          	jal	4ea4 <unlink>
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
     99e:	e0e50513          	addi	a0,a0,-498 # 57a8 <malloc+0x44e>
     9a2:	101040ef          	jal	52a2 <printf>
    exit(1);
     9a6:	4505                	li	a0,1
     9a8:	4ac040ef          	jal	4e54 <exit>
      printf("%s: error: write aa %d new file failed\n", s, i);
     9ac:	864a                	mv	a2,s2
     9ae:	85de                	mv	a1,s7
     9b0:	00005517          	auipc	a0,0x5
     9b4:	e2850513          	addi	a0,a0,-472 # 57d8 <malloc+0x47e>
     9b8:	0eb040ef          	jal	52a2 <printf>
      exit(1);
     9bc:	4505                	li	a0,1
     9be:	496040ef          	jal	4e54 <exit>
      printf("%s: error: write bb %d new file failed\n", s, i);
     9c2:	864a                	mv	a2,s2
     9c4:	85de                	mv	a1,s7
     9c6:	00005517          	auipc	a0,0x5
     9ca:	e4a50513          	addi	a0,a0,-438 # 5810 <malloc+0x4b6>
     9ce:	0d5040ef          	jal	52a2 <printf>
      exit(1);
     9d2:	4505                	li	a0,1
     9d4:	480040ef          	jal	4e54 <exit>
    printf("%s: error: open small failed!\n", s);
     9d8:	85de                	mv	a1,s7
     9da:	00005517          	auipc	a0,0x5
     9de:	e5e50513          	addi	a0,a0,-418 # 5838 <malloc+0x4de>
     9e2:	0c1040ef          	jal	52a2 <printf>
    exit(1);
     9e6:	4505                	li	a0,1
     9e8:	46c040ef          	jal	4e54 <exit>
    printf("%s: read failed\n", s);
     9ec:	85de                	mv	a1,s7
     9ee:	00005517          	auipc	a0,0x5
     9f2:	e6a50513          	addi	a0,a0,-406 # 5858 <malloc+0x4fe>
     9f6:	0ad040ef          	jal	52a2 <printf>
    exit(1);
     9fa:	4505                	li	a0,1
     9fc:	458040ef          	jal	4e54 <exit>
    printf("%s: unlink small failed\n", s);
     a00:	85de                	mv	a1,s7
     a02:	00005517          	auipc	a0,0x5
     a06:	e6e50513          	addi	a0,a0,-402 # 5870 <malloc+0x516>
     a0a:	099040ef          	jal	52a2 <printf>
    exit(1);
     a0e:	4505                	li	a0,1
     a10:	444040ef          	jal	4e54 <exit>

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
     a32:	e6250513          	addi	a0,a0,-414 # 5890 <malloc+0x536>
     a36:	45e040ef          	jal	4e94 <open>
  if(fd < 0){
     a3a:	06054a63          	bltz	a0,aae <writebig+0x9a>
     a3e:	8a2a                	mv	s4,a0
     a40:	4481                	li	s1,0
    ((int*)buf)[0] = i;
     a42:	0000c997          	auipc	s3,0xc
     a46:	25698993          	addi	s3,s3,598 # cc98 <buf>
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
     a5c:	418040ef          	jal	4e74 <write>
     a60:	07251163          	bne	a0,s2,ac2 <writebig+0xae>
  for(i = 0; i < MAXFILE; i++){
     a64:	2485                	addiw	s1,s1,1
     a66:	ff5496e3          	bne	s1,s5,a52 <writebig+0x3e>
  close(fd);
     a6a:	8552                	mv	a0,s4
     a6c:	410040ef          	jal	4e7c <close>
  fd = open("big", O_RDONLY);
     a70:	4581                	li	a1,0
     a72:	00005517          	auipc	a0,0x5
     a76:	e1e50513          	addi	a0,a0,-482 # 5890 <malloc+0x536>
     a7a:	41a040ef          	jal	4e94 <open>
     a7e:	8a2a                	mv	s4,a0
  n = 0;
     a80:	4481                	li	s1,0
    i = read(fd, buf, BSIZE);
     a82:	40000993          	li	s3,1024
     a86:	0000c917          	auipc	s2,0xc
     a8a:	21290913          	addi	s2,s2,530 # cc98 <buf>
  if(fd < 0){
     a8e:	04054563          	bltz	a0,ad8 <writebig+0xc4>
    i = read(fd, buf, BSIZE);
     a92:	864e                	mv	a2,s3
     a94:	85ca                	mv	a1,s2
     a96:	8552                	mv	a0,s4
     a98:	3d4040ef          	jal	4e6c <read>
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
     ab4:	de850513          	addi	a0,a0,-536 # 5898 <malloc+0x53e>
     ab8:	7ea040ef          	jal	52a2 <printf>
    exit(1);
     abc:	4505                	li	a0,1
     abe:	396040ef          	jal	4e54 <exit>
      printf("%s: error: write big file failed i=%d\n", s, i);
     ac2:	8626                	mv	a2,s1
     ac4:	85da                	mv	a1,s6
     ac6:	00005517          	auipc	a0,0x5
     aca:	df250513          	addi	a0,a0,-526 # 58b8 <malloc+0x55e>
     ace:	7d4040ef          	jal	52a2 <printf>
      exit(1);
     ad2:	4505                	li	a0,1
     ad4:	380040ef          	jal	4e54 <exit>
    printf("%s: error: open big failed!\n", s);
     ad8:	85da                	mv	a1,s6
     ada:	00005517          	auipc	a0,0x5
     ade:	e0650513          	addi	a0,a0,-506 # 58e0 <malloc+0x586>
     ae2:	7c0040ef          	jal	52a2 <printf>
    exit(1);
     ae6:	4505                	li	a0,1
     ae8:	36c040ef          	jal	4e54 <exit>
      if(n != MAXFILE){
     aec:	10c00793          	li	a5,268
     af0:	02f49763          	bne	s1,a5,b1e <writebig+0x10a>
  close(fd);
     af4:	8552                	mv	a0,s4
     af6:	386040ef          	jal	4e7c <close>
  if(unlink("big") < 0){
     afa:	00005517          	auipc	a0,0x5
     afe:	d9650513          	addi	a0,a0,-618 # 5890 <malloc+0x536>
     b02:	3a2040ef          	jal	4ea4 <unlink>
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
     b26:	dde50513          	addi	a0,a0,-546 # 5900 <malloc+0x5a6>
     b2a:	778040ef          	jal	52a2 <printf>
        exit(1);
     b2e:	4505                	li	a0,1
     b30:	324040ef          	jal	4e54 <exit>
      printf("%s: read failed %d\n", s, i);
     b34:	862a                	mv	a2,a0
     b36:	85da                	mv	a1,s6
     b38:	00005517          	auipc	a0,0x5
     b3c:	df050513          	addi	a0,a0,-528 # 5928 <malloc+0x5ce>
     b40:	762040ef          	jal	52a2 <printf>
      exit(1);
     b44:	4505                	li	a0,1
     b46:	30e040ef          	jal	4e54 <exit>
      printf("%s: read content of block %d is %d\n", s,
     b4a:	8626                	mv	a2,s1
     b4c:	85da                	mv	a1,s6
     b4e:	00005517          	auipc	a0,0x5
     b52:	df250513          	addi	a0,a0,-526 # 5940 <malloc+0x5e6>
     b56:	74c040ef          	jal	52a2 <printf>
      exit(1);
     b5a:	4505                	li	a0,1
     b5c:	2f8040ef          	jal	4e54 <exit>
    printf("%s: unlink big failed\n", s);
     b60:	85da                	mv	a1,s6
     b62:	00005517          	auipc	a0,0x5
     b66:	e0650513          	addi	a0,a0,-506 # 5968 <malloc+0x60e>
     b6a:	738040ef          	jal	52a2 <printf>
    exit(1);
     b6e:	4505                	li	a0,1
     b70:	2e4040ef          	jal	4e54 <exit>

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
     b8c:	df850513          	addi	a0,a0,-520 # 5980 <malloc+0x626>
     b90:	304040ef          	jal	4e94 <open>
  if(fd < 0){
     b94:	0a054f63          	bltz	a0,c52 <unlinkread+0xde>
     b98:	84aa                	mv	s1,a0
  write(fd, "hello", SZ);
     b9a:	4615                	li	a2,5
     b9c:	00005597          	auipc	a1,0x5
     ba0:	e1458593          	addi	a1,a1,-492 # 59b0 <malloc+0x656>
     ba4:	2d0040ef          	jal	4e74 <write>
  close(fd);
     ba8:	8526                	mv	a0,s1
     baa:	2d2040ef          	jal	4e7c <close>
  fd = open("unlinkread", O_RDWR);
     bae:	4589                	li	a1,2
     bb0:	00005517          	auipc	a0,0x5
     bb4:	dd050513          	addi	a0,a0,-560 # 5980 <malloc+0x626>
     bb8:	2dc040ef          	jal	4e94 <open>
     bbc:	84aa                	mv	s1,a0
  if(fd < 0){
     bbe:	0a054463          	bltz	a0,c66 <unlinkread+0xf2>
  if(unlink("unlinkread") != 0){
     bc2:	00005517          	auipc	a0,0x5
     bc6:	dbe50513          	addi	a0,a0,-578 # 5980 <malloc+0x626>
     bca:	2da040ef          	jal	4ea4 <unlink>
     bce:	e555                	bnez	a0,c7a <unlinkread+0x106>
  fd1 = open("unlinkread", O_CREATE | O_RDWR);
     bd0:	20200593          	li	a1,514
     bd4:	00005517          	auipc	a0,0x5
     bd8:	dac50513          	addi	a0,a0,-596 # 5980 <malloc+0x626>
     bdc:	2b8040ef          	jal	4e94 <open>
     be0:	892a                	mv	s2,a0
  write(fd1, "yyy", 3);
     be2:	460d                	li	a2,3
     be4:	00005597          	auipc	a1,0x5
     be8:	e1458593          	addi	a1,a1,-492 # 59f8 <malloc+0x69e>
     bec:	288040ef          	jal	4e74 <write>
  close(fd1);
     bf0:	854a                	mv	a0,s2
     bf2:	28a040ef          	jal	4e7c <close>
  if(read(fd, buf, sizeof(buf)) != SZ){
     bf6:	660d                	lui	a2,0x3
     bf8:	0000c597          	auipc	a1,0xc
     bfc:	0a058593          	addi	a1,a1,160 # cc98 <buf>
     c00:	8526                	mv	a0,s1
     c02:	26a040ef          	jal	4e6c <read>
     c06:	4795                	li	a5,5
     c08:	08f51363          	bne	a0,a5,c8e <unlinkread+0x11a>
  if(buf[0] != 'h'){
     c0c:	0000c717          	auipc	a4,0xc
     c10:	08c74703          	lbu	a4,140(a4) # cc98 <buf>
     c14:	06800793          	li	a5,104
     c18:	08f71563          	bne	a4,a5,ca2 <unlinkread+0x12e>
  if(write(fd, buf, 10) != 10){
     c1c:	4629                	li	a2,10
     c1e:	0000c597          	auipc	a1,0xc
     c22:	07a58593          	addi	a1,a1,122 # cc98 <buf>
     c26:	8526                	mv	a0,s1
     c28:	24c040ef          	jal	4e74 <write>
     c2c:	47a9                	li	a5,10
     c2e:	08f51463          	bne	a0,a5,cb6 <unlinkread+0x142>
  close(fd);
     c32:	8526                	mv	a0,s1
     c34:	248040ef          	jal	4e7c <close>
  unlink("unlinkread");
     c38:	00005517          	auipc	a0,0x5
     c3c:	d4850513          	addi	a0,a0,-696 # 5980 <malloc+0x626>
     c40:	264040ef          	jal	4ea4 <unlink>
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
     c58:	d3c50513          	addi	a0,a0,-708 # 5990 <malloc+0x636>
     c5c:	646040ef          	jal	52a2 <printf>
    exit(1);
     c60:	4505                	li	a0,1
     c62:	1f2040ef          	jal	4e54 <exit>
    printf("%s: open unlinkread failed\n", s);
     c66:	85ce                	mv	a1,s3
     c68:	00005517          	auipc	a0,0x5
     c6c:	d5050513          	addi	a0,a0,-688 # 59b8 <malloc+0x65e>
     c70:	632040ef          	jal	52a2 <printf>
    exit(1);
     c74:	4505                	li	a0,1
     c76:	1de040ef          	jal	4e54 <exit>
    printf("%s: unlink unlinkread failed\n", s);
     c7a:	85ce                	mv	a1,s3
     c7c:	00005517          	auipc	a0,0x5
     c80:	d5c50513          	addi	a0,a0,-676 # 59d8 <malloc+0x67e>
     c84:	61e040ef          	jal	52a2 <printf>
    exit(1);
     c88:	4505                	li	a0,1
     c8a:	1ca040ef          	jal	4e54 <exit>
    printf("%s: unlinkread read failed", s);
     c8e:	85ce                	mv	a1,s3
     c90:	00005517          	auipc	a0,0x5
     c94:	d7050513          	addi	a0,a0,-656 # 5a00 <malloc+0x6a6>
     c98:	60a040ef          	jal	52a2 <printf>
    exit(1);
     c9c:	4505                	li	a0,1
     c9e:	1b6040ef          	jal	4e54 <exit>
    printf("%s: unlinkread wrong data\n", s);
     ca2:	85ce                	mv	a1,s3
     ca4:	00005517          	auipc	a0,0x5
     ca8:	d7c50513          	addi	a0,a0,-644 # 5a20 <malloc+0x6c6>
     cac:	5f6040ef          	jal	52a2 <printf>
    exit(1);
     cb0:	4505                	li	a0,1
     cb2:	1a2040ef          	jal	4e54 <exit>
    printf("%s: unlinkread write failed\n", s);
     cb6:	85ce                	mv	a1,s3
     cb8:	00005517          	auipc	a0,0x5
     cbc:	d8850513          	addi	a0,a0,-632 # 5a40 <malloc+0x6e6>
     cc0:	5e2040ef          	jal	52a2 <printf>
    exit(1);
     cc4:	4505                	li	a0,1
     cc6:	18e040ef          	jal	4e54 <exit>

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
     cdc:	d8850513          	addi	a0,a0,-632 # 5a60 <malloc+0x706>
     ce0:	1c4040ef          	jal	4ea4 <unlink>
  unlink("lf2");
     ce4:	00005517          	auipc	a0,0x5
     ce8:	d8450513          	addi	a0,a0,-636 # 5a68 <malloc+0x70e>
     cec:	1b8040ef          	jal	4ea4 <unlink>
  fd = open("lf1", O_CREATE|O_RDWR);
     cf0:	20200593          	li	a1,514
     cf4:	00005517          	auipc	a0,0x5
     cf8:	d6c50513          	addi	a0,a0,-660 # 5a60 <malloc+0x706>
     cfc:	198040ef          	jal	4e94 <open>
  if(fd < 0){
     d00:	0c054f63          	bltz	a0,dde <linktest+0x114>
     d04:	84aa                	mv	s1,a0
  if(write(fd, "hello", SZ) != SZ){
     d06:	4615                	li	a2,5
     d08:	00005597          	auipc	a1,0x5
     d0c:	ca858593          	addi	a1,a1,-856 # 59b0 <malloc+0x656>
     d10:	164040ef          	jal	4e74 <write>
     d14:	4795                	li	a5,5
     d16:	0cf51e63          	bne	a0,a5,df2 <linktest+0x128>
  close(fd);
     d1a:	8526                	mv	a0,s1
     d1c:	160040ef          	jal	4e7c <close>
  if(link("lf1", "lf2") < 0){
     d20:	00005597          	auipc	a1,0x5
     d24:	d4858593          	addi	a1,a1,-696 # 5a68 <malloc+0x70e>
     d28:	00005517          	auipc	a0,0x5
     d2c:	d3850513          	addi	a0,a0,-712 # 5a60 <malloc+0x706>
     d30:	184040ef          	jal	4eb4 <link>
     d34:	0c054963          	bltz	a0,e06 <linktest+0x13c>
  unlink("lf1");
     d38:	00005517          	auipc	a0,0x5
     d3c:	d2850513          	addi	a0,a0,-728 # 5a60 <malloc+0x706>
     d40:	164040ef          	jal	4ea4 <unlink>
  if(open("lf1", 0) >= 0){
     d44:	4581                	li	a1,0
     d46:	00005517          	auipc	a0,0x5
     d4a:	d1a50513          	addi	a0,a0,-742 # 5a60 <malloc+0x706>
     d4e:	146040ef          	jal	4e94 <open>
     d52:	0c055463          	bgez	a0,e1a <linktest+0x150>
  fd = open("lf2", 0);
     d56:	4581                	li	a1,0
     d58:	00005517          	auipc	a0,0x5
     d5c:	d1050513          	addi	a0,a0,-752 # 5a68 <malloc+0x70e>
     d60:	134040ef          	jal	4e94 <open>
     d64:	84aa                	mv	s1,a0
  if(fd < 0){
     d66:	0c054463          	bltz	a0,e2e <linktest+0x164>
  if(read(fd, buf, sizeof(buf)) != SZ){
     d6a:	660d                	lui	a2,0x3
     d6c:	0000c597          	auipc	a1,0xc
     d70:	f2c58593          	addi	a1,a1,-212 # cc98 <buf>
     d74:	0f8040ef          	jal	4e6c <read>
     d78:	4795                	li	a5,5
     d7a:	0cf51463          	bne	a0,a5,e42 <linktest+0x178>
  close(fd);
     d7e:	8526                	mv	a0,s1
     d80:	0fc040ef          	jal	4e7c <close>
  if(link("lf2", "lf2") >= 0){
     d84:	00005597          	auipc	a1,0x5
     d88:	ce458593          	addi	a1,a1,-796 # 5a68 <malloc+0x70e>
     d8c:	852e                	mv	a0,a1
     d8e:	126040ef          	jal	4eb4 <link>
     d92:	0c055263          	bgez	a0,e56 <linktest+0x18c>
  unlink("lf2");
     d96:	00005517          	auipc	a0,0x5
     d9a:	cd250513          	addi	a0,a0,-814 # 5a68 <malloc+0x70e>
     d9e:	106040ef          	jal	4ea4 <unlink>
  if(link("lf2", "lf1") >= 0){
     da2:	00005597          	auipc	a1,0x5
     da6:	cbe58593          	addi	a1,a1,-834 # 5a60 <malloc+0x706>
     daa:	00005517          	auipc	a0,0x5
     dae:	cbe50513          	addi	a0,a0,-834 # 5a68 <malloc+0x70e>
     db2:	102040ef          	jal	4eb4 <link>
     db6:	0a055a63          	bgez	a0,e6a <linktest+0x1a0>
  if(link(".", "lf1") >= 0){
     dba:	00005597          	auipc	a1,0x5
     dbe:	ca658593          	addi	a1,a1,-858 # 5a60 <malloc+0x706>
     dc2:	00005517          	auipc	a0,0x5
     dc6:	dae50513          	addi	a0,a0,-594 # 5b70 <malloc+0x816>
     dca:	0ea040ef          	jal	4eb4 <link>
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
     de4:	c9050513          	addi	a0,a0,-880 # 5a70 <malloc+0x716>
     de8:	4ba040ef          	jal	52a2 <printf>
    exit(1);
     dec:	4505                	li	a0,1
     dee:	066040ef          	jal	4e54 <exit>
    printf("%s: write lf1 failed\n", s);
     df2:	85ca                	mv	a1,s2
     df4:	00005517          	auipc	a0,0x5
     df8:	c9450513          	addi	a0,a0,-876 # 5a88 <malloc+0x72e>
     dfc:	4a6040ef          	jal	52a2 <printf>
    exit(1);
     e00:	4505                	li	a0,1
     e02:	052040ef          	jal	4e54 <exit>
    printf("%s: link lf1 lf2 failed\n", s);
     e06:	85ca                	mv	a1,s2
     e08:	00005517          	auipc	a0,0x5
     e0c:	c9850513          	addi	a0,a0,-872 # 5aa0 <malloc+0x746>
     e10:	492040ef          	jal	52a2 <printf>
    exit(1);
     e14:	4505                	li	a0,1
     e16:	03e040ef          	jal	4e54 <exit>
    printf("%s: unlinked lf1 but it is still there!\n", s);
     e1a:	85ca                	mv	a1,s2
     e1c:	00005517          	auipc	a0,0x5
     e20:	ca450513          	addi	a0,a0,-860 # 5ac0 <malloc+0x766>
     e24:	47e040ef          	jal	52a2 <printf>
    exit(1);
     e28:	4505                	li	a0,1
     e2a:	02a040ef          	jal	4e54 <exit>
    printf("%s: open lf2 failed\n", s);
     e2e:	85ca                	mv	a1,s2
     e30:	00005517          	auipc	a0,0x5
     e34:	cc050513          	addi	a0,a0,-832 # 5af0 <malloc+0x796>
     e38:	46a040ef          	jal	52a2 <printf>
    exit(1);
     e3c:	4505                	li	a0,1
     e3e:	016040ef          	jal	4e54 <exit>
    printf("%s: read lf2 failed\n", s);
     e42:	85ca                	mv	a1,s2
     e44:	00005517          	auipc	a0,0x5
     e48:	cc450513          	addi	a0,a0,-828 # 5b08 <malloc+0x7ae>
     e4c:	456040ef          	jal	52a2 <printf>
    exit(1);
     e50:	4505                	li	a0,1
     e52:	002040ef          	jal	4e54 <exit>
    printf("%s: link lf2 lf2 succeeded! oops\n", s);
     e56:	85ca                	mv	a1,s2
     e58:	00005517          	auipc	a0,0x5
     e5c:	cc850513          	addi	a0,a0,-824 # 5b20 <malloc+0x7c6>
     e60:	442040ef          	jal	52a2 <printf>
    exit(1);
     e64:	4505                	li	a0,1
     e66:	7ef030ef          	jal	4e54 <exit>
    printf("%s: link non-existent succeeded! oops\n", s);
     e6a:	85ca                	mv	a1,s2
     e6c:	00005517          	auipc	a0,0x5
     e70:	cdc50513          	addi	a0,a0,-804 # 5b48 <malloc+0x7ee>
     e74:	42e040ef          	jal	52a2 <printf>
    exit(1);
     e78:	4505                	li	a0,1
     e7a:	7db030ef          	jal	4e54 <exit>
    printf("%s: link . lf1 succeeded! oops\n", s);
     e7e:	85ca                	mv	a1,s2
     e80:	00005517          	auipc	a0,0x5
     e84:	cf850513          	addi	a0,a0,-776 # 5b78 <malloc+0x81e>
     e88:	41a040ef          	jal	52a2 <printf>
    exit(1);
     e8c:	4505                	li	a0,1
     e8e:	7c7030ef          	jal	4e54 <exit>

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
     eae:	cee98993          	addi	s3,s3,-786 # 5b98 <malloc+0x83e>
     eb2:	597d                	li	s2,-1
  for(p = 0; p <= (uint)hi; p += PGSIZE){
     eb4:	6a85                	lui	s5,0x1
     eb6:	00114a37          	lui	s4,0x114
    if(link("nosuchfile", (char*)p) != -1){
     eba:	85a6                	mv	a1,s1
     ebc:	854e                	mv	a0,s3
     ebe:	7f7030ef          	jal	4eb4 <link>
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
     ee6:	cc650513          	addi	a0,a0,-826 # 5ba8 <malloc+0x84e>
     eea:	3b8040ef          	jal	52a2 <printf>
      exit(1);
     eee:	4505                	li	a0,1
     ef0:	765030ef          	jal	4e54 <exit>

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
     f10:	cbc50513          	addi	a0,a0,-836 # 5bc8 <malloc+0x86e>
     f14:	791030ef          	jal	4ea4 <unlink>
  fd = open("bd", O_CREATE);
     f18:	20000593          	li	a1,512
     f1c:	00005517          	auipc	a0,0x5
     f20:	cac50513          	addi	a0,a0,-852 # 5bc8 <malloc+0x86e>
     f24:	771030ef          	jal	4e94 <open>
  if(fd < 0){
     f28:	0c054463          	bltz	a0,ff0 <bigdir+0xfc>
  close(fd);
     f2c:	751030ef          	jal	4e7c <close>
  for(i = 0; i < N; i++){
     f30:	4901                	li	s2,0
    name[0] = 'x';
     f32:	07800a93          	li	s5,120
    if(link("bd", name) != 0){
     f36:	fa040a13          	addi	s4,s0,-96
     f3a:	00005997          	auipc	s3,0x5
     f3e:	c8e98993          	addi	s3,s3,-882 # 5bc8 <malloc+0x86e>
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
     f78:	73d030ef          	jal	4eb4 <link>
     f7c:	84aa                	mv	s1,a0
     f7e:	e159                	bnez	a0,1004 <bigdir+0x110>
  for(i = 0; i < N; i++){
     f80:	2905                	addiw	s2,s2,1
     f82:	fd6912e3          	bne	s2,s6,f46 <bigdir+0x52>
  unlink("bd");
     f86:	00005517          	auipc	a0,0x5
     f8a:	c4250513          	addi	a0,a0,-958 # 5bc8 <malloc+0x86e>
     f8e:	717030ef          	jal	4ea4 <unlink>
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
     fce:	6d7030ef          	jal	4ea4 <unlink>
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
     ff6:	bde50513          	addi	a0,a0,-1058 # 5bd0 <malloc+0x876>
     ffa:	2a8040ef          	jal	52a2 <printf>
    exit(1);
     ffe:	4505                	li	a0,1
    1000:	655030ef          	jal	4e54 <exit>
      printf("%s: bigdir i=%d link(bd, %s) failed\n", s, i, name);
    1004:	fa040693          	addi	a3,s0,-96
    1008:	864a                	mv	a2,s2
    100a:	85de                	mv	a1,s7
    100c:	00005517          	auipc	a0,0x5
    1010:	be450513          	addi	a0,a0,-1052 # 5bf0 <malloc+0x896>
    1014:	28e040ef          	jal	52a2 <printf>
      exit(1);
    1018:	4505                	li	a0,1
    101a:	63b030ef          	jal	4e54 <exit>
      printf("%s: bigdir unlink failed", s);
    101e:	85de                	mv	a1,s7
    1020:	00005517          	auipc	a0,0x5
    1024:	bf850513          	addi	a0,a0,-1032 # 5c18 <malloc+0x8be>
    1028:	27a040ef          	jal	52a2 <printf>
      exit(1);
    102c:	4505                	li	a0,1
    102e:	627030ef          	jal	4e54 <exit>

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
    1040:	00008497          	auipc	s1,0x8
    1044:	fc048493          	addi	s1,s1,-64 # 9000 <big>
    1048:	fd840593          	addi	a1,s0,-40
    104c:	6088                	ld	a0,0(s1)
    104e:	63f030ef          	jal	4e8c <exec>
  pipe(big);
    1052:	6088                	ld	a0,0(s1)
    1054:	611030ef          	jal	4e64 <pipe>
  exit(0);
    1058:	4501                	li	a0,0
    105a:	5fb030ef          	jal	4e54 <exit>

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
    1070:	35048493          	addi	s1,s1,848 # c350 <uninit+0x1dc8>
    argv[0] = (char*)0xffffffff;
    1074:	597d                	li	s2,-1
    1076:	02095913          	srli	s2,s2,0x20
    exec("echo", argv);
    107a:	fc040a13          	addi	s4,s0,-64
    107e:	00004997          	auipc	s3,0x4
    1082:	40a98993          	addi	s3,s3,1034 # 5488 <malloc+0x12e>
    argv[0] = (char*)0xffffffff;
    1086:	fd243023          	sd	s2,-64(s0)
    argv[1] = 0;
    108a:	fc043423          	sd	zero,-56(s0)
    exec("echo", argv);
    108e:	85d2                	mv	a1,s4
    1090:	854e                	mv	a0,s3
    1092:	5fb030ef          	jal	4e8c <exec>
  for(int i = 0; i < 50000; i++){
    1096:	34fd                	addiw	s1,s1,-1
    1098:	f4fd                	bnez	s1,1086 <badarg+0x28>
  exit(0);
    109a:	4501                	li	a0,0
    109c:	5b9030ef          	jal	4e54 <exit>

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
    10c6:	5df030ef          	jal	4ea4 <unlink>
  if(ret != -1){
    10ca:	57fd                	li	a5,-1
    10cc:	0cf51263          	bne	a0,a5,1190 <copyinstr2+0xf0>
  int fd = open(b, O_CREATE | O_WRONLY);
    10d0:	20100593          	li	a1,513
    10d4:	f6840513          	addi	a0,s0,-152
    10d8:	5bd030ef          	jal	4e94 <open>
  if(fd != -1){
    10dc:	57fd                	li	a5,-1
    10de:	0cf51563          	bne	a0,a5,11a8 <copyinstr2+0x108>
  ret = link(b, b);
    10e2:	f6840513          	addi	a0,s0,-152
    10e6:	85aa                	mv	a1,a0
    10e8:	5cd030ef          	jal	4eb4 <link>
  if(ret != -1){
    10ec:	57fd                	li	a5,-1
    10ee:	0cf51963          	bne	a0,a5,11c0 <copyinstr2+0x120>
  char *args[] = { "xx", 0 };
    10f2:	00006797          	auipc	a5,0x6
    10f6:	c3e78793          	addi	a5,a5,-962 # 6d30 <malloc+0x19d6>
    10fa:	f4f43c23          	sd	a5,-168(s0)
    10fe:	f6043023          	sd	zero,-160(s0)
  ret = exec(b, args);
    1102:	f5840593          	addi	a1,s0,-168
    1106:	f6840513          	addi	a0,s0,-152
    110a:	583030ef          	jal	4e8c <exec>
  if(ret != -1){
    110e:	57fd                	li	a5,-1
    1110:	0cf51563          	bne	a0,a5,11da <copyinstr2+0x13a>
  int pid = fork();
    1114:	539030ef          	jal	4e4c <fork>
  if(pid < 0){
    1118:	0c054d63          	bltz	a0,11f2 <copyinstr2+0x152>
  if(pid == 0){
    111c:	0e051863          	bnez	a0,120c <copyinstr2+0x16c>
    1120:	00008797          	auipc	a5,0x8
    1124:	46078793          	addi	a5,a5,1120 # 9580 <big.0>
    1128:	00009697          	auipc	a3,0x9
    112c:	45868693          	addi	a3,a3,1112 # a580 <big.0+0x1000>
      big[i] = 'x';
    1130:	07800713          	li	a4,120
    1134:	00e78023          	sb	a4,0(a5)
    for(int i = 0; i < PGSIZE; i++)
    1138:	0785                	addi	a5,a5,1
    113a:	fed79de3          	bne	a5,a3,1134 <copyinstr2+0x94>
    big[PGSIZE] = '\0';
    113e:	00009797          	auipc	a5,0x9
    1142:	44078123          	sb	zero,1090(a5) # a580 <big.0+0x1000>
    char *args2[] = { big, big, big, 0 };
    1146:	00006797          	auipc	a5,0x6
    114a:	7ea78793          	addi	a5,a5,2026 # 7930 <malloc+0x25d6>
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
    116e:	31e50513          	addi	a0,a0,798 # 5488 <malloc+0x12e>
    1172:	51b030ef          	jal	4e8c <exec>
    if(ret != -1){
    1176:	57fd                	li	a5,-1
    1178:	08f50663          	beq	a0,a5,1204 <copyinstr2+0x164>
      printf("exec(echo, BIG) returned %d, not -1\n", fd);
    117c:	85be                	mv	a1,a5
    117e:	00005517          	auipc	a0,0x5
    1182:	b4250513          	addi	a0,a0,-1214 # 5cc0 <malloc+0x966>
    1186:	11c040ef          	jal	52a2 <printf>
      exit(1);
    118a:	4505                	li	a0,1
    118c:	4c9030ef          	jal	4e54 <exit>
    printf("unlink(%s) returned %d, not -1\n", b, ret);
    1190:	862a                	mv	a2,a0
    1192:	f6840593          	addi	a1,s0,-152
    1196:	00005517          	auipc	a0,0x5
    119a:	aa250513          	addi	a0,a0,-1374 # 5c38 <malloc+0x8de>
    119e:	104040ef          	jal	52a2 <printf>
    exit(1);
    11a2:	4505                	li	a0,1
    11a4:	4b1030ef          	jal	4e54 <exit>
    printf("open(%s) returned %d, not -1\n", b, fd);
    11a8:	862a                	mv	a2,a0
    11aa:	f6840593          	addi	a1,s0,-152
    11ae:	00005517          	auipc	a0,0x5
    11b2:	aaa50513          	addi	a0,a0,-1366 # 5c58 <malloc+0x8fe>
    11b6:	0ec040ef          	jal	52a2 <printf>
    exit(1);
    11ba:	4505                	li	a0,1
    11bc:	499030ef          	jal	4e54 <exit>
    printf("link(%s, %s) returned %d, not -1\n", b, b, ret);
    11c0:	f6840593          	addi	a1,s0,-152
    11c4:	86aa                	mv	a3,a0
    11c6:	862e                	mv	a2,a1
    11c8:	00005517          	auipc	a0,0x5
    11cc:	ab050513          	addi	a0,a0,-1360 # 5c78 <malloc+0x91e>
    11d0:	0d2040ef          	jal	52a2 <printf>
    exit(1);
    11d4:	4505                	li	a0,1
    11d6:	47f030ef          	jal	4e54 <exit>
    printf("exec(%s) returned %d, not -1\n", b, fd);
    11da:	863e                	mv	a2,a5
    11dc:	f6840593          	addi	a1,s0,-152
    11e0:	00005517          	auipc	a0,0x5
    11e4:	ac050513          	addi	a0,a0,-1344 # 5ca0 <malloc+0x946>
    11e8:	0ba040ef          	jal	52a2 <printf>
    exit(1);
    11ec:	4505                	li	a0,1
    11ee:	467030ef          	jal	4e54 <exit>
    printf("fork failed\n");
    11f2:	00006517          	auipc	a0,0x6
    11f6:	00e50513          	addi	a0,a0,14 # 7200 <malloc+0x1ea6>
    11fa:	0a8040ef          	jal	52a2 <printf>
    exit(1);
    11fe:	4505                	li	a0,1
    1200:	455030ef          	jal	4e54 <exit>
    exit(747); // OK
    1204:	2eb00513          	li	a0,747
    1208:	44d030ef          	jal	4e54 <exit>
  int st = 0;
    120c:	f4042a23          	sw	zero,-172(s0)
  wait(&st);
    1210:	f5440513          	addi	a0,s0,-172
    1214:	449030ef          	jal	4e5c <wait>
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
    1230:	abc50513          	addi	a0,a0,-1348 # 5ce8 <malloc+0x98e>
    1234:	06e040ef          	jal	52a2 <printf>
    exit(1);
    1238:	4505                	li	a0,1
    123a:	41b030ef          	jal	4e54 <exit>

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
    1252:	29250513          	addi	a0,a0,658 # 54e0 <malloc+0x186>
    1256:	43f030ef          	jal	4e94 <open>
    125a:	423030ef          	jal	4e7c <close>
  pid = fork();
    125e:	3ef030ef          	jal	4e4c <fork>
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
    1282:	26298993          	addi	s3,s3,610 # 54e0 <malloc+0x186>
      int n = write(fd, "1234567890", 10);
    1286:	4a29                	li	s4,10
    1288:	00005b17          	auipc	s6,0x5
    128c:	ac0b0b13          	addi	s6,s6,-1344 # 5d48 <malloc+0x9ee>
      read(fd, buf, sizeof(buf));
    1290:	f7840c13          	addi	s8,s0,-136
    1294:	02000b93          	li	s7,32
      int fd = open("truncfile", O_WRONLY);
    1298:	85d6                	mv	a1,s5
    129a:	854e                	mv	a0,s3
    129c:	3f9030ef          	jal	4e94 <open>
    12a0:	84aa                	mv	s1,a0
      if(fd < 0){
    12a2:	04054f63          	bltz	a0,1300 <truncate3+0xc2>
      int n = write(fd, "1234567890", 10);
    12a6:	8652                	mv	a2,s4
    12a8:	85da                	mv	a1,s6
    12aa:	3cb030ef          	jal	4e74 <write>
      if(n != 10){
    12ae:	07451363          	bne	a0,s4,1314 <truncate3+0xd6>
      close(fd);
    12b2:	8526                	mv	a0,s1
    12b4:	3c9030ef          	jal	4e7c <close>
      fd = open("truncfile", O_RDONLY);
    12b8:	4581                	li	a1,0
    12ba:	854e                	mv	a0,s3
    12bc:	3d9030ef          	jal	4e94 <open>
    12c0:	84aa                	mv	s1,a0
      read(fd, buf, sizeof(buf));
    12c2:	865e                	mv	a2,s7
    12c4:	85e2                	mv	a1,s8
    12c6:	3a7030ef          	jal	4e6c <read>
      close(fd);
    12ca:	8526                	mv	a0,s1
    12cc:	3b1030ef          	jal	4e7c <close>
    for(int i = 0; i < 100; i++){
    12d0:	397d                	addiw	s2,s2,-1
    12d2:	fc0913e3          	bnez	s2,1298 <truncate3+0x5a>
    exit(0);
    12d6:	4501                	li	a0,0
    12d8:	37d030ef          	jal	4e54 <exit>
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
    12f2:	a2a50513          	addi	a0,a0,-1494 # 5d18 <malloc+0x9be>
    12f6:	7ad030ef          	jal	52a2 <printf>
    exit(1);
    12fa:	4505                	li	a0,1
    12fc:	359030ef          	jal	4e54 <exit>
        printf("%s: open failed\n", s);
    1300:	85e6                	mv	a1,s9
    1302:	00005517          	auipc	a0,0x5
    1306:	a2e50513          	addi	a0,a0,-1490 # 5d30 <malloc+0x9d6>
    130a:	799030ef          	jal	52a2 <printf>
        exit(1);
    130e:	4505                	li	a0,1
    1310:	345030ef          	jal	4e54 <exit>
        printf("%s: write got %d, expected 10\n", s, n);
    1314:	862a                	mv	a2,a0
    1316:	85e6                	mv	a1,s9
    1318:	00005517          	auipc	a0,0x5
    131c:	a4050513          	addi	a0,a0,-1472 # 5d58 <malloc+0x9fe>
    1320:	783030ef          	jal	52a2 <printf>
        exit(1);
    1324:	4505                	li	a0,1
    1326:	32f030ef          	jal	4e54 <exit>
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
    1342:	1a2a0a13          	addi	s4,s4,418 # 54e0 <malloc+0x186>
    int n = write(fd, "xxx", 3);
    1346:	498d                	li	s3,3
    1348:	00005b17          	auipc	s6,0x5
    134c:	a30b0b13          	addi	s6,s6,-1488 # 5d78 <malloc+0xa1e>
    int fd = open("truncfile", O_CREATE|O_WRONLY|O_TRUNC);
    1350:	85d6                	mv	a1,s5
    1352:	8552                	mv	a0,s4
    1354:	341030ef          	jal	4e94 <open>
    1358:	84aa                	mv	s1,a0
    if(fd < 0){
    135a:	02054e63          	bltz	a0,1396 <truncate3+0x158>
    int n = write(fd, "xxx", 3);
    135e:	864e                	mv	a2,s3
    1360:	85da                	mv	a1,s6
    1362:	313030ef          	jal	4e74 <write>
    if(n != 3){
    1366:	05351463          	bne	a0,s3,13ae <truncate3+0x170>
    close(fd);
    136a:	8526                	mv	a0,s1
    136c:	311030ef          	jal	4e7c <close>
  for(int i = 0; i < 150; i++){
    1370:	397d                	addiw	s2,s2,-1
    1372:	fc091fe3          	bnez	s2,1350 <truncate3+0x112>
    1376:	e4de                	sd	s7,72(sp)
    1378:	e0e2                	sd	s8,64(sp)
  wait(&xstatus);
    137a:	f9c40513          	addi	a0,s0,-100
    137e:	2df030ef          	jal	4e5c <wait>
  unlink("truncfile");
    1382:	00004517          	auipc	a0,0x4
    1386:	15e50513          	addi	a0,a0,350 # 54e0 <malloc+0x186>
    138a:	31b030ef          	jal	4ea4 <unlink>
  exit(xstatus);
    138e:	f9c42503          	lw	a0,-100(s0)
    1392:	2c3030ef          	jal	4e54 <exit>
    1396:	e4de                	sd	s7,72(sp)
    1398:	e0e2                	sd	s8,64(sp)
      printf("%s: open failed\n", s);
    139a:	85e6                	mv	a1,s9
    139c:	00005517          	auipc	a0,0x5
    13a0:	99450513          	addi	a0,a0,-1644 # 5d30 <malloc+0x9d6>
    13a4:	6ff030ef          	jal	52a2 <printf>
      exit(1);
    13a8:	4505                	li	a0,1
    13aa:	2ab030ef          	jal	4e54 <exit>
    13ae:	e4de                	sd	s7,72(sp)
    13b0:	e0e2                	sd	s8,64(sp)
      printf("%s: write got %d, expected 3\n", s, n);
    13b2:	862a                	mv	a2,a0
    13b4:	85e6                	mv	a1,s9
    13b6:	00005517          	auipc	a0,0x5
    13ba:	9ca50513          	addi	a0,a0,-1590 # 5d80 <malloc+0xa26>
    13be:	6e5030ef          	jal	52a2 <printf>
      exit(1);
    13c2:	4505                	li	a0,1
    13c4:	291030ef          	jal	4e54 <exit>

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
    13d8:	0b478793          	addi	a5,a5,180 # 5488 <malloc+0x12e>
    13dc:	fcf43023          	sd	a5,-64(s0)
    13e0:	00005797          	auipc	a5,0x5
    13e4:	9c078793          	addi	a5,a5,-1600 # 5da0 <malloc+0xa46>
    13e8:	fcf43423          	sd	a5,-56(s0)
    13ec:	fc043823          	sd	zero,-48(s0)
  unlink("echo-ok");
    13f0:	00005517          	auipc	a0,0x5
    13f4:	9b850513          	addi	a0,a0,-1608 # 5da8 <malloc+0xa4e>
    13f8:	2ad030ef          	jal	4ea4 <unlink>
  pid = fork();
    13fc:	251030ef          	jal	4e4c <fork>
  if(pid < 0) {
    1400:	02054f63          	bltz	a0,143e <exectest+0x76>
    1404:	fc26                	sd	s1,56(sp)
    1406:	84aa                	mv	s1,a0
  if(pid == 0) {
    1408:	e935                	bnez	a0,147c <exectest+0xb4>
    close(1);
    140a:	4505                	li	a0,1
    140c:	271030ef          	jal	4e7c <close>
    fd = open("echo-ok", O_CREATE|O_WRONLY);
    1410:	20100593          	li	a1,513
    1414:	00005517          	auipc	a0,0x5
    1418:	99450513          	addi	a0,a0,-1644 # 5da8 <malloc+0xa4e>
    141c:	279030ef          	jal	4e94 <open>
    if(fd < 0) {
    1420:	02054a63          	bltz	a0,1454 <exectest+0x8c>
    if(fd != 1) {
    1424:	4785                	li	a5,1
    1426:	04f50163          	beq	a0,a5,1468 <exectest+0xa0>
      printf("%s: wrong fd\n", s);
    142a:	85ca                	mv	a1,s2
    142c:	00005517          	auipc	a0,0x5
    1430:	99c50513          	addi	a0,a0,-1636 # 5dc8 <malloc+0xa6e>
    1434:	66f030ef          	jal	52a2 <printf>
      exit(1);
    1438:	4505                	li	a0,1
    143a:	21b030ef          	jal	4e54 <exit>
    143e:	fc26                	sd	s1,56(sp)
     printf("%s: fork failed\n", s);
    1440:	85ca                	mv	a1,s2
    1442:	00005517          	auipc	a0,0x5
    1446:	8d650513          	addi	a0,a0,-1834 # 5d18 <malloc+0x9be>
    144a:	659030ef          	jal	52a2 <printf>
     exit(1);
    144e:	4505                	li	a0,1
    1450:	205030ef          	jal	4e54 <exit>
      printf("%s: create failed\n", s);
    1454:	85ca                	mv	a1,s2
    1456:	00005517          	auipc	a0,0x5
    145a:	95a50513          	addi	a0,a0,-1702 # 5db0 <malloc+0xa56>
    145e:	645030ef          	jal	52a2 <printf>
      exit(1);
    1462:	4505                	li	a0,1
    1464:	1f1030ef          	jal	4e54 <exit>
    if(exec("echo", echoargv) < 0){
    1468:	fc040593          	addi	a1,s0,-64
    146c:	00004517          	auipc	a0,0x4
    1470:	01c50513          	addi	a0,a0,28 # 5488 <malloc+0x12e>
    1474:	219030ef          	jal	4e8c <exec>
    1478:	00054d63          	bltz	a0,1492 <exectest+0xca>
  if (wait(&xstatus) != pid) {
    147c:	fdc40513          	addi	a0,s0,-36
    1480:	1dd030ef          	jal	4e5c <wait>
    1484:	02951163          	bne	a0,s1,14a6 <exectest+0xde>
  if(xstatus != 0)
    1488:	fdc42503          	lw	a0,-36(s0)
    148c:	c50d                	beqz	a0,14b6 <exectest+0xee>
    exit(xstatus);
    148e:	1c7030ef          	jal	4e54 <exit>
      printf("%s: exec echo failed\n", s);
    1492:	85ca                	mv	a1,s2
    1494:	00005517          	auipc	a0,0x5
    1498:	94450513          	addi	a0,a0,-1724 # 5dd8 <malloc+0xa7e>
    149c:	607030ef          	jal	52a2 <printf>
      exit(1);
    14a0:	4505                	li	a0,1
    14a2:	1b3030ef          	jal	4e54 <exit>
    printf("%s: wait failed!\n", s);
    14a6:	85ca                	mv	a1,s2
    14a8:	00005517          	auipc	a0,0x5
    14ac:	94850513          	addi	a0,a0,-1720 # 5df0 <malloc+0xa96>
    14b0:	5f3030ef          	jal	52a2 <printf>
    14b4:	bfd1                	j	1488 <exectest+0xc0>
  fd = open("echo-ok", O_RDONLY);
    14b6:	4581                	li	a1,0
    14b8:	00005517          	auipc	a0,0x5
    14bc:	8f050513          	addi	a0,a0,-1808 # 5da8 <malloc+0xa4e>
    14c0:	1d5030ef          	jal	4e94 <open>
  if(fd < 0) {
    14c4:	02054463          	bltz	a0,14ec <exectest+0x124>
  if (read(fd, buf, 2) != 2) {
    14c8:	4609                	li	a2,2
    14ca:	fb840593          	addi	a1,s0,-72
    14ce:	19f030ef          	jal	4e6c <read>
    14d2:	4789                	li	a5,2
    14d4:	02f50663          	beq	a0,a5,1500 <exectest+0x138>
    printf("%s: read failed\n", s);
    14d8:	85ca                	mv	a1,s2
    14da:	00004517          	auipc	a0,0x4
    14de:	37e50513          	addi	a0,a0,894 # 5858 <malloc+0x4fe>
    14e2:	5c1030ef          	jal	52a2 <printf>
    exit(1);
    14e6:	4505                	li	a0,1
    14e8:	16d030ef          	jal	4e54 <exit>
    printf("%s: open failed\n", s);
    14ec:	85ca                	mv	a1,s2
    14ee:	00005517          	auipc	a0,0x5
    14f2:	84250513          	addi	a0,a0,-1982 # 5d30 <malloc+0x9d6>
    14f6:	5ad030ef          	jal	52a2 <printf>
    exit(1);
    14fa:	4505                	li	a0,1
    14fc:	159030ef          	jal	4e54 <exit>
  unlink("echo-ok");
    1500:	00005517          	auipc	a0,0x5
    1504:	8a850513          	addi	a0,a0,-1880 # 5da8 <malloc+0xa4e>
    1508:	19d030ef          	jal	4ea4 <unlink>
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
    152a:	8e250513          	addi	a0,a0,-1822 # 5e08 <malloc+0xaae>
    152e:	575030ef          	jal	52a2 <printf>
    exit(1);
    1532:	4505                	li	a0,1
    1534:	121030ef          	jal	4e54 <exit>
    exit(0);
    1538:	4501                	li	a0,0
    153a:	11b030ef          	jal	4e54 <exit>

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
    154e:	117030ef          	jal	4e64 <pipe>
    1552:	e925                	bnez	a0,15c2 <pipe1+0x84>
    1554:	e4a6                	sd	s1,72(sp)
    1556:	fc4e                	sd	s3,56(sp)
    1558:	84aa                	mv	s1,a0
  pid = fork();
    155a:	0f3030ef          	jal	4e4c <fork>
    155e:	89aa                	mv	s3,a0
  if(pid == 0){
    1560:	c151                	beqz	a0,15e4 <pipe1+0xa6>
  } else if(pid > 0){
    1562:	16a05063          	blez	a0,16c2 <pipe1+0x184>
    1566:	e0ca                	sd	s2,64(sp)
    1568:	f852                	sd	s4,48(sp)
    close(fds[1]);
    156a:	fac42503          	lw	a0,-84(s0)
    156e:	10f030ef          	jal	4e7c <close>
    total = 0;
    1572:	89a6                	mv	s3,s1
    cc = 1;
    1574:	4905                	li	s2,1
    while((n = read(fds[0], buf, cc)) > 0){
    1576:	0000ba17          	auipc	s4,0xb
    157a:	722a0a13          	addi	s4,s4,1826 # cc98 <buf>
    157e:	864a                	mv	a2,s2
    1580:	85d2                	mv	a1,s4
    1582:	fa842503          	lw	a0,-88(s0)
    1586:	0e7030ef          	jal	4e6c <read>
    158a:	85aa                	mv	a1,a0
    158c:	0ea05963          	blez	a0,167e <pipe1+0x140>
    1590:	0000b797          	auipc	a5,0xb
    1594:	70878793          	addi	a5,a5,1800 # cc98 <buf>
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
    15d6:	84e50513          	addi	a0,a0,-1970 # 5e20 <malloc+0xac6>
    15da:	4c9030ef          	jal	52a2 <printf>
    exit(1);
    15de:	4505                	li	a0,1
    15e0:	075030ef          	jal	4e54 <exit>
    15e4:	e0ca                	sd	s2,64(sp)
    15e6:	f852                	sd	s4,48(sp)
    15e8:	f456                	sd	s5,40(sp)
    15ea:	f05a                	sd	s6,32(sp)
    15ec:	ec5e                	sd	s7,24(sp)
    close(fds[0]);
    15ee:	fa842503          	lw	a0,-88(s0)
    15f2:	08b030ef          	jal	4e7c <close>
    for(n = 0; n < N; n++){
    15f6:	0000bb17          	auipc	s6,0xb
    15fa:	6a2b0b13          	addi	s6,s6,1698 # cc98 <buf>
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
    161c:	00e78023          	sb	a4,0(a5) # 3000 <subdir+0x3c0>
      for(i = 0; i < SZ; i++)
    1620:	0785                	addi	a5,a5,1
    1622:	ff279be3          	bne	a5,s2,1618 <pipe1+0xda>
      if(write(fds[1], buf, SZ) != SZ){
    1626:	8652                	mv	a2,s4
    1628:	85de                	mv	a1,s7
    162a:	fac42503          	lw	a0,-84(s0)
    162e:	047030ef          	jal	4e74 <write>
    1632:	01451c63          	bne	a0,s4,164a <pipe1+0x10c>
    1636:	4099899b          	addiw	s3,s3,1033
    for(n = 0; n < N; n++){
    163a:	24a5                	addiw	s1,s1,9
    163c:	0ff4f493          	zext.b	s1,s1
    1640:	fd599be3          	bne	s3,s5,1616 <pipe1+0xd8>
    exit(0);
    1644:	4501                	li	a0,0
    1646:	00f030ef          	jal	4e54 <exit>
        printf("%s: pipe1 oops 1\n", s);
    164a:	85e2                	mv	a1,s8
    164c:	00004517          	auipc	a0,0x4
    1650:	7ec50513          	addi	a0,a0,2028 # 5e38 <malloc+0xade>
    1654:	44f030ef          	jal	52a2 <printf>
        exit(1);
    1658:	4505                	li	a0,1
    165a:	7fa030ef          	jal	4e54 <exit>
          printf("%s: pipe1 oops 2\n", s);
    165e:	85e2                	mv	a1,s8
    1660:	00004517          	auipc	a0,0x4
    1664:	7f050513          	addi	a0,a0,2032 # 5e50 <malloc+0xaf6>
    1668:	43b030ef          	jal	52a2 <printf>
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
    1692:	00004517          	auipc	a0,0x4
    1696:	7d650513          	addi	a0,a0,2006 # 5e68 <malloc+0xb0e>
    169a:	409030ef          	jal	52a2 <printf>
      exit(1);
    169e:	4505                	li	a0,1
    16a0:	7b4030ef          	jal	4e54 <exit>
    16a4:	f456                	sd	s5,40(sp)
    16a6:	f05a                	sd	s6,32(sp)
    16a8:	ec5e                	sd	s7,24(sp)
    close(fds[0]);
    16aa:	fa842503          	lw	a0,-88(s0)
    16ae:	7ce030ef          	jal	4e7c <close>
    wait(&xstatus);
    16b2:	fa440513          	addi	a0,s0,-92
    16b6:	7a6030ef          	jal	4e5c <wait>
    exit(xstatus);
    16ba:	fa442503          	lw	a0,-92(s0)
    16be:	796030ef          	jal	4e54 <exit>
    16c2:	e0ca                	sd	s2,64(sp)
    16c4:	f852                	sd	s4,48(sp)
    16c6:	f456                	sd	s5,40(sp)
    16c8:	f05a                	sd	s6,32(sp)
    16ca:	ec5e                	sd	s7,24(sp)
    printf("%s: fork() failed\n", s);
    16cc:	85e2                	mv	a1,s8
    16ce:	00004517          	auipc	a0,0x4
    16d2:	7ba50513          	addi	a0,a0,1978 # 5e88 <malloc+0xb2e>
    16d6:	3cd030ef          	jal	52a2 <printf>
    exit(1);
    16da:	4505                	li	a0,1
    16dc:	778030ef          	jal	4e54 <exit>

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
    16fe:	74e030ef          	jal	4e4c <fork>
    1702:	84aa                	mv	s1,a0
    if(pid < 0){
    1704:	02054863          	bltz	a0,1734 <exitwait+0x54>
    if(pid){
    1708:	c525                	beqz	a0,1770 <exitwait+0x90>
      if(wait(&xstate) != pid){
    170a:	854e                	mv	a0,s3
    170c:	750030ef          	jal	4e5c <wait>
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
    173a:	5e250513          	addi	a0,a0,1506 # 5d18 <malloc+0x9be>
    173e:	365030ef          	jal	52a2 <printf>
      exit(1);
    1742:	4505                	li	a0,1
    1744:	710030ef          	jal	4e54 <exit>
        printf("%s: wait wrong pid\n", s);
    1748:	85d6                	mv	a1,s5
    174a:	00004517          	auipc	a0,0x4
    174e:	75650513          	addi	a0,a0,1878 # 5ea0 <malloc+0xb46>
    1752:	351030ef          	jal	52a2 <printf>
        exit(1);
    1756:	4505                	li	a0,1
    1758:	6fc030ef          	jal	4e54 <exit>
        printf("%s: wait wrong exit status\n", s);
    175c:	85d6                	mv	a1,s5
    175e:	00004517          	auipc	a0,0x4
    1762:	75a50513          	addi	a0,a0,1882 # 5eb8 <malloc+0xb5e>
    1766:	33d030ef          	jal	52a2 <printf>
        exit(1);
    176a:	4505                	li	a0,1
    176c:	6e8030ef          	jal	4e54 <exit>
      exit(i);
    1770:	854a                	mv	a0,s2
    1772:	6e2030ef          	jal	4e54 <exit>

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
    1788:	6c4030ef          	jal	4e4c <fork>
    if(pid1 < 0){
    178c:	02054663          	bltz	a0,17b8 <twochildren+0x42>
    if(pid1 == 0){
    1790:	cd15                	beqz	a0,17cc <twochildren+0x56>
      int pid2 = fork();
    1792:	6ba030ef          	jal	4e4c <fork>
      if(pid2 < 0){
    1796:	02054d63          	bltz	a0,17d0 <twochildren+0x5a>
      if(pid2 == 0){
    179a:	c529                	beqz	a0,17e4 <twochildren+0x6e>
        wait(0);
    179c:	4501                	li	a0,0
    179e:	6be030ef          	jal	4e5c <wait>
        wait(0);
    17a2:	4501                	li	a0,0
    17a4:	6b8030ef          	jal	4e5c <wait>
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
    17be:	55e50513          	addi	a0,a0,1374 # 5d18 <malloc+0x9be>
    17c2:	2e1030ef          	jal	52a2 <printf>
      exit(1);
    17c6:	4505                	li	a0,1
    17c8:	68c030ef          	jal	4e54 <exit>
      exit(0);
    17cc:	688030ef          	jal	4e54 <exit>
        printf("%s: fork failed\n", s);
    17d0:	85ca                	mv	a1,s2
    17d2:	00004517          	auipc	a0,0x4
    17d6:	54650513          	addi	a0,a0,1350 # 5d18 <malloc+0x9be>
    17da:	2c9030ef          	jal	52a2 <printf>
        exit(1);
    17de:	4505                	li	a0,1
    17e0:	674030ef          	jal	4e54 <exit>
        exit(0);
    17e4:	670030ef          	jal	4e54 <exit>

00000000000017e8 <forkfork>:
{
    17e8:	7179                	addi	sp,sp,-48
    17ea:	f406                	sd	ra,40(sp)
    17ec:	f022                	sd	s0,32(sp)
    17ee:	ec26                	sd	s1,24(sp)
    17f0:	1800                	addi	s0,sp,48
    17f2:	84aa                	mv	s1,a0
    int pid = fork();
    17f4:	658030ef          	jal	4e4c <fork>
    if(pid < 0){
    17f8:	02054b63          	bltz	a0,182e <forkfork+0x46>
    if(pid == 0){
    17fc:	c139                	beqz	a0,1842 <forkfork+0x5a>
    int pid = fork();
    17fe:	64e030ef          	jal	4e4c <fork>
    if(pid < 0){
    1802:	02054663          	bltz	a0,182e <forkfork+0x46>
    if(pid == 0){
    1806:	cd15                	beqz	a0,1842 <forkfork+0x5a>
    wait(&xstatus);
    1808:	fdc40513          	addi	a0,s0,-36
    180c:	650030ef          	jal	4e5c <wait>
    if(xstatus != 0) {
    1810:	fdc42783          	lw	a5,-36(s0)
    1814:	ebb9                	bnez	a5,186a <forkfork+0x82>
    wait(&xstatus);
    1816:	fdc40513          	addi	a0,s0,-36
    181a:	642030ef          	jal	4e5c <wait>
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
    1830:	00004517          	auipc	a0,0x4
    1834:	6a850513          	addi	a0,a0,1704 # 5ed8 <malloc+0xb7e>
    1838:	26b030ef          	jal	52a2 <printf>
      exit(1);
    183c:	4505                	li	a0,1
    183e:	616030ef          	jal	4e54 <exit>
{
    1842:	0c800493          	li	s1,200
        int pid1 = fork();
    1846:	606030ef          	jal	4e4c <fork>
        if(pid1 < 0){
    184a:	00054b63          	bltz	a0,1860 <forkfork+0x78>
        if(pid1 == 0){
    184e:	cd01                	beqz	a0,1866 <forkfork+0x7e>
        wait(0);
    1850:	4501                	li	a0,0
    1852:	60a030ef          	jal	4e5c <wait>
      for(int j = 0; j < 200; j++){
    1856:	34fd                	addiw	s1,s1,-1
    1858:	f4fd                	bnez	s1,1846 <forkfork+0x5e>
      exit(0);
    185a:	4501                	li	a0,0
    185c:	5f8030ef          	jal	4e54 <exit>
          exit(1);
    1860:	4505                	li	a0,1
    1862:	5f2030ef          	jal	4e54 <exit>
          exit(0);
    1866:	5ee030ef          	jal	4e54 <exit>
      printf("%s: fork in child failed", s);
    186a:	85a6                	mv	a1,s1
    186c:	00004517          	auipc	a0,0x4
    1870:	67c50513          	addi	a0,a0,1660 # 5ee8 <malloc+0xb8e>
    1874:	22f030ef          	jal	52a2 <printf>
      exit(1);
    1878:	4505                	li	a0,1
    187a:	5da030ef          	jal	4e54 <exit>

000000000000187e <reparent2>:
{
    187e:	1101                	addi	sp,sp,-32
    1880:	ec06                	sd	ra,24(sp)
    1882:	e822                	sd	s0,16(sp)
    1884:	e426                	sd	s1,8(sp)
    1886:	1000                	addi	s0,sp,32
    1888:	32000493          	li	s1,800
    int pid1 = fork();
    188c:	5c0030ef          	jal	4e4c <fork>
    if(pid1 < 0){
    1890:	00054b63          	bltz	a0,18a6 <reparent2+0x28>
    if(pid1 == 0){
    1894:	c115                	beqz	a0,18b8 <reparent2+0x3a>
    wait(0);
    1896:	4501                	li	a0,0
    1898:	5c4030ef          	jal	4e5c <wait>
  for(int i = 0; i < 800; i++){
    189c:	34fd                	addiw	s1,s1,-1
    189e:	f4fd                	bnez	s1,188c <reparent2+0xe>
  exit(0);
    18a0:	4501                	li	a0,0
    18a2:	5b2030ef          	jal	4e54 <exit>
      printf("fork failed\n");
    18a6:	00006517          	auipc	a0,0x6
    18aa:	95a50513          	addi	a0,a0,-1702 # 7200 <malloc+0x1ea6>
    18ae:	1f5030ef          	jal	52a2 <printf>
      exit(1);
    18b2:	4505                	li	a0,1
    18b4:	5a0030ef          	jal	4e54 <exit>
      fork();
    18b8:	594030ef          	jal	4e4c <fork>
      fork();
    18bc:	590030ef          	jal	4e4c <fork>
      exit(0);
    18c0:	4501                	li	a0,0
    18c2:	592030ef          	jal	4e54 <exit>

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
    18ea:	562030ef          	jal	4e4c <fork>
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
    1904:	558030ef          	jal	4e5c <wait>
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
    1936:	3e650513          	addi	a0,a0,998 # 5d18 <malloc+0x9be>
    193a:	169030ef          	jal	52a2 <printf>
      exit(1);
    193e:	4505                	li	a0,1
    1940:	514030ef          	jal	4e54 <exit>
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
    1962:	45250513          	addi	a0,a0,1106 # 5db0 <malloc+0xa56>
    1966:	13d030ef          	jal	52a2 <printf>
          exit(1);
    196a:	4505                	li	a0,1
    196c:	4e8030ef          	jal	4e54 <exit>
          name[1] = '0' + (i / 2);
    1970:	01f4d79b          	srliw	a5,s1,0x1f
    1974:	9fa5                	addw	a5,a5,s1
    1976:	4017d79b          	sraiw	a5,a5,0x1
    197a:	0307879b          	addiw	a5,a5,48
    197e:	f6f408a3          	sb	a5,-143(s0)
          if(unlink(name) < 0){
    1982:	854a                	mv	a0,s2
    1984:	520030ef          	jal	4ea4 <unlink>
    1988:	02054a63          	bltz	a0,19bc <createdelete+0xf6>
      for(i = 0; i < N; i++){
    198c:	2485                	addiw	s1,s1,1
        name[1] = '0' + i;
    198e:	0304879b          	addiw	a5,s1,48
    1992:	f6f408a3          	sb	a5,-143(s0)
        fd = open(name, O_CREATE | O_RDWR);
    1996:	85ce                	mv	a1,s3
    1998:	854a                	mv	a0,s2
    199a:	4fa030ef          	jal	4e94 <open>
        if(fd < 0){
    199e:	fa054fe3          	bltz	a0,195c <createdelete+0x96>
        close(fd);
    19a2:	4da030ef          	jal	4e7c <close>
        if(i > 0 && (i % 2 ) == 0){
    19a6:	fe9053e3          	blez	s1,198c <createdelete+0xc6>
    19aa:	0014f793          	andi	a5,s1,1
    19ae:	d3e9                	beqz	a5,1970 <createdelete+0xaa>
      for(i = 0; i < N; i++){
    19b0:	2485                	addiw	s1,s1,1
    19b2:	fd449ee3          	bne	s1,s4,198e <createdelete+0xc8>
      exit(0);
    19b6:	4501                	li	a0,0
    19b8:	49c030ef          	jal	4e54 <exit>
            printf("%s: unlink failed\n", s);
    19bc:	85ee                	mv	a1,s11
    19be:	00004517          	auipc	a0,0x4
    19c2:	54a50513          	addi	a0,a0,1354 # 5f08 <malloc+0xbae>
    19c6:	0dd030ef          	jal	52a2 <printf>
            exit(1);
    19ca:	4505                	li	a0,1
    19cc:	488030ef          	jal	4e54 <exit>
      exit(1);
    19d0:	4505                	li	a0,1
    19d2:	482030ef          	jal	4e54 <exit>
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
    19f4:	4a0030ef          	jal	4e94 <open>
      if((i == 0 || i >= N/2) && fd < 0){
    19f8:	01f5579b          	srliw	a5,a0,0x1f
    19fc:	dfe9                	beqz	a5,19d6 <createdelete+0x110>
    19fe:	fc098ce3          	beqz	s3,19d6 <createdelete+0x110>
        printf("%s: oops createdelete %s didn't exist\n", s, name);
    1a02:	f7040613          	addi	a2,s0,-144
    1a06:	85ee                	mv	a1,s11
    1a08:	00004517          	auipc	a0,0x4
    1a0c:	51850513          	addi	a0,a0,1304 # 5f20 <malloc+0xbc6>
    1a10:	093030ef          	jal	52a2 <printf>
        exit(1);
    1a14:	4505                	li	a0,1
    1a16:	43e030ef          	jal	4e54 <exit>
      } else if((i >= 1 && i < N/2) && fd >= 0){
    1a1a:	fc0542e3          	bltz	a0,19de <createdelete+0x118>
        printf("%s: oops createdelete %s did exist\n", s, name);
    1a1e:	f7040613          	addi	a2,s0,-144
    1a22:	85ee                	mv	a1,s11
    1a24:	00004517          	auipc	a0,0x4
    1a28:	52450513          	addi	a0,a0,1316 # 5f48 <malloc+0xbee>
    1a2c:	077030ef          	jal	52a2 <printf>
        exit(1);
    1a30:	4505                	li	a0,1
    1a32:	422030ef          	jal	4e54 <exit>
        close(fd);
    1a36:	446030ef          	jal	4e7c <close>
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
    1a7c:	428030ef          	jal	4ea4 <unlink>
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
    1ad4:	a2850513          	addi	a0,a0,-1496 # 54f8 <malloc+0x19e>
    1ad8:	3cc030ef          	jal	4ea4 <unlink>
  pid = fork();
    1adc:	370030ef          	jal	4e4c <fork>
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
    1af6:	e6da8a9b          	addiw	s5,s5,-403 # 41c64e6d <base+0x41c551d5>
    1afa:	6a0d                	lui	s4,0x3
    1afc:	039a0a1b          	addiw	s4,s4,57 # 3039 <subdir+0x3f9>
    if((x % 3) == 0){
    1b00:	000ab9b7          	lui	s3,0xab
    1b04:	aab98993          	addi	s3,s3,-1365 # aaaab <base+0x9ae13>
    1b08:	09b2                	slli	s3,s3,0xc
    1b0a:	aab98993          	addi	s3,s3,-1365
    } else if((x % 3) == 1){
    1b0e:	4b85                	li	s7,1
      unlink("x");
    1b10:	00004b17          	auipc	s6,0x4
    1b14:	9e8b0b13          	addi	s6,s6,-1560 # 54f8 <malloc+0x19e>
      link("cat", "x");
    1b18:	00004c97          	auipc	s9,0x4
    1b1c:	458c8c93          	addi	s9,s9,1112 # 5f70 <malloc+0xc16>
      close(open("x", O_RDWR | O_CREATE));
    1b20:	20200c13          	li	s8,514
    1b24:	a03d                	j	1b52 <linkunlink+0xa0>
    printf("%s: fork failed\n", s);
    1b26:	85a6                	mv	a1,s1
    1b28:	00004517          	auipc	a0,0x4
    1b2c:	1f050513          	addi	a0,a0,496 # 5d18 <malloc+0x9be>
    1b30:	772030ef          	jal	52a2 <printf>
    exit(1);
    1b34:	4505                	li	a0,1
    1b36:	31e030ef          	jal	4e54 <exit>
      close(open("x", O_RDWR | O_CREATE));
    1b3a:	85e2                	mv	a1,s8
    1b3c:	855a                	mv	a0,s6
    1b3e:	356030ef          	jal	4e94 <open>
    1b42:	33a030ef          	jal	4e7c <close>
    1b46:	a021                	j	1b4e <linkunlink+0x9c>
      unlink("x");
    1b48:	855a                	mv	a0,s6
    1b4a:	35a030ef          	jal	4ea4 <unlink>
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
    1b7a:	33a030ef          	jal	4eb4 <link>
    1b7e:	bfc1                	j	1b4e <linkunlink+0x9c>
  if(pid)
    1b80:	020d0363          	beqz	s10,1ba6 <linkunlink+0xf4>
    wait(0);
    1b84:	4501                	li	a0,0
    1b86:	2d6030ef          	jal	4e5c <wait>
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
    1ba8:	2ac030ef          	jal	4e54 <exit>

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
    1bc2:	28a030ef          	jal	4e4c <fork>
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
    1bd8:	3ec50513          	addi	a0,a0,1004 # 5fc0 <malloc+0xc66>
    1bdc:	6c6030ef          	jal	52a2 <printf>
    exit(1);
    1be0:	4505                	li	a0,1
    1be2:	272030ef          	jal	4e54 <exit>
      exit(0);
    1be6:	26e030ef          	jal	4e54 <exit>
    printf("%s: no fork at all!\n", s);
    1bea:	85ce                	mv	a1,s3
    1bec:	00004517          	auipc	a0,0x4
    1bf0:	38c50513          	addi	a0,a0,908 # 5f78 <malloc+0xc1e>
    1bf4:	6ae030ef          	jal	52a2 <printf>
    exit(1);
    1bf8:	4505                	li	a0,1
    1bfa:	25a030ef          	jal	4e54 <exit>
      printf("%s: wait stopped early\n", s);
    1bfe:	85ce                	mv	a1,s3
    1c00:	00004517          	auipc	a0,0x4
    1c04:	39050513          	addi	a0,a0,912 # 5f90 <malloc+0xc36>
    1c08:	69a030ef          	jal	52a2 <printf>
      exit(1);
    1c0c:	4505                	li	a0,1
    1c0e:	246030ef          	jal	4e54 <exit>
    printf("%s: wait got too many\n", s);
    1c12:	85ce                	mv	a1,s3
    1c14:	00004517          	auipc	a0,0x4
    1c18:	39450513          	addi	a0,a0,916 # 5fa8 <malloc+0xc4e>
    1c1c:	686030ef          	jal	52a2 <printf>
    exit(1);
    1c20:	4505                	li	a0,1
    1c22:	232030ef          	jal	4e54 <exit>
  if (n == 0) {
    1c26:	d0f1                	beqz	s1,1bea <forktest+0x3e>
  for(; n > 0; n--){
    1c28:	00905963          	blez	s1,1c3a <forktest+0x8e>
    if(wait(0) < 0){
    1c2c:	4501                	li	a0,0
    1c2e:	22e030ef          	jal	4e5c <wait>
    1c32:	fc0546e3          	bltz	a0,1bfe <forktest+0x52>
  for(; n > 0; n--){
    1c36:	34fd                	addiw	s1,s1,-1
    1c38:	f8f5                	bnez	s1,1c2c <forktest+0x80>
  if(wait(0) != -1){
    1c3a:	4501                	li	a0,0
    1c3c:	220030ef          	jal	4e5c <wait>
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
    1c76:	35098993          	addi	s3,s3,848 # c350 <uninit+0x1dc8>
    1c7a:	1003d937          	lui	s2,0x1003d
    1c7e:	090e                	slli	s2,s2,0x3
    1c80:	48090913          	addi	s2,s2,1152 # 1003d480 <base+0x1002d7e8>
    pid = fork();
    1c84:	1c8030ef          	jal	4e4c <fork>
    if(pid < 0){
    1c88:	02054763          	bltz	a0,1cb6 <kernmem+0x62>
    if(pid == 0){
    1c8c:	cd1d                	beqz	a0,1cca <kernmem+0x76>
    wait(&xstatus);
    1c8e:	8556                	mv	a0,s5
    1c90:	1cc030ef          	jal	4e5c <wait>
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
    1cbc:	06050513          	addi	a0,a0,96 # 5d18 <malloc+0x9be>
    1cc0:	5e2030ef          	jal	52a2 <printf>
      exit(1);
    1cc4:	4505                	li	a0,1
    1cc6:	18e030ef          	jal	4e54 <exit>
      printf("%s: oops could read %p = %x\n", s, a, *a);
    1cca:	0004c683          	lbu	a3,0(s1)
    1cce:	8626                	mv	a2,s1
    1cd0:	85da                	mv	a1,s6
    1cd2:	00004517          	auipc	a0,0x4
    1cd6:	31650513          	addi	a0,a0,790 # 5fe8 <malloc+0xc8e>
    1cda:	5c8030ef          	jal	52a2 <printf>
      exit(1);
    1cde:	4505                	li	a0,1
    1ce0:	174030ef          	jal	4e54 <exit>
      exit(1);
    1ce4:	4505                	li	a0,1
    1ce6:	16e030ef          	jal	4e54 <exit>

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
    1d0e:	13e030ef          	jal	4e4c <fork>
    if(pid < 0){
    1d12:	02054963          	bltz	a0,1d44 <MAXVAplus+0x5a>
    if(pid == 0){
    1d16:	c129                	beqz	a0,1d58 <MAXVAplus+0x6e>
    wait(&xstatus);
    1d18:	854a                	mv	a0,s2
    1d1a:	142030ef          	jal	4e5c <wait>
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
    1d4a:	fd250513          	addi	a0,a0,-46 # 5d18 <malloc+0x9be>
    1d4e:	554030ef          	jal	52a2 <printf>
      exit(1);
    1d52:	4505                	li	a0,1
    1d54:	100030ef          	jal	4e54 <exit>
      *(char*)a = 99;
    1d58:	fc843783          	ld	a5,-56(s0)
    1d5c:	06300713          	li	a4,99
    1d60:	00e78023          	sb	a4,0(a5)
      printf("%s: oops wrote %p\n", s, (void*)a);
    1d64:	fc843603          	ld	a2,-56(s0)
    1d68:	85ce                	mv	a1,s3
    1d6a:	00004517          	auipc	a0,0x4
    1d6e:	29e50513          	addi	a0,a0,670 # 6008 <malloc+0xcae>
    1d72:	530030ef          	jal	52a2 <printf>
      exit(1);
    1d76:	4505                	li	a0,1
    1d78:	0dc030ef          	jal	4e54 <exit>
      exit(1);
    1d7c:	4505                	li	a0,1
    1d7e:	0d6030ef          	jal	4e54 <exit>

0000000000001d82 <stacktest>:
{
    1d82:	7179                	addi	sp,sp,-48
    1d84:	f406                	sd	ra,40(sp)
    1d86:	f022                	sd	s0,32(sp)
    1d88:	ec26                	sd	s1,24(sp)
    1d8a:	1800                	addi	s0,sp,48
    1d8c:	84aa                	mv	s1,a0
  pid = fork();
    1d8e:	0be030ef          	jal	4e4c <fork>
  if(pid == 0) {
    1d92:	cd11                	beqz	a0,1dae <stacktest+0x2c>
  } else if(pid < 0){
    1d94:	02054c63          	bltz	a0,1dcc <stacktest+0x4a>
  wait(&xstatus);
    1d98:	fdc40513          	addi	a0,s0,-36
    1d9c:	0c0030ef          	jal	4e5c <wait>
  if(xstatus == -1)  // kernel killed child?
    1da0:	fdc42503          	lw	a0,-36(s0)
    1da4:	57fd                	li	a5,-1
    1da6:	02f50d63          	beq	a0,a5,1de0 <stacktest+0x5e>
    exit(xstatus);
    1daa:	0aa030ef          	jal	4e54 <exit>

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
    1dbe:	26650513          	addi	a0,a0,614 # 6020 <malloc+0xcc6>
    1dc2:	4e0030ef          	jal	52a2 <printf>
    exit(1);
    1dc6:	4505                	li	a0,1
    1dc8:	08c030ef          	jal	4e54 <exit>
    printf("%s: fork failed\n", s);
    1dcc:	85a6                	mv	a1,s1
    1dce:	00004517          	auipc	a0,0x4
    1dd2:	f4a50513          	addi	a0,a0,-182 # 5d18 <malloc+0x9be>
    1dd6:	4cc030ef          	jal	52a2 <printf>
    exit(1);
    1dda:	4505                	li	a0,1
    1ddc:	078030ef          	jal	4e54 <exit>
    exit(0);
    1de0:	4501                	li	a0,0
    1de2:	072030ef          	jal	4e54 <exit>

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
    1dfc:	b3878793          	addi	a5,a5,-1224 # 7930 <malloc+0x25d6>
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
    1e2c:	020030ef          	jal	4e4c <fork>
    if(pid == 0) {
    1e30:	cd19                	beqz	a0,1e4e <nowrite+0x68>
    } else if(pid < 0){
    1e32:	04054163          	bltz	a0,1e74 <nowrite+0x8e>
    wait(&xstatus);
    1e36:	854a                	mv	a0,s2
    1e38:	024030ef          	jal	4e5c <wait>
    if(xstatus == 0){
    1e3c:	fcc42783          	lw	a5,-52(s0)
    1e40:	c7a1                	beqz	a5,1e88 <nowrite+0xa2>
  for(int ai = 0; ai < sizeof(addrs)/sizeof(addrs[0]); ai++){
    1e42:	2485                	addiw	s1,s1,1
    1e44:	ff3494e3          	bne	s1,s3,1e2c <nowrite+0x46>
  exit(0);
    1e48:	4501                	li	a0,0
    1e4a:	00a030ef          	jal	4e54 <exit>
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
    1e66:	1e650513          	addi	a0,a0,486 # 6048 <malloc+0xcee>
    1e6a:	438030ef          	jal	52a2 <printf>
      exit(0);
    1e6e:	4501                	li	a0,0
    1e70:	7e5020ef          	jal	4e54 <exit>
      printf("%s: fork failed\n", s);
    1e74:	85d2                	mv	a1,s4
    1e76:	00004517          	auipc	a0,0x4
    1e7a:	ea250513          	addi	a0,a0,-350 # 5d18 <malloc+0x9be>
    1e7e:	424030ef          	jal	52a2 <printf>
      exit(1);
    1e82:	4505                	li	a0,1
    1e84:	7d1020ef          	jal	4e54 <exit>
      exit(1);
    1e88:	4505                	li	a0,1
    1e8a:	7cb020ef          	jal	4e54 <exit>

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
    1ea4:	7a9020ef          	jal	4e4c <fork>
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
    1ec2:	79b020ef          	jal	4e5c <wait>
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
    1ede:	777020ef          	jal	4e54 <exit>
    1ee2:	e0d2                	sd	s4,64(sp)
    1ee4:	fc56                	sd	s5,56(sp)
    1ee6:	f85a                	sd	s6,48(sp)
    1ee8:	f45e                	sd	s7,40(sp)
    1eea:	f062                	sd	s8,32(sp)
    1eec:	e86a                	sd	s10,16(sp)
      printf("fork failed\n");
    1eee:	00005517          	auipc	a0,0x5
    1ef2:	31250513          	addi	a0,a0,786 # 7200 <malloc+0x1ea6>
    1ef6:	3ac030ef          	jal	52a2 <printf>
      exit(1);
    1efa:	4505                	li	a0,1
    1efc:	759020ef          	jal	4e54 <exit>
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
    1f24:	781020ef          	jal	4ea4 <unlink>
    1f28:	47f9                	li	a5,30
    1f2a:	8d3e                	mv	s10,a5
          int fd = open(name, O_CREATE | O_RDWR);
    1f2c:	f9840b93          	addi	s7,s0,-104
    1f30:	20200b13          	li	s6,514
          int cc = write(fd, buf, sz);
    1f34:	6a8d                	lui	s5,0x3
    1f36:	0000bc17          	auipc	s8,0xb
    1f3a:	d62c0c13          	addi	s8,s8,-670 # cc98 <buf>
        for(int i = 0; i < ci+1; i++){
    1f3e:	8a26                	mv	s4,s1
    1f40:	02094563          	bltz	s2,1f6a <manywrites+0xdc>
          int fd = open(name, O_CREATE | O_RDWR);
    1f44:	85da                	mv	a1,s6
    1f46:	855e                	mv	a0,s7
    1f48:	74d020ef          	jal	4e94 <open>
    1f4c:	89aa                	mv	s3,a0
          if(fd < 0){
    1f4e:	02054d63          	bltz	a0,1f88 <manywrites+0xfa>
          int cc = write(fd, buf, sz);
    1f52:	8656                	mv	a2,s5
    1f54:	85e2                	mv	a1,s8
    1f56:	71f020ef          	jal	4e74 <write>
          if(cc != sz){
    1f5a:	05551363          	bne	a0,s5,1fa0 <manywrites+0x112>
          close(fd);
    1f5e:	854e                	mv	a0,s3
    1f60:	71d020ef          	jal	4e7c <close>
        for(int i = 0; i < ci+1; i++){
    1f64:	2a05                	addiw	s4,s4,1
    1f66:	fd495fe3          	bge	s2,s4,1f44 <manywrites+0xb6>
        unlink(name);
    1f6a:	f9840513          	addi	a0,s0,-104
    1f6e:	737020ef          	jal	4ea4 <unlink>
      for(int iters = 0; iters < howmany; iters++){
    1f72:	fffd079b          	addiw	a5,s10,-1
    1f76:	8d3e                	mv	s10,a5
    1f78:	f3f9                	bnez	a5,1f3e <manywrites+0xb0>
      unlink(name);
    1f7a:	f9840513          	addi	a0,s0,-104
    1f7e:	727020ef          	jal	4ea4 <unlink>
      exit(0);
    1f82:	4501                	li	a0,0
    1f84:	6d1020ef          	jal	4e54 <exit>
            printf("%s: cannot create %s\n", s, name);
    1f88:	f9840613          	addi	a2,s0,-104
    1f8c:	85e6                	mv	a1,s9
    1f8e:	00004517          	auipc	a0,0x4
    1f92:	0da50513          	addi	a0,a0,218 # 6068 <malloc+0xd0e>
    1f96:	30c030ef          	jal	52a2 <printf>
            exit(1);
    1f9a:	4505                	li	a0,1
    1f9c:	6b9020ef          	jal	4e54 <exit>
            printf("%s: write(%d) ret %d\n", s, sz, cc);
    1fa0:	86aa                	mv	a3,a0
    1fa2:	660d                	lui	a2,0x3
    1fa4:	85e6                	mv	a1,s9
    1fa6:	00003517          	auipc	a0,0x3
    1faa:	5b250513          	addi	a0,a0,1458 # 5558 <malloc+0x1fe>
    1fae:	2f4030ef          	jal	52a2 <printf>
            exit(1);
    1fb2:	4505                	li	a0,1
    1fb4:	6a1020ef          	jal	4e54 <exit>
    1fb8:	e0d2                	sd	s4,64(sp)
    1fba:	fc56                	sd	s5,56(sp)
    1fbc:	f85a                	sd	s6,48(sp)
    1fbe:	f45e                	sd	s7,40(sp)
    1fc0:	f062                	sd	s8,32(sp)
    1fc2:	e86a                	sd	s10,16(sp)
      exit(st);
    1fc4:	691020ef          	jal	4e54 <exit>

0000000000001fc8 <copyinstr3>:
{
    1fc8:	7179                	addi	sp,sp,-48
    1fca:	f406                	sd	ra,40(sp)
    1fcc:	f022                	sd	s0,32(sp)
    1fce:	ec26                	sd	s1,24(sp)
    1fd0:	1800                	addi	s0,sp,48
  sbrk(8192);
    1fd2:	6509                	lui	a0,0x2
    1fd4:	64d020ef          	jal	4e20 <sbrk>
  uint64 top = (uint64) sbrk(0);
    1fd8:	4501                	li	a0,0
    1fda:	647020ef          	jal	4e20 <sbrk>
  if((top % PGSIZE) != 0){
    1fde:	03451793          	slli	a5,a0,0x34
    1fe2:	e7bd                	bnez	a5,2050 <copyinstr3+0x88>
  top = (uint64) sbrk(0);
    1fe4:	4501                	li	a0,0
    1fe6:	63b020ef          	jal	4e20 <sbrk>
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
    1ffe:	6a7020ef          	jal	4ea4 <unlink>
  if(ret != -1){
    2002:	57fd                	li	a5,-1
    2004:	06f51763          	bne	a0,a5,2072 <copyinstr3+0xaa>
  int fd = open(b, O_CREATE | O_WRONLY);
    2008:	20100593          	li	a1,513
    200c:	8526                	mv	a0,s1
    200e:	687020ef          	jal	4e94 <open>
  if(fd != -1){
    2012:	57fd                	li	a5,-1
    2014:	06f51a63          	bne	a0,a5,2088 <copyinstr3+0xc0>
  ret = link(b, b);
    2018:	85a6                	mv	a1,s1
    201a:	8526                	mv	a0,s1
    201c:	699020ef          	jal	4eb4 <link>
  if(ret != -1){
    2020:	57fd                	li	a5,-1
    2022:	06f51e63          	bne	a0,a5,209e <copyinstr3+0xd6>
  char *args[] = { "xx", 0 };
    2026:	00005797          	auipc	a5,0x5
    202a:	d0a78793          	addi	a5,a5,-758 # 6d30 <malloc+0x19d6>
    202e:	fcf43823          	sd	a5,-48(s0)
    2032:	fc043c23          	sd	zero,-40(s0)
  ret = exec(b, args);
    2036:	fd040593          	addi	a1,s0,-48
    203a:	8526                	mv	a0,s1
    203c:	651020ef          	jal	4e8c <exec>
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
    205a:	5c7020ef          	jal	4e20 <sbrk>
    205e:	b759                	j	1fe4 <copyinstr3+0x1c>
    printf("oops\n");
    2060:	00004517          	auipc	a0,0x4
    2064:	02050513          	addi	a0,a0,32 # 6080 <malloc+0xd26>
    2068:	23a030ef          	jal	52a2 <printf>
    exit(1);
    206c:	4505                	li	a0,1
    206e:	5e7020ef          	jal	4e54 <exit>
    printf("unlink(%s) returned %d, not -1\n", b, ret);
    2072:	862a                	mv	a2,a0
    2074:	85a6                	mv	a1,s1
    2076:	00004517          	auipc	a0,0x4
    207a:	bc250513          	addi	a0,a0,-1086 # 5c38 <malloc+0x8de>
    207e:	224030ef          	jal	52a2 <printf>
    exit(1);
    2082:	4505                	li	a0,1
    2084:	5d1020ef          	jal	4e54 <exit>
    printf("open(%s) returned %d, not -1\n", b, fd);
    2088:	862a                	mv	a2,a0
    208a:	85a6                	mv	a1,s1
    208c:	00004517          	auipc	a0,0x4
    2090:	bcc50513          	addi	a0,a0,-1076 # 5c58 <malloc+0x8fe>
    2094:	20e030ef          	jal	52a2 <printf>
    exit(1);
    2098:	4505                	li	a0,1
    209a:	5bb020ef          	jal	4e54 <exit>
    printf("link(%s, %s) returned %d, not -1\n", b, b, ret);
    209e:	86aa                	mv	a3,a0
    20a0:	8626                	mv	a2,s1
    20a2:	85a6                	mv	a1,s1
    20a4:	00004517          	auipc	a0,0x4
    20a8:	bd450513          	addi	a0,a0,-1068 # 5c78 <malloc+0x91e>
    20ac:	1f6030ef          	jal	52a2 <printf>
    exit(1);
    20b0:	4505                	li	a0,1
    20b2:	5a3020ef          	jal	4e54 <exit>
    printf("exec(%s) returned %d, not -1\n", b, fd);
    20b6:	863e                	mv	a2,a5
    20b8:	85a6                	mv	a1,s1
    20ba:	00004517          	auipc	a0,0x4
    20be:	be650513          	addi	a0,a0,-1050 # 5ca0 <malloc+0x946>
    20c2:	1e0030ef          	jal	52a2 <printf>
    exit(1);
    20c6:	4505                	li	a0,1
    20c8:	58d020ef          	jal	4e54 <exit>

00000000000020cc <rwsbrk>:
{
    20cc:	1101                	addi	sp,sp,-32
    20ce:	ec06                	sd	ra,24(sp)
    20d0:	e822                	sd	s0,16(sp)
    20d2:	1000                	addi	s0,sp,32
  uint64 a = (uint64) sbrk(8192);
    20d4:	6509                	lui	a0,0x2
    20d6:	54b020ef          	jal	4e20 <sbrk>
  if(a == (uint64) SBRK_ERROR) {
    20da:	57fd                	li	a5,-1
    20dc:	04f50a63          	beq	a0,a5,2130 <rwsbrk+0x64>
    20e0:	e426                	sd	s1,8(sp)
    20e2:	84aa                	mv	s1,a0
  if (sbrk(-8192) == SBRK_ERROR) {
    20e4:	7579                	lui	a0,0xffffe
    20e6:	53b020ef          	jal	4e20 <sbrk>
    20ea:	57fd                	li	a5,-1
    20ec:	04f50d63          	beq	a0,a5,2146 <rwsbrk+0x7a>
    20f0:	e04a                	sd	s2,0(sp)
  fd = open("rwsbrk", O_CREATE|O_WRONLY);
    20f2:	20100593          	li	a1,513
    20f6:	00004517          	auipc	a0,0x4
    20fa:	fca50513          	addi	a0,a0,-54 # 60c0 <malloc+0xd66>
    20fe:	597020ef          	jal	4e94 <open>
    2102:	892a                	mv	s2,a0
  if(fd < 0){
    2104:	04054b63          	bltz	a0,215a <rwsbrk+0x8e>
  n = write(fd, (void*)(a+PGSIZE), 1024);
    2108:	6785                	lui	a5,0x1
    210a:	94be                	add	s1,s1,a5
    210c:	40000613          	li	a2,1024
    2110:	85a6                	mv	a1,s1
    2112:	563020ef          	jal	4e74 <write>
    2116:	862a                	mv	a2,a0
  if(n >= 0){
    2118:	04054a63          	bltz	a0,216c <rwsbrk+0xa0>
    printf("write(fd, %p, 1024) returned %d, not -1\n", (void*)a+PGSIZE, n);
    211c:	85a6                	mv	a1,s1
    211e:	00004517          	auipc	a0,0x4
    2122:	fc250513          	addi	a0,a0,-62 # 60e0 <malloc+0xd86>
    2126:	17c030ef          	jal	52a2 <printf>
    exit(1);
    212a:	4505                	li	a0,1
    212c:	529020ef          	jal	4e54 <exit>
    2130:	e426                	sd	s1,8(sp)
    2132:	e04a                	sd	s2,0(sp)
    printf("sbrk(rwsbrk) failed\n");
    2134:	00004517          	auipc	a0,0x4
    2138:	f5450513          	addi	a0,a0,-172 # 6088 <malloc+0xd2e>
    213c:	166030ef          	jal	52a2 <printf>
    exit(1);
    2140:	4505                	li	a0,1
    2142:	513020ef          	jal	4e54 <exit>
    2146:	e04a                	sd	s2,0(sp)
    printf("sbrk(rwsbrk) shrink failed\n");
    2148:	00004517          	auipc	a0,0x4
    214c:	f5850513          	addi	a0,a0,-168 # 60a0 <malloc+0xd46>
    2150:	152030ef          	jal	52a2 <printf>
    exit(1);
    2154:	4505                	li	a0,1
    2156:	4ff020ef          	jal	4e54 <exit>
    printf("open(rwsbrk) failed\n");
    215a:	00004517          	auipc	a0,0x4
    215e:	f6e50513          	addi	a0,a0,-146 # 60c8 <malloc+0xd6e>
    2162:	140030ef          	jal	52a2 <printf>
    exit(1);
    2166:	4505                	li	a0,1
    2168:	4ed020ef          	jal	4e54 <exit>
  close(fd);
    216c:	854a                	mv	a0,s2
    216e:	50f020ef          	jal	4e7c <close>
  unlink("rwsbrk");
    2172:	00004517          	auipc	a0,0x4
    2176:	f4e50513          	addi	a0,a0,-178 # 60c0 <malloc+0xd66>
    217a:	52b020ef          	jal	4ea4 <unlink>
  fd = open("README", O_RDONLY);
    217e:	4581                	li	a1,0
    2180:	00003517          	auipc	a0,0x3
    2184:	4e050513          	addi	a0,a0,1248 # 5660 <malloc+0x306>
    2188:	50d020ef          	jal	4e94 <open>
    218c:	892a                	mv	s2,a0
  if(fd < 0){
    218e:	02054363          	bltz	a0,21b4 <rwsbrk+0xe8>
  n = read(fd, (void*)(a+PGSIZE), 10);
    2192:	4629                	li	a2,10
    2194:	85a6                	mv	a1,s1
    2196:	4d7020ef          	jal	4e6c <read>
    219a:	862a                	mv	a2,a0
  if(n >= 0){
    219c:	02054563          	bltz	a0,21c6 <rwsbrk+0xfa>
    printf("read(fd, %p, 10) returned %d, not -1\n", (void*)a+PGSIZE, n);
    21a0:	85a6                	mv	a1,s1
    21a2:	00004517          	auipc	a0,0x4
    21a6:	f6e50513          	addi	a0,a0,-146 # 6110 <malloc+0xdb6>
    21aa:	0f8030ef          	jal	52a2 <printf>
    exit(1);
    21ae:	4505                	li	a0,1
    21b0:	4a5020ef          	jal	4e54 <exit>
    printf("open(README) failed\n");
    21b4:	00003517          	auipc	a0,0x3
    21b8:	4b450513          	addi	a0,a0,1204 # 5668 <malloc+0x30e>
    21bc:	0e6030ef          	jal	52a2 <printf>
    exit(1);
    21c0:	4505                	li	a0,1
    21c2:	493020ef          	jal	4e54 <exit>
  close(fd);
    21c6:	854a                	mv	a0,s2
    21c8:	4b5020ef          	jal	4e7c <close>
  exit(0);
    21cc:	4501                	li	a0,0
    21ce:	487020ef          	jal	4e54 <exit>

00000000000021d2 <sbrkbasic>:
{
    21d2:	715d                	addi	sp,sp,-80
    21d4:	e486                	sd	ra,72(sp)
    21d6:	e0a2                	sd	s0,64(sp)
    21d8:	ec56                	sd	s5,24(sp)
    21da:	0880                	addi	s0,sp,80
    21dc:	8aaa                	mv	s5,a0
  pid = fork();
    21de:	46f020ef          	jal	4e4c <fork>
  if(pid < 0){
    21e2:	02054c63          	bltz	a0,221a <sbrkbasic+0x48>
  if(pid == 0){
    21e6:	ed31                	bnez	a0,2242 <sbrkbasic+0x70>
    a = sbrk(TOOMUCH);
    21e8:	40000537          	lui	a0,0x40000
    21ec:	435020ef          	jal	4e20 <sbrk>
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
    220a:	00d50023          	sb	a3,0(a0) # 40000000 <base+0x3fff0368>
    for(b = a; b < a+TOOMUCH; b += PGSIZE){
    220e:	953a                	add	a0,a0,a4
    2210:	fef51de3          	bne	a0,a5,220a <sbrkbasic+0x38>
    exit(1);
    2214:	4505                	li	a0,1
    2216:	43f020ef          	jal	4e54 <exit>
    221a:	fc26                	sd	s1,56(sp)
    221c:	f84a                	sd	s2,48(sp)
    221e:	f44e                	sd	s3,40(sp)
    2220:	f052                	sd	s4,32(sp)
    printf("fork failed in sbrkbasic\n");
    2222:	00004517          	auipc	a0,0x4
    2226:	f1650513          	addi	a0,a0,-234 # 6138 <malloc+0xdde>
    222a:	078030ef          	jal	52a2 <printf>
    exit(1);
    222e:	4505                	li	a0,1
    2230:	425020ef          	jal	4e54 <exit>
    2234:	fc26                	sd	s1,56(sp)
    2236:	f84a                	sd	s2,48(sp)
    2238:	f44e                	sd	s3,40(sp)
    223a:	f052                	sd	s4,32(sp)
      exit(0);
    223c:	4501                	li	a0,0
    223e:	417020ef          	jal	4e54 <exit>
  wait(&xstatus);
    2242:	fbc40513          	addi	a0,s0,-68
    2246:	417020ef          	jal	4e5c <wait>
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
    225e:	3c3020ef          	jal	4e20 <sbrk>
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
    227e:	ede50513          	addi	a0,a0,-290 # 6158 <malloc+0xdfe>
    2282:	020030ef          	jal	52a2 <printf>
    exit(1);
    2286:	4505                	li	a0,1
    2288:	3cd020ef          	jal	4e54 <exit>
    228c:	84be                	mv	s1,a5
    b = sbrk(1);
    228e:	854e                	mv	a0,s3
    2290:	391020ef          	jal	4e20 <sbrk>
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
    22a6:	3a7020ef          	jal	4e4c <fork>
    22aa:	892a                	mv	s2,a0
  if(pid < 0){
    22ac:	04054263          	bltz	a0,22f0 <sbrkbasic+0x11e>
  c = sbrk(1);
    22b0:	4505                	li	a0,1
    22b2:	36f020ef          	jal	4e20 <sbrk>
  c = sbrk(1);
    22b6:	4505                	li	a0,1
    22b8:	369020ef          	jal	4e20 <sbrk>
  if(c != a + 1){
    22bc:	0489                	addi	s1,s1,2
    22be:	04950363          	beq	a0,s1,2304 <sbrkbasic+0x132>
    printf("%s: sbrk test failed post-fork\n", s);
    22c2:	85d6                	mv	a1,s5
    22c4:	00004517          	auipc	a0,0x4
    22c8:	ef450513          	addi	a0,a0,-268 # 61b8 <malloc+0xe5e>
    22cc:	7d7020ef          	jal	52a2 <printf>
    exit(1);
    22d0:	4505                	li	a0,1
    22d2:	383020ef          	jal	4e54 <exit>
      printf("%s: sbrk test failed %d %p %p\n", s, i, a, b);
    22d6:	872a                	mv	a4,a0
    22d8:	86a6                	mv	a3,s1
    22da:	864a                	mv	a2,s2
    22dc:	85d6                	mv	a1,s5
    22de:	00004517          	auipc	a0,0x4
    22e2:	e9a50513          	addi	a0,a0,-358 # 6178 <malloc+0xe1e>
    22e6:	7bd020ef          	jal	52a2 <printf>
      exit(1);
    22ea:	4505                	li	a0,1
    22ec:	369020ef          	jal	4e54 <exit>
    printf("%s: sbrk test fork failed\n", s);
    22f0:	85d6                	mv	a1,s5
    22f2:	00004517          	auipc	a0,0x4
    22f6:	ea650513          	addi	a0,a0,-346 # 6198 <malloc+0xe3e>
    22fa:	7a9020ef          	jal	52a2 <printf>
    exit(1);
    22fe:	4505                	li	a0,1
    2300:	355020ef          	jal	4e54 <exit>
  if(pid == 0)
    2304:	00091563          	bnez	s2,230e <sbrkbasic+0x13c>
    exit(0);
    2308:	4501                	li	a0,0
    230a:	34b020ef          	jal	4e54 <exit>
  wait(&xstatus);
    230e:	fbc40513          	addi	a0,s0,-68
    2312:	34b020ef          	jal	4e5c <wait>
  exit(xstatus);
    2316:	fbc42503          	lw	a0,-68(s0)
    231a:	33b020ef          	jal	4e54 <exit>

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
    2332:	2ef020ef          	jal	4e20 <sbrk>
    2336:	892a                	mv	s2,a0
  a = sbrk(0);
    2338:	4501                	li	a0,0
    233a:	2e7020ef          	jal	4e20 <sbrk>
    233e:	84aa                	mv	s1,a0
  p = sbrk(amt);
    2340:	06400537          	lui	a0,0x6400
    2344:	9d05                	subw	a0,a0,s1
    2346:	2db020ef          	jal	4e20 <sbrk>
  if (p != a) {
    234a:	08a49963          	bne	s1,a0,23dc <sbrkmuch+0xbe>
  *lastaddr = 99;
    234e:	064007b7          	lui	a5,0x6400
    2352:	06300713          	li	a4,99
    2356:	fee78fa3          	sb	a4,-1(a5) # 63fffff <base+0x63f0367>
  a = sbrk(0);
    235a:	4501                	li	a0,0
    235c:	2c5020ef          	jal	4e20 <sbrk>
    2360:	84aa                	mv	s1,a0
  c = sbrk(-PGSIZE);
    2362:	757d                	lui	a0,0xfffff
    2364:	2bd020ef          	jal	4e20 <sbrk>
  if(c == (char*)SBRK_ERROR){
    2368:	57fd                	li	a5,-1
    236a:	08f50363          	beq	a0,a5,23f0 <sbrkmuch+0xd2>
  c = sbrk(0);
    236e:	4501                	li	a0,0
    2370:	2b1020ef          	jal	4e20 <sbrk>
  if(c != a - PGSIZE){
    2374:	80048793          	addi	a5,s1,-2048
    2378:	80078793          	addi	a5,a5,-2048
    237c:	08f51463          	bne	a0,a5,2404 <sbrkmuch+0xe6>
  a = sbrk(0);
    2380:	4501                	li	a0,0
    2382:	29f020ef          	jal	4e20 <sbrk>
    2386:	84aa                	mv	s1,a0
  c = sbrk(PGSIZE);
    2388:	6505                	lui	a0,0x1
    238a:	297020ef          	jal	4e20 <sbrk>
    238e:	8a2a                	mv	s4,a0
  if(c != a || sbrk(0) != a + PGSIZE){
    2390:	08a49663          	bne	s1,a0,241c <sbrkmuch+0xfe>
    2394:	4501                	li	a0,0
    2396:	28b020ef          	jal	4e20 <sbrk>
    239a:	6785                	lui	a5,0x1
    239c:	97a6                	add	a5,a5,s1
    239e:	06f51f63          	bne	a0,a5,241c <sbrkmuch+0xfe>
  if(*lastaddr == 99){
    23a2:	064007b7          	lui	a5,0x6400
    23a6:	fff7c703          	lbu	a4,-1(a5) # 63fffff <base+0x63f0367>
    23aa:	06300793          	li	a5,99
    23ae:	08f70363          	beq	a4,a5,2434 <sbrkmuch+0x116>
  a = sbrk(0);
    23b2:	4501                	li	a0,0
    23b4:	26d020ef          	jal	4e20 <sbrk>
    23b8:	84aa                	mv	s1,a0
  c = sbrk(-(sbrk(0) - oldbrk));
    23ba:	4501                	li	a0,0
    23bc:	265020ef          	jal	4e20 <sbrk>
    23c0:	40a9053b          	subw	a0,s2,a0
    23c4:	25d020ef          	jal	4e20 <sbrk>
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
    23e2:	dfa50513          	addi	a0,a0,-518 # 61d8 <malloc+0xe7e>
    23e6:	6bd020ef          	jal	52a2 <printf>
    exit(1);
    23ea:	4505                	li	a0,1
    23ec:	269020ef          	jal	4e54 <exit>
    printf("%s: sbrk could not deallocate\n", s);
    23f0:	85ce                	mv	a1,s3
    23f2:	00004517          	auipc	a0,0x4
    23f6:	e2e50513          	addi	a0,a0,-466 # 6220 <malloc+0xec6>
    23fa:	6a9020ef          	jal	52a2 <printf>
    exit(1);
    23fe:	4505                	li	a0,1
    2400:	255020ef          	jal	4e54 <exit>
    printf("%s: sbrk deallocation produced wrong address, a %p c %p\n", s, a, c);
    2404:	86aa                	mv	a3,a0
    2406:	8626                	mv	a2,s1
    2408:	85ce                	mv	a1,s3
    240a:	00004517          	auipc	a0,0x4
    240e:	e3650513          	addi	a0,a0,-458 # 6240 <malloc+0xee6>
    2412:	691020ef          	jal	52a2 <printf>
    exit(1);
    2416:	4505                	li	a0,1
    2418:	23d020ef          	jal	4e54 <exit>
    printf("%s: sbrk re-allocation failed, a %p c %p\n", s, a, c);
    241c:	86d2                	mv	a3,s4
    241e:	8626                	mv	a2,s1
    2420:	85ce                	mv	a1,s3
    2422:	00004517          	auipc	a0,0x4
    2426:	e5e50513          	addi	a0,a0,-418 # 6280 <malloc+0xf26>
    242a:	679020ef          	jal	52a2 <printf>
    exit(1);
    242e:	4505                	li	a0,1
    2430:	225020ef          	jal	4e54 <exit>
    printf("%s: sbrk de-allocation didn't really deallocate\n", s);
    2434:	85ce                	mv	a1,s3
    2436:	00004517          	auipc	a0,0x4
    243a:	e7a50513          	addi	a0,a0,-390 # 62b0 <malloc+0xf56>
    243e:	665020ef          	jal	52a2 <printf>
    exit(1);
    2442:	4505                	li	a0,1
    2444:	211020ef          	jal	4e54 <exit>
    printf("%s: sbrk downsize failed, a %p c %p\n", s, a, c);
    2448:	86aa                	mv	a3,a0
    244a:	8626                	mv	a2,s1
    244c:	85ce                	mv	a1,s3
    244e:	00004517          	auipc	a0,0x4
    2452:	e9a50513          	addi	a0,a0,-358 # 62e8 <malloc+0xf8e>
    2456:	64d020ef          	jal	52a2 <printf>
    exit(1);
    245a:	4505                	li	a0,1
    245c:	1f9020ef          	jal	4e54 <exit>

0000000000002460 <argptest>:
{
    2460:	1101                	addi	sp,sp,-32
    2462:	ec06                	sd	ra,24(sp)
    2464:	e822                	sd	s0,16(sp)
    2466:	e426                	sd	s1,8(sp)
    2468:	e04a                	sd	s2,0(sp)
    246a:	1000                	addi	s0,sp,32
    246c:	892a                	mv	s2,a0
  fd = open("init", O_RDONLY);
    246e:	4581                	li	a1,0
    2470:	00004517          	auipc	a0,0x4
    2474:	ea050513          	addi	a0,a0,-352 # 6310 <malloc+0xfb6>
    2478:	21d020ef          	jal	4e94 <open>
  if (fd < 0) {
    247c:	02054563          	bltz	a0,24a6 <argptest+0x46>
    2480:	84aa                	mv	s1,a0
  read(fd, sbrk(0) - 1, -1);
    2482:	4501                	li	a0,0
    2484:	19d020ef          	jal	4e20 <sbrk>
    2488:	567d                	li	a2,-1
    248a:	00c505b3          	add	a1,a0,a2
    248e:	8526                	mv	a0,s1
    2490:	1dd020ef          	jal	4e6c <read>
  close(fd);
    2494:	8526                	mv	a0,s1
    2496:	1e7020ef          	jal	4e7c <close>
}
    249a:	60e2                	ld	ra,24(sp)
    249c:	6442                	ld	s0,16(sp)
    249e:	64a2                	ld	s1,8(sp)
    24a0:	6902                	ld	s2,0(sp)
    24a2:	6105                	addi	sp,sp,32
    24a4:	8082                	ret
    printf("%s: open failed\n", s);
    24a6:	85ca                	mv	a1,s2
    24a8:	00004517          	auipc	a0,0x4
    24ac:	88850513          	addi	a0,a0,-1912 # 5d30 <malloc+0x9d6>
    24b0:	5f3020ef          	jal	52a2 <printf>
    exit(1);
    24b4:	4505                	li	a0,1
    24b6:	19f020ef          	jal	4e54 <exit>

00000000000024ba <sbrkbugs>:
{
    24ba:	1141                	addi	sp,sp,-16
    24bc:	e406                	sd	ra,8(sp)
    24be:	e022                	sd	s0,0(sp)
    24c0:	0800                	addi	s0,sp,16
  int pid = fork();
    24c2:	18b020ef          	jal	4e4c <fork>
  if(pid < 0){
    24c6:	00054c63          	bltz	a0,24de <sbrkbugs+0x24>
  if(pid == 0){
    24ca:	e11d                	bnez	a0,24f0 <sbrkbugs+0x36>
    int sz = (uint64) sbrk(0);
    24cc:	155020ef          	jal	4e20 <sbrk>
    sbrk(-sz);
    24d0:	40a0053b          	negw	a0,a0
    24d4:	14d020ef          	jal	4e20 <sbrk>
    exit(0);
    24d8:	4501                	li	a0,0
    24da:	17b020ef          	jal	4e54 <exit>
    printf("fork failed\n");
    24de:	00005517          	auipc	a0,0x5
    24e2:	d2250513          	addi	a0,a0,-734 # 7200 <malloc+0x1ea6>
    24e6:	5bd020ef          	jal	52a2 <printf>
    exit(1);
    24ea:	4505                	li	a0,1
    24ec:	169020ef          	jal	4e54 <exit>
  wait(0);
    24f0:	4501                	li	a0,0
    24f2:	16b020ef          	jal	4e5c <wait>
  pid = fork();
    24f6:	157020ef          	jal	4e4c <fork>
  if(pid < 0){
    24fa:	00054f63          	bltz	a0,2518 <sbrkbugs+0x5e>
  if(pid == 0){
    24fe:	e515                	bnez	a0,252a <sbrkbugs+0x70>
    int sz = (uint64) sbrk(0);
    2500:	121020ef          	jal	4e20 <sbrk>
    sbrk(-(sz - 3500));
    2504:	6785                	lui	a5,0x1
    2506:	dac7879b          	addiw	a5,a5,-596 # dac <linktest+0xe2>
    250a:	40a7853b          	subw	a0,a5,a0
    250e:	113020ef          	jal	4e20 <sbrk>
    exit(0);
    2512:	4501                	li	a0,0
    2514:	141020ef          	jal	4e54 <exit>
    printf("fork failed\n");
    2518:	00005517          	auipc	a0,0x5
    251c:	ce850513          	addi	a0,a0,-792 # 7200 <malloc+0x1ea6>
    2520:	583020ef          	jal	52a2 <printf>
    exit(1);
    2524:	4505                	li	a0,1
    2526:	12f020ef          	jal	4e54 <exit>
  wait(0);
    252a:	4501                	li	a0,0
    252c:	131020ef          	jal	4e5c <wait>
  pid = fork();
    2530:	11d020ef          	jal	4e4c <fork>
  if(pid < 0){
    2534:	02054263          	bltz	a0,2558 <sbrkbugs+0x9e>
  if(pid == 0){
    2538:	e90d                	bnez	a0,256a <sbrkbugs+0xb0>
    sbrk((10*PGSIZE + 2048) - (uint64)sbrk(0));
    253a:	0e7020ef          	jal	4e20 <sbrk>
    253e:	67ad                	lui	a5,0xb
    2540:	8007879b          	addiw	a5,a5,-2048 # a800 <uninit+0x278>
    2544:	40a7853b          	subw	a0,a5,a0
    2548:	0d9020ef          	jal	4e20 <sbrk>
    sbrk(-10);
    254c:	5559                	li	a0,-10
    254e:	0d3020ef          	jal	4e20 <sbrk>
    exit(0);
    2552:	4501                	li	a0,0
    2554:	101020ef          	jal	4e54 <exit>
    printf("fork failed\n");
    2558:	00005517          	auipc	a0,0x5
    255c:	ca850513          	addi	a0,a0,-856 # 7200 <malloc+0x1ea6>
    2560:	543020ef          	jal	52a2 <printf>
    exit(1);
    2564:	4505                	li	a0,1
    2566:	0ef020ef          	jal	4e54 <exit>
  wait(0);
    256a:	4501                	li	a0,0
    256c:	0f1020ef          	jal	4e5c <wait>
  exit(0);
    2570:	4501                	li	a0,0
    2572:	0e3020ef          	jal	4e54 <exit>

0000000000002576 <sbrklast>:
{
    2576:	7179                	addi	sp,sp,-48
    2578:	f406                	sd	ra,40(sp)
    257a:	f022                	sd	s0,32(sp)
    257c:	ec26                	sd	s1,24(sp)
    257e:	e84a                	sd	s2,16(sp)
    2580:	e44e                	sd	s3,8(sp)
    2582:	e052                	sd	s4,0(sp)
    2584:	1800                	addi	s0,sp,48
  uint64 top = (uint64) sbrk(0);
    2586:	4501                	li	a0,0
    2588:	099020ef          	jal	4e20 <sbrk>
  if((top % PGSIZE) != 0)
    258c:	03451793          	slli	a5,a0,0x34
    2590:	ebad                	bnez	a5,2602 <sbrklast+0x8c>
  sbrk(PGSIZE);
    2592:	6505                	lui	a0,0x1
    2594:	08d020ef          	jal	4e20 <sbrk>
  sbrk(10);
    2598:	4529                	li	a0,10
    259a:	087020ef          	jal	4e20 <sbrk>
  sbrk(-20);
    259e:	5531                	li	a0,-20
    25a0:	081020ef          	jal	4e20 <sbrk>
  top = (uint64) sbrk(0);
    25a4:	4501                	li	a0,0
    25a6:	07b020ef          	jal	4e20 <sbrk>
    25aa:	84aa                	mv	s1,a0
  char *p = (char *) (top - 64);
    25ac:	fc050913          	addi	s2,a0,-64 # fc0 <bigdir+0xcc>
  p[0] = 'x';
    25b0:	07800993          	li	s3,120
    25b4:	fd350023          	sb	s3,-64(a0)
  p[1] = '\0';
    25b8:	fc0500a3          	sb	zero,-63(a0)
  int fd = open(p, O_RDWR|O_CREATE);
    25bc:	20200593          	li	a1,514
    25c0:	854a                	mv	a0,s2
    25c2:	0d3020ef          	jal	4e94 <open>
    25c6:	8a2a                	mv	s4,a0
  write(fd, p, 1);
    25c8:	4605                	li	a2,1
    25ca:	85ca                	mv	a1,s2
    25cc:	0a9020ef          	jal	4e74 <write>
  close(fd);
    25d0:	8552                	mv	a0,s4
    25d2:	0ab020ef          	jal	4e7c <close>
  fd = open(p, O_RDWR);
    25d6:	4589                	li	a1,2
    25d8:	854a                	mv	a0,s2
    25da:	0bb020ef          	jal	4e94 <open>
  p[0] = '\0';
    25de:	fc048023          	sb	zero,-64(s1)
  read(fd, p, 1);
    25e2:	4605                	li	a2,1
    25e4:	85ca                	mv	a1,s2
    25e6:	087020ef          	jal	4e6c <read>
  if(p[0] != 'x')
    25ea:	fc04c783          	lbu	a5,-64(s1)
    25ee:	03379263          	bne	a5,s3,2612 <sbrklast+0x9c>
}
    25f2:	70a2                	ld	ra,40(sp)
    25f4:	7402                	ld	s0,32(sp)
    25f6:	64e2                	ld	s1,24(sp)
    25f8:	6942                	ld	s2,16(sp)
    25fa:	69a2                	ld	s3,8(sp)
    25fc:	6a02                	ld	s4,0(sp)
    25fe:	6145                	addi	sp,sp,48
    2600:	8082                	ret
    sbrk(PGSIZE - (top % PGSIZE));
    2602:	0347d513          	srli	a0,a5,0x34
    2606:	6785                	lui	a5,0x1
    2608:	40a7853b          	subw	a0,a5,a0
    260c:	015020ef          	jal	4e20 <sbrk>
    2610:	b749                	j	2592 <sbrklast+0x1c>
    exit(1);
    2612:	4505                	li	a0,1
    2614:	041020ef          	jal	4e54 <exit>

0000000000002618 <sbrk8000>:
{
    2618:	1141                	addi	sp,sp,-16
    261a:	e406                	sd	ra,8(sp)
    261c:	e022                	sd	s0,0(sp)
    261e:	0800                	addi	s0,sp,16
  sbrk(0x80000004);
    2620:	80000537          	lui	a0,0x80000
    2624:	0511                	addi	a0,a0,4 # ffffffff80000004 <base+0xffffffff7fff036c>
    2626:	7fa020ef          	jal	4e20 <sbrk>
  volatile char *top = sbrk(0);
    262a:	4501                	li	a0,0
    262c:	7f4020ef          	jal	4e20 <sbrk>
  *(top-1) = *(top-1) + 1;
    2630:	fff54783          	lbu	a5,-1(a0)
    2634:	0785                	addi	a5,a5,1 # 1001 <bigdir+0x10d>
    2636:	0ff7f793          	zext.b	a5,a5
    263a:	fef50fa3          	sb	a5,-1(a0)
}
    263e:	60a2                	ld	ra,8(sp)
    2640:	6402                	ld	s0,0(sp)
    2642:	0141                	addi	sp,sp,16
    2644:	8082                	ret

0000000000002646 <execout>:
{
    2646:	7139                	addi	sp,sp,-64
    2648:	fc06                	sd	ra,56(sp)
    264a:	f822                	sd	s0,48(sp)
    264c:	0080                	addi	s0,sp,64
    int pid = fork();
    264e:	7fe020ef          	jal	4e4c <fork>
    if(pid < 0){
    2652:	00054b63          	bltz	a0,2668 <execout+0x22>
    } else if(pid == 0){
    2656:	c505                	beqz	a0,267e <execout+0x38>
    2658:	f426                	sd	s1,40(sp)
    265a:	f04a                	sd	s2,32(sp)
      wait((int*)0);
    265c:	4501                	li	a0,0
    265e:	7fe020ef          	jal	4e5c <wait>
  exit(0);
    2662:	4501                	li	a0,0
    2664:	7f0020ef          	jal	4e54 <exit>
    2668:	f426                	sd	s1,40(sp)
    266a:	f04a                	sd	s2,32(sp)
      printf("fork failed\n");
    266c:	00005517          	auipc	a0,0x5
    2670:	b9450513          	addi	a0,a0,-1132 # 7200 <malloc+0x1ea6>
    2674:	42f020ef          	jal	52a2 <printf>
      exit(1);
    2678:	4505                	li	a0,1
    267a:	7da020ef          	jal	4e54 <exit>
    267e:	f426                	sd	s1,40(sp)
    2680:	f04a                	sd	s2,32(sp)
    2682:	6499                	lui	s1,0x6
    2684:	1a848493          	addi	s1,s1,424 # 61a8 <malloc+0xe4e>
        char *a = sbrk(PGSIZE);
    2688:	6905                	lui	s2,0x1
    268a:	854a                	mv	a0,s2
    268c:	794020ef          	jal	4e20 <sbrk>
        if(a == SBRK_ERROR)
    2690:	57fd                	li	a5,-1
    2692:	00f50863          	beq	a0,a5,26a2 <execout+0x5c>
        *(a + PGSIZE - 1) = 1;
    2696:	954a                	add	a0,a0,s2
    2698:	4785                	li	a5,1
    269a:	fef50fa3          	sb	a5,-1(a0)
      while(n++ < max){
    269e:	34fd                	addiw	s1,s1,-1
    26a0:	f4ed                	bnez	s1,268a <execout+0x44>
      close(1);
    26a2:	4505                	li	a0,1
    26a4:	7d8020ef          	jal	4e7c <close>
      char *args[] = { "echo", "x", 0 };
    26a8:	00003797          	auipc	a5,0x3
    26ac:	de078793          	addi	a5,a5,-544 # 5488 <malloc+0x12e>
    26b0:	fcf43423          	sd	a5,-56(s0)
    26b4:	00003797          	auipc	a5,0x3
    26b8:	e4478793          	addi	a5,a5,-444 # 54f8 <malloc+0x19e>
    26bc:	fcf43823          	sd	a5,-48(s0)
    26c0:	fc043c23          	sd	zero,-40(s0)
      exec("echo", args);
    26c4:	fc840593          	addi	a1,s0,-56
    26c8:	00003517          	auipc	a0,0x3
    26cc:	dc050513          	addi	a0,a0,-576 # 5488 <malloc+0x12e>
    26d0:	7bc020ef          	jal	4e8c <exec>
      exit(0);
    26d4:	4501                	li	a0,0
    26d6:	77e020ef          	jal	4e54 <exit>

00000000000026da <fourteen>:
{
    26da:	1101                	addi	sp,sp,-32
    26dc:	ec06                	sd	ra,24(sp)
    26de:	e822                	sd	s0,16(sp)
    26e0:	e426                	sd	s1,8(sp)
    26e2:	1000                	addi	s0,sp,32
    26e4:	84aa                	mv	s1,a0
  if(mkdir("12345678901234") != 0){
    26e6:	00004517          	auipc	a0,0x4
    26ea:	e0250513          	addi	a0,a0,-510 # 64e8 <malloc+0x118e>
    26ee:	7ce020ef          	jal	4ebc <mkdir>
    26f2:	e555                	bnez	a0,279e <fourteen+0xc4>
  if(mkdir("12345678901234/123456789012345") != 0){
    26f4:	00004517          	auipc	a0,0x4
    26f8:	c4c50513          	addi	a0,a0,-948 # 6340 <malloc+0xfe6>
    26fc:	7c0020ef          	jal	4ebc <mkdir>
    2700:	e94d                	bnez	a0,27b2 <fourteen+0xd8>
  fd = open("123456789012345/123456789012345/123456789012345", O_CREATE);
    2702:	20000593          	li	a1,512
    2706:	00004517          	auipc	a0,0x4
    270a:	c9250513          	addi	a0,a0,-878 # 6398 <malloc+0x103e>
    270e:	786020ef          	jal	4e94 <open>
  if(fd < 0){
    2712:	0a054a63          	bltz	a0,27c6 <fourteen+0xec>
  close(fd);
    2716:	766020ef          	jal	4e7c <close>
  fd = open("12345678901234/12345678901234/12345678901234", 0);
    271a:	4581                	li	a1,0
    271c:	00004517          	auipc	a0,0x4
    2720:	cf450513          	addi	a0,a0,-780 # 6410 <malloc+0x10b6>
    2724:	770020ef          	jal	4e94 <open>
  if(fd < 0){
    2728:	0a054963          	bltz	a0,27da <fourteen+0x100>
  close(fd);
    272c:	750020ef          	jal	4e7c <close>
  if(mkdir("12345678901234/12345678901234") == 0){
    2730:	00004517          	auipc	a0,0x4
    2734:	d5050513          	addi	a0,a0,-688 # 6480 <malloc+0x1126>
    2738:	784020ef          	jal	4ebc <mkdir>
    273c:	c94d                	beqz	a0,27ee <fourteen+0x114>
  if(mkdir("123456789012345/12345678901234") == 0){
    273e:	00004517          	auipc	a0,0x4
    2742:	d9a50513          	addi	a0,a0,-614 # 64d8 <malloc+0x117e>
    2746:	776020ef          	jal	4ebc <mkdir>
    274a:	cd45                	beqz	a0,2802 <fourteen+0x128>
  unlink("123456789012345/12345678901234");
    274c:	00004517          	auipc	a0,0x4
    2750:	d8c50513          	addi	a0,a0,-628 # 64d8 <malloc+0x117e>
    2754:	750020ef          	jal	4ea4 <unlink>
  unlink("12345678901234/12345678901234");
    2758:	00004517          	auipc	a0,0x4
    275c:	d2850513          	addi	a0,a0,-728 # 6480 <malloc+0x1126>
    2760:	744020ef          	jal	4ea4 <unlink>
  unlink("12345678901234/12345678901234/12345678901234");
    2764:	00004517          	auipc	a0,0x4
    2768:	cac50513          	addi	a0,a0,-852 # 6410 <malloc+0x10b6>
    276c:	738020ef          	jal	4ea4 <unlink>
  unlink("123456789012345/123456789012345/123456789012345");
    2770:	00004517          	auipc	a0,0x4
    2774:	c2850513          	addi	a0,a0,-984 # 6398 <malloc+0x103e>
    2778:	72c020ef          	jal	4ea4 <unlink>
  unlink("12345678901234/123456789012345");
    277c:	00004517          	auipc	a0,0x4
    2780:	bc450513          	addi	a0,a0,-1084 # 6340 <malloc+0xfe6>
    2784:	720020ef          	jal	4ea4 <unlink>
  unlink("12345678901234");
    2788:	00004517          	auipc	a0,0x4
    278c:	d6050513          	addi	a0,a0,-672 # 64e8 <malloc+0x118e>
    2790:	714020ef          	jal	4ea4 <unlink>
}
    2794:	60e2                	ld	ra,24(sp)
    2796:	6442                	ld	s0,16(sp)
    2798:	64a2                	ld	s1,8(sp)
    279a:	6105                	addi	sp,sp,32
    279c:	8082                	ret
    printf("%s: mkdir 12345678901234 failed\n", s);
    279e:	85a6                	mv	a1,s1
    27a0:	00004517          	auipc	a0,0x4
    27a4:	b7850513          	addi	a0,a0,-1160 # 6318 <malloc+0xfbe>
    27a8:	2fb020ef          	jal	52a2 <printf>
    exit(1);
    27ac:	4505                	li	a0,1
    27ae:	6a6020ef          	jal	4e54 <exit>
    printf("%s: mkdir 12345678901234/123456789012345 failed\n", s);
    27b2:	85a6                	mv	a1,s1
    27b4:	00004517          	auipc	a0,0x4
    27b8:	bac50513          	addi	a0,a0,-1108 # 6360 <malloc+0x1006>
    27bc:	2e7020ef          	jal	52a2 <printf>
    exit(1);
    27c0:	4505                	li	a0,1
    27c2:	692020ef          	jal	4e54 <exit>
    printf("%s: create 123456789012345/123456789012345/123456789012345 failed\n", s);
    27c6:	85a6                	mv	a1,s1
    27c8:	00004517          	auipc	a0,0x4
    27cc:	c0050513          	addi	a0,a0,-1024 # 63c8 <malloc+0x106e>
    27d0:	2d3020ef          	jal	52a2 <printf>
    exit(1);
    27d4:	4505                	li	a0,1
    27d6:	67e020ef          	jal	4e54 <exit>
    printf("%s: open 12345678901234/12345678901234/12345678901234 failed\n", s);
    27da:	85a6                	mv	a1,s1
    27dc:	00004517          	auipc	a0,0x4
    27e0:	c6450513          	addi	a0,a0,-924 # 6440 <malloc+0x10e6>
    27e4:	2bf020ef          	jal	52a2 <printf>
    exit(1);
    27e8:	4505                	li	a0,1
    27ea:	66a020ef          	jal	4e54 <exit>
    printf("%s: mkdir 12345678901234/12345678901234 succeeded!\n", s);
    27ee:	85a6                	mv	a1,s1
    27f0:	00004517          	auipc	a0,0x4
    27f4:	cb050513          	addi	a0,a0,-848 # 64a0 <malloc+0x1146>
    27f8:	2ab020ef          	jal	52a2 <printf>
    exit(1);
    27fc:	4505                	li	a0,1
    27fe:	656020ef          	jal	4e54 <exit>
    printf("%s: mkdir 12345678901234/123456789012345 succeeded!\n", s);
    2802:	85a6                	mv	a1,s1
    2804:	00004517          	auipc	a0,0x4
    2808:	cf450513          	addi	a0,a0,-780 # 64f8 <malloc+0x119e>
    280c:	297020ef          	jal	52a2 <printf>
    exit(1);
    2810:	4505                	li	a0,1
    2812:	642020ef          	jal	4e54 <exit>

0000000000002816 <diskfull>:
{
    2816:	b6010113          	addi	sp,sp,-1184
    281a:	48113c23          	sd	ra,1176(sp)
    281e:	48813823          	sd	s0,1168(sp)
    2822:	48913423          	sd	s1,1160(sp)
    2826:	49213023          	sd	s2,1152(sp)
    282a:	47313c23          	sd	s3,1144(sp)
    282e:	47413823          	sd	s4,1136(sp)
    2832:	47513423          	sd	s5,1128(sp)
    2836:	47613023          	sd	s6,1120(sp)
    283a:	45713c23          	sd	s7,1112(sp)
    283e:	45813823          	sd	s8,1104(sp)
    2842:	45913423          	sd	s9,1096(sp)
    2846:	45a13023          	sd	s10,1088(sp)
    284a:	43b13c23          	sd	s11,1080(sp)
    284e:	4a010413          	addi	s0,sp,1184
    2852:	b6a43423          	sd	a0,-1176(s0)
  unlink("diskfulldir");
    2856:	00004517          	auipc	a0,0x4
    285a:	cda50513          	addi	a0,a0,-806 # 6530 <malloc+0x11d6>
    285e:	646020ef          	jal	4ea4 <unlink>
    2862:	03000a93          	li	s5,48
    name[0] = 'b';
    2866:	06200d13          	li	s10,98
    name[1] = 'i';
    286a:	06900c93          	li	s9,105
    name[2] = 'g';
    286e:	06700c13          	li	s8,103
    unlink(name);
    2872:	b7040b13          	addi	s6,s0,-1168
    int fd = open(name, O_CREATE|O_RDWR|O_TRUNC);
    2876:	60200b93          	li	s7,1538
    287a:	10c00d93          	li	s11,268
      if(write(fd, buf, BSIZE) != BSIZE){
    287e:	b9040a13          	addi	s4,s0,-1136
    2882:	aa8d                	j	29f4 <diskfull+0x1de>
      printf("%s: could not create file %s\n", s, name);
    2884:	b7040613          	addi	a2,s0,-1168
    2888:	b6843583          	ld	a1,-1176(s0)
    288c:	00004517          	auipc	a0,0x4
    2890:	cb450513          	addi	a0,a0,-844 # 6540 <malloc+0x11e6>
    2894:	20f020ef          	jal	52a2 <printf>
      break;
    2898:	a039                	j	28a6 <diskfull+0x90>
        close(fd);
    289a:	854e                	mv	a0,s3
    289c:	5e0020ef          	jal	4e7c <close>
    close(fd);
    28a0:	854e                	mv	a0,s3
    28a2:	5da020ef          	jal	4e7c <close>
  for(int i = 0; i < nzz; i++){
    28a6:	4481                	li	s1,0
    name[0] = 'z';
    28a8:	07a00993          	li	s3,122
    unlink(name);
    28ac:	b9040913          	addi	s2,s0,-1136
    int fd = open(name, O_CREATE|O_RDWR|O_TRUNC);
    28b0:	60200a13          	li	s4,1538
  for(int i = 0; i < nzz; i++){
    28b4:	08000a93          	li	s5,128
    name[0] = 'z';
    28b8:	b9340823          	sb	s3,-1136(s0)
    name[1] = 'z';
    28bc:	b93408a3          	sb	s3,-1135(s0)
    name[2] = '0' + (i / 32);
    28c0:	41f4d71b          	sraiw	a4,s1,0x1f
    28c4:	01b7571b          	srliw	a4,a4,0x1b
    28c8:	009707bb          	addw	a5,a4,s1
    28cc:	4057d69b          	sraiw	a3,a5,0x5
    28d0:	0306869b          	addiw	a3,a3,48
    28d4:	b8d40923          	sb	a3,-1134(s0)
    name[3] = '0' + (i % 32);
    28d8:	8bfd                	andi	a5,a5,31
    28da:	9f99                	subw	a5,a5,a4
    28dc:	0307879b          	addiw	a5,a5,48
    28e0:	b8f409a3          	sb	a5,-1133(s0)
    name[4] = '\0';
    28e4:	b8040a23          	sb	zero,-1132(s0)
    unlink(name);
    28e8:	854a                	mv	a0,s2
    28ea:	5ba020ef          	jal	4ea4 <unlink>
    int fd = open(name, O_CREATE|O_RDWR|O_TRUNC);
    28ee:	85d2                	mv	a1,s4
    28f0:	854a                	mv	a0,s2
    28f2:	5a2020ef          	jal	4e94 <open>
    if(fd < 0)
    28f6:	00054763          	bltz	a0,2904 <diskfull+0xee>
    close(fd);
    28fa:	582020ef          	jal	4e7c <close>
  for(int i = 0; i < nzz; i++){
    28fe:	2485                	addiw	s1,s1,1
    2900:	fb549ce3          	bne	s1,s5,28b8 <diskfull+0xa2>
  if(mkdir("diskfulldir") == 0)
    2904:	00004517          	auipc	a0,0x4
    2908:	c2c50513          	addi	a0,a0,-980 # 6530 <malloc+0x11d6>
    290c:	5b0020ef          	jal	4ebc <mkdir>
    2910:	12050363          	beqz	a0,2a36 <diskfull+0x220>
  unlink("diskfulldir");
    2914:	00004517          	auipc	a0,0x4
    2918:	c1c50513          	addi	a0,a0,-996 # 6530 <malloc+0x11d6>
    291c:	588020ef          	jal	4ea4 <unlink>
  for(int i = 0; i < nzz; i++){
    2920:	4481                	li	s1,0
    name[0] = 'z';
    2922:	07a00913          	li	s2,122
    unlink(name);
    2926:	b9040a13          	addi	s4,s0,-1136
  for(int i = 0; i < nzz; i++){
    292a:	08000993          	li	s3,128
    name[0] = 'z';
    292e:	b9240823          	sb	s2,-1136(s0)
    name[1] = 'z';
    2932:	b92408a3          	sb	s2,-1135(s0)
    name[2] = '0' + (i / 32);
    2936:	41f4d71b          	sraiw	a4,s1,0x1f
    293a:	01b7571b          	srliw	a4,a4,0x1b
    293e:	009707bb          	addw	a5,a4,s1
    2942:	4057d69b          	sraiw	a3,a5,0x5
    2946:	0306869b          	addiw	a3,a3,48
    294a:	b8d40923          	sb	a3,-1134(s0)
    name[3] = '0' + (i % 32);
    294e:	8bfd                	andi	a5,a5,31
    2950:	9f99                	subw	a5,a5,a4
    2952:	0307879b          	addiw	a5,a5,48
    2956:	b8f409a3          	sb	a5,-1133(s0)
    name[4] = '\0';
    295a:	b8040a23          	sb	zero,-1132(s0)
    unlink(name);
    295e:	8552                	mv	a0,s4
    2960:	544020ef          	jal	4ea4 <unlink>
  for(int i = 0; i < nzz; i++){
    2964:	2485                	addiw	s1,s1,1
    2966:	fd3494e3          	bne	s1,s3,292e <diskfull+0x118>
    296a:	03000493          	li	s1,48
    name[0] = 'b';
    296e:	06200b13          	li	s6,98
    name[1] = 'i';
    2972:	06900a93          	li	s5,105
    name[2] = 'g';
    2976:	06700a13          	li	s4,103
    unlink(name);
    297a:	b9040993          	addi	s3,s0,-1136
  for(int i = 0; '0' + i < 0177; i++){
    297e:	07f00913          	li	s2,127
    name[0] = 'b';
    2982:	b9640823          	sb	s6,-1136(s0)
    name[1] = 'i';
    2986:	b95408a3          	sb	s5,-1135(s0)
    name[2] = 'g';
    298a:	b9440923          	sb	s4,-1134(s0)
    name[3] = '0' + i;
    298e:	b89409a3          	sb	s1,-1133(s0)
    name[4] = '\0';
    2992:	b8040a23          	sb	zero,-1132(s0)
    unlink(name);
    2996:	854e                	mv	a0,s3
    2998:	50c020ef          	jal	4ea4 <unlink>
  for(int i = 0; '0' + i < 0177; i++){
    299c:	2485                	addiw	s1,s1,1
    299e:	0ff4f493          	zext.b	s1,s1
    29a2:	ff2490e3          	bne	s1,s2,2982 <diskfull+0x16c>
}
    29a6:	49813083          	ld	ra,1176(sp)
    29aa:	49013403          	ld	s0,1168(sp)
    29ae:	48813483          	ld	s1,1160(sp)
    29b2:	48013903          	ld	s2,1152(sp)
    29b6:	47813983          	ld	s3,1144(sp)
    29ba:	47013a03          	ld	s4,1136(sp)
    29be:	46813a83          	ld	s5,1128(sp)
    29c2:	46013b03          	ld	s6,1120(sp)
    29c6:	45813b83          	ld	s7,1112(sp)
    29ca:	45013c03          	ld	s8,1104(sp)
    29ce:	44813c83          	ld	s9,1096(sp)
    29d2:	44013d03          	ld	s10,1088(sp)
    29d6:	43813d83          	ld	s11,1080(sp)
    29da:	4a010113          	addi	sp,sp,1184
    29de:	8082                	ret
    close(fd);
    29e0:	854e                	mv	a0,s3
    29e2:	49a020ef          	jal	4e7c <close>
  for(fi = 0; done == 0 && '0' + fi < 0177; fi++){
    29e6:	2a85                	addiw	s5,s5,1 # 3001 <subdir+0x3c1>
    29e8:	0ffafa93          	zext.b	s5,s5
    29ec:	07f00793          	li	a5,127
    29f0:	eafa8be3          	beq	s5,a5,28a6 <diskfull+0x90>
    name[0] = 'b';
    29f4:	b7a40823          	sb	s10,-1168(s0)
    name[1] = 'i';
    29f8:	b79408a3          	sb	s9,-1167(s0)
    name[2] = 'g';
    29fc:	b7840923          	sb	s8,-1166(s0)
    name[3] = '0' + fi;
    2a00:	b75409a3          	sb	s5,-1165(s0)
    name[4] = '\0';
    2a04:	b6040a23          	sb	zero,-1164(s0)
    unlink(name);
    2a08:	855a                	mv	a0,s6
    2a0a:	49a020ef          	jal	4ea4 <unlink>
    int fd = open(name, O_CREATE|O_RDWR|O_TRUNC);
    2a0e:	85de                	mv	a1,s7
    2a10:	855a                	mv	a0,s6
    2a12:	482020ef          	jal	4e94 <open>
    2a16:	89aa                	mv	s3,a0
    if(fd < 0){
    2a18:	e60546e3          	bltz	a0,2884 <diskfull+0x6e>
    2a1c:	84ee                	mv	s1,s11
      if(write(fd, buf, BSIZE) != BSIZE){
    2a1e:	40000913          	li	s2,1024
    2a22:	864a                	mv	a2,s2
    2a24:	85d2                	mv	a1,s4
    2a26:	854e                	mv	a0,s3
    2a28:	44c020ef          	jal	4e74 <write>
    2a2c:	e72517e3          	bne	a0,s2,289a <diskfull+0x84>
    for(int i = 0; i < MAXFILE; i++){
    2a30:	34fd                	addiw	s1,s1,-1
    2a32:	f8e5                	bnez	s1,2a22 <diskfull+0x20c>
    2a34:	b775                	j	29e0 <diskfull+0x1ca>
    printf("%s: mkdir(diskfulldir) unexpectedly succeeded!\n", s);
    2a36:	b6843583          	ld	a1,-1176(s0)
    2a3a:	00004517          	auipc	a0,0x4
    2a3e:	b2650513          	addi	a0,a0,-1242 # 6560 <malloc+0x1206>
    2a42:	061020ef          	jal	52a2 <printf>
    2a46:	b5f9                	j	2914 <diskfull+0xfe>

0000000000002a48 <iputtest>:
{
    2a48:	1101                	addi	sp,sp,-32
    2a4a:	ec06                	sd	ra,24(sp)
    2a4c:	e822                	sd	s0,16(sp)
    2a4e:	e426                	sd	s1,8(sp)
    2a50:	1000                	addi	s0,sp,32
    2a52:	84aa                	mv	s1,a0
  if(mkdir("iputdir") < 0){
    2a54:	00004517          	auipc	a0,0x4
    2a58:	b3c50513          	addi	a0,a0,-1220 # 6590 <malloc+0x1236>
    2a5c:	460020ef          	jal	4ebc <mkdir>
    2a60:	02054f63          	bltz	a0,2a9e <iputtest+0x56>
  if(chdir("iputdir") < 0){
    2a64:	00004517          	auipc	a0,0x4
    2a68:	b2c50513          	addi	a0,a0,-1236 # 6590 <malloc+0x1236>
    2a6c:	458020ef          	jal	4ec4 <chdir>
    2a70:	04054163          	bltz	a0,2ab2 <iputtest+0x6a>
  if(unlink("../iputdir") < 0){
    2a74:	00004517          	auipc	a0,0x4
    2a78:	b5c50513          	addi	a0,a0,-1188 # 65d0 <malloc+0x1276>
    2a7c:	428020ef          	jal	4ea4 <unlink>
    2a80:	04054363          	bltz	a0,2ac6 <iputtest+0x7e>
  if(chdir("/") < 0){
    2a84:	00004517          	auipc	a0,0x4
    2a88:	b7c50513          	addi	a0,a0,-1156 # 6600 <malloc+0x12a6>
    2a8c:	438020ef          	jal	4ec4 <chdir>
    2a90:	04054563          	bltz	a0,2ada <iputtest+0x92>
}
    2a94:	60e2                	ld	ra,24(sp)
    2a96:	6442                	ld	s0,16(sp)
    2a98:	64a2                	ld	s1,8(sp)
    2a9a:	6105                	addi	sp,sp,32
    2a9c:	8082                	ret
    printf("%s: mkdir failed\n", s);
    2a9e:	85a6                	mv	a1,s1
    2aa0:	00004517          	auipc	a0,0x4
    2aa4:	af850513          	addi	a0,a0,-1288 # 6598 <malloc+0x123e>
    2aa8:	7fa020ef          	jal	52a2 <printf>
    exit(1);
    2aac:	4505                	li	a0,1
    2aae:	3a6020ef          	jal	4e54 <exit>
    printf("%s: chdir iputdir failed\n", s);
    2ab2:	85a6                	mv	a1,s1
    2ab4:	00004517          	auipc	a0,0x4
    2ab8:	afc50513          	addi	a0,a0,-1284 # 65b0 <malloc+0x1256>
    2abc:	7e6020ef          	jal	52a2 <printf>
    exit(1);
    2ac0:	4505                	li	a0,1
    2ac2:	392020ef          	jal	4e54 <exit>
    printf("%s: unlink ../iputdir failed\n", s);
    2ac6:	85a6                	mv	a1,s1
    2ac8:	00004517          	auipc	a0,0x4
    2acc:	b1850513          	addi	a0,a0,-1256 # 65e0 <malloc+0x1286>
    2ad0:	7d2020ef          	jal	52a2 <printf>
    exit(1);
    2ad4:	4505                	li	a0,1
    2ad6:	37e020ef          	jal	4e54 <exit>
    printf("%s: chdir / failed\n", s);
    2ada:	85a6                	mv	a1,s1
    2adc:	00004517          	auipc	a0,0x4
    2ae0:	b2c50513          	addi	a0,a0,-1236 # 6608 <malloc+0x12ae>
    2ae4:	7be020ef          	jal	52a2 <printf>
    exit(1);
    2ae8:	4505                	li	a0,1
    2aea:	36a020ef          	jal	4e54 <exit>

0000000000002aee <exitiputtest>:
{
    2aee:	7179                	addi	sp,sp,-48
    2af0:	f406                	sd	ra,40(sp)
    2af2:	f022                	sd	s0,32(sp)
    2af4:	ec26                	sd	s1,24(sp)
    2af6:	1800                	addi	s0,sp,48
    2af8:	84aa                	mv	s1,a0
  pid = fork();
    2afa:	352020ef          	jal	4e4c <fork>
  if(pid < 0){
    2afe:	02054e63          	bltz	a0,2b3a <exitiputtest+0x4c>
  if(pid == 0){
    2b02:	e541                	bnez	a0,2b8a <exitiputtest+0x9c>
    if(mkdir("iputdir") < 0){
    2b04:	00004517          	auipc	a0,0x4
    2b08:	a8c50513          	addi	a0,a0,-1396 # 6590 <malloc+0x1236>
    2b0c:	3b0020ef          	jal	4ebc <mkdir>
    2b10:	02054f63          	bltz	a0,2b4e <exitiputtest+0x60>
    if(chdir("iputdir") < 0){
    2b14:	00004517          	auipc	a0,0x4
    2b18:	a7c50513          	addi	a0,a0,-1412 # 6590 <malloc+0x1236>
    2b1c:	3a8020ef          	jal	4ec4 <chdir>
    2b20:	04054163          	bltz	a0,2b62 <exitiputtest+0x74>
    if(unlink("../iputdir") < 0){
    2b24:	00004517          	auipc	a0,0x4
    2b28:	aac50513          	addi	a0,a0,-1364 # 65d0 <malloc+0x1276>
    2b2c:	378020ef          	jal	4ea4 <unlink>
    2b30:	04054363          	bltz	a0,2b76 <exitiputtest+0x88>
    exit(0);
    2b34:	4501                	li	a0,0
    2b36:	31e020ef          	jal	4e54 <exit>
    printf("%s: fork failed\n", s);
    2b3a:	85a6                	mv	a1,s1
    2b3c:	00003517          	auipc	a0,0x3
    2b40:	1dc50513          	addi	a0,a0,476 # 5d18 <malloc+0x9be>
    2b44:	75e020ef          	jal	52a2 <printf>
    exit(1);
    2b48:	4505                	li	a0,1
    2b4a:	30a020ef          	jal	4e54 <exit>
      printf("%s: mkdir failed\n", s);
    2b4e:	85a6                	mv	a1,s1
    2b50:	00004517          	auipc	a0,0x4
    2b54:	a4850513          	addi	a0,a0,-1464 # 6598 <malloc+0x123e>
    2b58:	74a020ef          	jal	52a2 <printf>
      exit(1);
    2b5c:	4505                	li	a0,1
    2b5e:	2f6020ef          	jal	4e54 <exit>
      printf("%s: child chdir failed\n", s);
    2b62:	85a6                	mv	a1,s1
    2b64:	00004517          	auipc	a0,0x4
    2b68:	abc50513          	addi	a0,a0,-1348 # 6620 <malloc+0x12c6>
    2b6c:	736020ef          	jal	52a2 <printf>
      exit(1);
    2b70:	4505                	li	a0,1
    2b72:	2e2020ef          	jal	4e54 <exit>
      printf("%s: unlink ../iputdir failed\n", s);
    2b76:	85a6                	mv	a1,s1
    2b78:	00004517          	auipc	a0,0x4
    2b7c:	a6850513          	addi	a0,a0,-1432 # 65e0 <malloc+0x1286>
    2b80:	722020ef          	jal	52a2 <printf>
      exit(1);
    2b84:	4505                	li	a0,1
    2b86:	2ce020ef          	jal	4e54 <exit>
  wait(&xstatus);
    2b8a:	fdc40513          	addi	a0,s0,-36
    2b8e:	2ce020ef          	jal	4e5c <wait>
  exit(xstatus);
    2b92:	fdc42503          	lw	a0,-36(s0)
    2b96:	2be020ef          	jal	4e54 <exit>

0000000000002b9a <dirtest>:
{
    2b9a:	1101                	addi	sp,sp,-32
    2b9c:	ec06                	sd	ra,24(sp)
    2b9e:	e822                	sd	s0,16(sp)
    2ba0:	e426                	sd	s1,8(sp)
    2ba2:	1000                	addi	s0,sp,32
    2ba4:	84aa                	mv	s1,a0
  if(mkdir("dir0") < 0){
    2ba6:	00004517          	auipc	a0,0x4
    2baa:	a9250513          	addi	a0,a0,-1390 # 6638 <malloc+0x12de>
    2bae:	30e020ef          	jal	4ebc <mkdir>
    2bb2:	02054f63          	bltz	a0,2bf0 <dirtest+0x56>
  if(chdir("dir0") < 0){
    2bb6:	00004517          	auipc	a0,0x4
    2bba:	a8250513          	addi	a0,a0,-1406 # 6638 <malloc+0x12de>
    2bbe:	306020ef          	jal	4ec4 <chdir>
    2bc2:	04054163          	bltz	a0,2c04 <dirtest+0x6a>
  if(chdir("..") < 0){
    2bc6:	00004517          	auipc	a0,0x4
    2bca:	a9250513          	addi	a0,a0,-1390 # 6658 <malloc+0x12fe>
    2bce:	2f6020ef          	jal	4ec4 <chdir>
    2bd2:	04054363          	bltz	a0,2c18 <dirtest+0x7e>
  if(unlink("dir0") < 0){
    2bd6:	00004517          	auipc	a0,0x4
    2bda:	a6250513          	addi	a0,a0,-1438 # 6638 <malloc+0x12de>
    2bde:	2c6020ef          	jal	4ea4 <unlink>
    2be2:	04054563          	bltz	a0,2c2c <dirtest+0x92>
}
    2be6:	60e2                	ld	ra,24(sp)
    2be8:	6442                	ld	s0,16(sp)
    2bea:	64a2                	ld	s1,8(sp)
    2bec:	6105                	addi	sp,sp,32
    2bee:	8082                	ret
    printf("%s: mkdir failed\n", s);
    2bf0:	85a6                	mv	a1,s1
    2bf2:	00004517          	auipc	a0,0x4
    2bf6:	9a650513          	addi	a0,a0,-1626 # 6598 <malloc+0x123e>
    2bfa:	6a8020ef          	jal	52a2 <printf>
    exit(1);
    2bfe:	4505                	li	a0,1
    2c00:	254020ef          	jal	4e54 <exit>
    printf("%s: chdir dir0 failed\n", s);
    2c04:	85a6                	mv	a1,s1
    2c06:	00004517          	auipc	a0,0x4
    2c0a:	a3a50513          	addi	a0,a0,-1478 # 6640 <malloc+0x12e6>
    2c0e:	694020ef          	jal	52a2 <printf>
    exit(1);
    2c12:	4505                	li	a0,1
    2c14:	240020ef          	jal	4e54 <exit>
    printf("%s: chdir .. failed\n", s);
    2c18:	85a6                	mv	a1,s1
    2c1a:	00004517          	auipc	a0,0x4
    2c1e:	a4650513          	addi	a0,a0,-1466 # 6660 <malloc+0x1306>
    2c22:	680020ef          	jal	52a2 <printf>
    exit(1);
    2c26:	4505                	li	a0,1
    2c28:	22c020ef          	jal	4e54 <exit>
    printf("%s: unlink dir0 failed\n", s);
    2c2c:	85a6                	mv	a1,s1
    2c2e:	00004517          	auipc	a0,0x4
    2c32:	a4a50513          	addi	a0,a0,-1462 # 6678 <malloc+0x131e>
    2c36:	66c020ef          	jal	52a2 <printf>
    exit(1);
    2c3a:	4505                	li	a0,1
    2c3c:	218020ef          	jal	4e54 <exit>

0000000000002c40 <subdir>:
{
    2c40:	1101                	addi	sp,sp,-32
    2c42:	ec06                	sd	ra,24(sp)
    2c44:	e822                	sd	s0,16(sp)
    2c46:	e426                	sd	s1,8(sp)
    2c48:	e04a                	sd	s2,0(sp)
    2c4a:	1000                	addi	s0,sp,32
    2c4c:	892a                	mv	s2,a0
  unlink("ff");
    2c4e:	00004517          	auipc	a0,0x4
    2c52:	b7250513          	addi	a0,a0,-1166 # 67c0 <malloc+0x1466>
    2c56:	24e020ef          	jal	4ea4 <unlink>
  if(mkdir("dd") != 0){
    2c5a:	00004517          	auipc	a0,0x4
    2c5e:	a3650513          	addi	a0,a0,-1482 # 6690 <malloc+0x1336>
    2c62:	25a020ef          	jal	4ebc <mkdir>
    2c66:	2e051263          	bnez	a0,2f4a <subdir+0x30a>
  fd = open("dd/ff", O_CREATE | O_RDWR);
    2c6a:	20200593          	li	a1,514
    2c6e:	00004517          	auipc	a0,0x4
    2c72:	a4250513          	addi	a0,a0,-1470 # 66b0 <malloc+0x1356>
    2c76:	21e020ef          	jal	4e94 <open>
    2c7a:	84aa                	mv	s1,a0
  if(fd < 0){
    2c7c:	2e054163          	bltz	a0,2f5e <subdir+0x31e>
  write(fd, "ff", 2);
    2c80:	4609                	li	a2,2
    2c82:	00004597          	auipc	a1,0x4
    2c86:	b3e58593          	addi	a1,a1,-1218 # 67c0 <malloc+0x1466>
    2c8a:	1ea020ef          	jal	4e74 <write>
  close(fd);
    2c8e:	8526                	mv	a0,s1
    2c90:	1ec020ef          	jal	4e7c <close>
  if(unlink("dd") >= 0){
    2c94:	00004517          	auipc	a0,0x4
    2c98:	9fc50513          	addi	a0,a0,-1540 # 6690 <malloc+0x1336>
    2c9c:	208020ef          	jal	4ea4 <unlink>
    2ca0:	2c055963          	bgez	a0,2f72 <subdir+0x332>
  if(mkdir("/dd/dd") != 0){
    2ca4:	00004517          	auipc	a0,0x4
    2ca8:	a6450513          	addi	a0,a0,-1436 # 6708 <malloc+0x13ae>
    2cac:	210020ef          	jal	4ebc <mkdir>
    2cb0:	2c051b63          	bnez	a0,2f86 <subdir+0x346>
  fd = open("dd/dd/ff", O_CREATE | O_RDWR);
    2cb4:	20200593          	li	a1,514
    2cb8:	00004517          	auipc	a0,0x4
    2cbc:	a7850513          	addi	a0,a0,-1416 # 6730 <malloc+0x13d6>
    2cc0:	1d4020ef          	jal	4e94 <open>
    2cc4:	84aa                	mv	s1,a0
  if(fd < 0){
    2cc6:	2c054a63          	bltz	a0,2f9a <subdir+0x35a>
  write(fd, "FF", 2);
    2cca:	4609                	li	a2,2
    2ccc:	00004597          	auipc	a1,0x4
    2cd0:	a9458593          	addi	a1,a1,-1388 # 6760 <malloc+0x1406>
    2cd4:	1a0020ef          	jal	4e74 <write>
  close(fd);
    2cd8:	8526                	mv	a0,s1
    2cda:	1a2020ef          	jal	4e7c <close>
  fd = open("dd/dd/../ff", 0);
    2cde:	4581                	li	a1,0
    2ce0:	00004517          	auipc	a0,0x4
    2ce4:	a8850513          	addi	a0,a0,-1400 # 6768 <malloc+0x140e>
    2ce8:	1ac020ef          	jal	4e94 <open>
    2cec:	84aa                	mv	s1,a0
  if(fd < 0){
    2cee:	2c054063          	bltz	a0,2fae <subdir+0x36e>
  cc = read(fd, buf, sizeof(buf));
    2cf2:	660d                	lui	a2,0x3
    2cf4:	0000a597          	auipc	a1,0xa
    2cf8:	fa458593          	addi	a1,a1,-92 # cc98 <buf>
    2cfc:	170020ef          	jal	4e6c <read>
  if(cc != 2 || buf[0] != 'f'){
    2d00:	4789                	li	a5,2
    2d02:	2cf51063          	bne	a0,a5,2fc2 <subdir+0x382>
    2d06:	0000a717          	auipc	a4,0xa
    2d0a:	f9274703          	lbu	a4,-110(a4) # cc98 <buf>
    2d0e:	06600793          	li	a5,102
    2d12:	2af71863          	bne	a4,a5,2fc2 <subdir+0x382>
  close(fd);
    2d16:	8526                	mv	a0,s1
    2d18:	164020ef          	jal	4e7c <close>
  if(link("dd/dd/ff", "dd/dd/ffff") != 0){
    2d1c:	00004597          	auipc	a1,0x4
    2d20:	a9c58593          	addi	a1,a1,-1380 # 67b8 <malloc+0x145e>
    2d24:	00004517          	auipc	a0,0x4
    2d28:	a0c50513          	addi	a0,a0,-1524 # 6730 <malloc+0x13d6>
    2d2c:	188020ef          	jal	4eb4 <link>
    2d30:	2a051363          	bnez	a0,2fd6 <subdir+0x396>
  if(unlink("dd/dd/ff") != 0){
    2d34:	00004517          	auipc	a0,0x4
    2d38:	9fc50513          	addi	a0,a0,-1540 # 6730 <malloc+0x13d6>
    2d3c:	168020ef          	jal	4ea4 <unlink>
    2d40:	2a051563          	bnez	a0,2fea <subdir+0x3aa>
  if(open("dd/dd/ff", O_RDONLY) >= 0){
    2d44:	4581                	li	a1,0
    2d46:	00004517          	auipc	a0,0x4
    2d4a:	9ea50513          	addi	a0,a0,-1558 # 6730 <malloc+0x13d6>
    2d4e:	146020ef          	jal	4e94 <open>
    2d52:	2a055663          	bgez	a0,2ffe <subdir+0x3be>
  if(chdir("dd") != 0){
    2d56:	00004517          	auipc	a0,0x4
    2d5a:	93a50513          	addi	a0,a0,-1734 # 6690 <malloc+0x1336>
    2d5e:	166020ef          	jal	4ec4 <chdir>
    2d62:	2a051863          	bnez	a0,3012 <subdir+0x3d2>
  if(chdir("dd/../../dd") != 0){
    2d66:	00004517          	auipc	a0,0x4
    2d6a:	aea50513          	addi	a0,a0,-1302 # 6850 <malloc+0x14f6>
    2d6e:	156020ef          	jal	4ec4 <chdir>
    2d72:	2a051a63          	bnez	a0,3026 <subdir+0x3e6>
  if(chdir("dd/../../../dd") != 0){
    2d76:	00004517          	auipc	a0,0x4
    2d7a:	b0a50513          	addi	a0,a0,-1270 # 6880 <malloc+0x1526>
    2d7e:	146020ef          	jal	4ec4 <chdir>
    2d82:	2a051c63          	bnez	a0,303a <subdir+0x3fa>
  if(chdir("./..") != 0){
    2d86:	00004517          	auipc	a0,0x4
    2d8a:	b3250513          	addi	a0,a0,-1230 # 68b8 <malloc+0x155e>
    2d8e:	136020ef          	jal	4ec4 <chdir>
    2d92:	2a051e63          	bnez	a0,304e <subdir+0x40e>
  fd = open("dd/dd/ffff", 0);
    2d96:	4581                	li	a1,0
    2d98:	00004517          	auipc	a0,0x4
    2d9c:	a2050513          	addi	a0,a0,-1504 # 67b8 <malloc+0x145e>
    2da0:	0f4020ef          	jal	4e94 <open>
    2da4:	84aa                	mv	s1,a0
  if(fd < 0){
    2da6:	2a054e63          	bltz	a0,3062 <subdir+0x422>
  if(read(fd, buf, sizeof(buf)) != 2){
    2daa:	660d                	lui	a2,0x3
    2dac:	0000a597          	auipc	a1,0xa
    2db0:	eec58593          	addi	a1,a1,-276 # cc98 <buf>
    2db4:	0b8020ef          	jal	4e6c <read>
    2db8:	4789                	li	a5,2
    2dba:	2af51e63          	bne	a0,a5,3076 <subdir+0x436>
  close(fd);
    2dbe:	8526                	mv	a0,s1
    2dc0:	0bc020ef          	jal	4e7c <close>
  if(open("dd/dd/ff", O_RDONLY) >= 0){
    2dc4:	4581                	li	a1,0
    2dc6:	00004517          	auipc	a0,0x4
    2dca:	96a50513          	addi	a0,a0,-1686 # 6730 <malloc+0x13d6>
    2dce:	0c6020ef          	jal	4e94 <open>
    2dd2:	2a055c63          	bgez	a0,308a <subdir+0x44a>
  if(open("dd/ff/ff", O_CREATE|O_RDWR) >= 0){
    2dd6:	20200593          	li	a1,514
    2dda:	00004517          	auipc	a0,0x4
    2dde:	b6e50513          	addi	a0,a0,-1170 # 6948 <malloc+0x15ee>
    2de2:	0b2020ef          	jal	4e94 <open>
    2de6:	2a055c63          	bgez	a0,309e <subdir+0x45e>
  if(open("dd/xx/ff", O_CREATE|O_RDWR) >= 0){
    2dea:	20200593          	li	a1,514
    2dee:	00004517          	auipc	a0,0x4
    2df2:	b8a50513          	addi	a0,a0,-1142 # 6978 <malloc+0x161e>
    2df6:	09e020ef          	jal	4e94 <open>
    2dfa:	2a055c63          	bgez	a0,30b2 <subdir+0x472>
  if(open("dd", O_CREATE) >= 0){
    2dfe:	20000593          	li	a1,512
    2e02:	00004517          	auipc	a0,0x4
    2e06:	88e50513          	addi	a0,a0,-1906 # 6690 <malloc+0x1336>
    2e0a:	08a020ef          	jal	4e94 <open>
    2e0e:	2a055c63          	bgez	a0,30c6 <subdir+0x486>
  if(open("dd", O_RDWR) >= 0){
    2e12:	4589                	li	a1,2
    2e14:	00004517          	auipc	a0,0x4
    2e18:	87c50513          	addi	a0,a0,-1924 # 6690 <malloc+0x1336>
    2e1c:	078020ef          	jal	4e94 <open>
    2e20:	2a055d63          	bgez	a0,30da <subdir+0x49a>
  if(open("dd", O_WRONLY) >= 0){
    2e24:	4585                	li	a1,1
    2e26:	00004517          	auipc	a0,0x4
    2e2a:	86a50513          	addi	a0,a0,-1942 # 6690 <malloc+0x1336>
    2e2e:	066020ef          	jal	4e94 <open>
    2e32:	2a055e63          	bgez	a0,30ee <subdir+0x4ae>
  if(link("dd/ff/ff", "dd/dd/xx") == 0){
    2e36:	00004597          	auipc	a1,0x4
    2e3a:	bd258593          	addi	a1,a1,-1070 # 6a08 <malloc+0x16ae>
    2e3e:	00004517          	auipc	a0,0x4
    2e42:	b0a50513          	addi	a0,a0,-1270 # 6948 <malloc+0x15ee>
    2e46:	06e020ef          	jal	4eb4 <link>
    2e4a:	2a050c63          	beqz	a0,3102 <subdir+0x4c2>
  if(link("dd/xx/ff", "dd/dd/xx") == 0){
    2e4e:	00004597          	auipc	a1,0x4
    2e52:	bba58593          	addi	a1,a1,-1094 # 6a08 <malloc+0x16ae>
    2e56:	00004517          	auipc	a0,0x4
    2e5a:	b2250513          	addi	a0,a0,-1246 # 6978 <malloc+0x161e>
    2e5e:	056020ef          	jal	4eb4 <link>
    2e62:	2a050a63          	beqz	a0,3116 <subdir+0x4d6>
  if(link("dd/ff", "dd/dd/ffff") == 0){
    2e66:	00004597          	auipc	a1,0x4
    2e6a:	95258593          	addi	a1,a1,-1710 # 67b8 <malloc+0x145e>
    2e6e:	00004517          	auipc	a0,0x4
    2e72:	84250513          	addi	a0,a0,-1982 # 66b0 <malloc+0x1356>
    2e76:	03e020ef          	jal	4eb4 <link>
    2e7a:	2a050863          	beqz	a0,312a <subdir+0x4ea>
  if(mkdir("dd/ff/ff") == 0){
    2e7e:	00004517          	auipc	a0,0x4
    2e82:	aca50513          	addi	a0,a0,-1334 # 6948 <malloc+0x15ee>
    2e86:	036020ef          	jal	4ebc <mkdir>
    2e8a:	2a050a63          	beqz	a0,313e <subdir+0x4fe>
  if(mkdir("dd/xx/ff") == 0){
    2e8e:	00004517          	auipc	a0,0x4
    2e92:	aea50513          	addi	a0,a0,-1302 # 6978 <malloc+0x161e>
    2e96:	026020ef          	jal	4ebc <mkdir>
    2e9a:	2a050c63          	beqz	a0,3152 <subdir+0x512>
  if(mkdir("dd/dd/ffff") == 0){
    2e9e:	00004517          	auipc	a0,0x4
    2ea2:	91a50513          	addi	a0,a0,-1766 # 67b8 <malloc+0x145e>
    2ea6:	016020ef          	jal	4ebc <mkdir>
    2eaa:	2a050e63          	beqz	a0,3166 <subdir+0x526>
  if(unlink("dd/xx/ff") == 0){
    2eae:	00004517          	auipc	a0,0x4
    2eb2:	aca50513          	addi	a0,a0,-1334 # 6978 <malloc+0x161e>
    2eb6:	7ef010ef          	jal	4ea4 <unlink>
    2eba:	2c050063          	beqz	a0,317a <subdir+0x53a>
  if(unlink("dd/ff/ff") == 0){
    2ebe:	00004517          	auipc	a0,0x4
    2ec2:	a8a50513          	addi	a0,a0,-1398 # 6948 <malloc+0x15ee>
    2ec6:	7df010ef          	jal	4ea4 <unlink>
    2eca:	2c050263          	beqz	a0,318e <subdir+0x54e>
  if(chdir("dd/ff") == 0){
    2ece:	00003517          	auipc	a0,0x3
    2ed2:	7e250513          	addi	a0,a0,2018 # 66b0 <malloc+0x1356>
    2ed6:	7ef010ef          	jal	4ec4 <chdir>
    2eda:	2c050463          	beqz	a0,31a2 <subdir+0x562>
  if(chdir("dd/xx") == 0){
    2ede:	00004517          	auipc	a0,0x4
    2ee2:	c7a50513          	addi	a0,a0,-902 # 6b58 <malloc+0x17fe>
    2ee6:	7df010ef          	jal	4ec4 <chdir>
    2eea:	2c050663          	beqz	a0,31b6 <subdir+0x576>
  if(unlink("dd/dd/ffff") != 0){
    2eee:	00004517          	auipc	a0,0x4
    2ef2:	8ca50513          	addi	a0,a0,-1846 # 67b8 <malloc+0x145e>
    2ef6:	7af010ef          	jal	4ea4 <unlink>
    2efa:	2c051863          	bnez	a0,31ca <subdir+0x58a>
  if(unlink("dd/ff") != 0){
    2efe:	00003517          	auipc	a0,0x3
    2f02:	7b250513          	addi	a0,a0,1970 # 66b0 <malloc+0x1356>
    2f06:	79f010ef          	jal	4ea4 <unlink>
    2f0a:	2c051a63          	bnez	a0,31de <subdir+0x59e>
  if(unlink("dd") == 0){
    2f0e:	00003517          	auipc	a0,0x3
    2f12:	78250513          	addi	a0,a0,1922 # 6690 <malloc+0x1336>
    2f16:	78f010ef          	jal	4ea4 <unlink>
    2f1a:	2c050c63          	beqz	a0,31f2 <subdir+0x5b2>
  if(unlink("dd/dd") < 0){
    2f1e:	00004517          	auipc	a0,0x4
    2f22:	caa50513          	addi	a0,a0,-854 # 6bc8 <malloc+0x186e>
    2f26:	77f010ef          	jal	4ea4 <unlink>
    2f2a:	2c054e63          	bltz	a0,3206 <subdir+0x5c6>
  if(unlink("dd") < 0){
    2f2e:	00003517          	auipc	a0,0x3
    2f32:	76250513          	addi	a0,a0,1890 # 6690 <malloc+0x1336>
    2f36:	76f010ef          	jal	4ea4 <unlink>
    2f3a:	2e054063          	bltz	a0,321a <subdir+0x5da>
}
    2f3e:	60e2                	ld	ra,24(sp)
    2f40:	6442                	ld	s0,16(sp)
    2f42:	64a2                	ld	s1,8(sp)
    2f44:	6902                	ld	s2,0(sp)
    2f46:	6105                	addi	sp,sp,32
    2f48:	8082                	ret
    printf("%s: mkdir dd failed\n", s);
    2f4a:	85ca                	mv	a1,s2
    2f4c:	00003517          	auipc	a0,0x3
    2f50:	74c50513          	addi	a0,a0,1868 # 6698 <malloc+0x133e>
    2f54:	34e020ef          	jal	52a2 <printf>
    exit(1);
    2f58:	4505                	li	a0,1
    2f5a:	6fb010ef          	jal	4e54 <exit>
    printf("%s: create dd/ff failed\n", s);
    2f5e:	85ca                	mv	a1,s2
    2f60:	00003517          	auipc	a0,0x3
    2f64:	75850513          	addi	a0,a0,1880 # 66b8 <malloc+0x135e>
    2f68:	33a020ef          	jal	52a2 <printf>
    exit(1);
    2f6c:	4505                	li	a0,1
    2f6e:	6e7010ef          	jal	4e54 <exit>
    printf("%s: unlink dd (non-empty dir) succeeded!\n", s);
    2f72:	85ca                	mv	a1,s2
    2f74:	00003517          	auipc	a0,0x3
    2f78:	76450513          	addi	a0,a0,1892 # 66d8 <malloc+0x137e>
    2f7c:	326020ef          	jal	52a2 <printf>
    exit(1);
    2f80:	4505                	li	a0,1
    2f82:	6d3010ef          	jal	4e54 <exit>
    printf("%s: subdir mkdir dd/dd failed\n", s);
    2f86:	85ca                	mv	a1,s2
    2f88:	00003517          	auipc	a0,0x3
    2f8c:	78850513          	addi	a0,a0,1928 # 6710 <malloc+0x13b6>
    2f90:	312020ef          	jal	52a2 <printf>
    exit(1);
    2f94:	4505                	li	a0,1
    2f96:	6bf010ef          	jal	4e54 <exit>
    printf("%s: create dd/dd/ff failed\n", s);
    2f9a:	85ca                	mv	a1,s2
    2f9c:	00003517          	auipc	a0,0x3
    2fa0:	7a450513          	addi	a0,a0,1956 # 6740 <malloc+0x13e6>
    2fa4:	2fe020ef          	jal	52a2 <printf>
    exit(1);
    2fa8:	4505                	li	a0,1
    2faa:	6ab010ef          	jal	4e54 <exit>
    printf("%s: open dd/dd/../ff failed\n", s);
    2fae:	85ca                	mv	a1,s2
    2fb0:	00003517          	auipc	a0,0x3
    2fb4:	7c850513          	addi	a0,a0,1992 # 6778 <malloc+0x141e>
    2fb8:	2ea020ef          	jal	52a2 <printf>
    exit(1);
    2fbc:	4505                	li	a0,1
    2fbe:	697010ef          	jal	4e54 <exit>
    printf("%s: dd/dd/../ff wrong content\n", s);
    2fc2:	85ca                	mv	a1,s2
    2fc4:	00003517          	auipc	a0,0x3
    2fc8:	7d450513          	addi	a0,a0,2004 # 6798 <malloc+0x143e>
    2fcc:	2d6020ef          	jal	52a2 <printf>
    exit(1);
    2fd0:	4505                	li	a0,1
    2fd2:	683010ef          	jal	4e54 <exit>
    printf("%s: link dd/dd/ff dd/dd/ffff failed\n", s);
    2fd6:	85ca                	mv	a1,s2
    2fd8:	00003517          	auipc	a0,0x3
    2fdc:	7f050513          	addi	a0,a0,2032 # 67c8 <malloc+0x146e>
    2fe0:	2c2020ef          	jal	52a2 <printf>
    exit(1);
    2fe4:	4505                	li	a0,1
    2fe6:	66f010ef          	jal	4e54 <exit>
    printf("%s: unlink dd/dd/ff failed\n", s);
    2fea:	85ca                	mv	a1,s2
    2fec:	00004517          	auipc	a0,0x4
    2ff0:	80450513          	addi	a0,a0,-2044 # 67f0 <malloc+0x1496>
    2ff4:	2ae020ef          	jal	52a2 <printf>
    exit(1);
    2ff8:	4505                	li	a0,1
    2ffa:	65b010ef          	jal	4e54 <exit>
    printf("%s: open (unlinked) dd/dd/ff succeeded\n", s);
    2ffe:	85ca                	mv	a1,s2
    3000:	00004517          	auipc	a0,0x4
    3004:	81050513          	addi	a0,a0,-2032 # 6810 <malloc+0x14b6>
    3008:	29a020ef          	jal	52a2 <printf>
    exit(1);
    300c:	4505                	li	a0,1
    300e:	647010ef          	jal	4e54 <exit>
    printf("%s: chdir dd failed\n", s);
    3012:	85ca                	mv	a1,s2
    3014:	00004517          	auipc	a0,0x4
    3018:	82450513          	addi	a0,a0,-2012 # 6838 <malloc+0x14de>
    301c:	286020ef          	jal	52a2 <printf>
    exit(1);
    3020:	4505                	li	a0,1
    3022:	633010ef          	jal	4e54 <exit>
    printf("%s: chdir dd/../../dd failed\n", s);
    3026:	85ca                	mv	a1,s2
    3028:	00004517          	auipc	a0,0x4
    302c:	83850513          	addi	a0,a0,-1992 # 6860 <malloc+0x1506>
    3030:	272020ef          	jal	52a2 <printf>
    exit(1);
    3034:	4505                	li	a0,1
    3036:	61f010ef          	jal	4e54 <exit>
    printf("%s: chdir dd/../../../dd failed\n", s);
    303a:	85ca                	mv	a1,s2
    303c:	00004517          	auipc	a0,0x4
    3040:	85450513          	addi	a0,a0,-1964 # 6890 <malloc+0x1536>
    3044:	25e020ef          	jal	52a2 <printf>
    exit(1);
    3048:	4505                	li	a0,1
    304a:	60b010ef          	jal	4e54 <exit>
    printf("%s: chdir ./.. failed\n", s);
    304e:	85ca                	mv	a1,s2
    3050:	00004517          	auipc	a0,0x4
    3054:	87050513          	addi	a0,a0,-1936 # 68c0 <malloc+0x1566>
    3058:	24a020ef          	jal	52a2 <printf>
    exit(1);
    305c:	4505                	li	a0,1
    305e:	5f7010ef          	jal	4e54 <exit>
    printf("%s: open dd/dd/ffff failed\n", s);
    3062:	85ca                	mv	a1,s2
    3064:	00004517          	auipc	a0,0x4
    3068:	87450513          	addi	a0,a0,-1932 # 68d8 <malloc+0x157e>
    306c:	236020ef          	jal	52a2 <printf>
    exit(1);
    3070:	4505                	li	a0,1
    3072:	5e3010ef          	jal	4e54 <exit>
    printf("%s: read dd/dd/ffff wrong len\n", s);
    3076:	85ca                	mv	a1,s2
    3078:	00004517          	auipc	a0,0x4
    307c:	88050513          	addi	a0,a0,-1920 # 68f8 <malloc+0x159e>
    3080:	222020ef          	jal	52a2 <printf>
    exit(1);
    3084:	4505                	li	a0,1
    3086:	5cf010ef          	jal	4e54 <exit>
    printf("%s: open (unlinked) dd/dd/ff succeeded!\n", s);
    308a:	85ca                	mv	a1,s2
    308c:	00004517          	auipc	a0,0x4
    3090:	88c50513          	addi	a0,a0,-1908 # 6918 <malloc+0x15be>
    3094:	20e020ef          	jal	52a2 <printf>
    exit(1);
    3098:	4505                	li	a0,1
    309a:	5bb010ef          	jal	4e54 <exit>
    printf("%s: create dd/ff/ff succeeded!\n", s);
    309e:	85ca                	mv	a1,s2
    30a0:	00004517          	auipc	a0,0x4
    30a4:	8b850513          	addi	a0,a0,-1864 # 6958 <malloc+0x15fe>
    30a8:	1fa020ef          	jal	52a2 <printf>
    exit(1);
    30ac:	4505                	li	a0,1
    30ae:	5a7010ef          	jal	4e54 <exit>
    printf("%s: create dd/xx/ff succeeded!\n", s);
    30b2:	85ca                	mv	a1,s2
    30b4:	00004517          	auipc	a0,0x4
    30b8:	8d450513          	addi	a0,a0,-1836 # 6988 <malloc+0x162e>
    30bc:	1e6020ef          	jal	52a2 <printf>
    exit(1);
    30c0:	4505                	li	a0,1
    30c2:	593010ef          	jal	4e54 <exit>
    printf("%s: create dd succeeded!\n", s);
    30c6:	85ca                	mv	a1,s2
    30c8:	00004517          	auipc	a0,0x4
    30cc:	8e050513          	addi	a0,a0,-1824 # 69a8 <malloc+0x164e>
    30d0:	1d2020ef          	jal	52a2 <printf>
    exit(1);
    30d4:	4505                	li	a0,1
    30d6:	57f010ef          	jal	4e54 <exit>
    printf("%s: open dd rdwr succeeded!\n", s);
    30da:	85ca                	mv	a1,s2
    30dc:	00004517          	auipc	a0,0x4
    30e0:	8ec50513          	addi	a0,a0,-1812 # 69c8 <malloc+0x166e>
    30e4:	1be020ef          	jal	52a2 <printf>
    exit(1);
    30e8:	4505                	li	a0,1
    30ea:	56b010ef          	jal	4e54 <exit>
    printf("%s: open dd wronly succeeded!\n", s);
    30ee:	85ca                	mv	a1,s2
    30f0:	00004517          	auipc	a0,0x4
    30f4:	8f850513          	addi	a0,a0,-1800 # 69e8 <malloc+0x168e>
    30f8:	1aa020ef          	jal	52a2 <printf>
    exit(1);
    30fc:	4505                	li	a0,1
    30fe:	557010ef          	jal	4e54 <exit>
    printf("%s: link dd/ff/ff dd/dd/xx succeeded!\n", s);
    3102:	85ca                	mv	a1,s2
    3104:	00004517          	auipc	a0,0x4
    3108:	91450513          	addi	a0,a0,-1772 # 6a18 <malloc+0x16be>
    310c:	196020ef          	jal	52a2 <printf>
    exit(1);
    3110:	4505                	li	a0,1
    3112:	543010ef          	jal	4e54 <exit>
    printf("%s: link dd/xx/ff dd/dd/xx succeeded!\n", s);
    3116:	85ca                	mv	a1,s2
    3118:	00004517          	auipc	a0,0x4
    311c:	92850513          	addi	a0,a0,-1752 # 6a40 <malloc+0x16e6>
    3120:	182020ef          	jal	52a2 <printf>
    exit(1);
    3124:	4505                	li	a0,1
    3126:	52f010ef          	jal	4e54 <exit>
    printf("%s: link dd/ff dd/dd/ffff succeeded!\n", s);
    312a:	85ca                	mv	a1,s2
    312c:	00004517          	auipc	a0,0x4
    3130:	93c50513          	addi	a0,a0,-1732 # 6a68 <malloc+0x170e>
    3134:	16e020ef          	jal	52a2 <printf>
    exit(1);
    3138:	4505                	li	a0,1
    313a:	51b010ef          	jal	4e54 <exit>
    printf("%s: mkdir dd/ff/ff succeeded!\n", s);
    313e:	85ca                	mv	a1,s2
    3140:	00004517          	auipc	a0,0x4
    3144:	95050513          	addi	a0,a0,-1712 # 6a90 <malloc+0x1736>
    3148:	15a020ef          	jal	52a2 <printf>
    exit(1);
    314c:	4505                	li	a0,1
    314e:	507010ef          	jal	4e54 <exit>
    printf("%s: mkdir dd/xx/ff succeeded!\n", s);
    3152:	85ca                	mv	a1,s2
    3154:	00004517          	auipc	a0,0x4
    3158:	95c50513          	addi	a0,a0,-1700 # 6ab0 <malloc+0x1756>
    315c:	146020ef          	jal	52a2 <printf>
    exit(1);
    3160:	4505                	li	a0,1
    3162:	4f3010ef          	jal	4e54 <exit>
    printf("%s: mkdir dd/dd/ffff succeeded!\n", s);
    3166:	85ca                	mv	a1,s2
    3168:	00004517          	auipc	a0,0x4
    316c:	96850513          	addi	a0,a0,-1688 # 6ad0 <malloc+0x1776>
    3170:	132020ef          	jal	52a2 <printf>
    exit(1);
    3174:	4505                	li	a0,1
    3176:	4df010ef          	jal	4e54 <exit>
    printf("%s: unlink dd/xx/ff succeeded!\n", s);
    317a:	85ca                	mv	a1,s2
    317c:	00004517          	auipc	a0,0x4
    3180:	97c50513          	addi	a0,a0,-1668 # 6af8 <malloc+0x179e>
    3184:	11e020ef          	jal	52a2 <printf>
    exit(1);
    3188:	4505                	li	a0,1
    318a:	4cb010ef          	jal	4e54 <exit>
    printf("%s: unlink dd/ff/ff succeeded!\n", s);
    318e:	85ca                	mv	a1,s2
    3190:	00004517          	auipc	a0,0x4
    3194:	98850513          	addi	a0,a0,-1656 # 6b18 <malloc+0x17be>
    3198:	10a020ef          	jal	52a2 <printf>
    exit(1);
    319c:	4505                	li	a0,1
    319e:	4b7010ef          	jal	4e54 <exit>
    printf("%s: chdir dd/ff succeeded!\n", s);
    31a2:	85ca                	mv	a1,s2
    31a4:	00004517          	auipc	a0,0x4
    31a8:	99450513          	addi	a0,a0,-1644 # 6b38 <malloc+0x17de>
    31ac:	0f6020ef          	jal	52a2 <printf>
    exit(1);
    31b0:	4505                	li	a0,1
    31b2:	4a3010ef          	jal	4e54 <exit>
    printf("%s: chdir dd/xx succeeded!\n", s);
    31b6:	85ca                	mv	a1,s2
    31b8:	00004517          	auipc	a0,0x4
    31bc:	9a850513          	addi	a0,a0,-1624 # 6b60 <malloc+0x1806>
    31c0:	0e2020ef          	jal	52a2 <printf>
    exit(1);
    31c4:	4505                	li	a0,1
    31c6:	48f010ef          	jal	4e54 <exit>
    printf("%s: unlink dd/dd/ff failed\n", s);
    31ca:	85ca                	mv	a1,s2
    31cc:	00003517          	auipc	a0,0x3
    31d0:	62450513          	addi	a0,a0,1572 # 67f0 <malloc+0x1496>
    31d4:	0ce020ef          	jal	52a2 <printf>
    exit(1);
    31d8:	4505                	li	a0,1
    31da:	47b010ef          	jal	4e54 <exit>
    printf("%s: unlink dd/ff failed\n", s);
    31de:	85ca                	mv	a1,s2
    31e0:	00004517          	auipc	a0,0x4
    31e4:	9a050513          	addi	a0,a0,-1632 # 6b80 <malloc+0x1826>
    31e8:	0ba020ef          	jal	52a2 <printf>
    exit(1);
    31ec:	4505                	li	a0,1
    31ee:	467010ef          	jal	4e54 <exit>
    printf("%s: unlink non-empty dd succeeded!\n", s);
    31f2:	85ca                	mv	a1,s2
    31f4:	00004517          	auipc	a0,0x4
    31f8:	9ac50513          	addi	a0,a0,-1620 # 6ba0 <malloc+0x1846>
    31fc:	0a6020ef          	jal	52a2 <printf>
    exit(1);
    3200:	4505                	li	a0,1
    3202:	453010ef          	jal	4e54 <exit>
    printf("%s: unlink dd/dd failed\n", s);
    3206:	85ca                	mv	a1,s2
    3208:	00004517          	auipc	a0,0x4
    320c:	9c850513          	addi	a0,a0,-1592 # 6bd0 <malloc+0x1876>
    3210:	092020ef          	jal	52a2 <printf>
    exit(1);
    3214:	4505                	li	a0,1
    3216:	43f010ef          	jal	4e54 <exit>
    printf("%s: unlink dd failed\n", s);
    321a:	85ca                	mv	a1,s2
    321c:	00004517          	auipc	a0,0x4
    3220:	9d450513          	addi	a0,a0,-1580 # 6bf0 <malloc+0x1896>
    3224:	07e020ef          	jal	52a2 <printf>
    exit(1);
    3228:	4505                	li	a0,1
    322a:	42b010ef          	jal	4e54 <exit>

000000000000322e <rmdot>:
{
    322e:	1101                	addi	sp,sp,-32
    3230:	ec06                	sd	ra,24(sp)
    3232:	e822                	sd	s0,16(sp)
    3234:	e426                	sd	s1,8(sp)
    3236:	1000                	addi	s0,sp,32
    3238:	84aa                	mv	s1,a0
  if(mkdir("dots") != 0){
    323a:	00004517          	auipc	a0,0x4
    323e:	9ce50513          	addi	a0,a0,-1586 # 6c08 <malloc+0x18ae>
    3242:	47b010ef          	jal	4ebc <mkdir>
    3246:	e53d                	bnez	a0,32b4 <rmdot+0x86>
  if(chdir("dots") != 0){
    3248:	00004517          	auipc	a0,0x4
    324c:	9c050513          	addi	a0,a0,-1600 # 6c08 <malloc+0x18ae>
    3250:	475010ef          	jal	4ec4 <chdir>
    3254:	e935                	bnez	a0,32c8 <rmdot+0x9a>
  if(unlink(".") == 0){
    3256:	00003517          	auipc	a0,0x3
    325a:	91a50513          	addi	a0,a0,-1766 # 5b70 <malloc+0x816>
    325e:	447010ef          	jal	4ea4 <unlink>
    3262:	cd2d                	beqz	a0,32dc <rmdot+0xae>
  if(unlink("..") == 0){
    3264:	00003517          	auipc	a0,0x3
    3268:	3f450513          	addi	a0,a0,1012 # 6658 <malloc+0x12fe>
    326c:	439010ef          	jal	4ea4 <unlink>
    3270:	c141                	beqz	a0,32f0 <rmdot+0xc2>
  if(chdir("/") != 0){
    3272:	00003517          	auipc	a0,0x3
    3276:	38e50513          	addi	a0,a0,910 # 6600 <malloc+0x12a6>
    327a:	44b010ef          	jal	4ec4 <chdir>
    327e:	e159                	bnez	a0,3304 <rmdot+0xd6>
  if(unlink("dots/.") == 0){
    3280:	00004517          	auipc	a0,0x4
    3284:	9f050513          	addi	a0,a0,-1552 # 6c70 <malloc+0x1916>
    3288:	41d010ef          	jal	4ea4 <unlink>
    328c:	c551                	beqz	a0,3318 <rmdot+0xea>
  if(unlink("dots/..") == 0){
    328e:	00004517          	auipc	a0,0x4
    3292:	a0a50513          	addi	a0,a0,-1526 # 6c98 <malloc+0x193e>
    3296:	40f010ef          	jal	4ea4 <unlink>
    329a:	c949                	beqz	a0,332c <rmdot+0xfe>
  if(unlink("dots") != 0){
    329c:	00004517          	auipc	a0,0x4
    32a0:	96c50513          	addi	a0,a0,-1684 # 6c08 <malloc+0x18ae>
    32a4:	401010ef          	jal	4ea4 <unlink>
    32a8:	ed41                	bnez	a0,3340 <rmdot+0x112>
}
    32aa:	60e2                	ld	ra,24(sp)
    32ac:	6442                	ld	s0,16(sp)
    32ae:	64a2                	ld	s1,8(sp)
    32b0:	6105                	addi	sp,sp,32
    32b2:	8082                	ret
    printf("%s: mkdir dots failed\n", s);
    32b4:	85a6                	mv	a1,s1
    32b6:	00004517          	auipc	a0,0x4
    32ba:	95a50513          	addi	a0,a0,-1702 # 6c10 <malloc+0x18b6>
    32be:	7e5010ef          	jal	52a2 <printf>
    exit(1);
    32c2:	4505                	li	a0,1
    32c4:	391010ef          	jal	4e54 <exit>
    printf("%s: chdir dots failed\n", s);
    32c8:	85a6                	mv	a1,s1
    32ca:	00004517          	auipc	a0,0x4
    32ce:	95e50513          	addi	a0,a0,-1698 # 6c28 <malloc+0x18ce>
    32d2:	7d1010ef          	jal	52a2 <printf>
    exit(1);
    32d6:	4505                	li	a0,1
    32d8:	37d010ef          	jal	4e54 <exit>
    printf("%s: rm . worked!\n", s);
    32dc:	85a6                	mv	a1,s1
    32de:	00004517          	auipc	a0,0x4
    32e2:	96250513          	addi	a0,a0,-1694 # 6c40 <malloc+0x18e6>
    32e6:	7bd010ef          	jal	52a2 <printf>
    exit(1);
    32ea:	4505                	li	a0,1
    32ec:	369010ef          	jal	4e54 <exit>
    printf("%s: rm .. worked!\n", s);
    32f0:	85a6                	mv	a1,s1
    32f2:	00004517          	auipc	a0,0x4
    32f6:	96650513          	addi	a0,a0,-1690 # 6c58 <malloc+0x18fe>
    32fa:	7a9010ef          	jal	52a2 <printf>
    exit(1);
    32fe:	4505                	li	a0,1
    3300:	355010ef          	jal	4e54 <exit>
    printf("%s: chdir / failed\n", s);
    3304:	85a6                	mv	a1,s1
    3306:	00003517          	auipc	a0,0x3
    330a:	30250513          	addi	a0,a0,770 # 6608 <malloc+0x12ae>
    330e:	795010ef          	jal	52a2 <printf>
    exit(1);
    3312:	4505                	li	a0,1
    3314:	341010ef          	jal	4e54 <exit>
    printf("%s: unlink dots/. worked!\n", s);
    3318:	85a6                	mv	a1,s1
    331a:	00004517          	auipc	a0,0x4
    331e:	95e50513          	addi	a0,a0,-1698 # 6c78 <malloc+0x191e>
    3322:	781010ef          	jal	52a2 <printf>
    exit(1);
    3326:	4505                	li	a0,1
    3328:	32d010ef          	jal	4e54 <exit>
    printf("%s: unlink dots/.. worked!\n", s);
    332c:	85a6                	mv	a1,s1
    332e:	00004517          	auipc	a0,0x4
    3332:	97250513          	addi	a0,a0,-1678 # 6ca0 <malloc+0x1946>
    3336:	76d010ef          	jal	52a2 <printf>
    exit(1);
    333a:	4505                	li	a0,1
    333c:	319010ef          	jal	4e54 <exit>
    printf("%s: unlink dots failed!\n", s);
    3340:	85a6                	mv	a1,s1
    3342:	00004517          	auipc	a0,0x4
    3346:	97e50513          	addi	a0,a0,-1666 # 6cc0 <malloc+0x1966>
    334a:	759010ef          	jal	52a2 <printf>
    exit(1);
    334e:	4505                	li	a0,1
    3350:	305010ef          	jal	4e54 <exit>

0000000000003354 <dirfile>:
{
    3354:	1101                	addi	sp,sp,-32
    3356:	ec06                	sd	ra,24(sp)
    3358:	e822                	sd	s0,16(sp)
    335a:	e426                	sd	s1,8(sp)
    335c:	e04a                	sd	s2,0(sp)
    335e:	1000                	addi	s0,sp,32
    3360:	892a                	mv	s2,a0
  fd = open("dirfile", O_CREATE);
    3362:	20000593          	li	a1,512
    3366:	00004517          	auipc	a0,0x4
    336a:	97a50513          	addi	a0,a0,-1670 # 6ce0 <malloc+0x1986>
    336e:	327010ef          	jal	4e94 <open>
  if(fd < 0){
    3372:	0c054563          	bltz	a0,343c <dirfile+0xe8>
  close(fd);
    3376:	307010ef          	jal	4e7c <close>
  if(chdir("dirfile") == 0){
    337a:	00004517          	auipc	a0,0x4
    337e:	96650513          	addi	a0,a0,-1690 # 6ce0 <malloc+0x1986>
    3382:	343010ef          	jal	4ec4 <chdir>
    3386:	c569                	beqz	a0,3450 <dirfile+0xfc>
  fd = open("dirfile/xx", 0);
    3388:	4581                	li	a1,0
    338a:	00004517          	auipc	a0,0x4
    338e:	99e50513          	addi	a0,a0,-1634 # 6d28 <malloc+0x19ce>
    3392:	303010ef          	jal	4e94 <open>
  if(fd >= 0){
    3396:	0c055763          	bgez	a0,3464 <dirfile+0x110>
  fd = open("dirfile/xx", O_CREATE);
    339a:	20000593          	li	a1,512
    339e:	00004517          	auipc	a0,0x4
    33a2:	98a50513          	addi	a0,a0,-1654 # 6d28 <malloc+0x19ce>
    33a6:	2ef010ef          	jal	4e94 <open>
  if(fd >= 0){
    33aa:	0c055763          	bgez	a0,3478 <dirfile+0x124>
  if(mkdir("dirfile/xx") == 0){
    33ae:	00004517          	auipc	a0,0x4
    33b2:	97a50513          	addi	a0,a0,-1670 # 6d28 <malloc+0x19ce>
    33b6:	307010ef          	jal	4ebc <mkdir>
    33ba:	0c050963          	beqz	a0,348c <dirfile+0x138>
  if(unlink("dirfile/xx") == 0){
    33be:	00004517          	auipc	a0,0x4
    33c2:	96a50513          	addi	a0,a0,-1686 # 6d28 <malloc+0x19ce>
    33c6:	2df010ef          	jal	4ea4 <unlink>
    33ca:	0c050b63          	beqz	a0,34a0 <dirfile+0x14c>
  if(link("README", "dirfile/xx") == 0){
    33ce:	00004597          	auipc	a1,0x4
    33d2:	95a58593          	addi	a1,a1,-1702 # 6d28 <malloc+0x19ce>
    33d6:	00002517          	auipc	a0,0x2
    33da:	28a50513          	addi	a0,a0,650 # 5660 <malloc+0x306>
    33de:	2d7010ef          	jal	4eb4 <link>
    33e2:	0c050963          	beqz	a0,34b4 <dirfile+0x160>
  if(unlink("dirfile") != 0){
    33e6:	00004517          	auipc	a0,0x4
    33ea:	8fa50513          	addi	a0,a0,-1798 # 6ce0 <malloc+0x1986>
    33ee:	2b7010ef          	jal	4ea4 <unlink>
    33f2:	0c051b63          	bnez	a0,34c8 <dirfile+0x174>
  fd = open(".", O_RDWR);
    33f6:	4589                	li	a1,2
    33f8:	00002517          	auipc	a0,0x2
    33fc:	77850513          	addi	a0,a0,1912 # 5b70 <malloc+0x816>
    3400:	295010ef          	jal	4e94 <open>
  if(fd >= 0){
    3404:	0c055c63          	bgez	a0,34dc <dirfile+0x188>
  fd = open(".", 0);
    3408:	4581                	li	a1,0
    340a:	00002517          	auipc	a0,0x2
    340e:	76650513          	addi	a0,a0,1894 # 5b70 <malloc+0x816>
    3412:	283010ef          	jal	4e94 <open>
    3416:	84aa                	mv	s1,a0
  if(write(fd, "x", 1) > 0){
    3418:	4605                	li	a2,1
    341a:	00002597          	auipc	a1,0x2
    341e:	0de58593          	addi	a1,a1,222 # 54f8 <malloc+0x19e>
    3422:	253010ef          	jal	4e74 <write>
    3426:	0ca04563          	bgtz	a0,34f0 <dirfile+0x19c>
  close(fd);
    342a:	8526                	mv	a0,s1
    342c:	251010ef          	jal	4e7c <close>
}
    3430:	60e2                	ld	ra,24(sp)
    3432:	6442                	ld	s0,16(sp)
    3434:	64a2                	ld	s1,8(sp)
    3436:	6902                	ld	s2,0(sp)
    3438:	6105                	addi	sp,sp,32
    343a:	8082                	ret
    printf("%s: create dirfile failed\n", s);
    343c:	85ca                	mv	a1,s2
    343e:	00004517          	auipc	a0,0x4
    3442:	8aa50513          	addi	a0,a0,-1878 # 6ce8 <malloc+0x198e>
    3446:	65d010ef          	jal	52a2 <printf>
    exit(1);
    344a:	4505                	li	a0,1
    344c:	209010ef          	jal	4e54 <exit>
    printf("%s: chdir dirfile succeeded!\n", s);
    3450:	85ca                	mv	a1,s2
    3452:	00004517          	auipc	a0,0x4
    3456:	8b650513          	addi	a0,a0,-1866 # 6d08 <malloc+0x19ae>
    345a:	649010ef          	jal	52a2 <printf>
    exit(1);
    345e:	4505                	li	a0,1
    3460:	1f5010ef          	jal	4e54 <exit>
    printf("%s: create dirfile/xx succeeded!\n", s);
    3464:	85ca                	mv	a1,s2
    3466:	00004517          	auipc	a0,0x4
    346a:	8d250513          	addi	a0,a0,-1838 # 6d38 <malloc+0x19de>
    346e:	635010ef          	jal	52a2 <printf>
    exit(1);
    3472:	4505                	li	a0,1
    3474:	1e1010ef          	jal	4e54 <exit>
    printf("%s: create dirfile/xx succeeded!\n", s);
    3478:	85ca                	mv	a1,s2
    347a:	00004517          	auipc	a0,0x4
    347e:	8be50513          	addi	a0,a0,-1858 # 6d38 <malloc+0x19de>
    3482:	621010ef          	jal	52a2 <printf>
    exit(1);
    3486:	4505                	li	a0,1
    3488:	1cd010ef          	jal	4e54 <exit>
    printf("%s: mkdir dirfile/xx succeeded!\n", s);
    348c:	85ca                	mv	a1,s2
    348e:	00004517          	auipc	a0,0x4
    3492:	8d250513          	addi	a0,a0,-1838 # 6d60 <malloc+0x1a06>
    3496:	60d010ef          	jal	52a2 <printf>
    exit(1);
    349a:	4505                	li	a0,1
    349c:	1b9010ef          	jal	4e54 <exit>
    printf("%s: unlink dirfile/xx succeeded!\n", s);
    34a0:	85ca                	mv	a1,s2
    34a2:	00004517          	auipc	a0,0x4
    34a6:	8e650513          	addi	a0,a0,-1818 # 6d88 <malloc+0x1a2e>
    34aa:	5f9010ef          	jal	52a2 <printf>
    exit(1);
    34ae:	4505                	li	a0,1
    34b0:	1a5010ef          	jal	4e54 <exit>
    printf("%s: link to dirfile/xx succeeded!\n", s);
    34b4:	85ca                	mv	a1,s2
    34b6:	00004517          	auipc	a0,0x4
    34ba:	8fa50513          	addi	a0,a0,-1798 # 6db0 <malloc+0x1a56>
    34be:	5e5010ef          	jal	52a2 <printf>
    exit(1);
    34c2:	4505                	li	a0,1
    34c4:	191010ef          	jal	4e54 <exit>
    printf("%s: unlink dirfile failed!\n", s);
    34c8:	85ca                	mv	a1,s2
    34ca:	00004517          	auipc	a0,0x4
    34ce:	90e50513          	addi	a0,a0,-1778 # 6dd8 <malloc+0x1a7e>
    34d2:	5d1010ef          	jal	52a2 <printf>
    exit(1);
    34d6:	4505                	li	a0,1
    34d8:	17d010ef          	jal	4e54 <exit>
    printf("%s: open . for writing succeeded!\n", s);
    34dc:	85ca                	mv	a1,s2
    34de:	00004517          	auipc	a0,0x4
    34e2:	91a50513          	addi	a0,a0,-1766 # 6df8 <malloc+0x1a9e>
    34e6:	5bd010ef          	jal	52a2 <printf>
    exit(1);
    34ea:	4505                	li	a0,1
    34ec:	169010ef          	jal	4e54 <exit>
    printf("%s: write . succeeded!\n", s);
    34f0:	85ca                	mv	a1,s2
    34f2:	00004517          	auipc	a0,0x4
    34f6:	92e50513          	addi	a0,a0,-1746 # 6e20 <malloc+0x1ac6>
    34fa:	5a9010ef          	jal	52a2 <printf>
    exit(1);
    34fe:	4505                	li	a0,1
    3500:	155010ef          	jal	4e54 <exit>

0000000000003504 <iref>:
{
    3504:	715d                	addi	sp,sp,-80
    3506:	e486                	sd	ra,72(sp)
    3508:	e0a2                	sd	s0,64(sp)
    350a:	fc26                	sd	s1,56(sp)
    350c:	f84a                	sd	s2,48(sp)
    350e:	f44e                	sd	s3,40(sp)
    3510:	f052                	sd	s4,32(sp)
    3512:	ec56                	sd	s5,24(sp)
    3514:	e85a                	sd	s6,16(sp)
    3516:	e45e                	sd	s7,8(sp)
    3518:	0880                	addi	s0,sp,80
    351a:	8baa                	mv	s7,a0
    351c:	03300913          	li	s2,51
    if(mkdir("irefd") != 0){
    3520:	00004a97          	auipc	s5,0x4
    3524:	918a8a93          	addi	s5,s5,-1768 # 6e38 <malloc+0x1ade>
    mkdir("");
    3528:	00003497          	auipc	s1,0x3
    352c:	41848493          	addi	s1,s1,1048 # 6940 <malloc+0x15e6>
    link("README", "");
    3530:	00002b17          	auipc	s6,0x2
    3534:	130b0b13          	addi	s6,s6,304 # 5660 <malloc+0x306>
    fd = open("", O_CREATE);
    3538:	20000a13          	li	s4,512
    fd = open("xx", O_CREATE);
    353c:	00003997          	auipc	s3,0x3
    3540:	7f498993          	addi	s3,s3,2036 # 6d30 <malloc+0x19d6>
    3544:	a835                	j	3580 <iref+0x7c>
      printf("%s: mkdir irefd failed\n", s);
    3546:	85de                	mv	a1,s7
    3548:	00004517          	auipc	a0,0x4
    354c:	8f850513          	addi	a0,a0,-1800 # 6e40 <malloc+0x1ae6>
    3550:	553010ef          	jal	52a2 <printf>
      exit(1);
    3554:	4505                	li	a0,1
    3556:	0ff010ef          	jal	4e54 <exit>
      printf("%s: chdir irefd failed\n", s);
    355a:	85de                	mv	a1,s7
    355c:	00004517          	auipc	a0,0x4
    3560:	8fc50513          	addi	a0,a0,-1796 # 6e58 <malloc+0x1afe>
    3564:	53f010ef          	jal	52a2 <printf>
      exit(1);
    3568:	4505                	li	a0,1
    356a:	0eb010ef          	jal	4e54 <exit>
      close(fd);
    356e:	10f010ef          	jal	4e7c <close>
    3572:	a825                	j	35aa <iref+0xa6>
    unlink("xx");
    3574:	854e                	mv	a0,s3
    3576:	12f010ef          	jal	4ea4 <unlink>
  for(i = 0; i < NINODE + 1; i++){
    357a:	397d                	addiw	s2,s2,-1 # fff <bigdir+0x10b>
    357c:	04090063          	beqz	s2,35bc <iref+0xb8>
    if(mkdir("irefd") != 0){
    3580:	8556                	mv	a0,s5
    3582:	13b010ef          	jal	4ebc <mkdir>
    3586:	f161                	bnez	a0,3546 <iref+0x42>
    if(chdir("irefd") != 0){
    3588:	8556                	mv	a0,s5
    358a:	13b010ef          	jal	4ec4 <chdir>
    358e:	f571                	bnez	a0,355a <iref+0x56>
    mkdir("");
    3590:	8526                	mv	a0,s1
    3592:	12b010ef          	jal	4ebc <mkdir>
    link("README", "");
    3596:	85a6                	mv	a1,s1
    3598:	855a                	mv	a0,s6
    359a:	11b010ef          	jal	4eb4 <link>
    fd = open("", O_CREATE);
    359e:	85d2                	mv	a1,s4
    35a0:	8526                	mv	a0,s1
    35a2:	0f3010ef          	jal	4e94 <open>
    if(fd >= 0)
    35a6:	fc0554e3          	bgez	a0,356e <iref+0x6a>
    fd = open("xx", O_CREATE);
    35aa:	85d2                	mv	a1,s4
    35ac:	854e                	mv	a0,s3
    35ae:	0e7010ef          	jal	4e94 <open>
    if(fd >= 0)
    35b2:	fc0541e3          	bltz	a0,3574 <iref+0x70>
      close(fd);
    35b6:	0c7010ef          	jal	4e7c <close>
    35ba:	bf6d                	j	3574 <iref+0x70>
    35bc:	03300493          	li	s1,51
    chdir("..");
    35c0:	00003997          	auipc	s3,0x3
    35c4:	09898993          	addi	s3,s3,152 # 6658 <malloc+0x12fe>
    unlink("irefd");
    35c8:	00004917          	auipc	s2,0x4
    35cc:	87090913          	addi	s2,s2,-1936 # 6e38 <malloc+0x1ade>
    chdir("..");
    35d0:	854e                	mv	a0,s3
    35d2:	0f3010ef          	jal	4ec4 <chdir>
    unlink("irefd");
    35d6:	854a                	mv	a0,s2
    35d8:	0cd010ef          	jal	4ea4 <unlink>
  for(i = 0; i < NINODE + 1; i++){
    35dc:	34fd                	addiw	s1,s1,-1
    35de:	f8ed                	bnez	s1,35d0 <iref+0xcc>
  chdir("/");
    35e0:	00003517          	auipc	a0,0x3
    35e4:	02050513          	addi	a0,a0,32 # 6600 <malloc+0x12a6>
    35e8:	0dd010ef          	jal	4ec4 <chdir>
}
    35ec:	60a6                	ld	ra,72(sp)
    35ee:	6406                	ld	s0,64(sp)
    35f0:	74e2                	ld	s1,56(sp)
    35f2:	7942                	ld	s2,48(sp)
    35f4:	79a2                	ld	s3,40(sp)
    35f6:	7a02                	ld	s4,32(sp)
    35f8:	6ae2                	ld	s5,24(sp)
    35fa:	6b42                	ld	s6,16(sp)
    35fc:	6ba2                	ld	s7,8(sp)
    35fe:	6161                	addi	sp,sp,80
    3600:	8082                	ret

0000000000003602 <openiputtest>:
{
    3602:	7179                	addi	sp,sp,-48
    3604:	f406                	sd	ra,40(sp)
    3606:	f022                	sd	s0,32(sp)
    3608:	ec26                	sd	s1,24(sp)
    360a:	1800                	addi	s0,sp,48
    360c:	84aa                	mv	s1,a0
  if(mkdir("oidir") < 0){
    360e:	00004517          	auipc	a0,0x4
    3612:	86250513          	addi	a0,a0,-1950 # 6e70 <malloc+0x1b16>
    3616:	0a7010ef          	jal	4ebc <mkdir>
    361a:	02054a63          	bltz	a0,364e <openiputtest+0x4c>
  pid = fork();
    361e:	02f010ef          	jal	4e4c <fork>
  if(pid < 0){
    3622:	04054063          	bltz	a0,3662 <openiputtest+0x60>
  if(pid == 0){
    3626:	e939                	bnez	a0,367c <openiputtest+0x7a>
    int fd = open("oidir", O_RDWR);
    3628:	4589                	li	a1,2
    362a:	00004517          	auipc	a0,0x4
    362e:	84650513          	addi	a0,a0,-1978 # 6e70 <malloc+0x1b16>
    3632:	063010ef          	jal	4e94 <open>
    if(fd >= 0){
    3636:	04054063          	bltz	a0,3676 <openiputtest+0x74>
      printf("%s: open directory for write succeeded\n", s);
    363a:	85a6                	mv	a1,s1
    363c:	00004517          	auipc	a0,0x4
    3640:	85450513          	addi	a0,a0,-1964 # 6e90 <malloc+0x1b36>
    3644:	45f010ef          	jal	52a2 <printf>
      exit(1);
    3648:	4505                	li	a0,1
    364a:	00b010ef          	jal	4e54 <exit>
    printf("%s: mkdir oidir failed\n", s);
    364e:	85a6                	mv	a1,s1
    3650:	00004517          	auipc	a0,0x4
    3654:	82850513          	addi	a0,a0,-2008 # 6e78 <malloc+0x1b1e>
    3658:	44b010ef          	jal	52a2 <printf>
    exit(1);
    365c:	4505                	li	a0,1
    365e:	7f6010ef          	jal	4e54 <exit>
    printf("%s: fork failed\n", s);
    3662:	85a6                	mv	a1,s1
    3664:	00002517          	auipc	a0,0x2
    3668:	6b450513          	addi	a0,a0,1716 # 5d18 <malloc+0x9be>
    366c:	437010ef          	jal	52a2 <printf>
    exit(1);
    3670:	4505                	li	a0,1
    3672:	7e2010ef          	jal	4e54 <exit>
    exit(0);
    3676:	4501                	li	a0,0
    3678:	7dc010ef          	jal	4e54 <exit>
  pause(1);
    367c:	4505                	li	a0,1
    367e:	067010ef          	jal	4ee4 <pause>
  if(unlink("oidir") != 0){
    3682:	00003517          	auipc	a0,0x3
    3686:	7ee50513          	addi	a0,a0,2030 # 6e70 <malloc+0x1b16>
    368a:	01b010ef          	jal	4ea4 <unlink>
    368e:	c919                	beqz	a0,36a4 <openiputtest+0xa2>
    printf("%s: unlink failed\n", s);
    3690:	85a6                	mv	a1,s1
    3692:	00003517          	auipc	a0,0x3
    3696:	87650513          	addi	a0,a0,-1930 # 5f08 <malloc+0xbae>
    369a:	409010ef          	jal	52a2 <printf>
    exit(1);
    369e:	4505                	li	a0,1
    36a0:	7b4010ef          	jal	4e54 <exit>
  wait(&xstatus);
    36a4:	fdc40513          	addi	a0,s0,-36
    36a8:	7b4010ef          	jal	4e5c <wait>
  exit(xstatus);
    36ac:	fdc42503          	lw	a0,-36(s0)
    36b0:	7a4010ef          	jal	4e54 <exit>

00000000000036b4 <forkforkfork>:
{
    36b4:	1101                	addi	sp,sp,-32
    36b6:	ec06                	sd	ra,24(sp)
    36b8:	e822                	sd	s0,16(sp)
    36ba:	e426                	sd	s1,8(sp)
    36bc:	1000                	addi	s0,sp,32
    36be:	84aa                	mv	s1,a0
  unlink("stopforking");
    36c0:	00003517          	auipc	a0,0x3
    36c4:	7f850513          	addi	a0,a0,2040 # 6eb8 <malloc+0x1b5e>
    36c8:	7dc010ef          	jal	4ea4 <unlink>
  int pid = fork();
    36cc:	780010ef          	jal	4e4c <fork>
  if(pid < 0){
    36d0:	02054b63          	bltz	a0,3706 <forkforkfork+0x52>
  if(pid == 0){
    36d4:	c139                	beqz	a0,371a <forkforkfork+0x66>
  pause(20); // two seconds
    36d6:	4551                	li	a0,20
    36d8:	00d010ef          	jal	4ee4 <pause>
  close(open("stopforking", O_CREATE|O_RDWR));
    36dc:	20200593          	li	a1,514
    36e0:	00003517          	auipc	a0,0x3
    36e4:	7d850513          	addi	a0,a0,2008 # 6eb8 <malloc+0x1b5e>
    36e8:	7ac010ef          	jal	4e94 <open>
    36ec:	790010ef          	jal	4e7c <close>
  wait(0);
    36f0:	4501                	li	a0,0
    36f2:	76a010ef          	jal	4e5c <wait>
  pause(10); // one second
    36f6:	4529                	li	a0,10
    36f8:	7ec010ef          	jal	4ee4 <pause>
}
    36fc:	60e2                	ld	ra,24(sp)
    36fe:	6442                	ld	s0,16(sp)
    3700:	64a2                	ld	s1,8(sp)
    3702:	6105                	addi	sp,sp,32
    3704:	8082                	ret
    printf("%s: fork failed", s);
    3706:	85a6                	mv	a1,s1
    3708:	00002517          	auipc	a0,0x2
    370c:	7d050513          	addi	a0,a0,2000 # 5ed8 <malloc+0xb7e>
    3710:	393010ef          	jal	52a2 <printf>
    exit(1);
    3714:	4505                	li	a0,1
    3716:	73e010ef          	jal	4e54 <exit>
      int fd = open("stopforking", 0);
    371a:	4581                	li	a1,0
    371c:	00003517          	auipc	a0,0x3
    3720:	79c50513          	addi	a0,a0,1948 # 6eb8 <malloc+0x1b5e>
    3724:	770010ef          	jal	4e94 <open>
      if(fd >= 0){
    3728:	02055163          	bgez	a0,374a <forkforkfork+0x96>
      if(fork() < 0){
    372c:	720010ef          	jal	4e4c <fork>
    3730:	fe0555e3          	bgez	a0,371a <forkforkfork+0x66>
        close(open("stopforking", O_CREATE|O_RDWR));
    3734:	20200593          	li	a1,514
    3738:	00003517          	auipc	a0,0x3
    373c:	78050513          	addi	a0,a0,1920 # 6eb8 <malloc+0x1b5e>
    3740:	754010ef          	jal	4e94 <open>
    3744:	738010ef          	jal	4e7c <close>
    3748:	bfc9                	j	371a <forkforkfork+0x66>
        exit(0);
    374a:	4501                	li	a0,0
    374c:	708010ef          	jal	4e54 <exit>

0000000000003750 <killstatus>:
{
    3750:	715d                	addi	sp,sp,-80
    3752:	e486                	sd	ra,72(sp)
    3754:	e0a2                	sd	s0,64(sp)
    3756:	fc26                	sd	s1,56(sp)
    3758:	f84a                	sd	s2,48(sp)
    375a:	f44e                	sd	s3,40(sp)
    375c:	f052                	sd	s4,32(sp)
    375e:	ec56                	sd	s5,24(sp)
    3760:	e85a                	sd	s6,16(sp)
    3762:	0880                	addi	s0,sp,80
    3764:	8b2a                	mv	s6,a0
    3766:	06400913          	li	s2,100
    pause(1);
    376a:	4a85                	li	s5,1
    wait(&xst);
    376c:	fbc40a13          	addi	s4,s0,-68
    if(xst != -1) {
    3770:	59fd                	li	s3,-1
    int pid1 = fork();
    3772:	6da010ef          	jal	4e4c <fork>
    3776:	84aa                	mv	s1,a0
    if(pid1 < 0){
    3778:	02054663          	bltz	a0,37a4 <killstatus+0x54>
    if(pid1 == 0){
    377c:	cd15                	beqz	a0,37b8 <killstatus+0x68>
    pause(1);
    377e:	8556                	mv	a0,s5
    3780:	764010ef          	jal	4ee4 <pause>
    kill(pid1);
    3784:	8526                	mv	a0,s1
    3786:	6fe010ef          	jal	4e84 <kill>
    wait(&xst);
    378a:	8552                	mv	a0,s4
    378c:	6d0010ef          	jal	4e5c <wait>
    if(xst != -1) {
    3790:	fbc42783          	lw	a5,-68(s0)
    3794:	03379563          	bne	a5,s3,37be <killstatus+0x6e>
  for(int i = 0; i < 100; i++){
    3798:	397d                	addiw	s2,s2,-1
    379a:	fc091ce3          	bnez	s2,3772 <killstatus+0x22>
  exit(0);
    379e:	4501                	li	a0,0
    37a0:	6b4010ef          	jal	4e54 <exit>
      printf("%s: fork failed\n", s);
    37a4:	85da                	mv	a1,s6
    37a6:	00002517          	auipc	a0,0x2
    37aa:	57250513          	addi	a0,a0,1394 # 5d18 <malloc+0x9be>
    37ae:	2f5010ef          	jal	52a2 <printf>
      exit(1);
    37b2:	4505                	li	a0,1
    37b4:	6a0010ef          	jal	4e54 <exit>
        getpid();
    37b8:	71c010ef          	jal	4ed4 <getpid>
      while(1) {
    37bc:	bff5                	j	37b8 <killstatus+0x68>
       printf("%s: status should be -1\n", s);
    37be:	85da                	mv	a1,s6
    37c0:	00003517          	auipc	a0,0x3
    37c4:	70850513          	addi	a0,a0,1800 # 6ec8 <malloc+0x1b6e>
    37c8:	2db010ef          	jal	52a2 <printf>
       exit(1);
    37cc:	4505                	li	a0,1
    37ce:	686010ef          	jal	4e54 <exit>

00000000000037d2 <preempt>:
{
    37d2:	7139                	addi	sp,sp,-64
    37d4:	fc06                	sd	ra,56(sp)
    37d6:	f822                	sd	s0,48(sp)
    37d8:	f426                	sd	s1,40(sp)
    37da:	f04a                	sd	s2,32(sp)
    37dc:	ec4e                	sd	s3,24(sp)
    37de:	e852                	sd	s4,16(sp)
    37e0:	0080                	addi	s0,sp,64
    37e2:	892a                	mv	s2,a0
  pid1 = fork();
    37e4:	668010ef          	jal	4e4c <fork>
  if(pid1 < 0) {
    37e8:	00054563          	bltz	a0,37f2 <preempt+0x20>
    37ec:	84aa                	mv	s1,a0
  if(pid1 == 0)
    37ee:	ed01                	bnez	a0,3806 <preempt+0x34>
    for(;;)
    37f0:	a001                	j	37f0 <preempt+0x1e>
    printf("%s: fork failed", s);
    37f2:	85ca                	mv	a1,s2
    37f4:	00002517          	auipc	a0,0x2
    37f8:	6e450513          	addi	a0,a0,1764 # 5ed8 <malloc+0xb7e>
    37fc:	2a7010ef          	jal	52a2 <printf>
    exit(1);
    3800:	4505                	li	a0,1
    3802:	652010ef          	jal	4e54 <exit>
  pid2 = fork();
    3806:	646010ef          	jal	4e4c <fork>
    380a:	89aa                	mv	s3,a0
  if(pid2 < 0) {
    380c:	00054463          	bltz	a0,3814 <preempt+0x42>
  if(pid2 == 0)
    3810:	ed01                	bnez	a0,3828 <preempt+0x56>
    for(;;)
    3812:	a001                	j	3812 <preempt+0x40>
    printf("%s: fork failed\n", s);
    3814:	85ca                	mv	a1,s2
    3816:	00002517          	auipc	a0,0x2
    381a:	50250513          	addi	a0,a0,1282 # 5d18 <malloc+0x9be>
    381e:	285010ef          	jal	52a2 <printf>
    exit(1);
    3822:	4505                	li	a0,1
    3824:	630010ef          	jal	4e54 <exit>
  pipe(pfds);
    3828:	fc840513          	addi	a0,s0,-56
    382c:	638010ef          	jal	4e64 <pipe>
  pid3 = fork();
    3830:	61c010ef          	jal	4e4c <fork>
    3834:	8a2a                	mv	s4,a0
  if(pid3 < 0) {
    3836:	02054863          	bltz	a0,3866 <preempt+0x94>
  if(pid3 == 0){
    383a:	e921                	bnez	a0,388a <preempt+0xb8>
    close(pfds[0]);
    383c:	fc842503          	lw	a0,-56(s0)
    3840:	63c010ef          	jal	4e7c <close>
    if(write(pfds[1], "x", 1) != 1)
    3844:	4605                	li	a2,1
    3846:	00002597          	auipc	a1,0x2
    384a:	cb258593          	addi	a1,a1,-846 # 54f8 <malloc+0x19e>
    384e:	fcc42503          	lw	a0,-52(s0)
    3852:	622010ef          	jal	4e74 <write>
    3856:	4785                	li	a5,1
    3858:	02f51163          	bne	a0,a5,387a <preempt+0xa8>
    close(pfds[1]);
    385c:	fcc42503          	lw	a0,-52(s0)
    3860:	61c010ef          	jal	4e7c <close>
    for(;;)
    3864:	a001                	j	3864 <preempt+0x92>
     printf("%s: fork failed\n", s);
    3866:	85ca                	mv	a1,s2
    3868:	00002517          	auipc	a0,0x2
    386c:	4b050513          	addi	a0,a0,1200 # 5d18 <malloc+0x9be>
    3870:	233010ef          	jal	52a2 <printf>
     exit(1);
    3874:	4505                	li	a0,1
    3876:	5de010ef          	jal	4e54 <exit>
      printf("%s: preempt write error", s);
    387a:	85ca                	mv	a1,s2
    387c:	00003517          	auipc	a0,0x3
    3880:	66c50513          	addi	a0,a0,1644 # 6ee8 <malloc+0x1b8e>
    3884:	21f010ef          	jal	52a2 <printf>
    3888:	bfd1                	j	385c <preempt+0x8a>
  close(pfds[1]);
    388a:	fcc42503          	lw	a0,-52(s0)
    388e:	5ee010ef          	jal	4e7c <close>
  if(read(pfds[0], buf, sizeof(buf)) != 1){
    3892:	660d                	lui	a2,0x3
    3894:	00009597          	auipc	a1,0x9
    3898:	40458593          	addi	a1,a1,1028 # cc98 <buf>
    389c:	fc842503          	lw	a0,-56(s0)
    38a0:	5cc010ef          	jal	4e6c <read>
    38a4:	4785                	li	a5,1
    38a6:	02f50163          	beq	a0,a5,38c8 <preempt+0xf6>
    printf("%s: preempt read error", s);
    38aa:	85ca                	mv	a1,s2
    38ac:	00003517          	auipc	a0,0x3
    38b0:	65450513          	addi	a0,a0,1620 # 6f00 <malloc+0x1ba6>
    38b4:	1ef010ef          	jal	52a2 <printf>
}
    38b8:	70e2                	ld	ra,56(sp)
    38ba:	7442                	ld	s0,48(sp)
    38bc:	74a2                	ld	s1,40(sp)
    38be:	7902                	ld	s2,32(sp)
    38c0:	69e2                	ld	s3,24(sp)
    38c2:	6a42                	ld	s4,16(sp)
    38c4:	6121                	addi	sp,sp,64
    38c6:	8082                	ret
  close(pfds[0]);
    38c8:	fc842503          	lw	a0,-56(s0)
    38cc:	5b0010ef          	jal	4e7c <close>
  printf("kill... ");
    38d0:	00003517          	auipc	a0,0x3
    38d4:	64850513          	addi	a0,a0,1608 # 6f18 <malloc+0x1bbe>
    38d8:	1cb010ef          	jal	52a2 <printf>
  kill(pid1);
    38dc:	8526                	mv	a0,s1
    38de:	5a6010ef          	jal	4e84 <kill>
  kill(pid2);
    38e2:	854e                	mv	a0,s3
    38e4:	5a0010ef          	jal	4e84 <kill>
  kill(pid3);
    38e8:	8552                	mv	a0,s4
    38ea:	59a010ef          	jal	4e84 <kill>
  printf("wait... ");
    38ee:	00003517          	auipc	a0,0x3
    38f2:	63a50513          	addi	a0,a0,1594 # 6f28 <malloc+0x1bce>
    38f6:	1ad010ef          	jal	52a2 <printf>
  wait(0);
    38fa:	4501                	li	a0,0
    38fc:	560010ef          	jal	4e5c <wait>
  wait(0);
    3900:	4501                	li	a0,0
    3902:	55a010ef          	jal	4e5c <wait>
  wait(0);
    3906:	4501                	li	a0,0
    3908:	554010ef          	jal	4e5c <wait>
    390c:	b775                	j	38b8 <preempt+0xe6>

000000000000390e <reparent>:
{
    390e:	7179                	addi	sp,sp,-48
    3910:	f406                	sd	ra,40(sp)
    3912:	f022                	sd	s0,32(sp)
    3914:	ec26                	sd	s1,24(sp)
    3916:	e84a                	sd	s2,16(sp)
    3918:	e44e                	sd	s3,8(sp)
    391a:	e052                	sd	s4,0(sp)
    391c:	1800                	addi	s0,sp,48
    391e:	89aa                	mv	s3,a0
  int master_pid = getpid();
    3920:	5b4010ef          	jal	4ed4 <getpid>
    3924:	8a2a                	mv	s4,a0
    3926:	0c800913          	li	s2,200
    int pid = fork();
    392a:	522010ef          	jal	4e4c <fork>
    392e:	84aa                	mv	s1,a0
    if(pid < 0){
    3930:	00054e63          	bltz	a0,394c <reparent+0x3e>
    if(pid){
    3934:	c121                	beqz	a0,3974 <reparent+0x66>
      if(wait(0) != pid){
    3936:	4501                	li	a0,0
    3938:	524010ef          	jal	4e5c <wait>
    393c:	02951263          	bne	a0,s1,3960 <reparent+0x52>
  for(int i = 0; i < 200; i++){
    3940:	397d                	addiw	s2,s2,-1
    3942:	fe0914e3          	bnez	s2,392a <reparent+0x1c>
  exit(0);
    3946:	4501                	li	a0,0
    3948:	50c010ef          	jal	4e54 <exit>
      printf("%s: fork failed\n", s);
    394c:	85ce                	mv	a1,s3
    394e:	00002517          	auipc	a0,0x2
    3952:	3ca50513          	addi	a0,a0,970 # 5d18 <malloc+0x9be>
    3956:	14d010ef          	jal	52a2 <printf>
      exit(1);
    395a:	4505                	li	a0,1
    395c:	4f8010ef          	jal	4e54 <exit>
        printf("%s: wait wrong pid\n", s);
    3960:	85ce                	mv	a1,s3
    3962:	00002517          	auipc	a0,0x2
    3966:	53e50513          	addi	a0,a0,1342 # 5ea0 <malloc+0xb46>
    396a:	139010ef          	jal	52a2 <printf>
        exit(1);
    396e:	4505                	li	a0,1
    3970:	4e4010ef          	jal	4e54 <exit>
      int pid2 = fork();
    3974:	4d8010ef          	jal	4e4c <fork>
      if(pid2 < 0){
    3978:	00054563          	bltz	a0,3982 <reparent+0x74>
      exit(0);
    397c:	4501                	li	a0,0
    397e:	4d6010ef          	jal	4e54 <exit>
        kill(master_pid);
    3982:	8552                	mv	a0,s4
    3984:	500010ef          	jal	4e84 <kill>
        exit(1);
    3988:	4505                	li	a0,1
    398a:	4ca010ef          	jal	4e54 <exit>

000000000000398e <mem>:
{
    398e:	7139                	addi	sp,sp,-64
    3990:	fc06                	sd	ra,56(sp)
    3992:	f822                	sd	s0,48(sp)
    3994:	f426                	sd	s1,40(sp)
    3996:	f04a                	sd	s2,32(sp)
    3998:	ec4e                	sd	s3,24(sp)
    399a:	0080                	addi	s0,sp,64
    399c:	89aa                	mv	s3,a0
  if((pid = fork()) == 0){
    399e:	4ae010ef          	jal	4e4c <fork>
    m1 = 0;
    39a2:	4481                	li	s1,0
    while((m2 = malloc(10001)) != 0){
    39a4:	6909                	lui	s2,0x2
    39a6:	71190913          	addi	s2,s2,1809 # 2711 <fourteen+0x37>
  if((pid = fork()) == 0){
    39aa:	cd11                	beqz	a0,39c6 <mem+0x38>
    wait(&xstatus);
    39ac:	fcc40513          	addi	a0,s0,-52
    39b0:	4ac010ef          	jal	4e5c <wait>
    if(xstatus == -1){
    39b4:	fcc42503          	lw	a0,-52(s0)
    39b8:	57fd                	li	a5,-1
    39ba:	04f50363          	beq	a0,a5,3a00 <mem+0x72>
    exit(xstatus);
    39be:	496010ef          	jal	4e54 <exit>
      *(char**)m2 = m1;
    39c2:	e104                	sd	s1,0(a0)
      m1 = m2;
    39c4:	84aa                	mv	s1,a0
    while((m2 = malloc(10001)) != 0){
    39c6:	854a                	mv	a0,s2
    39c8:	193010ef          	jal	535a <malloc>
    39cc:	f97d                	bnez	a0,39c2 <mem+0x34>
    while(m1){
    39ce:	c491                	beqz	s1,39da <mem+0x4c>
      m2 = *(char**)m1;
    39d0:	8526                	mv	a0,s1
    39d2:	6084                	ld	s1,0(s1)
      free(m1);
    39d4:	101010ef          	jal	52d4 <free>
    while(m1){
    39d8:	fce5                	bnez	s1,39d0 <mem+0x42>
    m1 = malloc(1024*20);
    39da:	6515                	lui	a0,0x5
    39dc:	17f010ef          	jal	535a <malloc>
    if(m1 == 0){
    39e0:	c511                	beqz	a0,39ec <mem+0x5e>
    free(m1);
    39e2:	0f3010ef          	jal	52d4 <free>
    exit(0);
    39e6:	4501                	li	a0,0
    39e8:	46c010ef          	jal	4e54 <exit>
      printf("%s: couldn't allocate mem?!!\n", s);
    39ec:	85ce                	mv	a1,s3
    39ee:	00003517          	auipc	a0,0x3
    39f2:	54a50513          	addi	a0,a0,1354 # 6f38 <malloc+0x1bde>
    39f6:	0ad010ef          	jal	52a2 <printf>
      exit(1);
    39fa:	4505                	li	a0,1
    39fc:	458010ef          	jal	4e54 <exit>
      exit(0);
    3a00:	4501                	li	a0,0
    3a02:	452010ef          	jal	4e54 <exit>

0000000000003a06 <sharedfd>:
{
    3a06:	7159                	addi	sp,sp,-112
    3a08:	f486                	sd	ra,104(sp)
    3a0a:	f0a2                	sd	s0,96(sp)
    3a0c:	eca6                	sd	s1,88(sp)
    3a0e:	f85a                	sd	s6,48(sp)
    3a10:	1880                	addi	s0,sp,112
    3a12:	84aa                	mv	s1,a0
    3a14:	8b2a                	mv	s6,a0
  unlink("sharedfd");
    3a16:	00003517          	auipc	a0,0x3
    3a1a:	54250513          	addi	a0,a0,1346 # 6f58 <malloc+0x1bfe>
    3a1e:	486010ef          	jal	4ea4 <unlink>
  fd = open("sharedfd", O_CREATE|O_RDWR);
    3a22:	20200593          	li	a1,514
    3a26:	00003517          	auipc	a0,0x3
    3a2a:	53250513          	addi	a0,a0,1330 # 6f58 <malloc+0x1bfe>
    3a2e:	466010ef          	jal	4e94 <open>
  if(fd < 0){
    3a32:	04054863          	bltz	a0,3a82 <sharedfd+0x7c>
    3a36:	e8ca                	sd	s2,80(sp)
    3a38:	e4ce                	sd	s3,72(sp)
    3a3a:	e0d2                	sd	s4,64(sp)
    3a3c:	fc56                	sd	s5,56(sp)
    3a3e:	89aa                	mv	s3,a0
  pid = fork();
    3a40:	40c010ef          	jal	4e4c <fork>
    3a44:	8aaa                	mv	s5,a0
  memset(buf, pid==0?'c':'p', sizeof(buf));
    3a46:	07000593          	li	a1,112
    3a4a:	e119                	bnez	a0,3a50 <sharedfd+0x4a>
    3a4c:	06300593          	li	a1,99
    3a50:	4629                	li	a2,10
    3a52:	fa040513          	addi	a0,s0,-96
    3a56:	1d4010ef          	jal	4c2a <memset>
    3a5a:	3e800493          	li	s1,1000
    if(write(fd, buf, sizeof(buf)) != sizeof(buf)){
    3a5e:	fa040a13          	addi	s4,s0,-96
    3a62:	4929                	li	s2,10
    3a64:	864a                	mv	a2,s2
    3a66:	85d2                	mv	a1,s4
    3a68:	854e                	mv	a0,s3
    3a6a:	40a010ef          	jal	4e74 <write>
    3a6e:	03251963          	bne	a0,s2,3aa0 <sharedfd+0x9a>
  for(i = 0; i < N; i++){
    3a72:	34fd                	addiw	s1,s1,-1
    3a74:	f8e5                	bnez	s1,3a64 <sharedfd+0x5e>
  if(pid == 0) {
    3a76:	040a9063          	bnez	s5,3ab6 <sharedfd+0xb0>
    3a7a:	f45e                	sd	s7,40(sp)
    exit(0);
    3a7c:	4501                	li	a0,0
    3a7e:	3d6010ef          	jal	4e54 <exit>
    3a82:	e8ca                	sd	s2,80(sp)
    3a84:	e4ce                	sd	s3,72(sp)
    3a86:	e0d2                	sd	s4,64(sp)
    3a88:	fc56                	sd	s5,56(sp)
    3a8a:	f45e                	sd	s7,40(sp)
    printf("%s: cannot open sharedfd for writing", s);
    3a8c:	85a6                	mv	a1,s1
    3a8e:	00003517          	auipc	a0,0x3
    3a92:	4da50513          	addi	a0,a0,1242 # 6f68 <malloc+0x1c0e>
    3a96:	00d010ef          	jal	52a2 <printf>
    exit(1);
    3a9a:	4505                	li	a0,1
    3a9c:	3b8010ef          	jal	4e54 <exit>
    3aa0:	f45e                	sd	s7,40(sp)
      printf("%s: write sharedfd failed\n", s);
    3aa2:	85da                	mv	a1,s6
    3aa4:	00003517          	auipc	a0,0x3
    3aa8:	4ec50513          	addi	a0,a0,1260 # 6f90 <malloc+0x1c36>
    3aac:	7f6010ef          	jal	52a2 <printf>
      exit(1);
    3ab0:	4505                	li	a0,1
    3ab2:	3a2010ef          	jal	4e54 <exit>
    wait(&xstatus);
    3ab6:	f9c40513          	addi	a0,s0,-100
    3aba:	3a2010ef          	jal	4e5c <wait>
    if(xstatus != 0)
    3abe:	f9c42a03          	lw	s4,-100(s0)
    3ac2:	000a0663          	beqz	s4,3ace <sharedfd+0xc8>
    3ac6:	f45e                	sd	s7,40(sp)
      exit(xstatus);
    3ac8:	8552                	mv	a0,s4
    3aca:	38a010ef          	jal	4e54 <exit>
    3ace:	f45e                	sd	s7,40(sp)
  close(fd);
    3ad0:	854e                	mv	a0,s3
    3ad2:	3aa010ef          	jal	4e7c <close>
  fd = open("sharedfd", 0);
    3ad6:	4581                	li	a1,0
    3ad8:	00003517          	auipc	a0,0x3
    3adc:	48050513          	addi	a0,a0,1152 # 6f58 <malloc+0x1bfe>
    3ae0:	3b4010ef          	jal	4e94 <open>
    3ae4:	8baa                	mv	s7,a0
  nc = np = 0;
    3ae6:	89d2                	mv	s3,s4
  if(fd < 0){
    3ae8:	02054363          	bltz	a0,3b0e <sharedfd+0x108>
    3aec:	faa40913          	addi	s2,s0,-86
      if(buf[i] == 'c')
    3af0:	06300493          	li	s1,99
      if(buf[i] == 'p')
    3af4:	07000a93          	li	s5,112
  while((n = read(fd, buf, sizeof(buf))) > 0){
    3af8:	4629                	li	a2,10
    3afa:	fa040593          	addi	a1,s0,-96
    3afe:	855e                	mv	a0,s7
    3b00:	36c010ef          	jal	4e6c <read>
    3b04:	02a05b63          	blez	a0,3b3a <sharedfd+0x134>
    3b08:	fa040793          	addi	a5,s0,-96
    3b0c:	a839                	j	3b2a <sharedfd+0x124>
    printf("%s: cannot open sharedfd for reading\n", s);
    3b0e:	85da                	mv	a1,s6
    3b10:	00003517          	auipc	a0,0x3
    3b14:	4a050513          	addi	a0,a0,1184 # 6fb0 <malloc+0x1c56>
    3b18:	78a010ef          	jal	52a2 <printf>
    exit(1);
    3b1c:	4505                	li	a0,1
    3b1e:	336010ef          	jal	4e54 <exit>
        nc++;
    3b22:	2a05                	addiw	s4,s4,1
    for(i = 0; i < sizeof(buf); i++){
    3b24:	0785                	addi	a5,a5,1
    3b26:	fd2789e3          	beq	a5,s2,3af8 <sharedfd+0xf2>
      if(buf[i] == 'c')
    3b2a:	0007c703          	lbu	a4,0(a5)
    3b2e:	fe970ae3          	beq	a4,s1,3b22 <sharedfd+0x11c>
      if(buf[i] == 'p')
    3b32:	ff5719e3          	bne	a4,s5,3b24 <sharedfd+0x11e>
        np++;
    3b36:	2985                	addiw	s3,s3,1
    3b38:	b7f5                	j	3b24 <sharedfd+0x11e>
  close(fd);
    3b3a:	855e                	mv	a0,s7
    3b3c:	340010ef          	jal	4e7c <close>
  unlink("sharedfd");
    3b40:	00003517          	auipc	a0,0x3
    3b44:	41850513          	addi	a0,a0,1048 # 6f58 <malloc+0x1bfe>
    3b48:	35c010ef          	jal	4ea4 <unlink>
  if(nc == N*SZ && np == N*SZ){
    3b4c:	6789                	lui	a5,0x2
    3b4e:	71078793          	addi	a5,a5,1808 # 2710 <fourteen+0x36>
    3b52:	00fa1763          	bne	s4,a5,3b60 <sharedfd+0x15a>
    3b56:	01499563          	bne	s3,s4,3b60 <sharedfd+0x15a>
    exit(0);
    3b5a:	4501                	li	a0,0
    3b5c:	2f8010ef          	jal	4e54 <exit>
    printf("%s: nc/np test fails\n", s);
    3b60:	85da                	mv	a1,s6
    3b62:	00003517          	auipc	a0,0x3
    3b66:	47650513          	addi	a0,a0,1142 # 6fd8 <malloc+0x1c7e>
    3b6a:	738010ef          	jal	52a2 <printf>
    exit(1);
    3b6e:	4505                	li	a0,1
    3b70:	2e4010ef          	jal	4e54 <exit>

0000000000003b74 <fourfiles>:
{
    3b74:	7135                	addi	sp,sp,-160
    3b76:	ed06                	sd	ra,152(sp)
    3b78:	e922                	sd	s0,144(sp)
    3b7a:	e526                	sd	s1,136(sp)
    3b7c:	e14a                	sd	s2,128(sp)
    3b7e:	fcce                	sd	s3,120(sp)
    3b80:	f8d2                	sd	s4,112(sp)
    3b82:	f4d6                	sd	s5,104(sp)
    3b84:	f0da                	sd	s6,96(sp)
    3b86:	ecde                	sd	s7,88(sp)
    3b88:	e8e2                	sd	s8,80(sp)
    3b8a:	e4e6                	sd	s9,72(sp)
    3b8c:	e0ea                	sd	s10,64(sp)
    3b8e:	fc6e                	sd	s11,56(sp)
    3b90:	1100                	addi	s0,sp,160
    3b92:	8caa                	mv	s9,a0
  char *names[] = { "f0", "f1", "f2", "f3" };
    3b94:	00003797          	auipc	a5,0x3
    3b98:	45c78793          	addi	a5,a5,1116 # 6ff0 <malloc+0x1c96>
    3b9c:	f6f43823          	sd	a5,-144(s0)
    3ba0:	00003797          	auipc	a5,0x3
    3ba4:	45878793          	addi	a5,a5,1112 # 6ff8 <malloc+0x1c9e>
    3ba8:	f6f43c23          	sd	a5,-136(s0)
    3bac:	00003797          	auipc	a5,0x3
    3bb0:	45478793          	addi	a5,a5,1108 # 7000 <malloc+0x1ca6>
    3bb4:	f8f43023          	sd	a5,-128(s0)
    3bb8:	00003797          	auipc	a5,0x3
    3bbc:	45078793          	addi	a5,a5,1104 # 7008 <malloc+0x1cae>
    3bc0:	f8f43423          	sd	a5,-120(s0)
  for(pi = 0; pi < NCHILD; pi++){
    3bc4:	f7040b93          	addi	s7,s0,-144
  char *names[] = { "f0", "f1", "f2", "f3" };
    3bc8:	895e                	mv	s2,s7
  for(pi = 0; pi < NCHILD; pi++){
    3bca:	4481                	li	s1,0
    3bcc:	4a11                	li	s4,4
    fname = names[pi];
    3bce:	00093983          	ld	s3,0(s2)
    unlink(fname);
    3bd2:	854e                	mv	a0,s3
    3bd4:	2d0010ef          	jal	4ea4 <unlink>
    pid = fork();
    3bd8:	274010ef          	jal	4e4c <fork>
    if(pid < 0){
    3bdc:	04054063          	bltz	a0,3c1c <fourfiles+0xa8>
    if(pid == 0){
    3be0:	c921                	beqz	a0,3c30 <fourfiles+0xbc>
  for(pi = 0; pi < NCHILD; pi++){
    3be2:	2485                	addiw	s1,s1,1
    3be4:	0921                	addi	s2,s2,8
    3be6:	ff4494e3          	bne	s1,s4,3bce <fourfiles+0x5a>
    3bea:	4491                	li	s1,4
    wait(&xstatus);
    3bec:	f6c40913          	addi	s2,s0,-148
    3bf0:	854a                	mv	a0,s2
    3bf2:	26a010ef          	jal	4e5c <wait>
    if(xstatus != 0)
    3bf6:	f6c42b03          	lw	s6,-148(s0)
    3bfa:	0a0b1463          	bnez	s6,3ca2 <fourfiles+0x12e>
  for(pi = 0; pi < NCHILD; pi++){
    3bfe:	34fd                	addiw	s1,s1,-1
    3c00:	f8e5                	bnez	s1,3bf0 <fourfiles+0x7c>
    3c02:	03000493          	li	s1,48
    while((n = read(fd, buf, sizeof(buf))) > 0){
    3c06:	6a8d                	lui	s5,0x3
    3c08:	00009a17          	auipc	s4,0x9
    3c0c:	090a0a13          	addi	s4,s4,144 # cc98 <buf>
    if(total != N*SZ){
    3c10:	6d05                	lui	s10,0x1
    3c12:	770d0d13          	addi	s10,s10,1904 # 1770 <exitwait+0x90>
  for(i = 0; i < NCHILD; i++){
    3c16:	03400d93          	li	s11,52
    3c1a:	a86d                	j	3cd4 <fourfiles+0x160>
      printf("%s: fork failed\n", s);
    3c1c:	85e6                	mv	a1,s9
    3c1e:	00002517          	auipc	a0,0x2
    3c22:	0fa50513          	addi	a0,a0,250 # 5d18 <malloc+0x9be>
    3c26:	67c010ef          	jal	52a2 <printf>
      exit(1);
    3c2a:	4505                	li	a0,1
    3c2c:	228010ef          	jal	4e54 <exit>
      fd = open(fname, O_CREATE | O_RDWR);
    3c30:	20200593          	li	a1,514
    3c34:	854e                	mv	a0,s3
    3c36:	25e010ef          	jal	4e94 <open>
    3c3a:	892a                	mv	s2,a0
      if(fd < 0){
    3c3c:	04054063          	bltz	a0,3c7c <fourfiles+0x108>
      memset(buf, '0'+pi, SZ);
    3c40:	1f400613          	li	a2,500
    3c44:	0304859b          	addiw	a1,s1,48
    3c48:	00009517          	auipc	a0,0x9
    3c4c:	05050513          	addi	a0,a0,80 # cc98 <buf>
    3c50:	7db000ef          	jal	4c2a <memset>
    3c54:	44b1                	li	s1,12
        if((n = write(fd, buf, SZ)) != SZ){
    3c56:	1f400993          	li	s3,500
    3c5a:	00009a17          	auipc	s4,0x9
    3c5e:	03ea0a13          	addi	s4,s4,62 # cc98 <buf>
    3c62:	864e                	mv	a2,s3
    3c64:	85d2                	mv	a1,s4
    3c66:	854a                	mv	a0,s2
    3c68:	20c010ef          	jal	4e74 <write>
    3c6c:	85aa                	mv	a1,a0
    3c6e:	03351163          	bne	a0,s3,3c90 <fourfiles+0x11c>
      for(i = 0; i < N; i++){
    3c72:	34fd                	addiw	s1,s1,-1
    3c74:	f4fd                	bnez	s1,3c62 <fourfiles+0xee>
      exit(0);
    3c76:	4501                	li	a0,0
    3c78:	1dc010ef          	jal	4e54 <exit>
        printf("%s: create failed\n", s);
    3c7c:	85e6                	mv	a1,s9
    3c7e:	00002517          	auipc	a0,0x2
    3c82:	13250513          	addi	a0,a0,306 # 5db0 <malloc+0xa56>
    3c86:	61c010ef          	jal	52a2 <printf>
        exit(1);
    3c8a:	4505                	li	a0,1
    3c8c:	1c8010ef          	jal	4e54 <exit>
          printf("write failed %d\n", n);
    3c90:	00003517          	auipc	a0,0x3
    3c94:	38050513          	addi	a0,a0,896 # 7010 <malloc+0x1cb6>
    3c98:	60a010ef          	jal	52a2 <printf>
          exit(1);
    3c9c:	4505                	li	a0,1
    3c9e:	1b6010ef          	jal	4e54 <exit>
      exit(xstatus);
    3ca2:	855a                	mv	a0,s6
    3ca4:	1b0010ef          	jal	4e54 <exit>
          printf("%s: wrong char\n", s);
    3ca8:	85e6                	mv	a1,s9
    3caa:	00003517          	auipc	a0,0x3
    3cae:	37e50513          	addi	a0,a0,894 # 7028 <malloc+0x1cce>
    3cb2:	5f0010ef          	jal	52a2 <printf>
          exit(1);
    3cb6:	4505                	li	a0,1
    3cb8:	19c010ef          	jal	4e54 <exit>
    close(fd);
    3cbc:	854e                	mv	a0,s3
    3cbe:	1be010ef          	jal	4e7c <close>
    if(total != N*SZ){
    3cc2:	05a91863          	bne	s2,s10,3d12 <fourfiles+0x19e>
    unlink(fname);
    3cc6:	8562                	mv	a0,s8
    3cc8:	1dc010ef          	jal	4ea4 <unlink>
  for(i = 0; i < NCHILD; i++){
    3ccc:	0ba1                	addi	s7,s7,8
    3cce:	2485                	addiw	s1,s1,1
    3cd0:	05b48b63          	beq	s1,s11,3d26 <fourfiles+0x1b2>
    fname = names[i];
    3cd4:	000bbc03          	ld	s8,0(s7)
    fd = open(fname, 0);
    3cd8:	4581                	li	a1,0
    3cda:	8562                	mv	a0,s8
    3cdc:	1b8010ef          	jal	4e94 <open>
    3ce0:	89aa                	mv	s3,a0
    total = 0;
    3ce2:	895a                	mv	s2,s6
    while((n = read(fd, buf, sizeof(buf))) > 0){
    3ce4:	8656                	mv	a2,s5
    3ce6:	85d2                	mv	a1,s4
    3ce8:	854e                	mv	a0,s3
    3cea:	182010ef          	jal	4e6c <read>
    3cee:	fca057e3          	blez	a0,3cbc <fourfiles+0x148>
    3cf2:	00009797          	auipc	a5,0x9
    3cf6:	fa678793          	addi	a5,a5,-90 # cc98 <buf>
    3cfa:	00f506b3          	add	a3,a0,a5
        if(buf[j] != '0'+i){
    3cfe:	0007c703          	lbu	a4,0(a5)
    3d02:	fa9713e3          	bne	a4,s1,3ca8 <fourfiles+0x134>
      for(j = 0; j < n; j++){
    3d06:	0785                	addi	a5,a5,1
    3d08:	fed79be3          	bne	a5,a3,3cfe <fourfiles+0x18a>
      total += n;
    3d0c:	00a9093b          	addw	s2,s2,a0
    3d10:	bfd1                	j	3ce4 <fourfiles+0x170>
      printf("wrong length %d\n", total);
    3d12:	85ca                	mv	a1,s2
    3d14:	00003517          	auipc	a0,0x3
    3d18:	32450513          	addi	a0,a0,804 # 7038 <malloc+0x1cde>
    3d1c:	586010ef          	jal	52a2 <printf>
      exit(1);
    3d20:	4505                	li	a0,1
    3d22:	132010ef          	jal	4e54 <exit>
}
    3d26:	60ea                	ld	ra,152(sp)
    3d28:	644a                	ld	s0,144(sp)
    3d2a:	64aa                	ld	s1,136(sp)
    3d2c:	690a                	ld	s2,128(sp)
    3d2e:	79e6                	ld	s3,120(sp)
    3d30:	7a46                	ld	s4,112(sp)
    3d32:	7aa6                	ld	s5,104(sp)
    3d34:	7b06                	ld	s6,96(sp)
    3d36:	6be6                	ld	s7,88(sp)
    3d38:	6c46                	ld	s8,80(sp)
    3d3a:	6ca6                	ld	s9,72(sp)
    3d3c:	6d06                	ld	s10,64(sp)
    3d3e:	7de2                	ld	s11,56(sp)
    3d40:	610d                	addi	sp,sp,160
    3d42:	8082                	ret

0000000000003d44 <concreate>:
{
    3d44:	7171                	addi	sp,sp,-176
    3d46:	f506                	sd	ra,168(sp)
    3d48:	f122                	sd	s0,160(sp)
    3d4a:	ed26                	sd	s1,152(sp)
    3d4c:	e94a                	sd	s2,144(sp)
    3d4e:	e54e                	sd	s3,136(sp)
    3d50:	e152                	sd	s4,128(sp)
    3d52:	fcd6                	sd	s5,120(sp)
    3d54:	f8da                	sd	s6,112(sp)
    3d56:	f4de                	sd	s7,104(sp)
    3d58:	f0e2                	sd	s8,96(sp)
    3d5a:	ece6                	sd	s9,88(sp)
    3d5c:	e8ea                	sd	s10,80(sp)
    3d5e:	1900                	addi	s0,sp,176
    3d60:	8d2a                	mv	s10,a0
  file[0] = 'C';
    3d62:	04300793          	li	a5,67
    3d66:	f8f40c23          	sb	a5,-104(s0)
  file[2] = '\0';
    3d6a:	f8040d23          	sb	zero,-102(s0)
  for(i = 0; i < N; i++){
    3d6e:	4901                	li	s2,0
    unlink(file);
    3d70:	f9840993          	addi	s3,s0,-104
    if(pid && (i % 3) == 1){
    3d74:	55555b37          	lui	s6,0x55555
    3d78:	556b0b13          	addi	s6,s6,1366 # 55555556 <base+0x555458be>
    3d7c:	4b85                	li	s7,1
      fd = open(file, O_CREATE | O_RDWR);
    3d7e:	20200c13          	li	s8,514
      link("C0", file);
    3d82:	00003c97          	auipc	s9,0x3
    3d86:	2cec8c93          	addi	s9,s9,718 # 7050 <malloc+0x1cf6>
      wait(&xstatus);
    3d8a:	f5c40a93          	addi	s5,s0,-164
  for(i = 0; i < N; i++){
    3d8e:	02800a13          	li	s4,40
    3d92:	ac25                	j	3fca <concreate+0x286>
      link("C0", file);
    3d94:	85ce                	mv	a1,s3
    3d96:	8566                	mv	a0,s9
    3d98:	11c010ef          	jal	4eb4 <link>
    if(pid == 0) {
    3d9c:	ac29                	j	3fb6 <concreate+0x272>
    } else if(pid == 0 && (i % 5) == 1){
    3d9e:	666667b7          	lui	a5,0x66666
    3da2:	66778793          	addi	a5,a5,1639 # 66666667 <base+0x666569cf>
    3da6:	02f907b3          	mul	a5,s2,a5
    3daa:	9785                	srai	a5,a5,0x21
    3dac:	41f9571b          	sraiw	a4,s2,0x1f
    3db0:	9f99                	subw	a5,a5,a4
    3db2:	0027971b          	slliw	a4,a5,0x2
    3db6:	9fb9                	addw	a5,a5,a4
    3db8:	40f9093b          	subw	s2,s2,a5
    3dbc:	4785                	li	a5,1
    3dbe:	02f90563          	beq	s2,a5,3de8 <concreate+0xa4>
      fd = open(file, O_CREATE | O_RDWR);
    3dc2:	20200593          	li	a1,514
    3dc6:	f9840513          	addi	a0,s0,-104
    3dca:	0ca010ef          	jal	4e94 <open>
      if(fd < 0){
    3dce:	1c055f63          	bgez	a0,3fac <concreate+0x268>
        printf("concreate create %s failed\n", file);
    3dd2:	f9840593          	addi	a1,s0,-104
    3dd6:	00003517          	auipc	a0,0x3
    3dda:	28250513          	addi	a0,a0,642 # 7058 <malloc+0x1cfe>
    3dde:	4c4010ef          	jal	52a2 <printf>
        exit(1);
    3de2:	4505                	li	a0,1
    3de4:	070010ef          	jal	4e54 <exit>
      link("C0", file);
    3de8:	f9840593          	addi	a1,s0,-104
    3dec:	00003517          	auipc	a0,0x3
    3df0:	26450513          	addi	a0,a0,612 # 7050 <malloc+0x1cf6>
    3df4:	0c0010ef          	jal	4eb4 <link>
      exit(0);
    3df8:	4501                	li	a0,0
    3dfa:	05a010ef          	jal	4e54 <exit>
        exit(1);
    3dfe:	4505                	li	a0,1
    3e00:	054010ef          	jal	4e54 <exit>
  memset(fa, 0, sizeof(fa));
    3e04:	02800613          	li	a2,40
    3e08:	4581                	li	a1,0
    3e0a:	f7040513          	addi	a0,s0,-144
    3e0e:	61d000ef          	jal	4c2a <memset>
  fd = open(".", 0);
    3e12:	4581                	li	a1,0
    3e14:	00002517          	auipc	a0,0x2
    3e18:	d5c50513          	addi	a0,a0,-676 # 5b70 <malloc+0x816>
    3e1c:	078010ef          	jal	4e94 <open>
    3e20:	892a                	mv	s2,a0
  n = 0;
    3e22:	8b26                	mv	s6,s1
  while(read(fd, &de, sizeof(de)) > 0){
    3e24:	f6040a13          	addi	s4,s0,-160
    3e28:	49c1                	li	s3,16
    if(de.name[0] == 'C' && de.name[2] == '\0'){
    3e2a:	04300a93          	li	s5,67
      if(i < 0 || i >= sizeof(fa)){
    3e2e:	02700b93          	li	s7,39
      fa[i] = 1;
    3e32:	4c05                	li	s8,1
  while(read(fd, &de, sizeof(de)) > 0){
    3e34:	864e                	mv	a2,s3
    3e36:	85d2                	mv	a1,s4
    3e38:	854a                	mv	a0,s2
    3e3a:	032010ef          	jal	4e6c <read>
    3e3e:	06a05763          	blez	a0,3eac <concreate+0x168>
    if(de.inum == 0)
    3e42:	f6045783          	lhu	a5,-160(s0)
    3e46:	d7fd                	beqz	a5,3e34 <concreate+0xf0>
    if(de.name[0] == 'C' && de.name[2] == '\0'){
    3e48:	f6244783          	lbu	a5,-158(s0)
    3e4c:	ff5794e3          	bne	a5,s5,3e34 <concreate+0xf0>
    3e50:	f6444783          	lbu	a5,-156(s0)
    3e54:	f3e5                	bnez	a5,3e34 <concreate+0xf0>
      i = de.name[1] - '0';
    3e56:	f6344783          	lbu	a5,-157(s0)
    3e5a:	fd07879b          	addiw	a5,a5,-48
      if(i < 0 || i >= sizeof(fa)){
    3e5e:	00fbef63          	bltu	s7,a5,3e7c <concreate+0x138>
      if(fa[i]){
    3e62:	fa078713          	addi	a4,a5,-96
    3e66:	9722                	add	a4,a4,s0
    3e68:	fd074703          	lbu	a4,-48(a4)
    3e6c:	e705                	bnez	a4,3e94 <concreate+0x150>
      fa[i] = 1;
    3e6e:	fa078793          	addi	a5,a5,-96
    3e72:	97a2                	add	a5,a5,s0
    3e74:	fd878823          	sb	s8,-48(a5)
      n++;
    3e78:	2b05                	addiw	s6,s6,1
    3e7a:	bf6d                	j	3e34 <concreate+0xf0>
        printf("%s: concreate weird file %s\n", s, de.name);
    3e7c:	f6240613          	addi	a2,s0,-158
    3e80:	85ea                	mv	a1,s10
    3e82:	00003517          	auipc	a0,0x3
    3e86:	1f650513          	addi	a0,a0,502 # 7078 <malloc+0x1d1e>
    3e8a:	418010ef          	jal	52a2 <printf>
        exit(1);
    3e8e:	4505                	li	a0,1
    3e90:	7c5000ef          	jal	4e54 <exit>
        printf("%s: concreate duplicate file %s\n", s, de.name);
    3e94:	f6240613          	addi	a2,s0,-158
    3e98:	85ea                	mv	a1,s10
    3e9a:	00003517          	auipc	a0,0x3
    3e9e:	1fe50513          	addi	a0,a0,510 # 7098 <malloc+0x1d3e>
    3ea2:	400010ef          	jal	52a2 <printf>
        exit(1);
    3ea6:	4505                	li	a0,1
    3ea8:	7ad000ef          	jal	4e54 <exit>
  close(fd);
    3eac:	854a                	mv	a0,s2
    3eae:	7cf000ef          	jal	4e7c <close>
  if(n != N){
    3eb2:	02800793          	li	a5,40
    3eb6:	00fb1a63          	bne	s6,a5,3eca <concreate+0x186>
    if(((i % 3) == 0 && pid == 0) ||
    3eba:	55555a37          	lui	s4,0x55555
    3ebe:	556a0a13          	addi	s4,s4,1366 # 55555556 <base+0x555458be>
      close(open(file, 0));
    3ec2:	f9840993          	addi	s3,s0,-104
  for(i = 0; i < N; i++){
    3ec6:	8ada                	mv	s5,s6
    3ec8:	a049                	j	3f4a <concreate+0x206>
    printf("%s: concreate not enough files in directory listing\n", s);
    3eca:	85ea                	mv	a1,s10
    3ecc:	00003517          	auipc	a0,0x3
    3ed0:	1f450513          	addi	a0,a0,500 # 70c0 <malloc+0x1d66>
    3ed4:	3ce010ef          	jal	52a2 <printf>
    exit(1);
    3ed8:	4505                	li	a0,1
    3eda:	77b000ef          	jal	4e54 <exit>
      printf("%s: fork failed\n", s);
    3ede:	85ea                	mv	a1,s10
    3ee0:	00002517          	auipc	a0,0x2
    3ee4:	e3850513          	addi	a0,a0,-456 # 5d18 <malloc+0x9be>
    3ee8:	3ba010ef          	jal	52a2 <printf>
      exit(1);
    3eec:	4505                	li	a0,1
    3eee:	767000ef          	jal	4e54 <exit>
      close(open(file, 0));
    3ef2:	4581                	li	a1,0
    3ef4:	854e                	mv	a0,s3
    3ef6:	79f000ef          	jal	4e94 <open>
    3efa:	783000ef          	jal	4e7c <close>
      close(open(file, 0));
    3efe:	4581                	li	a1,0
    3f00:	854e                	mv	a0,s3
    3f02:	793000ef          	jal	4e94 <open>
    3f06:	777000ef          	jal	4e7c <close>
      close(open(file, 0));
    3f0a:	4581                	li	a1,0
    3f0c:	854e                	mv	a0,s3
    3f0e:	787000ef          	jal	4e94 <open>
    3f12:	76b000ef          	jal	4e7c <close>
      close(open(file, 0));
    3f16:	4581                	li	a1,0
    3f18:	854e                	mv	a0,s3
    3f1a:	77b000ef          	jal	4e94 <open>
    3f1e:	75f000ef          	jal	4e7c <close>
      close(open(file, 0));
    3f22:	4581                	li	a1,0
    3f24:	854e                	mv	a0,s3
    3f26:	76f000ef          	jal	4e94 <open>
    3f2a:	753000ef          	jal	4e7c <close>
      close(open(file, 0));
    3f2e:	4581                	li	a1,0
    3f30:	854e                	mv	a0,s3
    3f32:	763000ef          	jal	4e94 <open>
    3f36:	747000ef          	jal	4e7c <close>
    if(pid == 0)
    3f3a:	06090663          	beqz	s2,3fa6 <concreate+0x262>
      wait(0);
    3f3e:	4501                	li	a0,0
    3f40:	71d000ef          	jal	4e5c <wait>
  for(i = 0; i < N; i++){
    3f44:	2485                	addiw	s1,s1,1
    3f46:	0d548163          	beq	s1,s5,4008 <concreate+0x2c4>
    file[1] = '0' + i;
    3f4a:	0304879b          	addiw	a5,s1,48
    3f4e:	f8f40ca3          	sb	a5,-103(s0)
    pid = fork();
    3f52:	6fb000ef          	jal	4e4c <fork>
    3f56:	892a                	mv	s2,a0
    if(pid < 0){
    3f58:	f80543e3          	bltz	a0,3ede <concreate+0x19a>
    if(((i % 3) == 0 && pid == 0) ||
    3f5c:	03448733          	mul	a4,s1,s4
    3f60:	9301                	srli	a4,a4,0x20
    3f62:	41f4d79b          	sraiw	a5,s1,0x1f
    3f66:	9f1d                	subw	a4,a4,a5
    3f68:	0017179b          	slliw	a5,a4,0x1
    3f6c:	9fb9                	addw	a5,a5,a4
    3f6e:	40f487bb          	subw	a5,s1,a5
    3f72:	00a7e733          	or	a4,a5,a0
    3f76:	2701                	sext.w	a4,a4
    3f78:	df2d                	beqz	a4,3ef2 <concreate+0x1ae>
       ((i % 3) == 1 && pid != 0)){
    3f7a:	c119                	beqz	a0,3f80 <concreate+0x23c>
    if(((i % 3) == 0 && pid == 0) ||
    3f7c:	17fd                	addi	a5,a5,-1
       ((i % 3) == 1 && pid != 0)){
    3f7e:	dbb5                	beqz	a5,3ef2 <concreate+0x1ae>
      unlink(file);
    3f80:	854e                	mv	a0,s3
    3f82:	723000ef          	jal	4ea4 <unlink>
      unlink(file);
    3f86:	854e                	mv	a0,s3
    3f88:	71d000ef          	jal	4ea4 <unlink>
      unlink(file);
    3f8c:	854e                	mv	a0,s3
    3f8e:	717000ef          	jal	4ea4 <unlink>
      unlink(file);
    3f92:	854e                	mv	a0,s3
    3f94:	711000ef          	jal	4ea4 <unlink>
      unlink(file);
    3f98:	854e                	mv	a0,s3
    3f9a:	70b000ef          	jal	4ea4 <unlink>
      unlink(file);
    3f9e:	854e                	mv	a0,s3
    3fa0:	705000ef          	jal	4ea4 <unlink>
    3fa4:	bf59                	j	3f3a <concreate+0x1f6>
      exit(0);
    3fa6:	4501                	li	a0,0
    3fa8:	6ad000ef          	jal	4e54 <exit>
      close(fd);
    3fac:	6d1000ef          	jal	4e7c <close>
    if(pid == 0) {
    3fb0:	b5a1                	j	3df8 <concreate+0xb4>
      close(fd);
    3fb2:	6cb000ef          	jal	4e7c <close>
      wait(&xstatus);
    3fb6:	8556                	mv	a0,s5
    3fb8:	6a5000ef          	jal	4e5c <wait>
      if(xstatus != 0)
    3fbc:	f5c42483          	lw	s1,-164(s0)
    3fc0:	e2049fe3          	bnez	s1,3dfe <concreate+0xba>
  for(i = 0; i < N; i++){
    3fc4:	2905                	addiw	s2,s2,1
    3fc6:	e3490fe3          	beq	s2,s4,3e04 <concreate+0xc0>
    file[1] = '0' + i;
    3fca:	0309079b          	addiw	a5,s2,48
    3fce:	f8f40ca3          	sb	a5,-103(s0)
    unlink(file);
    3fd2:	854e                	mv	a0,s3
    3fd4:	6d1000ef          	jal	4ea4 <unlink>
    pid = fork();
    3fd8:	675000ef          	jal	4e4c <fork>
    if(pid && (i % 3) == 1){
    3fdc:	dc0501e3          	beqz	a0,3d9e <concreate+0x5a>
    3fe0:	036907b3          	mul	a5,s2,s6
    3fe4:	9381                	srli	a5,a5,0x20
    3fe6:	41f9571b          	sraiw	a4,s2,0x1f
    3fea:	9f99                	subw	a5,a5,a4
    3fec:	0017971b          	slliw	a4,a5,0x1
    3ff0:	9fb9                	addw	a5,a5,a4
    3ff2:	40f907bb          	subw	a5,s2,a5
    3ff6:	d9778fe3          	beq	a5,s7,3d94 <concreate+0x50>
      fd = open(file, O_CREATE | O_RDWR);
    3ffa:	85e2                	mv	a1,s8
    3ffc:	854e                	mv	a0,s3
    3ffe:	697000ef          	jal	4e94 <open>
      if(fd < 0){
    4002:	fa0558e3          	bgez	a0,3fb2 <concreate+0x26e>
    4006:	b3f1                	j	3dd2 <concreate+0x8e>
}
    4008:	70aa                	ld	ra,168(sp)
    400a:	740a                	ld	s0,160(sp)
    400c:	64ea                	ld	s1,152(sp)
    400e:	694a                	ld	s2,144(sp)
    4010:	69aa                	ld	s3,136(sp)
    4012:	6a0a                	ld	s4,128(sp)
    4014:	7ae6                	ld	s5,120(sp)
    4016:	7b46                	ld	s6,112(sp)
    4018:	7ba6                	ld	s7,104(sp)
    401a:	7c06                	ld	s8,96(sp)
    401c:	6ce6                	ld	s9,88(sp)
    401e:	6d46                	ld	s10,80(sp)
    4020:	614d                	addi	sp,sp,176
    4022:	8082                	ret

0000000000004024 <bigfile>:
{
    4024:	7139                	addi	sp,sp,-64
    4026:	fc06                	sd	ra,56(sp)
    4028:	f822                	sd	s0,48(sp)
    402a:	f426                	sd	s1,40(sp)
    402c:	f04a                	sd	s2,32(sp)
    402e:	ec4e                	sd	s3,24(sp)
    4030:	e852                	sd	s4,16(sp)
    4032:	e456                	sd	s5,8(sp)
    4034:	e05a                	sd	s6,0(sp)
    4036:	0080                	addi	s0,sp,64
    4038:	8b2a                	mv	s6,a0
  unlink("bigfile.dat");
    403a:	00003517          	auipc	a0,0x3
    403e:	0be50513          	addi	a0,a0,190 # 70f8 <malloc+0x1d9e>
    4042:	663000ef          	jal	4ea4 <unlink>
  fd = open("bigfile.dat", O_CREATE | O_RDWR);
    4046:	20200593          	li	a1,514
    404a:	00003517          	auipc	a0,0x3
    404e:	0ae50513          	addi	a0,a0,174 # 70f8 <malloc+0x1d9e>
    4052:	643000ef          	jal	4e94 <open>
  if(fd < 0){
    4056:	08054a63          	bltz	a0,40ea <bigfile+0xc6>
    405a:	8a2a                	mv	s4,a0
    405c:	4481                	li	s1,0
    memset(buf, i, SZ);
    405e:	25800913          	li	s2,600
    4062:	00009997          	auipc	s3,0x9
    4066:	c3698993          	addi	s3,s3,-970 # cc98 <buf>
  for(i = 0; i < N; i++){
    406a:	4ad1                	li	s5,20
    memset(buf, i, SZ);
    406c:	864a                	mv	a2,s2
    406e:	85a6                	mv	a1,s1
    4070:	854e                	mv	a0,s3
    4072:	3b9000ef          	jal	4c2a <memset>
    if(write(fd, buf, SZ) != SZ){
    4076:	864a                	mv	a2,s2
    4078:	85ce                	mv	a1,s3
    407a:	8552                	mv	a0,s4
    407c:	5f9000ef          	jal	4e74 <write>
    4080:	07251f63          	bne	a0,s2,40fe <bigfile+0xda>
  for(i = 0; i < N; i++){
    4084:	2485                	addiw	s1,s1,1
    4086:	ff5493e3          	bne	s1,s5,406c <bigfile+0x48>
  close(fd);
    408a:	8552                	mv	a0,s4
    408c:	5f1000ef          	jal	4e7c <close>
  fd = open("bigfile.dat", 0);
    4090:	4581                	li	a1,0
    4092:	00003517          	auipc	a0,0x3
    4096:	06650513          	addi	a0,a0,102 # 70f8 <malloc+0x1d9e>
    409a:	5fb000ef          	jal	4e94 <open>
    409e:	8aaa                	mv	s5,a0
  total = 0;
    40a0:	4a01                	li	s4,0
  for(i = 0; ; i++){
    40a2:	4481                	li	s1,0
    cc = read(fd, buf, SZ/2);
    40a4:	12c00993          	li	s3,300
    40a8:	00009917          	auipc	s2,0x9
    40ac:	bf090913          	addi	s2,s2,-1040 # cc98 <buf>
  if(fd < 0){
    40b0:	06054163          	bltz	a0,4112 <bigfile+0xee>
    cc = read(fd, buf, SZ/2);
    40b4:	864e                	mv	a2,s3
    40b6:	85ca                	mv	a1,s2
    40b8:	8556                	mv	a0,s5
    40ba:	5b3000ef          	jal	4e6c <read>
    if(cc < 0){
    40be:	06054463          	bltz	a0,4126 <bigfile+0x102>
    if(cc == 0)
    40c2:	c145                	beqz	a0,4162 <bigfile+0x13e>
    if(cc != SZ/2){
    40c4:	07351b63          	bne	a0,s3,413a <bigfile+0x116>
    if(buf[0] != i/2 || buf[SZ/2-1] != i/2){
    40c8:	01f4d79b          	srliw	a5,s1,0x1f
    40cc:	9fa5                	addw	a5,a5,s1
    40ce:	4017d79b          	sraiw	a5,a5,0x1
    40d2:	00094703          	lbu	a4,0(s2)
    40d6:	06f71c63          	bne	a4,a5,414e <bigfile+0x12a>
    40da:	12b94703          	lbu	a4,299(s2)
    40de:	06f71863          	bne	a4,a5,414e <bigfile+0x12a>
    total += cc;
    40e2:	12ca0a1b          	addiw	s4,s4,300
  for(i = 0; ; i++){
    40e6:	2485                	addiw	s1,s1,1
    cc = read(fd, buf, SZ/2);
    40e8:	b7f1                	j	40b4 <bigfile+0x90>
    printf("%s: cannot create bigfile", s);
    40ea:	85da                	mv	a1,s6
    40ec:	00003517          	auipc	a0,0x3
    40f0:	01c50513          	addi	a0,a0,28 # 7108 <malloc+0x1dae>
    40f4:	1ae010ef          	jal	52a2 <printf>
    exit(1);
    40f8:	4505                	li	a0,1
    40fa:	55b000ef          	jal	4e54 <exit>
      printf("%s: write bigfile failed\n", s);
    40fe:	85da                	mv	a1,s6
    4100:	00003517          	auipc	a0,0x3
    4104:	02850513          	addi	a0,a0,40 # 7128 <malloc+0x1dce>
    4108:	19a010ef          	jal	52a2 <printf>
      exit(1);
    410c:	4505                	li	a0,1
    410e:	547000ef          	jal	4e54 <exit>
    printf("%s: cannot open bigfile\n", s);
    4112:	85da                	mv	a1,s6
    4114:	00003517          	auipc	a0,0x3
    4118:	03450513          	addi	a0,a0,52 # 7148 <malloc+0x1dee>
    411c:	186010ef          	jal	52a2 <printf>
    exit(1);
    4120:	4505                	li	a0,1
    4122:	533000ef          	jal	4e54 <exit>
      printf("%s: read bigfile failed\n", s);
    4126:	85da                	mv	a1,s6
    4128:	00003517          	auipc	a0,0x3
    412c:	04050513          	addi	a0,a0,64 # 7168 <malloc+0x1e0e>
    4130:	172010ef          	jal	52a2 <printf>
      exit(1);
    4134:	4505                	li	a0,1
    4136:	51f000ef          	jal	4e54 <exit>
      printf("%s: short read bigfile\n", s);
    413a:	85da                	mv	a1,s6
    413c:	00003517          	auipc	a0,0x3
    4140:	04c50513          	addi	a0,a0,76 # 7188 <malloc+0x1e2e>
    4144:	15e010ef          	jal	52a2 <printf>
      exit(1);
    4148:	4505                	li	a0,1
    414a:	50b000ef          	jal	4e54 <exit>
      printf("%s: read bigfile wrong data\n", s);
    414e:	85da                	mv	a1,s6
    4150:	00003517          	auipc	a0,0x3
    4154:	05050513          	addi	a0,a0,80 # 71a0 <malloc+0x1e46>
    4158:	14a010ef          	jal	52a2 <printf>
      exit(1);
    415c:	4505                	li	a0,1
    415e:	4f7000ef          	jal	4e54 <exit>
  close(fd);
    4162:	8556                	mv	a0,s5
    4164:	519000ef          	jal	4e7c <close>
  if(total != N*SZ){
    4168:	678d                	lui	a5,0x3
    416a:	ee078793          	addi	a5,a5,-288 # 2ee0 <subdir+0x2a0>
    416e:	02fa1263          	bne	s4,a5,4192 <bigfile+0x16e>
  unlink("bigfile.dat");
    4172:	00003517          	auipc	a0,0x3
    4176:	f8650513          	addi	a0,a0,-122 # 70f8 <malloc+0x1d9e>
    417a:	52b000ef          	jal	4ea4 <unlink>
}
    417e:	70e2                	ld	ra,56(sp)
    4180:	7442                	ld	s0,48(sp)
    4182:	74a2                	ld	s1,40(sp)
    4184:	7902                	ld	s2,32(sp)
    4186:	69e2                	ld	s3,24(sp)
    4188:	6a42                	ld	s4,16(sp)
    418a:	6aa2                	ld	s5,8(sp)
    418c:	6b02                	ld	s6,0(sp)
    418e:	6121                	addi	sp,sp,64
    4190:	8082                	ret
    printf("%s: read bigfile wrong total\n", s);
    4192:	85da                	mv	a1,s6
    4194:	00003517          	auipc	a0,0x3
    4198:	02c50513          	addi	a0,a0,44 # 71c0 <malloc+0x1e66>
    419c:	106010ef          	jal	52a2 <printf>
    exit(1);
    41a0:	4505                	li	a0,1
    41a2:	4b3000ef          	jal	4e54 <exit>

00000000000041a6 <bigargtest>:
{
    41a6:	7121                	addi	sp,sp,-448
    41a8:	ff06                	sd	ra,440(sp)
    41aa:	fb22                	sd	s0,432(sp)
    41ac:	f726                	sd	s1,424(sp)
    41ae:	0380                	addi	s0,sp,448
    41b0:	84aa                	mv	s1,a0
  unlink("bigarg-ok");
    41b2:	00003517          	auipc	a0,0x3
    41b6:	02e50513          	addi	a0,a0,46 # 71e0 <malloc+0x1e86>
    41ba:	4eb000ef          	jal	4ea4 <unlink>
  pid = fork();
    41be:	48f000ef          	jal	4e4c <fork>
  if(pid == 0){
    41c2:	c915                	beqz	a0,41f6 <bigargtest+0x50>
  } else if(pid < 0){
    41c4:	08054c63          	bltz	a0,425c <bigargtest+0xb6>
  wait(&xstatus);
    41c8:	fdc40513          	addi	a0,s0,-36
    41cc:	491000ef          	jal	4e5c <wait>
  if(xstatus != 0)
    41d0:	fdc42503          	lw	a0,-36(s0)
    41d4:	ed51                	bnez	a0,4270 <bigargtest+0xca>
  fd = open("bigarg-ok", 0);
    41d6:	4581                	li	a1,0
    41d8:	00003517          	auipc	a0,0x3
    41dc:	00850513          	addi	a0,a0,8 # 71e0 <malloc+0x1e86>
    41e0:	4b5000ef          	jal	4e94 <open>
  if(fd < 0){
    41e4:	08054863          	bltz	a0,4274 <bigargtest+0xce>
  close(fd);
    41e8:	495000ef          	jal	4e7c <close>
}
    41ec:	70fa                	ld	ra,440(sp)
    41ee:	745a                	ld	s0,432(sp)
    41f0:	74ba                	ld	s1,424(sp)
    41f2:	6139                	addi	sp,sp,448
    41f4:	8082                	ret
    memset(big, ' ', sizeof(big));
    41f6:	19000613          	li	a2,400
    41fa:	02000593          	li	a1,32
    41fe:	e4840513          	addi	a0,s0,-440
    4202:	229000ef          	jal	4c2a <memset>
    big[sizeof(big)-1] = '\0';
    4206:	fc040ba3          	sb	zero,-41(s0)
    for(i = 0; i < MAXARG-1; i++)
    420a:	00005797          	auipc	a5,0x5
    420e:	27678793          	addi	a5,a5,630 # 9480 <args.1>
    4212:	00005697          	auipc	a3,0x5
    4216:	36668693          	addi	a3,a3,870 # 9578 <args.1+0xf8>
      args[i] = big;
    421a:	e4840713          	addi	a4,s0,-440
    421e:	e398                	sd	a4,0(a5)
    for(i = 0; i < MAXARG-1; i++)
    4220:	07a1                	addi	a5,a5,8
    4222:	fed79ee3          	bne	a5,a3,421e <bigargtest+0x78>
    args[MAXARG-1] = 0;
    4226:	00005797          	auipc	a5,0x5
    422a:	3407b923          	sd	zero,850(a5) # 9578 <args.1+0xf8>
    exec("echo", args);
    422e:	00005597          	auipc	a1,0x5
    4232:	25258593          	addi	a1,a1,594 # 9480 <args.1>
    4236:	00001517          	auipc	a0,0x1
    423a:	25250513          	addi	a0,a0,594 # 5488 <malloc+0x12e>
    423e:	44f000ef          	jal	4e8c <exec>
    fd = open("bigarg-ok", O_CREATE);
    4242:	20000593          	li	a1,512
    4246:	00003517          	auipc	a0,0x3
    424a:	f9a50513          	addi	a0,a0,-102 # 71e0 <malloc+0x1e86>
    424e:	447000ef          	jal	4e94 <open>
    close(fd);
    4252:	42b000ef          	jal	4e7c <close>
    exit(0);
    4256:	4501                	li	a0,0
    4258:	3fd000ef          	jal	4e54 <exit>
    printf("%s: bigargtest: fork failed\n", s);
    425c:	85a6                	mv	a1,s1
    425e:	00003517          	auipc	a0,0x3
    4262:	f9250513          	addi	a0,a0,-110 # 71f0 <malloc+0x1e96>
    4266:	03c010ef          	jal	52a2 <printf>
    exit(1);
    426a:	4505                	li	a0,1
    426c:	3e9000ef          	jal	4e54 <exit>
    exit(xstatus);
    4270:	3e5000ef          	jal	4e54 <exit>
    printf("%s: bigarg test failed!\n", s);
    4274:	85a6                	mv	a1,s1
    4276:	00003517          	auipc	a0,0x3
    427a:	f9a50513          	addi	a0,a0,-102 # 7210 <malloc+0x1eb6>
    427e:	024010ef          	jal	52a2 <printf>
    exit(1);
    4282:	4505                	li	a0,1
    4284:	3d1000ef          	jal	4e54 <exit>

0000000000004288 <lazy_alloc>:
{
    4288:	1141                	addi	sp,sp,-16
    428a:	e406                	sd	ra,8(sp)
    428c:	e022                	sd	s0,0(sp)
    428e:	0800                	addi	s0,sp,16
  prev_end = sbrklazy(REGION_SZ);
    4290:	40000537          	lui	a0,0x40000
    4294:	3a3000ef          	jal	4e36 <sbrklazy>
  if (prev_end == (char *) SBRK_ERROR) {
    4298:	57fd                	li	a5,-1
    429a:	02f50a63          	beq	a0,a5,42ce <lazy_alloc+0x46>
  for (i = prev_end + PGSIZE; i < new_end; i += 64 * PGSIZE)
    429e:	6605                	lui	a2,0x1
    42a0:	962a                	add	a2,a2,a0
    42a2:	400017b7          	lui	a5,0x40001
    42a6:	00f50733          	add	a4,a0,a5
    42aa:	87b2                	mv	a5,a2
    42ac:	000406b7          	lui	a3,0x40
    *(char **)i = i;
    42b0:	e39c                	sd	a5,0(a5)
  for (i = prev_end + PGSIZE; i < new_end; i += 64 * PGSIZE)
    42b2:	97b6                	add	a5,a5,a3
    42b4:	fee79ee3          	bne	a5,a4,42b0 <lazy_alloc+0x28>
  for (i = prev_end + PGSIZE; i < new_end; i += 64 * PGSIZE) {
    42b8:	000406b7          	lui	a3,0x40
    if (*(char **)i != i) {
    42bc:	621c                	ld	a5,0(a2)
    42be:	02c79163          	bne	a5,a2,42e0 <lazy_alloc+0x58>
  for (i = prev_end + PGSIZE; i < new_end; i += 64 * PGSIZE) {
    42c2:	9636                	add	a2,a2,a3
    42c4:	fee61ce3          	bne	a2,a4,42bc <lazy_alloc+0x34>
  exit(0);
    42c8:	4501                	li	a0,0
    42ca:	38b000ef          	jal	4e54 <exit>
    printf("sbrklazy() failed\n");
    42ce:	00003517          	auipc	a0,0x3
    42d2:	f6250513          	addi	a0,a0,-158 # 7230 <malloc+0x1ed6>
    42d6:	7cd000ef          	jal	52a2 <printf>
    exit(1);
    42da:	4505                	li	a0,1
    42dc:	379000ef          	jal	4e54 <exit>
      printf("failed to read value from memory\n");
    42e0:	00003517          	auipc	a0,0x3
    42e4:	f6850513          	addi	a0,a0,-152 # 7248 <malloc+0x1eee>
    42e8:	7bb000ef          	jal	52a2 <printf>
      exit(1);
    42ec:	4505                	li	a0,1
    42ee:	367000ef          	jal	4e54 <exit>

00000000000042f2 <lazy_unmap>:
{
    42f2:	7139                	addi	sp,sp,-64
    42f4:	fc06                	sd	ra,56(sp)
    42f6:	f822                	sd	s0,48(sp)
    42f8:	0080                	addi	s0,sp,64
  prev_end = sbrklazy(REGION_SZ);
    42fa:	40000537          	lui	a0,0x40000
    42fe:	339000ef          	jal	4e36 <sbrklazy>
  if (prev_end == (char*)SBRK_ERROR) {
    4302:	57fd                	li	a5,-1
    4304:	04f50863          	beq	a0,a5,4354 <lazy_unmap+0x62>
    4308:	f426                	sd	s1,40(sp)
    430a:	f04a                	sd	s2,32(sp)
    430c:	ec4e                	sd	s3,24(sp)
    430e:	e852                	sd	s4,16(sp)
  for (i = prev_end + PGSIZE; i < new_end; i += PGSIZE * PGSIZE)
    4310:	6905                	lui	s2,0x1
    4312:	992a                	add	s2,s2,a0
    4314:	400017b7          	lui	a5,0x40001
    4318:	00f504b3          	add	s1,a0,a5
    431c:	87ca                	mv	a5,s2
    431e:	01000737          	lui	a4,0x1000
    *(char **)i = i;
    4322:	e39c                	sd	a5,0(a5)
  for (i = prev_end + PGSIZE; i < new_end; i += PGSIZE * PGSIZE)
    4324:	97ba                	add	a5,a5,a4
    4326:	fe979ee3          	bne	a5,s1,4322 <lazy_unmap+0x30>
      wait(&status);
    432a:	fcc40993          	addi	s3,s0,-52
  for (i = prev_end + PGSIZE; i < new_end; i += PGSIZE * PGSIZE) {
    432e:	01000a37          	lui	s4,0x1000
    pid = fork();
    4332:	31b000ef          	jal	4e4c <fork>
    if (pid < 0) {
    4336:	02054c63          	bltz	a0,436e <lazy_unmap+0x7c>
    } else if (pid == 0) {
    433a:	c139                	beqz	a0,4380 <lazy_unmap+0x8e>
      wait(&status);
    433c:	854e                	mv	a0,s3
    433e:	31f000ef          	jal	4e5c <wait>
      if (status == 0) {
    4342:	fcc42783          	lw	a5,-52(s0)
    4346:	c7b1                	beqz	a5,4392 <lazy_unmap+0xa0>
  for (i = prev_end + PGSIZE; i < new_end; i += PGSIZE * PGSIZE) {
    4348:	9952                	add	s2,s2,s4
    434a:	fe9914e3          	bne	s2,s1,4332 <lazy_unmap+0x40>
  exit(0);
    434e:	4501                	li	a0,0
    4350:	305000ef          	jal	4e54 <exit>
    4354:	f426                	sd	s1,40(sp)
    4356:	f04a                	sd	s2,32(sp)
    4358:	ec4e                	sd	s3,24(sp)
    435a:	e852                	sd	s4,16(sp)
    printf("sbrklazy() failed\n");
    435c:	00003517          	auipc	a0,0x3
    4360:	ed450513          	addi	a0,a0,-300 # 7230 <malloc+0x1ed6>
    4364:	73f000ef          	jal	52a2 <printf>
    exit(1);
    4368:	4505                	li	a0,1
    436a:	2eb000ef          	jal	4e54 <exit>
      printf("error forking\n");
    436e:	00003517          	auipc	a0,0x3
    4372:	f0250513          	addi	a0,a0,-254 # 7270 <malloc+0x1f16>
    4376:	72d000ef          	jal	52a2 <printf>
      exit(1);
    437a:	4505                	li	a0,1
    437c:	2d9000ef          	jal	4e54 <exit>
      sbrklazy(-1L * REGION_SZ);
    4380:	c0000537          	lui	a0,0xc0000
    4384:	2b3000ef          	jal	4e36 <sbrklazy>
      *(char **)i = i;
    4388:	01293023          	sd	s2,0(s2) # 1000 <bigdir+0x10c>
      exit(0);
    438c:	4501                	li	a0,0
    438e:	2c7000ef          	jal	4e54 <exit>
        printf("memory not unmapped\n");
    4392:	00003517          	auipc	a0,0x3
    4396:	eee50513          	addi	a0,a0,-274 # 7280 <malloc+0x1f26>
    439a:	709000ef          	jal	52a2 <printf>
        exit(1);
    439e:	4505                	li	a0,1
    43a0:	2b5000ef          	jal	4e54 <exit>

00000000000043a4 <lazy_copy>:
{
    43a4:	7119                	addi	sp,sp,-128
    43a6:	fc86                	sd	ra,120(sp)
    43a8:	f8a2                	sd	s0,112(sp)
    43aa:	f4a6                	sd	s1,104(sp)
    43ac:	f0ca                	sd	s2,96(sp)
    43ae:	ecce                	sd	s3,88(sp)
    43b0:	e8d2                	sd	s4,80(sp)
    43b2:	e4d6                	sd	s5,72(sp)
    43b4:	e0da                	sd	s6,64(sp)
    43b6:	fc5e                	sd	s7,56(sp)
    43b8:	0100                	addi	s0,sp,128
    char *p = sbrk(0);
    43ba:	4501                	li	a0,0
    43bc:	265000ef          	jal	4e20 <sbrk>
    43c0:	84aa                	mv	s1,a0
    sbrklazy(4*PGSIZE);
    43c2:	6511                	lui	a0,0x4
    43c4:	273000ef          	jal	4e36 <sbrklazy>
    open(p + 8192, 0);
    43c8:	4581                	li	a1,0
    43ca:	6509                	lui	a0,0x2
    43cc:	9526                	add	a0,a0,s1
    43ce:	2c7000ef          	jal	4e94 <open>
    void *xx = sbrk(0);
    43d2:	4501                	li	a0,0
    43d4:	24d000ef          	jal	4e20 <sbrk>
    43d8:	84aa                	mv	s1,a0
    void *ret = sbrk(-(((uint64) xx)+1));
    43da:	fff54513          	not	a0,a0
    43de:	2501                	sext.w	a0,a0
    43e0:	241000ef          	jal	4e20 <sbrk>
    if(ret != xx){
    43e4:	00a48c63          	beq	s1,a0,43fc <lazy_copy+0x58>
    43e8:	85aa                	mv	a1,a0
      printf("sbrk(sbrk(0)+1) returned %p, not old sz\n", ret);
    43ea:	00003517          	auipc	a0,0x3
    43ee:	eae50513          	addi	a0,a0,-338 # 7298 <malloc+0x1f3e>
    43f2:	6b1000ef          	jal	52a2 <printf>
      exit(1);
    43f6:	4505                	li	a0,1
    43f8:	25d000ef          	jal	4e54 <exit>
  unsigned long bad[] = {
    43fc:	00003797          	auipc	a5,0x3
    4400:	53478793          	addi	a5,a5,1332 # 7930 <malloc+0x25d6>
    4404:	7fa8                	ld	a0,120(a5)
    4406:	63cc                	ld	a1,128(a5)
    4408:	67d0                	ld	a2,136(a5)
    440a:	6bd4                	ld	a3,144(a5)
    440c:	6fd8                	ld	a4,152(a5)
    440e:	f8a43023          	sd	a0,-128(s0)
    4412:	f8b43423          	sd	a1,-120(s0)
    4416:	f8c43823          	sd	a2,-112(s0)
    441a:	f8d43c23          	sd	a3,-104(s0)
    441e:	fae43023          	sd	a4,-96(s0)
    4422:	73dc                	ld	a5,160(a5)
    4424:	faf43423          	sd	a5,-88(s0)
  for(int i = 0; i < sizeof(bad)/sizeof(bad[0]); i++){
    4428:	f8040913          	addi	s2,s0,-128
    int fd = open("README", 0);
    442c:	00001a97          	auipc	s5,0x1
    4430:	234a8a93          	addi	s5,s5,564 # 5660 <malloc+0x306>
    if(read(fd, (char*)bad[i], 512) >= 0) { printf("read succeeded\n");  exit(1); }
    4434:	20000a13          	li	s4,512
    fd = open("junk", O_CREATE|O_RDWR|O_TRUNC);
    4438:	60200b93          	li	s7,1538
    443c:	00001b17          	auipc	s6,0x1
    4440:	134b0b13          	addi	s6,s6,308 # 5570 <malloc+0x216>
    int fd = open("README", 0);
    4444:	4581                	li	a1,0
    4446:	8556                	mv	a0,s5
    4448:	24d000ef          	jal	4e94 <open>
    444c:	84aa                	mv	s1,a0
    if(fd < 0) { printf("cannot open README\n"); exit(1); }
    444e:	04054563          	bltz	a0,4498 <lazy_copy+0xf4>
    if(read(fd, (char*)bad[i], 512) >= 0) { printf("read succeeded\n");  exit(1); }
    4452:	00093983          	ld	s3,0(s2)
    4456:	8652                	mv	a2,s4
    4458:	85ce                	mv	a1,s3
    445a:	213000ef          	jal	4e6c <read>
    445e:	04055663          	bgez	a0,44aa <lazy_copy+0x106>
    close(fd);
    4462:	8526                	mv	a0,s1
    4464:	219000ef          	jal	4e7c <close>
    fd = open("junk", O_CREATE|O_RDWR|O_TRUNC);
    4468:	85de                	mv	a1,s7
    446a:	855a                	mv	a0,s6
    446c:	229000ef          	jal	4e94 <open>
    4470:	84aa                	mv	s1,a0
    if(fd < 0) { printf("cannot open junk\n"); exit(1); }
    4472:	04054563          	bltz	a0,44bc <lazy_copy+0x118>
    if(write(fd, (char*)bad[i], 512) >= 0) { printf("write succeeded\n"); exit(1); }
    4476:	8652                	mv	a2,s4
    4478:	85ce                	mv	a1,s3
    447a:	1fb000ef          	jal	4e74 <write>
    447e:	04055863          	bgez	a0,44ce <lazy_copy+0x12a>
    close(fd);
    4482:	8526                	mv	a0,s1
    4484:	1f9000ef          	jal	4e7c <close>
  for(int i = 0; i < sizeof(bad)/sizeof(bad[0]); i++){
    4488:	0921                	addi	s2,s2,8
    448a:	fb040793          	addi	a5,s0,-80
    448e:	faf91be3          	bne	s2,a5,4444 <lazy_copy+0xa0>
  exit(0);
    4492:	4501                	li	a0,0
    4494:	1c1000ef          	jal	4e54 <exit>
    if(fd < 0) { printf("cannot open README\n"); exit(1); }
    4498:	00003517          	auipc	a0,0x3
    449c:	e3050513          	addi	a0,a0,-464 # 72c8 <malloc+0x1f6e>
    44a0:	603000ef          	jal	52a2 <printf>
    44a4:	4505                	li	a0,1
    44a6:	1af000ef          	jal	4e54 <exit>
    if(read(fd, (char*)bad[i], 512) >= 0) { printf("read succeeded\n");  exit(1); }
    44aa:	00003517          	auipc	a0,0x3
    44ae:	e3650513          	addi	a0,a0,-458 # 72e0 <malloc+0x1f86>
    44b2:	5f1000ef          	jal	52a2 <printf>
    44b6:	4505                	li	a0,1
    44b8:	19d000ef          	jal	4e54 <exit>
    if(fd < 0) { printf("cannot open junk\n"); exit(1); }
    44bc:	00003517          	auipc	a0,0x3
    44c0:	e3450513          	addi	a0,a0,-460 # 72f0 <malloc+0x1f96>
    44c4:	5df000ef          	jal	52a2 <printf>
    44c8:	4505                	li	a0,1
    44ca:	18b000ef          	jal	4e54 <exit>
    if(write(fd, (char*)bad[i], 512) >= 0) { printf("write succeeded\n"); exit(1); }
    44ce:	00003517          	auipc	a0,0x3
    44d2:	e3a50513          	addi	a0,a0,-454 # 7308 <malloc+0x1fae>
    44d6:	5cd000ef          	jal	52a2 <printf>
    44da:	4505                	li	a0,1
    44dc:	179000ef          	jal	4e54 <exit>

00000000000044e0 <lazy_sbrk>:
{
    44e0:	7179                	addi	sp,sp,-48
    44e2:	f406                	sd	ra,40(sp)
    44e4:	f022                	sd	s0,32(sp)
    44e6:	ec26                	sd	s1,24(sp)
    44e8:	e84a                	sd	s2,16(sp)
    44ea:	e44e                	sd	s3,8(sp)
    44ec:	1800                	addi	s0,sp,48
  char *p = sbrk(0);
    44ee:	4501                	li	a0,0
    44f0:	131000ef          	jal	4e20 <sbrk>
    44f4:	84aa                	mv	s1,a0
  while ((uint64)p < MAXVA-(1<<30)) {
    44f6:	0ff00793          	li	a5,255
    44fa:	07fa                	slli	a5,a5,0x1e
    44fc:	00f57e63          	bgeu	a0,a5,4518 <lazy_sbrk+0x38>
    p = sbrklazy(1<<30);
    4500:	400009b7          	lui	s3,0x40000
  while ((uint64)p < MAXVA-(1<<30)) {
    4504:	893e                	mv	s2,a5
    p = sbrklazy(1<<30);
    4506:	854e                	mv	a0,s3
    4508:	12f000ef          	jal	4e36 <sbrklazy>
    p = sbrklazy(0);
    450c:	4501                	li	a0,0
    450e:	129000ef          	jal	4e36 <sbrklazy>
    4512:	84aa                	mv	s1,a0
  while ((uint64)p < MAXVA-(1<<30)) {
    4514:	ff2569e3          	bltu	a0,s2,4506 <lazy_sbrk+0x26>
  int n = TRAPFRAME-PGSIZE-(uint64)p;
    4518:	7975                	lui	s2,0xffffd
    451a:	4099093b          	subw	s2,s2,s1
  char *p1 = sbrklazy(n);
    451e:	854a                	mv	a0,s2
    4520:	117000ef          	jal	4e36 <sbrklazy>
    4524:	862a                	mv	a2,a0
  if (p1 < 0 || p1 != p) {
    4526:	00950d63          	beq	a0,s1,4540 <lazy_sbrk+0x60>
    printf("sbrklazy(%d) returned %p, not expected %p\n", n, p1, p);
    452a:	86a6                	mv	a3,s1
    452c:	85ca                	mv	a1,s2
    452e:	00003517          	auipc	a0,0x3
    4532:	df250513          	addi	a0,a0,-526 # 7320 <malloc+0x1fc6>
    4536:	56d000ef          	jal	52a2 <printf>
    exit(1);
    453a:	4505                	li	a0,1
    453c:	119000ef          	jal	4e54 <exit>
  p = sbrk(PGSIZE);
    4540:	6505                	lui	a0,0x1
    4542:	0df000ef          	jal	4e20 <sbrk>
    4546:	862a                	mv	a2,a0
  if (p < 0 || (uint64)p != TRAPFRAME-PGSIZE) {
    4548:	040007b7          	lui	a5,0x4000
    454c:	17f5                	addi	a5,a5,-3 # 3fffffd <base+0x3ff0365>
    454e:	07b2                	slli	a5,a5,0xc
    4550:	00f50c63          	beq	a0,a5,4568 <lazy_sbrk+0x88>
    printf("sbrk(%d) returned %p, not expected TRAPFRAME-PGSIZE\n", PGSIZE, p);
    4554:	6585                	lui	a1,0x1
    4556:	00003517          	auipc	a0,0x3
    455a:	dfa50513          	addi	a0,a0,-518 # 7350 <malloc+0x1ff6>
    455e:	545000ef          	jal	52a2 <printf>
    exit(1);
    4562:	4505                	li	a0,1
    4564:	0f1000ef          	jal	4e54 <exit>
  p[0] = 1;
    4568:	040007b7          	lui	a5,0x4000
    456c:	17f5                	addi	a5,a5,-3 # 3fffffd <base+0x3ff0365>
    456e:	07b2                	slli	a5,a5,0xc
    4570:	4705                	li	a4,1
    4572:	00e78023          	sb	a4,0(a5)
  if (p[1] != 0) {
    4576:	0017c783          	lbu	a5,1(a5)
    457a:	cb91                	beqz	a5,458e <lazy_sbrk+0xae>
    printf("sbrk() returned non-zero-filled memory\n");
    457c:	00003517          	auipc	a0,0x3
    4580:	e0c50513          	addi	a0,a0,-500 # 7388 <malloc+0x202e>
    4584:	51f000ef          	jal	52a2 <printf>
    exit(1);
    4588:	4505                	li	a0,1
    458a:	0cb000ef          	jal	4e54 <exit>
  p = sbrk(1);
    458e:	4505                	li	a0,1
    4590:	091000ef          	jal	4e20 <sbrk>
    4594:	85aa                	mv	a1,a0
  if ((uint64)p != -1) {
    4596:	57fd                	li	a5,-1
    4598:	00f50b63          	beq	a0,a5,45ae <lazy_sbrk+0xce>
    printf("sbrk(1) returned %p, expected error\n", p);
    459c:	00003517          	auipc	a0,0x3
    45a0:	e1450513          	addi	a0,a0,-492 # 73b0 <malloc+0x2056>
    45a4:	4ff000ef          	jal	52a2 <printf>
    exit(1);
    45a8:	4505                	li	a0,1
    45aa:	0ab000ef          	jal	4e54 <exit>
  p = sbrklazy(1);
    45ae:	4505                	li	a0,1
    45b0:	087000ef          	jal	4e36 <sbrklazy>
    45b4:	85aa                	mv	a1,a0
  if ((uint64)p != -1) {
    45b6:	57fd                	li	a5,-1
    45b8:	00f50b63          	beq	a0,a5,45ce <lazy_sbrk+0xee>
    printf("sbrklazy(1) returned %p, expected error\n", p);
    45bc:	00003517          	auipc	a0,0x3
    45c0:	e1c50513          	addi	a0,a0,-484 # 73d8 <malloc+0x207e>
    45c4:	4df000ef          	jal	52a2 <printf>
    exit(1);
    45c8:	4505                	li	a0,1
    45ca:	08b000ef          	jal	4e54 <exit>
  exit(0);
    45ce:	4501                	li	a0,0
    45d0:	085000ef          	jal	4e54 <exit>

00000000000045d4 <sbrkfail>:
{
    45d4:	1141                	addi	sp,sp,-16
    45d6:	e406                	sd	ra,8(sp)
    45d8:	e022                	sd	s0,0(sp)
    45da:	0800                	addi	s0,sp,16
    exit(1);
    45dc:	4505                	li	a0,1
    45de:	077000ef          	jal	4e54 <exit>

00000000000045e2 <sbrkarg>:
{
    45e2:	7179                	addi	sp,sp,-48
    45e4:	f406                	sd	ra,40(sp)
    45e6:	f022                	sd	s0,32(sp)
    45e8:	ec26                	sd	s1,24(sp)
    45ea:	e84a                	sd	s2,16(sp)
    45ec:	e44e                	sd	s3,8(sp)
    45ee:	1800                	addi	s0,sp,48
    45f0:	89aa                	mv	s3,a0
  a = sbrk(PGSIZE);
    45f2:	6505                	lui	a0,0x1
    45f4:	02d000ef          	jal	4e20 <sbrk>
    45f8:	892a                	mv	s2,a0
  fd = open("sbrk", O_CREATE|O_WRONLY);
    45fa:	20100593          	li	a1,513
    45fe:	00003517          	auipc	a0,0x3
    4602:	e0a50513          	addi	a0,a0,-502 # 7408 <malloc+0x20ae>
    4606:	08f000ef          	jal	4e94 <open>
    460a:	84aa                	mv	s1,a0
  unlink("sbrk");
    460c:	00003517          	auipc	a0,0x3
    4610:	dfc50513          	addi	a0,a0,-516 # 7408 <malloc+0x20ae>
    4614:	091000ef          	jal	4ea4 <unlink>
  if(fd < 0)  {
    4618:	0204c963          	bltz	s1,464a <sbrkarg+0x68>
  if ((n = write(fd, a, PGSIZE)) < 0) {
    461c:	6605                	lui	a2,0x1
    461e:	85ca                	mv	a1,s2
    4620:	8526                	mv	a0,s1
    4622:	053000ef          	jal	4e74 <write>
    4626:	02054c63          	bltz	a0,465e <sbrkarg+0x7c>
  close(fd);
    462a:	8526                	mv	a0,s1
    462c:	051000ef          	jal	4e7c <close>
  a = sbrk(PGSIZE);
    4630:	6505                	lui	a0,0x1
    4632:	7ee000ef          	jal	4e20 <sbrk>
  if(pipe((int *) a) != 0){
    4636:	02f000ef          	jal	4e64 <pipe>
    463a:	ed05                	bnez	a0,4672 <sbrkarg+0x90>
}
    463c:	70a2                	ld	ra,40(sp)
    463e:	7402                	ld	s0,32(sp)
    4640:	64e2                	ld	s1,24(sp)
    4642:	6942                	ld	s2,16(sp)
    4644:	69a2                	ld	s3,8(sp)
    4646:	6145                	addi	sp,sp,48
    4648:	8082                	ret
    printf("%s: open sbrk failed\n", s);
    464a:	85ce                	mv	a1,s3
    464c:	00003517          	auipc	a0,0x3
    4650:	dc450513          	addi	a0,a0,-572 # 7410 <malloc+0x20b6>
    4654:	44f000ef          	jal	52a2 <printf>
    exit(1);
    4658:	4505                	li	a0,1
    465a:	7fa000ef          	jal	4e54 <exit>
    printf("%s: write sbrk failed\n", s);
    465e:	85ce                	mv	a1,s3
    4660:	00003517          	auipc	a0,0x3
    4664:	dc850513          	addi	a0,a0,-568 # 7428 <malloc+0x20ce>
    4668:	43b000ef          	jal	52a2 <printf>
    exit(1);
    466c:	4505                	li	a0,1
    466e:	7e6000ef          	jal	4e54 <exit>
    printf("%s: pipe() failed\n", s);
    4672:	85ce                	mv	a1,s3
    4674:	00001517          	auipc	a0,0x1
    4678:	7ac50513          	addi	a0,a0,1964 # 5e20 <malloc+0xac6>
    467c:	427000ef          	jal	52a2 <printf>
    exit(1);
    4680:	4505                	li	a0,1
    4682:	7d2000ef          	jal	4e54 <exit>

0000000000004686 <fsfull>:
{
    4686:	7171                	addi	sp,sp,-176
    4688:	f506                	sd	ra,168(sp)
    468a:	f122                	sd	s0,160(sp)
    468c:	ed26                	sd	s1,152(sp)
    468e:	e94a                	sd	s2,144(sp)
    4690:	e54e                	sd	s3,136(sp)
    4692:	e152                	sd	s4,128(sp)
    4694:	fcd6                	sd	s5,120(sp)
    4696:	f8da                	sd	s6,112(sp)
    4698:	f4de                	sd	s7,104(sp)
    469a:	f0e2                	sd	s8,96(sp)
    469c:	ece6                	sd	s9,88(sp)
    469e:	e8ea                	sd	s10,80(sp)
    46a0:	e4ee                	sd	s11,72(sp)
    46a2:	1900                	addi	s0,sp,176
  printf("fsfull test\n");
    46a4:	00003517          	auipc	a0,0x3
    46a8:	d9c50513          	addi	a0,a0,-612 # 7440 <malloc+0x20e6>
    46ac:	3f7000ef          	jal	52a2 <printf>
  for(nfiles = 0; ; nfiles++){
    46b0:	4481                	li	s1,0
    name[0] = 'f';
    46b2:	06600d93          	li	s11,102
    name[1] = '0' + nfiles / 1000;
    46b6:	10625cb7          	lui	s9,0x10625
    46ba:	dd3c8c93          	addi	s9,s9,-557 # 10624dd3 <base+0x1061513b>
    name[2] = '0' + (nfiles % 1000) / 100;
    46be:	51eb8ab7          	lui	s5,0x51eb8
    46c2:	51fa8a93          	addi	s5,s5,1311 # 51eb851f <base+0x51ea8887>
    name[3] = '0' + (nfiles % 100) / 10;
    46c6:	66666a37          	lui	s4,0x66666
    46ca:	667a0a13          	addi	s4,s4,1639 # 66666667 <base+0x666569cf>
    printf("writing %s\n", name);
    46ce:	f5040d13          	addi	s10,s0,-176
    name[0] = 'f';
    46d2:	f5b40823          	sb	s11,-176(s0)
    name[1] = '0' + nfiles / 1000;
    46d6:	039487b3          	mul	a5,s1,s9
    46da:	9799                	srai	a5,a5,0x26
    46dc:	41f4d69b          	sraiw	a3,s1,0x1f
    46e0:	9f95                	subw	a5,a5,a3
    46e2:	0307871b          	addiw	a4,a5,48
    46e6:	f4e408a3          	sb	a4,-175(s0)
    name[2] = '0' + (nfiles % 1000) / 100;
    46ea:	3e800713          	li	a4,1000
    46ee:	02f707bb          	mulw	a5,a4,a5
    46f2:	40f487bb          	subw	a5,s1,a5
    46f6:	03578733          	mul	a4,a5,s5
    46fa:	9715                	srai	a4,a4,0x25
    46fc:	41f7d79b          	sraiw	a5,a5,0x1f
    4700:	40f707bb          	subw	a5,a4,a5
    4704:	0307879b          	addiw	a5,a5,48
    4708:	f4f40923          	sb	a5,-174(s0)
    name[3] = '0' + (nfiles % 100) / 10;
    470c:	035487b3          	mul	a5,s1,s5
    4710:	9795                	srai	a5,a5,0x25
    4712:	9f95                	subw	a5,a5,a3
    4714:	06400713          	li	a4,100
    4718:	02f707bb          	mulw	a5,a4,a5
    471c:	40f487bb          	subw	a5,s1,a5
    4720:	03478733          	mul	a4,a5,s4
    4724:	9709                	srai	a4,a4,0x22
    4726:	41f7d79b          	sraiw	a5,a5,0x1f
    472a:	40f707bb          	subw	a5,a4,a5
    472e:	0307879b          	addiw	a5,a5,48
    4732:	f4f409a3          	sb	a5,-173(s0)
    name[4] = '0' + (nfiles % 10);
    4736:	03448733          	mul	a4,s1,s4
    473a:	9709                	srai	a4,a4,0x22
    473c:	9f15                	subw	a4,a4,a3
    473e:	0027179b          	slliw	a5,a4,0x2
    4742:	9fb9                	addw	a5,a5,a4
    4744:	0017979b          	slliw	a5,a5,0x1
    4748:	40f487bb          	subw	a5,s1,a5
    474c:	0307879b          	addiw	a5,a5,48
    4750:	f4f40a23          	sb	a5,-172(s0)
    name[5] = '\0';
    4754:	f4040aa3          	sb	zero,-171(s0)
    printf("writing %s\n", name);
    4758:	85ea                	mv	a1,s10
    475a:	00003517          	auipc	a0,0x3
    475e:	cf650513          	addi	a0,a0,-778 # 7450 <malloc+0x20f6>
    4762:	341000ef          	jal	52a2 <printf>
    int fd = open(name, O_CREATE|O_RDWR);
    4766:	20200593          	li	a1,514
    476a:	856a                	mv	a0,s10
    476c:	728000ef          	jal	4e94 <open>
    4770:	892a                	mv	s2,a0
    if(fd < 0){
    4772:	0e055b63          	bgez	a0,4868 <fsfull+0x1e2>
      printf("open %s failed\n", name);
    4776:	f5040593          	addi	a1,s0,-176
    477a:	00003517          	auipc	a0,0x3
    477e:	ce650513          	addi	a0,a0,-794 # 7460 <malloc+0x2106>
    4782:	321000ef          	jal	52a2 <printf>
  while(nfiles >= 0){
    4786:	0a04cc63          	bltz	s1,483e <fsfull+0x1b8>
    name[0] = 'f';
    478a:	06600c13          	li	s8,102
    name[1] = '0' + nfiles / 1000;
    478e:	10625a37          	lui	s4,0x10625
    4792:	dd3a0a13          	addi	s4,s4,-557 # 10624dd3 <base+0x1061513b>
    name[2] = '0' + (nfiles % 1000) / 100;
    4796:	3e800b93          	li	s7,1000
    479a:	51eb89b7          	lui	s3,0x51eb8
    479e:	51f98993          	addi	s3,s3,1311 # 51eb851f <base+0x51ea8887>
    name[3] = '0' + (nfiles % 100) / 10;
    47a2:	06400b13          	li	s6,100
    47a6:	66666937          	lui	s2,0x66666
    47aa:	66790913          	addi	s2,s2,1639 # 66666667 <base+0x666569cf>
    unlink(name);
    47ae:	f5040a93          	addi	s5,s0,-176
    name[0] = 'f';
    47b2:	f5840823          	sb	s8,-176(s0)
    name[1] = '0' + nfiles / 1000;
    47b6:	034487b3          	mul	a5,s1,s4
    47ba:	9799                	srai	a5,a5,0x26
    47bc:	41f4d69b          	sraiw	a3,s1,0x1f
    47c0:	9f95                	subw	a5,a5,a3
    47c2:	0307871b          	addiw	a4,a5,48
    47c6:	f4e408a3          	sb	a4,-175(s0)
    name[2] = '0' + (nfiles % 1000) / 100;
    47ca:	02fb87bb          	mulw	a5,s7,a5
    47ce:	40f487bb          	subw	a5,s1,a5
    47d2:	03378733          	mul	a4,a5,s3
    47d6:	9715                	srai	a4,a4,0x25
    47d8:	41f7d79b          	sraiw	a5,a5,0x1f
    47dc:	40f707bb          	subw	a5,a4,a5
    47e0:	0307879b          	addiw	a5,a5,48
    47e4:	f4f40923          	sb	a5,-174(s0)
    name[3] = '0' + (nfiles % 100) / 10;
    47e8:	033487b3          	mul	a5,s1,s3
    47ec:	9795                	srai	a5,a5,0x25
    47ee:	9f95                	subw	a5,a5,a3
    47f0:	02fb07bb          	mulw	a5,s6,a5
    47f4:	40f487bb          	subw	a5,s1,a5
    47f8:	03278733          	mul	a4,a5,s2
    47fc:	9709                	srai	a4,a4,0x22
    47fe:	41f7d79b          	sraiw	a5,a5,0x1f
    4802:	40f707bb          	subw	a5,a4,a5
    4806:	0307879b          	addiw	a5,a5,48
    480a:	f4f409a3          	sb	a5,-173(s0)
    name[4] = '0' + (nfiles % 10);
    480e:	03248733          	mul	a4,s1,s2
    4812:	9709                	srai	a4,a4,0x22
    4814:	9f15                	subw	a4,a4,a3
    4816:	0027179b          	slliw	a5,a4,0x2
    481a:	9fb9                	addw	a5,a5,a4
    481c:	0017979b          	slliw	a5,a5,0x1
    4820:	40f487bb          	subw	a5,s1,a5
    4824:	0307879b          	addiw	a5,a5,48
    4828:	f4f40a23          	sb	a5,-172(s0)
    name[5] = '\0';
    482c:	f4040aa3          	sb	zero,-171(s0)
    unlink(name);
    4830:	8556                	mv	a0,s5
    4832:	672000ef          	jal	4ea4 <unlink>
    nfiles--;
    4836:	34fd                	addiw	s1,s1,-1
  while(nfiles >= 0){
    4838:	57fd                	li	a5,-1
    483a:	f6f49ce3          	bne	s1,a5,47b2 <fsfull+0x12c>
  printf("fsfull test finished\n");
    483e:	00003517          	auipc	a0,0x3
    4842:	c4250513          	addi	a0,a0,-958 # 7480 <malloc+0x2126>
    4846:	25d000ef          	jal	52a2 <printf>
}
    484a:	70aa                	ld	ra,168(sp)
    484c:	740a                	ld	s0,160(sp)
    484e:	64ea                	ld	s1,152(sp)
    4850:	694a                	ld	s2,144(sp)
    4852:	69aa                	ld	s3,136(sp)
    4854:	6a0a                	ld	s4,128(sp)
    4856:	7ae6                	ld	s5,120(sp)
    4858:	7b46                	ld	s6,112(sp)
    485a:	7ba6                	ld	s7,104(sp)
    485c:	7c06                	ld	s8,96(sp)
    485e:	6ce6                	ld	s9,88(sp)
    4860:	6d46                	ld	s10,80(sp)
    4862:	6da6                	ld	s11,72(sp)
    4864:	614d                	addi	sp,sp,176
    4866:	8082                	ret
    int total = 0;
    4868:	4981                	li	s3,0
      int cc = write(fd, buf, BSIZE);
    486a:	40000c13          	li	s8,1024
    486e:	00008b97          	auipc	s7,0x8
    4872:	42ab8b93          	addi	s7,s7,1066 # cc98 <buf>
      if(cc < BSIZE)
    4876:	3ff00b13          	li	s6,1023
      int cc = write(fd, buf, BSIZE);
    487a:	8662                	mv	a2,s8
    487c:	85de                	mv	a1,s7
    487e:	854a                	mv	a0,s2
    4880:	5f4000ef          	jal	4e74 <write>
      if(cc < BSIZE)
    4884:	00ab5563          	bge	s6,a0,488e <fsfull+0x208>
      total += cc;
    4888:	00a989bb          	addw	s3,s3,a0
    while(1){
    488c:	b7fd                	j	487a <fsfull+0x1f4>
    printf("wrote %d bytes\n", total);
    488e:	85ce                	mv	a1,s3
    4890:	00003517          	auipc	a0,0x3
    4894:	be050513          	addi	a0,a0,-1056 # 7470 <malloc+0x2116>
    4898:	20b000ef          	jal	52a2 <printf>
    close(fd);
    489c:	854a                	mv	a0,s2
    489e:	5de000ef          	jal	4e7c <close>
    if(total == 0)
    48a2:	ee0982e3          	beqz	s3,4786 <fsfull+0x100>
  for(nfiles = 0; ; nfiles++){
    48a6:	2485                	addiw	s1,s1,1
    48a8:	b52d                	j	46d2 <fsfull+0x4c>

00000000000048aa <run>:
//

// run each test in its own process. run returns 1 if child's exit()
// indicates success.
int
run(void f(char *), char *s) {
    48aa:	7179                	addi	sp,sp,-48
    48ac:	f406                	sd	ra,40(sp)
    48ae:	f022                	sd	s0,32(sp)
    48b0:	ec26                	sd	s1,24(sp)
    48b2:	e84a                	sd	s2,16(sp)
    48b4:	1800                	addi	s0,sp,48
    48b6:	84aa                	mv	s1,a0
    48b8:	892e                	mv	s2,a1
  int pid;
  int xstatus;

  printf("test %s: ", s);
    48ba:	00003517          	auipc	a0,0x3
    48be:	bde50513          	addi	a0,a0,-1058 # 7498 <malloc+0x213e>
    48c2:	1e1000ef          	jal	52a2 <printf>
  if((pid = fork()) < 0) {
    48c6:	586000ef          	jal	4e4c <fork>
    48ca:	02054a63          	bltz	a0,48fe <run+0x54>
    printf("runtest: fork error\n");
    exit(1);
  }
  if(pid == 0) {
    48ce:	c129                	beqz	a0,4910 <run+0x66>
    f(s);
    exit(0);
  } else {
    wait(&xstatus);
    48d0:	fdc40513          	addi	a0,s0,-36
    48d4:	588000ef          	jal	4e5c <wait>
    if(xstatus != 0) 
    48d8:	fdc42783          	lw	a5,-36(s0)
    48dc:	cf9d                	beqz	a5,491a <run+0x70>
      printf("FAILED\n");
    48de:	00003517          	auipc	a0,0x3
    48e2:	be250513          	addi	a0,a0,-1054 # 74c0 <malloc+0x2166>
    48e6:	1bd000ef          	jal	52a2 <printf>
    else
      printf("OK\n");
    return xstatus == 0;
    48ea:	fdc42503          	lw	a0,-36(s0)
  }
}
    48ee:	00153513          	seqz	a0,a0
    48f2:	70a2                	ld	ra,40(sp)
    48f4:	7402                	ld	s0,32(sp)
    48f6:	64e2                	ld	s1,24(sp)
    48f8:	6942                	ld	s2,16(sp)
    48fa:	6145                	addi	sp,sp,48
    48fc:	8082                	ret
    printf("runtest: fork error\n");
    48fe:	00003517          	auipc	a0,0x3
    4902:	baa50513          	addi	a0,a0,-1110 # 74a8 <malloc+0x214e>
    4906:	19d000ef          	jal	52a2 <printf>
    exit(1);
    490a:	4505                	li	a0,1
    490c:	548000ef          	jal	4e54 <exit>
    f(s);
    4910:	854a                	mv	a0,s2
    4912:	9482                	jalr	s1
    exit(0);
    4914:	4501                	li	a0,0
    4916:	53e000ef          	jal	4e54 <exit>
      printf("OK\n");
    491a:	00003517          	auipc	a0,0x3
    491e:	bae50513          	addi	a0,a0,-1106 # 74c8 <malloc+0x216e>
    4922:	181000ef          	jal	52a2 <printf>
    4926:	b7d1                	j	48ea <run+0x40>

0000000000004928 <runtests>:

int
runtests(struct test *tests, char *justone, int continuous) {
    4928:	7179                	addi	sp,sp,-48
    492a:	f406                	sd	ra,40(sp)
    492c:	f022                	sd	s0,32(sp)
    492e:	ec26                	sd	s1,24(sp)
    4930:	e44e                	sd	s3,8(sp)
    4932:	1800                	addi	s0,sp,48
    4934:	84aa                	mv	s1,a0
  int ntests = 0;
  for (struct test *t = tests; t->s != 0; t++) {
    4936:	6508                	ld	a0,8(a0)
    4938:	cd29                	beqz	a0,4992 <runtests+0x6a>
    493a:	e84a                	sd	s2,16(sp)
    493c:	e052                	sd	s4,0(sp)
    493e:	892e                	mv	s2,a1
    if((justone == 0) || strcmp(t->s, justone) == 0) {
      ntests++;
      if(!run(t->f, t->s)){
        if(continuous != 2){
    4940:	1679                	addi	a2,a2,-2 # ffe <bigdir+0x10a>
    4942:	00c03a33          	snez	s4,a2
  int ntests = 0;
    4946:	4981                	li	s3,0
    4948:	a029                	j	4952 <runtests+0x2a>
      ntests++;
    494a:	2985                	addiw	s3,s3,1
  for (struct test *t = tests; t->s != 0; t++) {
    494c:	04c1                	addi	s1,s1,16
    494e:	6488                	ld	a0,8(s1)
    4950:	c905                	beqz	a0,4980 <runtests+0x58>
    if((justone == 0) || strcmp(t->s, justone) == 0) {
    4952:	00090663          	beqz	s2,495e <runtests+0x36>
    4956:	85ca                	mv	a1,s2
    4958:	276000ef          	jal	4bce <strcmp>
    495c:	f965                	bnez	a0,494c <runtests+0x24>
      if(!run(t->f, t->s)){
    495e:	648c                	ld	a1,8(s1)
    4960:	6088                	ld	a0,0(s1)
    4962:	f49ff0ef          	jal	48aa <run>
        if(continuous != 2){
    4966:	f175                	bnez	a0,494a <runtests+0x22>
    4968:	fe0a01e3          	beqz	s4,494a <runtests+0x22>
          printf("SOME TESTS FAILED\n");
    496c:	00003517          	auipc	a0,0x3
    4970:	b6450513          	addi	a0,a0,-1180 # 74d0 <malloc+0x2176>
    4974:	12f000ef          	jal	52a2 <printf>
          return -1;
    4978:	59fd                	li	s3,-1
    497a:	6942                	ld	s2,16(sp)
    497c:	6a02                	ld	s4,0(sp)
    497e:	a019                	j	4984 <runtests+0x5c>
    4980:	6942                	ld	s2,16(sp)
    4982:	6a02                	ld	s4,0(sp)
        }
      }
    }
  }
  return ntests;
}
    4984:	854e                	mv	a0,s3
    4986:	70a2                	ld	ra,40(sp)
    4988:	7402                	ld	s0,32(sp)
    498a:	64e2                	ld	s1,24(sp)
    498c:	69a2                	ld	s3,8(sp)
    498e:	6145                	addi	sp,sp,48
    4990:	8082                	ret
  return ntests;
    4992:	4981                	li	s3,0
    4994:	bfc5                	j	4984 <runtests+0x5c>

0000000000004996 <countfree>:


// use sbrk() to count how many free physical memory pages there are.
int
countfree()
{
    4996:	7139                	addi	sp,sp,-64
    4998:	fc06                	sd	ra,56(sp)
    499a:	f822                	sd	s0,48(sp)
    499c:	f426                	sd	s1,40(sp)
    499e:	f04a                	sd	s2,32(sp)
    49a0:	ec4e                	sd	s3,24(sp)
    49a2:	e852                	sd	s4,16(sp)
    49a4:	e456                	sd	s5,8(sp)
    49a6:	0080                	addi	s0,sp,64
  int n = 0;
  uint64 sz0 = (uint64)sbrk(0);
    49a8:	4501                	li	a0,0
    49aa:	476000ef          	jal	4e20 <sbrk>
    49ae:	8aaa                	mv	s5,a0
  int n = 0;
    49b0:	4481                	li	s1,0
  while(n<max){
    char *a = sbrk(PGSIZE);
    49b2:	6a05                	lui	s4,0x1
    if(a == SBRK_ERROR){
    49b4:	59fd                	li	s3,-1
  while(n<max){
    49b6:	6919                	lui	s2,0x6
    49b8:	1a890913          	addi	s2,s2,424 # 61a8 <malloc+0xe4e>
    char *a = sbrk(PGSIZE);
    49bc:	8552                	mv	a0,s4
    49be:	462000ef          	jal	4e20 <sbrk>
    if(a == SBRK_ERROR){
    49c2:	01350563          	beq	a0,s3,49cc <countfree+0x36>
      break;
    }
    n += 1;
    49c6:	2485                	addiw	s1,s1,1
  while(n<max){
    49c8:	ff249ae3          	bne	s1,s2,49bc <countfree+0x26>
  }
  sbrk(-((uint64)sbrk(0) - sz0));  
    49cc:	4501                	li	a0,0
    49ce:	452000ef          	jal	4e20 <sbrk>
    49d2:	40aa853b          	subw	a0,s5,a0
    49d6:	44a000ef          	jal	4e20 <sbrk>
  return n;
}
    49da:	8526                	mv	a0,s1
    49dc:	70e2                	ld	ra,56(sp)
    49de:	7442                	ld	s0,48(sp)
    49e0:	74a2                	ld	s1,40(sp)
    49e2:	7902                	ld	s2,32(sp)
    49e4:	69e2                	ld	s3,24(sp)
    49e6:	6a42                	ld	s4,16(sp)
    49e8:	6aa2                	ld	s5,8(sp)
    49ea:	6121                	addi	sp,sp,64
    49ec:	8082                	ret

00000000000049ee <drivetests>:

int
drivetests(int quick, int continuous, char *justone) {
    49ee:	7159                	addi	sp,sp,-112
    49f0:	f486                	sd	ra,104(sp)
    49f2:	f0a2                	sd	s0,96(sp)
    49f4:	eca6                	sd	s1,88(sp)
    49f6:	e8ca                	sd	s2,80(sp)
    49f8:	e4ce                	sd	s3,72(sp)
    49fa:	e0d2                	sd	s4,64(sp)
    49fc:	fc56                	sd	s5,56(sp)
    49fe:	f85a                	sd	s6,48(sp)
    4a00:	f45e                	sd	s7,40(sp)
    4a02:	f062                	sd	s8,32(sp)
    4a04:	ec66                	sd	s9,24(sp)
    4a06:	e86a                	sd	s10,16(sp)
    4a08:	e46e                	sd	s11,8(sp)
    4a0a:	1880                	addi	s0,sp,112
    4a0c:	8aaa                	mv	s5,a0
    4a0e:	89ae                	mv	s3,a1
    4a10:	8a32                	mv	s4,a2
      printf("FAILED -- lost some free pages %d (out of %d)\n", free1, free0);
      if(continuous != 2) {
        return 1;
      }
    }
    if (justone != 0 && ntests == 0) {
    4a12:	00c03d33          	snez	s10,a2
    printf("usertests starting\n");
    4a16:	00003c17          	auipc	s8,0x3
    4a1a:	ad2c0c13          	addi	s8,s8,-1326 # 74e8 <malloc+0x218e>
    n = runtests(quicktests, justone, continuous);
    4a1e:	00004b97          	auipc	s7,0x4
    4a22:	5f2b8b93          	addi	s7,s7,1522 # 9010 <quicktests>
      if(continuous != 2) {
    4a26:	4b09                	li	s6,2
      n = runtests(slowtests, justone, continuous);
    4a28:	00005c97          	auipc	s9,0x5
    4a2c:	9d8c8c93          	addi	s9,s9,-1576 # 9400 <slowtests>
      printf("FAILED -- lost some free pages %d (out of %d)\n", free1, free0);
    4a30:	00003d97          	auipc	s11,0x3
    4a34:	af0d8d93          	addi	s11,s11,-1296 # 7520 <malloc+0x21c6>
    4a38:	a82d                	j	4a72 <drivetests+0x84>
      if(continuous != 2) {
    4a3a:	0b699363          	bne	s3,s6,4ae0 <drivetests+0xf2>
    int ntests = 0;
    4a3e:	4481                	li	s1,0
    4a40:	a0b9                	j	4a8e <drivetests+0xa0>
        printf("usertests slow tests starting\n");
    4a42:	00003517          	auipc	a0,0x3
    4a46:	abe50513          	addi	a0,a0,-1346 # 7500 <malloc+0x21a6>
    4a4a:	059000ef          	jal	52a2 <printf>
    4a4e:	a0a1                	j	4a96 <drivetests+0xa8>
        if(continuous != 2) {
    4a50:	05698b63          	beq	s3,s6,4aa6 <drivetests+0xb8>
          return 1;
    4a54:	4505                	li	a0,1
    4a56:	a0b5                	j	4ac2 <drivetests+0xd4>
      printf("FAILED -- lost some free pages %d (out of %d)\n", free1, free0);
    4a58:	864a                	mv	a2,s2
    4a5a:	85aa                	mv	a1,a0
    4a5c:	856e                	mv	a0,s11
    4a5e:	045000ef          	jal	52a2 <printf>
      if(continuous != 2) {
    4a62:	09699163          	bne	s3,s6,4ae4 <drivetests+0xf6>
    if (justone != 0 && ntests == 0) {
    4a66:	e491                	bnez	s1,4a72 <drivetests+0x84>
    4a68:	000d0563          	beqz	s10,4a72 <drivetests+0x84>
    4a6c:	a0a1                	j	4ab4 <drivetests+0xc6>
      printf("NO TESTS EXECUTED\n");
      return 1;
    }
  } while(continuous);
    4a6e:	06098d63          	beqz	s3,4ae8 <drivetests+0xfa>
    printf("usertests starting\n");
    4a72:	8562                	mv	a0,s8
    4a74:	02f000ef          	jal	52a2 <printf>
    int free0 = countfree();
    4a78:	f1fff0ef          	jal	4996 <countfree>
    4a7c:	892a                	mv	s2,a0
    n = runtests(quicktests, justone, continuous);
    4a7e:	864e                	mv	a2,s3
    4a80:	85d2                	mv	a1,s4
    4a82:	855e                	mv	a0,s7
    4a84:	ea5ff0ef          	jal	4928 <runtests>
    4a88:	84aa                	mv	s1,a0
    if (n < 0) {
    4a8a:	fa0548e3          	bltz	a0,4a3a <drivetests+0x4c>
    if(!quick) {
    4a8e:	000a9c63          	bnez	s5,4aa6 <drivetests+0xb8>
      if (justone == 0)
    4a92:	fa0a08e3          	beqz	s4,4a42 <drivetests+0x54>
      n = runtests(slowtests, justone, continuous);
    4a96:	864e                	mv	a2,s3
    4a98:	85d2                	mv	a1,s4
    4a9a:	8566                	mv	a0,s9
    4a9c:	e8dff0ef          	jal	4928 <runtests>
      if (n < 0) {
    4aa0:	fa0548e3          	bltz	a0,4a50 <drivetests+0x62>
        ntests += n;
    4aa4:	9ca9                	addw	s1,s1,a0
    if((free1 = countfree()) < free0) {
    4aa6:	ef1ff0ef          	jal	4996 <countfree>
    4aaa:	fb2547e3          	blt	a0,s2,4a58 <drivetests+0x6a>
    if (justone != 0 && ntests == 0) {
    4aae:	f0e1                	bnez	s1,4a6e <drivetests+0x80>
    4ab0:	fa0d0fe3          	beqz	s10,4a6e <drivetests+0x80>
      printf("NO TESTS EXECUTED\n");
    4ab4:	00003517          	auipc	a0,0x3
    4ab8:	a9c50513          	addi	a0,a0,-1380 # 7550 <malloc+0x21f6>
    4abc:	7e6000ef          	jal	52a2 <printf>
      return 1;
    4ac0:	4505                	li	a0,1
  return 0;
}
    4ac2:	70a6                	ld	ra,104(sp)
    4ac4:	7406                	ld	s0,96(sp)
    4ac6:	64e6                	ld	s1,88(sp)
    4ac8:	6946                	ld	s2,80(sp)
    4aca:	69a6                	ld	s3,72(sp)
    4acc:	6a06                	ld	s4,64(sp)
    4ace:	7ae2                	ld	s5,56(sp)
    4ad0:	7b42                	ld	s6,48(sp)
    4ad2:	7ba2                	ld	s7,40(sp)
    4ad4:	7c02                	ld	s8,32(sp)
    4ad6:	6ce2                	ld	s9,24(sp)
    4ad8:	6d42                	ld	s10,16(sp)
    4ada:	6da2                	ld	s11,8(sp)
    4adc:	6165                	addi	sp,sp,112
    4ade:	8082                	ret
        return 1;
    4ae0:	4505                	li	a0,1
    4ae2:	b7c5                	j	4ac2 <drivetests+0xd4>
        return 1;
    4ae4:	4505                	li	a0,1
    4ae6:	bff1                	j	4ac2 <drivetests+0xd4>
  return 0;
    4ae8:	854e                	mv	a0,s3
    4aea:	bfe1                	j	4ac2 <drivetests+0xd4>

0000000000004aec <main>:

int
main(int argc, char *argv[])
{
    4aec:	1101                	addi	sp,sp,-32
    4aee:	ec06                	sd	ra,24(sp)
    4af0:	e822                	sd	s0,16(sp)
    4af2:	e426                	sd	s1,8(sp)
    4af4:	e04a                	sd	s2,0(sp)
    4af6:	1000                	addi	s0,sp,32
    4af8:	84aa                	mv	s1,a0
  int continuous = 0;
  int quick = 0;
  char *justone = 0;

  if(argc == 2 && strcmp(argv[1], "-q") == 0){
    4afa:	4789                	li	a5,2
    4afc:	00f50e63          	beq	a0,a5,4b18 <main+0x2c>
    continuous = 1;
  } else if(argc == 2 && strcmp(argv[1], "-C") == 0){
    continuous = 2;
  } else if(argc == 2 && argv[1][0] != '-'){
    justone = argv[1];
  } else if(argc > 1){
    4b00:	4785                	li	a5,1
    4b02:	06a7c663          	blt	a5,a0,4b6e <main+0x82>
  char *justone = 0;
    4b06:	4601                	li	a2,0
  int quick = 0;
    4b08:	4501                	li	a0,0
  int continuous = 0;
    4b0a:	4581                	li	a1,0
    printf("Usage: usertests [-c] [-C] [-q] [testname]\n");
    exit(1);
  }
  if (drivetests(quick, continuous, justone)) {
    4b0c:	ee3ff0ef          	jal	49ee <drivetests>
    4b10:	cd35                	beqz	a0,4b8c <main+0xa0>
    exit(1);
    4b12:	4505                	li	a0,1
    4b14:	340000ef          	jal	4e54 <exit>
    4b18:	892e                	mv	s2,a1
  if(argc == 2 && strcmp(argv[1], "-q") == 0){
    4b1a:	00003597          	auipc	a1,0x3
    4b1e:	a4e58593          	addi	a1,a1,-1458 # 7568 <malloc+0x220e>
    4b22:	00893503          	ld	a0,8(s2)
    4b26:	0a8000ef          	jal	4bce <strcmp>
    4b2a:	85aa                	mv	a1,a0
    4b2c:	e501                	bnez	a0,4b34 <main+0x48>
  char *justone = 0;
    4b2e:	4601                	li	a2,0
    quick = 1;
    4b30:	4505                	li	a0,1
    4b32:	bfe9                	j	4b0c <main+0x20>
  } else if(argc == 2 && strcmp(argv[1], "-c") == 0){
    4b34:	00003597          	auipc	a1,0x3
    4b38:	a3c58593          	addi	a1,a1,-1476 # 7570 <malloc+0x2216>
    4b3c:	00893503          	ld	a0,8(s2)
    4b40:	08e000ef          	jal	4bce <strcmp>
    4b44:	cd15                	beqz	a0,4b80 <main+0x94>
  } else if(argc == 2 && strcmp(argv[1], "-C") == 0){
    4b46:	00003597          	auipc	a1,0x3
    4b4a:	a7a58593          	addi	a1,a1,-1414 # 75c0 <malloc+0x2266>
    4b4e:	00893503          	ld	a0,8(s2)
    4b52:	07c000ef          	jal	4bce <strcmp>
    4b56:	c905                	beqz	a0,4b86 <main+0x9a>
  } else if(argc == 2 && argv[1][0] != '-'){
    4b58:	00893603          	ld	a2,8(s2)
    4b5c:	00064703          	lbu	a4,0(a2)
    4b60:	02d00793          	li	a5,45
    4b64:	00f70563          	beq	a4,a5,4b6e <main+0x82>
  int quick = 0;
    4b68:	4501                	li	a0,0
  int continuous = 0;
    4b6a:	4581                	li	a1,0
    4b6c:	b745                	j	4b0c <main+0x20>
    printf("Usage: usertests [-c] [-C] [-q] [testname]\n");
    4b6e:	00003517          	auipc	a0,0x3
    4b72:	a0a50513          	addi	a0,a0,-1526 # 7578 <malloc+0x221e>
    4b76:	72c000ef          	jal	52a2 <printf>
    exit(1);
    4b7a:	4505                	li	a0,1
    4b7c:	2d8000ef          	jal	4e54 <exit>
  char *justone = 0;
    4b80:	4601                	li	a2,0
    continuous = 1;
    4b82:	4585                	li	a1,1
    4b84:	b761                	j	4b0c <main+0x20>
    continuous = 2;
    4b86:	85a6                	mv	a1,s1
  char *justone = 0;
    4b88:	4601                	li	a2,0
    4b8a:	b749                	j	4b0c <main+0x20>
  }
  printf("ALL TESTS PASSED\n");
    4b8c:	00003517          	auipc	a0,0x3
    4b90:	a1c50513          	addi	a0,a0,-1508 # 75a8 <malloc+0x224e>
    4b94:	70e000ef          	jal	52a2 <printf>
  exit(0);
    4b98:	4501                	li	a0,0
    4b9a:	2ba000ef          	jal	4e54 <exit>

0000000000004b9e <start>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
start(int argc, char **argv)
{
    4b9e:	1141                	addi	sp,sp,-16
    4ba0:	e406                	sd	ra,8(sp)
    4ba2:	e022                	sd	s0,0(sp)
    4ba4:	0800                	addi	s0,sp,16
  int r;
  extern int main(int argc, char **argv);
  r = main(argc, argv);
    4ba6:	f47ff0ef          	jal	4aec <main>
  exit(r);
    4baa:	2aa000ef          	jal	4e54 <exit>

0000000000004bae <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
    4bae:	1141                	addi	sp,sp,-16
    4bb0:	e406                	sd	ra,8(sp)
    4bb2:	e022                	sd	s0,0(sp)
    4bb4:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
    4bb6:	87aa                	mv	a5,a0
    4bb8:	0585                	addi	a1,a1,1
    4bba:	0785                	addi	a5,a5,1
    4bbc:	fff5c703          	lbu	a4,-1(a1)
    4bc0:	fee78fa3          	sb	a4,-1(a5)
    4bc4:	fb75                	bnez	a4,4bb8 <strcpy+0xa>
    ;
  return os;
}
    4bc6:	60a2                	ld	ra,8(sp)
    4bc8:	6402                	ld	s0,0(sp)
    4bca:	0141                	addi	sp,sp,16
    4bcc:	8082                	ret

0000000000004bce <strcmp>:

int
strcmp(const char *p, const char *q)
{
    4bce:	1141                	addi	sp,sp,-16
    4bd0:	e406                	sd	ra,8(sp)
    4bd2:	e022                	sd	s0,0(sp)
    4bd4:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
    4bd6:	00054783          	lbu	a5,0(a0)
    4bda:	cb91                	beqz	a5,4bee <strcmp+0x20>
    4bdc:	0005c703          	lbu	a4,0(a1)
    4be0:	00f71763          	bne	a4,a5,4bee <strcmp+0x20>
    p++, q++;
    4be4:	0505                	addi	a0,a0,1
    4be6:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
    4be8:	00054783          	lbu	a5,0(a0)
    4bec:	fbe5                	bnez	a5,4bdc <strcmp+0xe>
  return (uchar)*p - (uchar)*q;
    4bee:	0005c503          	lbu	a0,0(a1)
}
    4bf2:	40a7853b          	subw	a0,a5,a0
    4bf6:	60a2                	ld	ra,8(sp)
    4bf8:	6402                	ld	s0,0(sp)
    4bfa:	0141                	addi	sp,sp,16
    4bfc:	8082                	ret

0000000000004bfe <strlen>:

uint
strlen(const char *s)
{
    4bfe:	1141                	addi	sp,sp,-16
    4c00:	e406                	sd	ra,8(sp)
    4c02:	e022                	sd	s0,0(sp)
    4c04:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
    4c06:	00054783          	lbu	a5,0(a0)
    4c0a:	cf91                	beqz	a5,4c26 <strlen+0x28>
    4c0c:	00150793          	addi	a5,a0,1
    4c10:	86be                	mv	a3,a5
    4c12:	0785                	addi	a5,a5,1
    4c14:	fff7c703          	lbu	a4,-1(a5)
    4c18:	ff65                	bnez	a4,4c10 <strlen+0x12>
    4c1a:	40a6853b          	subw	a0,a3,a0
    ;
  return n;
}
    4c1e:	60a2                	ld	ra,8(sp)
    4c20:	6402                	ld	s0,0(sp)
    4c22:	0141                	addi	sp,sp,16
    4c24:	8082                	ret
  for(n = 0; s[n]; n++)
    4c26:	4501                	li	a0,0
    4c28:	bfdd                	j	4c1e <strlen+0x20>

0000000000004c2a <memset>:

void*
memset(void *dst, int c, uint n)
{
    4c2a:	1141                	addi	sp,sp,-16
    4c2c:	e406                	sd	ra,8(sp)
    4c2e:	e022                	sd	s0,0(sp)
    4c30:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
    4c32:	ca19                	beqz	a2,4c48 <memset+0x1e>
    4c34:	87aa                	mv	a5,a0
    4c36:	1602                	slli	a2,a2,0x20
    4c38:	9201                	srli	a2,a2,0x20
    4c3a:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
    4c3e:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
    4c42:	0785                	addi	a5,a5,1
    4c44:	fee79de3          	bne	a5,a4,4c3e <memset+0x14>
  }
  return dst;
}
    4c48:	60a2                	ld	ra,8(sp)
    4c4a:	6402                	ld	s0,0(sp)
    4c4c:	0141                	addi	sp,sp,16
    4c4e:	8082                	ret

0000000000004c50 <strchr>:

char*
strchr(const char *s, char c)
{
    4c50:	1141                	addi	sp,sp,-16
    4c52:	e406                	sd	ra,8(sp)
    4c54:	e022                	sd	s0,0(sp)
    4c56:	0800                	addi	s0,sp,16
  for(; *s; s++)
    4c58:	00054783          	lbu	a5,0(a0)
    4c5c:	cf81                	beqz	a5,4c74 <strchr+0x24>
    if(*s == c)
    4c5e:	00f58763          	beq	a1,a5,4c6c <strchr+0x1c>
  for(; *s; s++)
    4c62:	0505                	addi	a0,a0,1
    4c64:	00054783          	lbu	a5,0(a0)
    4c68:	fbfd                	bnez	a5,4c5e <strchr+0xe>
      return (char*)s;
  return 0;
    4c6a:	4501                	li	a0,0
}
    4c6c:	60a2                	ld	ra,8(sp)
    4c6e:	6402                	ld	s0,0(sp)
    4c70:	0141                	addi	sp,sp,16
    4c72:	8082                	ret
  return 0;
    4c74:	4501                	li	a0,0
    4c76:	bfdd                	j	4c6c <strchr+0x1c>

0000000000004c78 <gets>:

char*
gets(char *buf, int max)
{
    4c78:	711d                	addi	sp,sp,-96
    4c7a:	ec86                	sd	ra,88(sp)
    4c7c:	e8a2                	sd	s0,80(sp)
    4c7e:	e4a6                	sd	s1,72(sp)
    4c80:	e0ca                	sd	s2,64(sp)
    4c82:	fc4e                	sd	s3,56(sp)
    4c84:	f852                	sd	s4,48(sp)
    4c86:	f456                	sd	s5,40(sp)
    4c88:	f05a                	sd	s6,32(sp)
    4c8a:	ec5e                	sd	s7,24(sp)
    4c8c:	e862                	sd	s8,16(sp)
    4c8e:	1080                	addi	s0,sp,96
    4c90:	8baa                	mv	s7,a0
    4c92:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
    4c94:	892a                	mv	s2,a0
    4c96:	4481                	li	s1,0
    cc = read(0, &c, 1);
    4c98:	faf40b13          	addi	s6,s0,-81
    4c9c:	4a85                	li	s5,1
  for(i=0; i+1 < max; ){
    4c9e:	8c26                	mv	s8,s1
    4ca0:	0014899b          	addiw	s3,s1,1
    4ca4:	84ce                	mv	s1,s3
    4ca6:	0349d463          	bge	s3,s4,4cce <gets+0x56>
    cc = read(0, &c, 1);
    4caa:	8656                	mv	a2,s5
    4cac:	85da                	mv	a1,s6
    4cae:	4501                	li	a0,0
    4cb0:	1bc000ef          	jal	4e6c <read>
    if(cc < 1)
    4cb4:	00a05d63          	blez	a0,4cce <gets+0x56>
      break;
    buf[i++] = c;
    4cb8:	faf44783          	lbu	a5,-81(s0)
    4cbc:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
    4cc0:	0905                	addi	s2,s2,1
    4cc2:	ff678713          	addi	a4,a5,-10
    4cc6:	c319                	beqz	a4,4ccc <gets+0x54>
    4cc8:	17cd                	addi	a5,a5,-13
    4cca:	fbf1                	bnez	a5,4c9e <gets+0x26>
    buf[i++] = c;
    4ccc:	8c4e                	mv	s8,s3
      break;
  }
  buf[i] = '\0';
    4cce:	9c5e                	add	s8,s8,s7
    4cd0:	000c0023          	sb	zero,0(s8)
  return buf;
}
    4cd4:	855e                	mv	a0,s7
    4cd6:	60e6                	ld	ra,88(sp)
    4cd8:	6446                	ld	s0,80(sp)
    4cda:	64a6                	ld	s1,72(sp)
    4cdc:	6906                	ld	s2,64(sp)
    4cde:	79e2                	ld	s3,56(sp)
    4ce0:	7a42                	ld	s4,48(sp)
    4ce2:	7aa2                	ld	s5,40(sp)
    4ce4:	7b02                	ld	s6,32(sp)
    4ce6:	6be2                	ld	s7,24(sp)
    4ce8:	6c42                	ld	s8,16(sp)
    4cea:	6125                	addi	sp,sp,96
    4cec:	8082                	ret

0000000000004cee <stat>:

int
stat(const char *n, struct stat *st)
{
    4cee:	1101                	addi	sp,sp,-32
    4cf0:	ec06                	sd	ra,24(sp)
    4cf2:	e822                	sd	s0,16(sp)
    4cf4:	e04a                	sd	s2,0(sp)
    4cf6:	1000                	addi	s0,sp,32
    4cf8:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
    4cfa:	4581                	li	a1,0
    4cfc:	198000ef          	jal	4e94 <open>
  if(fd < 0)
    4d00:	02054263          	bltz	a0,4d24 <stat+0x36>
    4d04:	e426                	sd	s1,8(sp)
    4d06:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
    4d08:	85ca                	mv	a1,s2
    4d0a:	1a2000ef          	jal	4eac <fstat>
    4d0e:	892a                	mv	s2,a0
  close(fd);
    4d10:	8526                	mv	a0,s1
    4d12:	16a000ef          	jal	4e7c <close>
  return r;
    4d16:	64a2                	ld	s1,8(sp)
}
    4d18:	854a                	mv	a0,s2
    4d1a:	60e2                	ld	ra,24(sp)
    4d1c:	6442                	ld	s0,16(sp)
    4d1e:	6902                	ld	s2,0(sp)
    4d20:	6105                	addi	sp,sp,32
    4d22:	8082                	ret
    return -1;
    4d24:	57fd                	li	a5,-1
    4d26:	893e                	mv	s2,a5
    4d28:	bfc5                	j	4d18 <stat+0x2a>

0000000000004d2a <atoi>:

int
atoi(const char *s)
{
    4d2a:	1141                	addi	sp,sp,-16
    4d2c:	e406                	sd	ra,8(sp)
    4d2e:	e022                	sd	s0,0(sp)
    4d30:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
    4d32:	00054683          	lbu	a3,0(a0)
    4d36:	fd06879b          	addiw	a5,a3,-48 # 3ffd0 <base+0x30338>
    4d3a:	0ff7f793          	zext.b	a5,a5
    4d3e:	4625                	li	a2,9
    4d40:	02f66963          	bltu	a2,a5,4d72 <atoi+0x48>
    4d44:	872a                	mv	a4,a0
  n = 0;
    4d46:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
    4d48:	0705                	addi	a4,a4,1 # 1000001 <base+0xff0369>
    4d4a:	0025179b          	slliw	a5,a0,0x2
    4d4e:	9fa9                	addw	a5,a5,a0
    4d50:	0017979b          	slliw	a5,a5,0x1
    4d54:	9fb5                	addw	a5,a5,a3
    4d56:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
    4d5a:	00074683          	lbu	a3,0(a4)
    4d5e:	fd06879b          	addiw	a5,a3,-48
    4d62:	0ff7f793          	zext.b	a5,a5
    4d66:	fef671e3          	bgeu	a2,a5,4d48 <atoi+0x1e>
  return n;
}
    4d6a:	60a2                	ld	ra,8(sp)
    4d6c:	6402                	ld	s0,0(sp)
    4d6e:	0141                	addi	sp,sp,16
    4d70:	8082                	ret
  n = 0;
    4d72:	4501                	li	a0,0
    4d74:	bfdd                	j	4d6a <atoi+0x40>

0000000000004d76 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
    4d76:	1141                	addi	sp,sp,-16
    4d78:	e406                	sd	ra,8(sp)
    4d7a:	e022                	sd	s0,0(sp)
    4d7c:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
    4d7e:	02b57563          	bgeu	a0,a1,4da8 <memmove+0x32>
    while(n-- > 0)
    4d82:	00c05f63          	blez	a2,4da0 <memmove+0x2a>
    4d86:	1602                	slli	a2,a2,0x20
    4d88:	9201                	srli	a2,a2,0x20
    4d8a:	00c507b3          	add	a5,a0,a2
  dst = vdst;
    4d8e:	872a                	mv	a4,a0
      *dst++ = *src++;
    4d90:	0585                	addi	a1,a1,1
    4d92:	0705                	addi	a4,a4,1
    4d94:	fff5c683          	lbu	a3,-1(a1)
    4d98:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
    4d9c:	fee79ae3          	bne	a5,a4,4d90 <memmove+0x1a>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
    4da0:	60a2                	ld	ra,8(sp)
    4da2:	6402                	ld	s0,0(sp)
    4da4:	0141                	addi	sp,sp,16
    4da6:	8082                	ret
    while(n-- > 0)
    4da8:	fec05ce3          	blez	a2,4da0 <memmove+0x2a>
    dst += n;
    4dac:	00c50733          	add	a4,a0,a2
    src += n;
    4db0:	95b2                	add	a1,a1,a2
    4db2:	fff6079b          	addiw	a5,a2,-1
    4db6:	1782                	slli	a5,a5,0x20
    4db8:	9381                	srli	a5,a5,0x20
    4dba:	fff7c793          	not	a5,a5
    4dbe:	97ba                	add	a5,a5,a4
      *--dst = *--src;
    4dc0:	15fd                	addi	a1,a1,-1
    4dc2:	177d                	addi	a4,a4,-1
    4dc4:	0005c683          	lbu	a3,0(a1)
    4dc8:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
    4dcc:	fef71ae3          	bne	a4,a5,4dc0 <memmove+0x4a>
    4dd0:	bfc1                	j	4da0 <memmove+0x2a>

0000000000004dd2 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
    4dd2:	1141                	addi	sp,sp,-16
    4dd4:	e406                	sd	ra,8(sp)
    4dd6:	e022                	sd	s0,0(sp)
    4dd8:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
    4dda:	c61d                	beqz	a2,4e08 <memcmp+0x36>
    4ddc:	1602                	slli	a2,a2,0x20
    4dde:	9201                	srli	a2,a2,0x20
    4de0:	00c506b3          	add	a3,a0,a2
    if (*p1 != *p2) {
    4de4:	00054783          	lbu	a5,0(a0)
    4de8:	0005c703          	lbu	a4,0(a1)
    4dec:	00e79863          	bne	a5,a4,4dfc <memcmp+0x2a>
      return *p1 - *p2;
    }
    p1++;
    4df0:	0505                	addi	a0,a0,1
    p2++;
    4df2:	0585                	addi	a1,a1,1
  while (n-- > 0) {
    4df4:	fed518e3          	bne	a0,a3,4de4 <memcmp+0x12>
  }
  return 0;
    4df8:	4501                	li	a0,0
    4dfa:	a019                	j	4e00 <memcmp+0x2e>
      return *p1 - *p2;
    4dfc:	40e7853b          	subw	a0,a5,a4
}
    4e00:	60a2                	ld	ra,8(sp)
    4e02:	6402                	ld	s0,0(sp)
    4e04:	0141                	addi	sp,sp,16
    4e06:	8082                	ret
  return 0;
    4e08:	4501                	li	a0,0
    4e0a:	bfdd                	j	4e00 <memcmp+0x2e>

0000000000004e0c <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
    4e0c:	1141                	addi	sp,sp,-16
    4e0e:	e406                	sd	ra,8(sp)
    4e10:	e022                	sd	s0,0(sp)
    4e12:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
    4e14:	f63ff0ef          	jal	4d76 <memmove>
}
    4e18:	60a2                	ld	ra,8(sp)
    4e1a:	6402                	ld	s0,0(sp)
    4e1c:	0141                	addi	sp,sp,16
    4e1e:	8082                	ret

0000000000004e20 <sbrk>:

char *
sbrk(int n) {
    4e20:	1141                	addi	sp,sp,-16
    4e22:	e406                	sd	ra,8(sp)
    4e24:	e022                	sd	s0,0(sp)
    4e26:	0800                	addi	s0,sp,16
  return sys_sbrk(n, SBRK_EAGER);
    4e28:	4585                	li	a1,1
    4e2a:	0b2000ef          	jal	4edc <sys_sbrk>
}
    4e2e:	60a2                	ld	ra,8(sp)
    4e30:	6402                	ld	s0,0(sp)
    4e32:	0141                	addi	sp,sp,16
    4e34:	8082                	ret

0000000000004e36 <sbrklazy>:

char *
sbrklazy(int n) {
    4e36:	1141                	addi	sp,sp,-16
    4e38:	e406                	sd	ra,8(sp)
    4e3a:	e022                	sd	s0,0(sp)
    4e3c:	0800                	addi	s0,sp,16
  return sys_sbrk(n, SBRK_LAZY);
    4e3e:	4589                	li	a1,2
    4e40:	09c000ef          	jal	4edc <sys_sbrk>
}
    4e44:	60a2                	ld	ra,8(sp)
    4e46:	6402                	ld	s0,0(sp)
    4e48:	0141                	addi	sp,sp,16
    4e4a:	8082                	ret

0000000000004e4c <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
    4e4c:	4885                	li	a7,1
 ecall
    4e4e:	00000073          	ecall
 ret
    4e52:	8082                	ret

0000000000004e54 <exit>:
.global exit
exit:
 li a7, SYS_exit
    4e54:	4889                	li	a7,2
 ecall
    4e56:	00000073          	ecall
 ret
    4e5a:	8082                	ret

0000000000004e5c <wait>:
.global wait
wait:
 li a7, SYS_wait
    4e5c:	488d                	li	a7,3
 ecall
    4e5e:	00000073          	ecall
 ret
    4e62:	8082                	ret

0000000000004e64 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
    4e64:	4891                	li	a7,4
 ecall
    4e66:	00000073          	ecall
 ret
    4e6a:	8082                	ret

0000000000004e6c <read>:
.global read
read:
 li a7, SYS_read
    4e6c:	4895                	li	a7,5
 ecall
    4e6e:	00000073          	ecall
 ret
    4e72:	8082                	ret

0000000000004e74 <write>:
.global write
write:
 li a7, SYS_write
    4e74:	48c1                	li	a7,16
 ecall
    4e76:	00000073          	ecall
 ret
    4e7a:	8082                	ret

0000000000004e7c <close>:
.global close
close:
 li a7, SYS_close
    4e7c:	48d5                	li	a7,21
 ecall
    4e7e:	00000073          	ecall
 ret
    4e82:	8082                	ret

0000000000004e84 <kill>:
.global kill
kill:
 li a7, SYS_kill
    4e84:	4899                	li	a7,6
 ecall
    4e86:	00000073          	ecall
 ret
    4e8a:	8082                	ret

0000000000004e8c <exec>:
.global exec
exec:
 li a7, SYS_exec
    4e8c:	489d                	li	a7,7
 ecall
    4e8e:	00000073          	ecall
 ret
    4e92:	8082                	ret

0000000000004e94 <open>:
.global open
open:
 li a7, SYS_open
    4e94:	48bd                	li	a7,15
 ecall
    4e96:	00000073          	ecall
 ret
    4e9a:	8082                	ret

0000000000004e9c <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
    4e9c:	48c5                	li	a7,17
 ecall
    4e9e:	00000073          	ecall
 ret
    4ea2:	8082                	ret

0000000000004ea4 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
    4ea4:	48c9                	li	a7,18
 ecall
    4ea6:	00000073          	ecall
 ret
    4eaa:	8082                	ret

0000000000004eac <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
    4eac:	48a1                	li	a7,8
 ecall
    4eae:	00000073          	ecall
 ret
    4eb2:	8082                	ret

0000000000004eb4 <link>:
.global link
link:
 li a7, SYS_link
    4eb4:	48cd                	li	a7,19
 ecall
    4eb6:	00000073          	ecall
 ret
    4eba:	8082                	ret

0000000000004ebc <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
    4ebc:	48d1                	li	a7,20
 ecall
    4ebe:	00000073          	ecall
 ret
    4ec2:	8082                	ret

0000000000004ec4 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
    4ec4:	48a5                	li	a7,9
 ecall
    4ec6:	00000073          	ecall
 ret
    4eca:	8082                	ret

0000000000004ecc <dup>:
.global dup
dup:
 li a7, SYS_dup
    4ecc:	48a9                	li	a7,10
 ecall
    4ece:	00000073          	ecall
 ret
    4ed2:	8082                	ret

0000000000004ed4 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
    4ed4:	48ad                	li	a7,11
 ecall
    4ed6:	00000073          	ecall
 ret
    4eda:	8082                	ret

0000000000004edc <sys_sbrk>:
.global sys_sbrk
sys_sbrk:
 li a7, SYS_sbrk
    4edc:	48b1                	li	a7,12
 ecall
    4ede:	00000073          	ecall
 ret
    4ee2:	8082                	ret

0000000000004ee4 <pause>:
.global pause
pause:
 li a7, SYS_pause
    4ee4:	48b5                	li	a7,13
 ecall
    4ee6:	00000073          	ecall
 ret
    4eea:	8082                	ret

0000000000004eec <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
    4eec:	48b9                	li	a7,14
 ecall
    4eee:	00000073          	ecall
 ret
    4ef2:	8082                	ret

0000000000004ef4 <memstat>:
.global memstat
memstat:
 li a7, SYS_memstat
    4ef4:	48d9                	li	a7,22
 ecall
    4ef6:	00000073          	ecall
 ret
    4efa:	8082                	ret

0000000000004efc <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
    4efc:	1101                	addi	sp,sp,-32
    4efe:	ec06                	sd	ra,24(sp)
    4f00:	e822                	sd	s0,16(sp)
    4f02:	1000                	addi	s0,sp,32
    4f04:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
    4f08:	4605                	li	a2,1
    4f0a:	fef40593          	addi	a1,s0,-17
    4f0e:	f67ff0ef          	jal	4e74 <write>
}
    4f12:	60e2                	ld	ra,24(sp)
    4f14:	6442                	ld	s0,16(sp)
    4f16:	6105                	addi	sp,sp,32
    4f18:	8082                	ret

0000000000004f1a <printint>:

static void
printint(int fd, long long xx, int base, int sgn)
{
    4f1a:	715d                	addi	sp,sp,-80
    4f1c:	e486                	sd	ra,72(sp)
    4f1e:	e0a2                	sd	s0,64(sp)
    4f20:	f84a                	sd	s2,48(sp)
    4f22:	f44e                	sd	s3,40(sp)
    4f24:	0880                	addi	s0,sp,80
    4f26:	892a                	mv	s2,a0
  char buf[20];
  int i, neg;
  unsigned long long x;

  neg = 0;
  if(sgn && xx < 0){
    4f28:	c6d1                	beqz	a3,4fb4 <printint+0x9a>
    4f2a:	0805d563          	bgez	a1,4fb4 <printint+0x9a>
    neg = 1;
    x = -xx;
    4f2e:	40b005b3          	neg	a1,a1
    neg = 1;
    4f32:	4305                	li	t1,1
  } else {
    x = xx;
  }

  i = 0;
    4f34:	fb840993          	addi	s3,s0,-72
  neg = 0;
    4f38:	86ce                	mv	a3,s3
  i = 0;
    4f3a:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
    4f3c:	00003817          	auipc	a6,0x3
    4f40:	a9c80813          	addi	a6,a6,-1380 # 79d8 <digits>
    4f44:	88ba                	mv	a7,a4
    4f46:	0017051b          	addiw	a0,a4,1
    4f4a:	872a                	mv	a4,a0
    4f4c:	02c5f7b3          	remu	a5,a1,a2
    4f50:	97c2                	add	a5,a5,a6
    4f52:	0007c783          	lbu	a5,0(a5)
    4f56:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
    4f5a:	87ae                	mv	a5,a1
    4f5c:	02c5d5b3          	divu	a1,a1,a2
    4f60:	0685                	addi	a3,a3,1
    4f62:	fec7f1e3          	bgeu	a5,a2,4f44 <printint+0x2a>
  if(neg)
    4f66:	00030c63          	beqz	t1,4f7e <printint+0x64>
    buf[i++] = '-';
    4f6a:	fd050793          	addi	a5,a0,-48
    4f6e:	00878533          	add	a0,a5,s0
    4f72:	02d00793          	li	a5,45
    4f76:	fef50423          	sb	a5,-24(a0)
    4f7a:	0028871b          	addiw	a4,a7,2

  while(--i >= 0)
    4f7e:	02e05563          	blez	a4,4fa8 <printint+0x8e>
    4f82:	fc26                	sd	s1,56(sp)
    4f84:	377d                	addiw	a4,a4,-1
    4f86:	00e984b3          	add	s1,s3,a4
    4f8a:	19fd                	addi	s3,s3,-1
    4f8c:	99ba                	add	s3,s3,a4
    4f8e:	1702                	slli	a4,a4,0x20
    4f90:	9301                	srli	a4,a4,0x20
    4f92:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
    4f96:	0004c583          	lbu	a1,0(s1)
    4f9a:	854a                	mv	a0,s2
    4f9c:	f61ff0ef          	jal	4efc <putc>
  while(--i >= 0)
    4fa0:	14fd                	addi	s1,s1,-1
    4fa2:	ff349ae3          	bne	s1,s3,4f96 <printint+0x7c>
    4fa6:	74e2                	ld	s1,56(sp)
}
    4fa8:	60a6                	ld	ra,72(sp)
    4faa:	6406                	ld	s0,64(sp)
    4fac:	7942                	ld	s2,48(sp)
    4fae:	79a2                	ld	s3,40(sp)
    4fb0:	6161                	addi	sp,sp,80
    4fb2:	8082                	ret
  neg = 0;
    4fb4:	4301                	li	t1,0
    4fb6:	bfbd                	j	4f34 <printint+0x1a>

0000000000004fb8 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %c, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
    4fb8:	711d                	addi	sp,sp,-96
    4fba:	ec86                	sd	ra,88(sp)
    4fbc:	e8a2                	sd	s0,80(sp)
    4fbe:	e4a6                	sd	s1,72(sp)
    4fc0:	1080                	addi	s0,sp,96
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
    4fc2:	0005c483          	lbu	s1,0(a1)
    4fc6:	22048363          	beqz	s1,51ec <vprintf+0x234>
    4fca:	e0ca                	sd	s2,64(sp)
    4fcc:	fc4e                	sd	s3,56(sp)
    4fce:	f852                	sd	s4,48(sp)
    4fd0:	f456                	sd	s5,40(sp)
    4fd2:	f05a                	sd	s6,32(sp)
    4fd4:	ec5e                	sd	s7,24(sp)
    4fd6:	e862                	sd	s8,16(sp)
    4fd8:	8b2a                	mv	s6,a0
    4fda:	8a2e                	mv	s4,a1
    4fdc:	8bb2                	mv	s7,a2
  state = 0;
    4fde:	4981                	li	s3,0
  for(i = 0; fmt[i]; i++){
    4fe0:	4901                	li	s2,0
    4fe2:	4701                	li	a4,0
      if(c0 == '%'){
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if(state == '%'){
    4fe4:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if(c0) c1 = fmt[i+1] & 0xff;
      if(c1) c2 = fmt[i+2] & 0xff;
      if(c0 == 'd'){
    4fe8:	06400c13          	li	s8,100
    4fec:	a00d                	j	500e <vprintf+0x56>
        putc(fd, c0);
    4fee:	85a6                	mv	a1,s1
    4ff0:	855a                	mv	a0,s6
    4ff2:	f0bff0ef          	jal	4efc <putc>
    4ff6:	a019                	j	4ffc <vprintf+0x44>
    } else if(state == '%'){
    4ff8:	03598363          	beq	s3,s5,501e <vprintf+0x66>
  for(i = 0; fmt[i]; i++){
    4ffc:	0019079b          	addiw	a5,s2,1
    5000:	893e                	mv	s2,a5
    5002:	873e                	mv	a4,a5
    5004:	97d2                	add	a5,a5,s4
    5006:	0007c483          	lbu	s1,0(a5)
    500a:	1c048a63          	beqz	s1,51de <vprintf+0x226>
    c0 = fmt[i] & 0xff;
    500e:	0004879b          	sext.w	a5,s1
    if(state == 0){
    5012:	fe0993e3          	bnez	s3,4ff8 <vprintf+0x40>
      if(c0 == '%'){
    5016:	fd579ce3          	bne	a5,s5,4fee <vprintf+0x36>
        state = '%';
    501a:	89be                	mv	s3,a5
    501c:	b7c5                	j	4ffc <vprintf+0x44>
      if(c0) c1 = fmt[i+1] & 0xff;
    501e:	00ea06b3          	add	a3,s4,a4
    5022:	0016c603          	lbu	a2,1(a3)
      if(c1) c2 = fmt[i+2] & 0xff;
    5026:	1c060863          	beqz	a2,51f6 <vprintf+0x23e>
      if(c0 == 'd'){
    502a:	03878763          	beq	a5,s8,5058 <vprintf+0xa0>
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c0 == 'l' && c1 == 'd'){
    502e:	f9478693          	addi	a3,a5,-108
    5032:	0016b693          	seqz	a3,a3
    5036:	f9c60593          	addi	a1,a2,-100
    503a:	e99d                	bnez	a1,5070 <vprintf+0xb8>
    503c:	ca95                	beqz	a3,5070 <vprintf+0xb8>
        printint(fd, va_arg(ap, uint64), 10, 1);
    503e:	008b8493          	addi	s1,s7,8
    5042:	4685                	li	a3,1
    5044:	4629                	li	a2,10
    5046:	000bb583          	ld	a1,0(s7)
    504a:	855a                	mv	a0,s6
    504c:	ecfff0ef          	jal	4f1a <printint>
        i += 1;
    5050:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 10, 1);
    5052:	8ba6                	mv	s7,s1
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c0);
      }

      state = 0;
    5054:	4981                	li	s3,0
    5056:	b75d                	j	4ffc <vprintf+0x44>
        printint(fd, va_arg(ap, int), 10, 1);
    5058:	008b8493          	addi	s1,s7,8
    505c:	4685                	li	a3,1
    505e:	4629                	li	a2,10
    5060:	000ba583          	lw	a1,0(s7)
    5064:	855a                	mv	a0,s6
    5066:	eb5ff0ef          	jal	4f1a <printint>
    506a:	8ba6                	mv	s7,s1
      state = 0;
    506c:	4981                	li	s3,0
    506e:	b779                	j	4ffc <vprintf+0x44>
      if(c1) c2 = fmt[i+2] & 0xff;
    5070:	9752                	add	a4,a4,s4
    5072:	00274583          	lbu	a1,2(a4)
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
    5076:	f9460713          	addi	a4,a2,-108
    507a:	00173713          	seqz	a4,a4
    507e:	8f75                	and	a4,a4,a3
    5080:	f9c58513          	addi	a0,a1,-100
    5084:	18051363          	bnez	a0,520a <vprintf+0x252>
    5088:	18070163          	beqz	a4,520a <vprintf+0x252>
        printint(fd, va_arg(ap, uint64), 10, 1);
    508c:	008b8493          	addi	s1,s7,8
    5090:	4685                	li	a3,1
    5092:	4629                	li	a2,10
    5094:	000bb583          	ld	a1,0(s7)
    5098:	855a                	mv	a0,s6
    509a:	e81ff0ef          	jal	4f1a <printint>
        i += 2;
    509e:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 10, 1);
    50a0:	8ba6                	mv	s7,s1
      state = 0;
    50a2:	4981                	li	s3,0
        i += 2;
    50a4:	bfa1                	j	4ffc <vprintf+0x44>
        printint(fd, va_arg(ap, uint32), 10, 0);
    50a6:	008b8493          	addi	s1,s7,8
    50aa:	4681                	li	a3,0
    50ac:	4629                	li	a2,10
    50ae:	000be583          	lwu	a1,0(s7)
    50b2:	855a                	mv	a0,s6
    50b4:	e67ff0ef          	jal	4f1a <printint>
    50b8:	8ba6                	mv	s7,s1
      state = 0;
    50ba:	4981                	li	s3,0
    50bc:	b781                	j	4ffc <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 10, 0);
    50be:	008b8493          	addi	s1,s7,8
    50c2:	4681                	li	a3,0
    50c4:	4629                	li	a2,10
    50c6:	000bb583          	ld	a1,0(s7)
    50ca:	855a                	mv	a0,s6
    50cc:	e4fff0ef          	jal	4f1a <printint>
        i += 1;
    50d0:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 10, 0);
    50d2:	8ba6                	mv	s7,s1
      state = 0;
    50d4:	4981                	li	s3,0
    50d6:	b71d                	j	4ffc <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 10, 0);
    50d8:	008b8493          	addi	s1,s7,8
    50dc:	4681                	li	a3,0
    50de:	4629                	li	a2,10
    50e0:	000bb583          	ld	a1,0(s7)
    50e4:	855a                	mv	a0,s6
    50e6:	e35ff0ef          	jal	4f1a <printint>
        i += 2;
    50ea:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 10, 0);
    50ec:	8ba6                	mv	s7,s1
      state = 0;
    50ee:	4981                	li	s3,0
        i += 2;
    50f0:	b731                	j	4ffc <vprintf+0x44>
        printint(fd, va_arg(ap, uint32), 16, 0);
    50f2:	008b8493          	addi	s1,s7,8
    50f6:	4681                	li	a3,0
    50f8:	4641                	li	a2,16
    50fa:	000be583          	lwu	a1,0(s7)
    50fe:	855a                	mv	a0,s6
    5100:	e1bff0ef          	jal	4f1a <printint>
    5104:	8ba6                	mv	s7,s1
      state = 0;
    5106:	4981                	li	s3,0
    5108:	bdd5                	j	4ffc <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 16, 0);
    510a:	008b8493          	addi	s1,s7,8
    510e:	4681                	li	a3,0
    5110:	4641                	li	a2,16
    5112:	000bb583          	ld	a1,0(s7)
    5116:	855a                	mv	a0,s6
    5118:	e03ff0ef          	jal	4f1a <printint>
        i += 1;
    511c:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 16, 0);
    511e:	8ba6                	mv	s7,s1
      state = 0;
    5120:	4981                	li	s3,0
    5122:	bde9                	j	4ffc <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 16, 0);
    5124:	008b8493          	addi	s1,s7,8
    5128:	4681                	li	a3,0
    512a:	4641                	li	a2,16
    512c:	000bb583          	ld	a1,0(s7)
    5130:	855a                	mv	a0,s6
    5132:	de9ff0ef          	jal	4f1a <printint>
        i += 2;
    5136:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 16, 0);
    5138:	8ba6                	mv	s7,s1
      state = 0;
    513a:	4981                	li	s3,0
        i += 2;
    513c:	b5c1                	j	4ffc <vprintf+0x44>
    513e:	e466                	sd	s9,8(sp)
        printptr(fd, va_arg(ap, uint64));
    5140:	008b8793          	addi	a5,s7,8
    5144:	8cbe                	mv	s9,a5
    5146:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
    514a:	03000593          	li	a1,48
    514e:	855a                	mv	a0,s6
    5150:	dadff0ef          	jal	4efc <putc>
  putc(fd, 'x');
    5154:	07800593          	li	a1,120
    5158:	855a                	mv	a0,s6
    515a:	da3ff0ef          	jal	4efc <putc>
    515e:	44c1                	li	s1,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
    5160:	00003b97          	auipc	s7,0x3
    5164:	878b8b93          	addi	s7,s7,-1928 # 79d8 <digits>
    5168:	03c9d793          	srli	a5,s3,0x3c
    516c:	97de                	add	a5,a5,s7
    516e:	0007c583          	lbu	a1,0(a5)
    5172:	855a                	mv	a0,s6
    5174:	d89ff0ef          	jal	4efc <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
    5178:	0992                	slli	s3,s3,0x4
    517a:	34fd                	addiw	s1,s1,-1
    517c:	f4f5                	bnez	s1,5168 <vprintf+0x1b0>
        printptr(fd, va_arg(ap, uint64));
    517e:	8be6                	mv	s7,s9
      state = 0;
    5180:	4981                	li	s3,0
    5182:	6ca2                	ld	s9,8(sp)
    5184:	bda5                	j	4ffc <vprintf+0x44>
        putc(fd, va_arg(ap, uint32));
    5186:	008b8493          	addi	s1,s7,8
    518a:	000bc583          	lbu	a1,0(s7)
    518e:	855a                	mv	a0,s6
    5190:	d6dff0ef          	jal	4efc <putc>
    5194:	8ba6                	mv	s7,s1
      state = 0;
    5196:	4981                	li	s3,0
    5198:	b595                	j	4ffc <vprintf+0x44>
        if((s = va_arg(ap, char*)) == 0)
    519a:	008b8993          	addi	s3,s7,8
    519e:	000bb483          	ld	s1,0(s7)
    51a2:	cc91                	beqz	s1,51be <vprintf+0x206>
        for(; *s; s++)
    51a4:	0004c583          	lbu	a1,0(s1)
    51a8:	c985                	beqz	a1,51d8 <vprintf+0x220>
          putc(fd, *s);
    51aa:	855a                	mv	a0,s6
    51ac:	d51ff0ef          	jal	4efc <putc>
        for(; *s; s++)
    51b0:	0485                	addi	s1,s1,1
    51b2:	0004c583          	lbu	a1,0(s1)
    51b6:	f9f5                	bnez	a1,51aa <vprintf+0x1f2>
        if((s = va_arg(ap, char*)) == 0)
    51b8:	8bce                	mv	s7,s3
      state = 0;
    51ba:	4981                	li	s3,0
    51bc:	b581                	j	4ffc <vprintf+0x44>
          s = "(null)";
    51be:	00002497          	auipc	s1,0x2
    51c2:	76a48493          	addi	s1,s1,1898 # 7928 <malloc+0x25ce>
        for(; *s; s++)
    51c6:	02800593          	li	a1,40
    51ca:	b7c5                	j	51aa <vprintf+0x1f2>
        putc(fd, '%');
    51cc:	85be                	mv	a1,a5
    51ce:	855a                	mv	a0,s6
    51d0:	d2dff0ef          	jal	4efc <putc>
      state = 0;
    51d4:	4981                	li	s3,0
    51d6:	b51d                	j	4ffc <vprintf+0x44>
        if((s = va_arg(ap, char*)) == 0)
    51d8:	8bce                	mv	s7,s3
      state = 0;
    51da:	4981                	li	s3,0
    51dc:	b505                	j	4ffc <vprintf+0x44>
    51de:	6906                	ld	s2,64(sp)
    51e0:	79e2                	ld	s3,56(sp)
    51e2:	7a42                	ld	s4,48(sp)
    51e4:	7aa2                	ld	s5,40(sp)
    51e6:	7b02                	ld	s6,32(sp)
    51e8:	6be2                	ld	s7,24(sp)
    51ea:	6c42                	ld	s8,16(sp)
    }
  }
}
    51ec:	60e6                	ld	ra,88(sp)
    51ee:	6446                	ld	s0,80(sp)
    51f0:	64a6                	ld	s1,72(sp)
    51f2:	6125                	addi	sp,sp,96
    51f4:	8082                	ret
      if(c0 == 'd'){
    51f6:	06400713          	li	a4,100
    51fa:	e4e78fe3          	beq	a5,a4,5058 <vprintf+0xa0>
      } else if(c0 == 'l' && c1 == 'd'){
    51fe:	f9478693          	addi	a3,a5,-108
    5202:	0016b693          	seqz	a3,a3
      c1 = c2 = 0;
    5206:	85b2                	mv	a1,a2
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
    5208:	4701                	li	a4,0
      } else if(c0 == 'u'){
    520a:	07500513          	li	a0,117
    520e:	e8a78ce3          	beq	a5,a0,50a6 <vprintf+0xee>
      } else if(c0 == 'l' && c1 == 'u'){
    5212:	f8b60513          	addi	a0,a2,-117
    5216:	e119                	bnez	a0,521c <vprintf+0x264>
    5218:	ea0693e3          	bnez	a3,50be <vprintf+0x106>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
    521c:	f8b58513          	addi	a0,a1,-117
    5220:	e119                	bnez	a0,5226 <vprintf+0x26e>
    5222:	ea071be3          	bnez	a4,50d8 <vprintf+0x120>
      } else if(c0 == 'x'){
    5226:	07800513          	li	a0,120
    522a:	eca784e3          	beq	a5,a0,50f2 <vprintf+0x13a>
      } else if(c0 == 'l' && c1 == 'x'){
    522e:	f8860613          	addi	a2,a2,-120
    5232:	e219                	bnez	a2,5238 <vprintf+0x280>
    5234:	ec069be3          	bnez	a3,510a <vprintf+0x152>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
    5238:	f8858593          	addi	a1,a1,-120
    523c:	e199                	bnez	a1,5242 <vprintf+0x28a>
    523e:	ee0713e3          	bnez	a4,5124 <vprintf+0x16c>
      } else if(c0 == 'p'){
    5242:	07000713          	li	a4,112
    5246:	eee78ce3          	beq	a5,a4,513e <vprintf+0x186>
      } else if(c0 == 'c'){
    524a:	06300713          	li	a4,99
    524e:	f2e78ce3          	beq	a5,a4,5186 <vprintf+0x1ce>
      } else if(c0 == 's'){
    5252:	07300713          	li	a4,115
    5256:	f4e782e3          	beq	a5,a4,519a <vprintf+0x1e2>
      } else if(c0 == '%'){
    525a:	02500713          	li	a4,37
    525e:	f6e787e3          	beq	a5,a4,51cc <vprintf+0x214>
        putc(fd, '%');
    5262:	02500593          	li	a1,37
    5266:	855a                	mv	a0,s6
    5268:	c95ff0ef          	jal	4efc <putc>
        putc(fd, c0);
    526c:	85a6                	mv	a1,s1
    526e:	855a                	mv	a0,s6
    5270:	c8dff0ef          	jal	4efc <putc>
      state = 0;
    5274:	4981                	li	s3,0
    5276:	b359                	j	4ffc <vprintf+0x44>

0000000000005278 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
    5278:	715d                	addi	sp,sp,-80
    527a:	ec06                	sd	ra,24(sp)
    527c:	e822                	sd	s0,16(sp)
    527e:	1000                	addi	s0,sp,32
    5280:	e010                	sd	a2,0(s0)
    5282:	e414                	sd	a3,8(s0)
    5284:	e818                	sd	a4,16(s0)
    5286:	ec1c                	sd	a5,24(s0)
    5288:	03043023          	sd	a6,32(s0)
    528c:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
    5290:	8622                	mv	a2,s0
    5292:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
    5296:	d23ff0ef          	jal	4fb8 <vprintf>
}
    529a:	60e2                	ld	ra,24(sp)
    529c:	6442                	ld	s0,16(sp)
    529e:	6161                	addi	sp,sp,80
    52a0:	8082                	ret

00000000000052a2 <printf>:

void
printf(const char *fmt, ...)
{
    52a2:	711d                	addi	sp,sp,-96
    52a4:	ec06                	sd	ra,24(sp)
    52a6:	e822                	sd	s0,16(sp)
    52a8:	1000                	addi	s0,sp,32
    52aa:	e40c                	sd	a1,8(s0)
    52ac:	e810                	sd	a2,16(s0)
    52ae:	ec14                	sd	a3,24(s0)
    52b0:	f018                	sd	a4,32(s0)
    52b2:	f41c                	sd	a5,40(s0)
    52b4:	03043823          	sd	a6,48(s0)
    52b8:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
    52bc:	00840613          	addi	a2,s0,8
    52c0:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
    52c4:	85aa                	mv	a1,a0
    52c6:	4505                	li	a0,1
    52c8:	cf1ff0ef          	jal	4fb8 <vprintf>
}
    52cc:	60e2                	ld	ra,24(sp)
    52ce:	6442                	ld	s0,16(sp)
    52d0:	6125                	addi	sp,sp,96
    52d2:	8082                	ret

00000000000052d4 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
    52d4:	1141                	addi	sp,sp,-16
    52d6:	e406                	sd	ra,8(sp)
    52d8:	e022                	sd	s0,0(sp)
    52da:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
    52dc:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    52e0:	00004797          	auipc	a5,0x4
    52e4:	1907b783          	ld	a5,400(a5) # 9470 <freep>
    52e8:	a039                	j	52f6 <free+0x22>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    52ea:	6398                	ld	a4,0(a5)
    52ec:	00e7e463          	bltu	a5,a4,52f4 <free+0x20>
    52f0:	00e6ea63          	bltu	a3,a4,5304 <free+0x30>
{
    52f4:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    52f6:	fed7fae3          	bgeu	a5,a3,52ea <free+0x16>
    52fa:	6398                	ld	a4,0(a5)
    52fc:	00e6e463          	bltu	a3,a4,5304 <free+0x30>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    5300:	fee7eae3          	bltu	a5,a4,52f4 <free+0x20>
      break;
  if(bp + bp->s.size == p->s.ptr){
    5304:	ff852583          	lw	a1,-8(a0)
    5308:	6390                	ld	a2,0(a5)
    530a:	02059813          	slli	a6,a1,0x20
    530e:	01c85713          	srli	a4,a6,0x1c
    5312:	9736                	add	a4,a4,a3
    5314:	02e60563          	beq	a2,a4,533e <free+0x6a>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
    5318:	fec53823          	sd	a2,-16(a0)
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    531c:	4790                	lw	a2,8(a5)
    531e:	02061593          	slli	a1,a2,0x20
    5322:	01c5d713          	srli	a4,a1,0x1c
    5326:	973e                	add	a4,a4,a5
    5328:	02e68263          	beq	a3,a4,534c <free+0x78>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
    532c:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
    532e:	00004717          	auipc	a4,0x4
    5332:	14f73123          	sd	a5,322(a4) # 9470 <freep>
}
    5336:	60a2                	ld	ra,8(sp)
    5338:	6402                	ld	s0,0(sp)
    533a:	0141                	addi	sp,sp,16
    533c:	8082                	ret
    bp->s.size += p->s.ptr->s.size;
    533e:	4618                	lw	a4,8(a2)
    5340:	9f2d                	addw	a4,a4,a1
    5342:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
    5346:	6398                	ld	a4,0(a5)
    5348:	6310                	ld	a2,0(a4)
    534a:	b7f9                	j	5318 <free+0x44>
    p->s.size += bp->s.size;
    534c:	ff852703          	lw	a4,-8(a0)
    5350:	9f31                	addw	a4,a4,a2
    5352:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
    5354:	ff053683          	ld	a3,-16(a0)
    5358:	bfd1                	j	532c <free+0x58>

000000000000535a <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
    535a:	7139                	addi	sp,sp,-64
    535c:	fc06                	sd	ra,56(sp)
    535e:	f822                	sd	s0,48(sp)
    5360:	f04a                	sd	s2,32(sp)
    5362:	ec4e                	sd	s3,24(sp)
    5364:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
    5366:	02051993          	slli	s3,a0,0x20
    536a:	0209d993          	srli	s3,s3,0x20
    536e:	09bd                	addi	s3,s3,15
    5370:	0049d993          	srli	s3,s3,0x4
    5374:	2985                	addiw	s3,s3,1
    5376:	894e                	mv	s2,s3
  if((prevp = freep) == 0){
    5378:	00004517          	auipc	a0,0x4
    537c:	0f853503          	ld	a0,248(a0) # 9470 <freep>
    5380:	c905                	beqz	a0,53b0 <malloc+0x56>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    5382:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
    5384:	4798                	lw	a4,8(a5)
    5386:	09377663          	bgeu	a4,s3,5412 <malloc+0xb8>
    538a:	f426                	sd	s1,40(sp)
    538c:	e852                	sd	s4,16(sp)
    538e:	e456                	sd	s5,8(sp)
    5390:	e05a                	sd	s6,0(sp)
  if(nu < 4096)
    5392:	8a4e                	mv	s4,s3
    5394:	6705                	lui	a4,0x1
    5396:	00e9f363          	bgeu	s3,a4,539c <malloc+0x42>
    539a:	6a05                	lui	s4,0x1
    539c:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
    53a0:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
    53a4:	00004497          	auipc	s1,0x4
    53a8:	0cc48493          	addi	s1,s1,204 # 9470 <freep>
  if(p == SBRK_ERROR)
    53ac:	5afd                	li	s5,-1
    53ae:	a83d                	j	53ec <malloc+0x92>
    53b0:	f426                	sd	s1,40(sp)
    53b2:	e852                	sd	s4,16(sp)
    53b4:	e456                	sd	s5,8(sp)
    53b6:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
    53b8:	0000b797          	auipc	a5,0xb
    53bc:	8e078793          	addi	a5,a5,-1824 # fc98 <base>
    53c0:	00004717          	auipc	a4,0x4
    53c4:	0af73823          	sd	a5,176(a4) # 9470 <freep>
    53c8:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
    53ca:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
    53ce:	b7d1                	j	5392 <malloc+0x38>
        prevp->s.ptr = p->s.ptr;
    53d0:	6398                	ld	a4,0(a5)
    53d2:	e118                	sd	a4,0(a0)
    53d4:	a899                	j	542a <malloc+0xd0>
  hp->s.size = nu;
    53d6:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
    53da:	0541                	addi	a0,a0,16
    53dc:	ef9ff0ef          	jal	52d4 <free>
  return freep;
    53e0:	6088                	ld	a0,0(s1)
      if((p = morecore(nunits)) == 0)
    53e2:	c125                	beqz	a0,5442 <malloc+0xe8>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    53e4:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
    53e6:	4798                	lw	a4,8(a5)
    53e8:	03277163          	bgeu	a4,s2,540a <malloc+0xb0>
    if(p == freep)
    53ec:	6098                	ld	a4,0(s1)
    53ee:	853e                	mv	a0,a5
    53f0:	fef71ae3          	bne	a4,a5,53e4 <malloc+0x8a>
  p = sbrk(nu * sizeof(Header));
    53f4:	8552                	mv	a0,s4
    53f6:	a2bff0ef          	jal	4e20 <sbrk>
  if(p == SBRK_ERROR)
    53fa:	fd551ee3          	bne	a0,s5,53d6 <malloc+0x7c>
        return 0;
    53fe:	4501                	li	a0,0
    5400:	74a2                	ld	s1,40(sp)
    5402:	6a42                	ld	s4,16(sp)
    5404:	6aa2                	ld	s5,8(sp)
    5406:	6b02                	ld	s6,0(sp)
    5408:	a03d                	j	5436 <malloc+0xdc>
    540a:	74a2                	ld	s1,40(sp)
    540c:	6a42                	ld	s4,16(sp)
    540e:	6aa2                	ld	s5,8(sp)
    5410:	6b02                	ld	s6,0(sp)
      if(p->s.size == nunits)
    5412:	fae90fe3          	beq	s2,a4,53d0 <malloc+0x76>
        p->s.size -= nunits;
    5416:	4137073b          	subw	a4,a4,s3
    541a:	c798                	sw	a4,8(a5)
        p += p->s.size;
    541c:	02071693          	slli	a3,a4,0x20
    5420:	01c6d713          	srli	a4,a3,0x1c
    5424:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
    5426:	0137a423          	sw	s3,8(a5)
      freep = prevp;
    542a:	00004717          	auipc	a4,0x4
    542e:	04a73323          	sd	a0,70(a4) # 9470 <freep>
      return (void*)(p + 1);
    5432:	01078513          	addi	a0,a5,16
  }
}
    5436:	70e2                	ld	ra,56(sp)
    5438:	7442                	ld	s0,48(sp)
    543a:	7902                	ld	s2,32(sp)
    543c:	69e2                	ld	s3,24(sp)
    543e:	6121                	addi	sp,sp,64
    5440:	8082                	ret
    5442:	74a2                	ld	s1,40(sp)
    5444:	6a42                	ld	s4,16(sp)
    5446:	6aa2                	ld	s5,8(sp)
    5448:	6b02                	ld	s6,0(sp)
    544a:	b7f5                	j	5436 <malloc+0xdc>
