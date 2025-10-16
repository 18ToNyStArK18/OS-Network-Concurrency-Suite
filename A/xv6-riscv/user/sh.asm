
user/_sh:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <getcmd>:
  exit(0);
}

int
getcmd(char *buf, int nbuf)
{
       0:	1101                	addi	sp,sp,-32
       2:	ec06                	sd	ra,24(sp)
       4:	e822                	sd	s0,16(sp)
       6:	e426                	sd	s1,8(sp)
       8:	e04a                	sd	s2,0(sp)
       a:	1000                	addi	s0,sp,32
       c:	84aa                	mv	s1,a0
       e:	892e                	mv	s2,a1
  write(2, "$ ", 2);
      10:	4609                	li	a2,2
      12:	00001597          	auipc	a1,0x1
      16:	26e58593          	addi	a1,a1,622 # 1280 <malloc+0xfc>
      1a:	8532                	mv	a0,a2
      1c:	48b000ef          	jal	ca6 <write>
  memset(buf, 0, nbuf);
      20:	864a                	mv	a2,s2
      22:	4581                	li	a1,0
      24:	8526                	mv	a0,s1
      26:	237000ef          	jal	a5c <memset>
  gets(buf, nbuf);
      2a:	85ca                	mv	a1,s2
      2c:	8526                	mv	a0,s1
      2e:	27d000ef          	jal	aaa <gets>
  if(buf[0] == 0) // EOF
      32:	0004c503          	lbu	a0,0(s1)
      36:	00153513          	seqz	a0,a0
    return -1;
  return 0;
}
      3a:	40a0053b          	negw	a0,a0
      3e:	60e2                	ld	ra,24(sp)
      40:	6442                	ld	s0,16(sp)
      42:	64a2                	ld	s1,8(sp)
      44:	6902                	ld	s2,0(sp)
      46:	6105                	addi	sp,sp,32
      48:	8082                	ret

000000000000004a <panic>:
  exit(0);
}

void
panic(char *s)
{
      4a:	1141                	addi	sp,sp,-16
      4c:	e406                	sd	ra,8(sp)
      4e:	e022                	sd	s0,0(sp)
      50:	0800                	addi	s0,sp,16
      52:	862a                	mv	a2,a0
  fprintf(2, "%s\n", s);
      54:	00001597          	auipc	a1,0x1
      58:	23c58593          	addi	a1,a1,572 # 1290 <malloc+0x10c>
      5c:	4509                	li	a0,2
      5e:	044010ef          	jal	10a2 <fprintf>
  exit(1);
      62:	4505                	li	a0,1
      64:	423000ef          	jal	c86 <exit>

0000000000000068 <fork1>:
}

int
fork1(void)
{
      68:	1141                	addi	sp,sp,-16
      6a:	e406                	sd	ra,8(sp)
      6c:	e022                	sd	s0,0(sp)
      6e:	0800                	addi	s0,sp,16
  int pid;

  pid = fork();
      70:	40f000ef          	jal	c7e <fork>
  if(pid == -1)
      74:	57fd                	li	a5,-1
      76:	00f50663          	beq	a0,a5,82 <fork1+0x1a>
    panic("fork");
  return pid;
}
      7a:	60a2                	ld	ra,8(sp)
      7c:	6402                	ld	s0,0(sp)
      7e:	0141                	addi	sp,sp,16
      80:	8082                	ret
    panic("fork");
      82:	00001517          	auipc	a0,0x1
      86:	21650513          	addi	a0,a0,534 # 1298 <malloc+0x114>
      8a:	fc1ff0ef          	jal	4a <panic>

000000000000008e <runcmd>:
{
      8e:	7179                	addi	sp,sp,-48
      90:	f406                	sd	ra,40(sp)
      92:	f022                	sd	s0,32(sp)
      94:	1800                	addi	s0,sp,48
  if(cmd == 0)
      96:	c115                	beqz	a0,ba <runcmd+0x2c>
      98:	ec26                	sd	s1,24(sp)
      9a:	84aa                	mv	s1,a0
  switch(cmd->type){
      9c:	4118                	lw	a4,0(a0)
      9e:	4795                	li	a5,5
      a0:	02e7e163          	bltu	a5,a4,c2 <runcmd+0x34>
      a4:	00056783          	lwu	a5,0(a0)
      a8:	078a                	slli	a5,a5,0x2
      aa:	00001717          	auipc	a4,0x1
      ae:	2ee70713          	addi	a4,a4,750 # 1398 <malloc+0x214>
      b2:	97ba                	add	a5,a5,a4
      b4:	439c                	lw	a5,0(a5)
      b6:	97ba                	add	a5,a5,a4
      b8:	8782                	jr	a5
      ba:	ec26                	sd	s1,24(sp)
    exit(1);
      bc:	4505                	li	a0,1
      be:	3c9000ef          	jal	c86 <exit>
    panic("runcmd");
      c2:	00001517          	auipc	a0,0x1
      c6:	1de50513          	addi	a0,a0,478 # 12a0 <malloc+0x11c>
      ca:	f81ff0ef          	jal	4a <panic>
    if(ecmd->argv[0] == 0)
      ce:	6508                	ld	a0,8(a0)
      d0:	c105                	beqz	a0,f0 <runcmd+0x62>
    exec(ecmd->argv[0], ecmd->argv);
      d2:	00848593          	addi	a1,s1,8
      d6:	3e9000ef          	jal	cbe <exec>
    fprintf(2, "exec %s failed\n", ecmd->argv[0]);
      da:	6490                	ld	a2,8(s1)
      dc:	00001597          	auipc	a1,0x1
      e0:	1cc58593          	addi	a1,a1,460 # 12a8 <malloc+0x124>
      e4:	4509                	li	a0,2
      e6:	7bd000ef          	jal	10a2 <fprintf>
  exit(0);
      ea:	4501                	li	a0,0
      ec:	39b000ef          	jal	c86 <exit>
      exit(1);
      f0:	4505                	li	a0,1
      f2:	395000ef          	jal	c86 <exit>
    close(rcmd->fd);
      f6:	5148                	lw	a0,36(a0)
      f8:	3b7000ef          	jal	cae <close>
    if(open(rcmd->file, rcmd->mode) < 0){
      fc:	508c                	lw	a1,32(s1)
      fe:	6888                	ld	a0,16(s1)
     100:	3c7000ef          	jal	cc6 <open>
     104:	00054563          	bltz	a0,10e <runcmd+0x80>
    runcmd(rcmd->cmd);
     108:	6488                	ld	a0,8(s1)
     10a:	f85ff0ef          	jal	8e <runcmd>
      fprintf(2, "open %s failed\n", rcmd->file);
     10e:	6890                	ld	a2,16(s1)
     110:	00001597          	auipc	a1,0x1
     114:	1a858593          	addi	a1,a1,424 # 12b8 <malloc+0x134>
     118:	4509                	li	a0,2
     11a:	789000ef          	jal	10a2 <fprintf>
      exit(1);
     11e:	4505                	li	a0,1
     120:	367000ef          	jal	c86 <exit>
    if(fork1() == 0)
     124:	f45ff0ef          	jal	68 <fork1>
     128:	e501                	bnez	a0,130 <runcmd+0xa2>
      runcmd(lcmd->left);
     12a:	6488                	ld	a0,8(s1)
     12c:	f63ff0ef          	jal	8e <runcmd>
    wait(0);
     130:	4501                	li	a0,0
     132:	35d000ef          	jal	c8e <wait>
    runcmd(lcmd->right);
     136:	6888                	ld	a0,16(s1)
     138:	f57ff0ef          	jal	8e <runcmd>
    if(pipe(p) < 0)
     13c:	fd840513          	addi	a0,s0,-40
     140:	357000ef          	jal	c96 <pipe>
     144:	02054763          	bltz	a0,172 <runcmd+0xe4>
    if(fork1() == 0){
     148:	f21ff0ef          	jal	68 <fork1>
     14c:	e90d                	bnez	a0,17e <runcmd+0xf0>
      close(1);
     14e:	4505                	li	a0,1
     150:	35f000ef          	jal	cae <close>
      dup(p[1]);
     154:	fdc42503          	lw	a0,-36(s0)
     158:	3a7000ef          	jal	cfe <dup>
      close(p[0]);
     15c:	fd842503          	lw	a0,-40(s0)
     160:	34f000ef          	jal	cae <close>
      close(p[1]);
     164:	fdc42503          	lw	a0,-36(s0)
     168:	347000ef          	jal	cae <close>
      runcmd(pcmd->left);
     16c:	6488                	ld	a0,8(s1)
     16e:	f21ff0ef          	jal	8e <runcmd>
      panic("pipe");
     172:	00001517          	auipc	a0,0x1
     176:	15650513          	addi	a0,a0,342 # 12c8 <malloc+0x144>
     17a:	ed1ff0ef          	jal	4a <panic>
    if(fork1() == 0){
     17e:	eebff0ef          	jal	68 <fork1>
     182:	e115                	bnez	a0,1a6 <runcmd+0x118>
      close(0);
     184:	32b000ef          	jal	cae <close>
      dup(p[0]);
     188:	fd842503          	lw	a0,-40(s0)
     18c:	373000ef          	jal	cfe <dup>
      close(p[0]);
     190:	fd842503          	lw	a0,-40(s0)
     194:	31b000ef          	jal	cae <close>
      close(p[1]);
     198:	fdc42503          	lw	a0,-36(s0)
     19c:	313000ef          	jal	cae <close>
      runcmd(pcmd->right);
     1a0:	6888                	ld	a0,16(s1)
     1a2:	eedff0ef          	jal	8e <runcmd>
    close(p[0]);
     1a6:	fd842503          	lw	a0,-40(s0)
     1aa:	305000ef          	jal	cae <close>
    close(p[1]);
     1ae:	fdc42503          	lw	a0,-36(s0)
     1b2:	2fd000ef          	jal	cae <close>
    wait(0);
     1b6:	4501                	li	a0,0
     1b8:	2d7000ef          	jal	c8e <wait>
    wait(0);
     1bc:	4501                	li	a0,0
     1be:	2d1000ef          	jal	c8e <wait>
    break;
     1c2:	b725                	j	ea <runcmd+0x5c>
    if(fork1() == 0)
     1c4:	ea5ff0ef          	jal	68 <fork1>
     1c8:	f20511e3          	bnez	a0,ea <runcmd+0x5c>
      runcmd(bcmd->cmd);
     1cc:	6488                	ld	a0,8(s1)
     1ce:	ec1ff0ef          	jal	8e <runcmd>

00000000000001d2 <execcmd>:
//PAGEBREAK!
// Constructors

struct cmd*
execcmd(void)
{
     1d2:	1101                	addi	sp,sp,-32
     1d4:	ec06                	sd	ra,24(sp)
     1d6:	e822                	sd	s0,16(sp)
     1d8:	e426                	sd	s1,8(sp)
     1da:	1000                	addi	s0,sp,32
  struct execcmd *cmd;

  cmd = malloc(sizeof(*cmd));
     1dc:	0a800513          	li	a0,168
     1e0:	7a5000ef          	jal	1184 <malloc>
     1e4:	84aa                	mv	s1,a0
  memset(cmd, 0, sizeof(*cmd));
     1e6:	0a800613          	li	a2,168
     1ea:	4581                	li	a1,0
     1ec:	071000ef          	jal	a5c <memset>
  cmd->type = EXEC;
     1f0:	4785                	li	a5,1
     1f2:	c09c                	sw	a5,0(s1)
  return (struct cmd*)cmd;
}
     1f4:	8526                	mv	a0,s1
     1f6:	60e2                	ld	ra,24(sp)
     1f8:	6442                	ld	s0,16(sp)
     1fa:	64a2                	ld	s1,8(sp)
     1fc:	6105                	addi	sp,sp,32
     1fe:	8082                	ret

0000000000000200 <redircmd>:

struct cmd*
redircmd(struct cmd *subcmd, char *file, char *efile, int mode, int fd)
{
     200:	7139                	addi	sp,sp,-64
     202:	fc06                	sd	ra,56(sp)
     204:	f822                	sd	s0,48(sp)
     206:	f426                	sd	s1,40(sp)
     208:	f04a                	sd	s2,32(sp)
     20a:	ec4e                	sd	s3,24(sp)
     20c:	e852                	sd	s4,16(sp)
     20e:	e456                	sd	s5,8(sp)
     210:	e05a                	sd	s6,0(sp)
     212:	0080                	addi	s0,sp,64
     214:	892a                	mv	s2,a0
     216:	89ae                	mv	s3,a1
     218:	8a32                	mv	s4,a2
     21a:	8ab6                	mv	s5,a3
     21c:	8b3a                	mv	s6,a4
  struct redircmd *cmd;

  cmd = malloc(sizeof(*cmd));
     21e:	02800513          	li	a0,40
     222:	763000ef          	jal	1184 <malloc>
     226:	84aa                	mv	s1,a0
  memset(cmd, 0, sizeof(*cmd));
     228:	02800613          	li	a2,40
     22c:	4581                	li	a1,0
     22e:	02f000ef          	jal	a5c <memset>
  cmd->type = REDIR;
     232:	4789                	li	a5,2
     234:	c09c                	sw	a5,0(s1)
  cmd->cmd = subcmd;
     236:	0124b423          	sd	s2,8(s1)
  cmd->file = file;
     23a:	0134b823          	sd	s3,16(s1)
  cmd->efile = efile;
     23e:	0144bc23          	sd	s4,24(s1)
  cmd->mode = mode;
     242:	0354a023          	sw	s5,32(s1)
  cmd->fd = fd;
     246:	0364a223          	sw	s6,36(s1)
  return (struct cmd*)cmd;
}
     24a:	8526                	mv	a0,s1
     24c:	70e2                	ld	ra,56(sp)
     24e:	7442                	ld	s0,48(sp)
     250:	74a2                	ld	s1,40(sp)
     252:	7902                	ld	s2,32(sp)
     254:	69e2                	ld	s3,24(sp)
     256:	6a42                	ld	s4,16(sp)
     258:	6aa2                	ld	s5,8(sp)
     25a:	6b02                	ld	s6,0(sp)
     25c:	6121                	addi	sp,sp,64
     25e:	8082                	ret

0000000000000260 <pipecmd>:

struct cmd*
pipecmd(struct cmd *left, struct cmd *right)
{
     260:	7179                	addi	sp,sp,-48
     262:	f406                	sd	ra,40(sp)
     264:	f022                	sd	s0,32(sp)
     266:	ec26                	sd	s1,24(sp)
     268:	e84a                	sd	s2,16(sp)
     26a:	e44e                	sd	s3,8(sp)
     26c:	1800                	addi	s0,sp,48
     26e:	892a                	mv	s2,a0
     270:	89ae                	mv	s3,a1
  struct pipecmd *cmd;

  cmd = malloc(sizeof(*cmd));
     272:	4561                	li	a0,24
     274:	711000ef          	jal	1184 <malloc>
     278:	84aa                	mv	s1,a0
  memset(cmd, 0, sizeof(*cmd));
     27a:	4661                	li	a2,24
     27c:	4581                	li	a1,0
     27e:	7de000ef          	jal	a5c <memset>
  cmd->type = PIPE;
     282:	478d                	li	a5,3
     284:	c09c                	sw	a5,0(s1)
  cmd->left = left;
     286:	0124b423          	sd	s2,8(s1)
  cmd->right = right;
     28a:	0134b823          	sd	s3,16(s1)
  return (struct cmd*)cmd;
}
     28e:	8526                	mv	a0,s1
     290:	70a2                	ld	ra,40(sp)
     292:	7402                	ld	s0,32(sp)
     294:	64e2                	ld	s1,24(sp)
     296:	6942                	ld	s2,16(sp)
     298:	69a2                	ld	s3,8(sp)
     29a:	6145                	addi	sp,sp,48
     29c:	8082                	ret

000000000000029e <listcmd>:

struct cmd*
listcmd(struct cmd *left, struct cmd *right)
{
     29e:	7179                	addi	sp,sp,-48
     2a0:	f406                	sd	ra,40(sp)
     2a2:	f022                	sd	s0,32(sp)
     2a4:	ec26                	sd	s1,24(sp)
     2a6:	e84a                	sd	s2,16(sp)
     2a8:	e44e                	sd	s3,8(sp)
     2aa:	1800                	addi	s0,sp,48
     2ac:	892a                	mv	s2,a0
     2ae:	89ae                	mv	s3,a1
  struct listcmd *cmd;

  cmd = malloc(sizeof(*cmd));
     2b0:	4561                	li	a0,24
     2b2:	6d3000ef          	jal	1184 <malloc>
     2b6:	84aa                	mv	s1,a0
  memset(cmd, 0, sizeof(*cmd));
     2b8:	4661                	li	a2,24
     2ba:	4581                	li	a1,0
     2bc:	7a0000ef          	jal	a5c <memset>
  cmd->type = LIST;
     2c0:	4791                	li	a5,4
     2c2:	c09c                	sw	a5,0(s1)
  cmd->left = left;
     2c4:	0124b423          	sd	s2,8(s1)
  cmd->right = right;
     2c8:	0134b823          	sd	s3,16(s1)
  return (struct cmd*)cmd;
}
     2cc:	8526                	mv	a0,s1
     2ce:	70a2                	ld	ra,40(sp)
     2d0:	7402                	ld	s0,32(sp)
     2d2:	64e2                	ld	s1,24(sp)
     2d4:	6942                	ld	s2,16(sp)
     2d6:	69a2                	ld	s3,8(sp)
     2d8:	6145                	addi	sp,sp,48
     2da:	8082                	ret

00000000000002dc <backcmd>:

struct cmd*
backcmd(struct cmd *subcmd)
{
     2dc:	1101                	addi	sp,sp,-32
     2de:	ec06                	sd	ra,24(sp)
     2e0:	e822                	sd	s0,16(sp)
     2e2:	e426                	sd	s1,8(sp)
     2e4:	e04a                	sd	s2,0(sp)
     2e6:	1000                	addi	s0,sp,32
     2e8:	892a                	mv	s2,a0
  struct backcmd *cmd;

  cmd = malloc(sizeof(*cmd));
     2ea:	4541                	li	a0,16
     2ec:	699000ef          	jal	1184 <malloc>
     2f0:	84aa                	mv	s1,a0
  memset(cmd, 0, sizeof(*cmd));
     2f2:	4641                	li	a2,16
     2f4:	4581                	li	a1,0
     2f6:	766000ef          	jal	a5c <memset>
  cmd->type = BACK;
     2fa:	4795                	li	a5,5
     2fc:	c09c                	sw	a5,0(s1)
  cmd->cmd = subcmd;
     2fe:	0124b423          	sd	s2,8(s1)
  return (struct cmd*)cmd;
}
     302:	8526                	mv	a0,s1
     304:	60e2                	ld	ra,24(sp)
     306:	6442                	ld	s0,16(sp)
     308:	64a2                	ld	s1,8(sp)
     30a:	6902                	ld	s2,0(sp)
     30c:	6105                	addi	sp,sp,32
     30e:	8082                	ret

0000000000000310 <gettoken>:
char whitespace[] = " \t\r\n\v";
char symbols[] = "<|>&;()";

int
gettoken(char **ps, char *es, char **q, char **eq)
{
     310:	7139                	addi	sp,sp,-64
     312:	fc06                	sd	ra,56(sp)
     314:	f822                	sd	s0,48(sp)
     316:	f426                	sd	s1,40(sp)
     318:	f04a                	sd	s2,32(sp)
     31a:	ec4e                	sd	s3,24(sp)
     31c:	e852                	sd	s4,16(sp)
     31e:	e456                	sd	s5,8(sp)
     320:	e05a                	sd	s6,0(sp)
     322:	0080                	addi	s0,sp,64
     324:	8a2a                	mv	s4,a0
     326:	892e                	mv	s2,a1
     328:	8ab2                	mv	s5,a2
     32a:	8b36                	mv	s6,a3
  char *s;
  int ret;

  s = *ps;
     32c:	6104                	ld	s1,0(a0)
  while(s < es && strchr(whitespace, *s))
     32e:	00002997          	auipc	s3,0x2
     332:	cda98993          	addi	s3,s3,-806 # 2008 <whitespace>
     336:	00b4fc63          	bgeu	s1,a1,34e <gettoken+0x3e>
     33a:	0004c583          	lbu	a1,0(s1)
     33e:	854e                	mv	a0,s3
     340:	742000ef          	jal	a82 <strchr>
     344:	c509                	beqz	a0,34e <gettoken+0x3e>
    s++;
     346:	0485                	addi	s1,s1,1
  while(s < es && strchr(whitespace, *s))
     348:	fe9919e3          	bne	s2,s1,33a <gettoken+0x2a>
     34c:	84ca                	mv	s1,s2
  if(q)
     34e:	000a8463          	beqz	s5,356 <gettoken+0x46>
    *q = s;
     352:	009ab023          	sd	s1,0(s5)
  ret = *s;
     356:	0004c783          	lbu	a5,0(s1)
     35a:	00078a9b          	sext.w	s5,a5
  switch(*s){
     35e:	03c00713          	li	a4,60
     362:	06f76463          	bltu	a4,a5,3ca <gettoken+0xba>
     366:	03a00713          	li	a4,58
     36a:	00f76e63          	bltu	a4,a5,386 <gettoken+0x76>
     36e:	cf89                	beqz	a5,388 <gettoken+0x78>
     370:	02600713          	li	a4,38
     374:	00e78963          	beq	a5,a4,386 <gettoken+0x76>
     378:	fd87879b          	addiw	a5,a5,-40
     37c:	0ff7f793          	zext.b	a5,a5
     380:	4705                	li	a4,1
     382:	06f76563          	bltu	a4,a5,3ec <gettoken+0xdc>
  case '(':
  case ')':
  case ';':
  case '&':
  case '<':
    s++;
     386:	0485                	addi	s1,s1,1
    ret = 'a';
    while(s < es && !strchr(whitespace, *s) && !strchr(symbols, *s))
      s++;
    break;
  }
  if(eq)
     388:	000b0463          	beqz	s6,390 <gettoken+0x80>
    *eq = s;
     38c:	009b3023          	sd	s1,0(s6)

  while(s < es && strchr(whitespace, *s))
     390:	00002997          	auipc	s3,0x2
     394:	c7898993          	addi	s3,s3,-904 # 2008 <whitespace>
     398:	0124fc63          	bgeu	s1,s2,3b0 <gettoken+0xa0>
     39c:	0004c583          	lbu	a1,0(s1)
     3a0:	854e                	mv	a0,s3
     3a2:	6e0000ef          	jal	a82 <strchr>
     3a6:	c509                	beqz	a0,3b0 <gettoken+0xa0>
    s++;
     3a8:	0485                	addi	s1,s1,1
  while(s < es && strchr(whitespace, *s))
     3aa:	fe9919e3          	bne	s2,s1,39c <gettoken+0x8c>
     3ae:	84ca                	mv	s1,s2
  *ps = s;
     3b0:	009a3023          	sd	s1,0(s4)
  return ret;
}
     3b4:	8556                	mv	a0,s5
     3b6:	70e2                	ld	ra,56(sp)
     3b8:	7442                	ld	s0,48(sp)
     3ba:	74a2                	ld	s1,40(sp)
     3bc:	7902                	ld	s2,32(sp)
     3be:	69e2                	ld	s3,24(sp)
     3c0:	6a42                	ld	s4,16(sp)
     3c2:	6aa2                	ld	s5,8(sp)
     3c4:	6b02                	ld	s6,0(sp)
     3c6:	6121                	addi	sp,sp,64
     3c8:	8082                	ret
  switch(*s){
     3ca:	03e00713          	li	a4,62
     3ce:	00e79b63          	bne	a5,a4,3e4 <gettoken+0xd4>
    if(*s == '>'){
     3d2:	0014c703          	lbu	a4,1(s1)
     3d6:	03e00793          	li	a5,62
     3da:	04f70863          	beq	a4,a5,42a <gettoken+0x11a>
    s++;
     3de:	0485                	addi	s1,s1,1
  ret = *s;
     3e0:	8abe                	mv	s5,a5
     3e2:	b75d                	j	388 <gettoken+0x78>
  switch(*s){
     3e4:	07c00713          	li	a4,124
     3e8:	f8e78fe3          	beq	a5,a4,386 <gettoken+0x76>
    while(s < es && !strchr(whitespace, *s) && !strchr(symbols, *s))
     3ec:	00002997          	auipc	s3,0x2
     3f0:	c1c98993          	addi	s3,s3,-996 # 2008 <whitespace>
     3f4:	00002a97          	auipc	s5,0x2
     3f8:	c0ca8a93          	addi	s5,s5,-1012 # 2000 <symbols>
     3fc:	0524f163          	bgeu	s1,s2,43e <gettoken+0x12e>
     400:	0004c583          	lbu	a1,0(s1)
     404:	854e                	mv	a0,s3
     406:	67c000ef          	jal	a82 <strchr>
     40a:	e51d                	bnez	a0,438 <gettoken+0x128>
     40c:	0004c583          	lbu	a1,0(s1)
     410:	8556                	mv	a0,s5
     412:	670000ef          	jal	a82 <strchr>
     416:	ed11                	bnez	a0,432 <gettoken+0x122>
      s++;
     418:	0485                	addi	s1,s1,1
    while(s < es && !strchr(whitespace, *s) && !strchr(symbols, *s))
     41a:	fe9913e3          	bne	s2,s1,400 <gettoken+0xf0>
  if(eq)
     41e:	84ca                	mv	s1,s2
    ret = 'a';
     420:	06100a93          	li	s5,97
  if(eq)
     424:	f60b14e3          	bnez	s6,38c <gettoken+0x7c>
     428:	b761                	j	3b0 <gettoken+0xa0>
      s++;
     42a:	0489                	addi	s1,s1,2
      ret = '+';
     42c:	02b00a93          	li	s5,43
     430:	bfa1                	j	388 <gettoken+0x78>
    ret = 'a';
     432:	06100a93          	li	s5,97
     436:	bf89                	j	388 <gettoken+0x78>
     438:	06100a93          	li	s5,97
     43c:	b7b1                	j	388 <gettoken+0x78>
     43e:	06100a93          	li	s5,97
  if(eq)
     442:	f40b15e3          	bnez	s6,38c <gettoken+0x7c>
     446:	b7ad                	j	3b0 <gettoken+0xa0>

0000000000000448 <peek>:

int
peek(char **ps, char *es, char *toks)
{
     448:	7139                	addi	sp,sp,-64
     44a:	fc06                	sd	ra,56(sp)
     44c:	f822                	sd	s0,48(sp)
     44e:	f426                	sd	s1,40(sp)
     450:	f04a                	sd	s2,32(sp)
     452:	ec4e                	sd	s3,24(sp)
     454:	e852                	sd	s4,16(sp)
     456:	e456                	sd	s5,8(sp)
     458:	0080                	addi	s0,sp,64
     45a:	8a2a                	mv	s4,a0
     45c:	892e                	mv	s2,a1
     45e:	8ab2                	mv	s5,a2
  char *s;

  s = *ps;
     460:	6104                	ld	s1,0(a0)
  while(s < es && strchr(whitespace, *s))
     462:	00002997          	auipc	s3,0x2
     466:	ba698993          	addi	s3,s3,-1114 # 2008 <whitespace>
     46a:	00b4fc63          	bgeu	s1,a1,482 <peek+0x3a>
     46e:	0004c583          	lbu	a1,0(s1)
     472:	854e                	mv	a0,s3
     474:	60e000ef          	jal	a82 <strchr>
     478:	c509                	beqz	a0,482 <peek+0x3a>
    s++;
     47a:	0485                	addi	s1,s1,1
  while(s < es && strchr(whitespace, *s))
     47c:	fe9919e3          	bne	s2,s1,46e <peek+0x26>
     480:	84ca                	mv	s1,s2
  *ps = s;
     482:	009a3023          	sd	s1,0(s4)
  return *s && strchr(toks, *s);
     486:	0004c583          	lbu	a1,0(s1)
     48a:	4501                	li	a0,0
     48c:	e991                	bnez	a1,4a0 <peek+0x58>
}
     48e:	70e2                	ld	ra,56(sp)
     490:	7442                	ld	s0,48(sp)
     492:	74a2                	ld	s1,40(sp)
     494:	7902                	ld	s2,32(sp)
     496:	69e2                	ld	s3,24(sp)
     498:	6a42                	ld	s4,16(sp)
     49a:	6aa2                	ld	s5,8(sp)
     49c:	6121                	addi	sp,sp,64
     49e:	8082                	ret
  return *s && strchr(toks, *s);
     4a0:	8556                	mv	a0,s5
     4a2:	5e0000ef          	jal	a82 <strchr>
     4a6:	00a03533          	snez	a0,a0
     4aa:	b7d5                	j	48e <peek+0x46>

00000000000004ac <parseredirs>:
  return cmd;
}

struct cmd*
parseredirs(struct cmd *cmd, char **ps, char *es)
{
     4ac:	7159                	addi	sp,sp,-112
     4ae:	f486                	sd	ra,104(sp)
     4b0:	f0a2                	sd	s0,96(sp)
     4b2:	eca6                	sd	s1,88(sp)
     4b4:	e8ca                	sd	s2,80(sp)
     4b6:	e4ce                	sd	s3,72(sp)
     4b8:	e0d2                	sd	s4,64(sp)
     4ba:	fc56                	sd	s5,56(sp)
     4bc:	f85a                	sd	s6,48(sp)
     4be:	f45e                	sd	s7,40(sp)
     4c0:	f062                	sd	s8,32(sp)
     4c2:	ec66                	sd	s9,24(sp)
     4c4:	1880                	addi	s0,sp,112
     4c6:	8a2a                	mv	s4,a0
     4c8:	89ae                	mv	s3,a1
     4ca:	8932                	mv	s2,a2
  int tok;
  char *q, *eq;

  while(peek(ps, es, "<>")){
     4cc:	00001b17          	auipc	s6,0x1
     4d0:	e24b0b13          	addi	s6,s6,-476 # 12f0 <malloc+0x16c>
    tok = gettoken(ps, es, 0, 0);
    if(gettoken(ps, es, &q, &eq) != 'a')
     4d4:	f9040c93          	addi	s9,s0,-112
     4d8:	f9840c13          	addi	s8,s0,-104
     4dc:	06100b93          	li	s7,97
  while(peek(ps, es, "<>")){
     4e0:	a00d                	j	502 <parseredirs+0x56>
      panic("missing file for redirection");
     4e2:	00001517          	auipc	a0,0x1
     4e6:	dee50513          	addi	a0,a0,-530 # 12d0 <malloc+0x14c>
     4ea:	b61ff0ef          	jal	4a <panic>
    switch(tok){
    case '<':
      cmd = redircmd(cmd, q, eq, O_RDONLY, 0);
     4ee:	4701                	li	a4,0
     4f0:	4681                	li	a3,0
     4f2:	f9043603          	ld	a2,-112(s0)
     4f6:	f9843583          	ld	a1,-104(s0)
     4fa:	8552                	mv	a0,s4
     4fc:	d05ff0ef          	jal	200 <redircmd>
     500:	8a2a                	mv	s4,a0
    switch(tok){
     502:	03c00a93          	li	s5,60
  while(peek(ps, es, "<>")){
     506:	865a                	mv	a2,s6
     508:	85ca                	mv	a1,s2
     50a:	854e                	mv	a0,s3
     50c:	f3dff0ef          	jal	448 <peek>
     510:	c135                	beqz	a0,574 <parseredirs+0xc8>
    tok = gettoken(ps, es, 0, 0);
     512:	4681                	li	a3,0
     514:	4601                	li	a2,0
     516:	85ca                	mv	a1,s2
     518:	854e                	mv	a0,s3
     51a:	df7ff0ef          	jal	310 <gettoken>
     51e:	84aa                	mv	s1,a0
    if(gettoken(ps, es, &q, &eq) != 'a')
     520:	86e6                	mv	a3,s9
     522:	8662                	mv	a2,s8
     524:	85ca                	mv	a1,s2
     526:	854e                	mv	a0,s3
     528:	de9ff0ef          	jal	310 <gettoken>
     52c:	fb751be3          	bne	a0,s7,4e2 <parseredirs+0x36>
    switch(tok){
     530:	fb548fe3          	beq	s1,s5,4ee <parseredirs+0x42>
     534:	03e00793          	li	a5,62
     538:	02f48263          	beq	s1,a5,55c <parseredirs+0xb0>
     53c:	02b00793          	li	a5,43
     540:	fcf493e3          	bne	s1,a5,506 <parseredirs+0x5a>
      break;
    case '>':
      cmd = redircmd(cmd, q, eq, O_WRONLY|O_CREATE|O_TRUNC, 1);
      break;
    case '+':  // >>
      cmd = redircmd(cmd, q, eq, O_WRONLY|O_CREATE, 1);
     544:	4705                	li	a4,1
     546:	20100693          	li	a3,513
     54a:	f9043603          	ld	a2,-112(s0)
     54e:	f9843583          	ld	a1,-104(s0)
     552:	8552                	mv	a0,s4
     554:	cadff0ef          	jal	200 <redircmd>
     558:	8a2a                	mv	s4,a0
      break;
     55a:	b765                	j	502 <parseredirs+0x56>
      cmd = redircmd(cmd, q, eq, O_WRONLY|O_CREATE|O_TRUNC, 1);
     55c:	4705                	li	a4,1
     55e:	60100693          	li	a3,1537
     562:	f9043603          	ld	a2,-112(s0)
     566:	f9843583          	ld	a1,-104(s0)
     56a:	8552                	mv	a0,s4
     56c:	c95ff0ef          	jal	200 <redircmd>
     570:	8a2a                	mv	s4,a0
      break;
     572:	bf41                	j	502 <parseredirs+0x56>
    }
  }
  return cmd;
}
     574:	8552                	mv	a0,s4
     576:	70a6                	ld	ra,104(sp)
     578:	7406                	ld	s0,96(sp)
     57a:	64e6                	ld	s1,88(sp)
     57c:	6946                	ld	s2,80(sp)
     57e:	69a6                	ld	s3,72(sp)
     580:	6a06                	ld	s4,64(sp)
     582:	7ae2                	ld	s5,56(sp)
     584:	7b42                	ld	s6,48(sp)
     586:	7ba2                	ld	s7,40(sp)
     588:	7c02                	ld	s8,32(sp)
     58a:	6ce2                	ld	s9,24(sp)
     58c:	6165                	addi	sp,sp,112
     58e:	8082                	ret

0000000000000590 <parseexec>:
  return cmd;
}

struct cmd*
parseexec(char **ps, char *es)
{
     590:	7119                	addi	sp,sp,-128
     592:	fc86                	sd	ra,120(sp)
     594:	f8a2                	sd	s0,112(sp)
     596:	f4a6                	sd	s1,104(sp)
     598:	e8d2                	sd	s4,80(sp)
     59a:	e4d6                	sd	s5,72(sp)
     59c:	0100                	addi	s0,sp,128
     59e:	8a2a                	mv	s4,a0
     5a0:	8aae                	mv	s5,a1
  char *q, *eq;
  int tok, argc;
  struct execcmd *cmd;
  struct cmd *ret;

  if(peek(ps, es, "("))
     5a2:	00001617          	auipc	a2,0x1
     5a6:	d5660613          	addi	a2,a2,-682 # 12f8 <malloc+0x174>
     5aa:	e9fff0ef          	jal	448 <peek>
     5ae:	e121                	bnez	a0,5ee <parseexec+0x5e>
     5b0:	f0ca                	sd	s2,96(sp)
     5b2:	ecce                	sd	s3,88(sp)
     5b4:	e0da                	sd	s6,64(sp)
     5b6:	fc5e                	sd	s7,56(sp)
     5b8:	f862                	sd	s8,48(sp)
     5ba:	f466                	sd	s9,40(sp)
     5bc:	f06a                	sd	s10,32(sp)
     5be:	ec6e                	sd	s11,24(sp)
     5c0:	892a                	mv	s2,a0
    return parseblock(ps, es);

  ret = execcmd();
     5c2:	c11ff0ef          	jal	1d2 <execcmd>
     5c6:	89aa                	mv	s3,a0
     5c8:	8daa                	mv	s11,a0
  cmd = (struct execcmd*)ret;

  argc = 0;
  ret = parseredirs(ret, ps, es);
     5ca:	8656                	mv	a2,s5
     5cc:	85d2                	mv	a1,s4
     5ce:	edfff0ef          	jal	4ac <parseredirs>
     5d2:	84aa                	mv	s1,a0
  while(!peek(ps, es, "|)&;")){
     5d4:	09a1                	addi	s3,s3,8
     5d6:	00001b17          	auipc	s6,0x1
     5da:	d42b0b13          	addi	s6,s6,-702 # 1318 <malloc+0x194>
    if((tok=gettoken(ps, es, &q, &eq)) == 0)
     5de:	f8040c13          	addi	s8,s0,-128
     5e2:	f8840b93          	addi	s7,s0,-120
      break;
    if(tok != 'a')
     5e6:	06100d13          	li	s10,97
      panic("syntax");
    cmd->argv[argc] = q;
    cmd->eargv[argc] = eq;
    argc++;
    if(argc >= MAXARGS)
     5ea:	4ca9                	li	s9,10
  while(!peek(ps, es, "|)&;")){
     5ec:	a81d                	j	622 <parseexec+0x92>
    return parseblock(ps, es);
     5ee:	85d6                	mv	a1,s5
     5f0:	8552                	mv	a0,s4
     5f2:	178000ef          	jal	76a <parseblock>
     5f6:	84aa                	mv	s1,a0
    ret = parseredirs(ret, ps, es);
  }
  cmd->argv[argc] = 0;
  cmd->eargv[argc] = 0;
  return ret;
}
     5f8:	8526                	mv	a0,s1
     5fa:	70e6                	ld	ra,120(sp)
     5fc:	7446                	ld	s0,112(sp)
     5fe:	74a6                	ld	s1,104(sp)
     600:	6a46                	ld	s4,80(sp)
     602:	6aa6                	ld	s5,72(sp)
     604:	6109                	addi	sp,sp,128
     606:	8082                	ret
      panic("syntax");
     608:	00001517          	auipc	a0,0x1
     60c:	cf850513          	addi	a0,a0,-776 # 1300 <malloc+0x17c>
     610:	a3bff0ef          	jal	4a <panic>
    if(argc >= MAXARGS)
     614:	09a1                	addi	s3,s3,8
    ret = parseredirs(ret, ps, es);
     616:	8656                	mv	a2,s5
     618:	85d2                	mv	a1,s4
     61a:	8526                	mv	a0,s1
     61c:	e91ff0ef          	jal	4ac <parseredirs>
     620:	84aa                	mv	s1,a0
  while(!peek(ps, es, "|)&;")){
     622:	865a                	mv	a2,s6
     624:	85d6                	mv	a1,s5
     626:	8552                	mv	a0,s4
     628:	e21ff0ef          	jal	448 <peek>
     62c:	e91d                	bnez	a0,662 <parseexec+0xd2>
    if((tok=gettoken(ps, es, &q, &eq)) == 0)
     62e:	86e2                	mv	a3,s8
     630:	865e                	mv	a2,s7
     632:	85d6                	mv	a1,s5
     634:	8552                	mv	a0,s4
     636:	cdbff0ef          	jal	310 <gettoken>
     63a:	c505                	beqz	a0,662 <parseexec+0xd2>
    if(tok != 'a')
     63c:	fda516e3          	bne	a0,s10,608 <parseexec+0x78>
    cmd->argv[argc] = q;
     640:	f8843783          	ld	a5,-120(s0)
     644:	00f9b023          	sd	a5,0(s3)
    cmd->eargv[argc] = eq;
     648:	f8043783          	ld	a5,-128(s0)
     64c:	04f9b823          	sd	a5,80(s3)
    argc++;
     650:	2905                	addiw	s2,s2,1
    if(argc >= MAXARGS)
     652:	fd9911e3          	bne	s2,s9,614 <parseexec+0x84>
      panic("too many args");
     656:	00001517          	auipc	a0,0x1
     65a:	cb250513          	addi	a0,a0,-846 # 1308 <malloc+0x184>
     65e:	9edff0ef          	jal	4a <panic>
  cmd->argv[argc] = 0;
     662:	090e                	slli	s2,s2,0x3
     664:	012d87b3          	add	a5,s11,s2
     668:	0007b423          	sd	zero,8(a5)
  cmd->eargv[argc] = 0;
     66c:	0407bc23          	sd	zero,88(a5)
     670:	7906                	ld	s2,96(sp)
     672:	69e6                	ld	s3,88(sp)
     674:	6b06                	ld	s6,64(sp)
     676:	7be2                	ld	s7,56(sp)
     678:	7c42                	ld	s8,48(sp)
     67a:	7ca2                	ld	s9,40(sp)
     67c:	7d02                	ld	s10,32(sp)
     67e:	6de2                	ld	s11,24(sp)
  return ret;
     680:	bfa5                	j	5f8 <parseexec+0x68>

0000000000000682 <parsepipe>:
{
     682:	7179                	addi	sp,sp,-48
     684:	f406                	sd	ra,40(sp)
     686:	f022                	sd	s0,32(sp)
     688:	ec26                	sd	s1,24(sp)
     68a:	e84a                	sd	s2,16(sp)
     68c:	e44e                	sd	s3,8(sp)
     68e:	e052                	sd	s4,0(sp)
     690:	1800                	addi	s0,sp,48
     692:	892a                	mv	s2,a0
     694:	8a2a                	mv	s4,a0
     696:	84ae                	mv	s1,a1
  cmd = parseexec(ps, es);
     698:	ef9ff0ef          	jal	590 <parseexec>
     69c:	89aa                	mv	s3,a0
  if(peek(ps, es, "|")){
     69e:	00001617          	auipc	a2,0x1
     6a2:	c8260613          	addi	a2,a2,-894 # 1320 <malloc+0x19c>
     6a6:	85a6                	mv	a1,s1
     6a8:	854a                	mv	a0,s2
     6aa:	d9fff0ef          	jal	448 <peek>
     6ae:	e911                	bnez	a0,6c2 <parsepipe+0x40>
}
     6b0:	854e                	mv	a0,s3
     6b2:	70a2                	ld	ra,40(sp)
     6b4:	7402                	ld	s0,32(sp)
     6b6:	64e2                	ld	s1,24(sp)
     6b8:	6942                	ld	s2,16(sp)
     6ba:	69a2                	ld	s3,8(sp)
     6bc:	6a02                	ld	s4,0(sp)
     6be:	6145                	addi	sp,sp,48
     6c0:	8082                	ret
    gettoken(ps, es, 0, 0);
     6c2:	4681                	li	a3,0
     6c4:	4601                	li	a2,0
     6c6:	85a6                	mv	a1,s1
     6c8:	8552                	mv	a0,s4
     6ca:	c47ff0ef          	jal	310 <gettoken>
    cmd = pipecmd(cmd, parsepipe(ps, es));
     6ce:	85a6                	mv	a1,s1
     6d0:	8552                	mv	a0,s4
     6d2:	fb1ff0ef          	jal	682 <parsepipe>
     6d6:	85aa                	mv	a1,a0
     6d8:	854e                	mv	a0,s3
     6da:	b87ff0ef          	jal	260 <pipecmd>
     6de:	89aa                	mv	s3,a0
  return cmd;
     6e0:	bfc1                	j	6b0 <parsepipe+0x2e>

00000000000006e2 <parseline>:
{
     6e2:	7179                	addi	sp,sp,-48
     6e4:	f406                	sd	ra,40(sp)
     6e6:	f022                	sd	s0,32(sp)
     6e8:	ec26                	sd	s1,24(sp)
     6ea:	e84a                	sd	s2,16(sp)
     6ec:	e44e                	sd	s3,8(sp)
     6ee:	e052                	sd	s4,0(sp)
     6f0:	1800                	addi	s0,sp,48
     6f2:	892a                	mv	s2,a0
     6f4:	89ae                	mv	s3,a1
  cmd = parsepipe(ps, es);
     6f6:	f8dff0ef          	jal	682 <parsepipe>
     6fa:	84aa                	mv	s1,a0
  while(peek(ps, es, "&")){
     6fc:	00001a17          	auipc	s4,0x1
     700:	c2ca0a13          	addi	s4,s4,-980 # 1328 <malloc+0x1a4>
     704:	a819                	j	71a <parseline+0x38>
    gettoken(ps, es, 0, 0);
     706:	4681                	li	a3,0
     708:	4601                	li	a2,0
     70a:	85ce                	mv	a1,s3
     70c:	854a                	mv	a0,s2
     70e:	c03ff0ef          	jal	310 <gettoken>
    cmd = backcmd(cmd);
     712:	8526                	mv	a0,s1
     714:	bc9ff0ef          	jal	2dc <backcmd>
     718:	84aa                	mv	s1,a0
  while(peek(ps, es, "&")){
     71a:	8652                	mv	a2,s4
     71c:	85ce                	mv	a1,s3
     71e:	854a                	mv	a0,s2
     720:	d29ff0ef          	jal	448 <peek>
     724:	f16d                	bnez	a0,706 <parseline+0x24>
  if(peek(ps, es, ";")){
     726:	00001617          	auipc	a2,0x1
     72a:	c0a60613          	addi	a2,a2,-1014 # 1330 <malloc+0x1ac>
     72e:	85ce                	mv	a1,s3
     730:	854a                	mv	a0,s2
     732:	d17ff0ef          	jal	448 <peek>
     736:	e911                	bnez	a0,74a <parseline+0x68>
}
     738:	8526                	mv	a0,s1
     73a:	70a2                	ld	ra,40(sp)
     73c:	7402                	ld	s0,32(sp)
     73e:	64e2                	ld	s1,24(sp)
     740:	6942                	ld	s2,16(sp)
     742:	69a2                	ld	s3,8(sp)
     744:	6a02                	ld	s4,0(sp)
     746:	6145                	addi	sp,sp,48
     748:	8082                	ret
    gettoken(ps, es, 0, 0);
     74a:	4681                	li	a3,0
     74c:	4601                	li	a2,0
     74e:	85ce                	mv	a1,s3
     750:	854a                	mv	a0,s2
     752:	bbfff0ef          	jal	310 <gettoken>
    cmd = listcmd(cmd, parseline(ps, es));
     756:	85ce                	mv	a1,s3
     758:	854a                	mv	a0,s2
     75a:	f89ff0ef          	jal	6e2 <parseline>
     75e:	85aa                	mv	a1,a0
     760:	8526                	mv	a0,s1
     762:	b3dff0ef          	jal	29e <listcmd>
     766:	84aa                	mv	s1,a0
  return cmd;
     768:	bfc1                	j	738 <parseline+0x56>

000000000000076a <parseblock>:
{
     76a:	7179                	addi	sp,sp,-48
     76c:	f406                	sd	ra,40(sp)
     76e:	f022                	sd	s0,32(sp)
     770:	ec26                	sd	s1,24(sp)
     772:	e84a                	sd	s2,16(sp)
     774:	e44e                	sd	s3,8(sp)
     776:	1800                	addi	s0,sp,48
     778:	84aa                	mv	s1,a0
     77a:	892e                	mv	s2,a1
  if(!peek(ps, es, "("))
     77c:	00001617          	auipc	a2,0x1
     780:	b7c60613          	addi	a2,a2,-1156 # 12f8 <malloc+0x174>
     784:	cc5ff0ef          	jal	448 <peek>
     788:	c539                	beqz	a0,7d6 <parseblock+0x6c>
  gettoken(ps, es, 0, 0);
     78a:	4681                	li	a3,0
     78c:	4601                	li	a2,0
     78e:	85ca                	mv	a1,s2
     790:	8526                	mv	a0,s1
     792:	b7fff0ef          	jal	310 <gettoken>
  cmd = parseline(ps, es);
     796:	85ca                	mv	a1,s2
     798:	8526                	mv	a0,s1
     79a:	f49ff0ef          	jal	6e2 <parseline>
     79e:	89aa                	mv	s3,a0
  if(!peek(ps, es, ")"))
     7a0:	00001617          	auipc	a2,0x1
     7a4:	ba860613          	addi	a2,a2,-1112 # 1348 <malloc+0x1c4>
     7a8:	85ca                	mv	a1,s2
     7aa:	8526                	mv	a0,s1
     7ac:	c9dff0ef          	jal	448 <peek>
     7b0:	c90d                	beqz	a0,7e2 <parseblock+0x78>
  gettoken(ps, es, 0, 0);
     7b2:	4681                	li	a3,0
     7b4:	4601                	li	a2,0
     7b6:	85ca                	mv	a1,s2
     7b8:	8526                	mv	a0,s1
     7ba:	b57ff0ef          	jal	310 <gettoken>
  cmd = parseredirs(cmd, ps, es);
     7be:	864a                	mv	a2,s2
     7c0:	85a6                	mv	a1,s1
     7c2:	854e                	mv	a0,s3
     7c4:	ce9ff0ef          	jal	4ac <parseredirs>
}
     7c8:	70a2                	ld	ra,40(sp)
     7ca:	7402                	ld	s0,32(sp)
     7cc:	64e2                	ld	s1,24(sp)
     7ce:	6942                	ld	s2,16(sp)
     7d0:	69a2                	ld	s3,8(sp)
     7d2:	6145                	addi	sp,sp,48
     7d4:	8082                	ret
    panic("parseblock");
     7d6:	00001517          	auipc	a0,0x1
     7da:	b6250513          	addi	a0,a0,-1182 # 1338 <malloc+0x1b4>
     7de:	86dff0ef          	jal	4a <panic>
    panic("syntax - missing )");
     7e2:	00001517          	auipc	a0,0x1
     7e6:	b6e50513          	addi	a0,a0,-1170 # 1350 <malloc+0x1cc>
     7ea:	861ff0ef          	jal	4a <panic>

00000000000007ee <nulterminate>:

// NUL-terminate all the counted strings.
struct cmd*
nulterminate(struct cmd *cmd)
{
     7ee:	1101                	addi	sp,sp,-32
     7f0:	ec06                	sd	ra,24(sp)
     7f2:	e822                	sd	s0,16(sp)
     7f4:	e426                	sd	s1,8(sp)
     7f6:	1000                	addi	s0,sp,32
     7f8:	84aa                	mv	s1,a0
  struct execcmd *ecmd;
  struct listcmd *lcmd;
  struct pipecmd *pcmd;
  struct redircmd *rcmd;

  if(cmd == 0)
     7fa:	c131                	beqz	a0,83e <nulterminate+0x50>
    return 0;

  switch(cmd->type){
     7fc:	4118                	lw	a4,0(a0)
     7fe:	4795                	li	a5,5
     800:	02e7ef63          	bltu	a5,a4,83e <nulterminate+0x50>
     804:	00056783          	lwu	a5,0(a0)
     808:	078a                	slli	a5,a5,0x2
     80a:	00001717          	auipc	a4,0x1
     80e:	ba670713          	addi	a4,a4,-1114 # 13b0 <malloc+0x22c>
     812:	97ba                	add	a5,a5,a4
     814:	439c                	lw	a5,0(a5)
     816:	97ba                	add	a5,a5,a4
     818:	8782                	jr	a5
  case EXEC:
    ecmd = (struct execcmd*)cmd;
    for(i=0; ecmd->argv[i]; i++)
     81a:	651c                	ld	a5,8(a0)
     81c:	c38d                	beqz	a5,83e <nulterminate+0x50>
     81e:	01050793          	addi	a5,a0,16
      *ecmd->eargv[i] = 0;
     822:	67b8                	ld	a4,72(a5)
     824:	00070023          	sb	zero,0(a4)
    for(i=0; ecmd->argv[i]; i++)
     828:	07a1                	addi	a5,a5,8
     82a:	ff87b703          	ld	a4,-8(a5)
     82e:	fb75                	bnez	a4,822 <nulterminate+0x34>
     830:	a039                	j	83e <nulterminate+0x50>
    break;

  case REDIR:
    rcmd = (struct redircmd*)cmd;
    nulterminate(rcmd->cmd);
     832:	6508                	ld	a0,8(a0)
     834:	fbbff0ef          	jal	7ee <nulterminate>
    *rcmd->efile = 0;
     838:	6c9c                	ld	a5,24(s1)
     83a:	00078023          	sb	zero,0(a5)
    bcmd = (struct backcmd*)cmd;
    nulterminate(bcmd->cmd);
    break;
  }
  return cmd;
}
     83e:	8526                	mv	a0,s1
     840:	60e2                	ld	ra,24(sp)
     842:	6442                	ld	s0,16(sp)
     844:	64a2                	ld	s1,8(sp)
     846:	6105                	addi	sp,sp,32
     848:	8082                	ret
    nulterminate(pcmd->left);
     84a:	6508                	ld	a0,8(a0)
     84c:	fa3ff0ef          	jal	7ee <nulterminate>
    nulterminate(pcmd->right);
     850:	6888                	ld	a0,16(s1)
     852:	f9dff0ef          	jal	7ee <nulterminate>
    break;
     856:	b7e5                	j	83e <nulterminate+0x50>
    nulterminate(lcmd->left);
     858:	6508                	ld	a0,8(a0)
     85a:	f95ff0ef          	jal	7ee <nulterminate>
    nulterminate(lcmd->right);
     85e:	6888                	ld	a0,16(s1)
     860:	f8fff0ef          	jal	7ee <nulterminate>
    break;
     864:	bfe9                	j	83e <nulterminate+0x50>
    nulterminate(bcmd->cmd);
     866:	6508                	ld	a0,8(a0)
     868:	f87ff0ef          	jal	7ee <nulterminate>
    break;
     86c:	bfc9                	j	83e <nulterminate+0x50>

000000000000086e <parsecmd>:
{
     86e:	7139                	addi	sp,sp,-64
     870:	fc06                	sd	ra,56(sp)
     872:	f822                	sd	s0,48(sp)
     874:	f426                	sd	s1,40(sp)
     876:	f04a                	sd	s2,32(sp)
     878:	ec4e                	sd	s3,24(sp)
     87a:	0080                	addi	s0,sp,64
     87c:	fca43423          	sd	a0,-56(s0)
  es = s + strlen(s);
     880:	84aa                	mv	s1,a0
     882:	1ae000ef          	jal	a30 <strlen>
     886:	1502                	slli	a0,a0,0x20
     888:	9101                	srli	a0,a0,0x20
     88a:	94aa                	add	s1,s1,a0
  cmd = parseline(&s, es);
     88c:	fc840913          	addi	s2,s0,-56
     890:	85a6                	mv	a1,s1
     892:	854a                	mv	a0,s2
     894:	e4fff0ef          	jal	6e2 <parseline>
     898:	89aa                	mv	s3,a0
  peek(&s, es, "");
     89a:	00001617          	auipc	a2,0x1
     89e:	9ee60613          	addi	a2,a2,-1554 # 1288 <malloc+0x104>
     8a2:	85a6                	mv	a1,s1
     8a4:	854a                	mv	a0,s2
     8a6:	ba3ff0ef          	jal	448 <peek>
  if(s != es){
     8aa:	fc843603          	ld	a2,-56(s0)
     8ae:	00961d63          	bne	a2,s1,8c8 <parsecmd+0x5a>
  nulterminate(cmd);
     8b2:	854e                	mv	a0,s3
     8b4:	f3bff0ef          	jal	7ee <nulterminate>
}
     8b8:	854e                	mv	a0,s3
     8ba:	70e2                	ld	ra,56(sp)
     8bc:	7442                	ld	s0,48(sp)
     8be:	74a2                	ld	s1,40(sp)
     8c0:	7902                	ld	s2,32(sp)
     8c2:	69e2                	ld	s3,24(sp)
     8c4:	6121                	addi	sp,sp,64
     8c6:	8082                	ret
    fprintf(2, "leftovers: %s\n", s);
     8c8:	00001597          	auipc	a1,0x1
     8cc:	aa058593          	addi	a1,a1,-1376 # 1368 <malloc+0x1e4>
     8d0:	4509                	li	a0,2
     8d2:	7d0000ef          	jal	10a2 <fprintf>
    panic("syntax");
     8d6:	00001517          	auipc	a0,0x1
     8da:	a2a50513          	addi	a0,a0,-1494 # 1300 <malloc+0x17c>
     8de:	f6cff0ef          	jal	4a <panic>

00000000000008e2 <main>:
{
     8e2:	7139                	addi	sp,sp,-64
     8e4:	fc06                	sd	ra,56(sp)
     8e6:	f822                	sd	s0,48(sp)
     8e8:	f426                	sd	s1,40(sp)
     8ea:	f04a                	sd	s2,32(sp)
     8ec:	ec4e                	sd	s3,24(sp)
     8ee:	e852                	sd	s4,16(sp)
     8f0:	e456                	sd	s5,8(sp)
     8f2:	e05a                	sd	s6,0(sp)
     8f4:	0080                	addi	s0,sp,64
  while((fd = open("console", O_RDWR)) >= 0){
     8f6:	4489                	li	s1,2
     8f8:	00001917          	auipc	s2,0x1
     8fc:	a8090913          	addi	s2,s2,-1408 # 1378 <malloc+0x1f4>
     900:	85a6                	mv	a1,s1
     902:	854a                	mv	a0,s2
     904:	3c2000ef          	jal	cc6 <open>
     908:	00054663          	bltz	a0,914 <main+0x32>
    if(fd >= 3){
     90c:	fea4dae3          	bge	s1,a0,900 <main+0x1e>
      close(fd);
     910:	39e000ef          	jal	cae <close>
  while(getcmd(buf, sizeof(buf)) >= 0){
     914:	06400993          	li	s3,100
     918:	00001917          	auipc	s2,0x1
     91c:	70890913          	addi	s2,s2,1800 # 2020 <buf.0>
    if (*cmd == '\n') // is a blank command
     920:	4a29                	li	s4,10
    if(cmd[0] == 'c' && cmd[1] == 'd' && cmd[2] == ' '){
     922:	06300a93          	li	s5,99
     926:	02000b13          	li	s6,32
     92a:	a039                	j	938 <main+0x56>
      if(fork1() == 0)
     92c:	f3cff0ef          	jal	68 <fork1>
     930:	c941                	beqz	a0,9c0 <main+0xde>
      wait(0);
     932:	4501                	li	a0,0
     934:	35a000ef          	jal	c8e <wait>
  while(getcmd(buf, sizeof(buf)) >= 0){
     938:	85ce                	mv	a1,s3
     93a:	854a                	mv	a0,s2
     93c:	ec4ff0ef          	jal	0 <getcmd>
     940:	08054563          	bltz	a0,9ca <main+0xe8>
    while (*cmd == ' ' || *cmd == '\t')
     944:	00094783          	lbu	a5,0(s2)
     948:	fe078713          	addi	a4,a5,-32
     94c:	cb01                	beqz	a4,95c <main+0x7a>
     94e:	ff778713          	addi	a4,a5,-9
    char *cmd = buf;
     952:	00001497          	auipc	s1,0x1
     956:	6ce48493          	addi	s1,s1,1742 # 2020 <buf.0>
    while (*cmd == ' ' || *cmd == '\t')
     95a:	ef11                	bnez	a4,976 <main+0x94>
    char *cmd = buf;
     95c:	00001497          	auipc	s1,0x1
     960:	6c448493          	addi	s1,s1,1732 # 2020 <buf.0>
      cmd++;
     964:	0485                	addi	s1,s1,1
    while (*cmd == ' ' || *cmd == '\t')
     966:	0004c783          	lbu	a5,0(s1)
     96a:	fe078713          	addi	a4,a5,-32
     96e:	db7d                	beqz	a4,964 <main+0x82>
     970:	ff778713          	addi	a4,a5,-9
     974:	db65                	beqz	a4,964 <main+0x82>
    if (*cmd == '\n') // is a blank command
     976:	fd4781e3          	beq	a5,s4,938 <main+0x56>
    if(cmd[0] == 'c' && cmd[1] == 'd' && cmd[2] == ' '){
     97a:	fb5799e3          	bne	a5,s5,92c <main+0x4a>
     97e:	0014c783          	lbu	a5,1(s1)
     982:	fb3795e3          	bne	a5,s3,92c <main+0x4a>
     986:	0024c783          	lbu	a5,2(s1)
     98a:	fb6791e3          	bne	a5,s6,92c <main+0x4a>
      cmd[strlen(cmd)-1] = 0;  // chop \n
     98e:	8526                	mv	a0,s1
     990:	0a0000ef          	jal	a30 <strlen>
     994:	fff5079b          	addiw	a5,a0,-1
     998:	1782                	slli	a5,a5,0x20
     99a:	9381                	srli	a5,a5,0x20
     99c:	97a6                	add	a5,a5,s1
     99e:	00078023          	sb	zero,0(a5)
      if(chdir(cmd+3) < 0)
     9a2:	048d                	addi	s1,s1,3
     9a4:	8526                	mv	a0,s1
     9a6:	350000ef          	jal	cf6 <chdir>
     9aa:	f80557e3          	bgez	a0,938 <main+0x56>
        fprintf(2, "cannot cd %s\n", cmd+3);
     9ae:	8626                	mv	a2,s1
     9b0:	00001597          	auipc	a1,0x1
     9b4:	9d058593          	addi	a1,a1,-1584 # 1380 <malloc+0x1fc>
     9b8:	4509                	li	a0,2
     9ba:	6e8000ef          	jal	10a2 <fprintf>
     9be:	bfad                	j	938 <main+0x56>
        runcmd(parsecmd(cmd));
     9c0:	8526                	mv	a0,s1
     9c2:	eadff0ef          	jal	86e <parsecmd>
     9c6:	ec8ff0ef          	jal	8e <runcmd>
  exit(0);
     9ca:	4501                	li	a0,0
     9cc:	2ba000ef          	jal	c86 <exit>

00000000000009d0 <start>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
start(int argc, char **argv)
{
     9d0:	1141                	addi	sp,sp,-16
     9d2:	e406                	sd	ra,8(sp)
     9d4:	e022                	sd	s0,0(sp)
     9d6:	0800                	addi	s0,sp,16
  int r;
  extern int main(int argc, char **argv);
  r = main(argc, argv);
     9d8:	f0bff0ef          	jal	8e2 <main>
  exit(r);
     9dc:	2aa000ef          	jal	c86 <exit>

00000000000009e0 <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
     9e0:	1141                	addi	sp,sp,-16
     9e2:	e406                	sd	ra,8(sp)
     9e4:	e022                	sd	s0,0(sp)
     9e6:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
     9e8:	87aa                	mv	a5,a0
     9ea:	0585                	addi	a1,a1,1
     9ec:	0785                	addi	a5,a5,1
     9ee:	fff5c703          	lbu	a4,-1(a1)
     9f2:	fee78fa3          	sb	a4,-1(a5)
     9f6:	fb75                	bnez	a4,9ea <strcpy+0xa>
    ;
  return os;
}
     9f8:	60a2                	ld	ra,8(sp)
     9fa:	6402                	ld	s0,0(sp)
     9fc:	0141                	addi	sp,sp,16
     9fe:	8082                	ret

0000000000000a00 <strcmp>:

int
strcmp(const char *p, const char *q)
{
     a00:	1141                	addi	sp,sp,-16
     a02:	e406                	sd	ra,8(sp)
     a04:	e022                	sd	s0,0(sp)
     a06:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
     a08:	00054783          	lbu	a5,0(a0)
     a0c:	cb91                	beqz	a5,a20 <strcmp+0x20>
     a0e:	0005c703          	lbu	a4,0(a1)
     a12:	00f71763          	bne	a4,a5,a20 <strcmp+0x20>
    p++, q++;
     a16:	0505                	addi	a0,a0,1
     a18:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
     a1a:	00054783          	lbu	a5,0(a0)
     a1e:	fbe5                	bnez	a5,a0e <strcmp+0xe>
  return (uchar)*p - (uchar)*q;
     a20:	0005c503          	lbu	a0,0(a1)
}
     a24:	40a7853b          	subw	a0,a5,a0
     a28:	60a2                	ld	ra,8(sp)
     a2a:	6402                	ld	s0,0(sp)
     a2c:	0141                	addi	sp,sp,16
     a2e:	8082                	ret

0000000000000a30 <strlen>:

uint
strlen(const char *s)
{
     a30:	1141                	addi	sp,sp,-16
     a32:	e406                	sd	ra,8(sp)
     a34:	e022                	sd	s0,0(sp)
     a36:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
     a38:	00054783          	lbu	a5,0(a0)
     a3c:	cf91                	beqz	a5,a58 <strlen+0x28>
     a3e:	00150793          	addi	a5,a0,1
     a42:	86be                	mv	a3,a5
     a44:	0785                	addi	a5,a5,1
     a46:	fff7c703          	lbu	a4,-1(a5)
     a4a:	ff65                	bnez	a4,a42 <strlen+0x12>
     a4c:	40a6853b          	subw	a0,a3,a0
    ;
  return n;
}
     a50:	60a2                	ld	ra,8(sp)
     a52:	6402                	ld	s0,0(sp)
     a54:	0141                	addi	sp,sp,16
     a56:	8082                	ret
  for(n = 0; s[n]; n++)
     a58:	4501                	li	a0,0
     a5a:	bfdd                	j	a50 <strlen+0x20>

0000000000000a5c <memset>:

void*
memset(void *dst, int c, uint n)
{
     a5c:	1141                	addi	sp,sp,-16
     a5e:	e406                	sd	ra,8(sp)
     a60:	e022                	sd	s0,0(sp)
     a62:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
     a64:	ca19                	beqz	a2,a7a <memset+0x1e>
     a66:	87aa                	mv	a5,a0
     a68:	1602                	slli	a2,a2,0x20
     a6a:	9201                	srli	a2,a2,0x20
     a6c:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
     a70:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
     a74:	0785                	addi	a5,a5,1
     a76:	fee79de3          	bne	a5,a4,a70 <memset+0x14>
  }
  return dst;
}
     a7a:	60a2                	ld	ra,8(sp)
     a7c:	6402                	ld	s0,0(sp)
     a7e:	0141                	addi	sp,sp,16
     a80:	8082                	ret

0000000000000a82 <strchr>:

char*
strchr(const char *s, char c)
{
     a82:	1141                	addi	sp,sp,-16
     a84:	e406                	sd	ra,8(sp)
     a86:	e022                	sd	s0,0(sp)
     a88:	0800                	addi	s0,sp,16
  for(; *s; s++)
     a8a:	00054783          	lbu	a5,0(a0)
     a8e:	cf81                	beqz	a5,aa6 <strchr+0x24>
    if(*s == c)
     a90:	00f58763          	beq	a1,a5,a9e <strchr+0x1c>
  for(; *s; s++)
     a94:	0505                	addi	a0,a0,1
     a96:	00054783          	lbu	a5,0(a0)
     a9a:	fbfd                	bnez	a5,a90 <strchr+0xe>
      return (char*)s;
  return 0;
     a9c:	4501                	li	a0,0
}
     a9e:	60a2                	ld	ra,8(sp)
     aa0:	6402                	ld	s0,0(sp)
     aa2:	0141                	addi	sp,sp,16
     aa4:	8082                	ret
  return 0;
     aa6:	4501                	li	a0,0
     aa8:	bfdd                	j	a9e <strchr+0x1c>

0000000000000aaa <gets>:

char*
gets(char *buf, int max)
{
     aaa:	711d                	addi	sp,sp,-96
     aac:	ec86                	sd	ra,88(sp)
     aae:	e8a2                	sd	s0,80(sp)
     ab0:	e4a6                	sd	s1,72(sp)
     ab2:	e0ca                	sd	s2,64(sp)
     ab4:	fc4e                	sd	s3,56(sp)
     ab6:	f852                	sd	s4,48(sp)
     ab8:	f456                	sd	s5,40(sp)
     aba:	f05a                	sd	s6,32(sp)
     abc:	ec5e                	sd	s7,24(sp)
     abe:	e862                	sd	s8,16(sp)
     ac0:	1080                	addi	s0,sp,96
     ac2:	8baa                	mv	s7,a0
     ac4:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
     ac6:	892a                	mv	s2,a0
     ac8:	4481                	li	s1,0
    cc = read(0, &c, 1);
     aca:	faf40b13          	addi	s6,s0,-81
     ace:	4a85                	li	s5,1
  for(i=0; i+1 < max; ){
     ad0:	8c26                	mv	s8,s1
     ad2:	0014899b          	addiw	s3,s1,1
     ad6:	84ce                	mv	s1,s3
     ad8:	0349d463          	bge	s3,s4,b00 <gets+0x56>
    cc = read(0, &c, 1);
     adc:	8656                	mv	a2,s5
     ade:	85da                	mv	a1,s6
     ae0:	4501                	li	a0,0
     ae2:	1bc000ef          	jal	c9e <read>
    if(cc < 1)
     ae6:	00a05d63          	blez	a0,b00 <gets+0x56>
      break;
    buf[i++] = c;
     aea:	faf44783          	lbu	a5,-81(s0)
     aee:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
     af2:	0905                	addi	s2,s2,1
     af4:	ff678713          	addi	a4,a5,-10
     af8:	c319                	beqz	a4,afe <gets+0x54>
     afa:	17cd                	addi	a5,a5,-13
     afc:	fbf1                	bnez	a5,ad0 <gets+0x26>
    buf[i++] = c;
     afe:	8c4e                	mv	s8,s3
      break;
  }
  buf[i] = '\0';
     b00:	9c5e                	add	s8,s8,s7
     b02:	000c0023          	sb	zero,0(s8)
  return buf;
}
     b06:	855e                	mv	a0,s7
     b08:	60e6                	ld	ra,88(sp)
     b0a:	6446                	ld	s0,80(sp)
     b0c:	64a6                	ld	s1,72(sp)
     b0e:	6906                	ld	s2,64(sp)
     b10:	79e2                	ld	s3,56(sp)
     b12:	7a42                	ld	s4,48(sp)
     b14:	7aa2                	ld	s5,40(sp)
     b16:	7b02                	ld	s6,32(sp)
     b18:	6be2                	ld	s7,24(sp)
     b1a:	6c42                	ld	s8,16(sp)
     b1c:	6125                	addi	sp,sp,96
     b1e:	8082                	ret

0000000000000b20 <stat>:

int
stat(const char *n, struct stat *st)
{
     b20:	1101                	addi	sp,sp,-32
     b22:	ec06                	sd	ra,24(sp)
     b24:	e822                	sd	s0,16(sp)
     b26:	e04a                	sd	s2,0(sp)
     b28:	1000                	addi	s0,sp,32
     b2a:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
     b2c:	4581                	li	a1,0
     b2e:	198000ef          	jal	cc6 <open>
  if(fd < 0)
     b32:	02054263          	bltz	a0,b56 <stat+0x36>
     b36:	e426                	sd	s1,8(sp)
     b38:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
     b3a:	85ca                	mv	a1,s2
     b3c:	1a2000ef          	jal	cde <fstat>
     b40:	892a                	mv	s2,a0
  close(fd);
     b42:	8526                	mv	a0,s1
     b44:	16a000ef          	jal	cae <close>
  return r;
     b48:	64a2                	ld	s1,8(sp)
}
     b4a:	854a                	mv	a0,s2
     b4c:	60e2                	ld	ra,24(sp)
     b4e:	6442                	ld	s0,16(sp)
     b50:	6902                	ld	s2,0(sp)
     b52:	6105                	addi	sp,sp,32
     b54:	8082                	ret
    return -1;
     b56:	57fd                	li	a5,-1
     b58:	893e                	mv	s2,a5
     b5a:	bfc5                	j	b4a <stat+0x2a>

0000000000000b5c <atoi>:

int
atoi(const char *s)
{
     b5c:	1141                	addi	sp,sp,-16
     b5e:	e406                	sd	ra,8(sp)
     b60:	e022                	sd	s0,0(sp)
     b62:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
     b64:	00054683          	lbu	a3,0(a0)
     b68:	fd06879b          	addiw	a5,a3,-48
     b6c:	0ff7f793          	zext.b	a5,a5
     b70:	4625                	li	a2,9
     b72:	02f66963          	bltu	a2,a5,ba4 <atoi+0x48>
     b76:	872a                	mv	a4,a0
  n = 0;
     b78:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
     b7a:	0705                	addi	a4,a4,1
     b7c:	0025179b          	slliw	a5,a0,0x2
     b80:	9fa9                	addw	a5,a5,a0
     b82:	0017979b          	slliw	a5,a5,0x1
     b86:	9fb5                	addw	a5,a5,a3
     b88:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
     b8c:	00074683          	lbu	a3,0(a4)
     b90:	fd06879b          	addiw	a5,a3,-48
     b94:	0ff7f793          	zext.b	a5,a5
     b98:	fef671e3          	bgeu	a2,a5,b7a <atoi+0x1e>
  return n;
}
     b9c:	60a2                	ld	ra,8(sp)
     b9e:	6402                	ld	s0,0(sp)
     ba0:	0141                	addi	sp,sp,16
     ba2:	8082                	ret
  n = 0;
     ba4:	4501                	li	a0,0
     ba6:	bfdd                	j	b9c <atoi+0x40>

0000000000000ba8 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
     ba8:	1141                	addi	sp,sp,-16
     baa:	e406                	sd	ra,8(sp)
     bac:	e022                	sd	s0,0(sp)
     bae:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
     bb0:	02b57563          	bgeu	a0,a1,bda <memmove+0x32>
    while(n-- > 0)
     bb4:	00c05f63          	blez	a2,bd2 <memmove+0x2a>
     bb8:	1602                	slli	a2,a2,0x20
     bba:	9201                	srli	a2,a2,0x20
     bbc:	00c507b3          	add	a5,a0,a2
  dst = vdst;
     bc0:	872a                	mv	a4,a0
      *dst++ = *src++;
     bc2:	0585                	addi	a1,a1,1
     bc4:	0705                	addi	a4,a4,1
     bc6:	fff5c683          	lbu	a3,-1(a1)
     bca:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
     bce:	fee79ae3          	bne	a5,a4,bc2 <memmove+0x1a>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
     bd2:	60a2                	ld	ra,8(sp)
     bd4:	6402                	ld	s0,0(sp)
     bd6:	0141                	addi	sp,sp,16
     bd8:	8082                	ret
    while(n-- > 0)
     bda:	fec05ce3          	blez	a2,bd2 <memmove+0x2a>
    dst += n;
     bde:	00c50733          	add	a4,a0,a2
    src += n;
     be2:	95b2                	add	a1,a1,a2
     be4:	fff6079b          	addiw	a5,a2,-1
     be8:	1782                	slli	a5,a5,0x20
     bea:	9381                	srli	a5,a5,0x20
     bec:	fff7c793          	not	a5,a5
     bf0:	97ba                	add	a5,a5,a4
      *--dst = *--src;
     bf2:	15fd                	addi	a1,a1,-1
     bf4:	177d                	addi	a4,a4,-1
     bf6:	0005c683          	lbu	a3,0(a1)
     bfa:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
     bfe:	fef71ae3          	bne	a4,a5,bf2 <memmove+0x4a>
     c02:	bfc1                	j	bd2 <memmove+0x2a>

0000000000000c04 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
     c04:	1141                	addi	sp,sp,-16
     c06:	e406                	sd	ra,8(sp)
     c08:	e022                	sd	s0,0(sp)
     c0a:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
     c0c:	c61d                	beqz	a2,c3a <memcmp+0x36>
     c0e:	1602                	slli	a2,a2,0x20
     c10:	9201                	srli	a2,a2,0x20
     c12:	00c506b3          	add	a3,a0,a2
    if (*p1 != *p2) {
     c16:	00054783          	lbu	a5,0(a0)
     c1a:	0005c703          	lbu	a4,0(a1)
     c1e:	00e79863          	bne	a5,a4,c2e <memcmp+0x2a>
      return *p1 - *p2;
    }
    p1++;
     c22:	0505                	addi	a0,a0,1
    p2++;
     c24:	0585                	addi	a1,a1,1
  while (n-- > 0) {
     c26:	fed518e3          	bne	a0,a3,c16 <memcmp+0x12>
  }
  return 0;
     c2a:	4501                	li	a0,0
     c2c:	a019                	j	c32 <memcmp+0x2e>
      return *p1 - *p2;
     c2e:	40e7853b          	subw	a0,a5,a4
}
     c32:	60a2                	ld	ra,8(sp)
     c34:	6402                	ld	s0,0(sp)
     c36:	0141                	addi	sp,sp,16
     c38:	8082                	ret
  return 0;
     c3a:	4501                	li	a0,0
     c3c:	bfdd                	j	c32 <memcmp+0x2e>

0000000000000c3e <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
     c3e:	1141                	addi	sp,sp,-16
     c40:	e406                	sd	ra,8(sp)
     c42:	e022                	sd	s0,0(sp)
     c44:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
     c46:	f63ff0ef          	jal	ba8 <memmove>
}
     c4a:	60a2                	ld	ra,8(sp)
     c4c:	6402                	ld	s0,0(sp)
     c4e:	0141                	addi	sp,sp,16
     c50:	8082                	ret

0000000000000c52 <sbrk>:

char *
sbrk(int n) {
     c52:	1141                	addi	sp,sp,-16
     c54:	e406                	sd	ra,8(sp)
     c56:	e022                	sd	s0,0(sp)
     c58:	0800                	addi	s0,sp,16
  return sys_sbrk(n, SBRK_EAGER);
     c5a:	4585                	li	a1,1
     c5c:	0b2000ef          	jal	d0e <sys_sbrk>
}
     c60:	60a2                	ld	ra,8(sp)
     c62:	6402                	ld	s0,0(sp)
     c64:	0141                	addi	sp,sp,16
     c66:	8082                	ret

0000000000000c68 <sbrklazy>:

char *
sbrklazy(int n) {
     c68:	1141                	addi	sp,sp,-16
     c6a:	e406                	sd	ra,8(sp)
     c6c:	e022                	sd	s0,0(sp)
     c6e:	0800                	addi	s0,sp,16
  return sys_sbrk(n, SBRK_LAZY);
     c70:	4589                	li	a1,2
     c72:	09c000ef          	jal	d0e <sys_sbrk>
}
     c76:	60a2                	ld	ra,8(sp)
     c78:	6402                	ld	s0,0(sp)
     c7a:	0141                	addi	sp,sp,16
     c7c:	8082                	ret

0000000000000c7e <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
     c7e:	4885                	li	a7,1
 ecall
     c80:	00000073          	ecall
 ret
     c84:	8082                	ret

0000000000000c86 <exit>:
.global exit
exit:
 li a7, SYS_exit
     c86:	4889                	li	a7,2
 ecall
     c88:	00000073          	ecall
 ret
     c8c:	8082                	ret

0000000000000c8e <wait>:
.global wait
wait:
 li a7, SYS_wait
     c8e:	488d                	li	a7,3
 ecall
     c90:	00000073          	ecall
 ret
     c94:	8082                	ret

0000000000000c96 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
     c96:	4891                	li	a7,4
 ecall
     c98:	00000073          	ecall
 ret
     c9c:	8082                	ret

0000000000000c9e <read>:
.global read
read:
 li a7, SYS_read
     c9e:	4895                	li	a7,5
 ecall
     ca0:	00000073          	ecall
 ret
     ca4:	8082                	ret

0000000000000ca6 <write>:
.global write
write:
 li a7, SYS_write
     ca6:	48c1                	li	a7,16
 ecall
     ca8:	00000073          	ecall
 ret
     cac:	8082                	ret

0000000000000cae <close>:
.global close
close:
 li a7, SYS_close
     cae:	48d5                	li	a7,21
 ecall
     cb0:	00000073          	ecall
 ret
     cb4:	8082                	ret

0000000000000cb6 <kill>:
.global kill
kill:
 li a7, SYS_kill
     cb6:	4899                	li	a7,6
 ecall
     cb8:	00000073          	ecall
 ret
     cbc:	8082                	ret

0000000000000cbe <exec>:
.global exec
exec:
 li a7, SYS_exec
     cbe:	489d                	li	a7,7
 ecall
     cc0:	00000073          	ecall
 ret
     cc4:	8082                	ret

0000000000000cc6 <open>:
.global open
open:
 li a7, SYS_open
     cc6:	48bd                	li	a7,15
 ecall
     cc8:	00000073          	ecall
 ret
     ccc:	8082                	ret

0000000000000cce <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
     cce:	48c5                	li	a7,17
 ecall
     cd0:	00000073          	ecall
 ret
     cd4:	8082                	ret

0000000000000cd6 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
     cd6:	48c9                	li	a7,18
 ecall
     cd8:	00000073          	ecall
 ret
     cdc:	8082                	ret

0000000000000cde <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
     cde:	48a1                	li	a7,8
 ecall
     ce0:	00000073          	ecall
 ret
     ce4:	8082                	ret

0000000000000ce6 <link>:
.global link
link:
 li a7, SYS_link
     ce6:	48cd                	li	a7,19
 ecall
     ce8:	00000073          	ecall
 ret
     cec:	8082                	ret

0000000000000cee <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
     cee:	48d1                	li	a7,20
 ecall
     cf0:	00000073          	ecall
 ret
     cf4:	8082                	ret

0000000000000cf6 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
     cf6:	48a5                	li	a7,9
 ecall
     cf8:	00000073          	ecall
 ret
     cfc:	8082                	ret

0000000000000cfe <dup>:
.global dup
dup:
 li a7, SYS_dup
     cfe:	48a9                	li	a7,10
 ecall
     d00:	00000073          	ecall
 ret
     d04:	8082                	ret

0000000000000d06 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
     d06:	48ad                	li	a7,11
 ecall
     d08:	00000073          	ecall
 ret
     d0c:	8082                	ret

0000000000000d0e <sys_sbrk>:
.global sys_sbrk
sys_sbrk:
 li a7, SYS_sbrk
     d0e:	48b1                	li	a7,12
 ecall
     d10:	00000073          	ecall
 ret
     d14:	8082                	ret

0000000000000d16 <pause>:
.global pause
pause:
 li a7, SYS_pause
     d16:	48b5                	li	a7,13
 ecall
     d18:	00000073          	ecall
 ret
     d1c:	8082                	ret

0000000000000d1e <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
     d1e:	48b9                	li	a7,14
 ecall
     d20:	00000073          	ecall
 ret
     d24:	8082                	ret

0000000000000d26 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
     d26:	1101                	addi	sp,sp,-32
     d28:	ec06                	sd	ra,24(sp)
     d2a:	e822                	sd	s0,16(sp)
     d2c:	1000                	addi	s0,sp,32
     d2e:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
     d32:	4605                	li	a2,1
     d34:	fef40593          	addi	a1,s0,-17
     d38:	f6fff0ef          	jal	ca6 <write>
}
     d3c:	60e2                	ld	ra,24(sp)
     d3e:	6442                	ld	s0,16(sp)
     d40:	6105                	addi	sp,sp,32
     d42:	8082                	ret

0000000000000d44 <printint>:

static void
printint(int fd, long long xx, int base, int sgn)
{
     d44:	715d                	addi	sp,sp,-80
     d46:	e486                	sd	ra,72(sp)
     d48:	e0a2                	sd	s0,64(sp)
     d4a:	f84a                	sd	s2,48(sp)
     d4c:	f44e                	sd	s3,40(sp)
     d4e:	0880                	addi	s0,sp,80
     d50:	892a                	mv	s2,a0
  char buf[20];
  int i, neg;
  unsigned long long x;

  neg = 0;
  if(sgn && xx < 0){
     d52:	c6d1                	beqz	a3,dde <printint+0x9a>
     d54:	0805d563          	bgez	a1,dde <printint+0x9a>
    neg = 1;
    x = -xx;
     d58:	40b005b3          	neg	a1,a1
    neg = 1;
     d5c:	4305                	li	t1,1
  } else {
    x = xx;
  }

  i = 0;
     d5e:	fb840993          	addi	s3,s0,-72
  neg = 0;
     d62:	86ce                	mv	a3,s3
  i = 0;
     d64:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
     d66:	00000817          	auipc	a6,0x0
     d6a:	66280813          	addi	a6,a6,1634 # 13c8 <digits>
     d6e:	88ba                	mv	a7,a4
     d70:	0017051b          	addiw	a0,a4,1
     d74:	872a                	mv	a4,a0
     d76:	02c5f7b3          	remu	a5,a1,a2
     d7a:	97c2                	add	a5,a5,a6
     d7c:	0007c783          	lbu	a5,0(a5)
     d80:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
     d84:	87ae                	mv	a5,a1
     d86:	02c5d5b3          	divu	a1,a1,a2
     d8a:	0685                	addi	a3,a3,1
     d8c:	fec7f1e3          	bgeu	a5,a2,d6e <printint+0x2a>
  if(neg)
     d90:	00030c63          	beqz	t1,da8 <printint+0x64>
    buf[i++] = '-';
     d94:	fd050793          	addi	a5,a0,-48
     d98:	00878533          	add	a0,a5,s0
     d9c:	02d00793          	li	a5,45
     da0:	fef50423          	sb	a5,-24(a0)
     da4:	0028871b          	addiw	a4,a7,2

  while(--i >= 0)
     da8:	02e05563          	blez	a4,dd2 <printint+0x8e>
     dac:	fc26                	sd	s1,56(sp)
     dae:	377d                	addiw	a4,a4,-1
     db0:	00e984b3          	add	s1,s3,a4
     db4:	19fd                	addi	s3,s3,-1
     db6:	99ba                	add	s3,s3,a4
     db8:	1702                	slli	a4,a4,0x20
     dba:	9301                	srli	a4,a4,0x20
     dbc:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
     dc0:	0004c583          	lbu	a1,0(s1)
     dc4:	854a                	mv	a0,s2
     dc6:	f61ff0ef          	jal	d26 <putc>
  while(--i >= 0)
     dca:	14fd                	addi	s1,s1,-1
     dcc:	ff349ae3          	bne	s1,s3,dc0 <printint+0x7c>
     dd0:	74e2                	ld	s1,56(sp)
}
     dd2:	60a6                	ld	ra,72(sp)
     dd4:	6406                	ld	s0,64(sp)
     dd6:	7942                	ld	s2,48(sp)
     dd8:	79a2                	ld	s3,40(sp)
     dda:	6161                	addi	sp,sp,80
     ddc:	8082                	ret
  neg = 0;
     dde:	4301                	li	t1,0
     de0:	bfbd                	j	d5e <printint+0x1a>

0000000000000de2 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %c, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
     de2:	711d                	addi	sp,sp,-96
     de4:	ec86                	sd	ra,88(sp)
     de6:	e8a2                	sd	s0,80(sp)
     de8:	e4a6                	sd	s1,72(sp)
     dea:	1080                	addi	s0,sp,96
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
     dec:	0005c483          	lbu	s1,0(a1)
     df0:	22048363          	beqz	s1,1016 <vprintf+0x234>
     df4:	e0ca                	sd	s2,64(sp)
     df6:	fc4e                	sd	s3,56(sp)
     df8:	f852                	sd	s4,48(sp)
     dfa:	f456                	sd	s5,40(sp)
     dfc:	f05a                	sd	s6,32(sp)
     dfe:	ec5e                	sd	s7,24(sp)
     e00:	e862                	sd	s8,16(sp)
     e02:	8b2a                	mv	s6,a0
     e04:	8a2e                	mv	s4,a1
     e06:	8bb2                	mv	s7,a2
  state = 0;
     e08:	4981                	li	s3,0
  for(i = 0; fmt[i]; i++){
     e0a:	4901                	li	s2,0
     e0c:	4701                	li	a4,0
      if(c0 == '%'){
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if(state == '%'){
     e0e:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if(c0) c1 = fmt[i+1] & 0xff;
      if(c1) c2 = fmt[i+2] & 0xff;
      if(c0 == 'd'){
     e12:	06400c13          	li	s8,100
     e16:	a00d                	j	e38 <vprintf+0x56>
        putc(fd, c0);
     e18:	85a6                	mv	a1,s1
     e1a:	855a                	mv	a0,s6
     e1c:	f0bff0ef          	jal	d26 <putc>
     e20:	a019                	j	e26 <vprintf+0x44>
    } else if(state == '%'){
     e22:	03598363          	beq	s3,s5,e48 <vprintf+0x66>
  for(i = 0; fmt[i]; i++){
     e26:	0019079b          	addiw	a5,s2,1
     e2a:	893e                	mv	s2,a5
     e2c:	873e                	mv	a4,a5
     e2e:	97d2                	add	a5,a5,s4
     e30:	0007c483          	lbu	s1,0(a5)
     e34:	1c048a63          	beqz	s1,1008 <vprintf+0x226>
    c0 = fmt[i] & 0xff;
     e38:	0004879b          	sext.w	a5,s1
    if(state == 0){
     e3c:	fe0993e3          	bnez	s3,e22 <vprintf+0x40>
      if(c0 == '%'){
     e40:	fd579ce3          	bne	a5,s5,e18 <vprintf+0x36>
        state = '%';
     e44:	89be                	mv	s3,a5
     e46:	b7c5                	j	e26 <vprintf+0x44>
      if(c0) c1 = fmt[i+1] & 0xff;
     e48:	00ea06b3          	add	a3,s4,a4
     e4c:	0016c603          	lbu	a2,1(a3)
      if(c1) c2 = fmt[i+2] & 0xff;
     e50:	1c060863          	beqz	a2,1020 <vprintf+0x23e>
      if(c0 == 'd'){
     e54:	03878763          	beq	a5,s8,e82 <vprintf+0xa0>
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c0 == 'l' && c1 == 'd'){
     e58:	f9478693          	addi	a3,a5,-108
     e5c:	0016b693          	seqz	a3,a3
     e60:	f9c60593          	addi	a1,a2,-100
     e64:	e99d                	bnez	a1,e9a <vprintf+0xb8>
     e66:	ca95                	beqz	a3,e9a <vprintf+0xb8>
        printint(fd, va_arg(ap, uint64), 10, 1);
     e68:	008b8493          	addi	s1,s7,8
     e6c:	4685                	li	a3,1
     e6e:	4629                	li	a2,10
     e70:	000bb583          	ld	a1,0(s7)
     e74:	855a                	mv	a0,s6
     e76:	ecfff0ef          	jal	d44 <printint>
        i += 1;
     e7a:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 10, 1);
     e7c:	8ba6                	mv	s7,s1
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c0);
      }

      state = 0;
     e7e:	4981                	li	s3,0
     e80:	b75d                	j	e26 <vprintf+0x44>
        printint(fd, va_arg(ap, int), 10, 1);
     e82:	008b8493          	addi	s1,s7,8
     e86:	4685                	li	a3,1
     e88:	4629                	li	a2,10
     e8a:	000ba583          	lw	a1,0(s7)
     e8e:	855a                	mv	a0,s6
     e90:	eb5ff0ef          	jal	d44 <printint>
     e94:	8ba6                	mv	s7,s1
      state = 0;
     e96:	4981                	li	s3,0
     e98:	b779                	j	e26 <vprintf+0x44>
      if(c1) c2 = fmt[i+2] & 0xff;
     e9a:	9752                	add	a4,a4,s4
     e9c:	00274583          	lbu	a1,2(a4)
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
     ea0:	f9460713          	addi	a4,a2,-108
     ea4:	00173713          	seqz	a4,a4
     ea8:	8f75                	and	a4,a4,a3
     eaa:	f9c58513          	addi	a0,a1,-100
     eae:	18051363          	bnez	a0,1034 <vprintf+0x252>
     eb2:	18070163          	beqz	a4,1034 <vprintf+0x252>
        printint(fd, va_arg(ap, uint64), 10, 1);
     eb6:	008b8493          	addi	s1,s7,8
     eba:	4685                	li	a3,1
     ebc:	4629                	li	a2,10
     ebe:	000bb583          	ld	a1,0(s7)
     ec2:	855a                	mv	a0,s6
     ec4:	e81ff0ef          	jal	d44 <printint>
        i += 2;
     ec8:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 10, 1);
     eca:	8ba6                	mv	s7,s1
      state = 0;
     ecc:	4981                	li	s3,0
        i += 2;
     ece:	bfa1                	j	e26 <vprintf+0x44>
        printint(fd, va_arg(ap, uint32), 10, 0);
     ed0:	008b8493          	addi	s1,s7,8
     ed4:	4681                	li	a3,0
     ed6:	4629                	li	a2,10
     ed8:	000be583          	lwu	a1,0(s7)
     edc:	855a                	mv	a0,s6
     ede:	e67ff0ef          	jal	d44 <printint>
     ee2:	8ba6                	mv	s7,s1
      state = 0;
     ee4:	4981                	li	s3,0
     ee6:	b781                	j	e26 <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 10, 0);
     ee8:	008b8493          	addi	s1,s7,8
     eec:	4681                	li	a3,0
     eee:	4629                	li	a2,10
     ef0:	000bb583          	ld	a1,0(s7)
     ef4:	855a                	mv	a0,s6
     ef6:	e4fff0ef          	jal	d44 <printint>
        i += 1;
     efa:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 10, 0);
     efc:	8ba6                	mv	s7,s1
      state = 0;
     efe:	4981                	li	s3,0
     f00:	b71d                	j	e26 <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 10, 0);
     f02:	008b8493          	addi	s1,s7,8
     f06:	4681                	li	a3,0
     f08:	4629                	li	a2,10
     f0a:	000bb583          	ld	a1,0(s7)
     f0e:	855a                	mv	a0,s6
     f10:	e35ff0ef          	jal	d44 <printint>
        i += 2;
     f14:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 10, 0);
     f16:	8ba6                	mv	s7,s1
      state = 0;
     f18:	4981                	li	s3,0
        i += 2;
     f1a:	b731                	j	e26 <vprintf+0x44>
        printint(fd, va_arg(ap, uint32), 16, 0);
     f1c:	008b8493          	addi	s1,s7,8
     f20:	4681                	li	a3,0
     f22:	4641                	li	a2,16
     f24:	000be583          	lwu	a1,0(s7)
     f28:	855a                	mv	a0,s6
     f2a:	e1bff0ef          	jal	d44 <printint>
     f2e:	8ba6                	mv	s7,s1
      state = 0;
     f30:	4981                	li	s3,0
     f32:	bdd5                	j	e26 <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 16, 0);
     f34:	008b8493          	addi	s1,s7,8
     f38:	4681                	li	a3,0
     f3a:	4641                	li	a2,16
     f3c:	000bb583          	ld	a1,0(s7)
     f40:	855a                	mv	a0,s6
     f42:	e03ff0ef          	jal	d44 <printint>
        i += 1;
     f46:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 16, 0);
     f48:	8ba6                	mv	s7,s1
      state = 0;
     f4a:	4981                	li	s3,0
     f4c:	bde9                	j	e26 <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 16, 0);
     f4e:	008b8493          	addi	s1,s7,8
     f52:	4681                	li	a3,0
     f54:	4641                	li	a2,16
     f56:	000bb583          	ld	a1,0(s7)
     f5a:	855a                	mv	a0,s6
     f5c:	de9ff0ef          	jal	d44 <printint>
        i += 2;
     f60:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 16, 0);
     f62:	8ba6                	mv	s7,s1
      state = 0;
     f64:	4981                	li	s3,0
        i += 2;
     f66:	b5c1                	j	e26 <vprintf+0x44>
     f68:	e466                	sd	s9,8(sp)
        printptr(fd, va_arg(ap, uint64));
     f6a:	008b8793          	addi	a5,s7,8
     f6e:	8cbe                	mv	s9,a5
     f70:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
     f74:	03000593          	li	a1,48
     f78:	855a                	mv	a0,s6
     f7a:	dadff0ef          	jal	d26 <putc>
  putc(fd, 'x');
     f7e:	07800593          	li	a1,120
     f82:	855a                	mv	a0,s6
     f84:	da3ff0ef          	jal	d26 <putc>
     f88:	44c1                	li	s1,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
     f8a:	00000b97          	auipc	s7,0x0
     f8e:	43eb8b93          	addi	s7,s7,1086 # 13c8 <digits>
     f92:	03c9d793          	srli	a5,s3,0x3c
     f96:	97de                	add	a5,a5,s7
     f98:	0007c583          	lbu	a1,0(a5)
     f9c:	855a                	mv	a0,s6
     f9e:	d89ff0ef          	jal	d26 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
     fa2:	0992                	slli	s3,s3,0x4
     fa4:	34fd                	addiw	s1,s1,-1
     fa6:	f4f5                	bnez	s1,f92 <vprintf+0x1b0>
        printptr(fd, va_arg(ap, uint64));
     fa8:	8be6                	mv	s7,s9
      state = 0;
     faa:	4981                	li	s3,0
     fac:	6ca2                	ld	s9,8(sp)
     fae:	bda5                	j	e26 <vprintf+0x44>
        putc(fd, va_arg(ap, uint32));
     fb0:	008b8493          	addi	s1,s7,8
     fb4:	000bc583          	lbu	a1,0(s7)
     fb8:	855a                	mv	a0,s6
     fba:	d6dff0ef          	jal	d26 <putc>
     fbe:	8ba6                	mv	s7,s1
      state = 0;
     fc0:	4981                	li	s3,0
     fc2:	b595                	j	e26 <vprintf+0x44>
        if((s = va_arg(ap, char*)) == 0)
     fc4:	008b8993          	addi	s3,s7,8
     fc8:	000bb483          	ld	s1,0(s7)
     fcc:	cc91                	beqz	s1,fe8 <vprintf+0x206>
        for(; *s; s++)
     fce:	0004c583          	lbu	a1,0(s1)
     fd2:	c985                	beqz	a1,1002 <vprintf+0x220>
          putc(fd, *s);
     fd4:	855a                	mv	a0,s6
     fd6:	d51ff0ef          	jal	d26 <putc>
        for(; *s; s++)
     fda:	0485                	addi	s1,s1,1
     fdc:	0004c583          	lbu	a1,0(s1)
     fe0:	f9f5                	bnez	a1,fd4 <vprintf+0x1f2>
        if((s = va_arg(ap, char*)) == 0)
     fe2:	8bce                	mv	s7,s3
      state = 0;
     fe4:	4981                	li	s3,0
     fe6:	b581                	j	e26 <vprintf+0x44>
          s = "(null)";
     fe8:	00000497          	auipc	s1,0x0
     fec:	3a848493          	addi	s1,s1,936 # 1390 <malloc+0x20c>
        for(; *s; s++)
     ff0:	02800593          	li	a1,40
     ff4:	b7c5                	j	fd4 <vprintf+0x1f2>
        putc(fd, '%');
     ff6:	85be                	mv	a1,a5
     ff8:	855a                	mv	a0,s6
     ffa:	d2dff0ef          	jal	d26 <putc>
      state = 0;
     ffe:	4981                	li	s3,0
    1000:	b51d                	j	e26 <vprintf+0x44>
        if((s = va_arg(ap, char*)) == 0)
    1002:	8bce                	mv	s7,s3
      state = 0;
    1004:	4981                	li	s3,0
    1006:	b505                	j	e26 <vprintf+0x44>
    1008:	6906                	ld	s2,64(sp)
    100a:	79e2                	ld	s3,56(sp)
    100c:	7a42                	ld	s4,48(sp)
    100e:	7aa2                	ld	s5,40(sp)
    1010:	7b02                	ld	s6,32(sp)
    1012:	6be2                	ld	s7,24(sp)
    1014:	6c42                	ld	s8,16(sp)
    }
  }
}
    1016:	60e6                	ld	ra,88(sp)
    1018:	6446                	ld	s0,80(sp)
    101a:	64a6                	ld	s1,72(sp)
    101c:	6125                	addi	sp,sp,96
    101e:	8082                	ret
      if(c0 == 'd'){
    1020:	06400713          	li	a4,100
    1024:	e4e78fe3          	beq	a5,a4,e82 <vprintf+0xa0>
      } else if(c0 == 'l' && c1 == 'd'){
    1028:	f9478693          	addi	a3,a5,-108
    102c:	0016b693          	seqz	a3,a3
      c1 = c2 = 0;
    1030:	85b2                	mv	a1,a2
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
    1032:	4701                	li	a4,0
      } else if(c0 == 'u'){
    1034:	07500513          	li	a0,117
    1038:	e8a78ce3          	beq	a5,a0,ed0 <vprintf+0xee>
      } else if(c0 == 'l' && c1 == 'u'){
    103c:	f8b60513          	addi	a0,a2,-117
    1040:	e119                	bnez	a0,1046 <vprintf+0x264>
    1042:	ea0693e3          	bnez	a3,ee8 <vprintf+0x106>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
    1046:	f8b58513          	addi	a0,a1,-117
    104a:	e119                	bnez	a0,1050 <vprintf+0x26e>
    104c:	ea071be3          	bnez	a4,f02 <vprintf+0x120>
      } else if(c0 == 'x'){
    1050:	07800513          	li	a0,120
    1054:	eca784e3          	beq	a5,a0,f1c <vprintf+0x13a>
      } else if(c0 == 'l' && c1 == 'x'){
    1058:	f8860613          	addi	a2,a2,-120
    105c:	e219                	bnez	a2,1062 <vprintf+0x280>
    105e:	ec069be3          	bnez	a3,f34 <vprintf+0x152>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
    1062:	f8858593          	addi	a1,a1,-120
    1066:	e199                	bnez	a1,106c <vprintf+0x28a>
    1068:	ee0713e3          	bnez	a4,f4e <vprintf+0x16c>
      } else if(c0 == 'p'){
    106c:	07000713          	li	a4,112
    1070:	eee78ce3          	beq	a5,a4,f68 <vprintf+0x186>
      } else if(c0 == 'c'){
    1074:	06300713          	li	a4,99
    1078:	f2e78ce3          	beq	a5,a4,fb0 <vprintf+0x1ce>
      } else if(c0 == 's'){
    107c:	07300713          	li	a4,115
    1080:	f4e782e3          	beq	a5,a4,fc4 <vprintf+0x1e2>
      } else if(c0 == '%'){
    1084:	02500713          	li	a4,37
    1088:	f6e787e3          	beq	a5,a4,ff6 <vprintf+0x214>
        putc(fd, '%');
    108c:	02500593          	li	a1,37
    1090:	855a                	mv	a0,s6
    1092:	c95ff0ef          	jal	d26 <putc>
        putc(fd, c0);
    1096:	85a6                	mv	a1,s1
    1098:	855a                	mv	a0,s6
    109a:	c8dff0ef          	jal	d26 <putc>
      state = 0;
    109e:	4981                	li	s3,0
    10a0:	b359                	j	e26 <vprintf+0x44>

00000000000010a2 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
    10a2:	715d                	addi	sp,sp,-80
    10a4:	ec06                	sd	ra,24(sp)
    10a6:	e822                	sd	s0,16(sp)
    10a8:	1000                	addi	s0,sp,32
    10aa:	e010                	sd	a2,0(s0)
    10ac:	e414                	sd	a3,8(s0)
    10ae:	e818                	sd	a4,16(s0)
    10b0:	ec1c                	sd	a5,24(s0)
    10b2:	03043023          	sd	a6,32(s0)
    10b6:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
    10ba:	8622                	mv	a2,s0
    10bc:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
    10c0:	d23ff0ef          	jal	de2 <vprintf>
}
    10c4:	60e2                	ld	ra,24(sp)
    10c6:	6442                	ld	s0,16(sp)
    10c8:	6161                	addi	sp,sp,80
    10ca:	8082                	ret

00000000000010cc <printf>:

void
printf(const char *fmt, ...)
{
    10cc:	711d                	addi	sp,sp,-96
    10ce:	ec06                	sd	ra,24(sp)
    10d0:	e822                	sd	s0,16(sp)
    10d2:	1000                	addi	s0,sp,32
    10d4:	e40c                	sd	a1,8(s0)
    10d6:	e810                	sd	a2,16(s0)
    10d8:	ec14                	sd	a3,24(s0)
    10da:	f018                	sd	a4,32(s0)
    10dc:	f41c                	sd	a5,40(s0)
    10de:	03043823          	sd	a6,48(s0)
    10e2:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
    10e6:	00840613          	addi	a2,s0,8
    10ea:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
    10ee:	85aa                	mv	a1,a0
    10f0:	4505                	li	a0,1
    10f2:	cf1ff0ef          	jal	de2 <vprintf>
}
    10f6:	60e2                	ld	ra,24(sp)
    10f8:	6442                	ld	s0,16(sp)
    10fa:	6125                	addi	sp,sp,96
    10fc:	8082                	ret

00000000000010fe <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
    10fe:	1141                	addi	sp,sp,-16
    1100:	e406                	sd	ra,8(sp)
    1102:	e022                	sd	s0,0(sp)
    1104:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
    1106:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    110a:	00001797          	auipc	a5,0x1
    110e:	f067b783          	ld	a5,-250(a5) # 2010 <freep>
    1112:	a039                	j	1120 <free+0x22>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    1114:	6398                	ld	a4,0(a5)
    1116:	00e7e463          	bltu	a5,a4,111e <free+0x20>
    111a:	00e6ea63          	bltu	a3,a4,112e <free+0x30>
{
    111e:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    1120:	fed7fae3          	bgeu	a5,a3,1114 <free+0x16>
    1124:	6398                	ld	a4,0(a5)
    1126:	00e6e463          	bltu	a3,a4,112e <free+0x30>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    112a:	fee7eae3          	bltu	a5,a4,111e <free+0x20>
      break;
  if(bp + bp->s.size == p->s.ptr){
    112e:	ff852583          	lw	a1,-8(a0)
    1132:	6390                	ld	a2,0(a5)
    1134:	02059813          	slli	a6,a1,0x20
    1138:	01c85713          	srli	a4,a6,0x1c
    113c:	9736                	add	a4,a4,a3
    113e:	02e60563          	beq	a2,a4,1168 <free+0x6a>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
    1142:	fec53823          	sd	a2,-16(a0)
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    1146:	4790                	lw	a2,8(a5)
    1148:	02061593          	slli	a1,a2,0x20
    114c:	01c5d713          	srli	a4,a1,0x1c
    1150:	973e                	add	a4,a4,a5
    1152:	02e68263          	beq	a3,a4,1176 <free+0x78>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
    1156:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
    1158:	00001717          	auipc	a4,0x1
    115c:	eaf73c23          	sd	a5,-328(a4) # 2010 <freep>
}
    1160:	60a2                	ld	ra,8(sp)
    1162:	6402                	ld	s0,0(sp)
    1164:	0141                	addi	sp,sp,16
    1166:	8082                	ret
    bp->s.size += p->s.ptr->s.size;
    1168:	4618                	lw	a4,8(a2)
    116a:	9f2d                	addw	a4,a4,a1
    116c:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
    1170:	6398                	ld	a4,0(a5)
    1172:	6310                	ld	a2,0(a4)
    1174:	b7f9                	j	1142 <free+0x44>
    p->s.size += bp->s.size;
    1176:	ff852703          	lw	a4,-8(a0)
    117a:	9f31                	addw	a4,a4,a2
    117c:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
    117e:	ff053683          	ld	a3,-16(a0)
    1182:	bfd1                	j	1156 <free+0x58>

0000000000001184 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
    1184:	7139                	addi	sp,sp,-64
    1186:	fc06                	sd	ra,56(sp)
    1188:	f822                	sd	s0,48(sp)
    118a:	f04a                	sd	s2,32(sp)
    118c:	ec4e                	sd	s3,24(sp)
    118e:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
    1190:	02051993          	slli	s3,a0,0x20
    1194:	0209d993          	srli	s3,s3,0x20
    1198:	09bd                	addi	s3,s3,15
    119a:	0049d993          	srli	s3,s3,0x4
    119e:	2985                	addiw	s3,s3,1
    11a0:	894e                	mv	s2,s3
  if((prevp = freep) == 0){
    11a2:	00001517          	auipc	a0,0x1
    11a6:	e6e53503          	ld	a0,-402(a0) # 2010 <freep>
    11aa:	c905                	beqz	a0,11da <malloc+0x56>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    11ac:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
    11ae:	4798                	lw	a4,8(a5)
    11b0:	09377663          	bgeu	a4,s3,123c <malloc+0xb8>
    11b4:	f426                	sd	s1,40(sp)
    11b6:	e852                	sd	s4,16(sp)
    11b8:	e456                	sd	s5,8(sp)
    11ba:	e05a                	sd	s6,0(sp)
  if(nu < 4096)
    11bc:	8a4e                	mv	s4,s3
    11be:	6705                	lui	a4,0x1
    11c0:	00e9f363          	bgeu	s3,a4,11c6 <malloc+0x42>
    11c4:	6a05                	lui	s4,0x1
    11c6:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
    11ca:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
    11ce:	00001497          	auipc	s1,0x1
    11d2:	e4248493          	addi	s1,s1,-446 # 2010 <freep>
  if(p == SBRK_ERROR)
    11d6:	5afd                	li	s5,-1
    11d8:	a83d                	j	1216 <malloc+0x92>
    11da:	f426                	sd	s1,40(sp)
    11dc:	e852                	sd	s4,16(sp)
    11de:	e456                	sd	s5,8(sp)
    11e0:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
    11e2:	00001797          	auipc	a5,0x1
    11e6:	ea678793          	addi	a5,a5,-346 # 2088 <base>
    11ea:	00001717          	auipc	a4,0x1
    11ee:	e2f73323          	sd	a5,-474(a4) # 2010 <freep>
    11f2:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
    11f4:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
    11f8:	b7d1                	j	11bc <malloc+0x38>
        prevp->s.ptr = p->s.ptr;
    11fa:	6398                	ld	a4,0(a5)
    11fc:	e118                	sd	a4,0(a0)
    11fe:	a899                	j	1254 <malloc+0xd0>
  hp->s.size = nu;
    1200:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
    1204:	0541                	addi	a0,a0,16
    1206:	ef9ff0ef          	jal	10fe <free>
  return freep;
    120a:	6088                	ld	a0,0(s1)
      if((p = morecore(nunits)) == 0)
    120c:	c125                	beqz	a0,126c <malloc+0xe8>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    120e:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
    1210:	4798                	lw	a4,8(a5)
    1212:	03277163          	bgeu	a4,s2,1234 <malloc+0xb0>
    if(p == freep)
    1216:	6098                	ld	a4,0(s1)
    1218:	853e                	mv	a0,a5
    121a:	fef71ae3          	bne	a4,a5,120e <malloc+0x8a>
  p = sbrk(nu * sizeof(Header));
    121e:	8552                	mv	a0,s4
    1220:	a33ff0ef          	jal	c52 <sbrk>
  if(p == SBRK_ERROR)
    1224:	fd551ee3          	bne	a0,s5,1200 <malloc+0x7c>
        return 0;
    1228:	4501                	li	a0,0
    122a:	74a2                	ld	s1,40(sp)
    122c:	6a42                	ld	s4,16(sp)
    122e:	6aa2                	ld	s5,8(sp)
    1230:	6b02                	ld	s6,0(sp)
    1232:	a03d                	j	1260 <malloc+0xdc>
    1234:	74a2                	ld	s1,40(sp)
    1236:	6a42                	ld	s4,16(sp)
    1238:	6aa2                	ld	s5,8(sp)
    123a:	6b02                	ld	s6,0(sp)
      if(p->s.size == nunits)
    123c:	fae90fe3          	beq	s2,a4,11fa <malloc+0x76>
        p->s.size -= nunits;
    1240:	4137073b          	subw	a4,a4,s3
    1244:	c798                	sw	a4,8(a5)
        p += p->s.size;
    1246:	02071693          	slli	a3,a4,0x20
    124a:	01c6d713          	srli	a4,a3,0x1c
    124e:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
    1250:	0137a423          	sw	s3,8(a5)
      freep = prevp;
    1254:	00001717          	auipc	a4,0x1
    1258:	daa73e23          	sd	a0,-580(a4) # 2010 <freep>
      return (void*)(p + 1);
    125c:	01078513          	addi	a0,a5,16
  }
}
    1260:	70e2                	ld	ra,56(sp)
    1262:	7442                	ld	s0,48(sp)
    1264:	7902                	ld	s2,32(sp)
    1266:	69e2                	ld	s3,24(sp)
    1268:	6121                	addi	sp,sp,64
    126a:	8082                	ret
    126c:	74a2                	ld	s1,40(sp)
    126e:	6a42                	ld	s4,16(sp)
    1270:	6aa2                	ld	s5,8(sp)
    1272:	6b02                	ld	s6,0(sp)
    1274:	b7f5                	j	1260 <malloc+0xdc>
