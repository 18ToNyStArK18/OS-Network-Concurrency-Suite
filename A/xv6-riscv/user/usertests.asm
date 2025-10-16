
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
      14:	b5078793          	addi	a5,a5,-1200 # 7b60 <malloc+0x2678>
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
      4a:	7e1040ef          	jal	502a <open>
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
      70:	57450513          	addi	a0,a0,1396 # 55e0 <malloc+0xf8>
      74:	3bc050ef          	jal	5430 <printf>
      exit(1);
      78:	4505                	li	a0,1
      7a:	771040ef          	jal	4fea <exit>

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
      aa:	55a50513          	addi	a0,a0,1370 # 5600 <malloc+0x118>
      ae:	382050ef          	jal	5430 <printf>
      exit(1);
      b2:	4505                	li	a0,1
      b4:	737040ef          	jal	4fea <exit>

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
      ca:	55250513          	addi	a0,a0,1362 # 5618 <malloc+0x130>
      ce:	75d040ef          	jal	502a <open>
  if(fd < 0){
      d2:	02054263          	bltz	a0,f6 <opentest+0x3e>
  close(fd);
      d6:	73d040ef          	jal	5012 <close>
  fd = open("doesnotexist", 0);
      da:	4581                	li	a1,0
      dc:	00005517          	auipc	a0,0x5
      e0:	55c50513          	addi	a0,a0,1372 # 5638 <malloc+0x150>
      e4:	747040ef          	jal	502a <open>
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
      fc:	52850513          	addi	a0,a0,1320 # 5620 <malloc+0x138>
     100:	330050ef          	jal	5430 <printf>
    exit(1);
     104:	4505                	li	a0,1
     106:	6e5040ef          	jal	4fea <exit>
    printf("%s: open doesnotexist succeeded!\n", s);
     10a:	85a6                	mv	a1,s1
     10c:	00005517          	auipc	a0,0x5
     110:	53c50513          	addi	a0,a0,1340 # 5648 <malloc+0x160>
     114:	31c050ef          	jal	5430 <printf>
    exit(1);
     118:	4505                	li	a0,1
     11a:	6d1040ef          	jal	4fea <exit>

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
     132:	54250513          	addi	a0,a0,1346 # 5670 <malloc+0x188>
     136:	705040ef          	jal	503a <unlink>
  int fd1 = open("truncfile", O_CREATE|O_TRUNC|O_WRONLY);
     13a:	60100593          	li	a1,1537
     13e:	00005517          	auipc	a0,0x5
     142:	53250513          	addi	a0,a0,1330 # 5670 <malloc+0x188>
     146:	6e5040ef          	jal	502a <open>
     14a:	84aa                	mv	s1,a0
  write(fd1, "abcd", 4);
     14c:	4611                	li	a2,4
     14e:	00005597          	auipc	a1,0x5
     152:	53258593          	addi	a1,a1,1330 # 5680 <malloc+0x198>
     156:	6b5040ef          	jal	500a <write>
  int fd2 = open("truncfile", O_TRUNC|O_WRONLY);
     15a:	40100593          	li	a1,1025
     15e:	00005517          	auipc	a0,0x5
     162:	51250513          	addi	a0,a0,1298 # 5670 <malloc+0x188>
     166:	6c5040ef          	jal	502a <open>
     16a:	892a                	mv	s2,a0
  int n = write(fd1, "x", 1);
     16c:	4605                	li	a2,1
     16e:	00005597          	auipc	a1,0x5
     172:	51a58593          	addi	a1,a1,1306 # 5688 <malloc+0x1a0>
     176:	8526                	mv	a0,s1
     178:	693040ef          	jal	500a <write>
  if(n != -1){
     17c:	57fd                	li	a5,-1
     17e:	02f51563          	bne	a0,a5,1a8 <truncate2+0x8a>
  unlink("truncfile");
     182:	00005517          	auipc	a0,0x5
     186:	4ee50513          	addi	a0,a0,1262 # 5670 <malloc+0x188>
     18a:	6b1040ef          	jal	503a <unlink>
  close(fd1);
     18e:	8526                	mv	a0,s1
     190:	683040ef          	jal	5012 <close>
  close(fd2);
     194:	854a                	mv	a0,s2
     196:	67d040ef          	jal	5012 <close>
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
     1b0:	4e450513          	addi	a0,a0,1252 # 5690 <malloc+0x1a8>
     1b4:	27c050ef          	jal	5430 <printf>
    exit(1);
     1b8:	4505                	li	a0,1
     1ba:	631040ef          	jal	4fea <exit>

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
     1f2:	639040ef          	jal	502a <open>
    close(fd);
     1f6:	61d040ef          	jal	5012 <close>
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
     222:	619040ef          	jal	503a <unlink>
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
     260:	45c50513          	addi	a0,a0,1116 # 56b8 <malloc+0x1d0>
     264:	5d7040ef          	jal	503a <unlink>
  for(sz = 499; sz < (MAXOPBLOCKS+2)*BSIZE; sz += 471){
     268:	1f300493          	li	s1,499
    fd = open("bigwrite", O_CREATE | O_RDWR);
     26c:	20200b93          	li	s7,514
     270:	00005a17          	auipc	s4,0x5
     274:	448a0a13          	addi	s4,s4,1096 # 56b8 <malloc+0x1d0>
     278:	4b09                	li	s6,2
      int cc = write(fd, buf, sz);
     27a:	0000e997          	auipc	s3,0xe
     27e:	a3e98993          	addi	s3,s3,-1474 # dcb8 <buf>
  for(sz = 499; sz < (MAXOPBLOCKS+2)*BSIZE; sz += 471){
     282:	6a8d                	lui	s5,0x3
     284:	1c9a8a93          	addi	s5,s5,457 # 31c9 <subdir+0x4c9>
    fd = open("bigwrite", O_CREATE | O_RDWR);
     288:	85de                	mv	a1,s7
     28a:	8552                	mv	a0,s4
     28c:	59f040ef          	jal	502a <open>
     290:	892a                	mv	s2,a0
    if(fd < 0){
     292:	04054463          	bltz	a0,2da <bigwrite+0x9a>
     296:	8c5a                	mv	s8,s6
      int cc = write(fd, buf, sz);
     298:	8626                	mv	a2,s1
     29a:	85ce                	mv	a1,s3
     29c:	854a                	mv	a0,s2
     29e:	56d040ef          	jal	500a <write>
      if(cc != sz){
     2a2:	04951663          	bne	a0,s1,2ee <bigwrite+0xae>
    for(i = 0; i < 2; i++){
     2a6:	3c7d                	addiw	s8,s8,-1
     2a8:	fe0c18e3          	bnez	s8,298 <bigwrite+0x58>
    close(fd);
     2ac:	854a                	mv	a0,s2
     2ae:	565040ef          	jal	5012 <close>
    unlink("bigwrite");
     2b2:	8552                	mv	a0,s4
     2b4:	587040ef          	jal	503a <unlink>
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
     2e0:	3ec50513          	addi	a0,a0,1004 # 56c8 <malloc+0x1e0>
     2e4:	14c050ef          	jal	5430 <printf>
      exit(1);
     2e8:	4505                	li	a0,1
     2ea:	501040ef          	jal	4fea <exit>
        printf("%s: write(%d) ret %d\n", s, sz, cc);
     2ee:	86aa                	mv	a3,a0
     2f0:	8626                	mv	a2,s1
     2f2:	85e6                	mv	a1,s9
     2f4:	00005517          	auipc	a0,0x5
     2f8:	3f450513          	addi	a0,a0,1012 # 56e8 <malloc+0x200>
     2fc:	134050ef          	jal	5430 <printf>
        exit(1);
     300:	4505                	li	a0,1
     302:	4e9040ef          	jal	4fea <exit>

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
     31e:	3e650513          	addi	a0,a0,998 # 5700 <malloc+0x218>
     322:	519040ef          	jal	503a <unlink>
     326:	25800913          	li	s2,600
  for(int i = 0; i < assumed_free; i++){
    int fd = open("junk", O_CREATE|O_WRONLY);
     32a:	20100a93          	li	s5,513
     32e:	00005997          	auipc	s3,0x5
     332:	3d298993          	addi	s3,s3,978 # 5700 <malloc+0x218>
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
     342:	4e9040ef          	jal	502a <open>
     346:	84aa                	mv	s1,a0
    if(fd < 0){
     348:	04054d63          	bltz	a0,3a2 <badwrite+0x9c>
    write(fd, (char*)0xffffffffffL, 1);
     34c:	865a                	mv	a2,s6
     34e:	85d2                	mv	a1,s4
     350:	4bb040ef          	jal	500a <write>
    close(fd);
     354:	8526                	mv	a0,s1
     356:	4bd040ef          	jal	5012 <close>
    unlink("junk");
     35a:	854e                	mv	a0,s3
     35c:	4df040ef          	jal	503a <unlink>
  for(int i = 0; i < assumed_free; i++){
     360:	397d                	addiw	s2,s2,-1
     362:	fc091ee3          	bnez	s2,33e <badwrite+0x38>
  }

  int fd = open("junk", O_CREATE|O_WRONLY);
     366:	20100593          	li	a1,513
     36a:	00005517          	auipc	a0,0x5
     36e:	39650513          	addi	a0,a0,918 # 5700 <malloc+0x218>
     372:	4b9040ef          	jal	502a <open>
     376:	84aa                	mv	s1,a0
  if(fd < 0){
     378:	02054e63          	bltz	a0,3b4 <badwrite+0xae>
    printf("open junk failed\n");
    exit(1);
  }
  if(write(fd, "x", 1) != 1){
     37c:	4605                	li	a2,1
     37e:	00005597          	auipc	a1,0x5
     382:	30a58593          	addi	a1,a1,778 # 5688 <malloc+0x1a0>
     386:	485040ef          	jal	500a <write>
     38a:	4785                	li	a5,1
     38c:	02f50d63          	beq	a0,a5,3c6 <badwrite+0xc0>
    printf("write failed\n");
     390:	00005517          	auipc	a0,0x5
     394:	39050513          	addi	a0,a0,912 # 5720 <malloc+0x238>
     398:	098050ef          	jal	5430 <printf>
    exit(1);
     39c:	4505                	li	a0,1
     39e:	44d040ef          	jal	4fea <exit>
      printf("open junk failed\n");
     3a2:	00005517          	auipc	a0,0x5
     3a6:	36650513          	addi	a0,a0,870 # 5708 <malloc+0x220>
     3aa:	086050ef          	jal	5430 <printf>
      exit(1);
     3ae:	4505                	li	a0,1
     3b0:	43b040ef          	jal	4fea <exit>
    printf("open junk failed\n");
     3b4:	00005517          	auipc	a0,0x5
     3b8:	35450513          	addi	a0,a0,852 # 5708 <malloc+0x220>
     3bc:	074050ef          	jal	5430 <printf>
    exit(1);
     3c0:	4505                	li	a0,1
     3c2:	429040ef          	jal	4fea <exit>
  }
  close(fd);
     3c6:	8526                	mv	a0,s1
     3c8:	44b040ef          	jal	5012 <close>
  unlink("junk");
     3cc:	00005517          	auipc	a0,0x5
     3d0:	33450513          	addi	a0,a0,820 # 5700 <malloc+0x218>
     3d4:	467040ef          	jal	503a <unlink>

  exit(0);
     3d8:	4501                	li	a0,0
     3da:	411040ef          	jal	4fea <exit>

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
     434:	407040ef          	jal	503a <unlink>
    int fd = open(name, O_CREATE|O_RDWR|O_TRUNC);
     438:	85d2                	mv	a1,s4
     43a:	854a                	mv	a0,s2
     43c:	3ef040ef          	jal	502a <open>
    if(fd < 0){
     440:	00054763          	bltz	a0,44e <outofinodes+0x70>
      // failure is eventually expected.
      break;
    }
    close(fd);
     444:	3cf040ef          	jal	5012 <close>
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
     48e:	3ad040ef          	jal	503a <unlink>
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
     4c8:	69c78793          	addi	a5,a5,1692 # 7b60 <malloc+0x2678>
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
     4fa:	23aa8a93          	addi	s5,s5,570 # 5730 <malloc+0x248>
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
     50e:	31d040ef          	jal	502a <open>
     512:	84aa                	mv	s1,a0
    if(fd < 0){
     514:	06054a63          	bltz	a0,588 <copyin+0xde>
    int n = write(fd, (void*)addr, 8192);
     518:	8652                	mv	a2,s4
     51a:	85ce                	mv	a1,s3
     51c:	2ef040ef          	jal	500a <write>
    if(n >= 0){
     520:	06055d63          	bgez	a0,59a <copyin+0xf0>
    close(fd);
     524:	8526                	mv	a0,s1
     526:	2ed040ef          	jal	5012 <close>
    unlink("copyin1");
     52a:	8556                	mv	a0,s5
     52c:	30f040ef          	jal	503a <unlink>
    n = write(1, (char*)addr, 8192);
     530:	8652                	mv	a2,s4
     532:	85ce                	mv	a1,s3
     534:	8562                	mv	a0,s8
     536:	2d5040ef          	jal	500a <write>
    if(n > 0){
     53a:	06a04b63          	bgtz	a0,5b0 <copyin+0x106>
    if(pipe(fds) < 0){
     53e:	855e                	mv	a0,s7
     540:	2bb040ef          	jal	4ffa <pipe>
     544:	08054163          	bltz	a0,5c6 <copyin+0x11c>
    n = write(fds[1], (char*)addr, 8192);
     548:	8652                	mv	a2,s4
     54a:	85ce                	mv	a1,s3
     54c:	f7442503          	lw	a0,-140(s0)
     550:	2bb040ef          	jal	500a <write>
    if(n > 0){
     554:	08a04263          	bgtz	a0,5d8 <copyin+0x12e>
    close(fds[0]);
     558:	f7042503          	lw	a0,-144(s0)
     55c:	2b7040ef          	jal	5012 <close>
    close(fds[1]);
     560:	f7442503          	lw	a0,-140(s0)
     564:	2af040ef          	jal	5012 <close>
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
     58c:	1b050513          	addi	a0,a0,432 # 5738 <malloc+0x250>
     590:	6a1040ef          	jal	5430 <printf>
      exit(1);
     594:	4505                	li	a0,1
     596:	255040ef          	jal	4fea <exit>
      printf("write(fd, %p, 8192) returned %d, not -1\n", (void*)addr, n);
     59a:	862a                	mv	a2,a0
     59c:	85ce                	mv	a1,s3
     59e:	00005517          	auipc	a0,0x5
     5a2:	1b250513          	addi	a0,a0,434 # 5750 <malloc+0x268>
     5a6:	68b040ef          	jal	5430 <printf>
      exit(1);
     5aa:	4505                	li	a0,1
     5ac:	23f040ef          	jal	4fea <exit>
      printf("write(1, %p, 8192) returned %d, not -1 or 0\n", (void*)addr, n);
     5b0:	862a                	mv	a2,a0
     5b2:	85ce                	mv	a1,s3
     5b4:	00005517          	auipc	a0,0x5
     5b8:	1cc50513          	addi	a0,a0,460 # 5780 <malloc+0x298>
     5bc:	675040ef          	jal	5430 <printf>
      exit(1);
     5c0:	4505                	li	a0,1
     5c2:	229040ef          	jal	4fea <exit>
      printf("pipe() failed\n");
     5c6:	00005517          	auipc	a0,0x5
     5ca:	1ea50513          	addi	a0,a0,490 # 57b0 <malloc+0x2c8>
     5ce:	663040ef          	jal	5430 <printf>
      exit(1);
     5d2:	4505                	li	a0,1
     5d4:	217040ef          	jal	4fea <exit>
      printf("write(pipe, %p, 8192) returned %d, not -1 or 0\n", (void*)addr, n);
     5d8:	862a                	mv	a2,a0
     5da:	85ce                	mv	a1,s3
     5dc:	00005517          	auipc	a0,0x5
     5e0:	1e450513          	addi	a0,a0,484 # 57c0 <malloc+0x2d8>
     5e4:	64d040ef          	jal	5430 <printf>
      exit(1);
     5e8:	4505                	li	a0,1
     5ea:	201040ef          	jal	4fea <exit>

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
     60c:	55878793          	addi	a5,a5,1368 # 7b60 <malloc+0x2678>
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
     640:	1b4b0b13          	addi	s6,s6,436 # 57f0 <malloc+0x308>
    int n = read(fd, (void*)addr, 8192);
     644:	6a89                	lui	s5,0x2
    if(pipe(fds) < 0){
     646:	f6840c13          	addi	s8,s0,-152
    n = write(fds[1], "x", 1);
     64a:	4a05                	li	s4,1
     64c:	00005b97          	auipc	s7,0x5
     650:	03cb8b93          	addi	s7,s7,60 # 5688 <malloc+0x1a0>
    uint64 addr = addrs[ai];
     654:	00093983          	ld	s3,0(s2)
    int fd = open("README", 0);
     658:	4581                	li	a1,0
     65a:	855a                	mv	a0,s6
     65c:	1cf040ef          	jal	502a <open>
     660:	84aa                	mv	s1,a0
    if(fd < 0){
     662:	06054863          	bltz	a0,6d2 <copyout+0xe4>
    int n = read(fd, (void*)addr, 8192);
     666:	8656                	mv	a2,s5
     668:	85ce                	mv	a1,s3
     66a:	199040ef          	jal	5002 <read>
    if(n > 0){
     66e:	06a04b63          	bgtz	a0,6e4 <copyout+0xf6>
    close(fd);
     672:	8526                	mv	a0,s1
     674:	19f040ef          	jal	5012 <close>
    if(pipe(fds) < 0){
     678:	8562                	mv	a0,s8
     67a:	181040ef          	jal	4ffa <pipe>
     67e:	06054e63          	bltz	a0,6fa <copyout+0x10c>
    n = write(fds[1], "x", 1);
     682:	8652                	mv	a2,s4
     684:	85de                	mv	a1,s7
     686:	f6c42503          	lw	a0,-148(s0)
     68a:	181040ef          	jal	500a <write>
    if(n != 1){
     68e:	07451f63          	bne	a0,s4,70c <copyout+0x11e>
    n = read(fds[0], (void*)addr, 8192);
     692:	8656                	mv	a2,s5
     694:	85ce                	mv	a1,s3
     696:	f6842503          	lw	a0,-152(s0)
     69a:	169040ef          	jal	5002 <read>
    if(n > 0){
     69e:	08a04063          	bgtz	a0,71e <copyout+0x130>
    close(fds[0]);
     6a2:	f6842503          	lw	a0,-152(s0)
     6a6:	16d040ef          	jal	5012 <close>
    close(fds[1]);
     6aa:	f6c42503          	lw	a0,-148(s0)
     6ae:	165040ef          	jal	5012 <close>
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
     6d6:	12650513          	addi	a0,a0,294 # 57f8 <malloc+0x310>
     6da:	557040ef          	jal	5430 <printf>
      exit(1);
     6de:	4505                	li	a0,1
     6e0:	10b040ef          	jal	4fea <exit>
      printf("read(fd, %p, 8192) returned %d, not -1 or 0\n", (void*)addr, n);
     6e4:	862a                	mv	a2,a0
     6e6:	85ce                	mv	a1,s3
     6e8:	00005517          	auipc	a0,0x5
     6ec:	12850513          	addi	a0,a0,296 # 5810 <malloc+0x328>
     6f0:	541040ef          	jal	5430 <printf>
      exit(1);
     6f4:	4505                	li	a0,1
     6f6:	0f5040ef          	jal	4fea <exit>
      printf("pipe() failed\n");
     6fa:	00005517          	auipc	a0,0x5
     6fe:	0b650513          	addi	a0,a0,182 # 57b0 <malloc+0x2c8>
     702:	52f040ef          	jal	5430 <printf>
      exit(1);
     706:	4505                	li	a0,1
     708:	0e3040ef          	jal	4fea <exit>
      printf("pipe write failed\n");
     70c:	00005517          	auipc	a0,0x5
     710:	13450513          	addi	a0,a0,308 # 5840 <malloc+0x358>
     714:	51d040ef          	jal	5430 <printf>
      exit(1);
     718:	4505                	li	a0,1
     71a:	0d1040ef          	jal	4fea <exit>
      printf("read(pipe, %p, 8192) returned %d, not -1 or 0\n", (void*)addr, n);
     71e:	862a                	mv	a2,a0
     720:	85ce                	mv	a1,s3
     722:	00005517          	auipc	a0,0x5
     726:	13650513          	addi	a0,a0,310 # 5858 <malloc+0x370>
     72a:	507040ef          	jal	5430 <printf>
      exit(1);
     72e:	4505                	li	a0,1
     730:	0bb040ef          	jal	4fea <exit>

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
     74c:	f2850513          	addi	a0,a0,-216 # 5670 <malloc+0x188>
     750:	0eb040ef          	jal	503a <unlink>
  int fd1 = open("truncfile", O_CREATE|O_WRONLY|O_TRUNC);
     754:	60100593          	li	a1,1537
     758:	00005517          	auipc	a0,0x5
     75c:	f1850513          	addi	a0,a0,-232 # 5670 <malloc+0x188>
     760:	0cb040ef          	jal	502a <open>
     764:	84aa                	mv	s1,a0
  write(fd1, "abcd", 4);
     766:	4611                	li	a2,4
     768:	00005597          	auipc	a1,0x5
     76c:	f1858593          	addi	a1,a1,-232 # 5680 <malloc+0x198>
     770:	09b040ef          	jal	500a <write>
  close(fd1);
     774:	8526                	mv	a0,s1
     776:	09d040ef          	jal	5012 <close>
  int fd2 = open("truncfile", O_RDONLY);
     77a:	4581                	li	a1,0
     77c:	00005517          	auipc	a0,0x5
     780:	ef450513          	addi	a0,a0,-268 # 5670 <malloc+0x188>
     784:	0a7040ef          	jal	502a <open>
     788:	84aa                	mv	s1,a0
  int n = read(fd2, buf, sizeof(buf));
     78a:	02000613          	li	a2,32
     78e:	fa040593          	addi	a1,s0,-96
     792:	071040ef          	jal	5002 <read>
  if(n != 4){
     796:	4791                	li	a5,4
     798:	0af51863          	bne	a0,a5,848 <truncate1+0x114>
  fd1 = open("truncfile", O_WRONLY|O_TRUNC);
     79c:	40100593          	li	a1,1025
     7a0:	00005517          	auipc	a0,0x5
     7a4:	ed050513          	addi	a0,a0,-304 # 5670 <malloc+0x188>
     7a8:	083040ef          	jal	502a <open>
     7ac:	89aa                	mv	s3,a0
  int fd3 = open("truncfile", O_RDONLY);
     7ae:	4581                	li	a1,0
     7b0:	00005517          	auipc	a0,0x5
     7b4:	ec050513          	addi	a0,a0,-320 # 5670 <malloc+0x188>
     7b8:	073040ef          	jal	502a <open>
     7bc:	892a                	mv	s2,a0
  n = read(fd3, buf, sizeof(buf));
     7be:	02000613          	li	a2,32
     7c2:	fa040593          	addi	a1,s0,-96
     7c6:	03d040ef          	jal	5002 <read>
     7ca:	8aaa                	mv	s5,a0
  if(n != 0){
     7cc:	e949                	bnez	a0,85e <truncate1+0x12a>
  n = read(fd2, buf, sizeof(buf));
     7ce:	02000613          	li	a2,32
     7d2:	fa040593          	addi	a1,s0,-96
     7d6:	8526                	mv	a0,s1
     7d8:	02b040ef          	jal	5002 <read>
     7dc:	8aaa                	mv	s5,a0
  if(n != 0){
     7de:	e155                	bnez	a0,882 <truncate1+0x14e>
  write(fd1, "abcdef", 6);
     7e0:	4619                	li	a2,6
     7e2:	00005597          	auipc	a1,0x5
     7e6:	10658593          	addi	a1,a1,262 # 58e8 <malloc+0x400>
     7ea:	854e                	mv	a0,s3
     7ec:	01f040ef          	jal	500a <write>
  n = read(fd3, buf, sizeof(buf));
     7f0:	02000613          	li	a2,32
     7f4:	fa040593          	addi	a1,s0,-96
     7f8:	854a                	mv	a0,s2
     7fa:	009040ef          	jal	5002 <read>
  if(n != 6){
     7fe:	4799                	li	a5,6
     800:	0af51363          	bne	a0,a5,8a6 <truncate1+0x172>
  n = read(fd2, buf, sizeof(buf));
     804:	02000613          	li	a2,32
     808:	fa040593          	addi	a1,s0,-96
     80c:	8526                	mv	a0,s1
     80e:	7f4040ef          	jal	5002 <read>
  if(n != 2){
     812:	4789                	li	a5,2
     814:	0af51463          	bne	a0,a5,8bc <truncate1+0x188>
  unlink("truncfile");
     818:	00005517          	auipc	a0,0x5
     81c:	e5850513          	addi	a0,a0,-424 # 5670 <malloc+0x188>
     820:	01b040ef          	jal	503a <unlink>
  close(fd1);
     824:	854e                	mv	a0,s3
     826:	7ec040ef          	jal	5012 <close>
  close(fd2);
     82a:	8526                	mv	a0,s1
     82c:	7e6040ef          	jal	5012 <close>
  close(fd3);
     830:	854a                	mv	a0,s2
     832:	7e0040ef          	jal	5012 <close>
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
     850:	03c50513          	addi	a0,a0,60 # 5888 <malloc+0x3a0>
     854:	3dd040ef          	jal	5430 <printf>
    exit(1);
     858:	4505                	li	a0,1
     85a:	790040ef          	jal	4fea <exit>
    printf("aaa fd3=%d\n", fd3);
     85e:	85ca                	mv	a1,s2
     860:	00005517          	auipc	a0,0x5
     864:	04850513          	addi	a0,a0,72 # 58a8 <malloc+0x3c0>
     868:	3c9040ef          	jal	5430 <printf>
    printf("%s: read %d bytes, wanted 0\n", s, n);
     86c:	8656                	mv	a2,s5
     86e:	85d2                	mv	a1,s4
     870:	00005517          	auipc	a0,0x5
     874:	04850513          	addi	a0,a0,72 # 58b8 <malloc+0x3d0>
     878:	3b9040ef          	jal	5430 <printf>
    exit(1);
     87c:	4505                	li	a0,1
     87e:	76c040ef          	jal	4fea <exit>
    printf("bbb fd2=%d\n", fd2);
     882:	85a6                	mv	a1,s1
     884:	00005517          	auipc	a0,0x5
     888:	05450513          	addi	a0,a0,84 # 58d8 <malloc+0x3f0>
     88c:	3a5040ef          	jal	5430 <printf>
    printf("%s: read %d bytes, wanted 0\n", s, n);
     890:	8656                	mv	a2,s5
     892:	85d2                	mv	a1,s4
     894:	00005517          	auipc	a0,0x5
     898:	02450513          	addi	a0,a0,36 # 58b8 <malloc+0x3d0>
     89c:	395040ef          	jal	5430 <printf>
    exit(1);
     8a0:	4505                	li	a0,1
     8a2:	748040ef          	jal	4fea <exit>
    printf("%s: read %d bytes, wanted 6\n", s, n);
     8a6:	862a                	mv	a2,a0
     8a8:	85d2                	mv	a1,s4
     8aa:	00005517          	auipc	a0,0x5
     8ae:	04650513          	addi	a0,a0,70 # 58f0 <malloc+0x408>
     8b2:	37f040ef          	jal	5430 <printf>
    exit(1);
     8b6:	4505                	li	a0,1
     8b8:	732040ef          	jal	4fea <exit>
    printf("%s: read %d bytes, wanted 2\n", s, n);
     8bc:	862a                	mv	a2,a0
     8be:	85d2                	mv	a1,s4
     8c0:	00005517          	auipc	a0,0x5
     8c4:	05050513          	addi	a0,a0,80 # 5910 <malloc+0x428>
     8c8:	369040ef          	jal	5430 <printf>
    exit(1);
     8cc:	4505                	li	a0,1
     8ce:	71c040ef          	jal	4fea <exit>

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
     8f2:	04250513          	addi	a0,a0,66 # 5930 <malloc+0x448>
     8f6:	734040ef          	jal	502a <open>
  if(fd < 0){
     8fa:	08054f63          	bltz	a0,998 <writetest+0xc6>
     8fe:	89aa                	mv	s3,a0
     900:	4901                	li	s2,0
    if(write(fd, "aaaaaaaaaa", SZ) != SZ){
     902:	44a9                	li	s1,10
     904:	00005a17          	auipc	s4,0x5
     908:	054a0a13          	addi	s4,s4,84 # 5958 <malloc+0x470>
    if(write(fd, "bbbbbbbbbb", SZ) != SZ){
     90c:	00005b17          	auipc	s6,0x5
     910:	084b0b13          	addi	s6,s6,132 # 5990 <malloc+0x4a8>
  for(i = 0; i < N; i++){
     914:	06400a93          	li	s5,100
    if(write(fd, "aaaaaaaaaa", SZ) != SZ){
     918:	8626                	mv	a2,s1
     91a:	85d2                	mv	a1,s4
     91c:	854e                	mv	a0,s3
     91e:	6ec040ef          	jal	500a <write>
     922:	08951563          	bne	a0,s1,9ac <writetest+0xda>
    if(write(fd, "bbbbbbbbbb", SZ) != SZ){
     926:	8626                	mv	a2,s1
     928:	85da                	mv	a1,s6
     92a:	854e                	mv	a0,s3
     92c:	6de040ef          	jal	500a <write>
     930:	08951963          	bne	a0,s1,9c2 <writetest+0xf0>
  for(i = 0; i < N; i++){
     934:	2905                	addiw	s2,s2,1
     936:	ff5911e3          	bne	s2,s5,918 <writetest+0x46>
  close(fd);
     93a:	854e                	mv	a0,s3
     93c:	6d6040ef          	jal	5012 <close>
  fd = open("small", O_RDONLY);
     940:	4581                	li	a1,0
     942:	00005517          	auipc	a0,0x5
     946:	fee50513          	addi	a0,a0,-18 # 5930 <malloc+0x448>
     94a:	6e0040ef          	jal	502a <open>
     94e:	84aa                	mv	s1,a0
  if(fd < 0){
     950:	08054463          	bltz	a0,9d8 <writetest+0x106>
  i = read(fd, buf, N*SZ*2);
     954:	7d000613          	li	a2,2000
     958:	0000d597          	auipc	a1,0xd
     95c:	36058593          	addi	a1,a1,864 # dcb8 <buf>
     960:	6a2040ef          	jal	5002 <read>
  if(i != N*SZ*2){
     964:	7d000793          	li	a5,2000
     968:	08f51263          	bne	a0,a5,9ec <writetest+0x11a>
  close(fd);
     96c:	8526                	mv	a0,s1
     96e:	6a4040ef          	jal	5012 <close>
  if(unlink("small") < 0){
     972:	00005517          	auipc	a0,0x5
     976:	fbe50513          	addi	a0,a0,-66 # 5930 <malloc+0x448>
     97a:	6c0040ef          	jal	503a <unlink>
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
     99e:	f9e50513          	addi	a0,a0,-98 # 5938 <malloc+0x450>
     9a2:	28f040ef          	jal	5430 <printf>
    exit(1);
     9a6:	4505                	li	a0,1
     9a8:	642040ef          	jal	4fea <exit>
      printf("%s: error: write aa %d new file failed\n", s, i);
     9ac:	864a                	mv	a2,s2
     9ae:	85de                	mv	a1,s7
     9b0:	00005517          	auipc	a0,0x5
     9b4:	fb850513          	addi	a0,a0,-72 # 5968 <malloc+0x480>
     9b8:	279040ef          	jal	5430 <printf>
      exit(1);
     9bc:	4505                	li	a0,1
     9be:	62c040ef          	jal	4fea <exit>
      printf("%s: error: write bb %d new file failed\n", s, i);
     9c2:	864a                	mv	a2,s2
     9c4:	85de                	mv	a1,s7
     9c6:	00005517          	auipc	a0,0x5
     9ca:	fda50513          	addi	a0,a0,-38 # 59a0 <malloc+0x4b8>
     9ce:	263040ef          	jal	5430 <printf>
      exit(1);
     9d2:	4505                	li	a0,1
     9d4:	616040ef          	jal	4fea <exit>
    printf("%s: error: open small failed!\n", s);
     9d8:	85de                	mv	a1,s7
     9da:	00005517          	auipc	a0,0x5
     9de:	fee50513          	addi	a0,a0,-18 # 59c8 <malloc+0x4e0>
     9e2:	24f040ef          	jal	5430 <printf>
    exit(1);
     9e6:	4505                	li	a0,1
     9e8:	602040ef          	jal	4fea <exit>
    printf("%s: read failed\n", s);
     9ec:	85de                	mv	a1,s7
     9ee:	00005517          	auipc	a0,0x5
     9f2:	ffa50513          	addi	a0,a0,-6 # 59e8 <malloc+0x500>
     9f6:	23b040ef          	jal	5430 <printf>
    exit(1);
     9fa:	4505                	li	a0,1
     9fc:	5ee040ef          	jal	4fea <exit>
    printf("%s: unlink small failed\n", s);
     a00:	85de                	mv	a1,s7
     a02:	00005517          	auipc	a0,0x5
     a06:	ffe50513          	addi	a0,a0,-2 # 5a00 <malloc+0x518>
     a0a:	227040ef          	jal	5430 <printf>
    exit(1);
     a0e:	4505                	li	a0,1
     a10:	5da040ef          	jal	4fea <exit>

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
     a32:	ff250513          	addi	a0,a0,-14 # 5a20 <malloc+0x538>
     a36:	5f4040ef          	jal	502a <open>
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
     a5c:	5ae040ef          	jal	500a <write>
     a60:	07251163          	bne	a0,s2,ac2 <writebig+0xae>
  for(i = 0; i < MAXFILE; i++){
     a64:	2485                	addiw	s1,s1,1
     a66:	ff5496e3          	bne	s1,s5,a52 <writebig+0x3e>
  close(fd);
     a6a:	8552                	mv	a0,s4
     a6c:	5a6040ef          	jal	5012 <close>
  fd = open("big", O_RDONLY);
     a70:	4581                	li	a1,0
     a72:	00005517          	auipc	a0,0x5
     a76:	fae50513          	addi	a0,a0,-82 # 5a20 <malloc+0x538>
     a7a:	5b0040ef          	jal	502a <open>
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
     a98:	56a040ef          	jal	5002 <read>
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
     ab4:	f7850513          	addi	a0,a0,-136 # 5a28 <malloc+0x540>
     ab8:	179040ef          	jal	5430 <printf>
    exit(1);
     abc:	4505                	li	a0,1
     abe:	52c040ef          	jal	4fea <exit>
      printf("%s: error: write big file failed i=%d\n", s, i);
     ac2:	8626                	mv	a2,s1
     ac4:	85da                	mv	a1,s6
     ac6:	00005517          	auipc	a0,0x5
     aca:	f8250513          	addi	a0,a0,-126 # 5a48 <malloc+0x560>
     ace:	163040ef          	jal	5430 <printf>
      exit(1);
     ad2:	4505                	li	a0,1
     ad4:	516040ef          	jal	4fea <exit>
    printf("%s: error: open big failed!\n", s);
     ad8:	85da                	mv	a1,s6
     ada:	00005517          	auipc	a0,0x5
     ade:	f9650513          	addi	a0,a0,-106 # 5a70 <malloc+0x588>
     ae2:	14f040ef          	jal	5430 <printf>
    exit(1);
     ae6:	4505                	li	a0,1
     ae8:	502040ef          	jal	4fea <exit>
      if(n != MAXFILE){
     aec:	10c00793          	li	a5,268
     af0:	02f49763          	bne	s1,a5,b1e <writebig+0x10a>
  close(fd);
     af4:	8552                	mv	a0,s4
     af6:	51c040ef          	jal	5012 <close>
  if(unlink("big") < 0){
     afa:	00005517          	auipc	a0,0x5
     afe:	f2650513          	addi	a0,a0,-218 # 5a20 <malloc+0x538>
     b02:	538040ef          	jal	503a <unlink>
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
     b26:	f6e50513          	addi	a0,a0,-146 # 5a90 <malloc+0x5a8>
     b2a:	107040ef          	jal	5430 <printf>
        exit(1);
     b2e:	4505                	li	a0,1
     b30:	4ba040ef          	jal	4fea <exit>
      printf("%s: read failed %d\n", s, i);
     b34:	862a                	mv	a2,a0
     b36:	85da                	mv	a1,s6
     b38:	00005517          	auipc	a0,0x5
     b3c:	f8050513          	addi	a0,a0,-128 # 5ab8 <malloc+0x5d0>
     b40:	0f1040ef          	jal	5430 <printf>
      exit(1);
     b44:	4505                	li	a0,1
     b46:	4a4040ef          	jal	4fea <exit>
      printf("%s: read content of block %d is %d\n", s,
     b4a:	8626                	mv	a2,s1
     b4c:	85da                	mv	a1,s6
     b4e:	00005517          	auipc	a0,0x5
     b52:	f8250513          	addi	a0,a0,-126 # 5ad0 <malloc+0x5e8>
     b56:	0db040ef          	jal	5430 <printf>
      exit(1);
     b5a:	4505                	li	a0,1
     b5c:	48e040ef          	jal	4fea <exit>
    printf("%s: unlink big failed\n", s);
     b60:	85da                	mv	a1,s6
     b62:	00005517          	auipc	a0,0x5
     b66:	f9650513          	addi	a0,a0,-106 # 5af8 <malloc+0x610>
     b6a:	0c7040ef          	jal	5430 <printf>
    exit(1);
     b6e:	4505                	li	a0,1
     b70:	47a040ef          	jal	4fea <exit>

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
     b8c:	f8850513          	addi	a0,a0,-120 # 5b10 <malloc+0x628>
     b90:	49a040ef          	jal	502a <open>
  if(fd < 0){
     b94:	0a054f63          	bltz	a0,c52 <unlinkread+0xde>
     b98:	84aa                	mv	s1,a0
  write(fd, "hello", SZ);
     b9a:	4615                	li	a2,5
     b9c:	00005597          	auipc	a1,0x5
     ba0:	fa458593          	addi	a1,a1,-92 # 5b40 <malloc+0x658>
     ba4:	466040ef          	jal	500a <write>
  close(fd);
     ba8:	8526                	mv	a0,s1
     baa:	468040ef          	jal	5012 <close>
  fd = open("unlinkread", O_RDWR);
     bae:	4589                	li	a1,2
     bb0:	00005517          	auipc	a0,0x5
     bb4:	f6050513          	addi	a0,a0,-160 # 5b10 <malloc+0x628>
     bb8:	472040ef          	jal	502a <open>
     bbc:	84aa                	mv	s1,a0
  if(fd < 0){
     bbe:	0a054463          	bltz	a0,c66 <unlinkread+0xf2>
  if(unlink("unlinkread") != 0){
     bc2:	00005517          	auipc	a0,0x5
     bc6:	f4e50513          	addi	a0,a0,-178 # 5b10 <malloc+0x628>
     bca:	470040ef          	jal	503a <unlink>
     bce:	e555                	bnez	a0,c7a <unlinkread+0x106>
  fd1 = open("unlinkread", O_CREATE | O_RDWR);
     bd0:	20200593          	li	a1,514
     bd4:	00005517          	auipc	a0,0x5
     bd8:	f3c50513          	addi	a0,a0,-196 # 5b10 <malloc+0x628>
     bdc:	44e040ef          	jal	502a <open>
     be0:	892a                	mv	s2,a0
  write(fd1, "yyy", 3);
     be2:	460d                	li	a2,3
     be4:	00005597          	auipc	a1,0x5
     be8:	fa458593          	addi	a1,a1,-92 # 5b88 <malloc+0x6a0>
     bec:	41e040ef          	jal	500a <write>
  close(fd1);
     bf0:	854a                	mv	a0,s2
     bf2:	420040ef          	jal	5012 <close>
  if(read(fd, buf, sizeof(buf)) != SZ){
     bf6:	660d                	lui	a2,0x3
     bf8:	0000d597          	auipc	a1,0xd
     bfc:	0c058593          	addi	a1,a1,192 # dcb8 <buf>
     c00:	8526                	mv	a0,s1
     c02:	400040ef          	jal	5002 <read>
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
     c28:	3e2040ef          	jal	500a <write>
     c2c:	47a9                	li	a5,10
     c2e:	08f51463          	bne	a0,a5,cb6 <unlinkread+0x142>
  close(fd);
     c32:	8526                	mv	a0,s1
     c34:	3de040ef          	jal	5012 <close>
  unlink("unlinkread");
     c38:	00005517          	auipc	a0,0x5
     c3c:	ed850513          	addi	a0,a0,-296 # 5b10 <malloc+0x628>
     c40:	3fa040ef          	jal	503a <unlink>
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
     c58:	ecc50513          	addi	a0,a0,-308 # 5b20 <malloc+0x638>
     c5c:	7d4040ef          	jal	5430 <printf>
    exit(1);
     c60:	4505                	li	a0,1
     c62:	388040ef          	jal	4fea <exit>
    printf("%s: open unlinkread failed\n", s);
     c66:	85ce                	mv	a1,s3
     c68:	00005517          	auipc	a0,0x5
     c6c:	ee050513          	addi	a0,a0,-288 # 5b48 <malloc+0x660>
     c70:	7c0040ef          	jal	5430 <printf>
    exit(1);
     c74:	4505                	li	a0,1
     c76:	374040ef          	jal	4fea <exit>
    printf("%s: unlink unlinkread failed\n", s);
     c7a:	85ce                	mv	a1,s3
     c7c:	00005517          	auipc	a0,0x5
     c80:	eec50513          	addi	a0,a0,-276 # 5b68 <malloc+0x680>
     c84:	7ac040ef          	jal	5430 <printf>
    exit(1);
     c88:	4505                	li	a0,1
     c8a:	360040ef          	jal	4fea <exit>
    printf("%s: unlinkread read failed", s);
     c8e:	85ce                	mv	a1,s3
     c90:	00005517          	auipc	a0,0x5
     c94:	f0050513          	addi	a0,a0,-256 # 5b90 <malloc+0x6a8>
     c98:	798040ef          	jal	5430 <printf>
    exit(1);
     c9c:	4505                	li	a0,1
     c9e:	34c040ef          	jal	4fea <exit>
    printf("%s: unlinkread wrong data\n", s);
     ca2:	85ce                	mv	a1,s3
     ca4:	00005517          	auipc	a0,0x5
     ca8:	f0c50513          	addi	a0,a0,-244 # 5bb0 <malloc+0x6c8>
     cac:	784040ef          	jal	5430 <printf>
    exit(1);
     cb0:	4505                	li	a0,1
     cb2:	338040ef          	jal	4fea <exit>
    printf("%s: unlinkread write failed\n", s);
     cb6:	85ce                	mv	a1,s3
     cb8:	00005517          	auipc	a0,0x5
     cbc:	f1850513          	addi	a0,a0,-232 # 5bd0 <malloc+0x6e8>
     cc0:	770040ef          	jal	5430 <printf>
    exit(1);
     cc4:	4505                	li	a0,1
     cc6:	324040ef          	jal	4fea <exit>

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
     cdc:	f1850513          	addi	a0,a0,-232 # 5bf0 <malloc+0x708>
     ce0:	35a040ef          	jal	503a <unlink>
  unlink("lf2");
     ce4:	00005517          	auipc	a0,0x5
     ce8:	f1450513          	addi	a0,a0,-236 # 5bf8 <malloc+0x710>
     cec:	34e040ef          	jal	503a <unlink>
  fd = open("lf1", O_CREATE|O_RDWR);
     cf0:	20200593          	li	a1,514
     cf4:	00005517          	auipc	a0,0x5
     cf8:	efc50513          	addi	a0,a0,-260 # 5bf0 <malloc+0x708>
     cfc:	32e040ef          	jal	502a <open>
  if(fd < 0){
     d00:	0c054f63          	bltz	a0,dde <linktest+0x114>
     d04:	84aa                	mv	s1,a0
  if(write(fd, "hello", SZ) != SZ){
     d06:	4615                	li	a2,5
     d08:	00005597          	auipc	a1,0x5
     d0c:	e3858593          	addi	a1,a1,-456 # 5b40 <malloc+0x658>
     d10:	2fa040ef          	jal	500a <write>
     d14:	4795                	li	a5,5
     d16:	0cf51e63          	bne	a0,a5,df2 <linktest+0x128>
  close(fd);
     d1a:	8526                	mv	a0,s1
     d1c:	2f6040ef          	jal	5012 <close>
  if(link("lf1", "lf2") < 0){
     d20:	00005597          	auipc	a1,0x5
     d24:	ed858593          	addi	a1,a1,-296 # 5bf8 <malloc+0x710>
     d28:	00005517          	auipc	a0,0x5
     d2c:	ec850513          	addi	a0,a0,-312 # 5bf0 <malloc+0x708>
     d30:	31a040ef          	jal	504a <link>
     d34:	0c054963          	bltz	a0,e06 <linktest+0x13c>
  unlink("lf1");
     d38:	00005517          	auipc	a0,0x5
     d3c:	eb850513          	addi	a0,a0,-328 # 5bf0 <malloc+0x708>
     d40:	2fa040ef          	jal	503a <unlink>
  if(open("lf1", 0) >= 0){
     d44:	4581                	li	a1,0
     d46:	00005517          	auipc	a0,0x5
     d4a:	eaa50513          	addi	a0,a0,-342 # 5bf0 <malloc+0x708>
     d4e:	2dc040ef          	jal	502a <open>
     d52:	0c055463          	bgez	a0,e1a <linktest+0x150>
  fd = open("lf2", 0);
     d56:	4581                	li	a1,0
     d58:	00005517          	auipc	a0,0x5
     d5c:	ea050513          	addi	a0,a0,-352 # 5bf8 <malloc+0x710>
     d60:	2ca040ef          	jal	502a <open>
     d64:	84aa                	mv	s1,a0
  if(fd < 0){
     d66:	0c054463          	bltz	a0,e2e <linktest+0x164>
  if(read(fd, buf, sizeof(buf)) != SZ){
     d6a:	660d                	lui	a2,0x3
     d6c:	0000d597          	auipc	a1,0xd
     d70:	f4c58593          	addi	a1,a1,-180 # dcb8 <buf>
     d74:	28e040ef          	jal	5002 <read>
     d78:	4795                	li	a5,5
     d7a:	0cf51463          	bne	a0,a5,e42 <linktest+0x178>
  close(fd);
     d7e:	8526                	mv	a0,s1
     d80:	292040ef          	jal	5012 <close>
  if(link("lf2", "lf2") >= 0){
     d84:	00005597          	auipc	a1,0x5
     d88:	e7458593          	addi	a1,a1,-396 # 5bf8 <malloc+0x710>
     d8c:	852e                	mv	a0,a1
     d8e:	2bc040ef          	jal	504a <link>
     d92:	0c055263          	bgez	a0,e56 <linktest+0x18c>
  unlink("lf2");
     d96:	00005517          	auipc	a0,0x5
     d9a:	e6250513          	addi	a0,a0,-414 # 5bf8 <malloc+0x710>
     d9e:	29c040ef          	jal	503a <unlink>
  if(link("lf2", "lf1") >= 0){
     da2:	00005597          	auipc	a1,0x5
     da6:	e4e58593          	addi	a1,a1,-434 # 5bf0 <malloc+0x708>
     daa:	00005517          	auipc	a0,0x5
     dae:	e4e50513          	addi	a0,a0,-434 # 5bf8 <malloc+0x710>
     db2:	298040ef          	jal	504a <link>
     db6:	0a055a63          	bgez	a0,e6a <linktest+0x1a0>
  if(link(".", "lf1") >= 0){
     dba:	00005597          	auipc	a1,0x5
     dbe:	e3658593          	addi	a1,a1,-458 # 5bf0 <malloc+0x708>
     dc2:	00005517          	auipc	a0,0x5
     dc6:	f3e50513          	addi	a0,a0,-194 # 5d00 <malloc+0x818>
     dca:	280040ef          	jal	504a <link>
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
     de4:	e2050513          	addi	a0,a0,-480 # 5c00 <malloc+0x718>
     de8:	648040ef          	jal	5430 <printf>
    exit(1);
     dec:	4505                	li	a0,1
     dee:	1fc040ef          	jal	4fea <exit>
    printf("%s: write lf1 failed\n", s);
     df2:	85ca                	mv	a1,s2
     df4:	00005517          	auipc	a0,0x5
     df8:	e2450513          	addi	a0,a0,-476 # 5c18 <malloc+0x730>
     dfc:	634040ef          	jal	5430 <printf>
    exit(1);
     e00:	4505                	li	a0,1
     e02:	1e8040ef          	jal	4fea <exit>
    printf("%s: link lf1 lf2 failed\n", s);
     e06:	85ca                	mv	a1,s2
     e08:	00005517          	auipc	a0,0x5
     e0c:	e2850513          	addi	a0,a0,-472 # 5c30 <malloc+0x748>
     e10:	620040ef          	jal	5430 <printf>
    exit(1);
     e14:	4505                	li	a0,1
     e16:	1d4040ef          	jal	4fea <exit>
    printf("%s: unlinked lf1 but it is still there!\n", s);
     e1a:	85ca                	mv	a1,s2
     e1c:	00005517          	auipc	a0,0x5
     e20:	e3450513          	addi	a0,a0,-460 # 5c50 <malloc+0x768>
     e24:	60c040ef          	jal	5430 <printf>
    exit(1);
     e28:	4505                	li	a0,1
     e2a:	1c0040ef          	jal	4fea <exit>
    printf("%s: open lf2 failed\n", s);
     e2e:	85ca                	mv	a1,s2
     e30:	00005517          	auipc	a0,0x5
     e34:	e5050513          	addi	a0,a0,-432 # 5c80 <malloc+0x798>
     e38:	5f8040ef          	jal	5430 <printf>
    exit(1);
     e3c:	4505                	li	a0,1
     e3e:	1ac040ef          	jal	4fea <exit>
    printf("%s: read lf2 failed\n", s);
     e42:	85ca                	mv	a1,s2
     e44:	00005517          	auipc	a0,0x5
     e48:	e5450513          	addi	a0,a0,-428 # 5c98 <malloc+0x7b0>
     e4c:	5e4040ef          	jal	5430 <printf>
    exit(1);
     e50:	4505                	li	a0,1
     e52:	198040ef          	jal	4fea <exit>
    printf("%s: link lf2 lf2 succeeded! oops\n", s);
     e56:	85ca                	mv	a1,s2
     e58:	00005517          	auipc	a0,0x5
     e5c:	e5850513          	addi	a0,a0,-424 # 5cb0 <malloc+0x7c8>
     e60:	5d0040ef          	jal	5430 <printf>
    exit(1);
     e64:	4505                	li	a0,1
     e66:	184040ef          	jal	4fea <exit>
    printf("%s: link non-existent succeeded! oops\n", s);
     e6a:	85ca                	mv	a1,s2
     e6c:	00005517          	auipc	a0,0x5
     e70:	e6c50513          	addi	a0,a0,-404 # 5cd8 <malloc+0x7f0>
     e74:	5bc040ef          	jal	5430 <printf>
    exit(1);
     e78:	4505                	li	a0,1
     e7a:	170040ef          	jal	4fea <exit>
    printf("%s: link . lf1 succeeded! oops\n", s);
     e7e:	85ca                	mv	a1,s2
     e80:	00005517          	auipc	a0,0x5
     e84:	e8850513          	addi	a0,a0,-376 # 5d08 <malloc+0x820>
     e88:	5a8040ef          	jal	5430 <printf>
    exit(1);
     e8c:	4505                	li	a0,1
     e8e:	15c040ef          	jal	4fea <exit>

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
     eae:	e7e98993          	addi	s3,s3,-386 # 5d28 <malloc+0x840>
     eb2:	597d                	li	s2,-1
  for(p = 0; p <= (uint)hi; p += PGSIZE){
     eb4:	6a85                	lui	s5,0x1
     eb6:	00114a37          	lui	s4,0x114
    if(link("nosuchfile", (char*)p) != -1){
     eba:	85a6                	mv	a1,s1
     ebc:	854e                	mv	a0,s3
     ebe:	18c040ef          	jal	504a <link>
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
     ee6:	e5650513          	addi	a0,a0,-426 # 5d38 <malloc+0x850>
     eea:	546040ef          	jal	5430 <printf>
      exit(1);
     eee:	4505                	li	a0,1
     ef0:	0fa040ef          	jal	4fea <exit>

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
     f10:	e4c50513          	addi	a0,a0,-436 # 5d58 <malloc+0x870>
     f14:	126040ef          	jal	503a <unlink>
  fd = open("bd", O_CREATE);
     f18:	20000593          	li	a1,512
     f1c:	00005517          	auipc	a0,0x5
     f20:	e3c50513          	addi	a0,a0,-452 # 5d58 <malloc+0x870>
     f24:	106040ef          	jal	502a <open>
  if(fd < 0){
     f28:	0c054463          	bltz	a0,ff0 <bigdir+0xfc>
  close(fd);
     f2c:	0e6040ef          	jal	5012 <close>
  for(i = 0; i < N; i++){
     f30:	4901                	li	s2,0
    name[0] = 'x';
     f32:	07800a93          	li	s5,120
    if(link("bd", name) != 0){
     f36:	fa040a13          	addi	s4,s0,-96
     f3a:	00005997          	auipc	s3,0x5
     f3e:	e1e98993          	addi	s3,s3,-482 # 5d58 <malloc+0x870>
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
     f78:	0d2040ef          	jal	504a <link>
     f7c:	84aa                	mv	s1,a0
     f7e:	e159                	bnez	a0,1004 <bigdir+0x110>
  for(i = 0; i < N; i++){
     f80:	2905                	addiw	s2,s2,1
     f82:	fd6912e3          	bne	s2,s6,f46 <bigdir+0x52>
  unlink("bd");
     f86:	00005517          	auipc	a0,0x5
     f8a:	dd250513          	addi	a0,a0,-558 # 5d58 <malloc+0x870>
     f8e:	0ac040ef          	jal	503a <unlink>
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
     fce:	06c040ef          	jal	503a <unlink>
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
     ff6:	d6e50513          	addi	a0,a0,-658 # 5d60 <malloc+0x878>
     ffa:	436040ef          	jal	5430 <printf>
    exit(1);
     ffe:	4505                	li	a0,1
    1000:	7eb030ef          	jal	4fea <exit>
      printf("%s: bigdir i=%d link(bd, %s) failed\n", s, i, name);
    1004:	fa040693          	addi	a3,s0,-96
    1008:	864a                	mv	a2,s2
    100a:	85de                	mv	a1,s7
    100c:	00005517          	auipc	a0,0x5
    1010:	d7450513          	addi	a0,a0,-652 # 5d80 <malloc+0x898>
    1014:	41c040ef          	jal	5430 <printf>
      exit(1);
    1018:	4505                	li	a0,1
    101a:	7d1030ef          	jal	4fea <exit>
      printf("%s: bigdir unlink failed", s);
    101e:	85de                	mv	a1,s7
    1020:	00005517          	auipc	a0,0x5
    1024:	d8850513          	addi	a0,a0,-632 # 5da8 <malloc+0x8c0>
    1028:	408040ef          	jal	5430 <printf>
      exit(1);
    102c:	4505                	li	a0,1
    102e:	7bd030ef          	jal	4fea <exit>

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
    104e:	7d5030ef          	jal	5022 <exec>
  pipe(big);
    1052:	6088                	ld	a0,0(s1)
    1054:	7a7030ef          	jal	4ffa <pipe>
  exit(0);
    1058:	4501                	li	a0,0
    105a:	791030ef          	jal	4fea <exit>

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
    1082:	59a98993          	addi	s3,s3,1434 # 5618 <malloc+0x130>
    argv[0] = (char*)0xffffffff;
    1086:	fd243023          	sd	s2,-64(s0)
    argv[1] = 0;
    108a:	fc043423          	sd	zero,-56(s0)
    exec("echo", argv);
    108e:	85d2                	mv	a1,s4
    1090:	854e                	mv	a0,s3
    1092:	791030ef          	jal	5022 <exec>
  for(int i = 0; i < 50000; i++){
    1096:	34fd                	addiw	s1,s1,-1
    1098:	f4fd                	bnez	s1,1086 <badarg+0x28>
  exit(0);
    109a:	4501                	li	a0,0
    109c:	74f030ef          	jal	4fea <exit>

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
    10c6:	775030ef          	jal	503a <unlink>
  if(ret != -1){
    10ca:	57fd                	li	a5,-1
    10cc:	0cf51263          	bne	a0,a5,1190 <copyinstr2+0xf0>
  int fd = open(b, O_CREATE | O_WRONLY);
    10d0:	20100593          	li	a1,513
    10d4:	f6840513          	addi	a0,s0,-152
    10d8:	753030ef          	jal	502a <open>
  if(fd != -1){
    10dc:	57fd                	li	a5,-1
    10de:	0cf51563          	bne	a0,a5,11a8 <copyinstr2+0x108>
  ret = link(b, b);
    10e2:	f6840513          	addi	a0,s0,-152
    10e6:	85aa                	mv	a1,a0
    10e8:	763030ef          	jal	504a <link>
  if(ret != -1){
    10ec:	57fd                	li	a5,-1
    10ee:	0cf51963          	bne	a0,a5,11c0 <copyinstr2+0x120>
  char *args[] = { "xx", 0 };
    10f2:	00006797          	auipc	a5,0x6
    10f6:	e0678793          	addi	a5,a5,-506 # 6ef8 <malloc+0x1a10>
    10fa:	f4f43c23          	sd	a5,-168(s0)
    10fe:	f6043023          	sd	zero,-160(s0)
  ret = exec(b, args);
    1102:	f5840593          	addi	a1,s0,-168
    1106:	f6840513          	addi	a0,s0,-152
    110a:	719030ef          	jal	5022 <exec>
  if(ret != -1){
    110e:	57fd                	li	a5,-1
    1110:	0cf51563          	bne	a0,a5,11da <copyinstr2+0x13a>
  int pid = fork();
    1114:	6cf030ef          	jal	4fe2 <fork>
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
    114a:	a1a78793          	addi	a5,a5,-1510 # 7b60 <malloc+0x2678>
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
    116e:	4ae50513          	addi	a0,a0,1198 # 5618 <malloc+0x130>
    1172:	6b1030ef          	jal	5022 <exec>
    if(ret != -1){
    1176:	57fd                	li	a5,-1
    1178:	08f50663          	beq	a0,a5,1204 <copyinstr2+0x164>
      printf("exec(echo, BIG) returned %d, not -1\n", fd);
    117c:	85be                	mv	a1,a5
    117e:	00005517          	auipc	a0,0x5
    1182:	cd250513          	addi	a0,a0,-814 # 5e50 <malloc+0x968>
    1186:	2aa040ef          	jal	5430 <printf>
      exit(1);
    118a:	4505                	li	a0,1
    118c:	65f030ef          	jal	4fea <exit>
    printf("unlink(%s) returned %d, not -1\n", b, ret);
    1190:	862a                	mv	a2,a0
    1192:	f6840593          	addi	a1,s0,-152
    1196:	00005517          	auipc	a0,0x5
    119a:	c3250513          	addi	a0,a0,-974 # 5dc8 <malloc+0x8e0>
    119e:	292040ef          	jal	5430 <printf>
    exit(1);
    11a2:	4505                	li	a0,1
    11a4:	647030ef          	jal	4fea <exit>
    printf("open(%s) returned %d, not -1\n", b, fd);
    11a8:	862a                	mv	a2,a0
    11aa:	f6840593          	addi	a1,s0,-152
    11ae:	00005517          	auipc	a0,0x5
    11b2:	c3a50513          	addi	a0,a0,-966 # 5de8 <malloc+0x900>
    11b6:	27a040ef          	jal	5430 <printf>
    exit(1);
    11ba:	4505                	li	a0,1
    11bc:	62f030ef          	jal	4fea <exit>
    printf("link(%s, %s) returned %d, not -1\n", b, b, ret);
    11c0:	f6840593          	addi	a1,s0,-152
    11c4:	86aa                	mv	a3,a0
    11c6:	862e                	mv	a2,a1
    11c8:	00005517          	auipc	a0,0x5
    11cc:	c4050513          	addi	a0,a0,-960 # 5e08 <malloc+0x920>
    11d0:	260040ef          	jal	5430 <printf>
    exit(1);
    11d4:	4505                	li	a0,1
    11d6:	615030ef          	jal	4fea <exit>
    printf("exec(%s) returned %d, not -1\n", b, fd);
    11da:	863e                	mv	a2,a5
    11dc:	f6840593          	addi	a1,s0,-152
    11e0:	00005517          	auipc	a0,0x5
    11e4:	c5050513          	addi	a0,a0,-944 # 5e30 <malloc+0x948>
    11e8:	248040ef          	jal	5430 <printf>
    exit(1);
    11ec:	4505                	li	a0,1
    11ee:	5fd030ef          	jal	4fea <exit>
    printf("fork failed\n");
    11f2:	00006517          	auipc	a0,0x6
    11f6:	25e50513          	addi	a0,a0,606 # 7450 <malloc+0x1f68>
    11fa:	236040ef          	jal	5430 <printf>
    exit(1);
    11fe:	4505                	li	a0,1
    1200:	5eb030ef          	jal	4fea <exit>
    exit(747); // OK
    1204:	2eb00513          	li	a0,747
    1208:	5e3030ef          	jal	4fea <exit>
  int st = 0;
    120c:	f4042a23          	sw	zero,-172(s0)
  wait(&st);
    1210:	f5440513          	addi	a0,s0,-172
    1214:	5df030ef          	jal	4ff2 <wait>
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
    1230:	c4c50513          	addi	a0,a0,-948 # 5e78 <malloc+0x990>
    1234:	1fc040ef          	jal	5430 <printf>
    exit(1);
    1238:	4505                	li	a0,1
    123a:	5b1030ef          	jal	4fea <exit>

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
    1252:	42250513          	addi	a0,a0,1058 # 5670 <malloc+0x188>
    1256:	5d5030ef          	jal	502a <open>
    125a:	5b9030ef          	jal	5012 <close>
  pid = fork();
    125e:	585030ef          	jal	4fe2 <fork>
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
    1282:	3f298993          	addi	s3,s3,1010 # 5670 <malloc+0x188>
      int n = write(fd, "1234567890", 10);
    1286:	4a29                	li	s4,10
    1288:	00005b17          	auipc	s6,0x5
    128c:	c50b0b13          	addi	s6,s6,-944 # 5ed8 <malloc+0x9f0>
      read(fd, buf, sizeof(buf));
    1290:	f7840c13          	addi	s8,s0,-136
    1294:	02000b93          	li	s7,32
      int fd = open("truncfile", O_WRONLY);
    1298:	85d6                	mv	a1,s5
    129a:	854e                	mv	a0,s3
    129c:	58f030ef          	jal	502a <open>
    12a0:	84aa                	mv	s1,a0
      if(fd < 0){
    12a2:	04054f63          	bltz	a0,1300 <truncate3+0xc2>
      int n = write(fd, "1234567890", 10);
    12a6:	8652                	mv	a2,s4
    12a8:	85da                	mv	a1,s6
    12aa:	561030ef          	jal	500a <write>
      if(n != 10){
    12ae:	07451363          	bne	a0,s4,1314 <truncate3+0xd6>
      close(fd);
    12b2:	8526                	mv	a0,s1
    12b4:	55f030ef          	jal	5012 <close>
      fd = open("truncfile", O_RDONLY);
    12b8:	4581                	li	a1,0
    12ba:	854e                	mv	a0,s3
    12bc:	56f030ef          	jal	502a <open>
    12c0:	84aa                	mv	s1,a0
      read(fd, buf, sizeof(buf));
    12c2:	865e                	mv	a2,s7
    12c4:	85e2                	mv	a1,s8
    12c6:	53d030ef          	jal	5002 <read>
      close(fd);
    12ca:	8526                	mv	a0,s1
    12cc:	547030ef          	jal	5012 <close>
    for(int i = 0; i < 100; i++){
    12d0:	397d                	addiw	s2,s2,-1
    12d2:	fc0913e3          	bnez	s2,1298 <truncate3+0x5a>
    exit(0);
    12d6:	4501                	li	a0,0
    12d8:	513030ef          	jal	4fea <exit>
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
    12f2:	bba50513          	addi	a0,a0,-1094 # 5ea8 <malloc+0x9c0>
    12f6:	13a040ef          	jal	5430 <printf>
    exit(1);
    12fa:	4505                	li	a0,1
    12fc:	4ef030ef          	jal	4fea <exit>
        printf("%s: open failed\n", s);
    1300:	85e6                	mv	a1,s9
    1302:	00005517          	auipc	a0,0x5
    1306:	bbe50513          	addi	a0,a0,-1090 # 5ec0 <malloc+0x9d8>
    130a:	126040ef          	jal	5430 <printf>
        exit(1);
    130e:	4505                	li	a0,1
    1310:	4db030ef          	jal	4fea <exit>
        printf("%s: write got %d, expected 10\n", s, n);
    1314:	862a                	mv	a2,a0
    1316:	85e6                	mv	a1,s9
    1318:	00005517          	auipc	a0,0x5
    131c:	bd050513          	addi	a0,a0,-1072 # 5ee8 <malloc+0xa00>
    1320:	110040ef          	jal	5430 <printf>
        exit(1);
    1324:	4505                	li	a0,1
    1326:	4c5030ef          	jal	4fea <exit>
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
    1342:	332a0a13          	addi	s4,s4,818 # 5670 <malloc+0x188>
    int n = write(fd, "xxx", 3);
    1346:	498d                	li	s3,3
    1348:	00005b17          	auipc	s6,0x5
    134c:	bc0b0b13          	addi	s6,s6,-1088 # 5f08 <malloc+0xa20>
    int fd = open("truncfile", O_CREATE|O_WRONLY|O_TRUNC);
    1350:	85d6                	mv	a1,s5
    1352:	8552                	mv	a0,s4
    1354:	4d7030ef          	jal	502a <open>
    1358:	84aa                	mv	s1,a0
    if(fd < 0){
    135a:	02054e63          	bltz	a0,1396 <truncate3+0x158>
    int n = write(fd, "xxx", 3);
    135e:	864e                	mv	a2,s3
    1360:	85da                	mv	a1,s6
    1362:	4a9030ef          	jal	500a <write>
    if(n != 3){
    1366:	05351463          	bne	a0,s3,13ae <truncate3+0x170>
    close(fd);
    136a:	8526                	mv	a0,s1
    136c:	4a7030ef          	jal	5012 <close>
  for(int i = 0; i < 150; i++){
    1370:	397d                	addiw	s2,s2,-1
    1372:	fc091fe3          	bnez	s2,1350 <truncate3+0x112>
    1376:	e4de                	sd	s7,72(sp)
    1378:	e0e2                	sd	s8,64(sp)
  wait(&xstatus);
    137a:	f9c40513          	addi	a0,s0,-100
    137e:	475030ef          	jal	4ff2 <wait>
  unlink("truncfile");
    1382:	00004517          	auipc	a0,0x4
    1386:	2ee50513          	addi	a0,a0,750 # 5670 <malloc+0x188>
    138a:	4b1030ef          	jal	503a <unlink>
  exit(xstatus);
    138e:	f9c42503          	lw	a0,-100(s0)
    1392:	459030ef          	jal	4fea <exit>
    1396:	e4de                	sd	s7,72(sp)
    1398:	e0e2                	sd	s8,64(sp)
      printf("%s: open failed\n", s);
    139a:	85e6                	mv	a1,s9
    139c:	00005517          	auipc	a0,0x5
    13a0:	b2450513          	addi	a0,a0,-1244 # 5ec0 <malloc+0x9d8>
    13a4:	08c040ef          	jal	5430 <printf>
      exit(1);
    13a8:	4505                	li	a0,1
    13aa:	441030ef          	jal	4fea <exit>
    13ae:	e4de                	sd	s7,72(sp)
    13b0:	e0e2                	sd	s8,64(sp)
      printf("%s: write got %d, expected 3\n", s, n);
    13b2:	862a                	mv	a2,a0
    13b4:	85e6                	mv	a1,s9
    13b6:	00005517          	auipc	a0,0x5
    13ba:	b5a50513          	addi	a0,a0,-1190 # 5f10 <malloc+0xa28>
    13be:	072040ef          	jal	5430 <printf>
      exit(1);
    13c2:	4505                	li	a0,1
    13c4:	427030ef          	jal	4fea <exit>

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
    13d8:	24478793          	addi	a5,a5,580 # 5618 <malloc+0x130>
    13dc:	fcf43023          	sd	a5,-64(s0)
    13e0:	00005797          	auipc	a5,0x5
    13e4:	b5078793          	addi	a5,a5,-1200 # 5f30 <malloc+0xa48>
    13e8:	fcf43423          	sd	a5,-56(s0)
    13ec:	fc043823          	sd	zero,-48(s0)
  unlink("echo-ok");
    13f0:	00005517          	auipc	a0,0x5
    13f4:	b4850513          	addi	a0,a0,-1208 # 5f38 <malloc+0xa50>
    13f8:	443030ef          	jal	503a <unlink>
  pid = fork();
    13fc:	3e7030ef          	jal	4fe2 <fork>
  if(pid < 0) {
    1400:	02054f63          	bltz	a0,143e <exectest+0x76>
    1404:	fc26                	sd	s1,56(sp)
    1406:	84aa                	mv	s1,a0
  if(pid == 0) {
    1408:	e935                	bnez	a0,147c <exectest+0xb4>
    close(1);
    140a:	4505                	li	a0,1
    140c:	407030ef          	jal	5012 <close>
    fd = open("echo-ok", O_CREATE|O_WRONLY);
    1410:	20100593          	li	a1,513
    1414:	00005517          	auipc	a0,0x5
    1418:	b2450513          	addi	a0,a0,-1244 # 5f38 <malloc+0xa50>
    141c:	40f030ef          	jal	502a <open>
    if(fd < 0) {
    1420:	02054a63          	bltz	a0,1454 <exectest+0x8c>
    if(fd != 1) {
    1424:	4785                	li	a5,1
    1426:	04f50163          	beq	a0,a5,1468 <exectest+0xa0>
      printf("%s: wrong fd\n", s);
    142a:	85ca                	mv	a1,s2
    142c:	00005517          	auipc	a0,0x5
    1430:	b2c50513          	addi	a0,a0,-1236 # 5f58 <malloc+0xa70>
    1434:	7fd030ef          	jal	5430 <printf>
      exit(1);
    1438:	4505                	li	a0,1
    143a:	3b1030ef          	jal	4fea <exit>
    143e:	fc26                	sd	s1,56(sp)
     printf("%s: fork failed\n", s);
    1440:	85ca                	mv	a1,s2
    1442:	00005517          	auipc	a0,0x5
    1446:	a6650513          	addi	a0,a0,-1434 # 5ea8 <malloc+0x9c0>
    144a:	7e7030ef          	jal	5430 <printf>
     exit(1);
    144e:	4505                	li	a0,1
    1450:	39b030ef          	jal	4fea <exit>
      printf("%s: create failed\n", s);
    1454:	85ca                	mv	a1,s2
    1456:	00005517          	auipc	a0,0x5
    145a:	aea50513          	addi	a0,a0,-1302 # 5f40 <malloc+0xa58>
    145e:	7d3030ef          	jal	5430 <printf>
      exit(1);
    1462:	4505                	li	a0,1
    1464:	387030ef          	jal	4fea <exit>
    if(exec("echo", echoargv) < 0){
    1468:	fc040593          	addi	a1,s0,-64
    146c:	00004517          	auipc	a0,0x4
    1470:	1ac50513          	addi	a0,a0,428 # 5618 <malloc+0x130>
    1474:	3af030ef          	jal	5022 <exec>
    1478:	00054d63          	bltz	a0,1492 <exectest+0xca>
  if (wait(&xstatus) != pid) {
    147c:	fdc40513          	addi	a0,s0,-36
    1480:	373030ef          	jal	4ff2 <wait>
    1484:	02951163          	bne	a0,s1,14a6 <exectest+0xde>
  if(xstatus != 0)
    1488:	fdc42503          	lw	a0,-36(s0)
    148c:	c50d                	beqz	a0,14b6 <exectest+0xee>
    exit(xstatus);
    148e:	35d030ef          	jal	4fea <exit>
      printf("%s: exec echo failed\n", s);
    1492:	85ca                	mv	a1,s2
    1494:	00005517          	auipc	a0,0x5
    1498:	ad450513          	addi	a0,a0,-1324 # 5f68 <malloc+0xa80>
    149c:	795030ef          	jal	5430 <printf>
      exit(1);
    14a0:	4505                	li	a0,1
    14a2:	349030ef          	jal	4fea <exit>
    printf("%s: wait failed!\n", s);
    14a6:	85ca                	mv	a1,s2
    14a8:	00005517          	auipc	a0,0x5
    14ac:	ad850513          	addi	a0,a0,-1320 # 5f80 <malloc+0xa98>
    14b0:	781030ef          	jal	5430 <printf>
    14b4:	bfd1                	j	1488 <exectest+0xc0>
  fd = open("echo-ok", O_RDONLY);
    14b6:	4581                	li	a1,0
    14b8:	00005517          	auipc	a0,0x5
    14bc:	a8050513          	addi	a0,a0,-1408 # 5f38 <malloc+0xa50>
    14c0:	36b030ef          	jal	502a <open>
  if(fd < 0) {
    14c4:	02054463          	bltz	a0,14ec <exectest+0x124>
  if (read(fd, buf, 2) != 2) {
    14c8:	4609                	li	a2,2
    14ca:	fb840593          	addi	a1,s0,-72
    14ce:	335030ef          	jal	5002 <read>
    14d2:	4789                	li	a5,2
    14d4:	02f50663          	beq	a0,a5,1500 <exectest+0x138>
    printf("%s: read failed\n", s);
    14d8:	85ca                	mv	a1,s2
    14da:	00004517          	auipc	a0,0x4
    14de:	50e50513          	addi	a0,a0,1294 # 59e8 <malloc+0x500>
    14e2:	74f030ef          	jal	5430 <printf>
    exit(1);
    14e6:	4505                	li	a0,1
    14e8:	303030ef          	jal	4fea <exit>
    printf("%s: open failed\n", s);
    14ec:	85ca                	mv	a1,s2
    14ee:	00005517          	auipc	a0,0x5
    14f2:	9d250513          	addi	a0,a0,-1582 # 5ec0 <malloc+0x9d8>
    14f6:	73b030ef          	jal	5430 <printf>
    exit(1);
    14fa:	4505                	li	a0,1
    14fc:	2ef030ef          	jal	4fea <exit>
  unlink("echo-ok");
    1500:	00005517          	auipc	a0,0x5
    1504:	a3850513          	addi	a0,a0,-1480 # 5f38 <malloc+0xa50>
    1508:	333030ef          	jal	503a <unlink>
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
    152a:	a7250513          	addi	a0,a0,-1422 # 5f98 <malloc+0xab0>
    152e:	703030ef          	jal	5430 <printf>
    exit(1);
    1532:	4505                	li	a0,1
    1534:	2b7030ef          	jal	4fea <exit>
    exit(0);
    1538:	4501                	li	a0,0
    153a:	2b1030ef          	jal	4fea <exit>

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
    154e:	2ad030ef          	jal	4ffa <pipe>
    1552:	e925                	bnez	a0,15c2 <pipe1+0x84>
    1554:	e4a6                	sd	s1,72(sp)
    1556:	fc4e                	sd	s3,56(sp)
    1558:	84aa                	mv	s1,a0
  pid = fork();
    155a:	289030ef          	jal	4fe2 <fork>
    155e:	89aa                	mv	s3,a0
  if(pid == 0){
    1560:	c151                	beqz	a0,15e4 <pipe1+0xa6>
  } else if(pid > 0){
    1562:	16a05063          	blez	a0,16c2 <pipe1+0x184>
    1566:	e0ca                	sd	s2,64(sp)
    1568:	f852                	sd	s4,48(sp)
    close(fds[1]);
    156a:	fac42503          	lw	a0,-84(s0)
    156e:	2a5030ef          	jal	5012 <close>
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
    1586:	27d030ef          	jal	5002 <read>
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
    15d6:	9de50513          	addi	a0,a0,-1570 # 5fb0 <malloc+0xac8>
    15da:	657030ef          	jal	5430 <printf>
    exit(1);
    15de:	4505                	li	a0,1
    15e0:	20b030ef          	jal	4fea <exit>
    15e4:	e0ca                	sd	s2,64(sp)
    15e6:	f852                	sd	s4,48(sp)
    15e8:	f456                	sd	s5,40(sp)
    15ea:	f05a                	sd	s6,32(sp)
    15ec:	ec5e                	sd	s7,24(sp)
    close(fds[0]);
    15ee:	fa842503          	lw	a0,-88(s0)
    15f2:	221030ef          	jal	5012 <close>
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
    161c:	00e78023          	sb	a4,0(a5) # 3000 <subdir+0x300>
      for(i = 0; i < SZ; i++)
    1620:	0785                	addi	a5,a5,1
    1622:	ff279be3          	bne	a5,s2,1618 <pipe1+0xda>
      if(write(fds[1], buf, SZ) != SZ){
    1626:	8652                	mv	a2,s4
    1628:	85de                	mv	a1,s7
    162a:	fac42503          	lw	a0,-84(s0)
    162e:	1dd030ef          	jal	500a <write>
    1632:	01451c63          	bne	a0,s4,164a <pipe1+0x10c>
    1636:	4099899b          	addiw	s3,s3,1033
    for(n = 0; n < N; n++){
    163a:	24a5                	addiw	s1,s1,9
    163c:	0ff4f493          	zext.b	s1,s1
    1640:	fd599be3          	bne	s3,s5,1616 <pipe1+0xd8>
    exit(0);
    1644:	4501                	li	a0,0
    1646:	1a5030ef          	jal	4fea <exit>
        printf("%s: pipe1 oops 1\n", s);
    164a:	85e2                	mv	a1,s8
    164c:	00005517          	auipc	a0,0x5
    1650:	97c50513          	addi	a0,a0,-1668 # 5fc8 <malloc+0xae0>
    1654:	5dd030ef          	jal	5430 <printf>
        exit(1);
    1658:	4505                	li	a0,1
    165a:	191030ef          	jal	4fea <exit>
          printf("%s: pipe1 oops 2\n", s);
    165e:	85e2                	mv	a1,s8
    1660:	00005517          	auipc	a0,0x5
    1664:	98050513          	addi	a0,a0,-1664 # 5fe0 <malloc+0xaf8>
    1668:	5c9030ef          	jal	5430 <printf>
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
    1696:	96650513          	addi	a0,a0,-1690 # 5ff8 <malloc+0xb10>
    169a:	597030ef          	jal	5430 <printf>
      exit(1);
    169e:	4505                	li	a0,1
    16a0:	14b030ef          	jal	4fea <exit>
    16a4:	f456                	sd	s5,40(sp)
    16a6:	f05a                	sd	s6,32(sp)
    16a8:	ec5e                	sd	s7,24(sp)
    close(fds[0]);
    16aa:	fa842503          	lw	a0,-88(s0)
    16ae:	165030ef          	jal	5012 <close>
    wait(&xstatus);
    16b2:	fa440513          	addi	a0,s0,-92
    16b6:	13d030ef          	jal	4ff2 <wait>
    exit(xstatus);
    16ba:	fa442503          	lw	a0,-92(s0)
    16be:	12d030ef          	jal	4fea <exit>
    16c2:	e0ca                	sd	s2,64(sp)
    16c4:	f852                	sd	s4,48(sp)
    16c6:	f456                	sd	s5,40(sp)
    16c8:	f05a                	sd	s6,32(sp)
    16ca:	ec5e                	sd	s7,24(sp)
    printf("%s: fork() failed\n", s);
    16cc:	85e2                	mv	a1,s8
    16ce:	00005517          	auipc	a0,0x5
    16d2:	94a50513          	addi	a0,a0,-1718 # 6018 <malloc+0xb30>
    16d6:	55b030ef          	jal	5430 <printf>
    exit(1);
    16da:	4505                	li	a0,1
    16dc:	10f030ef          	jal	4fea <exit>

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
    16fe:	0e5030ef          	jal	4fe2 <fork>
    1702:	84aa                	mv	s1,a0
    if(pid < 0){
    1704:	02054863          	bltz	a0,1734 <exitwait+0x54>
    if(pid){
    1708:	c525                	beqz	a0,1770 <exitwait+0x90>
      if(wait(&xstate) != pid){
    170a:	854e                	mv	a0,s3
    170c:	0e7030ef          	jal	4ff2 <wait>
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
    173a:	77250513          	addi	a0,a0,1906 # 5ea8 <malloc+0x9c0>
    173e:	4f3030ef          	jal	5430 <printf>
      exit(1);
    1742:	4505                	li	a0,1
    1744:	0a7030ef          	jal	4fea <exit>
        printf("%s: wait wrong pid\n", s);
    1748:	85d6                	mv	a1,s5
    174a:	00005517          	auipc	a0,0x5
    174e:	8e650513          	addi	a0,a0,-1818 # 6030 <malloc+0xb48>
    1752:	4df030ef          	jal	5430 <printf>
        exit(1);
    1756:	4505                	li	a0,1
    1758:	093030ef          	jal	4fea <exit>
        printf("%s: wait wrong exit status\n", s);
    175c:	85d6                	mv	a1,s5
    175e:	00005517          	auipc	a0,0x5
    1762:	8ea50513          	addi	a0,a0,-1814 # 6048 <malloc+0xb60>
    1766:	4cb030ef          	jal	5430 <printf>
        exit(1);
    176a:	4505                	li	a0,1
    176c:	07f030ef          	jal	4fea <exit>
      exit(i);
    1770:	854a                	mv	a0,s2
    1772:	079030ef          	jal	4fea <exit>

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
    1788:	05b030ef          	jal	4fe2 <fork>
    if(pid1 < 0){
    178c:	02054663          	bltz	a0,17b8 <twochildren+0x42>
    if(pid1 == 0){
    1790:	cd15                	beqz	a0,17cc <twochildren+0x56>
      int pid2 = fork();
    1792:	051030ef          	jal	4fe2 <fork>
      if(pid2 < 0){
    1796:	02054d63          	bltz	a0,17d0 <twochildren+0x5a>
      if(pid2 == 0){
    179a:	c529                	beqz	a0,17e4 <twochildren+0x6e>
        wait(0);
    179c:	4501                	li	a0,0
    179e:	055030ef          	jal	4ff2 <wait>
        wait(0);
    17a2:	4501                	li	a0,0
    17a4:	04f030ef          	jal	4ff2 <wait>
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
    17be:	6ee50513          	addi	a0,a0,1774 # 5ea8 <malloc+0x9c0>
    17c2:	46f030ef          	jal	5430 <printf>
      exit(1);
    17c6:	4505                	li	a0,1
    17c8:	023030ef          	jal	4fea <exit>
      exit(0);
    17cc:	01f030ef          	jal	4fea <exit>
        printf("%s: fork failed\n", s);
    17d0:	85ca                	mv	a1,s2
    17d2:	00004517          	auipc	a0,0x4
    17d6:	6d650513          	addi	a0,a0,1750 # 5ea8 <malloc+0x9c0>
    17da:	457030ef          	jal	5430 <printf>
        exit(1);
    17de:	4505                	li	a0,1
    17e0:	00b030ef          	jal	4fea <exit>
        exit(0);
    17e4:	007030ef          	jal	4fea <exit>

00000000000017e8 <forkfork>:
{
    17e8:	7179                	addi	sp,sp,-48
    17ea:	f406                	sd	ra,40(sp)
    17ec:	f022                	sd	s0,32(sp)
    17ee:	ec26                	sd	s1,24(sp)
    17f0:	1800                	addi	s0,sp,48
    17f2:	84aa                	mv	s1,a0
    int pid = fork();
    17f4:	7ee030ef          	jal	4fe2 <fork>
    if(pid < 0){
    17f8:	02054b63          	bltz	a0,182e <forkfork+0x46>
    if(pid == 0){
    17fc:	c139                	beqz	a0,1842 <forkfork+0x5a>
    int pid = fork();
    17fe:	7e4030ef          	jal	4fe2 <fork>
    if(pid < 0){
    1802:	02054663          	bltz	a0,182e <forkfork+0x46>
    if(pid == 0){
    1806:	cd15                	beqz	a0,1842 <forkfork+0x5a>
    wait(&xstatus);
    1808:	fdc40513          	addi	a0,s0,-36
    180c:	7e6030ef          	jal	4ff2 <wait>
    if(xstatus != 0) {
    1810:	fdc42783          	lw	a5,-36(s0)
    1814:	ebb9                	bnez	a5,186a <forkfork+0x82>
    wait(&xstatus);
    1816:	fdc40513          	addi	a0,s0,-36
    181a:	7d8030ef          	jal	4ff2 <wait>
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
    1834:	83850513          	addi	a0,a0,-1992 # 6068 <malloc+0xb80>
    1838:	3f9030ef          	jal	5430 <printf>
      exit(1);
    183c:	4505                	li	a0,1
    183e:	7ac030ef          	jal	4fea <exit>
{
    1842:	0c800493          	li	s1,200
        int pid1 = fork();
    1846:	79c030ef          	jal	4fe2 <fork>
        if(pid1 < 0){
    184a:	00054b63          	bltz	a0,1860 <forkfork+0x78>
        if(pid1 == 0){
    184e:	cd01                	beqz	a0,1866 <forkfork+0x7e>
        wait(0);
    1850:	4501                	li	a0,0
    1852:	7a0030ef          	jal	4ff2 <wait>
      for(int j = 0; j < 200; j++){
    1856:	34fd                	addiw	s1,s1,-1
    1858:	f4fd                	bnez	s1,1846 <forkfork+0x5e>
      exit(0);
    185a:	4501                	li	a0,0
    185c:	78e030ef          	jal	4fea <exit>
          exit(1);
    1860:	4505                	li	a0,1
    1862:	788030ef          	jal	4fea <exit>
          exit(0);
    1866:	784030ef          	jal	4fea <exit>
      printf("%s: fork in child failed", s);
    186a:	85a6                	mv	a1,s1
    186c:	00005517          	auipc	a0,0x5
    1870:	80c50513          	addi	a0,a0,-2036 # 6078 <malloc+0xb90>
    1874:	3bd030ef          	jal	5430 <printf>
      exit(1);
    1878:	4505                	li	a0,1
    187a:	770030ef          	jal	4fea <exit>

000000000000187e <reparent2>:
{
    187e:	1101                	addi	sp,sp,-32
    1880:	ec06                	sd	ra,24(sp)
    1882:	e822                	sd	s0,16(sp)
    1884:	e426                	sd	s1,8(sp)
    1886:	1000                	addi	s0,sp,32
    1888:	32000493          	li	s1,800
    int pid1 = fork();
    188c:	756030ef          	jal	4fe2 <fork>
    if(pid1 < 0){
    1890:	00054b63          	bltz	a0,18a6 <reparent2+0x28>
    if(pid1 == 0){
    1894:	c115                	beqz	a0,18b8 <reparent2+0x3a>
    wait(0);
    1896:	4501                	li	a0,0
    1898:	75a030ef          	jal	4ff2 <wait>
  for(int i = 0; i < 800; i++){
    189c:	34fd                	addiw	s1,s1,-1
    189e:	f4fd                	bnez	s1,188c <reparent2+0xe>
  exit(0);
    18a0:	4501                	li	a0,0
    18a2:	748030ef          	jal	4fea <exit>
      printf("fork failed\n");
    18a6:	00006517          	auipc	a0,0x6
    18aa:	baa50513          	addi	a0,a0,-1110 # 7450 <malloc+0x1f68>
    18ae:	383030ef          	jal	5430 <printf>
      exit(1);
    18b2:	4505                	li	a0,1
    18b4:	736030ef          	jal	4fea <exit>
      fork();
    18b8:	72a030ef          	jal	4fe2 <fork>
      fork();
    18bc:	726030ef          	jal	4fe2 <fork>
      exit(0);
    18c0:	4501                	li	a0,0
    18c2:	728030ef          	jal	4fea <exit>

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
    18ea:	6f8030ef          	jal	4fe2 <fork>
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
    1904:	6ee030ef          	jal	4ff2 <wait>
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
    1936:	57650513          	addi	a0,a0,1398 # 5ea8 <malloc+0x9c0>
    193a:	2f7030ef          	jal	5430 <printf>
      exit(1);
    193e:	4505                	li	a0,1
    1940:	6aa030ef          	jal	4fea <exit>
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
    1962:	5e250513          	addi	a0,a0,1506 # 5f40 <malloc+0xa58>
    1966:	2cb030ef          	jal	5430 <printf>
          exit(1);
    196a:	4505                	li	a0,1
    196c:	67e030ef          	jal	4fea <exit>
          name[1] = '0' + (i / 2);
    1970:	01f4d79b          	srliw	a5,s1,0x1f
    1974:	9fa5                	addw	a5,a5,s1
    1976:	4017d79b          	sraiw	a5,a5,0x1
    197a:	0307879b          	addiw	a5,a5,48
    197e:	f6f408a3          	sb	a5,-143(s0)
          if(unlink(name) < 0){
    1982:	854a                	mv	a0,s2
    1984:	6b6030ef          	jal	503a <unlink>
    1988:	02054a63          	bltz	a0,19bc <createdelete+0xf6>
      for(i = 0; i < N; i++){
    198c:	2485                	addiw	s1,s1,1
        name[1] = '0' + i;
    198e:	0304879b          	addiw	a5,s1,48
    1992:	f6f408a3          	sb	a5,-143(s0)
        fd = open(name, O_CREATE | O_RDWR);
    1996:	85ce                	mv	a1,s3
    1998:	854a                	mv	a0,s2
    199a:	690030ef          	jal	502a <open>
        if(fd < 0){
    199e:	fa054fe3          	bltz	a0,195c <createdelete+0x96>
        close(fd);
    19a2:	670030ef          	jal	5012 <close>
        if(i > 0 && (i % 2 ) == 0){
    19a6:	fe9053e3          	blez	s1,198c <createdelete+0xc6>
    19aa:	0014f793          	andi	a5,s1,1
    19ae:	d3e9                	beqz	a5,1970 <createdelete+0xaa>
      for(i = 0; i < N; i++){
    19b0:	2485                	addiw	s1,s1,1
    19b2:	fd449ee3          	bne	s1,s4,198e <createdelete+0xc8>
      exit(0);
    19b6:	4501                	li	a0,0
    19b8:	632030ef          	jal	4fea <exit>
            printf("%s: unlink failed\n", s);
    19bc:	85ee                	mv	a1,s11
    19be:	00004517          	auipc	a0,0x4
    19c2:	6da50513          	addi	a0,a0,1754 # 6098 <malloc+0xbb0>
    19c6:	26b030ef          	jal	5430 <printf>
            exit(1);
    19ca:	4505                	li	a0,1
    19cc:	61e030ef          	jal	4fea <exit>
      exit(1);
    19d0:	4505                	li	a0,1
    19d2:	618030ef          	jal	4fea <exit>
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
    19f4:	636030ef          	jal	502a <open>
      if((i == 0 || i >= N/2) && fd < 0){
    19f8:	01f5579b          	srliw	a5,a0,0x1f
    19fc:	dfe9                	beqz	a5,19d6 <createdelete+0x110>
    19fe:	fc098ce3          	beqz	s3,19d6 <createdelete+0x110>
        printf("%s: oops createdelete %s didn't exist\n", s, name);
    1a02:	f7040613          	addi	a2,s0,-144
    1a06:	85ee                	mv	a1,s11
    1a08:	00004517          	auipc	a0,0x4
    1a0c:	6a850513          	addi	a0,a0,1704 # 60b0 <malloc+0xbc8>
    1a10:	221030ef          	jal	5430 <printf>
        exit(1);
    1a14:	4505                	li	a0,1
    1a16:	5d4030ef          	jal	4fea <exit>
      } else if((i >= 1 && i < N/2) && fd >= 0){
    1a1a:	fc0542e3          	bltz	a0,19de <createdelete+0x118>
        printf("%s: oops createdelete %s did exist\n", s, name);
    1a1e:	f7040613          	addi	a2,s0,-144
    1a22:	85ee                	mv	a1,s11
    1a24:	00004517          	auipc	a0,0x4
    1a28:	6b450513          	addi	a0,a0,1716 # 60d8 <malloc+0xbf0>
    1a2c:	205030ef          	jal	5430 <printf>
        exit(1);
    1a30:	4505                	li	a0,1
    1a32:	5b8030ef          	jal	4fea <exit>
        close(fd);
    1a36:	5dc030ef          	jal	5012 <close>
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
    1a7c:	5be030ef          	jal	503a <unlink>
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
    1ad4:	bb850513          	addi	a0,a0,-1096 # 5688 <malloc+0x1a0>
    1ad8:	562030ef          	jal	503a <unlink>
  pid = fork();
    1adc:	506030ef          	jal	4fe2 <fork>
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
    1afc:	039a0a1b          	addiw	s4,s4,57 # 3039 <subdir+0x339>
    if((x % 3) == 0){
    1b00:	000ab9b7          	lui	s3,0xab
    1b04:	aab98993          	addi	s3,s3,-1365 # aaaab <base+0x99df3>
    1b08:	09b2                	slli	s3,s3,0xc
    1b0a:	aab98993          	addi	s3,s3,-1365
    } else if((x % 3) == 1){
    1b0e:	4b85                	li	s7,1
      unlink("x");
    1b10:	00004b17          	auipc	s6,0x4
    1b14:	b78b0b13          	addi	s6,s6,-1160 # 5688 <malloc+0x1a0>
      link("cat", "x");
    1b18:	00004c97          	auipc	s9,0x4
    1b1c:	5e8c8c93          	addi	s9,s9,1512 # 6100 <malloc+0xc18>
      close(open("x", O_RDWR | O_CREATE));
    1b20:	20200c13          	li	s8,514
    1b24:	a03d                	j	1b52 <linkunlink+0xa0>
    printf("%s: fork failed\n", s);
    1b26:	85a6                	mv	a1,s1
    1b28:	00004517          	auipc	a0,0x4
    1b2c:	38050513          	addi	a0,a0,896 # 5ea8 <malloc+0x9c0>
    1b30:	101030ef          	jal	5430 <printf>
    exit(1);
    1b34:	4505                	li	a0,1
    1b36:	4b4030ef          	jal	4fea <exit>
      close(open("x", O_RDWR | O_CREATE));
    1b3a:	85e2                	mv	a1,s8
    1b3c:	855a                	mv	a0,s6
    1b3e:	4ec030ef          	jal	502a <open>
    1b42:	4d0030ef          	jal	5012 <close>
    1b46:	a021                	j	1b4e <linkunlink+0x9c>
      unlink("x");
    1b48:	855a                	mv	a0,s6
    1b4a:	4f0030ef          	jal	503a <unlink>
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
    1b7a:	4d0030ef          	jal	504a <link>
    1b7e:	bfc1                	j	1b4e <linkunlink+0x9c>
  if(pid)
    1b80:	020d0363          	beqz	s10,1ba6 <linkunlink+0xf4>
    wait(0);
    1b84:	4501                	li	a0,0
    1b86:	46c030ef          	jal	4ff2 <wait>
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
    1ba8:	442030ef          	jal	4fea <exit>

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
    1bc2:	420030ef          	jal	4fe2 <fork>
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
    1bd8:	57c50513          	addi	a0,a0,1404 # 6150 <malloc+0xc68>
    1bdc:	055030ef          	jal	5430 <printf>
    exit(1);
    1be0:	4505                	li	a0,1
    1be2:	408030ef          	jal	4fea <exit>
      exit(0);
    1be6:	404030ef          	jal	4fea <exit>
    printf("%s: no fork at all!\n", s);
    1bea:	85ce                	mv	a1,s3
    1bec:	00004517          	auipc	a0,0x4
    1bf0:	51c50513          	addi	a0,a0,1308 # 6108 <malloc+0xc20>
    1bf4:	03d030ef          	jal	5430 <printf>
    exit(1);
    1bf8:	4505                	li	a0,1
    1bfa:	3f0030ef          	jal	4fea <exit>
      printf("%s: wait stopped early\n", s);
    1bfe:	85ce                	mv	a1,s3
    1c00:	00004517          	auipc	a0,0x4
    1c04:	52050513          	addi	a0,a0,1312 # 6120 <malloc+0xc38>
    1c08:	029030ef          	jal	5430 <printf>
      exit(1);
    1c0c:	4505                	li	a0,1
    1c0e:	3dc030ef          	jal	4fea <exit>
    printf("%s: wait got too many\n", s);
    1c12:	85ce                	mv	a1,s3
    1c14:	00004517          	auipc	a0,0x4
    1c18:	52450513          	addi	a0,a0,1316 # 6138 <malloc+0xc50>
    1c1c:	015030ef          	jal	5430 <printf>
    exit(1);
    1c20:	4505                	li	a0,1
    1c22:	3c8030ef          	jal	4fea <exit>
  if (n == 0) {
    1c26:	d0f1                	beqz	s1,1bea <forktest+0x3e>
  for(; n > 0; n--){
    1c28:	00905963          	blez	s1,1c3a <forktest+0x8e>
    if(wait(0) < 0){
    1c2c:	4501                	li	a0,0
    1c2e:	3c4030ef          	jal	4ff2 <wait>
    1c32:	fc0546e3          	bltz	a0,1bfe <forktest+0x52>
  for(; n > 0; n--){
    1c36:	34fd                	addiw	s1,s1,-1
    1c38:	f8f5                	bnez	s1,1c2c <forktest+0x80>
  if(wait(0) != -1){
    1c3a:	4501                	li	a0,0
    1c3c:	3b6030ef          	jal	4ff2 <wait>
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
    1c84:	35e030ef          	jal	4fe2 <fork>
    if(pid < 0){
    1c88:	02054763          	bltz	a0,1cb6 <kernmem+0x62>
    if(pid == 0){
    1c8c:	cd1d                	beqz	a0,1cca <kernmem+0x76>
    wait(&xstatus);
    1c8e:	8556                	mv	a0,s5
    1c90:	362030ef          	jal	4ff2 <wait>
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
    1cbc:	1f050513          	addi	a0,a0,496 # 5ea8 <malloc+0x9c0>
    1cc0:	770030ef          	jal	5430 <printf>
      exit(1);
    1cc4:	4505                	li	a0,1
    1cc6:	324030ef          	jal	4fea <exit>
      printf("%s: oops could read %p = %x\n", s, a, *a);
    1cca:	0004c683          	lbu	a3,0(s1)
    1cce:	8626                	mv	a2,s1
    1cd0:	85da                	mv	a1,s6
    1cd2:	00004517          	auipc	a0,0x4
    1cd6:	4a650513          	addi	a0,a0,1190 # 6178 <malloc+0xc90>
    1cda:	756030ef          	jal	5430 <printf>
      exit(1);
    1cde:	4505                	li	a0,1
    1ce0:	30a030ef          	jal	4fea <exit>
      exit(1);
    1ce4:	4505                	li	a0,1
    1ce6:	304030ef          	jal	4fea <exit>

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
    1d0e:	2d4030ef          	jal	4fe2 <fork>
    if(pid < 0){
    1d12:	02054963          	bltz	a0,1d44 <MAXVAplus+0x5a>
    if(pid == 0){
    1d16:	c129                	beqz	a0,1d58 <MAXVAplus+0x6e>
    wait(&xstatus);
    1d18:	854a                	mv	a0,s2
    1d1a:	2d8030ef          	jal	4ff2 <wait>
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
    1d4a:	16250513          	addi	a0,a0,354 # 5ea8 <malloc+0x9c0>
    1d4e:	6e2030ef          	jal	5430 <printf>
      exit(1);
    1d52:	4505                	li	a0,1
    1d54:	296030ef          	jal	4fea <exit>
      *(char*)a = 99;
    1d58:	fc843783          	ld	a5,-56(s0)
    1d5c:	06300713          	li	a4,99
    1d60:	00e78023          	sb	a4,0(a5)
      printf("%s: oops wrote %p\n", s, (void*)a);
    1d64:	fc843603          	ld	a2,-56(s0)
    1d68:	85ce                	mv	a1,s3
    1d6a:	00004517          	auipc	a0,0x4
    1d6e:	42e50513          	addi	a0,a0,1070 # 6198 <malloc+0xcb0>
    1d72:	6be030ef          	jal	5430 <printf>
      exit(1);
    1d76:	4505                	li	a0,1
    1d78:	272030ef          	jal	4fea <exit>
      exit(1);
    1d7c:	4505                	li	a0,1
    1d7e:	26c030ef          	jal	4fea <exit>

0000000000001d82 <stacktest>:
{
    1d82:	7179                	addi	sp,sp,-48
    1d84:	f406                	sd	ra,40(sp)
    1d86:	f022                	sd	s0,32(sp)
    1d88:	ec26                	sd	s1,24(sp)
    1d8a:	1800                	addi	s0,sp,48
    1d8c:	84aa                	mv	s1,a0
  pid = fork();
    1d8e:	254030ef          	jal	4fe2 <fork>
  if(pid == 0) {
    1d92:	cd11                	beqz	a0,1dae <stacktest+0x2c>
  } else if(pid < 0){
    1d94:	02054c63          	bltz	a0,1dcc <stacktest+0x4a>
  wait(&xstatus);
    1d98:	fdc40513          	addi	a0,s0,-36
    1d9c:	256030ef          	jal	4ff2 <wait>
  if(xstatus == -1)  // kernel killed child?
    1da0:	fdc42503          	lw	a0,-36(s0)
    1da4:	57fd                	li	a5,-1
    1da6:	02f50d63          	beq	a0,a5,1de0 <stacktest+0x5e>
    exit(xstatus);
    1daa:	240030ef          	jal	4fea <exit>

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
    1dbe:	3f650513          	addi	a0,a0,1014 # 61b0 <malloc+0xcc8>
    1dc2:	66e030ef          	jal	5430 <printf>
    exit(1);
    1dc6:	4505                	li	a0,1
    1dc8:	222030ef          	jal	4fea <exit>
    printf("%s: fork failed\n", s);
    1dcc:	85a6                	mv	a1,s1
    1dce:	00004517          	auipc	a0,0x4
    1dd2:	0da50513          	addi	a0,a0,218 # 5ea8 <malloc+0x9c0>
    1dd6:	65a030ef          	jal	5430 <printf>
    exit(1);
    1dda:	4505                	li	a0,1
    1ddc:	20e030ef          	jal	4fea <exit>
    exit(0);
    1de0:	4501                	li	a0,0
    1de2:	208030ef          	jal	4fea <exit>

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
    1dfc:	d6878793          	addi	a5,a5,-664 # 7b60 <malloc+0x2678>
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
    1e2c:	1b6030ef          	jal	4fe2 <fork>
    if(pid == 0) {
    1e30:	cd19                	beqz	a0,1e4e <nowrite+0x68>
    } else if(pid < 0){
    1e32:	04054163          	bltz	a0,1e74 <nowrite+0x8e>
    wait(&xstatus);
    1e36:	854a                	mv	a0,s2
    1e38:	1ba030ef          	jal	4ff2 <wait>
    if(xstatus == 0){
    1e3c:	fcc42783          	lw	a5,-52(s0)
    1e40:	c7a1                	beqz	a5,1e88 <nowrite+0xa2>
  for(int ai = 0; ai < sizeof(addrs)/sizeof(addrs[0]); ai++){
    1e42:	2485                	addiw	s1,s1,1
    1e44:	ff3494e3          	bne	s1,s3,1e2c <nowrite+0x46>
  exit(0);
    1e48:	4501                	li	a0,0
    1e4a:	1a0030ef          	jal	4fea <exit>
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
    1e66:	37650513          	addi	a0,a0,886 # 61d8 <malloc+0xcf0>
    1e6a:	5c6030ef          	jal	5430 <printf>
      exit(0);
    1e6e:	4501                	li	a0,0
    1e70:	17a030ef          	jal	4fea <exit>
      printf("%s: fork failed\n", s);
    1e74:	85d2                	mv	a1,s4
    1e76:	00004517          	auipc	a0,0x4
    1e7a:	03250513          	addi	a0,a0,50 # 5ea8 <malloc+0x9c0>
    1e7e:	5b2030ef          	jal	5430 <printf>
      exit(1);
    1e82:	4505                	li	a0,1
    1e84:	166030ef          	jal	4fea <exit>
      exit(1);
    1e88:	4505                	li	a0,1
    1e8a:	160030ef          	jal	4fea <exit>

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
    1ea4:	13e030ef          	jal	4fe2 <fork>
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
    1ec2:	130030ef          	jal	4ff2 <wait>
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
    1ede:	10c030ef          	jal	4fea <exit>
    1ee2:	e0d2                	sd	s4,64(sp)
    1ee4:	fc56                	sd	s5,56(sp)
    1ee6:	f85a                	sd	s6,48(sp)
    1ee8:	f45e                	sd	s7,40(sp)
    1eea:	f062                	sd	s8,32(sp)
    1eec:	e86a                	sd	s10,16(sp)
      printf("fork failed\n");
    1eee:	00005517          	auipc	a0,0x5
    1ef2:	56250513          	addi	a0,a0,1378 # 7450 <malloc+0x1f68>
    1ef6:	53a030ef          	jal	5430 <printf>
      exit(1);
    1efa:	4505                	li	a0,1
    1efc:	0ee030ef          	jal	4fea <exit>
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
    1f24:	116030ef          	jal	503a <unlink>
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
    1f48:	0e2030ef          	jal	502a <open>
    1f4c:	89aa                	mv	s3,a0
          if(fd < 0){
    1f4e:	02054d63          	bltz	a0,1f88 <manywrites+0xfa>
          int cc = write(fd, buf, sz);
    1f52:	8656                	mv	a2,s5
    1f54:	85e2                	mv	a1,s8
    1f56:	0b4030ef          	jal	500a <write>
          if(cc != sz){
    1f5a:	05551363          	bne	a0,s5,1fa0 <manywrites+0x112>
          close(fd);
    1f5e:	854e                	mv	a0,s3
    1f60:	0b2030ef          	jal	5012 <close>
        for(int i = 0; i < ci+1; i++){
    1f64:	2a05                	addiw	s4,s4,1
    1f66:	fd495fe3          	bge	s2,s4,1f44 <manywrites+0xb6>
        unlink(name);
    1f6a:	f9840513          	addi	a0,s0,-104
    1f6e:	0cc030ef          	jal	503a <unlink>
      for(int iters = 0; iters < howmany; iters++){
    1f72:	fffd079b          	addiw	a5,s10,-1
    1f76:	8d3e                	mv	s10,a5
    1f78:	f3f9                	bnez	a5,1f3e <manywrites+0xb0>
      unlink(name);
    1f7a:	f9840513          	addi	a0,s0,-104
    1f7e:	0bc030ef          	jal	503a <unlink>
      exit(0);
    1f82:	4501                	li	a0,0
    1f84:	066030ef          	jal	4fea <exit>
            printf("%s: cannot create %s\n", s, name);
    1f88:	f9840613          	addi	a2,s0,-104
    1f8c:	85e6                	mv	a1,s9
    1f8e:	00004517          	auipc	a0,0x4
    1f92:	26a50513          	addi	a0,a0,618 # 61f8 <malloc+0xd10>
    1f96:	49a030ef          	jal	5430 <printf>
            exit(1);
    1f9a:	4505                	li	a0,1
    1f9c:	04e030ef          	jal	4fea <exit>
            printf("%s: write(%d) ret %d\n", s, sz, cc);
    1fa0:	86aa                	mv	a3,a0
    1fa2:	660d                	lui	a2,0x3
    1fa4:	85e6                	mv	a1,s9
    1fa6:	00003517          	auipc	a0,0x3
    1faa:	74250513          	addi	a0,a0,1858 # 56e8 <malloc+0x200>
    1fae:	482030ef          	jal	5430 <printf>
            exit(1);
    1fb2:	4505                	li	a0,1
    1fb4:	036030ef          	jal	4fea <exit>
    1fb8:	e0d2                	sd	s4,64(sp)
    1fba:	fc56                	sd	s5,56(sp)
    1fbc:	f85a                	sd	s6,48(sp)
    1fbe:	f45e                	sd	s7,40(sp)
    1fc0:	f062                	sd	s8,32(sp)
    1fc2:	e86a                	sd	s10,16(sp)
      exit(st);
    1fc4:	026030ef          	jal	4fea <exit>

0000000000001fc8 <copyinstr3>:
{
    1fc8:	7179                	addi	sp,sp,-48
    1fca:	f406                	sd	ra,40(sp)
    1fcc:	f022                	sd	s0,32(sp)
    1fce:	ec26                	sd	s1,24(sp)
    1fd0:	1800                	addi	s0,sp,48
  sbrk(8192);
    1fd2:	6509                	lui	a0,0x2
    1fd4:	7e3020ef          	jal	4fb6 <sbrk>
  uint64 top = (uint64) sbrk(0);
    1fd8:	4501                	li	a0,0
    1fda:	7dd020ef          	jal	4fb6 <sbrk>
  if((top % PGSIZE) != 0){
    1fde:	03451793          	slli	a5,a0,0x34
    1fe2:	e7bd                	bnez	a5,2050 <copyinstr3+0x88>
  top = (uint64) sbrk(0);
    1fe4:	4501                	li	a0,0
    1fe6:	7d1020ef          	jal	4fb6 <sbrk>
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
    1ffe:	03c030ef          	jal	503a <unlink>
  if(ret != -1){
    2002:	57fd                	li	a5,-1
    2004:	06f51763          	bne	a0,a5,2072 <copyinstr3+0xaa>
  int fd = open(b, O_CREATE | O_WRONLY);
    2008:	20100593          	li	a1,513
    200c:	8526                	mv	a0,s1
    200e:	01c030ef          	jal	502a <open>
  if(fd != -1){
    2012:	57fd                	li	a5,-1
    2014:	06f51a63          	bne	a0,a5,2088 <copyinstr3+0xc0>
  ret = link(b, b);
    2018:	85a6                	mv	a1,s1
    201a:	8526                	mv	a0,s1
    201c:	02e030ef          	jal	504a <link>
  if(ret != -1){
    2020:	57fd                	li	a5,-1
    2022:	06f51e63          	bne	a0,a5,209e <copyinstr3+0xd6>
  char *args[] = { "xx", 0 };
    2026:	00005797          	auipc	a5,0x5
    202a:	ed278793          	addi	a5,a5,-302 # 6ef8 <malloc+0x1a10>
    202e:	fcf43823          	sd	a5,-48(s0)
    2032:	fc043c23          	sd	zero,-40(s0)
  ret = exec(b, args);
    2036:	fd040593          	addi	a1,s0,-48
    203a:	8526                	mv	a0,s1
    203c:	7e7020ef          	jal	5022 <exec>
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
    205a:	75d020ef          	jal	4fb6 <sbrk>
    205e:	b759                	j	1fe4 <copyinstr3+0x1c>
    printf("oops\n");
    2060:	00004517          	auipc	a0,0x4
    2064:	1b050513          	addi	a0,a0,432 # 6210 <malloc+0xd28>
    2068:	3c8030ef          	jal	5430 <printf>
    exit(1);
    206c:	4505                	li	a0,1
    206e:	77d020ef          	jal	4fea <exit>
    printf("unlink(%s) returned %d, not -1\n", b, ret);
    2072:	862a                	mv	a2,a0
    2074:	85a6                	mv	a1,s1
    2076:	00004517          	auipc	a0,0x4
    207a:	d5250513          	addi	a0,a0,-686 # 5dc8 <malloc+0x8e0>
    207e:	3b2030ef          	jal	5430 <printf>
    exit(1);
    2082:	4505                	li	a0,1
    2084:	767020ef          	jal	4fea <exit>
    printf("open(%s) returned %d, not -1\n", b, fd);
    2088:	862a                	mv	a2,a0
    208a:	85a6                	mv	a1,s1
    208c:	00004517          	auipc	a0,0x4
    2090:	d5c50513          	addi	a0,a0,-676 # 5de8 <malloc+0x900>
    2094:	39c030ef          	jal	5430 <printf>
    exit(1);
    2098:	4505                	li	a0,1
    209a:	751020ef          	jal	4fea <exit>
    printf("link(%s, %s) returned %d, not -1\n", b, b, ret);
    209e:	86aa                	mv	a3,a0
    20a0:	8626                	mv	a2,s1
    20a2:	85a6                	mv	a1,s1
    20a4:	00004517          	auipc	a0,0x4
    20a8:	d6450513          	addi	a0,a0,-668 # 5e08 <malloc+0x920>
    20ac:	384030ef          	jal	5430 <printf>
    exit(1);
    20b0:	4505                	li	a0,1
    20b2:	739020ef          	jal	4fea <exit>
    printf("exec(%s) returned %d, not -1\n", b, fd);
    20b6:	863e                	mv	a2,a5
    20b8:	85a6                	mv	a1,s1
    20ba:	00004517          	auipc	a0,0x4
    20be:	d7650513          	addi	a0,a0,-650 # 5e30 <malloc+0x948>
    20c2:	36e030ef          	jal	5430 <printf>
    exit(1);
    20c6:	4505                	li	a0,1
    20c8:	723020ef          	jal	4fea <exit>

00000000000020cc <rwsbrk>:
{
    20cc:	1101                	addi	sp,sp,-32
    20ce:	ec06                	sd	ra,24(sp)
    20d0:	e822                	sd	s0,16(sp)
    20d2:	1000                	addi	s0,sp,32
  uint64 a = (uint64) sbrk(8192);
    20d4:	6509                	lui	a0,0x2
    20d6:	6e1020ef          	jal	4fb6 <sbrk>
  if(a == (uint64) SBRK_ERROR) {
    20da:	57fd                	li	a5,-1
    20dc:	04f50a63          	beq	a0,a5,2130 <rwsbrk+0x64>
    20e0:	e426                	sd	s1,8(sp)
    20e2:	84aa                	mv	s1,a0
  if (sbrk(-8192) == SBRK_ERROR) {
    20e4:	7579                	lui	a0,0xffffe
    20e6:	6d1020ef          	jal	4fb6 <sbrk>
    20ea:	57fd                	li	a5,-1
    20ec:	04f50d63          	beq	a0,a5,2146 <rwsbrk+0x7a>
    20f0:	e04a                	sd	s2,0(sp)
  fd = open("rwsbrk", O_CREATE|O_WRONLY);
    20f2:	20100593          	li	a1,513
    20f6:	00004517          	auipc	a0,0x4
    20fa:	15a50513          	addi	a0,a0,346 # 6250 <malloc+0xd68>
    20fe:	72d020ef          	jal	502a <open>
    2102:	892a                	mv	s2,a0
  if(fd < 0){
    2104:	04054b63          	bltz	a0,215a <rwsbrk+0x8e>
  n = write(fd, (void*)(a+PGSIZE), 1024);
    2108:	6785                	lui	a5,0x1
    210a:	94be                	add	s1,s1,a5
    210c:	40000613          	li	a2,1024
    2110:	85a6                	mv	a1,s1
    2112:	6f9020ef          	jal	500a <write>
    2116:	862a                	mv	a2,a0
  if(n >= 0){
    2118:	04054a63          	bltz	a0,216c <rwsbrk+0xa0>
    printf("write(fd, %p, 1024) returned %d, not -1\n", (void*)a+PGSIZE, n);
    211c:	85a6                	mv	a1,s1
    211e:	00004517          	auipc	a0,0x4
    2122:	15250513          	addi	a0,a0,338 # 6270 <malloc+0xd88>
    2126:	30a030ef          	jal	5430 <printf>
    exit(1);
    212a:	4505                	li	a0,1
    212c:	6bf020ef          	jal	4fea <exit>
    2130:	e426                	sd	s1,8(sp)
    2132:	e04a                	sd	s2,0(sp)
    printf("sbrk(rwsbrk) failed\n");
    2134:	00004517          	auipc	a0,0x4
    2138:	0e450513          	addi	a0,a0,228 # 6218 <malloc+0xd30>
    213c:	2f4030ef          	jal	5430 <printf>
    exit(1);
    2140:	4505                	li	a0,1
    2142:	6a9020ef          	jal	4fea <exit>
    2146:	e04a                	sd	s2,0(sp)
    printf("sbrk(rwsbrk) shrink failed\n");
    2148:	00004517          	auipc	a0,0x4
    214c:	0e850513          	addi	a0,a0,232 # 6230 <malloc+0xd48>
    2150:	2e0030ef          	jal	5430 <printf>
    exit(1);
    2154:	4505                	li	a0,1
    2156:	695020ef          	jal	4fea <exit>
    printf("open(rwsbrk) failed\n");
    215a:	00004517          	auipc	a0,0x4
    215e:	0fe50513          	addi	a0,a0,254 # 6258 <malloc+0xd70>
    2162:	2ce030ef          	jal	5430 <printf>
    exit(1);
    2166:	4505                	li	a0,1
    2168:	683020ef          	jal	4fea <exit>
  close(fd);
    216c:	854a                	mv	a0,s2
    216e:	6a5020ef          	jal	5012 <close>
  unlink("rwsbrk");
    2172:	00004517          	auipc	a0,0x4
    2176:	0de50513          	addi	a0,a0,222 # 6250 <malloc+0xd68>
    217a:	6c1020ef          	jal	503a <unlink>
  fd = open("README", O_RDONLY);
    217e:	4581                	li	a1,0
    2180:	00003517          	auipc	a0,0x3
    2184:	67050513          	addi	a0,a0,1648 # 57f0 <malloc+0x308>
    2188:	6a3020ef          	jal	502a <open>
    218c:	892a                	mv	s2,a0
  if(fd < 0){
    218e:	02054363          	bltz	a0,21b4 <rwsbrk+0xe8>
  n = read(fd, (void*)(a+PGSIZE), 10);
    2192:	4629                	li	a2,10
    2194:	85a6                	mv	a1,s1
    2196:	66d020ef          	jal	5002 <read>
    219a:	862a                	mv	a2,a0
  if(n >= 0){
    219c:	02054563          	bltz	a0,21c6 <rwsbrk+0xfa>
    printf("read(fd, %p, 10) returned %d, not -1\n", (void*)a+PGSIZE, n);
    21a0:	85a6                	mv	a1,s1
    21a2:	00004517          	auipc	a0,0x4
    21a6:	0fe50513          	addi	a0,a0,254 # 62a0 <malloc+0xdb8>
    21aa:	286030ef          	jal	5430 <printf>
    exit(1);
    21ae:	4505                	li	a0,1
    21b0:	63b020ef          	jal	4fea <exit>
    printf("open(README) failed\n");
    21b4:	00003517          	auipc	a0,0x3
    21b8:	64450513          	addi	a0,a0,1604 # 57f8 <malloc+0x310>
    21bc:	274030ef          	jal	5430 <printf>
    exit(1);
    21c0:	4505                	li	a0,1
    21c2:	629020ef          	jal	4fea <exit>
  close(fd);
    21c6:	854a                	mv	a0,s2
    21c8:	64b020ef          	jal	5012 <close>
  exit(0);
    21cc:	4501                	li	a0,0
    21ce:	61d020ef          	jal	4fea <exit>

00000000000021d2 <sbrkbasic>:
{
    21d2:	715d                	addi	sp,sp,-80
    21d4:	e486                	sd	ra,72(sp)
    21d6:	e0a2                	sd	s0,64(sp)
    21d8:	ec56                	sd	s5,24(sp)
    21da:	0880                	addi	s0,sp,80
    21dc:	8aaa                	mv	s5,a0
  pid = fork();
    21de:	605020ef          	jal	4fe2 <fork>
  if(pid < 0){
    21e2:	02054c63          	bltz	a0,221a <sbrkbasic+0x48>
  if(pid == 0){
    21e6:	ed31                	bnez	a0,2242 <sbrkbasic+0x70>
    a = sbrk(TOOMUCH);
    21e8:	40000537          	lui	a0,0x40000
    21ec:	5cb020ef          	jal	4fb6 <sbrk>
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
    2216:	5d5020ef          	jal	4fea <exit>
    221a:	fc26                	sd	s1,56(sp)
    221c:	f84a                	sd	s2,48(sp)
    221e:	f44e                	sd	s3,40(sp)
    2220:	f052                	sd	s4,32(sp)
    printf("fork failed in sbrkbasic\n");
    2222:	00004517          	auipc	a0,0x4
    2226:	0a650513          	addi	a0,a0,166 # 62c8 <malloc+0xde0>
    222a:	206030ef          	jal	5430 <printf>
    exit(1);
    222e:	4505                	li	a0,1
    2230:	5bb020ef          	jal	4fea <exit>
    2234:	fc26                	sd	s1,56(sp)
    2236:	f84a                	sd	s2,48(sp)
    2238:	f44e                	sd	s3,40(sp)
    223a:	f052                	sd	s4,32(sp)
      exit(0);
    223c:	4501                	li	a0,0
    223e:	5ad020ef          	jal	4fea <exit>
  wait(&xstatus);
    2242:	fbc40513          	addi	a0,s0,-68
    2246:	5ad020ef          	jal	4ff2 <wait>
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
    225e:	559020ef          	jal	4fb6 <sbrk>
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
    227e:	06e50513          	addi	a0,a0,110 # 62e8 <malloc+0xe00>
    2282:	1ae030ef          	jal	5430 <printf>
    exit(1);
    2286:	4505                	li	a0,1
    2288:	563020ef          	jal	4fea <exit>
    228c:	84be                	mv	s1,a5
    b = sbrk(1);
    228e:	854e                	mv	a0,s3
    2290:	527020ef          	jal	4fb6 <sbrk>
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
    22a6:	53d020ef          	jal	4fe2 <fork>
    22aa:	892a                	mv	s2,a0
  if(pid < 0){
    22ac:	04054263          	bltz	a0,22f0 <sbrkbasic+0x11e>
  c = sbrk(1);
    22b0:	4505                	li	a0,1
    22b2:	505020ef          	jal	4fb6 <sbrk>
  c = sbrk(1);
    22b6:	4505                	li	a0,1
    22b8:	4ff020ef          	jal	4fb6 <sbrk>
  if(c != a + 1){
    22bc:	0489                	addi	s1,s1,2
    22be:	04950363          	beq	a0,s1,2304 <sbrkbasic+0x132>
    printf("%s: sbrk test failed post-fork\n", s);
    22c2:	85d6                	mv	a1,s5
    22c4:	00004517          	auipc	a0,0x4
    22c8:	08450513          	addi	a0,a0,132 # 6348 <malloc+0xe60>
    22cc:	164030ef          	jal	5430 <printf>
    exit(1);
    22d0:	4505                	li	a0,1
    22d2:	519020ef          	jal	4fea <exit>
      printf("%s: sbrk test failed %d %p %p\n", s, i, a, b);
    22d6:	872a                	mv	a4,a0
    22d8:	86a6                	mv	a3,s1
    22da:	864a                	mv	a2,s2
    22dc:	85d6                	mv	a1,s5
    22de:	00004517          	auipc	a0,0x4
    22e2:	02a50513          	addi	a0,a0,42 # 6308 <malloc+0xe20>
    22e6:	14a030ef          	jal	5430 <printf>
      exit(1);
    22ea:	4505                	li	a0,1
    22ec:	4ff020ef          	jal	4fea <exit>
    printf("%s: sbrk test fork failed\n", s);
    22f0:	85d6                	mv	a1,s5
    22f2:	00004517          	auipc	a0,0x4
    22f6:	03650513          	addi	a0,a0,54 # 6328 <malloc+0xe40>
    22fa:	136030ef          	jal	5430 <printf>
    exit(1);
    22fe:	4505                	li	a0,1
    2300:	4eb020ef          	jal	4fea <exit>
  if(pid == 0)
    2304:	00091563          	bnez	s2,230e <sbrkbasic+0x13c>
    exit(0);
    2308:	4501                	li	a0,0
    230a:	4e1020ef          	jal	4fea <exit>
  wait(&xstatus);
    230e:	fbc40513          	addi	a0,s0,-68
    2312:	4e1020ef          	jal	4ff2 <wait>
  exit(xstatus);
    2316:	fbc42503          	lw	a0,-68(s0)
    231a:	4d1020ef          	jal	4fea <exit>

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
    2332:	485020ef          	jal	4fb6 <sbrk>
    2336:	892a                	mv	s2,a0
  a = sbrk(0);
    2338:	4501                	li	a0,0
    233a:	47d020ef          	jal	4fb6 <sbrk>
    233e:	84aa                	mv	s1,a0
  p = sbrk(amt);
    2340:	06400537          	lui	a0,0x6400
    2344:	9d05                	subw	a0,a0,s1
    2346:	471020ef          	jal	4fb6 <sbrk>
  if (p != a) {
    234a:	08a49963          	bne	s1,a0,23dc <sbrkmuch+0xbe>
  *lastaddr = 99;
    234e:	064007b7          	lui	a5,0x6400
    2352:	06300713          	li	a4,99
    2356:	fee78fa3          	sb	a4,-1(a5) # 63fffff <base+0x63ef347>
  a = sbrk(0);
    235a:	4501                	li	a0,0
    235c:	45b020ef          	jal	4fb6 <sbrk>
    2360:	84aa                	mv	s1,a0
  c = sbrk(-PGSIZE);
    2362:	757d                	lui	a0,0xfffff
    2364:	453020ef          	jal	4fb6 <sbrk>
  if(c == (char*)SBRK_ERROR){
    2368:	57fd                	li	a5,-1
    236a:	08f50363          	beq	a0,a5,23f0 <sbrkmuch+0xd2>
  c = sbrk(0);
    236e:	4501                	li	a0,0
    2370:	447020ef          	jal	4fb6 <sbrk>
  if(c != a - PGSIZE){
    2374:	80048793          	addi	a5,s1,-2048
    2378:	80078793          	addi	a5,a5,-2048
    237c:	08f51463          	bne	a0,a5,2404 <sbrkmuch+0xe6>
  a = sbrk(0);
    2380:	4501                	li	a0,0
    2382:	435020ef          	jal	4fb6 <sbrk>
    2386:	84aa                	mv	s1,a0
  c = sbrk(PGSIZE);
    2388:	6505                	lui	a0,0x1
    238a:	42d020ef          	jal	4fb6 <sbrk>
    238e:	8a2a                	mv	s4,a0
  if(c != a || sbrk(0) != a + PGSIZE){
    2390:	08a49663          	bne	s1,a0,241c <sbrkmuch+0xfe>
    2394:	4501                	li	a0,0
    2396:	421020ef          	jal	4fb6 <sbrk>
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
    23b4:	403020ef          	jal	4fb6 <sbrk>
    23b8:	84aa                	mv	s1,a0
  c = sbrk(-(sbrk(0) - oldbrk));
    23ba:	4501                	li	a0,0
    23bc:	3fb020ef          	jal	4fb6 <sbrk>
    23c0:	40a9053b          	subw	a0,s2,a0
    23c4:	3f3020ef          	jal	4fb6 <sbrk>
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
    23e2:	f8a50513          	addi	a0,a0,-118 # 6368 <malloc+0xe80>
    23e6:	04a030ef          	jal	5430 <printf>
    exit(1);
    23ea:	4505                	li	a0,1
    23ec:	3ff020ef          	jal	4fea <exit>
    printf("%s: sbrk could not deallocate\n", s);
    23f0:	85ce                	mv	a1,s3
    23f2:	00004517          	auipc	a0,0x4
    23f6:	fbe50513          	addi	a0,a0,-66 # 63b0 <malloc+0xec8>
    23fa:	036030ef          	jal	5430 <printf>
    exit(1);
    23fe:	4505                	li	a0,1
    2400:	3eb020ef          	jal	4fea <exit>
    printf("%s: sbrk deallocation produced wrong address, a %p c %p\n", s, a, c);
    2404:	86aa                	mv	a3,a0
    2406:	8626                	mv	a2,s1
    2408:	85ce                	mv	a1,s3
    240a:	00004517          	auipc	a0,0x4
    240e:	fc650513          	addi	a0,a0,-58 # 63d0 <malloc+0xee8>
    2412:	01e030ef          	jal	5430 <printf>
    exit(1);
    2416:	4505                	li	a0,1
    2418:	3d3020ef          	jal	4fea <exit>
    printf("%s: sbrk re-allocation failed, a %p c %p\n", s, a, c);
    241c:	86d2                	mv	a3,s4
    241e:	8626                	mv	a2,s1
    2420:	85ce                	mv	a1,s3
    2422:	00004517          	auipc	a0,0x4
    2426:	fee50513          	addi	a0,a0,-18 # 6410 <malloc+0xf28>
    242a:	006030ef          	jal	5430 <printf>
    exit(1);
    242e:	4505                	li	a0,1
    2430:	3bb020ef          	jal	4fea <exit>
    printf("%s: sbrk de-allocation didn't really deallocate\n", s);
    2434:	85ce                	mv	a1,s3
    2436:	00004517          	auipc	a0,0x4
    243a:	00a50513          	addi	a0,a0,10 # 6440 <malloc+0xf58>
    243e:	7f3020ef          	jal	5430 <printf>
    exit(1);
    2442:	4505                	li	a0,1
    2444:	3a7020ef          	jal	4fea <exit>
    printf("%s: sbrk downsize failed, a %p c %p\n", s, a, c);
    2448:	86aa                	mv	a3,a0
    244a:	8626                	mv	a2,s1
    244c:	85ce                	mv	a1,s3
    244e:	00004517          	auipc	a0,0x4
    2452:	02a50513          	addi	a0,a0,42 # 6478 <malloc+0xf90>
    2456:	7db020ef          	jal	5430 <printf>
    exit(1);
    245a:	4505                	li	a0,1
    245c:	38f020ef          	jal	4fea <exit>

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
    2472:	345020ef          	jal	4fb6 <sbrk>
    2476:	892a                	mv	s2,a0
  fd = open("sbrk", O_CREATE|O_WRONLY);
    2478:	20100593          	li	a1,513
    247c:	00004517          	auipc	a0,0x4
    2480:	02450513          	addi	a0,a0,36 # 64a0 <malloc+0xfb8>
    2484:	3a7020ef          	jal	502a <open>
    2488:	84aa                	mv	s1,a0
  unlink("sbrk");
    248a:	00004517          	auipc	a0,0x4
    248e:	01650513          	addi	a0,a0,22 # 64a0 <malloc+0xfb8>
    2492:	3a9020ef          	jal	503a <unlink>
  if(fd < 0)  {
    2496:	0204c963          	bltz	s1,24c8 <sbrkarg+0x68>
  if ((n = write(fd, a, PGSIZE)) < 0) {
    249a:	6605                	lui	a2,0x1
    249c:	85ca                	mv	a1,s2
    249e:	8526                	mv	a0,s1
    24a0:	36b020ef          	jal	500a <write>
    24a4:	02054c63          	bltz	a0,24dc <sbrkarg+0x7c>
  close(fd);
    24a8:	8526                	mv	a0,s1
    24aa:	369020ef          	jal	5012 <close>
  a = sbrk(PGSIZE);
    24ae:	6505                	lui	a0,0x1
    24b0:	307020ef          	jal	4fb6 <sbrk>
  if(pipe((int *) a) != 0){
    24b4:	347020ef          	jal	4ffa <pipe>
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
    24ce:	fde50513          	addi	a0,a0,-34 # 64a8 <malloc+0xfc0>
    24d2:	75f020ef          	jal	5430 <printf>
    exit(1);
    24d6:	4505                	li	a0,1
    24d8:	313020ef          	jal	4fea <exit>
    printf("%s: write sbrk failed\n", s);
    24dc:	85ce                	mv	a1,s3
    24de:	00004517          	auipc	a0,0x4
    24e2:	fe250513          	addi	a0,a0,-30 # 64c0 <malloc+0xfd8>
    24e6:	74b020ef          	jal	5430 <printf>
    exit(1);
    24ea:	4505                	li	a0,1
    24ec:	2ff020ef          	jal	4fea <exit>
    printf("%s: pipe() failed\n", s);
    24f0:	85ce                	mv	a1,s3
    24f2:	00004517          	auipc	a0,0x4
    24f6:	abe50513          	addi	a0,a0,-1346 # 5fb0 <malloc+0xac8>
    24fa:	737020ef          	jal	5430 <printf>
    exit(1);
    24fe:	4505                	li	a0,1
    2500:	2eb020ef          	jal	4fea <exit>

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
    2518:	fc450513          	addi	a0,a0,-60 # 64d8 <malloc+0xff0>
    251c:	30f020ef          	jal	502a <open>
  if (fd < 0) {
    2520:	02054563          	bltz	a0,254a <argptest+0x46>
    2524:	84aa                	mv	s1,a0
  read(fd, sbrk(0) - 1, -1);
    2526:	4501                	li	a0,0
    2528:	28f020ef          	jal	4fb6 <sbrk>
    252c:	567d                	li	a2,-1
    252e:	00c505b3          	add	a1,a0,a2
    2532:	8526                	mv	a0,s1
    2534:	2cf020ef          	jal	5002 <read>
  close(fd);
    2538:	8526                	mv	a0,s1
    253a:	2d9020ef          	jal	5012 <close>
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
    2550:	97450513          	addi	a0,a0,-1676 # 5ec0 <malloc+0x9d8>
    2554:	6dd020ef          	jal	5430 <printf>
    exit(1);
    2558:	4505                	li	a0,1
    255a:	291020ef          	jal	4fea <exit>

000000000000255e <sbrkbugs>:
{
    255e:	1141                	addi	sp,sp,-16
    2560:	e406                	sd	ra,8(sp)
    2562:	e022                	sd	s0,0(sp)
    2564:	0800                	addi	s0,sp,16
  int pid = fork();
    2566:	27d020ef          	jal	4fe2 <fork>
  if(pid < 0){
    256a:	00054c63          	bltz	a0,2582 <sbrkbugs+0x24>
  if(pid == 0){
    256e:	e11d                	bnez	a0,2594 <sbrkbugs+0x36>
    int sz = (uint64) sbrk(0);
    2570:	247020ef          	jal	4fb6 <sbrk>
    sbrk(-sz);
    2574:	40a0053b          	negw	a0,a0
    2578:	23f020ef          	jal	4fb6 <sbrk>
    exit(0);
    257c:	4501                	li	a0,0
    257e:	26d020ef          	jal	4fea <exit>
    printf("fork failed\n");
    2582:	00005517          	auipc	a0,0x5
    2586:	ece50513          	addi	a0,a0,-306 # 7450 <malloc+0x1f68>
    258a:	6a7020ef          	jal	5430 <printf>
    exit(1);
    258e:	4505                	li	a0,1
    2590:	25b020ef          	jal	4fea <exit>
  wait(0);
    2594:	4501                	li	a0,0
    2596:	25d020ef          	jal	4ff2 <wait>
  pid = fork();
    259a:	249020ef          	jal	4fe2 <fork>
  if(pid < 0){
    259e:	00054f63          	bltz	a0,25bc <sbrkbugs+0x5e>
  if(pid == 0){
    25a2:	e515                	bnez	a0,25ce <sbrkbugs+0x70>
    int sz = (uint64) sbrk(0);
    25a4:	213020ef          	jal	4fb6 <sbrk>
    sbrk(-(sz - 3500));
    25a8:	6785                	lui	a5,0x1
    25aa:	dac7879b          	addiw	a5,a5,-596 # dac <linktest+0xe2>
    25ae:	40a7853b          	subw	a0,a5,a0
    25b2:	205020ef          	jal	4fb6 <sbrk>
    exit(0);
    25b6:	4501                	li	a0,0
    25b8:	233020ef          	jal	4fea <exit>
    printf("fork failed\n");
    25bc:	00005517          	auipc	a0,0x5
    25c0:	e9450513          	addi	a0,a0,-364 # 7450 <malloc+0x1f68>
    25c4:	66d020ef          	jal	5430 <printf>
    exit(1);
    25c8:	4505                	li	a0,1
    25ca:	221020ef          	jal	4fea <exit>
  wait(0);
    25ce:	4501                	li	a0,0
    25d0:	223020ef          	jal	4ff2 <wait>
  pid = fork();
    25d4:	20f020ef          	jal	4fe2 <fork>
  if(pid < 0){
    25d8:	02054263          	bltz	a0,25fc <sbrkbugs+0x9e>
  if(pid == 0){
    25dc:	e90d                	bnez	a0,260e <sbrkbugs+0xb0>
    sbrk((10*PGSIZE + 2048) - (uint64)sbrk(0));
    25de:	1d9020ef          	jal	4fb6 <sbrk>
    25e2:	67ad                	lui	a5,0xb
    25e4:	8007879b          	addiw	a5,a5,-2048 # a800 <big.0+0x260>
    25e8:	40a7853b          	subw	a0,a5,a0
    25ec:	1cb020ef          	jal	4fb6 <sbrk>
    sbrk(-10);
    25f0:	5559                	li	a0,-10
    25f2:	1c5020ef          	jal	4fb6 <sbrk>
    exit(0);
    25f6:	4501                	li	a0,0
    25f8:	1f3020ef          	jal	4fea <exit>
    printf("fork failed\n");
    25fc:	00005517          	auipc	a0,0x5
    2600:	e5450513          	addi	a0,a0,-428 # 7450 <malloc+0x1f68>
    2604:	62d020ef          	jal	5430 <printf>
    exit(1);
    2608:	4505                	li	a0,1
    260a:	1e1020ef          	jal	4fea <exit>
  wait(0);
    260e:	4501                	li	a0,0
    2610:	1e3020ef          	jal	4ff2 <wait>
  exit(0);
    2614:	4501                	li	a0,0
    2616:	1d5020ef          	jal	4fea <exit>

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
    262c:	18b020ef          	jal	4fb6 <sbrk>
  if((top % PGSIZE) != 0)
    2630:	03451793          	slli	a5,a0,0x34
    2634:	ebad                	bnez	a5,26a6 <sbrklast+0x8c>
  sbrk(PGSIZE);
    2636:	6505                	lui	a0,0x1
    2638:	17f020ef          	jal	4fb6 <sbrk>
  sbrk(10);
    263c:	4529                	li	a0,10
    263e:	179020ef          	jal	4fb6 <sbrk>
  sbrk(-20);
    2642:	5531                	li	a0,-20
    2644:	173020ef          	jal	4fb6 <sbrk>
  top = (uint64) sbrk(0);
    2648:	4501                	li	a0,0
    264a:	16d020ef          	jal	4fb6 <sbrk>
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
    2666:	1c5020ef          	jal	502a <open>
    266a:	8a2a                	mv	s4,a0
  write(fd, p, 1);
    266c:	4605                	li	a2,1
    266e:	85ca                	mv	a1,s2
    2670:	19b020ef          	jal	500a <write>
  close(fd);
    2674:	8552                	mv	a0,s4
    2676:	19d020ef          	jal	5012 <close>
  fd = open(p, O_RDWR);
    267a:	4589                	li	a1,2
    267c:	854a                	mv	a0,s2
    267e:	1ad020ef          	jal	502a <open>
  p[0] = '\0';
    2682:	fc048023          	sb	zero,-64(s1)
  read(fd, p, 1);
    2686:	4605                	li	a2,1
    2688:	85ca                	mv	a1,s2
    268a:	179020ef          	jal	5002 <read>
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
    26b0:	107020ef          	jal	4fb6 <sbrk>
    26b4:	b749                	j	2636 <sbrklast+0x1c>
    exit(1);
    26b6:	4505                	li	a0,1
    26b8:	133020ef          	jal	4fea <exit>

00000000000026bc <sbrk8000>:
{
    26bc:	1141                	addi	sp,sp,-16
    26be:	e406                	sd	ra,8(sp)
    26c0:	e022                	sd	s0,0(sp)
    26c2:	0800                	addi	s0,sp,16
  sbrk(0x80000004);
    26c4:	80000537          	lui	a0,0x80000
    26c8:	0511                	addi	a0,a0,4 # ffffffff80000004 <base+0xffffffff7ffef34c>
    26ca:	0ed020ef          	jal	4fb6 <sbrk>
  volatile char *top = sbrk(0);
    26ce:	4501                	li	a0,0
    26d0:	0e7020ef          	jal	4fb6 <sbrk>
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
    26fc:	0e7020ef          	jal	4fe2 <fork>
    2700:	84aa                	mv	s1,a0
    if(pid < 0){
    2702:	00054e63          	bltz	a0,271e <execout+0x34>
    } else if(pid == 0){
    2706:	c51d                	beqz	a0,2734 <execout+0x4a>
      wait((int*)0);
    2708:	4501                	li	a0,0
    270a:	0e9020ef          	jal	4ff2 <wait>
  for(int avail = 0; avail < 15; avail++){
    270e:	2905                	addiw	s2,s2,1
    2710:	ff3916e3          	bne	s2,s3,26fc <execout+0x12>
    2714:	f852                	sd	s4,48(sp)
    2716:	f456                	sd	s5,40(sp)
  exit(0);
    2718:	4501                	li	a0,0
    271a:	0d1020ef          	jal	4fea <exit>
    271e:	f852                	sd	s4,48(sp)
    2720:	f456                	sd	s5,40(sp)
      printf("fork failed\n");
    2722:	00005517          	auipc	a0,0x5
    2726:	d2e50513          	addi	a0,a0,-722 # 7450 <malloc+0x1f68>
    272a:	507020ef          	jal	5430 <printf>
      exit(1);
    272e:	4505                	li	a0,1
    2730:	0bb020ef          	jal	4fea <exit>
    2734:	f852                	sd	s4,48(sp)
    2736:	f456                	sd	s5,40(sp)
        char *a = sbrk(PGSIZE);
    2738:	6985                	lui	s3,0x1
        if(a == SBRK_ERROR)
    273a:	5a7d                	li	s4,-1
        *(a + PGSIZE - 1) = 1;
    273c:	4a85                	li	s5,1
        char *a = sbrk(PGSIZE);
    273e:	854e                	mv	a0,s3
    2740:	077020ef          	jal	4fb6 <sbrk>
        if(a == SBRK_ERROR)
    2744:	01450663          	beq	a0,s4,2750 <execout+0x66>
        *(a + PGSIZE - 1) = 1;
    2748:	954e                	add	a0,a0,s3
    274a:	ff550fa3          	sb	s5,-1(a0)
      while(1){
    274e:	bfc5                	j	273e <execout+0x54>
        sbrk(-PGSIZE);
    2750:	79fd                	lui	s3,0xfffff
      for(int i = 0; i < avail; i++)
    2752:	01205863          	blez	s2,2762 <execout+0x78>
        sbrk(-PGSIZE);
    2756:	854e                	mv	a0,s3
    2758:	05f020ef          	jal	4fb6 <sbrk>
      for(int i = 0; i < avail; i++)
    275c:	2485                	addiw	s1,s1,1
    275e:	ff249ce3          	bne	s1,s2,2756 <execout+0x6c>
      close(1);
    2762:	4505                	li	a0,1
    2764:	0af020ef          	jal	5012 <close>
      char *args[] = { "echo", "x", 0 };
    2768:	00003797          	auipc	a5,0x3
    276c:	eb078793          	addi	a5,a5,-336 # 5618 <malloc+0x130>
    2770:	faf43423          	sd	a5,-88(s0)
    2774:	00003797          	auipc	a5,0x3
    2778:	f1478793          	addi	a5,a5,-236 # 5688 <malloc+0x1a0>
    277c:	faf43823          	sd	a5,-80(s0)
    2780:	fa043c23          	sd	zero,-72(s0)
      exec("echo", args);
    2784:	fa840593          	addi	a1,s0,-88
    2788:	00003517          	auipc	a0,0x3
    278c:	e9050513          	addi	a0,a0,-368 # 5618 <malloc+0x130>
    2790:	093020ef          	jal	5022 <exec>
      exit(0);
    2794:	4501                	li	a0,0
    2796:	055020ef          	jal	4fea <exit>

000000000000279a <fourteen>:
{
    279a:	1101                	addi	sp,sp,-32
    279c:	ec06                	sd	ra,24(sp)
    279e:	e822                	sd	s0,16(sp)
    27a0:	e426                	sd	s1,8(sp)
    27a2:	1000                	addi	s0,sp,32
    27a4:	84aa                	mv	s1,a0
  if(mkdir("12345678901234") != 0){
    27a6:	00004517          	auipc	a0,0x4
    27aa:	f0a50513          	addi	a0,a0,-246 # 66b0 <malloc+0x11c8>
    27ae:	0a5020ef          	jal	5052 <mkdir>
    27b2:	e555                	bnez	a0,285e <fourteen+0xc4>
  if(mkdir("12345678901234/123456789012345") != 0){
    27b4:	00004517          	auipc	a0,0x4
    27b8:	d5450513          	addi	a0,a0,-684 # 6508 <malloc+0x1020>
    27bc:	097020ef          	jal	5052 <mkdir>
    27c0:	e94d                	bnez	a0,2872 <fourteen+0xd8>
  fd = open("123456789012345/123456789012345/123456789012345", O_CREATE);
    27c2:	20000593          	li	a1,512
    27c6:	00004517          	auipc	a0,0x4
    27ca:	d9a50513          	addi	a0,a0,-614 # 6560 <malloc+0x1078>
    27ce:	05d020ef          	jal	502a <open>
  if(fd < 0){
    27d2:	0a054a63          	bltz	a0,2886 <fourteen+0xec>
  close(fd);
    27d6:	03d020ef          	jal	5012 <close>
  fd = open("12345678901234/12345678901234/12345678901234", 0);
    27da:	4581                	li	a1,0
    27dc:	00004517          	auipc	a0,0x4
    27e0:	dfc50513          	addi	a0,a0,-516 # 65d8 <malloc+0x10f0>
    27e4:	047020ef          	jal	502a <open>
  if(fd < 0){
    27e8:	0a054963          	bltz	a0,289a <fourteen+0x100>
  close(fd);
    27ec:	027020ef          	jal	5012 <close>
  if(mkdir("12345678901234/12345678901234") == 0){
    27f0:	00004517          	auipc	a0,0x4
    27f4:	e5850513          	addi	a0,a0,-424 # 6648 <malloc+0x1160>
    27f8:	05b020ef          	jal	5052 <mkdir>
    27fc:	c94d                	beqz	a0,28ae <fourteen+0x114>
  if(mkdir("123456789012345/12345678901234") == 0){
    27fe:	00004517          	auipc	a0,0x4
    2802:	ea250513          	addi	a0,a0,-350 # 66a0 <malloc+0x11b8>
    2806:	04d020ef          	jal	5052 <mkdir>
    280a:	cd45                	beqz	a0,28c2 <fourteen+0x128>
  unlink("123456789012345/12345678901234");
    280c:	00004517          	auipc	a0,0x4
    2810:	e9450513          	addi	a0,a0,-364 # 66a0 <malloc+0x11b8>
    2814:	027020ef          	jal	503a <unlink>
  unlink("12345678901234/12345678901234");
    2818:	00004517          	auipc	a0,0x4
    281c:	e3050513          	addi	a0,a0,-464 # 6648 <malloc+0x1160>
    2820:	01b020ef          	jal	503a <unlink>
  unlink("12345678901234/12345678901234/12345678901234");
    2824:	00004517          	auipc	a0,0x4
    2828:	db450513          	addi	a0,a0,-588 # 65d8 <malloc+0x10f0>
    282c:	00f020ef          	jal	503a <unlink>
  unlink("123456789012345/123456789012345/123456789012345");
    2830:	00004517          	auipc	a0,0x4
    2834:	d3050513          	addi	a0,a0,-720 # 6560 <malloc+0x1078>
    2838:	003020ef          	jal	503a <unlink>
  unlink("12345678901234/123456789012345");
    283c:	00004517          	auipc	a0,0x4
    2840:	ccc50513          	addi	a0,a0,-820 # 6508 <malloc+0x1020>
    2844:	7f6020ef          	jal	503a <unlink>
  unlink("12345678901234");
    2848:	00004517          	auipc	a0,0x4
    284c:	e6850513          	addi	a0,a0,-408 # 66b0 <malloc+0x11c8>
    2850:	7ea020ef          	jal	503a <unlink>
}
    2854:	60e2                	ld	ra,24(sp)
    2856:	6442                	ld	s0,16(sp)
    2858:	64a2                	ld	s1,8(sp)
    285a:	6105                	addi	sp,sp,32
    285c:	8082                	ret
    printf("%s: mkdir 12345678901234 failed\n", s);
    285e:	85a6                	mv	a1,s1
    2860:	00004517          	auipc	a0,0x4
    2864:	c8050513          	addi	a0,a0,-896 # 64e0 <malloc+0xff8>
    2868:	3c9020ef          	jal	5430 <printf>
    exit(1);
    286c:	4505                	li	a0,1
    286e:	77c020ef          	jal	4fea <exit>
    printf("%s: mkdir 12345678901234/123456789012345 failed\n", s);
    2872:	85a6                	mv	a1,s1
    2874:	00004517          	auipc	a0,0x4
    2878:	cb450513          	addi	a0,a0,-844 # 6528 <malloc+0x1040>
    287c:	3b5020ef          	jal	5430 <printf>
    exit(1);
    2880:	4505                	li	a0,1
    2882:	768020ef          	jal	4fea <exit>
    printf("%s: create 123456789012345/123456789012345/123456789012345 failed\n", s);
    2886:	85a6                	mv	a1,s1
    2888:	00004517          	auipc	a0,0x4
    288c:	d0850513          	addi	a0,a0,-760 # 6590 <malloc+0x10a8>
    2890:	3a1020ef          	jal	5430 <printf>
    exit(1);
    2894:	4505                	li	a0,1
    2896:	754020ef          	jal	4fea <exit>
    printf("%s: open 12345678901234/12345678901234/12345678901234 failed\n", s);
    289a:	85a6                	mv	a1,s1
    289c:	00004517          	auipc	a0,0x4
    28a0:	d6c50513          	addi	a0,a0,-660 # 6608 <malloc+0x1120>
    28a4:	38d020ef          	jal	5430 <printf>
    exit(1);
    28a8:	4505                	li	a0,1
    28aa:	740020ef          	jal	4fea <exit>
    printf("%s: mkdir 12345678901234/12345678901234 succeeded!\n", s);
    28ae:	85a6                	mv	a1,s1
    28b0:	00004517          	auipc	a0,0x4
    28b4:	db850513          	addi	a0,a0,-584 # 6668 <malloc+0x1180>
    28b8:	379020ef          	jal	5430 <printf>
    exit(1);
    28bc:	4505                	li	a0,1
    28be:	72c020ef          	jal	4fea <exit>
    printf("%s: mkdir 12345678901234/123456789012345 succeeded!\n", s);
    28c2:	85a6                	mv	a1,s1
    28c4:	00004517          	auipc	a0,0x4
    28c8:	dfc50513          	addi	a0,a0,-516 # 66c0 <malloc+0x11d8>
    28cc:	365020ef          	jal	5430 <printf>
    exit(1);
    28d0:	4505                	li	a0,1
    28d2:	718020ef          	jal	4fea <exit>

00000000000028d6 <diskfull>:
{
    28d6:	b6010113          	addi	sp,sp,-1184
    28da:	48113c23          	sd	ra,1176(sp)
    28de:	48813823          	sd	s0,1168(sp)
    28e2:	48913423          	sd	s1,1160(sp)
    28e6:	49213023          	sd	s2,1152(sp)
    28ea:	47313c23          	sd	s3,1144(sp)
    28ee:	47413823          	sd	s4,1136(sp)
    28f2:	47513423          	sd	s5,1128(sp)
    28f6:	47613023          	sd	s6,1120(sp)
    28fa:	45713c23          	sd	s7,1112(sp)
    28fe:	45813823          	sd	s8,1104(sp)
    2902:	45913423          	sd	s9,1096(sp)
    2906:	45a13023          	sd	s10,1088(sp)
    290a:	43b13c23          	sd	s11,1080(sp)
    290e:	4a010413          	addi	s0,sp,1184
    2912:	b6a43423          	sd	a0,-1176(s0)
  unlink("diskfulldir");
    2916:	00004517          	auipc	a0,0x4
    291a:	de250513          	addi	a0,a0,-542 # 66f8 <malloc+0x1210>
    291e:	71c020ef          	jal	503a <unlink>
    2922:	03000a93          	li	s5,48
    name[0] = 'b';
    2926:	06200d13          	li	s10,98
    name[1] = 'i';
    292a:	06900c93          	li	s9,105
    name[2] = 'g';
    292e:	06700c13          	li	s8,103
    unlink(name);
    2932:	b7040b13          	addi	s6,s0,-1168
    int fd = open(name, O_CREATE|O_RDWR|O_TRUNC);
    2936:	60200b93          	li	s7,1538
    293a:	10c00d93          	li	s11,268
      if(write(fd, buf, BSIZE) != BSIZE){
    293e:	b9040a13          	addi	s4,s0,-1136
    2942:	aa8d                	j	2ab4 <diskfull+0x1de>
      printf("%s: could not create file %s\n", s, name);
    2944:	b7040613          	addi	a2,s0,-1168
    2948:	b6843583          	ld	a1,-1176(s0)
    294c:	00004517          	auipc	a0,0x4
    2950:	dbc50513          	addi	a0,a0,-580 # 6708 <malloc+0x1220>
    2954:	2dd020ef          	jal	5430 <printf>
      break;
    2958:	a039                	j	2966 <diskfull+0x90>
        close(fd);
    295a:	854e                	mv	a0,s3
    295c:	6b6020ef          	jal	5012 <close>
    close(fd);
    2960:	854e                	mv	a0,s3
    2962:	6b0020ef          	jal	5012 <close>
  for(int i = 0; i < nzz; i++){
    2966:	4481                	li	s1,0
    name[0] = 'z';
    2968:	07a00993          	li	s3,122
    unlink(name);
    296c:	b9040913          	addi	s2,s0,-1136
    int fd = open(name, O_CREATE|O_RDWR|O_TRUNC);
    2970:	60200a13          	li	s4,1538
  for(int i = 0; i < nzz; i++){
    2974:	08000a93          	li	s5,128
    name[0] = 'z';
    2978:	b9340823          	sb	s3,-1136(s0)
    name[1] = 'z';
    297c:	b93408a3          	sb	s3,-1135(s0)
    name[2] = '0' + (i / 32);
    2980:	41f4d71b          	sraiw	a4,s1,0x1f
    2984:	01b7571b          	srliw	a4,a4,0x1b
    2988:	009707bb          	addw	a5,a4,s1
    298c:	4057d69b          	sraiw	a3,a5,0x5
    2990:	0306869b          	addiw	a3,a3,48
    2994:	b8d40923          	sb	a3,-1134(s0)
    name[3] = '0' + (i % 32);
    2998:	8bfd                	andi	a5,a5,31
    299a:	9f99                	subw	a5,a5,a4
    299c:	0307879b          	addiw	a5,a5,48
    29a0:	b8f409a3          	sb	a5,-1133(s0)
    name[4] = '\0';
    29a4:	b8040a23          	sb	zero,-1132(s0)
    unlink(name);
    29a8:	854a                	mv	a0,s2
    29aa:	690020ef          	jal	503a <unlink>
    int fd = open(name, O_CREATE|O_RDWR|O_TRUNC);
    29ae:	85d2                	mv	a1,s4
    29b0:	854a                	mv	a0,s2
    29b2:	678020ef          	jal	502a <open>
    if(fd < 0)
    29b6:	00054763          	bltz	a0,29c4 <diskfull+0xee>
    close(fd);
    29ba:	658020ef          	jal	5012 <close>
  for(int i = 0; i < nzz; i++){
    29be:	2485                	addiw	s1,s1,1
    29c0:	fb549ce3          	bne	s1,s5,2978 <diskfull+0xa2>
  if(mkdir("diskfulldir") == 0)
    29c4:	00004517          	auipc	a0,0x4
    29c8:	d3450513          	addi	a0,a0,-716 # 66f8 <malloc+0x1210>
    29cc:	686020ef          	jal	5052 <mkdir>
    29d0:	12050363          	beqz	a0,2af6 <diskfull+0x220>
  unlink("diskfulldir");
    29d4:	00004517          	auipc	a0,0x4
    29d8:	d2450513          	addi	a0,a0,-732 # 66f8 <malloc+0x1210>
    29dc:	65e020ef          	jal	503a <unlink>
  for(int i = 0; i < nzz; i++){
    29e0:	4481                	li	s1,0
    name[0] = 'z';
    29e2:	07a00913          	li	s2,122
    unlink(name);
    29e6:	b9040a13          	addi	s4,s0,-1136
  for(int i = 0; i < nzz; i++){
    29ea:	08000993          	li	s3,128
    name[0] = 'z';
    29ee:	b9240823          	sb	s2,-1136(s0)
    name[1] = 'z';
    29f2:	b92408a3          	sb	s2,-1135(s0)
    name[2] = '0' + (i / 32);
    29f6:	41f4d71b          	sraiw	a4,s1,0x1f
    29fa:	01b7571b          	srliw	a4,a4,0x1b
    29fe:	009707bb          	addw	a5,a4,s1
    2a02:	4057d69b          	sraiw	a3,a5,0x5
    2a06:	0306869b          	addiw	a3,a3,48
    2a0a:	b8d40923          	sb	a3,-1134(s0)
    name[3] = '0' + (i % 32);
    2a0e:	8bfd                	andi	a5,a5,31
    2a10:	9f99                	subw	a5,a5,a4
    2a12:	0307879b          	addiw	a5,a5,48
    2a16:	b8f409a3          	sb	a5,-1133(s0)
    name[4] = '\0';
    2a1a:	b8040a23          	sb	zero,-1132(s0)
    unlink(name);
    2a1e:	8552                	mv	a0,s4
    2a20:	61a020ef          	jal	503a <unlink>
  for(int i = 0; i < nzz; i++){
    2a24:	2485                	addiw	s1,s1,1
    2a26:	fd3494e3          	bne	s1,s3,29ee <diskfull+0x118>
    2a2a:	03000493          	li	s1,48
    name[0] = 'b';
    2a2e:	06200b13          	li	s6,98
    name[1] = 'i';
    2a32:	06900a93          	li	s5,105
    name[2] = 'g';
    2a36:	06700a13          	li	s4,103
    unlink(name);
    2a3a:	b9040993          	addi	s3,s0,-1136
  for(int i = 0; '0' + i < 0177; i++){
    2a3e:	07f00913          	li	s2,127
    name[0] = 'b';
    2a42:	b9640823          	sb	s6,-1136(s0)
    name[1] = 'i';
    2a46:	b95408a3          	sb	s5,-1135(s0)
    name[2] = 'g';
    2a4a:	b9440923          	sb	s4,-1134(s0)
    name[3] = '0' + i;
    2a4e:	b89409a3          	sb	s1,-1133(s0)
    name[4] = '\0';
    2a52:	b8040a23          	sb	zero,-1132(s0)
    unlink(name);
    2a56:	854e                	mv	a0,s3
    2a58:	5e2020ef          	jal	503a <unlink>
  for(int i = 0; '0' + i < 0177; i++){
    2a5c:	2485                	addiw	s1,s1,1
    2a5e:	0ff4f493          	zext.b	s1,s1
    2a62:	ff2490e3          	bne	s1,s2,2a42 <diskfull+0x16c>
}
    2a66:	49813083          	ld	ra,1176(sp)
    2a6a:	49013403          	ld	s0,1168(sp)
    2a6e:	48813483          	ld	s1,1160(sp)
    2a72:	48013903          	ld	s2,1152(sp)
    2a76:	47813983          	ld	s3,1144(sp)
    2a7a:	47013a03          	ld	s4,1136(sp)
    2a7e:	46813a83          	ld	s5,1128(sp)
    2a82:	46013b03          	ld	s6,1120(sp)
    2a86:	45813b83          	ld	s7,1112(sp)
    2a8a:	45013c03          	ld	s8,1104(sp)
    2a8e:	44813c83          	ld	s9,1096(sp)
    2a92:	44013d03          	ld	s10,1088(sp)
    2a96:	43813d83          	ld	s11,1080(sp)
    2a9a:	4a010113          	addi	sp,sp,1184
    2a9e:	8082                	ret
    close(fd);
    2aa0:	854e                	mv	a0,s3
    2aa2:	570020ef          	jal	5012 <close>
  for(fi = 0; done == 0 && '0' + fi < 0177; fi++){
    2aa6:	2a85                	addiw	s5,s5,1 # 3001 <subdir+0x301>
    2aa8:	0ffafa93          	zext.b	s5,s5
    2aac:	07f00793          	li	a5,127
    2ab0:	eafa8be3          	beq	s5,a5,2966 <diskfull+0x90>
    name[0] = 'b';
    2ab4:	b7a40823          	sb	s10,-1168(s0)
    name[1] = 'i';
    2ab8:	b79408a3          	sb	s9,-1167(s0)
    name[2] = 'g';
    2abc:	b7840923          	sb	s8,-1166(s0)
    name[3] = '0' + fi;
    2ac0:	b75409a3          	sb	s5,-1165(s0)
    name[4] = '\0';
    2ac4:	b6040a23          	sb	zero,-1164(s0)
    unlink(name);
    2ac8:	855a                	mv	a0,s6
    2aca:	570020ef          	jal	503a <unlink>
    int fd = open(name, O_CREATE|O_RDWR|O_TRUNC);
    2ace:	85de                	mv	a1,s7
    2ad0:	855a                	mv	a0,s6
    2ad2:	558020ef          	jal	502a <open>
    2ad6:	89aa                	mv	s3,a0
    if(fd < 0){
    2ad8:	e60546e3          	bltz	a0,2944 <diskfull+0x6e>
    2adc:	84ee                	mv	s1,s11
      if(write(fd, buf, BSIZE) != BSIZE){
    2ade:	40000913          	li	s2,1024
    2ae2:	864a                	mv	a2,s2
    2ae4:	85d2                	mv	a1,s4
    2ae6:	854e                	mv	a0,s3
    2ae8:	522020ef          	jal	500a <write>
    2aec:	e72517e3          	bne	a0,s2,295a <diskfull+0x84>
    for(int i = 0; i < MAXFILE; i++){
    2af0:	34fd                	addiw	s1,s1,-1
    2af2:	f8e5                	bnez	s1,2ae2 <diskfull+0x20c>
    2af4:	b775                	j	2aa0 <diskfull+0x1ca>
    printf("%s: mkdir(diskfulldir) unexpectedly succeeded!\n", s);
    2af6:	b6843583          	ld	a1,-1176(s0)
    2afa:	00004517          	auipc	a0,0x4
    2afe:	c2e50513          	addi	a0,a0,-978 # 6728 <malloc+0x1240>
    2b02:	12f020ef          	jal	5430 <printf>
    2b06:	b5f9                	j	29d4 <diskfull+0xfe>

0000000000002b08 <iputtest>:
{
    2b08:	1101                	addi	sp,sp,-32
    2b0a:	ec06                	sd	ra,24(sp)
    2b0c:	e822                	sd	s0,16(sp)
    2b0e:	e426                	sd	s1,8(sp)
    2b10:	1000                	addi	s0,sp,32
    2b12:	84aa                	mv	s1,a0
  if(mkdir("iputdir") < 0){
    2b14:	00004517          	auipc	a0,0x4
    2b18:	c4450513          	addi	a0,a0,-956 # 6758 <malloc+0x1270>
    2b1c:	536020ef          	jal	5052 <mkdir>
    2b20:	02054f63          	bltz	a0,2b5e <iputtest+0x56>
  if(chdir("iputdir") < 0){
    2b24:	00004517          	auipc	a0,0x4
    2b28:	c3450513          	addi	a0,a0,-972 # 6758 <malloc+0x1270>
    2b2c:	52e020ef          	jal	505a <chdir>
    2b30:	04054163          	bltz	a0,2b72 <iputtest+0x6a>
  if(unlink("../iputdir") < 0){
    2b34:	00004517          	auipc	a0,0x4
    2b38:	c6450513          	addi	a0,a0,-924 # 6798 <malloc+0x12b0>
    2b3c:	4fe020ef          	jal	503a <unlink>
    2b40:	04054363          	bltz	a0,2b86 <iputtest+0x7e>
  if(chdir("/") < 0){
    2b44:	00004517          	auipc	a0,0x4
    2b48:	c8450513          	addi	a0,a0,-892 # 67c8 <malloc+0x12e0>
    2b4c:	50e020ef          	jal	505a <chdir>
    2b50:	04054563          	bltz	a0,2b9a <iputtest+0x92>
}
    2b54:	60e2                	ld	ra,24(sp)
    2b56:	6442                	ld	s0,16(sp)
    2b58:	64a2                	ld	s1,8(sp)
    2b5a:	6105                	addi	sp,sp,32
    2b5c:	8082                	ret
    printf("%s: mkdir failed\n", s);
    2b5e:	85a6                	mv	a1,s1
    2b60:	00004517          	auipc	a0,0x4
    2b64:	c0050513          	addi	a0,a0,-1024 # 6760 <malloc+0x1278>
    2b68:	0c9020ef          	jal	5430 <printf>
    exit(1);
    2b6c:	4505                	li	a0,1
    2b6e:	47c020ef          	jal	4fea <exit>
    printf("%s: chdir iputdir failed\n", s);
    2b72:	85a6                	mv	a1,s1
    2b74:	00004517          	auipc	a0,0x4
    2b78:	c0450513          	addi	a0,a0,-1020 # 6778 <malloc+0x1290>
    2b7c:	0b5020ef          	jal	5430 <printf>
    exit(1);
    2b80:	4505                	li	a0,1
    2b82:	468020ef          	jal	4fea <exit>
    printf("%s: unlink ../iputdir failed\n", s);
    2b86:	85a6                	mv	a1,s1
    2b88:	00004517          	auipc	a0,0x4
    2b8c:	c2050513          	addi	a0,a0,-992 # 67a8 <malloc+0x12c0>
    2b90:	0a1020ef          	jal	5430 <printf>
    exit(1);
    2b94:	4505                	li	a0,1
    2b96:	454020ef          	jal	4fea <exit>
    printf("%s: chdir / failed\n", s);
    2b9a:	85a6                	mv	a1,s1
    2b9c:	00004517          	auipc	a0,0x4
    2ba0:	c3450513          	addi	a0,a0,-972 # 67d0 <malloc+0x12e8>
    2ba4:	08d020ef          	jal	5430 <printf>
    exit(1);
    2ba8:	4505                	li	a0,1
    2baa:	440020ef          	jal	4fea <exit>

0000000000002bae <exitiputtest>:
{
    2bae:	7179                	addi	sp,sp,-48
    2bb0:	f406                	sd	ra,40(sp)
    2bb2:	f022                	sd	s0,32(sp)
    2bb4:	ec26                	sd	s1,24(sp)
    2bb6:	1800                	addi	s0,sp,48
    2bb8:	84aa                	mv	s1,a0
  pid = fork();
    2bba:	428020ef          	jal	4fe2 <fork>
  if(pid < 0){
    2bbe:	02054e63          	bltz	a0,2bfa <exitiputtest+0x4c>
  if(pid == 0){
    2bc2:	e541                	bnez	a0,2c4a <exitiputtest+0x9c>
    if(mkdir("iputdir") < 0){
    2bc4:	00004517          	auipc	a0,0x4
    2bc8:	b9450513          	addi	a0,a0,-1132 # 6758 <malloc+0x1270>
    2bcc:	486020ef          	jal	5052 <mkdir>
    2bd0:	02054f63          	bltz	a0,2c0e <exitiputtest+0x60>
    if(chdir("iputdir") < 0){
    2bd4:	00004517          	auipc	a0,0x4
    2bd8:	b8450513          	addi	a0,a0,-1148 # 6758 <malloc+0x1270>
    2bdc:	47e020ef          	jal	505a <chdir>
    2be0:	04054163          	bltz	a0,2c22 <exitiputtest+0x74>
    if(unlink("../iputdir") < 0){
    2be4:	00004517          	auipc	a0,0x4
    2be8:	bb450513          	addi	a0,a0,-1100 # 6798 <malloc+0x12b0>
    2bec:	44e020ef          	jal	503a <unlink>
    2bf0:	04054363          	bltz	a0,2c36 <exitiputtest+0x88>
    exit(0);
    2bf4:	4501                	li	a0,0
    2bf6:	3f4020ef          	jal	4fea <exit>
    printf("%s: fork failed\n", s);
    2bfa:	85a6                	mv	a1,s1
    2bfc:	00003517          	auipc	a0,0x3
    2c00:	2ac50513          	addi	a0,a0,684 # 5ea8 <malloc+0x9c0>
    2c04:	02d020ef          	jal	5430 <printf>
    exit(1);
    2c08:	4505                	li	a0,1
    2c0a:	3e0020ef          	jal	4fea <exit>
      printf("%s: mkdir failed\n", s);
    2c0e:	85a6                	mv	a1,s1
    2c10:	00004517          	auipc	a0,0x4
    2c14:	b5050513          	addi	a0,a0,-1200 # 6760 <malloc+0x1278>
    2c18:	019020ef          	jal	5430 <printf>
      exit(1);
    2c1c:	4505                	li	a0,1
    2c1e:	3cc020ef          	jal	4fea <exit>
      printf("%s: child chdir failed\n", s);
    2c22:	85a6                	mv	a1,s1
    2c24:	00004517          	auipc	a0,0x4
    2c28:	bc450513          	addi	a0,a0,-1084 # 67e8 <malloc+0x1300>
    2c2c:	005020ef          	jal	5430 <printf>
      exit(1);
    2c30:	4505                	li	a0,1
    2c32:	3b8020ef          	jal	4fea <exit>
      printf("%s: unlink ../iputdir failed\n", s);
    2c36:	85a6                	mv	a1,s1
    2c38:	00004517          	auipc	a0,0x4
    2c3c:	b7050513          	addi	a0,a0,-1168 # 67a8 <malloc+0x12c0>
    2c40:	7f0020ef          	jal	5430 <printf>
      exit(1);
    2c44:	4505                	li	a0,1
    2c46:	3a4020ef          	jal	4fea <exit>
  wait(&xstatus);
    2c4a:	fdc40513          	addi	a0,s0,-36
    2c4e:	3a4020ef          	jal	4ff2 <wait>
  exit(xstatus);
    2c52:	fdc42503          	lw	a0,-36(s0)
    2c56:	394020ef          	jal	4fea <exit>

0000000000002c5a <dirtest>:
{
    2c5a:	1101                	addi	sp,sp,-32
    2c5c:	ec06                	sd	ra,24(sp)
    2c5e:	e822                	sd	s0,16(sp)
    2c60:	e426                	sd	s1,8(sp)
    2c62:	1000                	addi	s0,sp,32
    2c64:	84aa                	mv	s1,a0
  if(mkdir("dir0") < 0){
    2c66:	00004517          	auipc	a0,0x4
    2c6a:	b9a50513          	addi	a0,a0,-1126 # 6800 <malloc+0x1318>
    2c6e:	3e4020ef          	jal	5052 <mkdir>
    2c72:	02054f63          	bltz	a0,2cb0 <dirtest+0x56>
  if(chdir("dir0") < 0){
    2c76:	00004517          	auipc	a0,0x4
    2c7a:	b8a50513          	addi	a0,a0,-1142 # 6800 <malloc+0x1318>
    2c7e:	3dc020ef          	jal	505a <chdir>
    2c82:	04054163          	bltz	a0,2cc4 <dirtest+0x6a>
  if(chdir("..") < 0){
    2c86:	00004517          	auipc	a0,0x4
    2c8a:	b9a50513          	addi	a0,a0,-1126 # 6820 <malloc+0x1338>
    2c8e:	3cc020ef          	jal	505a <chdir>
    2c92:	04054363          	bltz	a0,2cd8 <dirtest+0x7e>
  if(unlink("dir0") < 0){
    2c96:	00004517          	auipc	a0,0x4
    2c9a:	b6a50513          	addi	a0,a0,-1174 # 6800 <malloc+0x1318>
    2c9e:	39c020ef          	jal	503a <unlink>
    2ca2:	04054563          	bltz	a0,2cec <dirtest+0x92>
}
    2ca6:	60e2                	ld	ra,24(sp)
    2ca8:	6442                	ld	s0,16(sp)
    2caa:	64a2                	ld	s1,8(sp)
    2cac:	6105                	addi	sp,sp,32
    2cae:	8082                	ret
    printf("%s: mkdir failed\n", s);
    2cb0:	85a6                	mv	a1,s1
    2cb2:	00004517          	auipc	a0,0x4
    2cb6:	aae50513          	addi	a0,a0,-1362 # 6760 <malloc+0x1278>
    2cba:	776020ef          	jal	5430 <printf>
    exit(1);
    2cbe:	4505                	li	a0,1
    2cc0:	32a020ef          	jal	4fea <exit>
    printf("%s: chdir dir0 failed\n", s);
    2cc4:	85a6                	mv	a1,s1
    2cc6:	00004517          	auipc	a0,0x4
    2cca:	b4250513          	addi	a0,a0,-1214 # 6808 <malloc+0x1320>
    2cce:	762020ef          	jal	5430 <printf>
    exit(1);
    2cd2:	4505                	li	a0,1
    2cd4:	316020ef          	jal	4fea <exit>
    printf("%s: chdir .. failed\n", s);
    2cd8:	85a6                	mv	a1,s1
    2cda:	00004517          	auipc	a0,0x4
    2cde:	b4e50513          	addi	a0,a0,-1202 # 6828 <malloc+0x1340>
    2ce2:	74e020ef          	jal	5430 <printf>
    exit(1);
    2ce6:	4505                	li	a0,1
    2ce8:	302020ef          	jal	4fea <exit>
    printf("%s: unlink dir0 failed\n", s);
    2cec:	85a6                	mv	a1,s1
    2cee:	00004517          	auipc	a0,0x4
    2cf2:	b5250513          	addi	a0,a0,-1198 # 6840 <malloc+0x1358>
    2cf6:	73a020ef          	jal	5430 <printf>
    exit(1);
    2cfa:	4505                	li	a0,1
    2cfc:	2ee020ef          	jal	4fea <exit>

0000000000002d00 <subdir>:
{
    2d00:	1101                	addi	sp,sp,-32
    2d02:	ec06                	sd	ra,24(sp)
    2d04:	e822                	sd	s0,16(sp)
    2d06:	e426                	sd	s1,8(sp)
    2d08:	e04a                	sd	s2,0(sp)
    2d0a:	1000                	addi	s0,sp,32
    2d0c:	892a                	mv	s2,a0
  unlink("ff");
    2d0e:	00004517          	auipc	a0,0x4
    2d12:	c7a50513          	addi	a0,a0,-902 # 6988 <malloc+0x14a0>
    2d16:	324020ef          	jal	503a <unlink>
  if(mkdir("dd") != 0){
    2d1a:	00004517          	auipc	a0,0x4
    2d1e:	b3e50513          	addi	a0,a0,-1218 # 6858 <malloc+0x1370>
    2d22:	330020ef          	jal	5052 <mkdir>
    2d26:	2e051263          	bnez	a0,300a <subdir+0x30a>
  fd = open("dd/ff", O_CREATE | O_RDWR);
    2d2a:	20200593          	li	a1,514
    2d2e:	00004517          	auipc	a0,0x4
    2d32:	b4a50513          	addi	a0,a0,-1206 # 6878 <malloc+0x1390>
    2d36:	2f4020ef          	jal	502a <open>
    2d3a:	84aa                	mv	s1,a0
  if(fd < 0){
    2d3c:	2e054163          	bltz	a0,301e <subdir+0x31e>
  write(fd, "ff", 2);
    2d40:	4609                	li	a2,2
    2d42:	00004597          	auipc	a1,0x4
    2d46:	c4658593          	addi	a1,a1,-954 # 6988 <malloc+0x14a0>
    2d4a:	2c0020ef          	jal	500a <write>
  close(fd);
    2d4e:	8526                	mv	a0,s1
    2d50:	2c2020ef          	jal	5012 <close>
  if(unlink("dd") >= 0){
    2d54:	00004517          	auipc	a0,0x4
    2d58:	b0450513          	addi	a0,a0,-1276 # 6858 <malloc+0x1370>
    2d5c:	2de020ef          	jal	503a <unlink>
    2d60:	2c055963          	bgez	a0,3032 <subdir+0x332>
  if(mkdir("/dd/dd") != 0){
    2d64:	00004517          	auipc	a0,0x4
    2d68:	b6c50513          	addi	a0,a0,-1172 # 68d0 <malloc+0x13e8>
    2d6c:	2e6020ef          	jal	5052 <mkdir>
    2d70:	2c051b63          	bnez	a0,3046 <subdir+0x346>
  fd = open("dd/dd/ff", O_CREATE | O_RDWR);
    2d74:	20200593          	li	a1,514
    2d78:	00004517          	auipc	a0,0x4
    2d7c:	b8050513          	addi	a0,a0,-1152 # 68f8 <malloc+0x1410>
    2d80:	2aa020ef          	jal	502a <open>
    2d84:	84aa                	mv	s1,a0
  if(fd < 0){
    2d86:	2c054a63          	bltz	a0,305a <subdir+0x35a>
  write(fd, "FF", 2);
    2d8a:	4609                	li	a2,2
    2d8c:	00004597          	auipc	a1,0x4
    2d90:	b9c58593          	addi	a1,a1,-1124 # 6928 <malloc+0x1440>
    2d94:	276020ef          	jal	500a <write>
  close(fd);
    2d98:	8526                	mv	a0,s1
    2d9a:	278020ef          	jal	5012 <close>
  fd = open("dd/dd/../ff", 0);
    2d9e:	4581                	li	a1,0
    2da0:	00004517          	auipc	a0,0x4
    2da4:	b9050513          	addi	a0,a0,-1136 # 6930 <malloc+0x1448>
    2da8:	282020ef          	jal	502a <open>
    2dac:	84aa                	mv	s1,a0
  if(fd < 0){
    2dae:	2c054063          	bltz	a0,306e <subdir+0x36e>
  cc = read(fd, buf, sizeof(buf));
    2db2:	660d                	lui	a2,0x3
    2db4:	0000b597          	auipc	a1,0xb
    2db8:	f0458593          	addi	a1,a1,-252 # dcb8 <buf>
    2dbc:	246020ef          	jal	5002 <read>
  if(cc != 2 || buf[0] != 'f'){
    2dc0:	4789                	li	a5,2
    2dc2:	2cf51063          	bne	a0,a5,3082 <subdir+0x382>
    2dc6:	0000b717          	auipc	a4,0xb
    2dca:	ef274703          	lbu	a4,-270(a4) # dcb8 <buf>
    2dce:	06600793          	li	a5,102
    2dd2:	2af71863          	bne	a4,a5,3082 <subdir+0x382>
  close(fd);
    2dd6:	8526                	mv	a0,s1
    2dd8:	23a020ef          	jal	5012 <close>
  if(link("dd/dd/ff", "dd/dd/ffff") != 0){
    2ddc:	00004597          	auipc	a1,0x4
    2de0:	ba458593          	addi	a1,a1,-1116 # 6980 <malloc+0x1498>
    2de4:	00004517          	auipc	a0,0x4
    2de8:	b1450513          	addi	a0,a0,-1260 # 68f8 <malloc+0x1410>
    2dec:	25e020ef          	jal	504a <link>
    2df0:	2a051363          	bnez	a0,3096 <subdir+0x396>
  if(unlink("dd/dd/ff") != 0){
    2df4:	00004517          	auipc	a0,0x4
    2df8:	b0450513          	addi	a0,a0,-1276 # 68f8 <malloc+0x1410>
    2dfc:	23e020ef          	jal	503a <unlink>
    2e00:	2a051563          	bnez	a0,30aa <subdir+0x3aa>
  if(open("dd/dd/ff", O_RDONLY) >= 0){
    2e04:	4581                	li	a1,0
    2e06:	00004517          	auipc	a0,0x4
    2e0a:	af250513          	addi	a0,a0,-1294 # 68f8 <malloc+0x1410>
    2e0e:	21c020ef          	jal	502a <open>
    2e12:	2a055663          	bgez	a0,30be <subdir+0x3be>
  if(chdir("dd") != 0){
    2e16:	00004517          	auipc	a0,0x4
    2e1a:	a4250513          	addi	a0,a0,-1470 # 6858 <malloc+0x1370>
    2e1e:	23c020ef          	jal	505a <chdir>
    2e22:	2a051863          	bnez	a0,30d2 <subdir+0x3d2>
  if(chdir("dd/../../dd") != 0){
    2e26:	00004517          	auipc	a0,0x4
    2e2a:	bf250513          	addi	a0,a0,-1038 # 6a18 <malloc+0x1530>
    2e2e:	22c020ef          	jal	505a <chdir>
    2e32:	2a051a63          	bnez	a0,30e6 <subdir+0x3e6>
  if(chdir("dd/../../../dd") != 0){
    2e36:	00004517          	auipc	a0,0x4
    2e3a:	c1250513          	addi	a0,a0,-1006 # 6a48 <malloc+0x1560>
    2e3e:	21c020ef          	jal	505a <chdir>
    2e42:	2a051c63          	bnez	a0,30fa <subdir+0x3fa>
  if(chdir("./..") != 0){
    2e46:	00004517          	auipc	a0,0x4
    2e4a:	c3a50513          	addi	a0,a0,-966 # 6a80 <malloc+0x1598>
    2e4e:	20c020ef          	jal	505a <chdir>
    2e52:	2a051e63          	bnez	a0,310e <subdir+0x40e>
  fd = open("dd/dd/ffff", 0);
    2e56:	4581                	li	a1,0
    2e58:	00004517          	auipc	a0,0x4
    2e5c:	b2850513          	addi	a0,a0,-1240 # 6980 <malloc+0x1498>
    2e60:	1ca020ef          	jal	502a <open>
    2e64:	84aa                	mv	s1,a0
  if(fd < 0){
    2e66:	2a054e63          	bltz	a0,3122 <subdir+0x422>
  if(read(fd, buf, sizeof(buf)) != 2){
    2e6a:	660d                	lui	a2,0x3
    2e6c:	0000b597          	auipc	a1,0xb
    2e70:	e4c58593          	addi	a1,a1,-436 # dcb8 <buf>
    2e74:	18e020ef          	jal	5002 <read>
    2e78:	4789                	li	a5,2
    2e7a:	2af51e63          	bne	a0,a5,3136 <subdir+0x436>
  close(fd);
    2e7e:	8526                	mv	a0,s1
    2e80:	192020ef          	jal	5012 <close>
  if(open("dd/dd/ff", O_RDONLY) >= 0){
    2e84:	4581                	li	a1,0
    2e86:	00004517          	auipc	a0,0x4
    2e8a:	a7250513          	addi	a0,a0,-1422 # 68f8 <malloc+0x1410>
    2e8e:	19c020ef          	jal	502a <open>
    2e92:	2a055c63          	bgez	a0,314a <subdir+0x44a>
  if(open("dd/ff/ff", O_CREATE|O_RDWR) >= 0){
    2e96:	20200593          	li	a1,514
    2e9a:	00004517          	auipc	a0,0x4
    2e9e:	c7650513          	addi	a0,a0,-906 # 6b10 <malloc+0x1628>
    2ea2:	188020ef          	jal	502a <open>
    2ea6:	2a055c63          	bgez	a0,315e <subdir+0x45e>
  if(open("dd/xx/ff", O_CREATE|O_RDWR) >= 0){
    2eaa:	20200593          	li	a1,514
    2eae:	00004517          	auipc	a0,0x4
    2eb2:	c9250513          	addi	a0,a0,-878 # 6b40 <malloc+0x1658>
    2eb6:	174020ef          	jal	502a <open>
    2eba:	2a055c63          	bgez	a0,3172 <subdir+0x472>
  if(open("dd", O_CREATE) >= 0){
    2ebe:	20000593          	li	a1,512
    2ec2:	00004517          	auipc	a0,0x4
    2ec6:	99650513          	addi	a0,a0,-1642 # 6858 <malloc+0x1370>
    2eca:	160020ef          	jal	502a <open>
    2ece:	2a055c63          	bgez	a0,3186 <subdir+0x486>
  if(open("dd", O_RDWR) >= 0){
    2ed2:	4589                	li	a1,2
    2ed4:	00004517          	auipc	a0,0x4
    2ed8:	98450513          	addi	a0,a0,-1660 # 6858 <malloc+0x1370>
    2edc:	14e020ef          	jal	502a <open>
    2ee0:	2a055d63          	bgez	a0,319a <subdir+0x49a>
  if(open("dd", O_WRONLY) >= 0){
    2ee4:	4585                	li	a1,1
    2ee6:	00004517          	auipc	a0,0x4
    2eea:	97250513          	addi	a0,a0,-1678 # 6858 <malloc+0x1370>
    2eee:	13c020ef          	jal	502a <open>
    2ef2:	2a055e63          	bgez	a0,31ae <subdir+0x4ae>
  if(link("dd/ff/ff", "dd/dd/xx") == 0){
    2ef6:	00004597          	auipc	a1,0x4
    2efa:	cda58593          	addi	a1,a1,-806 # 6bd0 <malloc+0x16e8>
    2efe:	00004517          	auipc	a0,0x4
    2f02:	c1250513          	addi	a0,a0,-1006 # 6b10 <malloc+0x1628>
    2f06:	144020ef          	jal	504a <link>
    2f0a:	2a050c63          	beqz	a0,31c2 <subdir+0x4c2>
  if(link("dd/xx/ff", "dd/dd/xx") == 0){
    2f0e:	00004597          	auipc	a1,0x4
    2f12:	cc258593          	addi	a1,a1,-830 # 6bd0 <malloc+0x16e8>
    2f16:	00004517          	auipc	a0,0x4
    2f1a:	c2a50513          	addi	a0,a0,-982 # 6b40 <malloc+0x1658>
    2f1e:	12c020ef          	jal	504a <link>
    2f22:	2a050a63          	beqz	a0,31d6 <subdir+0x4d6>
  if(link("dd/ff", "dd/dd/ffff") == 0){
    2f26:	00004597          	auipc	a1,0x4
    2f2a:	a5a58593          	addi	a1,a1,-1446 # 6980 <malloc+0x1498>
    2f2e:	00004517          	auipc	a0,0x4
    2f32:	94a50513          	addi	a0,a0,-1718 # 6878 <malloc+0x1390>
    2f36:	114020ef          	jal	504a <link>
    2f3a:	2a050863          	beqz	a0,31ea <subdir+0x4ea>
  if(mkdir("dd/ff/ff") == 0){
    2f3e:	00004517          	auipc	a0,0x4
    2f42:	bd250513          	addi	a0,a0,-1070 # 6b10 <malloc+0x1628>
    2f46:	10c020ef          	jal	5052 <mkdir>
    2f4a:	2a050a63          	beqz	a0,31fe <subdir+0x4fe>
  if(mkdir("dd/xx/ff") == 0){
    2f4e:	00004517          	auipc	a0,0x4
    2f52:	bf250513          	addi	a0,a0,-1038 # 6b40 <malloc+0x1658>
    2f56:	0fc020ef          	jal	5052 <mkdir>
    2f5a:	2a050c63          	beqz	a0,3212 <subdir+0x512>
  if(mkdir("dd/dd/ffff") == 0){
    2f5e:	00004517          	auipc	a0,0x4
    2f62:	a2250513          	addi	a0,a0,-1502 # 6980 <malloc+0x1498>
    2f66:	0ec020ef          	jal	5052 <mkdir>
    2f6a:	2a050e63          	beqz	a0,3226 <subdir+0x526>
  if(unlink("dd/xx/ff") == 0){
    2f6e:	00004517          	auipc	a0,0x4
    2f72:	bd250513          	addi	a0,a0,-1070 # 6b40 <malloc+0x1658>
    2f76:	0c4020ef          	jal	503a <unlink>
    2f7a:	2c050063          	beqz	a0,323a <subdir+0x53a>
  if(unlink("dd/ff/ff") == 0){
    2f7e:	00004517          	auipc	a0,0x4
    2f82:	b9250513          	addi	a0,a0,-1134 # 6b10 <malloc+0x1628>
    2f86:	0b4020ef          	jal	503a <unlink>
    2f8a:	2c050263          	beqz	a0,324e <subdir+0x54e>
  if(chdir("dd/ff") == 0){
    2f8e:	00004517          	auipc	a0,0x4
    2f92:	8ea50513          	addi	a0,a0,-1814 # 6878 <malloc+0x1390>
    2f96:	0c4020ef          	jal	505a <chdir>
    2f9a:	2c050463          	beqz	a0,3262 <subdir+0x562>
  if(chdir("dd/xx") == 0){
    2f9e:	00004517          	auipc	a0,0x4
    2fa2:	d8250513          	addi	a0,a0,-638 # 6d20 <malloc+0x1838>
    2fa6:	0b4020ef          	jal	505a <chdir>
    2faa:	2c050663          	beqz	a0,3276 <subdir+0x576>
  if(unlink("dd/dd/ffff") != 0){
    2fae:	00004517          	auipc	a0,0x4
    2fb2:	9d250513          	addi	a0,a0,-1582 # 6980 <malloc+0x1498>
    2fb6:	084020ef          	jal	503a <unlink>
    2fba:	2c051863          	bnez	a0,328a <subdir+0x58a>
  if(unlink("dd/ff") != 0){
    2fbe:	00004517          	auipc	a0,0x4
    2fc2:	8ba50513          	addi	a0,a0,-1862 # 6878 <malloc+0x1390>
    2fc6:	074020ef          	jal	503a <unlink>
    2fca:	2c051a63          	bnez	a0,329e <subdir+0x59e>
  if(unlink("dd") == 0){
    2fce:	00004517          	auipc	a0,0x4
    2fd2:	88a50513          	addi	a0,a0,-1910 # 6858 <malloc+0x1370>
    2fd6:	064020ef          	jal	503a <unlink>
    2fda:	2c050c63          	beqz	a0,32b2 <subdir+0x5b2>
  if(unlink("dd/dd") < 0){
    2fde:	00004517          	auipc	a0,0x4
    2fe2:	db250513          	addi	a0,a0,-590 # 6d90 <malloc+0x18a8>
    2fe6:	054020ef          	jal	503a <unlink>
    2fea:	2c054e63          	bltz	a0,32c6 <subdir+0x5c6>
  if(unlink("dd") < 0){
    2fee:	00004517          	auipc	a0,0x4
    2ff2:	86a50513          	addi	a0,a0,-1942 # 6858 <malloc+0x1370>
    2ff6:	044020ef          	jal	503a <unlink>
    2ffa:	2e054063          	bltz	a0,32da <subdir+0x5da>
}
    2ffe:	60e2                	ld	ra,24(sp)
    3000:	6442                	ld	s0,16(sp)
    3002:	64a2                	ld	s1,8(sp)
    3004:	6902                	ld	s2,0(sp)
    3006:	6105                	addi	sp,sp,32
    3008:	8082                	ret
    printf("%s: mkdir dd failed\n", s);
    300a:	85ca                	mv	a1,s2
    300c:	00004517          	auipc	a0,0x4
    3010:	85450513          	addi	a0,a0,-1964 # 6860 <malloc+0x1378>
    3014:	41c020ef          	jal	5430 <printf>
    exit(1);
    3018:	4505                	li	a0,1
    301a:	7d1010ef          	jal	4fea <exit>
    printf("%s: create dd/ff failed\n", s);
    301e:	85ca                	mv	a1,s2
    3020:	00004517          	auipc	a0,0x4
    3024:	86050513          	addi	a0,a0,-1952 # 6880 <malloc+0x1398>
    3028:	408020ef          	jal	5430 <printf>
    exit(1);
    302c:	4505                	li	a0,1
    302e:	7bd010ef          	jal	4fea <exit>
    printf("%s: unlink dd (non-empty dir) succeeded!\n", s);
    3032:	85ca                	mv	a1,s2
    3034:	00004517          	auipc	a0,0x4
    3038:	86c50513          	addi	a0,a0,-1940 # 68a0 <malloc+0x13b8>
    303c:	3f4020ef          	jal	5430 <printf>
    exit(1);
    3040:	4505                	li	a0,1
    3042:	7a9010ef          	jal	4fea <exit>
    printf("%s: subdir mkdir dd/dd failed\n", s);
    3046:	85ca                	mv	a1,s2
    3048:	00004517          	auipc	a0,0x4
    304c:	89050513          	addi	a0,a0,-1904 # 68d8 <malloc+0x13f0>
    3050:	3e0020ef          	jal	5430 <printf>
    exit(1);
    3054:	4505                	li	a0,1
    3056:	795010ef          	jal	4fea <exit>
    printf("%s: create dd/dd/ff failed\n", s);
    305a:	85ca                	mv	a1,s2
    305c:	00004517          	auipc	a0,0x4
    3060:	8ac50513          	addi	a0,a0,-1876 # 6908 <malloc+0x1420>
    3064:	3cc020ef          	jal	5430 <printf>
    exit(1);
    3068:	4505                	li	a0,1
    306a:	781010ef          	jal	4fea <exit>
    printf("%s: open dd/dd/../ff failed\n", s);
    306e:	85ca                	mv	a1,s2
    3070:	00004517          	auipc	a0,0x4
    3074:	8d050513          	addi	a0,a0,-1840 # 6940 <malloc+0x1458>
    3078:	3b8020ef          	jal	5430 <printf>
    exit(1);
    307c:	4505                	li	a0,1
    307e:	76d010ef          	jal	4fea <exit>
    printf("%s: dd/dd/../ff wrong content\n", s);
    3082:	85ca                	mv	a1,s2
    3084:	00004517          	auipc	a0,0x4
    3088:	8dc50513          	addi	a0,a0,-1828 # 6960 <malloc+0x1478>
    308c:	3a4020ef          	jal	5430 <printf>
    exit(1);
    3090:	4505                	li	a0,1
    3092:	759010ef          	jal	4fea <exit>
    printf("%s: link dd/dd/ff dd/dd/ffff failed\n", s);
    3096:	85ca                	mv	a1,s2
    3098:	00004517          	auipc	a0,0x4
    309c:	8f850513          	addi	a0,a0,-1800 # 6990 <malloc+0x14a8>
    30a0:	390020ef          	jal	5430 <printf>
    exit(1);
    30a4:	4505                	li	a0,1
    30a6:	745010ef          	jal	4fea <exit>
    printf("%s: unlink dd/dd/ff failed\n", s);
    30aa:	85ca                	mv	a1,s2
    30ac:	00004517          	auipc	a0,0x4
    30b0:	90c50513          	addi	a0,a0,-1780 # 69b8 <malloc+0x14d0>
    30b4:	37c020ef          	jal	5430 <printf>
    exit(1);
    30b8:	4505                	li	a0,1
    30ba:	731010ef          	jal	4fea <exit>
    printf("%s: open (unlinked) dd/dd/ff succeeded\n", s);
    30be:	85ca                	mv	a1,s2
    30c0:	00004517          	auipc	a0,0x4
    30c4:	91850513          	addi	a0,a0,-1768 # 69d8 <malloc+0x14f0>
    30c8:	368020ef          	jal	5430 <printf>
    exit(1);
    30cc:	4505                	li	a0,1
    30ce:	71d010ef          	jal	4fea <exit>
    printf("%s: chdir dd failed\n", s);
    30d2:	85ca                	mv	a1,s2
    30d4:	00004517          	auipc	a0,0x4
    30d8:	92c50513          	addi	a0,a0,-1748 # 6a00 <malloc+0x1518>
    30dc:	354020ef          	jal	5430 <printf>
    exit(1);
    30e0:	4505                	li	a0,1
    30e2:	709010ef          	jal	4fea <exit>
    printf("%s: chdir dd/../../dd failed\n", s);
    30e6:	85ca                	mv	a1,s2
    30e8:	00004517          	auipc	a0,0x4
    30ec:	94050513          	addi	a0,a0,-1728 # 6a28 <malloc+0x1540>
    30f0:	340020ef          	jal	5430 <printf>
    exit(1);
    30f4:	4505                	li	a0,1
    30f6:	6f5010ef          	jal	4fea <exit>
    printf("%s: chdir dd/../../../dd failed\n", s);
    30fa:	85ca                	mv	a1,s2
    30fc:	00004517          	auipc	a0,0x4
    3100:	95c50513          	addi	a0,a0,-1700 # 6a58 <malloc+0x1570>
    3104:	32c020ef          	jal	5430 <printf>
    exit(1);
    3108:	4505                	li	a0,1
    310a:	6e1010ef          	jal	4fea <exit>
    printf("%s: chdir ./.. failed\n", s);
    310e:	85ca                	mv	a1,s2
    3110:	00004517          	auipc	a0,0x4
    3114:	97850513          	addi	a0,a0,-1672 # 6a88 <malloc+0x15a0>
    3118:	318020ef          	jal	5430 <printf>
    exit(1);
    311c:	4505                	li	a0,1
    311e:	6cd010ef          	jal	4fea <exit>
    printf("%s: open dd/dd/ffff failed\n", s);
    3122:	85ca                	mv	a1,s2
    3124:	00004517          	auipc	a0,0x4
    3128:	97c50513          	addi	a0,a0,-1668 # 6aa0 <malloc+0x15b8>
    312c:	304020ef          	jal	5430 <printf>
    exit(1);
    3130:	4505                	li	a0,1
    3132:	6b9010ef          	jal	4fea <exit>
    printf("%s: read dd/dd/ffff wrong len\n", s);
    3136:	85ca                	mv	a1,s2
    3138:	00004517          	auipc	a0,0x4
    313c:	98850513          	addi	a0,a0,-1656 # 6ac0 <malloc+0x15d8>
    3140:	2f0020ef          	jal	5430 <printf>
    exit(1);
    3144:	4505                	li	a0,1
    3146:	6a5010ef          	jal	4fea <exit>
    printf("%s: open (unlinked) dd/dd/ff succeeded!\n", s);
    314a:	85ca                	mv	a1,s2
    314c:	00004517          	auipc	a0,0x4
    3150:	99450513          	addi	a0,a0,-1644 # 6ae0 <malloc+0x15f8>
    3154:	2dc020ef          	jal	5430 <printf>
    exit(1);
    3158:	4505                	li	a0,1
    315a:	691010ef          	jal	4fea <exit>
    printf("%s: create dd/ff/ff succeeded!\n", s);
    315e:	85ca                	mv	a1,s2
    3160:	00004517          	auipc	a0,0x4
    3164:	9c050513          	addi	a0,a0,-1600 # 6b20 <malloc+0x1638>
    3168:	2c8020ef          	jal	5430 <printf>
    exit(1);
    316c:	4505                	li	a0,1
    316e:	67d010ef          	jal	4fea <exit>
    printf("%s: create dd/xx/ff succeeded!\n", s);
    3172:	85ca                	mv	a1,s2
    3174:	00004517          	auipc	a0,0x4
    3178:	9dc50513          	addi	a0,a0,-1572 # 6b50 <malloc+0x1668>
    317c:	2b4020ef          	jal	5430 <printf>
    exit(1);
    3180:	4505                	li	a0,1
    3182:	669010ef          	jal	4fea <exit>
    printf("%s: create dd succeeded!\n", s);
    3186:	85ca                	mv	a1,s2
    3188:	00004517          	auipc	a0,0x4
    318c:	9e850513          	addi	a0,a0,-1560 # 6b70 <malloc+0x1688>
    3190:	2a0020ef          	jal	5430 <printf>
    exit(1);
    3194:	4505                	li	a0,1
    3196:	655010ef          	jal	4fea <exit>
    printf("%s: open dd rdwr succeeded!\n", s);
    319a:	85ca                	mv	a1,s2
    319c:	00004517          	auipc	a0,0x4
    31a0:	9f450513          	addi	a0,a0,-1548 # 6b90 <malloc+0x16a8>
    31a4:	28c020ef          	jal	5430 <printf>
    exit(1);
    31a8:	4505                	li	a0,1
    31aa:	641010ef          	jal	4fea <exit>
    printf("%s: open dd wronly succeeded!\n", s);
    31ae:	85ca                	mv	a1,s2
    31b0:	00004517          	auipc	a0,0x4
    31b4:	a0050513          	addi	a0,a0,-1536 # 6bb0 <malloc+0x16c8>
    31b8:	278020ef          	jal	5430 <printf>
    exit(1);
    31bc:	4505                	li	a0,1
    31be:	62d010ef          	jal	4fea <exit>
    printf("%s: link dd/ff/ff dd/dd/xx succeeded!\n", s);
    31c2:	85ca                	mv	a1,s2
    31c4:	00004517          	auipc	a0,0x4
    31c8:	a1c50513          	addi	a0,a0,-1508 # 6be0 <malloc+0x16f8>
    31cc:	264020ef          	jal	5430 <printf>
    exit(1);
    31d0:	4505                	li	a0,1
    31d2:	619010ef          	jal	4fea <exit>
    printf("%s: link dd/xx/ff dd/dd/xx succeeded!\n", s);
    31d6:	85ca                	mv	a1,s2
    31d8:	00004517          	auipc	a0,0x4
    31dc:	a3050513          	addi	a0,a0,-1488 # 6c08 <malloc+0x1720>
    31e0:	250020ef          	jal	5430 <printf>
    exit(1);
    31e4:	4505                	li	a0,1
    31e6:	605010ef          	jal	4fea <exit>
    printf("%s: link dd/ff dd/dd/ffff succeeded!\n", s);
    31ea:	85ca                	mv	a1,s2
    31ec:	00004517          	auipc	a0,0x4
    31f0:	a4450513          	addi	a0,a0,-1468 # 6c30 <malloc+0x1748>
    31f4:	23c020ef          	jal	5430 <printf>
    exit(1);
    31f8:	4505                	li	a0,1
    31fa:	5f1010ef          	jal	4fea <exit>
    printf("%s: mkdir dd/ff/ff succeeded!\n", s);
    31fe:	85ca                	mv	a1,s2
    3200:	00004517          	auipc	a0,0x4
    3204:	a5850513          	addi	a0,a0,-1448 # 6c58 <malloc+0x1770>
    3208:	228020ef          	jal	5430 <printf>
    exit(1);
    320c:	4505                	li	a0,1
    320e:	5dd010ef          	jal	4fea <exit>
    printf("%s: mkdir dd/xx/ff succeeded!\n", s);
    3212:	85ca                	mv	a1,s2
    3214:	00004517          	auipc	a0,0x4
    3218:	a6450513          	addi	a0,a0,-1436 # 6c78 <malloc+0x1790>
    321c:	214020ef          	jal	5430 <printf>
    exit(1);
    3220:	4505                	li	a0,1
    3222:	5c9010ef          	jal	4fea <exit>
    printf("%s: mkdir dd/dd/ffff succeeded!\n", s);
    3226:	85ca                	mv	a1,s2
    3228:	00004517          	auipc	a0,0x4
    322c:	a7050513          	addi	a0,a0,-1424 # 6c98 <malloc+0x17b0>
    3230:	200020ef          	jal	5430 <printf>
    exit(1);
    3234:	4505                	li	a0,1
    3236:	5b5010ef          	jal	4fea <exit>
    printf("%s: unlink dd/xx/ff succeeded!\n", s);
    323a:	85ca                	mv	a1,s2
    323c:	00004517          	auipc	a0,0x4
    3240:	a8450513          	addi	a0,a0,-1404 # 6cc0 <malloc+0x17d8>
    3244:	1ec020ef          	jal	5430 <printf>
    exit(1);
    3248:	4505                	li	a0,1
    324a:	5a1010ef          	jal	4fea <exit>
    printf("%s: unlink dd/ff/ff succeeded!\n", s);
    324e:	85ca                	mv	a1,s2
    3250:	00004517          	auipc	a0,0x4
    3254:	a9050513          	addi	a0,a0,-1392 # 6ce0 <malloc+0x17f8>
    3258:	1d8020ef          	jal	5430 <printf>
    exit(1);
    325c:	4505                	li	a0,1
    325e:	58d010ef          	jal	4fea <exit>
    printf("%s: chdir dd/ff succeeded!\n", s);
    3262:	85ca                	mv	a1,s2
    3264:	00004517          	auipc	a0,0x4
    3268:	a9c50513          	addi	a0,a0,-1380 # 6d00 <malloc+0x1818>
    326c:	1c4020ef          	jal	5430 <printf>
    exit(1);
    3270:	4505                	li	a0,1
    3272:	579010ef          	jal	4fea <exit>
    printf("%s: chdir dd/xx succeeded!\n", s);
    3276:	85ca                	mv	a1,s2
    3278:	00004517          	auipc	a0,0x4
    327c:	ab050513          	addi	a0,a0,-1360 # 6d28 <malloc+0x1840>
    3280:	1b0020ef          	jal	5430 <printf>
    exit(1);
    3284:	4505                	li	a0,1
    3286:	565010ef          	jal	4fea <exit>
    printf("%s: unlink dd/dd/ff failed\n", s);
    328a:	85ca                	mv	a1,s2
    328c:	00003517          	auipc	a0,0x3
    3290:	72c50513          	addi	a0,a0,1836 # 69b8 <malloc+0x14d0>
    3294:	19c020ef          	jal	5430 <printf>
    exit(1);
    3298:	4505                	li	a0,1
    329a:	551010ef          	jal	4fea <exit>
    printf("%s: unlink dd/ff failed\n", s);
    329e:	85ca                	mv	a1,s2
    32a0:	00004517          	auipc	a0,0x4
    32a4:	aa850513          	addi	a0,a0,-1368 # 6d48 <malloc+0x1860>
    32a8:	188020ef          	jal	5430 <printf>
    exit(1);
    32ac:	4505                	li	a0,1
    32ae:	53d010ef          	jal	4fea <exit>
    printf("%s: unlink non-empty dd succeeded!\n", s);
    32b2:	85ca                	mv	a1,s2
    32b4:	00004517          	auipc	a0,0x4
    32b8:	ab450513          	addi	a0,a0,-1356 # 6d68 <malloc+0x1880>
    32bc:	174020ef          	jal	5430 <printf>
    exit(1);
    32c0:	4505                	li	a0,1
    32c2:	529010ef          	jal	4fea <exit>
    printf("%s: unlink dd/dd failed\n", s);
    32c6:	85ca                	mv	a1,s2
    32c8:	00004517          	auipc	a0,0x4
    32cc:	ad050513          	addi	a0,a0,-1328 # 6d98 <malloc+0x18b0>
    32d0:	160020ef          	jal	5430 <printf>
    exit(1);
    32d4:	4505                	li	a0,1
    32d6:	515010ef          	jal	4fea <exit>
    printf("%s: unlink dd failed\n", s);
    32da:	85ca                	mv	a1,s2
    32dc:	00004517          	auipc	a0,0x4
    32e0:	adc50513          	addi	a0,a0,-1316 # 6db8 <malloc+0x18d0>
    32e4:	14c020ef          	jal	5430 <printf>
    exit(1);
    32e8:	4505                	li	a0,1
    32ea:	501010ef          	jal	4fea <exit>

00000000000032ee <rmdot>:
{
    32ee:	1101                	addi	sp,sp,-32
    32f0:	ec06                	sd	ra,24(sp)
    32f2:	e822                	sd	s0,16(sp)
    32f4:	e426                	sd	s1,8(sp)
    32f6:	1000                	addi	s0,sp,32
    32f8:	84aa                	mv	s1,a0
  if(mkdir("dots") != 0){
    32fa:	00004517          	auipc	a0,0x4
    32fe:	ad650513          	addi	a0,a0,-1322 # 6dd0 <malloc+0x18e8>
    3302:	551010ef          	jal	5052 <mkdir>
    3306:	e53d                	bnez	a0,3374 <rmdot+0x86>
  if(chdir("dots") != 0){
    3308:	00004517          	auipc	a0,0x4
    330c:	ac850513          	addi	a0,a0,-1336 # 6dd0 <malloc+0x18e8>
    3310:	54b010ef          	jal	505a <chdir>
    3314:	e935                	bnez	a0,3388 <rmdot+0x9a>
  if(unlink(".") == 0){
    3316:	00003517          	auipc	a0,0x3
    331a:	9ea50513          	addi	a0,a0,-1558 # 5d00 <malloc+0x818>
    331e:	51d010ef          	jal	503a <unlink>
    3322:	cd2d                	beqz	a0,339c <rmdot+0xae>
  if(unlink("..") == 0){
    3324:	00003517          	auipc	a0,0x3
    3328:	4fc50513          	addi	a0,a0,1276 # 6820 <malloc+0x1338>
    332c:	50f010ef          	jal	503a <unlink>
    3330:	c141                	beqz	a0,33b0 <rmdot+0xc2>
  if(chdir("/") != 0){
    3332:	00003517          	auipc	a0,0x3
    3336:	49650513          	addi	a0,a0,1174 # 67c8 <malloc+0x12e0>
    333a:	521010ef          	jal	505a <chdir>
    333e:	e159                	bnez	a0,33c4 <rmdot+0xd6>
  if(unlink("dots/.") == 0){
    3340:	00004517          	auipc	a0,0x4
    3344:	af850513          	addi	a0,a0,-1288 # 6e38 <malloc+0x1950>
    3348:	4f3010ef          	jal	503a <unlink>
    334c:	c551                	beqz	a0,33d8 <rmdot+0xea>
  if(unlink("dots/..") == 0){
    334e:	00004517          	auipc	a0,0x4
    3352:	b1250513          	addi	a0,a0,-1262 # 6e60 <malloc+0x1978>
    3356:	4e5010ef          	jal	503a <unlink>
    335a:	c949                	beqz	a0,33ec <rmdot+0xfe>
  if(unlink("dots") != 0){
    335c:	00004517          	auipc	a0,0x4
    3360:	a7450513          	addi	a0,a0,-1420 # 6dd0 <malloc+0x18e8>
    3364:	4d7010ef          	jal	503a <unlink>
    3368:	ed41                	bnez	a0,3400 <rmdot+0x112>
}
    336a:	60e2                	ld	ra,24(sp)
    336c:	6442                	ld	s0,16(sp)
    336e:	64a2                	ld	s1,8(sp)
    3370:	6105                	addi	sp,sp,32
    3372:	8082                	ret
    printf("%s: mkdir dots failed\n", s);
    3374:	85a6                	mv	a1,s1
    3376:	00004517          	auipc	a0,0x4
    337a:	a6250513          	addi	a0,a0,-1438 # 6dd8 <malloc+0x18f0>
    337e:	0b2020ef          	jal	5430 <printf>
    exit(1);
    3382:	4505                	li	a0,1
    3384:	467010ef          	jal	4fea <exit>
    printf("%s: chdir dots failed\n", s);
    3388:	85a6                	mv	a1,s1
    338a:	00004517          	auipc	a0,0x4
    338e:	a6650513          	addi	a0,a0,-1434 # 6df0 <malloc+0x1908>
    3392:	09e020ef          	jal	5430 <printf>
    exit(1);
    3396:	4505                	li	a0,1
    3398:	453010ef          	jal	4fea <exit>
    printf("%s: rm . worked!\n", s);
    339c:	85a6                	mv	a1,s1
    339e:	00004517          	auipc	a0,0x4
    33a2:	a6a50513          	addi	a0,a0,-1430 # 6e08 <malloc+0x1920>
    33a6:	08a020ef          	jal	5430 <printf>
    exit(1);
    33aa:	4505                	li	a0,1
    33ac:	43f010ef          	jal	4fea <exit>
    printf("%s: rm .. worked!\n", s);
    33b0:	85a6                	mv	a1,s1
    33b2:	00004517          	auipc	a0,0x4
    33b6:	a6e50513          	addi	a0,a0,-1426 # 6e20 <malloc+0x1938>
    33ba:	076020ef          	jal	5430 <printf>
    exit(1);
    33be:	4505                	li	a0,1
    33c0:	42b010ef          	jal	4fea <exit>
    printf("%s: chdir / failed\n", s);
    33c4:	85a6                	mv	a1,s1
    33c6:	00003517          	auipc	a0,0x3
    33ca:	40a50513          	addi	a0,a0,1034 # 67d0 <malloc+0x12e8>
    33ce:	062020ef          	jal	5430 <printf>
    exit(1);
    33d2:	4505                	li	a0,1
    33d4:	417010ef          	jal	4fea <exit>
    printf("%s: unlink dots/. worked!\n", s);
    33d8:	85a6                	mv	a1,s1
    33da:	00004517          	auipc	a0,0x4
    33de:	a6650513          	addi	a0,a0,-1434 # 6e40 <malloc+0x1958>
    33e2:	04e020ef          	jal	5430 <printf>
    exit(1);
    33e6:	4505                	li	a0,1
    33e8:	403010ef          	jal	4fea <exit>
    printf("%s: unlink dots/.. worked!\n", s);
    33ec:	85a6                	mv	a1,s1
    33ee:	00004517          	auipc	a0,0x4
    33f2:	a7a50513          	addi	a0,a0,-1414 # 6e68 <malloc+0x1980>
    33f6:	03a020ef          	jal	5430 <printf>
    exit(1);
    33fa:	4505                	li	a0,1
    33fc:	3ef010ef          	jal	4fea <exit>
    printf("%s: unlink dots failed!\n", s);
    3400:	85a6                	mv	a1,s1
    3402:	00004517          	auipc	a0,0x4
    3406:	a8650513          	addi	a0,a0,-1402 # 6e88 <malloc+0x19a0>
    340a:	026020ef          	jal	5430 <printf>
    exit(1);
    340e:	4505                	li	a0,1
    3410:	3db010ef          	jal	4fea <exit>

0000000000003414 <dirfile>:
{
    3414:	1101                	addi	sp,sp,-32
    3416:	ec06                	sd	ra,24(sp)
    3418:	e822                	sd	s0,16(sp)
    341a:	e426                	sd	s1,8(sp)
    341c:	e04a                	sd	s2,0(sp)
    341e:	1000                	addi	s0,sp,32
    3420:	892a                	mv	s2,a0
  fd = open("dirfile", O_CREATE);
    3422:	20000593          	li	a1,512
    3426:	00004517          	auipc	a0,0x4
    342a:	a8250513          	addi	a0,a0,-1406 # 6ea8 <malloc+0x19c0>
    342e:	3fd010ef          	jal	502a <open>
  if(fd < 0){
    3432:	0c054563          	bltz	a0,34fc <dirfile+0xe8>
  close(fd);
    3436:	3dd010ef          	jal	5012 <close>
  if(chdir("dirfile") == 0){
    343a:	00004517          	auipc	a0,0x4
    343e:	a6e50513          	addi	a0,a0,-1426 # 6ea8 <malloc+0x19c0>
    3442:	419010ef          	jal	505a <chdir>
    3446:	c569                	beqz	a0,3510 <dirfile+0xfc>
  fd = open("dirfile/xx", 0);
    3448:	4581                	li	a1,0
    344a:	00004517          	auipc	a0,0x4
    344e:	aa650513          	addi	a0,a0,-1370 # 6ef0 <malloc+0x1a08>
    3452:	3d9010ef          	jal	502a <open>
  if(fd >= 0){
    3456:	0c055763          	bgez	a0,3524 <dirfile+0x110>
  fd = open("dirfile/xx", O_CREATE);
    345a:	20000593          	li	a1,512
    345e:	00004517          	auipc	a0,0x4
    3462:	a9250513          	addi	a0,a0,-1390 # 6ef0 <malloc+0x1a08>
    3466:	3c5010ef          	jal	502a <open>
  if(fd >= 0){
    346a:	0c055763          	bgez	a0,3538 <dirfile+0x124>
  if(mkdir("dirfile/xx") == 0){
    346e:	00004517          	auipc	a0,0x4
    3472:	a8250513          	addi	a0,a0,-1406 # 6ef0 <malloc+0x1a08>
    3476:	3dd010ef          	jal	5052 <mkdir>
    347a:	0c050963          	beqz	a0,354c <dirfile+0x138>
  if(unlink("dirfile/xx") == 0){
    347e:	00004517          	auipc	a0,0x4
    3482:	a7250513          	addi	a0,a0,-1422 # 6ef0 <malloc+0x1a08>
    3486:	3b5010ef          	jal	503a <unlink>
    348a:	0c050b63          	beqz	a0,3560 <dirfile+0x14c>
  if(link("README", "dirfile/xx") == 0){
    348e:	00004597          	auipc	a1,0x4
    3492:	a6258593          	addi	a1,a1,-1438 # 6ef0 <malloc+0x1a08>
    3496:	00002517          	auipc	a0,0x2
    349a:	35a50513          	addi	a0,a0,858 # 57f0 <malloc+0x308>
    349e:	3ad010ef          	jal	504a <link>
    34a2:	0c050963          	beqz	a0,3574 <dirfile+0x160>
  if(unlink("dirfile") != 0){
    34a6:	00004517          	auipc	a0,0x4
    34aa:	a0250513          	addi	a0,a0,-1534 # 6ea8 <malloc+0x19c0>
    34ae:	38d010ef          	jal	503a <unlink>
    34b2:	0c051b63          	bnez	a0,3588 <dirfile+0x174>
  fd = open(".", O_RDWR);
    34b6:	4589                	li	a1,2
    34b8:	00003517          	auipc	a0,0x3
    34bc:	84850513          	addi	a0,a0,-1976 # 5d00 <malloc+0x818>
    34c0:	36b010ef          	jal	502a <open>
  if(fd >= 0){
    34c4:	0c055c63          	bgez	a0,359c <dirfile+0x188>
  fd = open(".", 0);
    34c8:	4581                	li	a1,0
    34ca:	00003517          	auipc	a0,0x3
    34ce:	83650513          	addi	a0,a0,-1994 # 5d00 <malloc+0x818>
    34d2:	359010ef          	jal	502a <open>
    34d6:	84aa                	mv	s1,a0
  if(write(fd, "x", 1) > 0){
    34d8:	4605                	li	a2,1
    34da:	00002597          	auipc	a1,0x2
    34de:	1ae58593          	addi	a1,a1,430 # 5688 <malloc+0x1a0>
    34e2:	329010ef          	jal	500a <write>
    34e6:	0ca04563          	bgtz	a0,35b0 <dirfile+0x19c>
  close(fd);
    34ea:	8526                	mv	a0,s1
    34ec:	327010ef          	jal	5012 <close>
}
    34f0:	60e2                	ld	ra,24(sp)
    34f2:	6442                	ld	s0,16(sp)
    34f4:	64a2                	ld	s1,8(sp)
    34f6:	6902                	ld	s2,0(sp)
    34f8:	6105                	addi	sp,sp,32
    34fa:	8082                	ret
    printf("%s: create dirfile failed\n", s);
    34fc:	85ca                	mv	a1,s2
    34fe:	00004517          	auipc	a0,0x4
    3502:	9b250513          	addi	a0,a0,-1614 # 6eb0 <malloc+0x19c8>
    3506:	72b010ef          	jal	5430 <printf>
    exit(1);
    350a:	4505                	li	a0,1
    350c:	2df010ef          	jal	4fea <exit>
    printf("%s: chdir dirfile succeeded!\n", s);
    3510:	85ca                	mv	a1,s2
    3512:	00004517          	auipc	a0,0x4
    3516:	9be50513          	addi	a0,a0,-1602 # 6ed0 <malloc+0x19e8>
    351a:	717010ef          	jal	5430 <printf>
    exit(1);
    351e:	4505                	li	a0,1
    3520:	2cb010ef          	jal	4fea <exit>
    printf("%s: create dirfile/xx succeeded!\n", s);
    3524:	85ca                	mv	a1,s2
    3526:	00004517          	auipc	a0,0x4
    352a:	9da50513          	addi	a0,a0,-1574 # 6f00 <malloc+0x1a18>
    352e:	703010ef          	jal	5430 <printf>
    exit(1);
    3532:	4505                	li	a0,1
    3534:	2b7010ef          	jal	4fea <exit>
    printf("%s: create dirfile/xx succeeded!\n", s);
    3538:	85ca                	mv	a1,s2
    353a:	00004517          	auipc	a0,0x4
    353e:	9c650513          	addi	a0,a0,-1594 # 6f00 <malloc+0x1a18>
    3542:	6ef010ef          	jal	5430 <printf>
    exit(1);
    3546:	4505                	li	a0,1
    3548:	2a3010ef          	jal	4fea <exit>
    printf("%s: mkdir dirfile/xx succeeded!\n", s);
    354c:	85ca                	mv	a1,s2
    354e:	00004517          	auipc	a0,0x4
    3552:	9da50513          	addi	a0,a0,-1574 # 6f28 <malloc+0x1a40>
    3556:	6db010ef          	jal	5430 <printf>
    exit(1);
    355a:	4505                	li	a0,1
    355c:	28f010ef          	jal	4fea <exit>
    printf("%s: unlink dirfile/xx succeeded!\n", s);
    3560:	85ca                	mv	a1,s2
    3562:	00004517          	auipc	a0,0x4
    3566:	9ee50513          	addi	a0,a0,-1554 # 6f50 <malloc+0x1a68>
    356a:	6c7010ef          	jal	5430 <printf>
    exit(1);
    356e:	4505                	li	a0,1
    3570:	27b010ef          	jal	4fea <exit>
    printf("%s: link to dirfile/xx succeeded!\n", s);
    3574:	85ca                	mv	a1,s2
    3576:	00004517          	auipc	a0,0x4
    357a:	a0250513          	addi	a0,a0,-1534 # 6f78 <malloc+0x1a90>
    357e:	6b3010ef          	jal	5430 <printf>
    exit(1);
    3582:	4505                	li	a0,1
    3584:	267010ef          	jal	4fea <exit>
    printf("%s: unlink dirfile failed!\n", s);
    3588:	85ca                	mv	a1,s2
    358a:	00004517          	auipc	a0,0x4
    358e:	a1650513          	addi	a0,a0,-1514 # 6fa0 <malloc+0x1ab8>
    3592:	69f010ef          	jal	5430 <printf>
    exit(1);
    3596:	4505                	li	a0,1
    3598:	253010ef          	jal	4fea <exit>
    printf("%s: open . for writing succeeded!\n", s);
    359c:	85ca                	mv	a1,s2
    359e:	00004517          	auipc	a0,0x4
    35a2:	a2250513          	addi	a0,a0,-1502 # 6fc0 <malloc+0x1ad8>
    35a6:	68b010ef          	jal	5430 <printf>
    exit(1);
    35aa:	4505                	li	a0,1
    35ac:	23f010ef          	jal	4fea <exit>
    printf("%s: write . succeeded!\n", s);
    35b0:	85ca                	mv	a1,s2
    35b2:	00004517          	auipc	a0,0x4
    35b6:	a3650513          	addi	a0,a0,-1482 # 6fe8 <malloc+0x1b00>
    35ba:	677010ef          	jal	5430 <printf>
    exit(1);
    35be:	4505                	li	a0,1
    35c0:	22b010ef          	jal	4fea <exit>

00000000000035c4 <iref>:
{
    35c4:	715d                	addi	sp,sp,-80
    35c6:	e486                	sd	ra,72(sp)
    35c8:	e0a2                	sd	s0,64(sp)
    35ca:	fc26                	sd	s1,56(sp)
    35cc:	f84a                	sd	s2,48(sp)
    35ce:	f44e                	sd	s3,40(sp)
    35d0:	f052                	sd	s4,32(sp)
    35d2:	ec56                	sd	s5,24(sp)
    35d4:	e85a                	sd	s6,16(sp)
    35d6:	e45e                	sd	s7,8(sp)
    35d8:	0880                	addi	s0,sp,80
    35da:	8baa                	mv	s7,a0
    35dc:	03300913          	li	s2,51
    if(mkdir("irefd") != 0){
    35e0:	00004a97          	auipc	s5,0x4
    35e4:	a20a8a93          	addi	s5,s5,-1504 # 7000 <malloc+0x1b18>
    mkdir("");
    35e8:	00003497          	auipc	s1,0x3
    35ec:	52048493          	addi	s1,s1,1312 # 6b08 <malloc+0x1620>
    link("README", "");
    35f0:	00002b17          	auipc	s6,0x2
    35f4:	200b0b13          	addi	s6,s6,512 # 57f0 <malloc+0x308>
    fd = open("", O_CREATE);
    35f8:	20000a13          	li	s4,512
    fd = open("xx", O_CREATE);
    35fc:	00004997          	auipc	s3,0x4
    3600:	8fc98993          	addi	s3,s3,-1796 # 6ef8 <malloc+0x1a10>
    3604:	a835                	j	3640 <iref+0x7c>
      printf("%s: mkdir irefd failed\n", s);
    3606:	85de                	mv	a1,s7
    3608:	00004517          	auipc	a0,0x4
    360c:	a0050513          	addi	a0,a0,-1536 # 7008 <malloc+0x1b20>
    3610:	621010ef          	jal	5430 <printf>
      exit(1);
    3614:	4505                	li	a0,1
    3616:	1d5010ef          	jal	4fea <exit>
      printf("%s: chdir irefd failed\n", s);
    361a:	85de                	mv	a1,s7
    361c:	00004517          	auipc	a0,0x4
    3620:	a0450513          	addi	a0,a0,-1532 # 7020 <malloc+0x1b38>
    3624:	60d010ef          	jal	5430 <printf>
      exit(1);
    3628:	4505                	li	a0,1
    362a:	1c1010ef          	jal	4fea <exit>
      close(fd);
    362e:	1e5010ef          	jal	5012 <close>
    3632:	a825                	j	366a <iref+0xa6>
    unlink("xx");
    3634:	854e                	mv	a0,s3
    3636:	205010ef          	jal	503a <unlink>
  for(i = 0; i < NINODE + 1; i++){
    363a:	397d                	addiw	s2,s2,-1
    363c:	04090063          	beqz	s2,367c <iref+0xb8>
    if(mkdir("irefd") != 0){
    3640:	8556                	mv	a0,s5
    3642:	211010ef          	jal	5052 <mkdir>
    3646:	f161                	bnez	a0,3606 <iref+0x42>
    if(chdir("irefd") != 0){
    3648:	8556                	mv	a0,s5
    364a:	211010ef          	jal	505a <chdir>
    364e:	f571                	bnez	a0,361a <iref+0x56>
    mkdir("");
    3650:	8526                	mv	a0,s1
    3652:	201010ef          	jal	5052 <mkdir>
    link("README", "");
    3656:	85a6                	mv	a1,s1
    3658:	855a                	mv	a0,s6
    365a:	1f1010ef          	jal	504a <link>
    fd = open("", O_CREATE);
    365e:	85d2                	mv	a1,s4
    3660:	8526                	mv	a0,s1
    3662:	1c9010ef          	jal	502a <open>
    if(fd >= 0)
    3666:	fc0554e3          	bgez	a0,362e <iref+0x6a>
    fd = open("xx", O_CREATE);
    366a:	85d2                	mv	a1,s4
    366c:	854e                	mv	a0,s3
    366e:	1bd010ef          	jal	502a <open>
    if(fd >= 0)
    3672:	fc0541e3          	bltz	a0,3634 <iref+0x70>
      close(fd);
    3676:	19d010ef          	jal	5012 <close>
    367a:	bf6d                	j	3634 <iref+0x70>
    367c:	03300493          	li	s1,51
    chdir("..");
    3680:	00003997          	auipc	s3,0x3
    3684:	1a098993          	addi	s3,s3,416 # 6820 <malloc+0x1338>
    unlink("irefd");
    3688:	00004917          	auipc	s2,0x4
    368c:	97890913          	addi	s2,s2,-1672 # 7000 <malloc+0x1b18>
    chdir("..");
    3690:	854e                	mv	a0,s3
    3692:	1c9010ef          	jal	505a <chdir>
    unlink("irefd");
    3696:	854a                	mv	a0,s2
    3698:	1a3010ef          	jal	503a <unlink>
  for(i = 0; i < NINODE + 1; i++){
    369c:	34fd                	addiw	s1,s1,-1
    369e:	f8ed                	bnez	s1,3690 <iref+0xcc>
  chdir("/");
    36a0:	00003517          	auipc	a0,0x3
    36a4:	12850513          	addi	a0,a0,296 # 67c8 <malloc+0x12e0>
    36a8:	1b3010ef          	jal	505a <chdir>
}
    36ac:	60a6                	ld	ra,72(sp)
    36ae:	6406                	ld	s0,64(sp)
    36b0:	74e2                	ld	s1,56(sp)
    36b2:	7942                	ld	s2,48(sp)
    36b4:	79a2                	ld	s3,40(sp)
    36b6:	7a02                	ld	s4,32(sp)
    36b8:	6ae2                	ld	s5,24(sp)
    36ba:	6b42                	ld	s6,16(sp)
    36bc:	6ba2                	ld	s7,8(sp)
    36be:	6161                	addi	sp,sp,80
    36c0:	8082                	ret

00000000000036c2 <openiputtest>:
{
    36c2:	7179                	addi	sp,sp,-48
    36c4:	f406                	sd	ra,40(sp)
    36c6:	f022                	sd	s0,32(sp)
    36c8:	ec26                	sd	s1,24(sp)
    36ca:	1800                	addi	s0,sp,48
    36cc:	84aa                	mv	s1,a0
  if(mkdir("oidir") < 0){
    36ce:	00004517          	auipc	a0,0x4
    36d2:	96a50513          	addi	a0,a0,-1686 # 7038 <malloc+0x1b50>
    36d6:	17d010ef          	jal	5052 <mkdir>
    36da:	02054a63          	bltz	a0,370e <openiputtest+0x4c>
  pid = fork();
    36de:	105010ef          	jal	4fe2 <fork>
  if(pid < 0){
    36e2:	04054063          	bltz	a0,3722 <openiputtest+0x60>
  if(pid == 0){
    36e6:	e939                	bnez	a0,373c <openiputtest+0x7a>
    int fd = open("oidir", O_RDWR);
    36e8:	4589                	li	a1,2
    36ea:	00004517          	auipc	a0,0x4
    36ee:	94e50513          	addi	a0,a0,-1714 # 7038 <malloc+0x1b50>
    36f2:	139010ef          	jal	502a <open>
    if(fd >= 0){
    36f6:	04054063          	bltz	a0,3736 <openiputtest+0x74>
      printf("%s: open directory for write succeeded\n", s);
    36fa:	85a6                	mv	a1,s1
    36fc:	00004517          	auipc	a0,0x4
    3700:	95c50513          	addi	a0,a0,-1700 # 7058 <malloc+0x1b70>
    3704:	52d010ef          	jal	5430 <printf>
      exit(1);
    3708:	4505                	li	a0,1
    370a:	0e1010ef          	jal	4fea <exit>
    printf("%s: mkdir oidir failed\n", s);
    370e:	85a6                	mv	a1,s1
    3710:	00004517          	auipc	a0,0x4
    3714:	93050513          	addi	a0,a0,-1744 # 7040 <malloc+0x1b58>
    3718:	519010ef          	jal	5430 <printf>
    exit(1);
    371c:	4505                	li	a0,1
    371e:	0cd010ef          	jal	4fea <exit>
    printf("%s: fork failed\n", s);
    3722:	85a6                	mv	a1,s1
    3724:	00002517          	auipc	a0,0x2
    3728:	78450513          	addi	a0,a0,1924 # 5ea8 <malloc+0x9c0>
    372c:	505010ef          	jal	5430 <printf>
    exit(1);
    3730:	4505                	li	a0,1
    3732:	0b9010ef          	jal	4fea <exit>
    exit(0);
    3736:	4501                	li	a0,0
    3738:	0b3010ef          	jal	4fea <exit>
  pause(1);
    373c:	4505                	li	a0,1
    373e:	13d010ef          	jal	507a <pause>
  if(unlink("oidir") != 0){
    3742:	00004517          	auipc	a0,0x4
    3746:	8f650513          	addi	a0,a0,-1802 # 7038 <malloc+0x1b50>
    374a:	0f1010ef          	jal	503a <unlink>
    374e:	c919                	beqz	a0,3764 <openiputtest+0xa2>
    printf("%s: unlink failed\n", s);
    3750:	85a6                	mv	a1,s1
    3752:	00003517          	auipc	a0,0x3
    3756:	94650513          	addi	a0,a0,-1722 # 6098 <malloc+0xbb0>
    375a:	4d7010ef          	jal	5430 <printf>
    exit(1);
    375e:	4505                	li	a0,1
    3760:	08b010ef          	jal	4fea <exit>
  wait(&xstatus);
    3764:	fdc40513          	addi	a0,s0,-36
    3768:	08b010ef          	jal	4ff2 <wait>
  exit(xstatus);
    376c:	fdc42503          	lw	a0,-36(s0)
    3770:	07b010ef          	jal	4fea <exit>

0000000000003774 <forkforkfork>:
{
    3774:	1101                	addi	sp,sp,-32
    3776:	ec06                	sd	ra,24(sp)
    3778:	e822                	sd	s0,16(sp)
    377a:	e426                	sd	s1,8(sp)
    377c:	1000                	addi	s0,sp,32
    377e:	84aa                	mv	s1,a0
  unlink("stopforking");
    3780:	00004517          	auipc	a0,0x4
    3784:	90050513          	addi	a0,a0,-1792 # 7080 <malloc+0x1b98>
    3788:	0b3010ef          	jal	503a <unlink>
  int pid = fork();
    378c:	057010ef          	jal	4fe2 <fork>
  if(pid < 0){
    3790:	02054b63          	bltz	a0,37c6 <forkforkfork+0x52>
  if(pid == 0){
    3794:	c139                	beqz	a0,37da <forkforkfork+0x66>
  pause(20); // two seconds
    3796:	4551                	li	a0,20
    3798:	0e3010ef          	jal	507a <pause>
  close(open("stopforking", O_CREATE|O_RDWR));
    379c:	20200593          	li	a1,514
    37a0:	00004517          	auipc	a0,0x4
    37a4:	8e050513          	addi	a0,a0,-1824 # 7080 <malloc+0x1b98>
    37a8:	083010ef          	jal	502a <open>
    37ac:	067010ef          	jal	5012 <close>
  wait(0);
    37b0:	4501                	li	a0,0
    37b2:	041010ef          	jal	4ff2 <wait>
  pause(10); // one second
    37b6:	4529                	li	a0,10
    37b8:	0c3010ef          	jal	507a <pause>
}
    37bc:	60e2                	ld	ra,24(sp)
    37be:	6442                	ld	s0,16(sp)
    37c0:	64a2                	ld	s1,8(sp)
    37c2:	6105                	addi	sp,sp,32
    37c4:	8082                	ret
    printf("%s: fork failed", s);
    37c6:	85a6                	mv	a1,s1
    37c8:	00003517          	auipc	a0,0x3
    37cc:	8a050513          	addi	a0,a0,-1888 # 6068 <malloc+0xb80>
    37d0:	461010ef          	jal	5430 <printf>
    exit(1);
    37d4:	4505                	li	a0,1
    37d6:	015010ef          	jal	4fea <exit>
      int fd = open("stopforking", 0);
    37da:	4581                	li	a1,0
    37dc:	00004517          	auipc	a0,0x4
    37e0:	8a450513          	addi	a0,a0,-1884 # 7080 <malloc+0x1b98>
    37e4:	047010ef          	jal	502a <open>
      if(fd >= 0){
    37e8:	02055163          	bgez	a0,380a <forkforkfork+0x96>
      if(fork() < 0){
    37ec:	7f6010ef          	jal	4fe2 <fork>
    37f0:	fe0555e3          	bgez	a0,37da <forkforkfork+0x66>
        close(open("stopforking", O_CREATE|O_RDWR));
    37f4:	20200593          	li	a1,514
    37f8:	00004517          	auipc	a0,0x4
    37fc:	88850513          	addi	a0,a0,-1912 # 7080 <malloc+0x1b98>
    3800:	02b010ef          	jal	502a <open>
    3804:	00f010ef          	jal	5012 <close>
    3808:	bfc9                	j	37da <forkforkfork+0x66>
        exit(0);
    380a:	4501                	li	a0,0
    380c:	7de010ef          	jal	4fea <exit>

0000000000003810 <killstatus>:
{
    3810:	715d                	addi	sp,sp,-80
    3812:	e486                	sd	ra,72(sp)
    3814:	e0a2                	sd	s0,64(sp)
    3816:	fc26                	sd	s1,56(sp)
    3818:	f84a                	sd	s2,48(sp)
    381a:	f44e                	sd	s3,40(sp)
    381c:	f052                	sd	s4,32(sp)
    381e:	ec56                	sd	s5,24(sp)
    3820:	e85a                	sd	s6,16(sp)
    3822:	0880                	addi	s0,sp,80
    3824:	8b2a                	mv	s6,a0
    3826:	06400913          	li	s2,100
    pause(1);
    382a:	4a85                	li	s5,1
    wait(&xst);
    382c:	fbc40a13          	addi	s4,s0,-68
    if(xst != -1) {
    3830:	59fd                	li	s3,-1
    int pid1 = fork();
    3832:	7b0010ef          	jal	4fe2 <fork>
    3836:	84aa                	mv	s1,a0
    if(pid1 < 0){
    3838:	02054663          	bltz	a0,3864 <killstatus+0x54>
    if(pid1 == 0){
    383c:	cd15                	beqz	a0,3878 <killstatus+0x68>
    pause(1);
    383e:	8556                	mv	a0,s5
    3840:	03b010ef          	jal	507a <pause>
    kill(pid1);
    3844:	8526                	mv	a0,s1
    3846:	7d4010ef          	jal	501a <kill>
    wait(&xst);
    384a:	8552                	mv	a0,s4
    384c:	7a6010ef          	jal	4ff2 <wait>
    if(xst != -1) {
    3850:	fbc42783          	lw	a5,-68(s0)
    3854:	03379563          	bne	a5,s3,387e <killstatus+0x6e>
  for(int i = 0; i < 100; i++){
    3858:	397d                	addiw	s2,s2,-1
    385a:	fc091ce3          	bnez	s2,3832 <killstatus+0x22>
  exit(0);
    385e:	4501                	li	a0,0
    3860:	78a010ef          	jal	4fea <exit>
      printf("%s: fork failed\n", s);
    3864:	85da                	mv	a1,s6
    3866:	00002517          	auipc	a0,0x2
    386a:	64250513          	addi	a0,a0,1602 # 5ea8 <malloc+0x9c0>
    386e:	3c3010ef          	jal	5430 <printf>
      exit(1);
    3872:	4505                	li	a0,1
    3874:	776010ef          	jal	4fea <exit>
        getpid();
    3878:	7f2010ef          	jal	506a <getpid>
      while(1) {
    387c:	bff5                	j	3878 <killstatus+0x68>
       printf("%s: status should be -1\n", s);
    387e:	85da                	mv	a1,s6
    3880:	00004517          	auipc	a0,0x4
    3884:	81050513          	addi	a0,a0,-2032 # 7090 <malloc+0x1ba8>
    3888:	3a9010ef          	jal	5430 <printf>
       exit(1);
    388c:	4505                	li	a0,1
    388e:	75c010ef          	jal	4fea <exit>

0000000000003892 <preempt>:
{
    3892:	7139                	addi	sp,sp,-64
    3894:	fc06                	sd	ra,56(sp)
    3896:	f822                	sd	s0,48(sp)
    3898:	f426                	sd	s1,40(sp)
    389a:	f04a                	sd	s2,32(sp)
    389c:	ec4e                	sd	s3,24(sp)
    389e:	e852                	sd	s4,16(sp)
    38a0:	0080                	addi	s0,sp,64
    38a2:	892a                	mv	s2,a0
  pid1 = fork();
    38a4:	73e010ef          	jal	4fe2 <fork>
  if(pid1 < 0) {
    38a8:	00054563          	bltz	a0,38b2 <preempt+0x20>
    38ac:	84aa                	mv	s1,a0
  if(pid1 == 0)
    38ae:	ed01                	bnez	a0,38c6 <preempt+0x34>
    for(;;)
    38b0:	a001                	j	38b0 <preempt+0x1e>
    printf("%s: fork failed", s);
    38b2:	85ca                	mv	a1,s2
    38b4:	00002517          	auipc	a0,0x2
    38b8:	7b450513          	addi	a0,a0,1972 # 6068 <malloc+0xb80>
    38bc:	375010ef          	jal	5430 <printf>
    exit(1);
    38c0:	4505                	li	a0,1
    38c2:	728010ef          	jal	4fea <exit>
  pid2 = fork();
    38c6:	71c010ef          	jal	4fe2 <fork>
    38ca:	89aa                	mv	s3,a0
  if(pid2 < 0) {
    38cc:	00054463          	bltz	a0,38d4 <preempt+0x42>
  if(pid2 == 0)
    38d0:	ed01                	bnez	a0,38e8 <preempt+0x56>
    for(;;)
    38d2:	a001                	j	38d2 <preempt+0x40>
    printf("%s: fork failed\n", s);
    38d4:	85ca                	mv	a1,s2
    38d6:	00002517          	auipc	a0,0x2
    38da:	5d250513          	addi	a0,a0,1490 # 5ea8 <malloc+0x9c0>
    38de:	353010ef          	jal	5430 <printf>
    exit(1);
    38e2:	4505                	li	a0,1
    38e4:	706010ef          	jal	4fea <exit>
  pipe(pfds);
    38e8:	fc840513          	addi	a0,s0,-56
    38ec:	70e010ef          	jal	4ffa <pipe>
  pid3 = fork();
    38f0:	6f2010ef          	jal	4fe2 <fork>
    38f4:	8a2a                	mv	s4,a0
  if(pid3 < 0) {
    38f6:	02054863          	bltz	a0,3926 <preempt+0x94>
  if(pid3 == 0){
    38fa:	e921                	bnez	a0,394a <preempt+0xb8>
    close(pfds[0]);
    38fc:	fc842503          	lw	a0,-56(s0)
    3900:	712010ef          	jal	5012 <close>
    if(write(pfds[1], "x", 1) != 1)
    3904:	4605                	li	a2,1
    3906:	00002597          	auipc	a1,0x2
    390a:	d8258593          	addi	a1,a1,-638 # 5688 <malloc+0x1a0>
    390e:	fcc42503          	lw	a0,-52(s0)
    3912:	6f8010ef          	jal	500a <write>
    3916:	4785                	li	a5,1
    3918:	02f51163          	bne	a0,a5,393a <preempt+0xa8>
    close(pfds[1]);
    391c:	fcc42503          	lw	a0,-52(s0)
    3920:	6f2010ef          	jal	5012 <close>
    for(;;)
    3924:	a001                	j	3924 <preempt+0x92>
     printf("%s: fork failed\n", s);
    3926:	85ca                	mv	a1,s2
    3928:	00002517          	auipc	a0,0x2
    392c:	58050513          	addi	a0,a0,1408 # 5ea8 <malloc+0x9c0>
    3930:	301010ef          	jal	5430 <printf>
     exit(1);
    3934:	4505                	li	a0,1
    3936:	6b4010ef          	jal	4fea <exit>
      printf("%s: preempt write error", s);
    393a:	85ca                	mv	a1,s2
    393c:	00003517          	auipc	a0,0x3
    3940:	77450513          	addi	a0,a0,1908 # 70b0 <malloc+0x1bc8>
    3944:	2ed010ef          	jal	5430 <printf>
    3948:	bfd1                	j	391c <preempt+0x8a>
  close(pfds[1]);
    394a:	fcc42503          	lw	a0,-52(s0)
    394e:	6c4010ef          	jal	5012 <close>
  if(read(pfds[0], buf, sizeof(buf)) != 1){
    3952:	660d                	lui	a2,0x3
    3954:	0000a597          	auipc	a1,0xa
    3958:	36458593          	addi	a1,a1,868 # dcb8 <buf>
    395c:	fc842503          	lw	a0,-56(s0)
    3960:	6a2010ef          	jal	5002 <read>
    3964:	4785                	li	a5,1
    3966:	02f50163          	beq	a0,a5,3988 <preempt+0xf6>
    printf("%s: preempt read error", s);
    396a:	85ca                	mv	a1,s2
    396c:	00003517          	auipc	a0,0x3
    3970:	75c50513          	addi	a0,a0,1884 # 70c8 <malloc+0x1be0>
    3974:	2bd010ef          	jal	5430 <printf>
}
    3978:	70e2                	ld	ra,56(sp)
    397a:	7442                	ld	s0,48(sp)
    397c:	74a2                	ld	s1,40(sp)
    397e:	7902                	ld	s2,32(sp)
    3980:	69e2                	ld	s3,24(sp)
    3982:	6a42                	ld	s4,16(sp)
    3984:	6121                	addi	sp,sp,64
    3986:	8082                	ret
  close(pfds[0]);
    3988:	fc842503          	lw	a0,-56(s0)
    398c:	686010ef          	jal	5012 <close>
  printf("kill... ");
    3990:	00003517          	auipc	a0,0x3
    3994:	75050513          	addi	a0,a0,1872 # 70e0 <malloc+0x1bf8>
    3998:	299010ef          	jal	5430 <printf>
  kill(pid1);
    399c:	8526                	mv	a0,s1
    399e:	67c010ef          	jal	501a <kill>
  kill(pid2);
    39a2:	854e                	mv	a0,s3
    39a4:	676010ef          	jal	501a <kill>
  kill(pid3);
    39a8:	8552                	mv	a0,s4
    39aa:	670010ef          	jal	501a <kill>
  printf("wait... ");
    39ae:	00003517          	auipc	a0,0x3
    39b2:	74250513          	addi	a0,a0,1858 # 70f0 <malloc+0x1c08>
    39b6:	27b010ef          	jal	5430 <printf>
  wait(0);
    39ba:	4501                	li	a0,0
    39bc:	636010ef          	jal	4ff2 <wait>
  wait(0);
    39c0:	4501                	li	a0,0
    39c2:	630010ef          	jal	4ff2 <wait>
  wait(0);
    39c6:	4501                	li	a0,0
    39c8:	62a010ef          	jal	4ff2 <wait>
    39cc:	b775                	j	3978 <preempt+0xe6>

00000000000039ce <reparent>:
{
    39ce:	7179                	addi	sp,sp,-48
    39d0:	f406                	sd	ra,40(sp)
    39d2:	f022                	sd	s0,32(sp)
    39d4:	ec26                	sd	s1,24(sp)
    39d6:	e84a                	sd	s2,16(sp)
    39d8:	e44e                	sd	s3,8(sp)
    39da:	e052                	sd	s4,0(sp)
    39dc:	1800                	addi	s0,sp,48
    39de:	89aa                	mv	s3,a0
  int master_pid = getpid();
    39e0:	68a010ef          	jal	506a <getpid>
    39e4:	8a2a                	mv	s4,a0
    39e6:	0c800913          	li	s2,200
    int pid = fork();
    39ea:	5f8010ef          	jal	4fe2 <fork>
    39ee:	84aa                	mv	s1,a0
    if(pid < 0){
    39f0:	00054e63          	bltz	a0,3a0c <reparent+0x3e>
    if(pid){
    39f4:	c121                	beqz	a0,3a34 <reparent+0x66>
      if(wait(0) != pid){
    39f6:	4501                	li	a0,0
    39f8:	5fa010ef          	jal	4ff2 <wait>
    39fc:	02951263          	bne	a0,s1,3a20 <reparent+0x52>
  for(int i = 0; i < 200; i++){
    3a00:	397d                	addiw	s2,s2,-1
    3a02:	fe0914e3          	bnez	s2,39ea <reparent+0x1c>
  exit(0);
    3a06:	4501                	li	a0,0
    3a08:	5e2010ef          	jal	4fea <exit>
      printf("%s: fork failed\n", s);
    3a0c:	85ce                	mv	a1,s3
    3a0e:	00002517          	auipc	a0,0x2
    3a12:	49a50513          	addi	a0,a0,1178 # 5ea8 <malloc+0x9c0>
    3a16:	21b010ef          	jal	5430 <printf>
      exit(1);
    3a1a:	4505                	li	a0,1
    3a1c:	5ce010ef          	jal	4fea <exit>
        printf("%s: wait wrong pid\n", s);
    3a20:	85ce                	mv	a1,s3
    3a22:	00002517          	auipc	a0,0x2
    3a26:	60e50513          	addi	a0,a0,1550 # 6030 <malloc+0xb48>
    3a2a:	207010ef          	jal	5430 <printf>
        exit(1);
    3a2e:	4505                	li	a0,1
    3a30:	5ba010ef          	jal	4fea <exit>
      int pid2 = fork();
    3a34:	5ae010ef          	jal	4fe2 <fork>
      if(pid2 < 0){
    3a38:	00054563          	bltz	a0,3a42 <reparent+0x74>
      exit(0);
    3a3c:	4501                	li	a0,0
    3a3e:	5ac010ef          	jal	4fea <exit>
        kill(master_pid);
    3a42:	8552                	mv	a0,s4
    3a44:	5d6010ef          	jal	501a <kill>
        exit(1);
    3a48:	4505                	li	a0,1
    3a4a:	5a0010ef          	jal	4fea <exit>

0000000000003a4e <sbrkfail>:
{
    3a4e:	7175                	addi	sp,sp,-144
    3a50:	e506                	sd	ra,136(sp)
    3a52:	e122                	sd	s0,128(sp)
    3a54:	fca6                	sd	s1,120(sp)
    3a56:	f8ca                	sd	s2,112(sp)
    3a58:	f4ce                	sd	s3,104(sp)
    3a5a:	f0d2                	sd	s4,96(sp)
    3a5c:	ecd6                	sd	s5,88(sp)
    3a5e:	e8da                	sd	s6,80(sp)
    3a60:	e4de                	sd	s7,72(sp)
    3a62:	e0e2                	sd	s8,64(sp)
    3a64:	0900                	addi	s0,sp,144
    3a66:	8c2a                	mv	s8,a0
  if(pipe(fds) != 0){
    3a68:	fa040513          	addi	a0,s0,-96
    3a6c:	58e010ef          	jal	4ffa <pipe>
    3a70:	ed01                	bnez	a0,3a88 <sbrkfail+0x3a>
    3a72:	8baa                	mv	s7,a0
    3a74:	f7040493          	addi	s1,s0,-144
    3a78:	f9840993          	addi	s3,s0,-104
    3a7c:	8926                	mv	s2,s1
    if(pids[i] != -1) {
    3a7e:	5a7d                	li	s4,-1
      read(fds[0], &scratch, 1);
    3a80:	f9f40b13          	addi	s6,s0,-97
    3a84:	4a85                	li	s5,1
    3a86:	a095                	j	3aea <sbrkfail+0x9c>
    printf("%s: pipe() failed\n", s);
    3a88:	85e2                	mv	a1,s8
    3a8a:	00002517          	auipc	a0,0x2
    3a8e:	52650513          	addi	a0,a0,1318 # 5fb0 <malloc+0xac8>
    3a92:	19f010ef          	jal	5430 <printf>
    exit(1);
    3a96:	4505                	li	a0,1
    3a98:	552010ef          	jal	4fea <exit>
      if (sbrk(BIG - (uint64)sbrk(0)) ==  (char*)SBRK_ERROR)
    3a9c:	51a010ef          	jal	4fb6 <sbrk>
    3aa0:	064007b7          	lui	a5,0x6400
    3aa4:	40a7853b          	subw	a0,a5,a0
    3aa8:	50e010ef          	jal	4fb6 <sbrk>
    3aac:	57fd                	li	a5,-1
    3aae:	02f50163          	beq	a0,a5,3ad0 <sbrkfail+0x82>
        write(fds[1], "1", 1);
    3ab2:	4605                	li	a2,1
    3ab4:	00004597          	auipc	a1,0x4
    3ab8:	dc458593          	addi	a1,a1,-572 # 7878 <malloc+0x2390>
    3abc:	fa442503          	lw	a0,-92(s0)
    3ac0:	54a010ef          	jal	500a <write>
      for(;;) pause(1000);
    3ac4:	3e800493          	li	s1,1000
    3ac8:	8526                	mv	a0,s1
    3aca:	5b0010ef          	jal	507a <pause>
    3ace:	bfed                	j	3ac8 <sbrkfail+0x7a>
        write(fds[1], "0", 1);
    3ad0:	4605                	li	a2,1
    3ad2:	00003597          	auipc	a1,0x3
    3ad6:	62e58593          	addi	a1,a1,1582 # 7100 <malloc+0x1c18>
    3ada:	fa442503          	lw	a0,-92(s0)
    3ade:	52c010ef          	jal	500a <write>
    3ae2:	b7cd                	j	3ac4 <sbrkfail+0x76>
  for(i = 0; i < sizeof(pids)/sizeof(pids[0]); i++){
    3ae4:	0911                	addi	s2,s2,4
    3ae6:	03390a63          	beq	s2,s3,3b1a <sbrkfail+0xcc>
    if((pids[i] = fork()) == 0){
    3aea:	4f8010ef          	jal	4fe2 <fork>
    3aee:	00a92023          	sw	a0,0(s2)
    3af2:	d54d                	beqz	a0,3a9c <sbrkfail+0x4e>
    if(pids[i] != -1) {
    3af4:	ff4508e3          	beq	a0,s4,3ae4 <sbrkfail+0x96>
      read(fds[0], &scratch, 1);
    3af8:	8656                	mv	a2,s5
    3afa:	85da                	mv	a1,s6
    3afc:	fa042503          	lw	a0,-96(s0)
    3b00:	502010ef          	jal	5002 <read>
      if(scratch == '0')
    3b04:	f9f44783          	lbu	a5,-97(s0)
    3b08:	fd078793          	addi	a5,a5,-48 # 63fffd0 <base+0x63ef318>
    3b0c:	0017b793          	seqz	a5,a5
    3b10:	00fbe7b3          	or	a5,s7,a5
    3b14:	00078b9b          	sext.w	s7,a5
    3b18:	b7f1                	j	3ae4 <sbrkfail+0x96>
  if(!failed) {
    3b1a:	000b8863          	beqz	s7,3b2a <sbrkfail+0xdc>
  c = sbrk(PGSIZE);
    3b1e:	6505                	lui	a0,0x1
    3b20:	496010ef          	jal	4fb6 <sbrk>
    3b24:	8a2a                	mv	s4,a0
    if(pids[i] == -1)
    3b26:	597d                	li	s2,-1
    3b28:	a821                	j	3b40 <sbrkfail+0xf2>
    printf("%s: no allocation failed; allocate more?\n", s);
    3b2a:	85e2                	mv	a1,s8
    3b2c:	00003517          	auipc	a0,0x3
    3b30:	5dc50513          	addi	a0,a0,1500 # 7108 <malloc+0x1c20>
    3b34:	0fd010ef          	jal	5430 <printf>
    3b38:	b7dd                	j	3b1e <sbrkfail+0xd0>
  for(i = 0; i < sizeof(pids)/sizeof(pids[0]); i++){
    3b3a:	0491                	addi	s1,s1,4
    3b3c:	01348b63          	beq	s1,s3,3b52 <sbrkfail+0x104>
    if(pids[i] == -1)
    3b40:	4088                	lw	a0,0(s1)
    3b42:	ff250ce3          	beq	a0,s2,3b3a <sbrkfail+0xec>
    kill(pids[i]);
    3b46:	4d4010ef          	jal	501a <kill>
    wait(0);
    3b4a:	4501                	li	a0,0
    3b4c:	4a6010ef          	jal	4ff2 <wait>
    3b50:	b7ed                	j	3b3a <sbrkfail+0xec>
  if(c == (char*)SBRK_ERROR){
    3b52:	57fd                	li	a5,-1
    3b54:	02fa0a63          	beq	s4,a5,3b88 <sbrkfail+0x13a>
  pid = fork();
    3b58:	48a010ef          	jal	4fe2 <fork>
  if(pid < 0){
    3b5c:	04054063          	bltz	a0,3b9c <sbrkfail+0x14e>
  if(pid == 0){
    3b60:	e939                	bnez	a0,3bb6 <sbrkfail+0x168>
    a = sbrk(10*BIG);
    3b62:	3e800537          	lui	a0,0x3e800
    3b66:	450010ef          	jal	4fb6 <sbrk>
    if(a == (char*)SBRK_ERROR){
    3b6a:	57fd                	li	a5,-1
    3b6c:	04f50263          	beq	a0,a5,3bb0 <sbrkfail+0x162>
    printf("%s: allocate a lot of memory succeeded %d\n", s, 10*BIG);
    3b70:	3e800637          	lui	a2,0x3e800
    3b74:	85e2                	mv	a1,s8
    3b76:	00003517          	auipc	a0,0x3
    3b7a:	5e250513          	addi	a0,a0,1506 # 7158 <malloc+0x1c70>
    3b7e:	0b3010ef          	jal	5430 <printf>
    exit(1);
    3b82:	4505                	li	a0,1
    3b84:	466010ef          	jal	4fea <exit>
    printf("%s: failed sbrk leaked memory\n", s);
    3b88:	85e2                	mv	a1,s8
    3b8a:	00003517          	auipc	a0,0x3
    3b8e:	5ae50513          	addi	a0,a0,1454 # 7138 <malloc+0x1c50>
    3b92:	09f010ef          	jal	5430 <printf>
    exit(1);
    3b96:	4505                	li	a0,1
    3b98:	452010ef          	jal	4fea <exit>
    printf("%s: fork failed\n", s);
    3b9c:	85e2                	mv	a1,s8
    3b9e:	00002517          	auipc	a0,0x2
    3ba2:	30a50513          	addi	a0,a0,778 # 5ea8 <malloc+0x9c0>
    3ba6:	08b010ef          	jal	5430 <printf>
    exit(1);
    3baa:	4505                	li	a0,1
    3bac:	43e010ef          	jal	4fea <exit>
      exit(0);
    3bb0:	4501                	li	a0,0
    3bb2:	438010ef          	jal	4fea <exit>
  wait(&xstatus);
    3bb6:	fac40513          	addi	a0,s0,-84
    3bba:	438010ef          	jal	4ff2 <wait>
  if(xstatus != 0)
    3bbe:	fac42783          	lw	a5,-84(s0)
    3bc2:	ef89                	bnez	a5,3bdc <sbrkfail+0x18e>
}
    3bc4:	60aa                	ld	ra,136(sp)
    3bc6:	640a                	ld	s0,128(sp)
    3bc8:	74e6                	ld	s1,120(sp)
    3bca:	7946                	ld	s2,112(sp)
    3bcc:	79a6                	ld	s3,104(sp)
    3bce:	7a06                	ld	s4,96(sp)
    3bd0:	6ae6                	ld	s5,88(sp)
    3bd2:	6b46                	ld	s6,80(sp)
    3bd4:	6ba6                	ld	s7,72(sp)
    3bd6:	6c06                	ld	s8,64(sp)
    3bd8:	6149                	addi	sp,sp,144
    3bda:	8082                	ret
    exit(1);
    3bdc:	4505                	li	a0,1
    3bde:	40c010ef          	jal	4fea <exit>

0000000000003be2 <mem>:
{
    3be2:	7139                	addi	sp,sp,-64
    3be4:	fc06                	sd	ra,56(sp)
    3be6:	f822                	sd	s0,48(sp)
    3be8:	f426                	sd	s1,40(sp)
    3bea:	f04a                	sd	s2,32(sp)
    3bec:	ec4e                	sd	s3,24(sp)
    3bee:	0080                	addi	s0,sp,64
    3bf0:	89aa                	mv	s3,a0
  if((pid = fork()) == 0){
    3bf2:	3f0010ef          	jal	4fe2 <fork>
    m1 = 0;
    3bf6:	4481                	li	s1,0
    while((m2 = malloc(10001)) != 0){
    3bf8:	6909                	lui	s2,0x2
    3bfa:	71190913          	addi	s2,s2,1809 # 2711 <execout+0x27>
  if((pid = fork()) == 0){
    3bfe:	cd11                	beqz	a0,3c1a <mem+0x38>
    wait(&xstatus);
    3c00:	fcc40513          	addi	a0,s0,-52
    3c04:	3ee010ef          	jal	4ff2 <wait>
    if(xstatus == -1){
    3c08:	fcc42503          	lw	a0,-52(s0)
    3c0c:	57fd                	li	a5,-1
    3c0e:	04f50363          	beq	a0,a5,3c54 <mem+0x72>
    exit(xstatus);
    3c12:	3d8010ef          	jal	4fea <exit>
      *(char**)m2 = m1;
    3c16:	e104                	sd	s1,0(a0)
      m1 = m2;
    3c18:	84aa                	mv	s1,a0
    while((m2 = malloc(10001)) != 0){
    3c1a:	854a                	mv	a0,s2
    3c1c:	0cd010ef          	jal	54e8 <malloc>
    3c20:	f97d                	bnez	a0,3c16 <mem+0x34>
    while(m1){
    3c22:	c491                	beqz	s1,3c2e <mem+0x4c>
      m2 = *(char**)m1;
    3c24:	8526                	mv	a0,s1
    3c26:	6084                	ld	s1,0(s1)
      free(m1);
    3c28:	03b010ef          	jal	5462 <free>
    while(m1){
    3c2c:	fce5                	bnez	s1,3c24 <mem+0x42>
    m1 = malloc(1024*20);
    3c2e:	6515                	lui	a0,0x5
    3c30:	0b9010ef          	jal	54e8 <malloc>
    if(m1 == 0){
    3c34:	c511                	beqz	a0,3c40 <mem+0x5e>
    free(m1);
    3c36:	02d010ef          	jal	5462 <free>
    exit(0);
    3c3a:	4501                	li	a0,0
    3c3c:	3ae010ef          	jal	4fea <exit>
      printf("%s: couldn't allocate mem?!!\n", s);
    3c40:	85ce                	mv	a1,s3
    3c42:	00003517          	auipc	a0,0x3
    3c46:	54650513          	addi	a0,a0,1350 # 7188 <malloc+0x1ca0>
    3c4a:	7e6010ef          	jal	5430 <printf>
      exit(1);
    3c4e:	4505                	li	a0,1
    3c50:	39a010ef          	jal	4fea <exit>
      exit(0);
    3c54:	4501                	li	a0,0
    3c56:	394010ef          	jal	4fea <exit>

0000000000003c5a <sharedfd>:
{
    3c5a:	7159                	addi	sp,sp,-112
    3c5c:	f486                	sd	ra,104(sp)
    3c5e:	f0a2                	sd	s0,96(sp)
    3c60:	eca6                	sd	s1,88(sp)
    3c62:	f85a                	sd	s6,48(sp)
    3c64:	1880                	addi	s0,sp,112
    3c66:	84aa                	mv	s1,a0
    3c68:	8b2a                	mv	s6,a0
  unlink("sharedfd");
    3c6a:	00003517          	auipc	a0,0x3
    3c6e:	53e50513          	addi	a0,a0,1342 # 71a8 <malloc+0x1cc0>
    3c72:	3c8010ef          	jal	503a <unlink>
  fd = open("sharedfd", O_CREATE|O_RDWR);
    3c76:	20200593          	li	a1,514
    3c7a:	00003517          	auipc	a0,0x3
    3c7e:	52e50513          	addi	a0,a0,1326 # 71a8 <malloc+0x1cc0>
    3c82:	3a8010ef          	jal	502a <open>
  if(fd < 0){
    3c86:	04054863          	bltz	a0,3cd6 <sharedfd+0x7c>
    3c8a:	e8ca                	sd	s2,80(sp)
    3c8c:	e4ce                	sd	s3,72(sp)
    3c8e:	e0d2                	sd	s4,64(sp)
    3c90:	fc56                	sd	s5,56(sp)
    3c92:	89aa                	mv	s3,a0
  pid = fork();
    3c94:	34e010ef          	jal	4fe2 <fork>
    3c98:	8aaa                	mv	s5,a0
  memset(buf, pid==0?'c':'p', sizeof(buf));
    3c9a:	07000593          	li	a1,112
    3c9e:	e119                	bnez	a0,3ca4 <sharedfd+0x4a>
    3ca0:	06300593          	li	a1,99
    3ca4:	4629                	li	a2,10
    3ca6:	fa040513          	addi	a0,s0,-96
    3caa:	116010ef          	jal	4dc0 <memset>
    3cae:	3e800493          	li	s1,1000
    if(write(fd, buf, sizeof(buf)) != sizeof(buf)){
    3cb2:	fa040a13          	addi	s4,s0,-96
    3cb6:	4929                	li	s2,10
    3cb8:	864a                	mv	a2,s2
    3cba:	85d2                	mv	a1,s4
    3cbc:	854e                	mv	a0,s3
    3cbe:	34c010ef          	jal	500a <write>
    3cc2:	03251963          	bne	a0,s2,3cf4 <sharedfd+0x9a>
  for(i = 0; i < N; i++){
    3cc6:	34fd                	addiw	s1,s1,-1
    3cc8:	f8e5                	bnez	s1,3cb8 <sharedfd+0x5e>
  if(pid == 0) {
    3cca:	040a9063          	bnez	s5,3d0a <sharedfd+0xb0>
    3cce:	f45e                	sd	s7,40(sp)
    exit(0);
    3cd0:	4501                	li	a0,0
    3cd2:	318010ef          	jal	4fea <exit>
    3cd6:	e8ca                	sd	s2,80(sp)
    3cd8:	e4ce                	sd	s3,72(sp)
    3cda:	e0d2                	sd	s4,64(sp)
    3cdc:	fc56                	sd	s5,56(sp)
    3cde:	f45e                	sd	s7,40(sp)
    printf("%s: cannot open sharedfd for writing", s);
    3ce0:	85a6                	mv	a1,s1
    3ce2:	00003517          	auipc	a0,0x3
    3ce6:	4d650513          	addi	a0,a0,1238 # 71b8 <malloc+0x1cd0>
    3cea:	746010ef          	jal	5430 <printf>
    exit(1);
    3cee:	4505                	li	a0,1
    3cf0:	2fa010ef          	jal	4fea <exit>
    3cf4:	f45e                	sd	s7,40(sp)
      printf("%s: write sharedfd failed\n", s);
    3cf6:	85da                	mv	a1,s6
    3cf8:	00003517          	auipc	a0,0x3
    3cfc:	4e850513          	addi	a0,a0,1256 # 71e0 <malloc+0x1cf8>
    3d00:	730010ef          	jal	5430 <printf>
      exit(1);
    3d04:	4505                	li	a0,1
    3d06:	2e4010ef          	jal	4fea <exit>
    wait(&xstatus);
    3d0a:	f9c40513          	addi	a0,s0,-100
    3d0e:	2e4010ef          	jal	4ff2 <wait>
    if(xstatus != 0)
    3d12:	f9c42a03          	lw	s4,-100(s0)
    3d16:	000a0663          	beqz	s4,3d22 <sharedfd+0xc8>
    3d1a:	f45e                	sd	s7,40(sp)
      exit(xstatus);
    3d1c:	8552                	mv	a0,s4
    3d1e:	2cc010ef          	jal	4fea <exit>
    3d22:	f45e                	sd	s7,40(sp)
  close(fd);
    3d24:	854e                	mv	a0,s3
    3d26:	2ec010ef          	jal	5012 <close>
  fd = open("sharedfd", 0);
    3d2a:	4581                	li	a1,0
    3d2c:	00003517          	auipc	a0,0x3
    3d30:	47c50513          	addi	a0,a0,1148 # 71a8 <malloc+0x1cc0>
    3d34:	2f6010ef          	jal	502a <open>
    3d38:	8baa                	mv	s7,a0
  nc = np = 0;
    3d3a:	89d2                	mv	s3,s4
  if(fd < 0){
    3d3c:	02054363          	bltz	a0,3d62 <sharedfd+0x108>
    3d40:	faa40913          	addi	s2,s0,-86
      if(buf[i] == 'c')
    3d44:	06300493          	li	s1,99
      if(buf[i] == 'p')
    3d48:	07000a93          	li	s5,112
  while((n = read(fd, buf, sizeof(buf))) > 0){
    3d4c:	4629                	li	a2,10
    3d4e:	fa040593          	addi	a1,s0,-96
    3d52:	855e                	mv	a0,s7
    3d54:	2ae010ef          	jal	5002 <read>
    3d58:	02a05b63          	blez	a0,3d8e <sharedfd+0x134>
    3d5c:	fa040793          	addi	a5,s0,-96
    3d60:	a839                	j	3d7e <sharedfd+0x124>
    printf("%s: cannot open sharedfd for reading\n", s);
    3d62:	85da                	mv	a1,s6
    3d64:	00003517          	auipc	a0,0x3
    3d68:	49c50513          	addi	a0,a0,1180 # 7200 <malloc+0x1d18>
    3d6c:	6c4010ef          	jal	5430 <printf>
    exit(1);
    3d70:	4505                	li	a0,1
    3d72:	278010ef          	jal	4fea <exit>
        nc++;
    3d76:	2a05                	addiw	s4,s4,1
    for(i = 0; i < sizeof(buf); i++){
    3d78:	0785                	addi	a5,a5,1
    3d7a:	fd2789e3          	beq	a5,s2,3d4c <sharedfd+0xf2>
      if(buf[i] == 'c')
    3d7e:	0007c703          	lbu	a4,0(a5)
    3d82:	fe970ae3          	beq	a4,s1,3d76 <sharedfd+0x11c>
      if(buf[i] == 'p')
    3d86:	ff5719e3          	bne	a4,s5,3d78 <sharedfd+0x11e>
        np++;
    3d8a:	2985                	addiw	s3,s3,1
    3d8c:	b7f5                	j	3d78 <sharedfd+0x11e>
  close(fd);
    3d8e:	855e                	mv	a0,s7
    3d90:	282010ef          	jal	5012 <close>
  unlink("sharedfd");
    3d94:	00003517          	auipc	a0,0x3
    3d98:	41450513          	addi	a0,a0,1044 # 71a8 <malloc+0x1cc0>
    3d9c:	29e010ef          	jal	503a <unlink>
  if(nc == N*SZ && np == N*SZ){
    3da0:	6789                	lui	a5,0x2
    3da2:	71078793          	addi	a5,a5,1808 # 2710 <execout+0x26>
    3da6:	00fa1763          	bne	s4,a5,3db4 <sharedfd+0x15a>
    3daa:	01499563          	bne	s3,s4,3db4 <sharedfd+0x15a>
    exit(0);
    3dae:	4501                	li	a0,0
    3db0:	23a010ef          	jal	4fea <exit>
    printf("%s: nc/np test fails\n", s);
    3db4:	85da                	mv	a1,s6
    3db6:	00003517          	auipc	a0,0x3
    3dba:	47250513          	addi	a0,a0,1138 # 7228 <malloc+0x1d40>
    3dbe:	672010ef          	jal	5430 <printf>
    exit(1);
    3dc2:	4505                	li	a0,1
    3dc4:	226010ef          	jal	4fea <exit>

0000000000003dc8 <fourfiles>:
{
    3dc8:	7135                	addi	sp,sp,-160
    3dca:	ed06                	sd	ra,152(sp)
    3dcc:	e922                	sd	s0,144(sp)
    3dce:	e526                	sd	s1,136(sp)
    3dd0:	e14a                	sd	s2,128(sp)
    3dd2:	fcce                	sd	s3,120(sp)
    3dd4:	f8d2                	sd	s4,112(sp)
    3dd6:	f4d6                	sd	s5,104(sp)
    3dd8:	f0da                	sd	s6,96(sp)
    3dda:	ecde                	sd	s7,88(sp)
    3ddc:	e8e2                	sd	s8,80(sp)
    3dde:	e4e6                	sd	s9,72(sp)
    3de0:	e0ea                	sd	s10,64(sp)
    3de2:	fc6e                	sd	s11,56(sp)
    3de4:	1100                	addi	s0,sp,160
    3de6:	8caa                	mv	s9,a0
  char *names[] = { "f0", "f1", "f2", "f3" };
    3de8:	00003797          	auipc	a5,0x3
    3dec:	45878793          	addi	a5,a5,1112 # 7240 <malloc+0x1d58>
    3df0:	f6f43823          	sd	a5,-144(s0)
    3df4:	00003797          	auipc	a5,0x3
    3df8:	45478793          	addi	a5,a5,1108 # 7248 <malloc+0x1d60>
    3dfc:	f6f43c23          	sd	a5,-136(s0)
    3e00:	00003797          	auipc	a5,0x3
    3e04:	45078793          	addi	a5,a5,1104 # 7250 <malloc+0x1d68>
    3e08:	f8f43023          	sd	a5,-128(s0)
    3e0c:	00003797          	auipc	a5,0x3
    3e10:	44c78793          	addi	a5,a5,1100 # 7258 <malloc+0x1d70>
    3e14:	f8f43423          	sd	a5,-120(s0)
  for(pi = 0; pi < NCHILD; pi++){
    3e18:	f7040b93          	addi	s7,s0,-144
  char *names[] = { "f0", "f1", "f2", "f3" };
    3e1c:	895e                	mv	s2,s7
  for(pi = 0; pi < NCHILD; pi++){
    3e1e:	4481                	li	s1,0
    3e20:	4a11                	li	s4,4
    fname = names[pi];
    3e22:	00093983          	ld	s3,0(s2)
    unlink(fname);
    3e26:	854e                	mv	a0,s3
    3e28:	212010ef          	jal	503a <unlink>
    pid = fork();
    3e2c:	1b6010ef          	jal	4fe2 <fork>
    if(pid < 0){
    3e30:	04054063          	bltz	a0,3e70 <fourfiles+0xa8>
    if(pid == 0){
    3e34:	c921                	beqz	a0,3e84 <fourfiles+0xbc>
  for(pi = 0; pi < NCHILD; pi++){
    3e36:	2485                	addiw	s1,s1,1
    3e38:	0921                	addi	s2,s2,8
    3e3a:	ff4494e3          	bne	s1,s4,3e22 <fourfiles+0x5a>
    3e3e:	4491                	li	s1,4
    wait(&xstatus);
    3e40:	f6c40913          	addi	s2,s0,-148
    3e44:	854a                	mv	a0,s2
    3e46:	1ac010ef          	jal	4ff2 <wait>
    if(xstatus != 0)
    3e4a:	f6c42b03          	lw	s6,-148(s0)
    3e4e:	0a0b1463          	bnez	s6,3ef6 <fourfiles+0x12e>
  for(pi = 0; pi < NCHILD; pi++){
    3e52:	34fd                	addiw	s1,s1,-1
    3e54:	f8e5                	bnez	s1,3e44 <fourfiles+0x7c>
    3e56:	03000493          	li	s1,48
    while((n = read(fd, buf, sizeof(buf))) > 0){
    3e5a:	6a8d                	lui	s5,0x3
    3e5c:	0000aa17          	auipc	s4,0xa
    3e60:	e5ca0a13          	addi	s4,s4,-420 # dcb8 <buf>
    if(total != N*SZ){
    3e64:	6d05                	lui	s10,0x1
    3e66:	770d0d13          	addi	s10,s10,1904 # 1770 <exitwait+0x90>
  for(i = 0; i < NCHILD; i++){
    3e6a:	03400d93          	li	s11,52
    3e6e:	a86d                	j	3f28 <fourfiles+0x160>
      printf("%s: fork failed\n", s);
    3e70:	85e6                	mv	a1,s9
    3e72:	00002517          	auipc	a0,0x2
    3e76:	03650513          	addi	a0,a0,54 # 5ea8 <malloc+0x9c0>
    3e7a:	5b6010ef          	jal	5430 <printf>
      exit(1);
    3e7e:	4505                	li	a0,1
    3e80:	16a010ef          	jal	4fea <exit>
      fd = open(fname, O_CREATE | O_RDWR);
    3e84:	20200593          	li	a1,514
    3e88:	854e                	mv	a0,s3
    3e8a:	1a0010ef          	jal	502a <open>
    3e8e:	892a                	mv	s2,a0
      if(fd < 0){
    3e90:	04054063          	bltz	a0,3ed0 <fourfiles+0x108>
      memset(buf, '0'+pi, SZ);
    3e94:	1f400613          	li	a2,500
    3e98:	0304859b          	addiw	a1,s1,48
    3e9c:	0000a517          	auipc	a0,0xa
    3ea0:	e1c50513          	addi	a0,a0,-484 # dcb8 <buf>
    3ea4:	71d000ef          	jal	4dc0 <memset>
    3ea8:	44b1                	li	s1,12
        if((n = write(fd, buf, SZ)) != SZ){
    3eaa:	1f400993          	li	s3,500
    3eae:	0000aa17          	auipc	s4,0xa
    3eb2:	e0aa0a13          	addi	s4,s4,-502 # dcb8 <buf>
    3eb6:	864e                	mv	a2,s3
    3eb8:	85d2                	mv	a1,s4
    3eba:	854a                	mv	a0,s2
    3ebc:	14e010ef          	jal	500a <write>
    3ec0:	85aa                	mv	a1,a0
    3ec2:	03351163          	bne	a0,s3,3ee4 <fourfiles+0x11c>
      for(i = 0; i < N; i++){
    3ec6:	34fd                	addiw	s1,s1,-1
    3ec8:	f4fd                	bnez	s1,3eb6 <fourfiles+0xee>
      exit(0);
    3eca:	4501                	li	a0,0
    3ecc:	11e010ef          	jal	4fea <exit>
        printf("%s: create failed\n", s);
    3ed0:	85e6                	mv	a1,s9
    3ed2:	00002517          	auipc	a0,0x2
    3ed6:	06e50513          	addi	a0,a0,110 # 5f40 <malloc+0xa58>
    3eda:	556010ef          	jal	5430 <printf>
        exit(1);
    3ede:	4505                	li	a0,1
    3ee0:	10a010ef          	jal	4fea <exit>
          printf("write failed %d\n", n);
    3ee4:	00003517          	auipc	a0,0x3
    3ee8:	37c50513          	addi	a0,a0,892 # 7260 <malloc+0x1d78>
    3eec:	544010ef          	jal	5430 <printf>
          exit(1);
    3ef0:	4505                	li	a0,1
    3ef2:	0f8010ef          	jal	4fea <exit>
      exit(xstatus);
    3ef6:	855a                	mv	a0,s6
    3ef8:	0f2010ef          	jal	4fea <exit>
          printf("%s: wrong char\n", s);
    3efc:	85e6                	mv	a1,s9
    3efe:	00003517          	auipc	a0,0x3
    3f02:	37a50513          	addi	a0,a0,890 # 7278 <malloc+0x1d90>
    3f06:	52a010ef          	jal	5430 <printf>
          exit(1);
    3f0a:	4505                	li	a0,1
    3f0c:	0de010ef          	jal	4fea <exit>
    close(fd);
    3f10:	854e                	mv	a0,s3
    3f12:	100010ef          	jal	5012 <close>
    if(total != N*SZ){
    3f16:	05a91863          	bne	s2,s10,3f66 <fourfiles+0x19e>
    unlink(fname);
    3f1a:	8562                	mv	a0,s8
    3f1c:	11e010ef          	jal	503a <unlink>
  for(i = 0; i < NCHILD; i++){
    3f20:	0ba1                	addi	s7,s7,8
    3f22:	2485                	addiw	s1,s1,1
    3f24:	05b48b63          	beq	s1,s11,3f7a <fourfiles+0x1b2>
    fname = names[i];
    3f28:	000bbc03          	ld	s8,0(s7)
    fd = open(fname, 0);
    3f2c:	4581                	li	a1,0
    3f2e:	8562                	mv	a0,s8
    3f30:	0fa010ef          	jal	502a <open>
    3f34:	89aa                	mv	s3,a0
    total = 0;
    3f36:	895a                	mv	s2,s6
    while((n = read(fd, buf, sizeof(buf))) > 0){
    3f38:	8656                	mv	a2,s5
    3f3a:	85d2                	mv	a1,s4
    3f3c:	854e                	mv	a0,s3
    3f3e:	0c4010ef          	jal	5002 <read>
    3f42:	fca057e3          	blez	a0,3f10 <fourfiles+0x148>
    3f46:	0000a797          	auipc	a5,0xa
    3f4a:	d7278793          	addi	a5,a5,-654 # dcb8 <buf>
    3f4e:	00f506b3          	add	a3,a0,a5
        if(buf[j] != '0'+i){
    3f52:	0007c703          	lbu	a4,0(a5)
    3f56:	fa9713e3          	bne	a4,s1,3efc <fourfiles+0x134>
      for(j = 0; j < n; j++){
    3f5a:	0785                	addi	a5,a5,1
    3f5c:	fed79be3          	bne	a5,a3,3f52 <fourfiles+0x18a>
      total += n;
    3f60:	00a9093b          	addw	s2,s2,a0
    3f64:	bfd1                	j	3f38 <fourfiles+0x170>
      printf("wrong length %d\n", total);
    3f66:	85ca                	mv	a1,s2
    3f68:	00003517          	auipc	a0,0x3
    3f6c:	32050513          	addi	a0,a0,800 # 7288 <malloc+0x1da0>
    3f70:	4c0010ef          	jal	5430 <printf>
      exit(1);
    3f74:	4505                	li	a0,1
    3f76:	074010ef          	jal	4fea <exit>
}
    3f7a:	60ea                	ld	ra,152(sp)
    3f7c:	644a                	ld	s0,144(sp)
    3f7e:	64aa                	ld	s1,136(sp)
    3f80:	690a                	ld	s2,128(sp)
    3f82:	79e6                	ld	s3,120(sp)
    3f84:	7a46                	ld	s4,112(sp)
    3f86:	7aa6                	ld	s5,104(sp)
    3f88:	7b06                	ld	s6,96(sp)
    3f8a:	6be6                	ld	s7,88(sp)
    3f8c:	6c46                	ld	s8,80(sp)
    3f8e:	6ca6                	ld	s9,72(sp)
    3f90:	6d06                	ld	s10,64(sp)
    3f92:	7de2                	ld	s11,56(sp)
    3f94:	610d                	addi	sp,sp,160
    3f96:	8082                	ret

0000000000003f98 <concreate>:
{
    3f98:	7171                	addi	sp,sp,-176
    3f9a:	f506                	sd	ra,168(sp)
    3f9c:	f122                	sd	s0,160(sp)
    3f9e:	ed26                	sd	s1,152(sp)
    3fa0:	e94a                	sd	s2,144(sp)
    3fa2:	e54e                	sd	s3,136(sp)
    3fa4:	e152                	sd	s4,128(sp)
    3fa6:	fcd6                	sd	s5,120(sp)
    3fa8:	f8da                	sd	s6,112(sp)
    3faa:	f4de                	sd	s7,104(sp)
    3fac:	f0e2                	sd	s8,96(sp)
    3fae:	ece6                	sd	s9,88(sp)
    3fb0:	e8ea                	sd	s10,80(sp)
    3fb2:	1900                	addi	s0,sp,176
    3fb4:	8d2a                	mv	s10,a0
  file[0] = 'C';
    3fb6:	04300793          	li	a5,67
    3fba:	f8f40c23          	sb	a5,-104(s0)
  file[2] = '\0';
    3fbe:	f8040d23          	sb	zero,-102(s0)
  for(i = 0; i < N; i++){
    3fc2:	4901                	li	s2,0
    unlink(file);
    3fc4:	f9840993          	addi	s3,s0,-104
    if(pid && (i % 3) == 1){
    3fc8:	55555b37          	lui	s6,0x55555
    3fcc:	556b0b13          	addi	s6,s6,1366 # 55555556 <base+0x5554489e>
    3fd0:	4b85                	li	s7,1
      fd = open(file, O_CREATE | O_RDWR);
    3fd2:	20200c13          	li	s8,514
      link("C0", file);
    3fd6:	00003c97          	auipc	s9,0x3
    3fda:	2cac8c93          	addi	s9,s9,714 # 72a0 <malloc+0x1db8>
      wait(&xstatus);
    3fde:	f5c40a93          	addi	s5,s0,-164
  for(i = 0; i < N; i++){
    3fe2:	02800a13          	li	s4,40
    3fe6:	ac25                	j	421e <concreate+0x286>
      link("C0", file);
    3fe8:	85ce                	mv	a1,s3
    3fea:	8566                	mv	a0,s9
    3fec:	05e010ef          	jal	504a <link>
    if(pid == 0) {
    3ff0:	ac29                	j	420a <concreate+0x272>
    } else if(pid == 0 && (i % 5) == 1){
    3ff2:	666667b7          	lui	a5,0x66666
    3ff6:	66778793          	addi	a5,a5,1639 # 66666667 <base+0x666559af>
    3ffa:	02f907b3          	mul	a5,s2,a5
    3ffe:	9785                	srai	a5,a5,0x21
    4000:	41f9571b          	sraiw	a4,s2,0x1f
    4004:	9f99                	subw	a5,a5,a4
    4006:	0027971b          	slliw	a4,a5,0x2
    400a:	9fb9                	addw	a5,a5,a4
    400c:	40f9093b          	subw	s2,s2,a5
    4010:	4785                	li	a5,1
    4012:	02f90563          	beq	s2,a5,403c <concreate+0xa4>
      fd = open(file, O_CREATE | O_RDWR);
    4016:	20200593          	li	a1,514
    401a:	f9840513          	addi	a0,s0,-104
    401e:	00c010ef          	jal	502a <open>
      if(fd < 0){
    4022:	1c055f63          	bgez	a0,4200 <concreate+0x268>
        printf("concreate create %s failed\n", file);
    4026:	f9840593          	addi	a1,s0,-104
    402a:	00003517          	auipc	a0,0x3
    402e:	27e50513          	addi	a0,a0,638 # 72a8 <malloc+0x1dc0>
    4032:	3fe010ef          	jal	5430 <printf>
        exit(1);
    4036:	4505                	li	a0,1
    4038:	7b3000ef          	jal	4fea <exit>
      link("C0", file);
    403c:	f9840593          	addi	a1,s0,-104
    4040:	00003517          	auipc	a0,0x3
    4044:	26050513          	addi	a0,a0,608 # 72a0 <malloc+0x1db8>
    4048:	002010ef          	jal	504a <link>
      exit(0);
    404c:	4501                	li	a0,0
    404e:	79d000ef          	jal	4fea <exit>
        exit(1);
    4052:	4505                	li	a0,1
    4054:	797000ef          	jal	4fea <exit>
  memset(fa, 0, sizeof(fa));
    4058:	02800613          	li	a2,40
    405c:	4581                	li	a1,0
    405e:	f7040513          	addi	a0,s0,-144
    4062:	55f000ef          	jal	4dc0 <memset>
  fd = open(".", 0);
    4066:	4581                	li	a1,0
    4068:	00002517          	auipc	a0,0x2
    406c:	c9850513          	addi	a0,a0,-872 # 5d00 <malloc+0x818>
    4070:	7bb000ef          	jal	502a <open>
    4074:	892a                	mv	s2,a0
  n = 0;
    4076:	8b26                	mv	s6,s1
  while(read(fd, &de, sizeof(de)) > 0){
    4078:	f6040a13          	addi	s4,s0,-160
    407c:	49c1                	li	s3,16
    if(de.name[0] == 'C' && de.name[2] == '\0'){
    407e:	04300a93          	li	s5,67
      if(i < 0 || i >= sizeof(fa)){
    4082:	02700b93          	li	s7,39
      fa[i] = 1;
    4086:	4c05                	li	s8,1
  while(read(fd, &de, sizeof(de)) > 0){
    4088:	864e                	mv	a2,s3
    408a:	85d2                	mv	a1,s4
    408c:	854a                	mv	a0,s2
    408e:	775000ef          	jal	5002 <read>
    4092:	06a05763          	blez	a0,4100 <concreate+0x168>
    if(de.inum == 0)
    4096:	f6045783          	lhu	a5,-160(s0)
    409a:	d7fd                	beqz	a5,4088 <concreate+0xf0>
    if(de.name[0] == 'C' && de.name[2] == '\0'){
    409c:	f6244783          	lbu	a5,-158(s0)
    40a0:	ff5794e3          	bne	a5,s5,4088 <concreate+0xf0>
    40a4:	f6444783          	lbu	a5,-156(s0)
    40a8:	f3e5                	bnez	a5,4088 <concreate+0xf0>
      i = de.name[1] - '0';
    40aa:	f6344783          	lbu	a5,-157(s0)
    40ae:	fd07879b          	addiw	a5,a5,-48
      if(i < 0 || i >= sizeof(fa)){
    40b2:	00fbef63          	bltu	s7,a5,40d0 <concreate+0x138>
      if(fa[i]){
    40b6:	fa078713          	addi	a4,a5,-96
    40ba:	9722                	add	a4,a4,s0
    40bc:	fd074703          	lbu	a4,-48(a4)
    40c0:	e705                	bnez	a4,40e8 <concreate+0x150>
      fa[i] = 1;
    40c2:	fa078793          	addi	a5,a5,-96
    40c6:	97a2                	add	a5,a5,s0
    40c8:	fd878823          	sb	s8,-48(a5)
      n++;
    40cc:	2b05                	addiw	s6,s6,1
    40ce:	bf6d                	j	4088 <concreate+0xf0>
        printf("%s: concreate weird file %s\n", s, de.name);
    40d0:	f6240613          	addi	a2,s0,-158
    40d4:	85ea                	mv	a1,s10
    40d6:	00003517          	auipc	a0,0x3
    40da:	1f250513          	addi	a0,a0,498 # 72c8 <malloc+0x1de0>
    40de:	352010ef          	jal	5430 <printf>
        exit(1);
    40e2:	4505                	li	a0,1
    40e4:	707000ef          	jal	4fea <exit>
        printf("%s: concreate duplicate file %s\n", s, de.name);
    40e8:	f6240613          	addi	a2,s0,-158
    40ec:	85ea                	mv	a1,s10
    40ee:	00003517          	auipc	a0,0x3
    40f2:	1fa50513          	addi	a0,a0,506 # 72e8 <malloc+0x1e00>
    40f6:	33a010ef          	jal	5430 <printf>
        exit(1);
    40fa:	4505                	li	a0,1
    40fc:	6ef000ef          	jal	4fea <exit>
  close(fd);
    4100:	854a                	mv	a0,s2
    4102:	711000ef          	jal	5012 <close>
  if(n != N){
    4106:	02800793          	li	a5,40
    410a:	00fb1a63          	bne	s6,a5,411e <concreate+0x186>
    if(((i % 3) == 0 && pid == 0) ||
    410e:	55555a37          	lui	s4,0x55555
    4112:	556a0a13          	addi	s4,s4,1366 # 55555556 <base+0x5554489e>
      close(open(file, 0));
    4116:	f9840993          	addi	s3,s0,-104
  for(i = 0; i < N; i++){
    411a:	8ada                	mv	s5,s6
    411c:	a049                	j	419e <concreate+0x206>
    printf("%s: concreate not enough files in directory listing\n", s);
    411e:	85ea                	mv	a1,s10
    4120:	00003517          	auipc	a0,0x3
    4124:	1f050513          	addi	a0,a0,496 # 7310 <malloc+0x1e28>
    4128:	308010ef          	jal	5430 <printf>
    exit(1);
    412c:	4505                	li	a0,1
    412e:	6bd000ef          	jal	4fea <exit>
      printf("%s: fork failed\n", s);
    4132:	85ea                	mv	a1,s10
    4134:	00002517          	auipc	a0,0x2
    4138:	d7450513          	addi	a0,a0,-652 # 5ea8 <malloc+0x9c0>
    413c:	2f4010ef          	jal	5430 <printf>
      exit(1);
    4140:	4505                	li	a0,1
    4142:	6a9000ef          	jal	4fea <exit>
      close(open(file, 0));
    4146:	4581                	li	a1,0
    4148:	854e                	mv	a0,s3
    414a:	6e1000ef          	jal	502a <open>
    414e:	6c5000ef          	jal	5012 <close>
      close(open(file, 0));
    4152:	4581                	li	a1,0
    4154:	854e                	mv	a0,s3
    4156:	6d5000ef          	jal	502a <open>
    415a:	6b9000ef          	jal	5012 <close>
      close(open(file, 0));
    415e:	4581                	li	a1,0
    4160:	854e                	mv	a0,s3
    4162:	6c9000ef          	jal	502a <open>
    4166:	6ad000ef          	jal	5012 <close>
      close(open(file, 0));
    416a:	4581                	li	a1,0
    416c:	854e                	mv	a0,s3
    416e:	6bd000ef          	jal	502a <open>
    4172:	6a1000ef          	jal	5012 <close>
      close(open(file, 0));
    4176:	4581                	li	a1,0
    4178:	854e                	mv	a0,s3
    417a:	6b1000ef          	jal	502a <open>
    417e:	695000ef          	jal	5012 <close>
      close(open(file, 0));
    4182:	4581                	li	a1,0
    4184:	854e                	mv	a0,s3
    4186:	6a5000ef          	jal	502a <open>
    418a:	689000ef          	jal	5012 <close>
    if(pid == 0)
    418e:	06090663          	beqz	s2,41fa <concreate+0x262>
      wait(0);
    4192:	4501                	li	a0,0
    4194:	65f000ef          	jal	4ff2 <wait>
  for(i = 0; i < N; i++){
    4198:	2485                	addiw	s1,s1,1
    419a:	0d548163          	beq	s1,s5,425c <concreate+0x2c4>
    file[1] = '0' + i;
    419e:	0304879b          	addiw	a5,s1,48
    41a2:	f8f40ca3          	sb	a5,-103(s0)
    pid = fork();
    41a6:	63d000ef          	jal	4fe2 <fork>
    41aa:	892a                	mv	s2,a0
    if(pid < 0){
    41ac:	f80543e3          	bltz	a0,4132 <concreate+0x19a>
    if(((i % 3) == 0 && pid == 0) ||
    41b0:	03448733          	mul	a4,s1,s4
    41b4:	9301                	srli	a4,a4,0x20
    41b6:	41f4d79b          	sraiw	a5,s1,0x1f
    41ba:	9f1d                	subw	a4,a4,a5
    41bc:	0017179b          	slliw	a5,a4,0x1
    41c0:	9fb9                	addw	a5,a5,a4
    41c2:	40f487bb          	subw	a5,s1,a5
    41c6:	00a7e733          	or	a4,a5,a0
    41ca:	2701                	sext.w	a4,a4
    41cc:	df2d                	beqz	a4,4146 <concreate+0x1ae>
       ((i % 3) == 1 && pid != 0)){
    41ce:	c119                	beqz	a0,41d4 <concreate+0x23c>
    if(((i % 3) == 0 && pid == 0) ||
    41d0:	17fd                	addi	a5,a5,-1
       ((i % 3) == 1 && pid != 0)){
    41d2:	dbb5                	beqz	a5,4146 <concreate+0x1ae>
      unlink(file);
    41d4:	854e                	mv	a0,s3
    41d6:	665000ef          	jal	503a <unlink>
      unlink(file);
    41da:	854e                	mv	a0,s3
    41dc:	65f000ef          	jal	503a <unlink>
      unlink(file);
    41e0:	854e                	mv	a0,s3
    41e2:	659000ef          	jal	503a <unlink>
      unlink(file);
    41e6:	854e                	mv	a0,s3
    41e8:	653000ef          	jal	503a <unlink>
      unlink(file);
    41ec:	854e                	mv	a0,s3
    41ee:	64d000ef          	jal	503a <unlink>
      unlink(file);
    41f2:	854e                	mv	a0,s3
    41f4:	647000ef          	jal	503a <unlink>
    41f8:	bf59                	j	418e <concreate+0x1f6>
      exit(0);
    41fa:	4501                	li	a0,0
    41fc:	5ef000ef          	jal	4fea <exit>
      close(fd);
    4200:	613000ef          	jal	5012 <close>
    if(pid == 0) {
    4204:	b5a1                	j	404c <concreate+0xb4>
      close(fd);
    4206:	60d000ef          	jal	5012 <close>
      wait(&xstatus);
    420a:	8556                	mv	a0,s5
    420c:	5e7000ef          	jal	4ff2 <wait>
      if(xstatus != 0)
    4210:	f5c42483          	lw	s1,-164(s0)
    4214:	e2049fe3          	bnez	s1,4052 <concreate+0xba>
  for(i = 0; i < N; i++){
    4218:	2905                	addiw	s2,s2,1
    421a:	e3490fe3          	beq	s2,s4,4058 <concreate+0xc0>
    file[1] = '0' + i;
    421e:	0309079b          	addiw	a5,s2,48
    4222:	f8f40ca3          	sb	a5,-103(s0)
    unlink(file);
    4226:	854e                	mv	a0,s3
    4228:	613000ef          	jal	503a <unlink>
    pid = fork();
    422c:	5b7000ef          	jal	4fe2 <fork>
    if(pid && (i % 3) == 1){
    4230:	dc0501e3          	beqz	a0,3ff2 <concreate+0x5a>
    4234:	036907b3          	mul	a5,s2,s6
    4238:	9381                	srli	a5,a5,0x20
    423a:	41f9571b          	sraiw	a4,s2,0x1f
    423e:	9f99                	subw	a5,a5,a4
    4240:	0017971b          	slliw	a4,a5,0x1
    4244:	9fb9                	addw	a5,a5,a4
    4246:	40f907bb          	subw	a5,s2,a5
    424a:	d9778fe3          	beq	a5,s7,3fe8 <concreate+0x50>
      fd = open(file, O_CREATE | O_RDWR);
    424e:	85e2                	mv	a1,s8
    4250:	854e                	mv	a0,s3
    4252:	5d9000ef          	jal	502a <open>
      if(fd < 0){
    4256:	fa0558e3          	bgez	a0,4206 <concreate+0x26e>
    425a:	b3f1                	j	4026 <concreate+0x8e>
}
    425c:	70aa                	ld	ra,168(sp)
    425e:	740a                	ld	s0,160(sp)
    4260:	64ea                	ld	s1,152(sp)
    4262:	694a                	ld	s2,144(sp)
    4264:	69aa                	ld	s3,136(sp)
    4266:	6a0a                	ld	s4,128(sp)
    4268:	7ae6                	ld	s5,120(sp)
    426a:	7b46                	ld	s6,112(sp)
    426c:	7ba6                	ld	s7,104(sp)
    426e:	7c06                	ld	s8,96(sp)
    4270:	6ce6                	ld	s9,88(sp)
    4272:	6d46                	ld	s10,80(sp)
    4274:	614d                	addi	sp,sp,176
    4276:	8082                	ret

0000000000004278 <bigfile>:
{
    4278:	7139                	addi	sp,sp,-64
    427a:	fc06                	sd	ra,56(sp)
    427c:	f822                	sd	s0,48(sp)
    427e:	f426                	sd	s1,40(sp)
    4280:	f04a                	sd	s2,32(sp)
    4282:	ec4e                	sd	s3,24(sp)
    4284:	e852                	sd	s4,16(sp)
    4286:	e456                	sd	s5,8(sp)
    4288:	e05a                	sd	s6,0(sp)
    428a:	0080                	addi	s0,sp,64
    428c:	8b2a                	mv	s6,a0
  unlink("bigfile.dat");
    428e:	00003517          	auipc	a0,0x3
    4292:	0ba50513          	addi	a0,a0,186 # 7348 <malloc+0x1e60>
    4296:	5a5000ef          	jal	503a <unlink>
  fd = open("bigfile.dat", O_CREATE | O_RDWR);
    429a:	20200593          	li	a1,514
    429e:	00003517          	auipc	a0,0x3
    42a2:	0aa50513          	addi	a0,a0,170 # 7348 <malloc+0x1e60>
    42a6:	585000ef          	jal	502a <open>
  if(fd < 0){
    42aa:	08054a63          	bltz	a0,433e <bigfile+0xc6>
    42ae:	8a2a                	mv	s4,a0
    42b0:	4481                	li	s1,0
    memset(buf, i, SZ);
    42b2:	25800913          	li	s2,600
    42b6:	0000a997          	auipc	s3,0xa
    42ba:	a0298993          	addi	s3,s3,-1534 # dcb8 <buf>
  for(i = 0; i < N; i++){
    42be:	4ad1                	li	s5,20
    memset(buf, i, SZ);
    42c0:	864a                	mv	a2,s2
    42c2:	85a6                	mv	a1,s1
    42c4:	854e                	mv	a0,s3
    42c6:	2fb000ef          	jal	4dc0 <memset>
    if(write(fd, buf, SZ) != SZ){
    42ca:	864a                	mv	a2,s2
    42cc:	85ce                	mv	a1,s3
    42ce:	8552                	mv	a0,s4
    42d0:	53b000ef          	jal	500a <write>
    42d4:	07251f63          	bne	a0,s2,4352 <bigfile+0xda>
  for(i = 0; i < N; i++){
    42d8:	2485                	addiw	s1,s1,1
    42da:	ff5493e3          	bne	s1,s5,42c0 <bigfile+0x48>
  close(fd);
    42de:	8552                	mv	a0,s4
    42e0:	533000ef          	jal	5012 <close>
  fd = open("bigfile.dat", 0);
    42e4:	4581                	li	a1,0
    42e6:	00003517          	auipc	a0,0x3
    42ea:	06250513          	addi	a0,a0,98 # 7348 <malloc+0x1e60>
    42ee:	53d000ef          	jal	502a <open>
    42f2:	8aaa                	mv	s5,a0
  total = 0;
    42f4:	4a01                	li	s4,0
  for(i = 0; ; i++){
    42f6:	4481                	li	s1,0
    cc = read(fd, buf, SZ/2);
    42f8:	12c00993          	li	s3,300
    42fc:	0000a917          	auipc	s2,0xa
    4300:	9bc90913          	addi	s2,s2,-1604 # dcb8 <buf>
  if(fd < 0){
    4304:	06054163          	bltz	a0,4366 <bigfile+0xee>
    cc = read(fd, buf, SZ/2);
    4308:	864e                	mv	a2,s3
    430a:	85ca                	mv	a1,s2
    430c:	8556                	mv	a0,s5
    430e:	4f5000ef          	jal	5002 <read>
    if(cc < 0){
    4312:	06054463          	bltz	a0,437a <bigfile+0x102>
    if(cc == 0)
    4316:	c145                	beqz	a0,43b6 <bigfile+0x13e>
    if(cc != SZ/2){
    4318:	07351b63          	bne	a0,s3,438e <bigfile+0x116>
    if(buf[0] != i/2 || buf[SZ/2-1] != i/2){
    431c:	01f4d79b          	srliw	a5,s1,0x1f
    4320:	9fa5                	addw	a5,a5,s1
    4322:	4017d79b          	sraiw	a5,a5,0x1
    4326:	00094703          	lbu	a4,0(s2)
    432a:	06f71c63          	bne	a4,a5,43a2 <bigfile+0x12a>
    432e:	12b94703          	lbu	a4,299(s2)
    4332:	06f71863          	bne	a4,a5,43a2 <bigfile+0x12a>
    total += cc;
    4336:	12ca0a1b          	addiw	s4,s4,300
  for(i = 0; ; i++){
    433a:	2485                	addiw	s1,s1,1
    cc = read(fd, buf, SZ/2);
    433c:	b7f1                	j	4308 <bigfile+0x90>
    printf("%s: cannot create bigfile", s);
    433e:	85da                	mv	a1,s6
    4340:	00003517          	auipc	a0,0x3
    4344:	01850513          	addi	a0,a0,24 # 7358 <malloc+0x1e70>
    4348:	0e8010ef          	jal	5430 <printf>
    exit(1);
    434c:	4505                	li	a0,1
    434e:	49d000ef          	jal	4fea <exit>
      printf("%s: write bigfile failed\n", s);
    4352:	85da                	mv	a1,s6
    4354:	00003517          	auipc	a0,0x3
    4358:	02450513          	addi	a0,a0,36 # 7378 <malloc+0x1e90>
    435c:	0d4010ef          	jal	5430 <printf>
      exit(1);
    4360:	4505                	li	a0,1
    4362:	489000ef          	jal	4fea <exit>
    printf("%s: cannot open bigfile\n", s);
    4366:	85da                	mv	a1,s6
    4368:	00003517          	auipc	a0,0x3
    436c:	03050513          	addi	a0,a0,48 # 7398 <malloc+0x1eb0>
    4370:	0c0010ef          	jal	5430 <printf>
    exit(1);
    4374:	4505                	li	a0,1
    4376:	475000ef          	jal	4fea <exit>
      printf("%s: read bigfile failed\n", s);
    437a:	85da                	mv	a1,s6
    437c:	00003517          	auipc	a0,0x3
    4380:	03c50513          	addi	a0,a0,60 # 73b8 <malloc+0x1ed0>
    4384:	0ac010ef          	jal	5430 <printf>
      exit(1);
    4388:	4505                	li	a0,1
    438a:	461000ef          	jal	4fea <exit>
      printf("%s: short read bigfile\n", s);
    438e:	85da                	mv	a1,s6
    4390:	00003517          	auipc	a0,0x3
    4394:	04850513          	addi	a0,a0,72 # 73d8 <malloc+0x1ef0>
    4398:	098010ef          	jal	5430 <printf>
      exit(1);
    439c:	4505                	li	a0,1
    439e:	44d000ef          	jal	4fea <exit>
      printf("%s: read bigfile wrong data\n", s);
    43a2:	85da                	mv	a1,s6
    43a4:	00003517          	auipc	a0,0x3
    43a8:	04c50513          	addi	a0,a0,76 # 73f0 <malloc+0x1f08>
    43ac:	084010ef          	jal	5430 <printf>
      exit(1);
    43b0:	4505                	li	a0,1
    43b2:	439000ef          	jal	4fea <exit>
  close(fd);
    43b6:	8556                	mv	a0,s5
    43b8:	45b000ef          	jal	5012 <close>
  if(total != N*SZ){
    43bc:	678d                	lui	a5,0x3
    43be:	ee078793          	addi	a5,a5,-288 # 2ee0 <subdir+0x1e0>
    43c2:	02fa1263          	bne	s4,a5,43e6 <bigfile+0x16e>
  unlink("bigfile.dat");
    43c6:	00003517          	auipc	a0,0x3
    43ca:	f8250513          	addi	a0,a0,-126 # 7348 <malloc+0x1e60>
    43ce:	46d000ef          	jal	503a <unlink>
}
    43d2:	70e2                	ld	ra,56(sp)
    43d4:	7442                	ld	s0,48(sp)
    43d6:	74a2                	ld	s1,40(sp)
    43d8:	7902                	ld	s2,32(sp)
    43da:	69e2                	ld	s3,24(sp)
    43dc:	6a42                	ld	s4,16(sp)
    43de:	6aa2                	ld	s5,8(sp)
    43e0:	6b02                	ld	s6,0(sp)
    43e2:	6121                	addi	sp,sp,64
    43e4:	8082                	ret
    printf("%s: read bigfile wrong total\n", s);
    43e6:	85da                	mv	a1,s6
    43e8:	00003517          	auipc	a0,0x3
    43ec:	02850513          	addi	a0,a0,40 # 7410 <malloc+0x1f28>
    43f0:	040010ef          	jal	5430 <printf>
    exit(1);
    43f4:	4505                	li	a0,1
    43f6:	3f5000ef          	jal	4fea <exit>

00000000000043fa <bigargtest>:
{
    43fa:	7121                	addi	sp,sp,-448
    43fc:	ff06                	sd	ra,440(sp)
    43fe:	fb22                	sd	s0,432(sp)
    4400:	f726                	sd	s1,424(sp)
    4402:	0380                	addi	s0,sp,448
    4404:	84aa                	mv	s1,a0
  unlink("bigarg-ok");
    4406:	00003517          	auipc	a0,0x3
    440a:	02a50513          	addi	a0,a0,42 # 7430 <malloc+0x1f48>
    440e:	42d000ef          	jal	503a <unlink>
  pid = fork();
    4412:	3d1000ef          	jal	4fe2 <fork>
  if(pid == 0){
    4416:	c915                	beqz	a0,444a <bigargtest+0x50>
  } else if(pid < 0){
    4418:	08054c63          	bltz	a0,44b0 <bigargtest+0xb6>
  wait(&xstatus);
    441c:	fdc40513          	addi	a0,s0,-36
    4420:	3d3000ef          	jal	4ff2 <wait>
  if(xstatus != 0)
    4424:	fdc42503          	lw	a0,-36(s0)
    4428:	ed51                	bnez	a0,44c4 <bigargtest+0xca>
  fd = open("bigarg-ok", 0);
    442a:	4581                	li	a1,0
    442c:	00003517          	auipc	a0,0x3
    4430:	00450513          	addi	a0,a0,4 # 7430 <malloc+0x1f48>
    4434:	3f7000ef          	jal	502a <open>
  if(fd < 0){
    4438:	08054863          	bltz	a0,44c8 <bigargtest+0xce>
  close(fd);
    443c:	3d7000ef          	jal	5012 <close>
}
    4440:	70fa                	ld	ra,440(sp)
    4442:	745a                	ld	s0,432(sp)
    4444:	74ba                	ld	s1,424(sp)
    4446:	6139                	addi	sp,sp,448
    4448:	8082                	ret
    memset(big, ' ', sizeof(big));
    444a:	19000613          	li	a2,400
    444e:	02000593          	li	a1,32
    4452:	e4840513          	addi	a0,s0,-440
    4456:	16b000ef          	jal	4dc0 <memset>
    big[sizeof(big)-1] = '\0';
    445a:	fc040ba3          	sb	zero,-41(s0)
    for(i = 0; i < MAXARG-1; i++)
    445e:	00006797          	auipc	a5,0x6
    4462:	04278793          	addi	a5,a5,66 # a4a0 <args.1>
    4466:	00006697          	auipc	a3,0x6
    446a:	13268693          	addi	a3,a3,306 # a598 <args.1+0xf8>
      args[i] = big;
    446e:	e4840713          	addi	a4,s0,-440
    4472:	e398                	sd	a4,0(a5)
    for(i = 0; i < MAXARG-1; i++)
    4474:	07a1                	addi	a5,a5,8
    4476:	fed79ee3          	bne	a5,a3,4472 <bigargtest+0x78>
    args[MAXARG-1] = 0;
    447a:	00006797          	auipc	a5,0x6
    447e:	1007bf23          	sd	zero,286(a5) # a598 <args.1+0xf8>
    exec("echo", args);
    4482:	00006597          	auipc	a1,0x6
    4486:	01e58593          	addi	a1,a1,30 # a4a0 <args.1>
    448a:	00001517          	auipc	a0,0x1
    448e:	18e50513          	addi	a0,a0,398 # 5618 <malloc+0x130>
    4492:	391000ef          	jal	5022 <exec>
    fd = open("bigarg-ok", O_CREATE);
    4496:	20000593          	li	a1,512
    449a:	00003517          	auipc	a0,0x3
    449e:	f9650513          	addi	a0,a0,-106 # 7430 <malloc+0x1f48>
    44a2:	389000ef          	jal	502a <open>
    close(fd);
    44a6:	36d000ef          	jal	5012 <close>
    exit(0);
    44aa:	4501                	li	a0,0
    44ac:	33f000ef          	jal	4fea <exit>
    printf("%s: bigargtest: fork failed\n", s);
    44b0:	85a6                	mv	a1,s1
    44b2:	00003517          	auipc	a0,0x3
    44b6:	f8e50513          	addi	a0,a0,-114 # 7440 <malloc+0x1f58>
    44ba:	777000ef          	jal	5430 <printf>
    exit(1);
    44be:	4505                	li	a0,1
    44c0:	32b000ef          	jal	4fea <exit>
    exit(xstatus);
    44c4:	327000ef          	jal	4fea <exit>
    printf("%s: bigarg test failed!\n", s);
    44c8:	85a6                	mv	a1,s1
    44ca:	00003517          	auipc	a0,0x3
    44ce:	f9650513          	addi	a0,a0,-106 # 7460 <malloc+0x1f78>
    44d2:	75f000ef          	jal	5430 <printf>
    exit(1);
    44d6:	4505                	li	a0,1
    44d8:	313000ef          	jal	4fea <exit>

00000000000044dc <lazy_alloc>:
{
    44dc:	1141                	addi	sp,sp,-16
    44de:	e406                	sd	ra,8(sp)
    44e0:	e022                	sd	s0,0(sp)
    44e2:	0800                	addi	s0,sp,16
  prev_end = sbrklazy(REGION_SZ);
    44e4:	40000537          	lui	a0,0x40000
    44e8:	2e5000ef          	jal	4fcc <sbrklazy>
  if (prev_end == (char *) SBRK_ERROR) {
    44ec:	57fd                	li	a5,-1
    44ee:	02f50a63          	beq	a0,a5,4522 <lazy_alloc+0x46>
  for (i = prev_end + PGSIZE; i < new_end; i += 64 * PGSIZE)
    44f2:	6605                	lui	a2,0x1
    44f4:	962a                	add	a2,a2,a0
    44f6:	400017b7          	lui	a5,0x40001
    44fa:	00f50733          	add	a4,a0,a5
    44fe:	87b2                	mv	a5,a2
    4500:	000406b7          	lui	a3,0x40
    *(char **)i = i;
    4504:	e39c                	sd	a5,0(a5)
  for (i = prev_end + PGSIZE; i < new_end; i += 64 * PGSIZE)
    4506:	97b6                	add	a5,a5,a3
    4508:	fee79ee3          	bne	a5,a4,4504 <lazy_alloc+0x28>
  for (i = prev_end + PGSIZE; i < new_end; i += 64 * PGSIZE) {
    450c:	000406b7          	lui	a3,0x40
    if (*(char **)i != i) {
    4510:	621c                	ld	a5,0(a2)
    4512:	02c79163          	bne	a5,a2,4534 <lazy_alloc+0x58>
  for (i = prev_end + PGSIZE; i < new_end; i += 64 * PGSIZE) {
    4516:	9636                	add	a2,a2,a3
    4518:	fee61ce3          	bne	a2,a4,4510 <lazy_alloc+0x34>
  exit(0);
    451c:	4501                	li	a0,0
    451e:	2cd000ef          	jal	4fea <exit>
    printf("sbrklazy() failed\n");
    4522:	00003517          	auipc	a0,0x3
    4526:	f5e50513          	addi	a0,a0,-162 # 7480 <malloc+0x1f98>
    452a:	707000ef          	jal	5430 <printf>
    exit(1);
    452e:	4505                	li	a0,1
    4530:	2bb000ef          	jal	4fea <exit>
      printf("failed to read value from memory\n");
    4534:	00003517          	auipc	a0,0x3
    4538:	f6450513          	addi	a0,a0,-156 # 7498 <malloc+0x1fb0>
    453c:	6f5000ef          	jal	5430 <printf>
      exit(1);
    4540:	4505                	li	a0,1
    4542:	2a9000ef          	jal	4fea <exit>

0000000000004546 <lazy_unmap>:
{
    4546:	7139                	addi	sp,sp,-64
    4548:	fc06                	sd	ra,56(sp)
    454a:	f822                	sd	s0,48(sp)
    454c:	0080                	addi	s0,sp,64
  prev_end = sbrklazy(REGION_SZ);
    454e:	40000537          	lui	a0,0x40000
    4552:	27b000ef          	jal	4fcc <sbrklazy>
  if (prev_end == (char*)SBRK_ERROR) {
    4556:	57fd                	li	a5,-1
    4558:	04f50863          	beq	a0,a5,45a8 <lazy_unmap+0x62>
    455c:	f426                	sd	s1,40(sp)
    455e:	f04a                	sd	s2,32(sp)
    4560:	ec4e                	sd	s3,24(sp)
    4562:	e852                	sd	s4,16(sp)
  for (i = prev_end + PGSIZE; i < new_end; i += PGSIZE * PGSIZE)
    4564:	6905                	lui	s2,0x1
    4566:	992a                	add	s2,s2,a0
    4568:	400017b7          	lui	a5,0x40001
    456c:	00f504b3          	add	s1,a0,a5
    4570:	87ca                	mv	a5,s2
    4572:	01000737          	lui	a4,0x1000
    *(char **)i = i;
    4576:	e39c                	sd	a5,0(a5)
  for (i = prev_end + PGSIZE; i < new_end; i += PGSIZE * PGSIZE)
    4578:	97ba                	add	a5,a5,a4
    457a:	fe979ee3          	bne	a5,s1,4576 <lazy_unmap+0x30>
      wait(&status);
    457e:	fcc40993          	addi	s3,s0,-52
  for (i = prev_end + PGSIZE; i < new_end; i += PGSIZE * PGSIZE) {
    4582:	01000a37          	lui	s4,0x1000
    pid = fork();
    4586:	25d000ef          	jal	4fe2 <fork>
    if (pid < 0) {
    458a:	02054c63          	bltz	a0,45c2 <lazy_unmap+0x7c>
    } else if (pid == 0) {
    458e:	c139                	beqz	a0,45d4 <lazy_unmap+0x8e>
      wait(&status);
    4590:	854e                	mv	a0,s3
    4592:	261000ef          	jal	4ff2 <wait>
      if (status == 0) {
    4596:	fcc42783          	lw	a5,-52(s0)
    459a:	c7b1                	beqz	a5,45e6 <lazy_unmap+0xa0>
  for (i = prev_end + PGSIZE; i < new_end; i += PGSIZE * PGSIZE) {
    459c:	9952                	add	s2,s2,s4
    459e:	fe9914e3          	bne	s2,s1,4586 <lazy_unmap+0x40>
  exit(0);
    45a2:	4501                	li	a0,0
    45a4:	247000ef          	jal	4fea <exit>
    45a8:	f426                	sd	s1,40(sp)
    45aa:	f04a                	sd	s2,32(sp)
    45ac:	ec4e                	sd	s3,24(sp)
    45ae:	e852                	sd	s4,16(sp)
    printf("sbrklazy() failed\n");
    45b0:	00003517          	auipc	a0,0x3
    45b4:	ed050513          	addi	a0,a0,-304 # 7480 <malloc+0x1f98>
    45b8:	679000ef          	jal	5430 <printf>
    exit(1);
    45bc:	4505                	li	a0,1
    45be:	22d000ef          	jal	4fea <exit>
      printf("error forking\n");
    45c2:	00003517          	auipc	a0,0x3
    45c6:	efe50513          	addi	a0,a0,-258 # 74c0 <malloc+0x1fd8>
    45ca:	667000ef          	jal	5430 <printf>
      exit(1);
    45ce:	4505                	li	a0,1
    45d0:	21b000ef          	jal	4fea <exit>
      sbrklazy(-1L * REGION_SZ);
    45d4:	c0000537          	lui	a0,0xc0000
    45d8:	1f5000ef          	jal	4fcc <sbrklazy>
      *(char **)i = i;
    45dc:	01293023          	sd	s2,0(s2) # 1000 <bigdir+0x10c>
      exit(0);
    45e0:	4501                	li	a0,0
    45e2:	209000ef          	jal	4fea <exit>
        printf("memory not unmapped\n");
    45e6:	00003517          	auipc	a0,0x3
    45ea:	eea50513          	addi	a0,a0,-278 # 74d0 <malloc+0x1fe8>
    45ee:	643000ef          	jal	5430 <printf>
        exit(1);
    45f2:	4505                	li	a0,1
    45f4:	1f7000ef          	jal	4fea <exit>

00000000000045f8 <lazy_copy>:
{
    45f8:	7119                	addi	sp,sp,-128
    45fa:	fc86                	sd	ra,120(sp)
    45fc:	f8a2                	sd	s0,112(sp)
    45fe:	f4a6                	sd	s1,104(sp)
    4600:	f0ca                	sd	s2,96(sp)
    4602:	ecce                	sd	s3,88(sp)
    4604:	e8d2                	sd	s4,80(sp)
    4606:	e4d6                	sd	s5,72(sp)
    4608:	e0da                	sd	s6,64(sp)
    460a:	fc5e                	sd	s7,56(sp)
    460c:	0100                	addi	s0,sp,128
    char *p = sbrk(0);
    460e:	4501                	li	a0,0
    4610:	1a7000ef          	jal	4fb6 <sbrk>
    4614:	84aa                	mv	s1,a0
    sbrklazy(4*PGSIZE);
    4616:	6511                	lui	a0,0x4
    4618:	1b5000ef          	jal	4fcc <sbrklazy>
    open(p + 8192, 0);
    461c:	4581                	li	a1,0
    461e:	6509                	lui	a0,0x2
    4620:	9526                	add	a0,a0,s1
    4622:	209000ef          	jal	502a <open>
    void *xx = sbrk(0);
    4626:	4501                	li	a0,0
    4628:	18f000ef          	jal	4fb6 <sbrk>
    462c:	84aa                	mv	s1,a0
    void *ret = sbrk(-(((uint64) xx)+1));
    462e:	fff54513          	not	a0,a0
    4632:	2501                	sext.w	a0,a0
    4634:	183000ef          	jal	4fb6 <sbrk>
    if(ret != xx){
    4638:	00a48c63          	beq	s1,a0,4650 <lazy_copy+0x58>
    463c:	85aa                	mv	a1,a0
      printf("sbrk(sbrk(0)+1) returned %p, not old sz\n", ret);
    463e:	00003517          	auipc	a0,0x3
    4642:	eaa50513          	addi	a0,a0,-342 # 74e8 <malloc+0x2000>
    4646:	5eb000ef          	jal	5430 <printf>
      exit(1);
    464a:	4505                	li	a0,1
    464c:	19f000ef          	jal	4fea <exit>
  unsigned long bad[] = {
    4650:	00003797          	auipc	a5,0x3
    4654:	51078793          	addi	a5,a5,1296 # 7b60 <malloc+0x2678>
    4658:	7fa8                	ld	a0,120(a5)
    465a:	63cc                	ld	a1,128(a5)
    465c:	67d0                	ld	a2,136(a5)
    465e:	6bd4                	ld	a3,144(a5)
    4660:	6fd8                	ld	a4,152(a5)
    4662:	f8a43023          	sd	a0,-128(s0)
    4666:	f8b43423          	sd	a1,-120(s0)
    466a:	f8c43823          	sd	a2,-112(s0)
    466e:	f8d43c23          	sd	a3,-104(s0)
    4672:	fae43023          	sd	a4,-96(s0)
    4676:	73dc                	ld	a5,160(a5)
    4678:	faf43423          	sd	a5,-88(s0)
  for(int i = 0; i < sizeof(bad)/sizeof(bad[0]); i++){
    467c:	f8040913          	addi	s2,s0,-128
    int fd = open("README", 0);
    4680:	00001a97          	auipc	s5,0x1
    4684:	170a8a93          	addi	s5,s5,368 # 57f0 <malloc+0x308>
    if(read(fd, (char*)bad[i], 512) >= 0) { printf("read succeeded\n");  exit(1); }
    4688:	20000a13          	li	s4,512
    fd = open("junk", O_CREATE|O_RDWR|O_TRUNC);
    468c:	60200b93          	li	s7,1538
    4690:	00001b17          	auipc	s6,0x1
    4694:	070b0b13          	addi	s6,s6,112 # 5700 <malloc+0x218>
    int fd = open("README", 0);
    4698:	4581                	li	a1,0
    469a:	8556                	mv	a0,s5
    469c:	18f000ef          	jal	502a <open>
    46a0:	84aa                	mv	s1,a0
    if(fd < 0) { printf("cannot open README\n"); exit(1); }
    46a2:	04054563          	bltz	a0,46ec <lazy_copy+0xf4>
    if(read(fd, (char*)bad[i], 512) >= 0) { printf("read succeeded\n");  exit(1); }
    46a6:	00093983          	ld	s3,0(s2)
    46aa:	8652                	mv	a2,s4
    46ac:	85ce                	mv	a1,s3
    46ae:	155000ef          	jal	5002 <read>
    46b2:	04055663          	bgez	a0,46fe <lazy_copy+0x106>
    close(fd);
    46b6:	8526                	mv	a0,s1
    46b8:	15b000ef          	jal	5012 <close>
    fd = open("junk", O_CREATE|O_RDWR|O_TRUNC);
    46bc:	85de                	mv	a1,s7
    46be:	855a                	mv	a0,s6
    46c0:	16b000ef          	jal	502a <open>
    46c4:	84aa                	mv	s1,a0
    if(fd < 0) { printf("cannot open junk\n"); exit(1); }
    46c6:	04054563          	bltz	a0,4710 <lazy_copy+0x118>
    if(write(fd, (char*)bad[i], 512) >= 0) { printf("write succeeded\n"); exit(1); }
    46ca:	8652                	mv	a2,s4
    46cc:	85ce                	mv	a1,s3
    46ce:	13d000ef          	jal	500a <write>
    46d2:	04055863          	bgez	a0,4722 <lazy_copy+0x12a>
    close(fd);
    46d6:	8526                	mv	a0,s1
    46d8:	13b000ef          	jal	5012 <close>
  for(int i = 0; i < sizeof(bad)/sizeof(bad[0]); i++){
    46dc:	0921                	addi	s2,s2,8
    46de:	fb040793          	addi	a5,s0,-80
    46e2:	faf91be3          	bne	s2,a5,4698 <lazy_copy+0xa0>
  exit(0);
    46e6:	4501                	li	a0,0
    46e8:	103000ef          	jal	4fea <exit>
    if(fd < 0) { printf("cannot open README\n"); exit(1); }
    46ec:	00003517          	auipc	a0,0x3
    46f0:	e2c50513          	addi	a0,a0,-468 # 7518 <malloc+0x2030>
    46f4:	53d000ef          	jal	5430 <printf>
    46f8:	4505                	li	a0,1
    46fa:	0f1000ef          	jal	4fea <exit>
    if(read(fd, (char*)bad[i], 512) >= 0) { printf("read succeeded\n");  exit(1); }
    46fe:	00003517          	auipc	a0,0x3
    4702:	e3250513          	addi	a0,a0,-462 # 7530 <malloc+0x2048>
    4706:	52b000ef          	jal	5430 <printf>
    470a:	4505                	li	a0,1
    470c:	0df000ef          	jal	4fea <exit>
    if(fd < 0) { printf("cannot open junk\n"); exit(1); }
    4710:	00003517          	auipc	a0,0x3
    4714:	e3050513          	addi	a0,a0,-464 # 7540 <malloc+0x2058>
    4718:	519000ef          	jal	5430 <printf>
    471c:	4505                	li	a0,1
    471e:	0cd000ef          	jal	4fea <exit>
    if(write(fd, (char*)bad[i], 512) >= 0) { printf("write succeeded\n"); exit(1); }
    4722:	00003517          	auipc	a0,0x3
    4726:	e3650513          	addi	a0,a0,-458 # 7558 <malloc+0x2070>
    472a:	507000ef          	jal	5430 <printf>
    472e:	4505                	li	a0,1
    4730:	0bb000ef          	jal	4fea <exit>

0000000000004734 <lazy_sbrk>:
{
    4734:	7179                	addi	sp,sp,-48
    4736:	f406                	sd	ra,40(sp)
    4738:	f022                	sd	s0,32(sp)
    473a:	ec26                	sd	s1,24(sp)
    473c:	e84a                	sd	s2,16(sp)
    473e:	e44e                	sd	s3,8(sp)
    4740:	1800                	addi	s0,sp,48
  char *p = sbrk(0);
    4742:	4501                	li	a0,0
    4744:	073000ef          	jal	4fb6 <sbrk>
    4748:	84aa                	mv	s1,a0
  while ((uint64)p < MAXVA-(1<<30)) {
    474a:	0ff00793          	li	a5,255
    474e:	07fa                	slli	a5,a5,0x1e
    4750:	00f57e63          	bgeu	a0,a5,476c <lazy_sbrk+0x38>
    p = sbrklazy(1<<30);
    4754:	400009b7          	lui	s3,0x40000
  while ((uint64)p < MAXVA-(1<<30)) {
    4758:	893e                	mv	s2,a5
    p = sbrklazy(1<<30);
    475a:	854e                	mv	a0,s3
    475c:	071000ef          	jal	4fcc <sbrklazy>
    p = sbrklazy(0);
    4760:	4501                	li	a0,0
    4762:	06b000ef          	jal	4fcc <sbrklazy>
    4766:	84aa                	mv	s1,a0
  while ((uint64)p < MAXVA-(1<<30)) {
    4768:	ff2569e3          	bltu	a0,s2,475a <lazy_sbrk+0x26>
  int n = TRAPFRAME-PGSIZE-(uint64)p;
    476c:	7975                	lui	s2,0xffffd
    476e:	4099093b          	subw	s2,s2,s1
  char *p1 = sbrklazy(n);
    4772:	854a                	mv	a0,s2
    4774:	059000ef          	jal	4fcc <sbrklazy>
    4778:	862a                	mv	a2,a0
  if (p1 < 0 || p1 != p) {
    477a:	00950d63          	beq	a0,s1,4794 <lazy_sbrk+0x60>
    printf("sbrklazy(%d) returned %p, not expected %p\n", n, p1, p);
    477e:	86a6                	mv	a3,s1
    4780:	85ca                	mv	a1,s2
    4782:	00003517          	auipc	a0,0x3
    4786:	dee50513          	addi	a0,a0,-530 # 7570 <malloc+0x2088>
    478a:	4a7000ef          	jal	5430 <printf>
    exit(1);
    478e:	4505                	li	a0,1
    4790:	05b000ef          	jal	4fea <exit>
  p = sbrk(PGSIZE);
    4794:	6505                	lui	a0,0x1
    4796:	021000ef          	jal	4fb6 <sbrk>
    479a:	862a                	mv	a2,a0
  if (p < 0 || (uint64)p != TRAPFRAME-PGSIZE) {
    479c:	040007b7          	lui	a5,0x4000
    47a0:	17f5                	addi	a5,a5,-3 # 3fffffd <base+0x3fef345>
    47a2:	07b2                	slli	a5,a5,0xc
    47a4:	00f50c63          	beq	a0,a5,47bc <lazy_sbrk+0x88>
    printf("sbrk(%d) returned %p, not expected TRAPFRAME-PGSIZE\n", PGSIZE, p);
    47a8:	6585                	lui	a1,0x1
    47aa:	00003517          	auipc	a0,0x3
    47ae:	df650513          	addi	a0,a0,-522 # 75a0 <malloc+0x20b8>
    47b2:	47f000ef          	jal	5430 <printf>
    exit(1);
    47b6:	4505                	li	a0,1
    47b8:	033000ef          	jal	4fea <exit>
  p[0] = 1;
    47bc:	040007b7          	lui	a5,0x4000
    47c0:	17f5                	addi	a5,a5,-3 # 3fffffd <base+0x3fef345>
    47c2:	07b2                	slli	a5,a5,0xc
    47c4:	4705                	li	a4,1
    47c6:	00e78023          	sb	a4,0(a5)
  if (p[1] != 0) {
    47ca:	0017c783          	lbu	a5,1(a5)
    47ce:	cb91                	beqz	a5,47e2 <lazy_sbrk+0xae>
    printf("sbrk() returned non-zero-filled memory\n");
    47d0:	00003517          	auipc	a0,0x3
    47d4:	e0850513          	addi	a0,a0,-504 # 75d8 <malloc+0x20f0>
    47d8:	459000ef          	jal	5430 <printf>
    exit(1);
    47dc:	4505                	li	a0,1
    47de:	00d000ef          	jal	4fea <exit>
  p = sbrk(1);
    47e2:	4505                	li	a0,1
    47e4:	7d2000ef          	jal	4fb6 <sbrk>
    47e8:	85aa                	mv	a1,a0
  if ((uint64)p != -1) {
    47ea:	57fd                	li	a5,-1
    47ec:	00f50b63          	beq	a0,a5,4802 <lazy_sbrk+0xce>
    printf("sbrk(1) returned %p, expected error\n", p);
    47f0:	00003517          	auipc	a0,0x3
    47f4:	e1050513          	addi	a0,a0,-496 # 7600 <malloc+0x2118>
    47f8:	439000ef          	jal	5430 <printf>
    exit(1);
    47fc:	4505                	li	a0,1
    47fe:	7ec000ef          	jal	4fea <exit>
  p = sbrklazy(1);
    4802:	4505                	li	a0,1
    4804:	7c8000ef          	jal	4fcc <sbrklazy>
    4808:	85aa                	mv	a1,a0
  if ((uint64)p != -1) {
    480a:	57fd                	li	a5,-1
    480c:	00f50b63          	beq	a0,a5,4822 <lazy_sbrk+0xee>
    printf("sbrklazy(1) returned %p, expected error\n", p);
    4810:	00003517          	auipc	a0,0x3
    4814:	e1850513          	addi	a0,a0,-488 # 7628 <malloc+0x2140>
    4818:	419000ef          	jal	5430 <printf>
    exit(1);
    481c:	4505                	li	a0,1
    481e:	7cc000ef          	jal	4fea <exit>
  exit(0);
    4822:	4501                	li	a0,0
    4824:	7c6000ef          	jal	4fea <exit>

0000000000004828 <fsfull>:
{
    4828:	7171                	addi	sp,sp,-176
    482a:	f506                	sd	ra,168(sp)
    482c:	f122                	sd	s0,160(sp)
    482e:	ed26                	sd	s1,152(sp)
    4830:	e94a                	sd	s2,144(sp)
    4832:	e54e                	sd	s3,136(sp)
    4834:	e152                	sd	s4,128(sp)
    4836:	fcd6                	sd	s5,120(sp)
    4838:	f8da                	sd	s6,112(sp)
    483a:	f4de                	sd	s7,104(sp)
    483c:	f0e2                	sd	s8,96(sp)
    483e:	ece6                	sd	s9,88(sp)
    4840:	e8ea                	sd	s10,80(sp)
    4842:	e4ee                	sd	s11,72(sp)
    4844:	1900                	addi	s0,sp,176
  printf("fsfull test\n");
    4846:	00003517          	auipc	a0,0x3
    484a:	e1250513          	addi	a0,a0,-494 # 7658 <malloc+0x2170>
    484e:	3e3000ef          	jal	5430 <printf>
  for(nfiles = 0; ; nfiles++){
    4852:	4481                	li	s1,0
    name[0] = 'f';
    4854:	06600d93          	li	s11,102
    name[1] = '0' + nfiles / 1000;
    4858:	10625cb7          	lui	s9,0x10625
    485c:	dd3c8c93          	addi	s9,s9,-557 # 10624dd3 <base+0x1061411b>
    name[2] = '0' + (nfiles % 1000) / 100;
    4860:	51eb8ab7          	lui	s5,0x51eb8
    4864:	51fa8a93          	addi	s5,s5,1311 # 51eb851f <base+0x51ea7867>
    name[3] = '0' + (nfiles % 100) / 10;
    4868:	66666a37          	lui	s4,0x66666
    486c:	667a0a13          	addi	s4,s4,1639 # 66666667 <base+0x666559af>
    printf("writing %s\n", name);
    4870:	f5040d13          	addi	s10,s0,-176
    name[0] = 'f';
    4874:	f5b40823          	sb	s11,-176(s0)
    name[1] = '0' + nfiles / 1000;
    4878:	039487b3          	mul	a5,s1,s9
    487c:	9799                	srai	a5,a5,0x26
    487e:	41f4d69b          	sraiw	a3,s1,0x1f
    4882:	9f95                	subw	a5,a5,a3
    4884:	0307871b          	addiw	a4,a5,48
    4888:	f4e408a3          	sb	a4,-175(s0)
    name[2] = '0' + (nfiles % 1000) / 100;
    488c:	3e800713          	li	a4,1000
    4890:	02f707bb          	mulw	a5,a4,a5
    4894:	40f487bb          	subw	a5,s1,a5
    4898:	03578733          	mul	a4,a5,s5
    489c:	9715                	srai	a4,a4,0x25
    489e:	41f7d79b          	sraiw	a5,a5,0x1f
    48a2:	40f707bb          	subw	a5,a4,a5
    48a6:	0307879b          	addiw	a5,a5,48
    48aa:	f4f40923          	sb	a5,-174(s0)
    name[3] = '0' + (nfiles % 100) / 10;
    48ae:	035487b3          	mul	a5,s1,s5
    48b2:	9795                	srai	a5,a5,0x25
    48b4:	9f95                	subw	a5,a5,a3
    48b6:	06400713          	li	a4,100
    48ba:	02f707bb          	mulw	a5,a4,a5
    48be:	40f487bb          	subw	a5,s1,a5
    48c2:	03478733          	mul	a4,a5,s4
    48c6:	9709                	srai	a4,a4,0x22
    48c8:	41f7d79b          	sraiw	a5,a5,0x1f
    48cc:	40f707bb          	subw	a5,a4,a5
    48d0:	0307879b          	addiw	a5,a5,48
    48d4:	f4f409a3          	sb	a5,-173(s0)
    name[4] = '0' + (nfiles % 10);
    48d8:	03448733          	mul	a4,s1,s4
    48dc:	9709                	srai	a4,a4,0x22
    48de:	9f15                	subw	a4,a4,a3
    48e0:	0027179b          	slliw	a5,a4,0x2
    48e4:	9fb9                	addw	a5,a5,a4
    48e6:	0017979b          	slliw	a5,a5,0x1
    48ea:	40f487bb          	subw	a5,s1,a5
    48ee:	0307879b          	addiw	a5,a5,48
    48f2:	f4f40a23          	sb	a5,-172(s0)
    name[5] = '\0';
    48f6:	f4040aa3          	sb	zero,-171(s0)
    printf("writing %s\n", name);
    48fa:	85ea                	mv	a1,s10
    48fc:	00003517          	auipc	a0,0x3
    4900:	d6c50513          	addi	a0,a0,-660 # 7668 <malloc+0x2180>
    4904:	32d000ef          	jal	5430 <printf>
    int fd = open(name, O_CREATE|O_RDWR);
    4908:	20200593          	li	a1,514
    490c:	856a                	mv	a0,s10
    490e:	71c000ef          	jal	502a <open>
    4912:	892a                	mv	s2,a0
    if(fd < 0){
    4914:	0e055b63          	bgez	a0,4a0a <fsfull+0x1e2>
      printf("open %s failed\n", name);
    4918:	f5040593          	addi	a1,s0,-176
    491c:	00003517          	auipc	a0,0x3
    4920:	d5c50513          	addi	a0,a0,-676 # 7678 <malloc+0x2190>
    4924:	30d000ef          	jal	5430 <printf>
  while(nfiles >= 0){
    4928:	0a04cc63          	bltz	s1,49e0 <fsfull+0x1b8>
    name[0] = 'f';
    492c:	06600c13          	li	s8,102
    name[1] = '0' + nfiles / 1000;
    4930:	10625a37          	lui	s4,0x10625
    4934:	dd3a0a13          	addi	s4,s4,-557 # 10624dd3 <base+0x1061411b>
    name[2] = '0' + (nfiles % 1000) / 100;
    4938:	3e800b93          	li	s7,1000
    493c:	51eb89b7          	lui	s3,0x51eb8
    4940:	51f98993          	addi	s3,s3,1311 # 51eb851f <base+0x51ea7867>
    name[3] = '0' + (nfiles % 100) / 10;
    4944:	06400b13          	li	s6,100
    4948:	66666937          	lui	s2,0x66666
    494c:	66790913          	addi	s2,s2,1639 # 66666667 <base+0x666559af>
    unlink(name);
    4950:	f5040a93          	addi	s5,s0,-176
    name[0] = 'f';
    4954:	f5840823          	sb	s8,-176(s0)
    name[1] = '0' + nfiles / 1000;
    4958:	034487b3          	mul	a5,s1,s4
    495c:	9799                	srai	a5,a5,0x26
    495e:	41f4d69b          	sraiw	a3,s1,0x1f
    4962:	9f95                	subw	a5,a5,a3
    4964:	0307871b          	addiw	a4,a5,48
    4968:	f4e408a3          	sb	a4,-175(s0)
    name[2] = '0' + (nfiles % 1000) / 100;
    496c:	02fb87bb          	mulw	a5,s7,a5
    4970:	40f487bb          	subw	a5,s1,a5
    4974:	03378733          	mul	a4,a5,s3
    4978:	9715                	srai	a4,a4,0x25
    497a:	41f7d79b          	sraiw	a5,a5,0x1f
    497e:	40f707bb          	subw	a5,a4,a5
    4982:	0307879b          	addiw	a5,a5,48
    4986:	f4f40923          	sb	a5,-174(s0)
    name[3] = '0' + (nfiles % 100) / 10;
    498a:	033487b3          	mul	a5,s1,s3
    498e:	9795                	srai	a5,a5,0x25
    4990:	9f95                	subw	a5,a5,a3
    4992:	02fb07bb          	mulw	a5,s6,a5
    4996:	40f487bb          	subw	a5,s1,a5
    499a:	03278733          	mul	a4,a5,s2
    499e:	9709                	srai	a4,a4,0x22
    49a0:	41f7d79b          	sraiw	a5,a5,0x1f
    49a4:	40f707bb          	subw	a5,a4,a5
    49a8:	0307879b          	addiw	a5,a5,48
    49ac:	f4f409a3          	sb	a5,-173(s0)
    name[4] = '0' + (nfiles % 10);
    49b0:	03248733          	mul	a4,s1,s2
    49b4:	9709                	srai	a4,a4,0x22
    49b6:	9f15                	subw	a4,a4,a3
    49b8:	0027179b          	slliw	a5,a4,0x2
    49bc:	9fb9                	addw	a5,a5,a4
    49be:	0017979b          	slliw	a5,a5,0x1
    49c2:	40f487bb          	subw	a5,s1,a5
    49c6:	0307879b          	addiw	a5,a5,48
    49ca:	f4f40a23          	sb	a5,-172(s0)
    name[5] = '\0';
    49ce:	f4040aa3          	sb	zero,-171(s0)
    unlink(name);
    49d2:	8556                	mv	a0,s5
    49d4:	666000ef          	jal	503a <unlink>
    nfiles--;
    49d8:	34fd                	addiw	s1,s1,-1
  while(nfiles >= 0){
    49da:	57fd                	li	a5,-1
    49dc:	f6f49ce3          	bne	s1,a5,4954 <fsfull+0x12c>
  printf("fsfull test finished\n");
    49e0:	00003517          	auipc	a0,0x3
    49e4:	cb850513          	addi	a0,a0,-840 # 7698 <malloc+0x21b0>
    49e8:	249000ef          	jal	5430 <printf>
}
    49ec:	70aa                	ld	ra,168(sp)
    49ee:	740a                	ld	s0,160(sp)
    49f0:	64ea                	ld	s1,152(sp)
    49f2:	694a                	ld	s2,144(sp)
    49f4:	69aa                	ld	s3,136(sp)
    49f6:	6a0a                	ld	s4,128(sp)
    49f8:	7ae6                	ld	s5,120(sp)
    49fa:	7b46                	ld	s6,112(sp)
    49fc:	7ba6                	ld	s7,104(sp)
    49fe:	7c06                	ld	s8,96(sp)
    4a00:	6ce6                	ld	s9,88(sp)
    4a02:	6d46                	ld	s10,80(sp)
    4a04:	6da6                	ld	s11,72(sp)
    4a06:	614d                	addi	sp,sp,176
    4a08:	8082                	ret
    int total = 0;
    4a0a:	4981                	li	s3,0
      int cc = write(fd, buf, BSIZE);
    4a0c:	40000c13          	li	s8,1024
    4a10:	00009b97          	auipc	s7,0x9
    4a14:	2a8b8b93          	addi	s7,s7,680 # dcb8 <buf>
      if(cc < BSIZE)
    4a18:	3ff00b13          	li	s6,1023
      int cc = write(fd, buf, BSIZE);
    4a1c:	8662                	mv	a2,s8
    4a1e:	85de                	mv	a1,s7
    4a20:	854a                	mv	a0,s2
    4a22:	5e8000ef          	jal	500a <write>
      if(cc < BSIZE)
    4a26:	00ab5563          	bge	s6,a0,4a30 <fsfull+0x208>
      total += cc;
    4a2a:	00a989bb          	addw	s3,s3,a0
    while(1){
    4a2e:	b7fd                	j	4a1c <fsfull+0x1f4>
    printf("wrote %d bytes\n", total);
    4a30:	85ce                	mv	a1,s3
    4a32:	00003517          	auipc	a0,0x3
    4a36:	c5650513          	addi	a0,a0,-938 # 7688 <malloc+0x21a0>
    4a3a:	1f7000ef          	jal	5430 <printf>
    close(fd);
    4a3e:	854a                	mv	a0,s2
    4a40:	5d2000ef          	jal	5012 <close>
    if(total == 0)
    4a44:	ee0982e3          	beqz	s3,4928 <fsfull+0x100>
  for(nfiles = 0; ; nfiles++){
    4a48:	2485                	addiw	s1,s1,1
    4a4a:	b52d                	j	4874 <fsfull+0x4c>

0000000000004a4c <run>:
//

// run each test in its own process. run returns 1 if child's exit()
// indicates success.
int
run(void f(char *), char *s) {
    4a4c:	7179                	addi	sp,sp,-48
    4a4e:	f406                	sd	ra,40(sp)
    4a50:	f022                	sd	s0,32(sp)
    4a52:	ec26                	sd	s1,24(sp)
    4a54:	e84a                	sd	s2,16(sp)
    4a56:	1800                	addi	s0,sp,48
    4a58:	84aa                	mv	s1,a0
    4a5a:	892e                	mv	s2,a1
  int pid;
  int xstatus;

  printf("test %s: ", s);
    4a5c:	00003517          	auipc	a0,0x3
    4a60:	c5450513          	addi	a0,a0,-940 # 76b0 <malloc+0x21c8>
    4a64:	1cd000ef          	jal	5430 <printf>
  if((pid = fork()) < 0) {
    4a68:	57a000ef          	jal	4fe2 <fork>
    4a6c:	02054a63          	bltz	a0,4aa0 <run+0x54>
    printf("runtest: fork error\n");
    exit(1);
  }
  if(pid == 0) {
    4a70:	c129                	beqz	a0,4ab2 <run+0x66>
    f(s);
    exit(0);
  } else {
    wait(&xstatus);
    4a72:	fdc40513          	addi	a0,s0,-36
    4a76:	57c000ef          	jal	4ff2 <wait>
    if(xstatus != 0) 
    4a7a:	fdc42783          	lw	a5,-36(s0)
    4a7e:	cf9d                	beqz	a5,4abc <run+0x70>
      printf("FAILED\n");
    4a80:	00003517          	auipc	a0,0x3
    4a84:	c5850513          	addi	a0,a0,-936 # 76d8 <malloc+0x21f0>
    4a88:	1a9000ef          	jal	5430 <printf>
    else
      printf("OK\n");
    return xstatus == 0;
    4a8c:	fdc42503          	lw	a0,-36(s0)
  }
}
    4a90:	00153513          	seqz	a0,a0
    4a94:	70a2                	ld	ra,40(sp)
    4a96:	7402                	ld	s0,32(sp)
    4a98:	64e2                	ld	s1,24(sp)
    4a9a:	6942                	ld	s2,16(sp)
    4a9c:	6145                	addi	sp,sp,48
    4a9e:	8082                	ret
    printf("runtest: fork error\n");
    4aa0:	00003517          	auipc	a0,0x3
    4aa4:	c2050513          	addi	a0,a0,-992 # 76c0 <malloc+0x21d8>
    4aa8:	189000ef          	jal	5430 <printf>
    exit(1);
    4aac:	4505                	li	a0,1
    4aae:	53c000ef          	jal	4fea <exit>
    f(s);
    4ab2:	854a                	mv	a0,s2
    4ab4:	9482                	jalr	s1
    exit(0);
    4ab6:	4501                	li	a0,0
    4ab8:	532000ef          	jal	4fea <exit>
      printf("OK\n");
    4abc:	00003517          	auipc	a0,0x3
    4ac0:	c2450513          	addi	a0,a0,-988 # 76e0 <malloc+0x21f8>
    4ac4:	16d000ef          	jal	5430 <printf>
    4ac8:	b7d1                	j	4a8c <run+0x40>

0000000000004aca <runtests>:

int
runtests(struct test *tests, char *justone, int continuous) {
    4aca:	7179                	addi	sp,sp,-48
    4acc:	f406                	sd	ra,40(sp)
    4ace:	f022                	sd	s0,32(sp)
    4ad0:	ec26                	sd	s1,24(sp)
    4ad2:	e44e                	sd	s3,8(sp)
    4ad4:	1800                	addi	s0,sp,48
    4ad6:	84aa                	mv	s1,a0
  int ntests = 0;
  for (struct test *t = tests; t->s != 0; t++) {
    4ad8:	6508                	ld	a0,8(a0)
    4ada:	cd29                	beqz	a0,4b34 <runtests+0x6a>
    4adc:	e84a                	sd	s2,16(sp)
    4ade:	e052                	sd	s4,0(sp)
    4ae0:	892e                	mv	s2,a1
    if((justone == 0) || strcmp(t->s, justone) == 0) {
      ntests++;
      if(!run(t->f, t->s)){
        if(continuous != 2){
    4ae2:	1679                	addi	a2,a2,-2 # ffe <bigdir+0x10a>
    4ae4:	00c03a33          	snez	s4,a2
  int ntests = 0;
    4ae8:	4981                	li	s3,0
    4aea:	a029                	j	4af4 <runtests+0x2a>
      ntests++;
    4aec:	2985                	addiw	s3,s3,1
  for (struct test *t = tests; t->s != 0; t++) {
    4aee:	04c1                	addi	s1,s1,16
    4af0:	6488                	ld	a0,8(s1)
    4af2:	c905                	beqz	a0,4b22 <runtests+0x58>
    if((justone == 0) || strcmp(t->s, justone) == 0) {
    4af4:	00090663          	beqz	s2,4b00 <runtests+0x36>
    4af8:	85ca                	mv	a1,s2
    4afa:	26a000ef          	jal	4d64 <strcmp>
    4afe:	f965                	bnez	a0,4aee <runtests+0x24>
      if(!run(t->f, t->s)){
    4b00:	648c                	ld	a1,8(s1)
    4b02:	6088                	ld	a0,0(s1)
    4b04:	f49ff0ef          	jal	4a4c <run>
        if(continuous != 2){
    4b08:	f175                	bnez	a0,4aec <runtests+0x22>
    4b0a:	fe0a01e3          	beqz	s4,4aec <runtests+0x22>
          printf("SOME TESTS FAILED\n");
    4b0e:	00003517          	auipc	a0,0x3
    4b12:	bda50513          	addi	a0,a0,-1062 # 76e8 <malloc+0x2200>
    4b16:	11b000ef          	jal	5430 <printf>
          return -1;
    4b1a:	59fd                	li	s3,-1
    4b1c:	6942                	ld	s2,16(sp)
    4b1e:	6a02                	ld	s4,0(sp)
    4b20:	a019                	j	4b26 <runtests+0x5c>
    4b22:	6942                	ld	s2,16(sp)
    4b24:	6a02                	ld	s4,0(sp)
        }
      }
    }
  }
  return ntests;
}
    4b26:	854e                	mv	a0,s3
    4b28:	70a2                	ld	ra,40(sp)
    4b2a:	7402                	ld	s0,32(sp)
    4b2c:	64e2                	ld	s1,24(sp)
    4b2e:	69a2                	ld	s3,8(sp)
    4b30:	6145                	addi	sp,sp,48
    4b32:	8082                	ret
  return ntests;
    4b34:	4981                	li	s3,0
    4b36:	bfc5                	j	4b26 <runtests+0x5c>

0000000000004b38 <countfree>:


// use sbrk() to count how many free physical memory pages there are.
int
countfree()
{
    4b38:	7179                	addi	sp,sp,-48
    4b3a:	f406                	sd	ra,40(sp)
    4b3c:	f022                	sd	s0,32(sp)
    4b3e:	ec26                	sd	s1,24(sp)
    4b40:	e84a                	sd	s2,16(sp)
    4b42:	e44e                	sd	s3,8(sp)
    4b44:	e052                	sd	s4,0(sp)
    4b46:	1800                	addi	s0,sp,48
  int n = 0;
  uint64 sz0 = (uint64)sbrk(0);
    4b48:	4501                	li	a0,0
    4b4a:	46c000ef          	jal	4fb6 <sbrk>
    4b4e:	8a2a                	mv	s4,a0
  int n = 0;
    4b50:	4481                	li	s1,0
  while(1){
    char *a = sbrk(PGSIZE);
    4b52:	6985                	lui	s3,0x1
    if(a == SBRK_ERROR){
    4b54:	597d                	li	s2,-1
    char *a = sbrk(PGSIZE);
    4b56:	854e                	mv	a0,s3
    4b58:	45e000ef          	jal	4fb6 <sbrk>
    if(a == SBRK_ERROR){
    4b5c:	01250463          	beq	a0,s2,4b64 <countfree+0x2c>
      break;
    }
    n += 1;
    4b60:	2485                	addiw	s1,s1,1
  while(1){
    4b62:	bfd5                	j	4b56 <countfree+0x1e>
  }
  sbrk(-((uint64)sbrk(0) - sz0));  
    4b64:	4501                	li	a0,0
    4b66:	450000ef          	jal	4fb6 <sbrk>
    4b6a:	40aa053b          	subw	a0,s4,a0
    4b6e:	448000ef          	jal	4fb6 <sbrk>
  return n;
}
    4b72:	8526                	mv	a0,s1
    4b74:	70a2                	ld	ra,40(sp)
    4b76:	7402                	ld	s0,32(sp)
    4b78:	64e2                	ld	s1,24(sp)
    4b7a:	6942                	ld	s2,16(sp)
    4b7c:	69a2                	ld	s3,8(sp)
    4b7e:	6a02                	ld	s4,0(sp)
    4b80:	6145                	addi	sp,sp,48
    4b82:	8082                	ret

0000000000004b84 <drivetests>:

int
drivetests(int quick, int continuous, char *justone) {
    4b84:	7159                	addi	sp,sp,-112
    4b86:	f486                	sd	ra,104(sp)
    4b88:	f0a2                	sd	s0,96(sp)
    4b8a:	eca6                	sd	s1,88(sp)
    4b8c:	e8ca                	sd	s2,80(sp)
    4b8e:	e4ce                	sd	s3,72(sp)
    4b90:	e0d2                	sd	s4,64(sp)
    4b92:	fc56                	sd	s5,56(sp)
    4b94:	f85a                	sd	s6,48(sp)
    4b96:	f45e                	sd	s7,40(sp)
    4b98:	f062                	sd	s8,32(sp)
    4b9a:	ec66                	sd	s9,24(sp)
    4b9c:	e86a                	sd	s10,16(sp)
    4b9e:	e46e                	sd	s11,8(sp)
    4ba0:	1880                	addi	s0,sp,112
    4ba2:	8aaa                	mv	s5,a0
    4ba4:	89ae                	mv	s3,a1
    4ba6:	8a32                	mv	s4,a2
      printf("FAILED -- lost some free pages %d (out of %d)\n", free1, free0);
      if(continuous != 2) {
        return 1;
      }
    }
    if (justone != 0 && ntests == 0) {
    4ba8:	00c03d33          	snez	s10,a2
    printf("usertests starting\n");
    4bac:	00003c17          	auipc	s8,0x3
    4bb0:	b54c0c13          	addi	s8,s8,-1196 # 7700 <malloc+0x2218>
    n = runtests(quicktests, justone, continuous);
    4bb4:	00005b97          	auipc	s7,0x5
    4bb8:	45cb8b93          	addi	s7,s7,1116 # a010 <quicktests>
      if(continuous != 2) {
    4bbc:	4b09                	li	s6,2
      n = runtests(slowtests, justone, continuous);
    4bbe:	00006c97          	auipc	s9,0x6
    4bc2:	862c8c93          	addi	s9,s9,-1950 # a420 <slowtests>
      printf("FAILED -- lost some free pages %d (out of %d)\n", free1, free0);
    4bc6:	00003d97          	auipc	s11,0x3
    4bca:	b72d8d93          	addi	s11,s11,-1166 # 7738 <malloc+0x2250>
    4bce:	a82d                	j	4c08 <drivetests+0x84>
      if(continuous != 2) {
    4bd0:	0b699363          	bne	s3,s6,4c76 <drivetests+0xf2>
    int ntests = 0;
    4bd4:	4481                	li	s1,0
    4bd6:	a0b9                	j	4c24 <drivetests+0xa0>
        printf("usertests slow tests starting\n");
    4bd8:	00003517          	auipc	a0,0x3
    4bdc:	b4050513          	addi	a0,a0,-1216 # 7718 <malloc+0x2230>
    4be0:	051000ef          	jal	5430 <printf>
    4be4:	a0a1                	j	4c2c <drivetests+0xa8>
        if(continuous != 2) {
    4be6:	05698b63          	beq	s3,s6,4c3c <drivetests+0xb8>
          return 1;
    4bea:	4505                	li	a0,1
    4bec:	a0b5                	j	4c58 <drivetests+0xd4>
      printf("FAILED -- lost some free pages %d (out of %d)\n", free1, free0);
    4bee:	864a                	mv	a2,s2
    4bf0:	85aa                	mv	a1,a0
    4bf2:	856e                	mv	a0,s11
    4bf4:	03d000ef          	jal	5430 <printf>
      if(continuous != 2) {
    4bf8:	09699163          	bne	s3,s6,4c7a <drivetests+0xf6>
    if (justone != 0 && ntests == 0) {
    4bfc:	e491                	bnez	s1,4c08 <drivetests+0x84>
    4bfe:	000d0563          	beqz	s10,4c08 <drivetests+0x84>
    4c02:	a0a1                	j	4c4a <drivetests+0xc6>
      printf("NO TESTS EXECUTED\n");
      return 1;
    }
  } while(continuous);
    4c04:	06098d63          	beqz	s3,4c7e <drivetests+0xfa>
    printf("usertests starting\n");
    4c08:	8562                	mv	a0,s8
    4c0a:	027000ef          	jal	5430 <printf>
    int free0 = countfree();
    4c0e:	f2bff0ef          	jal	4b38 <countfree>
    4c12:	892a                	mv	s2,a0
    n = runtests(quicktests, justone, continuous);
    4c14:	864e                	mv	a2,s3
    4c16:	85d2                	mv	a1,s4
    4c18:	855e                	mv	a0,s7
    4c1a:	eb1ff0ef          	jal	4aca <runtests>
    4c1e:	84aa                	mv	s1,a0
    if (n < 0) {
    4c20:	fa0548e3          	bltz	a0,4bd0 <drivetests+0x4c>
    if(!quick) {
    4c24:	000a9c63          	bnez	s5,4c3c <drivetests+0xb8>
      if (justone == 0)
    4c28:	fa0a08e3          	beqz	s4,4bd8 <drivetests+0x54>
      n = runtests(slowtests, justone, continuous);
    4c2c:	864e                	mv	a2,s3
    4c2e:	85d2                	mv	a1,s4
    4c30:	8566                	mv	a0,s9
    4c32:	e99ff0ef          	jal	4aca <runtests>
      if (n < 0) {
    4c36:	fa0548e3          	bltz	a0,4be6 <drivetests+0x62>
        ntests += n;
    4c3a:	9ca9                	addw	s1,s1,a0
    if((free1 = countfree()) < free0) {
    4c3c:	efdff0ef          	jal	4b38 <countfree>
    4c40:	fb2547e3          	blt	a0,s2,4bee <drivetests+0x6a>
    if (justone != 0 && ntests == 0) {
    4c44:	f0e1                	bnez	s1,4c04 <drivetests+0x80>
    4c46:	fa0d0fe3          	beqz	s10,4c04 <drivetests+0x80>
      printf("NO TESTS EXECUTED\n");
    4c4a:	00003517          	auipc	a0,0x3
    4c4e:	b1e50513          	addi	a0,a0,-1250 # 7768 <malloc+0x2280>
    4c52:	7de000ef          	jal	5430 <printf>
      return 1;
    4c56:	4505                	li	a0,1
  return 0;
}
    4c58:	70a6                	ld	ra,104(sp)
    4c5a:	7406                	ld	s0,96(sp)
    4c5c:	64e6                	ld	s1,88(sp)
    4c5e:	6946                	ld	s2,80(sp)
    4c60:	69a6                	ld	s3,72(sp)
    4c62:	6a06                	ld	s4,64(sp)
    4c64:	7ae2                	ld	s5,56(sp)
    4c66:	7b42                	ld	s6,48(sp)
    4c68:	7ba2                	ld	s7,40(sp)
    4c6a:	7c02                	ld	s8,32(sp)
    4c6c:	6ce2                	ld	s9,24(sp)
    4c6e:	6d42                	ld	s10,16(sp)
    4c70:	6da2                	ld	s11,8(sp)
    4c72:	6165                	addi	sp,sp,112
    4c74:	8082                	ret
        return 1;
    4c76:	4505                	li	a0,1
    4c78:	b7c5                	j	4c58 <drivetests+0xd4>
        return 1;
    4c7a:	4505                	li	a0,1
    4c7c:	bff1                	j	4c58 <drivetests+0xd4>
  return 0;
    4c7e:	854e                	mv	a0,s3
    4c80:	bfe1                	j	4c58 <drivetests+0xd4>

0000000000004c82 <main>:

int
main(int argc, char *argv[])
{
    4c82:	1101                	addi	sp,sp,-32
    4c84:	ec06                	sd	ra,24(sp)
    4c86:	e822                	sd	s0,16(sp)
    4c88:	e426                	sd	s1,8(sp)
    4c8a:	e04a                	sd	s2,0(sp)
    4c8c:	1000                	addi	s0,sp,32
    4c8e:	84aa                	mv	s1,a0
  int continuous = 0;
  int quick = 0;
  char *justone = 0;

  if(argc == 2 && strcmp(argv[1], "-q") == 0){
    4c90:	4789                	li	a5,2
    4c92:	00f50e63          	beq	a0,a5,4cae <main+0x2c>
    continuous = 1;
  } else if(argc == 2 && strcmp(argv[1], "-C") == 0){
    continuous = 2;
  } else if(argc == 2 && argv[1][0] != '-'){
    justone = argv[1];
  } else if(argc > 1){
    4c96:	4785                	li	a5,1
    4c98:	06a7c663          	blt	a5,a0,4d04 <main+0x82>
  char *justone = 0;
    4c9c:	4601                	li	a2,0
  int quick = 0;
    4c9e:	4501                	li	a0,0
  int continuous = 0;
    4ca0:	4581                	li	a1,0
    printf("Usage: usertests [-c] [-C] [-q] [testname]\n");
    exit(1);
  }
  if (drivetests(quick, continuous, justone)) {
    4ca2:	ee3ff0ef          	jal	4b84 <drivetests>
    4ca6:	cd35                	beqz	a0,4d22 <main+0xa0>
    exit(1);
    4ca8:	4505                	li	a0,1
    4caa:	340000ef          	jal	4fea <exit>
    4cae:	892e                	mv	s2,a1
  if(argc == 2 && strcmp(argv[1], "-q") == 0){
    4cb0:	00003597          	auipc	a1,0x3
    4cb4:	ad058593          	addi	a1,a1,-1328 # 7780 <malloc+0x2298>
    4cb8:	00893503          	ld	a0,8(s2)
    4cbc:	0a8000ef          	jal	4d64 <strcmp>
    4cc0:	85aa                	mv	a1,a0
    4cc2:	e501                	bnez	a0,4cca <main+0x48>
  char *justone = 0;
    4cc4:	4601                	li	a2,0
    quick = 1;
    4cc6:	4505                	li	a0,1
    4cc8:	bfe9                	j	4ca2 <main+0x20>
  } else if(argc == 2 && strcmp(argv[1], "-c") == 0){
    4cca:	00003597          	auipc	a1,0x3
    4cce:	abe58593          	addi	a1,a1,-1346 # 7788 <malloc+0x22a0>
    4cd2:	00893503          	ld	a0,8(s2)
    4cd6:	08e000ef          	jal	4d64 <strcmp>
    4cda:	cd15                	beqz	a0,4d16 <main+0x94>
  } else if(argc == 2 && strcmp(argv[1], "-C") == 0){
    4cdc:	00003597          	auipc	a1,0x3
    4ce0:	afc58593          	addi	a1,a1,-1284 # 77d8 <malloc+0x22f0>
    4ce4:	00893503          	ld	a0,8(s2)
    4ce8:	07c000ef          	jal	4d64 <strcmp>
    4cec:	c905                	beqz	a0,4d1c <main+0x9a>
  } else if(argc == 2 && argv[1][0] != '-'){
    4cee:	00893603          	ld	a2,8(s2)
    4cf2:	00064703          	lbu	a4,0(a2)
    4cf6:	02d00793          	li	a5,45
    4cfa:	00f70563          	beq	a4,a5,4d04 <main+0x82>
  int quick = 0;
    4cfe:	4501                	li	a0,0
  int continuous = 0;
    4d00:	4581                	li	a1,0
    4d02:	b745                	j	4ca2 <main+0x20>
    printf("Usage: usertests [-c] [-C] [-q] [testname]\n");
    4d04:	00003517          	auipc	a0,0x3
    4d08:	a8c50513          	addi	a0,a0,-1396 # 7790 <malloc+0x22a8>
    4d0c:	724000ef          	jal	5430 <printf>
    exit(1);
    4d10:	4505                	li	a0,1
    4d12:	2d8000ef          	jal	4fea <exit>
  char *justone = 0;
    4d16:	4601                	li	a2,0
    continuous = 1;
    4d18:	4585                	li	a1,1
    4d1a:	b761                	j	4ca2 <main+0x20>
    continuous = 2;
    4d1c:	85a6                	mv	a1,s1
  char *justone = 0;
    4d1e:	4601                	li	a2,0
    4d20:	b749                	j	4ca2 <main+0x20>
  }
  printf("ALL TESTS PASSED\n");
    4d22:	00003517          	auipc	a0,0x3
    4d26:	a9e50513          	addi	a0,a0,-1378 # 77c0 <malloc+0x22d8>
    4d2a:	706000ef          	jal	5430 <printf>
  exit(0);
    4d2e:	4501                	li	a0,0
    4d30:	2ba000ef          	jal	4fea <exit>

0000000000004d34 <start>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
start(int argc, char **argv)
{
    4d34:	1141                	addi	sp,sp,-16
    4d36:	e406                	sd	ra,8(sp)
    4d38:	e022                	sd	s0,0(sp)
    4d3a:	0800                	addi	s0,sp,16
  int r;
  extern int main(int argc, char **argv);
  r = main(argc, argv);
    4d3c:	f47ff0ef          	jal	4c82 <main>
  exit(r);
    4d40:	2aa000ef          	jal	4fea <exit>

0000000000004d44 <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
    4d44:	1141                	addi	sp,sp,-16
    4d46:	e406                	sd	ra,8(sp)
    4d48:	e022                	sd	s0,0(sp)
    4d4a:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
    4d4c:	87aa                	mv	a5,a0
    4d4e:	0585                	addi	a1,a1,1
    4d50:	0785                	addi	a5,a5,1
    4d52:	fff5c703          	lbu	a4,-1(a1)
    4d56:	fee78fa3          	sb	a4,-1(a5)
    4d5a:	fb75                	bnez	a4,4d4e <strcpy+0xa>
    ;
  return os;
}
    4d5c:	60a2                	ld	ra,8(sp)
    4d5e:	6402                	ld	s0,0(sp)
    4d60:	0141                	addi	sp,sp,16
    4d62:	8082                	ret

0000000000004d64 <strcmp>:

int
strcmp(const char *p, const char *q)
{
    4d64:	1141                	addi	sp,sp,-16
    4d66:	e406                	sd	ra,8(sp)
    4d68:	e022                	sd	s0,0(sp)
    4d6a:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
    4d6c:	00054783          	lbu	a5,0(a0)
    4d70:	cb91                	beqz	a5,4d84 <strcmp+0x20>
    4d72:	0005c703          	lbu	a4,0(a1)
    4d76:	00f71763          	bne	a4,a5,4d84 <strcmp+0x20>
    p++, q++;
    4d7a:	0505                	addi	a0,a0,1
    4d7c:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
    4d7e:	00054783          	lbu	a5,0(a0)
    4d82:	fbe5                	bnez	a5,4d72 <strcmp+0xe>
  return (uchar)*p - (uchar)*q;
    4d84:	0005c503          	lbu	a0,0(a1)
}
    4d88:	40a7853b          	subw	a0,a5,a0
    4d8c:	60a2                	ld	ra,8(sp)
    4d8e:	6402                	ld	s0,0(sp)
    4d90:	0141                	addi	sp,sp,16
    4d92:	8082                	ret

0000000000004d94 <strlen>:

uint
strlen(const char *s)
{
    4d94:	1141                	addi	sp,sp,-16
    4d96:	e406                	sd	ra,8(sp)
    4d98:	e022                	sd	s0,0(sp)
    4d9a:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
    4d9c:	00054783          	lbu	a5,0(a0)
    4da0:	cf91                	beqz	a5,4dbc <strlen+0x28>
    4da2:	00150793          	addi	a5,a0,1
    4da6:	86be                	mv	a3,a5
    4da8:	0785                	addi	a5,a5,1
    4daa:	fff7c703          	lbu	a4,-1(a5)
    4dae:	ff65                	bnez	a4,4da6 <strlen+0x12>
    4db0:	40a6853b          	subw	a0,a3,a0
    ;
  return n;
}
    4db4:	60a2                	ld	ra,8(sp)
    4db6:	6402                	ld	s0,0(sp)
    4db8:	0141                	addi	sp,sp,16
    4dba:	8082                	ret
  for(n = 0; s[n]; n++)
    4dbc:	4501                	li	a0,0
    4dbe:	bfdd                	j	4db4 <strlen+0x20>

0000000000004dc0 <memset>:

void*
memset(void *dst, int c, uint n)
{
    4dc0:	1141                	addi	sp,sp,-16
    4dc2:	e406                	sd	ra,8(sp)
    4dc4:	e022                	sd	s0,0(sp)
    4dc6:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
    4dc8:	ca19                	beqz	a2,4dde <memset+0x1e>
    4dca:	87aa                	mv	a5,a0
    4dcc:	1602                	slli	a2,a2,0x20
    4dce:	9201                	srli	a2,a2,0x20
    4dd0:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
    4dd4:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
    4dd8:	0785                	addi	a5,a5,1
    4dda:	fee79de3          	bne	a5,a4,4dd4 <memset+0x14>
  }
  return dst;
}
    4dde:	60a2                	ld	ra,8(sp)
    4de0:	6402                	ld	s0,0(sp)
    4de2:	0141                	addi	sp,sp,16
    4de4:	8082                	ret

0000000000004de6 <strchr>:

char*
strchr(const char *s, char c)
{
    4de6:	1141                	addi	sp,sp,-16
    4de8:	e406                	sd	ra,8(sp)
    4dea:	e022                	sd	s0,0(sp)
    4dec:	0800                	addi	s0,sp,16
  for(; *s; s++)
    4dee:	00054783          	lbu	a5,0(a0)
    4df2:	cf81                	beqz	a5,4e0a <strchr+0x24>
    if(*s == c)
    4df4:	00f58763          	beq	a1,a5,4e02 <strchr+0x1c>
  for(; *s; s++)
    4df8:	0505                	addi	a0,a0,1
    4dfa:	00054783          	lbu	a5,0(a0)
    4dfe:	fbfd                	bnez	a5,4df4 <strchr+0xe>
      return (char*)s;
  return 0;
    4e00:	4501                	li	a0,0
}
    4e02:	60a2                	ld	ra,8(sp)
    4e04:	6402                	ld	s0,0(sp)
    4e06:	0141                	addi	sp,sp,16
    4e08:	8082                	ret
  return 0;
    4e0a:	4501                	li	a0,0
    4e0c:	bfdd                	j	4e02 <strchr+0x1c>

0000000000004e0e <gets>:

char*
gets(char *buf, int max)
{
    4e0e:	711d                	addi	sp,sp,-96
    4e10:	ec86                	sd	ra,88(sp)
    4e12:	e8a2                	sd	s0,80(sp)
    4e14:	e4a6                	sd	s1,72(sp)
    4e16:	e0ca                	sd	s2,64(sp)
    4e18:	fc4e                	sd	s3,56(sp)
    4e1a:	f852                	sd	s4,48(sp)
    4e1c:	f456                	sd	s5,40(sp)
    4e1e:	f05a                	sd	s6,32(sp)
    4e20:	ec5e                	sd	s7,24(sp)
    4e22:	e862                	sd	s8,16(sp)
    4e24:	1080                	addi	s0,sp,96
    4e26:	8baa                	mv	s7,a0
    4e28:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
    4e2a:	892a                	mv	s2,a0
    4e2c:	4481                	li	s1,0
    cc = read(0, &c, 1);
    4e2e:	faf40b13          	addi	s6,s0,-81
    4e32:	4a85                	li	s5,1
  for(i=0; i+1 < max; ){
    4e34:	8c26                	mv	s8,s1
    4e36:	0014899b          	addiw	s3,s1,1
    4e3a:	84ce                	mv	s1,s3
    4e3c:	0349d463          	bge	s3,s4,4e64 <gets+0x56>
    cc = read(0, &c, 1);
    4e40:	8656                	mv	a2,s5
    4e42:	85da                	mv	a1,s6
    4e44:	4501                	li	a0,0
    4e46:	1bc000ef          	jal	5002 <read>
    if(cc < 1)
    4e4a:	00a05d63          	blez	a0,4e64 <gets+0x56>
      break;
    buf[i++] = c;
    4e4e:	faf44783          	lbu	a5,-81(s0)
    4e52:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
    4e56:	0905                	addi	s2,s2,1
    4e58:	ff678713          	addi	a4,a5,-10
    4e5c:	c319                	beqz	a4,4e62 <gets+0x54>
    4e5e:	17cd                	addi	a5,a5,-13
    4e60:	fbf1                	bnez	a5,4e34 <gets+0x26>
    buf[i++] = c;
    4e62:	8c4e                	mv	s8,s3
      break;
  }
  buf[i] = '\0';
    4e64:	9c5e                	add	s8,s8,s7
    4e66:	000c0023          	sb	zero,0(s8)
  return buf;
}
    4e6a:	855e                	mv	a0,s7
    4e6c:	60e6                	ld	ra,88(sp)
    4e6e:	6446                	ld	s0,80(sp)
    4e70:	64a6                	ld	s1,72(sp)
    4e72:	6906                	ld	s2,64(sp)
    4e74:	79e2                	ld	s3,56(sp)
    4e76:	7a42                	ld	s4,48(sp)
    4e78:	7aa2                	ld	s5,40(sp)
    4e7a:	7b02                	ld	s6,32(sp)
    4e7c:	6be2                	ld	s7,24(sp)
    4e7e:	6c42                	ld	s8,16(sp)
    4e80:	6125                	addi	sp,sp,96
    4e82:	8082                	ret

0000000000004e84 <stat>:

int
stat(const char *n, struct stat *st)
{
    4e84:	1101                	addi	sp,sp,-32
    4e86:	ec06                	sd	ra,24(sp)
    4e88:	e822                	sd	s0,16(sp)
    4e8a:	e04a                	sd	s2,0(sp)
    4e8c:	1000                	addi	s0,sp,32
    4e8e:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
    4e90:	4581                	li	a1,0
    4e92:	198000ef          	jal	502a <open>
  if(fd < 0)
    4e96:	02054263          	bltz	a0,4eba <stat+0x36>
    4e9a:	e426                	sd	s1,8(sp)
    4e9c:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
    4e9e:	85ca                	mv	a1,s2
    4ea0:	1a2000ef          	jal	5042 <fstat>
    4ea4:	892a                	mv	s2,a0
  close(fd);
    4ea6:	8526                	mv	a0,s1
    4ea8:	16a000ef          	jal	5012 <close>
  return r;
    4eac:	64a2                	ld	s1,8(sp)
}
    4eae:	854a                	mv	a0,s2
    4eb0:	60e2                	ld	ra,24(sp)
    4eb2:	6442                	ld	s0,16(sp)
    4eb4:	6902                	ld	s2,0(sp)
    4eb6:	6105                	addi	sp,sp,32
    4eb8:	8082                	ret
    return -1;
    4eba:	57fd                	li	a5,-1
    4ebc:	893e                	mv	s2,a5
    4ebe:	bfc5                	j	4eae <stat+0x2a>

0000000000004ec0 <atoi>:

int
atoi(const char *s)
{
    4ec0:	1141                	addi	sp,sp,-16
    4ec2:	e406                	sd	ra,8(sp)
    4ec4:	e022                	sd	s0,0(sp)
    4ec6:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
    4ec8:	00054683          	lbu	a3,0(a0)
    4ecc:	fd06879b          	addiw	a5,a3,-48 # 3ffd0 <base+0x2f318>
    4ed0:	0ff7f793          	zext.b	a5,a5
    4ed4:	4625                	li	a2,9
    4ed6:	02f66963          	bltu	a2,a5,4f08 <atoi+0x48>
    4eda:	872a                	mv	a4,a0
  n = 0;
    4edc:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
    4ede:	0705                	addi	a4,a4,1 # 1000001 <base+0xfef349>
    4ee0:	0025179b          	slliw	a5,a0,0x2
    4ee4:	9fa9                	addw	a5,a5,a0
    4ee6:	0017979b          	slliw	a5,a5,0x1
    4eea:	9fb5                	addw	a5,a5,a3
    4eec:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
    4ef0:	00074683          	lbu	a3,0(a4)
    4ef4:	fd06879b          	addiw	a5,a3,-48
    4ef8:	0ff7f793          	zext.b	a5,a5
    4efc:	fef671e3          	bgeu	a2,a5,4ede <atoi+0x1e>
  return n;
}
    4f00:	60a2                	ld	ra,8(sp)
    4f02:	6402                	ld	s0,0(sp)
    4f04:	0141                	addi	sp,sp,16
    4f06:	8082                	ret
  n = 0;
    4f08:	4501                	li	a0,0
    4f0a:	bfdd                	j	4f00 <atoi+0x40>

0000000000004f0c <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
    4f0c:	1141                	addi	sp,sp,-16
    4f0e:	e406                	sd	ra,8(sp)
    4f10:	e022                	sd	s0,0(sp)
    4f12:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
    4f14:	02b57563          	bgeu	a0,a1,4f3e <memmove+0x32>
    while(n-- > 0)
    4f18:	00c05f63          	blez	a2,4f36 <memmove+0x2a>
    4f1c:	1602                	slli	a2,a2,0x20
    4f1e:	9201                	srli	a2,a2,0x20
    4f20:	00c507b3          	add	a5,a0,a2
  dst = vdst;
    4f24:	872a                	mv	a4,a0
      *dst++ = *src++;
    4f26:	0585                	addi	a1,a1,1
    4f28:	0705                	addi	a4,a4,1
    4f2a:	fff5c683          	lbu	a3,-1(a1)
    4f2e:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
    4f32:	fee79ae3          	bne	a5,a4,4f26 <memmove+0x1a>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
    4f36:	60a2                	ld	ra,8(sp)
    4f38:	6402                	ld	s0,0(sp)
    4f3a:	0141                	addi	sp,sp,16
    4f3c:	8082                	ret
    while(n-- > 0)
    4f3e:	fec05ce3          	blez	a2,4f36 <memmove+0x2a>
    dst += n;
    4f42:	00c50733          	add	a4,a0,a2
    src += n;
    4f46:	95b2                	add	a1,a1,a2
    4f48:	fff6079b          	addiw	a5,a2,-1
    4f4c:	1782                	slli	a5,a5,0x20
    4f4e:	9381                	srli	a5,a5,0x20
    4f50:	fff7c793          	not	a5,a5
    4f54:	97ba                	add	a5,a5,a4
      *--dst = *--src;
    4f56:	15fd                	addi	a1,a1,-1
    4f58:	177d                	addi	a4,a4,-1
    4f5a:	0005c683          	lbu	a3,0(a1)
    4f5e:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
    4f62:	fef71ae3          	bne	a4,a5,4f56 <memmove+0x4a>
    4f66:	bfc1                	j	4f36 <memmove+0x2a>

0000000000004f68 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
    4f68:	1141                	addi	sp,sp,-16
    4f6a:	e406                	sd	ra,8(sp)
    4f6c:	e022                	sd	s0,0(sp)
    4f6e:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
    4f70:	c61d                	beqz	a2,4f9e <memcmp+0x36>
    4f72:	1602                	slli	a2,a2,0x20
    4f74:	9201                	srli	a2,a2,0x20
    4f76:	00c506b3          	add	a3,a0,a2
    if (*p1 != *p2) {
    4f7a:	00054783          	lbu	a5,0(a0)
    4f7e:	0005c703          	lbu	a4,0(a1)
    4f82:	00e79863          	bne	a5,a4,4f92 <memcmp+0x2a>
      return *p1 - *p2;
    }
    p1++;
    4f86:	0505                	addi	a0,a0,1
    p2++;
    4f88:	0585                	addi	a1,a1,1
  while (n-- > 0) {
    4f8a:	fed518e3          	bne	a0,a3,4f7a <memcmp+0x12>
  }
  return 0;
    4f8e:	4501                	li	a0,0
    4f90:	a019                	j	4f96 <memcmp+0x2e>
      return *p1 - *p2;
    4f92:	40e7853b          	subw	a0,a5,a4
}
    4f96:	60a2                	ld	ra,8(sp)
    4f98:	6402                	ld	s0,0(sp)
    4f9a:	0141                	addi	sp,sp,16
    4f9c:	8082                	ret
  return 0;
    4f9e:	4501                	li	a0,0
    4fa0:	bfdd                	j	4f96 <memcmp+0x2e>

0000000000004fa2 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
    4fa2:	1141                	addi	sp,sp,-16
    4fa4:	e406                	sd	ra,8(sp)
    4fa6:	e022                	sd	s0,0(sp)
    4fa8:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
    4faa:	f63ff0ef          	jal	4f0c <memmove>
}
    4fae:	60a2                	ld	ra,8(sp)
    4fb0:	6402                	ld	s0,0(sp)
    4fb2:	0141                	addi	sp,sp,16
    4fb4:	8082                	ret

0000000000004fb6 <sbrk>:

char *
sbrk(int n) {
    4fb6:	1141                	addi	sp,sp,-16
    4fb8:	e406                	sd	ra,8(sp)
    4fba:	e022                	sd	s0,0(sp)
    4fbc:	0800                	addi	s0,sp,16
  return sys_sbrk(n, SBRK_EAGER);
    4fbe:	4585                	li	a1,1
    4fc0:	0b2000ef          	jal	5072 <sys_sbrk>
}
    4fc4:	60a2                	ld	ra,8(sp)
    4fc6:	6402                	ld	s0,0(sp)
    4fc8:	0141                	addi	sp,sp,16
    4fca:	8082                	ret

0000000000004fcc <sbrklazy>:

char *
sbrklazy(int n) {
    4fcc:	1141                	addi	sp,sp,-16
    4fce:	e406                	sd	ra,8(sp)
    4fd0:	e022                	sd	s0,0(sp)
    4fd2:	0800                	addi	s0,sp,16
  return sys_sbrk(n, SBRK_LAZY);
    4fd4:	4589                	li	a1,2
    4fd6:	09c000ef          	jal	5072 <sys_sbrk>
}
    4fda:	60a2                	ld	ra,8(sp)
    4fdc:	6402                	ld	s0,0(sp)
    4fde:	0141                	addi	sp,sp,16
    4fe0:	8082                	ret

0000000000004fe2 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
    4fe2:	4885                	li	a7,1
 ecall
    4fe4:	00000073          	ecall
 ret
    4fe8:	8082                	ret

0000000000004fea <exit>:
.global exit
exit:
 li a7, SYS_exit
    4fea:	4889                	li	a7,2
 ecall
    4fec:	00000073          	ecall
 ret
    4ff0:	8082                	ret

0000000000004ff2 <wait>:
.global wait
wait:
 li a7, SYS_wait
    4ff2:	488d                	li	a7,3
 ecall
    4ff4:	00000073          	ecall
 ret
    4ff8:	8082                	ret

0000000000004ffa <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
    4ffa:	4891                	li	a7,4
 ecall
    4ffc:	00000073          	ecall
 ret
    5000:	8082                	ret

0000000000005002 <read>:
.global read
read:
 li a7, SYS_read
    5002:	4895                	li	a7,5
 ecall
    5004:	00000073          	ecall
 ret
    5008:	8082                	ret

000000000000500a <write>:
.global write
write:
 li a7, SYS_write
    500a:	48c1                	li	a7,16
 ecall
    500c:	00000073          	ecall
 ret
    5010:	8082                	ret

0000000000005012 <close>:
.global close
close:
 li a7, SYS_close
    5012:	48d5                	li	a7,21
 ecall
    5014:	00000073          	ecall
 ret
    5018:	8082                	ret

000000000000501a <kill>:
.global kill
kill:
 li a7, SYS_kill
    501a:	4899                	li	a7,6
 ecall
    501c:	00000073          	ecall
 ret
    5020:	8082                	ret

0000000000005022 <exec>:
.global exec
exec:
 li a7, SYS_exec
    5022:	489d                	li	a7,7
 ecall
    5024:	00000073          	ecall
 ret
    5028:	8082                	ret

000000000000502a <open>:
.global open
open:
 li a7, SYS_open
    502a:	48bd                	li	a7,15
 ecall
    502c:	00000073          	ecall
 ret
    5030:	8082                	ret

0000000000005032 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
    5032:	48c5                	li	a7,17
 ecall
    5034:	00000073          	ecall
 ret
    5038:	8082                	ret

000000000000503a <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
    503a:	48c9                	li	a7,18
 ecall
    503c:	00000073          	ecall
 ret
    5040:	8082                	ret

0000000000005042 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
    5042:	48a1                	li	a7,8
 ecall
    5044:	00000073          	ecall
 ret
    5048:	8082                	ret

000000000000504a <link>:
.global link
link:
 li a7, SYS_link
    504a:	48cd                	li	a7,19
 ecall
    504c:	00000073          	ecall
 ret
    5050:	8082                	ret

0000000000005052 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
    5052:	48d1                	li	a7,20
 ecall
    5054:	00000073          	ecall
 ret
    5058:	8082                	ret

000000000000505a <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
    505a:	48a5                	li	a7,9
 ecall
    505c:	00000073          	ecall
 ret
    5060:	8082                	ret

0000000000005062 <dup>:
.global dup
dup:
 li a7, SYS_dup
    5062:	48a9                	li	a7,10
 ecall
    5064:	00000073          	ecall
 ret
    5068:	8082                	ret

000000000000506a <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
    506a:	48ad                	li	a7,11
 ecall
    506c:	00000073          	ecall
 ret
    5070:	8082                	ret

0000000000005072 <sys_sbrk>:
.global sys_sbrk
sys_sbrk:
 li a7, SYS_sbrk
    5072:	48b1                	li	a7,12
 ecall
    5074:	00000073          	ecall
 ret
    5078:	8082                	ret

000000000000507a <pause>:
.global pause
pause:
 li a7, SYS_pause
    507a:	48b5                	li	a7,13
 ecall
    507c:	00000073          	ecall
 ret
    5080:	8082                	ret

0000000000005082 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
    5082:	48b9                	li	a7,14
 ecall
    5084:	00000073          	ecall
 ret
    5088:	8082                	ret

000000000000508a <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
    508a:	1101                	addi	sp,sp,-32
    508c:	ec06                	sd	ra,24(sp)
    508e:	e822                	sd	s0,16(sp)
    5090:	1000                	addi	s0,sp,32
    5092:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
    5096:	4605                	li	a2,1
    5098:	fef40593          	addi	a1,s0,-17
    509c:	f6fff0ef          	jal	500a <write>
}
    50a0:	60e2                	ld	ra,24(sp)
    50a2:	6442                	ld	s0,16(sp)
    50a4:	6105                	addi	sp,sp,32
    50a6:	8082                	ret

00000000000050a8 <printint>:

static void
printint(int fd, long long xx, int base, int sgn)
{
    50a8:	715d                	addi	sp,sp,-80
    50aa:	e486                	sd	ra,72(sp)
    50ac:	e0a2                	sd	s0,64(sp)
    50ae:	f84a                	sd	s2,48(sp)
    50b0:	f44e                	sd	s3,40(sp)
    50b2:	0880                	addi	s0,sp,80
    50b4:	892a                	mv	s2,a0
  char buf[20];
  int i, neg;
  unsigned long long x;

  neg = 0;
  if(sgn && xx < 0){
    50b6:	c6d1                	beqz	a3,5142 <printint+0x9a>
    50b8:	0805d563          	bgez	a1,5142 <printint+0x9a>
    neg = 1;
    x = -xx;
    50bc:	40b005b3          	neg	a1,a1
    neg = 1;
    50c0:	4305                	li	t1,1
  } else {
    x = xx;
  }

  i = 0;
    50c2:	fb840993          	addi	s3,s0,-72
  neg = 0;
    50c6:	86ce                	mv	a3,s3
  i = 0;
    50c8:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
    50ca:	00003817          	auipc	a6,0x3
    50ce:	b3e80813          	addi	a6,a6,-1218 # 7c08 <digits>
    50d2:	88ba                	mv	a7,a4
    50d4:	0017051b          	addiw	a0,a4,1
    50d8:	872a                	mv	a4,a0
    50da:	02c5f7b3          	remu	a5,a1,a2
    50de:	97c2                	add	a5,a5,a6
    50e0:	0007c783          	lbu	a5,0(a5)
    50e4:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
    50e8:	87ae                	mv	a5,a1
    50ea:	02c5d5b3          	divu	a1,a1,a2
    50ee:	0685                	addi	a3,a3,1
    50f0:	fec7f1e3          	bgeu	a5,a2,50d2 <printint+0x2a>
  if(neg)
    50f4:	00030c63          	beqz	t1,510c <printint+0x64>
    buf[i++] = '-';
    50f8:	fd050793          	addi	a5,a0,-48
    50fc:	00878533          	add	a0,a5,s0
    5100:	02d00793          	li	a5,45
    5104:	fef50423          	sb	a5,-24(a0)
    5108:	0028871b          	addiw	a4,a7,2

  while(--i >= 0)
    510c:	02e05563          	blez	a4,5136 <printint+0x8e>
    5110:	fc26                	sd	s1,56(sp)
    5112:	377d                	addiw	a4,a4,-1
    5114:	00e984b3          	add	s1,s3,a4
    5118:	19fd                	addi	s3,s3,-1 # fff <bigdir+0x10b>
    511a:	99ba                	add	s3,s3,a4
    511c:	1702                	slli	a4,a4,0x20
    511e:	9301                	srli	a4,a4,0x20
    5120:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
    5124:	0004c583          	lbu	a1,0(s1)
    5128:	854a                	mv	a0,s2
    512a:	f61ff0ef          	jal	508a <putc>
  while(--i >= 0)
    512e:	14fd                	addi	s1,s1,-1
    5130:	ff349ae3          	bne	s1,s3,5124 <printint+0x7c>
    5134:	74e2                	ld	s1,56(sp)
}
    5136:	60a6                	ld	ra,72(sp)
    5138:	6406                	ld	s0,64(sp)
    513a:	7942                	ld	s2,48(sp)
    513c:	79a2                	ld	s3,40(sp)
    513e:	6161                	addi	sp,sp,80
    5140:	8082                	ret
  neg = 0;
    5142:	4301                	li	t1,0
    5144:	bfbd                	j	50c2 <printint+0x1a>

0000000000005146 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %c, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
    5146:	711d                	addi	sp,sp,-96
    5148:	ec86                	sd	ra,88(sp)
    514a:	e8a2                	sd	s0,80(sp)
    514c:	e4a6                	sd	s1,72(sp)
    514e:	1080                	addi	s0,sp,96
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
    5150:	0005c483          	lbu	s1,0(a1)
    5154:	22048363          	beqz	s1,537a <vprintf+0x234>
    5158:	e0ca                	sd	s2,64(sp)
    515a:	fc4e                	sd	s3,56(sp)
    515c:	f852                	sd	s4,48(sp)
    515e:	f456                	sd	s5,40(sp)
    5160:	f05a                	sd	s6,32(sp)
    5162:	ec5e                	sd	s7,24(sp)
    5164:	e862                	sd	s8,16(sp)
    5166:	8b2a                	mv	s6,a0
    5168:	8a2e                	mv	s4,a1
    516a:	8bb2                	mv	s7,a2
  state = 0;
    516c:	4981                	li	s3,0
  for(i = 0; fmt[i]; i++){
    516e:	4901                	li	s2,0
    5170:	4701                	li	a4,0
      if(c0 == '%'){
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if(state == '%'){
    5172:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if(c0) c1 = fmt[i+1] & 0xff;
      if(c1) c2 = fmt[i+2] & 0xff;
      if(c0 == 'd'){
    5176:	06400c13          	li	s8,100
    517a:	a00d                	j	519c <vprintf+0x56>
        putc(fd, c0);
    517c:	85a6                	mv	a1,s1
    517e:	855a                	mv	a0,s6
    5180:	f0bff0ef          	jal	508a <putc>
    5184:	a019                	j	518a <vprintf+0x44>
    } else if(state == '%'){
    5186:	03598363          	beq	s3,s5,51ac <vprintf+0x66>
  for(i = 0; fmt[i]; i++){
    518a:	0019079b          	addiw	a5,s2,1
    518e:	893e                	mv	s2,a5
    5190:	873e                	mv	a4,a5
    5192:	97d2                	add	a5,a5,s4
    5194:	0007c483          	lbu	s1,0(a5)
    5198:	1c048a63          	beqz	s1,536c <vprintf+0x226>
    c0 = fmt[i] & 0xff;
    519c:	0004879b          	sext.w	a5,s1
    if(state == 0){
    51a0:	fe0993e3          	bnez	s3,5186 <vprintf+0x40>
      if(c0 == '%'){
    51a4:	fd579ce3          	bne	a5,s5,517c <vprintf+0x36>
        state = '%';
    51a8:	89be                	mv	s3,a5
    51aa:	b7c5                	j	518a <vprintf+0x44>
      if(c0) c1 = fmt[i+1] & 0xff;
    51ac:	00ea06b3          	add	a3,s4,a4
    51b0:	0016c603          	lbu	a2,1(a3)
      if(c1) c2 = fmt[i+2] & 0xff;
    51b4:	1c060863          	beqz	a2,5384 <vprintf+0x23e>
      if(c0 == 'd'){
    51b8:	03878763          	beq	a5,s8,51e6 <vprintf+0xa0>
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c0 == 'l' && c1 == 'd'){
    51bc:	f9478693          	addi	a3,a5,-108
    51c0:	0016b693          	seqz	a3,a3
    51c4:	f9c60593          	addi	a1,a2,-100
    51c8:	e99d                	bnez	a1,51fe <vprintf+0xb8>
    51ca:	ca95                	beqz	a3,51fe <vprintf+0xb8>
        printint(fd, va_arg(ap, uint64), 10, 1);
    51cc:	008b8493          	addi	s1,s7,8
    51d0:	4685                	li	a3,1
    51d2:	4629                	li	a2,10
    51d4:	000bb583          	ld	a1,0(s7)
    51d8:	855a                	mv	a0,s6
    51da:	ecfff0ef          	jal	50a8 <printint>
        i += 1;
    51de:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 10, 1);
    51e0:	8ba6                	mv	s7,s1
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c0);
      }

      state = 0;
    51e2:	4981                	li	s3,0
    51e4:	b75d                	j	518a <vprintf+0x44>
        printint(fd, va_arg(ap, int), 10, 1);
    51e6:	008b8493          	addi	s1,s7,8
    51ea:	4685                	li	a3,1
    51ec:	4629                	li	a2,10
    51ee:	000ba583          	lw	a1,0(s7)
    51f2:	855a                	mv	a0,s6
    51f4:	eb5ff0ef          	jal	50a8 <printint>
    51f8:	8ba6                	mv	s7,s1
      state = 0;
    51fa:	4981                	li	s3,0
    51fc:	b779                	j	518a <vprintf+0x44>
      if(c1) c2 = fmt[i+2] & 0xff;
    51fe:	9752                	add	a4,a4,s4
    5200:	00274583          	lbu	a1,2(a4)
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
    5204:	f9460713          	addi	a4,a2,-108
    5208:	00173713          	seqz	a4,a4
    520c:	8f75                	and	a4,a4,a3
    520e:	f9c58513          	addi	a0,a1,-100
    5212:	18051363          	bnez	a0,5398 <vprintf+0x252>
    5216:	18070163          	beqz	a4,5398 <vprintf+0x252>
        printint(fd, va_arg(ap, uint64), 10, 1);
    521a:	008b8493          	addi	s1,s7,8
    521e:	4685                	li	a3,1
    5220:	4629                	li	a2,10
    5222:	000bb583          	ld	a1,0(s7)
    5226:	855a                	mv	a0,s6
    5228:	e81ff0ef          	jal	50a8 <printint>
        i += 2;
    522c:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 10, 1);
    522e:	8ba6                	mv	s7,s1
      state = 0;
    5230:	4981                	li	s3,0
        i += 2;
    5232:	bfa1                	j	518a <vprintf+0x44>
        printint(fd, va_arg(ap, uint32), 10, 0);
    5234:	008b8493          	addi	s1,s7,8
    5238:	4681                	li	a3,0
    523a:	4629                	li	a2,10
    523c:	000be583          	lwu	a1,0(s7)
    5240:	855a                	mv	a0,s6
    5242:	e67ff0ef          	jal	50a8 <printint>
    5246:	8ba6                	mv	s7,s1
      state = 0;
    5248:	4981                	li	s3,0
    524a:	b781                	j	518a <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 10, 0);
    524c:	008b8493          	addi	s1,s7,8
    5250:	4681                	li	a3,0
    5252:	4629                	li	a2,10
    5254:	000bb583          	ld	a1,0(s7)
    5258:	855a                	mv	a0,s6
    525a:	e4fff0ef          	jal	50a8 <printint>
        i += 1;
    525e:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 10, 0);
    5260:	8ba6                	mv	s7,s1
      state = 0;
    5262:	4981                	li	s3,0
    5264:	b71d                	j	518a <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 10, 0);
    5266:	008b8493          	addi	s1,s7,8
    526a:	4681                	li	a3,0
    526c:	4629                	li	a2,10
    526e:	000bb583          	ld	a1,0(s7)
    5272:	855a                	mv	a0,s6
    5274:	e35ff0ef          	jal	50a8 <printint>
        i += 2;
    5278:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 10, 0);
    527a:	8ba6                	mv	s7,s1
      state = 0;
    527c:	4981                	li	s3,0
        i += 2;
    527e:	b731                	j	518a <vprintf+0x44>
        printint(fd, va_arg(ap, uint32), 16, 0);
    5280:	008b8493          	addi	s1,s7,8
    5284:	4681                	li	a3,0
    5286:	4641                	li	a2,16
    5288:	000be583          	lwu	a1,0(s7)
    528c:	855a                	mv	a0,s6
    528e:	e1bff0ef          	jal	50a8 <printint>
    5292:	8ba6                	mv	s7,s1
      state = 0;
    5294:	4981                	li	s3,0
    5296:	bdd5                	j	518a <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 16, 0);
    5298:	008b8493          	addi	s1,s7,8
    529c:	4681                	li	a3,0
    529e:	4641                	li	a2,16
    52a0:	000bb583          	ld	a1,0(s7)
    52a4:	855a                	mv	a0,s6
    52a6:	e03ff0ef          	jal	50a8 <printint>
        i += 1;
    52aa:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 16, 0);
    52ac:	8ba6                	mv	s7,s1
      state = 0;
    52ae:	4981                	li	s3,0
    52b0:	bde9                	j	518a <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 16, 0);
    52b2:	008b8493          	addi	s1,s7,8
    52b6:	4681                	li	a3,0
    52b8:	4641                	li	a2,16
    52ba:	000bb583          	ld	a1,0(s7)
    52be:	855a                	mv	a0,s6
    52c0:	de9ff0ef          	jal	50a8 <printint>
        i += 2;
    52c4:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 16, 0);
    52c6:	8ba6                	mv	s7,s1
      state = 0;
    52c8:	4981                	li	s3,0
        i += 2;
    52ca:	b5c1                	j	518a <vprintf+0x44>
    52cc:	e466                	sd	s9,8(sp)
        printptr(fd, va_arg(ap, uint64));
    52ce:	008b8793          	addi	a5,s7,8
    52d2:	8cbe                	mv	s9,a5
    52d4:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
    52d8:	03000593          	li	a1,48
    52dc:	855a                	mv	a0,s6
    52de:	dadff0ef          	jal	508a <putc>
  putc(fd, 'x');
    52e2:	07800593          	li	a1,120
    52e6:	855a                	mv	a0,s6
    52e8:	da3ff0ef          	jal	508a <putc>
    52ec:	44c1                	li	s1,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
    52ee:	00003b97          	auipc	s7,0x3
    52f2:	91ab8b93          	addi	s7,s7,-1766 # 7c08 <digits>
    52f6:	03c9d793          	srli	a5,s3,0x3c
    52fa:	97de                	add	a5,a5,s7
    52fc:	0007c583          	lbu	a1,0(a5)
    5300:	855a                	mv	a0,s6
    5302:	d89ff0ef          	jal	508a <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
    5306:	0992                	slli	s3,s3,0x4
    5308:	34fd                	addiw	s1,s1,-1
    530a:	f4f5                	bnez	s1,52f6 <vprintf+0x1b0>
        printptr(fd, va_arg(ap, uint64));
    530c:	8be6                	mv	s7,s9
      state = 0;
    530e:	4981                	li	s3,0
    5310:	6ca2                	ld	s9,8(sp)
    5312:	bda5                	j	518a <vprintf+0x44>
        putc(fd, va_arg(ap, uint32));
    5314:	008b8493          	addi	s1,s7,8
    5318:	000bc583          	lbu	a1,0(s7)
    531c:	855a                	mv	a0,s6
    531e:	d6dff0ef          	jal	508a <putc>
    5322:	8ba6                	mv	s7,s1
      state = 0;
    5324:	4981                	li	s3,0
    5326:	b595                	j	518a <vprintf+0x44>
        if((s = va_arg(ap, char*)) == 0)
    5328:	008b8993          	addi	s3,s7,8
    532c:	000bb483          	ld	s1,0(s7)
    5330:	cc91                	beqz	s1,534c <vprintf+0x206>
        for(; *s; s++)
    5332:	0004c583          	lbu	a1,0(s1)
    5336:	c985                	beqz	a1,5366 <vprintf+0x220>
          putc(fd, *s);
    5338:	855a                	mv	a0,s6
    533a:	d51ff0ef          	jal	508a <putc>
        for(; *s; s++)
    533e:	0485                	addi	s1,s1,1
    5340:	0004c583          	lbu	a1,0(s1)
    5344:	f9f5                	bnez	a1,5338 <vprintf+0x1f2>
        if((s = va_arg(ap, char*)) == 0)
    5346:	8bce                	mv	s7,s3
      state = 0;
    5348:	4981                	li	s3,0
    534a:	b581                	j	518a <vprintf+0x44>
          s = "(null)";
    534c:	00003497          	auipc	s1,0x3
    5350:	80c48493          	addi	s1,s1,-2036 # 7b58 <malloc+0x2670>
        for(; *s; s++)
    5354:	02800593          	li	a1,40
    5358:	b7c5                	j	5338 <vprintf+0x1f2>
        putc(fd, '%');
    535a:	85be                	mv	a1,a5
    535c:	855a                	mv	a0,s6
    535e:	d2dff0ef          	jal	508a <putc>
      state = 0;
    5362:	4981                	li	s3,0
    5364:	b51d                	j	518a <vprintf+0x44>
        if((s = va_arg(ap, char*)) == 0)
    5366:	8bce                	mv	s7,s3
      state = 0;
    5368:	4981                	li	s3,0
    536a:	b505                	j	518a <vprintf+0x44>
    536c:	6906                	ld	s2,64(sp)
    536e:	79e2                	ld	s3,56(sp)
    5370:	7a42                	ld	s4,48(sp)
    5372:	7aa2                	ld	s5,40(sp)
    5374:	7b02                	ld	s6,32(sp)
    5376:	6be2                	ld	s7,24(sp)
    5378:	6c42                	ld	s8,16(sp)
    }
  }
}
    537a:	60e6                	ld	ra,88(sp)
    537c:	6446                	ld	s0,80(sp)
    537e:	64a6                	ld	s1,72(sp)
    5380:	6125                	addi	sp,sp,96
    5382:	8082                	ret
      if(c0 == 'd'){
    5384:	06400713          	li	a4,100
    5388:	e4e78fe3          	beq	a5,a4,51e6 <vprintf+0xa0>
      } else if(c0 == 'l' && c1 == 'd'){
    538c:	f9478693          	addi	a3,a5,-108
    5390:	0016b693          	seqz	a3,a3
      c1 = c2 = 0;
    5394:	85b2                	mv	a1,a2
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
    5396:	4701                	li	a4,0
      } else if(c0 == 'u'){
    5398:	07500513          	li	a0,117
    539c:	e8a78ce3          	beq	a5,a0,5234 <vprintf+0xee>
      } else if(c0 == 'l' && c1 == 'u'){
    53a0:	f8b60513          	addi	a0,a2,-117
    53a4:	e119                	bnez	a0,53aa <vprintf+0x264>
    53a6:	ea0693e3          	bnez	a3,524c <vprintf+0x106>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
    53aa:	f8b58513          	addi	a0,a1,-117
    53ae:	e119                	bnez	a0,53b4 <vprintf+0x26e>
    53b0:	ea071be3          	bnez	a4,5266 <vprintf+0x120>
      } else if(c0 == 'x'){
    53b4:	07800513          	li	a0,120
    53b8:	eca784e3          	beq	a5,a0,5280 <vprintf+0x13a>
      } else if(c0 == 'l' && c1 == 'x'){
    53bc:	f8860613          	addi	a2,a2,-120
    53c0:	e219                	bnez	a2,53c6 <vprintf+0x280>
    53c2:	ec069be3          	bnez	a3,5298 <vprintf+0x152>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
    53c6:	f8858593          	addi	a1,a1,-120
    53ca:	e199                	bnez	a1,53d0 <vprintf+0x28a>
    53cc:	ee0713e3          	bnez	a4,52b2 <vprintf+0x16c>
      } else if(c0 == 'p'){
    53d0:	07000713          	li	a4,112
    53d4:	eee78ce3          	beq	a5,a4,52cc <vprintf+0x186>
      } else if(c0 == 'c'){
    53d8:	06300713          	li	a4,99
    53dc:	f2e78ce3          	beq	a5,a4,5314 <vprintf+0x1ce>
      } else if(c0 == 's'){
    53e0:	07300713          	li	a4,115
    53e4:	f4e782e3          	beq	a5,a4,5328 <vprintf+0x1e2>
      } else if(c0 == '%'){
    53e8:	02500713          	li	a4,37
    53ec:	f6e787e3          	beq	a5,a4,535a <vprintf+0x214>
        putc(fd, '%');
    53f0:	02500593          	li	a1,37
    53f4:	855a                	mv	a0,s6
    53f6:	c95ff0ef          	jal	508a <putc>
        putc(fd, c0);
    53fa:	85a6                	mv	a1,s1
    53fc:	855a                	mv	a0,s6
    53fe:	c8dff0ef          	jal	508a <putc>
      state = 0;
    5402:	4981                	li	s3,0
    5404:	b359                	j	518a <vprintf+0x44>

0000000000005406 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
    5406:	715d                	addi	sp,sp,-80
    5408:	ec06                	sd	ra,24(sp)
    540a:	e822                	sd	s0,16(sp)
    540c:	1000                	addi	s0,sp,32
    540e:	e010                	sd	a2,0(s0)
    5410:	e414                	sd	a3,8(s0)
    5412:	e818                	sd	a4,16(s0)
    5414:	ec1c                	sd	a5,24(s0)
    5416:	03043023          	sd	a6,32(s0)
    541a:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
    541e:	8622                	mv	a2,s0
    5420:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
    5424:	d23ff0ef          	jal	5146 <vprintf>
}
    5428:	60e2                	ld	ra,24(sp)
    542a:	6442                	ld	s0,16(sp)
    542c:	6161                	addi	sp,sp,80
    542e:	8082                	ret

0000000000005430 <printf>:

void
printf(const char *fmt, ...)
{
    5430:	711d                	addi	sp,sp,-96
    5432:	ec06                	sd	ra,24(sp)
    5434:	e822                	sd	s0,16(sp)
    5436:	1000                	addi	s0,sp,32
    5438:	e40c                	sd	a1,8(s0)
    543a:	e810                	sd	a2,16(s0)
    543c:	ec14                	sd	a3,24(s0)
    543e:	f018                	sd	a4,32(s0)
    5440:	f41c                	sd	a5,40(s0)
    5442:	03043823          	sd	a6,48(s0)
    5446:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
    544a:	00840613          	addi	a2,s0,8
    544e:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
    5452:	85aa                	mv	a1,a0
    5454:	4505                	li	a0,1
    5456:	cf1ff0ef          	jal	5146 <vprintf>
}
    545a:	60e2                	ld	ra,24(sp)
    545c:	6442                	ld	s0,16(sp)
    545e:	6125                	addi	sp,sp,96
    5460:	8082                	ret

0000000000005462 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
    5462:	1141                	addi	sp,sp,-16
    5464:	e406                	sd	ra,8(sp)
    5466:	e022                	sd	s0,0(sp)
    5468:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
    546a:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    546e:	00005797          	auipc	a5,0x5
    5472:	0227b783          	ld	a5,34(a5) # a490 <freep>
    5476:	a039                	j	5484 <free+0x22>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    5478:	6398                	ld	a4,0(a5)
    547a:	00e7e463          	bltu	a5,a4,5482 <free+0x20>
    547e:	00e6ea63          	bltu	a3,a4,5492 <free+0x30>
{
    5482:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    5484:	fed7fae3          	bgeu	a5,a3,5478 <free+0x16>
    5488:	6398                	ld	a4,0(a5)
    548a:	00e6e463          	bltu	a3,a4,5492 <free+0x30>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    548e:	fee7eae3          	bltu	a5,a4,5482 <free+0x20>
      break;
  if(bp + bp->s.size == p->s.ptr){
    5492:	ff852583          	lw	a1,-8(a0)
    5496:	6390                	ld	a2,0(a5)
    5498:	02059813          	slli	a6,a1,0x20
    549c:	01c85713          	srli	a4,a6,0x1c
    54a0:	9736                	add	a4,a4,a3
    54a2:	02e60563          	beq	a2,a4,54cc <free+0x6a>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
    54a6:	fec53823          	sd	a2,-16(a0)
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    54aa:	4790                	lw	a2,8(a5)
    54ac:	02061593          	slli	a1,a2,0x20
    54b0:	01c5d713          	srli	a4,a1,0x1c
    54b4:	973e                	add	a4,a4,a5
    54b6:	02e68263          	beq	a3,a4,54da <free+0x78>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
    54ba:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
    54bc:	00005717          	auipc	a4,0x5
    54c0:	fcf73a23          	sd	a5,-44(a4) # a490 <freep>
}
    54c4:	60a2                	ld	ra,8(sp)
    54c6:	6402                	ld	s0,0(sp)
    54c8:	0141                	addi	sp,sp,16
    54ca:	8082                	ret
    bp->s.size += p->s.ptr->s.size;
    54cc:	4618                	lw	a4,8(a2)
    54ce:	9f2d                	addw	a4,a4,a1
    54d0:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
    54d4:	6398                	ld	a4,0(a5)
    54d6:	6310                	ld	a2,0(a4)
    54d8:	b7f9                	j	54a6 <free+0x44>
    p->s.size += bp->s.size;
    54da:	ff852703          	lw	a4,-8(a0)
    54de:	9f31                	addw	a4,a4,a2
    54e0:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
    54e2:	ff053683          	ld	a3,-16(a0)
    54e6:	bfd1                	j	54ba <free+0x58>

00000000000054e8 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
    54e8:	7139                	addi	sp,sp,-64
    54ea:	fc06                	sd	ra,56(sp)
    54ec:	f822                	sd	s0,48(sp)
    54ee:	f04a                	sd	s2,32(sp)
    54f0:	ec4e                	sd	s3,24(sp)
    54f2:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
    54f4:	02051993          	slli	s3,a0,0x20
    54f8:	0209d993          	srli	s3,s3,0x20
    54fc:	09bd                	addi	s3,s3,15
    54fe:	0049d993          	srli	s3,s3,0x4
    5502:	2985                	addiw	s3,s3,1
    5504:	894e                	mv	s2,s3
  if((prevp = freep) == 0){
    5506:	00005517          	auipc	a0,0x5
    550a:	f8a53503          	ld	a0,-118(a0) # a490 <freep>
    550e:	c905                	beqz	a0,553e <malloc+0x56>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    5510:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
    5512:	4798                	lw	a4,8(a5)
    5514:	09377663          	bgeu	a4,s3,55a0 <malloc+0xb8>
    5518:	f426                	sd	s1,40(sp)
    551a:	e852                	sd	s4,16(sp)
    551c:	e456                	sd	s5,8(sp)
    551e:	e05a                	sd	s6,0(sp)
  if(nu < 4096)
    5520:	8a4e                	mv	s4,s3
    5522:	6705                	lui	a4,0x1
    5524:	00e9f363          	bgeu	s3,a4,552a <malloc+0x42>
    5528:	6a05                	lui	s4,0x1
    552a:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
    552e:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
    5532:	00005497          	auipc	s1,0x5
    5536:	f5e48493          	addi	s1,s1,-162 # a490 <freep>
  if(p == SBRK_ERROR)
    553a:	5afd                	li	s5,-1
    553c:	a83d                	j	557a <malloc+0x92>
    553e:	f426                	sd	s1,40(sp)
    5540:	e852                	sd	s4,16(sp)
    5542:	e456                	sd	s5,8(sp)
    5544:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
    5546:	0000b797          	auipc	a5,0xb
    554a:	77278793          	addi	a5,a5,1906 # 10cb8 <base>
    554e:	00005717          	auipc	a4,0x5
    5552:	f4f73123          	sd	a5,-190(a4) # a490 <freep>
    5556:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
    5558:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
    555c:	b7d1                	j	5520 <malloc+0x38>
        prevp->s.ptr = p->s.ptr;
    555e:	6398                	ld	a4,0(a5)
    5560:	e118                	sd	a4,0(a0)
    5562:	a899                	j	55b8 <malloc+0xd0>
  hp->s.size = nu;
    5564:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
    5568:	0541                	addi	a0,a0,16
    556a:	ef9ff0ef          	jal	5462 <free>
  return freep;
    556e:	6088                	ld	a0,0(s1)
      if((p = morecore(nunits)) == 0)
    5570:	c125                	beqz	a0,55d0 <malloc+0xe8>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    5572:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
    5574:	4798                	lw	a4,8(a5)
    5576:	03277163          	bgeu	a4,s2,5598 <malloc+0xb0>
    if(p == freep)
    557a:	6098                	ld	a4,0(s1)
    557c:	853e                	mv	a0,a5
    557e:	fef71ae3          	bne	a4,a5,5572 <malloc+0x8a>
  p = sbrk(nu * sizeof(Header));
    5582:	8552                	mv	a0,s4
    5584:	a33ff0ef          	jal	4fb6 <sbrk>
  if(p == SBRK_ERROR)
    5588:	fd551ee3          	bne	a0,s5,5564 <malloc+0x7c>
        return 0;
    558c:	4501                	li	a0,0
    558e:	74a2                	ld	s1,40(sp)
    5590:	6a42                	ld	s4,16(sp)
    5592:	6aa2                	ld	s5,8(sp)
    5594:	6b02                	ld	s6,0(sp)
    5596:	a03d                	j	55c4 <malloc+0xdc>
    5598:	74a2                	ld	s1,40(sp)
    559a:	6a42                	ld	s4,16(sp)
    559c:	6aa2                	ld	s5,8(sp)
    559e:	6b02                	ld	s6,0(sp)
      if(p->s.size == nunits)
    55a0:	fae90fe3          	beq	s2,a4,555e <malloc+0x76>
        p->s.size -= nunits;
    55a4:	4137073b          	subw	a4,a4,s3
    55a8:	c798                	sw	a4,8(a5)
        p += p->s.size;
    55aa:	02071693          	slli	a3,a4,0x20
    55ae:	01c6d713          	srli	a4,a3,0x1c
    55b2:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
    55b4:	0137a423          	sw	s3,8(a5)
      freep = prevp;
    55b8:	00005717          	auipc	a4,0x5
    55bc:	eca73c23          	sd	a0,-296(a4) # a490 <freep>
      return (void*)(p + 1);
    55c0:	01078513          	addi	a0,a5,16
  }
}
    55c4:	70e2                	ld	ra,56(sp)
    55c6:	7442                	ld	s0,48(sp)
    55c8:	7902                	ld	s2,32(sp)
    55ca:	69e2                	ld	s3,24(sp)
    55cc:	6121                	addi	sp,sp,64
    55ce:	8082                	ret
    55d0:	74a2                	ld	s1,40(sp)
    55d2:	6a42                	ld	s4,16(sp)
    55d4:	6aa2                	ld	s5,8(sp)
    55d6:	6b02                	ld	s6,0(sp)
    55d8:	b7f5                	j	55c4 <malloc+0xdc>
