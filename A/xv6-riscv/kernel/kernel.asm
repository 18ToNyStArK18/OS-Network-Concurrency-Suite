
kernel/kernel:     file format elf64-littleriscv


Disassembly of section .text:

0000000080000000 <_entry>:
_entry:
        # set up a stack for C.
        # stack0 is declared in start.c,
        # with a 4096-byte stack per CPU.
        # sp = stack0 + ((hartid + 1) * 4096)
        la sp, stack0
    80000000:	0000b117          	auipc	sp,0xb
    80000004:	7d010113          	addi	sp,sp,2000 # 8000b7d0 <stack0>
        li a0, 1024*4
    80000008:	6505                	lui	a0,0x1
        csrr a1, mhartid
    8000000a:	f14025f3          	csrr	a1,mhartid
        addi a1, a1, 1
    8000000e:	0585                	addi	a1,a1,1
        mul a0, a0, a1
    80000010:	02b50533          	mul	a0,a0,a1
        add sp, sp, a0
    80000014:	912a                	add	sp,sp,a0
        # jump to start() in start.c
        call start
    80000016:	04e000ef          	jal	80000064 <start>

000000008000001a <spin>:
spin:
        j spin
    8000001a:	a001                	j	8000001a <spin>

000000008000001c <timerinit>:
}

// ask each hart to generate timer interrupts.
void
timerinit()
{
    8000001c:	1141                	addi	sp,sp,-16
    8000001e:	e406                	sd	ra,8(sp)
    80000020:	e022                	sd	s0,0(sp)
    80000022:	0800                	addi	s0,sp,16
#define MIE_STIE (1L << 5)  // supervisor timer
static inline uint64
r_mie()
{
  uint64 x;
  asm volatile("csrr %0, mie" : "=r" (x) );
    80000024:	304027f3          	csrr	a5,mie
  // enable supervisor-mode timer interrupts.
  w_mie(r_mie() | MIE_STIE);
    80000028:	0207e793          	ori	a5,a5,32
}

static inline void 
w_mie(uint64 x)
{
  asm volatile("csrw mie, %0" : : "r" (x));
    8000002c:	30479073          	csrw	mie,a5
static inline uint64
r_menvcfg()
{
  uint64 x;
  // asm volatile("csrr %0, menvcfg" : "=r" (x) );
  asm volatile("csrr %0, 0x30a" : "=r" (x) );
    80000030:	30a027f3          	csrr	a5,0x30a
  
  // enable the sstc extension (i.e. stimecmp).
  w_menvcfg(r_menvcfg() | (1L << 63)); 
    80000034:	577d                	li	a4,-1
    80000036:	177e                	slli	a4,a4,0x3f
    80000038:	8fd9                	or	a5,a5,a4

static inline void 
w_menvcfg(uint64 x)
{
  // asm volatile("csrw menvcfg, %0" : : "r" (x));
  asm volatile("csrw 0x30a, %0" : : "r" (x));
    8000003a:	30a79073          	csrw	0x30a,a5

static inline uint64
r_mcounteren()
{
  uint64 x;
  asm volatile("csrr %0, mcounteren" : "=r" (x) );
    8000003e:	306027f3          	csrr	a5,mcounteren
  
  // allow supervisor to use stimecmp and time.
  w_mcounteren(r_mcounteren() | 2);
    80000042:	0027e793          	ori	a5,a5,2
  asm volatile("csrw mcounteren, %0" : : "r" (x));
    80000046:	30679073          	csrw	mcounteren,a5
// machine-mode cycle counter
static inline uint64
r_time()
{
  uint64 x;
  asm volatile("csrr %0, time" : "=r" (x) );
    8000004a:	c01027f3          	rdtime	a5
  
  // ask for the very first timer interrupt.
  w_stimecmp(r_time() + 1000000);
    8000004e:	000f4737          	lui	a4,0xf4
    80000052:	24070713          	addi	a4,a4,576 # f4240 <_entry-0x7ff0bdc0>
    80000056:	97ba                	add	a5,a5,a4
  asm volatile("csrw 0x14d, %0" : : "r" (x));
    80000058:	14d79073          	csrw	stimecmp,a5
}
    8000005c:	60a2                	ld	ra,8(sp)
    8000005e:	6402                	ld	s0,0(sp)
    80000060:	0141                	addi	sp,sp,16
    80000062:	8082                	ret

0000000080000064 <start>:
{
    80000064:	1141                	addi	sp,sp,-16
    80000066:	e406                	sd	ra,8(sp)
    80000068:	e022                	sd	s0,0(sp)
    8000006a:	0800                	addi	s0,sp,16
  asm volatile("csrr %0, mstatus" : "=r" (x) );
    8000006c:	300027f3          	csrr	a5,mstatus
  x &= ~MSTATUS_MPP_MASK;
    80000070:	7779                	lui	a4,0xffffe
    80000072:	7ff70713          	addi	a4,a4,2047 # ffffffffffffe7ff <end+0xffffffff7dd98327>
    80000076:	8ff9                	and	a5,a5,a4
  x |= MSTATUS_MPP_S;
    80000078:	6705                	lui	a4,0x1
    8000007a:	80070713          	addi	a4,a4,-2048 # 800 <_entry-0x7ffff800>
    8000007e:	8fd9                	or	a5,a5,a4
  asm volatile("csrw mstatus, %0" : : "r" (x));
    80000080:	30079073          	csrw	mstatus,a5
  asm volatile("csrw mepc, %0" : : "r" (x));
    80000084:	00001797          	auipc	a5,0x1
    80000088:	e2a78793          	addi	a5,a5,-470 # 80000eae <main>
    8000008c:	34179073          	csrw	mepc,a5
  asm volatile("csrw satp, %0" : : "r" (x));
    80000090:	4781                	li	a5,0
    80000092:	18079073          	csrw	satp,a5
  asm volatile("csrw medeleg, %0" : : "r" (x));
    80000096:	67c1                	lui	a5,0x10
    80000098:	17fd                	addi	a5,a5,-1 # ffff <_entry-0x7fff0001>
    8000009a:	30279073          	csrw	medeleg,a5
  asm volatile("csrw mideleg, %0" : : "r" (x));
    8000009e:	30379073          	csrw	mideleg,a5
  asm volatile("csrr %0, sie" : "=r" (x) );
    800000a2:	104027f3          	csrr	a5,sie
  w_sie(r_sie() | SIE_SEIE | SIE_STIE);
    800000a6:	2207e793          	ori	a5,a5,544
  asm volatile("csrw sie, %0" : : "r" (x));
    800000aa:	10479073          	csrw	sie,a5
  asm volatile("csrw pmpaddr0, %0" : : "r" (x));
    800000ae:	57fd                	li	a5,-1
    800000b0:	83a9                	srli	a5,a5,0xa
    800000b2:	3b079073          	csrw	pmpaddr0,a5
  asm volatile("csrw pmpcfg0, %0" : : "r" (x));
    800000b6:	47bd                	li	a5,15
    800000b8:	3a079073          	csrw	pmpcfg0,a5
  timerinit();
    800000bc:	f61ff0ef          	jal	8000001c <timerinit>
  asm volatile("csrr %0, mhartid" : "=r" (x) );
    800000c0:	f14027f3          	csrr	a5,mhartid
  w_tp(id);
    800000c4:	2781                	sext.w	a5,a5
}

static inline void 
w_tp(uint64 x)
{
  asm volatile("mv tp, %0" : : "r" (x));
    800000c6:	823e                	mv	tp,a5
  asm volatile("mret");
    800000c8:	30200073          	mret
}
    800000cc:	60a2                	ld	ra,8(sp)
    800000ce:	6402                	ld	s0,0(sp)
    800000d0:	0141                	addi	sp,sp,16
    800000d2:	8082                	ret

00000000800000d4 <consolewrite>:
//
// user write()s to the console go here.
//
int
consolewrite(int user_src, uint64 src, int n)
{
    800000d4:	7119                	addi	sp,sp,-128
    800000d6:	fc86                	sd	ra,120(sp)
    800000d8:	f8a2                	sd	s0,112(sp)
    800000da:	f4a6                	sd	s1,104(sp)
    800000dc:	0100                	addi	s0,sp,128
  char buf[32];
  int i = 0;

  while(i < n){
    800000de:	06c05b63          	blez	a2,80000154 <consolewrite+0x80>
    800000e2:	f0ca                	sd	s2,96(sp)
    800000e4:	ecce                	sd	s3,88(sp)
    800000e6:	e8d2                	sd	s4,80(sp)
    800000e8:	e4d6                	sd	s5,72(sp)
    800000ea:	e0da                	sd	s6,64(sp)
    800000ec:	fc5e                	sd	s7,56(sp)
    800000ee:	f862                	sd	s8,48(sp)
    800000f0:	f466                	sd	s9,40(sp)
    800000f2:	f06a                	sd	s10,32(sp)
    800000f4:	8b2a                	mv	s6,a0
    800000f6:	8bae                	mv	s7,a1
    800000f8:	8a32                	mv	s4,a2
  int i = 0;
    800000fa:	4481                	li	s1,0
    int nn = sizeof(buf);
    if(nn > n - i)
    800000fc:	02000c93          	li	s9,32
    80000100:	02000d13          	li	s10,32
      nn = n - i;
    if(either_copyin(buf, user_src, src+i, nn) == -1)
    80000104:	f8040a93          	addi	s5,s0,-128
    80000108:	5c7d                	li	s8,-1
    8000010a:	a025                	j	80000132 <consolewrite+0x5e>
    if(nn > n - i)
    8000010c:	0009099b          	sext.w	s3,s2
    if(either_copyin(buf, user_src, src+i, nn) == -1)
    80000110:	86ce                	mv	a3,s3
    80000112:	01748633          	add	a2,s1,s7
    80000116:	85da                	mv	a1,s6
    80000118:	8556                	mv	a0,s5
    8000011a:	11b020ef          	jal	80002a34 <either_copyin>
    8000011e:	03850d63          	beq	a0,s8,80000158 <consolewrite+0x84>
      break;
    uartwrite(buf, nn);
    80000122:	85ce                	mv	a1,s3
    80000124:	8556                	mv	a0,s5
    80000126:	7b4000ef          	jal	800008da <uartwrite>
    i += nn;
    8000012a:	009904bb          	addw	s1,s2,s1
  while(i < n){
    8000012e:	0144d963          	bge	s1,s4,80000140 <consolewrite+0x6c>
    if(nn > n - i)
    80000132:	409a07bb          	subw	a5,s4,s1
    80000136:	893e                	mv	s2,a5
    80000138:	fcfcdae3          	bge	s9,a5,8000010c <consolewrite+0x38>
    8000013c:	896a                	mv	s2,s10
    8000013e:	b7f9                	j	8000010c <consolewrite+0x38>
    80000140:	7906                	ld	s2,96(sp)
    80000142:	69e6                	ld	s3,88(sp)
    80000144:	6a46                	ld	s4,80(sp)
    80000146:	6aa6                	ld	s5,72(sp)
    80000148:	6b06                	ld	s6,64(sp)
    8000014a:	7be2                	ld	s7,56(sp)
    8000014c:	7c42                	ld	s8,48(sp)
    8000014e:	7ca2                	ld	s9,40(sp)
    80000150:	7d02                	ld	s10,32(sp)
    80000152:	a821                	j	8000016a <consolewrite+0x96>
  int i = 0;
    80000154:	4481                	li	s1,0
    80000156:	a811                	j	8000016a <consolewrite+0x96>
    80000158:	7906                	ld	s2,96(sp)
    8000015a:	69e6                	ld	s3,88(sp)
    8000015c:	6a46                	ld	s4,80(sp)
    8000015e:	6aa6                	ld	s5,72(sp)
    80000160:	6b06                	ld	s6,64(sp)
    80000162:	7be2                	ld	s7,56(sp)
    80000164:	7c42                	ld	s8,48(sp)
    80000166:	7ca2                	ld	s9,40(sp)
    80000168:	7d02                	ld	s10,32(sp)
  }

  return i;
}
    8000016a:	8526                	mv	a0,s1
    8000016c:	70e6                	ld	ra,120(sp)
    8000016e:	7446                	ld	s0,112(sp)
    80000170:	74a6                	ld	s1,104(sp)
    80000172:	6109                	addi	sp,sp,128
    80000174:	8082                	ret

0000000080000176 <consoleread>:
// user_dist indicates whether dst is a user
// or kernel address.
//
int
consoleread(int user_dst, uint64 dst, int n)
{
    80000176:	711d                	addi	sp,sp,-96
    80000178:	ec86                	sd	ra,88(sp)
    8000017a:	e8a2                	sd	s0,80(sp)
    8000017c:	e4a6                	sd	s1,72(sp)
    8000017e:	e0ca                	sd	s2,64(sp)
    80000180:	fc4e                	sd	s3,56(sp)
    80000182:	f852                	sd	s4,48(sp)
    80000184:	f05a                	sd	s6,32(sp)
    80000186:	ec5e                	sd	s7,24(sp)
    80000188:	1080                	addi	s0,sp,96
    8000018a:	8b2a                	mv	s6,a0
    8000018c:	8a2e                	mv	s4,a1
    8000018e:	89b2                	mv	s3,a2
  uint target;
  int c;
  char cbuf;

  target = n;
    80000190:	8bb2                	mv	s7,a2
  acquire(&cons.lock);
    80000192:	00013517          	auipc	a0,0x13
    80000196:	63e50513          	addi	a0,a0,1598 # 800137d0 <cons>
    8000019a:	28f000ef          	jal	80000c28 <acquire>
  while(n > 0){
    // wait until interrupt handler has put some
    // input into cons.buffer.
    while(cons.r == cons.w){
    8000019e:	00013497          	auipc	s1,0x13
    800001a2:	63248493          	addi	s1,s1,1586 # 800137d0 <cons>
      if(killed(myproc())){
        release(&cons.lock);
        return -1;
      }
      sleep(&cons.r, &cons.lock);
    800001a6:	00013917          	auipc	s2,0x13
    800001aa:	6c290913          	addi	s2,s2,1730 # 80013868 <cons+0x98>
  while(n > 0){
    800001ae:	0b305b63          	blez	s3,80000264 <consoleread+0xee>
    while(cons.r == cons.w){
    800001b2:	0984a783          	lw	a5,152(s1)
    800001b6:	09c4a703          	lw	a4,156(s1)
    800001ba:	0af71063          	bne	a4,a5,8000025a <consoleread+0xe4>
      if(killed(myproc())){
    800001be:	569010ef          	jal	80001f26 <myproc>
    800001c2:	706020ef          	jal	800028c8 <killed>
    800001c6:	e12d                	bnez	a0,80000228 <consoleread+0xb2>
      sleep(&cons.r, &cons.lock);
    800001c8:	85a6                	mv	a1,s1
    800001ca:	854a                	mv	a0,s2
    800001cc:	464020ef          	jal	80002630 <sleep>
    while(cons.r == cons.w){
    800001d0:	0984a783          	lw	a5,152(s1)
    800001d4:	09c4a703          	lw	a4,156(s1)
    800001d8:	fef703e3          	beq	a4,a5,800001be <consoleread+0x48>
    800001dc:	f456                	sd	s5,40(sp)
    }

    c = cons.buf[cons.r++ % INPUT_BUF_SIZE];
    800001de:	00013717          	auipc	a4,0x13
    800001e2:	5f270713          	addi	a4,a4,1522 # 800137d0 <cons>
    800001e6:	0017869b          	addiw	a3,a5,1
    800001ea:	08d72c23          	sw	a3,152(a4)
    800001ee:	07f7f693          	andi	a3,a5,127
    800001f2:	9736                	add	a4,a4,a3
    800001f4:	01874703          	lbu	a4,24(a4)
    800001f8:	00070a9b          	sext.w	s5,a4

    if(c == C('D')){  // end-of-file
    800001fc:	4691                	li	a3,4
    800001fe:	04da8663          	beq	s5,a3,8000024a <consoleread+0xd4>
      }
      break;
    }

    // copy the input byte to the user-space buffer.
    cbuf = c;
    80000202:	fae407a3          	sb	a4,-81(s0)
    if(either_copyout(user_dst, dst, &cbuf, 1) == -1)
    80000206:	4685                	li	a3,1
    80000208:	faf40613          	addi	a2,s0,-81
    8000020c:	85d2                	mv	a1,s4
    8000020e:	855a                	mv	a0,s6
    80000210:	7da020ef          	jal	800029ea <either_copyout>
    80000214:	57fd                	li	a5,-1
    80000216:	04f50663          	beq	a0,a5,80000262 <consoleread+0xec>
      break;

    dst++;
    8000021a:	0a05                	addi	s4,s4,1
    --n;
    8000021c:	39fd                	addiw	s3,s3,-1

    if(c == '\n'){
    8000021e:	47a9                	li	a5,10
    80000220:	04fa8b63          	beq	s5,a5,80000276 <consoleread+0x100>
    80000224:	7aa2                	ld	s5,40(sp)
    80000226:	b761                	j	800001ae <consoleread+0x38>
        release(&cons.lock);
    80000228:	00013517          	auipc	a0,0x13
    8000022c:	5a850513          	addi	a0,a0,1448 # 800137d0 <cons>
    80000230:	28d000ef          	jal	80000cbc <release>
        return -1;
    80000234:	557d                	li	a0,-1
    }
  }
  release(&cons.lock);

  return target - n;
}
    80000236:	60e6                	ld	ra,88(sp)
    80000238:	6446                	ld	s0,80(sp)
    8000023a:	64a6                	ld	s1,72(sp)
    8000023c:	6906                	ld	s2,64(sp)
    8000023e:	79e2                	ld	s3,56(sp)
    80000240:	7a42                	ld	s4,48(sp)
    80000242:	7b02                	ld	s6,32(sp)
    80000244:	6be2                	ld	s7,24(sp)
    80000246:	6125                	addi	sp,sp,96
    80000248:	8082                	ret
      if(n < target){
    8000024a:	0179fa63          	bgeu	s3,s7,8000025e <consoleread+0xe8>
        cons.r--;
    8000024e:	00013717          	auipc	a4,0x13
    80000252:	60f72d23          	sw	a5,1562(a4) # 80013868 <cons+0x98>
    80000256:	7aa2                	ld	s5,40(sp)
    80000258:	a031                	j	80000264 <consoleread+0xee>
    8000025a:	f456                	sd	s5,40(sp)
    8000025c:	b749                	j	800001de <consoleread+0x68>
    8000025e:	7aa2                	ld	s5,40(sp)
    80000260:	a011                	j	80000264 <consoleread+0xee>
    80000262:	7aa2                	ld	s5,40(sp)
  release(&cons.lock);
    80000264:	00013517          	auipc	a0,0x13
    80000268:	56c50513          	addi	a0,a0,1388 # 800137d0 <cons>
    8000026c:	251000ef          	jal	80000cbc <release>
  return target - n;
    80000270:	413b853b          	subw	a0,s7,s3
    80000274:	b7c9                	j	80000236 <consoleread+0xc0>
    80000276:	7aa2                	ld	s5,40(sp)
    80000278:	b7f5                	j	80000264 <consoleread+0xee>

000000008000027a <consputc>:
{
    8000027a:	1141                	addi	sp,sp,-16
    8000027c:	e406                	sd	ra,8(sp)
    8000027e:	e022                	sd	s0,0(sp)
    80000280:	0800                	addi	s0,sp,16
  if(c == BACKSPACE){
    80000282:	10000793          	li	a5,256
    80000286:	00f50863          	beq	a0,a5,80000296 <consputc+0x1c>
    uartputc_sync(c);
    8000028a:	6e4000ef          	jal	8000096e <uartputc_sync>
}
    8000028e:	60a2                	ld	ra,8(sp)
    80000290:	6402                	ld	s0,0(sp)
    80000292:	0141                	addi	sp,sp,16
    80000294:	8082                	ret
    uartputc_sync('\b'); uartputc_sync(' '); uartputc_sync('\b');
    80000296:	4521                	li	a0,8
    80000298:	6d6000ef          	jal	8000096e <uartputc_sync>
    8000029c:	02000513          	li	a0,32
    800002a0:	6ce000ef          	jal	8000096e <uartputc_sync>
    800002a4:	4521                	li	a0,8
    800002a6:	6c8000ef          	jal	8000096e <uartputc_sync>
    800002aa:	b7d5                	j	8000028e <consputc+0x14>

00000000800002ac <consoleintr>:
// do erase/kill processing, append to cons.buf,
// wake up consoleread() if a whole line has arrived.
//
void
consoleintr(int c)
{
    800002ac:	1101                	addi	sp,sp,-32
    800002ae:	ec06                	sd	ra,24(sp)
    800002b0:	e822                	sd	s0,16(sp)
    800002b2:	e426                	sd	s1,8(sp)
    800002b4:	1000                	addi	s0,sp,32
    800002b6:	84aa                	mv	s1,a0
  acquire(&cons.lock);
    800002b8:	00013517          	auipc	a0,0x13
    800002bc:	51850513          	addi	a0,a0,1304 # 800137d0 <cons>
    800002c0:	169000ef          	jal	80000c28 <acquire>

  switch(c){
    800002c4:	47d5                	li	a5,21
    800002c6:	08f48d63          	beq	s1,a5,80000360 <consoleintr+0xb4>
    800002ca:	0297c563          	blt	a5,s1,800002f4 <consoleintr+0x48>
    800002ce:	47a1                	li	a5,8
    800002d0:	0ef48263          	beq	s1,a5,800003b4 <consoleintr+0x108>
    800002d4:	47c1                	li	a5,16
    800002d6:	10f49363          	bne	s1,a5,800003dc <consoleintr+0x130>
  case C('P'):  // Print process list.
    procdump();
    800002da:	7a4020ef          	jal	80002a7e <procdump>
      }
    }
    break;
  }
  
  release(&cons.lock);
    800002de:	00013517          	auipc	a0,0x13
    800002e2:	4f250513          	addi	a0,a0,1266 # 800137d0 <cons>
    800002e6:	1d7000ef          	jal	80000cbc <release>
}
    800002ea:	60e2                	ld	ra,24(sp)
    800002ec:	6442                	ld	s0,16(sp)
    800002ee:	64a2                	ld	s1,8(sp)
    800002f0:	6105                	addi	sp,sp,32
    800002f2:	8082                	ret
  switch(c){
    800002f4:	07f00793          	li	a5,127
    800002f8:	0af48e63          	beq	s1,a5,800003b4 <consoleintr+0x108>
    if(c != 0 && cons.e-cons.r < INPUT_BUF_SIZE){
    800002fc:	00013717          	auipc	a4,0x13
    80000300:	4d470713          	addi	a4,a4,1236 # 800137d0 <cons>
    80000304:	0a072783          	lw	a5,160(a4)
    80000308:	09872703          	lw	a4,152(a4)
    8000030c:	9f99                	subw	a5,a5,a4
    8000030e:	07f00713          	li	a4,127
    80000312:	fcf766e3          	bltu	a4,a5,800002de <consoleintr+0x32>
      c = (c == '\r') ? '\n' : c;
    80000316:	47b5                	li	a5,13
    80000318:	0cf48563          	beq	s1,a5,800003e2 <consoleintr+0x136>
      consputc(c);
    8000031c:	8526                	mv	a0,s1
    8000031e:	f5dff0ef          	jal	8000027a <consputc>
      cons.buf[cons.e++ % INPUT_BUF_SIZE] = c;
    80000322:	00013717          	auipc	a4,0x13
    80000326:	4ae70713          	addi	a4,a4,1198 # 800137d0 <cons>
    8000032a:	0a072683          	lw	a3,160(a4)
    8000032e:	0016879b          	addiw	a5,a3,1
    80000332:	863e                	mv	a2,a5
    80000334:	0af72023          	sw	a5,160(a4)
    80000338:	07f6f693          	andi	a3,a3,127
    8000033c:	9736                	add	a4,a4,a3
    8000033e:	00970c23          	sb	s1,24(a4)
      if(c == '\n' || c == C('D') || cons.e-cons.r == INPUT_BUF_SIZE){
    80000342:	ff648713          	addi	a4,s1,-10
    80000346:	c371                	beqz	a4,8000040a <consoleintr+0x15e>
    80000348:	14f1                	addi	s1,s1,-4
    8000034a:	c0e1                	beqz	s1,8000040a <consoleintr+0x15e>
    8000034c:	00013717          	auipc	a4,0x13
    80000350:	51c72703          	lw	a4,1308(a4) # 80013868 <cons+0x98>
    80000354:	9f99                	subw	a5,a5,a4
    80000356:	08000713          	li	a4,128
    8000035a:	f8e792e3          	bne	a5,a4,800002de <consoleintr+0x32>
    8000035e:	a075                	j	8000040a <consoleintr+0x15e>
    80000360:	e04a                	sd	s2,0(sp)
    while(cons.e != cons.w &&
    80000362:	00013717          	auipc	a4,0x13
    80000366:	46e70713          	addi	a4,a4,1134 # 800137d0 <cons>
    8000036a:	0a072783          	lw	a5,160(a4)
    8000036e:	09c72703          	lw	a4,156(a4)
          cons.buf[(cons.e-1) % INPUT_BUF_SIZE] != '\n'){
    80000372:	00013497          	auipc	s1,0x13
    80000376:	45e48493          	addi	s1,s1,1118 # 800137d0 <cons>
    while(cons.e != cons.w &&
    8000037a:	4929                	li	s2,10
    8000037c:	02f70863          	beq	a4,a5,800003ac <consoleintr+0x100>
          cons.buf[(cons.e-1) % INPUT_BUF_SIZE] != '\n'){
    80000380:	37fd                	addiw	a5,a5,-1
    80000382:	07f7f713          	andi	a4,a5,127
    80000386:	9726                	add	a4,a4,s1
    while(cons.e != cons.w &&
    80000388:	01874703          	lbu	a4,24(a4)
    8000038c:	03270263          	beq	a4,s2,800003b0 <consoleintr+0x104>
      cons.e--;
    80000390:	0af4a023          	sw	a5,160(s1)
      consputc(BACKSPACE);
    80000394:	10000513          	li	a0,256
    80000398:	ee3ff0ef          	jal	8000027a <consputc>
    while(cons.e != cons.w &&
    8000039c:	0a04a783          	lw	a5,160(s1)
    800003a0:	09c4a703          	lw	a4,156(s1)
    800003a4:	fcf71ee3          	bne	a4,a5,80000380 <consoleintr+0xd4>
    800003a8:	6902                	ld	s2,0(sp)
    800003aa:	bf15                	j	800002de <consoleintr+0x32>
    800003ac:	6902                	ld	s2,0(sp)
    800003ae:	bf05                	j	800002de <consoleintr+0x32>
    800003b0:	6902                	ld	s2,0(sp)
    800003b2:	b735                	j	800002de <consoleintr+0x32>
    if(cons.e != cons.w){
    800003b4:	00013717          	auipc	a4,0x13
    800003b8:	41c70713          	addi	a4,a4,1052 # 800137d0 <cons>
    800003bc:	0a072783          	lw	a5,160(a4)
    800003c0:	09c72703          	lw	a4,156(a4)
    800003c4:	f0f70de3          	beq	a4,a5,800002de <consoleintr+0x32>
      cons.e--;
    800003c8:	37fd                	addiw	a5,a5,-1
    800003ca:	00013717          	auipc	a4,0x13
    800003ce:	4af72323          	sw	a5,1190(a4) # 80013870 <cons+0xa0>
      consputc(BACKSPACE);
    800003d2:	10000513          	li	a0,256
    800003d6:	ea5ff0ef          	jal	8000027a <consputc>
    800003da:	b711                	j	800002de <consoleintr+0x32>
    if(c != 0 && cons.e-cons.r < INPUT_BUF_SIZE){
    800003dc:	f00481e3          	beqz	s1,800002de <consoleintr+0x32>
    800003e0:	bf31                	j	800002fc <consoleintr+0x50>
      consputc(c);
    800003e2:	4529                	li	a0,10
    800003e4:	e97ff0ef          	jal	8000027a <consputc>
      cons.buf[cons.e++ % INPUT_BUF_SIZE] = c;
    800003e8:	00013797          	auipc	a5,0x13
    800003ec:	3e878793          	addi	a5,a5,1000 # 800137d0 <cons>
    800003f0:	0a07a703          	lw	a4,160(a5)
    800003f4:	0017069b          	addiw	a3,a4,1
    800003f8:	8636                	mv	a2,a3
    800003fa:	0ad7a023          	sw	a3,160(a5)
    800003fe:	07f77713          	andi	a4,a4,127
    80000402:	97ba                	add	a5,a5,a4
    80000404:	4729                	li	a4,10
    80000406:	00e78c23          	sb	a4,24(a5)
        cons.w = cons.e;
    8000040a:	00013797          	auipc	a5,0x13
    8000040e:	46c7a123          	sw	a2,1122(a5) # 8001386c <cons+0x9c>
        wakeup(&cons.r);
    80000412:	00013517          	auipc	a0,0x13
    80000416:	45650513          	addi	a0,a0,1110 # 80013868 <cons+0x98>
    8000041a:	262020ef          	jal	8000267c <wakeup>
    8000041e:	b5c1                	j	800002de <consoleintr+0x32>

0000000080000420 <consoleinit>:

void
consoleinit(void)
{
    80000420:	1141                	addi	sp,sp,-16
    80000422:	e406                	sd	ra,8(sp)
    80000424:	e022                	sd	s0,0(sp)
    80000426:	0800                	addi	s0,sp,16
  initlock(&cons.lock, "cons");
    80000428:	00008597          	auipc	a1,0x8
    8000042c:	bd858593          	addi	a1,a1,-1064 # 80008000 <etext>
    80000430:	00013517          	auipc	a0,0x13
    80000434:	3a050513          	addi	a0,a0,928 # 800137d0 <cons>
    80000438:	766000ef          	jal	80000b9e <initlock>

  uartinit();
    8000043c:	448000ef          	jal	80000884 <uartinit>

  // connect read and write system calls
  // to consoleread and consolewrite.
  devsw[CONSOLE].read = consoleread;
    80000440:	02265797          	auipc	a5,0x2265
    80000444:	f0078793          	addi	a5,a5,-256 # 82265340 <devsw>
    80000448:	00000717          	auipc	a4,0x0
    8000044c:	d2e70713          	addi	a4,a4,-722 # 80000176 <consoleread>
    80000450:	eb98                	sd	a4,16(a5)
  devsw[CONSOLE].write = consolewrite;
    80000452:	00000717          	auipc	a4,0x0
    80000456:	c8270713          	addi	a4,a4,-894 # 800000d4 <consolewrite>
    8000045a:	ef98                	sd	a4,24(a5)
}
    8000045c:	60a2                	ld	ra,8(sp)
    8000045e:	6402                	ld	s0,0(sp)
    80000460:	0141                	addi	sp,sp,16
    80000462:	8082                	ret

0000000080000464 <printint>:

static char digits[] = "0123456789abcdef";

static void
printint(long long xx, int base, int sign)
{
    80000464:	7139                	addi	sp,sp,-64
    80000466:	fc06                	sd	ra,56(sp)
    80000468:	f822                	sd	s0,48(sp)
    8000046a:	f04a                	sd	s2,32(sp)
    8000046c:	0080                	addi	s0,sp,64
  char buf[20];
  int i;
  unsigned long long x;

  if(sign && (sign = (xx < 0)))
    8000046e:	c219                	beqz	a2,80000474 <printint+0x10>
    80000470:	08054163          	bltz	a0,800004f2 <printint+0x8e>
    x = -xx;
  else
    x = xx;
    80000474:	4301                	li	t1,0

  i = 0;
    80000476:	fc840913          	addi	s2,s0,-56
    x = xx;
    8000047a:	86ca                	mv	a3,s2
  i = 0;
    8000047c:	4701                	li	a4,0
  do {
    buf[i++] = digits[x % base];
    8000047e:	00008817          	auipc	a6,0x8
    80000482:	5d280813          	addi	a6,a6,1490 # 80008a50 <digits>
    80000486:	88ba                	mv	a7,a4
    80000488:	0017061b          	addiw	a2,a4,1
    8000048c:	8732                	mv	a4,a2
    8000048e:	02b577b3          	remu	a5,a0,a1
    80000492:	97c2                	add	a5,a5,a6
    80000494:	0007c783          	lbu	a5,0(a5)
    80000498:	00f68023          	sb	a5,0(a3)
  } while((x /= base) != 0);
    8000049c:	87aa                	mv	a5,a0
    8000049e:	02b55533          	divu	a0,a0,a1
    800004a2:	0685                	addi	a3,a3,1
    800004a4:	feb7f1e3          	bgeu	a5,a1,80000486 <printint+0x22>

  if(sign)
    800004a8:	00030c63          	beqz	t1,800004c0 <printint+0x5c>
    buf[i++] = '-';
    800004ac:	fe060793          	addi	a5,a2,-32
    800004b0:	00878633          	add	a2,a5,s0
    800004b4:	02d00793          	li	a5,45
    800004b8:	fef60423          	sb	a5,-24(a2)
    800004bc:	0028871b          	addiw	a4,a7,2

  while(--i >= 0)
    800004c0:	02e05463          	blez	a4,800004e8 <printint+0x84>
    800004c4:	f426                	sd	s1,40(sp)
    800004c6:	377d                	addiw	a4,a4,-1
    800004c8:	00e904b3          	add	s1,s2,a4
    800004cc:	197d                	addi	s2,s2,-1
    800004ce:	993a                	add	s2,s2,a4
    800004d0:	1702                	slli	a4,a4,0x20
    800004d2:	9301                	srli	a4,a4,0x20
    800004d4:	40e90933          	sub	s2,s2,a4
    consputc(buf[i]);
    800004d8:	0004c503          	lbu	a0,0(s1)
    800004dc:	d9fff0ef          	jal	8000027a <consputc>
  while(--i >= 0)
    800004e0:	14fd                	addi	s1,s1,-1
    800004e2:	ff249be3          	bne	s1,s2,800004d8 <printint+0x74>
    800004e6:	74a2                	ld	s1,40(sp)
}
    800004e8:	70e2                	ld	ra,56(sp)
    800004ea:	7442                	ld	s0,48(sp)
    800004ec:	7902                	ld	s2,32(sp)
    800004ee:	6121                	addi	sp,sp,64
    800004f0:	8082                	ret
    x = -xx;
    800004f2:	40a00533          	neg	a0,a0
  if(sign && (sign = (xx < 0)))
    800004f6:	4305                	li	t1,1
    x = -xx;
    800004f8:	bfbd                	j	80000476 <printint+0x12>

00000000800004fa <printf>:
}

// Print to the console.
int
printf(char *fmt, ...)
{
    800004fa:	7131                	addi	sp,sp,-192
    800004fc:	fc86                	sd	ra,120(sp)
    800004fe:	f8a2                	sd	s0,112(sp)
    80000500:	f0ca                	sd	s2,96(sp)
    80000502:	0100                	addi	s0,sp,128
    80000504:	892a                	mv	s2,a0
    80000506:	e40c                	sd	a1,8(s0)
    80000508:	e810                	sd	a2,16(s0)
    8000050a:	ec14                	sd	a3,24(s0)
    8000050c:	f018                	sd	a4,32(s0)
    8000050e:	f41c                	sd	a5,40(s0)
    80000510:	03043823          	sd	a6,48(s0)
    80000514:	03143c23          	sd	a7,56(s0)
  va_list ap;
  int i, cx, c0, c1, c2;
  char *s;

  if(panicking == 0)
    80000518:	0000b797          	auipc	a5,0xb
    8000051c:	28c7a783          	lw	a5,652(a5) # 8000b7a4 <panicking>
    80000520:	cf9d                	beqz	a5,8000055e <printf+0x64>
    acquire(&pr.lock);

  va_start(ap, fmt);
    80000522:	00840793          	addi	a5,s0,8
    80000526:	f8f43423          	sd	a5,-120(s0)
  for(i = 0; (cx = fmt[i] & 0xff) != 0; i++){
    8000052a:	00094503          	lbu	a0,0(s2)
    8000052e:	22050663          	beqz	a0,8000075a <printf+0x260>
    80000532:	f4a6                	sd	s1,104(sp)
    80000534:	ecce                	sd	s3,88(sp)
    80000536:	e8d2                	sd	s4,80(sp)
    80000538:	e4d6                	sd	s5,72(sp)
    8000053a:	e0da                	sd	s6,64(sp)
    8000053c:	fc5e                	sd	s7,56(sp)
    8000053e:	f862                	sd	s8,48(sp)
    80000540:	f06a                	sd	s10,32(sp)
    80000542:	ec6e                	sd	s11,24(sp)
    80000544:	4a01                	li	s4,0
    if(cx != '%'){
    80000546:	02500993          	li	s3,37
      printint(va_arg(ap, uint64), 10, 1);
      i += 1;
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
      printint(va_arg(ap, uint64), 10, 1);
      i += 2;
    } else if(c0 == 'u'){
    8000054a:	07500c13          	li	s8,117
      printint(va_arg(ap, uint64), 10, 0);
      i += 1;
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
      printint(va_arg(ap, uint64), 10, 0);
      i += 2;
    } else if(c0 == 'x'){
    8000054e:	07800d13          	li	s10,120
      printint(va_arg(ap, uint64), 16, 0);
      i += 1;
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
      printint(va_arg(ap, uint64), 16, 0);
      i += 2;
    } else if(c0 == 'p'){
    80000552:	07000d93          	li	s11,112
      printint(va_arg(ap, uint64), 10, 0);
    80000556:	4b29                	li	s6,10
    if(c0 == 'd'){
    80000558:	06400b93          	li	s7,100
    8000055c:	a015                	j	80000580 <printf+0x86>
    acquire(&pr.lock);
    8000055e:	00013517          	auipc	a0,0x13
    80000562:	31a50513          	addi	a0,a0,794 # 80013878 <pr>
    80000566:	6c2000ef          	jal	80000c28 <acquire>
    8000056a:	bf65                	j	80000522 <printf+0x28>
      consputc(cx);
    8000056c:	d0fff0ef          	jal	8000027a <consputc>
      continue;
    80000570:	84d2                	mv	s1,s4
  for(i = 0; (cx = fmt[i] & 0xff) != 0; i++){
    80000572:	2485                	addiw	s1,s1,1
    80000574:	8a26                	mv	s4,s1
    80000576:	94ca                	add	s1,s1,s2
    80000578:	0004c503          	lbu	a0,0(s1)
    8000057c:	1c050663          	beqz	a0,80000748 <printf+0x24e>
    if(cx != '%'){
    80000580:	ff3516e3          	bne	a0,s3,8000056c <printf+0x72>
    i++;
    80000584:	001a079b          	addiw	a5,s4,1
    80000588:	84be                	mv	s1,a5
    c0 = fmt[i+0] & 0xff;
    8000058a:	00f90733          	add	a4,s2,a5
    8000058e:	00074a83          	lbu	s5,0(a4)
    if(c0) c1 = fmt[i+1] & 0xff;
    80000592:	200a8963          	beqz	s5,800007a4 <printf+0x2aa>
    80000596:	00174683          	lbu	a3,1(a4)
    if(c1) c2 = fmt[i+2] & 0xff;
    8000059a:	1e068c63          	beqz	a3,80000792 <printf+0x298>
    if(c0 == 'd'){
    8000059e:	037a8863          	beq	s5,s7,800005ce <printf+0xd4>
    } else if(c0 == 'l' && c1 == 'd'){
    800005a2:	f94a8713          	addi	a4,s5,-108
    800005a6:	00173713          	seqz	a4,a4
    800005aa:	f9c68613          	addi	a2,a3,-100
    800005ae:	ee05                	bnez	a2,800005e6 <printf+0xec>
    800005b0:	cb1d                	beqz	a4,800005e6 <printf+0xec>
      printint(va_arg(ap, uint64), 10, 1);
    800005b2:	f8843783          	ld	a5,-120(s0)
    800005b6:	00878713          	addi	a4,a5,8
    800005ba:	f8e43423          	sd	a4,-120(s0)
    800005be:	4605                	li	a2,1
    800005c0:	85da                	mv	a1,s6
    800005c2:	6388                	ld	a0,0(a5)
    800005c4:	ea1ff0ef          	jal	80000464 <printint>
      i += 1;
    800005c8:	002a049b          	addiw	s1,s4,2
    800005cc:	b75d                	j	80000572 <printf+0x78>
      printint(va_arg(ap, int), 10, 1);
    800005ce:	f8843783          	ld	a5,-120(s0)
    800005d2:	00878713          	addi	a4,a5,8
    800005d6:	f8e43423          	sd	a4,-120(s0)
    800005da:	4605                	li	a2,1
    800005dc:	85da                	mv	a1,s6
    800005de:	4388                	lw	a0,0(a5)
    800005e0:	e85ff0ef          	jal	80000464 <printint>
    800005e4:	b779                	j	80000572 <printf+0x78>
    if(c1) c2 = fmt[i+2] & 0xff;
    800005e6:	97ca                	add	a5,a5,s2
    800005e8:	8636                	mv	a2,a3
    800005ea:	0027c683          	lbu	a3,2(a5)
    800005ee:	a2c9                	j	800007b0 <printf+0x2b6>
      printint(va_arg(ap, uint64), 10, 1);
    800005f0:	f8843783          	ld	a5,-120(s0)
    800005f4:	00878713          	addi	a4,a5,8
    800005f8:	f8e43423          	sd	a4,-120(s0)
    800005fc:	4605                	li	a2,1
    800005fe:	45a9                	li	a1,10
    80000600:	6388                	ld	a0,0(a5)
    80000602:	e63ff0ef          	jal	80000464 <printint>
      i += 2;
    80000606:	003a049b          	addiw	s1,s4,3
    8000060a:	b7a5                	j	80000572 <printf+0x78>
      printint(va_arg(ap, uint32), 10, 0);
    8000060c:	f8843783          	ld	a5,-120(s0)
    80000610:	00878713          	addi	a4,a5,8
    80000614:	f8e43423          	sd	a4,-120(s0)
    80000618:	4601                	li	a2,0
    8000061a:	85da                	mv	a1,s6
    8000061c:	0007e503          	lwu	a0,0(a5)
    80000620:	e45ff0ef          	jal	80000464 <printint>
    80000624:	b7b9                	j	80000572 <printf+0x78>
      printint(va_arg(ap, uint64), 10, 0);
    80000626:	f8843783          	ld	a5,-120(s0)
    8000062a:	00878713          	addi	a4,a5,8
    8000062e:	f8e43423          	sd	a4,-120(s0)
    80000632:	4601                	li	a2,0
    80000634:	85da                	mv	a1,s6
    80000636:	6388                	ld	a0,0(a5)
    80000638:	e2dff0ef          	jal	80000464 <printint>
      i += 1;
    8000063c:	002a049b          	addiw	s1,s4,2
    80000640:	bf0d                	j	80000572 <printf+0x78>
      printint(va_arg(ap, uint64), 10, 0);
    80000642:	f8843783          	ld	a5,-120(s0)
    80000646:	00878713          	addi	a4,a5,8
    8000064a:	f8e43423          	sd	a4,-120(s0)
    8000064e:	4601                	li	a2,0
    80000650:	45a9                	li	a1,10
    80000652:	6388                	ld	a0,0(a5)
    80000654:	e11ff0ef          	jal	80000464 <printint>
      i += 2;
    80000658:	003a049b          	addiw	s1,s4,3
    8000065c:	bf19                	j	80000572 <printf+0x78>
      printint(va_arg(ap, uint32), 16, 0);
    8000065e:	f8843783          	ld	a5,-120(s0)
    80000662:	00878713          	addi	a4,a5,8
    80000666:	f8e43423          	sd	a4,-120(s0)
    8000066a:	4601                	li	a2,0
    8000066c:	45c1                	li	a1,16
    8000066e:	0007e503          	lwu	a0,0(a5)
    80000672:	df3ff0ef          	jal	80000464 <printint>
    80000676:	bdf5                	j	80000572 <printf+0x78>
      printint(va_arg(ap, uint64), 16, 0);
    80000678:	f8843783          	ld	a5,-120(s0)
    8000067c:	00878713          	addi	a4,a5,8
    80000680:	f8e43423          	sd	a4,-120(s0)
    80000684:	45c1                	li	a1,16
    80000686:	6388                	ld	a0,0(a5)
    80000688:	dddff0ef          	jal	80000464 <printint>
      i += 1;
    8000068c:	002a049b          	addiw	s1,s4,2
    80000690:	b5cd                	j	80000572 <printf+0x78>
      printint(va_arg(ap, uint64), 16, 0);
    80000692:	f8843783          	ld	a5,-120(s0)
    80000696:	00878713          	addi	a4,a5,8
    8000069a:	f8e43423          	sd	a4,-120(s0)
    8000069e:	4601                	li	a2,0
    800006a0:	45c1                	li	a1,16
    800006a2:	6388                	ld	a0,0(a5)
    800006a4:	dc1ff0ef          	jal	80000464 <printint>
      i += 2;
    800006a8:	003a049b          	addiw	s1,s4,3
    800006ac:	b5d9                	j	80000572 <printf+0x78>
    800006ae:	f466                	sd	s9,40(sp)
      printptr(va_arg(ap, uint64));
    800006b0:	f8843783          	ld	a5,-120(s0)
    800006b4:	00878713          	addi	a4,a5,8
    800006b8:	f8e43423          	sd	a4,-120(s0)
    800006bc:	0007ba83          	ld	s5,0(a5)
  consputc('0');
    800006c0:	03000513          	li	a0,48
    800006c4:	bb7ff0ef          	jal	8000027a <consputc>
  consputc('x');
    800006c8:	07800513          	li	a0,120
    800006cc:	bafff0ef          	jal	8000027a <consputc>
    800006d0:	4a41                	li	s4,16
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    800006d2:	00008c97          	auipc	s9,0x8
    800006d6:	37ec8c93          	addi	s9,s9,894 # 80008a50 <digits>
    800006da:	03cad793          	srli	a5,s5,0x3c
    800006de:	97e6                	add	a5,a5,s9
    800006e0:	0007c503          	lbu	a0,0(a5)
    800006e4:	b97ff0ef          	jal	8000027a <consputc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
    800006e8:	0a92                	slli	s5,s5,0x4
    800006ea:	3a7d                	addiw	s4,s4,-1
    800006ec:	fe0a17e3          	bnez	s4,800006da <printf+0x1e0>
    800006f0:	7ca2                	ld	s9,40(sp)
    800006f2:	b541                	j	80000572 <printf+0x78>
    } else if(c0 == 'c'){
      consputc(va_arg(ap, uint));
    800006f4:	f8843783          	ld	a5,-120(s0)
    800006f8:	00878713          	addi	a4,a5,8
    800006fc:	f8e43423          	sd	a4,-120(s0)
    80000700:	4388                	lw	a0,0(a5)
    80000702:	b79ff0ef          	jal	8000027a <consputc>
    80000706:	b5b5                	j	80000572 <printf+0x78>
    } else if(c0 == 's'){
      if((s = va_arg(ap, char*)) == 0)
    80000708:	f8843783          	ld	a5,-120(s0)
    8000070c:	00878713          	addi	a4,a5,8
    80000710:	f8e43423          	sd	a4,-120(s0)
    80000714:	0007ba03          	ld	s4,0(a5)
    80000718:	000a0d63          	beqz	s4,80000732 <printf+0x238>
        s = "(null)";
      for(; *s; s++)
    8000071c:	000a4503          	lbu	a0,0(s4)
    80000720:	e40509e3          	beqz	a0,80000572 <printf+0x78>
        consputc(*s);
    80000724:	b57ff0ef          	jal	8000027a <consputc>
      for(; *s; s++)
    80000728:	0a05                	addi	s4,s4,1
    8000072a:	000a4503          	lbu	a0,0(s4)
    8000072e:	f97d                	bnez	a0,80000724 <printf+0x22a>
    80000730:	b589                	j	80000572 <printf+0x78>
        s = "(null)";
    80000732:	00008a17          	auipc	s4,0x8
    80000736:	8d6a0a13          	addi	s4,s4,-1834 # 80008008 <etext+0x8>
      for(; *s; s++)
    8000073a:	02800513          	li	a0,40
    8000073e:	b7dd                	j	80000724 <printf+0x22a>
    } else if(c0 == '%'){
      consputc('%');
    80000740:	8556                	mv	a0,s5
    80000742:	b39ff0ef          	jal	8000027a <consputc>
    80000746:	b535                	j	80000572 <printf+0x78>
    80000748:	74a6                	ld	s1,104(sp)
    8000074a:	69e6                	ld	s3,88(sp)
    8000074c:	6a46                	ld	s4,80(sp)
    8000074e:	6aa6                	ld	s5,72(sp)
    80000750:	6b06                	ld	s6,64(sp)
    80000752:	7be2                	ld	s7,56(sp)
    80000754:	7c42                	ld	s8,48(sp)
    80000756:	7d02                	ld	s10,32(sp)
    80000758:	6de2                	ld	s11,24(sp)
    }

  }
  va_end(ap);

  if(panicking == 0)
    8000075a:	0000b797          	auipc	a5,0xb
    8000075e:	04a7a783          	lw	a5,74(a5) # 8000b7a4 <panicking>
    80000762:	c38d                	beqz	a5,80000784 <printf+0x28a>
    release(&pr.lock);

  return 0;
}
    80000764:	4501                	li	a0,0
    80000766:	70e6                	ld	ra,120(sp)
    80000768:	7446                	ld	s0,112(sp)
    8000076a:	7906                	ld	s2,96(sp)
    8000076c:	6129                	addi	sp,sp,192
    8000076e:	8082                	ret
    80000770:	74a6                	ld	s1,104(sp)
    80000772:	69e6                	ld	s3,88(sp)
    80000774:	6a46                	ld	s4,80(sp)
    80000776:	6aa6                	ld	s5,72(sp)
    80000778:	6b06                	ld	s6,64(sp)
    8000077a:	7be2                	ld	s7,56(sp)
    8000077c:	7c42                	ld	s8,48(sp)
    8000077e:	7d02                	ld	s10,32(sp)
    80000780:	6de2                	ld	s11,24(sp)
    80000782:	bfe1                	j	8000075a <printf+0x260>
    release(&pr.lock);
    80000784:	00013517          	auipc	a0,0x13
    80000788:	0f450513          	addi	a0,a0,244 # 80013878 <pr>
    8000078c:	530000ef          	jal	80000cbc <release>
  return 0;
    80000790:	bfd1                	j	80000764 <printf+0x26a>
    if(c0 == 'd'){
    80000792:	e37a8ee3          	beq	s5,s7,800005ce <printf+0xd4>
    } else if(c0 == 'l' && c1 == 'd'){
    80000796:	f94a8713          	addi	a4,s5,-108
    8000079a:	00173713          	seqz	a4,a4
    8000079e:	8636                	mv	a2,a3
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
    800007a0:	4781                	li	a5,0
    800007a2:	a00d                	j	800007c4 <printf+0x2ca>
    } else if(c0 == 'l' && c1 == 'd'){
    800007a4:	f94a8713          	addi	a4,s5,-108
    800007a8:	00173713          	seqz	a4,a4
    c1 = c2 = 0;
    800007ac:	8656                	mv	a2,s5
    800007ae:	86d6                	mv	a3,s5
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
    800007b0:	f9460793          	addi	a5,a2,-108
    800007b4:	0017b793          	seqz	a5,a5
    800007b8:	8ff9                	and	a5,a5,a4
    800007ba:	f9c68593          	addi	a1,a3,-100
    800007be:	e199                	bnez	a1,800007c4 <printf+0x2ca>
    800007c0:	e20798e3          	bnez	a5,800005f0 <printf+0xf6>
    } else if(c0 == 'u'){
    800007c4:	e58a84e3          	beq	s5,s8,8000060c <printf+0x112>
    } else if(c0 == 'l' && c1 == 'u'){
    800007c8:	f8b60593          	addi	a1,a2,-117
    800007cc:	e199                	bnez	a1,800007d2 <printf+0x2d8>
    800007ce:	e4071ce3          	bnez	a4,80000626 <printf+0x12c>
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
    800007d2:	f8b68593          	addi	a1,a3,-117
    800007d6:	e199                	bnez	a1,800007dc <printf+0x2e2>
    800007d8:	e60795e3          	bnez	a5,80000642 <printf+0x148>
    } else if(c0 == 'x'){
    800007dc:	e9aa81e3          	beq	s5,s10,8000065e <printf+0x164>
    } else if(c0 == 'l' && c1 == 'x'){
    800007e0:	f8860613          	addi	a2,a2,-120
    800007e4:	e219                	bnez	a2,800007ea <printf+0x2f0>
    800007e6:	e80719e3          	bnez	a4,80000678 <printf+0x17e>
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
    800007ea:	f8868693          	addi	a3,a3,-120
    800007ee:	e299                	bnez	a3,800007f4 <printf+0x2fa>
    800007f0:	ea0791e3          	bnez	a5,80000692 <printf+0x198>
    } else if(c0 == 'p'){
    800007f4:	ebba8de3          	beq	s5,s11,800006ae <printf+0x1b4>
    } else if(c0 == 'c'){
    800007f8:	06300793          	li	a5,99
    800007fc:	eefa8ce3          	beq	s5,a5,800006f4 <printf+0x1fa>
    } else if(c0 == 's'){
    80000800:	07300793          	li	a5,115
    80000804:	f0fa82e3          	beq	s5,a5,80000708 <printf+0x20e>
    } else if(c0 == '%'){
    80000808:	02500793          	li	a5,37
    8000080c:	f2fa8ae3          	beq	s5,a5,80000740 <printf+0x246>
    } else if(c0 == 0){
    80000810:	f60a80e3          	beqz	s5,80000770 <printf+0x276>
      consputc('%');
    80000814:	02500513          	li	a0,37
    80000818:	a63ff0ef          	jal	8000027a <consputc>
      consputc(c0);
    8000081c:	8556                	mv	a0,s5
    8000081e:	a5dff0ef          	jal	8000027a <consputc>
    80000822:	bb81                	j	80000572 <printf+0x78>

0000000080000824 <panic>:

void
panic(char *s)
{
    80000824:	1101                	addi	sp,sp,-32
    80000826:	ec06                	sd	ra,24(sp)
    80000828:	e822                	sd	s0,16(sp)
    8000082a:	e426                	sd	s1,8(sp)
    8000082c:	e04a                	sd	s2,0(sp)
    8000082e:	1000                	addi	s0,sp,32
    80000830:	892a                	mv	s2,a0
  panicking = 1;
    80000832:	4485                	li	s1,1
    80000834:	0000b797          	auipc	a5,0xb
    80000838:	f697a823          	sw	s1,-144(a5) # 8000b7a4 <panicking>
  printf("panic: ");
    8000083c:	00007517          	auipc	a0,0x7
    80000840:	7dc50513          	addi	a0,a0,2012 # 80008018 <etext+0x18>
    80000844:	cb7ff0ef          	jal	800004fa <printf>
  printf("%s\n", s);
    80000848:	85ca                	mv	a1,s2
    8000084a:	00007517          	auipc	a0,0x7
    8000084e:	7d650513          	addi	a0,a0,2006 # 80008020 <etext+0x20>
    80000852:	ca9ff0ef          	jal	800004fa <printf>
  panicked = 1; // freeze uart output from other CPUs
    80000856:	0000b797          	auipc	a5,0xb
    8000085a:	f497a523          	sw	s1,-182(a5) # 8000b7a0 <panicked>
  for(;;)
    8000085e:	a001                	j	8000085e <panic+0x3a>

0000000080000860 <printfinit>:
    ;
}

void
printfinit(void)
{
    80000860:	1141                	addi	sp,sp,-16
    80000862:	e406                	sd	ra,8(sp)
    80000864:	e022                	sd	s0,0(sp)
    80000866:	0800                	addi	s0,sp,16
  initlock(&pr.lock, "pr");
    80000868:	00007597          	auipc	a1,0x7
    8000086c:	7c058593          	addi	a1,a1,1984 # 80008028 <etext+0x28>
    80000870:	00013517          	auipc	a0,0x13
    80000874:	00850513          	addi	a0,a0,8 # 80013878 <pr>
    80000878:	326000ef          	jal	80000b9e <initlock>
}
    8000087c:	60a2                	ld	ra,8(sp)
    8000087e:	6402                	ld	s0,0(sp)
    80000880:	0141                	addi	sp,sp,16
    80000882:	8082                	ret

0000000080000884 <uartinit>:
extern volatile int panicking; // from printf.c
extern volatile int panicked; // from printf.c

void
uartinit(void)
{
    80000884:	1141                	addi	sp,sp,-16
    80000886:	e406                	sd	ra,8(sp)
    80000888:	e022                	sd	s0,0(sp)
    8000088a:	0800                	addi	s0,sp,16
  // disable interrupts.
  WriteReg(IER, 0x00);
    8000088c:	100007b7          	lui	a5,0x10000
    80000890:	000780a3          	sb	zero,1(a5) # 10000001 <_entry-0x6fffffff>

  // special mode to set baud rate.
  WriteReg(LCR, LCR_BAUD_LATCH);
    80000894:	10000737          	lui	a4,0x10000
    80000898:	f8000693          	li	a3,-128
    8000089c:	00d701a3          	sb	a3,3(a4) # 10000003 <_entry-0x6ffffffd>

  // LSB for baud rate of 38.4K.
  WriteReg(0, 0x03);
    800008a0:	468d                	li	a3,3
    800008a2:	10000637          	lui	a2,0x10000
    800008a6:	00d60023          	sb	a3,0(a2) # 10000000 <_entry-0x70000000>

  // MSB for baud rate of 38.4K.
  WriteReg(1, 0x00);
    800008aa:	000780a3          	sb	zero,1(a5)

  // leave set-baud mode,
  // and set word length to 8 bits, no parity.
  WriteReg(LCR, LCR_EIGHT_BITS);
    800008ae:	00d701a3          	sb	a3,3(a4)

  // reset and enable FIFOs.
  WriteReg(FCR, FCR_FIFO_ENABLE | FCR_FIFO_CLEAR);
    800008b2:	8732                	mv	a4,a2
    800008b4:	461d                	li	a2,7
    800008b6:	00c70123          	sb	a2,2(a4)

  // enable transmit and receive interrupts.
  WriteReg(IER, IER_TX_ENABLE | IER_RX_ENABLE);
    800008ba:	00d780a3          	sb	a3,1(a5)

  initlock(&tx_lock, "uart");
    800008be:	00007597          	auipc	a1,0x7
    800008c2:	77258593          	addi	a1,a1,1906 # 80008030 <etext+0x30>
    800008c6:	00013517          	auipc	a0,0x13
    800008ca:	fca50513          	addi	a0,a0,-54 # 80013890 <tx_lock>
    800008ce:	2d0000ef          	jal	80000b9e <initlock>
}
    800008d2:	60a2                	ld	ra,8(sp)
    800008d4:	6402                	ld	s0,0(sp)
    800008d6:	0141                	addi	sp,sp,16
    800008d8:	8082                	ret

00000000800008da <uartwrite>:
// transmit buf[] to the uart. it blocks if the
// uart is busy, so it cannot be called from
// interrupts, only from write() system calls.
void
uartwrite(char buf[], int n)
{
    800008da:	715d                	addi	sp,sp,-80
    800008dc:	e486                	sd	ra,72(sp)
    800008de:	e0a2                	sd	s0,64(sp)
    800008e0:	fc26                	sd	s1,56(sp)
    800008e2:	ec56                	sd	s5,24(sp)
    800008e4:	0880                	addi	s0,sp,80
    800008e6:	8aaa                	mv	s5,a0
    800008e8:	84ae                	mv	s1,a1
  acquire(&tx_lock);
    800008ea:	00013517          	auipc	a0,0x13
    800008ee:	fa650513          	addi	a0,a0,-90 # 80013890 <tx_lock>
    800008f2:	336000ef          	jal	80000c28 <acquire>

  int i = 0;
  while(i < n){ 
    800008f6:	06905063          	blez	s1,80000956 <uartwrite+0x7c>
    800008fa:	f84a                	sd	s2,48(sp)
    800008fc:	f44e                	sd	s3,40(sp)
    800008fe:	f052                	sd	s4,32(sp)
    80000900:	e85a                	sd	s6,16(sp)
    80000902:	e45e                	sd	s7,8(sp)
    80000904:	8a56                	mv	s4,s5
    80000906:	9aa6                	add	s5,s5,s1
    while(tx_busy != 0){
    80000908:	0000b497          	auipc	s1,0xb
    8000090c:	ea448493          	addi	s1,s1,-348 # 8000b7ac <tx_busy>
      // wait for a UART transmit-complete interrupt
      // to set tx_busy to 0.
      sleep(&tx_chan, &tx_lock);
    80000910:	00013997          	auipc	s3,0x13
    80000914:	f8098993          	addi	s3,s3,-128 # 80013890 <tx_lock>
    80000918:	0000b917          	auipc	s2,0xb
    8000091c:	e9090913          	addi	s2,s2,-368 # 8000b7a8 <tx_chan>
    }   
      
    WriteReg(THR, buf[i]);
    80000920:	10000bb7          	lui	s7,0x10000
    i += 1;
    tx_busy = 1;
    80000924:	4b05                	li	s6,1
    80000926:	a005                	j	80000946 <uartwrite+0x6c>
      sleep(&tx_chan, &tx_lock);
    80000928:	85ce                	mv	a1,s3
    8000092a:	854a                	mv	a0,s2
    8000092c:	505010ef          	jal	80002630 <sleep>
    while(tx_busy != 0){
    80000930:	409c                	lw	a5,0(s1)
    80000932:	fbfd                	bnez	a5,80000928 <uartwrite+0x4e>
    WriteReg(THR, buf[i]);
    80000934:	000a4783          	lbu	a5,0(s4)
    80000938:	00fb8023          	sb	a5,0(s7) # 10000000 <_entry-0x70000000>
    tx_busy = 1;
    8000093c:	0164a023          	sw	s6,0(s1)
  while(i < n){ 
    80000940:	0a05                	addi	s4,s4,1
    80000942:	015a0563          	beq	s4,s5,8000094c <uartwrite+0x72>
    while(tx_busy != 0){
    80000946:	409c                	lw	a5,0(s1)
    80000948:	f3e5                	bnez	a5,80000928 <uartwrite+0x4e>
    8000094a:	b7ed                	j	80000934 <uartwrite+0x5a>
    8000094c:	7942                	ld	s2,48(sp)
    8000094e:	79a2                	ld	s3,40(sp)
    80000950:	7a02                	ld	s4,32(sp)
    80000952:	6b42                	ld	s6,16(sp)
    80000954:	6ba2                	ld	s7,8(sp)
  }

  release(&tx_lock);
    80000956:	00013517          	auipc	a0,0x13
    8000095a:	f3a50513          	addi	a0,a0,-198 # 80013890 <tx_lock>
    8000095e:	35e000ef          	jal	80000cbc <release>
}
    80000962:	60a6                	ld	ra,72(sp)
    80000964:	6406                	ld	s0,64(sp)
    80000966:	74e2                	ld	s1,56(sp)
    80000968:	6ae2                	ld	s5,24(sp)
    8000096a:	6161                	addi	sp,sp,80
    8000096c:	8082                	ret

000000008000096e <uartputc_sync>:
// interrupts, for use by kernel printf() and
// to echo characters. it spins waiting for the uart's
// output register to be empty.
void
uartputc_sync(int c)
{
    8000096e:	1101                	addi	sp,sp,-32
    80000970:	ec06                	sd	ra,24(sp)
    80000972:	e822                	sd	s0,16(sp)
    80000974:	e426                	sd	s1,8(sp)
    80000976:	1000                	addi	s0,sp,32
    80000978:	84aa                	mv	s1,a0
  if(panicking == 0)
    8000097a:	0000b797          	auipc	a5,0xb
    8000097e:	e2a7a783          	lw	a5,-470(a5) # 8000b7a4 <panicking>
    80000982:	cf95                	beqz	a5,800009be <uartputc_sync+0x50>
    push_off();

  if(panicked){
    80000984:	0000b797          	auipc	a5,0xb
    80000988:	e1c7a783          	lw	a5,-484(a5) # 8000b7a0 <panicked>
    8000098c:	ef85                	bnez	a5,800009c4 <uartputc_sync+0x56>
    for(;;)
      ;
  }

  // wait for Transmit Holding Empty to be set in LSR.
  while((ReadReg(LSR) & LSR_TX_IDLE) == 0)
    8000098e:	10000737          	lui	a4,0x10000
    80000992:	0715                	addi	a4,a4,5 # 10000005 <_entry-0x6ffffffb>
    80000994:	00074783          	lbu	a5,0(a4)
    80000998:	0207f793          	andi	a5,a5,32
    8000099c:	dfe5                	beqz	a5,80000994 <uartputc_sync+0x26>
    ;
  WriteReg(THR, c);
    8000099e:	0ff4f513          	zext.b	a0,s1
    800009a2:	100007b7          	lui	a5,0x10000
    800009a6:	00a78023          	sb	a0,0(a5) # 10000000 <_entry-0x70000000>

  if(panicking == 0)
    800009aa:	0000b797          	auipc	a5,0xb
    800009ae:	dfa7a783          	lw	a5,-518(a5) # 8000b7a4 <panicking>
    800009b2:	cb91                	beqz	a5,800009c6 <uartputc_sync+0x58>
    pop_off();
}
    800009b4:	60e2                	ld	ra,24(sp)
    800009b6:	6442                	ld	s0,16(sp)
    800009b8:	64a2                	ld	s1,8(sp)
    800009ba:	6105                	addi	sp,sp,32
    800009bc:	8082                	ret
    push_off();
    800009be:	226000ef          	jal	80000be4 <push_off>
    800009c2:	b7c9                	j	80000984 <uartputc_sync+0x16>
    for(;;)
    800009c4:	a001                	j	800009c4 <uartputc_sync+0x56>
    pop_off();
    800009c6:	2a6000ef          	jal	80000c6c <pop_off>
}
    800009ca:	b7ed                	j	800009b4 <uartputc_sync+0x46>

00000000800009cc <uartgetc>:

// read one input character from the UART.
// return -1 if none is waiting.
int
uartgetc(void)
{
    800009cc:	1141                	addi	sp,sp,-16
    800009ce:	e406                	sd	ra,8(sp)
    800009d0:	e022                	sd	s0,0(sp)
    800009d2:	0800                	addi	s0,sp,16
  if(ReadReg(LSR) & LSR_RX_READY){
    800009d4:	100007b7          	lui	a5,0x10000
    800009d8:	0057c783          	lbu	a5,5(a5) # 10000005 <_entry-0x6ffffffb>
    800009dc:	8b85                	andi	a5,a5,1
    800009de:	cb89                	beqz	a5,800009f0 <uartgetc+0x24>
    // input data is ready.
    return ReadReg(RHR);
    800009e0:	100007b7          	lui	a5,0x10000
    800009e4:	0007c503          	lbu	a0,0(a5) # 10000000 <_entry-0x70000000>
  } else {
    return -1;
  }
}
    800009e8:	60a2                	ld	ra,8(sp)
    800009ea:	6402                	ld	s0,0(sp)
    800009ec:	0141                	addi	sp,sp,16
    800009ee:	8082                	ret
    return -1;
    800009f0:	557d                	li	a0,-1
    800009f2:	bfdd                	j	800009e8 <uartgetc+0x1c>

00000000800009f4 <uartintr>:
// handle a uart interrupt, raised because input has
// arrived, or the uart is ready for more output, or
// both. called from devintr().
void
uartintr(void)
{
    800009f4:	1101                	addi	sp,sp,-32
    800009f6:	ec06                	sd	ra,24(sp)
    800009f8:	e822                	sd	s0,16(sp)
    800009fa:	e426                	sd	s1,8(sp)
    800009fc:	1000                	addi	s0,sp,32
  ReadReg(ISR); // acknowledge the interrupt
    800009fe:	100007b7          	lui	a5,0x10000
    80000a02:	0027c783          	lbu	a5,2(a5) # 10000002 <_entry-0x6ffffffe>

  acquire(&tx_lock);
    80000a06:	00013517          	auipc	a0,0x13
    80000a0a:	e8a50513          	addi	a0,a0,-374 # 80013890 <tx_lock>
    80000a0e:	21a000ef          	jal	80000c28 <acquire>
  if(ReadReg(LSR) & LSR_TX_IDLE){
    80000a12:	100007b7          	lui	a5,0x10000
    80000a16:	0057c783          	lbu	a5,5(a5) # 10000005 <_entry-0x6ffffffb>
    80000a1a:	0207f793          	andi	a5,a5,32
    80000a1e:	ef99                	bnez	a5,80000a3c <uartintr+0x48>
    // UART finished transmitting; wake up sending thread.
    tx_busy = 0;
    wakeup(&tx_chan);
  }
  release(&tx_lock);
    80000a20:	00013517          	auipc	a0,0x13
    80000a24:	e7050513          	addi	a0,a0,-400 # 80013890 <tx_lock>
    80000a28:	294000ef          	jal	80000cbc <release>

  // read and process incoming characters.
  while(1){
    int c = uartgetc();
    if(c == -1)
    80000a2c:	54fd                	li	s1,-1
    int c = uartgetc();
    80000a2e:	f9fff0ef          	jal	800009cc <uartgetc>
    if(c == -1)
    80000a32:	02950063          	beq	a0,s1,80000a52 <uartintr+0x5e>
      break;
    consoleintr(c);
    80000a36:	877ff0ef          	jal	800002ac <consoleintr>
  while(1){
    80000a3a:	bfd5                	j	80000a2e <uartintr+0x3a>
    tx_busy = 0;
    80000a3c:	0000b797          	auipc	a5,0xb
    80000a40:	d607a823          	sw	zero,-656(a5) # 8000b7ac <tx_busy>
    wakeup(&tx_chan);
    80000a44:	0000b517          	auipc	a0,0xb
    80000a48:	d6450513          	addi	a0,a0,-668 # 8000b7a8 <tx_chan>
    80000a4c:	431010ef          	jal	8000267c <wakeup>
    80000a50:	bfc1                	j	80000a20 <uartintr+0x2c>
  }
}
    80000a52:	60e2                	ld	ra,24(sp)
    80000a54:	6442                	ld	s0,16(sp)
    80000a56:	64a2                	ld	s1,8(sp)
    80000a58:	6105                	addi	sp,sp,32
    80000a5a:	8082                	ret

0000000080000a5c <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(void *pa)
{
    80000a5c:	1101                	addi	sp,sp,-32
    80000a5e:	ec06                	sd	ra,24(sp)
    80000a60:	e822                	sd	s0,16(sp)
    80000a62:	e426                	sd	s1,8(sp)
    80000a64:	e04a                	sd	s2,0(sp)
    80000a66:	1000                	addi	s0,sp,32
  struct run *r;

  if(((uint64)pa % PGSIZE) != 0 || (char*)pa < end || (uint64)pa >= PHYSTOP)
    80000a68:	02266797          	auipc	a5,0x2266
    80000a6c:	a7078793          	addi	a5,a5,-1424 # 822664d8 <end>
    80000a70:	00f53733          	sltu	a4,a0,a5
    80000a74:	47c5                	li	a5,17
    80000a76:	07ee                	slli	a5,a5,0x1b
    80000a78:	17fd                	addi	a5,a5,-1
    80000a7a:	00a7b7b3          	sltu	a5,a5,a0
    80000a7e:	8fd9                	or	a5,a5,a4
    80000a80:	ef95                	bnez	a5,80000abc <kfree+0x60>
    80000a82:	84aa                	mv	s1,a0
    80000a84:	03451793          	slli	a5,a0,0x34
    80000a88:	eb95                	bnez	a5,80000abc <kfree+0x60>
    panic("kfree");

  // Fill with junk to catch dangling refs.
  memset(pa, 1, PGSIZE);
    80000a8a:	6605                	lui	a2,0x1
    80000a8c:	4585                	li	a1,1
    80000a8e:	26a000ef          	jal	80000cf8 <memset>

  r = (struct run*)pa;

  acquire(&kmem.lock);
    80000a92:	00013917          	auipc	s2,0x13
    80000a96:	e1690913          	addi	s2,s2,-490 # 800138a8 <kmem>
    80000a9a:	854a                	mv	a0,s2
    80000a9c:	18c000ef          	jal	80000c28 <acquire>
  r->next = kmem.freelist;
    80000aa0:	01893783          	ld	a5,24(s2)
    80000aa4:	e09c                	sd	a5,0(s1)
  kmem.freelist = r;
    80000aa6:	00993c23          	sd	s1,24(s2)
  release(&kmem.lock);
    80000aaa:	854a                	mv	a0,s2
    80000aac:	210000ef          	jal	80000cbc <release>
}
    80000ab0:	60e2                	ld	ra,24(sp)
    80000ab2:	6442                	ld	s0,16(sp)
    80000ab4:	64a2                	ld	s1,8(sp)
    80000ab6:	6902                	ld	s2,0(sp)
    80000ab8:	6105                	addi	sp,sp,32
    80000aba:	8082                	ret
    panic("kfree");
    80000abc:	00007517          	auipc	a0,0x7
    80000ac0:	57c50513          	addi	a0,a0,1404 # 80008038 <etext+0x38>
    80000ac4:	d61ff0ef          	jal	80000824 <panic>

0000000080000ac8 <freerange>:
{
    80000ac8:	7179                	addi	sp,sp,-48
    80000aca:	f406                	sd	ra,40(sp)
    80000acc:	f022                	sd	s0,32(sp)
    80000ace:	ec26                	sd	s1,24(sp)
    80000ad0:	1800                	addi	s0,sp,48
  p = (char*)PGROUNDUP((uint64)pa_start);
    80000ad2:	6785                	lui	a5,0x1
    80000ad4:	fff78713          	addi	a4,a5,-1 # fff <_entry-0x7ffff001>
    80000ad8:	00e504b3          	add	s1,a0,a4
    80000adc:	777d                	lui	a4,0xfffff
    80000ade:	8cf9                	and	s1,s1,a4
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    80000ae0:	94be                	add	s1,s1,a5
    80000ae2:	0295e263          	bltu	a1,s1,80000b06 <freerange+0x3e>
    80000ae6:	e84a                	sd	s2,16(sp)
    80000ae8:	e44e                	sd	s3,8(sp)
    80000aea:	e052                	sd	s4,0(sp)
    80000aec:	892e                	mv	s2,a1
    kfree(p);
    80000aee:	8a3a                	mv	s4,a4
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    80000af0:	89be                	mv	s3,a5
    kfree(p);
    80000af2:	01448533          	add	a0,s1,s4
    80000af6:	f67ff0ef          	jal	80000a5c <kfree>
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    80000afa:	94ce                	add	s1,s1,s3
    80000afc:	fe997be3          	bgeu	s2,s1,80000af2 <freerange+0x2a>
    80000b00:	6942                	ld	s2,16(sp)
    80000b02:	69a2                	ld	s3,8(sp)
    80000b04:	6a02                	ld	s4,0(sp)
}
    80000b06:	70a2                	ld	ra,40(sp)
    80000b08:	7402                	ld	s0,32(sp)
    80000b0a:	64e2                	ld	s1,24(sp)
    80000b0c:	6145                	addi	sp,sp,48
    80000b0e:	8082                	ret

0000000080000b10 <kinit>:
{
    80000b10:	1141                	addi	sp,sp,-16
    80000b12:	e406                	sd	ra,8(sp)
    80000b14:	e022                	sd	s0,0(sp)
    80000b16:	0800                	addi	s0,sp,16
  initlock(&kmem.lock, "kmem");
    80000b18:	00007597          	auipc	a1,0x7
    80000b1c:	52858593          	addi	a1,a1,1320 # 80008040 <etext+0x40>
    80000b20:	00013517          	auipc	a0,0x13
    80000b24:	d8850513          	addi	a0,a0,-632 # 800138a8 <kmem>
    80000b28:	076000ef          	jal	80000b9e <initlock>
  freerange(end, (void*)PHYSTOP);
    80000b2c:	45c5                	li	a1,17
    80000b2e:	05ee                	slli	a1,a1,0x1b
    80000b30:	02266517          	auipc	a0,0x2266
    80000b34:	9a850513          	addi	a0,a0,-1624 # 822664d8 <end>
    80000b38:	f91ff0ef          	jal	80000ac8 <freerange>
}
    80000b3c:	60a2                	ld	ra,8(sp)
    80000b3e:	6402                	ld	s0,0(sp)
    80000b40:	0141                	addi	sp,sp,16
    80000b42:	8082                	ret

0000000080000b44 <kalloc>:
// Allocate one 4096-byte page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
void *
kalloc(void)
{
    80000b44:	1101                	addi	sp,sp,-32
    80000b46:	ec06                	sd	ra,24(sp)
    80000b48:	e822                	sd	s0,16(sp)
    80000b4a:	e426                	sd	s1,8(sp)
    80000b4c:	1000                	addi	s0,sp,32
  struct run *r;

  acquire(&kmem.lock);
    80000b4e:	00013517          	auipc	a0,0x13
    80000b52:	d5a50513          	addi	a0,a0,-678 # 800138a8 <kmem>
    80000b56:	0d2000ef          	jal	80000c28 <acquire>
  r = kmem.freelist;
    80000b5a:	00013497          	auipc	s1,0x13
    80000b5e:	d664b483          	ld	s1,-666(s1) # 800138c0 <kmem+0x18>
  if(r)
    80000b62:	c49d                	beqz	s1,80000b90 <kalloc+0x4c>
    kmem.freelist = r->next;
    80000b64:	609c                	ld	a5,0(s1)
    80000b66:	00013717          	auipc	a4,0x13
    80000b6a:	d4f73d23          	sd	a5,-678(a4) # 800138c0 <kmem+0x18>
  release(&kmem.lock);
    80000b6e:	00013517          	auipc	a0,0x13
    80000b72:	d3a50513          	addi	a0,a0,-710 # 800138a8 <kmem>
    80000b76:	146000ef          	jal	80000cbc <release>

  if(r)
    memset((char*)r, 5, PGSIZE); // fill with junk
    80000b7a:	6605                	lui	a2,0x1
    80000b7c:	4595                	li	a1,5
    80000b7e:	8526                	mv	a0,s1
    80000b80:	178000ef          	jal	80000cf8 <memset>
  return (void*)r;
}
    80000b84:	8526                	mv	a0,s1
    80000b86:	60e2                	ld	ra,24(sp)
    80000b88:	6442                	ld	s0,16(sp)
    80000b8a:	64a2                	ld	s1,8(sp)
    80000b8c:	6105                	addi	sp,sp,32
    80000b8e:	8082                	ret
  release(&kmem.lock);
    80000b90:	00013517          	auipc	a0,0x13
    80000b94:	d1850513          	addi	a0,a0,-744 # 800138a8 <kmem>
    80000b98:	124000ef          	jal	80000cbc <release>
  if(r)
    80000b9c:	b7e5                	j	80000b84 <kalloc+0x40>

0000000080000b9e <initlock>:
#include "proc.h"
#include "defs.h"

void
initlock(struct spinlock *lk, char *name)
{
    80000b9e:	1141                	addi	sp,sp,-16
    80000ba0:	e406                	sd	ra,8(sp)
    80000ba2:	e022                	sd	s0,0(sp)
    80000ba4:	0800                	addi	s0,sp,16
  lk->name = name;
    80000ba6:	e50c                	sd	a1,8(a0)
  lk->locked = 0;
    80000ba8:	00052023          	sw	zero,0(a0)
  lk->cpu = 0;
    80000bac:	00053823          	sd	zero,16(a0)
}
    80000bb0:	60a2                	ld	ra,8(sp)
    80000bb2:	6402                	ld	s0,0(sp)
    80000bb4:	0141                	addi	sp,sp,16
    80000bb6:	8082                	ret

0000000080000bb8 <holding>:
// Interrupts must be off.
int
holding(struct spinlock *lk)
{
  int r;
  r = (lk->locked && lk->cpu == mycpu());
    80000bb8:	411c                	lw	a5,0(a0)
    80000bba:	e399                	bnez	a5,80000bc0 <holding+0x8>
    80000bbc:	4501                	li	a0,0
  return r;
}
    80000bbe:	8082                	ret
{
    80000bc0:	1101                	addi	sp,sp,-32
    80000bc2:	ec06                	sd	ra,24(sp)
    80000bc4:	e822                	sd	s0,16(sp)
    80000bc6:	e426                	sd	s1,8(sp)
    80000bc8:	1000                	addi	s0,sp,32
  r = (lk->locked && lk->cpu == mycpu());
    80000bca:	691c                	ld	a5,16(a0)
    80000bcc:	84be                	mv	s1,a5
    80000bce:	338010ef          	jal	80001f06 <mycpu>
    80000bd2:	40a48533          	sub	a0,s1,a0
    80000bd6:	00153513          	seqz	a0,a0
}
    80000bda:	60e2                	ld	ra,24(sp)
    80000bdc:	6442                	ld	s0,16(sp)
    80000bde:	64a2                	ld	s1,8(sp)
    80000be0:	6105                	addi	sp,sp,32
    80000be2:	8082                	ret

0000000080000be4 <push_off>:
// it takes two pop_off()s to undo two push_off()s.  Also, if interrupts
// are initially off, then push_off, pop_off leaves them off.

void
push_off(void)
{
    80000be4:	1101                	addi	sp,sp,-32
    80000be6:	ec06                	sd	ra,24(sp)
    80000be8:	e822                	sd	s0,16(sp)
    80000bea:	e426                	sd	s1,8(sp)
    80000bec:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80000bee:	100027f3          	csrr	a5,sstatus
    80000bf2:	84be                	mv	s1,a5
    80000bf4:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    80000bf8:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80000bfa:	10079073          	csrw	sstatus,a5

  // disable interrupts to prevent an involuntary context
  // switch while using mycpu().
  intr_off();

  if(mycpu()->noff == 0)
    80000bfe:	308010ef          	jal	80001f06 <mycpu>
    80000c02:	5d3c                	lw	a5,120(a0)
    80000c04:	cb99                	beqz	a5,80000c1a <push_off+0x36>
    mycpu()->intena = old;
  mycpu()->noff += 1;
    80000c06:	300010ef          	jal	80001f06 <mycpu>
    80000c0a:	5d3c                	lw	a5,120(a0)
    80000c0c:	2785                	addiw	a5,a5,1
    80000c0e:	dd3c                	sw	a5,120(a0)
}
    80000c10:	60e2                	ld	ra,24(sp)
    80000c12:	6442                	ld	s0,16(sp)
    80000c14:	64a2                	ld	s1,8(sp)
    80000c16:	6105                	addi	sp,sp,32
    80000c18:	8082                	ret
    mycpu()->intena = old;
    80000c1a:	2ec010ef          	jal	80001f06 <mycpu>
  return (x & SSTATUS_SIE) != 0;
    80000c1e:	0014d793          	srli	a5,s1,0x1
    80000c22:	8b85                	andi	a5,a5,1
    80000c24:	dd7c                	sw	a5,124(a0)
    80000c26:	b7c5                	j	80000c06 <push_off+0x22>

0000000080000c28 <acquire>:
{
    80000c28:	1101                	addi	sp,sp,-32
    80000c2a:	ec06                	sd	ra,24(sp)
    80000c2c:	e822                	sd	s0,16(sp)
    80000c2e:	e426                	sd	s1,8(sp)
    80000c30:	1000                	addi	s0,sp,32
    80000c32:	84aa                	mv	s1,a0
  push_off(); // disable interrupts to avoid deadlock.
    80000c34:	fb1ff0ef          	jal	80000be4 <push_off>
  if(holding(lk))
    80000c38:	8526                	mv	a0,s1
    80000c3a:	f7fff0ef          	jal	80000bb8 <holding>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    80000c3e:	4705                	li	a4,1
  if(holding(lk))
    80000c40:	e105                	bnez	a0,80000c60 <acquire+0x38>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    80000c42:	87ba                	mv	a5,a4
    80000c44:	0cf4a7af          	amoswap.w.aq	a5,a5,(s1)
    80000c48:	2781                	sext.w	a5,a5
    80000c4a:	ffe5                	bnez	a5,80000c42 <acquire+0x1a>
  __sync_synchronize();
    80000c4c:	0330000f          	fence	rw,rw
  lk->cpu = mycpu();
    80000c50:	2b6010ef          	jal	80001f06 <mycpu>
    80000c54:	e888                	sd	a0,16(s1)
}
    80000c56:	60e2                	ld	ra,24(sp)
    80000c58:	6442                	ld	s0,16(sp)
    80000c5a:	64a2                	ld	s1,8(sp)
    80000c5c:	6105                	addi	sp,sp,32
    80000c5e:	8082                	ret
    panic("acquire");
    80000c60:	00007517          	auipc	a0,0x7
    80000c64:	3e850513          	addi	a0,a0,1000 # 80008048 <etext+0x48>
    80000c68:	bbdff0ef          	jal	80000824 <panic>

0000000080000c6c <pop_off>:

void
pop_off(void)
{
    80000c6c:	1141                	addi	sp,sp,-16
    80000c6e:	e406                	sd	ra,8(sp)
    80000c70:	e022                	sd	s0,0(sp)
    80000c72:	0800                	addi	s0,sp,16
  struct cpu *c = mycpu();
    80000c74:	292010ef          	jal	80001f06 <mycpu>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80000c78:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80000c7c:	8b89                	andi	a5,a5,2
  if(intr_get())
    80000c7e:	e39d                	bnez	a5,80000ca4 <pop_off+0x38>
    panic("pop_off - interruptible");
  if(c->noff < 1)
    80000c80:	5d3c                	lw	a5,120(a0)
    80000c82:	02f05763          	blez	a5,80000cb0 <pop_off+0x44>
    panic("pop_off");
  c->noff -= 1;
    80000c86:	37fd                	addiw	a5,a5,-1
    80000c88:	dd3c                	sw	a5,120(a0)
  if(c->noff == 0 && c->intena)
    80000c8a:	eb89                	bnez	a5,80000c9c <pop_off+0x30>
    80000c8c:	5d7c                	lw	a5,124(a0)
    80000c8e:	c799                	beqz	a5,80000c9c <pop_off+0x30>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80000c90:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80000c94:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80000c98:	10079073          	csrw	sstatus,a5
    intr_on();
}
    80000c9c:	60a2                	ld	ra,8(sp)
    80000c9e:	6402                	ld	s0,0(sp)
    80000ca0:	0141                	addi	sp,sp,16
    80000ca2:	8082                	ret
    panic("pop_off - interruptible");
    80000ca4:	00007517          	auipc	a0,0x7
    80000ca8:	3ac50513          	addi	a0,a0,940 # 80008050 <etext+0x50>
    80000cac:	b79ff0ef          	jal	80000824 <panic>
    panic("pop_off");
    80000cb0:	00007517          	auipc	a0,0x7
    80000cb4:	3b850513          	addi	a0,a0,952 # 80008068 <etext+0x68>
    80000cb8:	b6dff0ef          	jal	80000824 <panic>

0000000080000cbc <release>:
{
    80000cbc:	1101                	addi	sp,sp,-32
    80000cbe:	ec06                	sd	ra,24(sp)
    80000cc0:	e822                	sd	s0,16(sp)
    80000cc2:	e426                	sd	s1,8(sp)
    80000cc4:	1000                	addi	s0,sp,32
    80000cc6:	84aa                	mv	s1,a0
  if(!holding(lk))
    80000cc8:	ef1ff0ef          	jal	80000bb8 <holding>
    80000ccc:	c105                	beqz	a0,80000cec <release+0x30>
  lk->cpu = 0;
    80000cce:	0004b823          	sd	zero,16(s1)
  __sync_synchronize();
    80000cd2:	0330000f          	fence	rw,rw
  __sync_lock_release(&lk->locked);
    80000cd6:	0310000f          	fence	rw,w
    80000cda:	0004a023          	sw	zero,0(s1)
  pop_off();
    80000cde:	f8fff0ef          	jal	80000c6c <pop_off>
}
    80000ce2:	60e2                	ld	ra,24(sp)
    80000ce4:	6442                	ld	s0,16(sp)
    80000ce6:	64a2                	ld	s1,8(sp)
    80000ce8:	6105                	addi	sp,sp,32
    80000cea:	8082                	ret
    panic("release");
    80000cec:	00007517          	auipc	a0,0x7
    80000cf0:	38450513          	addi	a0,a0,900 # 80008070 <etext+0x70>
    80000cf4:	b31ff0ef          	jal	80000824 <panic>

0000000080000cf8 <memset>:
#include "types.h"

void*
memset(void *dst, int c, uint n)
{
    80000cf8:	1141                	addi	sp,sp,-16
    80000cfa:	e406                	sd	ra,8(sp)
    80000cfc:	e022                	sd	s0,0(sp)
    80000cfe:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
    80000d00:	ca19                	beqz	a2,80000d16 <memset+0x1e>
    80000d02:	87aa                	mv	a5,a0
    80000d04:	1602                	slli	a2,a2,0x20
    80000d06:	9201                	srli	a2,a2,0x20
    80000d08:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
    80000d0c:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
    80000d10:	0785                	addi	a5,a5,1
    80000d12:	fee79de3          	bne	a5,a4,80000d0c <memset+0x14>
  }
  return dst;
}
    80000d16:	60a2                	ld	ra,8(sp)
    80000d18:	6402                	ld	s0,0(sp)
    80000d1a:	0141                	addi	sp,sp,16
    80000d1c:	8082                	ret

0000000080000d1e <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
    80000d1e:	1141                	addi	sp,sp,-16
    80000d20:	e406                	sd	ra,8(sp)
    80000d22:	e022                	sd	s0,0(sp)
    80000d24:	0800                	addi	s0,sp,16
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
    80000d26:	c61d                	beqz	a2,80000d54 <memcmp+0x36>
    80000d28:	1602                	slli	a2,a2,0x20
    80000d2a:	9201                	srli	a2,a2,0x20
    80000d2c:	00c506b3          	add	a3,a0,a2
    if(*s1 != *s2)
    80000d30:	00054783          	lbu	a5,0(a0)
    80000d34:	0005c703          	lbu	a4,0(a1)
    80000d38:	00e79863          	bne	a5,a4,80000d48 <memcmp+0x2a>
      return *s1 - *s2;
    s1++, s2++;
    80000d3c:	0505                	addi	a0,a0,1
    80000d3e:	0585                	addi	a1,a1,1
  while(n-- > 0){
    80000d40:	fed518e3          	bne	a0,a3,80000d30 <memcmp+0x12>
  }

  return 0;
    80000d44:	4501                	li	a0,0
    80000d46:	a019                	j	80000d4c <memcmp+0x2e>
      return *s1 - *s2;
    80000d48:	40e7853b          	subw	a0,a5,a4
}
    80000d4c:	60a2                	ld	ra,8(sp)
    80000d4e:	6402                	ld	s0,0(sp)
    80000d50:	0141                	addi	sp,sp,16
    80000d52:	8082                	ret
  return 0;
    80000d54:	4501                	li	a0,0
    80000d56:	bfdd                	j	80000d4c <memcmp+0x2e>

0000000080000d58 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
    80000d58:	1141                	addi	sp,sp,-16
    80000d5a:	e406                	sd	ra,8(sp)
    80000d5c:	e022                	sd	s0,0(sp)
    80000d5e:	0800                	addi	s0,sp,16
  const char *s;
  char *d;

  if(n == 0)
    80000d60:	c205                	beqz	a2,80000d80 <memmove+0x28>
    return dst;
  
  s = src;
  d = dst;
  if(s < d && s + n > d){
    80000d62:	02a5e363          	bltu	a1,a0,80000d88 <memmove+0x30>
    s += n;
    d += n;
    while(n-- > 0)
      *--d = *--s;
  } else
    while(n-- > 0)
    80000d66:	1602                	slli	a2,a2,0x20
    80000d68:	9201                	srli	a2,a2,0x20
    80000d6a:	00c587b3          	add	a5,a1,a2
{
    80000d6e:	872a                	mv	a4,a0
      *d++ = *s++;
    80000d70:	0585                	addi	a1,a1,1
    80000d72:	0705                	addi	a4,a4,1
    80000d74:	fff5c683          	lbu	a3,-1(a1)
    80000d78:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
    80000d7c:	feb79ae3          	bne	a5,a1,80000d70 <memmove+0x18>

  return dst;
}
    80000d80:	60a2                	ld	ra,8(sp)
    80000d82:	6402                	ld	s0,0(sp)
    80000d84:	0141                	addi	sp,sp,16
    80000d86:	8082                	ret
  if(s < d && s + n > d){
    80000d88:	02061693          	slli	a3,a2,0x20
    80000d8c:	9281                	srli	a3,a3,0x20
    80000d8e:	00d58733          	add	a4,a1,a3
    80000d92:	fce57ae3          	bgeu	a0,a4,80000d66 <memmove+0xe>
    d += n;
    80000d96:	96aa                	add	a3,a3,a0
    while(n-- > 0)
    80000d98:	fff6079b          	addiw	a5,a2,-1 # fff <_entry-0x7ffff001>
    80000d9c:	1782                	slli	a5,a5,0x20
    80000d9e:	9381                	srli	a5,a5,0x20
    80000da0:	fff7c793          	not	a5,a5
    80000da4:	97ba                	add	a5,a5,a4
      *--d = *--s;
    80000da6:	177d                	addi	a4,a4,-1
    80000da8:	16fd                	addi	a3,a3,-1
    80000daa:	00074603          	lbu	a2,0(a4)
    80000dae:	00c68023          	sb	a2,0(a3)
    while(n-- > 0)
    80000db2:	fee79ae3          	bne	a5,a4,80000da6 <memmove+0x4e>
    80000db6:	b7e9                	j	80000d80 <memmove+0x28>

0000000080000db8 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
    80000db8:	1141                	addi	sp,sp,-16
    80000dba:	e406                	sd	ra,8(sp)
    80000dbc:	e022                	sd	s0,0(sp)
    80000dbe:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
    80000dc0:	f99ff0ef          	jal	80000d58 <memmove>
}
    80000dc4:	60a2                	ld	ra,8(sp)
    80000dc6:	6402                	ld	s0,0(sp)
    80000dc8:	0141                	addi	sp,sp,16
    80000dca:	8082                	ret

0000000080000dcc <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
    80000dcc:	1141                	addi	sp,sp,-16
    80000dce:	e406                	sd	ra,8(sp)
    80000dd0:	e022                	sd	s0,0(sp)
    80000dd2:	0800                	addi	s0,sp,16
  while(n > 0 && *p && *p == *q)
    80000dd4:	ce11                	beqz	a2,80000df0 <strncmp+0x24>
    80000dd6:	00054783          	lbu	a5,0(a0)
    80000dda:	cf89                	beqz	a5,80000df4 <strncmp+0x28>
    80000ddc:	0005c703          	lbu	a4,0(a1)
    80000de0:	00f71a63          	bne	a4,a5,80000df4 <strncmp+0x28>
    n--, p++, q++;
    80000de4:	367d                	addiw	a2,a2,-1
    80000de6:	0505                	addi	a0,a0,1
    80000de8:	0585                	addi	a1,a1,1
  while(n > 0 && *p && *p == *q)
    80000dea:	f675                	bnez	a2,80000dd6 <strncmp+0xa>
  if(n == 0)
    return 0;
    80000dec:	4501                	li	a0,0
    80000dee:	a801                	j	80000dfe <strncmp+0x32>
    80000df0:	4501                	li	a0,0
    80000df2:	a031                	j	80000dfe <strncmp+0x32>
  return (uchar)*p - (uchar)*q;
    80000df4:	00054503          	lbu	a0,0(a0)
    80000df8:	0005c783          	lbu	a5,0(a1)
    80000dfc:	9d1d                	subw	a0,a0,a5
}
    80000dfe:	60a2                	ld	ra,8(sp)
    80000e00:	6402                	ld	s0,0(sp)
    80000e02:	0141                	addi	sp,sp,16
    80000e04:	8082                	ret

0000000080000e06 <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
    80000e06:	1141                	addi	sp,sp,-16
    80000e08:	e406                	sd	ra,8(sp)
    80000e0a:	e022                	sd	s0,0(sp)
    80000e0c:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
    80000e0e:	87aa                	mv	a5,a0
    80000e10:	a011                	j	80000e14 <strncpy+0xe>
    80000e12:	8636                	mv	a2,a3
    80000e14:	02c05863          	blez	a2,80000e44 <strncpy+0x3e>
    80000e18:	fff6069b          	addiw	a3,a2,-1
    80000e1c:	8836                	mv	a6,a3
    80000e1e:	0785                	addi	a5,a5,1
    80000e20:	0005c703          	lbu	a4,0(a1)
    80000e24:	fee78fa3          	sb	a4,-1(a5)
    80000e28:	0585                	addi	a1,a1,1
    80000e2a:	f765                	bnez	a4,80000e12 <strncpy+0xc>
    ;
  while(n-- > 0)
    80000e2c:	873e                	mv	a4,a5
    80000e2e:	01005b63          	blez	a6,80000e44 <strncpy+0x3e>
    80000e32:	9fb1                	addw	a5,a5,a2
    80000e34:	37fd                	addiw	a5,a5,-1
    *s++ = 0;
    80000e36:	0705                	addi	a4,a4,1
    80000e38:	fe070fa3          	sb	zero,-1(a4)
  while(n-- > 0)
    80000e3c:	40e786bb          	subw	a3,a5,a4
    80000e40:	fed04be3          	bgtz	a3,80000e36 <strncpy+0x30>
  return os;
}
    80000e44:	60a2                	ld	ra,8(sp)
    80000e46:	6402                	ld	s0,0(sp)
    80000e48:	0141                	addi	sp,sp,16
    80000e4a:	8082                	ret

0000000080000e4c <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
    80000e4c:	1141                	addi	sp,sp,-16
    80000e4e:	e406                	sd	ra,8(sp)
    80000e50:	e022                	sd	s0,0(sp)
    80000e52:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  if(n <= 0)
    80000e54:	02c05363          	blez	a2,80000e7a <safestrcpy+0x2e>
    80000e58:	fff6069b          	addiw	a3,a2,-1
    80000e5c:	1682                	slli	a3,a3,0x20
    80000e5e:	9281                	srli	a3,a3,0x20
    80000e60:	96ae                	add	a3,a3,a1
    80000e62:	87aa                	mv	a5,a0
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
    80000e64:	00d58963          	beq	a1,a3,80000e76 <safestrcpy+0x2a>
    80000e68:	0585                	addi	a1,a1,1
    80000e6a:	0785                	addi	a5,a5,1
    80000e6c:	fff5c703          	lbu	a4,-1(a1)
    80000e70:	fee78fa3          	sb	a4,-1(a5)
    80000e74:	fb65                	bnez	a4,80000e64 <safestrcpy+0x18>
    ;
  *s = 0;
    80000e76:	00078023          	sb	zero,0(a5)
  return os;
}
    80000e7a:	60a2                	ld	ra,8(sp)
    80000e7c:	6402                	ld	s0,0(sp)
    80000e7e:	0141                	addi	sp,sp,16
    80000e80:	8082                	ret

0000000080000e82 <strlen>:

int
strlen(const char *s)
{
    80000e82:	1141                	addi	sp,sp,-16
    80000e84:	e406                	sd	ra,8(sp)
    80000e86:	e022                	sd	s0,0(sp)
    80000e88:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
    80000e8a:	00054783          	lbu	a5,0(a0)
    80000e8e:	cf91                	beqz	a5,80000eaa <strlen+0x28>
    80000e90:	00150793          	addi	a5,a0,1
    80000e94:	86be                	mv	a3,a5
    80000e96:	0785                	addi	a5,a5,1
    80000e98:	fff7c703          	lbu	a4,-1(a5)
    80000e9c:	ff65                	bnez	a4,80000e94 <strlen+0x12>
    80000e9e:	40a6853b          	subw	a0,a3,a0
    ;
  return n;
}
    80000ea2:	60a2                	ld	ra,8(sp)
    80000ea4:	6402                	ld	s0,0(sp)
    80000ea6:	0141                	addi	sp,sp,16
    80000ea8:	8082                	ret
  for(n = 0; s[n]; n++)
    80000eaa:	4501                	li	a0,0
    80000eac:	bfdd                	j	80000ea2 <strlen+0x20>

0000000080000eae <main>:
volatile static int started = 0;

// start() jumps here in supervisor mode on all CPUs.
void
main()
{
    80000eae:	1141                	addi	sp,sp,-16
    80000eb0:	e406                	sd	ra,8(sp)
    80000eb2:	e022                	sd	s0,0(sp)
    80000eb4:	0800                	addi	s0,sp,16
  if(cpuid() == 0){
    80000eb6:	03c010ef          	jal	80001ef2 <cpuid>
    virtio_disk_init(); // emulated hard disk
    userinit();      // first user process
    __sync_synchronize();
    started = 1;
  } else {
    while(started == 0)
    80000eba:	0000b717          	auipc	a4,0xb
    80000ebe:	8f670713          	addi	a4,a4,-1802 # 8000b7b0 <started>
  if(cpuid() == 0){
    80000ec2:	c51d                	beqz	a0,80000ef0 <main+0x42>
    while(started == 0)
    80000ec4:	431c                	lw	a5,0(a4)
    80000ec6:	2781                	sext.w	a5,a5
    80000ec8:	dff5                	beqz	a5,80000ec4 <main+0x16>
      ;
    __sync_synchronize();
    80000eca:	0330000f          	fence	rw,rw
    printf("hart %d starting\n", cpuid());
    80000ece:	024010ef          	jal	80001ef2 <cpuid>
    80000ed2:	85aa                	mv	a1,a0
    80000ed4:	00007517          	auipc	a0,0x7
    80000ed8:	1bc50513          	addi	a0,a0,444 # 80008090 <etext+0x90>
    80000edc:	e1eff0ef          	jal	800004fa <printf>
    kvminithart();    // turn on paging
    80000ee0:	080000ef          	jal	80000f60 <kvminithart>
    trapinithart();   // install kernel trap vector
    80000ee4:	4d7010ef          	jal	80002bba <trapinithart>
    plicinithart();   // ask PLIC for device interrupts
    80000ee8:	090050ef          	jal	80005f78 <plicinithart>
  }

  scheduler();        
    80000eec:	5a4010ef          	jal	80002490 <scheduler>
    consoleinit();
    80000ef0:	d30ff0ef          	jal	80000420 <consoleinit>
    printfinit();
    80000ef4:	96dff0ef          	jal	80000860 <printfinit>
    printf("\n");
    80000ef8:	00007517          	auipc	a0,0x7
    80000efc:	24850513          	addi	a0,a0,584 # 80008140 <etext+0x140>
    80000f00:	dfaff0ef          	jal	800004fa <printf>
    printf("xv6 kernel is booting\n");
    80000f04:	00007517          	auipc	a0,0x7
    80000f08:	17450513          	addi	a0,a0,372 # 80008078 <etext+0x78>
    80000f0c:	deeff0ef          	jal	800004fa <printf>
    printf("\n");
    80000f10:	00007517          	auipc	a0,0x7
    80000f14:	23050513          	addi	a0,a0,560 # 80008140 <etext+0x140>
    80000f18:	de2ff0ef          	jal	800004fa <printf>
    kinit();         // physical page allocator
    80000f1c:	bf5ff0ef          	jal	80000b10 <kinit>
    kvminit();       // create kernel page table
    80000f20:	2cc000ef          	jal	800011ec <kvminit>
    kvminithart();   // turn on paging
    80000f24:	03c000ef          	jal	80000f60 <kvminithart>
    procinit();      // process table
    80000f28:	70f000ef          	jal	80001e36 <procinit>
    trapinit();      // trap vectors
    80000f2c:	46b010ef          	jal	80002b96 <trapinit>
    trapinithart();  // install kernel trap vector
    80000f30:	48b010ef          	jal	80002bba <trapinithart>
    plicinit();      // set up interrupt controller
    80000f34:	02a050ef          	jal	80005f5e <plicinit>
    plicinithart();  // ask PLIC for device interrupts
    80000f38:	040050ef          	jal	80005f78 <plicinithart>
    binit();         // buffer cache
    80000f3c:	440020ef          	jal	8000337c <binit>
    iinit();         // inode table
    80000f40:	193020ef          	jal	800038d2 <iinit>
    fileinit();      // file table
    80000f44:	0bf030ef          	jal	80004802 <fileinit>
    virtio_disk_init(); // emulated hard disk
    80000f48:	120050ef          	jal	80006068 <virtio_disk_init>
    userinit();      // first user process
    80000f4c:	2e0010ef          	jal	8000222c <userinit>
    __sync_synchronize();
    80000f50:	0330000f          	fence	rw,rw
    started = 1;
    80000f54:	4785                	li	a5,1
    80000f56:	0000b717          	auipc	a4,0xb
    80000f5a:	84f72d23          	sw	a5,-1958(a4) # 8000b7b0 <started>
    80000f5e:	b779                	j	80000eec <main+0x3e>

0000000080000f60 <kvminithart>:

// Switch the current CPU's h/w page table register to
// the kernel's page table, and enable paging.
    void
kvminithart()
{
    80000f60:	1141                	addi	sp,sp,-16
    80000f62:	e406                	sd	ra,8(sp)
    80000f64:	e022                	sd	s0,0(sp)
    80000f66:	0800                	addi	s0,sp,16
// flush the TLB.
static inline void
sfence_vma()
{
  // the zero, zero means flush all TLB entries.
  asm volatile("sfence.vma zero, zero");
    80000f68:	12000073          	sfence.vma
    // wait for any previous writes to the page table memory to finish.
    sfence_vma();

    w_satp(MAKE_SATP(kernel_pagetable));
    80000f6c:	0000b797          	auipc	a5,0xb
    80000f70:	84c7b783          	ld	a5,-1972(a5) # 8000b7b8 <kernel_pagetable>
    80000f74:	83b1                	srli	a5,a5,0xc
    80000f76:	577d                	li	a4,-1
    80000f78:	177e                	slli	a4,a4,0x3f
    80000f7a:	8fd9                	or	a5,a5,a4
  asm volatile("csrw satp, %0" : : "r" (x));
    80000f7c:	18079073          	csrw	satp,a5
  asm volatile("sfence.vma zero, zero");
    80000f80:	12000073          	sfence.vma

    // flush stale entries from the TLB.
    sfence_vma();
}
    80000f84:	60a2                	ld	ra,8(sp)
    80000f86:	6402                	ld	s0,0(sp)
    80000f88:	0141                	addi	sp,sp,16
    80000f8a:	8082                	ret

0000000080000f8c <walk>:
//   21..29 -- 9 bits of level-1 index.
//   12..20 -- 9 bits of level-0 index.
//    0..11 -- 12 bits of byte offset within the page.
    pte_t *
walk(pagetable_t pagetable, uint64 va, int alloc)
{
    80000f8c:	7139                	addi	sp,sp,-64
    80000f8e:	fc06                	sd	ra,56(sp)
    80000f90:	f822                	sd	s0,48(sp)
    80000f92:	f426                	sd	s1,40(sp)
    80000f94:	f04a                	sd	s2,32(sp)
    80000f96:	ec4e                	sd	s3,24(sp)
    80000f98:	e852                	sd	s4,16(sp)
    80000f9a:	e456                	sd	s5,8(sp)
    80000f9c:	e05a                	sd	s6,0(sp)
    80000f9e:	0080                	addi	s0,sp,64
    80000fa0:	84aa                	mv	s1,a0
    80000fa2:	89ae                	mv	s3,a1
    80000fa4:	8b32                	mv	s6,a2
    if(va >= MAXVA)
    80000fa6:	57fd                	li	a5,-1
    80000fa8:	83e9                	srli	a5,a5,0x1a
    80000faa:	4a79                	li	s4,30
        panic("walk");

    for(int level = 2; level > 0; level--) {
    80000fac:	4ab1                	li	s5,12
    if(va >= MAXVA)
    80000fae:	04b7e263          	bltu	a5,a1,80000ff2 <walk+0x66>
        pte_t *pte = &pagetable[PX(level, va)];
    80000fb2:	0149d933          	srl	s2,s3,s4
    80000fb6:	1ff97913          	andi	s2,s2,511
    80000fba:	090e                	slli	s2,s2,0x3
    80000fbc:	9926                	add	s2,s2,s1
        if(*pte & PTE_V) {
    80000fbe:	00093483          	ld	s1,0(s2)
    80000fc2:	0014f793          	andi	a5,s1,1
    80000fc6:	cf85                	beqz	a5,80000ffe <walk+0x72>
            pagetable = (pagetable_t)PTE2PA(*pte);
    80000fc8:	80a9                	srli	s1,s1,0xa
    80000fca:	04b2                	slli	s1,s1,0xc
    for(int level = 2; level > 0; level--) {
    80000fcc:	3a5d                	addiw	s4,s4,-9
    80000fce:	ff5a12e3          	bne	s4,s5,80000fb2 <walk+0x26>
                return 0;
            memset(pagetable, 0, PGSIZE);
            *pte = PA2PTE(pagetable) | PTE_V;
        }
    }
    return &pagetable[PX(0, va)];
    80000fd2:	00c9d513          	srli	a0,s3,0xc
    80000fd6:	1ff57513          	andi	a0,a0,511
    80000fda:	050e                	slli	a0,a0,0x3
    80000fdc:	9526                	add	a0,a0,s1
}
    80000fde:	70e2                	ld	ra,56(sp)
    80000fe0:	7442                	ld	s0,48(sp)
    80000fe2:	74a2                	ld	s1,40(sp)
    80000fe4:	7902                	ld	s2,32(sp)
    80000fe6:	69e2                	ld	s3,24(sp)
    80000fe8:	6a42                	ld	s4,16(sp)
    80000fea:	6aa2                	ld	s5,8(sp)
    80000fec:	6b02                	ld	s6,0(sp)
    80000fee:	6121                	addi	sp,sp,64
    80000ff0:	8082                	ret
        panic("walk");
    80000ff2:	00007517          	auipc	a0,0x7
    80000ff6:	0b650513          	addi	a0,a0,182 # 800080a8 <etext+0xa8>
    80000ffa:	82bff0ef          	jal	80000824 <panic>
            if(!alloc || (pagetable = (pde_t*)kalloc()) == 0)
    80000ffe:	020b0263          	beqz	s6,80001022 <walk+0x96>
    80001002:	b43ff0ef          	jal	80000b44 <kalloc>
    80001006:	84aa                	mv	s1,a0
    80001008:	d979                	beqz	a0,80000fde <walk+0x52>
            memset(pagetable, 0, PGSIZE);
    8000100a:	6605                	lui	a2,0x1
    8000100c:	4581                	li	a1,0
    8000100e:	cebff0ef          	jal	80000cf8 <memset>
            *pte = PA2PTE(pagetable) | PTE_V;
    80001012:	00c4d793          	srli	a5,s1,0xc
    80001016:	07aa                	slli	a5,a5,0xa
    80001018:	0017e793          	ori	a5,a5,1
    8000101c:	00f93023          	sd	a5,0(s2)
    80001020:	b775                	j	80000fcc <walk+0x40>
                return 0;
    80001022:	4501                	li	a0,0
    80001024:	bf6d                	j	80000fde <walk+0x52>

0000000080001026 <walkaddr>:
walkaddr(pagetable_t pagetable, uint64 va)
{
    pte_t *pte;
    uint64 pa;

    if(va >= MAXVA)
    80001026:	57fd                	li	a5,-1
    80001028:	83e9                	srli	a5,a5,0x1a
    8000102a:	00b7f463          	bgeu	a5,a1,80001032 <walkaddr+0xc>
        return 0;
    8000102e:	4501                	li	a0,0
        return 0;
    if((*pte & PTE_U) == 0)
        return 0;
    pa = PTE2PA(*pte);
    return pa;
}
    80001030:	8082                	ret
{
    80001032:	1141                	addi	sp,sp,-16
    80001034:	e406                	sd	ra,8(sp)
    80001036:	e022                	sd	s0,0(sp)
    80001038:	0800                	addi	s0,sp,16
    pte = walk(pagetable, va, 0);
    8000103a:	4601                	li	a2,0
    8000103c:	f51ff0ef          	jal	80000f8c <walk>
    if(pte == 0)
    80001040:	c901                	beqz	a0,80001050 <walkaddr+0x2a>
    if((*pte & PTE_V) == 0)
    80001042:	611c                	ld	a5,0(a0)
    if((*pte & PTE_U) == 0)
    80001044:	0117f693          	andi	a3,a5,17
    80001048:	4745                	li	a4,17
        return 0;
    8000104a:	4501                	li	a0,0
    if((*pte & PTE_U) == 0)
    8000104c:	00e68663          	beq	a3,a4,80001058 <walkaddr+0x32>
}
    80001050:	60a2                	ld	ra,8(sp)
    80001052:	6402                	ld	s0,0(sp)
    80001054:	0141                	addi	sp,sp,16
    80001056:	8082                	ret
    pa = PTE2PA(*pte);
    80001058:	83a9                	srli	a5,a5,0xa
    8000105a:	00c79513          	slli	a0,a5,0xc
    return pa;
    8000105e:	bfcd                	j	80001050 <walkaddr+0x2a>

0000000080001060 <mappages>:
// va and size MUST be page-aligned.
// Returns 0 on success, -1 if walk() couldn't
// allocate a needed page-table page.
    int
mappages(pagetable_t pagetable, uint64 va, uint64 size, uint64 pa, int perm)
{
    80001060:	715d                	addi	sp,sp,-80
    80001062:	e486                	sd	ra,72(sp)
    80001064:	e0a2                	sd	s0,64(sp)
    80001066:	fc26                	sd	s1,56(sp)
    80001068:	f84a                	sd	s2,48(sp)
    8000106a:	f44e                	sd	s3,40(sp)
    8000106c:	f052                	sd	s4,32(sp)
    8000106e:	ec56                	sd	s5,24(sp)
    80001070:	e85a                	sd	s6,16(sp)
    80001072:	e45e                	sd	s7,8(sp)
    80001074:	0880                	addi	s0,sp,80
    uint64 a, last;
    pte_t *pte;

    if((va % PGSIZE) != 0)
    80001076:	03459793          	slli	a5,a1,0x34
    8000107a:	eba1                	bnez	a5,800010ca <mappages+0x6a>
    8000107c:	8a2a                	mv	s4,a0
    8000107e:	8aba                	mv	s5,a4
        panic("mappages: va not aligned");

    if((size % PGSIZE) != 0)
    80001080:	03461793          	slli	a5,a2,0x34
    80001084:	eba9                	bnez	a5,800010d6 <mappages+0x76>
        panic("mappages: size not aligned");

    if(size == 0)
    80001086:	ce31                	beqz	a2,800010e2 <mappages+0x82>
        panic("mappages: size");

    a = va;
    last = va + size - PGSIZE;
    80001088:	80060613          	addi	a2,a2,-2048 # 800 <_entry-0x7ffff800>
    8000108c:	80060613          	addi	a2,a2,-2048
    80001090:	00b60933          	add	s2,a2,a1
    a = va;
    80001094:	84ae                	mv	s1,a1
    for(;;){
        if((pte = walk(pagetable, a, 1)) == 0)
    80001096:	4b05                	li	s6,1
    80001098:	40b689b3          	sub	s3,a3,a1
        if(*pte & PTE_V)
            panic("mappages: remap");
        *pte = PA2PTE(pa) | perm | PTE_V;
        if(a == last)
            break;
        a += PGSIZE;
    8000109c:	6b85                	lui	s7,0x1
        if((pte = walk(pagetable, a, 1)) == 0)
    8000109e:	865a                	mv	a2,s6
    800010a0:	85a6                	mv	a1,s1
    800010a2:	8552                	mv	a0,s4
    800010a4:	ee9ff0ef          	jal	80000f8c <walk>
    800010a8:	c929                	beqz	a0,800010fa <mappages+0x9a>
        if(*pte & PTE_V)
    800010aa:	611c                	ld	a5,0(a0)
    800010ac:	8b85                	andi	a5,a5,1
    800010ae:	e3a1                	bnez	a5,800010ee <mappages+0x8e>
        *pte = PA2PTE(pa) | perm | PTE_V;
    800010b0:	013487b3          	add	a5,s1,s3
    800010b4:	83b1                	srli	a5,a5,0xc
    800010b6:	07aa                	slli	a5,a5,0xa
    800010b8:	0157e7b3          	or	a5,a5,s5
    800010bc:	0017e793          	ori	a5,a5,1
    800010c0:	e11c                	sd	a5,0(a0)
        if(a == last)
    800010c2:	05248863          	beq	s1,s2,80001112 <mappages+0xb2>
        a += PGSIZE;
    800010c6:	94de                	add	s1,s1,s7
        if((pte = walk(pagetable, a, 1)) == 0)
    800010c8:	bfd9                	j	8000109e <mappages+0x3e>
        panic("mappages: va not aligned");
    800010ca:	00007517          	auipc	a0,0x7
    800010ce:	fe650513          	addi	a0,a0,-26 # 800080b0 <etext+0xb0>
    800010d2:	f52ff0ef          	jal	80000824 <panic>
        panic("mappages: size not aligned");
    800010d6:	00007517          	auipc	a0,0x7
    800010da:	ffa50513          	addi	a0,a0,-6 # 800080d0 <etext+0xd0>
    800010de:	f46ff0ef          	jal	80000824 <panic>
        panic("mappages: size");
    800010e2:	00007517          	auipc	a0,0x7
    800010e6:	00e50513          	addi	a0,a0,14 # 800080f0 <etext+0xf0>
    800010ea:	f3aff0ef          	jal	80000824 <panic>
            panic("mappages: remap");
    800010ee:	00007517          	auipc	a0,0x7
    800010f2:	01250513          	addi	a0,a0,18 # 80008100 <etext+0x100>
    800010f6:	f2eff0ef          	jal	80000824 <panic>
            return -1;
    800010fa:	557d                	li	a0,-1
        pa += PGSIZE;
    }
    return 0;
}
    800010fc:	60a6                	ld	ra,72(sp)
    800010fe:	6406                	ld	s0,64(sp)
    80001100:	74e2                	ld	s1,56(sp)
    80001102:	7942                	ld	s2,48(sp)
    80001104:	79a2                	ld	s3,40(sp)
    80001106:	7a02                	ld	s4,32(sp)
    80001108:	6ae2                	ld	s5,24(sp)
    8000110a:	6b42                	ld	s6,16(sp)
    8000110c:	6ba2                	ld	s7,8(sp)
    8000110e:	6161                	addi	sp,sp,80
    80001110:	8082                	ret
    return 0;
    80001112:	4501                	li	a0,0
    80001114:	b7e5                	j	800010fc <mappages+0x9c>

0000000080001116 <kvmmap>:
{
    80001116:	1141                	addi	sp,sp,-16
    80001118:	e406                	sd	ra,8(sp)
    8000111a:	e022                	sd	s0,0(sp)
    8000111c:	0800                	addi	s0,sp,16
    8000111e:	87b6                	mv	a5,a3
    if(mappages(kpgtbl, va, sz, pa, perm) != 0)
    80001120:	86b2                	mv	a3,a2
    80001122:	863e                	mv	a2,a5
    80001124:	f3dff0ef          	jal	80001060 <mappages>
    80001128:	e509                	bnez	a0,80001132 <kvmmap+0x1c>
}
    8000112a:	60a2                	ld	ra,8(sp)
    8000112c:	6402                	ld	s0,0(sp)
    8000112e:	0141                	addi	sp,sp,16
    80001130:	8082                	ret
        panic("kvmmap");
    80001132:	00007517          	auipc	a0,0x7
    80001136:	fde50513          	addi	a0,a0,-34 # 80008110 <etext+0x110>
    8000113a:	eeaff0ef          	jal	80000824 <panic>

000000008000113e <kvmmake>:
{
    8000113e:	1101                	addi	sp,sp,-32
    80001140:	ec06                	sd	ra,24(sp)
    80001142:	e822                	sd	s0,16(sp)
    80001144:	e426                	sd	s1,8(sp)
    80001146:	1000                	addi	s0,sp,32
    kpgtbl = (pagetable_t) kalloc();
    80001148:	9fdff0ef          	jal	80000b44 <kalloc>
    8000114c:	84aa                	mv	s1,a0
    memset(kpgtbl, 0, PGSIZE);
    8000114e:	6605                	lui	a2,0x1
    80001150:	4581                	li	a1,0
    80001152:	ba7ff0ef          	jal	80000cf8 <memset>
    kvmmap(kpgtbl, UART0, UART0, PGSIZE, PTE_R | PTE_W);
    80001156:	4719                	li	a4,6
    80001158:	6685                	lui	a3,0x1
    8000115a:	10000637          	lui	a2,0x10000
    8000115e:	85b2                	mv	a1,a2
    80001160:	8526                	mv	a0,s1
    80001162:	fb5ff0ef          	jal	80001116 <kvmmap>
    kvmmap(kpgtbl, VIRTIO0, VIRTIO0, PGSIZE, PTE_R | PTE_W);
    80001166:	4719                	li	a4,6
    80001168:	6685                	lui	a3,0x1
    8000116a:	10001637          	lui	a2,0x10001
    8000116e:	85b2                	mv	a1,a2
    80001170:	8526                	mv	a0,s1
    80001172:	fa5ff0ef          	jal	80001116 <kvmmap>
    kvmmap(kpgtbl, PLIC, PLIC, 0x4000000, PTE_R | PTE_W);
    80001176:	4719                	li	a4,6
    80001178:	040006b7          	lui	a3,0x4000
    8000117c:	0c000637          	lui	a2,0xc000
    80001180:	85b2                	mv	a1,a2
    80001182:	8526                	mv	a0,s1
    80001184:	f93ff0ef          	jal	80001116 <kvmmap>
    kvmmap(kpgtbl, KERNBASE, KERNBASE, (uint64)etext-KERNBASE, PTE_R | PTE_X);
    80001188:	4729                	li	a4,10
    8000118a:	80007697          	auipc	a3,0x80007
    8000118e:	e7668693          	addi	a3,a3,-394 # 8000 <_entry-0x7fff8000>
    80001192:	4605                	li	a2,1
    80001194:	067e                	slli	a2,a2,0x1f
    80001196:	85b2                	mv	a1,a2
    80001198:	8526                	mv	a0,s1
    8000119a:	f7dff0ef          	jal	80001116 <kvmmap>
    kvmmap(kpgtbl, (uint64)etext, (uint64)etext, PHYSTOP-(uint64)etext, PTE_R | PTE_W);
    8000119e:	4719                	li	a4,6
    800011a0:	00007697          	auipc	a3,0x7
    800011a4:	e6068693          	addi	a3,a3,-416 # 80008000 <etext>
    800011a8:	47c5                	li	a5,17
    800011aa:	07ee                	slli	a5,a5,0x1b
    800011ac:	40d786b3          	sub	a3,a5,a3
    800011b0:	00007617          	auipc	a2,0x7
    800011b4:	e5060613          	addi	a2,a2,-432 # 80008000 <etext>
    800011b8:	85b2                	mv	a1,a2
    800011ba:	8526                	mv	a0,s1
    800011bc:	f5bff0ef          	jal	80001116 <kvmmap>
    kvmmap(kpgtbl, TRAMPOLINE, (uint64)trampoline, PGSIZE, PTE_R | PTE_X);
    800011c0:	4729                	li	a4,10
    800011c2:	6685                	lui	a3,0x1
    800011c4:	00006617          	auipc	a2,0x6
    800011c8:	e3c60613          	addi	a2,a2,-452 # 80007000 <_trampoline>
    800011cc:	040005b7          	lui	a1,0x4000
    800011d0:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    800011d2:	05b2                	slli	a1,a1,0xc
    800011d4:	8526                	mv	a0,s1
    800011d6:	f41ff0ef          	jal	80001116 <kvmmap>
    proc_mapstacks(kpgtbl);
    800011da:	8526                	mv	a0,s1
    800011dc:	3b1000ef          	jal	80001d8c <proc_mapstacks>
}
    800011e0:	8526                	mv	a0,s1
    800011e2:	60e2                	ld	ra,24(sp)
    800011e4:	6442                	ld	s0,16(sp)
    800011e6:	64a2                	ld	s1,8(sp)
    800011e8:	6105                	addi	sp,sp,32
    800011ea:	8082                	ret

00000000800011ec <kvminit>:
{
    800011ec:	1141                	addi	sp,sp,-16
    800011ee:	e406                	sd	ra,8(sp)
    800011f0:	e022                	sd	s0,0(sp)
    800011f2:	0800                	addi	s0,sp,16
    kernel_pagetable = kvmmake();
    800011f4:	f4bff0ef          	jal	8000113e <kvmmake>
    800011f8:	0000a797          	auipc	a5,0xa
    800011fc:	5ca7b023          	sd	a0,1472(a5) # 8000b7b8 <kernel_pagetable>
}
    80001200:	60a2                	ld	ra,8(sp)
    80001202:	6402                	ld	s0,0(sp)
    80001204:	0141                	addi	sp,sp,16
    80001206:	8082                	ret

0000000080001208 <uvmcreate>:

// create an empty user page table.
// returns 0 if out of memory.
    pagetable_t
uvmcreate()
{
    80001208:	1101                	addi	sp,sp,-32
    8000120a:	ec06                	sd	ra,24(sp)
    8000120c:	e822                	sd	s0,16(sp)
    8000120e:	e426                	sd	s1,8(sp)
    80001210:	1000                	addi	s0,sp,32
    pagetable_t pagetable;
    pagetable = (pagetable_t) kalloc();
    80001212:	933ff0ef          	jal	80000b44 <kalloc>
    80001216:	84aa                	mv	s1,a0
    if(pagetable == 0)
    80001218:	c509                	beqz	a0,80001222 <uvmcreate+0x1a>
        return 0;
    memset(pagetable, 0, PGSIZE);
    8000121a:	6605                	lui	a2,0x1
    8000121c:	4581                	li	a1,0
    8000121e:	adbff0ef          	jal	80000cf8 <memset>
    return pagetable;
}
    80001222:	8526                	mv	a0,s1
    80001224:	60e2                	ld	ra,24(sp)
    80001226:	6442                	ld	s0,16(sp)
    80001228:	64a2                	ld	s1,8(sp)
    8000122a:	6105                	addi	sp,sp,32
    8000122c:	8082                	ret

000000008000122e <uvmunmap>:
// Remove npages of mappings starting from va. va must be
// page-aligned. It's OK if the mappings don't exist.
// Optionally free the physical memory.
    void
uvmunmap(pagetable_t pagetable, uint64 va, uint64 npages, int do_free)
{
    8000122e:	7139                	addi	sp,sp,-64
    80001230:	fc06                	sd	ra,56(sp)
    80001232:	f822                	sd	s0,48(sp)
    80001234:	0080                	addi	s0,sp,64
    uint64 a;
    pte_t *pte;

    if((va % PGSIZE) != 0)
    80001236:	03459793          	slli	a5,a1,0x34
    8000123a:	e38d                	bnez	a5,8000125c <uvmunmap+0x2e>
    8000123c:	f04a                	sd	s2,32(sp)
    8000123e:	ec4e                	sd	s3,24(sp)
    80001240:	e852                	sd	s4,16(sp)
    80001242:	e456                	sd	s5,8(sp)
    80001244:	e05a                	sd	s6,0(sp)
    80001246:	8a2a                	mv	s4,a0
    80001248:	892e                	mv	s2,a1
    8000124a:	8ab6                	mv	s5,a3
        panic("uvmunmap: not aligned");

    for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    8000124c:	0632                	slli	a2,a2,0xc
    8000124e:	00b609b3          	add	s3,a2,a1
    80001252:	6b05                	lui	s6,0x1
    80001254:	0535f963          	bgeu	a1,s3,800012a6 <uvmunmap+0x78>
    80001258:	f426                	sd	s1,40(sp)
    8000125a:	a015                	j	8000127e <uvmunmap+0x50>
    8000125c:	f426                	sd	s1,40(sp)
    8000125e:	f04a                	sd	s2,32(sp)
    80001260:	ec4e                	sd	s3,24(sp)
    80001262:	e852                	sd	s4,16(sp)
    80001264:	e456                	sd	s5,8(sp)
    80001266:	e05a                	sd	s6,0(sp)
        panic("uvmunmap: not aligned");
    80001268:	00007517          	auipc	a0,0x7
    8000126c:	eb050513          	addi	a0,a0,-336 # 80008118 <etext+0x118>
    80001270:	db4ff0ef          	jal	80000824 <panic>
            continue;
        if(do_free){
            uint64 pa = PTE2PA(*pte);
            kfree((void*)pa);
        }
        *pte = 0;
    80001274:	0004b023          	sd	zero,0(s1)
    for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    80001278:	995a                	add	s2,s2,s6
    8000127a:	03397563          	bgeu	s2,s3,800012a4 <uvmunmap+0x76>
        if((pte = walk(pagetable, a, 0)) == 0) // leaf page table entry allocated?
    8000127e:	4601                	li	a2,0
    80001280:	85ca                	mv	a1,s2
    80001282:	8552                	mv	a0,s4
    80001284:	d09ff0ef          	jal	80000f8c <walk>
    80001288:	84aa                	mv	s1,a0
    8000128a:	d57d                	beqz	a0,80001278 <uvmunmap+0x4a>
        if((*pte & PTE_V) == 0)  // has physical page been allocated?
    8000128c:	611c                	ld	a5,0(a0)
    8000128e:	0017f713          	andi	a4,a5,1
    80001292:	d37d                	beqz	a4,80001278 <uvmunmap+0x4a>
        if(do_free){
    80001294:	fe0a80e3          	beqz	s5,80001274 <uvmunmap+0x46>
            uint64 pa = PTE2PA(*pte);
    80001298:	83a9                	srli	a5,a5,0xa
            kfree((void*)pa);
    8000129a:	00c79513          	slli	a0,a5,0xc
    8000129e:	fbeff0ef          	jal	80000a5c <kfree>
    800012a2:	bfc9                	j	80001274 <uvmunmap+0x46>
    800012a4:	74a2                	ld	s1,40(sp)
    800012a6:	7902                	ld	s2,32(sp)
    800012a8:	69e2                	ld	s3,24(sp)
    800012aa:	6a42                	ld	s4,16(sp)
    800012ac:	6aa2                	ld	s5,8(sp)
    800012ae:	6b02                	ld	s6,0(sp)
    }
}
    800012b0:	70e2                	ld	ra,56(sp)
    800012b2:	7442                	ld	s0,48(sp)
    800012b4:	6121                	addi	sp,sp,64
    800012b6:	8082                	ret

00000000800012b8 <handle_pgfault>:
{
    800012b8:	7115                	addi	sp,sp,-224
    800012ba:	ed86                	sd	ra,216(sp)
    800012bc:	e9a2                	sd	s0,208(sp)
    800012be:	e1ca                	sd	s2,192(sp)
    800012c0:	e566                	sd	s9,136(sp)
    800012c2:	e16a                	sd	s10,128(sp)
    800012c4:	1180                	addi	s0,sp,224
    800012c6:	8d2a                	mv	s10,a0
    800012c8:	892e                	mv	s2,a1
    800012ca:	8cb2                	mv	s9,a2
    struct proc *p = myproc();
    800012cc:	45b000ef          	jal	80001f26 <myproc>
    if(va >= MAXVA){
    800012d0:	57fd                	li	a5,-1
    800012d2:	83e9                	srli	a5,a5,0x1a
    800012d4:	5727ea63          	bltu	a5,s2,80001848 <handle_pgfault+0x590>
    800012d8:	e5a6                	sd	s1,200(sp)
    800012da:	fd4e                	sd	s3,184(sp)
    800012dc:	f952                	sd	s4,176(sp)
    800012de:	84aa                	mv	s1,a0
    mem = kalloc();
    800012e0:	865ff0ef          	jal	80000b44 <kalloc>
    800012e4:	89aa                	mv	s3,a0
    if(mem == 0){
    800012e6:	c925                	beqz	a0,80001356 <handle_pgfault+0x9e>
       va = PGROUNDDOWN(va);
    800012e8:	77fd                	lui	a5,0xfffff
    800012ea:	00f97933          	and	s2,s2,a5
    memset(mem, 0, PGSIZE);
    800012ee:	6605                	lui	a2,0x1
    800012f0:	4581                	li	a1,0
    800012f2:	854e                	mv	a0,s3
    800012f4:	a05ff0ef          	jal	80000cf8 <memset>
    for(int i = 0; i < p->num_swappped_pages; i++){
    800012f8:	000897b7          	lui	a5,0x89
    800012fc:	97a6                	add	a5,a5,s1
    800012fe:	1cc7a603          	lw	a2,460(a5) # 891cc <_entry-0x7ff76e34>
    80001302:	00c05f63          	blez	a2,80001320 <handle_pgfault+0x68>
    80001306:	00089737          	lui	a4,0x89
    8000130a:	df070713          	addi	a4,a4,-528 # 88df0 <_entry-0x7ff77210>
    8000130e:	9726                	add	a4,a4,s1
    80001310:	4781                	li	a5,0
        if(p->swapped_pages[i].va == va){
    80001312:	6314                	ld	a3,0(a4)
    80001314:	23268463          	beq	a3,s2,8000153c <handle_pgfault+0x284>
    for(int i = 0; i < p->num_swappped_pages; i++){
    80001318:	2785                	addiw	a5,a5,1
    8000131a:	0741                	addi	a4,a4,16
    8000131c:	fec79be3          	bne	a5,a2,80001312 <handle_pgfault+0x5a>
        readi(p->exec_ip, 0, (uint64)&elf, 0, sizeof(elf));
    80001320:	04000713          	li	a4,64
    80001324:	4681                	li	a3,0
    80001326:	f6040613          	addi	a2,s0,-160
    8000132a:	4581                	li	a1,0
    8000132c:	1704b503          	ld	a0,368(s1)
    80001330:	2fd020ef          	jal	80003e2c <readi>
        for(int i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)) {
    80001334:	f9845783          	lhu	a5,-104(s0)
    80001338:	42078563          	beqz	a5,80001762 <handle_pgfault+0x4aa>
    8000133c:	f556                	sd	s5,168(sp)
    8000133e:	f15a                	sd	s6,160(sp)
    80001340:	ed5e                	sd	s7,152(sp)
    80001342:	e962                	sd	s8,144(sp)
    80001344:	f8042683          	lw	a3,-128(s0)
    80001348:	4a01                	li	s4,0
            readi(p->exec_ip, 0, (uint64)&ph, off, sizeof(ph));
    8000134a:	f2840c13          	addi	s8,s0,-216
    8000134e:	03800b93          	li	s7,56
            if(ph.type == ELF_PROG_LOAD && (va >= ph.vaddr && va < ph.vaddr + ph.memsz)) {
    80001352:	4b05                	li	s6,1
    80001354:	a681                	j	80001694 <handle_pgfault+0x3dc>
    80001356:	f556                	sd	s5,168(sp)
    printf("[pid %d] MEMFULL\n",p->pid);
    80001358:	588c                	lw	a1,48(s1)
    8000135a:	00007517          	auipc	a0,0x7
    8000135e:	dd650513          	addi	a0,a0,-554 # 80008130 <etext+0x130>
    80001362:	998ff0ef          	jal	800004fa <printf>
    for(int i = 1;i<p->num_resident;i++){
    80001366:	000897b7          	lui	a5,0x89
    8000136a:	97a6                	add	a5,a5,s1
    8000136c:	1b07a503          	lw	a0,432(a5) # 891b0 <_entry-0x7ff76e50>
    80001370:	4785                	li	a5,1
    80001372:	02a7d663          	bge	a5,a0,8000139e <handle_pgfault+0xe6>
    80001376:	28848693          	addi	a3,s1,648
    int victim_inx = 0;
    8000137a:	4581                	li	a1,0
    for(int i = 1;i<p->num_resident;i++){
    8000137c:	873e                	mv	a4,a5
    8000137e:	a029                	j	80001388 <handle_pgfault+0xd0>
    80001380:	2705                	addiw	a4,a4,1
    80001382:	06c1                	addi	a3,a3,16 # 1010 <_entry-0x7fffeff0>
    80001384:	00a70e63          	beq	a4,a0,800013a0 <handle_pgfault+0xe8>
        if(p->resident_pages[i].seq < p->resident_pages[victim_inx].seq){
    80001388:	00459793          	slli	a5,a1,0x4
    8000138c:	27078793          	addi	a5,a5,624
    80001390:	97a6                	add	a5,a5,s1
    80001392:	4290                	lw	a2,0(a3)
    80001394:	479c                	lw	a5,8(a5)
    80001396:	fef655e3          	bge	a2,a5,80001380 <handle_pgfault+0xc8>
            victim_inx = i;
    8000139a:	85ba                	mv	a1,a4
    8000139c:	b7d5                	j	80001380 <handle_pgfault+0xc8>
    int victim_inx = 0;
    8000139e:	4581                	li	a1,0
    uint64 va = p->resident_pages[victim_inx].va;
    800013a0:	0592                	slli	a1,a1,0x4
    800013a2:	00b48a33          	add	s4,s1,a1
    800013a6:	270a3a83          	ld	s5,624(s4)
    int dirty = p->resident_pages[victim_inx].dirty;
    800013aa:	27ca2983          	lw	s3,636(s4)
    printf("[pid %d] VICTIM va=0x%lx seq=%d algo=FIFO\n",p->pid,va,seq);
    800013ae:	278a2683          	lw	a3,632(s4)
    800013b2:	8656                	mv	a2,s5
    800013b4:	588c                	lw	a1,48(s1)
    800013b6:	00007517          	auipc	a0,0x7
    800013ba:	d9250513          	addi	a0,a0,-622 # 80008148 <etext+0x148>
    800013be:	93cff0ef          	jal	800004fa <printf>
    if(dirty){
    800013c2:	10098563          	beqz	s3,800014cc <handle_pgfault+0x214>
        printf("[pid %d] EVICT va=0x%lx state=dirty\n",p->pid,va);
    800013c6:	8656                	mv	a2,s5
    800013c8:	588c                	lw	a1,48(s1)
    800013ca:	00007517          	auipc	a0,0x7
    800013ce:	dae50513          	addi	a0,a0,-594 # 80008178 <etext+0x178>
    800013d2:	928ff0ef          	jal	800004fa <printf>
    for(int i=0;i<MAX_SWAP_PAGES;i++){
    800013d6:	18048793          	addi	a5,s1,384
    800013da:	4981                	li	s3,0
    800013dc:	03c00693          	li	a3,60
        if(p->swap_slots[i]==0){
    800013e0:	4398                	lw	a4,0(a5)
    800013e2:	cf1d                	beqz	a4,80001420 <handle_pgfault+0x168>
    for(int i=0;i<MAX_SWAP_PAGES;i++){
    800013e4:	2985                	addiw	s3,s3,1
    800013e6:	0791                	addi	a5,a5,4
    800013e8:	fed99ce3          	bne	s3,a3,800013e0 <handle_pgfault+0x128>
            printf("[pid %d] SWAPFULL\n", p->pid);
    800013ec:	588c                	lw	a1,48(s1)
    800013ee:	00007517          	auipc	a0,0x7
    800013f2:	db250513          	addi	a0,a0,-590 # 800081a0 <etext+0x1a0>
    800013f6:	904ff0ef          	jal	800004fa <printf>
            printf("[pid %d] KILL swap-exhausted\n", p->pid);
    800013fa:	588c                	lw	a1,48(s1)
    800013fc:	00007517          	auipc	a0,0x7
    80001400:	dbc50513          	addi	a0,a0,-580 # 800081b8 <etext+0x1b8>
    80001404:	8f6ff0ef          	jal	800004fa <printf>
            kexit(-1);
    80001408:	557d                	li	a0,-1
    8000140a:	346010ef          	jal	80002750 <kexit>
            setkilled(p);
    8000140e:	8526                	mv	a0,s1
    80001410:	494010ef          	jal	800028a4 <setkilled>
            return -1;
    80001414:	557d                	li	a0,-1
    80001416:	64ae                	ld	s1,200(sp)
    80001418:	79ea                	ld	s3,184(sp)
    8000141a:	7a4a                	ld	s4,176(sp)
    8000141c:	7aaa                	ld	s5,168(sp)
    8000141e:	a425                	j	80001646 <handle_pgfault+0x38e>
            p->swap_slots[i]=1;
    80001420:	00299793          	slli	a5,s3,0x2
    80001424:	18078793          	addi	a5,a5,384
    80001428:	97a6                	add	a5,a5,s1
    8000142a:	4705                	li	a4,1
    8000142c:	c398                	sw	a4,0(a5)
        if(slot == -1){
    8000142e:	57fd                	li	a5,-1
    80001430:	faf98ee3          	beq	s3,a5,800013ec <handle_pgfault+0x134>
    80001434:	f15a                	sd	s6,160(sp)
        printf("[pid %d] SWAPOUT va=0x%lx slot=%d\n", p->pid, va, slot);
    80001436:	86ce                	mv	a3,s3
    80001438:	8656                	mv	a2,s5
    8000143a:	588c                	lw	a1,48(s1)
    8000143c:	00007517          	auipc	a0,0x7
    80001440:	d9c50513          	addi	a0,a0,-612 # 800081d8 <etext+0x1d8>
    80001444:	8b6ff0ef          	jal	800004fa <printf>
        uint64 pa = walkaddr(p->pagetable, va);
    80001448:	85d6                	mv	a1,s5
    8000144a:	68a8                	ld	a0,80(s1)
    8000144c:	bdbff0ef          	jal	80001026 <walkaddr>
    80001450:	8b2a                	mv	s6,a0
        begin_op();
    80001452:	054030ef          	jal	800044a6 <begin_op>
    if(p->swap_file == 0)
    80001456:	1784b783          	ld	a5,376(s1)
    8000145a:	cfa1                	beqz	a5,800014b2 <handle_pgfault+0x1fa>
    ilock(p->swap_file->ip);
    8000145c:	6f88                	ld	a0,24(a5)
    8000145e:	63c020ef          	jal	80003a9a <ilock>
    int result = writei(p->swap_file->ip, 0, (uint64)page_content, slot * PGSIZE, PGSIZE);
    80001462:	1784b783          	ld	a5,376(s1)
    80001466:	6705                	lui	a4,0x1
    80001468:	00c9969b          	slliw	a3,s3,0xc
    8000146c:	865a                	mv	a2,s6
    8000146e:	4581                	li	a1,0
    80001470:	6f88                	ld	a0,24(a5)
    80001472:	2ad020ef          	jal	80003f1e <writei>
    80001476:	8b2a                	mv	s6,a0
    iunlock(p->swap_file->ip);
    80001478:	1784b783          	ld	a5,376(s1)
    8000147c:	6f88                	ld	a0,24(a5)
    8000147e:	6ca020ef          	jal	80003b48 <iunlock>
        if (swap_write_page(p, slot, (char*)pa) != 0) {
    80001482:	6785                	lui	a5,0x1
    80001484:	02fb1763          	bne	s6,a5,800014b2 <handle_pgfault+0x1fa>
        end_op();
    80001488:	08e030ef          	jal	80004516 <end_op>
        p->swapped_pages[p->num_swappped_pages].va = va;
    8000148c:	00089637          	lui	a2,0x89
    80001490:	00c486b3          	add	a3,s1,a2
    80001494:	1cc6a703          	lw	a4,460(a3)
    80001498:	00471793          	slli	a5,a4,0x4
    8000149c:	97a6                	add	a5,a5,s1
    8000149e:	97b2                	add	a5,a5,a2
    800014a0:	df57b823          	sd	s5,-528(a5) # df0 <_entry-0x7ffff210>
        p->swapped_pages[p->num_swappped_pages].slot = slot;
    800014a4:	df37ac23          	sw	s3,-520(a5)
        p->num_swappped_pages++;
    800014a8:	2705                	addiw	a4,a4,1 # 1001 <_entry-0x7fffefff>
    800014aa:	1ce6a623          	sw	a4,460(a3)
    800014ae:	7b0a                	ld	s6,160(sp)
    800014b0:	a835                	j	800014ec <handle_pgfault+0x234>
            end_op();
    800014b2:	064030ef          	jal	80004516 <end_op>
            printf("[pid %d] Write failed max file size execeded\n",p->pid);
    800014b6:	588c                	lw	a1,48(s1)
    800014b8:	00007517          	auipc	a0,0x7
    800014bc:	d4850513          	addi	a0,a0,-696 # 80008200 <etext+0x200>
    800014c0:	83aff0ef          	jal	800004fa <printf>
            kexit(-1);
    800014c4:	557d                	li	a0,-1
    800014c6:	28a010ef          	jal	80002750 <kexit>
    800014ca:	bf7d                	j	80001488 <handle_pgfault+0x1d0>
        printf("[pid %d] EVICT va=0x%lx state=clean\n",p->pid,va);
    800014cc:	8656                	mv	a2,s5
    800014ce:	588c                	lw	a1,48(s1)
    800014d0:	00007517          	auipc	a0,0x7
    800014d4:	d6050513          	addi	a0,a0,-672 # 80008230 <etext+0x230>
    800014d8:	822ff0ef          	jal	800004fa <printf>
        printf("[pid %d] DISCARD va=0x%lx\n",p->pid,va);
    800014dc:	8656                	mv	a2,s5
    800014de:	588c                	lw	a1,48(s1)
    800014e0:	00007517          	auipc	a0,0x7
    800014e4:	d7850513          	addi	a0,a0,-648 # 80008258 <etext+0x258>
    800014e8:	812ff0ef          	jal	800004fa <printf>
    uvmunmap(p->pagetable,va,1,1);
    800014ec:	4685                	li	a3,1
    800014ee:	8636                	mv	a2,a3
    800014f0:	85d6                	mv	a1,s5
    800014f2:	68a8                	ld	a0,80(s1)
    800014f4:	d3bff0ef          	jal	8000122e <uvmunmap>
    p->resident_pages[victim_inx] = p->resident_pages[p->num_resident - 1];
    800014f8:	000897b7          	lui	a5,0x89
    800014fc:	97a6                	add	a5,a5,s1
    800014fe:	1b07a703          	lw	a4,432(a5) # 891b0 <_entry-0x7ff76e50>
    80001502:	377d                	addiw	a4,a4,-1
    80001504:	00471693          	slli	a3,a4,0x4
    80001508:	27068693          	addi	a3,a3,624
    8000150c:	96a6                	add	a3,a3,s1
    8000150e:	6290                	ld	a2,0(a3)
    80001510:	26ca3823          	sd	a2,624(s4)
    80001514:	6694                	ld	a3,8(a3)
    80001516:	26da3c23          	sd	a3,632(s4)
    p->num_resident--;
    8000151a:	1ae7a823          	sw	a4,432(a5)
        mem = kalloc();
    8000151e:	e26ff0ef          	jal	80000b44 <kalloc>
    80001522:	89aa                	mv	s3,a0
        if(mem == 0){
    80001524:	c119                	beqz	a0,8000152a <handle_pgfault+0x272>
    80001526:	7aaa                	ld	s5,168(sp)
    80001528:	b3c1                	j	800012e8 <handle_pgfault+0x30>
    8000152a:	f15a                	sd	s6,160(sp)
    8000152c:	ed5e                	sd	s7,152(sp)
    8000152e:	e962                	sd	s8,144(sp)
            panic("kalloc failed after eviction");
    80001530:	00007517          	auipc	a0,0x7
    80001534:	d4850513          	addi	a0,a0,-696 # 80008278 <etext+0x278>
    80001538:	aecff0ef          	jal	80000824 <panic>
            swap_slot = p->swapped_pages[i].slot;
    8000153c:	0792                	slli	a5,a5,0x4
    8000153e:	97a6                	add	a5,a5,s1
    80001540:	000896b7          	lui	a3,0x89
    80001544:	97b6                	add	a5,a5,a3
    80001546:	df87aa03          	lw	s4,-520(a5)
            p->swapped_pages[i] = p->swapped_pages[p->num_swappped_pages - 1];
    8000154a:	367d                	addiw	a2,a2,-1 # 88fff <_entry-0x7ff77001>
    8000154c:	6725                	lui	a4,0x9
    8000154e:	8df70713          	addi	a4,a4,-1825 # 88df <_entry-0x7fff7721>
    80001552:	9732                	add	a4,a4,a2
    80001554:	0712                	slli	a4,a4,0x4
    80001556:	9726                	add	a4,a4,s1
    80001558:	630c                	ld	a1,0(a4)
    8000155a:	deb7b823          	sd	a1,-528(a5)
    8000155e:	6718                	ld	a4,8(a4)
    80001560:	dee7bc23          	sd	a4,-520(a5)
            p->num_swappped_pages--;
    80001564:	96a6                	add	a3,a3,s1
    80001566:	1cc6a623          	sw	a2,460(a3) # 891cc <_entry-0x7ff76e34>
            p->swap_slots[swap_slot] = 0; // Free the slot
    8000156a:	002a1793          	slli	a5,s4,0x2
    8000156e:	18078793          	addi	a5,a5,384
    80001572:	97a6                	add	a5,a5,s1
    80001574:	0007a023          	sw	zero,0(a5)
    if(swap_slot != -1) {
    80001578:	57fd                	li	a5,-1
    8000157a:	dafa03e3          	beq	s4,a5,80001320 <handle_pgfault+0x68>
        printf("[pid %d] PAGEFAULT va=0x%lx access=%s cause=%s\n", p->pid, va, access_type, cause);
    8000157e:	00007717          	auipc	a4,0x7
    80001582:	d1a70713          	addi	a4,a4,-742 # 80008298 <etext+0x298>
    80001586:	86e6                	mv	a3,s9
    80001588:	864a                	mv	a2,s2
    8000158a:	588c                	lw	a1,48(s1)
    8000158c:	00007517          	auipc	a0,0x7
    80001590:	d1450513          	addi	a0,a0,-748 # 800082a0 <etext+0x2a0>
    80001594:	f67fe0ef          	jal	800004fa <printf>
        printf("[pid %d] SWAPIN va=0x%lx slot=%d\n", p->pid, va, swap_slot);
    80001598:	86d2                	mv	a3,s4
    8000159a:	864a                	mv	a2,s2
    8000159c:	588c                	lw	a1,48(s1)
    8000159e:	00007517          	auipc	a0,0x7
    800015a2:	d3250513          	addi	a0,a0,-718 # 800082d0 <etext+0x2d0>
    800015a6:	f55fe0ef          	jal	800004fa <printf>
        begin_op();
    800015aa:	6fd020ef          	jal	800044a6 <begin_op>
        ilock(p->swap_file->ip);
    800015ae:	1784b783          	ld	a5,376(s1)
    800015b2:	6f88                	ld	a0,24(a5)
    800015b4:	4e6020ef          	jal	80003a9a <ilock>
        if(readi(p->swap_file->ip, 0, (uint64)mem, swap_slot * PGSIZE, PGSIZE) != PGSIZE){
    800015b8:	1784b783          	ld	a5,376(s1)
    800015bc:	6705                	lui	a4,0x1
    800015be:	00ca169b          	slliw	a3,s4,0xc
    800015c2:	864e                	mv	a2,s3
    800015c4:	4581                	li	a1,0
    800015c6:	6f88                	ld	a0,24(a5)
    800015c8:	065020ef          	jal	80003e2c <readi>
    800015cc:	6785                	lui	a5,0x1
    800015ce:	08f51363          	bne	a0,a5,80001654 <handle_pgfault+0x39c>
        iunlock(p->swap_file->ip);
    800015d2:	1784b783          	ld	a5,376(s1)
    800015d6:	6f88                	ld	a0,24(a5)
    800015d8:	570020ef          	jal	80003b48 <iunlock>
        end_op();
    800015dc:	73b020ef          	jal	80004516 <end_op>
        if(mappages(pagetable, va, PGSIZE, (uint64)mem, PTE_U|PTE_R) != 0) {
    800015e0:	4749                	li	a4,18
    800015e2:	86ce                	mv	a3,s3
    800015e4:	6605                	lui	a2,0x1
    800015e6:	85ca                	mv	a1,s2
    800015e8:	856a                	mv	a0,s10
    800015ea:	a77ff0ef          	jal	80001060 <mappages>
    800015ee:	e541                	bnez	a0,80001676 <handle_pgfault+0x3be>
    if(p->num_resident >= MAX_RESIDENT_PAGES){
    800015f0:	000897b7          	lui	a5,0x89
    800015f4:	97a6                	add	a5,a5,s1
    800015f6:	1b07a703          	lw	a4,432(a5) # 891b0 <_entry-0x7ff76e50>
    800015fa:	67a5                	lui	a5,0x9
    800015fc:	8b778793          	addi	a5,a5,-1865 # 88b7 <_entry-0x7fff7749>
    80001600:	22e7ca63          	blt	a5,a4,80001834 <handle_pgfault+0x57c>
    p->resident_pages[i].va = va;
    80001604:	00471613          	slli	a2,a4,0x4
    80001608:	9626                	add	a2,a2,s1
    8000160a:	27263823          	sd	s2,624(a2) # 1270 <_entry-0x7fffed90>
    p->resident_pages[i].seq = p->next_fifo_seq++;
    8000160e:	000897b7          	lui	a5,0x89
    80001612:	97a6                	add	a5,a5,s1
    80001614:	1c87a583          	lw	a1,456(a5) # 891c8 <_entry-0x7ff76e38>
    80001618:	0015869b          	addiw	a3,a1,1
    8000161c:	1cd7a423          	sw	a3,456(a5)
    80001620:	26b62c23          	sw	a1,632(a2)
    p->resident_pages[i].dirty = 0;
    80001624:	26062e23          	sw	zero,636(a2)
    p->num_resident++;
    80001628:	2705                	addiw	a4,a4,1 # 1001 <_entry-0x7fffefff>
    8000162a:	1ae7a823          	sw	a4,432(a5)
    printf("[pid %d] RESIDENT va=0x%lx seq=%d\n", p->pid, va, p->next_fifo_seq);
    8000162e:	864a                	mv	a2,s2
    80001630:	588c                	lw	a1,48(s1)
    80001632:	00007517          	auipc	a0,0x7
    80001636:	d4e50513          	addi	a0,a0,-690 # 80008380 <etext+0x380>
    8000163a:	ec1fe0ef          	jal	800004fa <printf>
    return 0; // Success
    8000163e:	4501                	li	a0,0
}
    80001640:	64ae                	ld	s1,200(sp)
    80001642:	79ea                	ld	s3,184(sp)
    80001644:	7a4a                	ld	s4,176(sp)
}
    80001646:	60ee                	ld	ra,216(sp)
    80001648:	644e                	ld	s0,208(sp)
    8000164a:	690e                	ld	s2,192(sp)
    8000164c:	6caa                	ld	s9,136(sp)
    8000164e:	6d0a                	ld	s10,128(sp)
    80001650:	612d                	addi	sp,sp,224
    80001652:	8082                	ret
    80001654:	f556                	sd	s5,168(sp)
    80001656:	f15a                	sd	s6,160(sp)
    80001658:	ed5e                	sd	s7,152(sp)
    8000165a:	e962                	sd	s8,144(sp)
            iunlock(p->swap_file->ip);
    8000165c:	1784b783          	ld	a5,376(s1)
    80001660:	6f88                	ld	a0,24(a5)
    80001662:	4e6020ef          	jal	80003b48 <iunlock>
            end_op();
    80001666:	6b1020ef          	jal	80004516 <end_op>
            panic("swap_read_page failed");
    8000166a:	00007517          	auipc	a0,0x7
    8000166e:	c8e50513          	addi	a0,a0,-882 # 800082f8 <etext+0x2f8>
    80001672:	9b2ff0ef          	jal	80000824 <panic>
            kfree(mem); return -1;
    80001676:	854e                	mv	a0,s3
    80001678:	be4ff0ef          	jal	80000a5c <kfree>
    8000167c:	557d                	li	a0,-1
    8000167e:	64ae                	ld	s1,200(sp)
    80001680:	79ea                	ld	s3,184(sp)
    80001682:	7a4a                	ld	s4,176(sp)
    80001684:	b7c9                	j	80001646 <handle_pgfault+0x38e>
        for(int i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)) {
    80001686:	2a05                	addiw	s4,s4,1
    80001688:	038a869b          	addiw	a3,s5,56
    8000168c:	f9845783          	lhu	a5,-104(s0)
    80001690:	0cfa5563          	bge	s4,a5,8000175a <handle_pgfault+0x4a2>
            readi(p->exec_ip, 0, (uint64)&ph, off, sizeof(ph));
    80001694:	8ab6                	mv	s5,a3
    80001696:	875e                	mv	a4,s7
    80001698:	8662                	mv	a2,s8
    8000169a:	4581                	li	a1,0
    8000169c:	1704b503          	ld	a0,368(s1)
    800016a0:	78c020ef          	jal	80003e2c <readi>
            if(ph.type == ELF_PROG_LOAD && (va >= ph.vaddr && va < ph.vaddr + ph.memsz)) {
    800016a4:	f2842783          	lw	a5,-216(s0)
    800016a8:	fd679fe3          	bne	a5,s6,80001686 <handle_pgfault+0x3ce>
    800016ac:	f3843783          	ld	a5,-200(s0)
    800016b0:	fcf96be3          	bltu	s2,a5,80001686 <handle_pgfault+0x3ce>
    800016b4:	f5043703          	ld	a4,-176(s0)
    800016b8:	973e                	add	a4,a4,a5
    800016ba:	fce976e3          	bgeu	s2,a4,80001686 <handle_pgfault+0x3ce>
                file_offset = ph.off + (va - ph.vaddr);
    800016be:	0009069b          	sext.w	a3,s2
    800016c2:	0007861b          	sext.w	a2,a5
    800016c6:	f3043a03          	ld	s4,-208(s0)
    800016ca:	40fa0a3b          	subw	s4,s4,a5
    800016ce:	012a0a3b          	addw	s4,s4,s2
                file_size_to_read = ph.filesz > (va - ph.vaddr) ? ph.filesz - (va - ph.vaddr) : 0;
    800016d2:	f4843703          	ld	a4,-184(s0)
    800016d6:	40f907b3          	sub	a5,s2,a5
    800016da:	4b01                	li	s6,0
    800016dc:	00e7fb63          	bgeu	a5,a4,800016f2 <handle_pgfault+0x43a>
    800016e0:	00c707bb          	addw	a5,a4,a2
    800016e4:	9f95                	subw	a5,a5,a3
    800016e6:	8b3e                	mv	s6,a5
                if(file_size_to_read > PGSIZE) file_size_to_read = PGSIZE;
    800016e8:	6705                	lui	a4,0x1
    800016ea:	00f77363          	bgeu	a4,a5,800016f0 <handle_pgfault+0x438>
    800016ee:	6b05                	lui	s6,0x1
    800016f0:	2b01                	sext.w	s6,s6
                perm_flags = flags2perm(ph.flags) | PTE_U;
    800016f2:	f2c42503          	lw	a0,-212(s0)
    800016f6:	071030ef          	jal	80004f66 <flags2perm>
    800016fa:	8aaa                	mv	s5,a0
  asm volatile("csrr %0, stval" : "=r" (x) );
    800016fc:	14302673          	csrr	a2,stval
            printf("[pid %d] PAGEFAULT va=0x%lx access=%s cause=%s\n", p->pid, r_stval(), access_type, cause);
    80001700:	00007717          	auipc	a4,0x7
    80001704:	c1070713          	addi	a4,a4,-1008 # 80008310 <etext+0x310>
    80001708:	86e6                	mv	a3,s9
    8000170a:	588c                	lw	a1,48(s1)
    8000170c:	00007517          	auipc	a0,0x7
    80001710:	b9450513          	addi	a0,a0,-1132 # 800082a0 <etext+0x2a0>
    80001714:	de7fe0ef          	jal	800004fa <printf>
            printf("[pid %d] LOADEXEC va=0x%lx\n", p->pid, va);
    80001718:	864a                	mv	a2,s2
    8000171a:	588c                	lw	a1,48(s1)
    8000171c:	00007517          	auipc	a0,0x7
    80001720:	bfc50513          	addi	a0,a0,-1028 # 80008318 <etext+0x318>
    80001724:	dd7fe0ef          	jal	800004fa <printf>
            if(readi(p->exec_ip, 0, (uint64)mem, file_offset, file_size_to_read) != file_size_to_read) {
    80001728:	875a                	mv	a4,s6
    8000172a:	86d2                	mv	a3,s4
    8000172c:	864e                	mv	a2,s3
    8000172e:	4581                	li	a1,0
    80001730:	1704b503          	ld	a0,368(s1)
    80001734:	6f8020ef          	jal	80003e2c <readi>
    80001738:	09651363          	bne	a0,s6,800017be <handle_pgfault+0x506>
                perm_flags = flags2perm(ph.flags) | PTE_U;
    8000173c:	010ae713          	ori	a4,s5,16
            if(mappages(pagetable, va, PGSIZE, (uint64)mem, perm_flags) != 0) {
    80001740:	2701                	sext.w	a4,a4
    80001742:	86ce                	mv	a3,s3
    80001744:	6605                	lui	a2,0x1
    80001746:	85ca                	mv	a1,s2
    80001748:	856a                	mv	a0,s10
    8000174a:	917ff0ef          	jal	80001060 <mappages>
    8000174e:	e141                	bnez	a0,800017ce <handle_pgfault+0x516>
    80001750:	7aaa                	ld	s5,168(sp)
    80001752:	7b0a                	ld	s6,160(sp)
    80001754:	6bea                	ld	s7,152(sp)
    80001756:	6c4a                	ld	s8,144(sp)
    80001758:	bd61                	j	800015f0 <handle_pgfault+0x338>
    8000175a:	7aaa                	ld	s5,168(sp)
    8000175c:	7b0a                	ld	s6,160(sp)
    8000175e:	6bea                	ld	s7,152(sp)
    80001760:	6c4a                	ld	s8,144(sp)
        } else if (va < p->sz) {
    80001762:	64bc                	ld	a5,72(s1)
    80001764:	06f96d63          	bltu	s2,a5,800017de <handle_pgfault+0x526>
        } else if(va >= p->trapframe->sp - PGSIZE && va < MAXVA) {
    80001768:	6cbc                	ld	a5,88(s1)
    8000176a:	7b9c                	ld	a5,48(a5)
    8000176c:	80078793          	addi	a5,a5,-2048
    80001770:	80078793          	addi	a5,a5,-2048
    80001774:	0af96863          	bltu	s2,a5,80001824 <handle_pgfault+0x56c>
    80001778:	14302673          	csrr	a2,stval
            printf("[pid %d] PAGEFAULT va=0x%lx access=%s cause=%s\n", p->pid, r_stval(), access_type, cause);
    8000177c:	00007717          	auipc	a4,0x7
    80001780:	be470713          	addi	a4,a4,-1052 # 80008360 <etext+0x360>
    80001784:	86e6                	mv	a3,s9
    80001786:	588c                	lw	a1,48(s1)
    80001788:	00007517          	auipc	a0,0x7
    8000178c:	b1850513          	addi	a0,a0,-1256 # 800082a0 <etext+0x2a0>
    80001790:	d6bfe0ef          	jal	800004fa <printf>
            printf("[pid %d] ALLOC va=0x%lx\n", p->pid, va);
    80001794:	864a                	mv	a2,s2
    80001796:	588c                	lw	a1,48(s1)
    80001798:	00007517          	auipc	a0,0x7
    8000179c:	ba850513          	addi	a0,a0,-1112 # 80008340 <etext+0x340>
    800017a0:	d5bfe0ef          	jal	800004fa <printf>
            if(mappages(pagetable, va, PGSIZE, (uint64)mem, PTE_U|PTE_R) != 0) {
    800017a4:	4749                	li	a4,18
    800017a6:	86ce                	mv	a3,s3
    800017a8:	6605                	lui	a2,0x1
    800017aa:	85ca                	mv	a1,s2
    800017ac:	856a                	mv	a0,s10
    800017ae:	8b3ff0ef          	jal	80001060 <mappages>
    800017b2:	e2050fe3          	beqz	a0,800015f0 <handle_pgfault+0x338>
                kfree(mem); return -1;
    800017b6:	854e                	mv	a0,s3
    800017b8:	aa4ff0ef          	jal	80000a5c <kfree>
    800017bc:	a0bd                	j	8000182a <handle_pgfault+0x572>
                kfree(mem); return -1;
    800017be:	854e                	mv	a0,s3
    800017c0:	a9cff0ef          	jal	80000a5c <kfree>
    800017c4:	7aaa                	ld	s5,168(sp)
    800017c6:	7b0a                	ld	s6,160(sp)
    800017c8:	6bea                	ld	s7,152(sp)
    800017ca:	6c4a                	ld	s8,144(sp)
    800017cc:	a8b9                	j	8000182a <handle_pgfault+0x572>
                kfree(mem); return -1;
    800017ce:	854e                	mv	a0,s3
    800017d0:	a8cff0ef          	jal	80000a5c <kfree>
    800017d4:	7aaa                	ld	s5,168(sp)
    800017d6:	7b0a                	ld	s6,160(sp)
    800017d8:	6bea                	ld	s7,152(sp)
    800017da:	6c4a                	ld	s8,144(sp)
    800017dc:	a0b9                	j	8000182a <handle_pgfault+0x572>
    800017de:	14302673          	csrr	a2,stval
            printf("[pid %d] PAGEFAULT va=0x%lx access=%s cause=%s\n", p->pid, r_stval(), access_type, cause);
    800017e2:	00007717          	auipc	a4,0x7
    800017e6:	b5670713          	addi	a4,a4,-1194 # 80008338 <etext+0x338>
    800017ea:	86e6                	mv	a3,s9
    800017ec:	588c                	lw	a1,48(s1)
    800017ee:	00007517          	auipc	a0,0x7
    800017f2:	ab250513          	addi	a0,a0,-1358 # 800082a0 <etext+0x2a0>
    800017f6:	d05fe0ef          	jal	800004fa <printf>
            printf("[pid %d] ALLOC va=0x%lx\n", p->pid, va);
    800017fa:	864a                	mv	a2,s2
    800017fc:	588c                	lw	a1,48(s1)
    800017fe:	00007517          	auipc	a0,0x7
    80001802:	b4250513          	addi	a0,a0,-1214 # 80008340 <etext+0x340>
    80001806:	cf5fe0ef          	jal	800004fa <printf>
            if(mappages(pagetable, va, PGSIZE, (uint64)mem, PTE_U|PTE_R) != 0) {
    8000180a:	4749                	li	a4,18
    8000180c:	86ce                	mv	a3,s3
    8000180e:	6605                	lui	a2,0x1
    80001810:	85ca                	mv	a1,s2
    80001812:	856a                	mv	a0,s10
    80001814:	84dff0ef          	jal	80001060 <mappages>
    80001818:	dc050ce3          	beqz	a0,800015f0 <handle_pgfault+0x338>
                kfree(mem); return -1;
    8000181c:	854e                	mv	a0,s3
    8000181e:	a3eff0ef          	jal	80000a5c <kfree>
    80001822:	a021                	j	8000182a <handle_pgfault+0x572>
            kfree(mem);
    80001824:	854e                	mv	a0,s3
    80001826:	a36ff0ef          	jal	80000a5c <kfree>
                kfree(mem); return -1;
    8000182a:	557d                	li	a0,-1
    8000182c:	64ae                	ld	s1,200(sp)
    8000182e:	79ea                	ld	s3,184(sp)
    80001830:	7a4a                	ld	s4,176(sp)
    80001832:	bd11                	j	80001646 <handle_pgfault+0x38e>
    80001834:	f556                	sd	s5,168(sp)
    80001836:	f15a                	sd	s6,160(sp)
    80001838:	ed5e                	sd	s7,152(sp)
    8000183a:	e962                	sd	s8,144(sp)
        panic("Resident set full\n");
    8000183c:	00007517          	auipc	a0,0x7
    80001840:	b2c50513          	addi	a0,a0,-1236 # 80008368 <etext+0x368>
    80001844:	fe1fe0ef          	jal	80000824 <panic>
        return -1;
    80001848:	557d                	li	a0,-1
    8000184a:	bbf5                	j	80001646 <handle_pgfault+0x38e>

000000008000184c <uvmdealloc>:
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
    uint64
uvmdealloc(pagetable_t pagetable, uint64 oldsz, uint64 newsz)
{
    8000184c:	1101                	addi	sp,sp,-32
    8000184e:	ec06                	sd	ra,24(sp)
    80001850:	e822                	sd	s0,16(sp)
    80001852:	e426                	sd	s1,8(sp)
    80001854:	1000                	addi	s0,sp,32
    if(newsz >= oldsz)
        return oldsz;
    80001856:	84ae                	mv	s1,a1
    if(newsz >= oldsz)
    80001858:	00b67d63          	bgeu	a2,a1,80001872 <uvmdealloc+0x26>
    8000185c:	84b2                	mv	s1,a2

    if(PGROUNDUP(newsz) < PGROUNDUP(oldsz)){
    8000185e:	6785                	lui	a5,0x1
    80001860:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    80001862:	00f60733          	add	a4,a2,a5
    80001866:	76fd                	lui	a3,0xfffff
    80001868:	8f75                	and	a4,a4,a3
    8000186a:	97ae                	add	a5,a5,a1
    8000186c:	8ff5                	and	a5,a5,a3
    8000186e:	00f76863          	bltu	a4,a5,8000187e <uvmdealloc+0x32>
        int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
        uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
    }

    return newsz;
}
    80001872:	8526                	mv	a0,s1
    80001874:	60e2                	ld	ra,24(sp)
    80001876:	6442                	ld	s0,16(sp)
    80001878:	64a2                	ld	s1,8(sp)
    8000187a:	6105                	addi	sp,sp,32
    8000187c:	8082                	ret
        int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    8000187e:	8f99                	sub	a5,a5,a4
    80001880:	83b1                	srli	a5,a5,0xc
        uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
    80001882:	4685                	li	a3,1
    80001884:	0007861b          	sext.w	a2,a5
    80001888:	85ba                	mv	a1,a4
    8000188a:	9a5ff0ef          	jal	8000122e <uvmunmap>
    8000188e:	b7d5                	j	80001872 <uvmdealloc+0x26>

0000000080001890 <uvmalloc>:
    if(newsz < oldsz)
    80001890:	0ab66163          	bltu	a2,a1,80001932 <uvmalloc+0xa2>
{
    80001894:	715d                	addi	sp,sp,-80
    80001896:	e486                	sd	ra,72(sp)
    80001898:	e0a2                	sd	s0,64(sp)
    8000189a:	f84a                	sd	s2,48(sp)
    8000189c:	f052                	sd	s4,32(sp)
    8000189e:	ec56                	sd	s5,24(sp)
    800018a0:	e45e                	sd	s7,8(sp)
    800018a2:	0880                	addi	s0,sp,80
    800018a4:	8aaa                	mv	s5,a0
    800018a6:	8a32                	mv	s4,a2
    oldsz = PGROUNDUP(oldsz);
    800018a8:	6785                	lui	a5,0x1
    800018aa:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    800018ac:	95be                	add	a1,a1,a5
    800018ae:	77fd                	lui	a5,0xfffff
    800018b0:	00f5f933          	and	s2,a1,a5
    800018b4:	8bca                	mv	s7,s2
    for(a = oldsz; a < newsz; a += PGSIZE){
    800018b6:	08c97063          	bgeu	s2,a2,80001936 <uvmalloc+0xa6>
    800018ba:	fc26                	sd	s1,56(sp)
    800018bc:	f44e                	sd	s3,40(sp)
    800018be:	e85a                	sd	s6,16(sp)
        memset(mem, 0, PGSIZE);
    800018c0:	6985                	lui	s3,0x1
        if(mappages(pagetable, a, PGSIZE, (uint64)mem, PTE_R|PTE_U|xperm) != 0){
    800018c2:	0126eb13          	ori	s6,a3,18
        mem = kalloc();
    800018c6:	a7eff0ef          	jal	80000b44 <kalloc>
    800018ca:	84aa                	mv	s1,a0
        if(mem == 0){
    800018cc:	c50d                	beqz	a0,800018f6 <uvmalloc+0x66>
        memset(mem, 0, PGSIZE);
    800018ce:	864e                	mv	a2,s3
    800018d0:	4581                	li	a1,0
    800018d2:	c26ff0ef          	jal	80000cf8 <memset>
        if(mappages(pagetable, a, PGSIZE, (uint64)mem, PTE_R|PTE_U|xperm) != 0){
    800018d6:	875a                	mv	a4,s6
    800018d8:	86a6                	mv	a3,s1
    800018da:	864e                	mv	a2,s3
    800018dc:	85ca                	mv	a1,s2
    800018de:	8556                	mv	a0,s5
    800018e0:	f80ff0ef          	jal	80001060 <mappages>
    800018e4:	e915                	bnez	a0,80001918 <uvmalloc+0x88>
    for(a = oldsz; a < newsz; a += PGSIZE){
    800018e6:	994e                	add	s2,s2,s3
    800018e8:	fd496fe3          	bltu	s2,s4,800018c6 <uvmalloc+0x36>
    return newsz;
    800018ec:	8552                	mv	a0,s4
    800018ee:	74e2                	ld	s1,56(sp)
    800018f0:	79a2                	ld	s3,40(sp)
    800018f2:	6b42                	ld	s6,16(sp)
    800018f4:	a811                	j	80001908 <uvmalloc+0x78>
            uvmdealloc(pagetable, a, oldsz);
    800018f6:	865e                	mv	a2,s7
    800018f8:	85ca                	mv	a1,s2
    800018fa:	8556                	mv	a0,s5
    800018fc:	f51ff0ef          	jal	8000184c <uvmdealloc>
            return 0;
    80001900:	4501                	li	a0,0
    80001902:	74e2                	ld	s1,56(sp)
    80001904:	79a2                	ld	s3,40(sp)
    80001906:	6b42                	ld	s6,16(sp)
}
    80001908:	60a6                	ld	ra,72(sp)
    8000190a:	6406                	ld	s0,64(sp)
    8000190c:	7942                	ld	s2,48(sp)
    8000190e:	7a02                	ld	s4,32(sp)
    80001910:	6ae2                	ld	s5,24(sp)
    80001912:	6ba2                	ld	s7,8(sp)
    80001914:	6161                	addi	sp,sp,80
    80001916:	8082                	ret
            kfree(mem);
    80001918:	8526                	mv	a0,s1
    8000191a:	942ff0ef          	jal	80000a5c <kfree>
            uvmdealloc(pagetable, a, oldsz);
    8000191e:	865e                	mv	a2,s7
    80001920:	85ca                	mv	a1,s2
    80001922:	8556                	mv	a0,s5
    80001924:	f29ff0ef          	jal	8000184c <uvmdealloc>
            return 0;
    80001928:	4501                	li	a0,0
    8000192a:	74e2                	ld	s1,56(sp)
    8000192c:	79a2                	ld	s3,40(sp)
    8000192e:	6b42                	ld	s6,16(sp)
    80001930:	bfe1                	j	80001908 <uvmalloc+0x78>
        return oldsz;
    80001932:	852e                	mv	a0,a1
}
    80001934:	8082                	ret
    return newsz;
    80001936:	8532                	mv	a0,a2
    80001938:	bfc1                	j	80001908 <uvmalloc+0x78>

000000008000193a <freewalk>:

// Recursively free page-table pages.
// All leaf mappings must already have been removed.
    void
freewalk(pagetable_t pagetable)
{
    8000193a:	7179                	addi	sp,sp,-48
    8000193c:	f406                	sd	ra,40(sp)
    8000193e:	f022                	sd	s0,32(sp)
    80001940:	ec26                	sd	s1,24(sp)
    80001942:	e84a                	sd	s2,16(sp)
    80001944:	e44e                	sd	s3,8(sp)
    80001946:	1800                	addi	s0,sp,48
    80001948:	89aa                	mv	s3,a0
    // there are 2^9 = 512 PTEs in a page table.
    for(int i = 0; i < 512; i++){
    8000194a:	84aa                	mv	s1,a0
    8000194c:	6905                	lui	s2,0x1
    8000194e:	992a                	add	s2,s2,a0
    80001950:	a811                	j	80001964 <freewalk+0x2a>
            // this PTE points to a lower-level page table.
            uint64 child = PTE2PA(pte);
            freewalk((pagetable_t)child);
            pagetable[i] = 0;
        } else if(pte & PTE_V){
            panic("freewalk: leaf");
    80001952:	00007517          	auipc	a0,0x7
    80001956:	a5650513          	addi	a0,a0,-1450 # 800083a8 <etext+0x3a8>
    8000195a:	ecbfe0ef          	jal	80000824 <panic>
    for(int i = 0; i < 512; i++){
    8000195e:	04a1                	addi	s1,s1,8
    80001960:	03248163          	beq	s1,s2,80001982 <freewalk+0x48>
        pte_t pte = pagetable[i];
    80001964:	609c                	ld	a5,0(s1)
        if((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0){
    80001966:	0017f713          	andi	a4,a5,1
    8000196a:	db75                	beqz	a4,8000195e <freewalk+0x24>
    8000196c:	00e7f713          	andi	a4,a5,14
    80001970:	f36d                	bnez	a4,80001952 <freewalk+0x18>
            uint64 child = PTE2PA(pte);
    80001972:	83a9                	srli	a5,a5,0xa
            freewalk((pagetable_t)child);
    80001974:	00c79513          	slli	a0,a5,0xc
    80001978:	fc3ff0ef          	jal	8000193a <freewalk>
            pagetable[i] = 0;
    8000197c:	0004b023          	sd	zero,0(s1)
        if((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0){
    80001980:	bff9                	j	8000195e <freewalk+0x24>
        }
    }
    kfree((void*)pagetable);
    80001982:	854e                	mv	a0,s3
    80001984:	8d8ff0ef          	jal	80000a5c <kfree>
}
    80001988:	70a2                	ld	ra,40(sp)
    8000198a:	7402                	ld	s0,32(sp)
    8000198c:	64e2                	ld	s1,24(sp)
    8000198e:	6942                	ld	s2,16(sp)
    80001990:	69a2                	ld	s3,8(sp)
    80001992:	6145                	addi	sp,sp,48
    80001994:	8082                	ret

0000000080001996 <uvmfree>:

// Free user memory pages,
// then free page-table pages.
    void
uvmfree(pagetable_t pagetable, uint64 sz)
{
    80001996:	1101                	addi	sp,sp,-32
    80001998:	ec06                	sd	ra,24(sp)
    8000199a:	e822                	sd	s0,16(sp)
    8000199c:	e426                	sd	s1,8(sp)
    8000199e:	1000                	addi	s0,sp,32
    800019a0:	84aa                	mv	s1,a0
    if(sz > 0)
    800019a2:	e989                	bnez	a1,800019b4 <uvmfree+0x1e>
        uvmunmap(pagetable, 0, PGROUNDUP(sz)/PGSIZE, 1);
    freewalk(pagetable);
    800019a4:	8526                	mv	a0,s1
    800019a6:	f95ff0ef          	jal	8000193a <freewalk>
}
    800019aa:	60e2                	ld	ra,24(sp)
    800019ac:	6442                	ld	s0,16(sp)
    800019ae:	64a2                	ld	s1,8(sp)
    800019b0:	6105                	addi	sp,sp,32
    800019b2:	8082                	ret
        uvmunmap(pagetable, 0, PGROUNDUP(sz)/PGSIZE, 1);
    800019b4:	6785                	lui	a5,0x1
    800019b6:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    800019b8:	95be                	add	a1,a1,a5
    800019ba:	4685                	li	a3,1
    800019bc:	00c5d613          	srli	a2,a1,0xc
    800019c0:	4581                	li	a1,0
    800019c2:	86dff0ef          	jal	8000122e <uvmunmap>
    800019c6:	bff9                	j	800019a4 <uvmfree+0xe>

00000000800019c8 <uvmcopy>:
{
    pte_t *pte;
    uint64 pa, i;
    uint flags;
    char *mem;
    for(i = 0; i < sz; i += PGSIZE){
    800019c8:	ca45                	beqz	a2,80001a78 <uvmcopy+0xb0>
{
    800019ca:	715d                	addi	sp,sp,-80
    800019cc:	e486                	sd	ra,72(sp)
    800019ce:	e0a2                	sd	s0,64(sp)
    800019d0:	fc26                	sd	s1,56(sp)
    800019d2:	f84a                	sd	s2,48(sp)
    800019d4:	f44e                	sd	s3,40(sp)
    800019d6:	f052                	sd	s4,32(sp)
    800019d8:	ec56                	sd	s5,24(sp)
    800019da:	e85a                	sd	s6,16(sp)
    800019dc:	e45e                	sd	s7,8(sp)
    800019de:	e062                	sd	s8,0(sp)
    800019e0:	0880                	addi	s0,sp,80
    800019e2:	8b2a                	mv	s6,a0
    800019e4:	8bae                	mv	s7,a1
    800019e6:	8ab2                	mv	s5,a2
    for(i = 0; i < sz; i += PGSIZE){
    800019e8:	4901                	li	s2,0
        }
        pa = PTE2PA(*pte);
        flags = PTE_FLAGS(*pte);
        if((mem = kalloc()) == 0)
            goto err;
        memmove(mem, (char*)pa, PGSIZE);
    800019ea:	6a05                	lui	s4,0x1
            pte_t *child_pte = walk(new,i,1);
    800019ec:	4c05                	li	s8,1
    800019ee:	a03d                	j	80001a1c <uvmcopy+0x54>
        if((mem = kalloc()) == 0)
    800019f0:	954ff0ef          	jal	80000b44 <kalloc>
    800019f4:	84aa                	mv	s1,a0
    800019f6:	c939                	beqz	a0,80001a4c <uvmcopy+0x84>
        pa = PTE2PA(*pte);
    800019f8:	00a9d593          	srli	a1,s3,0xa
        memmove(mem, (char*)pa, PGSIZE);
    800019fc:	8652                	mv	a2,s4
    800019fe:	05b2                	slli	a1,a1,0xc
    80001a00:	b58ff0ef          	jal	80000d58 <memmove>
        if(mappages(new, i, PGSIZE, (uint64)mem, flags) != 0){
    80001a04:	3ff9f713          	andi	a4,s3,1023
    80001a08:	86a6                	mv	a3,s1
    80001a0a:	8652                	mv	a2,s4
    80001a0c:	85ca                	mv	a1,s2
    80001a0e:	855e                	mv	a0,s7
    80001a10:	e50ff0ef          	jal	80001060 <mappages>
    80001a14:	e90d                	bnez	a0,80001a46 <uvmcopy+0x7e>
    for(i = 0; i < sz; i += PGSIZE){
    80001a16:	9952                	add	s2,s2,s4
    80001a18:	05597363          	bgeu	s2,s5,80001a5e <uvmcopy+0x96>
        if((pte = walk(old, i, 0)) == 0)
    80001a1c:	4601                	li	a2,0
    80001a1e:	85ca                	mv	a1,s2
    80001a20:	855a                	mv	a0,s6
    80001a22:	d6aff0ef          	jal	80000f8c <walk>
    80001a26:	84aa                	mv	s1,a0
    80001a28:	d57d                	beqz	a0,80001a16 <uvmcopy+0x4e>
        if((*pte & PTE_V) == 0){
    80001a2a:	00053983          	ld	s3,0(a0)
    80001a2e:	0019f793          	andi	a5,s3,1
    80001a32:	ffdd                	bnez	a5,800019f0 <uvmcopy+0x28>
            pte_t *child_pte = walk(new,i,1);
    80001a34:	8662                	mv	a2,s8
    80001a36:	85ca                	mv	a1,s2
    80001a38:	855e                	mv	a0,s7
    80001a3a:	d52ff0ef          	jal	80000f8c <walk>
            if(child_pte == 0)
    80001a3e:	c519                	beqz	a0,80001a4c <uvmcopy+0x84>
            *child_pte = *pte;
    80001a40:	609c                	ld	a5,0(s1)
    80001a42:	e11c                	sd	a5,0(a0)
            continue;
    80001a44:	bfc9                	j	80001a16 <uvmcopy+0x4e>
            kfree(mem);
    80001a46:	8526                	mv	a0,s1
    80001a48:	814ff0ef          	jal	80000a5c <kfree>
        }
    }
    return 0;

err:
    uvmunmap(new, 0, i / PGSIZE, 1);
    80001a4c:	4685                	li	a3,1
    80001a4e:	00c95613          	srli	a2,s2,0xc
    80001a52:	4581                	li	a1,0
    80001a54:	855e                	mv	a0,s7
    80001a56:	fd8ff0ef          	jal	8000122e <uvmunmap>
    return -1;
    80001a5a:	557d                	li	a0,-1
    80001a5c:	a011                	j	80001a60 <uvmcopy+0x98>
    return 0;
    80001a5e:	4501                	li	a0,0
}
    80001a60:	60a6                	ld	ra,72(sp)
    80001a62:	6406                	ld	s0,64(sp)
    80001a64:	74e2                	ld	s1,56(sp)
    80001a66:	7942                	ld	s2,48(sp)
    80001a68:	79a2                	ld	s3,40(sp)
    80001a6a:	7a02                	ld	s4,32(sp)
    80001a6c:	6ae2                	ld	s5,24(sp)
    80001a6e:	6b42                	ld	s6,16(sp)
    80001a70:	6ba2                	ld	s7,8(sp)
    80001a72:	6c02                	ld	s8,0(sp)
    80001a74:	6161                	addi	sp,sp,80
    80001a76:	8082                	ret
    return 0;
    80001a78:	4501                	li	a0,0
}
    80001a7a:	8082                	ret

0000000080001a7c <uvmclear>:
*/
// mark a PTE invalid for user access.
// used by exec for the user stack guard page.
    void
uvmclear(pagetable_t pagetable, uint64 va)
{
    80001a7c:	1141                	addi	sp,sp,-16
    80001a7e:	e406                	sd	ra,8(sp)
    80001a80:	e022                	sd	s0,0(sp)
    80001a82:	0800                	addi	s0,sp,16
    pte_t *pte;

    pte = walk(pagetable, va, 0);
    80001a84:	4601                	li	a2,0
    80001a86:	d06ff0ef          	jal	80000f8c <walk>
    if(pte == 0)
    80001a8a:	c901                	beqz	a0,80001a9a <uvmclear+0x1e>
        panic("uvmclear");
    *pte &= ~PTE_U;
    80001a8c:	611c                	ld	a5,0(a0)
    80001a8e:	9bbd                	andi	a5,a5,-17
    80001a90:	e11c                	sd	a5,0(a0)
}
    80001a92:	60a2                	ld	ra,8(sp)
    80001a94:	6402                	ld	s0,0(sp)
    80001a96:	0141                	addi	sp,sp,16
    80001a98:	8082                	ret
        panic("uvmclear");
    80001a9a:	00007517          	auipc	a0,0x7
    80001a9e:	91e50513          	addi	a0,a0,-1762 # 800083b8 <etext+0x3b8>
    80001aa2:	d83fe0ef          	jal	80000824 <panic>

0000000080001aa6 <copyout>:
// Copy from kernel to user.
// Copy len bytes from src to virtual address dstva in a given page table.
// Return 0 on success, -1 on error.
    int
copyout(pagetable_t pagetable, uint64 dstva, char *src, uint64 len)
{
    80001aa6:	7159                	addi	sp,sp,-112
    80001aa8:	f486                	sd	ra,104(sp)
    80001aaa:	f0a2                	sd	s0,96(sp)
    80001aac:	e0d2                	sd	s4,64(sp)
    80001aae:	fc56                	sd	s5,56(sp)
    80001ab0:	f85a                	sd	s6,48(sp)
    80001ab2:	f45e                	sd	s7,40(sp)
    80001ab4:	e46e                	sd	s11,8(sp)
    80001ab6:	1880                	addi	s0,sp,112
    80001ab8:	8b2a                	mv	s6,a0
    80001aba:	8a2e                	mv	s4,a1
    80001abc:	8bb2                	mv	s7,a2
    80001abe:	8ab6                	mv	s5,a3
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001ac0:	14202773          	csrr	a4,scause
    const char* access_type;
    if (r_scause() == 12) { access_type = "exec"; }
    80001ac4:	47b1                	li	a5,12
    80001ac6:	00007d97          	auipc	s11,0x7
    80001aca:	84ad8d93          	addi	s11,s11,-1974 # 80008310 <etext+0x310>
    80001ace:	00f70b63          	beq	a4,a5,80001ae4 <copyout+0x3e>
    80001ad2:	14202773          	csrr	a4,scause
    else if (r_scause() == 13) { access_type = "read"; }
    80001ad6:	47b5                	li	a5,13
    else { access_type = "write"; }
    80001ad8:	00007d97          	auipc	s11,0x7
    80001adc:	8f0d8d93          	addi	s11,s11,-1808 # 800083c8 <etext+0x3c8>
    else if (r_scause() == 13) { access_type = "read"; }
    80001ae0:	02f70063          	beq	a4,a5,80001b00 <copyout+0x5a>

    uint64 n, va0, pa0;
    pte_t *pte;

    while(len > 0){
    80001ae4:	0a0a8663          	beqz	s5,80001b90 <copyout+0xea>
    80001ae8:	eca6                	sd	s1,88(sp)
    80001aea:	e8ca                	sd	s2,80(sp)
    80001aec:	e4ce                	sd	s3,72(sp)
    80001aee:	f062                	sd	s8,32(sp)
    80001af0:	ec66                	sd	s9,24(sp)
    80001af2:	e86a                	sd	s10,16(sp)
        va0 = PGROUNDDOWN(dstva);
    80001af4:	7d7d                	lui	s10,0xfffff
        if(va0 >= MAXVA)
    80001af6:	5cfd                	li	s9,-1
    80001af8:	01acdc93          	srli	s9,s9,0x1a
        pte = walk(pagetable, va0, 0);
        // forbid copyout over read-only user text pages.
        if((*pte & PTE_W) == 0)
            return -1;

        n = PGSIZE - (dstva - va0);
    80001afc:	6c05                	lui	s8,0x1
    80001afe:	a099                	j	80001b44 <copyout+0x9e>
    else if (r_scause() == 13) { access_type = "read"; }
    80001b00:	00007d97          	auipc	s11,0x7
    80001b04:	ca0d8d93          	addi	s11,s11,-864 # 800087a0 <etext+0x7a0>
    80001b08:	bff1                	j	80001ae4 <copyout+0x3e>
        pte = walk(pagetable, va0, 0);
    80001b0a:	4601                	li	a2,0
    80001b0c:	85a6                	mv	a1,s1
    80001b0e:	855a                	mv	a0,s6
    80001b10:	c7cff0ef          	jal	80000f8c <walk>
        if((*pte & PTE_W) == 0)
    80001b14:	611c                	ld	a5,0(a0)
    80001b16:	8b91                	andi	a5,a5,4
    80001b18:	c7d5                	beqz	a5,80001bc4 <copyout+0x11e>
        n = PGSIZE - (dstva - va0);
    80001b1a:	41448933          	sub	s2,s1,s4
    80001b1e:	9962                	add	s2,s2,s8
        if(n > len)
    80001b20:	012af363          	bgeu	s5,s2,80001b26 <copyout+0x80>
    80001b24:	8956                	mv	s2,s5
            n = len;
        memmove((void *)(pa0 + (dstva - va0)), src, n);
    80001b26:	409a0533          	sub	a0,s4,s1
    80001b2a:	0009061b          	sext.w	a2,s2
    80001b2e:	85de                	mv	a1,s7
    80001b30:	954e                	add	a0,a0,s3
    80001b32:	a26ff0ef          	jal	80000d58 <memmove>

        len -= n;
    80001b36:	412a8ab3          	sub	s5,s5,s2
        src += n;
    80001b3a:	9bca                	add	s7,s7,s2
        dstva = va0 + PGSIZE;
    80001b3c:	01848a33          	add	s4,s1,s8
    while(len > 0){
    80001b40:	040a8063          	beqz	s5,80001b80 <copyout+0xda>
        va0 = PGROUNDDOWN(dstva);
    80001b44:	01aa74b3          	and	s1,s4,s10
        if(va0 >= MAXVA)
    80001b48:	049ce663          	bltu	s9,s1,80001b94 <copyout+0xee>
        pa0 = walkaddr(pagetable, va0);
    80001b4c:	85a6                	mv	a1,s1
    80001b4e:	855a                	mv	a0,s6
    80001b50:	cd6ff0ef          	jal	80001026 <walkaddr>
    80001b54:	89aa                	mv	s3,a0
        if(pa0 == 0) {
    80001b56:	f955                	bnez	a0,80001b0a <copyout+0x64>
            if(handle_pgfault(pagetable, va0,access_type) != 0) {
    80001b58:	866e                	mv	a2,s11
    80001b5a:	85a6                	mv	a1,s1
    80001b5c:	855a                	mv	a0,s6
    80001b5e:	f5aff0ef          	jal	800012b8 <handle_pgfault>
    80001b62:	e929                	bnez	a0,80001bb4 <copyout+0x10e>
            pa0 = walkaddr(pagetable, va0); // Retry getting the address
    80001b64:	85a6                	mv	a1,s1
    80001b66:	855a                	mv	a0,s6
    80001b68:	cbeff0ef          	jal	80001026 <walkaddr>
    80001b6c:	89aa                	mv	s3,a0
            if(pa0 == 0) 
    80001b6e:	fd51                	bnez	a0,80001b0a <copyout+0x64>
                return -1;
    80001b70:	557d                	li	a0,-1
    80001b72:	64e6                	ld	s1,88(sp)
    80001b74:	6946                	ld	s2,80(sp)
    80001b76:	69a6                	ld	s3,72(sp)
    80001b78:	7c02                	ld	s8,32(sp)
    80001b7a:	6ce2                	ld	s9,24(sp)
    80001b7c:	6d42                	ld	s10,16(sp)
    80001b7e:	a015                	j	80001ba2 <copyout+0xfc>
    }
    return 0;
    80001b80:	4501                	li	a0,0
    80001b82:	64e6                	ld	s1,88(sp)
    80001b84:	6946                	ld	s2,80(sp)
    80001b86:	69a6                	ld	s3,72(sp)
    80001b88:	7c02                	ld	s8,32(sp)
    80001b8a:	6ce2                	ld	s9,24(sp)
    80001b8c:	6d42                	ld	s10,16(sp)
    80001b8e:	a811                	j	80001ba2 <copyout+0xfc>
    80001b90:	4501                	li	a0,0
    80001b92:	a801                	j	80001ba2 <copyout+0xfc>
            return -1;
    80001b94:	557d                	li	a0,-1
    80001b96:	64e6                	ld	s1,88(sp)
    80001b98:	6946                	ld	s2,80(sp)
    80001b9a:	69a6                	ld	s3,72(sp)
    80001b9c:	7c02                	ld	s8,32(sp)
    80001b9e:	6ce2                	ld	s9,24(sp)
    80001ba0:	6d42                	ld	s10,16(sp)
}
    80001ba2:	70a6                	ld	ra,104(sp)
    80001ba4:	7406                	ld	s0,96(sp)
    80001ba6:	6a06                	ld	s4,64(sp)
    80001ba8:	7ae2                	ld	s5,56(sp)
    80001baa:	7b42                	ld	s6,48(sp)
    80001bac:	7ba2                	ld	s7,40(sp)
    80001bae:	6da2                	ld	s11,8(sp)
    80001bb0:	6165                	addi	sp,sp,112
    80001bb2:	8082                	ret
                return -1;
    80001bb4:	557d                	li	a0,-1
    80001bb6:	64e6                	ld	s1,88(sp)
    80001bb8:	6946                	ld	s2,80(sp)
    80001bba:	69a6                	ld	s3,72(sp)
    80001bbc:	7c02                	ld	s8,32(sp)
    80001bbe:	6ce2                	ld	s9,24(sp)
    80001bc0:	6d42                	ld	s10,16(sp)
    80001bc2:	b7c5                	j	80001ba2 <copyout+0xfc>
            return -1;
    80001bc4:	557d                	li	a0,-1
    80001bc6:	64e6                	ld	s1,88(sp)
    80001bc8:	6946                	ld	s2,80(sp)
    80001bca:	69a6                	ld	s3,72(sp)
    80001bcc:	7c02                	ld	s8,32(sp)
    80001bce:	6ce2                	ld	s9,24(sp)
    80001bd0:	6d42                	ld	s10,16(sp)
    80001bd2:	bfc1                	j	80001ba2 <copyout+0xfc>

0000000080001bd4 <copyin>:
// Copy from user to kernel.
// Copy len bytes to dst from virtual address srcva in a given page table.
// Return 0 on success, -1 on error.
    int
copyin(pagetable_t pagetable, char *dst, uint64 srcva, uint64 len)
{
    80001bd4:	711d                	addi	sp,sp,-96
    80001bd6:	ec86                	sd	ra,88(sp)
    80001bd8:	e8a2                	sd	s0,80(sp)
    80001bda:	e0ca                	sd	s2,64(sp)
    80001bdc:	f852                	sd	s4,48(sp)
    80001bde:	f456                	sd	s5,40(sp)
    80001be0:	f05a                	sd	s6,32(sp)
    80001be2:	ec5e                	sd	s7,24(sp)
    80001be4:	e862                	sd	s8,16(sp)
    80001be6:	e466                	sd	s9,8(sp)
    80001be8:	1080                	addi	s0,sp,96
    80001bea:	8b2a                	mv	s6,a0
    80001bec:	8aae                	mv	s5,a1
    80001bee:	8932                	mv	s2,a2
    80001bf0:	8a36                	mv	s4,a3
    80001bf2:	14202773          	csrr	a4,scause
    const char* access_type;
    if (r_scause() == 12) { access_type = "exec"; }
    80001bf6:	47b1                	li	a5,12
    80001bf8:	00006c97          	auipc	s9,0x6
    80001bfc:	718c8c93          	addi	s9,s9,1816 # 80008310 <etext+0x310>
    80001c00:	00f70b63          	beq	a4,a5,80001c16 <copyin+0x42>
    80001c04:	14202773          	csrr	a4,scause
    else if (r_scause() == 13) { access_type = "read"; }
    80001c08:	47b5                	li	a5,13
    else { access_type = "write"; }
    80001c0a:	00006c97          	auipc	s9,0x6
    80001c0e:	7bec8c93          	addi	s9,s9,1982 # 800083c8 <etext+0x3c8>
    else if (r_scause() == 13) { access_type = "read"; }
    80001c12:	00f70a63          	beq	a4,a5,80001c26 <copyin+0x52>


    uint64 n, va0, pa0;

    while(len > 0){
        va0 = PGROUNDDOWN(srcva);
    80001c16:	7c7d                	lui	s8,0xfffff
            }
            pa0 = walkaddr(pagetable, va0); 
            if(pa0 == 0)
                return -1;
        }
        n = PGSIZE - (srcva - va0);
    80001c18:	6b85                	lui	s7,0x1

        len -= n;
        dst += n;
        srcva = va0 + PGSIZE;
    }
    return 0;
    80001c1a:	4501                	li	a0,0
    while(len > 0){
    80001c1c:	060a0863          	beqz	s4,80001c8c <copyin+0xb8>
    80001c20:	e4a6                	sd	s1,72(sp)
    80001c22:	fc4e                	sd	s3,56(sp)
    80001c24:	a81d                	j	80001c5a <copyin+0x86>
    else if (r_scause() == 13) { access_type = "read"; }
    80001c26:	00007c97          	auipc	s9,0x7
    80001c2a:	b7ac8c93          	addi	s9,s9,-1158 # 800087a0 <etext+0x7a0>
    80001c2e:	b7e5                	j	80001c16 <copyin+0x42>
        n = PGSIZE - (srcva - va0);
    80001c30:	412984b3          	sub	s1,s3,s2
    80001c34:	94de                	add	s1,s1,s7
        if(n > len)
    80001c36:	009a7363          	bgeu	s4,s1,80001c3c <copyin+0x68>
    80001c3a:	84d2                	mv	s1,s4
        memmove(dst, (void *)(pa0 + (srcva - va0)), n);
    80001c3c:	413905b3          	sub	a1,s2,s3
    80001c40:	0004861b          	sext.w	a2,s1
    80001c44:	95aa                	add	a1,a1,a0
    80001c46:	8556                	mv	a0,s5
    80001c48:	910ff0ef          	jal	80000d58 <memmove>
        len -= n;
    80001c4c:	409a0a33          	sub	s4,s4,s1
        dst += n;
    80001c50:	9aa6                	add	s5,s5,s1
        srcva = va0 + PGSIZE;
    80001c52:	01798933          	add	s2,s3,s7
    while(len > 0){
    80001c56:	020a0863          	beqz	s4,80001c86 <copyin+0xb2>
        va0 = PGROUNDDOWN(srcva);
    80001c5a:	018979b3          	and	s3,s2,s8
        pa0 = walkaddr(pagetable, va0);
    80001c5e:	85ce                	mv	a1,s3
    80001c60:	855a                	mv	a0,s6
    80001c62:	bc4ff0ef          	jal	80001026 <walkaddr>
        if(pa0 == 0) {
    80001c66:	f569                	bnez	a0,80001c30 <copyin+0x5c>
            if(handle_pgfault(pagetable, va0,access_type) != 0) {
    80001c68:	8666                	mv	a2,s9
    80001c6a:	85ce                	mv	a1,s3
    80001c6c:	855a                	mv	a0,s6
    80001c6e:	e4aff0ef          	jal	800012b8 <handle_pgfault>
    80001c72:	e905                	bnez	a0,80001ca2 <copyin+0xce>
            pa0 = walkaddr(pagetable, va0); 
    80001c74:	85ce                	mv	a1,s3
    80001c76:	855a                	mv	a0,s6
    80001c78:	baeff0ef          	jal	80001026 <walkaddr>
            if(pa0 == 0)
    80001c7c:	f955                	bnez	a0,80001c30 <copyin+0x5c>
                return -1;
    80001c7e:	557d                	li	a0,-1
    80001c80:	64a6                	ld	s1,72(sp)
    80001c82:	79e2                	ld	s3,56(sp)
    80001c84:	a021                	j	80001c8c <copyin+0xb8>
    return 0;
    80001c86:	4501                	li	a0,0
    80001c88:	64a6                	ld	s1,72(sp)
    80001c8a:	79e2                	ld	s3,56(sp)
}
    80001c8c:	60e6                	ld	ra,88(sp)
    80001c8e:	6446                	ld	s0,80(sp)
    80001c90:	6906                	ld	s2,64(sp)
    80001c92:	7a42                	ld	s4,48(sp)
    80001c94:	7aa2                	ld	s5,40(sp)
    80001c96:	7b02                	ld	s6,32(sp)
    80001c98:	6be2                	ld	s7,24(sp)
    80001c9a:	6c42                	ld	s8,16(sp)
    80001c9c:	6ca2                	ld	s9,8(sp)
    80001c9e:	6125                	addi	sp,sp,96
    80001ca0:	8082                	ret
                return -1;
    80001ca2:	557d                	li	a0,-1
    80001ca4:	64a6                	ld	s1,72(sp)
    80001ca6:	79e2                	ld	s3,56(sp)
    80001ca8:	b7d5                	j	80001c8c <copyin+0xb8>

0000000080001caa <copyinstr>:
// Copy bytes to dst from virtual address srcva in a given page table,
// until a '\0', or max.
// Return 0 on success, -1 on error.
    int
copyinstr(pagetable_t pagetable, char *dst, uint64 srcva, uint64 max)
{
    80001caa:	715d                	addi	sp,sp,-80
    80001cac:	e486                	sd	ra,72(sp)
    80001cae:	e0a2                	sd	s0,64(sp)
    80001cb0:	fc26                	sd	s1,56(sp)
    80001cb2:	f44e                	sd	s3,40(sp)
    80001cb4:	f052                	sd	s4,32(sp)
    80001cb6:	ec56                	sd	s5,24(sp)
    80001cb8:	e85a                	sd	s6,16(sp)
    80001cba:	e45e                	sd	s7,8(sp)
    80001cbc:	0880                	addi	s0,sp,80
    80001cbe:	8aaa                	mv	s5,a0
    80001cc0:	84ae                	mv	s1,a1
    80001cc2:	8bb2                	mv	s7,a2
    80001cc4:	89b6                	mv	s3,a3
    80001cc6:	14202773          	csrr	a4,scause
    const char* access_type;
    if (r_scause() == 12) { access_type = "exec"; }
    80001cca:	47b1                	li	a5,12
    80001ccc:	00f70463          	beq	a4,a5,80001cd4 <copyinstr+0x2a>
    80001cd0:	142027f3          	csrr	a5,scause
    else if (r_scause() == 13) { access_type = "read"; }
    else { access_type = "write"; }
    uint64 n, va0, pa0;
    int got_null = 0;
    while(got_null == 0 && max > 0){
        va0 = PGROUNDDOWN(srcva);
    80001cd4:	7b7d                	lui	s6,0xfffff
                return -1;
            }
            pa0 = walkaddr(pagetable, va0); // Retry
            if(pa0 == 0) return -1;
        }
        n = PGSIZE - (srcva - va0);
    80001cd6:	6a05                	lui	s4,0x1
    while(got_null == 0 && max > 0){
    80001cd8:	4781                	li	a5,0
    80001cda:	00098863          	beqz	s3,80001cea <copyinstr+0x40>
    80001cde:	f84a                	sd	s2,48(sp)
    80001ce0:	a82d                	j	80001d1a <copyinstr+0x70>
        if(n > max)
            n = max;
        char *p = (char *) (pa0 + (srcva - va0));
        while(n > 0){
            if(*p == '\0'){
                *dst = '\0';
    80001ce2:	00078023          	sb	zero,0(a5)
                got_null = 1;
    80001ce6:	4785                	li	a5,1
    80001ce8:	7942                	ld	s2,48(sp)
            p++;
            dst++;
        }
        srcva = va0 + PGSIZE;
    }
    if(got_null){
    80001cea:	0017c793          	xori	a5,a5,1
    80001cee:	40f0053b          	negw	a0,a5
        return 0;
    } else {
        return -1;
    }
}
    80001cf2:	60a6                	ld	ra,72(sp)
    80001cf4:	6406                	ld	s0,64(sp)
    80001cf6:	74e2                	ld	s1,56(sp)
    80001cf8:	79a2                	ld	s3,40(sp)
    80001cfa:	7a02                	ld	s4,32(sp)
    80001cfc:	6ae2                	ld	s5,24(sp)
    80001cfe:	6b42                	ld	s6,16(sp)
    80001d00:	6ba2                	ld	s7,8(sp)
    80001d02:	6161                	addi	sp,sp,80
    80001d04:	8082                	ret
    80001d06:	fff98713          	addi	a4,s3,-1 # fff <_entry-0x7ffff001>
    80001d0a:	9726                	add	a4,a4,s1
            --max;
    80001d0c:	40b709b3          	sub	s3,a4,a1
        srcva = va0 + PGSIZE;
    80001d10:	01490bb3          	add	s7,s2,s4
    while(got_null == 0 && max > 0){
    80001d14:	04e58463          	beq	a1,a4,80001d5c <copyinstr+0xb2>
{
    80001d18:	84be                	mv	s1,a5
        va0 = PGROUNDDOWN(srcva);
    80001d1a:	016bf933          	and	s2,s7,s6
        pa0 = walkaddr(pagetable, va0);
    80001d1e:	85ca                	mv	a1,s2
    80001d20:	8556                	mv	a0,s5
    80001d22:	b04ff0ef          	jal	80001026 <walkaddr>
        if(pa0 == 0){
    80001d26:	cd15                	beqz	a0,80001d62 <copyinstr+0xb8>
        n = PGSIZE - (srcva - va0);
    80001d28:	417906b3          	sub	a3,s2,s7
    80001d2c:	96d2                	add	a3,a3,s4
        if(n > max)
    80001d2e:	00d9f363          	bgeu	s3,a3,80001d34 <copyinstr+0x8a>
    80001d32:	86ce                	mv	a3,s3
        while(n > 0){
    80001d34:	ca95                	beqz	a3,80001d68 <copyinstr+0xbe>
        char *p = (char *) (pa0 + (srcva - va0));
    80001d36:	01750633          	add	a2,a0,s7
    80001d3a:	41260633          	sub	a2,a2,s2
    80001d3e:	87a6                	mv	a5,s1
            if(*p == '\0'){
    80001d40:	8e05                	sub	a2,a2,s1
        while(n > 0){
    80001d42:	96a6                	add	a3,a3,s1
    80001d44:	85be                	mv	a1,a5
            if(*p == '\0'){
    80001d46:	00f60733          	add	a4,a2,a5
    80001d4a:	00074703          	lbu	a4,0(a4)
    80001d4e:	db51                	beqz	a4,80001ce2 <copyinstr+0x38>
                *dst = *p;
    80001d50:	00e78023          	sb	a4,0(a5)
            dst++;
    80001d54:	0785                	addi	a5,a5,1
        while(n > 0){
    80001d56:	fed797e3          	bne	a5,a3,80001d44 <copyinstr+0x9a>
    80001d5a:	b775                	j	80001d06 <copyinstr+0x5c>
    80001d5c:	4781                	li	a5,0
    80001d5e:	7942                	ld	s2,48(sp)
    80001d60:	b769                	j	80001cea <copyinstr+0x40>
            return-1;
    80001d62:	557d                	li	a0,-1
    80001d64:	7942                	ld	s2,48(sp)
    80001d66:	b771                	j	80001cf2 <copyinstr+0x48>
        srcva = va0 + PGSIZE;
    80001d68:	6b85                	lui	s7,0x1
    80001d6a:	9bca                	add	s7,s7,s2
    80001d6c:	87a6                	mv	a5,s1
    80001d6e:	b76d                	j	80001d18 <copyinstr+0x6e>

0000000080001d70 <ismapped>:
// out of physical memory, and physical address if successful.


    int
ismapped(pagetable_t pagetable, uint64 va)
{
    80001d70:	1141                	addi	sp,sp,-16
    80001d72:	e406                	sd	ra,8(sp)
    80001d74:	e022                	sd	s0,0(sp)
    80001d76:	0800                	addi	s0,sp,16
    pte_t *pte = walk(pagetable, va, 0);
    80001d78:	4601                	li	a2,0
    80001d7a:	a12ff0ef          	jal	80000f8c <walk>
    if (pte == 0) {
    80001d7e:	c119                	beqz	a0,80001d84 <ismapped+0x14>
        return 0;
    }
    if (*pte & PTE_V){
    80001d80:	6108                	ld	a0,0(a0)
    80001d82:	8905                	andi	a0,a0,1
        return 1;
    }
    return 0;
}
    80001d84:	60a2                	ld	ra,8(sp)
    80001d86:	6402                	ld	s0,0(sp)
    80001d88:	0141                	addi	sp,sp,16
    80001d8a:	8082                	ret

0000000080001d8c <proc_mapstacks>:
// Allocate a page for each process's kernel stack.
// Map it high in memory, followed by an invalid
// guard page.
void
proc_mapstacks(pagetable_t kpgtbl)
{
    80001d8c:	711d                	addi	sp,sp,-96
    80001d8e:	ec86                	sd	ra,88(sp)
    80001d90:	e8a2                	sd	s0,80(sp)
    80001d92:	e4a6                	sd	s1,72(sp)
    80001d94:	e0ca                	sd	s2,64(sp)
    80001d96:	fc4e                	sd	s3,56(sp)
    80001d98:	f852                	sd	s4,48(sp)
    80001d9a:	f456                	sd	s5,40(sp)
    80001d9c:	f05a                	sd	s6,32(sp)
    80001d9e:	ec5e                	sd	s7,24(sp)
    80001da0:	e862                	sd	s8,16(sp)
    80001da2:	e466                	sd	s9,8(sp)
    80001da4:	1080                	addi	s0,sp,96
    80001da6:	8aaa                	mv	s5,a0
  struct proc *p;
  
  for(p = proc; p < &proc[NPROC]; p++) {
    80001da8:	00012497          	auipc	s1,0x12
    80001dac:	f5048493          	addi	s1,s1,-176 # 80013cf8 <proc>
    char *pa = kalloc();
    if(pa == 0)
      panic("kalloc");
    uint64 va = KSTACK((int) (p - proc));
    80001db0:	8ca6                	mv	s9,s1
    80001db2:	783c87b7          	lui	a5,0x783c8
    80001db6:	13578793          	addi	a5,a5,309 # 783c8135 <_entry-0x7c37ecb>
    80001dba:	3de5d937          	lui	s2,0x3de5d
    80001dbe:	090a                	slli	s2,s2,0x2
    80001dc0:	4e290913          	addi	s2,s2,1250 # 3de5d4e2 <_entry-0x421a2b1e>
    80001dc4:	1902                	slli	s2,s2,0x20
    80001dc6:	993e                	add	s2,s2,a5
    80001dc8:	040009b7          	lui	s3,0x4000
    80001dcc:	19fd                	addi	s3,s3,-1 # 3ffffff <_entry-0x7c000001>
    80001dce:	09b2                	slli	s3,s3,0xc
    kvmmap(kpgtbl, va, (uint64)pa, PGSIZE, PTE_R | PTE_W);
    80001dd0:	4c19                	li	s8,6
    80001dd2:	6b85                	lui	s7,0x1
  for(p = proc; p < &proc[NPROC]; p++) {
    80001dd4:	00089a37          	lui	s4,0x89
    80001dd8:	1d0a0a13          	addi	s4,s4,464 # 891d0 <_entry-0x7ff76e30>
    80001ddc:	02259b17          	auipc	s6,0x2259
    80001de0:	31cb0b13          	addi	s6,s6,796 # 8225b0f8 <tickslock>
    char *pa = kalloc();
    80001de4:	d61fe0ef          	jal	80000b44 <kalloc>
    80001de8:	862a                	mv	a2,a0
    if(pa == 0)
    80001dea:	c121                	beqz	a0,80001e2a <proc_mapstacks+0x9e>
    uint64 va = KSTACK((int) (p - proc));
    80001dec:	419485b3          	sub	a1,s1,s9
    80001df0:	8591                	srai	a1,a1,0x4
    80001df2:	032585b3          	mul	a1,a1,s2
    80001df6:	05b6                	slli	a1,a1,0xd
    80001df8:	6789                	lui	a5,0x2
    80001dfa:	9dbd                	addw	a1,a1,a5
    kvmmap(kpgtbl, va, (uint64)pa, PGSIZE, PTE_R | PTE_W);
    80001dfc:	8762                	mv	a4,s8
    80001dfe:	86de                	mv	a3,s7
    80001e00:	40b985b3          	sub	a1,s3,a1
    80001e04:	8556                	mv	a0,s5
    80001e06:	b10ff0ef          	jal	80001116 <kvmmap>
  for(p = proc; p < &proc[NPROC]; p++) {
    80001e0a:	94d2                	add	s1,s1,s4
    80001e0c:	fd649ce3          	bne	s1,s6,80001de4 <proc_mapstacks+0x58>
  }
}
    80001e10:	60e6                	ld	ra,88(sp)
    80001e12:	6446                	ld	s0,80(sp)
    80001e14:	64a6                	ld	s1,72(sp)
    80001e16:	6906                	ld	s2,64(sp)
    80001e18:	79e2                	ld	s3,56(sp)
    80001e1a:	7a42                	ld	s4,48(sp)
    80001e1c:	7aa2                	ld	s5,40(sp)
    80001e1e:	7b02                	ld	s6,32(sp)
    80001e20:	6be2                	ld	s7,24(sp)
    80001e22:	6c42                	ld	s8,16(sp)
    80001e24:	6ca2                	ld	s9,8(sp)
    80001e26:	6125                	addi	sp,sp,96
    80001e28:	8082                	ret
      panic("kalloc");
    80001e2a:	00006517          	auipc	a0,0x6
    80001e2e:	5a650513          	addi	a0,a0,1446 # 800083d0 <etext+0x3d0>
    80001e32:	9f3fe0ef          	jal	80000824 <panic>

0000000080001e36 <procinit>:

// initialize the proc table.
void
procinit(void)
{
    80001e36:	715d                	addi	sp,sp,-80
    80001e38:	e486                	sd	ra,72(sp)
    80001e3a:	e0a2                	sd	s0,64(sp)
    80001e3c:	fc26                	sd	s1,56(sp)
    80001e3e:	f84a                	sd	s2,48(sp)
    80001e40:	f44e                	sd	s3,40(sp)
    80001e42:	f052                	sd	s4,32(sp)
    80001e44:	ec56                	sd	s5,24(sp)
    80001e46:	e85a                	sd	s6,16(sp)
    80001e48:	e45e                	sd	s7,8(sp)
    80001e4a:	0880                	addi	s0,sp,80
  struct proc *p;
  
  initlock(&pid_lock, "nextpid");
    80001e4c:	00006597          	auipc	a1,0x6
    80001e50:	58c58593          	addi	a1,a1,1420 # 800083d8 <etext+0x3d8>
    80001e54:	00012517          	auipc	a0,0x12
    80001e58:	a7450513          	addi	a0,a0,-1420 # 800138c8 <pid_lock>
    80001e5c:	d43fe0ef          	jal	80000b9e <initlock>
  initlock(&wait_lock, "wait_lock");
    80001e60:	00006597          	auipc	a1,0x6
    80001e64:	58058593          	addi	a1,a1,1408 # 800083e0 <etext+0x3e0>
    80001e68:	00012517          	auipc	a0,0x12
    80001e6c:	a7850513          	addi	a0,a0,-1416 # 800138e0 <wait_lock>
    80001e70:	d2ffe0ef          	jal	80000b9e <initlock>
  for(p = proc; p < &proc[NPROC]; p++) {
    80001e74:	00012497          	auipc	s1,0x12
    80001e78:	e8448493          	addi	s1,s1,-380 # 80013cf8 <proc>
      initlock(&p->lock, "proc");
    80001e7c:	00006b97          	auipc	s7,0x6
    80001e80:	574b8b93          	addi	s7,s7,1396 # 800083f0 <etext+0x3f0>
      p->state = UNUSED;
      p->kstack = KSTACK((int) (p - proc));
    80001e84:	8b26                	mv	s6,s1
    80001e86:	783c87b7          	lui	a5,0x783c8
    80001e8a:	13578793          	addi	a5,a5,309 # 783c8135 <_entry-0x7c37ecb>
    80001e8e:	3de5d937          	lui	s2,0x3de5d
    80001e92:	090a                	slli	s2,s2,0x2
    80001e94:	4e290913          	addi	s2,s2,1250 # 3de5d4e2 <_entry-0x421a2b1e>
    80001e98:	1902                	slli	s2,s2,0x20
    80001e9a:	993e                	add	s2,s2,a5
    80001e9c:	040009b7          	lui	s3,0x4000
    80001ea0:	19fd                	addi	s3,s3,-1 # 3ffffff <_entry-0x7c000001>
    80001ea2:	09b2                	slli	s3,s3,0xc
  for(p = proc; p < &proc[NPROC]; p++) {
    80001ea4:	00089a37          	lui	s4,0x89
    80001ea8:	1d0a0a13          	addi	s4,s4,464 # 891d0 <_entry-0x7ff76e30>
    80001eac:	02259a97          	auipc	s5,0x2259
    80001eb0:	24ca8a93          	addi	s5,s5,588 # 8225b0f8 <tickslock>
      initlock(&p->lock, "proc");
    80001eb4:	85de                	mv	a1,s7
    80001eb6:	8526                	mv	a0,s1
    80001eb8:	ce7fe0ef          	jal	80000b9e <initlock>
      p->state = UNUSED;
    80001ebc:	0004ac23          	sw	zero,24(s1)
      p->kstack = KSTACK((int) (p - proc));
    80001ec0:	416487b3          	sub	a5,s1,s6
    80001ec4:	8791                	srai	a5,a5,0x4
    80001ec6:	032787b3          	mul	a5,a5,s2
    80001eca:	07b6                	slli	a5,a5,0xd
    80001ecc:	6709                	lui	a4,0x2
    80001ece:	9fb9                	addw	a5,a5,a4
    80001ed0:	40f987b3          	sub	a5,s3,a5
    80001ed4:	e0bc                	sd	a5,64(s1)
  for(p = proc; p < &proc[NPROC]; p++) {
    80001ed6:	94d2                	add	s1,s1,s4
    80001ed8:	fd549ee3          	bne	s1,s5,80001eb4 <procinit+0x7e>
  }
}
    80001edc:	60a6                	ld	ra,72(sp)
    80001ede:	6406                	ld	s0,64(sp)
    80001ee0:	74e2                	ld	s1,56(sp)
    80001ee2:	7942                	ld	s2,48(sp)
    80001ee4:	79a2                	ld	s3,40(sp)
    80001ee6:	7a02                	ld	s4,32(sp)
    80001ee8:	6ae2                	ld	s5,24(sp)
    80001eea:	6b42                	ld	s6,16(sp)
    80001eec:	6ba2                	ld	s7,8(sp)
    80001eee:	6161                	addi	sp,sp,80
    80001ef0:	8082                	ret

0000000080001ef2 <cpuid>:
// Must be called with interrupts disabled,
// to prevent race with process being moved
// to a different CPU.
int
cpuid()
{
    80001ef2:	1141                	addi	sp,sp,-16
    80001ef4:	e406                	sd	ra,8(sp)
    80001ef6:	e022                	sd	s0,0(sp)
    80001ef8:	0800                	addi	s0,sp,16
  asm volatile("mv %0, tp" : "=r" (x) );
    80001efa:	8512                	mv	a0,tp
  int id = r_tp();
  return id;
}
    80001efc:	2501                	sext.w	a0,a0
    80001efe:	60a2                	ld	ra,8(sp)
    80001f00:	6402                	ld	s0,0(sp)
    80001f02:	0141                	addi	sp,sp,16
    80001f04:	8082                	ret

0000000080001f06 <mycpu>:

// Return this CPU's cpu struct.
// Interrupts must be disabled.
struct cpu*
mycpu(void)
{
    80001f06:	1141                	addi	sp,sp,-16
    80001f08:	e406                	sd	ra,8(sp)
    80001f0a:	e022                	sd	s0,0(sp)
    80001f0c:	0800                	addi	s0,sp,16
    80001f0e:	8792                	mv	a5,tp
  int id = cpuid();
  struct cpu *c = &cpus[id];
    80001f10:	2781                	sext.w	a5,a5
    80001f12:	079e                	slli	a5,a5,0x7
  return c;
}
    80001f14:	00012517          	auipc	a0,0x12
    80001f18:	9e450513          	addi	a0,a0,-1564 # 800138f8 <cpus>
    80001f1c:	953e                	add	a0,a0,a5
    80001f1e:	60a2                	ld	ra,8(sp)
    80001f20:	6402                	ld	s0,0(sp)
    80001f22:	0141                	addi	sp,sp,16
    80001f24:	8082                	ret

0000000080001f26 <myproc>:

// Return the current struct proc *, or zero if none.
struct proc*
myproc(void)
{
    80001f26:	1101                	addi	sp,sp,-32
    80001f28:	ec06                	sd	ra,24(sp)
    80001f2a:	e822                	sd	s0,16(sp)
    80001f2c:	e426                	sd	s1,8(sp)
    80001f2e:	1000                	addi	s0,sp,32
  push_off();
    80001f30:	cb5fe0ef          	jal	80000be4 <push_off>
    80001f34:	8792                	mv	a5,tp
  struct cpu *c = mycpu();
  struct proc *p = c->proc;
    80001f36:	2781                	sext.w	a5,a5
    80001f38:	079e                	slli	a5,a5,0x7
    80001f3a:	00012717          	auipc	a4,0x12
    80001f3e:	98e70713          	addi	a4,a4,-1650 # 800138c8 <pid_lock>
    80001f42:	97ba                	add	a5,a5,a4
    80001f44:	7b9c                	ld	a5,48(a5)
    80001f46:	84be                	mv	s1,a5
  pop_off();
    80001f48:	d25fe0ef          	jal	80000c6c <pop_off>
  return p;
}
    80001f4c:	8526                	mv	a0,s1
    80001f4e:	60e2                	ld	ra,24(sp)
    80001f50:	6442                	ld	s0,16(sp)
    80001f52:	64a2                	ld	s1,8(sp)
    80001f54:	6105                	addi	sp,sp,32
    80001f56:	8082                	ret

0000000080001f58 <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch to forkret.
void
forkret(void)
{
    80001f58:	7179                	addi	sp,sp,-48
    80001f5a:	f406                	sd	ra,40(sp)
    80001f5c:	f022                	sd	s0,32(sp)
    80001f5e:	ec26                	sd	s1,24(sp)
    80001f60:	1800                	addi	s0,sp,48
  extern char userret[];
  static int first = 1;
  struct proc *p = myproc();
    80001f62:	fc5ff0ef          	jal	80001f26 <myproc>
    80001f66:	84aa                	mv	s1,a0

  // Still holding p->lock from scheduler.
  release(&p->lock);
    80001f68:	d55fe0ef          	jal	80000cbc <release>

  if (first) {
    80001f6c:	0000a797          	auipc	a5,0xa
    80001f70:	8247a783          	lw	a5,-2012(a5) # 8000b790 <first.1>
    80001f74:	cf95                	beqz	a5,80001fb0 <forkret+0x58>
    // File system initialization must be run in the context of a
    // regular process (e.g., because it calls sleep), and thus cannot
    // be run from main().
    fsinit(ROOTDEV);
    80001f76:	4505                	li	a0,1
    80001f78:	617010ef          	jal	80003d8e <fsinit>

    first = 0;
    80001f7c:	0000a797          	auipc	a5,0xa
    80001f80:	8007aa23          	sw	zero,-2028(a5) # 8000b790 <first.1>
    // ensure other cores see first=0.
    __sync_synchronize();
    80001f84:	0330000f          	fence	rw,rw

    // We can invoke kexec() now that file system is initialized.
    // Put the return value (argc) of kexec into a0.
    p->trapframe->a0 = kexec("/init", (char *[]){ "/init", 0 });
    80001f88:	00006797          	auipc	a5,0x6
    80001f8c:	47078793          	addi	a5,a5,1136 # 800083f8 <etext+0x3f8>
    80001f90:	fcf43823          	sd	a5,-48(s0)
    80001f94:	fc043c23          	sd	zero,-40(s0)
    80001f98:	fd040593          	addi	a1,s0,-48
    80001f9c:	853e                	mv	a0,a5
    80001f9e:	100030ef          	jal	8000509e <kexec>
    80001fa2:	6cbc                	ld	a5,88(s1)
    80001fa4:	fba8                	sd	a0,112(a5)
    if (p->trapframe->a0 == -1) {
    80001fa6:	6cbc                	ld	a5,88(s1)
    80001fa8:	7bb8                	ld	a4,112(a5)
    80001faa:	57fd                	li	a5,-1
    80001fac:	02f70d63          	beq	a4,a5,80001fe6 <forkret+0x8e>
      panic("exec");
    }
  }

  // return to user space, mimicing usertrap()'s return.
  prepare_return();
    80001fb0:	427000ef          	jal	80002bd6 <prepare_return>
  uint64 satp = MAKE_SATP(p->pagetable);
    80001fb4:	68a8                	ld	a0,80(s1)
    80001fb6:	8131                	srli	a0,a0,0xc
  uint64 trampoline_userret = TRAMPOLINE + (userret - trampoline);
    80001fb8:	04000737          	lui	a4,0x4000
    80001fbc:	177d                	addi	a4,a4,-1 # 3ffffff <_entry-0x7c000001>
    80001fbe:	0732                	slli	a4,a4,0xc
    80001fc0:	00005797          	auipc	a5,0x5
    80001fc4:	0dc78793          	addi	a5,a5,220 # 8000709c <userret>
    80001fc8:	00005697          	auipc	a3,0x5
    80001fcc:	03868693          	addi	a3,a3,56 # 80007000 <_trampoline>
    80001fd0:	8f95                	sub	a5,a5,a3
    80001fd2:	97ba                	add	a5,a5,a4
  ((void (*)(uint64))trampoline_userret)(satp);
    80001fd4:	577d                	li	a4,-1
    80001fd6:	177e                	slli	a4,a4,0x3f
    80001fd8:	8d59                	or	a0,a0,a4
    80001fda:	9782                	jalr	a5
}
    80001fdc:	70a2                	ld	ra,40(sp)
    80001fde:	7402                	ld	s0,32(sp)
    80001fe0:	64e2                	ld	s1,24(sp)
    80001fe2:	6145                	addi	sp,sp,48
    80001fe4:	8082                	ret
      panic("exec");
    80001fe6:	00006517          	auipc	a0,0x6
    80001fea:	32a50513          	addi	a0,a0,810 # 80008310 <etext+0x310>
    80001fee:	837fe0ef          	jal	80000824 <panic>

0000000080001ff2 <allocpid>:
{
    80001ff2:	1101                	addi	sp,sp,-32
    80001ff4:	ec06                	sd	ra,24(sp)
    80001ff6:	e822                	sd	s0,16(sp)
    80001ff8:	e426                	sd	s1,8(sp)
    80001ffa:	1000                	addi	s0,sp,32
  acquire(&pid_lock);
    80001ffc:	00012517          	auipc	a0,0x12
    80002000:	8cc50513          	addi	a0,a0,-1844 # 800138c8 <pid_lock>
    80002004:	c25fe0ef          	jal	80000c28 <acquire>
  pid = nextpid;
    80002008:	00009797          	auipc	a5,0x9
    8000200c:	78c78793          	addi	a5,a5,1932 # 8000b794 <nextpid>
    80002010:	4384                	lw	s1,0(a5)
  nextpid = nextpid + 1;
    80002012:	0014871b          	addiw	a4,s1,1
    80002016:	c398                	sw	a4,0(a5)
  release(&pid_lock);
    80002018:	00012517          	auipc	a0,0x12
    8000201c:	8b050513          	addi	a0,a0,-1872 # 800138c8 <pid_lock>
    80002020:	c9dfe0ef          	jal	80000cbc <release>
}
    80002024:	8526                	mv	a0,s1
    80002026:	60e2                	ld	ra,24(sp)
    80002028:	6442                	ld	s0,16(sp)
    8000202a:	64a2                	ld	s1,8(sp)
    8000202c:	6105                	addi	sp,sp,32
    8000202e:	8082                	ret

0000000080002030 <proc_pagetable>:
{
    80002030:	1101                	addi	sp,sp,-32
    80002032:	ec06                	sd	ra,24(sp)
    80002034:	e822                	sd	s0,16(sp)
    80002036:	e426                	sd	s1,8(sp)
    80002038:	e04a                	sd	s2,0(sp)
    8000203a:	1000                	addi	s0,sp,32
    8000203c:	892a                	mv	s2,a0
  pagetable = uvmcreate();
    8000203e:	9caff0ef          	jal	80001208 <uvmcreate>
    80002042:	84aa                	mv	s1,a0
  if(pagetable == 0)
    80002044:	cd05                	beqz	a0,8000207c <proc_pagetable+0x4c>
  if(mappages(pagetable, TRAMPOLINE, PGSIZE,
    80002046:	4729                	li	a4,10
    80002048:	00005697          	auipc	a3,0x5
    8000204c:	fb868693          	addi	a3,a3,-72 # 80007000 <_trampoline>
    80002050:	6605                	lui	a2,0x1
    80002052:	040005b7          	lui	a1,0x4000
    80002056:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80002058:	05b2                	slli	a1,a1,0xc
    8000205a:	806ff0ef          	jal	80001060 <mappages>
    8000205e:	02054663          	bltz	a0,8000208a <proc_pagetable+0x5a>
  if(mappages(pagetable, TRAPFRAME, PGSIZE,
    80002062:	4719                	li	a4,6
    80002064:	05893683          	ld	a3,88(s2)
    80002068:	6605                	lui	a2,0x1
    8000206a:	020005b7          	lui	a1,0x2000
    8000206e:	15fd                	addi	a1,a1,-1 # 1ffffff <_entry-0x7e000001>
    80002070:	05b6                	slli	a1,a1,0xd
    80002072:	8526                	mv	a0,s1
    80002074:	fedfe0ef          	jal	80001060 <mappages>
    80002078:	00054f63          	bltz	a0,80002096 <proc_pagetable+0x66>
}
    8000207c:	8526                	mv	a0,s1
    8000207e:	60e2                	ld	ra,24(sp)
    80002080:	6442                	ld	s0,16(sp)
    80002082:	64a2                	ld	s1,8(sp)
    80002084:	6902                	ld	s2,0(sp)
    80002086:	6105                	addi	sp,sp,32
    80002088:	8082                	ret
    uvmfree(pagetable, 0);
    8000208a:	4581                	li	a1,0
    8000208c:	8526                	mv	a0,s1
    8000208e:	909ff0ef          	jal	80001996 <uvmfree>
    return 0;
    80002092:	4481                	li	s1,0
    80002094:	b7e5                	j	8000207c <proc_pagetable+0x4c>
    uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    80002096:	4681                	li	a3,0
    80002098:	4605                	li	a2,1
    8000209a:	040005b7          	lui	a1,0x4000
    8000209e:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    800020a0:	05b2                	slli	a1,a1,0xc
    800020a2:	8526                	mv	a0,s1
    800020a4:	98aff0ef          	jal	8000122e <uvmunmap>
    uvmfree(pagetable, 0);
    800020a8:	4581                	li	a1,0
    800020aa:	8526                	mv	a0,s1
    800020ac:	8ebff0ef          	jal	80001996 <uvmfree>
    return 0;
    800020b0:	4481                	li	s1,0
    800020b2:	b7e9                	j	8000207c <proc_pagetable+0x4c>

00000000800020b4 <proc_freepagetable>:
{
    800020b4:	1101                	addi	sp,sp,-32
    800020b6:	ec06                	sd	ra,24(sp)
    800020b8:	e822                	sd	s0,16(sp)
    800020ba:	e426                	sd	s1,8(sp)
    800020bc:	e04a                	sd	s2,0(sp)
    800020be:	1000                	addi	s0,sp,32
    800020c0:	84aa                	mv	s1,a0
    800020c2:	892e                	mv	s2,a1
  uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    800020c4:	4681                	li	a3,0
    800020c6:	4605                	li	a2,1
    800020c8:	040005b7          	lui	a1,0x4000
    800020cc:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    800020ce:	05b2                	slli	a1,a1,0xc
    800020d0:	95eff0ef          	jal	8000122e <uvmunmap>
  uvmunmap(pagetable, TRAPFRAME, 1, 0);
    800020d4:	4681                	li	a3,0
    800020d6:	4605                	li	a2,1
    800020d8:	020005b7          	lui	a1,0x2000
    800020dc:	15fd                	addi	a1,a1,-1 # 1ffffff <_entry-0x7e000001>
    800020de:	05b6                	slli	a1,a1,0xd
    800020e0:	8526                	mv	a0,s1
    800020e2:	94cff0ef          	jal	8000122e <uvmunmap>
  uvmfree(pagetable, sz);
    800020e6:	85ca                	mv	a1,s2
    800020e8:	8526                	mv	a0,s1
    800020ea:	8adff0ef          	jal	80001996 <uvmfree>
}
    800020ee:	60e2                	ld	ra,24(sp)
    800020f0:	6442                	ld	s0,16(sp)
    800020f2:	64a2                	ld	s1,8(sp)
    800020f4:	6902                	ld	s2,0(sp)
    800020f6:	6105                	addi	sp,sp,32
    800020f8:	8082                	ret

00000000800020fa <freeproc>:
{
    800020fa:	1101                	addi	sp,sp,-32
    800020fc:	ec06                	sd	ra,24(sp)
    800020fe:	e822                	sd	s0,16(sp)
    80002100:	e426                	sd	s1,8(sp)
    80002102:	1000                	addi	s0,sp,32
    80002104:	84aa                	mv	s1,a0
  if(p->trapframe)
    80002106:	6d28                	ld	a0,88(a0)
    80002108:	c119                	beqz	a0,8000210e <freeproc+0x14>
    kfree((void*)p->trapframe);
    8000210a:	953fe0ef          	jal	80000a5c <kfree>
  p->trapframe = 0;
    8000210e:	0404bc23          	sd	zero,88(s1)
  if(p->pagetable)
    80002112:	68a8                	ld	a0,80(s1)
    80002114:	c501                	beqz	a0,8000211c <freeproc+0x22>
    proc_freepagetable(p->pagetable, p->sz);
    80002116:	64ac                	ld	a1,72(s1)
    80002118:	f9dff0ef          	jal	800020b4 <proc_freepagetable>
  p->pagetable = 0;
    8000211c:	0404b823          	sd	zero,80(s1)
  p->sz = 0;
    80002120:	0404b423          	sd	zero,72(s1)
  p->pid = 0;
    80002124:	0204a823          	sw	zero,48(s1)
  p->parent = 0;
    80002128:	0204bc23          	sd	zero,56(s1)
  p->name[0] = 0;
    8000212c:	14048c23          	sb	zero,344(s1)
  p->chan = 0;
    80002130:	0204b023          	sd	zero,32(s1)
  p->killed = 0;
    80002134:	0204a423          	sw	zero,40(s1)
  p->xstate = 0;
    80002138:	0204a623          	sw	zero,44(s1)
  p->state = UNUSED;
    8000213c:	0004ac23          	sw	zero,24(s1)
  if(p->exec_ip)
    80002140:	1704b503          	ld	a0,368(s1)
    80002144:	c119                	beqz	a0,8000214a <freeproc+0x50>
      iput(p->exec_ip);
    80002146:	2d7010ef          	jal	80003c1c <iput>
}
    8000214a:	60e2                	ld	ra,24(sp)
    8000214c:	6442                	ld	s0,16(sp)
    8000214e:	64a2                	ld	s1,8(sp)
    80002150:	6105                	addi	sp,sp,32
    80002152:	8082                	ret

0000000080002154 <allocproc>:
{
    80002154:	7179                	addi	sp,sp,-48
    80002156:	f406                	sd	ra,40(sp)
    80002158:	f022                	sd	s0,32(sp)
    8000215a:	ec26                	sd	s1,24(sp)
    8000215c:	e84a                	sd	s2,16(sp)
    8000215e:	e44e                	sd	s3,8(sp)
    80002160:	1800                	addi	s0,sp,48
  for(p = proc; p < &proc[NPROC]; p++) {
    80002162:	00012497          	auipc	s1,0x12
    80002166:	b9648493          	addi	s1,s1,-1130 # 80013cf8 <proc>
    8000216a:	00089937          	lui	s2,0x89
    8000216e:	1d090913          	addi	s2,s2,464 # 891d0 <_entry-0x7ff76e30>
    80002172:	02259997          	auipc	s3,0x2259
    80002176:	f8698993          	addi	s3,s3,-122 # 8225b0f8 <tickslock>
    acquire(&p->lock);
    8000217a:	8526                	mv	a0,s1
    8000217c:	aadfe0ef          	jal	80000c28 <acquire>
    if(p->state == UNUSED) {
    80002180:	4c9c                	lw	a5,24(s1)
    80002182:	cb89                	beqz	a5,80002194 <allocproc+0x40>
      release(&p->lock);
    80002184:	8526                	mv	a0,s1
    80002186:	b37fe0ef          	jal	80000cbc <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    8000218a:	94ca                	add	s1,s1,s2
    8000218c:	ff3497e3          	bne	s1,s3,8000217a <allocproc+0x26>
  return 0;
    80002190:	4481                	li	s1,0
    80002192:	a0ad                	j	800021fc <allocproc+0xa8>
  p->pid = allocpid();
    80002194:	e5fff0ef          	jal	80001ff2 <allocpid>
    80002198:	d888                	sw	a0,48(s1)
  p->state = USED;
    8000219a:	4785                	li	a5,1
    8000219c:	cc9c                	sw	a5,24(s1)
  p->next_fifo_seq = 0;
    8000219e:	000897b7          	lui	a5,0x89
    800021a2:	97a6                	add	a5,a5,s1
    800021a4:	1c07a423          	sw	zero,456(a5) # 891c8 <_entry-0x7ff76e38>
  p->num_resident = 0;
    800021a8:	1a07a823          	sw	zero,432(a5)
  p->num_swappped_pages=0;
    800021ac:	1c07a623          	sw	zero,460(a5)
  p->swap_path[0]='\0';
    800021b0:	1a078a23          	sb	zero,436(a5)
  for(int i=0;i<MAX_SWAP_PAGES;i++)
    800021b4:	18048793          	addi	a5,s1,384
    800021b8:	27048713          	addi	a4,s1,624
      p->swap_slots[i]=0;
    800021bc:	0007a023          	sw	zero,0(a5)
  for(int i=0;i<MAX_SWAP_PAGES;i++)
    800021c0:	0791                	addi	a5,a5,4
    800021c2:	fee79de3          	bne	a5,a4,800021bc <allocproc+0x68>
  if((p->trapframe = (struct trapframe *)kalloc()) == 0){
    800021c6:	97ffe0ef          	jal	80000b44 <kalloc>
    800021ca:	892a                	mv	s2,a0
    800021cc:	eca8                	sd	a0,88(s1)
    800021ce:	cd1d                	beqz	a0,8000220c <allocproc+0xb8>
  p->pagetable = proc_pagetable(p);
    800021d0:	8526                	mv	a0,s1
    800021d2:	e5fff0ef          	jal	80002030 <proc_pagetable>
    800021d6:	892a                	mv	s2,a0
    800021d8:	e8a8                	sd	a0,80(s1)
  if(p->pagetable == 0){
    800021da:	c129                	beqz	a0,8000221c <allocproc+0xc8>
  memset(&p->context, 0, sizeof(p->context));
    800021dc:	07000613          	li	a2,112
    800021e0:	4581                	li	a1,0
    800021e2:	06048513          	addi	a0,s1,96
    800021e6:	b13fe0ef          	jal	80000cf8 <memset>
  p->context.ra = (uint64)forkret;
    800021ea:	00000797          	auipc	a5,0x0
    800021ee:	d6e78793          	addi	a5,a5,-658 # 80001f58 <forkret>
    800021f2:	f0bc                	sd	a5,96(s1)
  p->context.sp = p->kstack + PGSIZE;
    800021f4:	60bc                	ld	a5,64(s1)
    800021f6:	6705                	lui	a4,0x1
    800021f8:	97ba                	add	a5,a5,a4
    800021fa:	f4bc                	sd	a5,104(s1)
}
    800021fc:	8526                	mv	a0,s1
    800021fe:	70a2                	ld	ra,40(sp)
    80002200:	7402                	ld	s0,32(sp)
    80002202:	64e2                	ld	s1,24(sp)
    80002204:	6942                	ld	s2,16(sp)
    80002206:	69a2                	ld	s3,8(sp)
    80002208:	6145                	addi	sp,sp,48
    8000220a:	8082                	ret
    freeproc(p);
    8000220c:	8526                	mv	a0,s1
    8000220e:	eedff0ef          	jal	800020fa <freeproc>
    release(&p->lock);
    80002212:	8526                	mv	a0,s1
    80002214:	aa9fe0ef          	jal	80000cbc <release>
    return 0;
    80002218:	84ca                	mv	s1,s2
    8000221a:	b7cd                	j	800021fc <allocproc+0xa8>
    freeproc(p);
    8000221c:	8526                	mv	a0,s1
    8000221e:	eddff0ef          	jal	800020fa <freeproc>
    release(&p->lock);
    80002222:	8526                	mv	a0,s1
    80002224:	a99fe0ef          	jal	80000cbc <release>
    return 0;
    80002228:	84ca                	mv	s1,s2
    8000222a:	bfc9                	j	800021fc <allocproc+0xa8>

000000008000222c <userinit>:
{
    8000222c:	1101                	addi	sp,sp,-32
    8000222e:	ec06                	sd	ra,24(sp)
    80002230:	e822                	sd	s0,16(sp)
    80002232:	e426                	sd	s1,8(sp)
    80002234:	1000                	addi	s0,sp,32
  p = allocproc();
    80002236:	f1fff0ef          	jal	80002154 <allocproc>
    8000223a:	84aa                	mv	s1,a0
  initproc = p;
    8000223c:	00009797          	auipc	a5,0x9
    80002240:	58a7b223          	sd	a0,1412(a5) # 8000b7c0 <initproc>
  p->cwd = namei("/");
    80002244:	00006517          	auipc	a0,0x6
    80002248:	1bc50513          	addi	a0,a0,444 # 80008400 <etext+0x400>
    8000224c:	07c020ef          	jal	800042c8 <namei>
    80002250:	14a4b823          	sd	a0,336(s1)
  p->state = RUNNABLE;
    80002254:	478d                	li	a5,3
    80002256:	cc9c                	sw	a5,24(s1)
  release(&p->lock);
    80002258:	8526                	mv	a0,s1
    8000225a:	a63fe0ef          	jal	80000cbc <release>
}
    8000225e:	60e2                	ld	ra,24(sp)
    80002260:	6442                	ld	s0,16(sp)
    80002262:	64a2                	ld	s1,8(sp)
    80002264:	6105                	addi	sp,sp,32
    80002266:	8082                	ret

0000000080002268 <growproc>:
{
    80002268:	1101                	addi	sp,sp,-32
    8000226a:	ec06                	sd	ra,24(sp)
    8000226c:	e822                	sd	s0,16(sp)
    8000226e:	e426                	sd	s1,8(sp)
    80002270:	e04a                	sd	s2,0(sp)
    80002272:	1000                	addi	s0,sp,32
    80002274:	84aa                	mv	s1,a0
  struct proc *p = myproc();
    80002276:	cb1ff0ef          	jal	80001f26 <myproc>
    8000227a:	892a                	mv	s2,a0
  sz = p->sz;
    8000227c:	652c                	ld	a1,72(a0)
  if(n > 0){
    8000227e:	02905963          	blez	s1,800022b0 <growproc+0x48>
    if(sz + n > TRAPFRAME) {
    80002282:	00b48633          	add	a2,s1,a1
    80002286:	020007b7          	lui	a5,0x2000
    8000228a:	17fd                	addi	a5,a5,-1 # 1ffffff <_entry-0x7e000001>
    8000228c:	07b6                	slli	a5,a5,0xd
    8000228e:	02c7ea63          	bltu	a5,a2,800022c2 <growproc+0x5a>
    if((sz = uvmalloc(p->pagetable, sz, sz + n, PTE_W)) == 0) {
    80002292:	4691                	li	a3,4
    80002294:	6928                	ld	a0,80(a0)
    80002296:	dfaff0ef          	jal	80001890 <uvmalloc>
    8000229a:	85aa                	mv	a1,a0
    8000229c:	c50d                	beqz	a0,800022c6 <growproc+0x5e>
  p->sz = sz;
    8000229e:	04b93423          	sd	a1,72(s2)
  return 0;
    800022a2:	4501                	li	a0,0
}
    800022a4:	60e2                	ld	ra,24(sp)
    800022a6:	6442                	ld	s0,16(sp)
    800022a8:	64a2                	ld	s1,8(sp)
    800022aa:	6902                	ld	s2,0(sp)
    800022ac:	6105                	addi	sp,sp,32
    800022ae:	8082                	ret
  } else if(n < 0){
    800022b0:	fe04d7e3          	bgez	s1,8000229e <growproc+0x36>
    sz = uvmdealloc(p->pagetable, sz, sz + n);
    800022b4:	00b48633          	add	a2,s1,a1
    800022b8:	6928                	ld	a0,80(a0)
    800022ba:	d92ff0ef          	jal	8000184c <uvmdealloc>
    800022be:	85aa                	mv	a1,a0
    800022c0:	bff9                	j	8000229e <growproc+0x36>
      return -1;
    800022c2:	557d                	li	a0,-1
    800022c4:	b7c5                	j	800022a4 <growproc+0x3c>
      return -1;
    800022c6:	557d                	li	a0,-1
    800022c8:	bff1                	j	800022a4 <growproc+0x3c>

00000000800022ca <kfork>:
{
    800022ca:	7139                	addi	sp,sp,-64
    800022cc:	fc06                	sd	ra,56(sp)
    800022ce:	f822                	sd	s0,48(sp)
    800022d0:	f426                	sd	s1,40(sp)
    800022d2:	e852                	sd	s4,16(sp)
    800022d4:	0080                	addi	s0,sp,64
  struct proc *p = myproc();
    800022d6:	c51ff0ef          	jal	80001f26 <myproc>
    800022da:	8a2a                	mv	s4,a0
  if((np = allocproc()) == 0){
    800022dc:	e79ff0ef          	jal	80002154 <allocproc>
    800022e0:	1a050663          	beqz	a0,8000248c <kfork+0x1c2>
    800022e4:	ec4e                	sd	s3,24(sp)
    800022e6:	89aa                	mv	s3,a0
  if(uvmcopy(p->pagetable, np->pagetable, p->sz) < 0){
    800022e8:	048a3603          	ld	a2,72(s4)
    800022ec:	692c                	ld	a1,80(a0)
    800022ee:	050a3503          	ld	a0,80(s4)
    800022f2:	ed6ff0ef          	jal	800019c8 <uvmcopy>
    800022f6:	0e054d63          	bltz	a0,800023f0 <kfork+0x126>
    800022fa:	f04a                	sd	s2,32(sp)
    800022fc:	e456                	sd	s5,8(sp)
  np->sz = p->sz;
    800022fe:	048a3783          	ld	a5,72(s4)
    80002302:	04f9b423          	sd	a5,72(s3)
  *(np->trapframe) = *(p->trapframe);
    80002306:	058a3683          	ld	a3,88(s4)
    8000230a:	87b6                	mv	a5,a3
    8000230c:	0589b703          	ld	a4,88(s3)
    80002310:	12068693          	addi	a3,a3,288
    80002314:	6388                	ld	a0,0(a5)
    80002316:	678c                	ld	a1,8(a5)
    80002318:	6b90                	ld	a2,16(a5)
    8000231a:	e308                	sd	a0,0(a4)
    8000231c:	e70c                	sd	a1,8(a4)
    8000231e:	eb10                	sd	a2,16(a4)
    80002320:	6f90                	ld	a2,24(a5)
    80002322:	ef10                	sd	a2,24(a4)
    80002324:	02078793          	addi	a5,a5,32
    80002328:	02070713          	addi	a4,a4,32 # 1020 <_entry-0x7fffefe0>
    8000232c:	fed794e3          	bne	a5,a3,80002314 <kfork+0x4a>
  np->heap_start = p->heap_start;
    80002330:	168a3783          	ld	a5,360(s4)
    80002334:	16f9b423          	sd	a5,360(s3)
  np->num_resident = p->num_resident;
    80002338:	000897b7          	lui	a5,0x89
    8000233c:	00fa0733          	add	a4,s4,a5
    80002340:	1b072683          	lw	a3,432(a4)
    80002344:	97ce                	add	a5,a5,s3
    80002346:	1ad7a823          	sw	a3,432(a5) # 891b0 <_entry-0x7ff76e50>
  np->next_fifo_seq = p->next_fifo_seq;
    8000234a:	1c872683          	lw	a3,456(a4)
    8000234e:	1cd7a423          	sw	a3,456(a5)
  np->num_swappped_pages = p->num_swappped_pages;
    80002352:	1cc72683          	lw	a3,460(a4)
    80002356:	1cd7a623          	sw	a3,460(a5)
  for (i = 0; i < p->num_resident; i++) {
    8000235a:	1b072783          	lw	a5,432(a4)
    8000235e:	02f05563          	blez	a5,80002388 <kfork+0xbe>
    80002362:	270a0713          	addi	a4,s4,624
    80002366:	27098793          	addi	a5,s3,624
    8000236a:	4681                	li	a3,0
    8000236c:	000895b7          	lui	a1,0x89
    80002370:	95d2                	add	a1,a1,s4
    np->resident_pages[i] = p->resident_pages[i];
    80002372:	6310                	ld	a2,0(a4)
    80002374:	e390                	sd	a2,0(a5)
    80002376:	6710                	ld	a2,8(a4)
    80002378:	e790                	sd	a2,8(a5)
  for (i = 0; i < p->num_resident; i++) {
    8000237a:	2685                	addiw	a3,a3,1
    8000237c:	0741                	addi	a4,a4,16
    8000237e:	07c1                	addi	a5,a5,16
    80002380:	1b05a603          	lw	a2,432(a1) # 891b0 <_entry-0x7ff76e50>
    80002384:	fec6c7e3          	blt	a3,a2,80002372 <kfork+0xa8>
  for (i = 0; i < p->num_swappped_pages; i++) {
    80002388:	000897b7          	lui	a5,0x89
    8000238c:	97d2                	add	a5,a5,s4
    8000238e:	1cc7a783          	lw	a5,460(a5) # 891cc <_entry-0x7ff76e34>
    80002392:	02f05863          	blez	a5,800023c2 <kfork+0xf8>
    80002396:	000897b7          	lui	a5,0x89
    8000239a:	df078793          	addi	a5,a5,-528 # 88df0 <_entry-0x7ff77210>
    8000239e:	00fa0733          	add	a4,s4,a5
    800023a2:	97ce                	add	a5,a5,s3
    800023a4:	4681                	li	a3,0
    800023a6:	000895b7          	lui	a1,0x89
    800023aa:	95d2                	add	a1,a1,s4
    np->swapped_pages[i] = p->swapped_pages[i];
    800023ac:	6310                	ld	a2,0(a4)
    800023ae:	e390                	sd	a2,0(a5)
    800023b0:	6710                	ld	a2,8(a4)
    800023b2:	e790                	sd	a2,8(a5)
  for (i = 0; i < p->num_swappped_pages; i++) {
    800023b4:	2685                	addiw	a3,a3,1
    800023b6:	0741                	addi	a4,a4,16
    800023b8:	07c1                	addi	a5,a5,16
    800023ba:	1cc5a603          	lw	a2,460(a1) # 891cc <_entry-0x7ff76e34>
    800023be:	fec6c7e3          	blt	a3,a2,800023ac <kfork+0xe2>
  for (i = 0; i < MAX_SWAP_PAGES; i++) {
    800023c2:	180a0793          	addi	a5,s4,384
    800023c6:	18098713          	addi	a4,s3,384
    800023ca:	270a0613          	addi	a2,s4,624
    np->swap_slots[i] = p->swap_slots[i];
    800023ce:	4394                	lw	a3,0(a5)
    800023d0:	c314                	sw	a3,0(a4)
  for (i = 0; i < MAX_SWAP_PAGES; i++) {
    800023d2:	0791                	addi	a5,a5,4
    800023d4:	0711                	addi	a4,a4,4
    800023d6:	fec79ce3          	bne	a5,a2,800023ce <kfork+0x104>
  np->trapframe->a0 = 0;
    800023da:	0589b783          	ld	a5,88(s3)
    800023de:	0607b823          	sd	zero,112(a5)
  for(i = 0; i < NOFILE; i++)
    800023e2:	0d0a0493          	addi	s1,s4,208
    800023e6:	0d098913          	addi	s2,s3,208
    800023ea:	150a0a93          	addi	s5,s4,336
    800023ee:	a831                	j	8000240a <kfork+0x140>
    freeproc(np);
    800023f0:	854e                	mv	a0,s3
    800023f2:	d09ff0ef          	jal	800020fa <freeproc>
    release(&np->lock);
    800023f6:	854e                	mv	a0,s3
    800023f8:	8c5fe0ef          	jal	80000cbc <release>
    return -1;
    800023fc:	54fd                	li	s1,-1
    800023fe:	69e2                	ld	s3,24(sp)
    80002400:	a8bd                	j	8000247e <kfork+0x1b4>
  for(i = 0; i < NOFILE; i++)
    80002402:	04a1                	addi	s1,s1,8
    80002404:	0921                	addi	s2,s2,8
    80002406:	01548963          	beq	s1,s5,80002418 <kfork+0x14e>
    if(p->ofile[i])
    8000240a:	6088                	ld	a0,0(s1)
    8000240c:	d97d                	beqz	a0,80002402 <kfork+0x138>
      np->ofile[i] = filedup(p->ofile[i]);
    8000240e:	476020ef          	jal	80004884 <filedup>
    80002412:	00a93023          	sd	a0,0(s2)
    80002416:	b7f5                	j	80002402 <kfork+0x138>
  np->cwd = idup(p->cwd);
    80002418:	150a3503          	ld	a0,336(s4)
    8000241c:	648010ef          	jal	80003a64 <idup>
    80002420:	14a9b823          	sd	a0,336(s3)
  if(p->exec_ip)
    80002424:	170a3503          	ld	a0,368(s4)
    80002428:	c509                	beqz	a0,80002432 <kfork+0x168>
    np->exec_ip = idup(p->exec_ip);
    8000242a:	63a010ef          	jal	80003a64 <idup>
    8000242e:	16a9b823          	sd	a0,368(s3)
  safestrcpy(np->name, p->name, sizeof(p->name));
    80002432:	4641                	li	a2,16
    80002434:	158a0593          	addi	a1,s4,344
    80002438:	15898513          	addi	a0,s3,344
    8000243c:	a11fe0ef          	jal	80000e4c <safestrcpy>
  pid = np->pid;
    80002440:	0309a483          	lw	s1,48(s3)
  release(&np->lock);
    80002444:	854e                	mv	a0,s3
    80002446:	877fe0ef          	jal	80000cbc <release>
  acquire(&wait_lock);
    8000244a:	00011517          	auipc	a0,0x11
    8000244e:	49650513          	addi	a0,a0,1174 # 800138e0 <wait_lock>
    80002452:	fd6fe0ef          	jal	80000c28 <acquire>
  np->parent = p;
    80002456:	0349bc23          	sd	s4,56(s3)
  release(&wait_lock);
    8000245a:	00011517          	auipc	a0,0x11
    8000245e:	48650513          	addi	a0,a0,1158 # 800138e0 <wait_lock>
    80002462:	85bfe0ef          	jal	80000cbc <release>
  acquire(&np->lock);
    80002466:	854e                	mv	a0,s3
    80002468:	fc0fe0ef          	jal	80000c28 <acquire>
  np->state = RUNNABLE;
    8000246c:	478d                	li	a5,3
    8000246e:	00f9ac23          	sw	a5,24(s3)
  release(&np->lock);
    80002472:	854e                	mv	a0,s3
    80002474:	849fe0ef          	jal	80000cbc <release>
  return pid;
    80002478:	7902                	ld	s2,32(sp)
    8000247a:	69e2                	ld	s3,24(sp)
    8000247c:	6aa2                	ld	s5,8(sp)
}
    8000247e:	8526                	mv	a0,s1
    80002480:	70e2                	ld	ra,56(sp)
    80002482:	7442                	ld	s0,48(sp)
    80002484:	74a2                	ld	s1,40(sp)
    80002486:	6a42                	ld	s4,16(sp)
    80002488:	6121                	addi	sp,sp,64
    8000248a:	8082                	ret
    return -1;
    8000248c:	54fd                	li	s1,-1
    8000248e:	bfc5                	j	8000247e <kfork+0x1b4>

0000000080002490 <scheduler>:
{
    80002490:	715d                	addi	sp,sp,-80
    80002492:	e486                	sd	ra,72(sp)
    80002494:	e0a2                	sd	s0,64(sp)
    80002496:	fc26                	sd	s1,56(sp)
    80002498:	f84a                	sd	s2,48(sp)
    8000249a:	f44e                	sd	s3,40(sp)
    8000249c:	f052                	sd	s4,32(sp)
    8000249e:	ec56                	sd	s5,24(sp)
    800024a0:	e85a                	sd	s6,16(sp)
    800024a2:	e45e                	sd	s7,8(sp)
    800024a4:	e062                	sd	s8,0(sp)
    800024a6:	0880                	addi	s0,sp,80
    800024a8:	8792                	mv	a5,tp
  int id = r_tp();
    800024aa:	2781                	sext.w	a5,a5
  c->proc = 0;
    800024ac:	00779b13          	slli	s6,a5,0x7
    800024b0:	00011717          	auipc	a4,0x11
    800024b4:	41870713          	addi	a4,a4,1048 # 800138c8 <pid_lock>
    800024b8:	975a                	add	a4,a4,s6
    800024ba:	02073823          	sd	zero,48(a4)
        swtch(&c->context, &p->context);
    800024be:	00011717          	auipc	a4,0x11
    800024c2:	44270713          	addi	a4,a4,1090 # 80013900 <cpus+0x8>
    800024c6:	9b3a                	add	s6,s6,a4
        p->state = RUNNING;
    800024c8:	4c11                	li	s8,4
        c->proc = p;
    800024ca:	079e                	slli	a5,a5,0x7
    800024cc:	00011a17          	auipc	s4,0x11
    800024d0:	3fca0a13          	addi	s4,s4,1020 # 800138c8 <pid_lock>
    800024d4:	9a3e                	add	s4,s4,a5
        found = 1;
    800024d6:	4b85                	li	s7,1
    800024d8:	a091                	j	8000251c <scheduler+0x8c>
      release(&p->lock);
    800024da:	8526                	mv	a0,s1
    800024dc:	fe0fe0ef          	jal	80000cbc <release>
    for(p = proc; p < &proc[NPROC]; p++) {
    800024e0:	94ca                	add	s1,s1,s2
    800024e2:	02259797          	auipc	a5,0x2259
    800024e6:	c1678793          	addi	a5,a5,-1002 # 8225b0f8 <tickslock>
    800024ea:	02f48563          	beq	s1,a5,80002514 <scheduler+0x84>
      acquire(&p->lock);
    800024ee:	8526                	mv	a0,s1
    800024f0:	f38fe0ef          	jal	80000c28 <acquire>
      if(p->state == RUNNABLE) {
    800024f4:	4c9c                	lw	a5,24(s1)
    800024f6:	ff3792e3          	bne	a5,s3,800024da <scheduler+0x4a>
        p->state = RUNNING;
    800024fa:	0184ac23          	sw	s8,24(s1)
        c->proc = p;
    800024fe:	029a3823          	sd	s1,48(s4)
        swtch(&c->context, &p->context);
    80002502:	06048593          	addi	a1,s1,96
    80002506:	855a                	mv	a0,s6
    80002508:	624000ef          	jal	80002b2c <swtch>
        c->proc = 0;
    8000250c:	020a3823          	sd	zero,48(s4)
        found = 1;
    80002510:	8ade                	mv	s5,s7
    80002512:	b7e1                	j	800024da <scheduler+0x4a>
    if(found == 0) {
    80002514:	000a9463          	bnez	s5,8000251c <scheduler+0x8c>
      asm volatile("wfi");
    80002518:	10500073          	wfi
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    8000251c:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80002520:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80002524:	10079073          	csrw	sstatus,a5
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80002528:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    8000252c:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    8000252e:	10079073          	csrw	sstatus,a5
    int found = 0;
    80002532:	4a81                	li	s5,0
    for(p = proc; p < &proc[NPROC]; p++) {
    80002534:	00011497          	auipc	s1,0x11
    80002538:	7c448493          	addi	s1,s1,1988 # 80013cf8 <proc>
      if(p->state == RUNNABLE) {
    8000253c:	498d                	li	s3,3
    for(p = proc; p < &proc[NPROC]; p++) {
    8000253e:	00089937          	lui	s2,0x89
    80002542:	1d090913          	addi	s2,s2,464 # 891d0 <_entry-0x7ff76e30>
    80002546:	b765                	j	800024ee <scheduler+0x5e>

0000000080002548 <sched>:
{
    80002548:	7179                	addi	sp,sp,-48
    8000254a:	f406                	sd	ra,40(sp)
    8000254c:	f022                	sd	s0,32(sp)
    8000254e:	ec26                	sd	s1,24(sp)
    80002550:	e84a                	sd	s2,16(sp)
    80002552:	e44e                	sd	s3,8(sp)
    80002554:	1800                	addi	s0,sp,48
  struct proc *p = myproc();
    80002556:	9d1ff0ef          	jal	80001f26 <myproc>
    8000255a:	84aa                	mv	s1,a0
  if(!holding(&p->lock))
    8000255c:	e5cfe0ef          	jal	80000bb8 <holding>
    80002560:	c935                	beqz	a0,800025d4 <sched+0x8c>
  asm volatile("mv %0, tp" : "=r" (x) );
    80002562:	8792                	mv	a5,tp
  if(mycpu()->noff != 1)
    80002564:	2781                	sext.w	a5,a5
    80002566:	079e                	slli	a5,a5,0x7
    80002568:	00011717          	auipc	a4,0x11
    8000256c:	36070713          	addi	a4,a4,864 # 800138c8 <pid_lock>
    80002570:	97ba                	add	a5,a5,a4
    80002572:	0a87a703          	lw	a4,168(a5)
    80002576:	4785                	li	a5,1
    80002578:	06f71463          	bne	a4,a5,800025e0 <sched+0x98>
  if(p->state == RUNNING)
    8000257c:	4c98                	lw	a4,24(s1)
    8000257e:	4791                	li	a5,4
    80002580:	06f70663          	beq	a4,a5,800025ec <sched+0xa4>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80002584:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80002588:	8b89                	andi	a5,a5,2
  if(intr_get())
    8000258a:	e7bd                	bnez	a5,800025f8 <sched+0xb0>
  asm volatile("mv %0, tp" : "=r" (x) );
    8000258c:	8792                	mv	a5,tp
  intena = mycpu()->intena;
    8000258e:	00011917          	auipc	s2,0x11
    80002592:	33a90913          	addi	s2,s2,826 # 800138c8 <pid_lock>
    80002596:	2781                	sext.w	a5,a5
    80002598:	079e                	slli	a5,a5,0x7
    8000259a:	97ca                	add	a5,a5,s2
    8000259c:	0ac7a983          	lw	s3,172(a5)
    800025a0:	8792                	mv	a5,tp
  swtch(&p->context, &mycpu()->context);
    800025a2:	2781                	sext.w	a5,a5
    800025a4:	079e                	slli	a5,a5,0x7
    800025a6:	07a1                	addi	a5,a5,8
    800025a8:	00011597          	auipc	a1,0x11
    800025ac:	35058593          	addi	a1,a1,848 # 800138f8 <cpus>
    800025b0:	95be                	add	a1,a1,a5
    800025b2:	06048513          	addi	a0,s1,96
    800025b6:	576000ef          	jal	80002b2c <swtch>
    800025ba:	8792                	mv	a5,tp
  mycpu()->intena = intena;
    800025bc:	2781                	sext.w	a5,a5
    800025be:	079e                	slli	a5,a5,0x7
    800025c0:	993e                	add	s2,s2,a5
    800025c2:	0b392623          	sw	s3,172(s2)
}
    800025c6:	70a2                	ld	ra,40(sp)
    800025c8:	7402                	ld	s0,32(sp)
    800025ca:	64e2                	ld	s1,24(sp)
    800025cc:	6942                	ld	s2,16(sp)
    800025ce:	69a2                	ld	s3,8(sp)
    800025d0:	6145                	addi	sp,sp,48
    800025d2:	8082                	ret
    panic("sched p->lock");
    800025d4:	00006517          	auipc	a0,0x6
    800025d8:	e3450513          	addi	a0,a0,-460 # 80008408 <etext+0x408>
    800025dc:	a48fe0ef          	jal	80000824 <panic>
    panic("sched locks");
    800025e0:	00006517          	auipc	a0,0x6
    800025e4:	e3850513          	addi	a0,a0,-456 # 80008418 <etext+0x418>
    800025e8:	a3cfe0ef          	jal	80000824 <panic>
    panic("sched RUNNING");
    800025ec:	00006517          	auipc	a0,0x6
    800025f0:	e3c50513          	addi	a0,a0,-452 # 80008428 <etext+0x428>
    800025f4:	a30fe0ef          	jal	80000824 <panic>
    panic("sched interruptible");
    800025f8:	00006517          	auipc	a0,0x6
    800025fc:	e4050513          	addi	a0,a0,-448 # 80008438 <etext+0x438>
    80002600:	a24fe0ef          	jal	80000824 <panic>

0000000080002604 <yield>:
{
    80002604:	1101                	addi	sp,sp,-32
    80002606:	ec06                	sd	ra,24(sp)
    80002608:	e822                	sd	s0,16(sp)
    8000260a:	e426                	sd	s1,8(sp)
    8000260c:	1000                	addi	s0,sp,32
  struct proc *p = myproc();
    8000260e:	919ff0ef          	jal	80001f26 <myproc>
    80002612:	84aa                	mv	s1,a0
  acquire(&p->lock);
    80002614:	e14fe0ef          	jal	80000c28 <acquire>
  p->state = RUNNABLE;
    80002618:	478d                	li	a5,3
    8000261a:	cc9c                	sw	a5,24(s1)
  sched();
    8000261c:	f2dff0ef          	jal	80002548 <sched>
  release(&p->lock);
    80002620:	8526                	mv	a0,s1
    80002622:	e9afe0ef          	jal	80000cbc <release>
}
    80002626:	60e2                	ld	ra,24(sp)
    80002628:	6442                	ld	s0,16(sp)
    8000262a:	64a2                	ld	s1,8(sp)
    8000262c:	6105                	addi	sp,sp,32
    8000262e:	8082                	ret

0000000080002630 <sleep>:

// Sleep on channel chan, releasing condition lock lk.
// Re-acquires lk when awakened.
void
sleep(void *chan, struct spinlock *lk)
{
    80002630:	7179                	addi	sp,sp,-48
    80002632:	f406                	sd	ra,40(sp)
    80002634:	f022                	sd	s0,32(sp)
    80002636:	ec26                	sd	s1,24(sp)
    80002638:	e84a                	sd	s2,16(sp)
    8000263a:	e44e                	sd	s3,8(sp)
    8000263c:	1800                	addi	s0,sp,48
    8000263e:	89aa                	mv	s3,a0
    80002640:	892e                	mv	s2,a1
  struct proc *p = myproc();
    80002642:	8e5ff0ef          	jal	80001f26 <myproc>
    80002646:	84aa                	mv	s1,a0
  // Once we hold p->lock, we can be
  // guaranteed that we won't miss any wakeup
  // (wakeup locks p->lock),
  // so it's okay to release lk.

  acquire(&p->lock);  //DOC: sleeplock1
    80002648:	de0fe0ef          	jal	80000c28 <acquire>
  release(lk);
    8000264c:	854a                	mv	a0,s2
    8000264e:	e6efe0ef          	jal	80000cbc <release>

  // Go to sleep.
  p->chan = chan;
    80002652:	0334b023          	sd	s3,32(s1)
  p->state = SLEEPING;
    80002656:	4789                	li	a5,2
    80002658:	cc9c                	sw	a5,24(s1)

  sched();
    8000265a:	eefff0ef          	jal	80002548 <sched>

  // Tidy up.
  p->chan = 0;
    8000265e:	0204b023          	sd	zero,32(s1)

  // Reacquire original lock.
  release(&p->lock);
    80002662:	8526                	mv	a0,s1
    80002664:	e58fe0ef          	jal	80000cbc <release>
  acquire(lk);
    80002668:	854a                	mv	a0,s2
    8000266a:	dbefe0ef          	jal	80000c28 <acquire>
}
    8000266e:	70a2                	ld	ra,40(sp)
    80002670:	7402                	ld	s0,32(sp)
    80002672:	64e2                	ld	s1,24(sp)
    80002674:	6942                	ld	s2,16(sp)
    80002676:	69a2                	ld	s3,8(sp)
    80002678:	6145                	addi	sp,sp,48
    8000267a:	8082                	ret

000000008000267c <wakeup>:

// Wake up all processes sleeping on channel chan.
// Caller should hold the condition lock.
void
wakeup(void *chan)
{
    8000267c:	7139                	addi	sp,sp,-64
    8000267e:	fc06                	sd	ra,56(sp)
    80002680:	f822                	sd	s0,48(sp)
    80002682:	f426                	sd	s1,40(sp)
    80002684:	f04a                	sd	s2,32(sp)
    80002686:	ec4e                	sd	s3,24(sp)
    80002688:	e852                	sd	s4,16(sp)
    8000268a:	e456                	sd	s5,8(sp)
    8000268c:	e05a                	sd	s6,0(sp)
    8000268e:	0080                	addi	s0,sp,64
    80002690:	8aaa                	mv	s5,a0
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++) {
    80002692:	00011497          	auipc	s1,0x11
    80002696:	66648493          	addi	s1,s1,1638 # 80013cf8 <proc>
    if(p != myproc()){
      acquire(&p->lock);
      if(p->state == SLEEPING && p->chan == chan) {
    8000269a:	4a09                	li	s4,2
        p->state = RUNNABLE;
    8000269c:	4b0d                	li	s6,3
  for(p = proc; p < &proc[NPROC]; p++) {
    8000269e:	00089937          	lui	s2,0x89
    800026a2:	1d090913          	addi	s2,s2,464 # 891d0 <_entry-0x7ff76e30>
    800026a6:	02259997          	auipc	s3,0x2259
    800026aa:	a5298993          	addi	s3,s3,-1454 # 8225b0f8 <tickslock>
    800026ae:	a039                	j	800026bc <wakeup+0x40>
      }
      release(&p->lock);
    800026b0:	8526                	mv	a0,s1
    800026b2:	e0afe0ef          	jal	80000cbc <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    800026b6:	94ca                	add	s1,s1,s2
    800026b8:	03348263          	beq	s1,s3,800026dc <wakeup+0x60>
    if(p != myproc()){
    800026bc:	86bff0ef          	jal	80001f26 <myproc>
    800026c0:	fe950be3          	beq	a0,s1,800026b6 <wakeup+0x3a>
      acquire(&p->lock);
    800026c4:	8526                	mv	a0,s1
    800026c6:	d62fe0ef          	jal	80000c28 <acquire>
      if(p->state == SLEEPING && p->chan == chan) {
    800026ca:	4c9c                	lw	a5,24(s1)
    800026cc:	ff4792e3          	bne	a5,s4,800026b0 <wakeup+0x34>
    800026d0:	709c                	ld	a5,32(s1)
    800026d2:	fd579fe3          	bne	a5,s5,800026b0 <wakeup+0x34>
        p->state = RUNNABLE;
    800026d6:	0164ac23          	sw	s6,24(s1)
    800026da:	bfd9                	j	800026b0 <wakeup+0x34>
    }
  }
}
    800026dc:	70e2                	ld	ra,56(sp)
    800026de:	7442                	ld	s0,48(sp)
    800026e0:	74a2                	ld	s1,40(sp)
    800026e2:	7902                	ld	s2,32(sp)
    800026e4:	69e2                	ld	s3,24(sp)
    800026e6:	6a42                	ld	s4,16(sp)
    800026e8:	6aa2                	ld	s5,8(sp)
    800026ea:	6b02                	ld	s6,0(sp)
    800026ec:	6121                	addi	sp,sp,64
    800026ee:	8082                	ret

00000000800026f0 <reparent>:
{
    800026f0:	7139                	addi	sp,sp,-64
    800026f2:	fc06                	sd	ra,56(sp)
    800026f4:	f822                	sd	s0,48(sp)
    800026f6:	f426                	sd	s1,40(sp)
    800026f8:	f04a                	sd	s2,32(sp)
    800026fa:	ec4e                	sd	s3,24(sp)
    800026fc:	e852                	sd	s4,16(sp)
    800026fe:	e456                	sd	s5,8(sp)
    80002700:	0080                	addi	s0,sp,64
    80002702:	89aa                	mv	s3,a0
  for(pp = proc; pp < &proc[NPROC]; pp++){
    80002704:	00011497          	auipc	s1,0x11
    80002708:	5f448493          	addi	s1,s1,1524 # 80013cf8 <proc>
      pp->parent = initproc;
    8000270c:	00009a97          	auipc	s5,0x9
    80002710:	0b4a8a93          	addi	s5,s5,180 # 8000b7c0 <initproc>
  for(pp = proc; pp < &proc[NPROC]; pp++){
    80002714:	00089937          	lui	s2,0x89
    80002718:	1d090913          	addi	s2,s2,464 # 891d0 <_entry-0x7ff76e30>
    8000271c:	02259a17          	auipc	s4,0x2259
    80002720:	9dca0a13          	addi	s4,s4,-1572 # 8225b0f8 <tickslock>
    80002724:	a021                	j	8000272c <reparent+0x3c>
    80002726:	94ca                	add	s1,s1,s2
    80002728:	01448b63          	beq	s1,s4,8000273e <reparent+0x4e>
    if(pp->parent == p){
    8000272c:	7c9c                	ld	a5,56(s1)
    8000272e:	ff379ce3          	bne	a5,s3,80002726 <reparent+0x36>
      pp->parent = initproc;
    80002732:	000ab503          	ld	a0,0(s5)
    80002736:	fc88                	sd	a0,56(s1)
      wakeup(initproc);
    80002738:	f45ff0ef          	jal	8000267c <wakeup>
    8000273c:	b7ed                	j	80002726 <reparent+0x36>
}
    8000273e:	70e2                	ld	ra,56(sp)
    80002740:	7442                	ld	s0,48(sp)
    80002742:	74a2                	ld	s1,40(sp)
    80002744:	7902                	ld	s2,32(sp)
    80002746:	69e2                	ld	s3,24(sp)
    80002748:	6a42                	ld	s4,16(sp)
    8000274a:	6aa2                	ld	s5,8(sp)
    8000274c:	6121                	addi	sp,sp,64
    8000274e:	8082                	ret

0000000080002750 <kexit>:
{
    80002750:	7179                	addi	sp,sp,-48
    80002752:	f406                	sd	ra,40(sp)
    80002754:	f022                	sd	s0,32(sp)
    80002756:	ec26                	sd	s1,24(sp)
    80002758:	e84a                	sd	s2,16(sp)
    8000275a:	e44e                	sd	s3,8(sp)
    8000275c:	e052                	sd	s4,0(sp)
    8000275e:	1800                	addi	s0,sp,48
    80002760:	8a2a                	mv	s4,a0
  struct proc *p = myproc();
    80002762:	fc4ff0ef          	jal	80001f26 <myproc>
    80002766:	892a                	mv	s2,a0
  if(p == initproc)
    80002768:	00009797          	auipc	a5,0x9
    8000276c:	0587b783          	ld	a5,88(a5) # 8000b7c0 <initproc>
    80002770:	0d050493          	addi	s1,a0,208
    80002774:	15050993          	addi	s3,a0,336
    80002778:	00a79b63          	bne	a5,a0,8000278e <kexit+0x3e>
    panic("init exiting");
    8000277c:	00006517          	auipc	a0,0x6
    80002780:	cd450513          	addi	a0,a0,-812 # 80008450 <etext+0x450>
    80002784:	8a0fe0ef          	jal	80000824 <panic>
  for(int fd = 0; fd < NOFILE; fd++){
    80002788:	04a1                	addi	s1,s1,8
    8000278a:	01348963          	beq	s1,s3,8000279c <kexit+0x4c>
    if(p->ofile[fd]){
    8000278e:	6088                	ld	a0,0(s1)
    80002790:	dd65                	beqz	a0,80002788 <kexit+0x38>
      fileclose(f);
    80002792:	138020ef          	jal	800048ca <fileclose>
      p->ofile[fd] = 0;
    80002796:	0004b023          	sd	zero,0(s1)
    8000279a:	b7fd                	j	80002788 <kexit+0x38>
  if(p->swap_file){
    8000279c:	17893783          	ld	a5,376(s2)
    800027a0:	cf8d                	beqz	a5,800027da <kexit+0x8a>
    printf("[pid %d] SWAPCLEANUP freed_slots=%d\n", p->pid, p->num_swappped_pages);
    800027a2:	000897b7          	lui	a5,0x89
    800027a6:	97ca                	add	a5,a5,s2
    800027a8:	1cc7a603          	lw	a2,460(a5) # 891cc <_entry-0x7ff76e34>
    800027ac:	03092583          	lw	a1,48(s2)
    800027b0:	00006517          	auipc	a0,0x6
    800027b4:	cb050513          	addi	a0,a0,-848 # 80008460 <etext+0x460>
    800027b8:	d43fd0ef          	jal	800004fa <printf>
    begin_op(); // Start a file system transaction.
    800027bc:	4eb010ef          	jal	800044a6 <begin_op>
    itrunc(p->swap_file->ip);
    800027c0:	17893783          	ld	a5,376(s2)
    800027c4:	6f88                	ld	a0,24(a5)
    800027c6:	3c2010ef          	jal	80003b88 <itrunc>
    fileclose(p->swap_file);
    800027ca:	17893503          	ld	a0,376(s2)
    800027ce:	0fc020ef          	jal	800048ca <fileclose>
    p->swap_file = 0; // Clear the pointer.
    800027d2:	16093c23          	sd	zero,376(s2)
    end_op(); // End the transaction.
    800027d6:	541010ef          	jal	80004516 <end_op>
  begin_op();
    800027da:	4cd010ef          	jal	800044a6 <begin_op>
  iput(p->cwd);
    800027de:	15093503          	ld	a0,336(s2)
    800027e2:	43a010ef          	jal	80003c1c <iput>
  end_op();
    800027e6:	531010ef          	jal	80004516 <end_op>
  p->cwd = 0;
    800027ea:	14093823          	sd	zero,336(s2)
  acquire(&wait_lock);
    800027ee:	00011517          	auipc	a0,0x11
    800027f2:	0f250513          	addi	a0,a0,242 # 800138e0 <wait_lock>
    800027f6:	c32fe0ef          	jal	80000c28 <acquire>
  reparent(p);
    800027fa:	854a                	mv	a0,s2
    800027fc:	ef5ff0ef          	jal	800026f0 <reparent>
  wakeup(p->parent);
    80002800:	03893503          	ld	a0,56(s2)
    80002804:	e79ff0ef          	jal	8000267c <wakeup>
  acquire(&p->lock);
    80002808:	854a                	mv	a0,s2
    8000280a:	c1efe0ef          	jal	80000c28 <acquire>
  p->xstate = status;
    8000280e:	03492623          	sw	s4,44(s2)
  p->state = ZOMBIE;
    80002812:	4795                	li	a5,5
    80002814:	00f92c23          	sw	a5,24(s2)
  release(&wait_lock);
    80002818:	00011517          	auipc	a0,0x11
    8000281c:	0c850513          	addi	a0,a0,200 # 800138e0 <wait_lock>
    80002820:	c9cfe0ef          	jal	80000cbc <release>
  sched();
    80002824:	d25ff0ef          	jal	80002548 <sched>
  panic("zombie exit");
    80002828:	00006517          	auipc	a0,0x6
    8000282c:	c6050513          	addi	a0,a0,-928 # 80008488 <etext+0x488>
    80002830:	ff5fd0ef          	jal	80000824 <panic>

0000000080002834 <kkill>:
// Kill the process with the given pid.
// The victim won't exit until it tries to return
// to user space (see usertrap() in trap.c).
int
kkill(int pid)
{
    80002834:	7179                	addi	sp,sp,-48
    80002836:	f406                	sd	ra,40(sp)
    80002838:	f022                	sd	s0,32(sp)
    8000283a:	ec26                	sd	s1,24(sp)
    8000283c:	e84a                	sd	s2,16(sp)
    8000283e:	e44e                	sd	s3,8(sp)
    80002840:	e052                	sd	s4,0(sp)
    80002842:	1800                	addi	s0,sp,48
    80002844:	892a                	mv	s2,a0
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++){
    80002846:	00011497          	auipc	s1,0x11
    8000284a:	4b248493          	addi	s1,s1,1202 # 80013cf8 <proc>
    8000284e:	000899b7          	lui	s3,0x89
    80002852:	1d098993          	addi	s3,s3,464 # 891d0 <_entry-0x7ff76e30>
    80002856:	02259a17          	auipc	s4,0x2259
    8000285a:	8a2a0a13          	addi	s4,s4,-1886 # 8225b0f8 <tickslock>
    acquire(&p->lock);
    8000285e:	8526                	mv	a0,s1
    80002860:	bc8fe0ef          	jal	80000c28 <acquire>
    if(p->pid == pid){
    80002864:	589c                	lw	a5,48(s1)
    80002866:	01278a63          	beq	a5,s2,8000287a <kkill+0x46>
        p->state = RUNNABLE;
      }
      release(&p->lock);
      return 0;
    }
    release(&p->lock);
    8000286a:	8526                	mv	a0,s1
    8000286c:	c50fe0ef          	jal	80000cbc <release>
  for(p = proc; p < &proc[NPROC]; p++){
    80002870:	94ce                	add	s1,s1,s3
    80002872:	ff4496e3          	bne	s1,s4,8000285e <kkill+0x2a>
  }
  return -1;
    80002876:	557d                	li	a0,-1
    80002878:	a819                	j	8000288e <kkill+0x5a>
      p->killed = 1;
    8000287a:	4785                	li	a5,1
    8000287c:	d49c                	sw	a5,40(s1)
      if(p->state == SLEEPING){
    8000287e:	4c98                	lw	a4,24(s1)
    80002880:	4789                	li	a5,2
    80002882:	00f70e63          	beq	a4,a5,8000289e <kkill+0x6a>
      release(&p->lock);
    80002886:	8526                	mv	a0,s1
    80002888:	c34fe0ef          	jal	80000cbc <release>
      return 0;
    8000288c:	4501                	li	a0,0
}
    8000288e:	70a2                	ld	ra,40(sp)
    80002890:	7402                	ld	s0,32(sp)
    80002892:	64e2                	ld	s1,24(sp)
    80002894:	6942                	ld	s2,16(sp)
    80002896:	69a2                	ld	s3,8(sp)
    80002898:	6a02                	ld	s4,0(sp)
    8000289a:	6145                	addi	sp,sp,48
    8000289c:	8082                	ret
        p->state = RUNNABLE;
    8000289e:	478d                	li	a5,3
    800028a0:	cc9c                	sw	a5,24(s1)
    800028a2:	b7d5                	j	80002886 <kkill+0x52>

00000000800028a4 <setkilled>:

void
setkilled(struct proc *p)
{
    800028a4:	1101                	addi	sp,sp,-32
    800028a6:	ec06                	sd	ra,24(sp)
    800028a8:	e822                	sd	s0,16(sp)
    800028aa:	e426                	sd	s1,8(sp)
    800028ac:	1000                	addi	s0,sp,32
    800028ae:	84aa                	mv	s1,a0
  acquire(&p->lock);
    800028b0:	b78fe0ef          	jal	80000c28 <acquire>
  p->killed = 1;
    800028b4:	4785                	li	a5,1
    800028b6:	d49c                	sw	a5,40(s1)
  release(&p->lock);
    800028b8:	8526                	mv	a0,s1
    800028ba:	c02fe0ef          	jal	80000cbc <release>
}
    800028be:	60e2                	ld	ra,24(sp)
    800028c0:	6442                	ld	s0,16(sp)
    800028c2:	64a2                	ld	s1,8(sp)
    800028c4:	6105                	addi	sp,sp,32
    800028c6:	8082                	ret

00000000800028c8 <killed>:

int
killed(struct proc *p)
{
    800028c8:	1101                	addi	sp,sp,-32
    800028ca:	ec06                	sd	ra,24(sp)
    800028cc:	e822                	sd	s0,16(sp)
    800028ce:	e426                	sd	s1,8(sp)
    800028d0:	e04a                	sd	s2,0(sp)
    800028d2:	1000                	addi	s0,sp,32
    800028d4:	84aa                	mv	s1,a0
  int k;
  
  acquire(&p->lock);
    800028d6:	b52fe0ef          	jal	80000c28 <acquire>
  k = p->killed;
    800028da:	549c                	lw	a5,40(s1)
    800028dc:	893e                	mv	s2,a5
  release(&p->lock);
    800028de:	8526                	mv	a0,s1
    800028e0:	bdcfe0ef          	jal	80000cbc <release>
  return k;
}
    800028e4:	854a                	mv	a0,s2
    800028e6:	60e2                	ld	ra,24(sp)
    800028e8:	6442                	ld	s0,16(sp)
    800028ea:	64a2                	ld	s1,8(sp)
    800028ec:	6902                	ld	s2,0(sp)
    800028ee:	6105                	addi	sp,sp,32
    800028f0:	8082                	ret

00000000800028f2 <kwait>:
{
    800028f2:	715d                	addi	sp,sp,-80
    800028f4:	e486                	sd	ra,72(sp)
    800028f6:	e0a2                	sd	s0,64(sp)
    800028f8:	fc26                	sd	s1,56(sp)
    800028fa:	f84a                	sd	s2,48(sp)
    800028fc:	f44e                	sd	s3,40(sp)
    800028fe:	f052                	sd	s4,32(sp)
    80002900:	ec56                	sd	s5,24(sp)
    80002902:	e85a                	sd	s6,16(sp)
    80002904:	e45e                	sd	s7,8(sp)
    80002906:	0880                	addi	s0,sp,80
    80002908:	8baa                	mv	s7,a0
  struct proc *p = myproc();
    8000290a:	e1cff0ef          	jal	80001f26 <myproc>
    8000290e:	892a                	mv	s2,a0
  acquire(&wait_lock);
    80002910:	00011517          	auipc	a0,0x11
    80002914:	fd050513          	addi	a0,a0,-48 # 800138e0 <wait_lock>
    80002918:	b10fe0ef          	jal	80000c28 <acquire>
        if(pp->state == ZOMBIE){
    8000291c:	4a95                	li	s5,5
        havekids = 1;
    8000291e:	4b05                	li	s6,1
    for(pp = proc; pp < &proc[NPROC]; pp++){
    80002920:	000899b7          	lui	s3,0x89
    80002924:	1d098993          	addi	s3,s3,464 # 891d0 <_entry-0x7ff76e30>
    80002928:	02258a17          	auipc	s4,0x2258
    8000292c:	7d0a0a13          	addi	s4,s4,2000 # 8225b0f8 <tickslock>
    80002930:	a879                	j	800029ce <kwait+0xdc>
          pid = pp->pid;
    80002932:	0304a983          	lw	s3,48(s1)
          if(addr != 0 && copyout(p->pagetable, addr, (char *)&pp->xstate,
    80002936:	000b8c63          	beqz	s7,8000294e <kwait+0x5c>
    8000293a:	4691                	li	a3,4
    8000293c:	02c48613          	addi	a2,s1,44
    80002940:	85de                	mv	a1,s7
    80002942:	05093503          	ld	a0,80(s2)
    80002946:	960ff0ef          	jal	80001aa6 <copyout>
    8000294a:	02054a63          	bltz	a0,8000297e <kwait+0x8c>
          freeproc(pp);
    8000294e:	8526                	mv	a0,s1
    80002950:	faaff0ef          	jal	800020fa <freeproc>
          release(&pp->lock);
    80002954:	8526                	mv	a0,s1
    80002956:	b66fe0ef          	jal	80000cbc <release>
          release(&wait_lock);
    8000295a:	00011517          	auipc	a0,0x11
    8000295e:	f8650513          	addi	a0,a0,-122 # 800138e0 <wait_lock>
    80002962:	b5afe0ef          	jal	80000cbc <release>
}
    80002966:	854e                	mv	a0,s3
    80002968:	60a6                	ld	ra,72(sp)
    8000296a:	6406                	ld	s0,64(sp)
    8000296c:	74e2                	ld	s1,56(sp)
    8000296e:	7942                	ld	s2,48(sp)
    80002970:	79a2                	ld	s3,40(sp)
    80002972:	7a02                	ld	s4,32(sp)
    80002974:	6ae2                	ld	s5,24(sp)
    80002976:	6b42                	ld	s6,16(sp)
    80002978:	6ba2                	ld	s7,8(sp)
    8000297a:	6161                	addi	sp,sp,80
    8000297c:	8082                	ret
            release(&pp->lock);
    8000297e:	8526                	mv	a0,s1
    80002980:	b3cfe0ef          	jal	80000cbc <release>
            release(&wait_lock);
    80002984:	00011517          	auipc	a0,0x11
    80002988:	f5c50513          	addi	a0,a0,-164 # 800138e0 <wait_lock>
    8000298c:	b30fe0ef          	jal	80000cbc <release>
            return -1;
    80002990:	59fd                	li	s3,-1
    80002992:	bfd1                	j	80002966 <kwait+0x74>
    for(pp = proc; pp < &proc[NPROC]; pp++){
    80002994:	94ce                	add	s1,s1,s3
    80002996:	03448063          	beq	s1,s4,800029b6 <kwait+0xc4>
      if(pp->parent == p){
    8000299a:	7c9c                	ld	a5,56(s1)
    8000299c:	ff279ce3          	bne	a5,s2,80002994 <kwait+0xa2>
        acquire(&pp->lock);
    800029a0:	8526                	mv	a0,s1
    800029a2:	a86fe0ef          	jal	80000c28 <acquire>
        if(pp->state == ZOMBIE){
    800029a6:	4c9c                	lw	a5,24(s1)
    800029a8:	f95785e3          	beq	a5,s5,80002932 <kwait+0x40>
        release(&pp->lock);
    800029ac:	8526                	mv	a0,s1
    800029ae:	b0efe0ef          	jal	80000cbc <release>
        havekids = 1;
    800029b2:	875a                	mv	a4,s6
    800029b4:	b7c5                	j	80002994 <kwait+0xa2>
    if(!havekids || killed(p)){
    800029b6:	c315                	beqz	a4,800029da <kwait+0xe8>
    800029b8:	854a                	mv	a0,s2
    800029ba:	f0fff0ef          	jal	800028c8 <killed>
    800029be:	ed11                	bnez	a0,800029da <kwait+0xe8>
    sleep(p, &wait_lock);  //DOC: wait-sleep
    800029c0:	00011597          	auipc	a1,0x11
    800029c4:	f2058593          	addi	a1,a1,-224 # 800138e0 <wait_lock>
    800029c8:	854a                	mv	a0,s2
    800029ca:	c67ff0ef          	jal	80002630 <sleep>
    havekids = 0;
    800029ce:	4701                	li	a4,0
    for(pp = proc; pp < &proc[NPROC]; pp++){
    800029d0:	00011497          	auipc	s1,0x11
    800029d4:	32848493          	addi	s1,s1,808 # 80013cf8 <proc>
    800029d8:	b7c9                	j	8000299a <kwait+0xa8>
      release(&wait_lock);
    800029da:	00011517          	auipc	a0,0x11
    800029de:	f0650513          	addi	a0,a0,-250 # 800138e0 <wait_lock>
    800029e2:	adafe0ef          	jal	80000cbc <release>
      return -1;
    800029e6:	59fd                	li	s3,-1
    800029e8:	bfbd                	j	80002966 <kwait+0x74>

00000000800029ea <either_copyout>:
// Copy to either a user address, or kernel address,
// depending on usr_dst.
// Returns 0 on success, -1 on error.
int
either_copyout(int user_dst, uint64 dst, void *src, uint64 len)
{
    800029ea:	7179                	addi	sp,sp,-48
    800029ec:	f406                	sd	ra,40(sp)
    800029ee:	f022                	sd	s0,32(sp)
    800029f0:	ec26                	sd	s1,24(sp)
    800029f2:	e84a                	sd	s2,16(sp)
    800029f4:	e44e                	sd	s3,8(sp)
    800029f6:	e052                	sd	s4,0(sp)
    800029f8:	1800                	addi	s0,sp,48
    800029fa:	84aa                	mv	s1,a0
    800029fc:	8a2e                	mv	s4,a1
    800029fe:	89b2                	mv	s3,a2
    80002a00:	8936                	mv	s2,a3
  struct proc *p = myproc();
    80002a02:	d24ff0ef          	jal	80001f26 <myproc>
  if(user_dst){
    80002a06:	cc99                	beqz	s1,80002a24 <either_copyout+0x3a>
    return copyout(p->pagetable, dst, src, len);
    80002a08:	86ca                	mv	a3,s2
    80002a0a:	864e                	mv	a2,s3
    80002a0c:	85d2                	mv	a1,s4
    80002a0e:	6928                	ld	a0,80(a0)
    80002a10:	896ff0ef          	jal	80001aa6 <copyout>
  } else {
    memmove((char *)dst, src, len);
    return 0;
  }
}
    80002a14:	70a2                	ld	ra,40(sp)
    80002a16:	7402                	ld	s0,32(sp)
    80002a18:	64e2                	ld	s1,24(sp)
    80002a1a:	6942                	ld	s2,16(sp)
    80002a1c:	69a2                	ld	s3,8(sp)
    80002a1e:	6a02                	ld	s4,0(sp)
    80002a20:	6145                	addi	sp,sp,48
    80002a22:	8082                	ret
    memmove((char *)dst, src, len);
    80002a24:	0009061b          	sext.w	a2,s2
    80002a28:	85ce                	mv	a1,s3
    80002a2a:	8552                	mv	a0,s4
    80002a2c:	b2cfe0ef          	jal	80000d58 <memmove>
    return 0;
    80002a30:	8526                	mv	a0,s1
    80002a32:	b7cd                	j	80002a14 <either_copyout+0x2a>

0000000080002a34 <either_copyin>:
// Copy from either a user address, or kernel address,
// depending on usr_src.
// Returns 0 on success, -1 on error.
int
either_copyin(void *dst, int user_src, uint64 src, uint64 len)
{
    80002a34:	7179                	addi	sp,sp,-48
    80002a36:	f406                	sd	ra,40(sp)
    80002a38:	f022                	sd	s0,32(sp)
    80002a3a:	ec26                	sd	s1,24(sp)
    80002a3c:	e84a                	sd	s2,16(sp)
    80002a3e:	e44e                	sd	s3,8(sp)
    80002a40:	e052                	sd	s4,0(sp)
    80002a42:	1800                	addi	s0,sp,48
    80002a44:	8a2a                	mv	s4,a0
    80002a46:	84ae                	mv	s1,a1
    80002a48:	89b2                	mv	s3,a2
    80002a4a:	8936                	mv	s2,a3
  struct proc *p = myproc();
    80002a4c:	cdaff0ef          	jal	80001f26 <myproc>
  if(user_src){
    80002a50:	cc99                	beqz	s1,80002a6e <either_copyin+0x3a>
    return copyin(p->pagetable, dst, src, len);
    80002a52:	86ca                	mv	a3,s2
    80002a54:	864e                	mv	a2,s3
    80002a56:	85d2                	mv	a1,s4
    80002a58:	6928                	ld	a0,80(a0)
    80002a5a:	97aff0ef          	jal	80001bd4 <copyin>
  } else {
    memmove(dst, (char*)src, len);
    return 0;
  }
}
    80002a5e:	70a2                	ld	ra,40(sp)
    80002a60:	7402                	ld	s0,32(sp)
    80002a62:	64e2                	ld	s1,24(sp)
    80002a64:	6942                	ld	s2,16(sp)
    80002a66:	69a2                	ld	s3,8(sp)
    80002a68:	6a02                	ld	s4,0(sp)
    80002a6a:	6145                	addi	sp,sp,48
    80002a6c:	8082                	ret
    memmove(dst, (char*)src, len);
    80002a6e:	0009061b          	sext.w	a2,s2
    80002a72:	85ce                	mv	a1,s3
    80002a74:	8552                	mv	a0,s4
    80002a76:	ae2fe0ef          	jal	80000d58 <memmove>
    return 0;
    80002a7a:	8526                	mv	a0,s1
    80002a7c:	b7cd                	j	80002a5e <either_copyin+0x2a>

0000000080002a7e <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
    80002a7e:	715d                	addi	sp,sp,-80
    80002a80:	e486                	sd	ra,72(sp)
    80002a82:	e0a2                	sd	s0,64(sp)
    80002a84:	fc26                	sd	s1,56(sp)
    80002a86:	f84a                	sd	s2,48(sp)
    80002a88:	f44e                	sd	s3,40(sp)
    80002a8a:	f052                	sd	s4,32(sp)
    80002a8c:	ec56                	sd	s5,24(sp)
    80002a8e:	e85a                	sd	s6,16(sp)
    80002a90:	e45e                	sd	s7,8(sp)
    80002a92:	e062                	sd	s8,0(sp)
    80002a94:	0880                	addi	s0,sp,80
  [ZOMBIE]    "zombie"
  };
  struct proc *p;
  char *state;

  printf("\n");
    80002a96:	00005517          	auipc	a0,0x5
    80002a9a:	6aa50513          	addi	a0,a0,1706 # 80008140 <etext+0x140>
    80002a9e:	a5dfd0ef          	jal	800004fa <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    80002aa2:	00011497          	auipc	s1,0x11
    80002aa6:	3ae48493          	addi	s1,s1,942 # 80013e50 <proc+0x158>
    80002aaa:	02258997          	auipc	s3,0x2258
    80002aae:	7a698993          	addi	s3,s3,1958 # 8225b250 <bcache+0x140>
    if(p->state == UNUSED)
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80002ab2:	4b95                	li	s7,5
      state = states[p->state];
    else
      state = "???";
    80002ab4:	00006a17          	auipc	s4,0x6
    80002ab8:	9e4a0a13          	addi	s4,s4,-1564 # 80008498 <etext+0x498>
    printf("%d %s %s", p->pid, state, p->name);
    80002abc:	00006b17          	auipc	s6,0x6
    80002ac0:	9e4b0b13          	addi	s6,s6,-1564 # 800084a0 <etext+0x4a0>
    printf("\n");
    80002ac4:	00005a97          	auipc	s5,0x5
    80002ac8:	67ca8a93          	addi	s5,s5,1660 # 80008140 <etext+0x140>
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80002acc:	00006c17          	auipc	s8,0x6
    80002ad0:	f9cc0c13          	addi	s8,s8,-100 # 80008a68 <states.0>
  for(p = proc; p < &proc[NPROC]; p++){
    80002ad4:	00089937          	lui	s2,0x89
    80002ad8:	1d090913          	addi	s2,s2,464 # 891d0 <_entry-0x7ff76e30>
    80002adc:	a821                	j	80002af4 <procdump+0x76>
    printf("%d %s %s", p->pid, state, p->name);
    80002ade:	ed86a583          	lw	a1,-296(a3)
    80002ae2:	855a                	mv	a0,s6
    80002ae4:	a17fd0ef          	jal	800004fa <printf>
    printf("\n");
    80002ae8:	8556                	mv	a0,s5
    80002aea:	a11fd0ef          	jal	800004fa <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    80002aee:	94ca                	add	s1,s1,s2
    80002af0:	03348263          	beq	s1,s3,80002b14 <procdump+0x96>
    if(p->state == UNUSED)
    80002af4:	86a6                	mv	a3,s1
    80002af6:	ec04a783          	lw	a5,-320(s1)
    80002afa:	dbf5                	beqz	a5,80002aee <procdump+0x70>
      state = "???";
    80002afc:	8652                	mv	a2,s4
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80002afe:	fefbe0e3          	bltu	s7,a5,80002ade <procdump+0x60>
    80002b02:	02079713          	slli	a4,a5,0x20
    80002b06:	01d75793          	srli	a5,a4,0x1d
    80002b0a:	97e2                	add	a5,a5,s8
    80002b0c:	6390                	ld	a2,0(a5)
    80002b0e:	fa61                	bnez	a2,80002ade <procdump+0x60>
      state = "???";
    80002b10:	8652                	mv	a2,s4
    80002b12:	b7f1                	j	80002ade <procdump+0x60>
  }
}
    80002b14:	60a6                	ld	ra,72(sp)
    80002b16:	6406                	ld	s0,64(sp)
    80002b18:	74e2                	ld	s1,56(sp)
    80002b1a:	7942                	ld	s2,48(sp)
    80002b1c:	79a2                	ld	s3,40(sp)
    80002b1e:	7a02                	ld	s4,32(sp)
    80002b20:	6ae2                	ld	s5,24(sp)
    80002b22:	6b42                	ld	s6,16(sp)
    80002b24:	6ba2                	ld	s7,8(sp)
    80002b26:	6c02                	ld	s8,0(sp)
    80002b28:	6161                	addi	sp,sp,80
    80002b2a:	8082                	ret

0000000080002b2c <swtch>:
# Save current registers in old. Load from new.	


.globl swtch
swtch:
        sd ra, 0(a0)
    80002b2c:	00153023          	sd	ra,0(a0)
        sd sp, 8(a0)
    80002b30:	00253423          	sd	sp,8(a0)
        sd s0, 16(a0)
    80002b34:	e900                	sd	s0,16(a0)
        sd s1, 24(a0)
    80002b36:	ed04                	sd	s1,24(a0)
        sd s2, 32(a0)
    80002b38:	03253023          	sd	s2,32(a0)
        sd s3, 40(a0)
    80002b3c:	03353423          	sd	s3,40(a0)
        sd s4, 48(a0)
    80002b40:	03453823          	sd	s4,48(a0)
        sd s5, 56(a0)
    80002b44:	03553c23          	sd	s5,56(a0)
        sd s6, 64(a0)
    80002b48:	05653023          	sd	s6,64(a0)
        sd s7, 72(a0)
    80002b4c:	05753423          	sd	s7,72(a0)
        sd s8, 80(a0)
    80002b50:	05853823          	sd	s8,80(a0)
        sd s9, 88(a0)
    80002b54:	05953c23          	sd	s9,88(a0)
        sd s10, 96(a0)
    80002b58:	07a53023          	sd	s10,96(a0)
        sd s11, 104(a0)
    80002b5c:	07b53423          	sd	s11,104(a0)

        ld ra, 0(a1)
    80002b60:	0005b083          	ld	ra,0(a1)
        ld sp, 8(a1)
    80002b64:	0085b103          	ld	sp,8(a1)
        ld s0, 16(a1)
    80002b68:	6980                	ld	s0,16(a1)
        ld s1, 24(a1)
    80002b6a:	6d84                	ld	s1,24(a1)
        ld s2, 32(a1)
    80002b6c:	0205b903          	ld	s2,32(a1)
        ld s3, 40(a1)
    80002b70:	0285b983          	ld	s3,40(a1)
        ld s4, 48(a1)
    80002b74:	0305ba03          	ld	s4,48(a1)
        ld s5, 56(a1)
    80002b78:	0385ba83          	ld	s5,56(a1)
        ld s6, 64(a1)
    80002b7c:	0405bb03          	ld	s6,64(a1)
        ld s7, 72(a1)
    80002b80:	0485bb83          	ld	s7,72(a1)
        ld s8, 80(a1)
    80002b84:	0505bc03          	ld	s8,80(a1)
        ld s9, 88(a1)
    80002b88:	0585bc83          	ld	s9,88(a1)
        ld s10, 96(a1)
    80002b8c:	0605bd03          	ld	s10,96(a1)
        ld s11, 104(a1)
    80002b90:	0685bd83          	ld	s11,104(a1)
        
        ret
    80002b94:	8082                	ret

0000000080002b96 <trapinit>:

extern int devintr();

void
trapinit(void)
{
    80002b96:	1141                	addi	sp,sp,-16
    80002b98:	e406                	sd	ra,8(sp)
    80002b9a:	e022                	sd	s0,0(sp)
    80002b9c:	0800                	addi	s0,sp,16
  initlock(&tickslock, "time");
    80002b9e:	00006597          	auipc	a1,0x6
    80002ba2:	94258593          	addi	a1,a1,-1726 # 800084e0 <etext+0x4e0>
    80002ba6:	02258517          	auipc	a0,0x2258
    80002baa:	55250513          	addi	a0,a0,1362 # 8225b0f8 <tickslock>
    80002bae:	ff1fd0ef          	jal	80000b9e <initlock>
}
    80002bb2:	60a2                	ld	ra,8(sp)
    80002bb4:	6402                	ld	s0,0(sp)
    80002bb6:	0141                	addi	sp,sp,16
    80002bb8:	8082                	ret

0000000080002bba <trapinithart>:

// set up to take exceptions and traps while in the kernel.
void
trapinithart(void)
{
    80002bba:	1141                	addi	sp,sp,-16
    80002bbc:	e406                	sd	ra,8(sp)
    80002bbe:	e022                	sd	s0,0(sp)
    80002bc0:	0800                	addi	s0,sp,16
  asm volatile("csrw stvec, %0" : : "r" (x));
    80002bc2:	00003797          	auipc	a5,0x3
    80002bc6:	33e78793          	addi	a5,a5,830 # 80005f00 <kernelvec>
    80002bca:	10579073          	csrw	stvec,a5
  w_stvec((uint64)kernelvec);
}
    80002bce:	60a2                	ld	ra,8(sp)
    80002bd0:	6402                	ld	s0,0(sp)
    80002bd2:	0141                	addi	sp,sp,16
    80002bd4:	8082                	ret

0000000080002bd6 <prepare_return>:
//
// set up trapframe and control registers for a return to user space
//
    void
prepare_return(void)
{
    80002bd6:	1141                	addi	sp,sp,-16
    80002bd8:	e406                	sd	ra,8(sp)
    80002bda:	e022                	sd	s0,0(sp)
    80002bdc:	0800                	addi	s0,sp,16
    struct proc *p = myproc();
    80002bde:	b48ff0ef          	jal	80001f26 <myproc>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80002be2:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    80002be6:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80002be8:	10079073          	csrw	sstatus,a5
    // kerneltrap() to usertrap(). because a trap from kernel
    // code to usertrap would be a disaster, turn off interrupts.
    intr_off();

    // send syscalls, interrupts, and exceptions to uservec in trampoline.S
    uint64 trampoline_uservec = TRAMPOLINE + (uservec - trampoline);
    80002bec:	04000737          	lui	a4,0x4000
    80002bf0:	177d                	addi	a4,a4,-1 # 3ffffff <_entry-0x7c000001>
    80002bf2:	0732                	slli	a4,a4,0xc
    80002bf4:	00004797          	auipc	a5,0x4
    80002bf8:	40c78793          	addi	a5,a5,1036 # 80007000 <_trampoline>
    80002bfc:	00004697          	auipc	a3,0x4
    80002c00:	40468693          	addi	a3,a3,1028 # 80007000 <_trampoline>
    80002c04:	8f95                	sub	a5,a5,a3
    80002c06:	97ba                	add	a5,a5,a4
  asm volatile("csrw stvec, %0" : : "r" (x));
    80002c08:	10579073          	csrw	stvec,a5
    w_stvec(trampoline_uservec);

    // set up trapframe values that uservec will need when
    // the process next traps into the kernel.
    p->trapframe->kernel_satp = r_satp();         // kernel page table
    80002c0c:	6d3c                	ld	a5,88(a0)
  asm volatile("csrr %0, satp" : "=r" (x) );
    80002c0e:	18002773          	csrr	a4,satp
    80002c12:	e398                	sd	a4,0(a5)
    p->trapframe->kernel_sp = p->kstack + PGSIZE; // process's kernel stack
    80002c14:	6d38                	ld	a4,88(a0)
    80002c16:	613c                	ld	a5,64(a0)
    80002c18:	6685                	lui	a3,0x1
    80002c1a:	97b6                	add	a5,a5,a3
    80002c1c:	e71c                	sd	a5,8(a4)
    p->trapframe->kernel_trap = (uint64)usertrap;
    80002c1e:	6d3c                	ld	a5,88(a0)
    80002c20:	00000717          	auipc	a4,0x0
    80002c24:	0fc70713          	addi	a4,a4,252 # 80002d1c <usertrap>
    80002c28:	eb98                	sd	a4,16(a5)
    p->trapframe->kernel_hartid = r_tp();         // hartid for cpuid()
    80002c2a:	6d3c                	ld	a5,88(a0)
  asm volatile("mv %0, tp" : "=r" (x) );
    80002c2c:	8712                	mv	a4,tp
    80002c2e:	f398                	sd	a4,32(a5)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80002c30:	100027f3          	csrr	a5,sstatus
    // set up the registers that trampoline.S's sret will use
    // to get to user space.

    // set S Previous Privilege mode to User.
    unsigned long x = r_sstatus();
    x &= ~SSTATUS_SPP; // clear SPP to 0 for user mode
    80002c34:	eff7f793          	andi	a5,a5,-257
    x |= SSTATUS_SPIE; // enable interrupts in user mode
    80002c38:	0207e793          	ori	a5,a5,32
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80002c3c:	10079073          	csrw	sstatus,a5
    w_sstatus(x);

    // set S Exception Program Counter to the saved user pc.
    w_sepc(p->trapframe->epc);
    80002c40:	6d3c                	ld	a5,88(a0)
  asm volatile("csrw sepc, %0" : : "r" (x));
    80002c42:	6f9c                	ld	a5,24(a5)
    80002c44:	14179073          	csrw	sepc,a5
}
    80002c48:	60a2                	ld	ra,8(sp)
    80002c4a:	6402                	ld	s0,0(sp)
    80002c4c:	0141                	addi	sp,sp,16
    80002c4e:	8082                	ret

0000000080002c50 <clockintr>:
    w_sstatus(sstatus);
}

    void
clockintr()
{
    80002c50:	1141                	addi	sp,sp,-16
    80002c52:	e406                	sd	ra,8(sp)
    80002c54:	e022                	sd	s0,0(sp)
    80002c56:	0800                	addi	s0,sp,16
    if(cpuid() == 0){
    80002c58:	a9aff0ef          	jal	80001ef2 <cpuid>
    80002c5c:	cd11                	beqz	a0,80002c78 <clockintr+0x28>
  asm volatile("csrr %0, time" : "=r" (x) );
    80002c5e:	c01027f3          	rdtime	a5
    }

    // ask for the next timer interrupt. this also clears
    // the interrupt request. 1000000 is about a tenth
    // of a second.
    w_stimecmp(r_time() + 1000000);
    80002c62:	000f4737          	lui	a4,0xf4
    80002c66:	24070713          	addi	a4,a4,576 # f4240 <_entry-0x7ff0bdc0>
    80002c6a:	97ba                	add	a5,a5,a4
  asm volatile("csrw 0x14d, %0" : : "r" (x));
    80002c6c:	14d79073          	csrw	stimecmp,a5
}
    80002c70:	60a2                	ld	ra,8(sp)
    80002c72:	6402                	ld	s0,0(sp)
    80002c74:	0141                	addi	sp,sp,16
    80002c76:	8082                	ret
        acquire(&tickslock);
    80002c78:	02258517          	auipc	a0,0x2258
    80002c7c:	48050513          	addi	a0,a0,1152 # 8225b0f8 <tickslock>
    80002c80:	fa9fd0ef          	jal	80000c28 <acquire>
        ticks++;
    80002c84:	00009717          	auipc	a4,0x9
    80002c88:	b4470713          	addi	a4,a4,-1212 # 8000b7c8 <ticks>
    80002c8c:	431c                	lw	a5,0(a4)
    80002c8e:	2785                	addiw	a5,a5,1
    80002c90:	c31c                	sw	a5,0(a4)
        wakeup(&ticks);
    80002c92:	853a                	mv	a0,a4
    80002c94:	9e9ff0ef          	jal	8000267c <wakeup>
        release(&tickslock);
    80002c98:	02258517          	auipc	a0,0x2258
    80002c9c:	46050513          	addi	a0,a0,1120 # 8225b0f8 <tickslock>
    80002ca0:	81cfe0ef          	jal	80000cbc <release>
    80002ca4:	bf6d                	j	80002c5e <clockintr+0xe>

0000000080002ca6 <devintr>:
// returns 2 if timer interrupt,
// 1 if other device,
// 0 if not recognized.
    int
devintr()
{
    80002ca6:	1101                	addi	sp,sp,-32
    80002ca8:	ec06                	sd	ra,24(sp)
    80002caa:	e822                	sd	s0,16(sp)
    80002cac:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, scause" : "=r" (x) );
    80002cae:	14202773          	csrr	a4,scause
    uint64 scause = r_scause();

    if(scause == 0x8000000000000009L){
    80002cb2:	57fd                	li	a5,-1
    80002cb4:	17fe                	slli	a5,a5,0x3f
    80002cb6:	07a5                	addi	a5,a5,9
    80002cb8:	00f70c63          	beq	a4,a5,80002cd0 <devintr+0x2a>
        // now allowed to interrupt again.
        if(irq)
            plic_complete(irq);

        return 1;
    } else if(scause == 0x8000000000000005L){
    80002cbc:	57fd                	li	a5,-1
    80002cbe:	17fe                	slli	a5,a5,0x3f
    80002cc0:	0795                	addi	a5,a5,5
        // timer interrupt.
        clockintr();
        return 2;
    } else {
        return 0;
    80002cc2:	4501                	li	a0,0
    } else if(scause == 0x8000000000000005L){
    80002cc4:	04f70863          	beq	a4,a5,80002d14 <devintr+0x6e>
    }
}
    80002cc8:	60e2                	ld	ra,24(sp)
    80002cca:	6442                	ld	s0,16(sp)
    80002ccc:	6105                	addi	sp,sp,32
    80002cce:	8082                	ret
    80002cd0:	e426                	sd	s1,8(sp)
        int irq = plic_claim();
    80002cd2:	2da030ef          	jal	80005fac <plic_claim>
    80002cd6:	872a                	mv	a4,a0
    80002cd8:	84aa                	mv	s1,a0
        if(irq == UART0_IRQ){
    80002cda:	47a9                	li	a5,10
    80002cdc:	00f50963          	beq	a0,a5,80002cee <devintr+0x48>
        } else if(irq == VIRTIO0_IRQ){
    80002ce0:	4785                	li	a5,1
    80002ce2:	00f50963          	beq	a0,a5,80002cf4 <devintr+0x4e>
        return 1;
    80002ce6:	4505                	li	a0,1
        } else if(irq){
    80002ce8:	eb09                	bnez	a4,80002cfa <devintr+0x54>
    80002cea:	64a2                	ld	s1,8(sp)
    80002cec:	bff1                	j	80002cc8 <devintr+0x22>
            uartintr();
    80002cee:	d07fd0ef          	jal	800009f4 <uartintr>
        if(irq)
    80002cf2:	a819                	j	80002d08 <devintr+0x62>
            virtio_disk_intr();
    80002cf4:	74e030ef          	jal	80006442 <virtio_disk_intr>
        if(irq)
    80002cf8:	a801                	j	80002d08 <devintr+0x62>
            printf("unexpected interrupt irq=%d\n", irq);
    80002cfa:	85ba                	mv	a1,a4
    80002cfc:	00005517          	auipc	a0,0x5
    80002d00:	7ec50513          	addi	a0,a0,2028 # 800084e8 <etext+0x4e8>
    80002d04:	ff6fd0ef          	jal	800004fa <printf>
            plic_complete(irq);
    80002d08:	8526                	mv	a0,s1
    80002d0a:	2c2030ef          	jal	80005fcc <plic_complete>
        return 1;
    80002d0e:	4505                	li	a0,1
    80002d10:	64a2                	ld	s1,8(sp)
    80002d12:	bf5d                	j	80002cc8 <devintr+0x22>
        clockintr();
    80002d14:	f3dff0ef          	jal	80002c50 <clockintr>
        return 2;
    80002d18:	4509                	li	a0,2
    80002d1a:	b77d                	j	80002cc8 <devintr+0x22>

0000000080002d1c <usertrap>:
{
    80002d1c:	7139                	addi	sp,sp,-64
    80002d1e:	fc06                	sd	ra,56(sp)
    80002d20:	f822                	sd	s0,48(sp)
    80002d22:	0080                	addi	s0,sp,64
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80002d24:	100027f3          	csrr	a5,sstatus
  if((r_sstatus() & SSTATUS_SPP) != 0)
    80002d28:	1007f793          	andi	a5,a5,256
    80002d2c:	e7f9                	bnez	a5,80002dfa <usertrap+0xde>
    80002d2e:	f426                	sd	s1,40(sp)
    80002d30:	ec4e                	sd	s3,24(sp)
  asm volatile("csrw stvec, %0" : : "r" (x));
    80002d32:	00003797          	auipc	a5,0x3
    80002d36:	1ce78793          	addi	a5,a5,462 # 80005f00 <kernelvec>
    80002d3a:	10579073          	csrw	stvec,a5
  struct proc *p = myproc();
    80002d3e:	9e8ff0ef          	jal	80001f26 <myproc>
    80002d42:	84aa                	mv	s1,a0
  p->trapframe->epc = r_sepc();
    80002d44:	6d3c                	ld	a5,88(a0)
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80002d46:	14102773          	csrr	a4,sepc
    80002d4a:	ef98                	sd	a4,24(a5)
  asm volatile("csrr %0, scause" : "=r" (x) );
    80002d4c:	14202773          	csrr	a4,scause
  if(r_scause() == 8){
    80002d50:	47a1                	li	a5,8
    80002d52:	0af70f63          	beq	a4,a5,80002e10 <usertrap+0xf4>
  } else if((which_dev = devintr()) != 0){
    80002d56:	f51ff0ef          	jal	80002ca6 <devintr>
    80002d5a:	89aa                	mv	s3,a0
    80002d5c:	1a051363          	bnez	a0,80002f02 <usertrap+0x1e6>
    80002d60:	14202773          	csrr	a4,scause
  } else if((r_scause()== 12 || r_scause() == 15 || r_scause() == 13)) {
    80002d64:	47b1                	li	a5,12
    80002d66:	00f70c63          	beq	a4,a5,80002d7e <usertrap+0x62>
    80002d6a:	14202773          	csrr	a4,scause
    80002d6e:	47bd                	li	a5,15
    80002d70:	00f70763          	beq	a4,a5,80002d7e <usertrap+0x62>
    80002d74:	14202773          	csrr	a4,scause
    80002d78:	47b5                	li	a5,13
    80002d7a:	14f71d63          	bne	a4,a5,80002ed4 <usertrap+0x1b8>
    80002d7e:	f04a                	sd	s2,32(sp)
    80002d80:	e852                	sd	s4,16(sp)
    80002d82:	e456                	sd	s5,8(sp)
  asm volatile("csrr %0, stval" : "=r" (x) );
    80002d84:	14302773          	csrr	a4,stval
    uint64 va = PGROUNDDOWN(r_stval());
    80002d88:	77fd                	lui	a5,0xfffff
    80002d8a:	00f77933          	and	s2,a4,a5
    80002d8e:	8a4a                	mv	s4,s2
    struct proc *p = myproc();
    80002d90:	996ff0ef          	jal	80001f26 <myproc>
    80002d94:	8aaa                	mv	s5,a0
    pte_t *pte = walk(p->pagetable,va,0);
    80002d96:	4601                	li	a2,0
    80002d98:	85ca                	mv	a1,s2
    80002d9a:	6928                	ld	a0,80(a0)
    80002d9c:	9f0fe0ef          	jal	80000f8c <walk>
  asm volatile("csrr %0, scause" : "=r" (x) );
    80002da0:	14202773          	csrr	a4,scause
    if (r_scause() == 12) { access_type = "exec"; }
    80002da4:	47b1                	li	a5,12
    80002da6:	00005697          	auipc	a3,0x5
    80002daa:	56a68693          	addi	a3,a3,1386 # 80008310 <etext+0x310>
    80002dae:	8936                	mv	s2,a3
    80002db0:	00f70c63          	beq	a4,a5,80002dc8 <usertrap+0xac>
    80002db4:	14202773          	csrr	a4,scause
    else if (r_scause() == 13) { access_type = "read"; }
    80002db8:	47b5                	li	a5,13
    else { access_type = "write"; }
    80002dba:	00005697          	auipc	a3,0x5
    80002dbe:	60e68693          	addi	a3,a3,1550 # 800083c8 <etext+0x3c8>
    80002dc2:	8936                	mv	s2,a3
    else if (r_scause() == 13) { access_type = "read"; }
    80002dc4:	08f70a63          	beq	a4,a5,80002e58 <usertrap+0x13c>
    80002dc8:	142027f3          	csrr	a5,scause
    if(r_scause() == 15 && pte != 0 && (*pte & PTE_V) && !(*pte & PTE_W)){
    80002dcc:	c909                	beqz	a0,80002dde <usertrap+0xc2>
    80002dce:	17c5                	addi	a5,a5,-15 # ffffffffffffeff1 <end+0xffffffff7dd98b19>
    80002dd0:	e799                	bnez	a5,80002dde <usertrap+0xc2>
    80002dd2:	611c                	ld	a5,0(a0)
    80002dd4:	0057f693          	andi	a3,a5,5
    80002dd8:	4705                	li	a4,1
    80002dda:	08e68563          	beq	a3,a4,80002e64 <usertrap+0x148>
    else if(handle_pgfault(p->pagetable, va,access_type) < 0) {
    80002dde:	864a                	mv	a2,s2
    80002de0:	85d2                	mv	a1,s4
    80002de2:	050ab503          	ld	a0,80(s5)
    80002de6:	cd2fe0ef          	jal	800012b8 <handle_pgfault>
    80002dea:	0c054363          	bltz	a0,80002eb0 <usertrap+0x194>
  asm volatile("sfence.vma zero, zero");
    80002dee:	12000073          	sfence.vma
}
    80002df2:	7902                	ld	s2,32(sp)
    80002df4:	6a42                	ld	s4,16(sp)
    80002df6:	6aa2                	ld	s5,8(sp)
    80002df8:	a81d                	j	80002e2e <usertrap+0x112>
    80002dfa:	f426                	sd	s1,40(sp)
    80002dfc:	f04a                	sd	s2,32(sp)
    80002dfe:	ec4e                	sd	s3,24(sp)
    80002e00:	e852                	sd	s4,16(sp)
    80002e02:	e456                	sd	s5,8(sp)
    panic("usertrap: not from user mode");
    80002e04:	00005517          	auipc	a0,0x5
    80002e08:	70450513          	addi	a0,a0,1796 # 80008508 <etext+0x508>
    80002e0c:	a19fd0ef          	jal	80000824 <panic>
    if(killed(p))
    80002e10:	ab9ff0ef          	jal	800028c8 <killed>
    80002e14:	ed15                	bnez	a0,80002e50 <usertrap+0x134>
    p->trapframe->epc += 4;
    80002e16:	6cb8                	ld	a4,88(s1)
    80002e18:	6f1c                	ld	a5,24(a4)
    80002e1a:	0791                	addi	a5,a5,4
    80002e1c:	ef1c                	sd	a5,24(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80002e1e:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80002e22:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80002e26:	10079073          	csrw	sstatus,a5
    syscall();
    80002e2a:	2e2000ef          	jal	8000310c <syscall>
  if(killed(p))
    80002e2e:	8526                	mv	a0,s1
    80002e30:	a99ff0ef          	jal	800028c8 <killed>
    80002e34:	ed61                	bnez	a0,80002f0c <usertrap+0x1f0>
  prepare_return();
    80002e36:	da1ff0ef          	jal	80002bd6 <prepare_return>
  uint64 satp = MAKE_SATP(p->pagetable);
    80002e3a:	68a8                	ld	a0,80(s1)
    80002e3c:	8131                	srli	a0,a0,0xc
    80002e3e:	57fd                	li	a5,-1
    80002e40:	17fe                	slli	a5,a5,0x3f
    80002e42:	8d5d                	or	a0,a0,a5
}
    80002e44:	74a2                	ld	s1,40(sp)
    80002e46:	69e2                	ld	s3,24(sp)
    80002e48:	70e2                	ld	ra,56(sp)
    80002e4a:	7442                	ld	s0,48(sp)
    80002e4c:	6121                	addi	sp,sp,64
    80002e4e:	8082                	ret
      kexit(-1);
    80002e50:	557d                	li	a0,-1
    80002e52:	8ffff0ef          	jal	80002750 <kexit>
    80002e56:	b7c1                	j	80002e16 <usertrap+0xfa>
    else if (r_scause() == 13) { access_type = "read"; }
    80002e58:	00006797          	auipc	a5,0x6
    80002e5c:	94878793          	addi	a5,a5,-1720 # 800087a0 <etext+0x7a0>
    80002e60:	893e                	mv	s2,a5
    80002e62:	b79d                	j	80002dc8 <usertrap+0xac>
     *pte |= PTE_W;
    80002e64:	0047e793          	ori	a5,a5,4
    80002e68:	e11c                	sd	a5,0(a0)
      for(int i = 0; i < p->num_resident; i++) {
    80002e6a:	000897b7          	lui	a5,0x89
    80002e6e:	97d6                	add	a5,a5,s5
    80002e70:	1b07a603          	lw	a2,432(a5) # 891b0 <_entry-0x7ff76e50>
    80002e74:	0ac05a63          	blez	a2,80002f28 <usertrap+0x20c>
    80002e78:	270a8713          	addi	a4,s5,624
    80002e7c:	87ce                	mv	a5,s3
        if(p->resident_pages[i].va == PGROUNDDOWN(va)) {
    80002e7e:	6314                	ld	a3,0(a4)
    80002e80:	01468e63          	beq	a3,s4,80002e9c <usertrap+0x180>
      for(int i = 0; i < p->num_resident; i++) {
    80002e84:	2785                	addiw	a5,a5,1
    80002e86:	0741                	addi	a4,a4,16
    80002e88:	fec79be3          	bne	a5,a2,80002e7e <usertrap+0x162>
  if(killed(p))
    80002e8c:	8526                	mv	a0,s1
    80002e8e:	a3bff0ef          	jal	800028c8 <killed>
    80002e92:	e559                	bnez	a0,80002f20 <usertrap+0x204>
    80002e94:	7902                	ld	s2,32(sp)
    80002e96:	6a42                	ld	s4,16(sp)
    80002e98:	6aa2                	ld	s5,8(sp)
    80002e9a:	bf71                	j	80002e36 <usertrap+0x11a>
          p->resident_pages[i].dirty = 1;
    80002e9c:	0792                	slli	a5,a5,0x4
    80002e9e:	27078793          	addi	a5,a5,624
    80002ea2:	97d6                	add	a5,a5,s5
    80002ea4:	4705                	li	a4,1
    80002ea6:	c7d8                	sw	a4,12(a5)
          break;
    80002ea8:	7902                	ld	s2,32(sp)
    80002eaa:	6a42                	ld	s4,16(sp)
    80002eac:	6aa2                	ld	s5,8(sp)
    80002eae:	b741                	j	80002e2e <usertrap+0x112>
  asm volatile("csrr %0, stval" : "=r" (x) );
    80002eb0:	14302673          	csrr	a2,stval
      printf("[pid %d] KILL invalid-access va=0x%lx access=%s\n", p->pid, r_stval(), access_type);
    80002eb4:	86ca                	mv	a3,s2
    80002eb6:	030aa583          	lw	a1,48(s5)
    80002eba:	00005517          	auipc	a0,0x5
    80002ebe:	66e50513          	addi	a0,a0,1646 # 80008528 <etext+0x528>
    80002ec2:	e38fd0ef          	jal	800004fa <printf>
      setkilled(p);
    80002ec6:	8556                	mv	a0,s5
    80002ec8:	9ddff0ef          	jal	800028a4 <setkilled>
    80002ecc:	7902                	ld	s2,32(sp)
    80002ece:	6a42                	ld	s4,16(sp)
    80002ed0:	6aa2                	ld	s5,8(sp)
    80002ed2:	bfb1                	j	80002e2e <usertrap+0x112>
  asm volatile("csrr %0, scause" : "=r" (x) );
    80002ed4:	142025f3          	csrr	a1,scause
      printf("usertrap(): unexpected scause 0x%lx pid=%d\n", r_scause(), p->pid);
    80002ed8:	5890                	lw	a2,48(s1)
    80002eda:	00005517          	auipc	a0,0x5
    80002ede:	68650513          	addi	a0,a0,1670 # 80008560 <etext+0x560>
    80002ee2:	e18fd0ef          	jal	800004fa <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80002ee6:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80002eea:	14302673          	csrr	a2,stval
      printf("            sepc=0x%lx stval=0x%lx\n", r_sepc(), r_stval());
    80002eee:	00005517          	auipc	a0,0x5
    80002ef2:	6a250513          	addi	a0,a0,1698 # 80008590 <etext+0x590>
    80002ef6:	e04fd0ef          	jal	800004fa <printf>
      setkilled(p);
    80002efa:	8526                	mv	a0,s1
    80002efc:	9a9ff0ef          	jal	800028a4 <setkilled>
    80002f00:	b73d                	j	80002e2e <usertrap+0x112>
  if(killed(p))
    80002f02:	8526                	mv	a0,s1
    80002f04:	9c5ff0ef          	jal	800028c8 <killed>
    80002f08:	c511                	beqz	a0,80002f14 <usertrap+0x1f8>
    80002f0a:	a011                	j	80002f0e <usertrap+0x1f2>
    80002f0c:	4981                	li	s3,0
      kexit(-1);
    80002f0e:	557d                	li	a0,-1
    80002f10:	841ff0ef          	jal	80002750 <kexit>
  if(which_dev == 2)
    80002f14:	4789                	li	a5,2
    80002f16:	f2f990e3          	bne	s3,a5,80002e36 <usertrap+0x11a>
      yield();
    80002f1a:	eeaff0ef          	jal	80002604 <yield>
    80002f1e:	bf21                	j	80002e36 <usertrap+0x11a>
    80002f20:	7902                	ld	s2,32(sp)
    80002f22:	6a42                	ld	s4,16(sp)
    80002f24:	6aa2                	ld	s5,8(sp)
    80002f26:	b7e5                	j	80002f0e <usertrap+0x1f2>
    80002f28:	7902                	ld	s2,32(sp)
    80002f2a:	6a42                	ld	s4,16(sp)
    80002f2c:	6aa2                	ld	s5,8(sp)
    80002f2e:	b701                	j	80002e2e <usertrap+0x112>

0000000080002f30 <kerneltrap>:
{
    80002f30:	7179                	addi	sp,sp,-48
    80002f32:	f406                	sd	ra,40(sp)
    80002f34:	f022                	sd	s0,32(sp)
    80002f36:	ec26                	sd	s1,24(sp)
    80002f38:	e84a                	sd	s2,16(sp)
    80002f3a:	e44e                	sd	s3,8(sp)
    80002f3c:	1800                	addi	s0,sp,48
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80002f3e:	14102973          	csrr	s2,sepc
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80002f42:	100024f3          	csrr	s1,sstatus
  asm volatile("csrr %0, scause" : "=r" (x) );
    80002f46:	142027f3          	csrr	a5,scause
    80002f4a:	89be                	mv	s3,a5
    if((sstatus & SSTATUS_SPP) == 0)
    80002f4c:	1004f793          	andi	a5,s1,256
    80002f50:	c795                	beqz	a5,80002f7c <kerneltrap+0x4c>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80002f52:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80002f56:	8b89                	andi	a5,a5,2
    if(intr_get() != 0)
    80002f58:	eb85                	bnez	a5,80002f88 <kerneltrap+0x58>
    if((which_dev = devintr()) == 0){
    80002f5a:	d4dff0ef          	jal	80002ca6 <devintr>
    80002f5e:	c91d                	beqz	a0,80002f94 <kerneltrap+0x64>
    if(which_dev == 2 && myproc() != 0)
    80002f60:	4789                	li	a5,2
    80002f62:	04f50a63          	beq	a0,a5,80002fb6 <kerneltrap+0x86>
  asm volatile("csrw sepc, %0" : : "r" (x));
    80002f66:	14191073          	csrw	sepc,s2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80002f6a:	10049073          	csrw	sstatus,s1
}
    80002f6e:	70a2                	ld	ra,40(sp)
    80002f70:	7402                	ld	s0,32(sp)
    80002f72:	64e2                	ld	s1,24(sp)
    80002f74:	6942                	ld	s2,16(sp)
    80002f76:	69a2                	ld	s3,8(sp)
    80002f78:	6145                	addi	sp,sp,48
    80002f7a:	8082                	ret
        panic("kerneltrap: not from supervisor mode");
    80002f7c:	00005517          	auipc	a0,0x5
    80002f80:	63c50513          	addi	a0,a0,1596 # 800085b8 <etext+0x5b8>
    80002f84:	8a1fd0ef          	jal	80000824 <panic>
        panic("kerneltrap: interrupts enabled");
    80002f88:	00005517          	auipc	a0,0x5
    80002f8c:	65850513          	addi	a0,a0,1624 # 800085e0 <etext+0x5e0>
    80002f90:	895fd0ef          	jal	80000824 <panic>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80002f94:	14102673          	csrr	a2,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80002f98:	143026f3          	csrr	a3,stval
        printf("scause=0x%lx sepc=0x%lx stval=0x%lx\n", scause, r_sepc(), r_stval());
    80002f9c:	85ce                	mv	a1,s3
    80002f9e:	00005517          	auipc	a0,0x5
    80002fa2:	66250513          	addi	a0,a0,1634 # 80008600 <etext+0x600>
    80002fa6:	d54fd0ef          	jal	800004fa <printf>
        panic("kerneltrap");
    80002faa:	00005517          	auipc	a0,0x5
    80002fae:	67e50513          	addi	a0,a0,1662 # 80008628 <etext+0x628>
    80002fb2:	873fd0ef          	jal	80000824 <panic>
    if(which_dev == 2 && myproc() != 0)
    80002fb6:	f71fe0ef          	jal	80001f26 <myproc>
    80002fba:	d555                	beqz	a0,80002f66 <kerneltrap+0x36>
        yield();
    80002fbc:	e48ff0ef          	jal	80002604 <yield>
    80002fc0:	b75d                	j	80002f66 <kerneltrap+0x36>

0000000080002fc2 <argraw>:
  return strlen(buf);
}

static uint64
argraw(int n)
{
    80002fc2:	1101                	addi	sp,sp,-32
    80002fc4:	ec06                	sd	ra,24(sp)
    80002fc6:	e822                	sd	s0,16(sp)
    80002fc8:	e426                	sd	s1,8(sp)
    80002fca:	1000                	addi	s0,sp,32
    80002fcc:	84aa                	mv	s1,a0
  struct proc *p = myproc();
    80002fce:	f59fe0ef          	jal	80001f26 <myproc>
  switch (n) {
    80002fd2:	4795                	li	a5,5
    80002fd4:	0497e163          	bltu	a5,s1,80003016 <argraw+0x54>
    80002fd8:	048a                	slli	s1,s1,0x2
    80002fda:	00006717          	auipc	a4,0x6
    80002fde:	abe70713          	addi	a4,a4,-1346 # 80008a98 <states.0+0x30>
    80002fe2:	94ba                	add	s1,s1,a4
    80002fe4:	409c                	lw	a5,0(s1)
    80002fe6:	97ba                	add	a5,a5,a4
    80002fe8:	8782                	jr	a5
  case 0:
    return p->trapframe->a0;
    80002fea:	6d3c                	ld	a5,88(a0)
    80002fec:	7ba8                	ld	a0,112(a5)
  case 5:
    return p->trapframe->a5;
  }
  panic("argraw");
  return -1;
}
    80002fee:	60e2                	ld	ra,24(sp)
    80002ff0:	6442                	ld	s0,16(sp)
    80002ff2:	64a2                	ld	s1,8(sp)
    80002ff4:	6105                	addi	sp,sp,32
    80002ff6:	8082                	ret
    return p->trapframe->a1;
    80002ff8:	6d3c                	ld	a5,88(a0)
    80002ffa:	7fa8                	ld	a0,120(a5)
    80002ffc:	bfcd                	j	80002fee <argraw+0x2c>
    return p->trapframe->a2;
    80002ffe:	6d3c                	ld	a5,88(a0)
    80003000:	63c8                	ld	a0,128(a5)
    80003002:	b7f5                	j	80002fee <argraw+0x2c>
    return p->trapframe->a3;
    80003004:	6d3c                	ld	a5,88(a0)
    80003006:	67c8                	ld	a0,136(a5)
    80003008:	b7dd                	j	80002fee <argraw+0x2c>
    return p->trapframe->a4;
    8000300a:	6d3c                	ld	a5,88(a0)
    8000300c:	6bc8                	ld	a0,144(a5)
    8000300e:	b7c5                	j	80002fee <argraw+0x2c>
    return p->trapframe->a5;
    80003010:	6d3c                	ld	a5,88(a0)
    80003012:	6fc8                	ld	a0,152(a5)
    80003014:	bfe9                	j	80002fee <argraw+0x2c>
  panic("argraw");
    80003016:	00005517          	auipc	a0,0x5
    8000301a:	62250513          	addi	a0,a0,1570 # 80008638 <etext+0x638>
    8000301e:	807fd0ef          	jal	80000824 <panic>

0000000080003022 <fetchaddr>:
{
    80003022:	1101                	addi	sp,sp,-32
    80003024:	ec06                	sd	ra,24(sp)
    80003026:	e822                	sd	s0,16(sp)
    80003028:	e426                	sd	s1,8(sp)
    8000302a:	e04a                	sd	s2,0(sp)
    8000302c:	1000                	addi	s0,sp,32
    8000302e:	84aa                	mv	s1,a0
    80003030:	892e                	mv	s2,a1
  struct proc *p = myproc();
    80003032:	ef5fe0ef          	jal	80001f26 <myproc>
  if(addr >= p->sz || addr+sizeof(uint64) > p->sz) // both tests needed, in case of overflow
    80003036:	653c                	ld	a5,72(a0)
    80003038:	02f4f663          	bgeu	s1,a5,80003064 <fetchaddr+0x42>
    8000303c:	00848713          	addi	a4,s1,8
    80003040:	02e7e463          	bltu	a5,a4,80003068 <fetchaddr+0x46>
  if(copyin(p->pagetable, (char *)ip, addr, sizeof(*ip)) != 0)
    80003044:	46a1                	li	a3,8
    80003046:	8626                	mv	a2,s1
    80003048:	85ca                	mv	a1,s2
    8000304a:	6928                	ld	a0,80(a0)
    8000304c:	b89fe0ef          	jal	80001bd4 <copyin>
    80003050:	00a03533          	snez	a0,a0
    80003054:	40a0053b          	negw	a0,a0
}
    80003058:	60e2                	ld	ra,24(sp)
    8000305a:	6442                	ld	s0,16(sp)
    8000305c:	64a2                	ld	s1,8(sp)
    8000305e:	6902                	ld	s2,0(sp)
    80003060:	6105                	addi	sp,sp,32
    80003062:	8082                	ret
    return -1;
    80003064:	557d                	li	a0,-1
    80003066:	bfcd                	j	80003058 <fetchaddr+0x36>
    80003068:	557d                	li	a0,-1
    8000306a:	b7fd                	j	80003058 <fetchaddr+0x36>

000000008000306c <fetchstr>:
{
    8000306c:	7179                	addi	sp,sp,-48
    8000306e:	f406                	sd	ra,40(sp)
    80003070:	f022                	sd	s0,32(sp)
    80003072:	ec26                	sd	s1,24(sp)
    80003074:	e84a                	sd	s2,16(sp)
    80003076:	e44e                	sd	s3,8(sp)
    80003078:	1800                	addi	s0,sp,48
    8000307a:	89aa                	mv	s3,a0
    8000307c:	84ae                	mv	s1,a1
    8000307e:	8932                	mv	s2,a2
  struct proc *p = myproc();
    80003080:	ea7fe0ef          	jal	80001f26 <myproc>
  if(copyinstr(p->pagetable, buf, addr, max) < 0)
    80003084:	86ca                	mv	a3,s2
    80003086:	864e                	mv	a2,s3
    80003088:	85a6                	mv	a1,s1
    8000308a:	6928                	ld	a0,80(a0)
    8000308c:	c1ffe0ef          	jal	80001caa <copyinstr>
    80003090:	00054c63          	bltz	a0,800030a8 <fetchstr+0x3c>
  return strlen(buf);
    80003094:	8526                	mv	a0,s1
    80003096:	dedfd0ef          	jal	80000e82 <strlen>
}
    8000309a:	70a2                	ld	ra,40(sp)
    8000309c:	7402                	ld	s0,32(sp)
    8000309e:	64e2                	ld	s1,24(sp)
    800030a0:	6942                	ld	s2,16(sp)
    800030a2:	69a2                	ld	s3,8(sp)
    800030a4:	6145                	addi	sp,sp,48
    800030a6:	8082                	ret
    return -1;
    800030a8:	557d                	li	a0,-1
    800030aa:	bfc5                	j	8000309a <fetchstr+0x2e>

00000000800030ac <argint>:

// Fetch the nth 32-bit system call argument.
void
argint(int n, int *ip)
{
    800030ac:	1101                	addi	sp,sp,-32
    800030ae:	ec06                	sd	ra,24(sp)
    800030b0:	e822                	sd	s0,16(sp)
    800030b2:	e426                	sd	s1,8(sp)
    800030b4:	1000                	addi	s0,sp,32
    800030b6:	84ae                	mv	s1,a1
  *ip = argraw(n);
    800030b8:	f0bff0ef          	jal	80002fc2 <argraw>
    800030bc:	c088                	sw	a0,0(s1)
}
    800030be:	60e2                	ld	ra,24(sp)
    800030c0:	6442                	ld	s0,16(sp)
    800030c2:	64a2                	ld	s1,8(sp)
    800030c4:	6105                	addi	sp,sp,32
    800030c6:	8082                	ret

00000000800030c8 <argaddr>:
// Retrieve an argument as a pointer.
// Doesn't check for legality, since
// copyin/copyout will do that.
void
argaddr(int n, uint64 *ip)
{
    800030c8:	1101                	addi	sp,sp,-32
    800030ca:	ec06                	sd	ra,24(sp)
    800030cc:	e822                	sd	s0,16(sp)
    800030ce:	e426                	sd	s1,8(sp)
    800030d0:	1000                	addi	s0,sp,32
    800030d2:	84ae                	mv	s1,a1
  *ip = argraw(n);
    800030d4:	eefff0ef          	jal	80002fc2 <argraw>
    800030d8:	e088                	sd	a0,0(s1)
}
    800030da:	60e2                	ld	ra,24(sp)
    800030dc:	6442                	ld	s0,16(sp)
    800030de:	64a2                	ld	s1,8(sp)
    800030e0:	6105                	addi	sp,sp,32
    800030e2:	8082                	ret

00000000800030e4 <argstr>:
// Fetch the nth word-sized system call argument as a null-terminated string.
// Copies into buf, at most max.
// Returns string length if OK (including nul), -1 if error.
int
argstr(int n, char *buf, int max)
{
    800030e4:	1101                	addi	sp,sp,-32
    800030e6:	ec06                	sd	ra,24(sp)
    800030e8:	e822                	sd	s0,16(sp)
    800030ea:	e426                	sd	s1,8(sp)
    800030ec:	e04a                	sd	s2,0(sp)
    800030ee:	1000                	addi	s0,sp,32
    800030f0:	892e                	mv	s2,a1
    800030f2:	84b2                	mv	s1,a2
  *ip = argraw(n);
    800030f4:	ecfff0ef          	jal	80002fc2 <argraw>
  uint64 addr;
  argaddr(n, &addr);
  return fetchstr(addr, buf, max);
    800030f8:	8626                	mv	a2,s1
    800030fa:	85ca                	mv	a1,s2
    800030fc:	f71ff0ef          	jal	8000306c <fetchstr>
}
    80003100:	60e2                	ld	ra,24(sp)
    80003102:	6442                	ld	s0,16(sp)
    80003104:	64a2                	ld	s1,8(sp)
    80003106:	6902                	ld	s2,0(sp)
    80003108:	6105                	addi	sp,sp,32
    8000310a:	8082                	ret

000000008000310c <syscall>:
[SYS_close]   sys_close,
};

void
syscall(void)
{
    8000310c:	1101                	addi	sp,sp,-32
    8000310e:	ec06                	sd	ra,24(sp)
    80003110:	e822                	sd	s0,16(sp)
    80003112:	e426                	sd	s1,8(sp)
    80003114:	e04a                	sd	s2,0(sp)
    80003116:	1000                	addi	s0,sp,32
  int num;
  struct proc *p = myproc();
    80003118:	e0ffe0ef          	jal	80001f26 <myproc>
    8000311c:	84aa                	mv	s1,a0

  num = p->trapframe->a7;
    8000311e:	05853903          	ld	s2,88(a0)
    80003122:	0a893783          	ld	a5,168(s2)
    80003126:	0007869b          	sext.w	a3,a5
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
    8000312a:	37fd                	addiw	a5,a5,-1
    8000312c:	4751                	li	a4,20
    8000312e:	00f76f63          	bltu	a4,a5,8000314c <syscall+0x40>
    80003132:	00369713          	slli	a4,a3,0x3
    80003136:	00006797          	auipc	a5,0x6
    8000313a:	97a78793          	addi	a5,a5,-1670 # 80008ab0 <syscalls>
    8000313e:	97ba                	add	a5,a5,a4
    80003140:	639c                	ld	a5,0(a5)
    80003142:	c789                	beqz	a5,8000314c <syscall+0x40>
    // Use num to lookup the system call function for num, call it,
    // and store its return value in p->trapframe->a0
    p->trapframe->a0 = syscalls[num]();
    80003144:	9782                	jalr	a5
    80003146:	06a93823          	sd	a0,112(s2)
    8000314a:	a829                	j	80003164 <syscall+0x58>
  } else {
    printf("%d %s: unknown sys call %d\n",
    8000314c:	15848613          	addi	a2,s1,344
    80003150:	588c                	lw	a1,48(s1)
    80003152:	00005517          	auipc	a0,0x5
    80003156:	4ee50513          	addi	a0,a0,1262 # 80008640 <etext+0x640>
    8000315a:	ba0fd0ef          	jal	800004fa <printf>
            p->pid, p->name, num);
    p->trapframe->a0 = -1;
    8000315e:	6cbc                	ld	a5,88(s1)
    80003160:	577d                	li	a4,-1
    80003162:	fbb8                	sd	a4,112(a5)
  }
}
    80003164:	60e2                	ld	ra,24(sp)
    80003166:	6442                	ld	s0,16(sp)
    80003168:	64a2                	ld	s1,8(sp)
    8000316a:	6902                	ld	s2,0(sp)
    8000316c:	6105                	addi	sp,sp,32
    8000316e:	8082                	ret

0000000080003170 <sys_exit>:
#include "proc.h"
#include "vm.h"

uint64
sys_exit(void)
{
    80003170:	1101                	addi	sp,sp,-32
    80003172:	ec06                	sd	ra,24(sp)
    80003174:	e822                	sd	s0,16(sp)
    80003176:	1000                	addi	s0,sp,32
  int n;
  argint(0, &n);
    80003178:	fec40593          	addi	a1,s0,-20
    8000317c:	4501                	li	a0,0
    8000317e:	f2fff0ef          	jal	800030ac <argint>
  kexit(n);
    80003182:	fec42503          	lw	a0,-20(s0)
    80003186:	dcaff0ef          	jal	80002750 <kexit>
  return 0;  // not reached
}
    8000318a:	4501                	li	a0,0
    8000318c:	60e2                	ld	ra,24(sp)
    8000318e:	6442                	ld	s0,16(sp)
    80003190:	6105                	addi	sp,sp,32
    80003192:	8082                	ret

0000000080003194 <sys_getpid>:

uint64
sys_getpid(void)
{
    80003194:	1141                	addi	sp,sp,-16
    80003196:	e406                	sd	ra,8(sp)
    80003198:	e022                	sd	s0,0(sp)
    8000319a:	0800                	addi	s0,sp,16
  return myproc()->pid;
    8000319c:	d8bfe0ef          	jal	80001f26 <myproc>
}
    800031a0:	5908                	lw	a0,48(a0)
    800031a2:	60a2                	ld	ra,8(sp)
    800031a4:	6402                	ld	s0,0(sp)
    800031a6:	0141                	addi	sp,sp,16
    800031a8:	8082                	ret

00000000800031aa <sys_fork>:

uint64
sys_fork(void)
{
    800031aa:	1141                	addi	sp,sp,-16
    800031ac:	e406                	sd	ra,8(sp)
    800031ae:	e022                	sd	s0,0(sp)
    800031b0:	0800                	addi	s0,sp,16
  return kfork();
    800031b2:	918ff0ef          	jal	800022ca <kfork>
}
    800031b6:	60a2                	ld	ra,8(sp)
    800031b8:	6402                	ld	s0,0(sp)
    800031ba:	0141                	addi	sp,sp,16
    800031bc:	8082                	ret

00000000800031be <sys_wait>:

uint64
sys_wait(void)
{
    800031be:	1101                	addi	sp,sp,-32
    800031c0:	ec06                	sd	ra,24(sp)
    800031c2:	e822                	sd	s0,16(sp)
    800031c4:	1000                	addi	s0,sp,32
  uint64 p;
  argaddr(0, &p);
    800031c6:	fe840593          	addi	a1,s0,-24
    800031ca:	4501                	li	a0,0
    800031cc:	efdff0ef          	jal	800030c8 <argaddr>
  return kwait(p);
    800031d0:	fe843503          	ld	a0,-24(s0)
    800031d4:	f1eff0ef          	jal	800028f2 <kwait>
}
    800031d8:	60e2                	ld	ra,24(sp)
    800031da:	6442                	ld	s0,16(sp)
    800031dc:	6105                	addi	sp,sp,32
    800031de:	8082                	ret

00000000800031e0 <sys_sbrk>:

uint64
sys_sbrk(void)
{
    800031e0:	715d                	addi	sp,sp,-80
    800031e2:	e486                	sd	ra,72(sp)
    800031e4:	e0a2                	sd	s0,64(sp)
    800031e6:	fc26                	sd	s1,56(sp)
    800031e8:	0880                	addi	s0,sp,80
  uint64 addr;
  int n;

  argint(0, &n);
    800031ea:	fbc40593          	addi	a1,s0,-68
    800031ee:	4501                	li	a0,0
    800031f0:	ebdff0ef          	jal	800030ac <argint>
  addr = myproc()->sz;
    800031f4:	d33fe0ef          	jal	80001f26 <myproc>
    800031f8:	6524                	ld	s1,72(a0)

  if (n > 0) {
    800031fa:	fbc42783          	lw	a5,-68(s0)
    800031fe:	02f05363          	blez	a5,80003224 <sys_sbrk+0x44>
    if(addr + n < addr || addr + n > TRAPFRAME) // Check for overflow or exceeding max address
    80003202:	97a6                	add	a5,a5,s1
    80003204:	02000737          	lui	a4,0x2000
    80003208:	177d                	addi	a4,a4,-1 # 1ffffff <_entry-0x7e000001>
    8000320a:	0736                	slli	a4,a4,0xd
    8000320c:	06f76663          	bltu	a4,a5,80003278 <sys_sbrk+0x98>
    80003210:	0697e463          	bltu	a5,s1,80003278 <sys_sbrk+0x98>
      return -1;
    myproc()->sz += n;
    80003214:	d13fe0ef          	jal	80001f26 <myproc>
    80003218:	fbc42703          	lw	a4,-68(s0)
    8000321c:	653c                	ld	a5,72(a0)
    8000321e:	97ba                	add	a5,a5,a4
    80003220:	e53c                	sd	a5,72(a0)
    80003222:	a019                	j	80003228 <sys_sbrk+0x48>
  } else if (n < 0) {
    80003224:	0007c863          	bltz	a5,80003234 <sys_sbrk+0x54>
    return -1;
  }
  */

  return addr;
}
    80003228:	8526                	mv	a0,s1
    8000322a:	60a6                	ld	ra,72(sp)
    8000322c:	6406                	ld	s0,64(sp)
    8000322e:	74e2                	ld	s1,56(sp)
    80003230:	6161                	addi	sp,sp,80
    80003232:	8082                	ret
    80003234:	f84a                	sd	s2,48(sp)
    80003236:	f44e                	sd	s3,40(sp)
    80003238:	f052                	sd	s4,32(sp)
    8000323a:	ec56                	sd	s5,24(sp)
    myproc()->sz = uvmdealloc(myproc()->pagetable, myproc()->sz, myproc()->sz + n);
    8000323c:	cebfe0ef          	jal	80001f26 <myproc>
    80003240:	05053903          	ld	s2,80(a0)
    80003244:	ce3fe0ef          	jal	80001f26 <myproc>
    80003248:	04853983          	ld	s3,72(a0)
    8000324c:	cdbfe0ef          	jal	80001f26 <myproc>
    80003250:	fbc42783          	lw	a5,-68(s0)
    80003254:	6538                	ld	a4,72(a0)
    80003256:	00e78a33          	add	s4,a5,a4
    8000325a:	ccdfe0ef          	jal	80001f26 <myproc>
    8000325e:	8aaa                	mv	s5,a0
    80003260:	8652                	mv	a2,s4
    80003262:	85ce                	mv	a1,s3
    80003264:	854a                	mv	a0,s2
    80003266:	de6fe0ef          	jal	8000184c <uvmdealloc>
    8000326a:	04aab423          	sd	a0,72(s5)
    8000326e:	7942                	ld	s2,48(sp)
    80003270:	79a2                	ld	s3,40(sp)
    80003272:	7a02                	ld	s4,32(sp)
    80003274:	6ae2                	ld	s5,24(sp)
    80003276:	bf4d                	j	80003228 <sys_sbrk+0x48>
      return -1;
    80003278:	54fd                	li	s1,-1
    8000327a:	b77d                	j	80003228 <sys_sbrk+0x48>

000000008000327c <sys_pause>:

uint64
sys_pause(void)
{
    8000327c:	7139                	addi	sp,sp,-64
    8000327e:	fc06                	sd	ra,56(sp)
    80003280:	f822                	sd	s0,48(sp)
    80003282:	0080                	addi	s0,sp,64
  int n;
  uint ticks0;

  argint(0, &n);
    80003284:	fcc40593          	addi	a1,s0,-52
    80003288:	4501                	li	a0,0
    8000328a:	e23ff0ef          	jal	800030ac <argint>
  if(n < 0)
    8000328e:	fcc42783          	lw	a5,-52(s0)
    80003292:	0607c863          	bltz	a5,80003302 <sys_pause+0x86>
    n = 0;
  acquire(&tickslock);
    80003296:	02258517          	auipc	a0,0x2258
    8000329a:	e6250513          	addi	a0,a0,-414 # 8225b0f8 <tickslock>
    8000329e:	98bfd0ef          	jal	80000c28 <acquire>
  ticks0 = ticks;
  while(ticks - ticks0 < n){
    800032a2:	fcc42783          	lw	a5,-52(s0)
    800032a6:	c3b9                	beqz	a5,800032ec <sys_pause+0x70>
    800032a8:	f426                	sd	s1,40(sp)
    800032aa:	f04a                	sd	s2,32(sp)
    800032ac:	ec4e                	sd	s3,24(sp)
  ticks0 = ticks;
    800032ae:	00008997          	auipc	s3,0x8
    800032b2:	51a9a983          	lw	s3,1306(s3) # 8000b7c8 <ticks>
    if(killed(myproc())){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
    800032b6:	02258917          	auipc	s2,0x2258
    800032ba:	e4290913          	addi	s2,s2,-446 # 8225b0f8 <tickslock>
    800032be:	00008497          	auipc	s1,0x8
    800032c2:	50a48493          	addi	s1,s1,1290 # 8000b7c8 <ticks>
    if(killed(myproc())){
    800032c6:	c61fe0ef          	jal	80001f26 <myproc>
    800032ca:	dfeff0ef          	jal	800028c8 <killed>
    800032ce:	ed0d                	bnez	a0,80003308 <sys_pause+0x8c>
    sleep(&ticks, &tickslock);
    800032d0:	85ca                	mv	a1,s2
    800032d2:	8526                	mv	a0,s1
    800032d4:	b5cff0ef          	jal	80002630 <sleep>
  while(ticks - ticks0 < n){
    800032d8:	409c                	lw	a5,0(s1)
    800032da:	413787bb          	subw	a5,a5,s3
    800032de:	fcc42703          	lw	a4,-52(s0)
    800032e2:	fee7e2e3          	bltu	a5,a4,800032c6 <sys_pause+0x4a>
    800032e6:	74a2                	ld	s1,40(sp)
    800032e8:	7902                	ld	s2,32(sp)
    800032ea:	69e2                	ld	s3,24(sp)
  }
  release(&tickslock);
    800032ec:	02258517          	auipc	a0,0x2258
    800032f0:	e0c50513          	addi	a0,a0,-500 # 8225b0f8 <tickslock>
    800032f4:	9c9fd0ef          	jal	80000cbc <release>
  return 0;
    800032f8:	4501                	li	a0,0
}
    800032fa:	70e2                	ld	ra,56(sp)
    800032fc:	7442                	ld	s0,48(sp)
    800032fe:	6121                	addi	sp,sp,64
    80003300:	8082                	ret
    n = 0;
    80003302:	fc042623          	sw	zero,-52(s0)
    80003306:	bf41                	j	80003296 <sys_pause+0x1a>
      release(&tickslock);
    80003308:	02258517          	auipc	a0,0x2258
    8000330c:	df050513          	addi	a0,a0,-528 # 8225b0f8 <tickslock>
    80003310:	9adfd0ef          	jal	80000cbc <release>
      return -1;
    80003314:	557d                	li	a0,-1
    80003316:	74a2                	ld	s1,40(sp)
    80003318:	7902                	ld	s2,32(sp)
    8000331a:	69e2                	ld	s3,24(sp)
    8000331c:	bff9                	j	800032fa <sys_pause+0x7e>

000000008000331e <sys_kill>:

uint64
sys_kill(void)
{
    8000331e:	1101                	addi	sp,sp,-32
    80003320:	ec06                	sd	ra,24(sp)
    80003322:	e822                	sd	s0,16(sp)
    80003324:	1000                	addi	s0,sp,32
  int pid;

  argint(0, &pid);
    80003326:	fec40593          	addi	a1,s0,-20
    8000332a:	4501                	li	a0,0
    8000332c:	d81ff0ef          	jal	800030ac <argint>
  return kkill(pid);
    80003330:	fec42503          	lw	a0,-20(s0)
    80003334:	d00ff0ef          	jal	80002834 <kkill>
}
    80003338:	60e2                	ld	ra,24(sp)
    8000333a:	6442                	ld	s0,16(sp)
    8000333c:	6105                	addi	sp,sp,32
    8000333e:	8082                	ret

0000000080003340 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
uint64
sys_uptime(void)
{
    80003340:	1101                	addi	sp,sp,-32
    80003342:	ec06                	sd	ra,24(sp)
    80003344:	e822                	sd	s0,16(sp)
    80003346:	e426                	sd	s1,8(sp)
    80003348:	1000                	addi	s0,sp,32
  uint xticks;

  acquire(&tickslock);
    8000334a:	02258517          	auipc	a0,0x2258
    8000334e:	dae50513          	addi	a0,a0,-594 # 8225b0f8 <tickslock>
    80003352:	8d7fd0ef          	jal	80000c28 <acquire>
  xticks = ticks;
    80003356:	00008797          	auipc	a5,0x8
    8000335a:	4727a783          	lw	a5,1138(a5) # 8000b7c8 <ticks>
    8000335e:	84be                	mv	s1,a5
  release(&tickslock);
    80003360:	02258517          	auipc	a0,0x2258
    80003364:	d9850513          	addi	a0,a0,-616 # 8225b0f8 <tickslock>
    80003368:	955fd0ef          	jal	80000cbc <release>
  return xticks;
}
    8000336c:	02049513          	slli	a0,s1,0x20
    80003370:	9101                	srli	a0,a0,0x20
    80003372:	60e2                	ld	ra,24(sp)
    80003374:	6442                	ld	s0,16(sp)
    80003376:	64a2                	ld	s1,8(sp)
    80003378:	6105                	addi	sp,sp,32
    8000337a:	8082                	ret

000000008000337c <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
    8000337c:	7179                	addi	sp,sp,-48
    8000337e:	f406                	sd	ra,40(sp)
    80003380:	f022                	sd	s0,32(sp)
    80003382:	ec26                	sd	s1,24(sp)
    80003384:	e84a                	sd	s2,16(sp)
    80003386:	e44e                	sd	s3,8(sp)
    80003388:	e052                	sd	s4,0(sp)
    8000338a:	1800                	addi	s0,sp,48
  struct buf *b;

  initlock(&bcache.lock, "bcache");
    8000338c:	00005597          	auipc	a1,0x5
    80003390:	2d458593          	addi	a1,a1,724 # 80008660 <etext+0x660>
    80003394:	02258517          	auipc	a0,0x2258
    80003398:	d7c50513          	addi	a0,a0,-644 # 8225b110 <bcache>
    8000339c:	803fd0ef          	jal	80000b9e <initlock>

  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
    800033a0:	02260797          	auipc	a5,0x2260
    800033a4:	d7078793          	addi	a5,a5,-656 # 82263110 <bcache+0x8000>
    800033a8:	02260717          	auipc	a4,0x2260
    800033ac:	fd070713          	addi	a4,a4,-48 # 82263378 <bcache+0x8268>
    800033b0:	2ae7b823          	sd	a4,688(a5)
  bcache.head.next = &bcache.head;
    800033b4:	2ae7bc23          	sd	a4,696(a5)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    800033b8:	02258497          	auipc	s1,0x2258
    800033bc:	d7048493          	addi	s1,s1,-656 # 8225b128 <bcache+0x18>
    b->next = bcache.head.next;
    800033c0:	893e                	mv	s2,a5
    b->prev = &bcache.head;
    800033c2:	89ba                	mv	s3,a4
    initsleeplock(&b->lock, "buffer");
    800033c4:	00005a17          	auipc	s4,0x5
    800033c8:	2a4a0a13          	addi	s4,s4,676 # 80008668 <etext+0x668>
    b->next = bcache.head.next;
    800033cc:	2b893783          	ld	a5,696(s2)
    800033d0:	e8bc                	sd	a5,80(s1)
    b->prev = &bcache.head;
    800033d2:	0534b423          	sd	s3,72(s1)
    initsleeplock(&b->lock, "buffer");
    800033d6:	85d2                	mv	a1,s4
    800033d8:	01048513          	addi	a0,s1,16
    800033dc:	328010ef          	jal	80004704 <initsleeplock>
    bcache.head.next->prev = b;
    800033e0:	2b893783          	ld	a5,696(s2)
    800033e4:	e7a4                	sd	s1,72(a5)
    bcache.head.next = b;
    800033e6:	2a993c23          	sd	s1,696(s2)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    800033ea:	45848493          	addi	s1,s1,1112
    800033ee:	fd349fe3          	bne	s1,s3,800033cc <binit+0x50>
  }
}
    800033f2:	70a2                	ld	ra,40(sp)
    800033f4:	7402                	ld	s0,32(sp)
    800033f6:	64e2                	ld	s1,24(sp)
    800033f8:	6942                	ld	s2,16(sp)
    800033fa:	69a2                	ld	s3,8(sp)
    800033fc:	6a02                	ld	s4,0(sp)
    800033fe:	6145                	addi	sp,sp,48
    80003400:	8082                	ret

0000000080003402 <bread>:
}

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
    80003402:	7179                	addi	sp,sp,-48
    80003404:	f406                	sd	ra,40(sp)
    80003406:	f022                	sd	s0,32(sp)
    80003408:	ec26                	sd	s1,24(sp)
    8000340a:	e84a                	sd	s2,16(sp)
    8000340c:	e44e                	sd	s3,8(sp)
    8000340e:	1800                	addi	s0,sp,48
    80003410:	892a                	mv	s2,a0
    80003412:	89ae                	mv	s3,a1
  acquire(&bcache.lock);
    80003414:	02258517          	auipc	a0,0x2258
    80003418:	cfc50513          	addi	a0,a0,-772 # 8225b110 <bcache>
    8000341c:	80dfd0ef          	jal	80000c28 <acquire>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
    80003420:	02260497          	auipc	s1,0x2260
    80003424:	fa84b483          	ld	s1,-88(s1) # 822633c8 <bcache+0x82b8>
    80003428:	02260797          	auipc	a5,0x2260
    8000342c:	f5078793          	addi	a5,a5,-176 # 82263378 <bcache+0x8268>
    80003430:	02f48b63          	beq	s1,a5,80003466 <bread+0x64>
    80003434:	873e                	mv	a4,a5
    80003436:	a021                	j	8000343e <bread+0x3c>
    80003438:	68a4                	ld	s1,80(s1)
    8000343a:	02e48663          	beq	s1,a4,80003466 <bread+0x64>
    if(b->dev == dev && b->blockno == blockno){
    8000343e:	449c                	lw	a5,8(s1)
    80003440:	ff279ce3          	bne	a5,s2,80003438 <bread+0x36>
    80003444:	44dc                	lw	a5,12(s1)
    80003446:	ff3799e3          	bne	a5,s3,80003438 <bread+0x36>
      b->refcnt++;
    8000344a:	40bc                	lw	a5,64(s1)
    8000344c:	2785                	addiw	a5,a5,1
    8000344e:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    80003450:	02258517          	auipc	a0,0x2258
    80003454:	cc050513          	addi	a0,a0,-832 # 8225b110 <bcache>
    80003458:	865fd0ef          	jal	80000cbc <release>
      acquiresleep(&b->lock);
    8000345c:	01048513          	addi	a0,s1,16
    80003460:	2da010ef          	jal	8000473a <acquiresleep>
      return b;
    80003464:	a889                	j	800034b6 <bread+0xb4>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    80003466:	02260497          	auipc	s1,0x2260
    8000346a:	f5a4b483          	ld	s1,-166(s1) # 822633c0 <bcache+0x82b0>
    8000346e:	02260797          	auipc	a5,0x2260
    80003472:	f0a78793          	addi	a5,a5,-246 # 82263378 <bcache+0x8268>
    80003476:	00f48863          	beq	s1,a5,80003486 <bread+0x84>
    8000347a:	873e                	mv	a4,a5
    if(b->refcnt == 0) {
    8000347c:	40bc                	lw	a5,64(s1)
    8000347e:	cb91                	beqz	a5,80003492 <bread+0x90>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    80003480:	64a4                	ld	s1,72(s1)
    80003482:	fee49de3          	bne	s1,a4,8000347c <bread+0x7a>
  panic("bget: no buffers");
    80003486:	00005517          	auipc	a0,0x5
    8000348a:	1ea50513          	addi	a0,a0,490 # 80008670 <etext+0x670>
    8000348e:	b96fd0ef          	jal	80000824 <panic>
      b->dev = dev;
    80003492:	0124a423          	sw	s2,8(s1)
      b->blockno = blockno;
    80003496:	0134a623          	sw	s3,12(s1)
      b->valid = 0;
    8000349a:	0004a023          	sw	zero,0(s1)
      b->refcnt = 1;
    8000349e:	4785                	li	a5,1
    800034a0:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    800034a2:	02258517          	auipc	a0,0x2258
    800034a6:	c6e50513          	addi	a0,a0,-914 # 8225b110 <bcache>
    800034aa:	813fd0ef          	jal	80000cbc <release>
      acquiresleep(&b->lock);
    800034ae:	01048513          	addi	a0,s1,16
    800034b2:	288010ef          	jal	8000473a <acquiresleep>
  struct buf *b;

  b = bget(dev, blockno);
  if(!b->valid) {
    800034b6:	409c                	lw	a5,0(s1)
    800034b8:	cb89                	beqz	a5,800034ca <bread+0xc8>
    virtio_disk_rw(b, 0);
    b->valid = 1;
  }
  return b;
}
    800034ba:	8526                	mv	a0,s1
    800034bc:	70a2                	ld	ra,40(sp)
    800034be:	7402                	ld	s0,32(sp)
    800034c0:	64e2                	ld	s1,24(sp)
    800034c2:	6942                	ld	s2,16(sp)
    800034c4:	69a2                	ld	s3,8(sp)
    800034c6:	6145                	addi	sp,sp,48
    800034c8:	8082                	ret
    virtio_disk_rw(b, 0);
    800034ca:	4581                	li	a1,0
    800034cc:	8526                	mv	a0,s1
    800034ce:	563020ef          	jal	80006230 <virtio_disk_rw>
    b->valid = 1;
    800034d2:	4785                	li	a5,1
    800034d4:	c09c                	sw	a5,0(s1)
  return b;
    800034d6:	b7d5                	j	800034ba <bread+0xb8>

00000000800034d8 <bwrite>:

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
    800034d8:	1101                	addi	sp,sp,-32
    800034da:	ec06                	sd	ra,24(sp)
    800034dc:	e822                	sd	s0,16(sp)
    800034de:	e426                	sd	s1,8(sp)
    800034e0:	1000                	addi	s0,sp,32
    800034e2:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    800034e4:	0541                	addi	a0,a0,16
    800034e6:	2d2010ef          	jal	800047b8 <holdingsleep>
    800034ea:	c911                	beqz	a0,800034fe <bwrite+0x26>
    panic("bwrite");
  virtio_disk_rw(b, 1);
    800034ec:	4585                	li	a1,1
    800034ee:	8526                	mv	a0,s1
    800034f0:	541020ef          	jal	80006230 <virtio_disk_rw>
}
    800034f4:	60e2                	ld	ra,24(sp)
    800034f6:	6442                	ld	s0,16(sp)
    800034f8:	64a2                	ld	s1,8(sp)
    800034fa:	6105                	addi	sp,sp,32
    800034fc:	8082                	ret
    panic("bwrite");
    800034fe:	00005517          	auipc	a0,0x5
    80003502:	18a50513          	addi	a0,a0,394 # 80008688 <etext+0x688>
    80003506:	b1efd0ef          	jal	80000824 <panic>

000000008000350a <brelse>:

// Release a locked buffer.
// Move to the head of the most-recently-used list.
void
brelse(struct buf *b)
{
    8000350a:	1101                	addi	sp,sp,-32
    8000350c:	ec06                	sd	ra,24(sp)
    8000350e:	e822                	sd	s0,16(sp)
    80003510:	e426                	sd	s1,8(sp)
    80003512:	e04a                	sd	s2,0(sp)
    80003514:	1000                	addi	s0,sp,32
    80003516:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    80003518:	01050913          	addi	s2,a0,16
    8000351c:	854a                	mv	a0,s2
    8000351e:	29a010ef          	jal	800047b8 <holdingsleep>
    80003522:	c125                	beqz	a0,80003582 <brelse+0x78>
    panic("brelse");

  releasesleep(&b->lock);
    80003524:	854a                	mv	a0,s2
    80003526:	25a010ef          	jal	80004780 <releasesleep>

  acquire(&bcache.lock);
    8000352a:	02258517          	auipc	a0,0x2258
    8000352e:	be650513          	addi	a0,a0,-1050 # 8225b110 <bcache>
    80003532:	ef6fd0ef          	jal	80000c28 <acquire>
  b->refcnt--;
    80003536:	40bc                	lw	a5,64(s1)
    80003538:	37fd                	addiw	a5,a5,-1
    8000353a:	c0bc                	sw	a5,64(s1)
  if (b->refcnt == 0) {
    8000353c:	e79d                	bnez	a5,8000356a <brelse+0x60>
    // no one is waiting for it.
    b->next->prev = b->prev;
    8000353e:	68b8                	ld	a4,80(s1)
    80003540:	64bc                	ld	a5,72(s1)
    80003542:	e73c                	sd	a5,72(a4)
    b->prev->next = b->next;
    80003544:	68b8                	ld	a4,80(s1)
    80003546:	ebb8                	sd	a4,80(a5)
    b->next = bcache.head.next;
    80003548:	02260797          	auipc	a5,0x2260
    8000354c:	bc878793          	addi	a5,a5,-1080 # 82263110 <bcache+0x8000>
    80003550:	2b87b703          	ld	a4,696(a5)
    80003554:	e8b8                	sd	a4,80(s1)
    b->prev = &bcache.head;
    80003556:	02260717          	auipc	a4,0x2260
    8000355a:	e2270713          	addi	a4,a4,-478 # 82263378 <bcache+0x8268>
    8000355e:	e4b8                	sd	a4,72(s1)
    bcache.head.next->prev = b;
    80003560:	2b87b703          	ld	a4,696(a5)
    80003564:	e724                	sd	s1,72(a4)
    bcache.head.next = b;
    80003566:	2a97bc23          	sd	s1,696(a5)
  }
  
  release(&bcache.lock);
    8000356a:	02258517          	auipc	a0,0x2258
    8000356e:	ba650513          	addi	a0,a0,-1114 # 8225b110 <bcache>
    80003572:	f4afd0ef          	jal	80000cbc <release>
}
    80003576:	60e2                	ld	ra,24(sp)
    80003578:	6442                	ld	s0,16(sp)
    8000357a:	64a2                	ld	s1,8(sp)
    8000357c:	6902                	ld	s2,0(sp)
    8000357e:	6105                	addi	sp,sp,32
    80003580:	8082                	ret
    panic("brelse");
    80003582:	00005517          	auipc	a0,0x5
    80003586:	10e50513          	addi	a0,a0,270 # 80008690 <etext+0x690>
    8000358a:	a9afd0ef          	jal	80000824 <panic>

000000008000358e <bpin>:

void
bpin(struct buf *b) {
    8000358e:	1101                	addi	sp,sp,-32
    80003590:	ec06                	sd	ra,24(sp)
    80003592:	e822                	sd	s0,16(sp)
    80003594:	e426                	sd	s1,8(sp)
    80003596:	1000                	addi	s0,sp,32
    80003598:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    8000359a:	02258517          	auipc	a0,0x2258
    8000359e:	b7650513          	addi	a0,a0,-1162 # 8225b110 <bcache>
    800035a2:	e86fd0ef          	jal	80000c28 <acquire>
  b->refcnt++;
    800035a6:	40bc                	lw	a5,64(s1)
    800035a8:	2785                	addiw	a5,a5,1
    800035aa:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    800035ac:	02258517          	auipc	a0,0x2258
    800035b0:	b6450513          	addi	a0,a0,-1180 # 8225b110 <bcache>
    800035b4:	f08fd0ef          	jal	80000cbc <release>
}
    800035b8:	60e2                	ld	ra,24(sp)
    800035ba:	6442                	ld	s0,16(sp)
    800035bc:	64a2                	ld	s1,8(sp)
    800035be:	6105                	addi	sp,sp,32
    800035c0:	8082                	ret

00000000800035c2 <bunpin>:

void
bunpin(struct buf *b) {
    800035c2:	1101                	addi	sp,sp,-32
    800035c4:	ec06                	sd	ra,24(sp)
    800035c6:	e822                	sd	s0,16(sp)
    800035c8:	e426                	sd	s1,8(sp)
    800035ca:	1000                	addi	s0,sp,32
    800035cc:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    800035ce:	02258517          	auipc	a0,0x2258
    800035d2:	b4250513          	addi	a0,a0,-1214 # 8225b110 <bcache>
    800035d6:	e52fd0ef          	jal	80000c28 <acquire>
  b->refcnt--;
    800035da:	40bc                	lw	a5,64(s1)
    800035dc:	37fd                	addiw	a5,a5,-1
    800035de:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    800035e0:	02258517          	auipc	a0,0x2258
    800035e4:	b3050513          	addi	a0,a0,-1232 # 8225b110 <bcache>
    800035e8:	ed4fd0ef          	jal	80000cbc <release>
}
    800035ec:	60e2                	ld	ra,24(sp)
    800035ee:	6442                	ld	s0,16(sp)
    800035f0:	64a2                	ld	s1,8(sp)
    800035f2:	6105                	addi	sp,sp,32
    800035f4:	8082                	ret

00000000800035f6 <bfree>:
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
    800035f6:	1101                	addi	sp,sp,-32
    800035f8:	ec06                	sd	ra,24(sp)
    800035fa:	e822                	sd	s0,16(sp)
    800035fc:	e426                	sd	s1,8(sp)
    800035fe:	e04a                	sd	s2,0(sp)
    80003600:	1000                	addi	s0,sp,32
    80003602:	84ae                	mv	s1,a1
  struct buf *bp;
  int bi, m;

  bp = bread(dev, BBLOCK(b, sb));
    80003604:	00d5d79b          	srliw	a5,a1,0xd
    80003608:	02260597          	auipc	a1,0x2260
    8000360c:	1e45a583          	lw	a1,484(a1) # 822637ec <sb+0x1c>
    80003610:	9dbd                	addw	a1,a1,a5
    80003612:	df1ff0ef          	jal	80003402 <bread>
  bi = b % BPB;
  m = 1 << (bi % 8);
    80003616:	0074f713          	andi	a4,s1,7
    8000361a:	4785                	li	a5,1
    8000361c:	00e797bb          	sllw	a5,a5,a4
  bi = b % BPB;
    80003620:	14ce                	slli	s1,s1,0x33
  if((bp->data[bi/8] & m) == 0)
    80003622:	90d9                	srli	s1,s1,0x36
    80003624:	00950733          	add	a4,a0,s1
    80003628:	05874703          	lbu	a4,88(a4)
    8000362c:	00e7f6b3          	and	a3,a5,a4
    80003630:	c29d                	beqz	a3,80003656 <bfree+0x60>
    80003632:	892a                	mv	s2,a0
    panic("freeing free block");
  bp->data[bi/8] &= ~m;
    80003634:	94aa                	add	s1,s1,a0
    80003636:	fff7c793          	not	a5,a5
    8000363a:	8f7d                	and	a4,a4,a5
    8000363c:	04e48c23          	sb	a4,88(s1)
  log_write(bp);
    80003640:	000010ef          	jal	80004640 <log_write>
  brelse(bp);
    80003644:	854a                	mv	a0,s2
    80003646:	ec5ff0ef          	jal	8000350a <brelse>
}
    8000364a:	60e2                	ld	ra,24(sp)
    8000364c:	6442                	ld	s0,16(sp)
    8000364e:	64a2                	ld	s1,8(sp)
    80003650:	6902                	ld	s2,0(sp)
    80003652:	6105                	addi	sp,sp,32
    80003654:	8082                	ret
    panic("freeing free block");
    80003656:	00005517          	auipc	a0,0x5
    8000365a:	04250513          	addi	a0,a0,66 # 80008698 <etext+0x698>
    8000365e:	9c6fd0ef          	jal	80000824 <panic>

0000000080003662 <balloc>:
{
    80003662:	715d                	addi	sp,sp,-80
    80003664:	e486                	sd	ra,72(sp)
    80003666:	e0a2                	sd	s0,64(sp)
    80003668:	fc26                	sd	s1,56(sp)
    8000366a:	0880                	addi	s0,sp,80
  for(b = 0; b < sb.size; b += BPB){
    8000366c:	02260797          	auipc	a5,0x2260
    80003670:	1687a783          	lw	a5,360(a5) # 822637d4 <sb+0x4>
    80003674:	0e078263          	beqz	a5,80003758 <balloc+0xf6>
    80003678:	f84a                	sd	s2,48(sp)
    8000367a:	f44e                	sd	s3,40(sp)
    8000367c:	f052                	sd	s4,32(sp)
    8000367e:	ec56                	sd	s5,24(sp)
    80003680:	e85a                	sd	s6,16(sp)
    80003682:	e45e                	sd	s7,8(sp)
    80003684:	e062                	sd	s8,0(sp)
    80003686:	8baa                	mv	s7,a0
    80003688:	4a81                	li	s5,0
    bp = bread(dev, BBLOCK(b, sb));
    8000368a:	02260b17          	auipc	s6,0x2260
    8000368e:	146b0b13          	addi	s6,s6,326 # 822637d0 <sb>
      m = 1 << (bi % 8);
    80003692:	4985                	li	s3,1
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80003694:	6a09                	lui	s4,0x2
  for(b = 0; b < sb.size; b += BPB){
    80003696:	6c09                	lui	s8,0x2
    80003698:	a09d                	j	800036fe <balloc+0x9c>
        bp->data[bi/8] |= m;  // Mark block in use.
    8000369a:	97ca                	add	a5,a5,s2
    8000369c:	8e55                	or	a2,a2,a3
    8000369e:	04c78c23          	sb	a2,88(a5)
        log_write(bp);
    800036a2:	854a                	mv	a0,s2
    800036a4:	79d000ef          	jal	80004640 <log_write>
        brelse(bp);
    800036a8:	854a                	mv	a0,s2
    800036aa:	e61ff0ef          	jal	8000350a <brelse>
  bp = bread(dev, bno);
    800036ae:	85a6                	mv	a1,s1
    800036b0:	855e                	mv	a0,s7
    800036b2:	d51ff0ef          	jal	80003402 <bread>
    800036b6:	892a                	mv	s2,a0
  memset(bp->data, 0, BSIZE);
    800036b8:	40000613          	li	a2,1024
    800036bc:	4581                	li	a1,0
    800036be:	05850513          	addi	a0,a0,88
    800036c2:	e36fd0ef          	jal	80000cf8 <memset>
  log_write(bp);
    800036c6:	854a                	mv	a0,s2
    800036c8:	779000ef          	jal	80004640 <log_write>
  brelse(bp);
    800036cc:	854a                	mv	a0,s2
    800036ce:	e3dff0ef          	jal	8000350a <brelse>
}
    800036d2:	7942                	ld	s2,48(sp)
    800036d4:	79a2                	ld	s3,40(sp)
    800036d6:	7a02                	ld	s4,32(sp)
    800036d8:	6ae2                	ld	s5,24(sp)
    800036da:	6b42                	ld	s6,16(sp)
    800036dc:	6ba2                	ld	s7,8(sp)
    800036de:	6c02                	ld	s8,0(sp)
}
    800036e0:	8526                	mv	a0,s1
    800036e2:	60a6                	ld	ra,72(sp)
    800036e4:	6406                	ld	s0,64(sp)
    800036e6:	74e2                	ld	s1,56(sp)
    800036e8:	6161                	addi	sp,sp,80
    800036ea:	8082                	ret
    brelse(bp);
    800036ec:	854a                	mv	a0,s2
    800036ee:	e1dff0ef          	jal	8000350a <brelse>
  for(b = 0; b < sb.size; b += BPB){
    800036f2:	015c0abb          	addw	s5,s8,s5
    800036f6:	004b2783          	lw	a5,4(s6)
    800036fa:	04faf863          	bgeu	s5,a5,8000374a <balloc+0xe8>
    bp = bread(dev, BBLOCK(b, sb));
    800036fe:	40dad59b          	sraiw	a1,s5,0xd
    80003702:	01cb2783          	lw	a5,28(s6)
    80003706:	9dbd                	addw	a1,a1,a5
    80003708:	855e                	mv	a0,s7
    8000370a:	cf9ff0ef          	jal	80003402 <bread>
    8000370e:	892a                	mv	s2,a0
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80003710:	004b2503          	lw	a0,4(s6)
    80003714:	84d6                	mv	s1,s5
    80003716:	4701                	li	a4,0
    80003718:	fca4fae3          	bgeu	s1,a0,800036ec <balloc+0x8a>
      m = 1 << (bi % 8);
    8000371c:	00777693          	andi	a3,a4,7
    80003720:	00d996bb          	sllw	a3,s3,a3
      if((bp->data[bi/8] & m) == 0){  // Is block free?
    80003724:	41f7579b          	sraiw	a5,a4,0x1f
    80003728:	01d7d79b          	srliw	a5,a5,0x1d
    8000372c:	9fb9                	addw	a5,a5,a4
    8000372e:	4037d79b          	sraiw	a5,a5,0x3
    80003732:	00f90633          	add	a2,s2,a5
    80003736:	05864603          	lbu	a2,88(a2) # 1058 <_entry-0x7fffefa8>
    8000373a:	00c6f5b3          	and	a1,a3,a2
    8000373e:	ddb1                	beqz	a1,8000369a <balloc+0x38>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80003740:	2705                	addiw	a4,a4,1
    80003742:	2485                	addiw	s1,s1,1
    80003744:	fd471ae3          	bne	a4,s4,80003718 <balloc+0xb6>
    80003748:	b755                	j	800036ec <balloc+0x8a>
    8000374a:	7942                	ld	s2,48(sp)
    8000374c:	79a2                	ld	s3,40(sp)
    8000374e:	7a02                	ld	s4,32(sp)
    80003750:	6ae2                	ld	s5,24(sp)
    80003752:	6b42                	ld	s6,16(sp)
    80003754:	6ba2                	ld	s7,8(sp)
    80003756:	6c02                	ld	s8,0(sp)
  printf("balloc: out of blocks\n");
    80003758:	00005517          	auipc	a0,0x5
    8000375c:	f5850513          	addi	a0,a0,-168 # 800086b0 <etext+0x6b0>
    80003760:	d9bfc0ef          	jal	800004fa <printf>
  return 0;
    80003764:	4481                	li	s1,0
    80003766:	bfad                	j	800036e0 <balloc+0x7e>

0000000080003768 <bmap>:
// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
// returns 0 if out of disk space.
static uint
bmap(struct inode *ip, uint bn)
{
    80003768:	7179                	addi	sp,sp,-48
    8000376a:	f406                	sd	ra,40(sp)
    8000376c:	f022                	sd	s0,32(sp)
    8000376e:	ec26                	sd	s1,24(sp)
    80003770:	e84a                	sd	s2,16(sp)
    80003772:	e44e                	sd	s3,8(sp)
    80003774:	1800                	addi	s0,sp,48
    80003776:	892a                	mv	s2,a0
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
    80003778:	47ad                	li	a5,11
    8000377a:	02b7e363          	bltu	a5,a1,800037a0 <bmap+0x38>
    if((addr = ip->addrs[bn]) == 0){
    8000377e:	02059793          	slli	a5,a1,0x20
    80003782:	01e7d593          	srli	a1,a5,0x1e
    80003786:	00b509b3          	add	s3,a0,a1
    8000378a:	0509a483          	lw	s1,80(s3)
    8000378e:	e0b5                	bnez	s1,800037f2 <bmap+0x8a>
      addr = balloc(ip->dev);
    80003790:	4108                	lw	a0,0(a0)
    80003792:	ed1ff0ef          	jal	80003662 <balloc>
    80003796:	84aa                	mv	s1,a0
      if(addr == 0)
    80003798:	cd29                	beqz	a0,800037f2 <bmap+0x8a>
        return 0;
      ip->addrs[bn] = addr;
    8000379a:	04a9a823          	sw	a0,80(s3)
    8000379e:	a891                	j	800037f2 <bmap+0x8a>
    }
    return addr;
  }
  bn -= NDIRECT;
    800037a0:	ff45879b          	addiw	a5,a1,-12
    800037a4:	873e                	mv	a4,a5
    800037a6:	89be                	mv	s3,a5

  if(bn < NINDIRECT){
    800037a8:	0ff00793          	li	a5,255
    800037ac:	06e7e763          	bltu	a5,a4,8000381a <bmap+0xb2>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0){
    800037b0:	08052483          	lw	s1,128(a0)
    800037b4:	e891                	bnez	s1,800037c8 <bmap+0x60>
      addr = balloc(ip->dev);
    800037b6:	4108                	lw	a0,0(a0)
    800037b8:	eabff0ef          	jal	80003662 <balloc>
    800037bc:	84aa                	mv	s1,a0
      if(addr == 0)
    800037be:	c915                	beqz	a0,800037f2 <bmap+0x8a>
    800037c0:	e052                	sd	s4,0(sp)
        return 0;
      ip->addrs[NDIRECT] = addr;
    800037c2:	08a92023          	sw	a0,128(s2)
    800037c6:	a011                	j	800037ca <bmap+0x62>
    800037c8:	e052                	sd	s4,0(sp)
    }
    bp = bread(ip->dev, addr);
    800037ca:	85a6                	mv	a1,s1
    800037cc:	00092503          	lw	a0,0(s2)
    800037d0:	c33ff0ef          	jal	80003402 <bread>
    800037d4:	8a2a                	mv	s4,a0
    a = (uint*)bp->data;
    800037d6:	05850793          	addi	a5,a0,88
    if((addr = a[bn]) == 0){
    800037da:	02099713          	slli	a4,s3,0x20
    800037de:	01e75593          	srli	a1,a4,0x1e
    800037e2:	97ae                	add	a5,a5,a1
    800037e4:	89be                	mv	s3,a5
    800037e6:	4384                	lw	s1,0(a5)
    800037e8:	cc89                	beqz	s1,80003802 <bmap+0x9a>
      if(addr){
        a[bn] = addr;
        log_write(bp);
      }
    }
    brelse(bp);
    800037ea:	8552                	mv	a0,s4
    800037ec:	d1fff0ef          	jal	8000350a <brelse>
    return addr;
    800037f0:	6a02                	ld	s4,0(sp)
  }

  panic("bmap: out of range");
}
    800037f2:	8526                	mv	a0,s1
    800037f4:	70a2                	ld	ra,40(sp)
    800037f6:	7402                	ld	s0,32(sp)
    800037f8:	64e2                	ld	s1,24(sp)
    800037fa:	6942                	ld	s2,16(sp)
    800037fc:	69a2                	ld	s3,8(sp)
    800037fe:	6145                	addi	sp,sp,48
    80003800:	8082                	ret
      addr = balloc(ip->dev);
    80003802:	00092503          	lw	a0,0(s2)
    80003806:	e5dff0ef          	jal	80003662 <balloc>
    8000380a:	84aa                	mv	s1,a0
      if(addr){
    8000380c:	dd79                	beqz	a0,800037ea <bmap+0x82>
        a[bn] = addr;
    8000380e:	00a9a023          	sw	a0,0(s3)
        log_write(bp);
    80003812:	8552                	mv	a0,s4
    80003814:	62d000ef          	jal	80004640 <log_write>
    80003818:	bfc9                	j	800037ea <bmap+0x82>
    8000381a:	e052                	sd	s4,0(sp)
  panic("bmap: out of range");
    8000381c:	00005517          	auipc	a0,0x5
    80003820:	eac50513          	addi	a0,a0,-340 # 800086c8 <etext+0x6c8>
    80003824:	800fd0ef          	jal	80000824 <panic>

0000000080003828 <iget>:
{
    80003828:	7179                	addi	sp,sp,-48
    8000382a:	f406                	sd	ra,40(sp)
    8000382c:	f022                	sd	s0,32(sp)
    8000382e:	ec26                	sd	s1,24(sp)
    80003830:	e84a                	sd	s2,16(sp)
    80003832:	e44e                	sd	s3,8(sp)
    80003834:	e052                	sd	s4,0(sp)
    80003836:	1800                	addi	s0,sp,48
    80003838:	892a                	mv	s2,a0
    8000383a:	8a2e                	mv	s4,a1
  acquire(&itable.lock);
    8000383c:	02260517          	auipc	a0,0x2260
    80003840:	fb450513          	addi	a0,a0,-76 # 822637f0 <itable>
    80003844:	be4fd0ef          	jal	80000c28 <acquire>
  empty = 0;
    80003848:	4981                	li	s3,0
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    8000384a:	02260497          	auipc	s1,0x2260
    8000384e:	fbe48493          	addi	s1,s1,-66 # 82263808 <itable+0x18>
    80003852:	02262697          	auipc	a3,0x2262
    80003856:	a4668693          	addi	a3,a3,-1466 # 82265298 <log>
    8000385a:	a809                	j	8000386c <iget+0x44>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    8000385c:	e781                	bnez	a5,80003864 <iget+0x3c>
    8000385e:	00099363          	bnez	s3,80003864 <iget+0x3c>
      empty = ip;
    80003862:	89a6                	mv	s3,s1
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    80003864:	08848493          	addi	s1,s1,136
    80003868:	02d48563          	beq	s1,a3,80003892 <iget+0x6a>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
    8000386c:	449c                	lw	a5,8(s1)
    8000386e:	fef057e3          	blez	a5,8000385c <iget+0x34>
    80003872:	4098                	lw	a4,0(s1)
    80003874:	ff2718e3          	bne	a4,s2,80003864 <iget+0x3c>
    80003878:	40d8                	lw	a4,4(s1)
    8000387a:	ff4715e3          	bne	a4,s4,80003864 <iget+0x3c>
      ip->ref++;
    8000387e:	2785                	addiw	a5,a5,1
    80003880:	c49c                	sw	a5,8(s1)
      release(&itable.lock);
    80003882:	02260517          	auipc	a0,0x2260
    80003886:	f6e50513          	addi	a0,a0,-146 # 822637f0 <itable>
    8000388a:	c32fd0ef          	jal	80000cbc <release>
      return ip;
    8000388e:	89a6                	mv	s3,s1
    80003890:	a015                	j	800038b4 <iget+0x8c>
  if(empty == 0)
    80003892:	02098a63          	beqz	s3,800038c6 <iget+0x9e>
  ip->dev = dev;
    80003896:	0129a023          	sw	s2,0(s3)
  ip->inum = inum;
    8000389a:	0149a223          	sw	s4,4(s3)
  ip->ref = 1;
    8000389e:	4785                	li	a5,1
    800038a0:	00f9a423          	sw	a5,8(s3)
  ip->valid = 0;
    800038a4:	0409a023          	sw	zero,64(s3)
  release(&itable.lock);
    800038a8:	02260517          	auipc	a0,0x2260
    800038ac:	f4850513          	addi	a0,a0,-184 # 822637f0 <itable>
    800038b0:	c0cfd0ef          	jal	80000cbc <release>
}
    800038b4:	854e                	mv	a0,s3
    800038b6:	70a2                	ld	ra,40(sp)
    800038b8:	7402                	ld	s0,32(sp)
    800038ba:	64e2                	ld	s1,24(sp)
    800038bc:	6942                	ld	s2,16(sp)
    800038be:	69a2                	ld	s3,8(sp)
    800038c0:	6a02                	ld	s4,0(sp)
    800038c2:	6145                	addi	sp,sp,48
    800038c4:	8082                	ret
    panic("iget: no inodes");
    800038c6:	00005517          	auipc	a0,0x5
    800038ca:	e1a50513          	addi	a0,a0,-486 # 800086e0 <etext+0x6e0>
    800038ce:	f57fc0ef          	jal	80000824 <panic>

00000000800038d2 <iinit>:
{
    800038d2:	7179                	addi	sp,sp,-48
    800038d4:	f406                	sd	ra,40(sp)
    800038d6:	f022                	sd	s0,32(sp)
    800038d8:	ec26                	sd	s1,24(sp)
    800038da:	e84a                	sd	s2,16(sp)
    800038dc:	e44e                	sd	s3,8(sp)
    800038de:	1800                	addi	s0,sp,48
  initlock(&itable.lock, "itable");
    800038e0:	00005597          	auipc	a1,0x5
    800038e4:	e1058593          	addi	a1,a1,-496 # 800086f0 <etext+0x6f0>
    800038e8:	02260517          	auipc	a0,0x2260
    800038ec:	f0850513          	addi	a0,a0,-248 # 822637f0 <itable>
    800038f0:	aaefd0ef          	jal	80000b9e <initlock>
  for(i = 0; i < NINODE; i++) {
    800038f4:	02260497          	auipc	s1,0x2260
    800038f8:	f2448493          	addi	s1,s1,-220 # 82263818 <itable+0x28>
    800038fc:	02262997          	auipc	s3,0x2262
    80003900:	9ac98993          	addi	s3,s3,-1620 # 822652a8 <log+0x10>
    initsleeplock(&itable.inode[i].lock, "inode");
    80003904:	00005917          	auipc	s2,0x5
    80003908:	df490913          	addi	s2,s2,-524 # 800086f8 <etext+0x6f8>
    8000390c:	85ca                	mv	a1,s2
    8000390e:	8526                	mv	a0,s1
    80003910:	5f5000ef          	jal	80004704 <initsleeplock>
  for(i = 0; i < NINODE; i++) {
    80003914:	08848493          	addi	s1,s1,136
    80003918:	ff349ae3          	bne	s1,s3,8000390c <iinit+0x3a>
}
    8000391c:	70a2                	ld	ra,40(sp)
    8000391e:	7402                	ld	s0,32(sp)
    80003920:	64e2                	ld	s1,24(sp)
    80003922:	6942                	ld	s2,16(sp)
    80003924:	69a2                	ld	s3,8(sp)
    80003926:	6145                	addi	sp,sp,48
    80003928:	8082                	ret

000000008000392a <ialloc>:
{
    8000392a:	7139                	addi	sp,sp,-64
    8000392c:	fc06                	sd	ra,56(sp)
    8000392e:	f822                	sd	s0,48(sp)
    80003930:	0080                	addi	s0,sp,64
  for(inum = 1; inum < sb.ninodes; inum++){
    80003932:	02260717          	auipc	a4,0x2260
    80003936:	eaa72703          	lw	a4,-342(a4) # 822637dc <sb+0xc>
    8000393a:	4785                	li	a5,1
    8000393c:	06e7f063          	bgeu	a5,a4,8000399c <ialloc+0x72>
    80003940:	f426                	sd	s1,40(sp)
    80003942:	f04a                	sd	s2,32(sp)
    80003944:	ec4e                	sd	s3,24(sp)
    80003946:	e852                	sd	s4,16(sp)
    80003948:	e456                	sd	s5,8(sp)
    8000394a:	e05a                	sd	s6,0(sp)
    8000394c:	8aaa                	mv	s5,a0
    8000394e:	8b2e                	mv	s6,a1
    80003950:	893e                	mv	s2,a5
    bp = bread(dev, IBLOCK(inum, sb));
    80003952:	02260a17          	auipc	s4,0x2260
    80003956:	e7ea0a13          	addi	s4,s4,-386 # 822637d0 <sb>
    8000395a:	00495593          	srli	a1,s2,0x4
    8000395e:	018a2783          	lw	a5,24(s4)
    80003962:	9dbd                	addw	a1,a1,a5
    80003964:	8556                	mv	a0,s5
    80003966:	a9dff0ef          	jal	80003402 <bread>
    8000396a:	84aa                	mv	s1,a0
    dip = (struct dinode*)bp->data + inum%IPB;
    8000396c:	05850993          	addi	s3,a0,88
    80003970:	00f97793          	andi	a5,s2,15
    80003974:	079a                	slli	a5,a5,0x6
    80003976:	99be                	add	s3,s3,a5
    if(dip->type == 0){  // a free inode
    80003978:	00099783          	lh	a5,0(s3)
    8000397c:	cb9d                	beqz	a5,800039b2 <ialloc+0x88>
    brelse(bp);
    8000397e:	b8dff0ef          	jal	8000350a <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
    80003982:	0905                	addi	s2,s2,1
    80003984:	00ca2703          	lw	a4,12(s4)
    80003988:	0009079b          	sext.w	a5,s2
    8000398c:	fce7e7e3          	bltu	a5,a4,8000395a <ialloc+0x30>
    80003990:	74a2                	ld	s1,40(sp)
    80003992:	7902                	ld	s2,32(sp)
    80003994:	69e2                	ld	s3,24(sp)
    80003996:	6a42                	ld	s4,16(sp)
    80003998:	6aa2                	ld	s5,8(sp)
    8000399a:	6b02                	ld	s6,0(sp)
  printf("ialloc: no inodes\n");
    8000399c:	00005517          	auipc	a0,0x5
    800039a0:	d6450513          	addi	a0,a0,-668 # 80008700 <etext+0x700>
    800039a4:	b57fc0ef          	jal	800004fa <printf>
  return 0;
    800039a8:	4501                	li	a0,0
}
    800039aa:	70e2                	ld	ra,56(sp)
    800039ac:	7442                	ld	s0,48(sp)
    800039ae:	6121                	addi	sp,sp,64
    800039b0:	8082                	ret
      memset(dip, 0, sizeof(*dip));
    800039b2:	04000613          	li	a2,64
    800039b6:	4581                	li	a1,0
    800039b8:	854e                	mv	a0,s3
    800039ba:	b3efd0ef          	jal	80000cf8 <memset>
      dip->type = type;
    800039be:	01699023          	sh	s6,0(s3)
      log_write(bp);   // mark it allocated on the disk
    800039c2:	8526                	mv	a0,s1
    800039c4:	47d000ef          	jal	80004640 <log_write>
      brelse(bp);
    800039c8:	8526                	mv	a0,s1
    800039ca:	b41ff0ef          	jal	8000350a <brelse>
      return iget(dev, inum);
    800039ce:	0009059b          	sext.w	a1,s2
    800039d2:	8556                	mv	a0,s5
    800039d4:	e55ff0ef          	jal	80003828 <iget>
    800039d8:	74a2                	ld	s1,40(sp)
    800039da:	7902                	ld	s2,32(sp)
    800039dc:	69e2                	ld	s3,24(sp)
    800039de:	6a42                	ld	s4,16(sp)
    800039e0:	6aa2                	ld	s5,8(sp)
    800039e2:	6b02                	ld	s6,0(sp)
    800039e4:	b7d9                	j	800039aa <ialloc+0x80>

00000000800039e6 <iupdate>:
{
    800039e6:	1101                	addi	sp,sp,-32
    800039e8:	ec06                	sd	ra,24(sp)
    800039ea:	e822                	sd	s0,16(sp)
    800039ec:	e426                	sd	s1,8(sp)
    800039ee:	e04a                	sd	s2,0(sp)
    800039f0:	1000                	addi	s0,sp,32
    800039f2:	84aa                	mv	s1,a0
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    800039f4:	415c                	lw	a5,4(a0)
    800039f6:	0047d79b          	srliw	a5,a5,0x4
    800039fa:	02260597          	auipc	a1,0x2260
    800039fe:	dee5a583          	lw	a1,-530(a1) # 822637e8 <sb+0x18>
    80003a02:	9dbd                	addw	a1,a1,a5
    80003a04:	4108                	lw	a0,0(a0)
    80003a06:	9fdff0ef          	jal	80003402 <bread>
    80003a0a:	892a                	mv	s2,a0
  dip = (struct dinode*)bp->data + ip->inum%IPB;
    80003a0c:	05850793          	addi	a5,a0,88
    80003a10:	40d8                	lw	a4,4(s1)
    80003a12:	8b3d                	andi	a4,a4,15
    80003a14:	071a                	slli	a4,a4,0x6
    80003a16:	97ba                	add	a5,a5,a4
  dip->type = ip->type;
    80003a18:	04449703          	lh	a4,68(s1)
    80003a1c:	00e79023          	sh	a4,0(a5)
  dip->major = ip->major;
    80003a20:	04649703          	lh	a4,70(s1)
    80003a24:	00e79123          	sh	a4,2(a5)
  dip->minor = ip->minor;
    80003a28:	04849703          	lh	a4,72(s1)
    80003a2c:	00e79223          	sh	a4,4(a5)
  dip->nlink = ip->nlink;
    80003a30:	04a49703          	lh	a4,74(s1)
    80003a34:	00e79323          	sh	a4,6(a5)
  dip->size = ip->size;
    80003a38:	44f8                	lw	a4,76(s1)
    80003a3a:	c798                	sw	a4,8(a5)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
    80003a3c:	03400613          	li	a2,52
    80003a40:	05048593          	addi	a1,s1,80
    80003a44:	00c78513          	addi	a0,a5,12
    80003a48:	b10fd0ef          	jal	80000d58 <memmove>
  log_write(bp);
    80003a4c:	854a                	mv	a0,s2
    80003a4e:	3f3000ef          	jal	80004640 <log_write>
  brelse(bp);
    80003a52:	854a                	mv	a0,s2
    80003a54:	ab7ff0ef          	jal	8000350a <brelse>
}
    80003a58:	60e2                	ld	ra,24(sp)
    80003a5a:	6442                	ld	s0,16(sp)
    80003a5c:	64a2                	ld	s1,8(sp)
    80003a5e:	6902                	ld	s2,0(sp)
    80003a60:	6105                	addi	sp,sp,32
    80003a62:	8082                	ret

0000000080003a64 <idup>:
{
    80003a64:	1101                	addi	sp,sp,-32
    80003a66:	ec06                	sd	ra,24(sp)
    80003a68:	e822                	sd	s0,16(sp)
    80003a6a:	e426                	sd	s1,8(sp)
    80003a6c:	1000                	addi	s0,sp,32
    80003a6e:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    80003a70:	02260517          	auipc	a0,0x2260
    80003a74:	d8050513          	addi	a0,a0,-640 # 822637f0 <itable>
    80003a78:	9b0fd0ef          	jal	80000c28 <acquire>
  ip->ref++;
    80003a7c:	449c                	lw	a5,8(s1)
    80003a7e:	2785                	addiw	a5,a5,1
    80003a80:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    80003a82:	02260517          	auipc	a0,0x2260
    80003a86:	d6e50513          	addi	a0,a0,-658 # 822637f0 <itable>
    80003a8a:	a32fd0ef          	jal	80000cbc <release>
}
    80003a8e:	8526                	mv	a0,s1
    80003a90:	60e2                	ld	ra,24(sp)
    80003a92:	6442                	ld	s0,16(sp)
    80003a94:	64a2                	ld	s1,8(sp)
    80003a96:	6105                	addi	sp,sp,32
    80003a98:	8082                	ret

0000000080003a9a <ilock>:
{
    80003a9a:	1101                	addi	sp,sp,-32
    80003a9c:	ec06                	sd	ra,24(sp)
    80003a9e:	e822                	sd	s0,16(sp)
    80003aa0:	e426                	sd	s1,8(sp)
    80003aa2:	1000                	addi	s0,sp,32
  if(ip == 0 || ip->ref < 1)
    80003aa4:	cd19                	beqz	a0,80003ac2 <ilock+0x28>
    80003aa6:	84aa                	mv	s1,a0
    80003aa8:	451c                	lw	a5,8(a0)
    80003aaa:	00f05c63          	blez	a5,80003ac2 <ilock+0x28>
  acquiresleep(&ip->lock);
    80003aae:	0541                	addi	a0,a0,16
    80003ab0:	48b000ef          	jal	8000473a <acquiresleep>
  if(ip->valid == 0){
    80003ab4:	40bc                	lw	a5,64(s1)
    80003ab6:	cf89                	beqz	a5,80003ad0 <ilock+0x36>
}
    80003ab8:	60e2                	ld	ra,24(sp)
    80003aba:	6442                	ld	s0,16(sp)
    80003abc:	64a2                	ld	s1,8(sp)
    80003abe:	6105                	addi	sp,sp,32
    80003ac0:	8082                	ret
    80003ac2:	e04a                	sd	s2,0(sp)
    panic("ilock");
    80003ac4:	00005517          	auipc	a0,0x5
    80003ac8:	c5450513          	addi	a0,a0,-940 # 80008718 <etext+0x718>
    80003acc:	d59fc0ef          	jal	80000824 <panic>
    80003ad0:	e04a                	sd	s2,0(sp)
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80003ad2:	40dc                	lw	a5,4(s1)
    80003ad4:	0047d79b          	srliw	a5,a5,0x4
    80003ad8:	02260597          	auipc	a1,0x2260
    80003adc:	d105a583          	lw	a1,-752(a1) # 822637e8 <sb+0x18>
    80003ae0:	9dbd                	addw	a1,a1,a5
    80003ae2:	4088                	lw	a0,0(s1)
    80003ae4:	91fff0ef          	jal	80003402 <bread>
    80003ae8:	892a                	mv	s2,a0
    dip = (struct dinode*)bp->data + ip->inum%IPB;
    80003aea:	05850593          	addi	a1,a0,88
    80003aee:	40dc                	lw	a5,4(s1)
    80003af0:	8bbd                	andi	a5,a5,15
    80003af2:	079a                	slli	a5,a5,0x6
    80003af4:	95be                	add	a1,a1,a5
    ip->type = dip->type;
    80003af6:	00059783          	lh	a5,0(a1)
    80003afa:	04f49223          	sh	a5,68(s1)
    ip->major = dip->major;
    80003afe:	00259783          	lh	a5,2(a1)
    80003b02:	04f49323          	sh	a5,70(s1)
    ip->minor = dip->minor;
    80003b06:	00459783          	lh	a5,4(a1)
    80003b0a:	04f49423          	sh	a5,72(s1)
    ip->nlink = dip->nlink;
    80003b0e:	00659783          	lh	a5,6(a1)
    80003b12:	04f49523          	sh	a5,74(s1)
    ip->size = dip->size;
    80003b16:	459c                	lw	a5,8(a1)
    80003b18:	c4fc                	sw	a5,76(s1)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
    80003b1a:	03400613          	li	a2,52
    80003b1e:	05b1                	addi	a1,a1,12
    80003b20:	05048513          	addi	a0,s1,80
    80003b24:	a34fd0ef          	jal	80000d58 <memmove>
    brelse(bp);
    80003b28:	854a                	mv	a0,s2
    80003b2a:	9e1ff0ef          	jal	8000350a <brelse>
    ip->valid = 1;
    80003b2e:	4785                	li	a5,1
    80003b30:	c0bc                	sw	a5,64(s1)
    if(ip->type == 0)
    80003b32:	04449783          	lh	a5,68(s1)
    80003b36:	c399                	beqz	a5,80003b3c <ilock+0xa2>
    80003b38:	6902                	ld	s2,0(sp)
    80003b3a:	bfbd                	j	80003ab8 <ilock+0x1e>
      panic("ilock: no type");
    80003b3c:	00005517          	auipc	a0,0x5
    80003b40:	be450513          	addi	a0,a0,-1052 # 80008720 <etext+0x720>
    80003b44:	ce1fc0ef          	jal	80000824 <panic>

0000000080003b48 <iunlock>:
{
    80003b48:	1101                	addi	sp,sp,-32
    80003b4a:	ec06                	sd	ra,24(sp)
    80003b4c:	e822                	sd	s0,16(sp)
    80003b4e:	e426                	sd	s1,8(sp)
    80003b50:	e04a                	sd	s2,0(sp)
    80003b52:	1000                	addi	s0,sp,32
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
    80003b54:	c505                	beqz	a0,80003b7c <iunlock+0x34>
    80003b56:	84aa                	mv	s1,a0
    80003b58:	01050913          	addi	s2,a0,16
    80003b5c:	854a                	mv	a0,s2
    80003b5e:	45b000ef          	jal	800047b8 <holdingsleep>
    80003b62:	cd09                	beqz	a0,80003b7c <iunlock+0x34>
    80003b64:	449c                	lw	a5,8(s1)
    80003b66:	00f05b63          	blez	a5,80003b7c <iunlock+0x34>
  releasesleep(&ip->lock);
    80003b6a:	854a                	mv	a0,s2
    80003b6c:	415000ef          	jal	80004780 <releasesleep>
}
    80003b70:	60e2                	ld	ra,24(sp)
    80003b72:	6442                	ld	s0,16(sp)
    80003b74:	64a2                	ld	s1,8(sp)
    80003b76:	6902                	ld	s2,0(sp)
    80003b78:	6105                	addi	sp,sp,32
    80003b7a:	8082                	ret
    panic("iunlock");
    80003b7c:	00005517          	auipc	a0,0x5
    80003b80:	bb450513          	addi	a0,a0,-1100 # 80008730 <etext+0x730>
    80003b84:	ca1fc0ef          	jal	80000824 <panic>

0000000080003b88 <itrunc>:

// Truncate inode (discard contents).
// Caller must hold ip->lock.
void
itrunc(struct inode *ip)
{
    80003b88:	7179                	addi	sp,sp,-48
    80003b8a:	f406                	sd	ra,40(sp)
    80003b8c:	f022                	sd	s0,32(sp)
    80003b8e:	ec26                	sd	s1,24(sp)
    80003b90:	e84a                	sd	s2,16(sp)
    80003b92:	e44e                	sd	s3,8(sp)
    80003b94:	1800                	addi	s0,sp,48
    80003b96:	89aa                	mv	s3,a0
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
    80003b98:	05050493          	addi	s1,a0,80
    80003b9c:	08050913          	addi	s2,a0,128
    80003ba0:	a021                	j	80003ba8 <itrunc+0x20>
    80003ba2:	0491                	addi	s1,s1,4
    80003ba4:	01248b63          	beq	s1,s2,80003bba <itrunc+0x32>
    if(ip->addrs[i]){
    80003ba8:	408c                	lw	a1,0(s1)
    80003baa:	dde5                	beqz	a1,80003ba2 <itrunc+0x1a>
      bfree(ip->dev, ip->addrs[i]);
    80003bac:	0009a503          	lw	a0,0(s3)
    80003bb0:	a47ff0ef          	jal	800035f6 <bfree>
      ip->addrs[i] = 0;
    80003bb4:	0004a023          	sw	zero,0(s1)
    80003bb8:	b7ed                	j	80003ba2 <itrunc+0x1a>
    }
  }

  if(ip->addrs[NDIRECT]){
    80003bba:	0809a583          	lw	a1,128(s3)
    80003bbe:	ed89                	bnez	a1,80003bd8 <itrunc+0x50>
    brelse(bp);
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
    80003bc0:	0409a623          	sw	zero,76(s3)
  iupdate(ip);
    80003bc4:	854e                	mv	a0,s3
    80003bc6:	e21ff0ef          	jal	800039e6 <iupdate>
}
    80003bca:	70a2                	ld	ra,40(sp)
    80003bcc:	7402                	ld	s0,32(sp)
    80003bce:	64e2                	ld	s1,24(sp)
    80003bd0:	6942                	ld	s2,16(sp)
    80003bd2:	69a2                	ld	s3,8(sp)
    80003bd4:	6145                	addi	sp,sp,48
    80003bd6:	8082                	ret
    80003bd8:	e052                	sd	s4,0(sp)
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
    80003bda:	0009a503          	lw	a0,0(s3)
    80003bde:	825ff0ef          	jal	80003402 <bread>
    80003be2:	8a2a                	mv	s4,a0
    for(j = 0; j < NINDIRECT; j++){
    80003be4:	05850493          	addi	s1,a0,88
    80003be8:	45850913          	addi	s2,a0,1112
    80003bec:	a021                	j	80003bf4 <itrunc+0x6c>
    80003bee:	0491                	addi	s1,s1,4
    80003bf0:	01248963          	beq	s1,s2,80003c02 <itrunc+0x7a>
      if(a[j])
    80003bf4:	408c                	lw	a1,0(s1)
    80003bf6:	dde5                	beqz	a1,80003bee <itrunc+0x66>
        bfree(ip->dev, a[j]);
    80003bf8:	0009a503          	lw	a0,0(s3)
    80003bfc:	9fbff0ef          	jal	800035f6 <bfree>
    80003c00:	b7fd                	j	80003bee <itrunc+0x66>
    brelse(bp);
    80003c02:	8552                	mv	a0,s4
    80003c04:	907ff0ef          	jal	8000350a <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    80003c08:	0809a583          	lw	a1,128(s3)
    80003c0c:	0009a503          	lw	a0,0(s3)
    80003c10:	9e7ff0ef          	jal	800035f6 <bfree>
    ip->addrs[NDIRECT] = 0;
    80003c14:	0809a023          	sw	zero,128(s3)
    80003c18:	6a02                	ld	s4,0(sp)
    80003c1a:	b75d                	j	80003bc0 <itrunc+0x38>

0000000080003c1c <iput>:
{
    80003c1c:	1101                	addi	sp,sp,-32
    80003c1e:	ec06                	sd	ra,24(sp)
    80003c20:	e822                	sd	s0,16(sp)
    80003c22:	e426                	sd	s1,8(sp)
    80003c24:	1000                	addi	s0,sp,32
    80003c26:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    80003c28:	02260517          	auipc	a0,0x2260
    80003c2c:	bc850513          	addi	a0,a0,-1080 # 822637f0 <itable>
    80003c30:	ff9fc0ef          	jal	80000c28 <acquire>
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    80003c34:	4498                	lw	a4,8(s1)
    80003c36:	4785                	li	a5,1
    80003c38:	02f70063          	beq	a4,a5,80003c58 <iput+0x3c>
  ip->ref--;
    80003c3c:	449c                	lw	a5,8(s1)
    80003c3e:	37fd                	addiw	a5,a5,-1
    80003c40:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    80003c42:	02260517          	auipc	a0,0x2260
    80003c46:	bae50513          	addi	a0,a0,-1106 # 822637f0 <itable>
    80003c4a:	872fd0ef          	jal	80000cbc <release>
}
    80003c4e:	60e2                	ld	ra,24(sp)
    80003c50:	6442                	ld	s0,16(sp)
    80003c52:	64a2                	ld	s1,8(sp)
    80003c54:	6105                	addi	sp,sp,32
    80003c56:	8082                	ret
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    80003c58:	40bc                	lw	a5,64(s1)
    80003c5a:	d3ed                	beqz	a5,80003c3c <iput+0x20>
    80003c5c:	04a49783          	lh	a5,74(s1)
    80003c60:	fff1                	bnez	a5,80003c3c <iput+0x20>
    80003c62:	e04a                	sd	s2,0(sp)
    acquiresleep(&ip->lock);
    80003c64:	01048793          	addi	a5,s1,16
    80003c68:	893e                	mv	s2,a5
    80003c6a:	853e                	mv	a0,a5
    80003c6c:	2cf000ef          	jal	8000473a <acquiresleep>
    release(&itable.lock);
    80003c70:	02260517          	auipc	a0,0x2260
    80003c74:	b8050513          	addi	a0,a0,-1152 # 822637f0 <itable>
    80003c78:	844fd0ef          	jal	80000cbc <release>
    itrunc(ip);
    80003c7c:	8526                	mv	a0,s1
    80003c7e:	f0bff0ef          	jal	80003b88 <itrunc>
    ip->type = 0;
    80003c82:	04049223          	sh	zero,68(s1)
    iupdate(ip);
    80003c86:	8526                	mv	a0,s1
    80003c88:	d5fff0ef          	jal	800039e6 <iupdate>
    ip->valid = 0;
    80003c8c:	0404a023          	sw	zero,64(s1)
    releasesleep(&ip->lock);
    80003c90:	854a                	mv	a0,s2
    80003c92:	2ef000ef          	jal	80004780 <releasesleep>
    acquire(&itable.lock);
    80003c96:	02260517          	auipc	a0,0x2260
    80003c9a:	b5a50513          	addi	a0,a0,-1190 # 822637f0 <itable>
    80003c9e:	f8bfc0ef          	jal	80000c28 <acquire>
    80003ca2:	6902                	ld	s2,0(sp)
    80003ca4:	bf61                	j	80003c3c <iput+0x20>

0000000080003ca6 <iunlockput>:
{
    80003ca6:	1101                	addi	sp,sp,-32
    80003ca8:	ec06                	sd	ra,24(sp)
    80003caa:	e822                	sd	s0,16(sp)
    80003cac:	e426                	sd	s1,8(sp)
    80003cae:	1000                	addi	s0,sp,32
    80003cb0:	84aa                	mv	s1,a0
  iunlock(ip);
    80003cb2:	e97ff0ef          	jal	80003b48 <iunlock>
  iput(ip);
    80003cb6:	8526                	mv	a0,s1
    80003cb8:	f65ff0ef          	jal	80003c1c <iput>
}
    80003cbc:	60e2                	ld	ra,24(sp)
    80003cbe:	6442                	ld	s0,16(sp)
    80003cc0:	64a2                	ld	s1,8(sp)
    80003cc2:	6105                	addi	sp,sp,32
    80003cc4:	8082                	ret

0000000080003cc6 <ireclaim>:
  for (int inum = 1; inum < sb.ninodes; inum++) {
    80003cc6:	02260717          	auipc	a4,0x2260
    80003cca:	b1672703          	lw	a4,-1258(a4) # 822637dc <sb+0xc>
    80003cce:	4785                	li	a5,1
    80003cd0:	0ae7fe63          	bgeu	a5,a4,80003d8c <ireclaim+0xc6>
{
    80003cd4:	7139                	addi	sp,sp,-64
    80003cd6:	fc06                	sd	ra,56(sp)
    80003cd8:	f822                	sd	s0,48(sp)
    80003cda:	f426                	sd	s1,40(sp)
    80003cdc:	f04a                	sd	s2,32(sp)
    80003cde:	ec4e                	sd	s3,24(sp)
    80003ce0:	e852                	sd	s4,16(sp)
    80003ce2:	e456                	sd	s5,8(sp)
    80003ce4:	e05a                	sd	s6,0(sp)
    80003ce6:	0080                	addi	s0,sp,64
    80003ce8:	8aaa                	mv	s5,a0
  for (int inum = 1; inum < sb.ninodes; inum++) {
    80003cea:	84be                	mv	s1,a5
    struct buf *bp = bread(dev, IBLOCK(inum, sb));
    80003cec:	02260a17          	auipc	s4,0x2260
    80003cf0:	ae4a0a13          	addi	s4,s4,-1308 # 822637d0 <sb>
      printf("ireclaim: orphaned inode %d\n", inum);
    80003cf4:	00005b17          	auipc	s6,0x5
    80003cf8:	a44b0b13          	addi	s6,s6,-1468 # 80008738 <etext+0x738>
    80003cfc:	a099                	j	80003d42 <ireclaim+0x7c>
    80003cfe:	85ce                	mv	a1,s3
    80003d00:	855a                	mv	a0,s6
    80003d02:	ff8fc0ef          	jal	800004fa <printf>
      ip = iget(dev, inum);
    80003d06:	85ce                	mv	a1,s3
    80003d08:	8556                	mv	a0,s5
    80003d0a:	b1fff0ef          	jal	80003828 <iget>
    80003d0e:	89aa                	mv	s3,a0
    brelse(bp);
    80003d10:	854a                	mv	a0,s2
    80003d12:	ff8ff0ef          	jal	8000350a <brelse>
    if (ip) {
    80003d16:	00098f63          	beqz	s3,80003d34 <ireclaim+0x6e>
      begin_op();
    80003d1a:	78c000ef          	jal	800044a6 <begin_op>
      ilock(ip);
    80003d1e:	854e                	mv	a0,s3
    80003d20:	d7bff0ef          	jal	80003a9a <ilock>
      iunlock(ip);
    80003d24:	854e                	mv	a0,s3
    80003d26:	e23ff0ef          	jal	80003b48 <iunlock>
      iput(ip);
    80003d2a:	854e                	mv	a0,s3
    80003d2c:	ef1ff0ef          	jal	80003c1c <iput>
      end_op();
    80003d30:	7e6000ef          	jal	80004516 <end_op>
  for (int inum = 1; inum < sb.ninodes; inum++) {
    80003d34:	0485                	addi	s1,s1,1
    80003d36:	00ca2703          	lw	a4,12(s4)
    80003d3a:	0004879b          	sext.w	a5,s1
    80003d3e:	02e7fd63          	bgeu	a5,a4,80003d78 <ireclaim+0xb2>
    80003d42:	0004899b          	sext.w	s3,s1
    struct buf *bp = bread(dev, IBLOCK(inum, sb));
    80003d46:	0044d593          	srli	a1,s1,0x4
    80003d4a:	018a2783          	lw	a5,24(s4)
    80003d4e:	9dbd                	addw	a1,a1,a5
    80003d50:	8556                	mv	a0,s5
    80003d52:	eb0ff0ef          	jal	80003402 <bread>
    80003d56:	892a                	mv	s2,a0
    struct dinode *dip = (struct dinode *)bp->data + inum % IPB;
    80003d58:	05850793          	addi	a5,a0,88
    80003d5c:	00f9f713          	andi	a4,s3,15
    80003d60:	071a                	slli	a4,a4,0x6
    80003d62:	97ba                	add	a5,a5,a4
    if (dip->type != 0 && dip->nlink == 0) {  // is an orphaned inode
    80003d64:	00079703          	lh	a4,0(a5)
    80003d68:	c701                	beqz	a4,80003d70 <ireclaim+0xaa>
    80003d6a:	00679783          	lh	a5,6(a5)
    80003d6e:	dbc1                	beqz	a5,80003cfe <ireclaim+0x38>
    brelse(bp);
    80003d70:	854a                	mv	a0,s2
    80003d72:	f98ff0ef          	jal	8000350a <brelse>
    if (ip) {
    80003d76:	bf7d                	j	80003d34 <ireclaim+0x6e>
}
    80003d78:	70e2                	ld	ra,56(sp)
    80003d7a:	7442                	ld	s0,48(sp)
    80003d7c:	74a2                	ld	s1,40(sp)
    80003d7e:	7902                	ld	s2,32(sp)
    80003d80:	69e2                	ld	s3,24(sp)
    80003d82:	6a42                	ld	s4,16(sp)
    80003d84:	6aa2                	ld	s5,8(sp)
    80003d86:	6b02                	ld	s6,0(sp)
    80003d88:	6121                	addi	sp,sp,64
    80003d8a:	8082                	ret
    80003d8c:	8082                	ret

0000000080003d8e <fsinit>:
fsinit(int dev) {
    80003d8e:	1101                	addi	sp,sp,-32
    80003d90:	ec06                	sd	ra,24(sp)
    80003d92:	e822                	sd	s0,16(sp)
    80003d94:	e426                	sd	s1,8(sp)
    80003d96:	e04a                	sd	s2,0(sp)
    80003d98:	1000                	addi	s0,sp,32
    80003d9a:	892a                	mv	s2,a0
  bp = bread(dev, 1);
    80003d9c:	4585                	li	a1,1
    80003d9e:	e64ff0ef          	jal	80003402 <bread>
    80003da2:	84aa                	mv	s1,a0
  memmove(sb, bp->data, sizeof(*sb));
    80003da4:	02000613          	li	a2,32
    80003da8:	05850593          	addi	a1,a0,88
    80003dac:	02260517          	auipc	a0,0x2260
    80003db0:	a2450513          	addi	a0,a0,-1500 # 822637d0 <sb>
    80003db4:	fa5fc0ef          	jal	80000d58 <memmove>
  brelse(bp);
    80003db8:	8526                	mv	a0,s1
    80003dba:	f50ff0ef          	jal	8000350a <brelse>
  if(sb.magic != FSMAGIC)
    80003dbe:	02260717          	auipc	a4,0x2260
    80003dc2:	a1272703          	lw	a4,-1518(a4) # 822637d0 <sb>
    80003dc6:	102037b7          	lui	a5,0x10203
    80003dca:	04078793          	addi	a5,a5,64 # 10203040 <_entry-0x6fdfcfc0>
    80003dce:	02f71263          	bne	a4,a5,80003df2 <fsinit+0x64>
  initlog(dev, &sb);
    80003dd2:	02260597          	auipc	a1,0x2260
    80003dd6:	9fe58593          	addi	a1,a1,-1538 # 822637d0 <sb>
    80003dda:	854a                	mv	a0,s2
    80003ddc:	648000ef          	jal	80004424 <initlog>
  ireclaim(dev);
    80003de0:	854a                	mv	a0,s2
    80003de2:	ee5ff0ef          	jal	80003cc6 <ireclaim>
}
    80003de6:	60e2                	ld	ra,24(sp)
    80003de8:	6442                	ld	s0,16(sp)
    80003dea:	64a2                	ld	s1,8(sp)
    80003dec:	6902                	ld	s2,0(sp)
    80003dee:	6105                	addi	sp,sp,32
    80003df0:	8082                	ret
    panic("invalid file system");
    80003df2:	00005517          	auipc	a0,0x5
    80003df6:	96650513          	addi	a0,a0,-1690 # 80008758 <etext+0x758>
    80003dfa:	a2bfc0ef          	jal	80000824 <panic>

0000000080003dfe <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
    80003dfe:	1141                	addi	sp,sp,-16
    80003e00:	e406                	sd	ra,8(sp)
    80003e02:	e022                	sd	s0,0(sp)
    80003e04:	0800                	addi	s0,sp,16
  st->dev = ip->dev;
    80003e06:	411c                	lw	a5,0(a0)
    80003e08:	c19c                	sw	a5,0(a1)
  st->ino = ip->inum;
    80003e0a:	415c                	lw	a5,4(a0)
    80003e0c:	c1dc                	sw	a5,4(a1)
  st->type = ip->type;
    80003e0e:	04451783          	lh	a5,68(a0)
    80003e12:	00f59423          	sh	a5,8(a1)
  st->nlink = ip->nlink;
    80003e16:	04a51783          	lh	a5,74(a0)
    80003e1a:	00f59523          	sh	a5,10(a1)
  st->size = ip->size;
    80003e1e:	04c56783          	lwu	a5,76(a0)
    80003e22:	e99c                	sd	a5,16(a1)
}
    80003e24:	60a2                	ld	ra,8(sp)
    80003e26:	6402                	ld	s0,0(sp)
    80003e28:	0141                	addi	sp,sp,16
    80003e2a:	8082                	ret

0000000080003e2c <readi>:
readi(struct inode *ip, int user_dst, uint64 dst, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    80003e2c:	457c                	lw	a5,76(a0)
    80003e2e:	0ed7e663          	bltu	a5,a3,80003f1a <readi+0xee>
{
    80003e32:	7159                	addi	sp,sp,-112
    80003e34:	f486                	sd	ra,104(sp)
    80003e36:	f0a2                	sd	s0,96(sp)
    80003e38:	eca6                	sd	s1,88(sp)
    80003e3a:	e0d2                	sd	s4,64(sp)
    80003e3c:	fc56                	sd	s5,56(sp)
    80003e3e:	f85a                	sd	s6,48(sp)
    80003e40:	f45e                	sd	s7,40(sp)
    80003e42:	1880                	addi	s0,sp,112
    80003e44:	8b2a                	mv	s6,a0
    80003e46:	8bae                	mv	s7,a1
    80003e48:	8a32                	mv	s4,a2
    80003e4a:	84b6                	mv	s1,a3
    80003e4c:	8aba                	mv	s5,a4
  if(off > ip->size || off + n < off)
    80003e4e:	9f35                	addw	a4,a4,a3
    return 0;
    80003e50:	4501                	li	a0,0
  if(off > ip->size || off + n < off)
    80003e52:	0ad76b63          	bltu	a4,a3,80003f08 <readi+0xdc>
    80003e56:	e4ce                	sd	s3,72(sp)
  if(off + n > ip->size)
    80003e58:	00e7f463          	bgeu	a5,a4,80003e60 <readi+0x34>
    n = ip->size - off;
    80003e5c:	40d78abb          	subw	s5,a5,a3

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80003e60:	080a8b63          	beqz	s5,80003ef6 <readi+0xca>
    80003e64:	e8ca                	sd	s2,80(sp)
    80003e66:	f062                	sd	s8,32(sp)
    80003e68:	ec66                	sd	s9,24(sp)
    80003e6a:	e86a                	sd	s10,16(sp)
    80003e6c:	e46e                	sd	s11,8(sp)
    80003e6e:	4981                	li	s3,0
    uint addr = bmap(ip, off/BSIZE);
    if(addr == 0)
      break;
    bp = bread(ip->dev, addr);
    m = min(n - tot, BSIZE - off%BSIZE);
    80003e70:	40000c93          	li	s9,1024
    if(either_copyout(user_dst, dst, bp->data + (off % BSIZE), m) == -1) {
    80003e74:	5c7d                	li	s8,-1
    80003e76:	a80d                	j	80003ea8 <readi+0x7c>
    80003e78:	020d1d93          	slli	s11,s10,0x20
    80003e7c:	020ddd93          	srli	s11,s11,0x20
    80003e80:	05890613          	addi	a2,s2,88
    80003e84:	86ee                	mv	a3,s11
    80003e86:	963e                	add	a2,a2,a5
    80003e88:	85d2                	mv	a1,s4
    80003e8a:	855e                	mv	a0,s7
    80003e8c:	b5ffe0ef          	jal	800029ea <either_copyout>
    80003e90:	05850363          	beq	a0,s8,80003ed6 <readi+0xaa>
      brelse(bp);
      tot = -1;
      break;
    }
    brelse(bp);
    80003e94:	854a                	mv	a0,s2
    80003e96:	e74ff0ef          	jal	8000350a <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80003e9a:	013d09bb          	addw	s3,s10,s3
    80003e9e:	009d04bb          	addw	s1,s10,s1
    80003ea2:	9a6e                	add	s4,s4,s11
    80003ea4:	0559f363          	bgeu	s3,s5,80003eea <readi+0xbe>
    uint addr = bmap(ip, off/BSIZE);
    80003ea8:	00a4d59b          	srliw	a1,s1,0xa
    80003eac:	855a                	mv	a0,s6
    80003eae:	8bbff0ef          	jal	80003768 <bmap>
    80003eb2:	85aa                	mv	a1,a0
    if(addr == 0)
    80003eb4:	c139                	beqz	a0,80003efa <readi+0xce>
    bp = bread(ip->dev, addr);
    80003eb6:	000b2503          	lw	a0,0(s6)
    80003eba:	d48ff0ef          	jal	80003402 <bread>
    80003ebe:	892a                	mv	s2,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    80003ec0:	3ff4f793          	andi	a5,s1,1023
    80003ec4:	40fc873b          	subw	a4,s9,a5
    80003ec8:	413a86bb          	subw	a3,s5,s3
    80003ecc:	8d3a                	mv	s10,a4
    80003ece:	fae6f5e3          	bgeu	a3,a4,80003e78 <readi+0x4c>
    80003ed2:	8d36                	mv	s10,a3
    80003ed4:	b755                	j	80003e78 <readi+0x4c>
      brelse(bp);
    80003ed6:	854a                	mv	a0,s2
    80003ed8:	e32ff0ef          	jal	8000350a <brelse>
      tot = -1;
    80003edc:	59fd                	li	s3,-1
      break;
    80003ede:	6946                	ld	s2,80(sp)
    80003ee0:	7c02                	ld	s8,32(sp)
    80003ee2:	6ce2                	ld	s9,24(sp)
    80003ee4:	6d42                	ld	s10,16(sp)
    80003ee6:	6da2                	ld	s11,8(sp)
    80003ee8:	a831                	j	80003f04 <readi+0xd8>
    80003eea:	6946                	ld	s2,80(sp)
    80003eec:	7c02                	ld	s8,32(sp)
    80003eee:	6ce2                	ld	s9,24(sp)
    80003ef0:	6d42                	ld	s10,16(sp)
    80003ef2:	6da2                	ld	s11,8(sp)
    80003ef4:	a801                	j	80003f04 <readi+0xd8>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80003ef6:	89d6                	mv	s3,s5
    80003ef8:	a031                	j	80003f04 <readi+0xd8>
    80003efa:	6946                	ld	s2,80(sp)
    80003efc:	7c02                	ld	s8,32(sp)
    80003efe:	6ce2                	ld	s9,24(sp)
    80003f00:	6d42                	ld	s10,16(sp)
    80003f02:	6da2                	ld	s11,8(sp)
  }
  return tot;
    80003f04:	854e                	mv	a0,s3
    80003f06:	69a6                	ld	s3,72(sp)
}
    80003f08:	70a6                	ld	ra,104(sp)
    80003f0a:	7406                	ld	s0,96(sp)
    80003f0c:	64e6                	ld	s1,88(sp)
    80003f0e:	6a06                	ld	s4,64(sp)
    80003f10:	7ae2                	ld	s5,56(sp)
    80003f12:	7b42                	ld	s6,48(sp)
    80003f14:	7ba2                	ld	s7,40(sp)
    80003f16:	6165                	addi	sp,sp,112
    80003f18:	8082                	ret
    return 0;
    80003f1a:	4501                	li	a0,0
}
    80003f1c:	8082                	ret

0000000080003f1e <writei>:
writei(struct inode *ip, int user_src, uint64 src, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    80003f1e:	457c                	lw	a5,76(a0)
    80003f20:	0ed7eb63          	bltu	a5,a3,80004016 <writei+0xf8>
{
    80003f24:	7159                	addi	sp,sp,-112
    80003f26:	f486                	sd	ra,104(sp)
    80003f28:	f0a2                	sd	s0,96(sp)
    80003f2a:	e8ca                	sd	s2,80(sp)
    80003f2c:	e0d2                	sd	s4,64(sp)
    80003f2e:	fc56                	sd	s5,56(sp)
    80003f30:	f85a                	sd	s6,48(sp)
    80003f32:	f45e                	sd	s7,40(sp)
    80003f34:	1880                	addi	s0,sp,112
    80003f36:	8aaa                	mv	s5,a0
    80003f38:	8bae                	mv	s7,a1
    80003f3a:	8a32                	mv	s4,a2
    80003f3c:	8936                	mv	s2,a3
    80003f3e:	8b3a                	mv	s6,a4
  if(off > ip->size || off + n < off)
    80003f40:	00e687bb          	addw	a5,a3,a4
    return -1;
  if(off + n > MAXFILE*BSIZE){
    80003f44:	00043737          	lui	a4,0x43
    80003f48:	0cf76963          	bltu	a4,a5,8000401a <writei+0xfc>
    80003f4c:	0cd7e763          	bltu	a5,a3,8000401a <writei+0xfc>
    80003f50:	e4ce                	sd	s3,72(sp)
    return -1;
  }
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80003f52:	0a0b0a63          	beqz	s6,80004006 <writei+0xe8>
    80003f56:	eca6                	sd	s1,88(sp)
    80003f58:	f062                	sd	s8,32(sp)
    80003f5a:	ec66                	sd	s9,24(sp)
    80003f5c:	e86a                	sd	s10,16(sp)
    80003f5e:	e46e                	sd	s11,8(sp)
    80003f60:	4981                	li	s3,0
    uint addr = bmap(ip, off/BSIZE);
    if(addr == 0)
      break;
    bp = bread(ip->dev, addr);
    m = min(n - tot, BSIZE - off%BSIZE);
    80003f62:	40000c93          	li	s9,1024
    if(either_copyin(bp->data + (off % BSIZE), user_src, src, m) == -1) {
    80003f66:	5c7d                	li	s8,-1
    80003f68:	a825                	j	80003fa0 <writei+0x82>
    80003f6a:	020d1d93          	slli	s11,s10,0x20
    80003f6e:	020ddd93          	srli	s11,s11,0x20
    80003f72:	05848513          	addi	a0,s1,88
    80003f76:	86ee                	mv	a3,s11
    80003f78:	8652                	mv	a2,s4
    80003f7a:	85de                	mv	a1,s7
    80003f7c:	953e                	add	a0,a0,a5
    80003f7e:	ab7fe0ef          	jal	80002a34 <either_copyin>
    80003f82:	05850663          	beq	a0,s8,80003fce <writei+0xb0>
      brelse(bp);
      break;
    }
    log_write(bp);
    80003f86:	8526                	mv	a0,s1
    80003f88:	6b8000ef          	jal	80004640 <log_write>
    brelse(bp);
    80003f8c:	8526                	mv	a0,s1
    80003f8e:	d7cff0ef          	jal	8000350a <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80003f92:	013d09bb          	addw	s3,s10,s3
    80003f96:	012d093b          	addw	s2,s10,s2
    80003f9a:	9a6e                	add	s4,s4,s11
    80003f9c:	0369fc63          	bgeu	s3,s6,80003fd4 <writei+0xb6>
    uint addr = bmap(ip, off/BSIZE);
    80003fa0:	00a9559b          	srliw	a1,s2,0xa
    80003fa4:	8556                	mv	a0,s5
    80003fa6:	fc2ff0ef          	jal	80003768 <bmap>
    80003faa:	85aa                	mv	a1,a0
    if(addr == 0)
    80003fac:	c505                	beqz	a0,80003fd4 <writei+0xb6>
    bp = bread(ip->dev, addr);
    80003fae:	000aa503          	lw	a0,0(s5)
    80003fb2:	c50ff0ef          	jal	80003402 <bread>
    80003fb6:	84aa                	mv	s1,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    80003fb8:	3ff97793          	andi	a5,s2,1023
    80003fbc:	40fc873b          	subw	a4,s9,a5
    80003fc0:	413b06bb          	subw	a3,s6,s3
    80003fc4:	8d3a                	mv	s10,a4
    80003fc6:	fae6f2e3          	bgeu	a3,a4,80003f6a <writei+0x4c>
    80003fca:	8d36                	mv	s10,a3
    80003fcc:	bf79                	j	80003f6a <writei+0x4c>
      brelse(bp);
    80003fce:	8526                	mv	a0,s1
    80003fd0:	d3aff0ef          	jal	8000350a <brelse>
  }

  if(off > ip->size)
    80003fd4:	04caa783          	lw	a5,76(s5)
    80003fd8:	0327f963          	bgeu	a5,s2,8000400a <writei+0xec>
    ip->size = off;
    80003fdc:	052aa623          	sw	s2,76(s5)
    80003fe0:	64e6                	ld	s1,88(sp)
    80003fe2:	7c02                	ld	s8,32(sp)
    80003fe4:	6ce2                	ld	s9,24(sp)
    80003fe6:	6d42                	ld	s10,16(sp)
    80003fe8:	6da2                	ld	s11,8(sp)

  // write the i-node back to disk even if the size didn't change
  // because the loop above might have called bmap() and added a new
  // block to ip->addrs[].
  iupdate(ip);
    80003fea:	8556                	mv	a0,s5
    80003fec:	9fbff0ef          	jal	800039e6 <iupdate>

  return tot;
    80003ff0:	854e                	mv	a0,s3
    80003ff2:	69a6                	ld	s3,72(sp)
}
    80003ff4:	70a6                	ld	ra,104(sp)
    80003ff6:	7406                	ld	s0,96(sp)
    80003ff8:	6946                	ld	s2,80(sp)
    80003ffa:	6a06                	ld	s4,64(sp)
    80003ffc:	7ae2                	ld	s5,56(sp)
    80003ffe:	7b42                	ld	s6,48(sp)
    80004000:	7ba2                	ld	s7,40(sp)
    80004002:	6165                	addi	sp,sp,112
    80004004:	8082                	ret
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80004006:	89da                	mv	s3,s6
    80004008:	b7cd                	j	80003fea <writei+0xcc>
    8000400a:	64e6                	ld	s1,88(sp)
    8000400c:	7c02                	ld	s8,32(sp)
    8000400e:	6ce2                	ld	s9,24(sp)
    80004010:	6d42                	ld	s10,16(sp)
    80004012:	6da2                	ld	s11,8(sp)
    80004014:	bfd9                	j	80003fea <writei+0xcc>
    return -1;
    80004016:	557d                	li	a0,-1
}
    80004018:	8082                	ret
    return -1;
    8000401a:	557d                	li	a0,-1
    8000401c:	bfe1                	j	80003ff4 <writei+0xd6>

000000008000401e <namecmp>:

// Directories

int
namecmp(const char *s, const char *t)
{
    8000401e:	1141                	addi	sp,sp,-16
    80004020:	e406                	sd	ra,8(sp)
    80004022:	e022                	sd	s0,0(sp)
    80004024:	0800                	addi	s0,sp,16
  return strncmp(s, t, DIRSIZ);
    80004026:	4639                	li	a2,14
    80004028:	da5fc0ef          	jal	80000dcc <strncmp>
}
    8000402c:	60a2                	ld	ra,8(sp)
    8000402e:	6402                	ld	s0,0(sp)
    80004030:	0141                	addi	sp,sp,16
    80004032:	8082                	ret

0000000080004034 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
    80004034:	711d                	addi	sp,sp,-96
    80004036:	ec86                	sd	ra,88(sp)
    80004038:	e8a2                	sd	s0,80(sp)
    8000403a:	e4a6                	sd	s1,72(sp)
    8000403c:	e0ca                	sd	s2,64(sp)
    8000403e:	fc4e                	sd	s3,56(sp)
    80004040:	f852                	sd	s4,48(sp)
    80004042:	f456                	sd	s5,40(sp)
    80004044:	f05a                	sd	s6,32(sp)
    80004046:	ec5e                	sd	s7,24(sp)
    80004048:	1080                	addi	s0,sp,96
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
    8000404a:	04451703          	lh	a4,68(a0)
    8000404e:	4785                	li	a5,1
    80004050:	00f71f63          	bne	a4,a5,8000406e <dirlookup+0x3a>
    80004054:	892a                	mv	s2,a0
    80004056:	8aae                	mv	s5,a1
    80004058:	8bb2                	mv	s7,a2
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
    8000405a:	457c                	lw	a5,76(a0)
    8000405c:	4481                	li	s1,0
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    8000405e:	fa040a13          	addi	s4,s0,-96
    80004062:	49c1                	li	s3,16
      panic("dirlookup read");
    if(de.inum == 0)
      continue;
    if(namecmp(name, de.name) == 0){
    80004064:	fa240b13          	addi	s6,s0,-94
      inum = de.inum;
      return iget(dp->dev, inum);
    }
  }

  return 0;
    80004068:	4501                	li	a0,0
  for(off = 0; off < dp->size; off += sizeof(de)){
    8000406a:	e39d                	bnez	a5,80004090 <dirlookup+0x5c>
    8000406c:	a8b9                	j	800040ca <dirlookup+0x96>
    panic("dirlookup not DIR");
    8000406e:	00004517          	auipc	a0,0x4
    80004072:	70250513          	addi	a0,a0,1794 # 80008770 <etext+0x770>
    80004076:	faefc0ef          	jal	80000824 <panic>
      panic("dirlookup read");
    8000407a:	00004517          	auipc	a0,0x4
    8000407e:	70e50513          	addi	a0,a0,1806 # 80008788 <etext+0x788>
    80004082:	fa2fc0ef          	jal	80000824 <panic>
  for(off = 0; off < dp->size; off += sizeof(de)){
    80004086:	24c1                	addiw	s1,s1,16
    80004088:	04c92783          	lw	a5,76(s2)
    8000408c:	02f4fe63          	bgeu	s1,a5,800040c8 <dirlookup+0x94>
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80004090:	874e                	mv	a4,s3
    80004092:	86a6                	mv	a3,s1
    80004094:	8652                	mv	a2,s4
    80004096:	4581                	li	a1,0
    80004098:	854a                	mv	a0,s2
    8000409a:	d93ff0ef          	jal	80003e2c <readi>
    8000409e:	fd351ee3          	bne	a0,s3,8000407a <dirlookup+0x46>
    if(de.inum == 0)
    800040a2:	fa045783          	lhu	a5,-96(s0)
    800040a6:	d3e5                	beqz	a5,80004086 <dirlookup+0x52>
    if(namecmp(name, de.name) == 0){
    800040a8:	85da                	mv	a1,s6
    800040aa:	8556                	mv	a0,s5
    800040ac:	f73ff0ef          	jal	8000401e <namecmp>
    800040b0:	f979                	bnez	a0,80004086 <dirlookup+0x52>
      if(poff)
    800040b2:	000b8463          	beqz	s7,800040ba <dirlookup+0x86>
        *poff = off;
    800040b6:	009ba023          	sw	s1,0(s7)
      return iget(dp->dev, inum);
    800040ba:	fa045583          	lhu	a1,-96(s0)
    800040be:	00092503          	lw	a0,0(s2)
    800040c2:	f66ff0ef          	jal	80003828 <iget>
    800040c6:	a011                	j	800040ca <dirlookup+0x96>
  return 0;
    800040c8:	4501                	li	a0,0
}
    800040ca:	60e6                	ld	ra,88(sp)
    800040cc:	6446                	ld	s0,80(sp)
    800040ce:	64a6                	ld	s1,72(sp)
    800040d0:	6906                	ld	s2,64(sp)
    800040d2:	79e2                	ld	s3,56(sp)
    800040d4:	7a42                	ld	s4,48(sp)
    800040d6:	7aa2                	ld	s5,40(sp)
    800040d8:	7b02                	ld	s6,32(sp)
    800040da:	6be2                	ld	s7,24(sp)
    800040dc:	6125                	addi	sp,sp,96
    800040de:	8082                	ret

00000000800040e0 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
    800040e0:	711d                	addi	sp,sp,-96
    800040e2:	ec86                	sd	ra,88(sp)
    800040e4:	e8a2                	sd	s0,80(sp)
    800040e6:	e4a6                	sd	s1,72(sp)
    800040e8:	e0ca                	sd	s2,64(sp)
    800040ea:	fc4e                	sd	s3,56(sp)
    800040ec:	f852                	sd	s4,48(sp)
    800040ee:	f456                	sd	s5,40(sp)
    800040f0:	f05a                	sd	s6,32(sp)
    800040f2:	ec5e                	sd	s7,24(sp)
    800040f4:	e862                	sd	s8,16(sp)
    800040f6:	e466                	sd	s9,8(sp)
    800040f8:	e06a                	sd	s10,0(sp)
    800040fa:	1080                	addi	s0,sp,96
    800040fc:	84aa                	mv	s1,a0
    800040fe:	8b2e                	mv	s6,a1
    80004100:	8ab2                	mv	s5,a2
  struct inode *ip, *next;

  if(*path == '/')
    80004102:	00054703          	lbu	a4,0(a0)
    80004106:	02f00793          	li	a5,47
    8000410a:	00f70f63          	beq	a4,a5,80004128 <namex+0x48>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
    8000410e:	e19fd0ef          	jal	80001f26 <myproc>
    80004112:	15053503          	ld	a0,336(a0)
    80004116:	94fff0ef          	jal	80003a64 <idup>
    8000411a:	8a2a                	mv	s4,a0
  while(*path == '/')
    8000411c:	02f00993          	li	s3,47
  if(len >= DIRSIZ)
    80004120:	4c35                	li	s8,13
    memmove(name, s, DIRSIZ);
    80004122:	4cb9                	li	s9,14

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
    if(ip->type != T_DIR){
    80004124:	4b85                	li	s7,1
    80004126:	a879                	j	800041c4 <namex+0xe4>
    ip = iget(ROOTDEV, ROOTINO);
    80004128:	4585                	li	a1,1
    8000412a:	852e                	mv	a0,a1
    8000412c:	efcff0ef          	jal	80003828 <iget>
    80004130:	8a2a                	mv	s4,a0
    80004132:	b7ed                	j	8000411c <namex+0x3c>
      iunlockput(ip);
    80004134:	8552                	mv	a0,s4
    80004136:	b71ff0ef          	jal	80003ca6 <iunlockput>
      return 0;
    8000413a:	4a01                	li	s4,0
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}
    8000413c:	8552                	mv	a0,s4
    8000413e:	60e6                	ld	ra,88(sp)
    80004140:	6446                	ld	s0,80(sp)
    80004142:	64a6                	ld	s1,72(sp)
    80004144:	6906                	ld	s2,64(sp)
    80004146:	79e2                	ld	s3,56(sp)
    80004148:	7a42                	ld	s4,48(sp)
    8000414a:	7aa2                	ld	s5,40(sp)
    8000414c:	7b02                	ld	s6,32(sp)
    8000414e:	6be2                	ld	s7,24(sp)
    80004150:	6c42                	ld	s8,16(sp)
    80004152:	6ca2                	ld	s9,8(sp)
    80004154:	6d02                	ld	s10,0(sp)
    80004156:	6125                	addi	sp,sp,96
    80004158:	8082                	ret
      iunlock(ip);
    8000415a:	8552                	mv	a0,s4
    8000415c:	9edff0ef          	jal	80003b48 <iunlock>
      return ip;
    80004160:	bff1                	j	8000413c <namex+0x5c>
      iunlockput(ip);
    80004162:	8552                	mv	a0,s4
    80004164:	b43ff0ef          	jal	80003ca6 <iunlockput>
      return 0;
    80004168:	8a4a                	mv	s4,s2
    8000416a:	bfc9                	j	8000413c <namex+0x5c>
  len = path - s;
    8000416c:	40990633          	sub	a2,s2,s1
    80004170:	00060d1b          	sext.w	s10,a2
  if(len >= DIRSIZ)
    80004174:	09ac5463          	bge	s8,s10,800041fc <namex+0x11c>
    memmove(name, s, DIRSIZ);
    80004178:	8666                	mv	a2,s9
    8000417a:	85a6                	mv	a1,s1
    8000417c:	8556                	mv	a0,s5
    8000417e:	bdbfc0ef          	jal	80000d58 <memmove>
    80004182:	84ca                	mv	s1,s2
  while(*path == '/')
    80004184:	0004c783          	lbu	a5,0(s1)
    80004188:	01379763          	bne	a5,s3,80004196 <namex+0xb6>
    path++;
    8000418c:	0485                	addi	s1,s1,1
  while(*path == '/')
    8000418e:	0004c783          	lbu	a5,0(s1)
    80004192:	ff378de3          	beq	a5,s3,8000418c <namex+0xac>
    ilock(ip);
    80004196:	8552                	mv	a0,s4
    80004198:	903ff0ef          	jal	80003a9a <ilock>
    if(ip->type != T_DIR){
    8000419c:	044a1783          	lh	a5,68(s4)
    800041a0:	f9779ae3          	bne	a5,s7,80004134 <namex+0x54>
    if(nameiparent && *path == '\0'){
    800041a4:	000b0563          	beqz	s6,800041ae <namex+0xce>
    800041a8:	0004c783          	lbu	a5,0(s1)
    800041ac:	d7dd                	beqz	a5,8000415a <namex+0x7a>
    if((next = dirlookup(ip, name, 0)) == 0){
    800041ae:	4601                	li	a2,0
    800041b0:	85d6                	mv	a1,s5
    800041b2:	8552                	mv	a0,s4
    800041b4:	e81ff0ef          	jal	80004034 <dirlookup>
    800041b8:	892a                	mv	s2,a0
    800041ba:	d545                	beqz	a0,80004162 <namex+0x82>
    iunlockput(ip);
    800041bc:	8552                	mv	a0,s4
    800041be:	ae9ff0ef          	jal	80003ca6 <iunlockput>
    ip = next;
    800041c2:	8a4a                	mv	s4,s2
  while(*path == '/')
    800041c4:	0004c783          	lbu	a5,0(s1)
    800041c8:	01379763          	bne	a5,s3,800041d6 <namex+0xf6>
    path++;
    800041cc:	0485                	addi	s1,s1,1
  while(*path == '/')
    800041ce:	0004c783          	lbu	a5,0(s1)
    800041d2:	ff378de3          	beq	a5,s3,800041cc <namex+0xec>
  if(*path == 0)
    800041d6:	cf8d                	beqz	a5,80004210 <namex+0x130>
  while(*path != '/' && *path != 0)
    800041d8:	0004c783          	lbu	a5,0(s1)
    800041dc:	fd178713          	addi	a4,a5,-47
    800041e0:	cb19                	beqz	a4,800041f6 <namex+0x116>
    800041e2:	cb91                	beqz	a5,800041f6 <namex+0x116>
    800041e4:	8926                	mv	s2,s1
    path++;
    800041e6:	0905                	addi	s2,s2,1
  while(*path != '/' && *path != 0)
    800041e8:	00094783          	lbu	a5,0(s2)
    800041ec:	fd178713          	addi	a4,a5,-47
    800041f0:	df35                	beqz	a4,8000416c <namex+0x8c>
    800041f2:	fbf5                	bnez	a5,800041e6 <namex+0x106>
    800041f4:	bfa5                	j	8000416c <namex+0x8c>
    800041f6:	8926                	mv	s2,s1
  len = path - s;
    800041f8:	4d01                	li	s10,0
    800041fa:	4601                	li	a2,0
    memmove(name, s, len);
    800041fc:	2601                	sext.w	a2,a2
    800041fe:	85a6                	mv	a1,s1
    80004200:	8556                	mv	a0,s5
    80004202:	b57fc0ef          	jal	80000d58 <memmove>
    name[len] = 0;
    80004206:	9d56                	add	s10,s10,s5
    80004208:	000d0023          	sb	zero,0(s10) # fffffffffffff000 <end+0xffffffff7dd98b28>
    8000420c:	84ca                	mv	s1,s2
    8000420e:	bf9d                	j	80004184 <namex+0xa4>
  if(nameiparent){
    80004210:	f20b06e3          	beqz	s6,8000413c <namex+0x5c>
    iput(ip);
    80004214:	8552                	mv	a0,s4
    80004216:	a07ff0ef          	jal	80003c1c <iput>
    return 0;
    8000421a:	4a01                	li	s4,0
    8000421c:	b705                	j	8000413c <namex+0x5c>

000000008000421e <dirlink>:
{
    8000421e:	715d                	addi	sp,sp,-80
    80004220:	e486                	sd	ra,72(sp)
    80004222:	e0a2                	sd	s0,64(sp)
    80004224:	f84a                	sd	s2,48(sp)
    80004226:	ec56                	sd	s5,24(sp)
    80004228:	e85a                	sd	s6,16(sp)
    8000422a:	0880                	addi	s0,sp,80
    8000422c:	892a                	mv	s2,a0
    8000422e:	8aae                	mv	s5,a1
    80004230:	8b32                	mv	s6,a2
  if((ip = dirlookup(dp, name, 0)) != 0){
    80004232:	4601                	li	a2,0
    80004234:	e01ff0ef          	jal	80004034 <dirlookup>
    80004238:	ed1d                	bnez	a0,80004276 <dirlink+0x58>
    8000423a:	fc26                	sd	s1,56(sp)
  for(off = 0; off < dp->size; off += sizeof(de)){
    8000423c:	04c92483          	lw	s1,76(s2)
    80004240:	c4b9                	beqz	s1,8000428e <dirlink+0x70>
    80004242:	f44e                	sd	s3,40(sp)
    80004244:	f052                	sd	s4,32(sp)
    80004246:	4481                	li	s1,0
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80004248:	fb040a13          	addi	s4,s0,-80
    8000424c:	49c1                	li	s3,16
    8000424e:	874e                	mv	a4,s3
    80004250:	86a6                	mv	a3,s1
    80004252:	8652                	mv	a2,s4
    80004254:	4581                	li	a1,0
    80004256:	854a                	mv	a0,s2
    80004258:	bd5ff0ef          	jal	80003e2c <readi>
    8000425c:	03351163          	bne	a0,s3,8000427e <dirlink+0x60>
    if(de.inum == 0)
    80004260:	fb045783          	lhu	a5,-80(s0)
    80004264:	c39d                	beqz	a5,8000428a <dirlink+0x6c>
  for(off = 0; off < dp->size; off += sizeof(de)){
    80004266:	24c1                	addiw	s1,s1,16
    80004268:	04c92783          	lw	a5,76(s2)
    8000426c:	fef4e1e3          	bltu	s1,a5,8000424e <dirlink+0x30>
    80004270:	79a2                	ld	s3,40(sp)
    80004272:	7a02                	ld	s4,32(sp)
    80004274:	a829                	j	8000428e <dirlink+0x70>
    iput(ip);
    80004276:	9a7ff0ef          	jal	80003c1c <iput>
    return -1;
    8000427a:	557d                	li	a0,-1
    8000427c:	a83d                	j	800042ba <dirlink+0x9c>
      panic("dirlink read");
    8000427e:	00004517          	auipc	a0,0x4
    80004282:	51a50513          	addi	a0,a0,1306 # 80008798 <etext+0x798>
    80004286:	d9efc0ef          	jal	80000824 <panic>
    8000428a:	79a2                	ld	s3,40(sp)
    8000428c:	7a02                	ld	s4,32(sp)
  strncpy(de.name, name, DIRSIZ);
    8000428e:	4639                	li	a2,14
    80004290:	85d6                	mv	a1,s5
    80004292:	fb240513          	addi	a0,s0,-78
    80004296:	b71fc0ef          	jal	80000e06 <strncpy>
  de.inum = inum;
    8000429a:	fb641823          	sh	s6,-80(s0)
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    8000429e:	4741                	li	a4,16
    800042a0:	86a6                	mv	a3,s1
    800042a2:	fb040613          	addi	a2,s0,-80
    800042a6:	4581                	li	a1,0
    800042a8:	854a                	mv	a0,s2
    800042aa:	c75ff0ef          	jal	80003f1e <writei>
    800042ae:	1541                	addi	a0,a0,-16
    800042b0:	00a03533          	snez	a0,a0
    800042b4:	40a0053b          	negw	a0,a0
    800042b8:	74e2                	ld	s1,56(sp)
}
    800042ba:	60a6                	ld	ra,72(sp)
    800042bc:	6406                	ld	s0,64(sp)
    800042be:	7942                	ld	s2,48(sp)
    800042c0:	6ae2                	ld	s5,24(sp)
    800042c2:	6b42                	ld	s6,16(sp)
    800042c4:	6161                	addi	sp,sp,80
    800042c6:	8082                	ret

00000000800042c8 <namei>:

struct inode*
namei(char *path)
{
    800042c8:	1101                	addi	sp,sp,-32
    800042ca:	ec06                	sd	ra,24(sp)
    800042cc:	e822                	sd	s0,16(sp)
    800042ce:	1000                	addi	s0,sp,32
  char name[DIRSIZ];
  return namex(path, 0, name);
    800042d0:	fe040613          	addi	a2,s0,-32
    800042d4:	4581                	li	a1,0
    800042d6:	e0bff0ef          	jal	800040e0 <namex>
}
    800042da:	60e2                	ld	ra,24(sp)
    800042dc:	6442                	ld	s0,16(sp)
    800042de:	6105                	addi	sp,sp,32
    800042e0:	8082                	ret

00000000800042e2 <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
    800042e2:	1141                	addi	sp,sp,-16
    800042e4:	e406                	sd	ra,8(sp)
    800042e6:	e022                	sd	s0,0(sp)
    800042e8:	0800                	addi	s0,sp,16
    800042ea:	862e                	mv	a2,a1
  return namex(path, 1, name);
    800042ec:	4585                	li	a1,1
    800042ee:	df3ff0ef          	jal	800040e0 <namex>
}
    800042f2:	60a2                	ld	ra,8(sp)
    800042f4:	6402                	ld	s0,0(sp)
    800042f6:	0141                	addi	sp,sp,16
    800042f8:	8082                	ret

00000000800042fa <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
    800042fa:	1101                	addi	sp,sp,-32
    800042fc:	ec06                	sd	ra,24(sp)
    800042fe:	e822                	sd	s0,16(sp)
    80004300:	e426                	sd	s1,8(sp)
    80004302:	e04a                	sd	s2,0(sp)
    80004304:	1000                	addi	s0,sp,32
  struct buf *buf = bread(log.dev, log.start);
    80004306:	02261917          	auipc	s2,0x2261
    8000430a:	f9290913          	addi	s2,s2,-110 # 82265298 <log>
    8000430e:	01892583          	lw	a1,24(s2)
    80004312:	02492503          	lw	a0,36(s2)
    80004316:	8ecff0ef          	jal	80003402 <bread>
    8000431a:	84aa                	mv	s1,a0
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
    8000431c:	02892603          	lw	a2,40(s2)
    80004320:	cd30                	sw	a2,88(a0)
  for (i = 0; i < log.lh.n; i++) {
    80004322:	00c05f63          	blez	a2,80004340 <write_head+0x46>
    80004326:	02261717          	auipc	a4,0x2261
    8000432a:	f9e70713          	addi	a4,a4,-98 # 822652c4 <log+0x2c>
    8000432e:	87aa                	mv	a5,a0
    80004330:	060a                	slli	a2,a2,0x2
    80004332:	962a                	add	a2,a2,a0
    hb->block[i] = log.lh.block[i];
    80004334:	4314                	lw	a3,0(a4)
    80004336:	cff4                	sw	a3,92(a5)
  for (i = 0; i < log.lh.n; i++) {
    80004338:	0711                	addi	a4,a4,4
    8000433a:	0791                	addi	a5,a5,4
    8000433c:	fec79ce3          	bne	a5,a2,80004334 <write_head+0x3a>
  }
  bwrite(buf);
    80004340:	8526                	mv	a0,s1
    80004342:	996ff0ef          	jal	800034d8 <bwrite>
  brelse(buf);
    80004346:	8526                	mv	a0,s1
    80004348:	9c2ff0ef          	jal	8000350a <brelse>
}
    8000434c:	60e2                	ld	ra,24(sp)
    8000434e:	6442                	ld	s0,16(sp)
    80004350:	64a2                	ld	s1,8(sp)
    80004352:	6902                	ld	s2,0(sp)
    80004354:	6105                	addi	sp,sp,32
    80004356:	8082                	ret

0000000080004358 <install_trans>:
  for (tail = 0; tail < log.lh.n; tail++) {
    80004358:	02261797          	auipc	a5,0x2261
    8000435c:	f687a783          	lw	a5,-152(a5) # 822652c0 <log+0x28>
    80004360:	0cf05163          	blez	a5,80004422 <install_trans+0xca>
{
    80004364:	715d                	addi	sp,sp,-80
    80004366:	e486                	sd	ra,72(sp)
    80004368:	e0a2                	sd	s0,64(sp)
    8000436a:	fc26                	sd	s1,56(sp)
    8000436c:	f84a                	sd	s2,48(sp)
    8000436e:	f44e                	sd	s3,40(sp)
    80004370:	f052                	sd	s4,32(sp)
    80004372:	ec56                	sd	s5,24(sp)
    80004374:	e85a                	sd	s6,16(sp)
    80004376:	e45e                	sd	s7,8(sp)
    80004378:	e062                	sd	s8,0(sp)
    8000437a:	0880                	addi	s0,sp,80
    8000437c:	8b2a                	mv	s6,a0
    8000437e:	02261a97          	auipc	s5,0x2261
    80004382:	f46a8a93          	addi	s5,s5,-186 # 822652c4 <log+0x2c>
  for (tail = 0; tail < log.lh.n; tail++) {
    80004386:	4981                	li	s3,0
      printf("recovering tail %d dst %d\n", tail, log.lh.block[tail]);
    80004388:	00004c17          	auipc	s8,0x4
    8000438c:	420c0c13          	addi	s8,s8,1056 # 800087a8 <etext+0x7a8>
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    80004390:	02261a17          	auipc	s4,0x2261
    80004394:	f08a0a13          	addi	s4,s4,-248 # 82265298 <log>
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
    80004398:	40000b93          	li	s7,1024
    8000439c:	a025                	j	800043c4 <install_trans+0x6c>
      printf("recovering tail %d dst %d\n", tail, log.lh.block[tail]);
    8000439e:	000aa603          	lw	a2,0(s5)
    800043a2:	85ce                	mv	a1,s3
    800043a4:	8562                	mv	a0,s8
    800043a6:	954fc0ef          	jal	800004fa <printf>
    800043aa:	a839                	j	800043c8 <install_trans+0x70>
    brelse(lbuf);
    800043ac:	854a                	mv	a0,s2
    800043ae:	95cff0ef          	jal	8000350a <brelse>
    brelse(dbuf);
    800043b2:	8526                	mv	a0,s1
    800043b4:	956ff0ef          	jal	8000350a <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    800043b8:	2985                	addiw	s3,s3,1
    800043ba:	0a91                	addi	s5,s5,4
    800043bc:	028a2783          	lw	a5,40(s4)
    800043c0:	04f9d563          	bge	s3,a5,8000440a <install_trans+0xb2>
    if(recovering) {
    800043c4:	fc0b1de3          	bnez	s6,8000439e <install_trans+0x46>
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    800043c8:	018a2583          	lw	a1,24(s4)
    800043cc:	013585bb          	addw	a1,a1,s3
    800043d0:	2585                	addiw	a1,a1,1
    800043d2:	024a2503          	lw	a0,36(s4)
    800043d6:	82cff0ef          	jal	80003402 <bread>
    800043da:	892a                	mv	s2,a0
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
    800043dc:	000aa583          	lw	a1,0(s5)
    800043e0:	024a2503          	lw	a0,36(s4)
    800043e4:	81eff0ef          	jal	80003402 <bread>
    800043e8:	84aa                	mv	s1,a0
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
    800043ea:	865e                	mv	a2,s7
    800043ec:	05890593          	addi	a1,s2,88
    800043f0:	05850513          	addi	a0,a0,88
    800043f4:	965fc0ef          	jal	80000d58 <memmove>
    bwrite(dbuf);  // write dst to disk
    800043f8:	8526                	mv	a0,s1
    800043fa:	8deff0ef          	jal	800034d8 <bwrite>
    if(recovering == 0)
    800043fe:	fa0b17e3          	bnez	s6,800043ac <install_trans+0x54>
      bunpin(dbuf);
    80004402:	8526                	mv	a0,s1
    80004404:	9beff0ef          	jal	800035c2 <bunpin>
    80004408:	b755                	j	800043ac <install_trans+0x54>
}
    8000440a:	60a6                	ld	ra,72(sp)
    8000440c:	6406                	ld	s0,64(sp)
    8000440e:	74e2                	ld	s1,56(sp)
    80004410:	7942                	ld	s2,48(sp)
    80004412:	79a2                	ld	s3,40(sp)
    80004414:	7a02                	ld	s4,32(sp)
    80004416:	6ae2                	ld	s5,24(sp)
    80004418:	6b42                	ld	s6,16(sp)
    8000441a:	6ba2                	ld	s7,8(sp)
    8000441c:	6c02                	ld	s8,0(sp)
    8000441e:	6161                	addi	sp,sp,80
    80004420:	8082                	ret
    80004422:	8082                	ret

0000000080004424 <initlog>:
{
    80004424:	7179                	addi	sp,sp,-48
    80004426:	f406                	sd	ra,40(sp)
    80004428:	f022                	sd	s0,32(sp)
    8000442a:	ec26                	sd	s1,24(sp)
    8000442c:	e84a                	sd	s2,16(sp)
    8000442e:	e44e                	sd	s3,8(sp)
    80004430:	1800                	addi	s0,sp,48
    80004432:	84aa                	mv	s1,a0
    80004434:	89ae                	mv	s3,a1
  initlock(&log.lock, "log");
    80004436:	02261917          	auipc	s2,0x2261
    8000443a:	e6290913          	addi	s2,s2,-414 # 82265298 <log>
    8000443e:	00004597          	auipc	a1,0x4
    80004442:	38a58593          	addi	a1,a1,906 # 800087c8 <etext+0x7c8>
    80004446:	854a                	mv	a0,s2
    80004448:	f56fc0ef          	jal	80000b9e <initlock>
  log.start = sb->logstart;
    8000444c:	0149a583          	lw	a1,20(s3)
    80004450:	00b92c23          	sw	a1,24(s2)
  log.dev = dev;
    80004454:	02992223          	sw	s1,36(s2)
  struct buf *buf = bread(log.dev, log.start);
    80004458:	8526                	mv	a0,s1
    8000445a:	fa9fe0ef          	jal	80003402 <bread>
  log.lh.n = lh->n;
    8000445e:	4d30                	lw	a2,88(a0)
    80004460:	02c92423          	sw	a2,40(s2)
  for (i = 0; i < log.lh.n; i++) {
    80004464:	00c05f63          	blez	a2,80004482 <initlog+0x5e>
    80004468:	87aa                	mv	a5,a0
    8000446a:	02261717          	auipc	a4,0x2261
    8000446e:	e5a70713          	addi	a4,a4,-422 # 822652c4 <log+0x2c>
    80004472:	060a                	slli	a2,a2,0x2
    80004474:	962a                	add	a2,a2,a0
    log.lh.block[i] = lh->block[i];
    80004476:	4ff4                	lw	a3,92(a5)
    80004478:	c314                	sw	a3,0(a4)
  for (i = 0; i < log.lh.n; i++) {
    8000447a:	0791                	addi	a5,a5,4
    8000447c:	0711                	addi	a4,a4,4
    8000447e:	fec79ce3          	bne	a5,a2,80004476 <initlog+0x52>
  brelse(buf);
    80004482:	888ff0ef          	jal	8000350a <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(1); // if committed, copy from log to disk
    80004486:	4505                	li	a0,1
    80004488:	ed1ff0ef          	jal	80004358 <install_trans>
  log.lh.n = 0;
    8000448c:	02261797          	auipc	a5,0x2261
    80004490:	e207aa23          	sw	zero,-460(a5) # 822652c0 <log+0x28>
  write_head(); // clear the log
    80004494:	e67ff0ef          	jal	800042fa <write_head>
}
    80004498:	70a2                	ld	ra,40(sp)
    8000449a:	7402                	ld	s0,32(sp)
    8000449c:	64e2                	ld	s1,24(sp)
    8000449e:	6942                	ld	s2,16(sp)
    800044a0:	69a2                	ld	s3,8(sp)
    800044a2:	6145                	addi	sp,sp,48
    800044a4:	8082                	ret

00000000800044a6 <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
    800044a6:	1101                	addi	sp,sp,-32
    800044a8:	ec06                	sd	ra,24(sp)
    800044aa:	e822                	sd	s0,16(sp)
    800044ac:	e426                	sd	s1,8(sp)
    800044ae:	e04a                	sd	s2,0(sp)
    800044b0:	1000                	addi	s0,sp,32
  acquire(&log.lock);
    800044b2:	02261517          	auipc	a0,0x2261
    800044b6:	de650513          	addi	a0,a0,-538 # 82265298 <log>
    800044ba:	f6efc0ef          	jal	80000c28 <acquire>
  while(1){
    if(log.committing){
    800044be:	02261497          	auipc	s1,0x2261
    800044c2:	dda48493          	addi	s1,s1,-550 # 82265298 <log>
      sleep(&log, &log.lock);
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGBLOCKS){
    800044c6:	4979                	li	s2,30
    800044c8:	a029                	j	800044d2 <begin_op+0x2c>
      sleep(&log, &log.lock);
    800044ca:	85a6                	mv	a1,s1
    800044cc:	8526                	mv	a0,s1
    800044ce:	962fe0ef          	jal	80002630 <sleep>
    if(log.committing){
    800044d2:	509c                	lw	a5,32(s1)
    800044d4:	fbfd                	bnez	a5,800044ca <begin_op+0x24>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGBLOCKS){
    800044d6:	4cd8                	lw	a4,28(s1)
    800044d8:	2705                	addiw	a4,a4,1
    800044da:	0027179b          	slliw	a5,a4,0x2
    800044de:	9fb9                	addw	a5,a5,a4
    800044e0:	0017979b          	slliw	a5,a5,0x1
    800044e4:	5494                	lw	a3,40(s1)
    800044e6:	9fb5                	addw	a5,a5,a3
    800044e8:	00f95763          	bge	s2,a5,800044f6 <begin_op+0x50>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    800044ec:	85a6                	mv	a1,s1
    800044ee:	8526                	mv	a0,s1
    800044f0:	940fe0ef          	jal	80002630 <sleep>
    800044f4:	bff9                	j	800044d2 <begin_op+0x2c>
    } else {
      log.outstanding += 1;
    800044f6:	02261797          	auipc	a5,0x2261
    800044fa:	dae7af23          	sw	a4,-578(a5) # 822652b4 <log+0x1c>
      release(&log.lock);
    800044fe:	02261517          	auipc	a0,0x2261
    80004502:	d9a50513          	addi	a0,a0,-614 # 82265298 <log>
    80004506:	fb6fc0ef          	jal	80000cbc <release>
      break;
    }
  }
}
    8000450a:	60e2                	ld	ra,24(sp)
    8000450c:	6442                	ld	s0,16(sp)
    8000450e:	64a2                	ld	s1,8(sp)
    80004510:	6902                	ld	s2,0(sp)
    80004512:	6105                	addi	sp,sp,32
    80004514:	8082                	ret

0000000080004516 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
    80004516:	7139                	addi	sp,sp,-64
    80004518:	fc06                	sd	ra,56(sp)
    8000451a:	f822                	sd	s0,48(sp)
    8000451c:	f426                	sd	s1,40(sp)
    8000451e:	f04a                	sd	s2,32(sp)
    80004520:	0080                	addi	s0,sp,64
  int do_commit = 0;

  acquire(&log.lock);
    80004522:	02261497          	auipc	s1,0x2261
    80004526:	d7648493          	addi	s1,s1,-650 # 82265298 <log>
    8000452a:	8526                	mv	a0,s1
    8000452c:	efcfc0ef          	jal	80000c28 <acquire>
  log.outstanding -= 1;
    80004530:	4cdc                	lw	a5,28(s1)
    80004532:	37fd                	addiw	a5,a5,-1
    80004534:	893e                	mv	s2,a5
    80004536:	ccdc                	sw	a5,28(s1)
  if(log.committing)
    80004538:	509c                	lw	a5,32(s1)
    8000453a:	e7b1                	bnez	a5,80004586 <end_op+0x70>
    panic("log.committing");
  if(log.outstanding == 0){
    8000453c:	04091e63          	bnez	s2,80004598 <end_op+0x82>
    do_commit = 1;
    log.committing = 1;
    80004540:	02261497          	auipc	s1,0x2261
    80004544:	d5848493          	addi	s1,s1,-680 # 82265298 <log>
    80004548:	4785                	li	a5,1
    8000454a:	d09c                	sw	a5,32(s1)
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
    8000454c:	8526                	mv	a0,s1
    8000454e:	f6efc0ef          	jal	80000cbc <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
    80004552:	549c                	lw	a5,40(s1)
    80004554:	06f04463          	bgtz	a5,800045bc <end_op+0xa6>
    acquire(&log.lock);
    80004558:	02261517          	auipc	a0,0x2261
    8000455c:	d4050513          	addi	a0,a0,-704 # 82265298 <log>
    80004560:	ec8fc0ef          	jal	80000c28 <acquire>
    log.committing = 0;
    80004564:	02261797          	auipc	a5,0x2261
    80004568:	d407aa23          	sw	zero,-684(a5) # 822652b8 <log+0x20>
    wakeup(&log);
    8000456c:	02261517          	auipc	a0,0x2261
    80004570:	d2c50513          	addi	a0,a0,-724 # 82265298 <log>
    80004574:	908fe0ef          	jal	8000267c <wakeup>
    release(&log.lock);
    80004578:	02261517          	auipc	a0,0x2261
    8000457c:	d2050513          	addi	a0,a0,-736 # 82265298 <log>
    80004580:	f3cfc0ef          	jal	80000cbc <release>
}
    80004584:	a035                	j	800045b0 <end_op+0x9a>
    80004586:	ec4e                	sd	s3,24(sp)
    80004588:	e852                	sd	s4,16(sp)
    8000458a:	e456                	sd	s5,8(sp)
    panic("log.committing");
    8000458c:	00004517          	auipc	a0,0x4
    80004590:	24450513          	addi	a0,a0,580 # 800087d0 <etext+0x7d0>
    80004594:	a90fc0ef          	jal	80000824 <panic>
    wakeup(&log);
    80004598:	02261517          	auipc	a0,0x2261
    8000459c:	d0050513          	addi	a0,a0,-768 # 82265298 <log>
    800045a0:	8dcfe0ef          	jal	8000267c <wakeup>
  release(&log.lock);
    800045a4:	02261517          	auipc	a0,0x2261
    800045a8:	cf450513          	addi	a0,a0,-780 # 82265298 <log>
    800045ac:	f10fc0ef          	jal	80000cbc <release>
}
    800045b0:	70e2                	ld	ra,56(sp)
    800045b2:	7442                	ld	s0,48(sp)
    800045b4:	74a2                	ld	s1,40(sp)
    800045b6:	7902                	ld	s2,32(sp)
    800045b8:	6121                	addi	sp,sp,64
    800045ba:	8082                	ret
    800045bc:	ec4e                	sd	s3,24(sp)
    800045be:	e852                	sd	s4,16(sp)
    800045c0:	e456                	sd	s5,8(sp)
  for (tail = 0; tail < log.lh.n; tail++) {
    800045c2:	02261a97          	auipc	s5,0x2261
    800045c6:	d02a8a93          	addi	s5,s5,-766 # 822652c4 <log+0x2c>
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
    800045ca:	02261a17          	auipc	s4,0x2261
    800045ce:	ccea0a13          	addi	s4,s4,-818 # 82265298 <log>
    800045d2:	018a2583          	lw	a1,24(s4)
    800045d6:	012585bb          	addw	a1,a1,s2
    800045da:	2585                	addiw	a1,a1,1
    800045dc:	024a2503          	lw	a0,36(s4)
    800045e0:	e23fe0ef          	jal	80003402 <bread>
    800045e4:	84aa                	mv	s1,a0
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
    800045e6:	000aa583          	lw	a1,0(s5)
    800045ea:	024a2503          	lw	a0,36(s4)
    800045ee:	e15fe0ef          	jal	80003402 <bread>
    800045f2:	89aa                	mv	s3,a0
    memmove(to->data, from->data, BSIZE);
    800045f4:	40000613          	li	a2,1024
    800045f8:	05850593          	addi	a1,a0,88
    800045fc:	05848513          	addi	a0,s1,88
    80004600:	f58fc0ef          	jal	80000d58 <memmove>
    bwrite(to);  // write the log
    80004604:	8526                	mv	a0,s1
    80004606:	ed3fe0ef          	jal	800034d8 <bwrite>
    brelse(from);
    8000460a:	854e                	mv	a0,s3
    8000460c:	efffe0ef          	jal	8000350a <brelse>
    brelse(to);
    80004610:	8526                	mv	a0,s1
    80004612:	ef9fe0ef          	jal	8000350a <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    80004616:	2905                	addiw	s2,s2,1
    80004618:	0a91                	addi	s5,s5,4
    8000461a:	028a2783          	lw	a5,40(s4)
    8000461e:	faf94ae3          	blt	s2,a5,800045d2 <end_op+0xbc>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
    80004622:	cd9ff0ef          	jal	800042fa <write_head>
    install_trans(0); // Now install writes to home locations
    80004626:	4501                	li	a0,0
    80004628:	d31ff0ef          	jal	80004358 <install_trans>
    log.lh.n = 0;
    8000462c:	02261797          	auipc	a5,0x2261
    80004630:	c807aa23          	sw	zero,-876(a5) # 822652c0 <log+0x28>
    write_head();    // Erase the transaction from the log
    80004634:	cc7ff0ef          	jal	800042fa <write_head>
    80004638:	69e2                	ld	s3,24(sp)
    8000463a:	6a42                	ld	s4,16(sp)
    8000463c:	6aa2                	ld	s5,8(sp)
    8000463e:	bf29                	j	80004558 <end_op+0x42>

0000000080004640 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
    80004640:	1101                	addi	sp,sp,-32
    80004642:	ec06                	sd	ra,24(sp)
    80004644:	e822                	sd	s0,16(sp)
    80004646:	e426                	sd	s1,8(sp)
    80004648:	1000                	addi	s0,sp,32
    8000464a:	84aa                	mv	s1,a0
  int i;

  acquire(&log.lock);
    8000464c:	02261517          	auipc	a0,0x2261
    80004650:	c4c50513          	addi	a0,a0,-948 # 82265298 <log>
    80004654:	dd4fc0ef          	jal	80000c28 <acquire>
  if (log.lh.n >= LOGBLOCKS)
    80004658:	02261617          	auipc	a2,0x2261
    8000465c:	c6862603          	lw	a2,-920(a2) # 822652c0 <log+0x28>
    80004660:	47f5                	li	a5,29
    80004662:	04c7cd63          	blt	a5,a2,800046bc <log_write+0x7c>
    panic("too big a transaction");
  if (log.outstanding < 1)
    80004666:	02261797          	auipc	a5,0x2261
    8000466a:	c4e7a783          	lw	a5,-946(a5) # 822652b4 <log+0x1c>
    8000466e:	04f05d63          	blez	a5,800046c8 <log_write+0x88>
    panic("log_write outside of trans");

  for (i = 0; i < log.lh.n; i++) {
    80004672:	4781                	li	a5,0
    80004674:	06c05063          	blez	a2,800046d4 <log_write+0x94>
    if (log.lh.block[i] == b->blockno)   // log absorption
    80004678:	44cc                	lw	a1,12(s1)
    8000467a:	02261717          	auipc	a4,0x2261
    8000467e:	c4a70713          	addi	a4,a4,-950 # 822652c4 <log+0x2c>
  for (i = 0; i < log.lh.n; i++) {
    80004682:	4781                	li	a5,0
    if (log.lh.block[i] == b->blockno)   // log absorption
    80004684:	4314                	lw	a3,0(a4)
    80004686:	04b68763          	beq	a3,a1,800046d4 <log_write+0x94>
  for (i = 0; i < log.lh.n; i++) {
    8000468a:	2785                	addiw	a5,a5,1
    8000468c:	0711                	addi	a4,a4,4
    8000468e:	fef61be3          	bne	a2,a5,80004684 <log_write+0x44>
      break;
  }
  log.lh.block[i] = b->blockno;
    80004692:	060a                	slli	a2,a2,0x2
    80004694:	02060613          	addi	a2,a2,32
    80004698:	02261797          	auipc	a5,0x2261
    8000469c:	c0078793          	addi	a5,a5,-1024 # 82265298 <log>
    800046a0:	97b2                	add	a5,a5,a2
    800046a2:	44d8                	lw	a4,12(s1)
    800046a4:	c7d8                	sw	a4,12(a5)
  if (i == log.lh.n) {  // Add new block to log?
    bpin(b);
    800046a6:	8526                	mv	a0,s1
    800046a8:	ee7fe0ef          	jal	8000358e <bpin>
    log.lh.n++;
    800046ac:	02261717          	auipc	a4,0x2261
    800046b0:	bec70713          	addi	a4,a4,-1044 # 82265298 <log>
    800046b4:	571c                	lw	a5,40(a4)
    800046b6:	2785                	addiw	a5,a5,1
    800046b8:	d71c                	sw	a5,40(a4)
    800046ba:	a815                	j	800046ee <log_write+0xae>
    panic("too big a transaction");
    800046bc:	00004517          	auipc	a0,0x4
    800046c0:	12450513          	addi	a0,a0,292 # 800087e0 <etext+0x7e0>
    800046c4:	960fc0ef          	jal	80000824 <panic>
    panic("log_write outside of trans");
    800046c8:	00004517          	auipc	a0,0x4
    800046cc:	13050513          	addi	a0,a0,304 # 800087f8 <etext+0x7f8>
    800046d0:	954fc0ef          	jal	80000824 <panic>
  log.lh.block[i] = b->blockno;
    800046d4:	00279693          	slli	a3,a5,0x2
    800046d8:	02068693          	addi	a3,a3,32
    800046dc:	02261717          	auipc	a4,0x2261
    800046e0:	bbc70713          	addi	a4,a4,-1092 # 82265298 <log>
    800046e4:	9736                	add	a4,a4,a3
    800046e6:	44d4                	lw	a3,12(s1)
    800046e8:	c754                	sw	a3,12(a4)
  if (i == log.lh.n) {  // Add new block to log?
    800046ea:	faf60ee3          	beq	a2,a5,800046a6 <log_write+0x66>
  }
  release(&log.lock);
    800046ee:	02261517          	auipc	a0,0x2261
    800046f2:	baa50513          	addi	a0,a0,-1110 # 82265298 <log>
    800046f6:	dc6fc0ef          	jal	80000cbc <release>
}
    800046fa:	60e2                	ld	ra,24(sp)
    800046fc:	6442                	ld	s0,16(sp)
    800046fe:	64a2                	ld	s1,8(sp)
    80004700:	6105                	addi	sp,sp,32
    80004702:	8082                	ret

0000000080004704 <initsleeplock>:
#include "proc.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
    80004704:	1101                	addi	sp,sp,-32
    80004706:	ec06                	sd	ra,24(sp)
    80004708:	e822                	sd	s0,16(sp)
    8000470a:	e426                	sd	s1,8(sp)
    8000470c:	e04a                	sd	s2,0(sp)
    8000470e:	1000                	addi	s0,sp,32
    80004710:	84aa                	mv	s1,a0
    80004712:	892e                	mv	s2,a1
  initlock(&lk->lk, "sleep lock");
    80004714:	00004597          	auipc	a1,0x4
    80004718:	10458593          	addi	a1,a1,260 # 80008818 <etext+0x818>
    8000471c:	0521                	addi	a0,a0,8
    8000471e:	c80fc0ef          	jal	80000b9e <initlock>
  lk->name = name;
    80004722:	0324b023          	sd	s2,32(s1)
  lk->locked = 0;
    80004726:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    8000472a:	0204a423          	sw	zero,40(s1)
}
    8000472e:	60e2                	ld	ra,24(sp)
    80004730:	6442                	ld	s0,16(sp)
    80004732:	64a2                	ld	s1,8(sp)
    80004734:	6902                	ld	s2,0(sp)
    80004736:	6105                	addi	sp,sp,32
    80004738:	8082                	ret

000000008000473a <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
    8000473a:	1101                	addi	sp,sp,-32
    8000473c:	ec06                	sd	ra,24(sp)
    8000473e:	e822                	sd	s0,16(sp)
    80004740:	e426                	sd	s1,8(sp)
    80004742:	e04a                	sd	s2,0(sp)
    80004744:	1000                	addi	s0,sp,32
    80004746:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    80004748:	00850913          	addi	s2,a0,8
    8000474c:	854a                	mv	a0,s2
    8000474e:	cdafc0ef          	jal	80000c28 <acquire>
  while (lk->locked) {
    80004752:	409c                	lw	a5,0(s1)
    80004754:	c799                	beqz	a5,80004762 <acquiresleep+0x28>
    sleep(lk, &lk->lk);
    80004756:	85ca                	mv	a1,s2
    80004758:	8526                	mv	a0,s1
    8000475a:	ed7fd0ef          	jal	80002630 <sleep>
  while (lk->locked) {
    8000475e:	409c                	lw	a5,0(s1)
    80004760:	fbfd                	bnez	a5,80004756 <acquiresleep+0x1c>
  }
  lk->locked = 1;
    80004762:	4785                	li	a5,1
    80004764:	c09c                	sw	a5,0(s1)
  lk->pid = myproc()->pid;
    80004766:	fc0fd0ef          	jal	80001f26 <myproc>
    8000476a:	591c                	lw	a5,48(a0)
    8000476c:	d49c                	sw	a5,40(s1)
  release(&lk->lk);
    8000476e:	854a                	mv	a0,s2
    80004770:	d4cfc0ef          	jal	80000cbc <release>
}
    80004774:	60e2                	ld	ra,24(sp)
    80004776:	6442                	ld	s0,16(sp)
    80004778:	64a2                	ld	s1,8(sp)
    8000477a:	6902                	ld	s2,0(sp)
    8000477c:	6105                	addi	sp,sp,32
    8000477e:	8082                	ret

0000000080004780 <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
    80004780:	1101                	addi	sp,sp,-32
    80004782:	ec06                	sd	ra,24(sp)
    80004784:	e822                	sd	s0,16(sp)
    80004786:	e426                	sd	s1,8(sp)
    80004788:	e04a                	sd	s2,0(sp)
    8000478a:	1000                	addi	s0,sp,32
    8000478c:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    8000478e:	00850913          	addi	s2,a0,8
    80004792:	854a                	mv	a0,s2
    80004794:	c94fc0ef          	jal	80000c28 <acquire>
  lk->locked = 0;
    80004798:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    8000479c:	0204a423          	sw	zero,40(s1)
  wakeup(lk);
    800047a0:	8526                	mv	a0,s1
    800047a2:	edbfd0ef          	jal	8000267c <wakeup>
  release(&lk->lk);
    800047a6:	854a                	mv	a0,s2
    800047a8:	d14fc0ef          	jal	80000cbc <release>
}
    800047ac:	60e2                	ld	ra,24(sp)
    800047ae:	6442                	ld	s0,16(sp)
    800047b0:	64a2                	ld	s1,8(sp)
    800047b2:	6902                	ld	s2,0(sp)
    800047b4:	6105                	addi	sp,sp,32
    800047b6:	8082                	ret

00000000800047b8 <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
    800047b8:	7179                	addi	sp,sp,-48
    800047ba:	f406                	sd	ra,40(sp)
    800047bc:	f022                	sd	s0,32(sp)
    800047be:	ec26                	sd	s1,24(sp)
    800047c0:	e84a                	sd	s2,16(sp)
    800047c2:	1800                	addi	s0,sp,48
    800047c4:	84aa                	mv	s1,a0
  int r;
  
  acquire(&lk->lk);
    800047c6:	00850913          	addi	s2,a0,8
    800047ca:	854a                	mv	a0,s2
    800047cc:	c5cfc0ef          	jal	80000c28 <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
    800047d0:	409c                	lw	a5,0(s1)
    800047d2:	ef81                	bnez	a5,800047ea <holdingsleep+0x32>
    800047d4:	4481                	li	s1,0
  release(&lk->lk);
    800047d6:	854a                	mv	a0,s2
    800047d8:	ce4fc0ef          	jal	80000cbc <release>
  return r;
}
    800047dc:	8526                	mv	a0,s1
    800047de:	70a2                	ld	ra,40(sp)
    800047e0:	7402                	ld	s0,32(sp)
    800047e2:	64e2                	ld	s1,24(sp)
    800047e4:	6942                	ld	s2,16(sp)
    800047e6:	6145                	addi	sp,sp,48
    800047e8:	8082                	ret
    800047ea:	e44e                	sd	s3,8(sp)
  r = lk->locked && (lk->pid == myproc()->pid);
    800047ec:	0284a983          	lw	s3,40(s1)
    800047f0:	f36fd0ef          	jal	80001f26 <myproc>
    800047f4:	5904                	lw	s1,48(a0)
    800047f6:	413484b3          	sub	s1,s1,s3
    800047fa:	0014b493          	seqz	s1,s1
    800047fe:	69a2                	ld	s3,8(sp)
    80004800:	bfd9                	j	800047d6 <holdingsleep+0x1e>

0000000080004802 <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
    80004802:	1141                	addi	sp,sp,-16
    80004804:	e406                	sd	ra,8(sp)
    80004806:	e022                	sd	s0,0(sp)
    80004808:	0800                	addi	s0,sp,16
  initlock(&ftable.lock, "ftable");
    8000480a:	00004597          	auipc	a1,0x4
    8000480e:	01e58593          	addi	a1,a1,30 # 80008828 <etext+0x828>
    80004812:	02261517          	auipc	a0,0x2261
    80004816:	bce50513          	addi	a0,a0,-1074 # 822653e0 <ftable>
    8000481a:	b84fc0ef          	jal	80000b9e <initlock>
}
    8000481e:	60a2                	ld	ra,8(sp)
    80004820:	6402                	ld	s0,0(sp)
    80004822:	0141                	addi	sp,sp,16
    80004824:	8082                	ret

0000000080004826 <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
    80004826:	1101                	addi	sp,sp,-32
    80004828:	ec06                	sd	ra,24(sp)
    8000482a:	e822                	sd	s0,16(sp)
    8000482c:	e426                	sd	s1,8(sp)
    8000482e:	1000                	addi	s0,sp,32
  struct file *f;

  acquire(&ftable.lock);
    80004830:	02261517          	auipc	a0,0x2261
    80004834:	bb050513          	addi	a0,a0,-1104 # 822653e0 <ftable>
    80004838:	bf0fc0ef          	jal	80000c28 <acquire>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    8000483c:	02261497          	auipc	s1,0x2261
    80004840:	bbc48493          	addi	s1,s1,-1092 # 822653f8 <ftable+0x18>
    80004844:	02262717          	auipc	a4,0x2262
    80004848:	b5470713          	addi	a4,a4,-1196 # 82266398 <disk>
    if(f->ref == 0){
    8000484c:	40dc                	lw	a5,4(s1)
    8000484e:	cf89                	beqz	a5,80004868 <filealloc+0x42>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    80004850:	02848493          	addi	s1,s1,40
    80004854:	fee49ce3          	bne	s1,a4,8000484c <filealloc+0x26>
      f->ref = 1;
      release(&ftable.lock);
      return f;
    }
  }
  release(&ftable.lock);
    80004858:	02261517          	auipc	a0,0x2261
    8000485c:	b8850513          	addi	a0,a0,-1144 # 822653e0 <ftable>
    80004860:	c5cfc0ef          	jal	80000cbc <release>
  return 0;
    80004864:	4481                	li	s1,0
    80004866:	a809                	j	80004878 <filealloc+0x52>
      f->ref = 1;
    80004868:	4785                	li	a5,1
    8000486a:	c0dc                	sw	a5,4(s1)
      release(&ftable.lock);
    8000486c:	02261517          	auipc	a0,0x2261
    80004870:	b7450513          	addi	a0,a0,-1164 # 822653e0 <ftable>
    80004874:	c48fc0ef          	jal	80000cbc <release>
}
    80004878:	8526                	mv	a0,s1
    8000487a:	60e2                	ld	ra,24(sp)
    8000487c:	6442                	ld	s0,16(sp)
    8000487e:	64a2                	ld	s1,8(sp)
    80004880:	6105                	addi	sp,sp,32
    80004882:	8082                	ret

0000000080004884 <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
    80004884:	1101                	addi	sp,sp,-32
    80004886:	ec06                	sd	ra,24(sp)
    80004888:	e822                	sd	s0,16(sp)
    8000488a:	e426                	sd	s1,8(sp)
    8000488c:	1000                	addi	s0,sp,32
    8000488e:	84aa                	mv	s1,a0
  acquire(&ftable.lock);
    80004890:	02261517          	auipc	a0,0x2261
    80004894:	b5050513          	addi	a0,a0,-1200 # 822653e0 <ftable>
    80004898:	b90fc0ef          	jal	80000c28 <acquire>
  if(f->ref < 1)
    8000489c:	40dc                	lw	a5,4(s1)
    8000489e:	02f05063          	blez	a5,800048be <filedup+0x3a>
    panic("filedup");
  f->ref++;
    800048a2:	2785                	addiw	a5,a5,1
    800048a4:	c0dc                	sw	a5,4(s1)
  release(&ftable.lock);
    800048a6:	02261517          	auipc	a0,0x2261
    800048aa:	b3a50513          	addi	a0,a0,-1222 # 822653e0 <ftable>
    800048ae:	c0efc0ef          	jal	80000cbc <release>
  return f;
}
    800048b2:	8526                	mv	a0,s1
    800048b4:	60e2                	ld	ra,24(sp)
    800048b6:	6442                	ld	s0,16(sp)
    800048b8:	64a2                	ld	s1,8(sp)
    800048ba:	6105                	addi	sp,sp,32
    800048bc:	8082                	ret
    panic("filedup");
    800048be:	00004517          	auipc	a0,0x4
    800048c2:	f7250513          	addi	a0,a0,-142 # 80008830 <etext+0x830>
    800048c6:	f5ffb0ef          	jal	80000824 <panic>

00000000800048ca <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
    800048ca:	7139                	addi	sp,sp,-64
    800048cc:	fc06                	sd	ra,56(sp)
    800048ce:	f822                	sd	s0,48(sp)
    800048d0:	f426                	sd	s1,40(sp)
    800048d2:	0080                	addi	s0,sp,64
    800048d4:	84aa                	mv	s1,a0
  struct file ff;

  acquire(&ftable.lock);
    800048d6:	02261517          	auipc	a0,0x2261
    800048da:	b0a50513          	addi	a0,a0,-1270 # 822653e0 <ftable>
    800048de:	b4afc0ef          	jal	80000c28 <acquire>
  if(f->ref < 1)
    800048e2:	40dc                	lw	a5,4(s1)
    800048e4:	04f05a63          	blez	a5,80004938 <fileclose+0x6e>
    panic("fileclose");
  if(--f->ref > 0){
    800048e8:	37fd                	addiw	a5,a5,-1
    800048ea:	c0dc                	sw	a5,4(s1)
    800048ec:	06f04063          	bgtz	a5,8000494c <fileclose+0x82>
    800048f0:	f04a                	sd	s2,32(sp)
    800048f2:	ec4e                	sd	s3,24(sp)
    800048f4:	e852                	sd	s4,16(sp)
    800048f6:	e456                	sd	s5,8(sp)
    release(&ftable.lock);
    return;
  }
  ff = *f;
    800048f8:	0004a903          	lw	s2,0(s1)
    800048fc:	0094c783          	lbu	a5,9(s1)
    80004900:	89be                	mv	s3,a5
    80004902:	689c                	ld	a5,16(s1)
    80004904:	8a3e                	mv	s4,a5
    80004906:	6c9c                	ld	a5,24(s1)
    80004908:	8abe                	mv	s5,a5
  f->ref = 0;
    8000490a:	0004a223          	sw	zero,4(s1)
  f->type = FD_NONE;
    8000490e:	0004a023          	sw	zero,0(s1)
  release(&ftable.lock);
    80004912:	02261517          	auipc	a0,0x2261
    80004916:	ace50513          	addi	a0,a0,-1330 # 822653e0 <ftable>
    8000491a:	ba2fc0ef          	jal	80000cbc <release>

  if(ff.type == FD_PIPE){
    8000491e:	4785                	li	a5,1
    80004920:	04f90163          	beq	s2,a5,80004962 <fileclose+0x98>
    pipeclose(ff.pipe, ff.writable);
  } else if(ff.type == FD_INODE || ff.type == FD_DEVICE){
    80004924:	ffe9079b          	addiw	a5,s2,-2
    80004928:	4705                	li	a4,1
    8000492a:	04f77563          	bgeu	a4,a5,80004974 <fileclose+0xaa>
    8000492e:	7902                	ld	s2,32(sp)
    80004930:	69e2                	ld	s3,24(sp)
    80004932:	6a42                	ld	s4,16(sp)
    80004934:	6aa2                	ld	s5,8(sp)
    80004936:	a00d                	j	80004958 <fileclose+0x8e>
    80004938:	f04a                	sd	s2,32(sp)
    8000493a:	ec4e                	sd	s3,24(sp)
    8000493c:	e852                	sd	s4,16(sp)
    8000493e:	e456                	sd	s5,8(sp)
    panic("fileclose");
    80004940:	00004517          	auipc	a0,0x4
    80004944:	ef850513          	addi	a0,a0,-264 # 80008838 <etext+0x838>
    80004948:	eddfb0ef          	jal	80000824 <panic>
    release(&ftable.lock);
    8000494c:	02261517          	auipc	a0,0x2261
    80004950:	a9450513          	addi	a0,a0,-1388 # 822653e0 <ftable>
    80004954:	b68fc0ef          	jal	80000cbc <release>
    begin_op();
    iput(ff.ip);
    end_op();
  }
}
    80004958:	70e2                	ld	ra,56(sp)
    8000495a:	7442                	ld	s0,48(sp)
    8000495c:	74a2                	ld	s1,40(sp)
    8000495e:	6121                	addi	sp,sp,64
    80004960:	8082                	ret
    pipeclose(ff.pipe, ff.writable);
    80004962:	85ce                	mv	a1,s3
    80004964:	8552                	mv	a0,s4
    80004966:	348000ef          	jal	80004cae <pipeclose>
    8000496a:	7902                	ld	s2,32(sp)
    8000496c:	69e2                	ld	s3,24(sp)
    8000496e:	6a42                	ld	s4,16(sp)
    80004970:	6aa2                	ld	s5,8(sp)
    80004972:	b7dd                	j	80004958 <fileclose+0x8e>
    begin_op();
    80004974:	b33ff0ef          	jal	800044a6 <begin_op>
    iput(ff.ip);
    80004978:	8556                	mv	a0,s5
    8000497a:	aa2ff0ef          	jal	80003c1c <iput>
    end_op();
    8000497e:	b99ff0ef          	jal	80004516 <end_op>
    80004982:	7902                	ld	s2,32(sp)
    80004984:	69e2                	ld	s3,24(sp)
    80004986:	6a42                	ld	s4,16(sp)
    80004988:	6aa2                	ld	s5,8(sp)
    8000498a:	b7f9                	j	80004958 <fileclose+0x8e>

000000008000498c <filestat>:

// Get metadata about file f.
// addr is a user virtual address, pointing to a struct stat.
int
filestat(struct file *f, uint64 addr)
{
    8000498c:	715d                	addi	sp,sp,-80
    8000498e:	e486                	sd	ra,72(sp)
    80004990:	e0a2                	sd	s0,64(sp)
    80004992:	fc26                	sd	s1,56(sp)
    80004994:	f052                	sd	s4,32(sp)
    80004996:	0880                	addi	s0,sp,80
    80004998:	84aa                	mv	s1,a0
    8000499a:	8a2e                	mv	s4,a1
  struct proc *p = myproc();
    8000499c:	d8afd0ef          	jal	80001f26 <myproc>
  struct stat st;
  
  if(f->type == FD_INODE || f->type == FD_DEVICE){
    800049a0:	409c                	lw	a5,0(s1)
    800049a2:	37f9                	addiw	a5,a5,-2
    800049a4:	4705                	li	a4,1
    800049a6:	04f76263          	bltu	a4,a5,800049ea <filestat+0x5e>
    800049aa:	f84a                	sd	s2,48(sp)
    800049ac:	f44e                	sd	s3,40(sp)
    800049ae:	89aa                	mv	s3,a0
    ilock(f->ip);
    800049b0:	6c88                	ld	a0,24(s1)
    800049b2:	8e8ff0ef          	jal	80003a9a <ilock>
    stati(f->ip, &st);
    800049b6:	fb840913          	addi	s2,s0,-72
    800049ba:	85ca                	mv	a1,s2
    800049bc:	6c88                	ld	a0,24(s1)
    800049be:	c40ff0ef          	jal	80003dfe <stati>
    iunlock(f->ip);
    800049c2:	6c88                	ld	a0,24(s1)
    800049c4:	984ff0ef          	jal	80003b48 <iunlock>
    if(copyout(p->pagetable, addr, (char *)&st, sizeof(st)) < 0)
    800049c8:	46e1                	li	a3,24
    800049ca:	864a                	mv	a2,s2
    800049cc:	85d2                	mv	a1,s4
    800049ce:	0509b503          	ld	a0,80(s3)
    800049d2:	8d4fd0ef          	jal	80001aa6 <copyout>
    800049d6:	41f5551b          	sraiw	a0,a0,0x1f
    800049da:	7942                	ld	s2,48(sp)
    800049dc:	79a2                	ld	s3,40(sp)
      return -1;
    return 0;
  }
  return -1;
}
    800049de:	60a6                	ld	ra,72(sp)
    800049e0:	6406                	ld	s0,64(sp)
    800049e2:	74e2                	ld	s1,56(sp)
    800049e4:	7a02                	ld	s4,32(sp)
    800049e6:	6161                	addi	sp,sp,80
    800049e8:	8082                	ret
  return -1;
    800049ea:	557d                	li	a0,-1
    800049ec:	bfcd                	j	800049de <filestat+0x52>

00000000800049ee <fileread>:

// Read from file f.
// addr is a user virtual address.
int
fileread(struct file *f, uint64 addr, int n)
{
    800049ee:	7179                	addi	sp,sp,-48
    800049f0:	f406                	sd	ra,40(sp)
    800049f2:	f022                	sd	s0,32(sp)
    800049f4:	e84a                	sd	s2,16(sp)
    800049f6:	1800                	addi	s0,sp,48
  int r = 0;

  if(f->readable == 0)
    800049f8:	00854783          	lbu	a5,8(a0)
    800049fc:	cfd1                	beqz	a5,80004a98 <fileread+0xaa>
    800049fe:	ec26                	sd	s1,24(sp)
    80004a00:	e44e                	sd	s3,8(sp)
    80004a02:	84aa                	mv	s1,a0
    80004a04:	892e                	mv	s2,a1
    80004a06:	89b2                	mv	s3,a2
    return -1;

  if(f->type == FD_PIPE){
    80004a08:	411c                	lw	a5,0(a0)
    80004a0a:	4705                	li	a4,1
    80004a0c:	04e78363          	beq	a5,a4,80004a52 <fileread+0x64>
    r = piperead(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    80004a10:	470d                	li	a4,3
    80004a12:	04e78763          	beq	a5,a4,80004a60 <fileread+0x72>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
      return -1;
    r = devsw[f->major].read(1, addr, n);
  } else if(f->type == FD_INODE){
    80004a16:	4709                	li	a4,2
    80004a18:	06e79a63          	bne	a5,a4,80004a8c <fileread+0x9e>
    ilock(f->ip);
    80004a1c:	6d08                	ld	a0,24(a0)
    80004a1e:	87cff0ef          	jal	80003a9a <ilock>
    if((r = readi(f->ip, 1, addr, f->off, n)) > 0)
    80004a22:	874e                	mv	a4,s3
    80004a24:	5094                	lw	a3,32(s1)
    80004a26:	864a                	mv	a2,s2
    80004a28:	4585                	li	a1,1
    80004a2a:	6c88                	ld	a0,24(s1)
    80004a2c:	c00ff0ef          	jal	80003e2c <readi>
    80004a30:	892a                	mv	s2,a0
    80004a32:	00a05563          	blez	a0,80004a3c <fileread+0x4e>
      f->off += r;
    80004a36:	509c                	lw	a5,32(s1)
    80004a38:	9fa9                	addw	a5,a5,a0
    80004a3a:	d09c                	sw	a5,32(s1)
    iunlock(f->ip);
    80004a3c:	6c88                	ld	a0,24(s1)
    80004a3e:	90aff0ef          	jal	80003b48 <iunlock>
    80004a42:	64e2                	ld	s1,24(sp)
    80004a44:	69a2                	ld	s3,8(sp)
  } else {
    panic("fileread");
  }

  return r;
}
    80004a46:	854a                	mv	a0,s2
    80004a48:	70a2                	ld	ra,40(sp)
    80004a4a:	7402                	ld	s0,32(sp)
    80004a4c:	6942                	ld	s2,16(sp)
    80004a4e:	6145                	addi	sp,sp,48
    80004a50:	8082                	ret
    r = piperead(f->pipe, addr, n);
    80004a52:	6908                	ld	a0,16(a0)
    80004a54:	3b0000ef          	jal	80004e04 <piperead>
    80004a58:	892a                	mv	s2,a0
    80004a5a:	64e2                	ld	s1,24(sp)
    80004a5c:	69a2                	ld	s3,8(sp)
    80004a5e:	b7e5                	j	80004a46 <fileread+0x58>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
    80004a60:	02451783          	lh	a5,36(a0)
    80004a64:	03079693          	slli	a3,a5,0x30
    80004a68:	92c1                	srli	a3,a3,0x30
    80004a6a:	4725                	li	a4,9
    80004a6c:	02d76963          	bltu	a4,a3,80004a9e <fileread+0xb0>
    80004a70:	0792                	slli	a5,a5,0x4
    80004a72:	02261717          	auipc	a4,0x2261
    80004a76:	8ce70713          	addi	a4,a4,-1842 # 82265340 <devsw>
    80004a7a:	97ba                	add	a5,a5,a4
    80004a7c:	639c                	ld	a5,0(a5)
    80004a7e:	c78d                	beqz	a5,80004aa8 <fileread+0xba>
    r = devsw[f->major].read(1, addr, n);
    80004a80:	4505                	li	a0,1
    80004a82:	9782                	jalr	a5
    80004a84:	892a                	mv	s2,a0
    80004a86:	64e2                	ld	s1,24(sp)
    80004a88:	69a2                	ld	s3,8(sp)
    80004a8a:	bf75                	j	80004a46 <fileread+0x58>
    panic("fileread");
    80004a8c:	00004517          	auipc	a0,0x4
    80004a90:	dbc50513          	addi	a0,a0,-580 # 80008848 <etext+0x848>
    80004a94:	d91fb0ef          	jal	80000824 <panic>
    return -1;
    80004a98:	57fd                	li	a5,-1
    80004a9a:	893e                	mv	s2,a5
    80004a9c:	b76d                	j	80004a46 <fileread+0x58>
      return -1;
    80004a9e:	57fd                	li	a5,-1
    80004aa0:	893e                	mv	s2,a5
    80004aa2:	64e2                	ld	s1,24(sp)
    80004aa4:	69a2                	ld	s3,8(sp)
    80004aa6:	b745                	j	80004a46 <fileread+0x58>
    80004aa8:	57fd                	li	a5,-1
    80004aaa:	893e                	mv	s2,a5
    80004aac:	64e2                	ld	s1,24(sp)
    80004aae:	69a2                	ld	s3,8(sp)
    80004ab0:	bf59                	j	80004a46 <fileread+0x58>

0000000080004ab2 <filewrite>:
int
filewrite(struct file *f, uint64 addr, int n)
{
  int r, ret = 0;

  if(f->writable == 0)
    80004ab2:	00954783          	lbu	a5,9(a0)
    80004ab6:	10078f63          	beqz	a5,80004bd4 <filewrite+0x122>
{
    80004aba:	711d                	addi	sp,sp,-96
    80004abc:	ec86                	sd	ra,88(sp)
    80004abe:	e8a2                	sd	s0,80(sp)
    80004ac0:	e0ca                	sd	s2,64(sp)
    80004ac2:	f456                	sd	s5,40(sp)
    80004ac4:	f05a                	sd	s6,32(sp)
    80004ac6:	1080                	addi	s0,sp,96
    80004ac8:	892a                	mv	s2,a0
    80004aca:	8b2e                	mv	s6,a1
    80004acc:	8ab2                	mv	s5,a2
    return -1;

  if(f->type == FD_PIPE){
    80004ace:	411c                	lw	a5,0(a0)
    80004ad0:	4705                	li	a4,1
    80004ad2:	02e78a63          	beq	a5,a4,80004b06 <filewrite+0x54>
    ret = pipewrite(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    80004ad6:	470d                	li	a4,3
    80004ad8:	02e78b63          	beq	a5,a4,80004b0e <filewrite+0x5c>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
      return -1;
    ret = devsw[f->major].write(1, addr, n);
  } else if(f->type == FD_INODE){
    80004adc:	4709                	li	a4,2
    80004ade:	0ce79f63          	bne	a5,a4,80004bbc <filewrite+0x10a>
    80004ae2:	f852                	sd	s4,48(sp)
    // the maximum log transaction size, including
    // i-node, indirect block, allocation blocks,
    // and 2 blocks of slop for non-aligned writes.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * BSIZE;
    int i = 0;
    while(i < n){
    80004ae4:	0ac05a63          	blez	a2,80004b98 <filewrite+0xe6>
    80004ae8:	e4a6                	sd	s1,72(sp)
    80004aea:	fc4e                	sd	s3,56(sp)
    80004aec:	ec5e                	sd	s7,24(sp)
    80004aee:	e862                	sd	s8,16(sp)
    80004af0:	e466                	sd	s9,8(sp)
    int i = 0;
    80004af2:	4a01                	li	s4,0
      int n1 = n - i;
      if(n1 > max)
    80004af4:	6b85                	lui	s7,0x1
    80004af6:	c00b8b93          	addi	s7,s7,-1024 # c00 <_entry-0x7ffff400>
    80004afa:	6785                	lui	a5,0x1
    80004afc:	c007879b          	addiw	a5,a5,-1024 # c00 <_entry-0x7ffff400>
    80004b00:	8cbe                	mv	s9,a5
        n1 = max;

      begin_op();
      ilock(f->ip);
      if ((r = writei(f->ip, 1, addr + i, f->off, n1)) > 0)
    80004b02:	4c05                	li	s8,1
    80004b04:	a8ad                	j	80004b7e <filewrite+0xcc>
    ret = pipewrite(f->pipe, addr, n);
    80004b06:	6908                	ld	a0,16(a0)
    80004b08:	204000ef          	jal	80004d0c <pipewrite>
    80004b0c:	a04d                	j	80004bae <filewrite+0xfc>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
    80004b0e:	02451783          	lh	a5,36(a0)
    80004b12:	03079693          	slli	a3,a5,0x30
    80004b16:	92c1                	srli	a3,a3,0x30
    80004b18:	4725                	li	a4,9
    80004b1a:	0ad76f63          	bltu	a4,a3,80004bd8 <filewrite+0x126>
    80004b1e:	0792                	slli	a5,a5,0x4
    80004b20:	02261717          	auipc	a4,0x2261
    80004b24:	82070713          	addi	a4,a4,-2016 # 82265340 <devsw>
    80004b28:	97ba                	add	a5,a5,a4
    80004b2a:	679c                	ld	a5,8(a5)
    80004b2c:	cbc5                	beqz	a5,80004bdc <filewrite+0x12a>
    ret = devsw[f->major].write(1, addr, n);
    80004b2e:	4505                	li	a0,1
    80004b30:	9782                	jalr	a5
    80004b32:	a8b5                	j	80004bae <filewrite+0xfc>
      if(n1 > max)
    80004b34:	2981                	sext.w	s3,s3
      begin_op();
    80004b36:	971ff0ef          	jal	800044a6 <begin_op>
      ilock(f->ip);
    80004b3a:	01893503          	ld	a0,24(s2)
    80004b3e:	f5dfe0ef          	jal	80003a9a <ilock>
      if ((r = writei(f->ip, 1, addr + i, f->off, n1)) > 0)
    80004b42:	874e                	mv	a4,s3
    80004b44:	02092683          	lw	a3,32(s2)
    80004b48:	016a0633          	add	a2,s4,s6
    80004b4c:	85e2                	mv	a1,s8
    80004b4e:	01893503          	ld	a0,24(s2)
    80004b52:	bccff0ef          	jal	80003f1e <writei>
    80004b56:	84aa                	mv	s1,a0
    80004b58:	00a05763          	blez	a0,80004b66 <filewrite+0xb4>
        f->off += r;
    80004b5c:	02092783          	lw	a5,32(s2)
    80004b60:	9fa9                	addw	a5,a5,a0
    80004b62:	02f92023          	sw	a5,32(s2)
      iunlock(f->ip);
    80004b66:	01893503          	ld	a0,24(s2)
    80004b6a:	fdffe0ef          	jal	80003b48 <iunlock>
      end_op();
    80004b6e:	9a9ff0ef          	jal	80004516 <end_op>

      if(r != n1){
    80004b72:	02999563          	bne	s3,s1,80004b9c <filewrite+0xea>
        // error from writei
        break;
      }
      i += r;
    80004b76:	01448a3b          	addw	s4,s1,s4
    while(i < n){
    80004b7a:	015a5963          	bge	s4,s5,80004b8c <filewrite+0xda>
      int n1 = n - i;
    80004b7e:	414a87bb          	subw	a5,s5,s4
    80004b82:	89be                	mv	s3,a5
      if(n1 > max)
    80004b84:	fafbd8e3          	bge	s7,a5,80004b34 <filewrite+0x82>
    80004b88:	89e6                	mv	s3,s9
    80004b8a:	b76d                	j	80004b34 <filewrite+0x82>
    80004b8c:	64a6                	ld	s1,72(sp)
    80004b8e:	79e2                	ld	s3,56(sp)
    80004b90:	6be2                	ld	s7,24(sp)
    80004b92:	6c42                	ld	s8,16(sp)
    80004b94:	6ca2                	ld	s9,8(sp)
    80004b96:	a801                	j	80004ba6 <filewrite+0xf4>
    int i = 0;
    80004b98:	4a01                	li	s4,0
    80004b9a:	a031                	j	80004ba6 <filewrite+0xf4>
    80004b9c:	64a6                	ld	s1,72(sp)
    80004b9e:	79e2                	ld	s3,56(sp)
    80004ba0:	6be2                	ld	s7,24(sp)
    80004ba2:	6c42                	ld	s8,16(sp)
    80004ba4:	6ca2                	ld	s9,8(sp)
    }
    ret = (i == n ? n : -1);
    80004ba6:	034a9d63          	bne	s5,s4,80004be0 <filewrite+0x12e>
    80004baa:	8556                	mv	a0,s5
    80004bac:	7a42                	ld	s4,48(sp)
  } else {
    panic("filewrite");
  }

  return ret;
}
    80004bae:	60e6                	ld	ra,88(sp)
    80004bb0:	6446                	ld	s0,80(sp)
    80004bb2:	6906                	ld	s2,64(sp)
    80004bb4:	7aa2                	ld	s5,40(sp)
    80004bb6:	7b02                	ld	s6,32(sp)
    80004bb8:	6125                	addi	sp,sp,96
    80004bba:	8082                	ret
    80004bbc:	e4a6                	sd	s1,72(sp)
    80004bbe:	fc4e                	sd	s3,56(sp)
    80004bc0:	f852                	sd	s4,48(sp)
    80004bc2:	ec5e                	sd	s7,24(sp)
    80004bc4:	e862                	sd	s8,16(sp)
    80004bc6:	e466                	sd	s9,8(sp)
    panic("filewrite");
    80004bc8:	00004517          	auipc	a0,0x4
    80004bcc:	c9050513          	addi	a0,a0,-880 # 80008858 <etext+0x858>
    80004bd0:	c55fb0ef          	jal	80000824 <panic>
    return -1;
    80004bd4:	557d                	li	a0,-1
}
    80004bd6:	8082                	ret
      return -1;
    80004bd8:	557d                	li	a0,-1
    80004bda:	bfd1                	j	80004bae <filewrite+0xfc>
    80004bdc:	557d                	li	a0,-1
    80004bde:	bfc1                	j	80004bae <filewrite+0xfc>
    ret = (i == n ? n : -1);
    80004be0:	557d                	li	a0,-1
    80004be2:	7a42                	ld	s4,48(sp)
    80004be4:	b7e9                	j	80004bae <filewrite+0xfc>

0000000080004be6 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
    80004be6:	7179                	addi	sp,sp,-48
    80004be8:	f406                	sd	ra,40(sp)
    80004bea:	f022                	sd	s0,32(sp)
    80004bec:	ec26                	sd	s1,24(sp)
    80004bee:	e052                	sd	s4,0(sp)
    80004bf0:	1800                	addi	s0,sp,48
    80004bf2:	84aa                	mv	s1,a0
    80004bf4:	8a2e                	mv	s4,a1
  struct pipe *pi;

  pi = 0;
  *f0 = *f1 = 0;
    80004bf6:	0005b023          	sd	zero,0(a1)
    80004bfa:	00053023          	sd	zero,0(a0)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
    80004bfe:	c29ff0ef          	jal	80004826 <filealloc>
    80004c02:	e088                	sd	a0,0(s1)
    80004c04:	c549                	beqz	a0,80004c8e <pipealloc+0xa8>
    80004c06:	c21ff0ef          	jal	80004826 <filealloc>
    80004c0a:	00aa3023          	sd	a0,0(s4)
    80004c0e:	cd25                	beqz	a0,80004c86 <pipealloc+0xa0>
    80004c10:	e84a                	sd	s2,16(sp)
    goto bad;
  if((pi = (struct pipe*)kalloc()) == 0)
    80004c12:	f33fb0ef          	jal	80000b44 <kalloc>
    80004c16:	892a                	mv	s2,a0
    80004c18:	c12d                	beqz	a0,80004c7a <pipealloc+0x94>
    80004c1a:	e44e                	sd	s3,8(sp)
    goto bad;
  pi->readopen = 1;
    80004c1c:	4985                	li	s3,1
    80004c1e:	23352023          	sw	s3,544(a0)
  pi->writeopen = 1;
    80004c22:	23352223          	sw	s3,548(a0)
  pi->nwrite = 0;
    80004c26:	20052e23          	sw	zero,540(a0)
  pi->nread = 0;
    80004c2a:	20052c23          	sw	zero,536(a0)
  initlock(&pi->lock, "pipe");
    80004c2e:	00004597          	auipc	a1,0x4
    80004c32:	c3a58593          	addi	a1,a1,-966 # 80008868 <etext+0x868>
    80004c36:	f69fb0ef          	jal	80000b9e <initlock>
  (*f0)->type = FD_PIPE;
    80004c3a:	609c                	ld	a5,0(s1)
    80004c3c:	0137a023          	sw	s3,0(a5)
  (*f0)->readable = 1;
    80004c40:	609c                	ld	a5,0(s1)
    80004c42:	01378423          	sb	s3,8(a5)
  (*f0)->writable = 0;
    80004c46:	609c                	ld	a5,0(s1)
    80004c48:	000784a3          	sb	zero,9(a5)
  (*f0)->pipe = pi;
    80004c4c:	609c                	ld	a5,0(s1)
    80004c4e:	0127b823          	sd	s2,16(a5)
  (*f1)->type = FD_PIPE;
    80004c52:	000a3783          	ld	a5,0(s4)
    80004c56:	0137a023          	sw	s3,0(a5)
  (*f1)->readable = 0;
    80004c5a:	000a3783          	ld	a5,0(s4)
    80004c5e:	00078423          	sb	zero,8(a5)
  (*f1)->writable = 1;
    80004c62:	000a3783          	ld	a5,0(s4)
    80004c66:	013784a3          	sb	s3,9(a5)
  (*f1)->pipe = pi;
    80004c6a:	000a3783          	ld	a5,0(s4)
    80004c6e:	0127b823          	sd	s2,16(a5)
  return 0;
    80004c72:	4501                	li	a0,0
    80004c74:	6942                	ld	s2,16(sp)
    80004c76:	69a2                	ld	s3,8(sp)
    80004c78:	a01d                	j	80004c9e <pipealloc+0xb8>

 bad:
  if(pi)
    kfree((char*)pi);
  if(*f0)
    80004c7a:	6088                	ld	a0,0(s1)
    80004c7c:	c119                	beqz	a0,80004c82 <pipealloc+0x9c>
    80004c7e:	6942                	ld	s2,16(sp)
    80004c80:	a029                	j	80004c8a <pipealloc+0xa4>
    80004c82:	6942                	ld	s2,16(sp)
    80004c84:	a029                	j	80004c8e <pipealloc+0xa8>
    80004c86:	6088                	ld	a0,0(s1)
    80004c88:	c10d                	beqz	a0,80004caa <pipealloc+0xc4>
    fileclose(*f0);
    80004c8a:	c41ff0ef          	jal	800048ca <fileclose>
  if(*f1)
    80004c8e:	000a3783          	ld	a5,0(s4)
    fileclose(*f1);
  return -1;
    80004c92:	557d                	li	a0,-1
  if(*f1)
    80004c94:	c789                	beqz	a5,80004c9e <pipealloc+0xb8>
    fileclose(*f1);
    80004c96:	853e                	mv	a0,a5
    80004c98:	c33ff0ef          	jal	800048ca <fileclose>
  return -1;
    80004c9c:	557d                	li	a0,-1
}
    80004c9e:	70a2                	ld	ra,40(sp)
    80004ca0:	7402                	ld	s0,32(sp)
    80004ca2:	64e2                	ld	s1,24(sp)
    80004ca4:	6a02                	ld	s4,0(sp)
    80004ca6:	6145                	addi	sp,sp,48
    80004ca8:	8082                	ret
  return -1;
    80004caa:	557d                	li	a0,-1
    80004cac:	bfcd                	j	80004c9e <pipealloc+0xb8>

0000000080004cae <pipeclose>:

void
pipeclose(struct pipe *pi, int writable)
{
    80004cae:	1101                	addi	sp,sp,-32
    80004cb0:	ec06                	sd	ra,24(sp)
    80004cb2:	e822                	sd	s0,16(sp)
    80004cb4:	e426                	sd	s1,8(sp)
    80004cb6:	e04a                	sd	s2,0(sp)
    80004cb8:	1000                	addi	s0,sp,32
    80004cba:	84aa                	mv	s1,a0
    80004cbc:	892e                	mv	s2,a1
  acquire(&pi->lock);
    80004cbe:	f6bfb0ef          	jal	80000c28 <acquire>
  if(writable){
    80004cc2:	02090763          	beqz	s2,80004cf0 <pipeclose+0x42>
    pi->writeopen = 0;
    80004cc6:	2204a223          	sw	zero,548(s1)
    wakeup(&pi->nread);
    80004cca:	21848513          	addi	a0,s1,536
    80004cce:	9affd0ef          	jal	8000267c <wakeup>
  } else {
    pi->readopen = 0;
    wakeup(&pi->nwrite);
  }
  if(pi->readopen == 0 && pi->writeopen == 0){
    80004cd2:	2204a783          	lw	a5,544(s1)
    80004cd6:	e781                	bnez	a5,80004cde <pipeclose+0x30>
    80004cd8:	2244a783          	lw	a5,548(s1)
    80004cdc:	c38d                	beqz	a5,80004cfe <pipeclose+0x50>
    release(&pi->lock);
    kfree((char*)pi);
  } else
    release(&pi->lock);
    80004cde:	8526                	mv	a0,s1
    80004ce0:	fddfb0ef          	jal	80000cbc <release>
}
    80004ce4:	60e2                	ld	ra,24(sp)
    80004ce6:	6442                	ld	s0,16(sp)
    80004ce8:	64a2                	ld	s1,8(sp)
    80004cea:	6902                	ld	s2,0(sp)
    80004cec:	6105                	addi	sp,sp,32
    80004cee:	8082                	ret
    pi->readopen = 0;
    80004cf0:	2204a023          	sw	zero,544(s1)
    wakeup(&pi->nwrite);
    80004cf4:	21c48513          	addi	a0,s1,540
    80004cf8:	985fd0ef          	jal	8000267c <wakeup>
    80004cfc:	bfd9                	j	80004cd2 <pipeclose+0x24>
    release(&pi->lock);
    80004cfe:	8526                	mv	a0,s1
    80004d00:	fbdfb0ef          	jal	80000cbc <release>
    kfree((char*)pi);
    80004d04:	8526                	mv	a0,s1
    80004d06:	d57fb0ef          	jal	80000a5c <kfree>
    80004d0a:	bfe9                	j	80004ce4 <pipeclose+0x36>

0000000080004d0c <pipewrite>:

int
pipewrite(struct pipe *pi, uint64 addr, int n)
{
    80004d0c:	7159                	addi	sp,sp,-112
    80004d0e:	f486                	sd	ra,104(sp)
    80004d10:	f0a2                	sd	s0,96(sp)
    80004d12:	eca6                	sd	s1,88(sp)
    80004d14:	e8ca                	sd	s2,80(sp)
    80004d16:	e4ce                	sd	s3,72(sp)
    80004d18:	e0d2                	sd	s4,64(sp)
    80004d1a:	fc56                	sd	s5,56(sp)
    80004d1c:	1880                	addi	s0,sp,112
    80004d1e:	84aa                	mv	s1,a0
    80004d20:	8aae                	mv	s5,a1
    80004d22:	8a32                	mv	s4,a2
  int i = 0;
  struct proc *pr = myproc();
    80004d24:	a02fd0ef          	jal	80001f26 <myproc>
    80004d28:	89aa                	mv	s3,a0

  acquire(&pi->lock);
    80004d2a:	8526                	mv	a0,s1
    80004d2c:	efdfb0ef          	jal	80000c28 <acquire>
  while(i < n){
    80004d30:	0d405263          	blez	s4,80004df4 <pipewrite+0xe8>
    80004d34:	f85a                	sd	s6,48(sp)
    80004d36:	f45e                	sd	s7,40(sp)
    80004d38:	f062                	sd	s8,32(sp)
    80004d3a:	ec66                	sd	s9,24(sp)
    80004d3c:	e86a                	sd	s10,16(sp)
  int i = 0;
    80004d3e:	4901                	li	s2,0
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
      wakeup(&pi->nread);
      sleep(&pi->nwrite, &pi->lock);
    } else {
      char ch;
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    80004d40:	f9f40c13          	addi	s8,s0,-97
    80004d44:	4b85                	li	s7,1
    80004d46:	5b7d                	li	s6,-1
      wakeup(&pi->nread);
    80004d48:	21848d13          	addi	s10,s1,536
      sleep(&pi->nwrite, &pi->lock);
    80004d4c:	21c48c93          	addi	s9,s1,540
    80004d50:	a82d                	j	80004d8a <pipewrite+0x7e>
      release(&pi->lock);
    80004d52:	8526                	mv	a0,s1
    80004d54:	f69fb0ef          	jal	80000cbc <release>
      return -1;
    80004d58:	597d                	li	s2,-1
    80004d5a:	7b42                	ld	s6,48(sp)
    80004d5c:	7ba2                	ld	s7,40(sp)
    80004d5e:	7c02                	ld	s8,32(sp)
    80004d60:	6ce2                	ld	s9,24(sp)
    80004d62:	6d42                	ld	s10,16(sp)
  }
  wakeup(&pi->nread);
  release(&pi->lock);

  return i;
}
    80004d64:	854a                	mv	a0,s2
    80004d66:	70a6                	ld	ra,104(sp)
    80004d68:	7406                	ld	s0,96(sp)
    80004d6a:	64e6                	ld	s1,88(sp)
    80004d6c:	6946                	ld	s2,80(sp)
    80004d6e:	69a6                	ld	s3,72(sp)
    80004d70:	6a06                	ld	s4,64(sp)
    80004d72:	7ae2                	ld	s5,56(sp)
    80004d74:	6165                	addi	sp,sp,112
    80004d76:	8082                	ret
      wakeup(&pi->nread);
    80004d78:	856a                	mv	a0,s10
    80004d7a:	903fd0ef          	jal	8000267c <wakeup>
      sleep(&pi->nwrite, &pi->lock);
    80004d7e:	85a6                	mv	a1,s1
    80004d80:	8566                	mv	a0,s9
    80004d82:	8affd0ef          	jal	80002630 <sleep>
  while(i < n){
    80004d86:	05495a63          	bge	s2,s4,80004dda <pipewrite+0xce>
    if(pi->readopen == 0 || killed(pr)){
    80004d8a:	2204a783          	lw	a5,544(s1)
    80004d8e:	d3f1                	beqz	a5,80004d52 <pipewrite+0x46>
    80004d90:	854e                	mv	a0,s3
    80004d92:	b37fd0ef          	jal	800028c8 <killed>
    80004d96:	fd55                	bnez	a0,80004d52 <pipewrite+0x46>
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
    80004d98:	2184a783          	lw	a5,536(s1)
    80004d9c:	21c4a703          	lw	a4,540(s1)
    80004da0:	2007879b          	addiw	a5,a5,512
    80004da4:	fcf70ae3          	beq	a4,a5,80004d78 <pipewrite+0x6c>
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    80004da8:	86de                	mv	a3,s7
    80004daa:	01590633          	add	a2,s2,s5
    80004dae:	85e2                	mv	a1,s8
    80004db0:	0509b503          	ld	a0,80(s3)
    80004db4:	e21fc0ef          	jal	80001bd4 <copyin>
    80004db8:	05650063          	beq	a0,s6,80004df8 <pipewrite+0xec>
      pi->data[pi->nwrite++ % PIPESIZE] = ch;
    80004dbc:	21c4a783          	lw	a5,540(s1)
    80004dc0:	0017871b          	addiw	a4,a5,1
    80004dc4:	20e4ae23          	sw	a4,540(s1)
    80004dc8:	1ff7f793          	andi	a5,a5,511
    80004dcc:	97a6                	add	a5,a5,s1
    80004dce:	f9f44703          	lbu	a4,-97(s0)
    80004dd2:	00e78c23          	sb	a4,24(a5)
      i++;
    80004dd6:	2905                	addiw	s2,s2,1
    80004dd8:	b77d                	j	80004d86 <pipewrite+0x7a>
    80004dda:	7b42                	ld	s6,48(sp)
    80004ddc:	7ba2                	ld	s7,40(sp)
    80004dde:	7c02                	ld	s8,32(sp)
    80004de0:	6ce2                	ld	s9,24(sp)
    80004de2:	6d42                	ld	s10,16(sp)
  wakeup(&pi->nread);
    80004de4:	21848513          	addi	a0,s1,536
    80004de8:	895fd0ef          	jal	8000267c <wakeup>
  release(&pi->lock);
    80004dec:	8526                	mv	a0,s1
    80004dee:	ecffb0ef          	jal	80000cbc <release>
  return i;
    80004df2:	bf8d                	j	80004d64 <pipewrite+0x58>
  int i = 0;
    80004df4:	4901                	li	s2,0
    80004df6:	b7fd                	j	80004de4 <pipewrite+0xd8>
    80004df8:	7b42                	ld	s6,48(sp)
    80004dfa:	7ba2                	ld	s7,40(sp)
    80004dfc:	7c02                	ld	s8,32(sp)
    80004dfe:	6ce2                	ld	s9,24(sp)
    80004e00:	6d42                	ld	s10,16(sp)
    80004e02:	b7cd                	j	80004de4 <pipewrite+0xd8>

0000000080004e04 <piperead>:

int
piperead(struct pipe *pi, uint64 addr, int n)
{
    80004e04:	711d                	addi	sp,sp,-96
    80004e06:	ec86                	sd	ra,88(sp)
    80004e08:	e8a2                	sd	s0,80(sp)
    80004e0a:	e4a6                	sd	s1,72(sp)
    80004e0c:	e0ca                	sd	s2,64(sp)
    80004e0e:	fc4e                	sd	s3,56(sp)
    80004e10:	f852                	sd	s4,48(sp)
    80004e12:	f456                	sd	s5,40(sp)
    80004e14:	1080                	addi	s0,sp,96
    80004e16:	84aa                	mv	s1,a0
    80004e18:	892e                	mv	s2,a1
    80004e1a:	8ab2                	mv	s5,a2
  int i;
  struct proc *pr = myproc();
    80004e1c:	90afd0ef          	jal	80001f26 <myproc>
    80004e20:	8a2a                	mv	s4,a0
  char ch;

  acquire(&pi->lock);
    80004e22:	8526                	mv	a0,s1
    80004e24:	e05fb0ef          	jal	80000c28 <acquire>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80004e28:	2184a703          	lw	a4,536(s1)
    80004e2c:	21c4a783          	lw	a5,540(s1)
    if(killed(pr)){
      release(&pi->lock);
      return -1;
    }
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    80004e30:	21848993          	addi	s3,s1,536
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80004e34:	02f71763          	bne	a4,a5,80004e62 <piperead+0x5e>
    80004e38:	2244a783          	lw	a5,548(s1)
    80004e3c:	cf85                	beqz	a5,80004e74 <piperead+0x70>
    if(killed(pr)){
    80004e3e:	8552                	mv	a0,s4
    80004e40:	a89fd0ef          	jal	800028c8 <killed>
    80004e44:	e11d                	bnez	a0,80004e6a <piperead+0x66>
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    80004e46:	85a6                	mv	a1,s1
    80004e48:	854e                	mv	a0,s3
    80004e4a:	fe6fd0ef          	jal	80002630 <sleep>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80004e4e:	2184a703          	lw	a4,536(s1)
    80004e52:	21c4a783          	lw	a5,540(s1)
    80004e56:	fef701e3          	beq	a4,a5,80004e38 <piperead+0x34>
    80004e5a:	f05a                	sd	s6,32(sp)
    80004e5c:	ec5e                	sd	s7,24(sp)
    80004e5e:	e862                	sd	s8,16(sp)
    80004e60:	a829                	j	80004e7a <piperead+0x76>
    80004e62:	f05a                	sd	s6,32(sp)
    80004e64:	ec5e                	sd	s7,24(sp)
    80004e66:	e862                	sd	s8,16(sp)
    80004e68:	a809                	j	80004e7a <piperead+0x76>
      release(&pi->lock);
    80004e6a:	8526                	mv	a0,s1
    80004e6c:	e51fb0ef          	jal	80000cbc <release>
      return -1;
    80004e70:	59fd                	li	s3,-1
    80004e72:	a0a5                	j	80004eda <piperead+0xd6>
    80004e74:	f05a                	sd	s6,32(sp)
    80004e76:	ec5e                	sd	s7,24(sp)
    80004e78:	e862                	sd	s8,16(sp)
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80004e7a:	4981                	li	s3,0
    if(pi->nread == pi->nwrite)
      break;
    ch = pi->data[pi->nread % PIPESIZE];
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1) {
    80004e7c:	faf40c13          	addi	s8,s0,-81
    80004e80:	4b85                	li	s7,1
    80004e82:	5b7d                	li	s6,-1
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80004e84:	05505163          	blez	s5,80004ec6 <piperead+0xc2>
    if(pi->nread == pi->nwrite)
    80004e88:	2184a783          	lw	a5,536(s1)
    80004e8c:	21c4a703          	lw	a4,540(s1)
    80004e90:	02f70b63          	beq	a4,a5,80004ec6 <piperead+0xc2>
    ch = pi->data[pi->nread % PIPESIZE];
    80004e94:	1ff7f793          	andi	a5,a5,511
    80004e98:	97a6                	add	a5,a5,s1
    80004e9a:	0187c783          	lbu	a5,24(a5)
    80004e9e:	faf407a3          	sb	a5,-81(s0)
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1) {
    80004ea2:	86de                	mv	a3,s7
    80004ea4:	8662                	mv	a2,s8
    80004ea6:	85ca                	mv	a1,s2
    80004ea8:	050a3503          	ld	a0,80(s4)
    80004eac:	bfbfc0ef          	jal	80001aa6 <copyout>
    80004eb0:	03650f63          	beq	a0,s6,80004eee <piperead+0xea>
      if(i == 0)
        i = -1;
      break;
    }
    pi->nread++;
    80004eb4:	2184a783          	lw	a5,536(s1)
    80004eb8:	2785                	addiw	a5,a5,1
    80004eba:	20f4ac23          	sw	a5,536(s1)
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80004ebe:	2985                	addiw	s3,s3,1
    80004ec0:	0905                	addi	s2,s2,1
    80004ec2:	fd3a93e3          	bne	s5,s3,80004e88 <piperead+0x84>
  }
  wakeup(&pi->nwrite);  //DOC: piperead-wakeup
    80004ec6:	21c48513          	addi	a0,s1,540
    80004eca:	fb2fd0ef          	jal	8000267c <wakeup>
  release(&pi->lock);
    80004ece:	8526                	mv	a0,s1
    80004ed0:	dedfb0ef          	jal	80000cbc <release>
    80004ed4:	7b02                	ld	s6,32(sp)
    80004ed6:	6be2                	ld	s7,24(sp)
    80004ed8:	6c42                	ld	s8,16(sp)
  return i;
}
    80004eda:	854e                	mv	a0,s3
    80004edc:	60e6                	ld	ra,88(sp)
    80004ede:	6446                	ld	s0,80(sp)
    80004ee0:	64a6                	ld	s1,72(sp)
    80004ee2:	6906                	ld	s2,64(sp)
    80004ee4:	79e2                	ld	s3,56(sp)
    80004ee6:	7a42                	ld	s4,48(sp)
    80004ee8:	7aa2                	ld	s5,40(sp)
    80004eea:	6125                	addi	sp,sp,96
    80004eec:	8082                	ret
      if(i == 0)
    80004eee:	fc099ce3          	bnez	s3,80004ec6 <piperead+0xc2>
        i = -1;
    80004ef2:	89aa                	mv	s3,a0
    80004ef4:	bfc9                	j	80004ec6 <piperead+0xc2>

0000000080004ef6 <ulazymalloc>:
//static int loadseg(pde_t *, uint64, struct inode *, uint, uint);
struct inode* create(char *path, short type, short major, short minor);
uint64 ulazymalloc(pagetable_t pagetable, uint64 va_start, uint64 va_end, int xperm){
uint64 a;

  if(va_end < va_start)
    80004ef6:	04b66a63          	bltu	a2,a1,80004f4a <ulazymalloc+0x54>
uint64 ulazymalloc(pagetable_t pagetable, uint64 va_start, uint64 va_end, int xperm){
    80004efa:	7139                	addi	sp,sp,-64
    80004efc:	fc06                	sd	ra,56(sp)
    80004efe:	f822                	sd	s0,48(sp)
    80004f00:	f426                	sd	s1,40(sp)
    80004f02:	f04a                	sd	s2,32(sp)
    80004f04:	e852                	sd	s4,16(sp)
    80004f06:	0080                	addi	s0,sp,64
    80004f08:	8a2a                	mv	s4,a0
    80004f0a:	8932                	mv	s2,a2
    return va_start;

  va_start = PGROUNDUP(va_start);
    80004f0c:	6785                	lui	a5,0x1
    80004f0e:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    80004f10:	95be                	add	a1,a1,a5
    80004f12:	77fd                	lui	a5,0xfffff
    80004f14:	00f5f4b3          	and	s1,a1,a5
  for(a = va_start; a < va_end; a += PGSIZE){
    80004f18:	02c4fb63          	bgeu	s1,a2,80004f4e <ulazymalloc+0x58>
    80004f1c:	ec4e                	sd	s3,24(sp)
    80004f1e:	e456                	sd	s5,8(sp)
    80004f20:	e05a                	sd	s6,0(sp)
    pte_t *pte = walk(pagetable, a, 1);
    80004f22:	4a85                	li	s5,1
      // In case of failure, we don't have a simple way to deallocate just this segment,
      // so we let kexec handle the full cleanup.
      return 0;
    }
    // Mark as User-accessible with given permissions, but NOT valid (PTE_V=0).
    *pte = PTE_U | xperm;
    80004f24:	0106e993          	ori	s3,a3,16
  for(a = va_start; a < va_end; a += PGSIZE){
    80004f28:	6b05                	lui	s6,0x1
    pte_t *pte = walk(pagetable, a, 1);
    80004f2a:	8656                	mv	a2,s5
    80004f2c:	85a6                	mv	a1,s1
    80004f2e:	8552                	mv	a0,s4
    80004f30:	85cfc0ef          	jal	80000f8c <walk>
    if(pte == 0){
    80004f34:	cd19                	beqz	a0,80004f52 <ulazymalloc+0x5c>
    *pte = PTE_U | xperm;
    80004f36:	01353023          	sd	s3,0(a0)
  for(a = va_start; a < va_end; a += PGSIZE){
    80004f3a:	94da                	add	s1,s1,s6
    80004f3c:	ff24e7e3          	bltu	s1,s2,80004f2a <ulazymalloc+0x34>
  }
  return va_end;
    80004f40:	854a                	mv	a0,s2
    80004f42:	69e2                	ld	s3,24(sp)
    80004f44:	6aa2                	ld	s5,8(sp)
    80004f46:	6b02                	ld	s6,0(sp)
    80004f48:	a801                	j	80004f58 <ulazymalloc+0x62>
    return va_start;
    80004f4a:	852e                	mv	a0,a1
}
    80004f4c:	8082                	ret
  return va_end;
    80004f4e:	8532                	mv	a0,a2
    80004f50:	a021                	j	80004f58 <ulazymalloc+0x62>
    80004f52:	69e2                	ld	s3,24(sp)
    80004f54:	6aa2                	ld	s5,8(sp)
    80004f56:	6b02                	ld	s6,0(sp)
}
    80004f58:	70e2                	ld	ra,56(sp)
    80004f5a:	7442                	ld	s0,48(sp)
    80004f5c:	74a2                	ld	s1,40(sp)
    80004f5e:	7902                	ld	s2,32(sp)
    80004f60:	6a42                	ld	s4,16(sp)
    80004f62:	6121                	addi	sp,sp,64
    80004f64:	8082                	ret

0000000080004f66 <flags2perm>:
// map ELF permissions to PTE permission bits.
int flags2perm(int flags)
{
    80004f66:	1141                	addi	sp,sp,-16
    80004f68:	e406                	sd	ra,8(sp)
    80004f6a:	e022                	sd	s0,0(sp)
    80004f6c:	0800                	addi	s0,sp,16
    80004f6e:	87aa                	mv	a5,a0
    int perm = 0;
    if(flags & 0x1)
    80004f70:	0035151b          	slliw	a0,a0,0x3
    80004f74:	8921                	andi	a0,a0,8
      perm = PTE_X;
    if(flags & 0x2)
    80004f76:	0027f713          	andi	a4,a5,2
    80004f7a:	c319                	beqz	a4,80004f80 <flags2perm+0x1a>
      perm |= PTE_W;
    80004f7c:	00456513          	ori	a0,a0,4
    if(flags & ELF_PROG_FLAG_READ)
    80004f80:	8b91                	andi	a5,a5,4
    80004f82:	c399                	beqz	a5,80004f88 <flags2perm+0x22>
      perm |= PTE_R;
    80004f84:	00256513          	ori	a0,a0,2
    return perm;
}
    80004f88:	60a2                	ld	ra,8(sp)
    80004f8a:	6402                	ld	s0,0(sp)
    80004f8c:	0141                	addi	sp,sp,16
    80004f8e:	8082                	ret

0000000080004f90 <itoa>:
void
itoa(int n, char *buf, int min_width)
{
    80004f90:	1141                	addi	sp,sp,-16
    80004f92:	e406                	sd	ra,8(sp)
    80004f94:	e022                	sd	s0,0(sp)
    80004f96:	0800                	addi	s0,sp,16
  int i = 0;
  if (n == 0) {
    80004f98:	c921                	beqz	a0,80004fe8 <itoa+0x58>
    buf[i++] = '0';
  } else {
    // Generate digits in reverse order.
    while(n > 0){
    80004f9a:	86ae                	mv	a3,a1
      buf[i++] = (n % 10) + '0';
    80004f9c:	666668b7          	lui	a7,0x66666
    80004fa0:	66788893          	addi	a7,a7,1639 # 66666667 <_entry-0x19999999>
    while(n > 0){
    80004fa4:	4325                	li	t1,9
    80004fa6:	02a05f63          	blez	a0,80004fe4 <itoa+0x54>
      buf[i++] = (n % 10) + '0';
    80004faa:	03150733          	mul	a4,a0,a7
    80004fae:	9709                	srai	a4,a4,0x22
    80004fb0:	41f5579b          	sraiw	a5,a0,0x1f
    80004fb4:	9f1d                	subw	a4,a4,a5
    80004fb6:	0027179b          	slliw	a5,a4,0x2
    80004fba:	9fb9                	addw	a5,a5,a4
    80004fbc:	0017979b          	slliw	a5,a5,0x1
    80004fc0:	40f507bb          	subw	a5,a0,a5
    80004fc4:	0307879b          	addiw	a5,a5,48 # fffffffffffff030 <end+0xffffffff7dd98b58>
    80004fc8:	00f68023          	sb	a5,0(a3)
      n /= 10;
    80004fcc:	882a                	mv	a6,a0
    80004fce:	853a                	mv	a0,a4
    while(n > 0){
    80004fd0:	87b6                	mv	a5,a3
    80004fd2:	0685                	addi	a3,a3,1
    80004fd4:	fd034be3          	blt	t1,a6,80004faa <itoa+0x1a>
      buf[i++] = (n % 10) + '0';
    80004fd8:	40b786bb          	subw	a3,a5,a1
    80004fdc:	2685                	addiw	a3,a3,1
    }
  }

  // Add padding if needed.
  while(i < min_width){
    80004fde:	00c6cc63          	blt	a3,a2,80004ff6 <itoa+0x66>
    80004fe2:	a081                	j	80005022 <itoa+0x92>
  int i = 0;
    80004fe4:	4681                	li	a3,0
    80004fe6:	a031                	j	80004ff2 <itoa+0x62>
    buf[i++] = '0';
    80004fe8:	03000793          	li	a5,48
    80004fec:	00f58023          	sb	a5,0(a1)
    80004ff0:	4685                	li	a3,1
  while(i < min_width){
    80004ff2:	06c6d963          	bge	a3,a2,80005064 <itoa+0xd4>
    80004ff6:	87b6                	mv	a5,a3
    buf[i++] = '0';
    80004ff8:	03000513          	li	a0,48
    80004ffc:	00f58733          	add	a4,a1,a5
    80005000:	00a70023          	sb	a0,0(a4)
  while(i < min_width){
    80005004:	0785                	addi	a5,a5,1
    80005006:	0007871b          	sext.w	a4,a5
    8000500a:	fec749e3          	blt	a4,a2,80004ffc <itoa+0x6c>
    8000500e:	87b6                	mv	a5,a3
    80005010:	4701                	li	a4,0
    80005012:	00c6d563          	bge	a3,a2,8000501c <itoa+0x8c>
    80005016:	fff6071b          	addiw	a4,a2,-1
    8000501a:	9f15                	subw	a4,a4,a3
    8000501c:	2785                	addiw	a5,a5,1
    8000501e:	00f706bb          	addw	a3,a4,a5
  }

  buf[i] = '\0';
    80005022:	00d587b3          	add	a5,a1,a3
    80005026:	00078023          	sb	zero,0(a5)

  // Reverse the entire string to get the correct order.
  for(int j = 0; j < i/2; j++){
    8000502a:	4785                	li	a5,1
    8000502c:	02d7d863          	bge	a5,a3,8000505c <itoa+0xcc>
    80005030:	01f6d51b          	srliw	a0,a3,0x1f
    80005034:	9d35                	addw	a0,a0,a3
    80005036:	4015551b          	sraiw	a0,a0,0x1
    8000503a:	87ae                	mv	a5,a1
    8000503c:	15fd                	addi	a1,a1,-1
    8000503e:	95b6                	add	a1,a1,a3
    80005040:	4701                	li	a4,0
    char temp = buf[j];
    80005042:	0007c683          	lbu	a3,0(a5)
    buf[j] = buf[i-j-1];
    80005046:	0005c603          	lbu	a2,0(a1)
    8000504a:	00c78023          	sb	a2,0(a5)
    buf[i-j-1] = temp;
    8000504e:	00d58023          	sb	a3,0(a1)
  for(int j = 0; j < i/2; j++){
    80005052:	2705                	addiw	a4,a4,1
    80005054:	0785                	addi	a5,a5,1
    80005056:	15fd                	addi	a1,a1,-1
    80005058:	fea745e3          	blt	a4,a0,80005042 <itoa+0xb2>
  }
}
    8000505c:	60a2                	ld	ra,8(sp)
    8000505e:	6402                	ld	s0,0(sp)
    80005060:	0141                	addi	sp,sp,16
    80005062:	8082                	ret
  buf[i] = '\0';
    80005064:	96ae                	add	a3,a3,a1
    80005066:	00068023          	sb	zero,0(a3)
  for(int j = 0; j < i/2; j++){
    8000506a:	bfcd                	j	8000505c <itoa+0xcc>

000000008000506c <strcat>:


char*
strcat(char *dest, const char *src)
{
    8000506c:	1141                	addi	sp,sp,-16
    8000506e:	e406                	sd	ra,8(sp)
    80005070:	e022                	sd	s0,0(sp)
    80005072:	0800                	addi	s0,sp,16
    char *d = dest;
    // Move pointer to the end of the destination string.
    while (*d) {
    80005074:	00054783          	lbu	a5,0(a0)
    80005078:	c38d                	beqz	a5,8000509a <strcat+0x2e>
    char *d = dest;
    8000507a:	87aa                	mv	a5,a0
        d++;
    8000507c:	0785                	addi	a5,a5,1
    while (*d) {
    8000507e:	0007c703          	lbu	a4,0(a5)
    80005082:	ff6d                	bnez	a4,8000507c <strcat+0x10>
    }
    // Copy characters from source to the end of destination.
    while ((*d++ = *src++)) {
    80005084:	0585                	addi	a1,a1,1
    80005086:	0785                	addi	a5,a5,1
    80005088:	fff5c703          	lbu	a4,-1(a1)
    8000508c:	fee78fa3          	sb	a4,-1(a5)
    80005090:	fb75                	bnez	a4,80005084 <strcat+0x18>
        ;
    }
    return dest;
}
    80005092:	60a2                	ld	ra,8(sp)
    80005094:	6402                	ld	s0,0(sp)
    80005096:	0141                	addi	sp,sp,16
    80005098:	8082                	ret
    char *d = dest;
    8000509a:	87aa                	mv	a5,a0
    8000509c:	b7e5                	j	80005084 <strcat+0x18>

000000008000509e <kexec>:
//
// In kernel/exec.c, replace the existing kexec function

int
kexec(char *path, char **argv)
{
    8000509e:	db010113          	addi	sp,sp,-592
    800050a2:	24113423          	sd	ra,584(sp)
    800050a6:	24813023          	sd	s0,576(sp)
    800050aa:	22913c23          	sd	s1,568(sp)
    800050ae:	23213823          	sd	s2,560(sp)
    800050b2:	23313423          	sd	s3,552(sp)
    800050b6:	21813023          	sd	s8,512(sp)
    800050ba:	ffe6                	sd	s9,504(sp)
    800050bc:	0c80                	addi	s0,sp,592
    800050be:	8c2a                	mv	s8,a0
    800050c0:	8cae                	mv	s9,a1
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pagetable_t pagetable = 0, oldpagetable;
  struct proc *p = myproc();
    800050c2:	e65fc0ef          	jal	80001f26 <myproc>
    800050c6:	892a                	mv	s2,a0
  char pid_str[16];
  char swap_path[32];
  safestrcpy(swap_path,"/pgswp",sizeof(swap_path));
    800050c8:	de840493          	addi	s1,s0,-536
    800050cc:	02000613          	li	a2,32
    800050d0:	00003597          	auipc	a1,0x3
    800050d4:	7a058593          	addi	a1,a1,1952 # 80008870 <etext+0x870>
    800050d8:	8526                	mv	a0,s1
    800050da:	d73fb0ef          	jal	80000e4c <safestrcpy>
  safestrcpy(p->swap_path,swap_path,sizeof(swap_path));
    800050de:	02000613          	li	a2,32
    800050e2:	85a6                	mv	a1,s1
    800050e4:	00089537          	lui	a0,0x89
    800050e8:	1b450513          	addi	a0,a0,436 # 891b4 <_entry-0x7ff76e4c>
    800050ec:	954a                	add	a0,a0,s2
    800050ee:	d5ffb0ef          	jal	80000e4c <safestrcpy>
  itoa(p->pid,pid_str,5);
    800050f2:	e0840993          	addi	s3,s0,-504
    800050f6:	4615                	li	a2,5
    800050f8:	85ce                	mv	a1,s3
    800050fa:	03092503          	lw	a0,48(s2)
    800050fe:	e93ff0ef          	jal	80004f90 <itoa>
  strcat(swap_path,pid_str);
    80005102:	85ce                	mv	a1,s3
    80005104:	8526                	mv	a0,s1
    80005106:	f67ff0ef          	jal	8000506c <strcat>
  uint64 text_start = -1, text_end = 0;
  uint64 data_start = -1, data_end = 0;

  begin_op();
    8000510a:	b9cff0ef          	jal	800044a6 <begin_op>
  // 'create' returns an inode pointer (the on-disk representation).
 ip = create(swap_path, T_FILE, 0, 0);
    8000510e:	4681                	li	a3,0
    80005110:	4601                	li	a2,0
    80005112:	4589                	li	a1,2
    80005114:	8526                	mv	a0,s1
    80005116:	03f000ef          	jal	80005954 <create>
  if(ip == 0){
    8000511a:	cd51                	beqz	a0,800051b6 <kexec+0x118>
    8000511c:	84aa                	mv	s1,a0
    end_op();
    goto bad;
  }

  // Allocate a 'file' structure (the in-memory handle).
  if((p->swap_file = filealloc()) == 0){
    8000511e:	f08ff0ef          	jal	80004826 <filealloc>
    80005122:	16a93c23          	sd	a0,376(s2)
    80005126:	cd41                	beqz	a0,800051be <kexec+0x120>
    end_op();
    goto bad;
  }

  // Configure the file handle.
  p->swap_file->type = FD_INODE;
    80005128:	4789                	li	a5,2
    8000512a:	c11c                	sw	a5,0(a0)
  p->swap_file->ip = ip; // Link the handle to the on-disk inode.
    8000512c:	17893783          	ld	a5,376(s2)
    80005130:	ef84                	sd	s1,24(a5)
  p->swap_file->readable = 1;
    80005132:	17893703          	ld	a4,376(s2)
    80005136:	4785                	li	a5,1
    80005138:	00f70423          	sb	a5,8(a4)
  p->swap_file->writable = 1;
    8000513c:	17893703          	ld	a4,376(s2)
    80005140:	00f704a3          	sb	a5,9(a4)

  iunlock(ip ); // Unlock the inode; create() returns it locked.
    80005144:	8526                	mv	a0,s1
    80005146:	a03fe0ef          	jal	80003b48 <iunlock>
  end_op();
    8000514a:	bccff0ef          	jal	80004516 <end_op>

  begin_op();
    8000514e:	b58ff0ef          	jal	800044a6 <begin_op>

  if((ip = namei(path)) == 0){
    80005152:	8562                	mv	a0,s8
    80005154:	974ff0ef          	jal	800042c8 <namei>
    80005158:	84aa                	mv	s1,a0
    8000515a:	c925                	beqz	a0,800051ca <kexec+0x12c>
    end_op();
    printf("exec checkpoint FAIL: namei failed\n");
    return -1;
  }
  ilock(ip);
    8000515c:	93ffe0ef          	jal	80003a9a <ilock>
   // Read the ELF header.
  if(readi(ip, 0, (uint64)&elf, 0, sizeof(elf)) != sizeof(elf))
    80005160:	04000713          	li	a4,64
    80005164:	4681                	li	a3,0
    80005166:	e5040613          	addi	a2,s0,-432
    8000516a:	4581                	li	a1,0
    8000516c:	8526                	mv	a0,s1
    8000516e:	cbffe0ef          	jal	80003e2c <readi>
    80005172:	04000793          	li	a5,64
    80005176:	00f51a63          	bne	a0,a5,8000518a <kexec+0xec>
    goto bad;

  if(elf.magic != ELF_MAGIC)
    8000517a:	e5042703          	lw	a4,-432(s0)
    8000517e:	464c47b7          	lui	a5,0x464c4
    80005182:	57f78793          	addi	a5,a5,1407 # 464c457f <_entry-0x39b3ba81>
    80005186:	04f70c63          	beq	a4,a5,800051de <kexec+0x140>

bad:
  if(pagetable)
      proc_freepagetable(pagetable, sz);
  if(ip){
      iunlockput(ip);
    8000518a:	8526                	mv	a0,s1
    8000518c:	b1bfe0ef          	jal	80003ca6 <iunlockput>
      end_op();
    80005190:	b86ff0ef          	jal	80004516 <end_op>
  }
  return -1;
    80005194:	557d                	li	a0,-1
}
    80005196:	24813083          	ld	ra,584(sp)
    8000519a:	24013403          	ld	s0,576(sp)
    8000519e:	23813483          	ld	s1,568(sp)
    800051a2:	23013903          	ld	s2,560(sp)
    800051a6:	22813983          	ld	s3,552(sp)
    800051aa:	20013c03          	ld	s8,512(sp)
    800051ae:	7cfe                	ld	s9,504(sp)
    800051b0:	25010113          	addi	sp,sp,592
    800051b4:	8082                	ret
    end_op();
    800051b6:	b60ff0ef          	jal	80004516 <end_op>
  return -1;
    800051ba:	557d                	li	a0,-1
    800051bc:	bfe9                	j	80005196 <kexec+0xf8>
    iunlockput(ip); // Clean up the created inode if filealloc fails.
    800051be:	8526                	mv	a0,s1
    800051c0:	ae7fe0ef          	jal	80003ca6 <iunlockput>
    end_op();
    800051c4:	b52ff0ef          	jal	80004516 <end_op>
  if(pagetable)
    800051c8:	b7c9                	j	8000518a <kexec+0xec>
    end_op();
    800051ca:	b4cff0ef          	jal	80004516 <end_op>
    printf("exec checkpoint FAIL: namei failed\n");
    800051ce:	00003517          	auipc	a0,0x3
    800051d2:	6aa50513          	addi	a0,a0,1706 # 80008878 <etext+0x878>
    800051d6:	b24fb0ef          	jal	800004fa <printf>
    return -1;
    800051da:	557d                	li	a0,-1
    800051dc:	bf6d                	j	80005196 <kexec+0xf8>
    800051de:	f7ee                	sd	s11,488(sp)
  if((pagetable = proc_pagetable(p)) == 0)
    800051e0:	854a                	mv	a0,s2
    800051e2:	e4ffc0ef          	jal	80002030 <proc_pagetable>
    800051e6:	8daa                	mv	s11,a0
    800051e8:	2c050863          	beqz	a0,800054b8 <kexec+0x41a>
    800051ec:	23413023          	sd	s4,544(sp)
    800051f0:	21513c23          	sd	s5,536(sp)
    800051f4:	21613823          	sd	s6,528(sp)
    800051f8:	21713423          	sd	s7,520(sp)
    800051fc:	fbea                	sd	s10,496(sp)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    800051fe:	e8845783          	lhu	a5,-376(s0)
    80005202:	cbe5                	beqz	a5,800052f2 <kexec+0x254>
    80005204:	e7042683          	lw	a3,-400(s0)
  uint64 data_start = -1, data_end = 0;
    80005208:	da043c23          	sd	zero,-584(s0)
    8000520c:	57fd                	li	a5,-1
    8000520e:	dcf43423          	sd	a5,-568(s0)
  uint64 text_start = -1, text_end = 0;
    80005212:	dc043023          	sd	zero,-576(s0)
    80005216:	dcf43823          	sd	a5,-560(s0)
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    8000521a:	4d01                	li	s10,0
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    8000521c:	4a81                	li	s5,0
      if(readi(ip, 0, (uint64)&ph, off, sizeof(ph)) != sizeof(ph))
    8000521e:	03800b13          	li	s6,56
      if(ph.vaddr % PGSIZE != 0)
    80005222:	6785                	lui	a5,0x1
    80005224:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    80005226:	dcf43c23          	sd	a5,-552(s0)
    8000522a:	a091                	j	8000526e <kexec+0x1d0>
          if (text_start == -1 || ph.vaddr < text_start) text_start = ph.vaddr;
    8000522c:	dd443823          	sd	s4,-560(s0)
          if (ph.vaddr + ph.memsz > text_end) text_end = ph.vaddr + ph.memsz;
    80005230:	dc043783          	ld	a5,-576(s0)
    80005234:	0137f463          	bgeu	a5,s3,8000523c <kexec+0x19e>
    80005238:	dd343023          	sd	s3,-576(s0)
      if((ulazymalloc(pagetable, ph.vaddr, ph.vaddr + ph.memsz, flags2perm(ph.flags))) == 0)
    8000523c:	d2bff0ef          	jal	80004f66 <flags2perm>
    80005240:	86aa                	mv	a3,a0
    80005242:	864e                	mv	a2,s3
    80005244:	85d2                	mv	a1,s4
    80005246:	856e                	mv	a0,s11
    80005248:	cafff0ef          	jal	80004ef6 <ulazymalloc>
    8000524c:	26050863          	beqz	a0,800054bc <kexec+0x41e>
      if(ph.vaddr + ph.memsz > sz)
    80005250:	e2843783          	ld	a5,-472(s0)
    80005254:	e4043703          	ld	a4,-448(s0)
    80005258:	97ba                	add	a5,a5,a4
    8000525a:	00fd7363          	bgeu	s10,a5,80005260 <kexec+0x1c2>
    8000525e:	8d3e                	mv	s10,a5
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80005260:	2a85                	addiw	s5,s5,1
    80005262:	038b869b          	addiw	a3,s7,56
    80005266:	e8845783          	lhu	a5,-376(s0)
    8000526a:	08fade63          	bge	s5,a5,80005306 <kexec+0x268>
      if(readi(ip, 0, (uint64)&ph, off, sizeof(ph)) != sizeof(ph))
    8000526e:	8bb6                	mv	s7,a3
    80005270:	875a                	mv	a4,s6
    80005272:	e1840613          	addi	a2,s0,-488
    80005276:	4581                	li	a1,0
    80005278:	8526                	mv	a0,s1
    8000527a:	bb3fe0ef          	jal	80003e2c <readi>
    8000527e:	23651f63          	bne	a0,s6,800054bc <kexec+0x41e>
      if(ph.type != ELF_PROG_LOAD)
    80005282:	e1842783          	lw	a5,-488(s0)
    80005286:	4705                	li	a4,1
    80005288:	fce79ce3          	bne	a5,a4,80005260 <kexec+0x1c2>
      if(ph.memsz < ph.filesz)
    8000528c:	e4043983          	ld	s3,-448(s0)
    80005290:	e3843783          	ld	a5,-456(s0)
    80005294:	22f9e463          	bltu	s3,a5,800054bc <kexec+0x41e>
      if(ph.vaddr + ph.memsz < ph.vaddr)
    80005298:	e2843a03          	ld	s4,-472(s0)
    8000529c:	99d2                	add	s3,s3,s4
    8000529e:	2149ef63          	bltu	s3,s4,800054bc <kexec+0x41e>
      if(ph.vaddr % PGSIZE != 0)
    800052a2:	dd843783          	ld	a5,-552(s0)
    800052a6:	00fa77b3          	and	a5,s4,a5
    800052aa:	20079963          	bnez	a5,800054bc <kexec+0x41e>
      if (ph.flags & ELF_PROG_FLAG_EXEC) { // Text segment
    800052ae:	e1c42503          	lw	a0,-484(s0)
    800052b2:	00e577b3          	and	a5,a0,a4
    800052b6:	cb99                	beqz	a5,800052cc <kexec+0x22e>
          if (text_start == -1 || ph.vaddr < text_start) text_start = ph.vaddr;
    800052b8:	dd043783          	ld	a5,-560(s0)
    800052bc:	577d                	li	a4,-1
    800052be:	f6e787e3          	beq	a5,a4,8000522c <kexec+0x18e>
    800052c2:	f6fa77e3          	bgeu	s4,a5,80005230 <kexec+0x192>
    800052c6:	dd443823          	sd	s4,-560(s0)
    800052ca:	b79d                	j	80005230 <kexec+0x192>
          if (data_start == -1 || ph.vaddr < data_start) data_start = ph.vaddr;
    800052cc:	dc843783          	ld	a5,-568(s0)
    800052d0:	577d                	li	a4,-1
    800052d2:	00e78763          	beq	a5,a4,800052e0 <kexec+0x242>
    800052d6:	00fa7763          	bgeu	s4,a5,800052e4 <kexec+0x246>
    800052da:	dd443423          	sd	s4,-568(s0)
    800052de:	a019                	j	800052e4 <kexec+0x246>
    800052e0:	dd443423          	sd	s4,-568(s0)
          if (ph.vaddr + ph.memsz > data_end) data_end = ph.vaddr + ph.memsz;
    800052e4:	db843783          	ld	a5,-584(s0)
    800052e8:	f537fae3          	bgeu	a5,s3,8000523c <kexec+0x19e>
    800052ec:	db343c23          	sd	s3,-584(s0)
    800052f0:	b7b1                	j	8000523c <kexec+0x19e>
  uint64 data_start = -1, data_end = 0;
    800052f2:	da043c23          	sd	zero,-584(s0)
    800052f6:	57fd                	li	a5,-1
    800052f8:	dcf43423          	sd	a5,-568(s0)
  uint64 text_start = -1, text_end = 0;
    800052fc:	dc043023          	sd	zero,-576(s0)
    80005300:	dcf43823          	sd	a5,-560(s0)
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    80005304:	4d01                	li	s10,0
  p->exec_ip = idup(ip);
    80005306:	8526                	mv	a0,s1
    80005308:	f5cfe0ef          	jal	80003a64 <idup>
    8000530c:	16a93823          	sd	a0,368(s2)
  iunlockput(ip);
    80005310:	8526                	mv	a0,s1
    80005312:	995fe0ef          	jal	80003ca6 <iunlockput>
  end_op();
    80005316:	a00ff0ef          	jal	80004516 <end_op>
  p = myproc();
    8000531a:	c0dfc0ef          	jal	80001f26 <myproc>
    8000531e:	892a                	mv	s2,a0
    80005320:	dca43c23          	sd	a0,-552(s0)
  uint64 oldsz = p->sz;
    80005324:	653c                	ld	a5,72(a0)
    80005326:	daf43823          	sd	a5,-592(s0)
  p->heap_start = sz;
    8000532a:	17a53423          	sd	s10,360(a0)
  sz = PGROUNDUP(sz);
    8000532e:	6485                	lui	s1,0x1
    80005330:	14fd                	addi	s1,s1,-1 # fff <_entry-0x7ffff001>
    80005332:	94ea                	add	s1,s1,s10
    80005334:	77fd                	lui	a5,0xfffff
    80005336:	8cfd                	and	s1,s1,a5
  if((sz1 = uvmalloc(pagetable, sz, sz + (USERSTACK+1)*PGSIZE, PTE_W)) == 0)
    80005338:	4691                	li	a3,4
    8000533a:	6609                	lui	a2,0x2
    8000533c:	9626                	add	a2,a2,s1
    8000533e:	85a6                	mv	a1,s1
    80005340:	856e                	mv	a0,s11
    80005342:	d4efc0ef          	jal	80001890 <uvmalloc>
    80005346:	8d2a                	mv	s10,a0
    80005348:	e10d                	bnez	a0,8000536a <kexec+0x2cc>
      proc_freepagetable(pagetable, sz);
    8000534a:	85a6                	mv	a1,s1
    8000534c:	856e                	mv	a0,s11
    8000534e:	d67fc0ef          	jal	800020b4 <proc_freepagetable>
  return -1;
    80005352:	557d                	li	a0,-1
    80005354:	22013a03          	ld	s4,544(sp)
    80005358:	21813a83          	ld	s5,536(sp)
    8000535c:	21013b03          	ld	s6,528(sp)
    80005360:	20813b83          	ld	s7,520(sp)
    80005364:	7d5e                	ld	s10,496(sp)
    80005366:	7dbe                	ld	s11,488(sp)
    80005368:	b53d                	j	80005196 <kexec+0xf8>
  uvmclear(pagetable, sz-(USERSTACK+1)*PGSIZE);
    8000536a:	75f9                	lui	a1,0xffffe
    8000536c:	84aa                	mv	s1,a0
    8000536e:	95aa                	add	a1,a1,a0
    80005370:	856e                	mv	a0,s11
    80005372:	f0afc0ef          	jal	80001a7c <uvmclear>
  stackbase = sp - USERSTACK*PGSIZE;
    80005376:	800d0a13          	addi	s4,s10,-2048
    8000537a:	800a0a13          	addi	s4,s4,-2048
  printf("[pid %d] INIT-LAZYMAP text=[0x%lx,0x%lx) data=[0x%lx,0x%lx) heap_start=0x%lx stack_top=0x%lx\n",
    8000537e:	88ea                	mv	a7,s10
    80005380:	16893803          	ld	a6,360(s2)
    80005384:	db843783          	ld	a5,-584(s0)
    80005388:	dc843703          	ld	a4,-568(s0)
    8000538c:	dc043683          	ld	a3,-576(s0)
    80005390:	dd043603          	ld	a2,-560(s0)
    80005394:	03092583          	lw	a1,48(s2)
    80005398:	00003517          	auipc	a0,0x3
    8000539c:	50850513          	addi	a0,a0,1288 # 800088a0 <etext+0x8a0>
    800053a0:	95afb0ef          	jal	800004fa <printf>
  for(argc = 0; argv[argc]; argc++) {
    800053a4:	000cb503          	ld	a0,0(s9)
    800053a8:	4a81                	li	s5,0
      ustack[argc] = sp;
    800053aa:	e9040993          	addi	s3,s0,-368
      if(argc >= MAXARG)
    800053ae:	02000913          	li	s2,32
  for(argc = 0; argv[argc]; argc++) {
    800053b2:	c921                	beqz	a0,80005402 <kexec+0x364>
      sp -= strlen(argv[argc]) + 1;
    800053b4:	acffb0ef          	jal	80000e82 <strlen>
    800053b8:	2505                	addiw	a0,a0,1
    800053ba:	40a48533          	sub	a0,s1,a0
      sp -= sp % 16; // riscv sp must be 16-byte aligned
    800053be:	ff057493          	andi	s1,a0,-16
      if(sp < stackbase)
    800053c2:	1144ec63          	bltu	s1,s4,800054da <kexec+0x43c>
      if(copyout(pagetable, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
    800053c6:	8be6                	mv	s7,s9
    800053c8:	000cbb03          	ld	s6,0(s9)
    800053cc:	855a                	mv	a0,s6
    800053ce:	ab5fb0ef          	jal	80000e82 <strlen>
    800053d2:	0015069b          	addiw	a3,a0,1
    800053d6:	865a                	mv	a2,s6
    800053d8:	85a6                	mv	a1,s1
    800053da:	856e                	mv	a0,s11
    800053dc:	ecafc0ef          	jal	80001aa6 <copyout>
    800053e0:	0e054f63          	bltz	a0,800054de <kexec+0x440>
      ustack[argc] = sp;
    800053e4:	003a9793          	slli	a5,s5,0x3
    800053e8:	97ce                	add	a5,a5,s3
    800053ea:	e384                	sd	s1,0(a5)
  for(argc = 0; argv[argc]; argc++) {
    800053ec:	0a85                	addi	s5,s5,1
    800053ee:	008c8793          	addi	a5,s9,8
    800053f2:	8cbe                	mv	s9,a5
    800053f4:	008bb503          	ld	a0,8(s7)
    800053f8:	c509                	beqz	a0,80005402 <kexec+0x364>
      if(argc >= MAXARG)
    800053fa:	fb2a9de3          	bne	s5,s2,800053b4 <kexec+0x316>
  sz = sz1;
    800053fe:	84ea                	mv	s1,s10
    80005400:	b7a9                	j	8000534a <kexec+0x2ac>
  ustack[argc] = 0;
    80005402:	003a9793          	slli	a5,s5,0x3
    80005406:	fc078793          	addi	a5,a5,-64 # ffffffffffffefc0 <end+0xffffffff7dd98ae8>
    8000540a:	fd040713          	addi	a4,s0,-48
    8000540e:	97ba                	add	a5,a5,a4
    80005410:	f007b023          	sd	zero,-256(a5)
  sp -= (argc+1) * sizeof(uint64);
    80005414:	003a9693          	slli	a3,s5,0x3
    80005418:	06a1                	addi	a3,a3,8
    8000541a:	8c95                	sub	s1,s1,a3
  sp -= sp % 16;
    8000541c:	ff04fb13          	andi	s6,s1,-16
  sz = sz1;
    80005420:	84ea                	mv	s1,s10
  if(sp < stackbase)
    80005422:	f34b64e3          	bltu	s6,s4,8000534a <kexec+0x2ac>
  if(copyout(pagetable, sp, (char *)ustack, (argc+1)*sizeof(uint64)) < 0)
    80005426:	e9040613          	addi	a2,s0,-368
    8000542a:	85da                	mv	a1,s6
    8000542c:	856e                	mv	a0,s11
    8000542e:	e78fc0ef          	jal	80001aa6 <copyout>
    80005432:	f0054ce3          	bltz	a0,8000534a <kexec+0x2ac>
  p->trapframe->a1 = sp;
    80005436:	dd843783          	ld	a5,-552(s0)
    8000543a:	6fbc                	ld	a5,88(a5)
    8000543c:	0767bc23          	sd	s6,120(a5)
  for(last=s=path; *s; s++)
    80005440:	000c4703          	lbu	a4,0(s8)
    80005444:	cf11                	beqz	a4,80005460 <kexec+0x3c2>
    80005446:	001c0793          	addi	a5,s8,1
      if(*s == '/')
    8000544a:	02f00693          	li	a3,47
    8000544e:	a029                	j	80005458 <kexec+0x3ba>
  for(last=s=path; *s; s++)
    80005450:	0785                	addi	a5,a5,1
    80005452:	fff7c703          	lbu	a4,-1(a5)
    80005456:	c709                	beqz	a4,80005460 <kexec+0x3c2>
      if(*s == '/')
    80005458:	fed71ce3          	bne	a4,a3,80005450 <kexec+0x3b2>
          last = s+1;
    8000545c:	8c3e                	mv	s8,a5
    8000545e:	bfcd                	j	80005450 <kexec+0x3b2>
  safestrcpy(p->name, last, sizeof(p->name));
    80005460:	4641                	li	a2,16
    80005462:	85e2                	mv	a1,s8
    80005464:	dd843483          	ld	s1,-552(s0)
    80005468:	15848513          	addi	a0,s1,344
    8000546c:	9e1fb0ef          	jal	80000e4c <safestrcpy>
  oldpagetable = p->pagetable;
    80005470:	68a8                	ld	a0,80(s1)
  p->num_resident = 0; 
    80005472:	000897b7          	lui	a5,0x89
    80005476:	97a6                	add	a5,a5,s1
    80005478:	1a07a823          	sw	zero,432(a5) # 891b0 <_entry-0x7ff76e50>
  p->next_fifo_seq = 0;
    8000547c:	1c07a423          	sw	zero,456(a5)
  p->pagetable = pagetable;
    80005480:	05b4b823          	sd	s11,80(s1)
  p->sz = sz;
    80005484:	05a4b423          	sd	s10,72(s1)
  p->trapframe->epc = elf.entry;
    80005488:	6cbc                	ld	a5,88(s1)
    8000548a:	e6843703          	ld	a4,-408(s0)
    8000548e:	ef98                	sd	a4,24(a5)
  p->trapframe->sp = sp;
    80005490:	6cbc                	ld	a5,88(s1)
    80005492:	0367b823          	sd	s6,48(a5)
  proc_freepagetable(oldpagetable, oldsz);
    80005496:	db043583          	ld	a1,-592(s0)
    8000549a:	c1bfc0ef          	jal	800020b4 <proc_freepagetable>
  return argc;
    8000549e:	000a851b          	sext.w	a0,s5
    800054a2:	22013a03          	ld	s4,544(sp)
    800054a6:	21813a83          	ld	s5,536(sp)
    800054aa:	21013b03          	ld	s6,528(sp)
    800054ae:	20813b83          	ld	s7,520(sp)
    800054b2:	7d5e                	ld	s10,496(sp)
    800054b4:	7dbe                	ld	s11,488(sp)
    800054b6:	b1c5                	j	80005196 <kexec+0xf8>
    800054b8:	7dbe                	ld	s11,488(sp)
    800054ba:	b9c1                	j	8000518a <kexec+0xec>
      proc_freepagetable(pagetable, sz);
    800054bc:	85ea                	mv	a1,s10
    800054be:	856e                	mv	a0,s11
    800054c0:	bf5fc0ef          	jal	800020b4 <proc_freepagetable>
  if(ip){
    800054c4:	22013a03          	ld	s4,544(sp)
    800054c8:	21813a83          	ld	s5,536(sp)
    800054cc:	21013b03          	ld	s6,528(sp)
    800054d0:	20813b83          	ld	s7,520(sp)
    800054d4:	7d5e                	ld	s10,496(sp)
    800054d6:	7dbe                	ld	s11,488(sp)
    800054d8:	b94d                	j	8000518a <kexec+0xec>
  sz = sz1;
    800054da:	84ea                	mv	s1,s10
    800054dc:	b5bd                	j	8000534a <kexec+0x2ac>
    800054de:	84ea                	mv	s1,s10
    800054e0:	b5ad                	j	8000534a <kexec+0x2ac>

00000000800054e2 <argfd>:

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
{
    800054e2:	7179                	addi	sp,sp,-48
    800054e4:	f406                	sd	ra,40(sp)
    800054e6:	f022                	sd	s0,32(sp)
    800054e8:	ec26                	sd	s1,24(sp)
    800054ea:	e84a                	sd	s2,16(sp)
    800054ec:	1800                	addi	s0,sp,48
    800054ee:	892e                	mv	s2,a1
    800054f0:	84b2                	mv	s1,a2
  int fd;
  struct file *f;

  argint(n, &fd);
    800054f2:	fdc40593          	addi	a1,s0,-36
    800054f6:	bb7fd0ef          	jal	800030ac <argint>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
    800054fa:	fdc42703          	lw	a4,-36(s0)
    800054fe:	47bd                	li	a5,15
    80005500:	02e7ea63          	bltu	a5,a4,80005534 <argfd+0x52>
    80005504:	a23fc0ef          	jal	80001f26 <myproc>
    80005508:	fdc42703          	lw	a4,-36(s0)
    8000550c:	00371793          	slli	a5,a4,0x3
    80005510:	0d078793          	addi	a5,a5,208
    80005514:	953e                	add	a0,a0,a5
    80005516:	611c                	ld	a5,0(a0)
    80005518:	c385                	beqz	a5,80005538 <argfd+0x56>
    return -1;
  if(pfd)
    8000551a:	00090463          	beqz	s2,80005522 <argfd+0x40>
    *pfd = fd;
    8000551e:	00e92023          	sw	a4,0(s2)
  if(pf)
    *pf = f;
  return 0;
    80005522:	4501                	li	a0,0
  if(pf)
    80005524:	c091                	beqz	s1,80005528 <argfd+0x46>
    *pf = f;
    80005526:	e09c                	sd	a5,0(s1)
}
    80005528:	70a2                	ld	ra,40(sp)
    8000552a:	7402                	ld	s0,32(sp)
    8000552c:	64e2                	ld	s1,24(sp)
    8000552e:	6942                	ld	s2,16(sp)
    80005530:	6145                	addi	sp,sp,48
    80005532:	8082                	ret
    return -1;
    80005534:	557d                	li	a0,-1
    80005536:	bfcd                	j	80005528 <argfd+0x46>
    80005538:	557d                	li	a0,-1
    8000553a:	b7fd                	j	80005528 <argfd+0x46>

000000008000553c <fdalloc>:

// Allocate a file descriptor for the given file.
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
    8000553c:	1101                	addi	sp,sp,-32
    8000553e:	ec06                	sd	ra,24(sp)
    80005540:	e822                	sd	s0,16(sp)
    80005542:	e426                	sd	s1,8(sp)
    80005544:	1000                	addi	s0,sp,32
    80005546:	84aa                	mv	s1,a0
  int fd;
  struct proc *p = myproc();
    80005548:	9dffc0ef          	jal	80001f26 <myproc>
    8000554c:	862a                	mv	a2,a0

  for(fd = 0; fd < NOFILE; fd++){
    8000554e:	0d050793          	addi	a5,a0,208
    80005552:	4501                	li	a0,0
    80005554:	46c1                	li	a3,16
    if(p->ofile[fd] == 0){
    80005556:	6398                	ld	a4,0(a5)
    80005558:	cb19                	beqz	a4,8000556e <fdalloc+0x32>
  for(fd = 0; fd < NOFILE; fd++){
    8000555a:	2505                	addiw	a0,a0,1
    8000555c:	07a1                	addi	a5,a5,8
    8000555e:	fed51ce3          	bne	a0,a3,80005556 <fdalloc+0x1a>
      p->ofile[fd] = f;
      return fd;
    }
  }
  return -1;
    80005562:	557d                	li	a0,-1
}
    80005564:	60e2                	ld	ra,24(sp)
    80005566:	6442                	ld	s0,16(sp)
    80005568:	64a2                	ld	s1,8(sp)
    8000556a:	6105                	addi	sp,sp,32
    8000556c:	8082                	ret
      p->ofile[fd] = f;
    8000556e:	00351793          	slli	a5,a0,0x3
    80005572:	0d078793          	addi	a5,a5,208
    80005576:	963e                	add	a2,a2,a5
    80005578:	e204                	sd	s1,0(a2)
      return fd;
    8000557a:	b7ed                	j	80005564 <fdalloc+0x28>

000000008000557c <sys_dup>:

uint64
sys_dup(void)
{
    8000557c:	7179                	addi	sp,sp,-48
    8000557e:	f406                	sd	ra,40(sp)
    80005580:	f022                	sd	s0,32(sp)
    80005582:	1800                	addi	s0,sp,48
  struct file *f;
  int fd;

  if(argfd(0, 0, &f) < 0)
    80005584:	fd840613          	addi	a2,s0,-40
    80005588:	4581                	li	a1,0
    8000558a:	4501                	li	a0,0
    8000558c:	f57ff0ef          	jal	800054e2 <argfd>
    return -1;
    80005590:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0)
    80005592:	02054363          	bltz	a0,800055b8 <sys_dup+0x3c>
    80005596:	ec26                	sd	s1,24(sp)
    80005598:	e84a                	sd	s2,16(sp)
  if((fd=fdalloc(f)) < 0)
    8000559a:	fd843483          	ld	s1,-40(s0)
    8000559e:	8526                	mv	a0,s1
    800055a0:	f9dff0ef          	jal	8000553c <fdalloc>
    800055a4:	892a                	mv	s2,a0
    return -1;
    800055a6:	57fd                	li	a5,-1
  if((fd=fdalloc(f)) < 0)
    800055a8:	00054d63          	bltz	a0,800055c2 <sys_dup+0x46>
  filedup(f);
    800055ac:	8526                	mv	a0,s1
    800055ae:	ad6ff0ef          	jal	80004884 <filedup>
  return fd;
    800055b2:	87ca                	mv	a5,s2
    800055b4:	64e2                	ld	s1,24(sp)
    800055b6:	6942                	ld	s2,16(sp)
}
    800055b8:	853e                	mv	a0,a5
    800055ba:	70a2                	ld	ra,40(sp)
    800055bc:	7402                	ld	s0,32(sp)
    800055be:	6145                	addi	sp,sp,48
    800055c0:	8082                	ret
    800055c2:	64e2                	ld	s1,24(sp)
    800055c4:	6942                	ld	s2,16(sp)
    800055c6:	bfcd                	j	800055b8 <sys_dup+0x3c>

00000000800055c8 <sys_read>:

uint64
sys_read(void)
{
    800055c8:	7179                	addi	sp,sp,-48
    800055ca:	f406                	sd	ra,40(sp)
    800055cc:	f022                	sd	s0,32(sp)
    800055ce:	1800                	addi	s0,sp,48
  struct file *f;
  int n;
  uint64 p;

  argaddr(1, &p);
    800055d0:	fd840593          	addi	a1,s0,-40
    800055d4:	4505                	li	a0,1
    800055d6:	af3fd0ef          	jal	800030c8 <argaddr>
  argint(2, &n);
    800055da:	fe440593          	addi	a1,s0,-28
    800055de:	4509                	li	a0,2
    800055e0:	acdfd0ef          	jal	800030ac <argint>
  if(argfd(0, 0, &f) < 0)
    800055e4:	fe840613          	addi	a2,s0,-24
    800055e8:	4581                	li	a1,0
    800055ea:	4501                	li	a0,0
    800055ec:	ef7ff0ef          	jal	800054e2 <argfd>
    800055f0:	87aa                	mv	a5,a0
    return -1;
    800055f2:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    800055f4:	0007ca63          	bltz	a5,80005608 <sys_read+0x40>
  return fileread(f, p, n);
    800055f8:	fe442603          	lw	a2,-28(s0)
    800055fc:	fd843583          	ld	a1,-40(s0)
    80005600:	fe843503          	ld	a0,-24(s0)
    80005604:	beaff0ef          	jal	800049ee <fileread>
}
    80005608:	70a2                	ld	ra,40(sp)
    8000560a:	7402                	ld	s0,32(sp)
    8000560c:	6145                	addi	sp,sp,48
    8000560e:	8082                	ret

0000000080005610 <sys_write>:

uint64
sys_write(void)
{
    80005610:	7179                	addi	sp,sp,-48
    80005612:	f406                	sd	ra,40(sp)
    80005614:	f022                	sd	s0,32(sp)
    80005616:	1800                	addi	s0,sp,48
  struct file *f;
  int n;
  uint64 p;
  
  argaddr(1, &p);
    80005618:	fd840593          	addi	a1,s0,-40
    8000561c:	4505                	li	a0,1
    8000561e:	aabfd0ef          	jal	800030c8 <argaddr>
  argint(2, &n);
    80005622:	fe440593          	addi	a1,s0,-28
    80005626:	4509                	li	a0,2
    80005628:	a85fd0ef          	jal	800030ac <argint>
  if(argfd(0, 0, &f) < 0)
    8000562c:	fe840613          	addi	a2,s0,-24
    80005630:	4581                	li	a1,0
    80005632:	4501                	li	a0,0
    80005634:	eafff0ef          	jal	800054e2 <argfd>
    80005638:	87aa                	mv	a5,a0
    return -1;
    8000563a:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    8000563c:	0007ca63          	bltz	a5,80005650 <sys_write+0x40>

  return filewrite(f, p, n);
    80005640:	fe442603          	lw	a2,-28(s0)
    80005644:	fd843583          	ld	a1,-40(s0)
    80005648:	fe843503          	ld	a0,-24(s0)
    8000564c:	c66ff0ef          	jal	80004ab2 <filewrite>
}
    80005650:	70a2                	ld	ra,40(sp)
    80005652:	7402                	ld	s0,32(sp)
    80005654:	6145                	addi	sp,sp,48
    80005656:	8082                	ret

0000000080005658 <sys_close>:

uint64
sys_close(void)
{
    80005658:	1101                	addi	sp,sp,-32
    8000565a:	ec06                	sd	ra,24(sp)
    8000565c:	e822                	sd	s0,16(sp)
    8000565e:	1000                	addi	s0,sp,32
  int fd;
  struct file *f;

  if(argfd(0, &fd, &f) < 0)
    80005660:	fe040613          	addi	a2,s0,-32
    80005664:	fec40593          	addi	a1,s0,-20
    80005668:	4501                	li	a0,0
    8000566a:	e79ff0ef          	jal	800054e2 <argfd>
    return -1;
    8000566e:	57fd                	li	a5,-1
  if(argfd(0, &fd, &f) < 0)
    80005670:	02054163          	bltz	a0,80005692 <sys_close+0x3a>
  myproc()->ofile[fd] = 0;
    80005674:	8b3fc0ef          	jal	80001f26 <myproc>
    80005678:	fec42783          	lw	a5,-20(s0)
    8000567c:	078e                	slli	a5,a5,0x3
    8000567e:	0d078793          	addi	a5,a5,208
    80005682:	953e                	add	a0,a0,a5
    80005684:	00053023          	sd	zero,0(a0)
  fileclose(f);
    80005688:	fe043503          	ld	a0,-32(s0)
    8000568c:	a3eff0ef          	jal	800048ca <fileclose>
  return 0;
    80005690:	4781                	li	a5,0
}
    80005692:	853e                	mv	a0,a5
    80005694:	60e2                	ld	ra,24(sp)
    80005696:	6442                	ld	s0,16(sp)
    80005698:	6105                	addi	sp,sp,32
    8000569a:	8082                	ret

000000008000569c <sys_fstat>:

uint64
sys_fstat(void)
{
    8000569c:	1101                	addi	sp,sp,-32
    8000569e:	ec06                	sd	ra,24(sp)
    800056a0:	e822                	sd	s0,16(sp)
    800056a2:	1000                	addi	s0,sp,32
  struct file *f;
  uint64 st; // user pointer to struct stat

  argaddr(1, &st);
    800056a4:	fe040593          	addi	a1,s0,-32
    800056a8:	4505                	li	a0,1
    800056aa:	a1ffd0ef          	jal	800030c8 <argaddr>
  if(argfd(0, 0, &f) < 0)
    800056ae:	fe840613          	addi	a2,s0,-24
    800056b2:	4581                	li	a1,0
    800056b4:	4501                	li	a0,0
    800056b6:	e2dff0ef          	jal	800054e2 <argfd>
    800056ba:	87aa                	mv	a5,a0
    return -1;
    800056bc:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    800056be:	0007c863          	bltz	a5,800056ce <sys_fstat+0x32>
  return filestat(f, st);
    800056c2:	fe043583          	ld	a1,-32(s0)
    800056c6:	fe843503          	ld	a0,-24(s0)
    800056ca:	ac2ff0ef          	jal	8000498c <filestat>
}
    800056ce:	60e2                	ld	ra,24(sp)
    800056d0:	6442                	ld	s0,16(sp)
    800056d2:	6105                	addi	sp,sp,32
    800056d4:	8082                	ret

00000000800056d6 <sys_link>:

// Create the path new as a link to the same inode as old.
uint64
sys_link(void)
{
    800056d6:	7169                	addi	sp,sp,-304
    800056d8:	f606                	sd	ra,296(sp)
    800056da:	f222                	sd	s0,288(sp)
    800056dc:	1a00                	addi	s0,sp,304
  char name[DIRSIZ], new[MAXPATH], old[MAXPATH];
  struct inode *dp, *ip;

  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    800056de:	08000613          	li	a2,128
    800056e2:	ed040593          	addi	a1,s0,-304
    800056e6:	4501                	li	a0,0
    800056e8:	9fdfd0ef          	jal	800030e4 <argstr>
    return -1;
    800056ec:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    800056ee:	0c054e63          	bltz	a0,800057ca <sys_link+0xf4>
    800056f2:	08000613          	li	a2,128
    800056f6:	f5040593          	addi	a1,s0,-176
    800056fa:	4505                	li	a0,1
    800056fc:	9e9fd0ef          	jal	800030e4 <argstr>
    return -1;
    80005700:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80005702:	0c054463          	bltz	a0,800057ca <sys_link+0xf4>
    80005706:	ee26                	sd	s1,280(sp)

  begin_op();
    80005708:	d9ffe0ef          	jal	800044a6 <begin_op>
  if((ip = namei(old)) == 0){
    8000570c:	ed040513          	addi	a0,s0,-304
    80005710:	bb9fe0ef          	jal	800042c8 <namei>
    80005714:	84aa                	mv	s1,a0
    80005716:	c53d                	beqz	a0,80005784 <sys_link+0xae>
    end_op();
    return -1;
  }

  ilock(ip);
    80005718:	b82fe0ef          	jal	80003a9a <ilock>
  if(ip->type == T_DIR){
    8000571c:	04449703          	lh	a4,68(s1)
    80005720:	4785                	li	a5,1
    80005722:	06f70663          	beq	a4,a5,8000578e <sys_link+0xb8>
    80005726:	ea4a                	sd	s2,272(sp)
    iunlockput(ip);
    end_op();
    return -1;
  }

  ip->nlink++;
    80005728:	04a4d783          	lhu	a5,74(s1)
    8000572c:	2785                	addiw	a5,a5,1
    8000572e:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    80005732:	8526                	mv	a0,s1
    80005734:	ab2fe0ef          	jal	800039e6 <iupdate>
  iunlock(ip);
    80005738:	8526                	mv	a0,s1
    8000573a:	c0efe0ef          	jal	80003b48 <iunlock>

  if((dp = nameiparent(new, name)) == 0)
    8000573e:	fd040593          	addi	a1,s0,-48
    80005742:	f5040513          	addi	a0,s0,-176
    80005746:	b9dfe0ef          	jal	800042e2 <nameiparent>
    8000574a:	892a                	mv	s2,a0
    8000574c:	cd21                	beqz	a0,800057a4 <sys_link+0xce>
    goto bad;
  ilock(dp);
    8000574e:	b4cfe0ef          	jal	80003a9a <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
    80005752:	854a                	mv	a0,s2
    80005754:	00092703          	lw	a4,0(s2)
    80005758:	409c                	lw	a5,0(s1)
    8000575a:	04f71263          	bne	a4,a5,8000579e <sys_link+0xc8>
    8000575e:	40d0                	lw	a2,4(s1)
    80005760:	fd040593          	addi	a1,s0,-48
    80005764:	abbfe0ef          	jal	8000421e <dirlink>
    80005768:	02054b63          	bltz	a0,8000579e <sys_link+0xc8>
    iunlockput(dp);
    goto bad;
  }
  iunlockput(dp);
    8000576c:	854a                	mv	a0,s2
    8000576e:	d38fe0ef          	jal	80003ca6 <iunlockput>
  iput(ip);
    80005772:	8526                	mv	a0,s1
    80005774:	ca8fe0ef          	jal	80003c1c <iput>

  end_op();
    80005778:	d9ffe0ef          	jal	80004516 <end_op>

  return 0;
    8000577c:	4781                	li	a5,0
    8000577e:	64f2                	ld	s1,280(sp)
    80005780:	6952                	ld	s2,272(sp)
    80005782:	a0a1                	j	800057ca <sys_link+0xf4>
    end_op();
    80005784:	d93fe0ef          	jal	80004516 <end_op>
    return -1;
    80005788:	57fd                	li	a5,-1
    8000578a:	64f2                	ld	s1,280(sp)
    8000578c:	a83d                	j	800057ca <sys_link+0xf4>
    iunlockput(ip);
    8000578e:	8526                	mv	a0,s1
    80005790:	d16fe0ef          	jal	80003ca6 <iunlockput>
    end_op();
    80005794:	d83fe0ef          	jal	80004516 <end_op>
    return -1;
    80005798:	57fd                	li	a5,-1
    8000579a:	64f2                	ld	s1,280(sp)
    8000579c:	a03d                	j	800057ca <sys_link+0xf4>
    iunlockput(dp);
    8000579e:	854a                	mv	a0,s2
    800057a0:	d06fe0ef          	jal	80003ca6 <iunlockput>

bad:
  ilock(ip);
    800057a4:	8526                	mv	a0,s1
    800057a6:	af4fe0ef          	jal	80003a9a <ilock>
  ip->nlink--;
    800057aa:	04a4d783          	lhu	a5,74(s1)
    800057ae:	37fd                	addiw	a5,a5,-1
    800057b0:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    800057b4:	8526                	mv	a0,s1
    800057b6:	a30fe0ef          	jal	800039e6 <iupdate>
  iunlockput(ip);
    800057ba:	8526                	mv	a0,s1
    800057bc:	ceafe0ef          	jal	80003ca6 <iunlockput>
  end_op();
    800057c0:	d57fe0ef          	jal	80004516 <end_op>
  return -1;
    800057c4:	57fd                	li	a5,-1
    800057c6:	64f2                	ld	s1,280(sp)
    800057c8:	6952                	ld	s2,272(sp)
}
    800057ca:	853e                	mv	a0,a5
    800057cc:	70b2                	ld	ra,296(sp)
    800057ce:	7412                	ld	s0,288(sp)
    800057d0:	6155                	addi	sp,sp,304
    800057d2:	8082                	ret

00000000800057d4 <sys_unlink>:
  return 1;
}

uint64
sys_unlink(void)
{
    800057d4:	7151                	addi	sp,sp,-240
    800057d6:	f586                	sd	ra,232(sp)
    800057d8:	f1a2                	sd	s0,224(sp)
    800057da:	1980                	addi	s0,sp,240
  struct inode *ip, *dp;
  struct dirent de;
  char name[DIRSIZ], path[MAXPATH];
  uint off;

  if(argstr(0, path, MAXPATH) < 0)
    800057dc:	08000613          	li	a2,128
    800057e0:	f3040593          	addi	a1,s0,-208
    800057e4:	4501                	li	a0,0
    800057e6:	8fffd0ef          	jal	800030e4 <argstr>
    800057ea:	14054d63          	bltz	a0,80005944 <sys_unlink+0x170>
    800057ee:	eda6                	sd	s1,216(sp)
    return -1;

  begin_op();
    800057f0:	cb7fe0ef          	jal	800044a6 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
    800057f4:	fb040593          	addi	a1,s0,-80
    800057f8:	f3040513          	addi	a0,s0,-208
    800057fc:	ae7fe0ef          	jal	800042e2 <nameiparent>
    80005800:	84aa                	mv	s1,a0
    80005802:	c955                	beqz	a0,800058b6 <sys_unlink+0xe2>
    end_op();
    return -1;
  }

  ilock(dp);
    80005804:	a96fe0ef          	jal	80003a9a <ilock>

  // Cannot unlink "." or "..".
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
    80005808:	00003597          	auipc	a1,0x3
    8000580c:	0f858593          	addi	a1,a1,248 # 80008900 <etext+0x900>
    80005810:	fb040513          	addi	a0,s0,-80
    80005814:	80bfe0ef          	jal	8000401e <namecmp>
    80005818:	10050b63          	beqz	a0,8000592e <sys_unlink+0x15a>
    8000581c:	00003597          	auipc	a1,0x3
    80005820:	0ec58593          	addi	a1,a1,236 # 80008908 <etext+0x908>
    80005824:	fb040513          	addi	a0,s0,-80
    80005828:	ff6fe0ef          	jal	8000401e <namecmp>
    8000582c:	10050163          	beqz	a0,8000592e <sys_unlink+0x15a>
    80005830:	e9ca                	sd	s2,208(sp)
    goto bad;

  if((ip = dirlookup(dp, name, &off)) == 0)
    80005832:	f2c40613          	addi	a2,s0,-212
    80005836:	fb040593          	addi	a1,s0,-80
    8000583a:	8526                	mv	a0,s1
    8000583c:	ff8fe0ef          	jal	80004034 <dirlookup>
    80005840:	892a                	mv	s2,a0
    80005842:	0e050563          	beqz	a0,8000592c <sys_unlink+0x158>
    80005846:	e5ce                	sd	s3,200(sp)
    goto bad;
  ilock(ip);
    80005848:	a52fe0ef          	jal	80003a9a <ilock>

  if(ip->nlink < 1)
    8000584c:	04a91783          	lh	a5,74(s2)
    80005850:	06f05863          	blez	a5,800058c0 <sys_unlink+0xec>
    panic("unlink: nlink < 1");
  if(ip->type == T_DIR && !isdirempty(ip)){
    80005854:	04491703          	lh	a4,68(s2)
    80005858:	4785                	li	a5,1
    8000585a:	06f70963          	beq	a4,a5,800058cc <sys_unlink+0xf8>
    iunlockput(ip);
    goto bad;
  }

  memset(&de, 0, sizeof(de));
    8000585e:	fc040993          	addi	s3,s0,-64
    80005862:	4641                	li	a2,16
    80005864:	4581                	li	a1,0
    80005866:	854e                	mv	a0,s3
    80005868:	c90fb0ef          	jal	80000cf8 <memset>
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    8000586c:	4741                	li	a4,16
    8000586e:	f2c42683          	lw	a3,-212(s0)
    80005872:	864e                	mv	a2,s3
    80005874:	4581                	li	a1,0
    80005876:	8526                	mv	a0,s1
    80005878:	ea6fe0ef          	jal	80003f1e <writei>
    8000587c:	47c1                	li	a5,16
    8000587e:	08f51863          	bne	a0,a5,8000590e <sys_unlink+0x13a>
    panic("unlink: writei");
  if(ip->type == T_DIR){
    80005882:	04491703          	lh	a4,68(s2)
    80005886:	4785                	li	a5,1
    80005888:	08f70963          	beq	a4,a5,8000591a <sys_unlink+0x146>
    dp->nlink--;
    iupdate(dp);
  }
  iunlockput(dp);
    8000588c:	8526                	mv	a0,s1
    8000588e:	c18fe0ef          	jal	80003ca6 <iunlockput>

  ip->nlink--;
    80005892:	04a95783          	lhu	a5,74(s2)
    80005896:	37fd                	addiw	a5,a5,-1
    80005898:	04f91523          	sh	a5,74(s2)
  iupdate(ip);
    8000589c:	854a                	mv	a0,s2
    8000589e:	948fe0ef          	jal	800039e6 <iupdate>
  iunlockput(ip);
    800058a2:	854a                	mv	a0,s2
    800058a4:	c02fe0ef          	jal	80003ca6 <iunlockput>

  end_op();
    800058a8:	c6ffe0ef          	jal	80004516 <end_op>

  return 0;
    800058ac:	4501                	li	a0,0
    800058ae:	64ee                	ld	s1,216(sp)
    800058b0:	694e                	ld	s2,208(sp)
    800058b2:	69ae                	ld	s3,200(sp)
    800058b4:	a061                	j	8000593c <sys_unlink+0x168>
    end_op();
    800058b6:	c61fe0ef          	jal	80004516 <end_op>
    return -1;
    800058ba:	557d                	li	a0,-1
    800058bc:	64ee                	ld	s1,216(sp)
    800058be:	a8bd                	j	8000593c <sys_unlink+0x168>
    panic("unlink: nlink < 1");
    800058c0:	00003517          	auipc	a0,0x3
    800058c4:	05050513          	addi	a0,a0,80 # 80008910 <etext+0x910>
    800058c8:	f5dfa0ef          	jal	80000824 <panic>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    800058cc:	04c92703          	lw	a4,76(s2)
    800058d0:	02000793          	li	a5,32
    800058d4:	f8e7f5e3          	bgeu	a5,a4,8000585e <sys_unlink+0x8a>
    800058d8:	89be                	mv	s3,a5
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    800058da:	4741                	li	a4,16
    800058dc:	86ce                	mv	a3,s3
    800058de:	f1840613          	addi	a2,s0,-232
    800058e2:	4581                	li	a1,0
    800058e4:	854a                	mv	a0,s2
    800058e6:	d46fe0ef          	jal	80003e2c <readi>
    800058ea:	47c1                	li	a5,16
    800058ec:	00f51b63          	bne	a0,a5,80005902 <sys_unlink+0x12e>
    if(de.inum != 0)
    800058f0:	f1845783          	lhu	a5,-232(s0)
    800058f4:	ebb1                	bnez	a5,80005948 <sys_unlink+0x174>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    800058f6:	29c1                	addiw	s3,s3,16
    800058f8:	04c92783          	lw	a5,76(s2)
    800058fc:	fcf9efe3          	bltu	s3,a5,800058da <sys_unlink+0x106>
    80005900:	bfb9                	j	8000585e <sys_unlink+0x8a>
      panic("isdirempty: readi");
    80005902:	00003517          	auipc	a0,0x3
    80005906:	02650513          	addi	a0,a0,38 # 80008928 <etext+0x928>
    8000590a:	f1bfa0ef          	jal	80000824 <panic>
    panic("unlink: writei");
    8000590e:	00003517          	auipc	a0,0x3
    80005912:	03250513          	addi	a0,a0,50 # 80008940 <etext+0x940>
    80005916:	f0ffa0ef          	jal	80000824 <panic>
    dp->nlink--;
    8000591a:	04a4d783          	lhu	a5,74(s1)
    8000591e:	37fd                	addiw	a5,a5,-1
    80005920:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    80005924:	8526                	mv	a0,s1
    80005926:	8c0fe0ef          	jal	800039e6 <iupdate>
    8000592a:	b78d                	j	8000588c <sys_unlink+0xb8>
    8000592c:	694e                	ld	s2,208(sp)

bad:
  iunlockput(dp);
    8000592e:	8526                	mv	a0,s1
    80005930:	b76fe0ef          	jal	80003ca6 <iunlockput>
  end_op();
    80005934:	be3fe0ef          	jal	80004516 <end_op>
  return -1;
    80005938:	557d                	li	a0,-1
    8000593a:	64ee                	ld	s1,216(sp)
}
    8000593c:	70ae                	ld	ra,232(sp)
    8000593e:	740e                	ld	s0,224(sp)
    80005940:	616d                	addi	sp,sp,240
    80005942:	8082                	ret
    return -1;
    80005944:	557d                	li	a0,-1
    80005946:	bfdd                	j	8000593c <sys_unlink+0x168>
    iunlockput(ip);
    80005948:	854a                	mv	a0,s2
    8000594a:	b5cfe0ef          	jal	80003ca6 <iunlockput>
    goto bad;
    8000594e:	694e                	ld	s2,208(sp)
    80005950:	69ae                	ld	s3,200(sp)
    80005952:	bff1                	j	8000592e <sys_unlink+0x15a>

0000000080005954 <create>:

struct inode*
create(char *path, short type, short major, short minor)
{
    80005954:	715d                	addi	sp,sp,-80
    80005956:	e486                	sd	ra,72(sp)
    80005958:	e0a2                	sd	s0,64(sp)
    8000595a:	fc26                	sd	s1,56(sp)
    8000595c:	f84a                	sd	s2,48(sp)
    8000595e:	f44e                	sd	s3,40(sp)
    80005960:	f052                	sd	s4,32(sp)
    80005962:	ec56                	sd	s5,24(sp)
    80005964:	e85a                	sd	s6,16(sp)
    80005966:	0880                	addi	s0,sp,80
    80005968:	892e                	mv	s2,a1
    8000596a:	8a2e                	mv	s4,a1
    8000596c:	8ab2                	mv	s5,a2
    8000596e:	8b36                	mv	s6,a3
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
    80005970:	fb040593          	addi	a1,s0,-80
    80005974:	96ffe0ef          	jal	800042e2 <nameiparent>
    80005978:	84aa                	mv	s1,a0
    8000597a:	10050763          	beqz	a0,80005a88 <create+0x134>
    return 0;

  ilock(dp);
    8000597e:	91cfe0ef          	jal	80003a9a <ilock>

  if((ip = dirlookup(dp, name, 0)) != 0){
    80005982:	4601                	li	a2,0
    80005984:	fb040593          	addi	a1,s0,-80
    80005988:	8526                	mv	a0,s1
    8000598a:	eaafe0ef          	jal	80004034 <dirlookup>
    8000598e:	89aa                	mv	s3,a0
    80005990:	c131                	beqz	a0,800059d4 <create+0x80>
    iunlockput(dp);
    80005992:	8526                	mv	a0,s1
    80005994:	b12fe0ef          	jal	80003ca6 <iunlockput>
    ilock(ip);
    80005998:	854e                	mv	a0,s3
    8000599a:	900fe0ef          	jal	80003a9a <ilock>
    if(type == T_FILE && (ip->type == T_FILE || ip->type == T_DEVICE))
    8000599e:	4789                	li	a5,2
    800059a0:	02f91563          	bne	s2,a5,800059ca <create+0x76>
    800059a4:	0449d783          	lhu	a5,68(s3)
    800059a8:	37f9                	addiw	a5,a5,-2
    800059aa:	17c2                	slli	a5,a5,0x30
    800059ac:	93c1                	srli	a5,a5,0x30
    800059ae:	4705                	li	a4,1
    800059b0:	00f76d63          	bltu	a4,a5,800059ca <create+0x76>
  ip->nlink = 0;
  iupdate(ip);
  iunlockput(ip);
  iunlockput(dp);
  return 0;
}
    800059b4:	854e                	mv	a0,s3
    800059b6:	60a6                	ld	ra,72(sp)
    800059b8:	6406                	ld	s0,64(sp)
    800059ba:	74e2                	ld	s1,56(sp)
    800059bc:	7942                	ld	s2,48(sp)
    800059be:	79a2                	ld	s3,40(sp)
    800059c0:	7a02                	ld	s4,32(sp)
    800059c2:	6ae2                	ld	s5,24(sp)
    800059c4:	6b42                	ld	s6,16(sp)
    800059c6:	6161                	addi	sp,sp,80
    800059c8:	8082                	ret
    iunlockput(ip);
    800059ca:	854e                	mv	a0,s3
    800059cc:	adafe0ef          	jal	80003ca6 <iunlockput>
    return 0;
    800059d0:	4981                	li	s3,0
    800059d2:	b7cd                	j	800059b4 <create+0x60>
  if((ip = ialloc(dp->dev, type)) == 0){
    800059d4:	85ca                	mv	a1,s2
    800059d6:	4088                	lw	a0,0(s1)
    800059d8:	f53fd0ef          	jal	8000392a <ialloc>
    800059dc:	892a                	mv	s2,a0
    800059de:	cd15                	beqz	a0,80005a1a <create+0xc6>
  ilock(ip);
    800059e0:	8bafe0ef          	jal	80003a9a <ilock>
  ip->major = major;
    800059e4:	05591323          	sh	s5,70(s2)
  ip->minor = minor;
    800059e8:	05691423          	sh	s6,72(s2)
  ip->nlink = 1;
    800059ec:	4785                	li	a5,1
    800059ee:	04f91523          	sh	a5,74(s2)
  iupdate(ip);
    800059f2:	854a                	mv	a0,s2
    800059f4:	ff3fd0ef          	jal	800039e6 <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
    800059f8:	4705                	li	a4,1
    800059fa:	02ea0463          	beq	s4,a4,80005a22 <create+0xce>
  if(dirlink(dp, name, ip->inum) < 0)
    800059fe:	00492603          	lw	a2,4(s2)
    80005a02:	fb040593          	addi	a1,s0,-80
    80005a06:	8526                	mv	a0,s1
    80005a08:	817fe0ef          	jal	8000421e <dirlink>
    80005a0c:	06054263          	bltz	a0,80005a70 <create+0x11c>
  iunlockput(dp);
    80005a10:	8526                	mv	a0,s1
    80005a12:	a94fe0ef          	jal	80003ca6 <iunlockput>
  return ip;
    80005a16:	89ca                	mv	s3,s2
    80005a18:	bf71                	j	800059b4 <create+0x60>
    iunlockput(dp);
    80005a1a:	8526                	mv	a0,s1
    80005a1c:	a8afe0ef          	jal	80003ca6 <iunlockput>
    return 0;
    80005a20:	bf51                	j	800059b4 <create+0x60>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
    80005a22:	00492603          	lw	a2,4(s2)
    80005a26:	00003597          	auipc	a1,0x3
    80005a2a:	eda58593          	addi	a1,a1,-294 # 80008900 <etext+0x900>
    80005a2e:	854a                	mv	a0,s2
    80005a30:	feefe0ef          	jal	8000421e <dirlink>
    80005a34:	02054e63          	bltz	a0,80005a70 <create+0x11c>
    80005a38:	40d0                	lw	a2,4(s1)
    80005a3a:	00003597          	auipc	a1,0x3
    80005a3e:	ece58593          	addi	a1,a1,-306 # 80008908 <etext+0x908>
    80005a42:	854a                	mv	a0,s2
    80005a44:	fdafe0ef          	jal	8000421e <dirlink>
    80005a48:	02054463          	bltz	a0,80005a70 <create+0x11c>
  if(dirlink(dp, name, ip->inum) < 0)
    80005a4c:	00492603          	lw	a2,4(s2)
    80005a50:	fb040593          	addi	a1,s0,-80
    80005a54:	8526                	mv	a0,s1
    80005a56:	fc8fe0ef          	jal	8000421e <dirlink>
    80005a5a:	00054b63          	bltz	a0,80005a70 <create+0x11c>
    dp->nlink++;  // for ".."
    80005a5e:	04a4d783          	lhu	a5,74(s1)
    80005a62:	2785                	addiw	a5,a5,1
    80005a64:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    80005a68:	8526                	mv	a0,s1
    80005a6a:	f7dfd0ef          	jal	800039e6 <iupdate>
    80005a6e:	b74d                	j	80005a10 <create+0xbc>
  ip->nlink = 0;
    80005a70:	04091523          	sh	zero,74(s2)
  iupdate(ip);
    80005a74:	854a                	mv	a0,s2
    80005a76:	f71fd0ef          	jal	800039e6 <iupdate>
  iunlockput(ip);
    80005a7a:	854a                	mv	a0,s2
    80005a7c:	a2afe0ef          	jal	80003ca6 <iunlockput>
  iunlockput(dp);
    80005a80:	8526                	mv	a0,s1
    80005a82:	a24fe0ef          	jal	80003ca6 <iunlockput>
  return 0;
    80005a86:	b73d                	j	800059b4 <create+0x60>
    return 0;
    80005a88:	89aa                	mv	s3,a0
    80005a8a:	b72d                	j	800059b4 <create+0x60>

0000000080005a8c <sys_open>:

uint64
sys_open(void)
{
    80005a8c:	7131                	addi	sp,sp,-192
    80005a8e:	fd06                	sd	ra,184(sp)
    80005a90:	f922                	sd	s0,176(sp)
    80005a92:	0180                	addi	s0,sp,192
  int fd, omode;
  struct file *f;
  struct inode *ip;
  int n;

  argint(1, &omode);
    80005a94:	f4c40593          	addi	a1,s0,-180
    80005a98:	4505                	li	a0,1
    80005a9a:	e12fd0ef          	jal	800030ac <argint>
  if((n = argstr(0, path, MAXPATH)) < 0)
    80005a9e:	08000613          	li	a2,128
    80005aa2:	f5040593          	addi	a1,s0,-176
    80005aa6:	4501                	li	a0,0
    80005aa8:	e3cfd0ef          	jal	800030e4 <argstr>
    80005aac:	87aa                	mv	a5,a0
    return -1;
    80005aae:	557d                	li	a0,-1
  if((n = argstr(0, path, MAXPATH)) < 0)
    80005ab0:	0a07c363          	bltz	a5,80005b56 <sys_open+0xca>
    80005ab4:	f526                	sd	s1,168(sp)

  begin_op();
    80005ab6:	9f1fe0ef          	jal	800044a6 <begin_op>

  if(omode & O_CREATE){
    80005aba:	f4c42783          	lw	a5,-180(s0)
    80005abe:	2007f793          	andi	a5,a5,512
    80005ac2:	c3dd                	beqz	a5,80005b68 <sys_open+0xdc>
    ip = create(path, T_FILE, 0, 0);
    80005ac4:	4681                	li	a3,0
    80005ac6:	4601                	li	a2,0
    80005ac8:	4589                	li	a1,2
    80005aca:	f5040513          	addi	a0,s0,-176
    80005ace:	e87ff0ef          	jal	80005954 <create>
    80005ad2:	84aa                	mv	s1,a0
    if(ip == 0){
    80005ad4:	c549                	beqz	a0,80005b5e <sys_open+0xd2>
      end_op();
      return -1;
    }
  }

  if(ip->type == T_DEVICE && (ip->major < 0 || ip->major >= NDEV)){
    80005ad6:	04449703          	lh	a4,68(s1)
    80005ada:	478d                	li	a5,3
    80005adc:	00f71763          	bne	a4,a5,80005aea <sys_open+0x5e>
    80005ae0:	0464d703          	lhu	a4,70(s1)
    80005ae4:	47a5                	li	a5,9
    80005ae6:	0ae7ee63          	bltu	a5,a4,80005ba2 <sys_open+0x116>
    80005aea:	f14a                	sd	s2,160(sp)
    iunlockput(ip);
    end_op();
    return -1;
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
    80005aec:	d3bfe0ef          	jal	80004826 <filealloc>
    80005af0:	892a                	mv	s2,a0
    80005af2:	c561                	beqz	a0,80005bba <sys_open+0x12e>
    80005af4:	ed4e                	sd	s3,152(sp)
    80005af6:	a47ff0ef          	jal	8000553c <fdalloc>
    80005afa:	89aa                	mv	s3,a0
    80005afc:	0a054b63          	bltz	a0,80005bb2 <sys_open+0x126>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if(ip->type == T_DEVICE){
    80005b00:	04449703          	lh	a4,68(s1)
    80005b04:	478d                	li	a5,3
    80005b06:	0cf70363          	beq	a4,a5,80005bcc <sys_open+0x140>
    f->type = FD_DEVICE;
    f->major = ip->major;
  } else {
    f->type = FD_INODE;
    80005b0a:	4789                	li	a5,2
    80005b0c:	00f92023          	sw	a5,0(s2)
    f->off = 0;
    80005b10:	02092023          	sw	zero,32(s2)
  }
  f->ip = ip;
    80005b14:	00993c23          	sd	s1,24(s2)
  f->readable = !(omode & O_WRONLY);
    80005b18:	f4c42783          	lw	a5,-180(s0)
    80005b1c:	0017f713          	andi	a4,a5,1
    80005b20:	00174713          	xori	a4,a4,1
    80005b24:	00e90423          	sb	a4,8(s2)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
    80005b28:	0037f713          	andi	a4,a5,3
    80005b2c:	00e03733          	snez	a4,a4
    80005b30:	00e904a3          	sb	a4,9(s2)

  if((omode & O_TRUNC) && ip->type == T_FILE){
    80005b34:	4007f793          	andi	a5,a5,1024
    80005b38:	c791                	beqz	a5,80005b44 <sys_open+0xb8>
    80005b3a:	04449703          	lh	a4,68(s1)
    80005b3e:	4789                	li	a5,2
    80005b40:	08f70d63          	beq	a4,a5,80005bda <sys_open+0x14e>
    itrunc(ip);
  }

  iunlock(ip);
    80005b44:	8526                	mv	a0,s1
    80005b46:	802fe0ef          	jal	80003b48 <iunlock>
  end_op();
    80005b4a:	9cdfe0ef          	jal	80004516 <end_op>

  return fd;
    80005b4e:	854e                	mv	a0,s3
    80005b50:	74aa                	ld	s1,168(sp)
    80005b52:	790a                	ld	s2,160(sp)
    80005b54:	69ea                	ld	s3,152(sp)
}
    80005b56:	70ea                	ld	ra,184(sp)
    80005b58:	744a                	ld	s0,176(sp)
    80005b5a:	6129                	addi	sp,sp,192
    80005b5c:	8082                	ret
      end_op();
    80005b5e:	9b9fe0ef          	jal	80004516 <end_op>
      return -1;
    80005b62:	557d                	li	a0,-1
    80005b64:	74aa                	ld	s1,168(sp)
    80005b66:	bfc5                	j	80005b56 <sys_open+0xca>
    if((ip = namei(path)) == 0){
    80005b68:	f5040513          	addi	a0,s0,-176
    80005b6c:	f5cfe0ef          	jal	800042c8 <namei>
    80005b70:	84aa                	mv	s1,a0
    80005b72:	c11d                	beqz	a0,80005b98 <sys_open+0x10c>
    ilock(ip);
    80005b74:	f27fd0ef          	jal	80003a9a <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
    80005b78:	04449703          	lh	a4,68(s1)
    80005b7c:	4785                	li	a5,1
    80005b7e:	f4f71ce3          	bne	a4,a5,80005ad6 <sys_open+0x4a>
    80005b82:	f4c42783          	lw	a5,-180(s0)
    80005b86:	d3b5                	beqz	a5,80005aea <sys_open+0x5e>
      iunlockput(ip);
    80005b88:	8526                	mv	a0,s1
    80005b8a:	91cfe0ef          	jal	80003ca6 <iunlockput>
      end_op();
    80005b8e:	989fe0ef          	jal	80004516 <end_op>
      return -1;
    80005b92:	557d                	li	a0,-1
    80005b94:	74aa                	ld	s1,168(sp)
    80005b96:	b7c1                	j	80005b56 <sys_open+0xca>
      end_op();
    80005b98:	97ffe0ef          	jal	80004516 <end_op>
      return -1;
    80005b9c:	557d                	li	a0,-1
    80005b9e:	74aa                	ld	s1,168(sp)
    80005ba0:	bf5d                	j	80005b56 <sys_open+0xca>
    iunlockput(ip);
    80005ba2:	8526                	mv	a0,s1
    80005ba4:	902fe0ef          	jal	80003ca6 <iunlockput>
    end_op();
    80005ba8:	96ffe0ef          	jal	80004516 <end_op>
    return -1;
    80005bac:	557d                	li	a0,-1
    80005bae:	74aa                	ld	s1,168(sp)
    80005bb0:	b75d                	j	80005b56 <sys_open+0xca>
      fileclose(f);
    80005bb2:	854a                	mv	a0,s2
    80005bb4:	d17fe0ef          	jal	800048ca <fileclose>
    80005bb8:	69ea                	ld	s3,152(sp)
    iunlockput(ip);
    80005bba:	8526                	mv	a0,s1
    80005bbc:	8eafe0ef          	jal	80003ca6 <iunlockput>
    end_op();
    80005bc0:	957fe0ef          	jal	80004516 <end_op>
    return -1;
    80005bc4:	557d                	li	a0,-1
    80005bc6:	74aa                	ld	s1,168(sp)
    80005bc8:	790a                	ld	s2,160(sp)
    80005bca:	b771                	j	80005b56 <sys_open+0xca>
    f->type = FD_DEVICE;
    80005bcc:	00e92023          	sw	a4,0(s2)
    f->major = ip->major;
    80005bd0:	04649783          	lh	a5,70(s1)
    80005bd4:	02f91223          	sh	a5,36(s2)
    80005bd8:	bf35                	j	80005b14 <sys_open+0x88>
    itrunc(ip);
    80005bda:	8526                	mv	a0,s1
    80005bdc:	fadfd0ef          	jal	80003b88 <itrunc>
    80005be0:	b795                	j	80005b44 <sys_open+0xb8>

0000000080005be2 <sys_mkdir>:

uint64
sys_mkdir(void)
{
    80005be2:	7175                	addi	sp,sp,-144
    80005be4:	e506                	sd	ra,136(sp)
    80005be6:	e122                	sd	s0,128(sp)
    80005be8:	0900                	addi	s0,sp,144
  char path[MAXPATH];
  struct inode *ip;

  begin_op();
    80005bea:	8bdfe0ef          	jal	800044a6 <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
    80005bee:	08000613          	li	a2,128
    80005bf2:	f7040593          	addi	a1,s0,-144
    80005bf6:	4501                	li	a0,0
    80005bf8:	cecfd0ef          	jal	800030e4 <argstr>
    80005bfc:	02054363          	bltz	a0,80005c22 <sys_mkdir+0x40>
    80005c00:	4681                	li	a3,0
    80005c02:	4601                	li	a2,0
    80005c04:	4585                	li	a1,1
    80005c06:	f7040513          	addi	a0,s0,-144
    80005c0a:	d4bff0ef          	jal	80005954 <create>
    80005c0e:	c911                	beqz	a0,80005c22 <sys_mkdir+0x40>
    end_op();
    return -1;
  }
  iunlockput(ip);
    80005c10:	896fe0ef          	jal	80003ca6 <iunlockput>
  end_op();
    80005c14:	903fe0ef          	jal	80004516 <end_op>
  return 0;
    80005c18:	4501                	li	a0,0
}
    80005c1a:	60aa                	ld	ra,136(sp)
    80005c1c:	640a                	ld	s0,128(sp)
    80005c1e:	6149                	addi	sp,sp,144
    80005c20:	8082                	ret
    end_op();
    80005c22:	8f5fe0ef          	jal	80004516 <end_op>
    return -1;
    80005c26:	557d                	li	a0,-1
    80005c28:	bfcd                	j	80005c1a <sys_mkdir+0x38>

0000000080005c2a <sys_mknod>:

uint64
sys_mknod(void)
{
    80005c2a:	7135                	addi	sp,sp,-160
    80005c2c:	ed06                	sd	ra,152(sp)
    80005c2e:	e922                	sd	s0,144(sp)
    80005c30:	1100                	addi	s0,sp,160
  struct inode *ip;
  char path[MAXPATH];
  int major, minor;

  begin_op();
    80005c32:	875fe0ef          	jal	800044a6 <begin_op>
  argint(1, &major);
    80005c36:	f6c40593          	addi	a1,s0,-148
    80005c3a:	4505                	li	a0,1
    80005c3c:	c70fd0ef          	jal	800030ac <argint>
  argint(2, &minor);
    80005c40:	f6840593          	addi	a1,s0,-152
    80005c44:	4509                	li	a0,2
    80005c46:	c66fd0ef          	jal	800030ac <argint>
  if((argstr(0, path, MAXPATH)) < 0 ||
    80005c4a:	08000613          	li	a2,128
    80005c4e:	f7040593          	addi	a1,s0,-144
    80005c52:	4501                	li	a0,0
    80005c54:	c90fd0ef          	jal	800030e4 <argstr>
    80005c58:	02054563          	bltz	a0,80005c82 <sys_mknod+0x58>
     (ip = create(path, T_DEVICE, major, minor)) == 0){
    80005c5c:	f6841683          	lh	a3,-152(s0)
    80005c60:	f6c41603          	lh	a2,-148(s0)
    80005c64:	458d                	li	a1,3
    80005c66:	f7040513          	addi	a0,s0,-144
    80005c6a:	cebff0ef          	jal	80005954 <create>
  if((argstr(0, path, MAXPATH)) < 0 ||
    80005c6e:	c911                	beqz	a0,80005c82 <sys_mknod+0x58>
    end_op();
    return -1;
  }
  iunlockput(ip);
    80005c70:	836fe0ef          	jal	80003ca6 <iunlockput>
  end_op();
    80005c74:	8a3fe0ef          	jal	80004516 <end_op>
  return 0;
    80005c78:	4501                	li	a0,0
}
    80005c7a:	60ea                	ld	ra,152(sp)
    80005c7c:	644a                	ld	s0,144(sp)
    80005c7e:	610d                	addi	sp,sp,160
    80005c80:	8082                	ret
    end_op();
    80005c82:	895fe0ef          	jal	80004516 <end_op>
    return -1;
    80005c86:	557d                	li	a0,-1
    80005c88:	bfcd                	j	80005c7a <sys_mknod+0x50>

0000000080005c8a <sys_chdir>:

uint64
sys_chdir(void)
{
    80005c8a:	7135                	addi	sp,sp,-160
    80005c8c:	ed06                	sd	ra,152(sp)
    80005c8e:	e922                	sd	s0,144(sp)
    80005c90:	e14a                	sd	s2,128(sp)
    80005c92:	1100                	addi	s0,sp,160
  char path[MAXPATH];
  struct inode *ip;
  struct proc *p = myproc();
    80005c94:	a92fc0ef          	jal	80001f26 <myproc>
    80005c98:	892a                	mv	s2,a0
  
  begin_op();
    80005c9a:	80dfe0ef          	jal	800044a6 <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = namei(path)) == 0){
    80005c9e:	08000613          	li	a2,128
    80005ca2:	f6040593          	addi	a1,s0,-160
    80005ca6:	4501                	li	a0,0
    80005ca8:	c3cfd0ef          	jal	800030e4 <argstr>
    80005cac:	04054363          	bltz	a0,80005cf2 <sys_chdir+0x68>
    80005cb0:	e526                	sd	s1,136(sp)
    80005cb2:	f6040513          	addi	a0,s0,-160
    80005cb6:	e12fe0ef          	jal	800042c8 <namei>
    80005cba:	84aa                	mv	s1,a0
    80005cbc:	c915                	beqz	a0,80005cf0 <sys_chdir+0x66>
    end_op();
    return -1;
  }
  ilock(ip);
    80005cbe:	dddfd0ef          	jal	80003a9a <ilock>
  if(ip->type != T_DIR){
    80005cc2:	04449703          	lh	a4,68(s1)
    80005cc6:	4785                	li	a5,1
    80005cc8:	02f71963          	bne	a4,a5,80005cfa <sys_chdir+0x70>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
    80005ccc:	8526                	mv	a0,s1
    80005cce:	e7bfd0ef          	jal	80003b48 <iunlock>
  iput(p->cwd);
    80005cd2:	15093503          	ld	a0,336(s2)
    80005cd6:	f47fd0ef          	jal	80003c1c <iput>
  end_op();
    80005cda:	83dfe0ef          	jal	80004516 <end_op>
  p->cwd = ip;
    80005cde:	14993823          	sd	s1,336(s2)
  return 0;
    80005ce2:	4501                	li	a0,0
    80005ce4:	64aa                	ld	s1,136(sp)
}
    80005ce6:	60ea                	ld	ra,152(sp)
    80005ce8:	644a                	ld	s0,144(sp)
    80005cea:	690a                	ld	s2,128(sp)
    80005cec:	610d                	addi	sp,sp,160
    80005cee:	8082                	ret
    80005cf0:	64aa                	ld	s1,136(sp)
    end_op();
    80005cf2:	825fe0ef          	jal	80004516 <end_op>
    return -1;
    80005cf6:	557d                	li	a0,-1
    80005cf8:	b7fd                	j	80005ce6 <sys_chdir+0x5c>
    iunlockput(ip);
    80005cfa:	8526                	mv	a0,s1
    80005cfc:	fabfd0ef          	jal	80003ca6 <iunlockput>
    end_op();
    80005d00:	817fe0ef          	jal	80004516 <end_op>
    return -1;
    80005d04:	557d                	li	a0,-1
    80005d06:	64aa                	ld	s1,136(sp)
    80005d08:	bff9                	j	80005ce6 <sys_chdir+0x5c>

0000000080005d0a <sys_exec>:

uint64
sys_exec(void)
{
    80005d0a:	7105                	addi	sp,sp,-480
    80005d0c:	ef86                	sd	ra,472(sp)
    80005d0e:	eba2                	sd	s0,464(sp)
    80005d10:	1380                	addi	s0,sp,480
  char path[MAXPATH], *argv[MAXARG];
  int i;
  uint64 uargv, uarg;

  argaddr(1, &uargv);
    80005d12:	e2840593          	addi	a1,s0,-472
    80005d16:	4505                	li	a0,1
    80005d18:	bb0fd0ef          	jal	800030c8 <argaddr>
  if(argstr(0, path, MAXPATH) < 0) {
    80005d1c:	08000613          	li	a2,128
    80005d20:	f3040593          	addi	a1,s0,-208
    80005d24:	4501                	li	a0,0
    80005d26:	bbefd0ef          	jal	800030e4 <argstr>
    80005d2a:	87aa                	mv	a5,a0
    return -1;
    80005d2c:	557d                	li	a0,-1
  if(argstr(0, path, MAXPATH) < 0) {
    80005d2e:	0e07c063          	bltz	a5,80005e0e <sys_exec+0x104>
    80005d32:	e7a6                	sd	s1,456(sp)
    80005d34:	e3ca                	sd	s2,448(sp)
    80005d36:	ff4e                	sd	s3,440(sp)
    80005d38:	fb52                	sd	s4,432(sp)
    80005d3a:	f756                	sd	s5,424(sp)
    80005d3c:	f35a                	sd	s6,416(sp)
    80005d3e:	ef5e                	sd	s7,408(sp)
  }
  memset(argv, 0, sizeof(argv));
    80005d40:	e3040a13          	addi	s4,s0,-464
    80005d44:	10000613          	li	a2,256
    80005d48:	4581                	li	a1,0
    80005d4a:	8552                	mv	a0,s4
    80005d4c:	fadfa0ef          	jal	80000cf8 <memset>
  for(i=0;; i++){
    if(i >= NELEM(argv)){
    80005d50:	84d2                	mv	s1,s4
  memset(argv, 0, sizeof(argv));
    80005d52:	89d2                	mv	s3,s4
    80005d54:	4901                	li	s2,0
      goto bad;
    }
    if(fetchaddr(uargv+sizeof(uint64)*i, (uint64*)&uarg) < 0){
    80005d56:	e2040a93          	addi	s5,s0,-480
      break;
    }
    argv[i] = kalloc();
    if(argv[i] == 0)
      goto bad;
    if(fetchstr(uarg, argv[i], PGSIZE) < 0)
    80005d5a:	6b05                	lui	s6,0x1
    if(i >= NELEM(argv)){
    80005d5c:	02000b93          	li	s7,32
    if(fetchaddr(uargv+sizeof(uint64)*i, (uint64*)&uarg) < 0){
    80005d60:	00391513          	slli	a0,s2,0x3
    80005d64:	85d6                	mv	a1,s5
    80005d66:	e2843783          	ld	a5,-472(s0)
    80005d6a:	953e                	add	a0,a0,a5
    80005d6c:	ab6fd0ef          	jal	80003022 <fetchaddr>
    80005d70:	02054663          	bltz	a0,80005d9c <sys_exec+0x92>
    if(uarg == 0){
    80005d74:	e2043783          	ld	a5,-480(s0)
    80005d78:	c7a1                	beqz	a5,80005dc0 <sys_exec+0xb6>
    argv[i] = kalloc();
    80005d7a:	dcbfa0ef          	jal	80000b44 <kalloc>
    80005d7e:	85aa                	mv	a1,a0
    80005d80:	00a9b023          	sd	a0,0(s3)
    if(argv[i] == 0)
    80005d84:	cd01                	beqz	a0,80005d9c <sys_exec+0x92>
    if(fetchstr(uarg, argv[i], PGSIZE) < 0)
    80005d86:	865a                	mv	a2,s6
    80005d88:	e2043503          	ld	a0,-480(s0)
    80005d8c:	ae0fd0ef          	jal	8000306c <fetchstr>
    80005d90:	00054663          	bltz	a0,80005d9c <sys_exec+0x92>
    if(i >= NELEM(argv)){
    80005d94:	0905                	addi	s2,s2,1
    80005d96:	09a1                	addi	s3,s3,8
    80005d98:	fd7914e3          	bne	s2,s7,80005d60 <sys_exec+0x56>
    kfree(argv[i]);

  return ret;

 bad:
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80005d9c:	100a0a13          	addi	s4,s4,256
    80005da0:	6088                	ld	a0,0(s1)
    80005da2:	cd31                	beqz	a0,80005dfe <sys_exec+0xf4>
    kfree(argv[i]);
    80005da4:	cb9fa0ef          	jal	80000a5c <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80005da8:	04a1                	addi	s1,s1,8
    80005daa:	ff449be3          	bne	s1,s4,80005da0 <sys_exec+0x96>
  return -1;
    80005dae:	557d                	li	a0,-1
    80005db0:	64be                	ld	s1,456(sp)
    80005db2:	691e                	ld	s2,448(sp)
    80005db4:	79fa                	ld	s3,440(sp)
    80005db6:	7a5a                	ld	s4,432(sp)
    80005db8:	7aba                	ld	s5,424(sp)
    80005dba:	7b1a                	ld	s6,416(sp)
    80005dbc:	6bfa                	ld	s7,408(sp)
    80005dbe:	a881                	j	80005e0e <sys_exec+0x104>
      argv[i] = 0;
    80005dc0:	0009079b          	sext.w	a5,s2
    80005dc4:	e3040593          	addi	a1,s0,-464
    80005dc8:	078e                	slli	a5,a5,0x3
    80005dca:	97ae                	add	a5,a5,a1
    80005dcc:	0007b023          	sd	zero,0(a5)
  int ret = kexec(path, argv);
    80005dd0:	f3040513          	addi	a0,s0,-208
    80005dd4:	acaff0ef          	jal	8000509e <kexec>
    80005dd8:	892a                	mv	s2,a0
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80005dda:	100a0a13          	addi	s4,s4,256
    80005dde:	6088                	ld	a0,0(s1)
    80005de0:	c511                	beqz	a0,80005dec <sys_exec+0xe2>
    kfree(argv[i]);
    80005de2:	c7bfa0ef          	jal	80000a5c <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80005de6:	04a1                	addi	s1,s1,8
    80005de8:	ff449be3          	bne	s1,s4,80005dde <sys_exec+0xd4>
  return ret;
    80005dec:	854a                	mv	a0,s2
    80005dee:	64be                	ld	s1,456(sp)
    80005df0:	691e                	ld	s2,448(sp)
    80005df2:	79fa                	ld	s3,440(sp)
    80005df4:	7a5a                	ld	s4,432(sp)
    80005df6:	7aba                	ld	s5,424(sp)
    80005df8:	7b1a                	ld	s6,416(sp)
    80005dfa:	6bfa                	ld	s7,408(sp)
    80005dfc:	a809                	j	80005e0e <sys_exec+0x104>
  return -1;
    80005dfe:	557d                	li	a0,-1
    80005e00:	64be                	ld	s1,456(sp)
    80005e02:	691e                	ld	s2,448(sp)
    80005e04:	79fa                	ld	s3,440(sp)
    80005e06:	7a5a                	ld	s4,432(sp)
    80005e08:	7aba                	ld	s5,424(sp)
    80005e0a:	7b1a                	ld	s6,416(sp)
    80005e0c:	6bfa                	ld	s7,408(sp)
}
    80005e0e:	60fe                	ld	ra,472(sp)
    80005e10:	645e                	ld	s0,464(sp)
    80005e12:	613d                	addi	sp,sp,480
    80005e14:	8082                	ret

0000000080005e16 <sys_pipe>:

uint64
sys_pipe(void)
{
    80005e16:	7139                	addi	sp,sp,-64
    80005e18:	fc06                	sd	ra,56(sp)
    80005e1a:	f822                	sd	s0,48(sp)
    80005e1c:	f426                	sd	s1,40(sp)
    80005e1e:	0080                	addi	s0,sp,64
  uint64 fdarray; // user pointer to array of two integers
  struct file *rf, *wf;
  int fd0, fd1;
  struct proc *p = myproc();
    80005e20:	906fc0ef          	jal	80001f26 <myproc>
    80005e24:	84aa                	mv	s1,a0

  argaddr(0, &fdarray);
    80005e26:	fd840593          	addi	a1,s0,-40
    80005e2a:	4501                	li	a0,0
    80005e2c:	a9cfd0ef          	jal	800030c8 <argaddr>
  if(pipealloc(&rf, &wf) < 0)
    80005e30:	fc840593          	addi	a1,s0,-56
    80005e34:	fd040513          	addi	a0,s0,-48
    80005e38:	daffe0ef          	jal	80004be6 <pipealloc>
    return -1;
    80005e3c:	57fd                	li	a5,-1
  if(pipealloc(&rf, &wf) < 0)
    80005e3e:	0a054763          	bltz	a0,80005eec <sys_pipe+0xd6>
  fd0 = -1;
    80005e42:	fcf42223          	sw	a5,-60(s0)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
    80005e46:	fd043503          	ld	a0,-48(s0)
    80005e4a:	ef2ff0ef          	jal	8000553c <fdalloc>
    80005e4e:	fca42223          	sw	a0,-60(s0)
    80005e52:	08054463          	bltz	a0,80005eda <sys_pipe+0xc4>
    80005e56:	fc843503          	ld	a0,-56(s0)
    80005e5a:	ee2ff0ef          	jal	8000553c <fdalloc>
    80005e5e:	fca42023          	sw	a0,-64(s0)
    80005e62:	06054263          	bltz	a0,80005ec6 <sys_pipe+0xb0>
      p->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    80005e66:	4691                	li	a3,4
    80005e68:	fc440613          	addi	a2,s0,-60
    80005e6c:	fd843583          	ld	a1,-40(s0)
    80005e70:	68a8                	ld	a0,80(s1)
    80005e72:	c35fb0ef          	jal	80001aa6 <copyout>
    80005e76:	00054e63          	bltz	a0,80005e92 <sys_pipe+0x7c>
     copyout(p->pagetable, fdarray+sizeof(fd0), (char *)&fd1, sizeof(fd1)) < 0){
    80005e7a:	4691                	li	a3,4
    80005e7c:	fc040613          	addi	a2,s0,-64
    80005e80:	fd843583          	ld	a1,-40(s0)
    80005e84:	95b6                	add	a1,a1,a3
    80005e86:	68a8                	ld	a0,80(s1)
    80005e88:	c1ffb0ef          	jal	80001aa6 <copyout>
    p->ofile[fd1] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  return 0;
    80005e8c:	4781                	li	a5,0
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    80005e8e:	04055f63          	bgez	a0,80005eec <sys_pipe+0xd6>
    p->ofile[fd0] = 0;
    80005e92:	fc442783          	lw	a5,-60(s0)
    80005e96:	078e                	slli	a5,a5,0x3
    80005e98:	0d078793          	addi	a5,a5,208
    80005e9c:	97a6                	add	a5,a5,s1
    80005e9e:	0007b023          	sd	zero,0(a5)
    p->ofile[fd1] = 0;
    80005ea2:	fc042783          	lw	a5,-64(s0)
    80005ea6:	078e                	slli	a5,a5,0x3
    80005ea8:	0d078793          	addi	a5,a5,208
    80005eac:	97a6                	add	a5,a5,s1
    80005eae:	0007b023          	sd	zero,0(a5)
    fileclose(rf);
    80005eb2:	fd043503          	ld	a0,-48(s0)
    80005eb6:	a15fe0ef          	jal	800048ca <fileclose>
    fileclose(wf);
    80005eba:	fc843503          	ld	a0,-56(s0)
    80005ebe:	a0dfe0ef          	jal	800048ca <fileclose>
    return -1;
    80005ec2:	57fd                	li	a5,-1
    80005ec4:	a025                	j	80005eec <sys_pipe+0xd6>
    if(fd0 >= 0)
    80005ec6:	fc442783          	lw	a5,-60(s0)
    80005eca:	0007c863          	bltz	a5,80005eda <sys_pipe+0xc4>
      p->ofile[fd0] = 0;
    80005ece:	078e                	slli	a5,a5,0x3
    80005ed0:	0d078793          	addi	a5,a5,208
    80005ed4:	97a6                	add	a5,a5,s1
    80005ed6:	0007b023          	sd	zero,0(a5)
    fileclose(rf);
    80005eda:	fd043503          	ld	a0,-48(s0)
    80005ede:	9edfe0ef          	jal	800048ca <fileclose>
    fileclose(wf);
    80005ee2:	fc843503          	ld	a0,-56(s0)
    80005ee6:	9e5fe0ef          	jal	800048ca <fileclose>
    return -1;
    80005eea:	57fd                	li	a5,-1
}
    80005eec:	853e                	mv	a0,a5
    80005eee:	70e2                	ld	ra,56(sp)
    80005ef0:	7442                	ld	s0,48(sp)
    80005ef2:	74a2                	ld	s1,40(sp)
    80005ef4:	6121                	addi	sp,sp,64
    80005ef6:	8082                	ret
	...

0000000080005f00 <kernelvec>:
.globl kerneltrap
.globl kernelvec
.align 4
kernelvec:
        # make room to save registers.
        addi sp, sp, -256
    80005f00:	7111                	addi	sp,sp,-256

        # save caller-saved registers.
        sd ra, 0(sp)
    80005f02:	e006                	sd	ra,0(sp)
        # sd sp, 8(sp)
        sd gp, 16(sp)
    80005f04:	e80e                	sd	gp,16(sp)
        sd tp, 24(sp)
    80005f06:	ec12                	sd	tp,24(sp)
        sd t0, 32(sp)
    80005f08:	f016                	sd	t0,32(sp)
        sd t1, 40(sp)
    80005f0a:	f41a                	sd	t1,40(sp)
        sd t2, 48(sp)
    80005f0c:	f81e                	sd	t2,48(sp)
        sd a0, 72(sp)
    80005f0e:	e4aa                	sd	a0,72(sp)
        sd a1, 80(sp)
    80005f10:	e8ae                	sd	a1,80(sp)
        sd a2, 88(sp)
    80005f12:	ecb2                	sd	a2,88(sp)
        sd a3, 96(sp)
    80005f14:	f0b6                	sd	a3,96(sp)
        sd a4, 104(sp)
    80005f16:	f4ba                	sd	a4,104(sp)
        sd a5, 112(sp)
    80005f18:	f8be                	sd	a5,112(sp)
        sd a6, 120(sp)
    80005f1a:	fcc2                	sd	a6,120(sp)
        sd a7, 128(sp)
    80005f1c:	e146                	sd	a7,128(sp)
        sd t3, 216(sp)
    80005f1e:	edf2                	sd	t3,216(sp)
        sd t4, 224(sp)
    80005f20:	f1f6                	sd	t4,224(sp)
        sd t5, 232(sp)
    80005f22:	f5fa                	sd	t5,232(sp)
        sd t6, 240(sp)
    80005f24:	f9fe                	sd	t6,240(sp)

        # call the C trap handler in trap.c
        call kerneltrap
    80005f26:	80afd0ef          	jal	80002f30 <kerneltrap>

        # restore registers.
        ld ra, 0(sp)
    80005f2a:	6082                	ld	ra,0(sp)
        # ld sp, 8(sp)
        ld gp, 16(sp)
    80005f2c:	61c2                	ld	gp,16(sp)
        # not tp (contains hartid), in case we moved CPUs
        ld t0, 32(sp)
    80005f2e:	7282                	ld	t0,32(sp)
        ld t1, 40(sp)
    80005f30:	7322                	ld	t1,40(sp)
        ld t2, 48(sp)
    80005f32:	73c2                	ld	t2,48(sp)
        ld a0, 72(sp)
    80005f34:	6526                	ld	a0,72(sp)
        ld a1, 80(sp)
    80005f36:	65c6                	ld	a1,80(sp)
        ld a2, 88(sp)
    80005f38:	6666                	ld	a2,88(sp)
        ld a3, 96(sp)
    80005f3a:	7686                	ld	a3,96(sp)
        ld a4, 104(sp)
    80005f3c:	7726                	ld	a4,104(sp)
        ld a5, 112(sp)
    80005f3e:	77c6                	ld	a5,112(sp)
        ld a6, 120(sp)
    80005f40:	7866                	ld	a6,120(sp)
        ld a7, 128(sp)
    80005f42:	688a                	ld	a7,128(sp)
        ld t3, 216(sp)
    80005f44:	6e6e                	ld	t3,216(sp)
        ld t4, 224(sp)
    80005f46:	7e8e                	ld	t4,224(sp)
        ld t5, 232(sp)
    80005f48:	7f2e                	ld	t5,232(sp)
        ld t6, 240(sp)
    80005f4a:	7fce                	ld	t6,240(sp)

        addi sp, sp, 256
    80005f4c:	6111                	addi	sp,sp,256

        # return to whatever we were doing in the kernel.
        sret
    80005f4e:	10200073          	sret
    80005f52:	00000013          	nop
    80005f56:	00000013          	nop
    80005f5a:	00000013          	nop

0000000080005f5e <plicinit>:
// the riscv Platform Level Interrupt Controller (PLIC).
//

void
plicinit(void)
{
    80005f5e:	1141                	addi	sp,sp,-16
    80005f60:	e406                	sd	ra,8(sp)
    80005f62:	e022                	sd	s0,0(sp)
    80005f64:	0800                	addi	s0,sp,16
  // set desired IRQ priorities non-zero (otherwise disabled).
  *(uint32*)(PLIC + UART0_IRQ*4) = 1;
    80005f66:	0c000737          	lui	a4,0xc000
    80005f6a:	4785                	li	a5,1
    80005f6c:	d71c                	sw	a5,40(a4)
  *(uint32*)(PLIC + VIRTIO0_IRQ*4) = 1;
    80005f6e:	c35c                	sw	a5,4(a4)
}
    80005f70:	60a2                	ld	ra,8(sp)
    80005f72:	6402                	ld	s0,0(sp)
    80005f74:	0141                	addi	sp,sp,16
    80005f76:	8082                	ret

0000000080005f78 <plicinithart>:

void
plicinithart(void)
{
    80005f78:	1141                	addi	sp,sp,-16
    80005f7a:	e406                	sd	ra,8(sp)
    80005f7c:	e022                	sd	s0,0(sp)
    80005f7e:	0800                	addi	s0,sp,16
  int hart = cpuid();
    80005f80:	f73fb0ef          	jal	80001ef2 <cpuid>
  
  // set enable bits for this hart's S-mode
  // for the uart and virtio disk.
  *(uint32*)PLIC_SENABLE(hart) = (1 << UART0_IRQ) | (1 << VIRTIO0_IRQ);
    80005f84:	0085171b          	slliw	a4,a0,0x8
    80005f88:	0c0027b7          	lui	a5,0xc002
    80005f8c:	97ba                	add	a5,a5,a4
    80005f8e:	40200713          	li	a4,1026
    80005f92:	08e7a023          	sw	a4,128(a5) # c002080 <_entry-0x73ffdf80>

  // set this hart's S-mode priority threshold to 0.
  *(uint32*)PLIC_SPRIORITY(hart) = 0;
    80005f96:	00d5151b          	slliw	a0,a0,0xd
    80005f9a:	0c2017b7          	lui	a5,0xc201
    80005f9e:	97aa                	add	a5,a5,a0
    80005fa0:	0007a023          	sw	zero,0(a5) # c201000 <_entry-0x73dff000>
}
    80005fa4:	60a2                	ld	ra,8(sp)
    80005fa6:	6402                	ld	s0,0(sp)
    80005fa8:	0141                	addi	sp,sp,16
    80005faa:	8082                	ret

0000000080005fac <plic_claim>:

// ask the PLIC what interrupt we should serve.
int
plic_claim(void)
{
    80005fac:	1141                	addi	sp,sp,-16
    80005fae:	e406                	sd	ra,8(sp)
    80005fb0:	e022                	sd	s0,0(sp)
    80005fb2:	0800                	addi	s0,sp,16
  int hart = cpuid();
    80005fb4:	f3ffb0ef          	jal	80001ef2 <cpuid>
  int irq = *(uint32*)PLIC_SCLAIM(hart);
    80005fb8:	00d5151b          	slliw	a0,a0,0xd
    80005fbc:	0c2017b7          	lui	a5,0xc201
    80005fc0:	97aa                	add	a5,a5,a0
  return irq;
}
    80005fc2:	43c8                	lw	a0,4(a5)
    80005fc4:	60a2                	ld	ra,8(sp)
    80005fc6:	6402                	ld	s0,0(sp)
    80005fc8:	0141                	addi	sp,sp,16
    80005fca:	8082                	ret

0000000080005fcc <plic_complete>:

// tell the PLIC we've served this IRQ.
void
plic_complete(int irq)
{
    80005fcc:	1101                	addi	sp,sp,-32
    80005fce:	ec06                	sd	ra,24(sp)
    80005fd0:	e822                	sd	s0,16(sp)
    80005fd2:	e426                	sd	s1,8(sp)
    80005fd4:	1000                	addi	s0,sp,32
    80005fd6:	84aa                	mv	s1,a0
  int hart = cpuid();
    80005fd8:	f1bfb0ef          	jal	80001ef2 <cpuid>
  *(uint32*)PLIC_SCLAIM(hart) = irq;
    80005fdc:	00d5179b          	slliw	a5,a0,0xd
    80005fe0:	0c201737          	lui	a4,0xc201
    80005fe4:	97ba                	add	a5,a5,a4
    80005fe6:	c3c4                	sw	s1,4(a5)
}
    80005fe8:	60e2                	ld	ra,24(sp)
    80005fea:	6442                	ld	s0,16(sp)
    80005fec:	64a2                	ld	s1,8(sp)
    80005fee:	6105                	addi	sp,sp,32
    80005ff0:	8082                	ret

0000000080005ff2 <free_desc>:
}

// mark a descriptor as free.
static void
free_desc(int i)
{
    80005ff2:	1141                	addi	sp,sp,-16
    80005ff4:	e406                	sd	ra,8(sp)
    80005ff6:	e022                	sd	s0,0(sp)
    80005ff8:	0800                	addi	s0,sp,16
  if(i >= NUM)
    80005ffa:	479d                	li	a5,7
    80005ffc:	04a7ca63          	blt	a5,a0,80006050 <free_desc+0x5e>
    panic("free_desc 1");
  if(disk.free[i])
    80006000:	02260797          	auipc	a5,0x2260
    80006004:	39878793          	addi	a5,a5,920 # 82266398 <disk>
    80006008:	97aa                	add	a5,a5,a0
    8000600a:	0187c783          	lbu	a5,24(a5)
    8000600e:	e7b9                	bnez	a5,8000605c <free_desc+0x6a>
    panic("free_desc 2");
  disk.desc[i].addr = 0;
    80006010:	00451693          	slli	a3,a0,0x4
    80006014:	02260797          	auipc	a5,0x2260
    80006018:	38478793          	addi	a5,a5,900 # 82266398 <disk>
    8000601c:	6398                	ld	a4,0(a5)
    8000601e:	9736                	add	a4,a4,a3
    80006020:	00073023          	sd	zero,0(a4) # c201000 <_entry-0x73dff000>
  disk.desc[i].len = 0;
    80006024:	6398                	ld	a4,0(a5)
    80006026:	9736                	add	a4,a4,a3
    80006028:	00072423          	sw	zero,8(a4)
  disk.desc[i].flags = 0;
    8000602c:	00071623          	sh	zero,12(a4)
  disk.desc[i].next = 0;
    80006030:	00071723          	sh	zero,14(a4)
  disk.free[i] = 1;
    80006034:	97aa                	add	a5,a5,a0
    80006036:	4705                	li	a4,1
    80006038:	00e78c23          	sb	a4,24(a5)
  wakeup(&disk.free[0]);
    8000603c:	02260517          	auipc	a0,0x2260
    80006040:	37450513          	addi	a0,a0,884 # 822663b0 <disk+0x18>
    80006044:	e38fc0ef          	jal	8000267c <wakeup>
}
    80006048:	60a2                	ld	ra,8(sp)
    8000604a:	6402                	ld	s0,0(sp)
    8000604c:	0141                	addi	sp,sp,16
    8000604e:	8082                	ret
    panic("free_desc 1");
    80006050:	00003517          	auipc	a0,0x3
    80006054:	90050513          	addi	a0,a0,-1792 # 80008950 <etext+0x950>
    80006058:	fccfa0ef          	jal	80000824 <panic>
    panic("free_desc 2");
    8000605c:	00003517          	auipc	a0,0x3
    80006060:	90450513          	addi	a0,a0,-1788 # 80008960 <etext+0x960>
    80006064:	fc0fa0ef          	jal	80000824 <panic>

0000000080006068 <virtio_disk_init>:
{
    80006068:	1101                	addi	sp,sp,-32
    8000606a:	ec06                	sd	ra,24(sp)
    8000606c:	e822                	sd	s0,16(sp)
    8000606e:	e426                	sd	s1,8(sp)
    80006070:	e04a                	sd	s2,0(sp)
    80006072:	1000                	addi	s0,sp,32
  initlock(&disk.vdisk_lock, "virtio_disk");
    80006074:	00003597          	auipc	a1,0x3
    80006078:	8fc58593          	addi	a1,a1,-1796 # 80008970 <etext+0x970>
    8000607c:	02260517          	auipc	a0,0x2260
    80006080:	44450513          	addi	a0,a0,1092 # 822664c0 <disk+0x128>
    80006084:	b1bfa0ef          	jal	80000b9e <initlock>
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    80006088:	100017b7          	lui	a5,0x10001
    8000608c:	4398                	lw	a4,0(a5)
    8000608e:	2701                	sext.w	a4,a4
    80006090:	747277b7          	lui	a5,0x74727
    80006094:	97678793          	addi	a5,a5,-1674 # 74726976 <_entry-0xb8d968a>
    80006098:	14f71863          	bne	a4,a5,800061e8 <virtio_disk_init+0x180>
     *R(VIRTIO_MMIO_VERSION) != 2 ||
    8000609c:	100017b7          	lui	a5,0x10001
    800060a0:	43dc                	lw	a5,4(a5)
    800060a2:	2781                	sext.w	a5,a5
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    800060a4:	4709                	li	a4,2
    800060a6:	14e79163          	bne	a5,a4,800061e8 <virtio_disk_init+0x180>
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    800060aa:	100017b7          	lui	a5,0x10001
    800060ae:	479c                	lw	a5,8(a5)
    800060b0:	2781                	sext.w	a5,a5
     *R(VIRTIO_MMIO_VERSION) != 2 ||
    800060b2:	12e79b63          	bne	a5,a4,800061e8 <virtio_disk_init+0x180>
     *R(VIRTIO_MMIO_VENDOR_ID) != 0x554d4551){
    800060b6:	100017b7          	lui	a5,0x10001
    800060ba:	47d8                	lw	a4,12(a5)
    800060bc:	2701                	sext.w	a4,a4
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    800060be:	554d47b7          	lui	a5,0x554d4
    800060c2:	55178793          	addi	a5,a5,1361 # 554d4551 <_entry-0x2ab2baaf>
    800060c6:	12f71163          	bne	a4,a5,800061e8 <virtio_disk_init+0x180>
  *R(VIRTIO_MMIO_STATUS) = status;
    800060ca:	100017b7          	lui	a5,0x10001
    800060ce:	0607a823          	sw	zero,112(a5) # 10001070 <_entry-0x6fffef90>
  *R(VIRTIO_MMIO_STATUS) = status;
    800060d2:	4705                	li	a4,1
    800060d4:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    800060d6:	470d                	li	a4,3
    800060d8:	dbb8                	sw	a4,112(a5)
  uint64 features = *R(VIRTIO_MMIO_DEVICE_FEATURES);
    800060da:	10001737          	lui	a4,0x10001
    800060de:	4b18                	lw	a4,16(a4)
  features &= ~(1 << VIRTIO_RING_F_INDIRECT_DESC);
    800060e0:	c7ffe6b7          	lui	a3,0xc7ffe
    800060e4:	75f68693          	addi	a3,a3,1887 # ffffffffc7ffe75f <end+0xffffffff45d98287>
  *R(VIRTIO_MMIO_DRIVER_FEATURES) = features;
    800060e8:	8f75                	and	a4,a4,a3
    800060ea:	100016b7          	lui	a3,0x10001
    800060ee:	d298                	sw	a4,32(a3)
  *R(VIRTIO_MMIO_STATUS) = status;
    800060f0:	472d                	li	a4,11
    800060f2:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    800060f4:	07078793          	addi	a5,a5,112
  status = *R(VIRTIO_MMIO_STATUS);
    800060f8:	439c                	lw	a5,0(a5)
    800060fa:	0007891b          	sext.w	s2,a5
  if(!(status & VIRTIO_CONFIG_S_FEATURES_OK))
    800060fe:	8ba1                	andi	a5,a5,8
    80006100:	0e078a63          	beqz	a5,800061f4 <virtio_disk_init+0x18c>
  *R(VIRTIO_MMIO_QUEUE_SEL) = 0;
    80006104:	100017b7          	lui	a5,0x10001
    80006108:	0207a823          	sw	zero,48(a5) # 10001030 <_entry-0x6fffefd0>
  if(*R(VIRTIO_MMIO_QUEUE_READY))
    8000610c:	43fc                	lw	a5,68(a5)
    8000610e:	2781                	sext.w	a5,a5
    80006110:	0e079863          	bnez	a5,80006200 <virtio_disk_init+0x198>
  uint32 max = *R(VIRTIO_MMIO_QUEUE_NUM_MAX);
    80006114:	100017b7          	lui	a5,0x10001
    80006118:	5bdc                	lw	a5,52(a5)
    8000611a:	2781                	sext.w	a5,a5
  if(max == 0)
    8000611c:	0e078863          	beqz	a5,8000620c <virtio_disk_init+0x1a4>
  if(max < NUM)
    80006120:	471d                	li	a4,7
    80006122:	0ef77b63          	bgeu	a4,a5,80006218 <virtio_disk_init+0x1b0>
  disk.desc = kalloc();
    80006126:	a1ffa0ef          	jal	80000b44 <kalloc>
    8000612a:	02260497          	auipc	s1,0x2260
    8000612e:	26e48493          	addi	s1,s1,622 # 82266398 <disk>
    80006132:	e088                	sd	a0,0(s1)
  disk.avail = kalloc();
    80006134:	a11fa0ef          	jal	80000b44 <kalloc>
    80006138:	e488                	sd	a0,8(s1)
  disk.used = kalloc();
    8000613a:	a0bfa0ef          	jal	80000b44 <kalloc>
    8000613e:	87aa                	mv	a5,a0
    80006140:	e888                	sd	a0,16(s1)
  if(!disk.desc || !disk.avail || !disk.used)
    80006142:	6088                	ld	a0,0(s1)
    80006144:	0e050063          	beqz	a0,80006224 <virtio_disk_init+0x1bc>
    80006148:	02260717          	auipc	a4,0x2260
    8000614c:	25873703          	ld	a4,600(a4) # 822663a0 <disk+0x8>
    80006150:	cb71                	beqz	a4,80006224 <virtio_disk_init+0x1bc>
    80006152:	cbe9                	beqz	a5,80006224 <virtio_disk_init+0x1bc>
  memset(disk.desc, 0, PGSIZE);
    80006154:	6605                	lui	a2,0x1
    80006156:	4581                	li	a1,0
    80006158:	ba1fa0ef          	jal	80000cf8 <memset>
  memset(disk.avail, 0, PGSIZE);
    8000615c:	02260497          	auipc	s1,0x2260
    80006160:	23c48493          	addi	s1,s1,572 # 82266398 <disk>
    80006164:	6605                	lui	a2,0x1
    80006166:	4581                	li	a1,0
    80006168:	6488                	ld	a0,8(s1)
    8000616a:	b8ffa0ef          	jal	80000cf8 <memset>
  memset(disk.used, 0, PGSIZE);
    8000616e:	6605                	lui	a2,0x1
    80006170:	4581                	li	a1,0
    80006172:	6888                	ld	a0,16(s1)
    80006174:	b85fa0ef          	jal	80000cf8 <memset>
  *R(VIRTIO_MMIO_QUEUE_NUM) = NUM;
    80006178:	100017b7          	lui	a5,0x10001
    8000617c:	4721                	li	a4,8
    8000617e:	df98                	sw	a4,56(a5)
  *R(VIRTIO_MMIO_QUEUE_DESC_LOW) = (uint64)disk.desc;
    80006180:	4098                	lw	a4,0(s1)
    80006182:	08e7a023          	sw	a4,128(a5) # 10001080 <_entry-0x6fffef80>
  *R(VIRTIO_MMIO_QUEUE_DESC_HIGH) = (uint64)disk.desc >> 32;
    80006186:	40d8                	lw	a4,4(s1)
    80006188:	08e7a223          	sw	a4,132(a5)
  *R(VIRTIO_MMIO_DRIVER_DESC_LOW) = (uint64)disk.avail;
    8000618c:	649c                	ld	a5,8(s1)
    8000618e:	0007869b          	sext.w	a3,a5
    80006192:	10001737          	lui	a4,0x10001
    80006196:	08d72823          	sw	a3,144(a4) # 10001090 <_entry-0x6fffef70>
  *R(VIRTIO_MMIO_DRIVER_DESC_HIGH) = (uint64)disk.avail >> 32;
    8000619a:	9781                	srai	a5,a5,0x20
    8000619c:	08f72a23          	sw	a5,148(a4)
  *R(VIRTIO_MMIO_DEVICE_DESC_LOW) = (uint64)disk.used;
    800061a0:	689c                	ld	a5,16(s1)
    800061a2:	0007869b          	sext.w	a3,a5
    800061a6:	0ad72023          	sw	a3,160(a4)
  *R(VIRTIO_MMIO_DEVICE_DESC_HIGH) = (uint64)disk.used >> 32;
    800061aa:	9781                	srai	a5,a5,0x20
    800061ac:	0af72223          	sw	a5,164(a4)
  *R(VIRTIO_MMIO_QUEUE_READY) = 0x1;
    800061b0:	4785                	li	a5,1
    800061b2:	c37c                	sw	a5,68(a4)
    disk.free[i] = 1;
    800061b4:	00f48c23          	sb	a5,24(s1)
    800061b8:	00f48ca3          	sb	a5,25(s1)
    800061bc:	00f48d23          	sb	a5,26(s1)
    800061c0:	00f48da3          	sb	a5,27(s1)
    800061c4:	00f48e23          	sb	a5,28(s1)
    800061c8:	00f48ea3          	sb	a5,29(s1)
    800061cc:	00f48f23          	sb	a5,30(s1)
    800061d0:	00f48fa3          	sb	a5,31(s1)
  status |= VIRTIO_CONFIG_S_DRIVER_OK;
    800061d4:	00496913          	ori	s2,s2,4
  *R(VIRTIO_MMIO_STATUS) = status;
    800061d8:	07272823          	sw	s2,112(a4)
}
    800061dc:	60e2                	ld	ra,24(sp)
    800061de:	6442                	ld	s0,16(sp)
    800061e0:	64a2                	ld	s1,8(sp)
    800061e2:	6902                	ld	s2,0(sp)
    800061e4:	6105                	addi	sp,sp,32
    800061e6:	8082                	ret
    panic("could not find virtio disk");
    800061e8:	00002517          	auipc	a0,0x2
    800061ec:	79850513          	addi	a0,a0,1944 # 80008980 <etext+0x980>
    800061f0:	e34fa0ef          	jal	80000824 <panic>
    panic("virtio disk FEATURES_OK unset");
    800061f4:	00002517          	auipc	a0,0x2
    800061f8:	7ac50513          	addi	a0,a0,1964 # 800089a0 <etext+0x9a0>
    800061fc:	e28fa0ef          	jal	80000824 <panic>
    panic("virtio disk should not be ready");
    80006200:	00002517          	auipc	a0,0x2
    80006204:	7c050513          	addi	a0,a0,1984 # 800089c0 <etext+0x9c0>
    80006208:	e1cfa0ef          	jal	80000824 <panic>
    panic("virtio disk has no queue 0");
    8000620c:	00002517          	auipc	a0,0x2
    80006210:	7d450513          	addi	a0,a0,2004 # 800089e0 <etext+0x9e0>
    80006214:	e10fa0ef          	jal	80000824 <panic>
    panic("virtio disk max queue too short");
    80006218:	00002517          	auipc	a0,0x2
    8000621c:	7e850513          	addi	a0,a0,2024 # 80008a00 <etext+0xa00>
    80006220:	e04fa0ef          	jal	80000824 <panic>
    panic("virtio disk kalloc");
    80006224:	00002517          	auipc	a0,0x2
    80006228:	7fc50513          	addi	a0,a0,2044 # 80008a20 <etext+0xa20>
    8000622c:	df8fa0ef          	jal	80000824 <panic>

0000000080006230 <virtio_disk_rw>:
  return 0;
}

void
virtio_disk_rw(struct buf *b, int write)
{
    80006230:	711d                	addi	sp,sp,-96
    80006232:	ec86                	sd	ra,88(sp)
    80006234:	e8a2                	sd	s0,80(sp)
    80006236:	e4a6                	sd	s1,72(sp)
    80006238:	e0ca                	sd	s2,64(sp)
    8000623a:	fc4e                	sd	s3,56(sp)
    8000623c:	f852                	sd	s4,48(sp)
    8000623e:	f456                	sd	s5,40(sp)
    80006240:	f05a                	sd	s6,32(sp)
    80006242:	ec5e                	sd	s7,24(sp)
    80006244:	e862                	sd	s8,16(sp)
    80006246:	1080                	addi	s0,sp,96
    80006248:	89aa                	mv	s3,a0
    8000624a:	8b2e                	mv	s6,a1
  uint64 sector = b->blockno * (BSIZE / 512);
    8000624c:	00c52b83          	lw	s7,12(a0)
    80006250:	001b9b9b          	slliw	s7,s7,0x1
    80006254:	1b82                	slli	s7,s7,0x20
    80006256:	020bdb93          	srli	s7,s7,0x20

  acquire(&disk.vdisk_lock);
    8000625a:	02260517          	auipc	a0,0x2260
    8000625e:	26650513          	addi	a0,a0,614 # 822664c0 <disk+0x128>
    80006262:	9c7fa0ef          	jal	80000c28 <acquire>
  for(int i = 0; i < NUM; i++){
    80006266:	44a1                	li	s1,8
      disk.free[i] = 0;
    80006268:	02260a97          	auipc	s5,0x2260
    8000626c:	130a8a93          	addi	s5,s5,304 # 82266398 <disk>
  for(int i = 0; i < 3; i++){
    80006270:	4a0d                	li	s4,3
    idx[i] = alloc_desc();
    80006272:	5c7d                	li	s8,-1
    80006274:	a095                	j	800062d8 <virtio_disk_rw+0xa8>
      disk.free[i] = 0;
    80006276:	00fa8733          	add	a4,s5,a5
    8000627a:	00070c23          	sb	zero,24(a4)
    idx[i] = alloc_desc();
    8000627e:	c19c                	sw	a5,0(a1)
    if(idx[i] < 0){
    80006280:	0207c563          	bltz	a5,800062aa <virtio_disk_rw+0x7a>
  for(int i = 0; i < 3; i++){
    80006284:	2905                	addiw	s2,s2,1
    80006286:	0611                	addi	a2,a2,4 # 1004 <_entry-0x7fffeffc>
    80006288:	05490c63          	beq	s2,s4,800062e0 <virtio_disk_rw+0xb0>
    idx[i] = alloc_desc();
    8000628c:	85b2                	mv	a1,a2
  for(int i = 0; i < NUM; i++){
    8000628e:	02260717          	auipc	a4,0x2260
    80006292:	10a70713          	addi	a4,a4,266 # 82266398 <disk>
    80006296:	4781                	li	a5,0
    if(disk.free[i]){
    80006298:	01874683          	lbu	a3,24(a4)
    8000629c:	fee9                	bnez	a3,80006276 <virtio_disk_rw+0x46>
  for(int i = 0; i < NUM; i++){
    8000629e:	2785                	addiw	a5,a5,1
    800062a0:	0705                	addi	a4,a4,1
    800062a2:	fe979be3          	bne	a5,s1,80006298 <virtio_disk_rw+0x68>
    idx[i] = alloc_desc();
    800062a6:	0185a023          	sw	s8,0(a1)
      for(int j = 0; j < i; j++)
    800062aa:	01205d63          	blez	s2,800062c4 <virtio_disk_rw+0x94>
        free_desc(idx[j]);
    800062ae:	fa042503          	lw	a0,-96(s0)
    800062b2:	d41ff0ef          	jal	80005ff2 <free_desc>
      for(int j = 0; j < i; j++)
    800062b6:	4785                	li	a5,1
    800062b8:	0127d663          	bge	a5,s2,800062c4 <virtio_disk_rw+0x94>
        free_desc(idx[j]);
    800062bc:	fa442503          	lw	a0,-92(s0)
    800062c0:	d33ff0ef          	jal	80005ff2 <free_desc>
  int idx[3];
  while(1){
    if(alloc3_desc(idx) == 0) {
      break;
    }
    sleep(&disk.free[0], &disk.vdisk_lock);
    800062c4:	02260597          	auipc	a1,0x2260
    800062c8:	1fc58593          	addi	a1,a1,508 # 822664c0 <disk+0x128>
    800062cc:	02260517          	auipc	a0,0x2260
    800062d0:	0e450513          	addi	a0,a0,228 # 822663b0 <disk+0x18>
    800062d4:	b5cfc0ef          	jal	80002630 <sleep>
  for(int i = 0; i < 3; i++){
    800062d8:	fa040613          	addi	a2,s0,-96
    800062dc:	4901                	li	s2,0
    800062de:	b77d                	j	8000628c <virtio_disk_rw+0x5c>
  }

  // format the three descriptors.
  // qemu's virtio-blk.c reads them.

  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    800062e0:	fa042503          	lw	a0,-96(s0)
    800062e4:	00451693          	slli	a3,a0,0x4

  if(write)
    800062e8:	02260797          	auipc	a5,0x2260
    800062ec:	0b078793          	addi	a5,a5,176 # 82266398 <disk>
    800062f0:	00451713          	slli	a4,a0,0x4
    800062f4:	0a070713          	addi	a4,a4,160
    800062f8:	973e                	add	a4,a4,a5
    800062fa:	01603633          	snez	a2,s6
    800062fe:	c710                	sw	a2,8(a4)
    buf0->type = VIRTIO_BLK_T_OUT; // write the disk
  else
    buf0->type = VIRTIO_BLK_T_IN; // read the disk
  buf0->reserved = 0;
    80006300:	00072623          	sw	zero,12(a4)
  buf0->sector = sector;
    80006304:	01773823          	sd	s7,16(a4)

  disk.desc[idx[0]].addr = (uint64) buf0;
    80006308:	6398                	ld	a4,0(a5)
    8000630a:	9736                	add	a4,a4,a3
  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    8000630c:	0a868613          	addi	a2,a3,168 # 100010a8 <_entry-0x6fffef58>
    80006310:	963e                	add	a2,a2,a5
  disk.desc[idx[0]].addr = (uint64) buf0;
    80006312:	e310                	sd	a2,0(a4)
  disk.desc[idx[0]].len = sizeof(struct virtio_blk_req);
    80006314:	6390                	ld	a2,0(a5)
    80006316:	00d60833          	add	a6,a2,a3
    8000631a:	4741                	li	a4,16
    8000631c:	00e82423          	sw	a4,8(a6)
  disk.desc[idx[0]].flags = VRING_DESC_F_NEXT;
    80006320:	4585                	li	a1,1
    80006322:	00b81623          	sh	a1,12(a6)
  disk.desc[idx[0]].next = idx[1];
    80006326:	fa442703          	lw	a4,-92(s0)
    8000632a:	00e81723          	sh	a4,14(a6)

  disk.desc[idx[1]].addr = (uint64) b->data;
    8000632e:	0712                	slli	a4,a4,0x4
    80006330:	963a                	add	a2,a2,a4
    80006332:	05898813          	addi	a6,s3,88
    80006336:	01063023          	sd	a6,0(a2)
  disk.desc[idx[1]].len = BSIZE;
    8000633a:	0007b883          	ld	a7,0(a5)
    8000633e:	9746                	add	a4,a4,a7
    80006340:	40000613          	li	a2,1024
    80006344:	c710                	sw	a2,8(a4)
  if(write)
    80006346:	001b3613          	seqz	a2,s6
    8000634a:	0016161b          	slliw	a2,a2,0x1
    disk.desc[idx[1]].flags = 0; // device reads b->data
  else
    disk.desc[idx[1]].flags = VRING_DESC_F_WRITE; // device writes b->data
  disk.desc[idx[1]].flags |= VRING_DESC_F_NEXT;
    8000634e:	8e4d                	or	a2,a2,a1
    80006350:	00c71623          	sh	a2,12(a4)
  disk.desc[idx[1]].next = idx[2];
    80006354:	fa842603          	lw	a2,-88(s0)
    80006358:	00c71723          	sh	a2,14(a4)

  disk.info[idx[0]].status = 0xff; // device writes 0 on success
    8000635c:	00451813          	slli	a6,a0,0x4
    80006360:	02080813          	addi	a6,a6,32
    80006364:	983e                	add	a6,a6,a5
    80006366:	577d                	li	a4,-1
    80006368:	00e80823          	sb	a4,16(a6)
  disk.desc[idx[2]].addr = (uint64) &disk.info[idx[0]].status;
    8000636c:	0612                	slli	a2,a2,0x4
    8000636e:	98b2                	add	a7,a7,a2
    80006370:	03068713          	addi	a4,a3,48
    80006374:	973e                	add	a4,a4,a5
    80006376:	00e8b023          	sd	a4,0(a7)
  disk.desc[idx[2]].len = 1;
    8000637a:	6398                	ld	a4,0(a5)
    8000637c:	9732                	add	a4,a4,a2
    8000637e:	c70c                	sw	a1,8(a4)
  disk.desc[idx[2]].flags = VRING_DESC_F_WRITE; // device writes the status
    80006380:	4689                	li	a3,2
    80006382:	00d71623          	sh	a3,12(a4)
  disk.desc[idx[2]].next = 0;
    80006386:	00071723          	sh	zero,14(a4)

  // record struct buf for virtio_disk_intr().
  b->disk = 1;
    8000638a:	00b9a223          	sw	a1,4(s3)
  disk.info[idx[0]].b = b;
    8000638e:	01383423          	sd	s3,8(a6)

  // tell the device the first index in our chain of descriptors.
  disk.avail->ring[disk.avail->idx % NUM] = idx[0];
    80006392:	6794                	ld	a3,8(a5)
    80006394:	0026d703          	lhu	a4,2(a3)
    80006398:	8b1d                	andi	a4,a4,7
    8000639a:	0706                	slli	a4,a4,0x1
    8000639c:	96ba                	add	a3,a3,a4
    8000639e:	00a69223          	sh	a0,4(a3)

  __sync_synchronize();
    800063a2:	0330000f          	fence	rw,rw

  // tell the device another avail ring entry is available.
  disk.avail->idx += 1; // not % NUM ...
    800063a6:	6798                	ld	a4,8(a5)
    800063a8:	00275783          	lhu	a5,2(a4)
    800063ac:	2785                	addiw	a5,a5,1
    800063ae:	00f71123          	sh	a5,2(a4)

  __sync_synchronize();
    800063b2:	0330000f          	fence	rw,rw

  *R(VIRTIO_MMIO_QUEUE_NOTIFY) = 0; // value is queue number
    800063b6:	100017b7          	lui	a5,0x10001
    800063ba:	0407a823          	sw	zero,80(a5) # 10001050 <_entry-0x6fffefb0>

  // Wait for virtio_disk_intr() to say request has finished.
  while(b->disk == 1) {
    800063be:	0049a783          	lw	a5,4(s3)
    sleep(b, &disk.vdisk_lock);
    800063c2:	02260917          	auipc	s2,0x2260
    800063c6:	0fe90913          	addi	s2,s2,254 # 822664c0 <disk+0x128>
  while(b->disk == 1) {
    800063ca:	84ae                	mv	s1,a1
    800063cc:	00b79a63          	bne	a5,a1,800063e0 <virtio_disk_rw+0x1b0>
    sleep(b, &disk.vdisk_lock);
    800063d0:	85ca                	mv	a1,s2
    800063d2:	854e                	mv	a0,s3
    800063d4:	a5cfc0ef          	jal	80002630 <sleep>
  while(b->disk == 1) {
    800063d8:	0049a783          	lw	a5,4(s3)
    800063dc:	fe978ae3          	beq	a5,s1,800063d0 <virtio_disk_rw+0x1a0>
  }

  disk.info[idx[0]].b = 0;
    800063e0:	fa042903          	lw	s2,-96(s0)
    800063e4:	00491713          	slli	a4,s2,0x4
    800063e8:	02070713          	addi	a4,a4,32
    800063ec:	02260797          	auipc	a5,0x2260
    800063f0:	fac78793          	addi	a5,a5,-84 # 82266398 <disk>
    800063f4:	97ba                	add	a5,a5,a4
    800063f6:	0007b423          	sd	zero,8(a5)
    int flag = disk.desc[i].flags;
    800063fa:	02260997          	auipc	s3,0x2260
    800063fe:	f9e98993          	addi	s3,s3,-98 # 82266398 <disk>
    80006402:	00491713          	slli	a4,s2,0x4
    80006406:	0009b783          	ld	a5,0(s3)
    8000640a:	97ba                	add	a5,a5,a4
    8000640c:	00c7d483          	lhu	s1,12(a5)
    int nxt = disk.desc[i].next;
    80006410:	854a                	mv	a0,s2
    80006412:	00e7d903          	lhu	s2,14(a5)
    free_desc(i);
    80006416:	bddff0ef          	jal	80005ff2 <free_desc>
    if(flag & VRING_DESC_F_NEXT)
    8000641a:	8885                	andi	s1,s1,1
    8000641c:	f0fd                	bnez	s1,80006402 <virtio_disk_rw+0x1d2>
  free_chain(idx[0]);

  release(&disk.vdisk_lock);
    8000641e:	02260517          	auipc	a0,0x2260
    80006422:	0a250513          	addi	a0,a0,162 # 822664c0 <disk+0x128>
    80006426:	897fa0ef          	jal	80000cbc <release>
}
    8000642a:	60e6                	ld	ra,88(sp)
    8000642c:	6446                	ld	s0,80(sp)
    8000642e:	64a6                	ld	s1,72(sp)
    80006430:	6906                	ld	s2,64(sp)
    80006432:	79e2                	ld	s3,56(sp)
    80006434:	7a42                	ld	s4,48(sp)
    80006436:	7aa2                	ld	s5,40(sp)
    80006438:	7b02                	ld	s6,32(sp)
    8000643a:	6be2                	ld	s7,24(sp)
    8000643c:	6c42                	ld	s8,16(sp)
    8000643e:	6125                	addi	sp,sp,96
    80006440:	8082                	ret

0000000080006442 <virtio_disk_intr>:

void
virtio_disk_intr()
{
    80006442:	1101                	addi	sp,sp,-32
    80006444:	ec06                	sd	ra,24(sp)
    80006446:	e822                	sd	s0,16(sp)
    80006448:	e426                	sd	s1,8(sp)
    8000644a:	1000                	addi	s0,sp,32
  acquire(&disk.vdisk_lock);
    8000644c:	02260497          	auipc	s1,0x2260
    80006450:	f4c48493          	addi	s1,s1,-180 # 82266398 <disk>
    80006454:	02260517          	auipc	a0,0x2260
    80006458:	06c50513          	addi	a0,a0,108 # 822664c0 <disk+0x128>
    8000645c:	fccfa0ef          	jal	80000c28 <acquire>
  // we've seen this interrupt, which the following line does.
  // this may race with the device writing new entries to
  // the "used" ring, in which case we may process the new
  // completion entries in this interrupt, and have nothing to do
  // in the next interrupt, which is harmless.
  *R(VIRTIO_MMIO_INTERRUPT_ACK) = *R(VIRTIO_MMIO_INTERRUPT_STATUS) & 0x3;
    80006460:	100017b7          	lui	a5,0x10001
    80006464:	53bc                	lw	a5,96(a5)
    80006466:	8b8d                	andi	a5,a5,3
    80006468:	10001737          	lui	a4,0x10001
    8000646c:	d37c                	sw	a5,100(a4)

  __sync_synchronize();
    8000646e:	0330000f          	fence	rw,rw

  // the device increments disk.used->idx when it
  // adds an entry to the used ring.

  while(disk.used_idx != disk.used->idx){
    80006472:	689c                	ld	a5,16(s1)
    80006474:	0204d703          	lhu	a4,32(s1)
    80006478:	0027d783          	lhu	a5,2(a5) # 10001002 <_entry-0x6fffeffe>
    8000647c:	04f70863          	beq	a4,a5,800064cc <virtio_disk_intr+0x8a>
    __sync_synchronize();
    80006480:	0330000f          	fence	rw,rw
    int id = disk.used->ring[disk.used_idx % NUM].id;
    80006484:	6898                	ld	a4,16(s1)
    80006486:	0204d783          	lhu	a5,32(s1)
    8000648a:	8b9d                	andi	a5,a5,7
    8000648c:	078e                	slli	a5,a5,0x3
    8000648e:	97ba                	add	a5,a5,a4
    80006490:	43dc                	lw	a5,4(a5)

    if(disk.info[id].status != 0)
    80006492:	00479713          	slli	a4,a5,0x4
    80006496:	02070713          	addi	a4,a4,32 # 10001020 <_entry-0x6fffefe0>
    8000649a:	9726                	add	a4,a4,s1
    8000649c:	01074703          	lbu	a4,16(a4)
    800064a0:	e329                	bnez	a4,800064e2 <virtio_disk_intr+0xa0>
      panic("virtio_disk_intr status");

    struct buf *b = disk.info[id].b;
    800064a2:	0792                	slli	a5,a5,0x4
    800064a4:	02078793          	addi	a5,a5,32
    800064a8:	97a6                	add	a5,a5,s1
    800064aa:	6788                	ld	a0,8(a5)
    b->disk = 0;   // disk is done with buf
    800064ac:	00052223          	sw	zero,4(a0)
    wakeup(b);
    800064b0:	9ccfc0ef          	jal	8000267c <wakeup>

    disk.used_idx += 1;
    800064b4:	0204d783          	lhu	a5,32(s1)
    800064b8:	2785                	addiw	a5,a5,1
    800064ba:	17c2                	slli	a5,a5,0x30
    800064bc:	93c1                	srli	a5,a5,0x30
    800064be:	02f49023          	sh	a5,32(s1)
  while(disk.used_idx != disk.used->idx){
    800064c2:	6898                	ld	a4,16(s1)
    800064c4:	00275703          	lhu	a4,2(a4)
    800064c8:	faf71ce3          	bne	a4,a5,80006480 <virtio_disk_intr+0x3e>
  }

  release(&disk.vdisk_lock);
    800064cc:	02260517          	auipc	a0,0x2260
    800064d0:	ff450513          	addi	a0,a0,-12 # 822664c0 <disk+0x128>
    800064d4:	fe8fa0ef          	jal	80000cbc <release>
}
    800064d8:	60e2                	ld	ra,24(sp)
    800064da:	6442                	ld	s0,16(sp)
    800064dc:	64a2                	ld	s1,8(sp)
    800064de:	6105                	addi	sp,sp,32
    800064e0:	8082                	ret
      panic("virtio_disk_intr status");
    800064e2:	00002517          	auipc	a0,0x2
    800064e6:	55650513          	addi	a0,a0,1366 # 80008a38 <etext+0xa38>
    800064ea:	b3afa0ef          	jal	80000824 <panic>
	...

0000000080007000 <_trampoline>:
    80007000:	14051073          	csrw	sscratch,a0
    80007004:	02000537          	lui	a0,0x2000
    80007008:	357d                	addiw	a0,a0,-1 # 1ffffff <_entry-0x7e000001>
    8000700a:	0536                	slli	a0,a0,0xd
    8000700c:	02153423          	sd	ra,40(a0)
    80007010:	02253823          	sd	sp,48(a0)
    80007014:	02353c23          	sd	gp,56(a0)
    80007018:	04453023          	sd	tp,64(a0)
    8000701c:	04553423          	sd	t0,72(a0)
    80007020:	04653823          	sd	t1,80(a0)
    80007024:	04753c23          	sd	t2,88(a0)
    80007028:	f120                	sd	s0,96(a0)
    8000702a:	f524                	sd	s1,104(a0)
    8000702c:	fd2c                	sd	a1,120(a0)
    8000702e:	e150                	sd	a2,128(a0)
    80007030:	e554                	sd	a3,136(a0)
    80007032:	e958                	sd	a4,144(a0)
    80007034:	ed5c                	sd	a5,152(a0)
    80007036:	0b053023          	sd	a6,160(a0)
    8000703a:	0b153423          	sd	a7,168(a0)
    8000703e:	0b253823          	sd	s2,176(a0)
    80007042:	0b353c23          	sd	s3,184(a0)
    80007046:	0d453023          	sd	s4,192(a0)
    8000704a:	0d553423          	sd	s5,200(a0)
    8000704e:	0d653823          	sd	s6,208(a0)
    80007052:	0d753c23          	sd	s7,216(a0)
    80007056:	0f853023          	sd	s8,224(a0)
    8000705a:	0f953423          	sd	s9,232(a0)
    8000705e:	0fa53823          	sd	s10,240(a0)
    80007062:	0fb53c23          	sd	s11,248(a0)
    80007066:	11c53023          	sd	t3,256(a0)
    8000706a:	11d53423          	sd	t4,264(a0)
    8000706e:	11e53823          	sd	t5,272(a0)
    80007072:	11f53c23          	sd	t6,280(a0)
    80007076:	140022f3          	csrr	t0,sscratch
    8000707a:	06553823          	sd	t0,112(a0)
    8000707e:	00853103          	ld	sp,8(a0)
    80007082:	02053203          	ld	tp,32(a0)
    80007086:	01053283          	ld	t0,16(a0)
    8000708a:	00053303          	ld	t1,0(a0)
    8000708e:	12000073          	sfence.vma
    80007092:	18031073          	csrw	satp,t1
    80007096:	12000073          	sfence.vma
    8000709a:	9282                	jalr	t0

000000008000709c <userret>:
    8000709c:	12000073          	sfence.vma
    800070a0:	18051073          	csrw	satp,a0
    800070a4:	12000073          	sfence.vma
    800070a8:	02000537          	lui	a0,0x2000
    800070ac:	357d                	addiw	a0,a0,-1 # 1ffffff <_entry-0x7e000001>
    800070ae:	0536                	slli	a0,a0,0xd
    800070b0:	02853083          	ld	ra,40(a0)
    800070b4:	03053103          	ld	sp,48(a0)
    800070b8:	03853183          	ld	gp,56(a0)
    800070bc:	04053203          	ld	tp,64(a0)
    800070c0:	04853283          	ld	t0,72(a0)
    800070c4:	05053303          	ld	t1,80(a0)
    800070c8:	05853383          	ld	t2,88(a0)
    800070cc:	7120                	ld	s0,96(a0)
    800070ce:	7524                	ld	s1,104(a0)
    800070d0:	7d2c                	ld	a1,120(a0)
    800070d2:	6150                	ld	a2,128(a0)
    800070d4:	6554                	ld	a3,136(a0)
    800070d6:	6958                	ld	a4,144(a0)
    800070d8:	6d5c                	ld	a5,152(a0)
    800070da:	0a053803          	ld	a6,160(a0)
    800070de:	0a853883          	ld	a7,168(a0)
    800070e2:	0b053903          	ld	s2,176(a0)
    800070e6:	0b853983          	ld	s3,184(a0)
    800070ea:	0c053a03          	ld	s4,192(a0)
    800070ee:	0c853a83          	ld	s5,200(a0)
    800070f2:	0d053b03          	ld	s6,208(a0)
    800070f6:	0d853b83          	ld	s7,216(a0)
    800070fa:	0e053c03          	ld	s8,224(a0)
    800070fe:	0e853c83          	ld	s9,232(a0)
    80007102:	0f053d03          	ld	s10,240(a0)
    80007106:	0f853d83          	ld	s11,248(a0)
    8000710a:	10053e03          	ld	t3,256(a0)
    8000710e:	10853e83          	ld	t4,264(a0)
    80007112:	11053f03          	ld	t5,272(a0)
    80007116:	11853f83          	ld	t6,280(a0)
    8000711a:	7928                	ld	a0,112(a0)
    8000711c:	10200073          	sret
	...
