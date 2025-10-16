
user/_grep:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <matchstar>:
  return 0;
}

// matchstar: search for c*re at beginning of text
int matchstar(int c, char *re, char *text)
{
   0:	7179                	addi	sp,sp,-48
   2:	f406                	sd	ra,40(sp)
   4:	f022                	sd	s0,32(sp)
   6:	ec26                	sd	s1,24(sp)
   8:	e84a                	sd	s2,16(sp)
   a:	e44e                	sd	s3,8(sp)
   c:	e052                	sd	s4,0(sp)
   e:	1800                	addi	s0,sp,48
  10:	892a                	mv	s2,a0
  12:	89ae                	mv	s3,a1
  14:	84b2                	mv	s1,a2
  do{  // a * matches zero or more instances
    if(matchhere(re, text))
      return 1;
  }while(*text!='\0' && (*text++==c || c=='.'));
  16:	fd250a13          	addi	s4,a0,-46
  1a:	001a3a13          	seqz	s4,s4
    if(matchhere(re, text))
  1e:	85a6                	mv	a1,s1
  20:	854e                	mv	a0,s3
  22:	02a000ef          	jal	4c <matchhere>
  26:	e911                	bnez	a0,3a <matchstar+0x3a>
  }while(*text!='\0' && (*text++==c || c=='.'));
  28:	0004c783          	lbu	a5,0(s1)
  2c:	cb81                	beqz	a5,3c <matchstar+0x3c>
  2e:	0485                	addi	s1,s1,1
  30:	ff2787e3          	beq	a5,s2,1e <matchstar+0x1e>
  34:	fe0a15e3          	bnez	s4,1e <matchstar+0x1e>
  38:	a011                	j	3c <matchstar+0x3c>
      return 1;
  3a:	4505                	li	a0,1
  return 0;
}
  3c:	70a2                	ld	ra,40(sp)
  3e:	7402                	ld	s0,32(sp)
  40:	64e2                	ld	s1,24(sp)
  42:	6942                	ld	s2,16(sp)
  44:	69a2                	ld	s3,8(sp)
  46:	6a02                	ld	s4,0(sp)
  48:	6145                	addi	sp,sp,48
  4a:	8082                	ret

000000000000004c <matchhere>:
  if(re[0] == '\0')
  4c:	00054703          	lbu	a4,0(a0)
  50:	cf39                	beqz	a4,ae <matchhere+0x62>
{
  52:	1141                	addi	sp,sp,-16
  54:	e406                	sd	ra,8(sp)
  56:	e022                	sd	s0,0(sp)
  58:	0800                	addi	s0,sp,16
  5a:	87aa                	mv	a5,a0
  if(re[1] == '*')
  5c:	00154683          	lbu	a3,1(a0)
  60:	02a00613          	li	a2,42
  64:	02c68363          	beq	a3,a2,8a <matchhere+0x3e>
  if(re[0] == '$' && re[1] == '\0')
  68:	e681                	bnez	a3,70 <matchhere+0x24>
  6a:	fdc70693          	addi	a3,a4,-36
  6e:	c68d                	beqz	a3,98 <matchhere+0x4c>
  if(*text!='\0' && (re[0]=='.' || re[0]==*text))
  70:	0005c683          	lbu	a3,0(a1)
  return 0;
  74:	4501                	li	a0,0
  if(*text!='\0' && (re[0]=='.' || re[0]==*text))
  76:	c691                	beqz	a3,82 <matchhere+0x36>
  78:	02d70563          	beq	a4,a3,a2 <matchhere+0x56>
  7c:	fd270713          	addi	a4,a4,-46
  80:	c30d                	beqz	a4,a2 <matchhere+0x56>
}
  82:	60a2                	ld	ra,8(sp)
  84:	6402                	ld	s0,0(sp)
  86:	0141                	addi	sp,sp,16
  88:	8082                	ret
    return matchstar(re[0], re+2, text);
  8a:	862e                	mv	a2,a1
  8c:	00250593          	addi	a1,a0,2
  90:	853a                	mv	a0,a4
  92:	f6fff0ef          	jal	0 <matchstar>
  96:	b7f5                	j	82 <matchhere+0x36>
    return *text == '\0';
  98:	0005c503          	lbu	a0,0(a1)
  9c:	00153513          	seqz	a0,a0
  a0:	b7cd                	j	82 <matchhere+0x36>
    return matchhere(re+1, text+1);
  a2:	0585                	addi	a1,a1,1
  a4:	00178513          	addi	a0,a5,1
  a8:	fa5ff0ef          	jal	4c <matchhere>
  ac:	bfd9                	j	82 <matchhere+0x36>
    return 1;
  ae:	4505                	li	a0,1
}
  b0:	8082                	ret

00000000000000b2 <match>:
{
  b2:	1101                	addi	sp,sp,-32
  b4:	ec06                	sd	ra,24(sp)
  b6:	e822                	sd	s0,16(sp)
  b8:	e426                	sd	s1,8(sp)
  ba:	e04a                	sd	s2,0(sp)
  bc:	1000                	addi	s0,sp,32
  be:	892a                	mv	s2,a0
  c0:	84ae                	mv	s1,a1
  if(re[0] == '^')
  c2:	00054703          	lbu	a4,0(a0)
  c6:	05e00793          	li	a5,94
  ca:	00f70c63          	beq	a4,a5,e2 <match+0x30>
    if(matchhere(re, text))
  ce:	85a6                	mv	a1,s1
  d0:	854a                	mv	a0,s2
  d2:	f7bff0ef          	jal	4c <matchhere>
  d6:	e911                	bnez	a0,ea <match+0x38>
  }while(*text++ != '\0');
  d8:	0485                	addi	s1,s1,1
  da:	fff4c783          	lbu	a5,-1(s1)
  de:	fbe5                	bnez	a5,ce <match+0x1c>
  e0:	a031                	j	ec <match+0x3a>
    return matchhere(re+1, text);
  e2:	0505                	addi	a0,a0,1
  e4:	f69ff0ef          	jal	4c <matchhere>
  e8:	a011                	j	ec <match+0x3a>
      return 1;
  ea:	4505                	li	a0,1
}
  ec:	60e2                	ld	ra,24(sp)
  ee:	6442                	ld	s0,16(sp)
  f0:	64a2                	ld	s1,8(sp)
  f2:	6902                	ld	s2,0(sp)
  f4:	6105                	addi	sp,sp,32
  f6:	8082                	ret

00000000000000f8 <grep>:
{
  f8:	711d                	addi	sp,sp,-96
  fa:	ec86                	sd	ra,88(sp)
  fc:	e8a2                	sd	s0,80(sp)
  fe:	e4a6                	sd	s1,72(sp)
 100:	e0ca                	sd	s2,64(sp)
 102:	fc4e                	sd	s3,56(sp)
 104:	f852                	sd	s4,48(sp)
 106:	f456                	sd	s5,40(sp)
 108:	f05a                	sd	s6,32(sp)
 10a:	ec5e                	sd	s7,24(sp)
 10c:	e862                	sd	s8,16(sp)
 10e:	e466                	sd	s9,8(sp)
 110:	e06a                	sd	s10,0(sp)
 112:	1080                	addi	s0,sp,96
 114:	8aaa                	mv	s5,a0
 116:	8cae                	mv	s9,a1
  m = 0;
 118:	4b01                	li	s6,0
  while((n = read(fd, buf+m, sizeof(buf)-m-1)) > 0){
 11a:	3ff00d13          	li	s10,1023
 11e:	00002b97          	auipc	s7,0x2
 122:	ef2b8b93          	addi	s7,s7,-270 # 2010 <buf>
    while((q = strchr(p, '\n')) != 0){
 126:	49a9                	li	s3,10
        write(1, p, q+1 - p);
 128:	4c05                	li	s8,1
  while((n = read(fd, buf+m, sizeof(buf)-m-1)) > 0){
 12a:	a82d                	j	164 <grep+0x6c>
      p = q+1;
 12c:	00148913          	addi	s2,s1,1
    while((q = strchr(p, '\n')) != 0){
 130:	85ce                	mv	a1,s3
 132:	854a                	mv	a0,s2
 134:	1da000ef          	jal	30e <strchr>
 138:	84aa                	mv	s1,a0
 13a:	c11d                	beqz	a0,160 <grep+0x68>
      *q = 0;
 13c:	00048023          	sb	zero,0(s1)
      if(match(pattern, p)){
 140:	85ca                	mv	a1,s2
 142:	8556                	mv	a0,s5
 144:	f6fff0ef          	jal	b2 <match>
 148:	d175                	beqz	a0,12c <grep+0x34>
        *q = '\n';
 14a:	01348023          	sb	s3,0(s1)
        write(1, p, q+1 - p);
 14e:	00148613          	addi	a2,s1,1
 152:	4126063b          	subw	a2,a2,s2
 156:	85ca                	mv	a1,s2
 158:	8562                	mv	a0,s8
 15a:	3d8000ef          	jal	532 <write>
 15e:	b7f9                	j	12c <grep+0x34>
    if(m > 0){
 160:	03604463          	bgtz	s6,188 <grep+0x90>
  while((n = read(fd, buf+m, sizeof(buf)-m-1)) > 0){
 164:	416d063b          	subw	a2,s10,s6
 168:	016b85b3          	add	a1,s7,s6
 16c:	8566                	mv	a0,s9
 16e:	3bc000ef          	jal	52a <read>
 172:	02a05c63          	blez	a0,1aa <grep+0xb2>
    m += n;
 176:	00ab0a3b          	addw	s4,s6,a0
 17a:	8b52                	mv	s6,s4
    buf[m] = '\0';
 17c:	014b87b3          	add	a5,s7,s4
 180:	00078023          	sb	zero,0(a5)
    p = buf;
 184:	895e                	mv	s2,s7
    while((q = strchr(p, '\n')) != 0){
 186:	b76d                	j	130 <grep+0x38>
      m -= p - buf;
 188:	00002797          	auipc	a5,0x2
 18c:	e8878793          	addi	a5,a5,-376 # 2010 <buf>
 190:	40f907b3          	sub	a5,s2,a5
 194:	40fa063b          	subw	a2,s4,a5
 198:	8b32                	mv	s6,a2
      memmove(buf, p, m);
 19a:	85ca                	mv	a1,s2
 19c:	00002517          	auipc	a0,0x2
 1a0:	e7450513          	addi	a0,a0,-396 # 2010 <buf>
 1a4:	290000ef          	jal	434 <memmove>
 1a8:	bf75                	j	164 <grep+0x6c>
}
 1aa:	60e6                	ld	ra,88(sp)
 1ac:	6446                	ld	s0,80(sp)
 1ae:	64a6                	ld	s1,72(sp)
 1b0:	6906                	ld	s2,64(sp)
 1b2:	79e2                	ld	s3,56(sp)
 1b4:	7a42                	ld	s4,48(sp)
 1b6:	7aa2                	ld	s5,40(sp)
 1b8:	7b02                	ld	s6,32(sp)
 1ba:	6be2                	ld	s7,24(sp)
 1bc:	6c42                	ld	s8,16(sp)
 1be:	6ca2                	ld	s9,8(sp)
 1c0:	6d02                	ld	s10,0(sp)
 1c2:	6125                	addi	sp,sp,96
 1c4:	8082                	ret

00000000000001c6 <main>:
{
 1c6:	7179                	addi	sp,sp,-48
 1c8:	f406                	sd	ra,40(sp)
 1ca:	f022                	sd	s0,32(sp)
 1cc:	ec26                	sd	s1,24(sp)
 1ce:	e84a                	sd	s2,16(sp)
 1d0:	e44e                	sd	s3,8(sp)
 1d2:	e052                	sd	s4,0(sp)
 1d4:	1800                	addi	s0,sp,48
  if(argc <= 1){
 1d6:	4785                	li	a5,1
 1d8:	04a7d663          	bge	a5,a0,224 <main+0x5e>
  pattern = argv[1];
 1dc:	0085ba03          	ld	s4,8(a1)
  if(argc <= 2){
 1e0:	4789                	li	a5,2
 1e2:	04a7db63          	bge	a5,a0,238 <main+0x72>
 1e6:	01058913          	addi	s2,a1,16
 1ea:	ffd5099b          	addiw	s3,a0,-3
 1ee:	02099793          	slli	a5,s3,0x20
 1f2:	01d7d993          	srli	s3,a5,0x1d
 1f6:	05e1                	addi	a1,a1,24
 1f8:	99ae                	add	s3,s3,a1
    if((fd = open(argv[i], O_RDONLY)) < 0){
 1fa:	4581                	li	a1,0
 1fc:	00093503          	ld	a0,0(s2)
 200:	352000ef          	jal	552 <open>
 204:	84aa                	mv	s1,a0
 206:	04054063          	bltz	a0,246 <main+0x80>
    grep(pattern, fd);
 20a:	85aa                	mv	a1,a0
 20c:	8552                	mv	a0,s4
 20e:	eebff0ef          	jal	f8 <grep>
    close(fd);
 212:	8526                	mv	a0,s1
 214:	326000ef          	jal	53a <close>
  for(i = 2; i < argc; i++){
 218:	0921                	addi	s2,s2,8
 21a:	ff3910e3          	bne	s2,s3,1fa <main+0x34>
  exit(0);
 21e:	4501                	li	a0,0
 220:	2f2000ef          	jal	512 <exit>
    fprintf(2, "usage: grep pattern [file ...]\n");
 224:	00001597          	auipc	a1,0x1
 228:	8ec58593          	addi	a1,a1,-1812 # b10 <malloc+0xf8>
 22c:	4509                	li	a0,2
 22e:	708000ef          	jal	936 <fprintf>
    exit(1);
 232:	4505                	li	a0,1
 234:	2de000ef          	jal	512 <exit>
    grep(pattern, 0);
 238:	4581                	li	a1,0
 23a:	8552                	mv	a0,s4
 23c:	ebdff0ef          	jal	f8 <grep>
    exit(0);
 240:	4501                	li	a0,0
 242:	2d0000ef          	jal	512 <exit>
      printf("grep: cannot open %s\n", argv[i]);
 246:	00093583          	ld	a1,0(s2)
 24a:	00001517          	auipc	a0,0x1
 24e:	8e650513          	addi	a0,a0,-1818 # b30 <malloc+0x118>
 252:	70e000ef          	jal	960 <printf>
      exit(1);
 256:	4505                	li	a0,1
 258:	2ba000ef          	jal	512 <exit>

000000000000025c <start>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
start(int argc, char **argv)
{
 25c:	1141                	addi	sp,sp,-16
 25e:	e406                	sd	ra,8(sp)
 260:	e022                	sd	s0,0(sp)
 262:	0800                	addi	s0,sp,16
  int r;
  extern int main(int argc, char **argv);
  r = main(argc, argv);
 264:	f63ff0ef          	jal	1c6 <main>
  exit(r);
 268:	2aa000ef          	jal	512 <exit>

000000000000026c <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
 26c:	1141                	addi	sp,sp,-16
 26e:	e406                	sd	ra,8(sp)
 270:	e022                	sd	s0,0(sp)
 272:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 274:	87aa                	mv	a5,a0
 276:	0585                	addi	a1,a1,1
 278:	0785                	addi	a5,a5,1
 27a:	fff5c703          	lbu	a4,-1(a1)
 27e:	fee78fa3          	sb	a4,-1(a5)
 282:	fb75                	bnez	a4,276 <strcpy+0xa>
    ;
  return os;
}
 284:	60a2                	ld	ra,8(sp)
 286:	6402                	ld	s0,0(sp)
 288:	0141                	addi	sp,sp,16
 28a:	8082                	ret

000000000000028c <strcmp>:

int
strcmp(const char *p, const char *q)
{
 28c:	1141                	addi	sp,sp,-16
 28e:	e406                	sd	ra,8(sp)
 290:	e022                	sd	s0,0(sp)
 292:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
 294:	00054783          	lbu	a5,0(a0)
 298:	cb91                	beqz	a5,2ac <strcmp+0x20>
 29a:	0005c703          	lbu	a4,0(a1)
 29e:	00f71763          	bne	a4,a5,2ac <strcmp+0x20>
    p++, q++;
 2a2:	0505                	addi	a0,a0,1
 2a4:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
 2a6:	00054783          	lbu	a5,0(a0)
 2aa:	fbe5                	bnez	a5,29a <strcmp+0xe>
  return (uchar)*p - (uchar)*q;
 2ac:	0005c503          	lbu	a0,0(a1)
}
 2b0:	40a7853b          	subw	a0,a5,a0
 2b4:	60a2                	ld	ra,8(sp)
 2b6:	6402                	ld	s0,0(sp)
 2b8:	0141                	addi	sp,sp,16
 2ba:	8082                	ret

00000000000002bc <strlen>:

uint
strlen(const char *s)
{
 2bc:	1141                	addi	sp,sp,-16
 2be:	e406                	sd	ra,8(sp)
 2c0:	e022                	sd	s0,0(sp)
 2c2:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 2c4:	00054783          	lbu	a5,0(a0)
 2c8:	cf91                	beqz	a5,2e4 <strlen+0x28>
 2ca:	00150793          	addi	a5,a0,1
 2ce:	86be                	mv	a3,a5
 2d0:	0785                	addi	a5,a5,1
 2d2:	fff7c703          	lbu	a4,-1(a5)
 2d6:	ff65                	bnez	a4,2ce <strlen+0x12>
 2d8:	40a6853b          	subw	a0,a3,a0
    ;
  return n;
}
 2dc:	60a2                	ld	ra,8(sp)
 2de:	6402                	ld	s0,0(sp)
 2e0:	0141                	addi	sp,sp,16
 2e2:	8082                	ret
  for(n = 0; s[n]; n++)
 2e4:	4501                	li	a0,0
 2e6:	bfdd                	j	2dc <strlen+0x20>

00000000000002e8 <memset>:

void*
memset(void *dst, int c, uint n)
{
 2e8:	1141                	addi	sp,sp,-16
 2ea:	e406                	sd	ra,8(sp)
 2ec:	e022                	sd	s0,0(sp)
 2ee:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 2f0:	ca19                	beqz	a2,306 <memset+0x1e>
 2f2:	87aa                	mv	a5,a0
 2f4:	1602                	slli	a2,a2,0x20
 2f6:	9201                	srli	a2,a2,0x20
 2f8:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 2fc:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 300:	0785                	addi	a5,a5,1
 302:	fee79de3          	bne	a5,a4,2fc <memset+0x14>
  }
  return dst;
}
 306:	60a2                	ld	ra,8(sp)
 308:	6402                	ld	s0,0(sp)
 30a:	0141                	addi	sp,sp,16
 30c:	8082                	ret

000000000000030e <strchr>:

char*
strchr(const char *s, char c)
{
 30e:	1141                	addi	sp,sp,-16
 310:	e406                	sd	ra,8(sp)
 312:	e022                	sd	s0,0(sp)
 314:	0800                	addi	s0,sp,16
  for(; *s; s++)
 316:	00054783          	lbu	a5,0(a0)
 31a:	cf81                	beqz	a5,332 <strchr+0x24>
    if(*s == c)
 31c:	00f58763          	beq	a1,a5,32a <strchr+0x1c>
  for(; *s; s++)
 320:	0505                	addi	a0,a0,1
 322:	00054783          	lbu	a5,0(a0)
 326:	fbfd                	bnez	a5,31c <strchr+0xe>
      return (char*)s;
  return 0;
 328:	4501                	li	a0,0
}
 32a:	60a2                	ld	ra,8(sp)
 32c:	6402                	ld	s0,0(sp)
 32e:	0141                	addi	sp,sp,16
 330:	8082                	ret
  return 0;
 332:	4501                	li	a0,0
 334:	bfdd                	j	32a <strchr+0x1c>

0000000000000336 <gets>:

char*
gets(char *buf, int max)
{
 336:	711d                	addi	sp,sp,-96
 338:	ec86                	sd	ra,88(sp)
 33a:	e8a2                	sd	s0,80(sp)
 33c:	e4a6                	sd	s1,72(sp)
 33e:	e0ca                	sd	s2,64(sp)
 340:	fc4e                	sd	s3,56(sp)
 342:	f852                	sd	s4,48(sp)
 344:	f456                	sd	s5,40(sp)
 346:	f05a                	sd	s6,32(sp)
 348:	ec5e                	sd	s7,24(sp)
 34a:	e862                	sd	s8,16(sp)
 34c:	1080                	addi	s0,sp,96
 34e:	8baa                	mv	s7,a0
 350:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 352:	892a                	mv	s2,a0
 354:	4481                	li	s1,0
    cc = read(0, &c, 1);
 356:	faf40b13          	addi	s6,s0,-81
 35a:	4a85                	li	s5,1
  for(i=0; i+1 < max; ){
 35c:	8c26                	mv	s8,s1
 35e:	0014899b          	addiw	s3,s1,1
 362:	84ce                	mv	s1,s3
 364:	0349d463          	bge	s3,s4,38c <gets+0x56>
    cc = read(0, &c, 1);
 368:	8656                	mv	a2,s5
 36a:	85da                	mv	a1,s6
 36c:	4501                	li	a0,0
 36e:	1bc000ef          	jal	52a <read>
    if(cc < 1)
 372:	00a05d63          	blez	a0,38c <gets+0x56>
      break;
    buf[i++] = c;
 376:	faf44783          	lbu	a5,-81(s0)
 37a:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 37e:	0905                	addi	s2,s2,1
 380:	ff678713          	addi	a4,a5,-10
 384:	c319                	beqz	a4,38a <gets+0x54>
 386:	17cd                	addi	a5,a5,-13
 388:	fbf1                	bnez	a5,35c <gets+0x26>
    buf[i++] = c;
 38a:	8c4e                	mv	s8,s3
      break;
  }
  buf[i] = '\0';
 38c:	9c5e                	add	s8,s8,s7
 38e:	000c0023          	sb	zero,0(s8)
  return buf;
}
 392:	855e                	mv	a0,s7
 394:	60e6                	ld	ra,88(sp)
 396:	6446                	ld	s0,80(sp)
 398:	64a6                	ld	s1,72(sp)
 39a:	6906                	ld	s2,64(sp)
 39c:	79e2                	ld	s3,56(sp)
 39e:	7a42                	ld	s4,48(sp)
 3a0:	7aa2                	ld	s5,40(sp)
 3a2:	7b02                	ld	s6,32(sp)
 3a4:	6be2                	ld	s7,24(sp)
 3a6:	6c42                	ld	s8,16(sp)
 3a8:	6125                	addi	sp,sp,96
 3aa:	8082                	ret

00000000000003ac <stat>:

int
stat(const char *n, struct stat *st)
{
 3ac:	1101                	addi	sp,sp,-32
 3ae:	ec06                	sd	ra,24(sp)
 3b0:	e822                	sd	s0,16(sp)
 3b2:	e04a                	sd	s2,0(sp)
 3b4:	1000                	addi	s0,sp,32
 3b6:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 3b8:	4581                	li	a1,0
 3ba:	198000ef          	jal	552 <open>
  if(fd < 0)
 3be:	02054263          	bltz	a0,3e2 <stat+0x36>
 3c2:	e426                	sd	s1,8(sp)
 3c4:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 3c6:	85ca                	mv	a1,s2
 3c8:	1a2000ef          	jal	56a <fstat>
 3cc:	892a                	mv	s2,a0
  close(fd);
 3ce:	8526                	mv	a0,s1
 3d0:	16a000ef          	jal	53a <close>
  return r;
 3d4:	64a2                	ld	s1,8(sp)
}
 3d6:	854a                	mv	a0,s2
 3d8:	60e2                	ld	ra,24(sp)
 3da:	6442                	ld	s0,16(sp)
 3dc:	6902                	ld	s2,0(sp)
 3de:	6105                	addi	sp,sp,32
 3e0:	8082                	ret
    return -1;
 3e2:	57fd                	li	a5,-1
 3e4:	893e                	mv	s2,a5
 3e6:	bfc5                	j	3d6 <stat+0x2a>

00000000000003e8 <atoi>:

int
atoi(const char *s)
{
 3e8:	1141                	addi	sp,sp,-16
 3ea:	e406                	sd	ra,8(sp)
 3ec:	e022                	sd	s0,0(sp)
 3ee:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 3f0:	00054683          	lbu	a3,0(a0)
 3f4:	fd06879b          	addiw	a5,a3,-48
 3f8:	0ff7f793          	zext.b	a5,a5
 3fc:	4625                	li	a2,9
 3fe:	02f66963          	bltu	a2,a5,430 <atoi+0x48>
 402:	872a                	mv	a4,a0
  n = 0;
 404:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
 406:	0705                	addi	a4,a4,1
 408:	0025179b          	slliw	a5,a0,0x2
 40c:	9fa9                	addw	a5,a5,a0
 40e:	0017979b          	slliw	a5,a5,0x1
 412:	9fb5                	addw	a5,a5,a3
 414:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 418:	00074683          	lbu	a3,0(a4)
 41c:	fd06879b          	addiw	a5,a3,-48
 420:	0ff7f793          	zext.b	a5,a5
 424:	fef671e3          	bgeu	a2,a5,406 <atoi+0x1e>
  return n;
}
 428:	60a2                	ld	ra,8(sp)
 42a:	6402                	ld	s0,0(sp)
 42c:	0141                	addi	sp,sp,16
 42e:	8082                	ret
  n = 0;
 430:	4501                	li	a0,0
 432:	bfdd                	j	428 <atoi+0x40>

0000000000000434 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 434:	1141                	addi	sp,sp,-16
 436:	e406                	sd	ra,8(sp)
 438:	e022                	sd	s0,0(sp)
 43a:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 43c:	02b57563          	bgeu	a0,a1,466 <memmove+0x32>
    while(n-- > 0)
 440:	00c05f63          	blez	a2,45e <memmove+0x2a>
 444:	1602                	slli	a2,a2,0x20
 446:	9201                	srli	a2,a2,0x20
 448:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 44c:	872a                	mv	a4,a0
      *dst++ = *src++;
 44e:	0585                	addi	a1,a1,1
 450:	0705                	addi	a4,a4,1
 452:	fff5c683          	lbu	a3,-1(a1)
 456:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 45a:	fee79ae3          	bne	a5,a4,44e <memmove+0x1a>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 45e:	60a2                	ld	ra,8(sp)
 460:	6402                	ld	s0,0(sp)
 462:	0141                	addi	sp,sp,16
 464:	8082                	ret
    while(n-- > 0)
 466:	fec05ce3          	blez	a2,45e <memmove+0x2a>
    dst += n;
 46a:	00c50733          	add	a4,a0,a2
    src += n;
 46e:	95b2                	add	a1,a1,a2
 470:	fff6079b          	addiw	a5,a2,-1
 474:	1782                	slli	a5,a5,0x20
 476:	9381                	srli	a5,a5,0x20
 478:	fff7c793          	not	a5,a5
 47c:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 47e:	15fd                	addi	a1,a1,-1
 480:	177d                	addi	a4,a4,-1
 482:	0005c683          	lbu	a3,0(a1)
 486:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 48a:	fef71ae3          	bne	a4,a5,47e <memmove+0x4a>
 48e:	bfc1                	j	45e <memmove+0x2a>

0000000000000490 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 490:	1141                	addi	sp,sp,-16
 492:	e406                	sd	ra,8(sp)
 494:	e022                	sd	s0,0(sp)
 496:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 498:	c61d                	beqz	a2,4c6 <memcmp+0x36>
 49a:	1602                	slli	a2,a2,0x20
 49c:	9201                	srli	a2,a2,0x20
 49e:	00c506b3          	add	a3,a0,a2
    if (*p1 != *p2) {
 4a2:	00054783          	lbu	a5,0(a0)
 4a6:	0005c703          	lbu	a4,0(a1)
 4aa:	00e79863          	bne	a5,a4,4ba <memcmp+0x2a>
      return *p1 - *p2;
    }
    p1++;
 4ae:	0505                	addi	a0,a0,1
    p2++;
 4b0:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 4b2:	fed518e3          	bne	a0,a3,4a2 <memcmp+0x12>
  }
  return 0;
 4b6:	4501                	li	a0,0
 4b8:	a019                	j	4be <memcmp+0x2e>
      return *p1 - *p2;
 4ba:	40e7853b          	subw	a0,a5,a4
}
 4be:	60a2                	ld	ra,8(sp)
 4c0:	6402                	ld	s0,0(sp)
 4c2:	0141                	addi	sp,sp,16
 4c4:	8082                	ret
  return 0;
 4c6:	4501                	li	a0,0
 4c8:	bfdd                	j	4be <memcmp+0x2e>

00000000000004ca <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 4ca:	1141                	addi	sp,sp,-16
 4cc:	e406                	sd	ra,8(sp)
 4ce:	e022                	sd	s0,0(sp)
 4d0:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 4d2:	f63ff0ef          	jal	434 <memmove>
}
 4d6:	60a2                	ld	ra,8(sp)
 4d8:	6402                	ld	s0,0(sp)
 4da:	0141                	addi	sp,sp,16
 4dc:	8082                	ret

00000000000004de <sbrk>:

char *
sbrk(int n) {
 4de:	1141                	addi	sp,sp,-16
 4e0:	e406                	sd	ra,8(sp)
 4e2:	e022                	sd	s0,0(sp)
 4e4:	0800                	addi	s0,sp,16
  return sys_sbrk(n, SBRK_EAGER);
 4e6:	4585                	li	a1,1
 4e8:	0b2000ef          	jal	59a <sys_sbrk>
}
 4ec:	60a2                	ld	ra,8(sp)
 4ee:	6402                	ld	s0,0(sp)
 4f0:	0141                	addi	sp,sp,16
 4f2:	8082                	ret

00000000000004f4 <sbrklazy>:

char *
sbrklazy(int n) {
 4f4:	1141                	addi	sp,sp,-16
 4f6:	e406                	sd	ra,8(sp)
 4f8:	e022                	sd	s0,0(sp)
 4fa:	0800                	addi	s0,sp,16
  return sys_sbrk(n, SBRK_LAZY);
 4fc:	4589                	li	a1,2
 4fe:	09c000ef          	jal	59a <sys_sbrk>
}
 502:	60a2                	ld	ra,8(sp)
 504:	6402                	ld	s0,0(sp)
 506:	0141                	addi	sp,sp,16
 508:	8082                	ret

000000000000050a <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 50a:	4885                	li	a7,1
 ecall
 50c:	00000073          	ecall
 ret
 510:	8082                	ret

0000000000000512 <exit>:
.global exit
exit:
 li a7, SYS_exit
 512:	4889                	li	a7,2
 ecall
 514:	00000073          	ecall
 ret
 518:	8082                	ret

000000000000051a <wait>:
.global wait
wait:
 li a7, SYS_wait
 51a:	488d                	li	a7,3
 ecall
 51c:	00000073          	ecall
 ret
 520:	8082                	ret

0000000000000522 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 522:	4891                	li	a7,4
 ecall
 524:	00000073          	ecall
 ret
 528:	8082                	ret

000000000000052a <read>:
.global read
read:
 li a7, SYS_read
 52a:	4895                	li	a7,5
 ecall
 52c:	00000073          	ecall
 ret
 530:	8082                	ret

0000000000000532 <write>:
.global write
write:
 li a7, SYS_write
 532:	48c1                	li	a7,16
 ecall
 534:	00000073          	ecall
 ret
 538:	8082                	ret

000000000000053a <close>:
.global close
close:
 li a7, SYS_close
 53a:	48d5                	li	a7,21
 ecall
 53c:	00000073          	ecall
 ret
 540:	8082                	ret

0000000000000542 <kill>:
.global kill
kill:
 li a7, SYS_kill
 542:	4899                	li	a7,6
 ecall
 544:	00000073          	ecall
 ret
 548:	8082                	ret

000000000000054a <exec>:
.global exec
exec:
 li a7, SYS_exec
 54a:	489d                	li	a7,7
 ecall
 54c:	00000073          	ecall
 ret
 550:	8082                	ret

0000000000000552 <open>:
.global open
open:
 li a7, SYS_open
 552:	48bd                	li	a7,15
 ecall
 554:	00000073          	ecall
 ret
 558:	8082                	ret

000000000000055a <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 55a:	48c5                	li	a7,17
 ecall
 55c:	00000073          	ecall
 ret
 560:	8082                	ret

0000000000000562 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 562:	48c9                	li	a7,18
 ecall
 564:	00000073          	ecall
 ret
 568:	8082                	ret

000000000000056a <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 56a:	48a1                	li	a7,8
 ecall
 56c:	00000073          	ecall
 ret
 570:	8082                	ret

0000000000000572 <link>:
.global link
link:
 li a7, SYS_link
 572:	48cd                	li	a7,19
 ecall
 574:	00000073          	ecall
 ret
 578:	8082                	ret

000000000000057a <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 57a:	48d1                	li	a7,20
 ecall
 57c:	00000073          	ecall
 ret
 580:	8082                	ret

0000000000000582 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 582:	48a5                	li	a7,9
 ecall
 584:	00000073          	ecall
 ret
 588:	8082                	ret

000000000000058a <dup>:
.global dup
dup:
 li a7, SYS_dup
 58a:	48a9                	li	a7,10
 ecall
 58c:	00000073          	ecall
 ret
 590:	8082                	ret

0000000000000592 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 592:	48ad                	li	a7,11
 ecall
 594:	00000073          	ecall
 ret
 598:	8082                	ret

000000000000059a <sys_sbrk>:
.global sys_sbrk
sys_sbrk:
 li a7, SYS_sbrk
 59a:	48b1                	li	a7,12
 ecall
 59c:	00000073          	ecall
 ret
 5a0:	8082                	ret

00000000000005a2 <pause>:
.global pause
pause:
 li a7, SYS_pause
 5a2:	48b5                	li	a7,13
 ecall
 5a4:	00000073          	ecall
 ret
 5a8:	8082                	ret

00000000000005aa <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 5aa:	48b9                	li	a7,14
 ecall
 5ac:	00000073          	ecall
 ret
 5b0:	8082                	ret

00000000000005b2 <memstat>:
.global memstat
memstat:
 li a7, SYS_memstat
 5b2:	48d9                	li	a7,22
 ecall
 5b4:	00000073          	ecall
 ret
 5b8:	8082                	ret

00000000000005ba <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 5ba:	1101                	addi	sp,sp,-32
 5bc:	ec06                	sd	ra,24(sp)
 5be:	e822                	sd	s0,16(sp)
 5c0:	1000                	addi	s0,sp,32
 5c2:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 5c6:	4605                	li	a2,1
 5c8:	fef40593          	addi	a1,s0,-17
 5cc:	f67ff0ef          	jal	532 <write>
}
 5d0:	60e2                	ld	ra,24(sp)
 5d2:	6442                	ld	s0,16(sp)
 5d4:	6105                	addi	sp,sp,32
 5d6:	8082                	ret

00000000000005d8 <printint>:

static void
printint(int fd, long long xx, int base, int sgn)
{
 5d8:	715d                	addi	sp,sp,-80
 5da:	e486                	sd	ra,72(sp)
 5dc:	e0a2                	sd	s0,64(sp)
 5de:	f84a                	sd	s2,48(sp)
 5e0:	f44e                	sd	s3,40(sp)
 5e2:	0880                	addi	s0,sp,80
 5e4:	892a                	mv	s2,a0
  char buf[20];
  int i, neg;
  unsigned long long x;

  neg = 0;
  if(sgn && xx < 0){
 5e6:	c6d1                	beqz	a3,672 <printint+0x9a>
 5e8:	0805d563          	bgez	a1,672 <printint+0x9a>
    neg = 1;
    x = -xx;
 5ec:	40b005b3          	neg	a1,a1
    neg = 1;
 5f0:	4305                	li	t1,1
  } else {
    x = xx;
  }

  i = 0;
 5f2:	fb840993          	addi	s3,s0,-72
  neg = 0;
 5f6:	86ce                	mv	a3,s3
  i = 0;
 5f8:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 5fa:	00000817          	auipc	a6,0x0
 5fe:	55680813          	addi	a6,a6,1366 # b50 <digits>
 602:	88ba                	mv	a7,a4
 604:	0017051b          	addiw	a0,a4,1
 608:	872a                	mv	a4,a0
 60a:	02c5f7b3          	remu	a5,a1,a2
 60e:	97c2                	add	a5,a5,a6
 610:	0007c783          	lbu	a5,0(a5)
 614:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 618:	87ae                	mv	a5,a1
 61a:	02c5d5b3          	divu	a1,a1,a2
 61e:	0685                	addi	a3,a3,1
 620:	fec7f1e3          	bgeu	a5,a2,602 <printint+0x2a>
  if(neg)
 624:	00030c63          	beqz	t1,63c <printint+0x64>
    buf[i++] = '-';
 628:	fd050793          	addi	a5,a0,-48
 62c:	00878533          	add	a0,a5,s0
 630:	02d00793          	li	a5,45
 634:	fef50423          	sb	a5,-24(a0)
 638:	0028871b          	addiw	a4,a7,2

  while(--i >= 0)
 63c:	02e05563          	blez	a4,666 <printint+0x8e>
 640:	fc26                	sd	s1,56(sp)
 642:	377d                	addiw	a4,a4,-1
 644:	00e984b3          	add	s1,s3,a4
 648:	19fd                	addi	s3,s3,-1
 64a:	99ba                	add	s3,s3,a4
 64c:	1702                	slli	a4,a4,0x20
 64e:	9301                	srli	a4,a4,0x20
 650:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 654:	0004c583          	lbu	a1,0(s1)
 658:	854a                	mv	a0,s2
 65a:	f61ff0ef          	jal	5ba <putc>
  while(--i >= 0)
 65e:	14fd                	addi	s1,s1,-1
 660:	ff349ae3          	bne	s1,s3,654 <printint+0x7c>
 664:	74e2                	ld	s1,56(sp)
}
 666:	60a6                	ld	ra,72(sp)
 668:	6406                	ld	s0,64(sp)
 66a:	7942                	ld	s2,48(sp)
 66c:	79a2                	ld	s3,40(sp)
 66e:	6161                	addi	sp,sp,80
 670:	8082                	ret
  neg = 0;
 672:	4301                	li	t1,0
 674:	bfbd                	j	5f2 <printint+0x1a>

0000000000000676 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %c, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 676:	711d                	addi	sp,sp,-96
 678:	ec86                	sd	ra,88(sp)
 67a:	e8a2                	sd	s0,80(sp)
 67c:	e4a6                	sd	s1,72(sp)
 67e:	1080                	addi	s0,sp,96
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 680:	0005c483          	lbu	s1,0(a1)
 684:	22048363          	beqz	s1,8aa <vprintf+0x234>
 688:	e0ca                	sd	s2,64(sp)
 68a:	fc4e                	sd	s3,56(sp)
 68c:	f852                	sd	s4,48(sp)
 68e:	f456                	sd	s5,40(sp)
 690:	f05a                	sd	s6,32(sp)
 692:	ec5e                	sd	s7,24(sp)
 694:	e862                	sd	s8,16(sp)
 696:	8b2a                	mv	s6,a0
 698:	8a2e                	mv	s4,a1
 69a:	8bb2                	mv	s7,a2
  state = 0;
 69c:	4981                	li	s3,0
  for(i = 0; fmt[i]; i++){
 69e:	4901                	li	s2,0
 6a0:	4701                	li	a4,0
      if(c0 == '%'){
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if(state == '%'){
 6a2:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if(c0) c1 = fmt[i+1] & 0xff;
      if(c1) c2 = fmt[i+2] & 0xff;
      if(c0 == 'd'){
 6a6:	06400c13          	li	s8,100
 6aa:	a00d                	j	6cc <vprintf+0x56>
        putc(fd, c0);
 6ac:	85a6                	mv	a1,s1
 6ae:	855a                	mv	a0,s6
 6b0:	f0bff0ef          	jal	5ba <putc>
 6b4:	a019                	j	6ba <vprintf+0x44>
    } else if(state == '%'){
 6b6:	03598363          	beq	s3,s5,6dc <vprintf+0x66>
  for(i = 0; fmt[i]; i++){
 6ba:	0019079b          	addiw	a5,s2,1
 6be:	893e                	mv	s2,a5
 6c0:	873e                	mv	a4,a5
 6c2:	97d2                	add	a5,a5,s4
 6c4:	0007c483          	lbu	s1,0(a5)
 6c8:	1c048a63          	beqz	s1,89c <vprintf+0x226>
    c0 = fmt[i] & 0xff;
 6cc:	0004879b          	sext.w	a5,s1
    if(state == 0){
 6d0:	fe0993e3          	bnez	s3,6b6 <vprintf+0x40>
      if(c0 == '%'){
 6d4:	fd579ce3          	bne	a5,s5,6ac <vprintf+0x36>
        state = '%';
 6d8:	89be                	mv	s3,a5
 6da:	b7c5                	j	6ba <vprintf+0x44>
      if(c0) c1 = fmt[i+1] & 0xff;
 6dc:	00ea06b3          	add	a3,s4,a4
 6e0:	0016c603          	lbu	a2,1(a3)
      if(c1) c2 = fmt[i+2] & 0xff;
 6e4:	1c060863          	beqz	a2,8b4 <vprintf+0x23e>
      if(c0 == 'd'){
 6e8:	03878763          	beq	a5,s8,716 <vprintf+0xa0>
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c0 == 'l' && c1 == 'd'){
 6ec:	f9478693          	addi	a3,a5,-108
 6f0:	0016b693          	seqz	a3,a3
 6f4:	f9c60593          	addi	a1,a2,-100
 6f8:	e99d                	bnez	a1,72e <vprintf+0xb8>
 6fa:	ca95                	beqz	a3,72e <vprintf+0xb8>
        printint(fd, va_arg(ap, uint64), 10, 1);
 6fc:	008b8493          	addi	s1,s7,8
 700:	4685                	li	a3,1
 702:	4629                	li	a2,10
 704:	000bb583          	ld	a1,0(s7)
 708:	855a                	mv	a0,s6
 70a:	ecfff0ef          	jal	5d8 <printint>
        i += 1;
 70e:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 10, 1);
 710:	8ba6                	mv	s7,s1
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c0);
      }

      state = 0;
 712:	4981                	li	s3,0
 714:	b75d                	j	6ba <vprintf+0x44>
        printint(fd, va_arg(ap, int), 10, 1);
 716:	008b8493          	addi	s1,s7,8
 71a:	4685                	li	a3,1
 71c:	4629                	li	a2,10
 71e:	000ba583          	lw	a1,0(s7)
 722:	855a                	mv	a0,s6
 724:	eb5ff0ef          	jal	5d8 <printint>
 728:	8ba6                	mv	s7,s1
      state = 0;
 72a:	4981                	li	s3,0
 72c:	b779                	j	6ba <vprintf+0x44>
      if(c1) c2 = fmt[i+2] & 0xff;
 72e:	9752                	add	a4,a4,s4
 730:	00274583          	lbu	a1,2(a4)
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 734:	f9460713          	addi	a4,a2,-108
 738:	00173713          	seqz	a4,a4
 73c:	8f75                	and	a4,a4,a3
 73e:	f9c58513          	addi	a0,a1,-100
 742:	18051363          	bnez	a0,8c8 <vprintf+0x252>
 746:	18070163          	beqz	a4,8c8 <vprintf+0x252>
        printint(fd, va_arg(ap, uint64), 10, 1);
 74a:	008b8493          	addi	s1,s7,8
 74e:	4685                	li	a3,1
 750:	4629                	li	a2,10
 752:	000bb583          	ld	a1,0(s7)
 756:	855a                	mv	a0,s6
 758:	e81ff0ef          	jal	5d8 <printint>
        i += 2;
 75c:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 10, 1);
 75e:	8ba6                	mv	s7,s1
      state = 0;
 760:	4981                	li	s3,0
        i += 2;
 762:	bfa1                	j	6ba <vprintf+0x44>
        printint(fd, va_arg(ap, uint32), 10, 0);
 764:	008b8493          	addi	s1,s7,8
 768:	4681                	li	a3,0
 76a:	4629                	li	a2,10
 76c:	000be583          	lwu	a1,0(s7)
 770:	855a                	mv	a0,s6
 772:	e67ff0ef          	jal	5d8 <printint>
 776:	8ba6                	mv	s7,s1
      state = 0;
 778:	4981                	li	s3,0
 77a:	b781                	j	6ba <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 10, 0);
 77c:	008b8493          	addi	s1,s7,8
 780:	4681                	li	a3,0
 782:	4629                	li	a2,10
 784:	000bb583          	ld	a1,0(s7)
 788:	855a                	mv	a0,s6
 78a:	e4fff0ef          	jal	5d8 <printint>
        i += 1;
 78e:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 10, 0);
 790:	8ba6                	mv	s7,s1
      state = 0;
 792:	4981                	li	s3,0
 794:	b71d                	j	6ba <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 10, 0);
 796:	008b8493          	addi	s1,s7,8
 79a:	4681                	li	a3,0
 79c:	4629                	li	a2,10
 79e:	000bb583          	ld	a1,0(s7)
 7a2:	855a                	mv	a0,s6
 7a4:	e35ff0ef          	jal	5d8 <printint>
        i += 2;
 7a8:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 10, 0);
 7aa:	8ba6                	mv	s7,s1
      state = 0;
 7ac:	4981                	li	s3,0
        i += 2;
 7ae:	b731                	j	6ba <vprintf+0x44>
        printint(fd, va_arg(ap, uint32), 16, 0);
 7b0:	008b8493          	addi	s1,s7,8
 7b4:	4681                	li	a3,0
 7b6:	4641                	li	a2,16
 7b8:	000be583          	lwu	a1,0(s7)
 7bc:	855a                	mv	a0,s6
 7be:	e1bff0ef          	jal	5d8 <printint>
 7c2:	8ba6                	mv	s7,s1
      state = 0;
 7c4:	4981                	li	s3,0
 7c6:	bdd5                	j	6ba <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 16, 0);
 7c8:	008b8493          	addi	s1,s7,8
 7cc:	4681                	li	a3,0
 7ce:	4641                	li	a2,16
 7d0:	000bb583          	ld	a1,0(s7)
 7d4:	855a                	mv	a0,s6
 7d6:	e03ff0ef          	jal	5d8 <printint>
        i += 1;
 7da:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 16, 0);
 7dc:	8ba6                	mv	s7,s1
      state = 0;
 7de:	4981                	li	s3,0
 7e0:	bde9                	j	6ba <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 16, 0);
 7e2:	008b8493          	addi	s1,s7,8
 7e6:	4681                	li	a3,0
 7e8:	4641                	li	a2,16
 7ea:	000bb583          	ld	a1,0(s7)
 7ee:	855a                	mv	a0,s6
 7f0:	de9ff0ef          	jal	5d8 <printint>
        i += 2;
 7f4:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 16, 0);
 7f6:	8ba6                	mv	s7,s1
      state = 0;
 7f8:	4981                	li	s3,0
        i += 2;
 7fa:	b5c1                	j	6ba <vprintf+0x44>
 7fc:	e466                	sd	s9,8(sp)
        printptr(fd, va_arg(ap, uint64));
 7fe:	008b8793          	addi	a5,s7,8
 802:	8cbe                	mv	s9,a5
 804:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 808:	03000593          	li	a1,48
 80c:	855a                	mv	a0,s6
 80e:	dadff0ef          	jal	5ba <putc>
  putc(fd, 'x');
 812:	07800593          	li	a1,120
 816:	855a                	mv	a0,s6
 818:	da3ff0ef          	jal	5ba <putc>
 81c:	44c1                	li	s1,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 81e:	00000b97          	auipc	s7,0x0
 822:	332b8b93          	addi	s7,s7,818 # b50 <digits>
 826:	03c9d793          	srli	a5,s3,0x3c
 82a:	97de                	add	a5,a5,s7
 82c:	0007c583          	lbu	a1,0(a5)
 830:	855a                	mv	a0,s6
 832:	d89ff0ef          	jal	5ba <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 836:	0992                	slli	s3,s3,0x4
 838:	34fd                	addiw	s1,s1,-1
 83a:	f4f5                	bnez	s1,826 <vprintf+0x1b0>
        printptr(fd, va_arg(ap, uint64));
 83c:	8be6                	mv	s7,s9
      state = 0;
 83e:	4981                	li	s3,0
 840:	6ca2                	ld	s9,8(sp)
 842:	bda5                	j	6ba <vprintf+0x44>
        putc(fd, va_arg(ap, uint32));
 844:	008b8493          	addi	s1,s7,8
 848:	000bc583          	lbu	a1,0(s7)
 84c:	855a                	mv	a0,s6
 84e:	d6dff0ef          	jal	5ba <putc>
 852:	8ba6                	mv	s7,s1
      state = 0;
 854:	4981                	li	s3,0
 856:	b595                	j	6ba <vprintf+0x44>
        if((s = va_arg(ap, char*)) == 0)
 858:	008b8993          	addi	s3,s7,8
 85c:	000bb483          	ld	s1,0(s7)
 860:	cc91                	beqz	s1,87c <vprintf+0x206>
        for(; *s; s++)
 862:	0004c583          	lbu	a1,0(s1)
 866:	c985                	beqz	a1,896 <vprintf+0x220>
          putc(fd, *s);
 868:	855a                	mv	a0,s6
 86a:	d51ff0ef          	jal	5ba <putc>
        for(; *s; s++)
 86e:	0485                	addi	s1,s1,1
 870:	0004c583          	lbu	a1,0(s1)
 874:	f9f5                	bnez	a1,868 <vprintf+0x1f2>
        if((s = va_arg(ap, char*)) == 0)
 876:	8bce                	mv	s7,s3
      state = 0;
 878:	4981                	li	s3,0
 87a:	b581                	j	6ba <vprintf+0x44>
          s = "(null)";
 87c:	00000497          	auipc	s1,0x0
 880:	2cc48493          	addi	s1,s1,716 # b48 <malloc+0x130>
        for(; *s; s++)
 884:	02800593          	li	a1,40
 888:	b7c5                	j	868 <vprintf+0x1f2>
        putc(fd, '%');
 88a:	85be                	mv	a1,a5
 88c:	855a                	mv	a0,s6
 88e:	d2dff0ef          	jal	5ba <putc>
      state = 0;
 892:	4981                	li	s3,0
 894:	b51d                	j	6ba <vprintf+0x44>
        if((s = va_arg(ap, char*)) == 0)
 896:	8bce                	mv	s7,s3
      state = 0;
 898:	4981                	li	s3,0
 89a:	b505                	j	6ba <vprintf+0x44>
 89c:	6906                	ld	s2,64(sp)
 89e:	79e2                	ld	s3,56(sp)
 8a0:	7a42                	ld	s4,48(sp)
 8a2:	7aa2                	ld	s5,40(sp)
 8a4:	7b02                	ld	s6,32(sp)
 8a6:	6be2                	ld	s7,24(sp)
 8a8:	6c42                	ld	s8,16(sp)
    }
  }
}
 8aa:	60e6                	ld	ra,88(sp)
 8ac:	6446                	ld	s0,80(sp)
 8ae:	64a6                	ld	s1,72(sp)
 8b0:	6125                	addi	sp,sp,96
 8b2:	8082                	ret
      if(c0 == 'd'){
 8b4:	06400713          	li	a4,100
 8b8:	e4e78fe3          	beq	a5,a4,716 <vprintf+0xa0>
      } else if(c0 == 'l' && c1 == 'd'){
 8bc:	f9478693          	addi	a3,a5,-108
 8c0:	0016b693          	seqz	a3,a3
      c1 = c2 = 0;
 8c4:	85b2                	mv	a1,a2
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 8c6:	4701                	li	a4,0
      } else if(c0 == 'u'){
 8c8:	07500513          	li	a0,117
 8cc:	e8a78ce3          	beq	a5,a0,764 <vprintf+0xee>
      } else if(c0 == 'l' && c1 == 'u'){
 8d0:	f8b60513          	addi	a0,a2,-117
 8d4:	e119                	bnez	a0,8da <vprintf+0x264>
 8d6:	ea0693e3          	bnez	a3,77c <vprintf+0x106>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
 8da:	f8b58513          	addi	a0,a1,-117
 8de:	e119                	bnez	a0,8e4 <vprintf+0x26e>
 8e0:	ea071be3          	bnez	a4,796 <vprintf+0x120>
      } else if(c0 == 'x'){
 8e4:	07800513          	li	a0,120
 8e8:	eca784e3          	beq	a5,a0,7b0 <vprintf+0x13a>
      } else if(c0 == 'l' && c1 == 'x'){
 8ec:	f8860613          	addi	a2,a2,-120
 8f0:	e219                	bnez	a2,8f6 <vprintf+0x280>
 8f2:	ec069be3          	bnez	a3,7c8 <vprintf+0x152>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
 8f6:	f8858593          	addi	a1,a1,-120
 8fa:	e199                	bnez	a1,900 <vprintf+0x28a>
 8fc:	ee0713e3          	bnez	a4,7e2 <vprintf+0x16c>
      } else if(c0 == 'p'){
 900:	07000713          	li	a4,112
 904:	eee78ce3          	beq	a5,a4,7fc <vprintf+0x186>
      } else if(c0 == 'c'){
 908:	06300713          	li	a4,99
 90c:	f2e78ce3          	beq	a5,a4,844 <vprintf+0x1ce>
      } else if(c0 == 's'){
 910:	07300713          	li	a4,115
 914:	f4e782e3          	beq	a5,a4,858 <vprintf+0x1e2>
      } else if(c0 == '%'){
 918:	02500713          	li	a4,37
 91c:	f6e787e3          	beq	a5,a4,88a <vprintf+0x214>
        putc(fd, '%');
 920:	02500593          	li	a1,37
 924:	855a                	mv	a0,s6
 926:	c95ff0ef          	jal	5ba <putc>
        putc(fd, c0);
 92a:	85a6                	mv	a1,s1
 92c:	855a                	mv	a0,s6
 92e:	c8dff0ef          	jal	5ba <putc>
      state = 0;
 932:	4981                	li	s3,0
 934:	b359                	j	6ba <vprintf+0x44>

0000000000000936 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 936:	715d                	addi	sp,sp,-80
 938:	ec06                	sd	ra,24(sp)
 93a:	e822                	sd	s0,16(sp)
 93c:	1000                	addi	s0,sp,32
 93e:	e010                	sd	a2,0(s0)
 940:	e414                	sd	a3,8(s0)
 942:	e818                	sd	a4,16(s0)
 944:	ec1c                	sd	a5,24(s0)
 946:	03043023          	sd	a6,32(s0)
 94a:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 94e:	8622                	mv	a2,s0
 950:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 954:	d23ff0ef          	jal	676 <vprintf>
}
 958:	60e2                	ld	ra,24(sp)
 95a:	6442                	ld	s0,16(sp)
 95c:	6161                	addi	sp,sp,80
 95e:	8082                	ret

0000000000000960 <printf>:

void
printf(const char *fmt, ...)
{
 960:	711d                	addi	sp,sp,-96
 962:	ec06                	sd	ra,24(sp)
 964:	e822                	sd	s0,16(sp)
 966:	1000                	addi	s0,sp,32
 968:	e40c                	sd	a1,8(s0)
 96a:	e810                	sd	a2,16(s0)
 96c:	ec14                	sd	a3,24(s0)
 96e:	f018                	sd	a4,32(s0)
 970:	f41c                	sd	a5,40(s0)
 972:	03043823          	sd	a6,48(s0)
 976:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 97a:	00840613          	addi	a2,s0,8
 97e:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 982:	85aa                	mv	a1,a0
 984:	4505                	li	a0,1
 986:	cf1ff0ef          	jal	676 <vprintf>
}
 98a:	60e2                	ld	ra,24(sp)
 98c:	6442                	ld	s0,16(sp)
 98e:	6125                	addi	sp,sp,96
 990:	8082                	ret

0000000000000992 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 992:	1141                	addi	sp,sp,-16
 994:	e406                	sd	ra,8(sp)
 996:	e022                	sd	s0,0(sp)
 998:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 99a:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 99e:	00001797          	auipc	a5,0x1
 9a2:	6627b783          	ld	a5,1634(a5) # 2000 <freep>
 9a6:	a039                	j	9b4 <free+0x22>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 9a8:	6398                	ld	a4,0(a5)
 9aa:	00e7e463          	bltu	a5,a4,9b2 <free+0x20>
 9ae:	00e6ea63          	bltu	a3,a4,9c2 <free+0x30>
{
 9b2:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 9b4:	fed7fae3          	bgeu	a5,a3,9a8 <free+0x16>
 9b8:	6398                	ld	a4,0(a5)
 9ba:	00e6e463          	bltu	a3,a4,9c2 <free+0x30>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 9be:	fee7eae3          	bltu	a5,a4,9b2 <free+0x20>
      break;
  if(bp + bp->s.size == p->s.ptr){
 9c2:	ff852583          	lw	a1,-8(a0)
 9c6:	6390                	ld	a2,0(a5)
 9c8:	02059813          	slli	a6,a1,0x20
 9cc:	01c85713          	srli	a4,a6,0x1c
 9d0:	9736                	add	a4,a4,a3
 9d2:	02e60563          	beq	a2,a4,9fc <free+0x6a>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
 9d6:	fec53823          	sd	a2,-16(a0)
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
 9da:	4790                	lw	a2,8(a5)
 9dc:	02061593          	slli	a1,a2,0x20
 9e0:	01c5d713          	srli	a4,a1,0x1c
 9e4:	973e                	add	a4,a4,a5
 9e6:	02e68263          	beq	a3,a4,a0a <free+0x78>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
 9ea:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 9ec:	00001717          	auipc	a4,0x1
 9f0:	60f73a23          	sd	a5,1556(a4) # 2000 <freep>
}
 9f4:	60a2                	ld	ra,8(sp)
 9f6:	6402                	ld	s0,0(sp)
 9f8:	0141                	addi	sp,sp,16
 9fa:	8082                	ret
    bp->s.size += p->s.ptr->s.size;
 9fc:	4618                	lw	a4,8(a2)
 9fe:	9f2d                	addw	a4,a4,a1
 a00:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 a04:	6398                	ld	a4,0(a5)
 a06:	6310                	ld	a2,0(a4)
 a08:	b7f9                	j	9d6 <free+0x44>
    p->s.size += bp->s.size;
 a0a:	ff852703          	lw	a4,-8(a0)
 a0e:	9f31                	addw	a4,a4,a2
 a10:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 a12:	ff053683          	ld	a3,-16(a0)
 a16:	bfd1                	j	9ea <free+0x58>

0000000000000a18 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 a18:	7139                	addi	sp,sp,-64
 a1a:	fc06                	sd	ra,56(sp)
 a1c:	f822                	sd	s0,48(sp)
 a1e:	f04a                	sd	s2,32(sp)
 a20:	ec4e                	sd	s3,24(sp)
 a22:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 a24:	02051993          	slli	s3,a0,0x20
 a28:	0209d993          	srli	s3,s3,0x20
 a2c:	09bd                	addi	s3,s3,15
 a2e:	0049d993          	srli	s3,s3,0x4
 a32:	2985                	addiw	s3,s3,1
 a34:	894e                	mv	s2,s3
  if((prevp = freep) == 0){
 a36:	00001517          	auipc	a0,0x1
 a3a:	5ca53503          	ld	a0,1482(a0) # 2000 <freep>
 a3e:	c905                	beqz	a0,a6e <malloc+0x56>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 a40:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 a42:	4798                	lw	a4,8(a5)
 a44:	09377663          	bgeu	a4,s3,ad0 <malloc+0xb8>
 a48:	f426                	sd	s1,40(sp)
 a4a:	e852                	sd	s4,16(sp)
 a4c:	e456                	sd	s5,8(sp)
 a4e:	e05a                	sd	s6,0(sp)
  if(nu < 4096)
 a50:	8a4e                	mv	s4,s3
 a52:	6705                	lui	a4,0x1
 a54:	00e9f363          	bgeu	s3,a4,a5a <malloc+0x42>
 a58:	6a05                	lui	s4,0x1
 a5a:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 a5e:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 a62:	00001497          	auipc	s1,0x1
 a66:	59e48493          	addi	s1,s1,1438 # 2000 <freep>
  if(p == SBRK_ERROR)
 a6a:	5afd                	li	s5,-1
 a6c:	a83d                	j	aaa <malloc+0x92>
 a6e:	f426                	sd	s1,40(sp)
 a70:	e852                	sd	s4,16(sp)
 a72:	e456                	sd	s5,8(sp)
 a74:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
 a76:	00002797          	auipc	a5,0x2
 a7a:	99a78793          	addi	a5,a5,-1638 # 2410 <base>
 a7e:	00001717          	auipc	a4,0x1
 a82:	58f73123          	sd	a5,1410(a4) # 2000 <freep>
 a86:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 a88:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 a8c:	b7d1                	j	a50 <malloc+0x38>
        prevp->s.ptr = p->s.ptr;
 a8e:	6398                	ld	a4,0(a5)
 a90:	e118                	sd	a4,0(a0)
 a92:	a899                	j	ae8 <malloc+0xd0>
  hp->s.size = nu;
 a94:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 a98:	0541                	addi	a0,a0,16
 a9a:	ef9ff0ef          	jal	992 <free>
  return freep;
 a9e:	6088                	ld	a0,0(s1)
      if((p = morecore(nunits)) == 0)
 aa0:	c125                	beqz	a0,b00 <malloc+0xe8>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 aa2:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 aa4:	4798                	lw	a4,8(a5)
 aa6:	03277163          	bgeu	a4,s2,ac8 <malloc+0xb0>
    if(p == freep)
 aaa:	6098                	ld	a4,0(s1)
 aac:	853e                	mv	a0,a5
 aae:	fef71ae3          	bne	a4,a5,aa2 <malloc+0x8a>
  p = sbrk(nu * sizeof(Header));
 ab2:	8552                	mv	a0,s4
 ab4:	a2bff0ef          	jal	4de <sbrk>
  if(p == SBRK_ERROR)
 ab8:	fd551ee3          	bne	a0,s5,a94 <malloc+0x7c>
        return 0;
 abc:	4501                	li	a0,0
 abe:	74a2                	ld	s1,40(sp)
 ac0:	6a42                	ld	s4,16(sp)
 ac2:	6aa2                	ld	s5,8(sp)
 ac4:	6b02                	ld	s6,0(sp)
 ac6:	a03d                	j	af4 <malloc+0xdc>
 ac8:	74a2                	ld	s1,40(sp)
 aca:	6a42                	ld	s4,16(sp)
 acc:	6aa2                	ld	s5,8(sp)
 ace:	6b02                	ld	s6,0(sp)
      if(p->s.size == nunits)
 ad0:	fae90fe3          	beq	s2,a4,a8e <malloc+0x76>
        p->s.size -= nunits;
 ad4:	4137073b          	subw	a4,a4,s3
 ad8:	c798                	sw	a4,8(a5)
        p += p->s.size;
 ada:	02071693          	slli	a3,a4,0x20
 ade:	01c6d713          	srli	a4,a3,0x1c
 ae2:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 ae4:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 ae8:	00001717          	auipc	a4,0x1
 aec:	50a73c23          	sd	a0,1304(a4) # 2000 <freep>
      return (void*)(p + 1);
 af0:	01078513          	addi	a0,a5,16
  }
}
 af4:	70e2                	ld	ra,56(sp)
 af6:	7442                	ld	s0,48(sp)
 af8:	7902                	ld	s2,32(sp)
 afa:	69e2                	ld	s3,24(sp)
 afc:	6121                	addi	sp,sp,64
 afe:	8082                	ret
 b00:	74a2                	ld	s1,40(sp)
 b02:	6a42                	ld	s4,16(sp)
 b04:	6aa2                	ld	s5,8(sp)
 b06:	6b02                	ld	s6,0(sp)
 b08:	b7f5                	j	af4 <malloc+0xdc>
