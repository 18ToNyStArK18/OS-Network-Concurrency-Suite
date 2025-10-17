
kernel/kernel:     file format elf64-littleriscv


Disassembly of section .text:

0000000080000000 <_entry>:
_entry:
        # set up a stack for C.
        # stack0 is declared in start.c,
        # with a 4096-byte stack per CPU.
        # sp = stack0 + ((hartid + 1) * 4096)
        la sp, stack0
    80000000:	0000c117          	auipc	sp,0xc
    80000004:	8a010113          	addi	sp,sp,-1888 # 8000b8a0 <stack0>
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
    80000072:	7ff70713          	addi	a4,a4,2047 # ffffffffffffe7ff <end+0xffffffff7dd89a57>
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
    8000011a:	1c5020ef          	jal	80002ade <either_copyin>
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
    80000196:	70e50513          	addi	a0,a0,1806 # 800138a0 <cons>
    8000019a:	28f000ef          	jal	80000c28 <acquire>
  while(n > 0){
    // wait until interrupt handler has put some
    // input into cons.buffer.
    while(cons.r == cons.w){
    8000019e:	00013497          	auipc	s1,0x13
    800001a2:	70248493          	addi	s1,s1,1794 # 800138a0 <cons>
      if(killed(myproc())){
        release(&cons.lock);
        return -1;
      }
      sleep(&cons.r, &cons.lock);
    800001a6:	00013917          	auipc	s2,0x13
    800001aa:	79290913          	addi	s2,s2,1938 # 80013938 <cons+0x98>
  while(n > 0){
    800001ae:	0b305b63          	blez	s3,80000264 <consoleread+0xee>
    while(cons.r == cons.w){
    800001b2:	0984a783          	lw	a5,152(s1)
    800001b6:	09c4a703          	lw	a4,156(s1)
    800001ba:	0af71063          	bne	a4,a5,8000025a <consoleread+0xe4>
      if(killed(myproc())){
    800001be:	5fb010ef          	jal	80001fb8 <myproc>
    800001c2:	7b0020ef          	jal	80002972 <killed>
    800001c6:	e12d                	bnez	a0,80000228 <consoleread+0xb2>
      sleep(&cons.r, &cons.lock);
    800001c8:	85a6                	mv	a1,s1
    800001ca:	854a                	mv	a0,s2
    800001cc:	50e020ef          	jal	800026da <sleep>
    while(cons.r == cons.w){
    800001d0:	0984a783          	lw	a5,152(s1)
    800001d4:	09c4a703          	lw	a4,156(s1)
    800001d8:	fef703e3          	beq	a4,a5,800001be <consoleread+0x48>
    800001dc:	f456                	sd	s5,40(sp)
    }

    c = cons.buf[cons.r++ % INPUT_BUF_SIZE];
    800001de:	00013717          	auipc	a4,0x13
    800001e2:	6c270713          	addi	a4,a4,1730 # 800138a0 <cons>
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
    80000210:	085020ef          	jal	80002a94 <either_copyout>
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
    8000022c:	67850513          	addi	a0,a0,1656 # 800138a0 <cons>
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
    80000252:	6ef72523          	sw	a5,1770(a4) # 80013938 <cons+0x98>
    80000256:	7aa2                	ld	s5,40(sp)
    80000258:	a031                	j	80000264 <consoleread+0xee>
    8000025a:	f456                	sd	s5,40(sp)
    8000025c:	b749                	j	800001de <consoleread+0x68>
    8000025e:	7aa2                	ld	s5,40(sp)
    80000260:	a011                	j	80000264 <consoleread+0xee>
    80000262:	7aa2                	ld	s5,40(sp)
  release(&cons.lock);
    80000264:	00013517          	auipc	a0,0x13
    80000268:	63c50513          	addi	a0,a0,1596 # 800138a0 <cons>
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
    800002bc:	5e850513          	addi	a0,a0,1512 # 800138a0 <cons>
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
    800002da:	04f020ef          	jal	80002b28 <procdump>
      }
    }
    break;
  }
  
  release(&cons.lock);
    800002de:	00013517          	auipc	a0,0x13
    800002e2:	5c250513          	addi	a0,a0,1474 # 800138a0 <cons>
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
    80000300:	5a470713          	addi	a4,a4,1444 # 800138a0 <cons>
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
    80000326:	57e70713          	addi	a4,a4,1406 # 800138a0 <cons>
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
    80000350:	5ec72703          	lw	a4,1516(a4) # 80013938 <cons+0x98>
    80000354:	9f99                	subw	a5,a5,a4
    80000356:	08000713          	li	a4,128
    8000035a:	f8e792e3          	bne	a5,a4,800002de <consoleintr+0x32>
    8000035e:	a075                	j	8000040a <consoleintr+0x15e>
    80000360:	e04a                	sd	s2,0(sp)
    while(cons.e != cons.w &&
    80000362:	00013717          	auipc	a4,0x13
    80000366:	53e70713          	addi	a4,a4,1342 # 800138a0 <cons>
    8000036a:	0a072783          	lw	a5,160(a4)
    8000036e:	09c72703          	lw	a4,156(a4)
          cons.buf[(cons.e-1) % INPUT_BUF_SIZE] != '\n'){
    80000372:	00013497          	auipc	s1,0x13
    80000376:	52e48493          	addi	s1,s1,1326 # 800138a0 <cons>
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
    800003b8:	4ec70713          	addi	a4,a4,1260 # 800138a0 <cons>
    800003bc:	0a072783          	lw	a5,160(a4)
    800003c0:	09c72703          	lw	a4,156(a4)
    800003c4:	f0f70de3          	beq	a4,a5,800002de <consoleintr+0x32>
      cons.e--;
    800003c8:	37fd                	addiw	a5,a5,-1
    800003ca:	00013717          	auipc	a4,0x13
    800003ce:	56f72b23          	sw	a5,1398(a4) # 80013940 <cons+0xa0>
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
    800003ec:	4b878793          	addi	a5,a5,1208 # 800138a0 <cons>
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
    8000040e:	52c7a923          	sw	a2,1330(a5) # 8001393c <cons+0x9c>
        wakeup(&cons.r);
    80000412:	00013517          	auipc	a0,0x13
    80000416:	52650513          	addi	a0,a0,1318 # 80013938 <cons+0x98>
    8000041a:	30c020ef          	jal	80002726 <wakeup>
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
    80000434:	47050513          	addi	a0,a0,1136 # 800138a0 <cons>
    80000438:	766000ef          	jal	80000b9e <initlock>

  uartinit();
    8000043c:	448000ef          	jal	80000884 <uartinit>

  // connect read and write system calls
  // to consoleread and consolewrite.
  devsw[CONSOLE].read = consoleread;
    80000440:	02273797          	auipc	a5,0x2273
    80000444:	7d078793          	addi	a5,a5,2000 # 82273c10 <devsw>
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
    80000482:	65a80813          	addi	a6,a6,1626 # 80008ad8 <digits>
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
    8000051c:	35c7a783          	lw	a5,860(a5) # 8000b874 <panicking>
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
    80000562:	3ea50513          	addi	a0,a0,1002 # 80013948 <pr>
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
    800006d6:	406c8c93          	addi	s9,s9,1030 # 80008ad8 <digits>
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
    8000075e:	11a7a783          	lw	a5,282(a5) # 8000b874 <panicking>
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
    80000788:	1c450513          	addi	a0,a0,452 # 80013948 <pr>
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
    80000838:	0497a023          	sw	s1,64(a5) # 8000b874 <panicking>
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
    8000085a:	0097ad23          	sw	s1,26(a5) # 8000b870 <panicked>
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
    80000874:	0d850513          	addi	a0,a0,216 # 80013948 <pr>
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
    800008ca:	09a50513          	addi	a0,a0,154 # 80013960 <tx_lock>
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
    800008ee:	07650513          	addi	a0,a0,118 # 80013960 <tx_lock>
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
    8000090c:	f7448493          	addi	s1,s1,-140 # 8000b87c <tx_busy>
      // wait for a UART transmit-complete interrupt
      // to set tx_busy to 0.
      sleep(&tx_chan, &tx_lock);
    80000910:	00013997          	auipc	s3,0x13
    80000914:	05098993          	addi	s3,s3,80 # 80013960 <tx_lock>
    80000918:	0000b917          	auipc	s2,0xb
    8000091c:	f6090913          	addi	s2,s2,-160 # 8000b878 <tx_chan>
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
    8000092c:	5af010ef          	jal	800026da <sleep>
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
    8000095a:	00a50513          	addi	a0,a0,10 # 80013960 <tx_lock>
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
    8000097e:	efa7a783          	lw	a5,-262(a5) # 8000b874 <panicking>
    80000982:	cf95                	beqz	a5,800009be <uartputc_sync+0x50>
    push_off();

  if(panicked){
    80000984:	0000b797          	auipc	a5,0xb
    80000988:	eec7a783          	lw	a5,-276(a5) # 8000b870 <panicked>
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
    800009ae:	eca7a783          	lw	a5,-310(a5) # 8000b874 <panicking>
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
    80000a0a:	f5a50513          	addi	a0,a0,-166 # 80013960 <tx_lock>
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
    80000a24:	f4050513          	addi	a0,a0,-192 # 80013960 <tx_lock>
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
    80000a40:	e407a023          	sw	zero,-448(a5) # 8000b87c <tx_busy>
    wakeup(&tx_chan);
    80000a44:	0000b517          	auipc	a0,0xb
    80000a48:	e3450513          	addi	a0,a0,-460 # 8000b878 <tx_chan>
    80000a4c:	4db010ef          	jal	80002726 <wakeup>
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
    80000a68:	02274797          	auipc	a5,0x2274
    80000a6c:	34078793          	addi	a5,a5,832 # 82274da8 <end>
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
    80000a96:	ee690913          	addi	s2,s2,-282 # 80013978 <kmem>
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
    80000b24:	e5850513          	addi	a0,a0,-424 # 80013978 <kmem>
    80000b28:	076000ef          	jal	80000b9e <initlock>
  freerange(end, (void*)PHYSTOP);
    80000b2c:	45c5                	li	a1,17
    80000b2e:	05ee                	slli	a1,a1,0x1b
    80000b30:	02274517          	auipc	a0,0x2274
    80000b34:	27850513          	addi	a0,a0,632 # 82274da8 <end>
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
    80000b52:	e2a50513          	addi	a0,a0,-470 # 80013978 <kmem>
    80000b56:	0d2000ef          	jal	80000c28 <acquire>
  r = kmem.freelist;
    80000b5a:	00013497          	auipc	s1,0x13
    80000b5e:	e364b483          	ld	s1,-458(s1) # 80013990 <kmem+0x18>
  if(r)
    80000b62:	c49d                	beqz	s1,80000b90 <kalloc+0x4c>
    kmem.freelist = r->next;
    80000b64:	609c                	ld	a5,0(s1)
    80000b66:	00013717          	auipc	a4,0x13
    80000b6a:	e2f73523          	sd	a5,-470(a4) # 80013990 <kmem+0x18>
  release(&kmem.lock);
    80000b6e:	00013517          	auipc	a0,0x13
    80000b72:	e0a50513          	addi	a0,a0,-502 # 80013978 <kmem>
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
    80000b94:	de850513          	addi	a0,a0,-536 # 80013978 <kmem>
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
    80000bce:	3ca010ef          	jal	80001f98 <mycpu>
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
    80000bfe:	39a010ef          	jal	80001f98 <mycpu>
    80000c02:	5d3c                	lw	a5,120(a0)
    80000c04:	cb99                	beqz	a5,80000c1a <push_off+0x36>
    mycpu()->intena = old;
  mycpu()->noff += 1;
    80000c06:	392010ef          	jal	80001f98 <mycpu>
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
    80000c1a:	37e010ef          	jal	80001f98 <mycpu>
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
    80000c50:	348010ef          	jal	80001f98 <mycpu>
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
    80000c74:	324010ef          	jal	80001f98 <mycpu>
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
    80000eb6:	0ce010ef          	jal	80001f84 <cpuid>
    virtio_disk_init(); // emulated hard disk
    userinit();      // first user process
    __sync_synchronize();
    started = 1;
  } else {
    while(started == 0)
    80000eba:	0000b717          	auipc	a4,0xb
    80000ebe:	9c670713          	addi	a4,a4,-1594 # 8000b880 <started>
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
    80000ece:	0b6010ef          	jal	80001f84 <cpuid>
    80000ed2:	85aa                	mv	a1,a0
    80000ed4:	00007517          	auipc	a0,0x7
    80000ed8:	1bc50513          	addi	a0,a0,444 # 80008090 <etext+0x90>
    80000edc:	e1eff0ef          	jal	800004fa <printf>
    kvminithart();    // turn on paging
    80000ee0:	080000ef          	jal	80000f60 <kvminithart>
    trapinithart();   // install kernel trap vector
    80000ee4:	581010ef          	jal	80002c64 <trapinithart>
    plicinithart();   // ask PLIC for device interrupts
    80000ee8:	360050ef          	jal	80006248 <plicinithart>
  }

  scheduler();        
    80000eec:	64e010ef          	jal	8000253a <scheduler>
    consoleinit();
    80000ef0:	d30ff0ef          	jal	80000420 <consoleinit>
    printfinit();
    80000ef4:	96dff0ef          	jal	80000860 <printfinit>
    printf("\n");
    80000ef8:	00007517          	auipc	a0,0x7
    80000efc:	23850513          	addi	a0,a0,568 # 80008130 <etext+0x130>
    80000f00:	dfaff0ef          	jal	800004fa <printf>
    printf("xv6 kernel is booting\n");
    80000f04:	00007517          	auipc	a0,0x7
    80000f08:	17450513          	addi	a0,a0,372 # 80008078 <etext+0x78>
    80000f0c:	deeff0ef          	jal	800004fa <printf>
    printf("\n");
    80000f10:	00007517          	auipc	a0,0x7
    80000f14:	22050513          	addi	a0,a0,544 # 80008130 <etext+0x130>
    80000f18:	de2ff0ef          	jal	800004fa <printf>
    kinit();         // physical page allocator
    80000f1c:	bf5ff0ef          	jal	80000b10 <kinit>
    kvminit();       // create kernel page table
    80000f20:	2c4000ef          	jal	800011e4 <kvminit>
    kvminithart();   // turn on paging
    80000f24:	03c000ef          	jal	80000f60 <kvminithart>
    procinit();      // process table
    80000f28:	79d000ef          	jal	80001ec4 <procinit>
    trapinit();      // trap vectors
    80000f2c:	515010ef          	jal	80002c40 <trapinit>
    trapinithart();  // install kernel trap vector
    80000f30:	535010ef          	jal	80002c64 <trapinithart>
    plicinit();      // set up interrupt controller
    80000f34:	2fa050ef          	jal	8000622e <plicinit>
    plicinithart();  // ask PLIC for device interrupts
    80000f38:	310050ef          	jal	80006248 <plicinithart>
    binit();         // buffer cache
    80000f3c:	682020ef          	jal	800035be <binit>
    iinit();         // inode table
    80000f40:	3d5020ef          	jal	80003b14 <iinit>
    fileinit();      // file table
    80000f44:	301030ef          	jal	80004a44 <fileinit>
    virtio_disk_init(); // emulated hard disk
    80000f48:	3f0050ef          	jal	80006338 <virtio_disk_init>
    userinit();      // first user process
    80000f4c:	38a010ef          	jal	800022d6 <userinit>
    __sync_synchronize();
    80000f50:	0330000f          	fence	rw,rw
    started = 1;
    80000f54:	4785                	li	a5,1
    80000f56:	0000b717          	auipc	a4,0xb
    80000f5a:	92f72523          	sw	a5,-1750(a4) # 8000b880 <started>
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
    80000f70:	91c7b783          	ld	a5,-1764(a5) # 8000b888 <kernel_pagetable>
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
            return-1;
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
    800010a8:	c139                	beqz	a0,800010ee <mappages+0x8e>
        if(*pte & PTE_V)
    800010aa:	611c                	ld	a5,0(a0)
    800010ac:	8b85                	andi	a5,a5,1
    800010ae:	efa1                	bnez	a5,80001106 <mappages+0xa6>
        *pte = PA2PTE(pa) | perm | PTE_V;
    800010b0:	013487b3          	add	a5,s1,s3
    800010b4:	83b1                	srli	a5,a5,0xc
    800010b6:	07aa                	slli	a5,a5,0xa
    800010b8:	0157e7b3          	or	a5,a5,s5
    800010bc:	0017e793          	ori	a5,a5,1
    800010c0:	e11c                	sd	a5,0(a0)
        if(a == last)
    800010c2:	05248463          	beq	s1,s2,8000110a <mappages+0xaa>
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
            return -1;
    800010ee:	557d                	li	a0,-1
        pa += PGSIZE;
    }
    return 0;
}
    800010f0:	60a6                	ld	ra,72(sp)
    800010f2:	6406                	ld	s0,64(sp)
    800010f4:	74e2                	ld	s1,56(sp)
    800010f6:	7942                	ld	s2,48(sp)
    800010f8:	79a2                	ld	s3,40(sp)
    800010fa:	7a02                	ld	s4,32(sp)
    800010fc:	6ae2                	ld	s5,24(sp)
    800010fe:	6b42                	ld	s6,16(sp)
    80001100:	6ba2                	ld	s7,8(sp)
    80001102:	6161                	addi	sp,sp,80
    80001104:	8082                	ret
            return-1;
    80001106:	557d                	li	a0,-1
    80001108:	b7e5                	j	800010f0 <mappages+0x90>
    return 0;
    8000110a:	4501                	li	a0,0
    8000110c:	b7d5                	j	800010f0 <mappages+0x90>

000000008000110e <kvmmap>:
{
    8000110e:	1141                	addi	sp,sp,-16
    80001110:	e406                	sd	ra,8(sp)
    80001112:	e022                	sd	s0,0(sp)
    80001114:	0800                	addi	s0,sp,16
    80001116:	87b6                	mv	a5,a3
    if(mappages(kpgtbl, va, sz, pa, perm) != 0)
    80001118:	86b2                	mv	a3,a2
    8000111a:	863e                	mv	a2,a5
    8000111c:	f45ff0ef          	jal	80001060 <mappages>
    80001120:	e509                	bnez	a0,8000112a <kvmmap+0x1c>
}
    80001122:	60a2                	ld	ra,8(sp)
    80001124:	6402                	ld	s0,0(sp)
    80001126:	0141                	addi	sp,sp,16
    80001128:	8082                	ret
        panic("kvmmap");
    8000112a:	00007517          	auipc	a0,0x7
    8000112e:	fd650513          	addi	a0,a0,-42 # 80008100 <etext+0x100>
    80001132:	ef2ff0ef          	jal	80000824 <panic>

0000000080001136 <kvmmake>:
{
    80001136:	1101                	addi	sp,sp,-32
    80001138:	ec06                	sd	ra,24(sp)
    8000113a:	e822                	sd	s0,16(sp)
    8000113c:	e426                	sd	s1,8(sp)
    8000113e:	1000                	addi	s0,sp,32
    kpgtbl = (pagetable_t) kalloc();
    80001140:	a05ff0ef          	jal	80000b44 <kalloc>
    80001144:	84aa                	mv	s1,a0
    memset(kpgtbl, 0, PGSIZE);
    80001146:	6605                	lui	a2,0x1
    80001148:	4581                	li	a1,0
    8000114a:	bafff0ef          	jal	80000cf8 <memset>
    kvmmap(kpgtbl, UART0, UART0, PGSIZE, PTE_R | PTE_W);
    8000114e:	4719                	li	a4,6
    80001150:	6685                	lui	a3,0x1
    80001152:	10000637          	lui	a2,0x10000
    80001156:	85b2                	mv	a1,a2
    80001158:	8526                	mv	a0,s1
    8000115a:	fb5ff0ef          	jal	8000110e <kvmmap>
    kvmmap(kpgtbl, VIRTIO0, VIRTIO0, PGSIZE, PTE_R | PTE_W);
    8000115e:	4719                	li	a4,6
    80001160:	6685                	lui	a3,0x1
    80001162:	10001637          	lui	a2,0x10001
    80001166:	85b2                	mv	a1,a2
    80001168:	8526                	mv	a0,s1
    8000116a:	fa5ff0ef          	jal	8000110e <kvmmap>
    kvmmap(kpgtbl, PLIC, PLIC, 0x4000000, PTE_R | PTE_W);
    8000116e:	4719                	li	a4,6
    80001170:	040006b7          	lui	a3,0x4000
    80001174:	0c000637          	lui	a2,0xc000
    80001178:	85b2                	mv	a1,a2
    8000117a:	8526                	mv	a0,s1
    8000117c:	f93ff0ef          	jal	8000110e <kvmmap>
    kvmmap(kpgtbl, KERNBASE, KERNBASE, (uint64)etext-KERNBASE, PTE_R | PTE_X);
    80001180:	4729                	li	a4,10
    80001182:	80007697          	auipc	a3,0x80007
    80001186:	e7e68693          	addi	a3,a3,-386 # 8000 <_entry-0x7fff8000>
    8000118a:	4605                	li	a2,1
    8000118c:	067e                	slli	a2,a2,0x1f
    8000118e:	85b2                	mv	a1,a2
    80001190:	8526                	mv	a0,s1
    80001192:	f7dff0ef          	jal	8000110e <kvmmap>
    kvmmap(kpgtbl, (uint64)etext, (uint64)etext, PHYSTOP-(uint64)etext, PTE_R | PTE_W);
    80001196:	4719                	li	a4,6
    80001198:	00007697          	auipc	a3,0x7
    8000119c:	e6868693          	addi	a3,a3,-408 # 80008000 <etext>
    800011a0:	47c5                	li	a5,17
    800011a2:	07ee                	slli	a5,a5,0x1b
    800011a4:	40d786b3          	sub	a3,a5,a3
    800011a8:	00007617          	auipc	a2,0x7
    800011ac:	e5860613          	addi	a2,a2,-424 # 80008000 <etext>
    800011b0:	85b2                	mv	a1,a2
    800011b2:	8526                	mv	a0,s1
    800011b4:	f5bff0ef          	jal	8000110e <kvmmap>
    kvmmap(kpgtbl, TRAMPOLINE, (uint64)trampoline, PGSIZE, PTE_R | PTE_X);
    800011b8:	4729                	li	a4,10
    800011ba:	6685                	lui	a3,0x1
    800011bc:	00006617          	auipc	a2,0x6
    800011c0:	e4460613          	addi	a2,a2,-444 # 80007000 <_trampoline>
    800011c4:	040005b7          	lui	a1,0x4000
    800011c8:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    800011ca:	05b2                	slli	a1,a1,0xc
    800011cc:	8526                	mv	a0,s1
    800011ce:	f41ff0ef          	jal	8000110e <kvmmap>
    proc_mapstacks(kpgtbl);
    800011d2:	8526                	mv	a0,s1
    800011d4:	443000ef          	jal	80001e16 <proc_mapstacks>
}
    800011d8:	8526                	mv	a0,s1
    800011da:	60e2                	ld	ra,24(sp)
    800011dc:	6442                	ld	s0,16(sp)
    800011de:	64a2                	ld	s1,8(sp)
    800011e0:	6105                	addi	sp,sp,32
    800011e2:	8082                	ret

00000000800011e4 <kvminit>:
{
    800011e4:	1141                	addi	sp,sp,-16
    800011e6:	e406                	sd	ra,8(sp)
    800011e8:	e022                	sd	s0,0(sp)
    800011ea:	0800                	addi	s0,sp,16
    kernel_pagetable = kvmmake();
    800011ec:	f4bff0ef          	jal	80001136 <kvmmake>
    800011f0:	0000a797          	auipc	a5,0xa
    800011f4:	68a7bc23          	sd	a0,1688(a5) # 8000b888 <kernel_pagetable>
}
    800011f8:	60a2                	ld	ra,8(sp)
    800011fa:	6402                	ld	s0,0(sp)
    800011fc:	0141                	addi	sp,sp,16
    800011fe:	8082                	ret

0000000080001200 <uvmcreate>:

// create an empty user page table.
// returns 0 if out of memory.
    pagetable_t
uvmcreate()
{
    80001200:	1101                	addi	sp,sp,-32
    80001202:	ec06                	sd	ra,24(sp)
    80001204:	e822                	sd	s0,16(sp)
    80001206:	e426                	sd	s1,8(sp)
    80001208:	1000                	addi	s0,sp,32
    pagetable_t pagetable;
    pagetable = (pagetable_t) kalloc();
    8000120a:	93bff0ef          	jal	80000b44 <kalloc>
    8000120e:	84aa                	mv	s1,a0
    if(pagetable == 0)
    80001210:	c509                	beqz	a0,8000121a <uvmcreate+0x1a>
        return 0;
    memset(pagetable, 0, PGSIZE);
    80001212:	6605                	lui	a2,0x1
    80001214:	4581                	li	a1,0
    80001216:	ae3ff0ef          	jal	80000cf8 <memset>
    return pagetable;
}
    8000121a:	8526                	mv	a0,s1
    8000121c:	60e2                	ld	ra,24(sp)
    8000121e:	6442                	ld	s0,16(sp)
    80001220:	64a2                	ld	s1,8(sp)
    80001222:	6105                	addi	sp,sp,32
    80001224:	8082                	ret

0000000080001226 <uvmunmap>:
// Remove npages of mappings starting from va. va must be
// page-aligned. It's OK if the mappings don't exist.
// Optionally free the physical memory.
    void
uvmunmap(pagetable_t pagetable, uint64 va, uint64 npages, int do_free)
{
    80001226:	7139                	addi	sp,sp,-64
    80001228:	fc06                	sd	ra,56(sp)
    8000122a:	f822                	sd	s0,48(sp)
    8000122c:	0080                	addi	s0,sp,64
    uint64 a;
    pte_t *pte;

    if((va % PGSIZE) != 0)
    8000122e:	03459793          	slli	a5,a1,0x34
    80001232:	e38d                	bnez	a5,80001254 <uvmunmap+0x2e>
    80001234:	f04a                	sd	s2,32(sp)
    80001236:	ec4e                	sd	s3,24(sp)
    80001238:	e852                	sd	s4,16(sp)
    8000123a:	e456                	sd	s5,8(sp)
    8000123c:	e05a                	sd	s6,0(sp)
    8000123e:	8a2a                	mv	s4,a0
    80001240:	892e                	mv	s2,a1
    80001242:	8ab6                	mv	s5,a3
        panic("uvmunmap: not aligned");

    for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    80001244:	0632                	slli	a2,a2,0xc
    80001246:	00b609b3          	add	s3,a2,a1
    8000124a:	6b05                	lui	s6,0x1
    8000124c:	0535f963          	bgeu	a1,s3,8000129e <uvmunmap+0x78>
    80001250:	f426                	sd	s1,40(sp)
    80001252:	a015                	j	80001276 <uvmunmap+0x50>
    80001254:	f426                	sd	s1,40(sp)
    80001256:	f04a                	sd	s2,32(sp)
    80001258:	ec4e                	sd	s3,24(sp)
    8000125a:	e852                	sd	s4,16(sp)
    8000125c:	e456                	sd	s5,8(sp)
    8000125e:	e05a                	sd	s6,0(sp)
        panic("uvmunmap: not aligned");
    80001260:	00007517          	auipc	a0,0x7
    80001264:	ea850513          	addi	a0,a0,-344 # 80008108 <etext+0x108>
    80001268:	dbcff0ef          	jal	80000824 <panic>
            continue;
        if(do_free){
            uint64 pa = PTE2PA(*pte);
            kfree((void*)pa);
        }
        *pte = 0;
    8000126c:	0004b023          	sd	zero,0(s1)
    for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    80001270:	995a                	add	s2,s2,s6
    80001272:	03397563          	bgeu	s2,s3,8000129c <uvmunmap+0x76>
        if((pte = walk(pagetable, a, 0)) == 0) // leaf page table entry allocated?
    80001276:	4601                	li	a2,0
    80001278:	85ca                	mv	a1,s2
    8000127a:	8552                	mv	a0,s4
    8000127c:	d11ff0ef          	jal	80000f8c <walk>
    80001280:	84aa                	mv	s1,a0
    80001282:	d57d                	beqz	a0,80001270 <uvmunmap+0x4a>
        if((*pte & PTE_V) == 0)  // has physical page been allocated?
    80001284:	611c                	ld	a5,0(a0)
    80001286:	0017f713          	andi	a4,a5,1
    8000128a:	d37d                	beqz	a4,80001270 <uvmunmap+0x4a>
        if(do_free){
    8000128c:	fe0a80e3          	beqz	s5,8000126c <uvmunmap+0x46>
            uint64 pa = PTE2PA(*pte);
    80001290:	83a9                	srli	a5,a5,0xa
            kfree((void*)pa);
    80001292:	00c79513          	slli	a0,a5,0xc
    80001296:	fc6ff0ef          	jal	80000a5c <kfree>
    8000129a:	bfc9                	j	8000126c <uvmunmap+0x46>
    8000129c:	74a2                	ld	s1,40(sp)
    8000129e:	7902                	ld	s2,32(sp)
    800012a0:	69e2                	ld	s3,24(sp)
    800012a2:	6a42                	ld	s4,16(sp)
    800012a4:	6aa2                	ld	s5,8(sp)
    800012a6:	6b02                	ld	s6,0(sp)
    }
}
    800012a8:	70e2                	ld	ra,56(sp)
    800012aa:	7442                	ld	s0,48(sp)
    800012ac:	6121                	addi	sp,sp,64
    800012ae:	8082                	ret

00000000800012b0 <handle_pgfault>:
{
    800012b0:	7115                	addi	sp,sp,-224
    800012b2:	ed86                	sd	ra,216(sp)
    800012b4:	e9a2                	sd	s0,208(sp)
    800012b6:	e1ca                	sd	s2,192(sp)
    800012b8:	e566                	sd	s9,136(sp)
    800012ba:	e16a                	sd	s10,128(sp)
    800012bc:	1180                	addi	s0,sp,224
    800012be:	8caa                	mv	s9,a0
    800012c0:	892e                	mv	s2,a1
    800012c2:	8d32                	mv	s10,a2
    struct proc *p = myproc();
    800012c4:	4f5000ef          	jal	80001fb8 <myproc>
    if(va >= MAXVA){
    800012c8:	57fd                	li	a5,-1
    800012ca:	83e9                	srli	a5,a5,0x1a
    800012cc:	5927e163          	bltu	a5,s2,8000184e <handle_pgfault+0x59e>
    800012d0:	e5a6                	sd	s1,200(sp)
    800012d2:	fd4e                	sd	s3,184(sp)
    800012d4:	f952                	sd	s4,176(sp)
    800012d6:	84aa                	mv	s1,a0
    mem = kalloc();
    800012d8:	86dff0ef          	jal	80000b44 <kalloc>
    800012dc:	89aa                	mv	s3,a0
    if(mem == 0){
    800012de:	cd3d                	beqz	a0,8000135c <handle_pgfault+0xac>
    va = PGROUNDDOWN(va);
    800012e0:	77fd                	lui	a5,0xfffff
    800012e2:	00f97933          	and	s2,s2,a5
    memset(mem, 0, PGSIZE);
    800012e6:	6605                	lui	a2,0x1
    800012e8:	4581                	li	a1,0
    800012ea:	854e                	mv	a0,s3
    800012ec:	a0dff0ef          	jal	80000cf8 <memset>
    for(int i = 0; i < p->num_swappped_pages; i++){
    800012f0:	000897b7          	lui	a5,0x89
    800012f4:	97a6                	add	a5,a5,s1
    800012f6:	1cc7a603          	lw	a2,460(a5) # 891cc <_entry-0x7ff76e34>
    800012fa:	00c05f63          	blez	a2,80001318 <handle_pgfault+0x68>
    800012fe:	00089737          	lui	a4,0x89
    80001302:	df070713          	addi	a4,a4,-528 # 88df0 <_entry-0x7ff77210>
    80001306:	9726                	add	a4,a4,s1
    80001308:	4781                	li	a5,0
        if(p->swapped_pages[i].va == va){
    8000130a:	6314                	ld	a3,0(a4)
    8000130c:	23268b63          	beq	a3,s2,80001542 <handle_pgfault+0x292>
    for(int i = 0; i < p->num_swappped_pages; i++){
    80001310:	2785                	addiw	a5,a5,1
    80001312:	0741                	addi	a4,a4,16
    80001314:	fec79be3          	bne	a5,a2,8000130a <handle_pgfault+0x5a>
        int heap_or_stack = (va >= p->heap_start && va < p->sz);
    80001318:	1684b783          	ld	a5,360(s1)
    8000131c:	00f96563          	bltu	s2,a5,80001326 <handle_pgfault+0x76>
    80001320:	64bc                	ld	a5,72(s1)
    80001322:	50f97663          	bgeu	s2,a5,8000182e <handle_pgfault+0x57e>
        readi(p->exec_ip, 0, (uint64)&elf, 0, sizeof(elf));
    80001326:	04000713          	li	a4,64
    8000132a:	4681                	li	a3,0
    8000132c:	f6040613          	addi	a2,s0,-160
    80001330:	4581                	li	a1,0
    80001332:	1704b503          	ld	a0,368(s1)
    80001336:	539020ef          	jal	8000406e <readi>
        for(int i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)) {
    8000133a:	f9845783          	lhu	a5,-104(s0)
    8000133e:	3c078463          	beqz	a5,80001706 <handle_pgfault+0x456>
    80001342:	f556                	sd	s5,168(sp)
    80001344:	f15a                	sd	s6,160(sp)
    80001346:	ed5e                	sd	s7,152(sp)
    80001348:	e962                	sd	s8,144(sp)
    8000134a:	f8042683          	lw	a3,-128(s0)
    8000134e:	4a01                	li	s4,0
            readi(p->exec_ip, 0, (uint64)&ph, off, sizeof(ph));
    80001350:	f2840c13          	addi	s8,s0,-216
    80001354:	03800b93          	li	s7,56
            if(ph.type == ELF_PROG_LOAD && (va >= ph.vaddr && va < ph.vaddr + ph.memsz)) {
    80001358:	4b05                	li	s6,1
    8000135a:	a4c5                	j	8000163a <handle_pgfault+0x38a>
    8000135c:	f556                	sd	s5,168(sp)
    printf("[pid %d] MEMFULL\n",p->pid);
    8000135e:	588c                	lw	a1,48(s1)
    80001360:	00007517          	auipc	a0,0x7
    80001364:	dc050513          	addi	a0,a0,-576 # 80008120 <etext+0x120>
    80001368:	992ff0ef          	jal	800004fa <printf>
    for(int i = 1;i<p->num_resident;i++){
    8000136c:	000897b7          	lui	a5,0x89
    80001370:	97a6                	add	a5,a5,s1
    80001372:	1b07a503          	lw	a0,432(a5) # 891b0 <_entry-0x7ff76e50>
    80001376:	4785                	li	a5,1
    80001378:	02a7d663          	bge	a5,a0,800013a4 <handle_pgfault+0xf4>
    8000137c:	28848693          	addi	a3,s1,648
    int victim_inx = 0;
    80001380:	4581                	li	a1,0
    for(int i = 1;i<p->num_resident;i++){
    80001382:	873e                	mv	a4,a5
    80001384:	a029                	j	8000138e <handle_pgfault+0xde>
    80001386:	2705                	addiw	a4,a4,1
    80001388:	06c1                	addi	a3,a3,16 # 1010 <_entry-0x7fffeff0>
    8000138a:	00a70e63          	beq	a4,a0,800013a6 <handle_pgfault+0xf6>
        if(p->resident_pages[i].seq < p->resident_pages[victim_inx].seq){
    8000138e:	00459793          	slli	a5,a1,0x4
    80001392:	27078793          	addi	a5,a5,624
    80001396:	97a6                	add	a5,a5,s1
    80001398:	4290                	lw	a2,0(a3)
    8000139a:	479c                	lw	a5,8(a5)
    8000139c:	fef655e3          	bge	a2,a5,80001386 <handle_pgfault+0xd6>
            victim_inx = i;
    800013a0:	85ba                	mv	a1,a4
    800013a2:	b7d5                	j	80001386 <handle_pgfault+0xd6>
    int victim_inx = 0;
    800013a4:	4581                	li	a1,0
    uint64 va = p->resident_pages[victim_inx].va;
    800013a6:	0592                	slli	a1,a1,0x4
    800013a8:	00b48a33          	add	s4,s1,a1
    800013ac:	270a3a83          	ld	s5,624(s4)
    int dirty = p->resident_pages[victim_inx].dirty;
    800013b0:	27ca2983          	lw	s3,636(s4)
    printf("[pid %d] VICTIM va=0x%lx seq=%d algo=FIFO\n",p->pid,va,seq);
    800013b4:	278a2683          	lw	a3,632(s4)
    800013b8:	8656                	mv	a2,s5
    800013ba:	588c                	lw	a1,48(s1)
    800013bc:	00007517          	auipc	a0,0x7
    800013c0:	d7c50513          	addi	a0,a0,-644 # 80008138 <etext+0x138>
    800013c4:	936ff0ef          	jal	800004fa <printf>
    if(dirty){
    800013c8:	10098563          	beqz	s3,800014d2 <handle_pgfault+0x222>
        printf("[pid %d] EVICT va=0x%lx state=dirty\n",p->pid,va);
    800013cc:	8656                	mv	a2,s5
    800013ce:	588c                	lw	a1,48(s1)
    800013d0:	00007517          	auipc	a0,0x7
    800013d4:	d9850513          	addi	a0,a0,-616 # 80008168 <etext+0x168>
    800013d8:	922ff0ef          	jal	800004fa <printf>
    for(int i=0;i<MAX_SWAP_PAGES;i++){
    800013dc:	18048793          	addi	a5,s1,384
    800013e0:	4981                	li	s3,0
    800013e2:	03c00693          	li	a3,60
        if(p->swap_slots[i]==0){
    800013e6:	4398                	lw	a4,0(a5)
    800013e8:	cf1d                	beqz	a4,80001426 <handle_pgfault+0x176>
    for(int i=0;i<MAX_SWAP_PAGES;i++){
    800013ea:	2985                	addiw	s3,s3,1
    800013ec:	0791                	addi	a5,a5,4
    800013ee:	fed99ce3          	bne	s3,a3,800013e6 <handle_pgfault+0x136>
            printf("[pid %d] SWAPFULL\n", p->pid);
    800013f2:	588c                	lw	a1,48(s1)
    800013f4:	00007517          	auipc	a0,0x7
    800013f8:	d9c50513          	addi	a0,a0,-612 # 80008190 <etext+0x190>
    800013fc:	8feff0ef          	jal	800004fa <printf>
            printf("[pid %d] KILL swap-exhausted\n", p->pid);
    80001400:	588c                	lw	a1,48(s1)
    80001402:	00007517          	auipc	a0,0x7
    80001406:	da650513          	addi	a0,a0,-602 # 800081a8 <etext+0x1a8>
    8000140a:	8f0ff0ef          	jal	800004fa <printf>
            kexit(-1);
    8000140e:	557d                	li	a0,-1
    80001410:	3ea010ef          	jal	800027fa <kexit>
            setkilled(p);
    80001414:	8526                	mv	a0,s1
    80001416:	538010ef          	jal	8000294e <setkilled>
            return -1;
    8000141a:	557d                	li	a0,-1
    8000141c:	64ae                	ld	s1,200(sp)
    8000141e:	79ea                	ld	s3,184(sp)
    80001420:	7a4a                	ld	s4,176(sp)
    80001422:	7aaa                	ld	s5,168(sp)
    80001424:	a671                	j	800017b0 <handle_pgfault+0x500>
            p->swap_slots[i]=1;
    80001426:	00299793          	slli	a5,s3,0x2
    8000142a:	18078793          	addi	a5,a5,384
    8000142e:	97a6                	add	a5,a5,s1
    80001430:	4705                	li	a4,1
    80001432:	c398                	sw	a4,0(a5)
        if(slot == -1){
    80001434:	57fd                	li	a5,-1
    80001436:	faf98ee3          	beq	s3,a5,800013f2 <handle_pgfault+0x142>
    8000143a:	f15a                	sd	s6,160(sp)
        printf("[pid %d] SWAPOUT va=0x%lx slot=%d\n", p->pid, va, slot);
    8000143c:	86ce                	mv	a3,s3
    8000143e:	8656                	mv	a2,s5
    80001440:	588c                	lw	a1,48(s1)
    80001442:	00007517          	auipc	a0,0x7
    80001446:	d8650513          	addi	a0,a0,-634 # 800081c8 <etext+0x1c8>
    8000144a:	8b0ff0ef          	jal	800004fa <printf>
        uint64 pa = walkaddr(p->pagetable, va);
    8000144e:	85d6                	mv	a1,s5
    80001450:	68a8                	ld	a0,80(s1)
    80001452:	bd5ff0ef          	jal	80001026 <walkaddr>
    80001456:	8b2a                	mv	s6,a0
        begin_op();
    80001458:	290030ef          	jal	800046e8 <begin_op>
    if(p->swap_file == 0)
    8000145c:	1784b783          	ld	a5,376(s1)
    80001460:	cfa1                	beqz	a5,800014b8 <handle_pgfault+0x208>
    ilock(p->swap_file->ip);
    80001462:	6f88                	ld	a0,24(a5)
    80001464:	079020ef          	jal	80003cdc <ilock>
    int result = writei(p->swap_file->ip, 0, (uint64)page_content, slot * PGSIZE, PGSIZE);
    80001468:	1784b783          	ld	a5,376(s1)
    8000146c:	6705                	lui	a4,0x1
    8000146e:	00c9969b          	slliw	a3,s3,0xc
    80001472:	865a                	mv	a2,s6
    80001474:	4581                	li	a1,0
    80001476:	6f88                	ld	a0,24(a5)
    80001478:	4e9020ef          	jal	80004160 <writei>
    8000147c:	8b2a                	mv	s6,a0
    iunlock(p->swap_file->ip);
    8000147e:	1784b783          	ld	a5,376(s1)
    80001482:	6f88                	ld	a0,24(a5)
    80001484:	107020ef          	jal	80003d8a <iunlock>
        if (swap_write_page(p, slot, (char*)pa) != 0) {
    80001488:	6785                	lui	a5,0x1
    8000148a:	02fb1763          	bne	s6,a5,800014b8 <handle_pgfault+0x208>
        end_op();
    8000148e:	2ca030ef          	jal	80004758 <end_op>
        p->swapped_pages[p->num_swappped_pages].va = va;
    80001492:	00089637          	lui	a2,0x89
    80001496:	00c486b3          	add	a3,s1,a2
    8000149a:	1cc6a703          	lw	a4,460(a3)
    8000149e:	00471793          	slli	a5,a4,0x4
    800014a2:	97a6                	add	a5,a5,s1
    800014a4:	97b2                	add	a5,a5,a2
    800014a6:	df57b823          	sd	s5,-528(a5) # df0 <_entry-0x7ffff210>
        p->swapped_pages[p->num_swappped_pages].slot = slot;
    800014aa:	df37ac23          	sw	s3,-520(a5)
        p->num_swappped_pages++;
    800014ae:	2705                	addiw	a4,a4,1 # 1001 <_entry-0x7fffefff>
    800014b0:	1ce6a623          	sw	a4,460(a3)
    800014b4:	7b0a                	ld	s6,160(sp)
    800014b6:	a835                	j	800014f2 <handle_pgfault+0x242>
            end_op();
    800014b8:	2a0030ef          	jal	80004758 <end_op>
            printf("[pid %d] Write failed max file size execeded\n",p->pid);
    800014bc:	588c                	lw	a1,48(s1)
    800014be:	00007517          	auipc	a0,0x7
    800014c2:	d3250513          	addi	a0,a0,-718 # 800081f0 <etext+0x1f0>
    800014c6:	834ff0ef          	jal	800004fa <printf>
            kexit(-1);
    800014ca:	557d                	li	a0,-1
    800014cc:	32e010ef          	jal	800027fa <kexit>
    800014d0:	bf7d                	j	8000148e <handle_pgfault+0x1de>
        printf("[pid %d] EVICT va=0x%lx state=clean\n",p->pid,va);
    800014d2:	8656                	mv	a2,s5
    800014d4:	588c                	lw	a1,48(s1)
    800014d6:	00007517          	auipc	a0,0x7
    800014da:	d4a50513          	addi	a0,a0,-694 # 80008220 <etext+0x220>
    800014de:	81cff0ef          	jal	800004fa <printf>
        printf("[pid %d] DISCARD va=0x%lx\n",p->pid,va);
    800014e2:	8656                	mv	a2,s5
    800014e4:	588c                	lw	a1,48(s1)
    800014e6:	00007517          	auipc	a0,0x7
    800014ea:	d6250513          	addi	a0,a0,-670 # 80008248 <etext+0x248>
    800014ee:	80cff0ef          	jal	800004fa <printf>
    uvmunmap(p->pagetable,va,1,1);
    800014f2:	4685                	li	a3,1
    800014f4:	8636                	mv	a2,a3
    800014f6:	85d6                	mv	a1,s5
    800014f8:	68a8                	ld	a0,80(s1)
    800014fa:	d2dff0ef          	jal	80001226 <uvmunmap>
    p->resident_pages[victim_inx] = p->resident_pages[p->num_resident - 1];
    800014fe:	000897b7          	lui	a5,0x89
    80001502:	97a6                	add	a5,a5,s1
    80001504:	1b07a703          	lw	a4,432(a5) # 891b0 <_entry-0x7ff76e50>
    80001508:	377d                	addiw	a4,a4,-1
    8000150a:	00471693          	slli	a3,a4,0x4
    8000150e:	27068693          	addi	a3,a3,624
    80001512:	96a6                	add	a3,a3,s1
    80001514:	6290                	ld	a2,0(a3)
    80001516:	26ca3823          	sd	a2,624(s4)
    8000151a:	6694                	ld	a3,8(a3)
    8000151c:	26da3c23          	sd	a3,632(s4)
    p->num_resident--;
    80001520:	1ae7a823          	sw	a4,432(a5)
        mem = kalloc();
    80001524:	e20ff0ef          	jal	80000b44 <kalloc>
    80001528:	89aa                	mv	s3,a0
        if(mem == 0){
    8000152a:	c119                	beqz	a0,80001530 <handle_pgfault+0x280>
    8000152c:	7aaa                	ld	s5,168(sp)
    8000152e:	bb4d                	j	800012e0 <handle_pgfault+0x30>
    80001530:	f15a                	sd	s6,160(sp)
    80001532:	ed5e                	sd	s7,152(sp)
    80001534:	e962                	sd	s8,144(sp)
            panic("kalloc failed after eviction");
    80001536:	00007517          	auipc	a0,0x7
    8000153a:	d3250513          	addi	a0,a0,-718 # 80008268 <etext+0x268>
    8000153e:	ae6ff0ef          	jal	80000824 <panic>
            swap_slot = p->swapped_pages[i].slot;
    80001542:	0792                	slli	a5,a5,0x4
    80001544:	97a6                	add	a5,a5,s1
    80001546:	000896b7          	lui	a3,0x89
    8000154a:	97b6                	add	a5,a5,a3
    8000154c:	df87aa03          	lw	s4,-520(a5)
            p->swapped_pages[i] = p->swapped_pages[p->num_swappped_pages - 1];
    80001550:	367d                	addiw	a2,a2,-1 # 88fff <_entry-0x7ff77001>
    80001552:	6725                	lui	a4,0x9
    80001554:	8df70713          	addi	a4,a4,-1825 # 88df <_entry-0x7fff7721>
    80001558:	9732                	add	a4,a4,a2
    8000155a:	0712                	slli	a4,a4,0x4
    8000155c:	9726                	add	a4,a4,s1
    8000155e:	630c                	ld	a1,0(a4)
    80001560:	deb7b823          	sd	a1,-528(a5)
    80001564:	6718                	ld	a4,8(a4)
    80001566:	dee7bc23          	sd	a4,-520(a5)
            p->num_swappped_pages--;
    8000156a:	96a6                	add	a3,a3,s1
    8000156c:	1cc6a623          	sw	a2,460(a3) # 891cc <_entry-0x7ff76e34>
            p->swap_slots[swap_slot] = 0; // Free the slot
    80001570:	002a1793          	slli	a5,s4,0x2
    80001574:	18078793          	addi	a5,a5,384
    80001578:	97a6                	add	a5,a5,s1
    8000157a:	0007a023          	sw	zero,0(a5)
    if(swap_slot != -1) {
    8000157e:	57fd                	li	a5,-1
    80001580:	d8fa0ce3          	beq	s4,a5,80001318 <handle_pgfault+0x68>
        printf("[pid %d] PAGEFAULT va=0x%lx access=%s cause=%s\n", p->pid, va, access_type, cause);
    80001584:	00007717          	auipc	a4,0x7
    80001588:	d0470713          	addi	a4,a4,-764 # 80008288 <etext+0x288>
    8000158c:	86ea                	mv	a3,s10
    8000158e:	864a                	mv	a2,s2
    80001590:	588c                	lw	a1,48(s1)
    80001592:	00007517          	auipc	a0,0x7
    80001596:	cfe50513          	addi	a0,a0,-770 # 80008290 <etext+0x290>
    8000159a:	f61fe0ef          	jal	800004fa <printf>
        printf("[pid %d] SWAPIN va=0x%lx slot=%d\n", p->pid, va, swap_slot);
    8000159e:	86d2                	mv	a3,s4
    800015a0:	864a                	mv	a2,s2
    800015a2:	588c                	lw	a1,48(s1)
    800015a4:	00007517          	auipc	a0,0x7
    800015a8:	d1c50513          	addi	a0,a0,-740 # 800082c0 <etext+0x2c0>
    800015ac:	f4ffe0ef          	jal	800004fa <printf>
        begin_op();
    800015b0:	138030ef          	jal	800046e8 <begin_op>
        ilock(p->swap_file->ip);
    800015b4:	1784b783          	ld	a5,376(s1)
    800015b8:	6f88                	ld	a0,24(a5)
    800015ba:	722020ef          	jal	80003cdc <ilock>
        if(readi(p->swap_file->ip, 0, (uint64)mem, swap_slot * PGSIZE, PGSIZE) != PGSIZE){
    800015be:	1784b783          	ld	a5,376(s1)
    800015c2:	6705                	lui	a4,0x1
    800015c4:	00ca169b          	slliw	a3,s4,0xc
    800015c8:	864e                	mv	a2,s3
    800015ca:	4581                	li	a1,0
    800015cc:	6f88                	ld	a0,24(a5)
    800015ce:	2a1020ef          	jal	8000406e <readi>
    800015d2:	6785                	lui	a5,0x1
    800015d4:	02f51b63          	bne	a0,a5,8000160a <handle_pgfault+0x35a>
        iunlock(p->swap_file->ip);
    800015d8:	1784b783          	ld	a5,376(s1)
    800015dc:	6f88                	ld	a0,24(a5)
    800015de:	7ac020ef          	jal	80003d8a <iunlock>
        end_op();
    800015e2:	176030ef          	jal	80004758 <end_op>
        if(mappages(pagetable, va, PGSIZE, (uint64)mem, PTE_U|PTE_R) != 0) {
    800015e6:	4749                	li	a4,18
    800015e8:	86ce                	mv	a3,s3
    800015ea:	6605                	lui	a2,0x1
    800015ec:	85ca                	mv	a1,s2
    800015ee:	8566                	mv	a0,s9
    800015f0:	a71ff0ef          	jal	80001060 <mappages>
        is_swapped =1;
    800015f4:	4a05                	li	s4,1
        if(mappages(pagetable, va, PGSIZE, (uint64)mem, PTE_U|PTE_R) != 0) {
    800015f6:	16050163          	beqz	a0,80001758 <handle_pgfault+0x4a8>
            kfree(mem); return -1;
    800015fa:	854e                	mv	a0,s3
    800015fc:	c60ff0ef          	jal	80000a5c <kfree>
    80001600:	557d                	li	a0,-1
    80001602:	64ae                	ld	s1,200(sp)
    80001604:	79ea                	ld	s3,184(sp)
    80001606:	7a4a                	ld	s4,176(sp)
    80001608:	a265                	j	800017b0 <handle_pgfault+0x500>
    8000160a:	f556                	sd	s5,168(sp)
    8000160c:	f15a                	sd	s6,160(sp)
    8000160e:	ed5e                	sd	s7,152(sp)
    80001610:	e962                	sd	s8,144(sp)
            iunlock(p->swap_file->ip);
    80001612:	1784b783          	ld	a5,376(s1)
    80001616:	6f88                	ld	a0,24(a5)
    80001618:	772020ef          	jal	80003d8a <iunlock>
            end_op();
    8000161c:	13c030ef          	jal	80004758 <end_op>
            panic("swap_read_page failed");
    80001620:	00007517          	auipc	a0,0x7
    80001624:	cc850513          	addi	a0,a0,-824 # 800082e8 <etext+0x2e8>
    80001628:	9fcff0ef          	jal	80000824 <panic>
        for(int i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)) {
    8000162c:	2a05                	addiw	s4,s4,1
    8000162e:	038a869b          	addiw	a3,s5,56
    80001632:	f9845783          	lhu	a5,-104(s0)
    80001636:	0cfa5463          	bge	s4,a5,800016fe <handle_pgfault+0x44e>
            readi(p->exec_ip, 0, (uint64)&ph, off, sizeof(ph));
    8000163a:	8ab6                	mv	s5,a3
    8000163c:	875e                	mv	a4,s7
    8000163e:	8662                	mv	a2,s8
    80001640:	4581                	li	a1,0
    80001642:	1704b503          	ld	a0,368(s1)
    80001646:	229020ef          	jal	8000406e <readi>
            if(ph.type == ELF_PROG_LOAD && (va >= ph.vaddr && va < ph.vaddr + ph.memsz)) {
    8000164a:	f2842783          	lw	a5,-216(s0)
    8000164e:	fd679fe3          	bne	a5,s6,8000162c <handle_pgfault+0x37c>
    80001652:	f3843783          	ld	a5,-200(s0)
    80001656:	fcf96be3          	bltu	s2,a5,8000162c <handle_pgfault+0x37c>
    8000165a:	f5043703          	ld	a4,-176(s0)
    8000165e:	973e                	add	a4,a4,a5
    80001660:	fce976e3          	bgeu	s2,a4,8000162c <handle_pgfault+0x37c>
                file_offset = ph.off + (va - ph.vaddr);
    80001664:	0009069b          	sext.w	a3,s2
    80001668:	0007861b          	sext.w	a2,a5
    8000166c:	f3043a83          	ld	s5,-208(s0)
    80001670:	40fa8abb          	subw	s5,s5,a5
    80001674:	012a8abb          	addw	s5,s5,s2
                file_size_to_read = ph.filesz > (va - ph.vaddr) ? ph.filesz - (va - ph.vaddr) : 0;
    80001678:	f4843703          	ld	a4,-184(s0)
    8000167c:	40f907b3          	sub	a5,s2,a5
    80001680:	4b01                	li	s6,0
    80001682:	00e7fb63          	bgeu	a5,a4,80001698 <handle_pgfault+0x3e8>
    80001686:	00c707bb          	addw	a5,a4,a2
    8000168a:	9f95                	subw	a5,a5,a3
    8000168c:	8b3e                	mv	s6,a5
                if(file_size_to_read > PGSIZE) file_size_to_read = PGSIZE;
    8000168e:	6705                	lui	a4,0x1
    80001690:	00f77363          	bgeu	a4,a5,80001696 <handle_pgfault+0x3e6>
    80001694:	6b05                	lui	s6,0x1
    80001696:	2b01                	sext.w	s6,s6
                perm_flags = flags2perm(ph.flags) | PTE_U;
    80001698:	f2c42503          	lw	a0,-212(s0)
    8000169c:	30d030ef          	jal	800051a8 <flags2perm>
    800016a0:	8a2a                	mv	s4,a0
            printf("[pid %d] PAGEFAULT va=0x%lx access=%s cause=%s\n", p->pid, va, access_type, cause);
    800016a2:	00007717          	auipc	a4,0x7
    800016a6:	c5e70713          	addi	a4,a4,-930 # 80008300 <etext+0x300>
    800016aa:	86ea                	mv	a3,s10
    800016ac:	864a                	mv	a2,s2
    800016ae:	588c                	lw	a1,48(s1)
    800016b0:	00007517          	auipc	a0,0x7
    800016b4:	be050513          	addi	a0,a0,-1056 # 80008290 <etext+0x290>
    800016b8:	e43fe0ef          	jal	800004fa <printf>
            printf("[pid %d] LOADEXEC va=0x%lx\n", p->pid, va);
    800016bc:	864a                	mv	a2,s2
    800016be:	588c                	lw	a1,48(s1)
    800016c0:	00007517          	auipc	a0,0x7
    800016c4:	c4850513          	addi	a0,a0,-952 # 80008308 <etext+0x308>
    800016c8:	e33fe0ef          	jal	800004fa <printf>
            if(readi(p->exec_ip, 0, (uint64)mem, file_offset, file_size_to_read) != file_size_to_read) {
    800016cc:	875a                	mv	a4,s6
    800016ce:	86d6                	mv	a3,s5
    800016d0:	864e                	mv	a2,s3
    800016d2:	4581                	li	a1,0
    800016d4:	1704b503          	ld	a0,368(s1)
    800016d8:	197020ef          	jal	8000406e <readi>
    800016dc:	0f651163          	bne	a0,s6,800017be <handle_pgfault+0x50e>
                perm_flags = flags2perm(ph.flags) | PTE_U;
    800016e0:	010a6713          	ori	a4,s4,16
            if(mappages(pagetable, va, PGSIZE, (uint64)mem, perm_flags) != 0) {
    800016e4:	2701                	sext.w	a4,a4
    800016e6:	86ce                	mv	a3,s3
    800016e8:	6605                	lui	a2,0x1
    800016ea:	85ca                	mv	a1,s2
    800016ec:	8566                	mv	a0,s9
    800016ee:	973ff0ef          	jal	80001060 <mappages>
    800016f2:	ed71                	bnez	a0,800017ce <handle_pgfault+0x51e>
    800016f4:	7aaa                	ld	s5,168(sp)
    800016f6:	7b0a                	ld	s6,160(sp)
    800016f8:	6bea                	ld	s7,152(sp)
    800016fa:	6c4a                	ld	s8,144(sp)
    800016fc:	a8a9                	j	80001756 <handle_pgfault+0x4a6>
    800016fe:	7aaa                	ld	s5,168(sp)
    80001700:	7b0a                	ld	s6,160(sp)
    80001702:	6bea                	ld	s7,152(sp)
    80001704:	6c4a                	ld	s8,144(sp)
        } else if (va < p->sz) {
    80001706:	64bc                	ld	a5,72(s1)
    80001708:	0cf96b63          	bltu	s2,a5,800017de <handle_pgfault+0x52e>
        } else if(va >= p->trapframe->sp - PGSIZE && va < MAXVA) {
    8000170c:	6cbc                	ld	a5,88(s1)
    8000170e:	7b9c                	ld	a5,48(a5)
    80001710:	80078793          	addi	a5,a5,-2048 # 800 <_entry-0x7ffff800>
    80001714:	80078793          	addi	a5,a5,-2048
    80001718:	10f96863          	bltu	s2,a5,80001828 <handle_pgfault+0x578>
            printf("[pid %d] PAGEFAULT va=0x%lx access=%s cause=%s\n", p->pid, va, access_type, cause);
    8000171c:	00007717          	auipc	a4,0x7
    80001720:	c3470713          	addi	a4,a4,-972 # 80008350 <etext+0x350>
    80001724:	86ea                	mv	a3,s10
    80001726:	864a                	mv	a2,s2
    80001728:	588c                	lw	a1,48(s1)
    8000172a:	00007517          	auipc	a0,0x7
    8000172e:	b6650513          	addi	a0,a0,-1178 # 80008290 <etext+0x290>
    80001732:	dc9fe0ef          	jal	800004fa <printf>
            printf("[pid %d] ALLOC va=0x%lx\n", p->pid, va);
    80001736:	864a                	mv	a2,s2
    80001738:	588c                	lw	a1,48(s1)
    8000173a:	00007517          	auipc	a0,0x7
    8000173e:	bf650513          	addi	a0,a0,-1034 # 80008330 <etext+0x330>
    80001742:	db9fe0ef          	jal	800004fa <printf>
            if(mappages(pagetable, va, PGSIZE, (uint64)mem, PTE_U|PTE_R) != 0) {
    80001746:	4749                	li	a4,18
    80001748:	86ce                	mv	a3,s3
    8000174a:	6605                	lui	a2,0x1
    8000174c:	85ca                	mv	a1,s2
    8000174e:	8566                	mv	a0,s9
    80001750:	911ff0ef          	jal	80001060 <mappages>
    80001754:	e571                	bnez	a0,80001820 <handle_pgfault+0x570>
    int is_swapped=0;
    80001756:	4a01                	li	s4,0
    if(p->num_resident >= MAX_RESIDENT_PAGES){
    80001758:	000897b7          	lui	a5,0x89
    8000175c:	97a6                	add	a5,a5,s1
    8000175e:	1b07a703          	lw	a4,432(a5) # 891b0 <_entry-0x7ff76e50>
    80001762:	67a5                	lui	a5,0x9
    80001764:	8b778793          	addi	a5,a5,-1865 # 88b7 <_entry-0x7fff7749>
    80001768:	0ce7c863          	blt	a5,a4,80001838 <handle_pgfault+0x588>
    int i = p->num_resident;
    8000176c:	000897b7          	lui	a5,0x89
    80001770:	97a6                	add	a5,a5,s1
    80001772:	1b07a603          	lw	a2,432(a5) # 891b0 <_entry-0x7ff76e50>
    p->resident_pages[i].va = va;
    80001776:	00461713          	slli	a4,a2,0x4
    8000177a:	9726                	add	a4,a4,s1
    8000177c:	27273823          	sd	s2,624(a4)
    p->resident_pages[i].seq = ++p->next_fifo_seq;
    80001780:	1c87a683          	lw	a3,456(a5)
    80001784:	2685                	addiw	a3,a3,1
    80001786:	1cd7a423          	sw	a3,456(a5)
    8000178a:	26d72c23          	sw	a3,632(a4)
    p->resident_pages[i].dirty = swapped;
    8000178e:	27472e23          	sw	s4,636(a4)
    p->num_resident++;
    80001792:	2605                	addiw	a2,a2,1 # 1001 <_entry-0x7fffefff>
    80001794:	1ac7a823          	sw	a2,432(a5)
    printf("[pid %d] RESIDENT va=0x%lx seq=%d\n", p->pid, va, p->next_fifo_seq);
    80001798:	864a                	mv	a2,s2
    8000179a:	588c                	lw	a1,48(s1)
    8000179c:	00007517          	auipc	a0,0x7
    800017a0:	bdc50513          	addi	a0,a0,-1060 # 80008378 <etext+0x378>
    800017a4:	d57fe0ef          	jal	800004fa <printf>
    return 0; // Success
    800017a8:	4501                	li	a0,0
}
    800017aa:	64ae                	ld	s1,200(sp)
    800017ac:	79ea                	ld	s3,184(sp)
    800017ae:	7a4a                	ld	s4,176(sp)
}
    800017b0:	60ee                	ld	ra,216(sp)
    800017b2:	644e                	ld	s0,208(sp)
    800017b4:	690e                	ld	s2,192(sp)
    800017b6:	6caa                	ld	s9,136(sp)
    800017b8:	6d0a                	ld	s10,128(sp)
    800017ba:	612d                	addi	sp,sp,224
    800017bc:	8082                	ret
                kfree(mem); return -1;
    800017be:	854e                	mv	a0,s3
    800017c0:	a9cff0ef          	jal	80000a5c <kfree>
    800017c4:	7aaa                	ld	s5,168(sp)
    800017c6:	7b0a                	ld	s6,160(sp)
    800017c8:	6bea                	ld	s7,152(sp)
    800017ca:	6c4a                	ld	s8,144(sp)
    800017cc:	a08d                	j	8000182e <handle_pgfault+0x57e>
                kfree(mem); return -1;
    800017ce:	854e                	mv	a0,s3
    800017d0:	a8cff0ef          	jal	80000a5c <kfree>
    800017d4:	7aaa                	ld	s5,168(sp)
    800017d6:	7b0a                	ld	s6,160(sp)
    800017d8:	6bea                	ld	s7,152(sp)
    800017da:	6c4a                	ld	s8,144(sp)
    800017dc:	a889                	j	8000182e <handle_pgfault+0x57e>
            printf("[pid %d] PAGEFAULT va=0x%lx access=%s cause=%s\n", p->pid, va, access_type, cause);
    800017de:	00007717          	auipc	a4,0x7
    800017e2:	b4a70713          	addi	a4,a4,-1206 # 80008328 <etext+0x328>
    800017e6:	86ea                	mv	a3,s10
    800017e8:	864a                	mv	a2,s2
    800017ea:	588c                	lw	a1,48(s1)
    800017ec:	00007517          	auipc	a0,0x7
    800017f0:	aa450513          	addi	a0,a0,-1372 # 80008290 <etext+0x290>
    800017f4:	d07fe0ef          	jal	800004fa <printf>
            printf("[pid %d] ALLOC va=0x%lx\n", p->pid, va);
    800017f8:	864a                	mv	a2,s2
    800017fa:	588c                	lw	a1,48(s1)
    800017fc:	00007517          	auipc	a0,0x7
    80001800:	b3450513          	addi	a0,a0,-1228 # 80008330 <etext+0x330>
    80001804:	cf7fe0ef          	jal	800004fa <printf>
            if(mappages(pagetable, va, PGSIZE, (uint64)mem, PTE_U|PTE_R) != 0) {
    80001808:	4749                	li	a4,18
    8000180a:	86ce                	mv	a3,s3
    8000180c:	6605                	lui	a2,0x1
    8000180e:	85ca                	mv	a1,s2
    80001810:	8566                	mv	a0,s9
    80001812:	84fff0ef          	jal	80001060 <mappages>
    80001816:	d121                	beqz	a0,80001756 <handle_pgfault+0x4a6>
                kfree(mem); return -1;
    80001818:	854e                	mv	a0,s3
    8000181a:	a42ff0ef          	jal	80000a5c <kfree>
    8000181e:	a801                	j	8000182e <handle_pgfault+0x57e>
                kfree(mem); return -1;
    80001820:	854e                	mv	a0,s3
    80001822:	a3aff0ef          	jal	80000a5c <kfree>
    80001826:	a021                	j	8000182e <handle_pgfault+0x57e>
            kfree(mem);
    80001828:	854e                	mv	a0,s3
    8000182a:	a32ff0ef          	jal	80000a5c <kfree>
            return -1;
    8000182e:	557d                	li	a0,-1
    80001830:	64ae                	ld	s1,200(sp)
    80001832:	79ea                	ld	s3,184(sp)
    80001834:	7a4a                	ld	s4,176(sp)
    80001836:	bfad                	j	800017b0 <handle_pgfault+0x500>
        printf("[pid %d]Resident set full\n",p->pid);
    80001838:	588c                	lw	a1,48(s1)
    8000183a:	00007517          	auipc	a0,0x7
    8000183e:	b1e50513          	addi	a0,a0,-1250 # 80008358 <etext+0x358>
    80001842:	cb9fe0ef          	jal	800004fa <printf>
        kexit(-1);
    80001846:	557d                	li	a0,-1
    80001848:	7b3000ef          	jal	800027fa <kexit>
    8000184c:	b705                	j	8000176c <handle_pgfault+0x4bc>
        return -1;
    8000184e:	557d                	li	a0,-1
    80001850:	b785                	j	800017b0 <handle_pgfault+0x500>

0000000080001852 <uvmdealloc>:
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
    uint64
uvmdealloc(pagetable_t pagetable, uint64 oldsz, uint64 newsz)
{
    80001852:	1101                	addi	sp,sp,-32
    80001854:	ec06                	sd	ra,24(sp)
    80001856:	e822                	sd	s0,16(sp)
    80001858:	e426                	sd	s1,8(sp)
    8000185a:	1000                	addi	s0,sp,32
    if(newsz >= oldsz)
        return oldsz;
    8000185c:	84ae                	mv	s1,a1
    if(newsz >= oldsz)
    8000185e:	00b67d63          	bgeu	a2,a1,80001878 <uvmdealloc+0x26>
    80001862:	84b2                	mv	s1,a2

    if(PGROUNDUP(newsz) < PGROUNDUP(oldsz)){
    80001864:	6785                	lui	a5,0x1
    80001866:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    80001868:	00f60733          	add	a4,a2,a5
    8000186c:	76fd                	lui	a3,0xfffff
    8000186e:	8f75                	and	a4,a4,a3
    80001870:	97ae                	add	a5,a5,a1
    80001872:	8ff5                	and	a5,a5,a3
    80001874:	00f76863          	bltu	a4,a5,80001884 <uvmdealloc+0x32>
        int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
        uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
    }

    return newsz;
}
    80001878:	8526                	mv	a0,s1
    8000187a:	60e2                	ld	ra,24(sp)
    8000187c:	6442                	ld	s0,16(sp)
    8000187e:	64a2                	ld	s1,8(sp)
    80001880:	6105                	addi	sp,sp,32
    80001882:	8082                	ret
        int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    80001884:	8f99                	sub	a5,a5,a4
    80001886:	83b1                	srli	a5,a5,0xc
        uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
    80001888:	4685                	li	a3,1
    8000188a:	0007861b          	sext.w	a2,a5
    8000188e:	85ba                	mv	a1,a4
    80001890:	997ff0ef          	jal	80001226 <uvmunmap>
    80001894:	b7d5                	j	80001878 <uvmdealloc+0x26>

0000000080001896 <uvmalloc>:
    if(newsz < oldsz)
    80001896:	0ab66163          	bltu	a2,a1,80001938 <uvmalloc+0xa2>
{
    8000189a:	715d                	addi	sp,sp,-80
    8000189c:	e486                	sd	ra,72(sp)
    8000189e:	e0a2                	sd	s0,64(sp)
    800018a0:	f84a                	sd	s2,48(sp)
    800018a2:	f052                	sd	s4,32(sp)
    800018a4:	ec56                	sd	s5,24(sp)
    800018a6:	e45e                	sd	s7,8(sp)
    800018a8:	0880                	addi	s0,sp,80
    800018aa:	8aaa                	mv	s5,a0
    800018ac:	8a32                	mv	s4,a2
    oldsz = PGROUNDUP(oldsz);
    800018ae:	6785                	lui	a5,0x1
    800018b0:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    800018b2:	95be                	add	a1,a1,a5
    800018b4:	77fd                	lui	a5,0xfffff
    800018b6:	00f5f933          	and	s2,a1,a5
    800018ba:	8bca                	mv	s7,s2
    for(a = oldsz; a < newsz; a += PGSIZE){
    800018bc:	08c97063          	bgeu	s2,a2,8000193c <uvmalloc+0xa6>
    800018c0:	fc26                	sd	s1,56(sp)
    800018c2:	f44e                	sd	s3,40(sp)
    800018c4:	e85a                	sd	s6,16(sp)
        memset(mem, 0, PGSIZE);
    800018c6:	6985                	lui	s3,0x1
        if(mappages(pagetable, a, PGSIZE, (uint64)mem, PTE_R|PTE_U|xperm) != 0){
    800018c8:	0126eb13          	ori	s6,a3,18
        mem = kalloc();
    800018cc:	a78ff0ef          	jal	80000b44 <kalloc>
    800018d0:	84aa                	mv	s1,a0
        if(mem == 0){
    800018d2:	c50d                	beqz	a0,800018fc <uvmalloc+0x66>
        memset(mem, 0, PGSIZE);
    800018d4:	864e                	mv	a2,s3
    800018d6:	4581                	li	a1,0
    800018d8:	c20ff0ef          	jal	80000cf8 <memset>
        if(mappages(pagetable, a, PGSIZE, (uint64)mem, PTE_R|PTE_U|xperm) != 0){
    800018dc:	875a                	mv	a4,s6
    800018de:	86a6                	mv	a3,s1
    800018e0:	864e                	mv	a2,s3
    800018e2:	85ca                	mv	a1,s2
    800018e4:	8556                	mv	a0,s5
    800018e6:	f7aff0ef          	jal	80001060 <mappages>
    800018ea:	e915                	bnez	a0,8000191e <uvmalloc+0x88>
    for(a = oldsz; a < newsz; a += PGSIZE){
    800018ec:	994e                	add	s2,s2,s3
    800018ee:	fd496fe3          	bltu	s2,s4,800018cc <uvmalloc+0x36>
    return newsz;
    800018f2:	8552                	mv	a0,s4
    800018f4:	74e2                	ld	s1,56(sp)
    800018f6:	79a2                	ld	s3,40(sp)
    800018f8:	6b42                	ld	s6,16(sp)
    800018fa:	a811                	j	8000190e <uvmalloc+0x78>
            uvmdealloc(pagetable, a, oldsz);
    800018fc:	865e                	mv	a2,s7
    800018fe:	85ca                	mv	a1,s2
    80001900:	8556                	mv	a0,s5
    80001902:	f51ff0ef          	jal	80001852 <uvmdealloc>
            return 0;
    80001906:	4501                	li	a0,0
    80001908:	74e2                	ld	s1,56(sp)
    8000190a:	79a2                	ld	s3,40(sp)
    8000190c:	6b42                	ld	s6,16(sp)
}
    8000190e:	60a6                	ld	ra,72(sp)
    80001910:	6406                	ld	s0,64(sp)
    80001912:	7942                	ld	s2,48(sp)
    80001914:	7a02                	ld	s4,32(sp)
    80001916:	6ae2                	ld	s5,24(sp)
    80001918:	6ba2                	ld	s7,8(sp)
    8000191a:	6161                	addi	sp,sp,80
    8000191c:	8082                	ret
            kfree(mem);
    8000191e:	8526                	mv	a0,s1
    80001920:	93cff0ef          	jal	80000a5c <kfree>
            uvmdealloc(pagetable, a, oldsz);
    80001924:	865e                	mv	a2,s7
    80001926:	85ca                	mv	a1,s2
    80001928:	8556                	mv	a0,s5
    8000192a:	f29ff0ef          	jal	80001852 <uvmdealloc>
            return 0;
    8000192e:	4501                	li	a0,0
    80001930:	74e2                	ld	s1,56(sp)
    80001932:	79a2                	ld	s3,40(sp)
    80001934:	6b42                	ld	s6,16(sp)
    80001936:	bfe1                	j	8000190e <uvmalloc+0x78>
        return oldsz;
    80001938:	852e                	mv	a0,a1
}
    8000193a:	8082                	ret
    return newsz;
    8000193c:	8532                	mv	a0,a2
    8000193e:	bfc1                	j	8000190e <uvmalloc+0x78>

0000000080001940 <freewalk>:

// Recursively free page-table pages.
// All leaf mappings must already have been removed.
    void
freewalk(pagetable_t pagetable)
{
    80001940:	7179                	addi	sp,sp,-48
    80001942:	f406                	sd	ra,40(sp)
    80001944:	f022                	sd	s0,32(sp)
    80001946:	ec26                	sd	s1,24(sp)
    80001948:	e84a                	sd	s2,16(sp)
    8000194a:	e44e                	sd	s3,8(sp)
    8000194c:	e052                	sd	s4,0(sp)
    8000194e:	1800                	addi	s0,sp,48
    80001950:	8a2a                	mv	s4,a0
    // there are 2^9 = 512 PTEs in a page table.
    for(int i = 0; i < 512; i++){
    80001952:	84aa                	mv	s1,a0
    80001954:	6905                	lui	s2,0x1
    80001956:	992a                	add	s2,s2,a0
        pte_t pte = pagetable[i];
        if((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0){
    80001958:	4985                	li	s3,1
    8000195a:	a021                	j	80001962 <freewalk+0x22>
    for(int i = 0; i < 512; i++){
    8000195c:	04a1                	addi	s1,s1,8
    8000195e:	01248f63          	beq	s1,s2,8000197c <freewalk+0x3c>
        pte_t pte = pagetable[i];
    80001962:	609c                	ld	a5,0(s1)
        if((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0){
    80001964:	00f7f713          	andi	a4,a5,15
    80001968:	ff371ae3          	bne	a4,s3,8000195c <freewalk+0x1c>
            // this PTE points to a lower-level page table.
            uint64 child = PTE2PA(pte);
    8000196c:	83a9                	srli	a5,a5,0xa
            freewalk((pagetable_t)child);
    8000196e:	00c79513          	slli	a0,a5,0xc
    80001972:	fcfff0ef          	jal	80001940 <freewalk>
            pagetable[i] = 0;
    80001976:	0004b023          	sd	zero,0(s1)
    8000197a:	b7cd                	j	8000195c <freewalk+0x1c>
        } else if(pte & PTE_V){
        }
    }
    kfree((void*)pagetable);
    8000197c:	8552                	mv	a0,s4
    8000197e:	8deff0ef          	jal	80000a5c <kfree>
}
    80001982:	70a2                	ld	ra,40(sp)
    80001984:	7402                	ld	s0,32(sp)
    80001986:	64e2                	ld	s1,24(sp)
    80001988:	6942                	ld	s2,16(sp)
    8000198a:	69a2                	ld	s3,8(sp)
    8000198c:	6a02                	ld	s4,0(sp)
    8000198e:	6145                	addi	sp,sp,48
    80001990:	8082                	ret

0000000080001992 <uvmfree>:

// Free user memory pages,
// then free page-table pages.
    void
uvmfree(pagetable_t pagetable, uint64 sz)
{
    80001992:	1101                	addi	sp,sp,-32
    80001994:	ec06                	sd	ra,24(sp)
    80001996:	e822                	sd	s0,16(sp)
    80001998:	e426                	sd	s1,8(sp)
    8000199a:	1000                	addi	s0,sp,32
    8000199c:	84aa                	mv	s1,a0
    if(sz > 0)
    8000199e:	e989                	bnez	a1,800019b0 <uvmfree+0x1e>
        uvmunmap(pagetable, 0, PGROUNDUP(sz)/PGSIZE, 1);
    freewalk(pagetable);
    800019a0:	8526                	mv	a0,s1
    800019a2:	f9fff0ef          	jal	80001940 <freewalk>
}
    800019a6:	60e2                	ld	ra,24(sp)
    800019a8:	6442                	ld	s0,16(sp)
    800019aa:	64a2                	ld	s1,8(sp)
    800019ac:	6105                	addi	sp,sp,32
    800019ae:	8082                	ret
        uvmunmap(pagetable, 0, PGROUNDUP(sz)/PGSIZE, 1);
    800019b0:	6785                	lui	a5,0x1
    800019b2:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    800019b4:	95be                	add	a1,a1,a5
    800019b6:	4685                	li	a3,1
    800019b8:	00c5d613          	srli	a2,a1,0xc
    800019bc:	4581                	li	a1,0
    800019be:	869ff0ef          	jal	80001226 <uvmunmap>
    800019c2:	bff9                	j	800019a0 <uvmfree+0xe>

00000000800019c4 <uvmcopy>:
{
    pte_t *pte;
    uint64 pa, i;
    uint flags;
    char *mem;
    for(i = 0; i < sz; i += PGSIZE){
    800019c4:	ca59                	beqz	a2,80001a5a <uvmcopy+0x96>
{
    800019c6:	715d                	addi	sp,sp,-80
    800019c8:	e486                	sd	ra,72(sp)
    800019ca:	e0a2                	sd	s0,64(sp)
    800019cc:	fc26                	sd	s1,56(sp)
    800019ce:	f84a                	sd	s2,48(sp)
    800019d0:	f44e                	sd	s3,40(sp)
    800019d2:	f052                	sd	s4,32(sp)
    800019d4:	ec56                	sd	s5,24(sp)
    800019d6:	e85a                	sd	s6,16(sp)
    800019d8:	e45e                	sd	s7,8(sp)
    800019da:	0880                	addi	s0,sp,80
    800019dc:	8b2a                	mv	s6,a0
    800019de:	8bae                	mv	s7,a1
    800019e0:	8ab2                	mv	s5,a2
    for(i = 0; i < sz; i += PGSIZE){
    800019e2:	4481                	li	s1,0
        }
        pa = PTE2PA(*pte);
        flags = PTE_FLAGS(*pte);
        if((mem = kalloc()) == 0)
            goto err;
        memmove(mem, (char*)pa, PGSIZE);
    800019e4:	6a05                	lui	s4,0x1
    800019e6:	a021                	j	800019ee <uvmcopy+0x2a>
    for(i = 0; i < sz; i += PGSIZE){
    800019e8:	94d2                	add	s1,s1,s4
    800019ea:	0554fc63          	bgeu	s1,s5,80001a42 <uvmcopy+0x7e>
        if((pte = walk(old, i, 0)) == 0)
    800019ee:	4601                	li	a2,0
    800019f0:	85a6                	mv	a1,s1
    800019f2:	855a                	mv	a0,s6
    800019f4:	d98ff0ef          	jal	80000f8c <walk>
    800019f8:	d965                	beqz	a0,800019e8 <uvmcopy+0x24>
        if((*pte & PTE_V) == 0){
    800019fa:	00053983          	ld	s3,0(a0)
    800019fe:	0019f793          	andi	a5,s3,1
    80001a02:	d3fd                	beqz	a5,800019e8 <uvmcopy+0x24>
        if((mem = kalloc()) == 0)
    80001a04:	940ff0ef          	jal	80000b44 <kalloc>
    80001a08:	892a                	mv	s2,a0
    80001a0a:	c11d                	beqz	a0,80001a30 <uvmcopy+0x6c>
        pa = PTE2PA(*pte);
    80001a0c:	00a9d593          	srli	a1,s3,0xa
        memmove(mem, (char*)pa, PGSIZE);
    80001a10:	8652                	mv	a2,s4
    80001a12:	05b2                	slli	a1,a1,0xc
    80001a14:	b44ff0ef          	jal	80000d58 <memmove>
        if(mappages(new, i, PGSIZE, (uint64)mem, flags) != 0){
    80001a18:	3ff9f713          	andi	a4,s3,1023
    80001a1c:	86ca                	mv	a3,s2
    80001a1e:	8652                	mv	a2,s4
    80001a20:	85a6                	mv	a1,s1
    80001a22:	855e                	mv	a0,s7
    80001a24:	e3cff0ef          	jal	80001060 <mappages>
    80001a28:	d161                	beqz	a0,800019e8 <uvmcopy+0x24>
            kfree(mem);
    80001a2a:	854a                	mv	a0,s2
    80001a2c:	830ff0ef          	jal	80000a5c <kfree>
        }
    }
    return 0;

err:
    uvmunmap(new, 0, i / PGSIZE, 1);
    80001a30:	4685                	li	a3,1
    80001a32:	00c4d613          	srli	a2,s1,0xc
    80001a36:	4581                	li	a1,0
    80001a38:	855e                	mv	a0,s7
    80001a3a:	fecff0ef          	jal	80001226 <uvmunmap>
    return -1;
    80001a3e:	557d                	li	a0,-1
    80001a40:	a011                	j	80001a44 <uvmcopy+0x80>
    return 0;
    80001a42:	4501                	li	a0,0
}
    80001a44:	60a6                	ld	ra,72(sp)
    80001a46:	6406                	ld	s0,64(sp)
    80001a48:	74e2                	ld	s1,56(sp)
    80001a4a:	7942                	ld	s2,48(sp)
    80001a4c:	79a2                	ld	s3,40(sp)
    80001a4e:	7a02                	ld	s4,32(sp)
    80001a50:	6ae2                	ld	s5,24(sp)
    80001a52:	6b42                	ld	s6,16(sp)
    80001a54:	6ba2                	ld	s7,8(sp)
    80001a56:	6161                	addi	sp,sp,80
    80001a58:	8082                	ret
    return 0;
    80001a5a:	4501                	li	a0,0
}
    80001a5c:	8082                	ret

0000000080001a5e <uvmclear>:
*/
// mark a PTE invalid for user access.
// used by exec for the user stack guard page.
    void
uvmclear(pagetable_t pagetable, uint64 va)
{
    80001a5e:	1141                	addi	sp,sp,-16
    80001a60:	e406                	sd	ra,8(sp)
    80001a62:	e022                	sd	s0,0(sp)
    80001a64:	0800                	addi	s0,sp,16
    pte_t *pte;

    pte = walk(pagetable, va, 0);
    80001a66:	4601                	li	a2,0
    80001a68:	d24ff0ef          	jal	80000f8c <walk>
    if(pte == 0)
    80001a6c:	c901                	beqz	a0,80001a7c <uvmclear+0x1e>
        panic("uvmclear");
    *pte &= ~PTE_U;
    80001a6e:	611c                	ld	a5,0(a0)
    80001a70:	9bbd                	andi	a5,a5,-17
    80001a72:	e11c                	sd	a5,0(a0)
}
    80001a74:	60a2                	ld	ra,8(sp)
    80001a76:	6402                	ld	s0,0(sp)
    80001a78:	0141                	addi	sp,sp,16
    80001a7a:	8082                	ret
        panic("uvmclear");
    80001a7c:	00007517          	auipc	a0,0x7
    80001a80:	92450513          	addi	a0,a0,-1756 # 800083a0 <etext+0x3a0>
    80001a84:	da1fe0ef          	jal	80000824 <panic>

0000000080001a88 <copyout>:
// Copy from kernel to user.
// Copy len bytes from src to virtual address dstva in a given page table.
// Return 0 on success, -1 on error.
    int
copyout(pagetable_t pagetable, uint64 dstva, char *src, uint64 len)
{
    80001a88:	7159                	addi	sp,sp,-112
    80001a8a:	f486                	sd	ra,104(sp)
    80001a8c:	f0a2                	sd	s0,96(sp)
    80001a8e:	e0d2                	sd	s4,64(sp)
    80001a90:	fc56                	sd	s5,56(sp)
    80001a92:	f85a                	sd	s6,48(sp)
    80001a94:	f45e                	sd	s7,40(sp)
    80001a96:	e46e                	sd	s11,8(sp)
    80001a98:	1880                	addi	s0,sp,112
    80001a9a:	8b2a                	mv	s6,a0
    80001a9c:	8a2e                	mv	s4,a1
    80001a9e:	8bb2                	mv	s7,a2
    80001aa0:	8ab6                	mv	s5,a3
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001aa2:	14202773          	csrr	a4,scause
    const char* access_type;
    if (r_scause() == 12) { access_type = "exec"; }
    80001aa6:	47b1                	li	a5,12
    80001aa8:	00007d97          	auipc	s11,0x7
    80001aac:	858d8d93          	addi	s11,s11,-1960 # 80008300 <etext+0x300>
    80001ab0:	00f70b63          	beq	a4,a5,80001ac6 <copyout+0x3e>
    80001ab4:	14202773          	csrr	a4,scause
    else if (r_scause() == 13) { access_type = "read"; }
    80001ab8:	47b5                	li	a5,13
    else { access_type = "write"; }
    80001aba:	00007d97          	auipc	s11,0x7
    80001abe:	8f6d8d93          	addi	s11,s11,-1802 # 800083b0 <etext+0x3b0>
    else if (r_scause() == 13) { access_type = "read"; }
    80001ac2:	02f70063          	beq	a4,a5,80001ae2 <copyout+0x5a>
    pte_t *pte;

    uint64 n, va0, pa0;
    while(len > 0){
    80001ac6:	100a8063          	beqz	s5,80001bc6 <copyout+0x13e>
    80001aca:	eca6                	sd	s1,88(sp)
    80001acc:	e8ca                	sd	s2,80(sp)
    80001ace:	e4ce                	sd	s3,72(sp)
    80001ad0:	f062                	sd	s8,32(sp)
    80001ad2:	ec66                	sd	s9,24(sp)
    80001ad4:	e86a                	sd	s10,16(sp)
        va0 = PGROUNDDOWN(dstva);
    80001ad6:	7d7d                	lui	s10,0xfffff
        if(va0 >= MAXVA){
    80001ad8:	5cfd                	li	s9,-1
    80001ada:	01acdc93          	srli	s9,s9,0x1a
        }
        pte = walk(pagetable, va0, 0);
        // forbid copyout over read-only user text pages.
        if((*pte & PTE_W) == 0)
            return -1; 
        n = PGSIZE - (dstva - va0);
    80001ade:	6c05                	lui	s8,0x1
    80001ae0:	a079                	j	80001b6e <copyout+0xe6>
    else if (r_scause() == 13) { access_type = "read"; }
    80001ae2:	00007d97          	auipc	s11,0x7
    80001ae6:	ce6d8d93          	addi	s11,s11,-794 # 800087c8 <etext+0x7c8>
    80001aea:	bff1                	j	80001ac6 <copyout+0x3e>
            printf("over the limit\n");
    80001aec:	00007517          	auipc	a0,0x7
    80001af0:	8cc50513          	addi	a0,a0,-1844 # 800083b8 <etext+0x3b8>
    80001af4:	a07fe0ef          	jal	800004fa <printf>
            return -1;
    80001af8:	557d                	li	a0,-1
    80001afa:	64e6                	ld	s1,88(sp)
    80001afc:	6946                	ld	s2,80(sp)
    80001afe:	69a6                	ld	s3,72(sp)
    80001b00:	7c02                	ld	s8,32(sp)
    80001b02:	6ce2                	ld	s9,24(sp)
    80001b04:	6d42                	ld	s10,16(sp)
        len -= n;
        src += n;
        dstva = va0 + PGSIZE;
    }
    return 0;
}
    80001b06:	70a6                	ld	ra,104(sp)
    80001b08:	7406                	ld	s0,96(sp)
    80001b0a:	6a06                	ld	s4,64(sp)
    80001b0c:	7ae2                	ld	s5,56(sp)
    80001b0e:	7b42                	ld	s6,48(sp)
    80001b10:	7ba2                	ld	s7,40(sp)
    80001b12:	6da2                	ld	s11,8(sp)
    80001b14:	6165                	addi	sp,sp,112
    80001b16:	8082                	ret
                printf("handle_pgfault returned false\n");
    80001b18:	00007517          	auipc	a0,0x7
    80001b1c:	8b050513          	addi	a0,a0,-1872 # 800083c8 <etext+0x3c8>
    80001b20:	9dbfe0ef          	jal	800004fa <printf>
                return -1;
    80001b24:	557d                	li	a0,-1
    80001b26:	64e6                	ld	s1,88(sp)
    80001b28:	6946                	ld	s2,80(sp)
    80001b2a:	69a6                	ld	s3,72(sp)
    80001b2c:	7c02                	ld	s8,32(sp)
    80001b2e:	6ce2                	ld	s9,24(sp)
    80001b30:	6d42                	ld	s10,16(sp)
    80001b32:	bfd1                	j	80001b06 <copyout+0x7e>
        pte = walk(pagetable, va0, 0);
    80001b34:	4601                	li	a2,0
    80001b36:	85a6                	mv	a1,s1
    80001b38:	855a                	mv	a0,s6
    80001b3a:	c52ff0ef          	jal	80000f8c <walk>
        if((*pte & PTE_W) == 0)
    80001b3e:	611c                	ld	a5,0(a0)
    80001b40:	8b91                	andi	a5,a5,4
    80001b42:	c7c1                	beqz	a5,80001bca <copyout+0x142>
        n = PGSIZE - (dstva - va0);
    80001b44:	41448933          	sub	s2,s1,s4
    80001b48:	9962                	add	s2,s2,s8
        if(n > len)
    80001b4a:	012af363          	bgeu	s5,s2,80001b50 <copyout+0xc8>
    80001b4e:	8956                	mv	s2,s5
        memmove((void *)(pa0 + (dstva - va0)), src, n);
    80001b50:	409a0533          	sub	a0,s4,s1
    80001b54:	0009061b          	sext.w	a2,s2
    80001b58:	85de                	mv	a1,s7
    80001b5a:	954e                	add	a0,a0,s3
    80001b5c:	9fcff0ef          	jal	80000d58 <memmove>
        len -= n;
    80001b60:	412a8ab3          	sub	s5,s5,s2
        src += n;
    80001b64:	9bca                	add	s7,s7,s2
        dstva = va0 + PGSIZE;
    80001b66:	01848a33          	add	s4,s1,s8
    while(len > 0){
    80001b6a:	040a8663          	beqz	s5,80001bb6 <copyout+0x12e>
        va0 = PGROUNDDOWN(dstva);
    80001b6e:	01aa74b3          	and	s1,s4,s10
        if(va0 >= MAXVA){
    80001b72:	f69cede3          	bltu	s9,s1,80001aec <copyout+0x64>
        pa0 = walkaddr(pagetable, va0);
    80001b76:	85a6                	mv	a1,s1
    80001b78:	855a                	mv	a0,s6
    80001b7a:	cacff0ef          	jal	80001026 <walkaddr>
    80001b7e:	89aa                	mv	s3,a0
        if(pa0 == 0) {
    80001b80:	f955                	bnez	a0,80001b34 <copyout+0xac>
            if(handle_pgfault(pagetable, va0,access_type) != 0) {
    80001b82:	866e                	mv	a2,s11
    80001b84:	85a6                	mv	a1,s1
    80001b86:	855a                	mv	a0,s6
    80001b88:	f28ff0ef          	jal	800012b0 <handle_pgfault>
    80001b8c:	f551                	bnez	a0,80001b18 <copyout+0x90>
            pa0 = walkaddr(pagetable, va0); // Retry getting the address
    80001b8e:	85a6                	mv	a1,s1
    80001b90:	855a                	mv	a0,s6
    80001b92:	c94ff0ef          	jal	80001026 <walkaddr>
    80001b96:	89aa                	mv	s3,a0
            if(pa0 == 0){ 
    80001b98:	fd51                	bnez	a0,80001b34 <copyout+0xac>
                printf("got 0 again\n");
    80001b9a:	00007517          	auipc	a0,0x7
    80001b9e:	84e50513          	addi	a0,a0,-1970 # 800083e8 <etext+0x3e8>
    80001ba2:	959fe0ef          	jal	800004fa <printf>
                return -1;
    80001ba6:	557d                	li	a0,-1
    80001ba8:	64e6                	ld	s1,88(sp)
    80001baa:	6946                	ld	s2,80(sp)
    80001bac:	69a6                	ld	s3,72(sp)
    80001bae:	7c02                	ld	s8,32(sp)
    80001bb0:	6ce2                	ld	s9,24(sp)
    80001bb2:	6d42                	ld	s10,16(sp)
    80001bb4:	bf89                	j	80001b06 <copyout+0x7e>
    return 0;
    80001bb6:	4501                	li	a0,0
    80001bb8:	64e6                	ld	s1,88(sp)
    80001bba:	6946                	ld	s2,80(sp)
    80001bbc:	69a6                	ld	s3,72(sp)
    80001bbe:	7c02                	ld	s8,32(sp)
    80001bc0:	6ce2                	ld	s9,24(sp)
    80001bc2:	6d42                	ld	s10,16(sp)
    80001bc4:	b789                	j	80001b06 <copyout+0x7e>
    80001bc6:	4501                	li	a0,0
    80001bc8:	bf3d                	j	80001b06 <copyout+0x7e>
            return -1; 
    80001bca:	557d                	li	a0,-1
    80001bcc:	64e6                	ld	s1,88(sp)
    80001bce:	6946                	ld	s2,80(sp)
    80001bd0:	69a6                	ld	s3,72(sp)
    80001bd2:	7c02                	ld	s8,32(sp)
    80001bd4:	6ce2                	ld	s9,24(sp)
    80001bd6:	6d42                	ld	s10,16(sp)
    80001bd8:	b73d                	j	80001b06 <copyout+0x7e>

0000000080001bda <copyin>:
// Copy from user to kernel.
// Copy len bytes to dst from virtual address srcva in a given page table.
// Return 0 on success, -1 on error.
    int
copyin(pagetable_t pagetable, char *dst, uint64 srcva, uint64 len)
{
    80001bda:	711d                	addi	sp,sp,-96
    80001bdc:	ec86                	sd	ra,88(sp)
    80001bde:	e8a2                	sd	s0,80(sp)
    80001be0:	e0ca                	sd	s2,64(sp)
    80001be2:	f852                	sd	s4,48(sp)
    80001be4:	f456                	sd	s5,40(sp)
    80001be6:	f05a                	sd	s6,32(sp)
    80001be8:	ec5e                	sd	s7,24(sp)
    80001bea:	e862                	sd	s8,16(sp)
    80001bec:	e466                	sd	s9,8(sp)
    80001bee:	1080                	addi	s0,sp,96
    80001bf0:	8b2a                	mv	s6,a0
    80001bf2:	8aae                	mv	s5,a1
    80001bf4:	8932                	mv	s2,a2
    80001bf6:	8a36                	mv	s4,a3
    80001bf8:	14202773          	csrr	a4,scause
    const char* access_type;
    if (r_scause() == 12) { access_type = "exec"; }
    80001bfc:	47b1                	li	a5,12
    80001bfe:	00006c97          	auipc	s9,0x6
    80001c02:	702c8c93          	addi	s9,s9,1794 # 80008300 <etext+0x300>
    80001c06:	00f70b63          	beq	a4,a5,80001c1c <copyin+0x42>
    80001c0a:	14202773          	csrr	a4,scause
    else if (r_scause() == 13) { access_type = "read"; }
    80001c0e:	47b5                	li	a5,13
    else { access_type = "write"; }
    80001c10:	00006c97          	auipc	s9,0x6
    80001c14:	7a0c8c93          	addi	s9,s9,1952 # 800083b0 <etext+0x3b0>
    else if (r_scause() == 13) { access_type = "read"; }
    80001c18:	00f70a63          	beq	a4,a5,80001c2c <copyin+0x52>

    uint64 n, va0, pa0;

    while(len > 0){
        va0 = PGROUNDDOWN(srcva);
    80001c1c:	7c7d                	lui	s8,0xfffff
            pa0 = walkaddr(pagetable, va0); 
            if(pa0 == 0)
                return -1;
        }

        n = PGSIZE - (srcva - va0);
    80001c1e:	6b85                	lui	s7,0x1
        memmove(dst, (void *)(pa0 + (srcva - va0)), n);
        len -= n;
        dst += n;
        srcva = va0 + PGSIZE;
    }
    return 0;
    80001c20:	4501                	li	a0,0
    while(len > 0){
    80001c22:	060a0863          	beqz	s4,80001c92 <copyin+0xb8>
    80001c26:	e4a6                	sd	s1,72(sp)
    80001c28:	fc4e                	sd	s3,56(sp)
    80001c2a:	a81d                	j	80001c60 <copyin+0x86>
    else if (r_scause() == 13) { access_type = "read"; }
    80001c2c:	00007c97          	auipc	s9,0x7
    80001c30:	b9cc8c93          	addi	s9,s9,-1124 # 800087c8 <etext+0x7c8>
    80001c34:	b7e5                	j	80001c1c <copyin+0x42>
        n = PGSIZE - (srcva - va0);
    80001c36:	412984b3          	sub	s1,s3,s2
    80001c3a:	94de                	add	s1,s1,s7
        if(n > len)
    80001c3c:	009a7363          	bgeu	s4,s1,80001c42 <copyin+0x68>
    80001c40:	84d2                	mv	s1,s4
        memmove(dst, (void *)(pa0 + (srcva - va0)), n);
    80001c42:	413905b3          	sub	a1,s2,s3
    80001c46:	0004861b          	sext.w	a2,s1
    80001c4a:	95aa                	add	a1,a1,a0
    80001c4c:	8556                	mv	a0,s5
    80001c4e:	90aff0ef          	jal	80000d58 <memmove>
        len -= n;
    80001c52:	409a0a33          	sub	s4,s4,s1
        dst += n;
    80001c56:	9aa6                	add	s5,s5,s1
        srcva = va0 + PGSIZE;
    80001c58:	01798933          	add	s2,s3,s7
    while(len > 0){
    80001c5c:	020a0863          	beqz	s4,80001c8c <copyin+0xb2>
        va0 = PGROUNDDOWN(srcva);
    80001c60:	018979b3          	and	s3,s2,s8
        pa0 = walkaddr(pagetable, va0);
    80001c64:	85ce                	mv	a1,s3
    80001c66:	855a                	mv	a0,s6
    80001c68:	bbeff0ef          	jal	80001026 <walkaddr>
        if(pa0 == 0) { 
    80001c6c:	f569                	bnez	a0,80001c36 <copyin+0x5c>
            if(handle_pgfault(pagetable, va0,access_type) != 0) {
    80001c6e:	8666                	mv	a2,s9
    80001c70:	85ce                	mv	a1,s3
    80001c72:	855a                	mv	a0,s6
    80001c74:	e3cff0ef          	jal	800012b0 <handle_pgfault>
    80001c78:	e905                	bnez	a0,80001ca8 <copyin+0xce>
            pa0 = walkaddr(pagetable, va0); 
    80001c7a:	85ce                	mv	a1,s3
    80001c7c:	855a                	mv	a0,s6
    80001c7e:	ba8ff0ef          	jal	80001026 <walkaddr>
            if(pa0 == 0)
    80001c82:	f955                	bnez	a0,80001c36 <copyin+0x5c>
                return -1;
    80001c84:	557d                	li	a0,-1
    80001c86:	64a6                	ld	s1,72(sp)
    80001c88:	79e2                	ld	s3,56(sp)
    80001c8a:	a021                	j	80001c92 <copyin+0xb8>
    return 0;
    80001c8c:	4501                	li	a0,0
    80001c8e:	64a6                	ld	s1,72(sp)
    80001c90:	79e2                	ld	s3,56(sp)
}
    80001c92:	60e6                	ld	ra,88(sp)
    80001c94:	6446                	ld	s0,80(sp)
    80001c96:	6906                	ld	s2,64(sp)
    80001c98:	7a42                	ld	s4,48(sp)
    80001c9a:	7aa2                	ld	s5,40(sp)
    80001c9c:	7b02                	ld	s6,32(sp)
    80001c9e:	6be2                	ld	s7,24(sp)
    80001ca0:	6c42                	ld	s8,16(sp)
    80001ca2:	6ca2                	ld	s9,8(sp)
    80001ca4:	6125                	addi	sp,sp,96
    80001ca6:	8082                	ret
                return -1;
    80001ca8:	557d                	li	a0,-1
    80001caa:	64a6                	ld	s1,72(sp)
    80001cac:	79e2                	ld	s3,56(sp)
    80001cae:	b7d5                	j	80001c92 <copyin+0xb8>

0000000080001cb0 <copyinstr>:
// Copy bytes to dst from virtual address srcva in a given page table,
// until a '\0', or max.
// Return 0 on success, -1 on error.
    int
copyinstr(pagetable_t pagetable, char *dst, uint64 srcva, uint64 max)
{
    80001cb0:	715d                	addi	sp,sp,-80
    80001cb2:	e486                	sd	ra,72(sp)
    80001cb4:	e0a2                	sd	s0,64(sp)
    80001cb6:	fc26                	sd	s1,56(sp)
    80001cb8:	f44e                	sd	s3,40(sp)
    80001cba:	f052                	sd	s4,32(sp)
    80001cbc:	ec56                	sd	s5,24(sp)
    80001cbe:	e85a                	sd	s6,16(sp)
    80001cc0:	e45e                	sd	s7,8(sp)
    80001cc2:	0880                	addi	s0,sp,80
    80001cc4:	8aaa                	mv	s5,a0
    80001cc6:	84ae                	mv	s1,a1
    80001cc8:	8bb2                	mv	s7,a2
    80001cca:	89b6                	mv	s3,a3
    80001ccc:	14202773          	csrr	a4,scause
    const char* access_type;
    if (r_scause() == 12) { access_type = "exec"; }
    80001cd0:	47b1                	li	a5,12
    80001cd2:	00f70463          	beq	a4,a5,80001cda <copyinstr+0x2a>
    80001cd6:	142027f3          	csrr	a5,scause
    else if (r_scause() == 13) { access_type = "read"; }
    else { access_type = "write"; }
    uint64 n, va0, pa0;
    int got_null = 0;
    while(got_null == 0 && max > 0){
        va0 = PGROUNDDOWN(srcva);
    80001cda:	7b7d                	lui	s6,0xfffff
                return -1;
            }
            pa0 = walkaddr(pagetable, va0); // Retry
            if(pa0 == 0) return -1;
        }
        n = PGSIZE - (srcva - va0);
    80001cdc:	6a05                	lui	s4,0x1
    while(got_null == 0 && max > 0){
    80001cde:	4781                	li	a5,0
    80001ce0:	00098863          	beqz	s3,80001cf0 <copyinstr+0x40>
    80001ce4:	f84a                	sd	s2,48(sp)
    80001ce6:	a82d                	j	80001d20 <copyinstr+0x70>
        if(n > max)
            n = max;
        char *p = (char *) (pa0 + (srcva - va0));
        while(n > 0){
            if(*p == '\0'){
                *dst = '\0';
    80001ce8:	00078023          	sb	zero,0(a5)
                got_null = 1;
    80001cec:	4785                	li	a5,1
    80001cee:	7942                	ld	s2,48(sp)
            p++;
            dst++;
        }
        srcva = va0 + PGSIZE;
    }
    if(got_null){
    80001cf0:	0017c793          	xori	a5,a5,1
    80001cf4:	40f0053b          	negw	a0,a5
        return 0;
    } else {
        return -1;
    }
}
    80001cf8:	60a6                	ld	ra,72(sp)
    80001cfa:	6406                	ld	s0,64(sp)
    80001cfc:	74e2                	ld	s1,56(sp)
    80001cfe:	79a2                	ld	s3,40(sp)
    80001d00:	7a02                	ld	s4,32(sp)
    80001d02:	6ae2                	ld	s5,24(sp)
    80001d04:	6b42                	ld	s6,16(sp)
    80001d06:	6ba2                	ld	s7,8(sp)
    80001d08:	6161                	addi	sp,sp,80
    80001d0a:	8082                	ret
    80001d0c:	fff98713          	addi	a4,s3,-1 # fff <_entry-0x7ffff001>
    80001d10:	9726                	add	a4,a4,s1
            --max;
    80001d12:	40b709b3          	sub	s3,a4,a1
        srcva = va0 + PGSIZE;
    80001d16:	01490bb3          	add	s7,s2,s4
    while(got_null == 0 && max > 0){
    80001d1a:	04e58463          	beq	a1,a4,80001d62 <copyinstr+0xb2>
{
    80001d1e:	84be                	mv	s1,a5
        va0 = PGROUNDDOWN(srcva);
    80001d20:	016bf933          	and	s2,s7,s6
        pa0 = walkaddr(pagetable, va0);
    80001d24:	85ca                	mv	a1,s2
    80001d26:	8556                	mv	a0,s5
    80001d28:	afeff0ef          	jal	80001026 <walkaddr>
        if(pa0 == 0){
    80001d2c:	cd15                	beqz	a0,80001d68 <copyinstr+0xb8>
        n = PGSIZE - (srcva - va0);
    80001d2e:	417906b3          	sub	a3,s2,s7
    80001d32:	96d2                	add	a3,a3,s4
        if(n > max)
    80001d34:	00d9f363          	bgeu	s3,a3,80001d3a <copyinstr+0x8a>
    80001d38:	86ce                	mv	a3,s3
        while(n > 0){
    80001d3a:	ca95                	beqz	a3,80001d6e <copyinstr+0xbe>
        char *p = (char *) (pa0 + (srcva - va0));
    80001d3c:	01750633          	add	a2,a0,s7
    80001d40:	41260633          	sub	a2,a2,s2
    80001d44:	87a6                	mv	a5,s1
            if(*p == '\0'){
    80001d46:	8e05                	sub	a2,a2,s1
        while(n > 0){
    80001d48:	96a6                	add	a3,a3,s1
    80001d4a:	85be                	mv	a1,a5
            if(*p == '\0'){
    80001d4c:	00f60733          	add	a4,a2,a5
    80001d50:	00074703          	lbu	a4,0(a4)
    80001d54:	db51                	beqz	a4,80001ce8 <copyinstr+0x38>
                *dst = *p;
    80001d56:	00e78023          	sb	a4,0(a5)
            dst++;
    80001d5a:	0785                	addi	a5,a5,1
        while(n > 0){
    80001d5c:	fed797e3          	bne	a5,a3,80001d4a <copyinstr+0x9a>
    80001d60:	b775                	j	80001d0c <copyinstr+0x5c>
    80001d62:	4781                	li	a5,0
    80001d64:	7942                	ld	s2,48(sp)
    80001d66:	b769                	j	80001cf0 <copyinstr+0x40>
            return-1;
    80001d68:	557d                	li	a0,-1
    80001d6a:	7942                	ld	s2,48(sp)
    80001d6c:	b771                	j	80001cf8 <copyinstr+0x48>
        srcva = va0 + PGSIZE;
    80001d6e:	6b85                	lui	s7,0x1
    80001d70:	9bca                	add	s7,s7,s2
    80001d72:	87a6                	mv	a5,s1
    80001d74:	b76d                	j	80001d1e <copyinstr+0x6e>

0000000080001d76 <ismapped>:
// out of physical memory, and physical address if successful.


    int
ismapped(pagetable_t pagetable, uint64 va)
{
    80001d76:	1141                	addi	sp,sp,-16
    80001d78:	e406                	sd	ra,8(sp)
    80001d7a:	e022                	sd	s0,0(sp)
    80001d7c:	0800                	addi	s0,sp,16
    pte_t *pte = walk(pagetable, va, 0);
    80001d7e:	4601                	li	a2,0
    80001d80:	a0cff0ef          	jal	80000f8c <walk>
    if (pte == 0) {
    80001d84:	c119                	beqz	a0,80001d8a <ismapped+0x14>
        return 0;
    }
    if (*pte & PTE_V){
    80001d86:	6108                	ld	a0,0(a0)
    80001d88:	8905                	andi	a0,a0,1
        return 1;
    }
    return 0;
}
    80001d8a:	60a2                	ld	ra,8(sp)
    80001d8c:	6402                	ld	s0,0(sp)
    80001d8e:	0141                	addi	sp,sp,16
    80001d90:	8082                	ret

0000000080001d92 <vmfault>:
{
    80001d92:	7179                	addi	sp,sp,-48
    80001d94:	f406                	sd	ra,40(sp)
    80001d96:	f022                	sd	s0,32(sp)
    80001d98:	e84a                	sd	s2,16(sp)
    80001d9a:	e44e                	sd	s3,8(sp)
    80001d9c:	1800                	addi	s0,sp,48
    80001d9e:	89aa                	mv	s3,a0
    80001da0:	892e                	mv	s2,a1
    struct proc *p = myproc();
    80001da2:	216000ef          	jal	80001fb8 <myproc>
    if (va >= p->sz)
    80001da6:	653c                	ld	a5,72(a0)
    80001da8:	00f96a63          	bltu	s2,a5,80001dbc <vmfault+0x2a>
        return 0;
    80001dac:	4981                	li	s3,0
}
    80001dae:	854e                	mv	a0,s3
    80001db0:	70a2                	ld	ra,40(sp)
    80001db2:	7402                	ld	s0,32(sp)
    80001db4:	6942                	ld	s2,16(sp)
    80001db6:	69a2                	ld	s3,8(sp)
    80001db8:	6145                	addi	sp,sp,48
    80001dba:	8082                	ret
    80001dbc:	ec26                	sd	s1,24(sp)
    80001dbe:	e052                	sd	s4,0(sp)
    80001dc0:	84aa                	mv	s1,a0
    va = PGROUNDDOWN(va);
    80001dc2:	77fd                	lui	a5,0xfffff
    80001dc4:	00f97a33          	and	s4,s2,a5
    if(ismapped(pagetable, va)) {
    80001dc8:	85d2                	mv	a1,s4
    80001dca:	854e                	mv	a0,s3
    80001dcc:	fabff0ef          	jal	80001d76 <ismapped>
        return 0;
    80001dd0:	4981                	li	s3,0
    if(ismapped(pagetable, va)) {
    80001dd2:	c501                	beqz	a0,80001dda <vmfault+0x48>
    80001dd4:	64e2                	ld	s1,24(sp)
    80001dd6:	6a02                	ld	s4,0(sp)
    80001dd8:	bfd9                	j	80001dae <vmfault+0x1c>
    mem = (uint64) kalloc(); // Just allocates memory
    80001dda:	d6bfe0ef          	jal	80000b44 <kalloc>
    80001dde:	892a                	mv	s2,a0
    if(mem == 0)
    80001de0:	c905                	beqz	a0,80001e10 <vmfault+0x7e>
    mem = (uint64) kalloc(); // Just allocates memory
    80001de2:	89aa                	mv	s3,a0
    memset((void *) mem, 0, PGSIZE);
    80001de4:	6605                	lui	a2,0x1
    80001de6:	4581                	li	a1,0
    80001de8:	f11fe0ef          	jal	80000cf8 <memset>
    if (mappages(p->pagetable, va, PGSIZE, mem, PTE_W|PTE_U|PTE_R) != 0) {
    80001dec:	4759                	li	a4,22
    80001dee:	86ca                	mv	a3,s2
    80001df0:	6605                	lui	a2,0x1
    80001df2:	85d2                	mv	a1,s4
    80001df4:	68a8                	ld	a0,80(s1)
    80001df6:	a6aff0ef          	jal	80001060 <mappages>
    80001dfa:	e501                	bnez	a0,80001e02 <vmfault+0x70>
    80001dfc:	64e2                	ld	s1,24(sp)
    80001dfe:	6a02                	ld	s4,0(sp)
    80001e00:	b77d                	j	80001dae <vmfault+0x1c>
        kfree((void *)mem);
    80001e02:	854a                	mv	a0,s2
    80001e04:	c59fe0ef          	jal	80000a5c <kfree>
        return 0;
    80001e08:	4981                	li	s3,0
    80001e0a:	64e2                	ld	s1,24(sp)
    80001e0c:	6a02                	ld	s4,0(sp)
    80001e0e:	b745                	j	80001dae <vmfault+0x1c>
    80001e10:	64e2                	ld	s1,24(sp)
    80001e12:	6a02                	ld	s4,0(sp)
    80001e14:	bf69                	j	80001dae <vmfault+0x1c>

0000000080001e16 <proc_mapstacks>:
// Allocate a page for each process's kernel stack.
// Map it high in memory, followed by an invalid
// guard page.
void
proc_mapstacks(pagetable_t kpgtbl)
{
    80001e16:	711d                	addi	sp,sp,-96
    80001e18:	ec86                	sd	ra,88(sp)
    80001e1a:	e8a2                	sd	s0,80(sp)
    80001e1c:	e4a6                	sd	s1,72(sp)
    80001e1e:	e0ca                	sd	s2,64(sp)
    80001e20:	fc4e                	sd	s3,56(sp)
    80001e22:	f852                	sd	s4,48(sp)
    80001e24:	f456                	sd	s5,40(sp)
    80001e26:	f05a                	sd	s6,32(sp)
    80001e28:	ec5e                	sd	s7,24(sp)
    80001e2a:	e862                	sd	s8,16(sp)
    80001e2c:	e466                	sd	s9,8(sp)
    80001e2e:	1080                	addi	s0,sp,96
    80001e30:	8aaa                	mv	s5,a0
  struct proc *p;
  
  for(p = proc; p < &proc[NPROC]; p++) {
    80001e32:	00012497          	auipc	s1,0x12
    80001e36:	f9648493          	addi	s1,s1,-106 # 80013dc8 <proc>
    char *pa = kalloc();
    if(pa == 0)
      panic("kalloc");
    uint64 va = KSTACK((int) (p - proc));
    80001e3a:	8ca6                	mv	s9,s1
    80001e3c:	fee8f937          	lui	s2,0xfee8f
    80001e40:	d0590913          	addi	s2,s2,-763 # fffffffffee8ed05 <end+0xffffffff7cc19f5d>
    80001e44:	0932                	slli	s2,s2,0xc
    80001e46:	94790913          	addi	s2,s2,-1721
    80001e4a:	0936                	slli	s2,s2,0xd
    80001e4c:	60790913          	addi	s2,s2,1543
    80001e50:	0932                	slli	s2,s2,0xc
    80001e52:	26790913          	addi	s2,s2,615
    80001e56:	040009b7          	lui	s3,0x4000
    80001e5a:	19fd                	addi	s3,s3,-1 # 3ffffff <_entry-0x7c000001>
    80001e5c:	09b2                	slli	s3,s3,0xc
    kvmmap(kpgtbl, va, (uint64)pa, PGSIZE, PTE_R | PTE_W);
    80001e5e:	4c19                	li	s8,6
    80001e60:	6b85                	lui	s7,0x1
  for(p = proc; p < &proc[NPROC]; p++) {
    80001e62:	00089a37          	lui	s4,0x89
    80001e66:	570a0a13          	addi	s4,s4,1392 # 89570 <_entry-0x7ff76a90>
    80001e6a:	02268b17          	auipc	s6,0x2268
    80001e6e:	b5eb0b13          	addi	s6,s6,-1186 # 822699c8 <tickslock>
    char *pa = kalloc();
    80001e72:	cd3fe0ef          	jal	80000b44 <kalloc>
    80001e76:	862a                	mv	a2,a0
    if(pa == 0)
    80001e78:	c121                	beqz	a0,80001eb8 <proc_mapstacks+0xa2>
    uint64 va = KSTACK((int) (p - proc));
    80001e7a:	419485b3          	sub	a1,s1,s9
    80001e7e:	8591                	srai	a1,a1,0x4
    80001e80:	032585b3          	mul	a1,a1,s2
    80001e84:	05b6                	slli	a1,a1,0xd
    80001e86:	6789                	lui	a5,0x2
    80001e88:	9dbd                	addw	a1,a1,a5
    kvmmap(kpgtbl, va, (uint64)pa, PGSIZE, PTE_R | PTE_W);
    80001e8a:	8762                	mv	a4,s8
    80001e8c:	86de                	mv	a3,s7
    80001e8e:	40b985b3          	sub	a1,s3,a1
    80001e92:	8556                	mv	a0,s5
    80001e94:	a7aff0ef          	jal	8000110e <kvmmap>
  for(p = proc; p < &proc[NPROC]; p++) {
    80001e98:	94d2                	add	s1,s1,s4
    80001e9a:	fd649ce3          	bne	s1,s6,80001e72 <proc_mapstacks+0x5c>
  }
}
    80001e9e:	60e6                	ld	ra,88(sp)
    80001ea0:	6446                	ld	s0,80(sp)
    80001ea2:	64a6                	ld	s1,72(sp)
    80001ea4:	6906                	ld	s2,64(sp)
    80001ea6:	79e2                	ld	s3,56(sp)
    80001ea8:	7a42                	ld	s4,48(sp)
    80001eaa:	7aa2                	ld	s5,40(sp)
    80001eac:	7b02                	ld	s6,32(sp)
    80001eae:	6be2                	ld	s7,24(sp)
    80001eb0:	6c42                	ld	s8,16(sp)
    80001eb2:	6ca2                	ld	s9,8(sp)
    80001eb4:	6125                	addi	sp,sp,96
    80001eb6:	8082                	ret
      panic("kalloc");
    80001eb8:	00006517          	auipc	a0,0x6
    80001ebc:	54050513          	addi	a0,a0,1344 # 800083f8 <etext+0x3f8>
    80001ec0:	965fe0ef          	jal	80000824 <panic>

0000000080001ec4 <procinit>:

// initialize the proc table.
void
procinit(void)
{
    80001ec4:	715d                	addi	sp,sp,-80
    80001ec6:	e486                	sd	ra,72(sp)
    80001ec8:	e0a2                	sd	s0,64(sp)
    80001eca:	fc26                	sd	s1,56(sp)
    80001ecc:	f84a                	sd	s2,48(sp)
    80001ece:	f44e                	sd	s3,40(sp)
    80001ed0:	f052                	sd	s4,32(sp)
    80001ed2:	ec56                	sd	s5,24(sp)
    80001ed4:	e85a                	sd	s6,16(sp)
    80001ed6:	e45e                	sd	s7,8(sp)
    80001ed8:	0880                	addi	s0,sp,80
  struct proc *p;
  
  initlock(&pid_lock, "nextpid");
    80001eda:	00006597          	auipc	a1,0x6
    80001ede:	52658593          	addi	a1,a1,1318 # 80008400 <etext+0x400>
    80001ee2:	00012517          	auipc	a0,0x12
    80001ee6:	ab650513          	addi	a0,a0,-1354 # 80013998 <pid_lock>
    80001eea:	cb5fe0ef          	jal	80000b9e <initlock>
  initlock(&wait_lock, "wait_lock");
    80001eee:	00006597          	auipc	a1,0x6
    80001ef2:	51a58593          	addi	a1,a1,1306 # 80008408 <etext+0x408>
    80001ef6:	00012517          	auipc	a0,0x12
    80001efa:	aba50513          	addi	a0,a0,-1350 # 800139b0 <wait_lock>
    80001efe:	ca1fe0ef          	jal	80000b9e <initlock>
  for(p = proc; p < &proc[NPROC]; p++) {
    80001f02:	00012497          	auipc	s1,0x12
    80001f06:	ec648493          	addi	s1,s1,-314 # 80013dc8 <proc>
      initlock(&p->lock, "proc");
    80001f0a:	00006b97          	auipc	s7,0x6
    80001f0e:	50eb8b93          	addi	s7,s7,1294 # 80008418 <etext+0x418>
      p->state = UNUSED;
      p->kstack = KSTACK((int) (p - proc));
    80001f12:	8b26                	mv	s6,s1
    80001f14:	fee8f937          	lui	s2,0xfee8f
    80001f18:	d0590913          	addi	s2,s2,-763 # fffffffffee8ed05 <end+0xffffffff7cc19f5d>
    80001f1c:	0932                	slli	s2,s2,0xc
    80001f1e:	94790913          	addi	s2,s2,-1721
    80001f22:	0936                	slli	s2,s2,0xd
    80001f24:	60790913          	addi	s2,s2,1543
    80001f28:	0932                	slli	s2,s2,0xc
    80001f2a:	26790913          	addi	s2,s2,615
    80001f2e:	040009b7          	lui	s3,0x4000
    80001f32:	19fd                	addi	s3,s3,-1 # 3ffffff <_entry-0x7c000001>
    80001f34:	09b2                	slli	s3,s3,0xc
  for(p = proc; p < &proc[NPROC]; p++) {
    80001f36:	00089a37          	lui	s4,0x89
    80001f3a:	570a0a13          	addi	s4,s4,1392 # 89570 <_entry-0x7ff76a90>
    80001f3e:	02268a97          	auipc	s5,0x2268
    80001f42:	a8aa8a93          	addi	s5,s5,-1398 # 822699c8 <tickslock>
      initlock(&p->lock, "proc");
    80001f46:	85de                	mv	a1,s7
    80001f48:	8526                	mv	a0,s1
    80001f4a:	c55fe0ef          	jal	80000b9e <initlock>
      p->state = UNUSED;
    80001f4e:	0004ac23          	sw	zero,24(s1)
      p->kstack = KSTACK((int) (p - proc));
    80001f52:	416487b3          	sub	a5,s1,s6
    80001f56:	8791                	srai	a5,a5,0x4
    80001f58:	032787b3          	mul	a5,a5,s2
    80001f5c:	07b6                	slli	a5,a5,0xd
    80001f5e:	6709                	lui	a4,0x2
    80001f60:	9fb9                	addw	a5,a5,a4
    80001f62:	40f987b3          	sub	a5,s3,a5
    80001f66:	e0bc                	sd	a5,64(s1)
  for(p = proc; p < &proc[NPROC]; p++) {
    80001f68:	94d2                	add	s1,s1,s4
    80001f6a:	fd549ee3          	bne	s1,s5,80001f46 <procinit+0x82>
  }
}
    80001f6e:	60a6                	ld	ra,72(sp)
    80001f70:	6406                	ld	s0,64(sp)
    80001f72:	74e2                	ld	s1,56(sp)
    80001f74:	7942                	ld	s2,48(sp)
    80001f76:	79a2                	ld	s3,40(sp)
    80001f78:	7a02                	ld	s4,32(sp)
    80001f7a:	6ae2                	ld	s5,24(sp)
    80001f7c:	6b42                	ld	s6,16(sp)
    80001f7e:	6ba2                	ld	s7,8(sp)
    80001f80:	6161                	addi	sp,sp,80
    80001f82:	8082                	ret

0000000080001f84 <cpuid>:
// Must be called with interrupts disabled,
// to prevent race with process being moved
// to a different CPU.
int
cpuid()
{
    80001f84:	1141                	addi	sp,sp,-16
    80001f86:	e406                	sd	ra,8(sp)
    80001f88:	e022                	sd	s0,0(sp)
    80001f8a:	0800                	addi	s0,sp,16
  asm volatile("mv %0, tp" : "=r" (x) );
    80001f8c:	8512                	mv	a0,tp
  int id = r_tp();
  return id;
}
    80001f8e:	2501                	sext.w	a0,a0
    80001f90:	60a2                	ld	ra,8(sp)
    80001f92:	6402                	ld	s0,0(sp)
    80001f94:	0141                	addi	sp,sp,16
    80001f96:	8082                	ret

0000000080001f98 <mycpu>:

// Return this CPU's cpu struct.
// Interrupts must be disabled.
struct cpu*
mycpu(void)
{
    80001f98:	1141                	addi	sp,sp,-16
    80001f9a:	e406                	sd	ra,8(sp)
    80001f9c:	e022                	sd	s0,0(sp)
    80001f9e:	0800                	addi	s0,sp,16
    80001fa0:	8792                	mv	a5,tp
  int id = cpuid();
  struct cpu *c = &cpus[id];
    80001fa2:	2781                	sext.w	a5,a5
    80001fa4:	079e                	slli	a5,a5,0x7
  return c;
}
    80001fa6:	00012517          	auipc	a0,0x12
    80001faa:	a2250513          	addi	a0,a0,-1502 # 800139c8 <cpus>
    80001fae:	953e                	add	a0,a0,a5
    80001fb0:	60a2                	ld	ra,8(sp)
    80001fb2:	6402                	ld	s0,0(sp)
    80001fb4:	0141                	addi	sp,sp,16
    80001fb6:	8082                	ret

0000000080001fb8 <myproc>:

// Return the current struct proc *, or zero if none.
struct proc*
myproc(void)
{
    80001fb8:	1101                	addi	sp,sp,-32
    80001fba:	ec06                	sd	ra,24(sp)
    80001fbc:	e822                	sd	s0,16(sp)
    80001fbe:	e426                	sd	s1,8(sp)
    80001fc0:	1000                	addi	s0,sp,32
  push_off();
    80001fc2:	c23fe0ef          	jal	80000be4 <push_off>
    80001fc6:	8792                	mv	a5,tp
  struct cpu *c = mycpu();
  struct proc *p = c->proc;
    80001fc8:	2781                	sext.w	a5,a5
    80001fca:	079e                	slli	a5,a5,0x7
    80001fcc:	00012717          	auipc	a4,0x12
    80001fd0:	9cc70713          	addi	a4,a4,-1588 # 80013998 <pid_lock>
    80001fd4:	97ba                	add	a5,a5,a4
    80001fd6:	7b9c                	ld	a5,48(a5)
    80001fd8:	84be                	mv	s1,a5
  pop_off();
    80001fda:	c93fe0ef          	jal	80000c6c <pop_off>
  return p;
}
    80001fde:	8526                	mv	a0,s1
    80001fe0:	60e2                	ld	ra,24(sp)
    80001fe2:	6442                	ld	s0,16(sp)
    80001fe4:	64a2                	ld	s1,8(sp)
    80001fe6:	6105                	addi	sp,sp,32
    80001fe8:	8082                	ret

0000000080001fea <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch to forkret.
void
forkret(void)
{
    80001fea:	7179                	addi	sp,sp,-48
    80001fec:	f406                	sd	ra,40(sp)
    80001fee:	f022                	sd	s0,32(sp)
    80001ff0:	ec26                	sd	s1,24(sp)
    80001ff2:	1800                	addi	s0,sp,48
  extern char userret[];
  static int first = 1;
  struct proc *p = myproc();
    80001ff4:	fc5ff0ef          	jal	80001fb8 <myproc>
    80001ff8:	84aa                	mv	s1,a0

  // Still holding p->lock from scheduler.
  release(&p->lock);
    80001ffa:	cc3fe0ef          	jal	80000cbc <release>

  if (first) {
    80001ffe:	0000a797          	auipc	a5,0xa
    80002002:	8627a783          	lw	a5,-1950(a5) # 8000b860 <first.1>
    80002006:	cf95                	beqz	a5,80002042 <forkret+0x58>
    // File system initialization must be run in the context of a
    // regular process (e.g., because it calls sleep), and thus cannot
    // be run from main().
    fsinit(ROOTDEV);
    80002008:	4505                	li	a0,1
    8000200a:	7c7010ef          	jal	80003fd0 <fsinit>

    first = 0;
    8000200e:	0000a797          	auipc	a5,0xa
    80002012:	8407a923          	sw	zero,-1966(a5) # 8000b860 <first.1>
    // ensure other cores see first=0.
    __sync_synchronize();
    80002016:	0330000f          	fence	rw,rw

    // We can invoke kexec() now that file system is initialized.
    // Put the return value (argc) of kexec into a0.
    p->trapframe->a0 = kexec("/init", (char *[]){ "/init", 0 });
    8000201a:	00006797          	auipc	a5,0x6
    8000201e:	40678793          	addi	a5,a5,1030 # 80008420 <etext+0x420>
    80002022:	fcf43823          	sd	a5,-48(s0)
    80002026:	fc043c23          	sd	zero,-40(s0)
    8000202a:	fd040593          	addi	a1,s0,-48
    8000202e:	853e                	mv	a0,a5
    80002030:	2b0030ef          	jal	800052e0 <kexec>
    80002034:	6cbc                	ld	a5,88(s1)
    80002036:	fba8                	sd	a0,112(a5)
    if (p->trapframe->a0 == -1) {
    80002038:	6cbc                	ld	a5,88(s1)
    8000203a:	7bb8                	ld	a4,112(a5)
    8000203c:	57fd                	li	a5,-1
    8000203e:	02f70d63          	beq	a4,a5,80002078 <forkret+0x8e>
      panic("exec");
    }
  }

  // return to user space, mimicing usertrap()'s return.
  prepare_return();
    80002042:	43f000ef          	jal	80002c80 <prepare_return>
  uint64 satp = MAKE_SATP(p->pagetable);
    80002046:	68a8                	ld	a0,80(s1)
    80002048:	8131                	srli	a0,a0,0xc
  uint64 trampoline_userret = TRAMPOLINE + (userret - trampoline);
    8000204a:	04000737          	lui	a4,0x4000
    8000204e:	177d                	addi	a4,a4,-1 # 3ffffff <_entry-0x7c000001>
    80002050:	0732                	slli	a4,a4,0xc
    80002052:	00005797          	auipc	a5,0x5
    80002056:	04a78793          	addi	a5,a5,74 # 8000709c <userret>
    8000205a:	00005697          	auipc	a3,0x5
    8000205e:	fa668693          	addi	a3,a3,-90 # 80007000 <_trampoline>
    80002062:	8f95                	sub	a5,a5,a3
    80002064:	97ba                	add	a5,a5,a4
  ((void (*)(uint64))trampoline_userret)(satp);
    80002066:	577d                	li	a4,-1
    80002068:	177e                	slli	a4,a4,0x3f
    8000206a:	8d59                	or	a0,a0,a4
    8000206c:	9782                	jalr	a5
}
    8000206e:	70a2                	ld	ra,40(sp)
    80002070:	7402                	ld	s0,32(sp)
    80002072:	64e2                	ld	s1,24(sp)
    80002074:	6145                	addi	sp,sp,48
    80002076:	8082                	ret
      panic("exec");
    80002078:	00006517          	auipc	a0,0x6
    8000207c:	28850513          	addi	a0,a0,648 # 80008300 <etext+0x300>
    80002080:	fa4fe0ef          	jal	80000824 <panic>

0000000080002084 <allocpid>:
{
    80002084:	1101                	addi	sp,sp,-32
    80002086:	ec06                	sd	ra,24(sp)
    80002088:	e822                	sd	s0,16(sp)
    8000208a:	e426                	sd	s1,8(sp)
    8000208c:	1000                	addi	s0,sp,32
  acquire(&pid_lock);
    8000208e:	00012517          	auipc	a0,0x12
    80002092:	90a50513          	addi	a0,a0,-1782 # 80013998 <pid_lock>
    80002096:	b93fe0ef          	jal	80000c28 <acquire>
  pid = nextpid;
    8000209a:	00009797          	auipc	a5,0x9
    8000209e:	7ca78793          	addi	a5,a5,1994 # 8000b864 <nextpid>
    800020a2:	4384                	lw	s1,0(a5)
  nextpid = nextpid + 1;
    800020a4:	0014871b          	addiw	a4,s1,1
    800020a8:	c398                	sw	a4,0(a5)
  release(&pid_lock);
    800020aa:	00012517          	auipc	a0,0x12
    800020ae:	8ee50513          	addi	a0,a0,-1810 # 80013998 <pid_lock>
    800020b2:	c0bfe0ef          	jal	80000cbc <release>
}
    800020b6:	8526                	mv	a0,s1
    800020b8:	60e2                	ld	ra,24(sp)
    800020ba:	6442                	ld	s0,16(sp)
    800020bc:	64a2                	ld	s1,8(sp)
    800020be:	6105                	addi	sp,sp,32
    800020c0:	8082                	ret

00000000800020c2 <proc_pagetable>:
{
    800020c2:	1101                	addi	sp,sp,-32
    800020c4:	ec06                	sd	ra,24(sp)
    800020c6:	e822                	sd	s0,16(sp)
    800020c8:	e426                	sd	s1,8(sp)
    800020ca:	e04a                	sd	s2,0(sp)
    800020cc:	1000                	addi	s0,sp,32
    800020ce:	892a                	mv	s2,a0
  pagetable = uvmcreate();
    800020d0:	930ff0ef          	jal	80001200 <uvmcreate>
    800020d4:	84aa                	mv	s1,a0
  if(pagetable == 0)
    800020d6:	cd05                	beqz	a0,8000210e <proc_pagetable+0x4c>
  if(mappages(pagetable, TRAMPOLINE, PGSIZE,
    800020d8:	4729                	li	a4,10
    800020da:	00005697          	auipc	a3,0x5
    800020de:	f2668693          	addi	a3,a3,-218 # 80007000 <_trampoline>
    800020e2:	6605                	lui	a2,0x1
    800020e4:	040005b7          	lui	a1,0x4000
    800020e8:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    800020ea:	05b2                	slli	a1,a1,0xc
    800020ec:	f75fe0ef          	jal	80001060 <mappages>
    800020f0:	02054663          	bltz	a0,8000211c <proc_pagetable+0x5a>
  if(mappages(pagetable, TRAPFRAME, PGSIZE,
    800020f4:	4719                	li	a4,6
    800020f6:	05893683          	ld	a3,88(s2)
    800020fa:	6605                	lui	a2,0x1
    800020fc:	020005b7          	lui	a1,0x2000
    80002100:	15fd                	addi	a1,a1,-1 # 1ffffff <_entry-0x7e000001>
    80002102:	05b6                	slli	a1,a1,0xd
    80002104:	8526                	mv	a0,s1
    80002106:	f5bfe0ef          	jal	80001060 <mappages>
    8000210a:	00054f63          	bltz	a0,80002128 <proc_pagetable+0x66>
}
    8000210e:	8526                	mv	a0,s1
    80002110:	60e2                	ld	ra,24(sp)
    80002112:	6442                	ld	s0,16(sp)
    80002114:	64a2                	ld	s1,8(sp)
    80002116:	6902                	ld	s2,0(sp)
    80002118:	6105                	addi	sp,sp,32
    8000211a:	8082                	ret
    uvmfree(pagetable, 0);
    8000211c:	4581                	li	a1,0
    8000211e:	8526                	mv	a0,s1
    80002120:	873ff0ef          	jal	80001992 <uvmfree>
    return 0;
    80002124:	4481                	li	s1,0
    80002126:	b7e5                	j	8000210e <proc_pagetable+0x4c>
    uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    80002128:	4681                	li	a3,0
    8000212a:	4605                	li	a2,1
    8000212c:	040005b7          	lui	a1,0x4000
    80002130:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80002132:	05b2                	slli	a1,a1,0xc
    80002134:	8526                	mv	a0,s1
    80002136:	8f0ff0ef          	jal	80001226 <uvmunmap>
    uvmfree(pagetable, 0);
    8000213a:	4581                	li	a1,0
    8000213c:	8526                	mv	a0,s1
    8000213e:	855ff0ef          	jal	80001992 <uvmfree>
    return 0;
    80002142:	4481                	li	s1,0
    80002144:	b7e9                	j	8000210e <proc_pagetable+0x4c>

0000000080002146 <proc_freepagetable>:
{
    80002146:	1101                	addi	sp,sp,-32
    80002148:	ec06                	sd	ra,24(sp)
    8000214a:	e822                	sd	s0,16(sp)
    8000214c:	e426                	sd	s1,8(sp)
    8000214e:	e04a                	sd	s2,0(sp)
    80002150:	1000                	addi	s0,sp,32
    80002152:	84aa                	mv	s1,a0
    80002154:	892e                	mv	s2,a1
  uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    80002156:	4681                	li	a3,0
    80002158:	4605                	li	a2,1
    8000215a:	040005b7          	lui	a1,0x4000
    8000215e:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80002160:	05b2                	slli	a1,a1,0xc
    80002162:	8c4ff0ef          	jal	80001226 <uvmunmap>
  uvmunmap(pagetable, TRAPFRAME, 1, 0);
    80002166:	4681                	li	a3,0
    80002168:	4605                	li	a2,1
    8000216a:	020005b7          	lui	a1,0x2000
    8000216e:	15fd                	addi	a1,a1,-1 # 1ffffff <_entry-0x7e000001>
    80002170:	05b6                	slli	a1,a1,0xd
    80002172:	8526                	mv	a0,s1
    80002174:	8b2ff0ef          	jal	80001226 <uvmunmap>
  uvmfree(pagetable, sz);
    80002178:	85ca                	mv	a1,s2
    8000217a:	8526                	mv	a0,s1
    8000217c:	817ff0ef          	jal	80001992 <uvmfree>
}
    80002180:	60e2                	ld	ra,24(sp)
    80002182:	6442                	ld	s0,16(sp)
    80002184:	64a2                	ld	s1,8(sp)
    80002186:	6902                	ld	s2,0(sp)
    80002188:	6105                	addi	sp,sp,32
    8000218a:	8082                	ret

000000008000218c <freeproc>:
{
    8000218c:	1101                	addi	sp,sp,-32
    8000218e:	ec06                	sd	ra,24(sp)
    80002190:	e822                	sd	s0,16(sp)
    80002192:	e426                	sd	s1,8(sp)
    80002194:	1000                	addi	s0,sp,32
    80002196:	84aa                	mv	s1,a0
  if(p->trapframe)
    80002198:	6d28                	ld	a0,88(a0)
    8000219a:	c119                	beqz	a0,800021a0 <freeproc+0x14>
    kfree((void*)p->trapframe);
    8000219c:	8c1fe0ef          	jal	80000a5c <kfree>
  p->trapframe = 0;
    800021a0:	0404bc23          	sd	zero,88(s1)
  if(p->pagetable)
    800021a4:	68a8                	ld	a0,80(s1)
    800021a6:	c501                	beqz	a0,800021ae <freeproc+0x22>
    proc_freepagetable(p->pagetable, p->sz);
    800021a8:	64ac                	ld	a1,72(s1)
    800021aa:	f9dff0ef          	jal	80002146 <proc_freepagetable>
  p->pagetable = 0;
    800021ae:	0404b823          	sd	zero,80(s1)
  p->sz = 0;
    800021b2:	0404b423          	sd	zero,72(s1)
  p->pid = 0;
    800021b6:	0204a823          	sw	zero,48(s1)
  p->parent = 0;
    800021ba:	0204bc23          	sd	zero,56(s1)
  p->name[0] = 0;
    800021be:	14048c23          	sb	zero,344(s1)
  p->chan = 0;
    800021c2:	0204b023          	sd	zero,32(s1)
  p->killed = 0;
    800021c6:	0204a423          	sw	zero,40(s1)
  p->xstate = 0;
    800021ca:	0204a623          	sw	zero,44(s1)
  p->state = UNUSED;
    800021ce:	0004ac23          	sw	zero,24(s1)
  if(p->exec_ip)
    800021d2:	1704b503          	ld	a0,368(s1)
    800021d6:	c119                	beqz	a0,800021dc <freeproc+0x50>
      iput(p->exec_ip);
    800021d8:	487010ef          	jal	80003e5e <iput>
}
    800021dc:	60e2                	ld	ra,24(sp)
    800021de:	6442                	ld	s0,16(sp)
    800021e0:	64a2                	ld	s1,8(sp)
    800021e2:	6105                	addi	sp,sp,32
    800021e4:	8082                	ret

00000000800021e6 <allocproc>:
{
    800021e6:	7179                	addi	sp,sp,-48
    800021e8:	f406                	sd	ra,40(sp)
    800021ea:	f022                	sd	s0,32(sp)
    800021ec:	ec26                	sd	s1,24(sp)
    800021ee:	e84a                	sd	s2,16(sp)
    800021f0:	e44e                	sd	s3,8(sp)
    800021f2:	1800                	addi	s0,sp,48
  for(p = proc; p < &proc[NPROC]; p++) {
    800021f4:	00012497          	auipc	s1,0x12
    800021f8:	bd448493          	addi	s1,s1,-1068 # 80013dc8 <proc>
    800021fc:	00089937          	lui	s2,0x89
    80002200:	57090913          	addi	s2,s2,1392 # 89570 <_entry-0x7ff76a90>
    80002204:	02267997          	auipc	s3,0x2267
    80002208:	7c498993          	addi	s3,s3,1988 # 822699c8 <tickslock>
    acquire(&p->lock);
    8000220c:	8526                	mv	a0,s1
    8000220e:	a1bfe0ef          	jal	80000c28 <acquire>
    if(p->state == UNUSED) {
    80002212:	4c9c                	lw	a5,24(s1)
    80002214:	cb89                	beqz	a5,80002226 <allocproc+0x40>
      release(&p->lock);
    80002216:	8526                	mv	a0,s1
    80002218:	aa5fe0ef          	jal	80000cbc <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    8000221c:	94ca                	add	s1,s1,s2
    8000221e:	ff3497e3          	bne	s1,s3,8000220c <allocproc+0x26>
  return 0;
    80002222:	4481                	li	s1,0
    80002224:	a049                	j	800022a6 <allocproc+0xc0>
  p->pid = allocpid();
    80002226:	e5fff0ef          	jal	80002084 <allocpid>
    8000222a:	d888                	sw	a0,48(s1)
  p->state = USED;
    8000222c:	4785                	li	a5,1
    8000222e:	cc9c                	sw	a5,24(s1)
  p->next_fifo_seq = 0;
    80002230:	000897b7          	lui	a5,0x89
    80002234:	97a6                	add	a5,a5,s1
    80002236:	1c07a423          	sw	zero,456(a5) # 891c8 <_entry-0x7ff76e38>
  p->num_resident = 0;
    8000223a:	1a07a823          	sw	zero,432(a5)
  p->num_swappped_pages=0;
    8000223e:	1c07a623          	sw	zero,460(a5)
  p->swap_path[0]='\0';
    80002242:	1a078a23          	sb	zero,436(a5)
  p->text_end=0;
    80002246:	1c07aa23          	sw	zero,468(a5)
  p->text_start=0;
    8000224a:	1c07a823          	sw	zero,464(a5)
  p->data_start=0;
    8000224e:	1c07ac23          	sw	zero,472(a5)
  p->data_end=0;
    80002252:	1c07ae23          	sw	zero,476(a5)
  p->stack_top=0;
    80002256:	1e07a223          	sw	zero,484(a5)
  p->num_phdrs=0;
    8000225a:	1e07a423          	sw	zero,488(a5)
  for(int i=0;i<MAX_SWAP_PAGES;i++)
    8000225e:	18048793          	addi	a5,s1,384
    80002262:	27048713          	addi	a4,s1,624
      p->swap_slots[i]=0;
    80002266:	0007a023          	sw	zero,0(a5)
  for(int i=0;i<MAX_SWAP_PAGES;i++)
    8000226a:	0791                	addi	a5,a5,4
    8000226c:	fee79de3          	bne	a5,a4,80002266 <allocproc+0x80>
  if((p->trapframe = (struct trapframe *)kalloc()) == 0){
    80002270:	8d5fe0ef          	jal	80000b44 <kalloc>
    80002274:	892a                	mv	s2,a0
    80002276:	eca8                	sd	a0,88(s1)
    80002278:	cd1d                	beqz	a0,800022b6 <allocproc+0xd0>
  p->pagetable = proc_pagetable(p);
    8000227a:	8526                	mv	a0,s1
    8000227c:	e47ff0ef          	jal	800020c2 <proc_pagetable>
    80002280:	892a                	mv	s2,a0
    80002282:	e8a8                	sd	a0,80(s1)
  if(p->pagetable == 0){
    80002284:	c129                	beqz	a0,800022c6 <allocproc+0xe0>
  memset(&p->context, 0, sizeof(p->context));
    80002286:	07000613          	li	a2,112
    8000228a:	4581                	li	a1,0
    8000228c:	06048513          	addi	a0,s1,96
    80002290:	a69fe0ef          	jal	80000cf8 <memset>
  p->context.ra = (uint64)forkret;
    80002294:	00000797          	auipc	a5,0x0
    80002298:	d5678793          	addi	a5,a5,-682 # 80001fea <forkret>
    8000229c:	f0bc                	sd	a5,96(s1)
  p->context.sp = p->kstack + PGSIZE;
    8000229e:	60bc                	ld	a5,64(s1)
    800022a0:	6705                	lui	a4,0x1
    800022a2:	97ba                	add	a5,a5,a4
    800022a4:	f4bc                	sd	a5,104(s1)
}
    800022a6:	8526                	mv	a0,s1
    800022a8:	70a2                	ld	ra,40(sp)
    800022aa:	7402                	ld	s0,32(sp)
    800022ac:	64e2                	ld	s1,24(sp)
    800022ae:	6942                	ld	s2,16(sp)
    800022b0:	69a2                	ld	s3,8(sp)
    800022b2:	6145                	addi	sp,sp,48
    800022b4:	8082                	ret
    freeproc(p);
    800022b6:	8526                	mv	a0,s1
    800022b8:	ed5ff0ef          	jal	8000218c <freeproc>
    release(&p->lock);
    800022bc:	8526                	mv	a0,s1
    800022be:	9fffe0ef          	jal	80000cbc <release>
    return 0;
    800022c2:	84ca                	mv	s1,s2
    800022c4:	b7cd                	j	800022a6 <allocproc+0xc0>
    freeproc(p);
    800022c6:	8526                	mv	a0,s1
    800022c8:	ec5ff0ef          	jal	8000218c <freeproc>
    release(&p->lock);
    800022cc:	8526                	mv	a0,s1
    800022ce:	9effe0ef          	jal	80000cbc <release>
    return 0;
    800022d2:	84ca                	mv	s1,s2
    800022d4:	bfc9                	j	800022a6 <allocproc+0xc0>

00000000800022d6 <userinit>:
{
    800022d6:	1101                	addi	sp,sp,-32
    800022d8:	ec06                	sd	ra,24(sp)
    800022da:	e822                	sd	s0,16(sp)
    800022dc:	e426                	sd	s1,8(sp)
    800022de:	1000                	addi	s0,sp,32
  p = allocproc();
    800022e0:	f07ff0ef          	jal	800021e6 <allocproc>
    800022e4:	84aa                	mv	s1,a0
  initproc = p;
    800022e6:	00009797          	auipc	a5,0x9
    800022ea:	5aa7b523          	sd	a0,1450(a5) # 8000b890 <initproc>
  p->cwd = namei("/");
    800022ee:	00006517          	auipc	a0,0x6
    800022f2:	13a50513          	addi	a0,a0,314 # 80008428 <etext+0x428>
    800022f6:	214020ef          	jal	8000450a <namei>
    800022fa:	14a4b823          	sd	a0,336(s1)
  p->state = RUNNABLE;
    800022fe:	478d                	li	a5,3
    80002300:	cc9c                	sw	a5,24(s1)
  release(&p->lock);
    80002302:	8526                	mv	a0,s1
    80002304:	9b9fe0ef          	jal	80000cbc <release>
}
    80002308:	60e2                	ld	ra,24(sp)
    8000230a:	6442                	ld	s0,16(sp)
    8000230c:	64a2                	ld	s1,8(sp)
    8000230e:	6105                	addi	sp,sp,32
    80002310:	8082                	ret

0000000080002312 <growproc>:
{
    80002312:	1101                	addi	sp,sp,-32
    80002314:	ec06                	sd	ra,24(sp)
    80002316:	e822                	sd	s0,16(sp)
    80002318:	e426                	sd	s1,8(sp)
    8000231a:	e04a                	sd	s2,0(sp)
    8000231c:	1000                	addi	s0,sp,32
    8000231e:	84aa                	mv	s1,a0
  struct proc *p = myproc();
    80002320:	c99ff0ef          	jal	80001fb8 <myproc>
    80002324:	892a                	mv	s2,a0
  sz = p->sz;
    80002326:	652c                	ld	a1,72(a0)
  if(n > 0){
    80002328:	02905963          	blez	s1,8000235a <growproc+0x48>
    if(sz + n > TRAPFRAME) {
    8000232c:	00b48633          	add	a2,s1,a1
    80002330:	020007b7          	lui	a5,0x2000
    80002334:	17fd                	addi	a5,a5,-1 # 1ffffff <_entry-0x7e000001>
    80002336:	07b6                	slli	a5,a5,0xd
    80002338:	02c7ea63          	bltu	a5,a2,8000236c <growproc+0x5a>
    if((sz = uvmalloc(p->pagetable, sz, sz + n, PTE_W)) == 0) {
    8000233c:	4691                	li	a3,4
    8000233e:	6928                	ld	a0,80(a0)
    80002340:	d56ff0ef          	jal	80001896 <uvmalloc>
    80002344:	85aa                	mv	a1,a0
    80002346:	c50d                	beqz	a0,80002370 <growproc+0x5e>
  p->sz = sz;
    80002348:	04b93423          	sd	a1,72(s2)
  return 0;
    8000234c:	4501                	li	a0,0
}
    8000234e:	60e2                	ld	ra,24(sp)
    80002350:	6442                	ld	s0,16(sp)
    80002352:	64a2                	ld	s1,8(sp)
    80002354:	6902                	ld	s2,0(sp)
    80002356:	6105                	addi	sp,sp,32
    80002358:	8082                	ret
  } else if(n < 0){
    8000235a:	fe04d7e3          	bgez	s1,80002348 <growproc+0x36>
    sz = uvmdealloc(p->pagetable, sz, sz + n);
    8000235e:	00b48633          	add	a2,s1,a1
    80002362:	6928                	ld	a0,80(a0)
    80002364:	ceeff0ef          	jal	80001852 <uvmdealloc>
    80002368:	85aa                	mv	a1,a0
    8000236a:	bff9                	j	80002348 <growproc+0x36>
      return -1;
    8000236c:	557d                	li	a0,-1
    8000236e:	b7c5                	j	8000234e <growproc+0x3c>
      return -1;
    80002370:	557d                	li	a0,-1
    80002372:	bff1                	j	8000234e <growproc+0x3c>

0000000080002374 <kfork>:
{
    80002374:	7139                	addi	sp,sp,-64
    80002376:	fc06                	sd	ra,56(sp)
    80002378:	f822                	sd	s0,48(sp)
    8000237a:	f426                	sd	s1,40(sp)
    8000237c:	e852                	sd	s4,16(sp)
    8000237e:	0080                	addi	s0,sp,64
  struct proc *p = myproc();
    80002380:	c39ff0ef          	jal	80001fb8 <myproc>
    80002384:	8a2a                	mv	s4,a0
  if((np = allocproc()) == 0){
    80002386:	e61ff0ef          	jal	800021e6 <allocproc>
    8000238a:	1a050663          	beqz	a0,80002536 <kfork+0x1c2>
    8000238e:	ec4e                	sd	s3,24(sp)
    80002390:	89aa                	mv	s3,a0
  if(uvmcopy(p->pagetable, np->pagetable, p->sz) < 0){
    80002392:	048a3603          	ld	a2,72(s4)
    80002396:	692c                	ld	a1,80(a0)
    80002398:	050a3503          	ld	a0,80(s4)
    8000239c:	e28ff0ef          	jal	800019c4 <uvmcopy>
    800023a0:	0e054d63          	bltz	a0,8000249a <kfork+0x126>
    800023a4:	f04a                	sd	s2,32(sp)
    800023a6:	e456                	sd	s5,8(sp)
  np->sz = p->sz;
    800023a8:	048a3783          	ld	a5,72(s4)
    800023ac:	04f9b423          	sd	a5,72(s3)
  *(np->trapframe) = *(p->trapframe);
    800023b0:	058a3683          	ld	a3,88(s4)
    800023b4:	87b6                	mv	a5,a3
    800023b6:	0589b703          	ld	a4,88(s3)
    800023ba:	12068693          	addi	a3,a3,288
    800023be:	6388                	ld	a0,0(a5)
    800023c0:	678c                	ld	a1,8(a5)
    800023c2:	6b90                	ld	a2,16(a5)
    800023c4:	e308                	sd	a0,0(a4)
    800023c6:	e70c                	sd	a1,8(a4)
    800023c8:	eb10                	sd	a2,16(a4)
    800023ca:	6f90                	ld	a2,24(a5)
    800023cc:	ef10                	sd	a2,24(a4)
    800023ce:	02078793          	addi	a5,a5,32
    800023d2:	02070713          	addi	a4,a4,32 # 1020 <_entry-0x7fffefe0>
    800023d6:	fed794e3          	bne	a5,a3,800023be <kfork+0x4a>
  np->heap_start = p->heap_start;
    800023da:	168a3783          	ld	a5,360(s4)
    800023de:	16f9b423          	sd	a5,360(s3)
  np->num_resident = p->num_resident;
    800023e2:	000897b7          	lui	a5,0x89
    800023e6:	00fa0733          	add	a4,s4,a5
    800023ea:	1b072683          	lw	a3,432(a4)
    800023ee:	97ce                	add	a5,a5,s3
    800023f0:	1ad7a823          	sw	a3,432(a5) # 891b0 <_entry-0x7ff76e50>
  np->next_fifo_seq = p->next_fifo_seq;
    800023f4:	1c872683          	lw	a3,456(a4)
    800023f8:	1cd7a423          	sw	a3,456(a5)
  np->num_swappped_pages = p->num_swappped_pages;
    800023fc:	1cc72683          	lw	a3,460(a4)
    80002400:	1cd7a623          	sw	a3,460(a5)
  for (i = 0; i < p->num_resident; i++) {
    80002404:	1b072783          	lw	a5,432(a4)
    80002408:	02f05563          	blez	a5,80002432 <kfork+0xbe>
    8000240c:	270a0713          	addi	a4,s4,624
    80002410:	27098793          	addi	a5,s3,624
    80002414:	4681                	li	a3,0
    80002416:	000895b7          	lui	a1,0x89
    8000241a:	95d2                	add	a1,a1,s4
    np->resident_pages[i] = p->resident_pages[i];
    8000241c:	6310                	ld	a2,0(a4)
    8000241e:	e390                	sd	a2,0(a5)
    80002420:	6710                	ld	a2,8(a4)
    80002422:	e790                	sd	a2,8(a5)
  for (i = 0; i < p->num_resident; i++) {
    80002424:	2685                	addiw	a3,a3,1
    80002426:	0741                	addi	a4,a4,16
    80002428:	07c1                	addi	a5,a5,16
    8000242a:	1b05a603          	lw	a2,432(a1) # 891b0 <_entry-0x7ff76e50>
    8000242e:	fec6c7e3          	blt	a3,a2,8000241c <kfork+0xa8>
  for (i = 0; i < p->num_swappped_pages; i++) {
    80002432:	000897b7          	lui	a5,0x89
    80002436:	97d2                	add	a5,a5,s4
    80002438:	1cc7a783          	lw	a5,460(a5) # 891cc <_entry-0x7ff76e34>
    8000243c:	02f05863          	blez	a5,8000246c <kfork+0xf8>
    80002440:	000897b7          	lui	a5,0x89
    80002444:	df078793          	addi	a5,a5,-528 # 88df0 <_entry-0x7ff77210>
    80002448:	00fa0733          	add	a4,s4,a5
    8000244c:	97ce                	add	a5,a5,s3
    8000244e:	4681                	li	a3,0
    80002450:	000895b7          	lui	a1,0x89
    80002454:	95d2                	add	a1,a1,s4
    np->swapped_pages[i] = p->swapped_pages[i];
    80002456:	6310                	ld	a2,0(a4)
    80002458:	e390                	sd	a2,0(a5)
    8000245a:	6710                	ld	a2,8(a4)
    8000245c:	e790                	sd	a2,8(a5)
  for (i = 0; i < p->num_swappped_pages; i++) {
    8000245e:	2685                	addiw	a3,a3,1
    80002460:	0741                	addi	a4,a4,16
    80002462:	07c1                	addi	a5,a5,16
    80002464:	1cc5a603          	lw	a2,460(a1) # 891cc <_entry-0x7ff76e34>
    80002468:	fec6c7e3          	blt	a3,a2,80002456 <kfork+0xe2>
  for (i = 0; i < MAX_SWAP_PAGES; i++) {
    8000246c:	180a0793          	addi	a5,s4,384
    80002470:	18098713          	addi	a4,s3,384
    80002474:	270a0613          	addi	a2,s4,624
    np->swap_slots[i] = p->swap_slots[i];
    80002478:	4394                	lw	a3,0(a5)
    8000247a:	c314                	sw	a3,0(a4)
  for (i = 0; i < MAX_SWAP_PAGES; i++) {
    8000247c:	0791                	addi	a5,a5,4
    8000247e:	0711                	addi	a4,a4,4
    80002480:	fec79ce3          	bne	a5,a2,80002478 <kfork+0x104>
  np->trapframe->a0 = 0;
    80002484:	0589b783          	ld	a5,88(s3)
    80002488:	0607b823          	sd	zero,112(a5)
  for(i = 0; i < NOFILE; i++)
    8000248c:	0d0a0493          	addi	s1,s4,208
    80002490:	0d098913          	addi	s2,s3,208
    80002494:	150a0a93          	addi	s5,s4,336
    80002498:	a831                	j	800024b4 <kfork+0x140>
    freeproc(np);
    8000249a:	854e                	mv	a0,s3
    8000249c:	cf1ff0ef          	jal	8000218c <freeproc>
    release(&np->lock);
    800024a0:	854e                	mv	a0,s3
    800024a2:	81bfe0ef          	jal	80000cbc <release>
    return -1;
    800024a6:	54fd                	li	s1,-1
    800024a8:	69e2                	ld	s3,24(sp)
    800024aa:	a8bd                	j	80002528 <kfork+0x1b4>
  for(i = 0; i < NOFILE; i++)
    800024ac:	04a1                	addi	s1,s1,8
    800024ae:	0921                	addi	s2,s2,8
    800024b0:	01548963          	beq	s1,s5,800024c2 <kfork+0x14e>
    if(p->ofile[i])
    800024b4:	6088                	ld	a0,0(s1)
    800024b6:	d97d                	beqz	a0,800024ac <kfork+0x138>
      np->ofile[i] = filedup(p->ofile[i]);
    800024b8:	60e020ef          	jal	80004ac6 <filedup>
    800024bc:	00a93023          	sd	a0,0(s2)
    800024c0:	b7f5                	j	800024ac <kfork+0x138>
  np->cwd = idup(p->cwd);
    800024c2:	150a3503          	ld	a0,336(s4)
    800024c6:	7e0010ef          	jal	80003ca6 <idup>
    800024ca:	14a9b823          	sd	a0,336(s3)
  if(p->exec_ip)
    800024ce:	170a3503          	ld	a0,368(s4)
    800024d2:	c509                	beqz	a0,800024dc <kfork+0x168>
    np->exec_ip = idup(p->exec_ip);
    800024d4:	7d2010ef          	jal	80003ca6 <idup>
    800024d8:	16a9b823          	sd	a0,368(s3)
  safestrcpy(np->name, p->name, sizeof(p->name));
    800024dc:	4641                	li	a2,16
    800024de:	158a0593          	addi	a1,s4,344
    800024e2:	15898513          	addi	a0,s3,344
    800024e6:	967fe0ef          	jal	80000e4c <safestrcpy>
  pid = np->pid;
    800024ea:	0309a483          	lw	s1,48(s3)
  release(&np->lock);
    800024ee:	854e                	mv	a0,s3
    800024f0:	fccfe0ef          	jal	80000cbc <release>
  acquire(&wait_lock);
    800024f4:	00011517          	auipc	a0,0x11
    800024f8:	4bc50513          	addi	a0,a0,1212 # 800139b0 <wait_lock>
    800024fc:	f2cfe0ef          	jal	80000c28 <acquire>
  np->parent = p;
    80002500:	0349bc23          	sd	s4,56(s3)
  release(&wait_lock);
    80002504:	00011517          	auipc	a0,0x11
    80002508:	4ac50513          	addi	a0,a0,1196 # 800139b0 <wait_lock>
    8000250c:	fb0fe0ef          	jal	80000cbc <release>
  acquire(&np->lock);
    80002510:	854e                	mv	a0,s3
    80002512:	f16fe0ef          	jal	80000c28 <acquire>
  np->state = RUNNABLE;
    80002516:	478d                	li	a5,3
    80002518:	00f9ac23          	sw	a5,24(s3)
  release(&np->lock);
    8000251c:	854e                	mv	a0,s3
    8000251e:	f9efe0ef          	jal	80000cbc <release>
  return pid;
    80002522:	7902                	ld	s2,32(sp)
    80002524:	69e2                	ld	s3,24(sp)
    80002526:	6aa2                	ld	s5,8(sp)
}
    80002528:	8526                	mv	a0,s1
    8000252a:	70e2                	ld	ra,56(sp)
    8000252c:	7442                	ld	s0,48(sp)
    8000252e:	74a2                	ld	s1,40(sp)
    80002530:	6a42                	ld	s4,16(sp)
    80002532:	6121                	addi	sp,sp,64
    80002534:	8082                	ret
    return -1;
    80002536:	54fd                	li	s1,-1
    80002538:	bfc5                	j	80002528 <kfork+0x1b4>

000000008000253a <scheduler>:
{
    8000253a:	715d                	addi	sp,sp,-80
    8000253c:	e486                	sd	ra,72(sp)
    8000253e:	e0a2                	sd	s0,64(sp)
    80002540:	fc26                	sd	s1,56(sp)
    80002542:	f84a                	sd	s2,48(sp)
    80002544:	f44e                	sd	s3,40(sp)
    80002546:	f052                	sd	s4,32(sp)
    80002548:	ec56                	sd	s5,24(sp)
    8000254a:	e85a                	sd	s6,16(sp)
    8000254c:	e45e                	sd	s7,8(sp)
    8000254e:	e062                	sd	s8,0(sp)
    80002550:	0880                	addi	s0,sp,80
    80002552:	8792                	mv	a5,tp
  int id = r_tp();
    80002554:	2781                	sext.w	a5,a5
  c->proc = 0;
    80002556:	00779b13          	slli	s6,a5,0x7
    8000255a:	00011717          	auipc	a4,0x11
    8000255e:	43e70713          	addi	a4,a4,1086 # 80013998 <pid_lock>
    80002562:	975a                	add	a4,a4,s6
    80002564:	02073823          	sd	zero,48(a4)
        swtch(&c->context, &p->context);
    80002568:	00011717          	auipc	a4,0x11
    8000256c:	46870713          	addi	a4,a4,1128 # 800139d0 <cpus+0x8>
    80002570:	9b3a                	add	s6,s6,a4
        p->state = RUNNING;
    80002572:	4c11                	li	s8,4
        c->proc = p;
    80002574:	079e                	slli	a5,a5,0x7
    80002576:	00011a17          	auipc	s4,0x11
    8000257a:	422a0a13          	addi	s4,s4,1058 # 80013998 <pid_lock>
    8000257e:	9a3e                	add	s4,s4,a5
        found = 1;
    80002580:	4b85                	li	s7,1
    80002582:	a091                	j	800025c6 <scheduler+0x8c>
      release(&p->lock);
    80002584:	8526                	mv	a0,s1
    80002586:	f36fe0ef          	jal	80000cbc <release>
    for(p = proc; p < &proc[NPROC]; p++) {
    8000258a:	94ca                	add	s1,s1,s2
    8000258c:	02267797          	auipc	a5,0x2267
    80002590:	43c78793          	addi	a5,a5,1084 # 822699c8 <tickslock>
    80002594:	02f48563          	beq	s1,a5,800025be <scheduler+0x84>
      acquire(&p->lock);
    80002598:	8526                	mv	a0,s1
    8000259a:	e8efe0ef          	jal	80000c28 <acquire>
      if(p->state == RUNNABLE) {
    8000259e:	4c9c                	lw	a5,24(s1)
    800025a0:	ff3792e3          	bne	a5,s3,80002584 <scheduler+0x4a>
        p->state = RUNNING;
    800025a4:	0184ac23          	sw	s8,24(s1)
        c->proc = p;
    800025a8:	029a3823          	sd	s1,48(s4)
        swtch(&c->context, &p->context);
    800025ac:	06048593          	addi	a1,s1,96
    800025b0:	855a                	mv	a0,s6
    800025b2:	624000ef          	jal	80002bd6 <swtch>
        c->proc = 0;
    800025b6:	020a3823          	sd	zero,48(s4)
        found = 1;
    800025ba:	8ade                	mv	s5,s7
    800025bc:	b7e1                	j	80002584 <scheduler+0x4a>
    if(found == 0) {
    800025be:	000a9463          	bnez	s5,800025c6 <scheduler+0x8c>
      asm volatile("wfi");
    800025c2:	10500073          	wfi
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800025c6:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    800025ca:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    800025ce:	10079073          	csrw	sstatus,a5
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800025d2:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    800025d6:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    800025d8:	10079073          	csrw	sstatus,a5
    int found = 0;
    800025dc:	4a81                	li	s5,0
    for(p = proc; p < &proc[NPROC]; p++) {
    800025de:	00011497          	auipc	s1,0x11
    800025e2:	7ea48493          	addi	s1,s1,2026 # 80013dc8 <proc>
      if(p->state == RUNNABLE) {
    800025e6:	498d                	li	s3,3
    for(p = proc; p < &proc[NPROC]; p++) {
    800025e8:	00089937          	lui	s2,0x89
    800025ec:	57090913          	addi	s2,s2,1392 # 89570 <_entry-0x7ff76a90>
    800025f0:	b765                	j	80002598 <scheduler+0x5e>

00000000800025f2 <sched>:
{
    800025f2:	7179                	addi	sp,sp,-48
    800025f4:	f406                	sd	ra,40(sp)
    800025f6:	f022                	sd	s0,32(sp)
    800025f8:	ec26                	sd	s1,24(sp)
    800025fa:	e84a                	sd	s2,16(sp)
    800025fc:	e44e                	sd	s3,8(sp)
    800025fe:	1800                	addi	s0,sp,48
  struct proc *p = myproc();
    80002600:	9b9ff0ef          	jal	80001fb8 <myproc>
    80002604:	84aa                	mv	s1,a0
  if(!holding(&p->lock))
    80002606:	db2fe0ef          	jal	80000bb8 <holding>
    8000260a:	c935                	beqz	a0,8000267e <sched+0x8c>
  asm volatile("mv %0, tp" : "=r" (x) );
    8000260c:	8792                	mv	a5,tp
  if(mycpu()->noff != 1)
    8000260e:	2781                	sext.w	a5,a5
    80002610:	079e                	slli	a5,a5,0x7
    80002612:	00011717          	auipc	a4,0x11
    80002616:	38670713          	addi	a4,a4,902 # 80013998 <pid_lock>
    8000261a:	97ba                	add	a5,a5,a4
    8000261c:	0a87a703          	lw	a4,168(a5)
    80002620:	4785                	li	a5,1
    80002622:	06f71463          	bne	a4,a5,8000268a <sched+0x98>
  if(p->state == RUNNING)
    80002626:	4c98                	lw	a4,24(s1)
    80002628:	4791                	li	a5,4
    8000262a:	06f70663          	beq	a4,a5,80002696 <sched+0xa4>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    8000262e:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80002632:	8b89                	andi	a5,a5,2
  if(intr_get())
    80002634:	e7bd                	bnez	a5,800026a2 <sched+0xb0>
  asm volatile("mv %0, tp" : "=r" (x) );
    80002636:	8792                	mv	a5,tp
  intena = mycpu()->intena;
    80002638:	00011917          	auipc	s2,0x11
    8000263c:	36090913          	addi	s2,s2,864 # 80013998 <pid_lock>
    80002640:	2781                	sext.w	a5,a5
    80002642:	079e                	slli	a5,a5,0x7
    80002644:	97ca                	add	a5,a5,s2
    80002646:	0ac7a983          	lw	s3,172(a5)
    8000264a:	8792                	mv	a5,tp
  swtch(&p->context, &mycpu()->context);
    8000264c:	2781                	sext.w	a5,a5
    8000264e:	079e                	slli	a5,a5,0x7
    80002650:	07a1                	addi	a5,a5,8
    80002652:	00011597          	auipc	a1,0x11
    80002656:	37658593          	addi	a1,a1,886 # 800139c8 <cpus>
    8000265a:	95be                	add	a1,a1,a5
    8000265c:	06048513          	addi	a0,s1,96
    80002660:	576000ef          	jal	80002bd6 <swtch>
    80002664:	8792                	mv	a5,tp
  mycpu()->intena = intena;
    80002666:	2781                	sext.w	a5,a5
    80002668:	079e                	slli	a5,a5,0x7
    8000266a:	993e                	add	s2,s2,a5
    8000266c:	0b392623          	sw	s3,172(s2)
}
    80002670:	70a2                	ld	ra,40(sp)
    80002672:	7402                	ld	s0,32(sp)
    80002674:	64e2                	ld	s1,24(sp)
    80002676:	6942                	ld	s2,16(sp)
    80002678:	69a2                	ld	s3,8(sp)
    8000267a:	6145                	addi	sp,sp,48
    8000267c:	8082                	ret
    panic("sched p->lock");
    8000267e:	00006517          	auipc	a0,0x6
    80002682:	db250513          	addi	a0,a0,-590 # 80008430 <etext+0x430>
    80002686:	99efe0ef          	jal	80000824 <panic>
    panic("sched locks");
    8000268a:	00006517          	auipc	a0,0x6
    8000268e:	db650513          	addi	a0,a0,-586 # 80008440 <etext+0x440>
    80002692:	992fe0ef          	jal	80000824 <panic>
    panic("sched RUNNING");
    80002696:	00006517          	auipc	a0,0x6
    8000269a:	dba50513          	addi	a0,a0,-582 # 80008450 <etext+0x450>
    8000269e:	986fe0ef          	jal	80000824 <panic>
    panic("sched interruptible");
    800026a2:	00006517          	auipc	a0,0x6
    800026a6:	dbe50513          	addi	a0,a0,-578 # 80008460 <etext+0x460>
    800026aa:	97afe0ef          	jal	80000824 <panic>

00000000800026ae <yield>:
{
    800026ae:	1101                	addi	sp,sp,-32
    800026b0:	ec06                	sd	ra,24(sp)
    800026b2:	e822                	sd	s0,16(sp)
    800026b4:	e426                	sd	s1,8(sp)
    800026b6:	1000                	addi	s0,sp,32
  struct proc *p = myproc();
    800026b8:	901ff0ef          	jal	80001fb8 <myproc>
    800026bc:	84aa                	mv	s1,a0
  acquire(&p->lock);
    800026be:	d6afe0ef          	jal	80000c28 <acquire>
  p->state = RUNNABLE;
    800026c2:	478d                	li	a5,3
    800026c4:	cc9c                	sw	a5,24(s1)
  sched();
    800026c6:	f2dff0ef          	jal	800025f2 <sched>
  release(&p->lock);
    800026ca:	8526                	mv	a0,s1
    800026cc:	df0fe0ef          	jal	80000cbc <release>
}
    800026d0:	60e2                	ld	ra,24(sp)
    800026d2:	6442                	ld	s0,16(sp)
    800026d4:	64a2                	ld	s1,8(sp)
    800026d6:	6105                	addi	sp,sp,32
    800026d8:	8082                	ret

00000000800026da <sleep>:

// Sleep on channel chan, releasing condition lock lk.
// Re-acquires lk when awakened.
void
sleep(void *chan, struct spinlock *lk)
{
    800026da:	7179                	addi	sp,sp,-48
    800026dc:	f406                	sd	ra,40(sp)
    800026de:	f022                	sd	s0,32(sp)
    800026e0:	ec26                	sd	s1,24(sp)
    800026e2:	e84a                	sd	s2,16(sp)
    800026e4:	e44e                	sd	s3,8(sp)
    800026e6:	1800                	addi	s0,sp,48
    800026e8:	89aa                	mv	s3,a0
    800026ea:	892e                	mv	s2,a1
  struct proc *p = myproc();
    800026ec:	8cdff0ef          	jal	80001fb8 <myproc>
    800026f0:	84aa                	mv	s1,a0
  // Once we hold p->lock, we can be
  // guaranteed that we won't miss any wakeup
  // (wakeup locks p->lock),
  // so it's okay to release lk.

  acquire(&p->lock);  //DOC: sleeplock1
    800026f2:	d36fe0ef          	jal	80000c28 <acquire>
  release(lk);
    800026f6:	854a                	mv	a0,s2
    800026f8:	dc4fe0ef          	jal	80000cbc <release>

  // Go to sleep.
  p->chan = chan;
    800026fc:	0334b023          	sd	s3,32(s1)
  p->state = SLEEPING;
    80002700:	4789                	li	a5,2
    80002702:	cc9c                	sw	a5,24(s1)

  sched();
    80002704:	eefff0ef          	jal	800025f2 <sched>

  // Tidy up.
  p->chan = 0;
    80002708:	0204b023          	sd	zero,32(s1)

  // Reacquire original lock.
  release(&p->lock);
    8000270c:	8526                	mv	a0,s1
    8000270e:	daefe0ef          	jal	80000cbc <release>
  acquire(lk);
    80002712:	854a                	mv	a0,s2
    80002714:	d14fe0ef          	jal	80000c28 <acquire>
}
    80002718:	70a2                	ld	ra,40(sp)
    8000271a:	7402                	ld	s0,32(sp)
    8000271c:	64e2                	ld	s1,24(sp)
    8000271e:	6942                	ld	s2,16(sp)
    80002720:	69a2                	ld	s3,8(sp)
    80002722:	6145                	addi	sp,sp,48
    80002724:	8082                	ret

0000000080002726 <wakeup>:

// Wake up all processes sleeping on channel chan.
// Caller should hold the condition lock.
void
wakeup(void *chan)
{
    80002726:	7139                	addi	sp,sp,-64
    80002728:	fc06                	sd	ra,56(sp)
    8000272a:	f822                	sd	s0,48(sp)
    8000272c:	f426                	sd	s1,40(sp)
    8000272e:	f04a                	sd	s2,32(sp)
    80002730:	ec4e                	sd	s3,24(sp)
    80002732:	e852                	sd	s4,16(sp)
    80002734:	e456                	sd	s5,8(sp)
    80002736:	e05a                	sd	s6,0(sp)
    80002738:	0080                	addi	s0,sp,64
    8000273a:	8aaa                	mv	s5,a0
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++) {
    8000273c:	00011497          	auipc	s1,0x11
    80002740:	68c48493          	addi	s1,s1,1676 # 80013dc8 <proc>
    if(p != myproc()){
      acquire(&p->lock);
      if(p->state == SLEEPING && p->chan == chan) {
    80002744:	4a09                	li	s4,2
        p->state = RUNNABLE;
    80002746:	4b0d                	li	s6,3
  for(p = proc; p < &proc[NPROC]; p++) {
    80002748:	00089937          	lui	s2,0x89
    8000274c:	57090913          	addi	s2,s2,1392 # 89570 <_entry-0x7ff76a90>
    80002750:	02267997          	auipc	s3,0x2267
    80002754:	27898993          	addi	s3,s3,632 # 822699c8 <tickslock>
    80002758:	a039                	j	80002766 <wakeup+0x40>
      }
      release(&p->lock);
    8000275a:	8526                	mv	a0,s1
    8000275c:	d60fe0ef          	jal	80000cbc <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    80002760:	94ca                	add	s1,s1,s2
    80002762:	03348263          	beq	s1,s3,80002786 <wakeup+0x60>
    if(p != myproc()){
    80002766:	853ff0ef          	jal	80001fb8 <myproc>
    8000276a:	fe950be3          	beq	a0,s1,80002760 <wakeup+0x3a>
      acquire(&p->lock);
    8000276e:	8526                	mv	a0,s1
    80002770:	cb8fe0ef          	jal	80000c28 <acquire>
      if(p->state == SLEEPING && p->chan == chan) {
    80002774:	4c9c                	lw	a5,24(s1)
    80002776:	ff4792e3          	bne	a5,s4,8000275a <wakeup+0x34>
    8000277a:	709c                	ld	a5,32(s1)
    8000277c:	fd579fe3          	bne	a5,s5,8000275a <wakeup+0x34>
        p->state = RUNNABLE;
    80002780:	0164ac23          	sw	s6,24(s1)
    80002784:	bfd9                	j	8000275a <wakeup+0x34>
    }
  }
}
    80002786:	70e2                	ld	ra,56(sp)
    80002788:	7442                	ld	s0,48(sp)
    8000278a:	74a2                	ld	s1,40(sp)
    8000278c:	7902                	ld	s2,32(sp)
    8000278e:	69e2                	ld	s3,24(sp)
    80002790:	6a42                	ld	s4,16(sp)
    80002792:	6aa2                	ld	s5,8(sp)
    80002794:	6b02                	ld	s6,0(sp)
    80002796:	6121                	addi	sp,sp,64
    80002798:	8082                	ret

000000008000279a <reparent>:
{
    8000279a:	7139                	addi	sp,sp,-64
    8000279c:	fc06                	sd	ra,56(sp)
    8000279e:	f822                	sd	s0,48(sp)
    800027a0:	f426                	sd	s1,40(sp)
    800027a2:	f04a                	sd	s2,32(sp)
    800027a4:	ec4e                	sd	s3,24(sp)
    800027a6:	e852                	sd	s4,16(sp)
    800027a8:	e456                	sd	s5,8(sp)
    800027aa:	0080                	addi	s0,sp,64
    800027ac:	89aa                	mv	s3,a0
  for(pp = proc; pp < &proc[NPROC]; pp++){
    800027ae:	00011497          	auipc	s1,0x11
    800027b2:	61a48493          	addi	s1,s1,1562 # 80013dc8 <proc>
      pp->parent = initproc;
    800027b6:	00009a97          	auipc	s5,0x9
    800027ba:	0daa8a93          	addi	s5,s5,218 # 8000b890 <initproc>
  for(pp = proc; pp < &proc[NPROC]; pp++){
    800027be:	00089937          	lui	s2,0x89
    800027c2:	57090913          	addi	s2,s2,1392 # 89570 <_entry-0x7ff76a90>
    800027c6:	02267a17          	auipc	s4,0x2267
    800027ca:	202a0a13          	addi	s4,s4,514 # 822699c8 <tickslock>
    800027ce:	a021                	j	800027d6 <reparent+0x3c>
    800027d0:	94ca                	add	s1,s1,s2
    800027d2:	01448b63          	beq	s1,s4,800027e8 <reparent+0x4e>
    if(pp->parent == p){
    800027d6:	7c9c                	ld	a5,56(s1)
    800027d8:	ff379ce3          	bne	a5,s3,800027d0 <reparent+0x36>
      pp->parent = initproc;
    800027dc:	000ab503          	ld	a0,0(s5)
    800027e0:	fc88                	sd	a0,56(s1)
      wakeup(initproc);
    800027e2:	f45ff0ef          	jal	80002726 <wakeup>
    800027e6:	b7ed                	j	800027d0 <reparent+0x36>
}
    800027e8:	70e2                	ld	ra,56(sp)
    800027ea:	7442                	ld	s0,48(sp)
    800027ec:	74a2                	ld	s1,40(sp)
    800027ee:	7902                	ld	s2,32(sp)
    800027f0:	69e2                	ld	s3,24(sp)
    800027f2:	6a42                	ld	s4,16(sp)
    800027f4:	6aa2                	ld	s5,8(sp)
    800027f6:	6121                	addi	sp,sp,64
    800027f8:	8082                	ret

00000000800027fa <kexit>:
{
    800027fa:	7179                	addi	sp,sp,-48
    800027fc:	f406                	sd	ra,40(sp)
    800027fe:	f022                	sd	s0,32(sp)
    80002800:	ec26                	sd	s1,24(sp)
    80002802:	e84a                	sd	s2,16(sp)
    80002804:	e44e                	sd	s3,8(sp)
    80002806:	e052                	sd	s4,0(sp)
    80002808:	1800                	addi	s0,sp,48
    8000280a:	8a2a                	mv	s4,a0
  struct proc *p = myproc();
    8000280c:	facff0ef          	jal	80001fb8 <myproc>
    80002810:	892a                	mv	s2,a0
  if(p == initproc)
    80002812:	00009797          	auipc	a5,0x9
    80002816:	07e7b783          	ld	a5,126(a5) # 8000b890 <initproc>
    8000281a:	0d050493          	addi	s1,a0,208
    8000281e:	15050993          	addi	s3,a0,336
    80002822:	00a79b63          	bne	a5,a0,80002838 <kexit+0x3e>
    panic("init exiting");
    80002826:	00006517          	auipc	a0,0x6
    8000282a:	c5250513          	addi	a0,a0,-942 # 80008478 <etext+0x478>
    8000282e:	ff7fd0ef          	jal	80000824 <panic>
  for(int fd = 0; fd < NOFILE; fd++){
    80002832:	04a1                	addi	s1,s1,8
    80002834:	01348963          	beq	s1,s3,80002846 <kexit+0x4c>
    if(p->ofile[fd]){
    80002838:	6088                	ld	a0,0(s1)
    8000283a:	dd65                	beqz	a0,80002832 <kexit+0x38>
      fileclose(f);
    8000283c:	2d0020ef          	jal	80004b0c <fileclose>
      p->ofile[fd] = 0;
    80002840:	0004b023          	sd	zero,0(s1)
    80002844:	b7fd                	j	80002832 <kexit+0x38>
  if(p->swap_file){
    80002846:	17893783          	ld	a5,376(s2)
    8000284a:	cf8d                	beqz	a5,80002884 <kexit+0x8a>
    printf("[pid %d] SWAPCLEANUP freed_slots=%d\n", p->pid, p->num_swappped_pages);
    8000284c:	000897b7          	lui	a5,0x89
    80002850:	97ca                	add	a5,a5,s2
    80002852:	1cc7a603          	lw	a2,460(a5) # 891cc <_entry-0x7ff76e34>
    80002856:	03092583          	lw	a1,48(s2)
    8000285a:	00006517          	auipc	a0,0x6
    8000285e:	c2e50513          	addi	a0,a0,-978 # 80008488 <etext+0x488>
    80002862:	c99fd0ef          	jal	800004fa <printf>
    begin_op(); // Start a file system transaction.
    80002866:	683010ef          	jal	800046e8 <begin_op>
    itrunc(p->swap_file->ip);
    8000286a:	17893783          	ld	a5,376(s2)
    8000286e:	6f88                	ld	a0,24(a5)
    80002870:	55a010ef          	jal	80003dca <itrunc>
    fileclose(p->swap_file);
    80002874:	17893503          	ld	a0,376(s2)
    80002878:	294020ef          	jal	80004b0c <fileclose>
    p->swap_file = 0; // Clear the pointer.
    8000287c:	16093c23          	sd	zero,376(s2)
    end_op(); // End the transaction.
    80002880:	6d9010ef          	jal	80004758 <end_op>
  begin_op();
    80002884:	665010ef          	jal	800046e8 <begin_op>
  iput(p->cwd);
    80002888:	15093503          	ld	a0,336(s2)
    8000288c:	5d2010ef          	jal	80003e5e <iput>
  end_op();
    80002890:	6c9010ef          	jal	80004758 <end_op>
  p->cwd = 0;
    80002894:	14093823          	sd	zero,336(s2)
  acquire(&wait_lock);
    80002898:	00011517          	auipc	a0,0x11
    8000289c:	11850513          	addi	a0,a0,280 # 800139b0 <wait_lock>
    800028a0:	b88fe0ef          	jal	80000c28 <acquire>
  reparent(p);
    800028a4:	854a                	mv	a0,s2
    800028a6:	ef5ff0ef          	jal	8000279a <reparent>
  wakeup(p->parent);
    800028aa:	03893503          	ld	a0,56(s2)
    800028ae:	e79ff0ef          	jal	80002726 <wakeup>
  acquire(&p->lock);
    800028b2:	854a                	mv	a0,s2
    800028b4:	b74fe0ef          	jal	80000c28 <acquire>
  p->xstate = status;
    800028b8:	03492623          	sw	s4,44(s2)
  p->state = ZOMBIE;
    800028bc:	4795                	li	a5,5
    800028be:	00f92c23          	sw	a5,24(s2)
  release(&wait_lock);
    800028c2:	00011517          	auipc	a0,0x11
    800028c6:	0ee50513          	addi	a0,a0,238 # 800139b0 <wait_lock>
    800028ca:	bf2fe0ef          	jal	80000cbc <release>
  sched();
    800028ce:	d25ff0ef          	jal	800025f2 <sched>
  panic("zombie exit");
    800028d2:	00006517          	auipc	a0,0x6
    800028d6:	bde50513          	addi	a0,a0,-1058 # 800084b0 <etext+0x4b0>
    800028da:	f4bfd0ef          	jal	80000824 <panic>

00000000800028de <kkill>:
// Kill the process with the given pid.
// The victim won't exit until it tries to return
// to user space (see usertrap() in trap.c).
int
kkill(int pid)
{
    800028de:	7179                	addi	sp,sp,-48
    800028e0:	f406                	sd	ra,40(sp)
    800028e2:	f022                	sd	s0,32(sp)
    800028e4:	ec26                	sd	s1,24(sp)
    800028e6:	e84a                	sd	s2,16(sp)
    800028e8:	e44e                	sd	s3,8(sp)
    800028ea:	e052                	sd	s4,0(sp)
    800028ec:	1800                	addi	s0,sp,48
    800028ee:	892a                	mv	s2,a0
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++){
    800028f0:	00011497          	auipc	s1,0x11
    800028f4:	4d848493          	addi	s1,s1,1240 # 80013dc8 <proc>
    800028f8:	000899b7          	lui	s3,0x89
    800028fc:	57098993          	addi	s3,s3,1392 # 89570 <_entry-0x7ff76a90>
    80002900:	02267a17          	auipc	s4,0x2267
    80002904:	0c8a0a13          	addi	s4,s4,200 # 822699c8 <tickslock>
    acquire(&p->lock);
    80002908:	8526                	mv	a0,s1
    8000290a:	b1efe0ef          	jal	80000c28 <acquire>
    if(p->pid == pid){
    8000290e:	589c                	lw	a5,48(s1)
    80002910:	01278a63          	beq	a5,s2,80002924 <kkill+0x46>
        p->state = RUNNABLE;
      }
      release(&p->lock);
      return 0;
    }
    release(&p->lock);
    80002914:	8526                	mv	a0,s1
    80002916:	ba6fe0ef          	jal	80000cbc <release>
  for(p = proc; p < &proc[NPROC]; p++){
    8000291a:	94ce                	add	s1,s1,s3
    8000291c:	ff4496e3          	bne	s1,s4,80002908 <kkill+0x2a>
  }
  return -1;
    80002920:	557d                	li	a0,-1
    80002922:	a819                	j	80002938 <kkill+0x5a>
      p->killed = 1;
    80002924:	4785                	li	a5,1
    80002926:	d49c                	sw	a5,40(s1)
      if(p->state == SLEEPING){
    80002928:	4c98                	lw	a4,24(s1)
    8000292a:	4789                	li	a5,2
    8000292c:	00f70e63          	beq	a4,a5,80002948 <kkill+0x6a>
      release(&p->lock);
    80002930:	8526                	mv	a0,s1
    80002932:	b8afe0ef          	jal	80000cbc <release>
      return 0;
    80002936:	4501                	li	a0,0
}
    80002938:	70a2                	ld	ra,40(sp)
    8000293a:	7402                	ld	s0,32(sp)
    8000293c:	64e2                	ld	s1,24(sp)
    8000293e:	6942                	ld	s2,16(sp)
    80002940:	69a2                	ld	s3,8(sp)
    80002942:	6a02                	ld	s4,0(sp)
    80002944:	6145                	addi	sp,sp,48
    80002946:	8082                	ret
        p->state = RUNNABLE;
    80002948:	478d                	li	a5,3
    8000294a:	cc9c                	sw	a5,24(s1)
    8000294c:	b7d5                	j	80002930 <kkill+0x52>

000000008000294e <setkilled>:

void
setkilled(struct proc *p)
{
    8000294e:	1101                	addi	sp,sp,-32
    80002950:	ec06                	sd	ra,24(sp)
    80002952:	e822                	sd	s0,16(sp)
    80002954:	e426                	sd	s1,8(sp)
    80002956:	1000                	addi	s0,sp,32
    80002958:	84aa                	mv	s1,a0
  acquire(&p->lock);
    8000295a:	acefe0ef          	jal	80000c28 <acquire>
  p->killed = 1;
    8000295e:	4785                	li	a5,1
    80002960:	d49c                	sw	a5,40(s1)
  release(&p->lock);
    80002962:	8526                	mv	a0,s1
    80002964:	b58fe0ef          	jal	80000cbc <release>
}
    80002968:	60e2                	ld	ra,24(sp)
    8000296a:	6442                	ld	s0,16(sp)
    8000296c:	64a2                	ld	s1,8(sp)
    8000296e:	6105                	addi	sp,sp,32
    80002970:	8082                	ret

0000000080002972 <killed>:

int
killed(struct proc *p)
{
    80002972:	1101                	addi	sp,sp,-32
    80002974:	ec06                	sd	ra,24(sp)
    80002976:	e822                	sd	s0,16(sp)
    80002978:	e426                	sd	s1,8(sp)
    8000297a:	e04a                	sd	s2,0(sp)
    8000297c:	1000                	addi	s0,sp,32
    8000297e:	84aa                	mv	s1,a0
  int k;
  
  acquire(&p->lock);
    80002980:	aa8fe0ef          	jal	80000c28 <acquire>
  k = p->killed;
    80002984:	549c                	lw	a5,40(s1)
    80002986:	893e                	mv	s2,a5
  release(&p->lock);
    80002988:	8526                	mv	a0,s1
    8000298a:	b32fe0ef          	jal	80000cbc <release>
  return k;
}
    8000298e:	854a                	mv	a0,s2
    80002990:	60e2                	ld	ra,24(sp)
    80002992:	6442                	ld	s0,16(sp)
    80002994:	64a2                	ld	s1,8(sp)
    80002996:	6902                	ld	s2,0(sp)
    80002998:	6105                	addi	sp,sp,32
    8000299a:	8082                	ret

000000008000299c <kwait>:
{
    8000299c:	715d                	addi	sp,sp,-80
    8000299e:	e486                	sd	ra,72(sp)
    800029a0:	e0a2                	sd	s0,64(sp)
    800029a2:	fc26                	sd	s1,56(sp)
    800029a4:	f84a                	sd	s2,48(sp)
    800029a6:	f44e                	sd	s3,40(sp)
    800029a8:	f052                	sd	s4,32(sp)
    800029aa:	ec56                	sd	s5,24(sp)
    800029ac:	e85a                	sd	s6,16(sp)
    800029ae:	e45e                	sd	s7,8(sp)
    800029b0:	0880                	addi	s0,sp,80
    800029b2:	8baa                	mv	s7,a0
  struct proc *p = myproc();
    800029b4:	e04ff0ef          	jal	80001fb8 <myproc>
    800029b8:	892a                	mv	s2,a0
  acquire(&wait_lock);
    800029ba:	00011517          	auipc	a0,0x11
    800029be:	ff650513          	addi	a0,a0,-10 # 800139b0 <wait_lock>
    800029c2:	a66fe0ef          	jal	80000c28 <acquire>
        if(pp->state == ZOMBIE){
    800029c6:	4a95                	li	s5,5
        havekids = 1;
    800029c8:	4b05                	li	s6,1
    for(pp = proc; pp < &proc[NPROC]; pp++){
    800029ca:	000899b7          	lui	s3,0x89
    800029ce:	57098993          	addi	s3,s3,1392 # 89570 <_entry-0x7ff76a90>
    800029d2:	02267a17          	auipc	s4,0x2267
    800029d6:	ff6a0a13          	addi	s4,s4,-10 # 822699c8 <tickslock>
    800029da:	a879                	j	80002a78 <kwait+0xdc>
          pid = pp->pid;
    800029dc:	0304a983          	lw	s3,48(s1)
          if(addr != 0 && copyout(p->pagetable, addr, (char *)&pp->xstate,
    800029e0:	000b8c63          	beqz	s7,800029f8 <kwait+0x5c>
    800029e4:	4691                	li	a3,4
    800029e6:	02c48613          	addi	a2,s1,44
    800029ea:	85de                	mv	a1,s7
    800029ec:	05093503          	ld	a0,80(s2)
    800029f0:	898ff0ef          	jal	80001a88 <copyout>
    800029f4:	02054a63          	bltz	a0,80002a28 <kwait+0x8c>
          freeproc(pp);
    800029f8:	8526                	mv	a0,s1
    800029fa:	f92ff0ef          	jal	8000218c <freeproc>
          release(&pp->lock);
    800029fe:	8526                	mv	a0,s1
    80002a00:	abcfe0ef          	jal	80000cbc <release>
          release(&wait_lock);
    80002a04:	00011517          	auipc	a0,0x11
    80002a08:	fac50513          	addi	a0,a0,-84 # 800139b0 <wait_lock>
    80002a0c:	ab0fe0ef          	jal	80000cbc <release>
}
    80002a10:	854e                	mv	a0,s3
    80002a12:	60a6                	ld	ra,72(sp)
    80002a14:	6406                	ld	s0,64(sp)
    80002a16:	74e2                	ld	s1,56(sp)
    80002a18:	7942                	ld	s2,48(sp)
    80002a1a:	79a2                	ld	s3,40(sp)
    80002a1c:	7a02                	ld	s4,32(sp)
    80002a1e:	6ae2                	ld	s5,24(sp)
    80002a20:	6b42                	ld	s6,16(sp)
    80002a22:	6ba2                	ld	s7,8(sp)
    80002a24:	6161                	addi	sp,sp,80
    80002a26:	8082                	ret
            release(&pp->lock);
    80002a28:	8526                	mv	a0,s1
    80002a2a:	a92fe0ef          	jal	80000cbc <release>
            release(&wait_lock);
    80002a2e:	00011517          	auipc	a0,0x11
    80002a32:	f8250513          	addi	a0,a0,-126 # 800139b0 <wait_lock>
    80002a36:	a86fe0ef          	jal	80000cbc <release>
            return -1;
    80002a3a:	59fd                	li	s3,-1
    80002a3c:	bfd1                	j	80002a10 <kwait+0x74>
    for(pp = proc; pp < &proc[NPROC]; pp++){
    80002a3e:	94ce                	add	s1,s1,s3
    80002a40:	03448063          	beq	s1,s4,80002a60 <kwait+0xc4>
      if(pp->parent == p){
    80002a44:	7c9c                	ld	a5,56(s1)
    80002a46:	ff279ce3          	bne	a5,s2,80002a3e <kwait+0xa2>
        acquire(&pp->lock);
    80002a4a:	8526                	mv	a0,s1
    80002a4c:	9dcfe0ef          	jal	80000c28 <acquire>
        if(pp->state == ZOMBIE){
    80002a50:	4c9c                	lw	a5,24(s1)
    80002a52:	f95785e3          	beq	a5,s5,800029dc <kwait+0x40>
        release(&pp->lock);
    80002a56:	8526                	mv	a0,s1
    80002a58:	a64fe0ef          	jal	80000cbc <release>
        havekids = 1;
    80002a5c:	875a                	mv	a4,s6
    80002a5e:	b7c5                	j	80002a3e <kwait+0xa2>
    if(!havekids || killed(p)){
    80002a60:	c315                	beqz	a4,80002a84 <kwait+0xe8>
    80002a62:	854a                	mv	a0,s2
    80002a64:	f0fff0ef          	jal	80002972 <killed>
    80002a68:	ed11                	bnez	a0,80002a84 <kwait+0xe8>
    sleep(p, &wait_lock);  //DOC: wait-sleep
    80002a6a:	00011597          	auipc	a1,0x11
    80002a6e:	f4658593          	addi	a1,a1,-186 # 800139b0 <wait_lock>
    80002a72:	854a                	mv	a0,s2
    80002a74:	c67ff0ef          	jal	800026da <sleep>
    havekids = 0;
    80002a78:	4701                	li	a4,0
    for(pp = proc; pp < &proc[NPROC]; pp++){
    80002a7a:	00011497          	auipc	s1,0x11
    80002a7e:	34e48493          	addi	s1,s1,846 # 80013dc8 <proc>
    80002a82:	b7c9                	j	80002a44 <kwait+0xa8>
      release(&wait_lock);
    80002a84:	00011517          	auipc	a0,0x11
    80002a88:	f2c50513          	addi	a0,a0,-212 # 800139b0 <wait_lock>
    80002a8c:	a30fe0ef          	jal	80000cbc <release>
      return -1;
    80002a90:	59fd                	li	s3,-1
    80002a92:	bfbd                	j	80002a10 <kwait+0x74>

0000000080002a94 <either_copyout>:
// Copy to either a user address, or kernel address,
// depending on usr_dst.
// Returns 0 on success, -1 on error.
int
either_copyout(int user_dst, uint64 dst, void *src, uint64 len)
{
    80002a94:	7179                	addi	sp,sp,-48
    80002a96:	f406                	sd	ra,40(sp)
    80002a98:	f022                	sd	s0,32(sp)
    80002a9a:	ec26                	sd	s1,24(sp)
    80002a9c:	e84a                	sd	s2,16(sp)
    80002a9e:	e44e                	sd	s3,8(sp)
    80002aa0:	e052                	sd	s4,0(sp)
    80002aa2:	1800                	addi	s0,sp,48
    80002aa4:	84aa                	mv	s1,a0
    80002aa6:	8a2e                	mv	s4,a1
    80002aa8:	89b2                	mv	s3,a2
    80002aaa:	8936                	mv	s2,a3
  struct proc *p = myproc();
    80002aac:	d0cff0ef          	jal	80001fb8 <myproc>
  if(user_dst){
    80002ab0:	cc99                	beqz	s1,80002ace <either_copyout+0x3a>
    return copyout(p->pagetable, dst, src, len);
    80002ab2:	86ca                	mv	a3,s2
    80002ab4:	864e                	mv	a2,s3
    80002ab6:	85d2                	mv	a1,s4
    80002ab8:	6928                	ld	a0,80(a0)
    80002aba:	fcffe0ef          	jal	80001a88 <copyout>
  } else {
    memmove((char *)dst, src, len);
    return 0;
  }
}
    80002abe:	70a2                	ld	ra,40(sp)
    80002ac0:	7402                	ld	s0,32(sp)
    80002ac2:	64e2                	ld	s1,24(sp)
    80002ac4:	6942                	ld	s2,16(sp)
    80002ac6:	69a2                	ld	s3,8(sp)
    80002ac8:	6a02                	ld	s4,0(sp)
    80002aca:	6145                	addi	sp,sp,48
    80002acc:	8082                	ret
    memmove((char *)dst, src, len);
    80002ace:	0009061b          	sext.w	a2,s2
    80002ad2:	85ce                	mv	a1,s3
    80002ad4:	8552                	mv	a0,s4
    80002ad6:	a82fe0ef          	jal	80000d58 <memmove>
    return 0;
    80002ada:	8526                	mv	a0,s1
    80002adc:	b7cd                	j	80002abe <either_copyout+0x2a>

0000000080002ade <either_copyin>:
// Copy from either a user address, or kernel address,
// depending on usr_src.
// Returns 0 on success, -1 on error.
int
either_copyin(void *dst, int user_src, uint64 src, uint64 len)
{
    80002ade:	7179                	addi	sp,sp,-48
    80002ae0:	f406                	sd	ra,40(sp)
    80002ae2:	f022                	sd	s0,32(sp)
    80002ae4:	ec26                	sd	s1,24(sp)
    80002ae6:	e84a                	sd	s2,16(sp)
    80002ae8:	e44e                	sd	s3,8(sp)
    80002aea:	e052                	sd	s4,0(sp)
    80002aec:	1800                	addi	s0,sp,48
    80002aee:	8a2a                	mv	s4,a0
    80002af0:	84ae                	mv	s1,a1
    80002af2:	89b2                	mv	s3,a2
    80002af4:	8936                	mv	s2,a3
  struct proc *p = myproc();
    80002af6:	cc2ff0ef          	jal	80001fb8 <myproc>
  if(user_src){
    80002afa:	cc99                	beqz	s1,80002b18 <either_copyin+0x3a>
    return copyin(p->pagetable, dst, src, len);
    80002afc:	86ca                	mv	a3,s2
    80002afe:	864e                	mv	a2,s3
    80002b00:	85d2                	mv	a1,s4
    80002b02:	6928                	ld	a0,80(a0)
    80002b04:	8d6ff0ef          	jal	80001bda <copyin>
  } else {
    memmove(dst, (char*)src, len);
    return 0;
  }
}
    80002b08:	70a2                	ld	ra,40(sp)
    80002b0a:	7402                	ld	s0,32(sp)
    80002b0c:	64e2                	ld	s1,24(sp)
    80002b0e:	6942                	ld	s2,16(sp)
    80002b10:	69a2                	ld	s3,8(sp)
    80002b12:	6a02                	ld	s4,0(sp)
    80002b14:	6145                	addi	sp,sp,48
    80002b16:	8082                	ret
    memmove(dst, (char*)src, len);
    80002b18:	0009061b          	sext.w	a2,s2
    80002b1c:	85ce                	mv	a1,s3
    80002b1e:	8552                	mv	a0,s4
    80002b20:	a38fe0ef          	jal	80000d58 <memmove>
    return 0;
    80002b24:	8526                	mv	a0,s1
    80002b26:	b7cd                	j	80002b08 <either_copyin+0x2a>

0000000080002b28 <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
    80002b28:	715d                	addi	sp,sp,-80
    80002b2a:	e486                	sd	ra,72(sp)
    80002b2c:	e0a2                	sd	s0,64(sp)
    80002b2e:	fc26                	sd	s1,56(sp)
    80002b30:	f84a                	sd	s2,48(sp)
    80002b32:	f44e                	sd	s3,40(sp)
    80002b34:	f052                	sd	s4,32(sp)
    80002b36:	ec56                	sd	s5,24(sp)
    80002b38:	e85a                	sd	s6,16(sp)
    80002b3a:	e45e                	sd	s7,8(sp)
    80002b3c:	e062                	sd	s8,0(sp)
    80002b3e:	0880                	addi	s0,sp,80
  [ZOMBIE]    "zombie"
  };
  struct proc *p;
  char *state;

  printf("\n");
    80002b40:	00005517          	auipc	a0,0x5
    80002b44:	5f050513          	addi	a0,a0,1520 # 80008130 <etext+0x130>
    80002b48:	9b3fd0ef          	jal	800004fa <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    80002b4c:	00011497          	auipc	s1,0x11
    80002b50:	3d448493          	addi	s1,s1,980 # 80013f20 <proc+0x158>
    80002b54:	02267997          	auipc	s3,0x2267
    80002b58:	fcc98993          	addi	s3,s3,-52 # 82269b20 <bcache+0x140>
    if(p->state == UNUSED)
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80002b5c:	4b95                	li	s7,5
      state = states[p->state];
    else
      state = "???";
    80002b5e:	00006a17          	auipc	s4,0x6
    80002b62:	962a0a13          	addi	s4,s4,-1694 # 800084c0 <etext+0x4c0>
    printf("%d %s %s", p->pid, state, p->name);
    80002b66:	00006b17          	auipc	s6,0x6
    80002b6a:	962b0b13          	addi	s6,s6,-1694 # 800084c8 <etext+0x4c8>
    printf("\n");
    80002b6e:	00005a97          	auipc	s5,0x5
    80002b72:	5c2a8a93          	addi	s5,s5,1474 # 80008130 <etext+0x130>
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80002b76:	00006c17          	auipc	s8,0x6
    80002b7a:	f7ac0c13          	addi	s8,s8,-134 # 80008af0 <states.0>
  for(p = proc; p < &proc[NPROC]; p++){
    80002b7e:	00089937          	lui	s2,0x89
    80002b82:	57090913          	addi	s2,s2,1392 # 89570 <_entry-0x7ff76a90>
    80002b86:	a821                	j	80002b9e <procdump+0x76>
    printf("%d %s %s", p->pid, state, p->name);
    80002b88:	ed86a583          	lw	a1,-296(a3)
    80002b8c:	855a                	mv	a0,s6
    80002b8e:	96dfd0ef          	jal	800004fa <printf>
    printf("\n");
    80002b92:	8556                	mv	a0,s5
    80002b94:	967fd0ef          	jal	800004fa <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    80002b98:	94ca                	add	s1,s1,s2
    80002b9a:	03348263          	beq	s1,s3,80002bbe <procdump+0x96>
    if(p->state == UNUSED)
    80002b9e:	86a6                	mv	a3,s1
    80002ba0:	ec04a783          	lw	a5,-320(s1)
    80002ba4:	dbf5                	beqz	a5,80002b98 <procdump+0x70>
      state = "???";
    80002ba6:	8652                	mv	a2,s4
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80002ba8:	fefbe0e3          	bltu	s7,a5,80002b88 <procdump+0x60>
    80002bac:	02079713          	slli	a4,a5,0x20
    80002bb0:	01d75793          	srli	a5,a4,0x1d
    80002bb4:	97e2                	add	a5,a5,s8
    80002bb6:	6390                	ld	a2,0(a5)
    80002bb8:	fa61                	bnez	a2,80002b88 <procdump+0x60>
      state = "???";
    80002bba:	8652                	mv	a2,s4
    80002bbc:	b7f1                	j	80002b88 <procdump+0x60>
  }
}
    80002bbe:	60a6                	ld	ra,72(sp)
    80002bc0:	6406                	ld	s0,64(sp)
    80002bc2:	74e2                	ld	s1,56(sp)
    80002bc4:	7942                	ld	s2,48(sp)
    80002bc6:	79a2                	ld	s3,40(sp)
    80002bc8:	7a02                	ld	s4,32(sp)
    80002bca:	6ae2                	ld	s5,24(sp)
    80002bcc:	6b42                	ld	s6,16(sp)
    80002bce:	6ba2                	ld	s7,8(sp)
    80002bd0:	6c02                	ld	s8,0(sp)
    80002bd2:	6161                	addi	sp,sp,80
    80002bd4:	8082                	ret

0000000080002bd6 <swtch>:
# Save current registers in old. Load from new.	


.globl swtch
swtch:
        sd ra, 0(a0)
    80002bd6:	00153023          	sd	ra,0(a0)
        sd sp, 8(a0)
    80002bda:	00253423          	sd	sp,8(a0)
        sd s0, 16(a0)
    80002bde:	e900                	sd	s0,16(a0)
        sd s1, 24(a0)
    80002be0:	ed04                	sd	s1,24(a0)
        sd s2, 32(a0)
    80002be2:	03253023          	sd	s2,32(a0)
        sd s3, 40(a0)
    80002be6:	03353423          	sd	s3,40(a0)
        sd s4, 48(a0)
    80002bea:	03453823          	sd	s4,48(a0)
        sd s5, 56(a0)
    80002bee:	03553c23          	sd	s5,56(a0)
        sd s6, 64(a0)
    80002bf2:	05653023          	sd	s6,64(a0)
        sd s7, 72(a0)
    80002bf6:	05753423          	sd	s7,72(a0)
        sd s8, 80(a0)
    80002bfa:	05853823          	sd	s8,80(a0)
        sd s9, 88(a0)
    80002bfe:	05953c23          	sd	s9,88(a0)
        sd s10, 96(a0)
    80002c02:	07a53023          	sd	s10,96(a0)
        sd s11, 104(a0)
    80002c06:	07b53423          	sd	s11,104(a0)

        ld ra, 0(a1)
    80002c0a:	0005b083          	ld	ra,0(a1)
        ld sp, 8(a1)
    80002c0e:	0085b103          	ld	sp,8(a1)
        ld s0, 16(a1)
    80002c12:	6980                	ld	s0,16(a1)
        ld s1, 24(a1)
    80002c14:	6d84                	ld	s1,24(a1)
        ld s2, 32(a1)
    80002c16:	0205b903          	ld	s2,32(a1)
        ld s3, 40(a1)
    80002c1a:	0285b983          	ld	s3,40(a1)
        ld s4, 48(a1)
    80002c1e:	0305ba03          	ld	s4,48(a1)
        ld s5, 56(a1)
    80002c22:	0385ba83          	ld	s5,56(a1)
        ld s6, 64(a1)
    80002c26:	0405bb03          	ld	s6,64(a1)
        ld s7, 72(a1)
    80002c2a:	0485bb83          	ld	s7,72(a1)
        ld s8, 80(a1)
    80002c2e:	0505bc03          	ld	s8,80(a1)
        ld s9, 88(a1)
    80002c32:	0585bc83          	ld	s9,88(a1)
        ld s10, 96(a1)
    80002c36:	0605bd03          	ld	s10,96(a1)
        ld s11, 104(a1)
    80002c3a:	0685bd83          	ld	s11,104(a1)
        
        ret
    80002c3e:	8082                	ret

0000000080002c40 <trapinit>:

extern int devintr();

void
trapinit(void)
{
    80002c40:	1141                	addi	sp,sp,-16
    80002c42:	e406                	sd	ra,8(sp)
    80002c44:	e022                	sd	s0,0(sp)
    80002c46:	0800                	addi	s0,sp,16
  initlock(&tickslock, "time");
    80002c48:	00006597          	auipc	a1,0x6
    80002c4c:	8c058593          	addi	a1,a1,-1856 # 80008508 <etext+0x508>
    80002c50:	02267517          	auipc	a0,0x2267
    80002c54:	d7850513          	addi	a0,a0,-648 # 822699c8 <tickslock>
    80002c58:	f47fd0ef          	jal	80000b9e <initlock>
}
    80002c5c:	60a2                	ld	ra,8(sp)
    80002c5e:	6402                	ld	s0,0(sp)
    80002c60:	0141                	addi	sp,sp,16
    80002c62:	8082                	ret

0000000080002c64 <trapinithart>:

// set up to take exceptions and traps while in the kernel.
void
trapinithart(void)
{
    80002c64:	1141                	addi	sp,sp,-16
    80002c66:	e406                	sd	ra,8(sp)
    80002c68:	e022                	sd	s0,0(sp)
    80002c6a:	0800                	addi	s0,sp,16
  asm volatile("csrw stvec, %0" : : "r" (x));
    80002c6c:	00003797          	auipc	a5,0x3
    80002c70:	56478793          	addi	a5,a5,1380 # 800061d0 <kernelvec>
    80002c74:	10579073          	csrw	stvec,a5
    w_stvec((uint64)kernelvec);
}
    80002c78:	60a2                	ld	ra,8(sp)
    80002c7a:	6402                	ld	s0,0(sp)
    80002c7c:	0141                	addi	sp,sp,16
    80002c7e:	8082                	ret

0000000080002c80 <prepare_return>:
//
// set up trapframe and control registers for a return to user space
//
    void
prepare_return(void)
{
    80002c80:	1141                	addi	sp,sp,-16
    80002c82:	e406                	sd	ra,8(sp)
    80002c84:	e022                	sd	s0,0(sp)
    80002c86:	0800                	addi	s0,sp,16
    struct proc *p = myproc();
    80002c88:	b30ff0ef          	jal	80001fb8 <myproc>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80002c8c:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    80002c90:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80002c92:	10079073          	csrw	sstatus,a5
    // kerneltrap() to usertrap(). because a trap from kernel
    // code to usertrap would be a disaster, turn off interrupts.
    intr_off();

    // send syscalls, interrupts, and exceptions to uservec in trampoline.S
    uint64 trampoline_uservec = TRAMPOLINE + (uservec - trampoline);
    80002c96:	04000737          	lui	a4,0x4000
    80002c9a:	177d                	addi	a4,a4,-1 # 3ffffff <_entry-0x7c000001>
    80002c9c:	0732                	slli	a4,a4,0xc
    80002c9e:	00004797          	auipc	a5,0x4
    80002ca2:	36278793          	addi	a5,a5,866 # 80007000 <_trampoline>
    80002ca6:	00004697          	auipc	a3,0x4
    80002caa:	35a68693          	addi	a3,a3,858 # 80007000 <_trampoline>
    80002cae:	8f95                	sub	a5,a5,a3
    80002cb0:	97ba                	add	a5,a5,a4
  asm volatile("csrw stvec, %0" : : "r" (x));
    80002cb2:	10579073          	csrw	stvec,a5
    w_stvec(trampoline_uservec);

    // set up trapframe values that uservec will need when
    // the process next traps into the kernel.
    p->trapframe->kernel_satp = r_satp();         // kernel page table
    80002cb6:	6d3c                	ld	a5,88(a0)
  asm volatile("csrr %0, satp" : "=r" (x) );
    80002cb8:	18002773          	csrr	a4,satp
    80002cbc:	e398                	sd	a4,0(a5)
    p->trapframe->kernel_sp = p->kstack + PGSIZE; // process's kernel stack
    80002cbe:	6d38                	ld	a4,88(a0)
    80002cc0:	613c                	ld	a5,64(a0)
    80002cc2:	6685                	lui	a3,0x1
    80002cc4:	97b6                	add	a5,a5,a3
    80002cc6:	e71c                	sd	a5,8(a4)
    p->trapframe->kernel_trap = (uint64)usertrap;
    80002cc8:	6d3c                	ld	a5,88(a0)
    80002cca:	00000717          	auipc	a4,0x0
    80002cce:	0fc70713          	addi	a4,a4,252 # 80002dc6 <usertrap>
    80002cd2:	eb98                	sd	a4,16(a5)
    p->trapframe->kernel_hartid = r_tp();         // hartid for cpuid()
    80002cd4:	6d3c                	ld	a5,88(a0)
  asm volatile("mv %0, tp" : "=r" (x) );
    80002cd6:	8712                	mv	a4,tp
    80002cd8:	f398                	sd	a4,32(a5)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80002cda:	100027f3          	csrr	a5,sstatus
    // set up the registers that trampoline.S's sret will use
    // to get to user space.

    // set S Previous Privilege mode to User.
    unsigned long x = r_sstatus();
    x &= ~SSTATUS_SPP; // clear SPP to 0 for user mode
    80002cde:	eff7f793          	andi	a5,a5,-257
    x |= SSTATUS_SPIE; // enable interrupts in user mode
    80002ce2:	0207e793          	ori	a5,a5,32
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80002ce6:	10079073          	csrw	sstatus,a5
    w_sstatus(x);

    // set S Exception Program Counter to the saved user pc.
    w_sepc(p->trapframe->epc);
    80002cea:	6d3c                	ld	a5,88(a0)
  asm volatile("csrw sepc, %0" : : "r" (x));
    80002cec:	6f9c                	ld	a5,24(a5)
    80002cee:	14179073          	csrw	sepc,a5
}
    80002cf2:	60a2                	ld	ra,8(sp)
    80002cf4:	6402                	ld	s0,0(sp)
    80002cf6:	0141                	addi	sp,sp,16
    80002cf8:	8082                	ret

0000000080002cfa <clockintr>:
    w_sstatus(sstatus);
}

    void
clockintr()
{
    80002cfa:	1141                	addi	sp,sp,-16
    80002cfc:	e406                	sd	ra,8(sp)
    80002cfe:	e022                	sd	s0,0(sp)
    80002d00:	0800                	addi	s0,sp,16
    if(cpuid() == 0){
    80002d02:	a82ff0ef          	jal	80001f84 <cpuid>
    80002d06:	cd11                	beqz	a0,80002d22 <clockintr+0x28>
  asm volatile("csrr %0, time" : "=r" (x) );
    80002d08:	c01027f3          	rdtime	a5
    }

    // ask for the next timer interrupt. this also clears
    // the interrupt request. 1000000 is about a tenth
    // of a second.
    w_stimecmp(r_time() + 1000000);
    80002d0c:	000f4737          	lui	a4,0xf4
    80002d10:	24070713          	addi	a4,a4,576 # f4240 <_entry-0x7ff0bdc0>
    80002d14:	97ba                	add	a5,a5,a4
  asm volatile("csrw 0x14d, %0" : : "r" (x));
    80002d16:	14d79073          	csrw	stimecmp,a5
}
    80002d1a:	60a2                	ld	ra,8(sp)
    80002d1c:	6402                	ld	s0,0(sp)
    80002d1e:	0141                	addi	sp,sp,16
    80002d20:	8082                	ret
        acquire(&tickslock);
    80002d22:	02267517          	auipc	a0,0x2267
    80002d26:	ca650513          	addi	a0,a0,-858 # 822699c8 <tickslock>
    80002d2a:	efffd0ef          	jal	80000c28 <acquire>
        ticks++;
    80002d2e:	00009717          	auipc	a4,0x9
    80002d32:	b6a70713          	addi	a4,a4,-1174 # 8000b898 <ticks>
    80002d36:	431c                	lw	a5,0(a4)
    80002d38:	2785                	addiw	a5,a5,1
    80002d3a:	c31c                	sw	a5,0(a4)
        wakeup(&ticks);
    80002d3c:	853a                	mv	a0,a4
    80002d3e:	9e9ff0ef          	jal	80002726 <wakeup>
        release(&tickslock);
    80002d42:	02267517          	auipc	a0,0x2267
    80002d46:	c8650513          	addi	a0,a0,-890 # 822699c8 <tickslock>
    80002d4a:	f73fd0ef          	jal	80000cbc <release>
    80002d4e:	bf6d                	j	80002d08 <clockintr+0xe>

0000000080002d50 <devintr>:
// returns 2 if timer interrupt,
// 1 if other device,
// 0 if not recognized.
    int
devintr()
{
    80002d50:	1101                	addi	sp,sp,-32
    80002d52:	ec06                	sd	ra,24(sp)
    80002d54:	e822                	sd	s0,16(sp)
    80002d56:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, scause" : "=r" (x) );
    80002d58:	14202773          	csrr	a4,scause
    uint64 scause = r_scause();

    if(scause == 0x8000000000000009L){
    80002d5c:	57fd                	li	a5,-1
    80002d5e:	17fe                	slli	a5,a5,0x3f
    80002d60:	07a5                	addi	a5,a5,9
    80002d62:	00f70c63          	beq	a4,a5,80002d7a <devintr+0x2a>
        // now allowed to interrupt again.
        if(irq)
            plic_complete(irq);

        return 1;
    } else if(scause == 0x8000000000000005L){
    80002d66:	57fd                	li	a5,-1
    80002d68:	17fe                	slli	a5,a5,0x3f
    80002d6a:	0795                	addi	a5,a5,5
        // timer interrupt.
        clockintr();
        return 2;
    } else {
        return 0;
    80002d6c:	4501                	li	a0,0
    } else if(scause == 0x8000000000000005L){
    80002d6e:	04f70863          	beq	a4,a5,80002dbe <devintr+0x6e>
    }
}
    80002d72:	60e2                	ld	ra,24(sp)
    80002d74:	6442                	ld	s0,16(sp)
    80002d76:	6105                	addi	sp,sp,32
    80002d78:	8082                	ret
    80002d7a:	e426                	sd	s1,8(sp)
        int irq = plic_claim();
    80002d7c:	500030ef          	jal	8000627c <plic_claim>
    80002d80:	872a                	mv	a4,a0
    80002d82:	84aa                	mv	s1,a0
        if(irq == UART0_IRQ){
    80002d84:	47a9                	li	a5,10
    80002d86:	00f50963          	beq	a0,a5,80002d98 <devintr+0x48>
        } else if(irq == VIRTIO0_IRQ){
    80002d8a:	4785                	li	a5,1
    80002d8c:	00f50963          	beq	a0,a5,80002d9e <devintr+0x4e>
        return 1;
    80002d90:	4505                	li	a0,1
        } else if(irq){
    80002d92:	eb09                	bnez	a4,80002da4 <devintr+0x54>
    80002d94:	64a2                	ld	s1,8(sp)
    80002d96:	bff1                	j	80002d72 <devintr+0x22>
            uartintr();
    80002d98:	c5dfd0ef          	jal	800009f4 <uartintr>
        if(irq)
    80002d9c:	a819                	j	80002db2 <devintr+0x62>
            virtio_disk_intr();
    80002d9e:	175030ef          	jal	80006712 <virtio_disk_intr>
        if(irq)
    80002da2:	a801                	j	80002db2 <devintr+0x62>
            printf("unexpected interrupt irq=%d\n", irq);
    80002da4:	85ba                	mv	a1,a4
    80002da6:	00005517          	auipc	a0,0x5
    80002daa:	76a50513          	addi	a0,a0,1898 # 80008510 <etext+0x510>
    80002dae:	f4cfd0ef          	jal	800004fa <printf>
            plic_complete(irq);
    80002db2:	8526                	mv	a0,s1
    80002db4:	4e8030ef          	jal	8000629c <plic_complete>
        return 1;
    80002db8:	4505                	li	a0,1
    80002dba:	64a2                	ld	s1,8(sp)
    80002dbc:	bf5d                	j	80002d72 <devintr+0x22>
        clockintr();
    80002dbe:	f3dff0ef          	jal	80002cfa <clockintr>
        return 2;
    80002dc2:	4509                	li	a0,2
    80002dc4:	b77d                	j	80002d72 <devintr+0x22>

0000000080002dc6 <usertrap>:
{
    80002dc6:	7179                	addi	sp,sp,-48
    80002dc8:	f406                	sd	ra,40(sp)
    80002dca:	f022                	sd	s0,32(sp)
    80002dcc:	1800                	addi	s0,sp,48
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80002dce:	100027f3          	csrr	a5,sstatus
    if((r_sstatus() & SSTATUS_SPP) != 0)
    80002dd2:	1007f793          	andi	a5,a5,256
    80002dd6:	ebc5                	bnez	a5,80002e86 <usertrap+0xc0>
    80002dd8:	ec26                	sd	s1,24(sp)
    80002dda:	e84a                	sd	s2,16(sp)
  asm volatile("csrw stvec, %0" : : "r" (x));
    80002ddc:	00003797          	auipc	a5,0x3
    80002de0:	3f478793          	addi	a5,a5,1012 # 800061d0 <kernelvec>
    80002de4:	10579073          	csrw	stvec,a5
    struct proc *p = myproc();
    80002de8:	9d0ff0ef          	jal	80001fb8 <myproc>
    80002dec:	84aa                	mv	s1,a0
    p->trapframe->epc = r_sepc();
    80002dee:	6d3c                	ld	a5,88(a0)
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80002df0:	14102773          	csrr	a4,sepc
    80002df4:	ef98                	sd	a4,24(a5)
  asm volatile("csrr %0, scause" : "=r" (x) );
    80002df6:	14202773          	csrr	a4,scause
    if(r_scause() == 8){
    80002dfa:	47a1                	li	a5,8
    80002dfc:	08f70e63          	beq	a4,a5,80002e98 <usertrap+0xd2>
    } else if((which_dev = devintr()) != 0){
    80002e00:	f51ff0ef          	jal	80002d50 <devintr>
    80002e04:	892a                	mv	s2,a0
    80002e06:	20051463          	bnez	a0,8000300e <usertrap+0x248>
    80002e0a:	14202773          	csrr	a4,scause
    }else if((r_scause() == 12 || r_scause() == 15 || r_scause() == 13)) { // Page fault occurred
    80002e0e:	47b1                	li	a5,12
    80002e10:	00f70c63          	beq	a4,a5,80002e28 <usertrap+0x62>
    80002e14:	14202773          	csrr	a4,scause
    80002e18:	47bd                	li	a5,15
    80002e1a:	00f70763          	beq	a4,a5,80002e28 <usertrap+0x62>
    80002e1e:	14202773          	csrr	a4,scause
    80002e22:	47b5                	li	a5,13
    80002e24:	1af71e63          	bne	a4,a5,80002fe0 <usertrap+0x21a>
    80002e28:	e44e                	sd	s3,8(sp)
  asm volatile("csrr %0, stval" : "=r" (x) );
    80002e2a:	14302773          	csrr	a4,stval
    80002e2e:	89ba                	mv	s3,a4
        if(va >= MAXVA)
    80002e30:	57fd                	li	a5,-1
    80002e32:	83e9                	srli	a5,a5,0x1a
    80002e34:	0ae7e763          	bltu	a5,a4,80002ee2 <usertrap+0x11c>
        pte_t *pte = walk(p->pagetable, va, 0);
    80002e38:	4601                	li	a2,0
    80002e3a:	85ce                	mv	a1,s3
    80002e3c:	68a8                	ld	a0,80(s1)
    80002e3e:	94efe0ef          	jal	80000f8c <walk>
  asm volatile("csrr %0, scause" : "=r" (x) );
    80002e42:	142027f3          	csrr	a5,scause
        if(r_scause() == 15 && pte != 0 && (*pte & PTE_V) && !(*pte & PTE_W)) {
    80002e46:	c119                	beqz	a0,80002e4c <usertrap+0x86>
    80002e48:	17c5                	addi	a5,a5,-15
    80002e4a:	c3c5                	beqz	a5,80002eea <usertrap+0x124>
    80002e4c:	14202773          	csrr	a4,scause
            if (r_scause() == 12) { access_type = "exec"; }
    80002e50:	47b1                	li	a5,12
    80002e52:	00005697          	auipc	a3,0x5
    80002e56:	4ae68693          	addi	a3,a3,1198 # 80008300 <etext+0x300>
    80002e5a:	8936                	mv	s2,a3
    80002e5c:	00f70c63          	beq	a4,a5,80002e74 <usertrap+0xae>
    80002e60:	14202773          	csrr	a4,scause
            else if (r_scause() == 13) { access_type = "read"; }
    80002e64:	47b5                	li	a5,13
            else { access_type = "write"; }
    80002e66:	00005697          	auipc	a3,0x5
    80002e6a:	54a68693          	addi	a3,a3,1354 # 800083b0 <etext+0x3b0>
    80002e6e:	8936                	mv	s2,a3
            else if (r_scause() == 13) { access_type = "read"; }
    80002e70:	14f70463          	beq	a4,a5,80002fb8 <usertrap+0x1f2>
            if(handle_pgfault(p->pagetable, va, access_type) < 0) {
    80002e74:	864a                	mv	a2,s2
    80002e76:	85ce                	mv	a1,s3
    80002e78:	68a8                	ld	a0,80(s1)
    80002e7a:	c36fe0ef          	jal	800012b0 <handle_pgfault>
    80002e7e:	14054363          	bltz	a0,80002fc4 <usertrap+0x1fe>
    80002e82:	69a2                	ld	s3,8(sp)
    80002e84:	a80d                	j	80002eb6 <usertrap+0xf0>
    80002e86:	ec26                	sd	s1,24(sp)
    80002e88:	e84a                	sd	s2,16(sp)
    80002e8a:	e44e                	sd	s3,8(sp)
        panic("usertrap: not from user mode");
    80002e8c:	00005517          	auipc	a0,0x5
    80002e90:	6a450513          	addi	a0,a0,1700 # 80008530 <etext+0x530>
    80002e94:	991fd0ef          	jal	80000824 <panic>
        if(killed(p))
    80002e98:	adbff0ef          	jal	80002972 <killed>
    80002e9c:	ed1d                	bnez	a0,80002eda <usertrap+0x114>
        p->trapframe->epc += 4;
    80002e9e:	6cb8                	ld	a4,88(s1)
    80002ea0:	6f1c                	ld	a5,24(a4)
    80002ea2:	0791                	addi	a5,a5,4
    80002ea4:	ef1c                	sd	a5,24(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80002ea6:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80002eaa:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80002eae:	10079073          	csrw	sstatus,a5
        syscall();
    80002eb2:	35e000ef          	jal	80003210 <syscall>
    if(killed(p))
    80002eb6:	8526                	mv	a0,s1
    80002eb8:	abbff0ef          	jal	80002972 <killed>
    80002ebc:	14051e63          	bnez	a0,80003018 <usertrap+0x252>
    prepare_return();
    80002ec0:	dc1ff0ef          	jal	80002c80 <prepare_return>
    uint64 satp = MAKE_SATP(p->pagetable);
    80002ec4:	68a8                	ld	a0,80(s1)
    80002ec6:	8131                	srli	a0,a0,0xc
    80002ec8:	57fd                	li	a5,-1
    80002eca:	17fe                	slli	a5,a5,0x3f
    80002ecc:	8d5d                	or	a0,a0,a5
}
    80002ece:	64e2                	ld	s1,24(sp)
    80002ed0:	6942                	ld	s2,16(sp)
    80002ed2:	70a2                	ld	ra,40(sp)
    80002ed4:	7402                	ld	s0,32(sp)
    80002ed6:	6145                	addi	sp,sp,48
    80002ed8:	8082                	ret
            kexit(-1);
    80002eda:	557d                	li	a0,-1
    80002edc:	91fff0ef          	jal	800027fa <kexit>
    80002ee0:	bf7d                	j	80002e9e <usertrap+0xd8>
            kexit(-1);
    80002ee2:	557d                	li	a0,-1
    80002ee4:	917ff0ef          	jal	800027fa <kexit>
    80002ee8:	bf81                	j	80002e38 <usertrap+0x72>
        if(r_scause() == 15 && pte != 0 && (*pte & PTE_V) && !(*pte & PTE_W)) {
    80002eea:	610c                	ld	a1,0(a0)
    80002eec:	0055f713          	andi	a4,a1,5
    80002ef0:	4785                	li	a5,1
    80002ef2:	f4f71de3          	bne	a4,a5,80002e4c <usertrap+0x86>
            uint64 page_va = PGROUNDDOWN(va);
    80002ef6:	76fd                	lui	a3,0xfffff
    80002ef8:	00d9f6b3          	and	a3,s3,a3
            if (page_va >= p->heap_start) {
    80002efc:	1684b783          	ld	a5,360(s1)
    80002f00:	06f6fa63          	bgeu	a3,a5,80002f74 <usertrap+0x1ae>
                for(int i = 0; i < p->num_phdrs; i++) {
    80002f04:	000897b7          	lui	a5,0x89
    80002f08:	97a6                	add	a5,a5,s1
    80002f0a:	1e87a803          	lw	a6,488(a5) # 891e8 <_entry-0x7ff76e18>
    80002f0e:	05005263          	blez	a6,80002f52 <usertrap+0x18c>
    80002f12:	000897b7          	lui	a5,0x89
    80002f16:	20078793          	addi	a5,a5,512 # 89200 <_entry-0x7ff76e00>
    80002f1a:	97a6                	add	a5,a5,s1
    80002f1c:	864a                	mv	a2,s2
    80002f1e:	a031                	j	80002f2a <usertrap+0x164>
    80002f20:	2605                	addiw	a2,a2,1 # 1001 <_entry-0x7fffefff>
    80002f22:	03878793          	addi	a5,a5,56
    80002f26:	03060663          	beq	a2,a6,80002f52 <usertrap+0x18c>
                    struct proghdr ph = p->phdrs[i];
    80002f2a:	6398                	ld	a4,0(a5)
                    if(page_va >= ph.vaddr && page_va < ph.vaddr + ph.memsz) {
    80002f2c:	fee6eae3          	bltu	a3,a4,80002f20 <usertrap+0x15a>
    80002f30:	0187b883          	ld	a7,24(a5)
    80002f34:	9746                	add	a4,a4,a7
    80002f36:	fee6f5e3          	bgeu	a3,a4,80002f20 <usertrap+0x15a>
                    struct proghdr ph = p->phdrs[i];
    80002f3a:	00361793          	slli	a5,a2,0x3
    80002f3e:	8f91                	sub	a5,a5,a2
    80002f40:	078e                	slli	a5,a5,0x3
    80002f42:	97a6                	add	a5,a5,s1
    80002f44:	00089737          	lui	a4,0x89
    80002f48:	97ba                	add	a5,a5,a4
                        if (ph.flags & ELF_PROG_FLAG_WRITE) {
    80002f4a:	1f47a783          	lw	a5,500(a5)
    80002f4e:	8b89                	andi	a5,a5,2
    80002f50:	e395                	bnez	a5,80002f74 <usertrap+0x1ae>
                printf("[pid %d] KILL invalid-access va=0x%lx access=%s\n", p->pid, va, access_type);
    80002f52:	00005697          	auipc	a3,0x5
    80002f56:	45e68693          	addi	a3,a3,1118 # 800083b0 <etext+0x3b0>
    80002f5a:	864e                	mv	a2,s3
    80002f5c:	588c                	lw	a1,48(s1)
    80002f5e:	00005517          	auipc	a0,0x5
    80002f62:	5f250513          	addi	a0,a0,1522 # 80008550 <etext+0x550>
    80002f66:	d94fd0ef          	jal	800004fa <printf>
                setkilled(p);
    80002f6a:	8526                	mv	a0,s1
    80002f6c:	9e3ff0ef          	jal	8000294e <setkilled>
    80002f70:	69a2                	ld	s3,8(sp)
    80002f72:	b791                	j	80002eb6 <usertrap+0xf0>
                *pte |= PTE_W;
    80002f74:	0045e593          	ori	a1,a1,4
    80002f78:	e10c                	sd	a1,0(a0)
                for(int i = 0; i < p->num_resident; i++) {
    80002f7a:	000897b7          	lui	a5,0x89
    80002f7e:	97a6                	add	a5,a5,s1
    80002f80:	1b07a583          	lw	a1,432(a5) # 891b0 <_entry-0x7ff76e50>
    80002f84:	0ab05663          	blez	a1,80003030 <usertrap+0x26a>
    80002f88:	27048713          	addi	a4,s1,624
    80002f8c:	87ca                	mv	a5,s2
                    if(p->resident_pages[i].va == page_va) {
    80002f8e:	6310                	ld	a2,0(a4)
    80002f90:	00d60c63          	beq	a2,a3,80002fa8 <usertrap+0x1e2>
                for(int i = 0; i < p->num_resident; i++) {
    80002f94:	2785                	addiw	a5,a5,1
    80002f96:	0741                	addi	a4,a4,16 # 89010 <_entry-0x7ff76ff0>
    80002f98:	feb79be3          	bne	a5,a1,80002f8e <usertrap+0x1c8>
    if(killed(p))
    80002f9c:	8526                	mv	a0,s1
    80002f9e:	9d5ff0ef          	jal	80002972 <killed>
    80002fa2:	e549                	bnez	a0,8000302c <usertrap+0x266>
    80002fa4:	69a2                	ld	s3,8(sp)
    80002fa6:	bf29                	j	80002ec0 <usertrap+0xfa>
                        p->resident_pages[i].dirty = 1;
    80002fa8:	0792                	slli	a5,a5,0x4
    80002faa:	27078793          	addi	a5,a5,624
    80002fae:	97a6                	add	a5,a5,s1
    80002fb0:	4705                	li	a4,1
    80002fb2:	c7d8                	sw	a4,12(a5)
                        break;
    80002fb4:	69a2                	ld	s3,8(sp)
    80002fb6:	b701                	j	80002eb6 <usertrap+0xf0>
            else if (r_scause() == 13) { access_type = "read"; }
    80002fb8:	00006797          	auipc	a5,0x6
    80002fbc:	81078793          	addi	a5,a5,-2032 # 800087c8 <etext+0x7c8>
    80002fc0:	893e                	mv	s2,a5
    80002fc2:	bd4d                	j	80002e74 <usertrap+0xae>
                printf("[pid %d] KILL invalid-access va=0x%lx access=%s\n", p->pid, va, access_type);
    80002fc4:	86ca                	mv	a3,s2
    80002fc6:	864e                	mv	a2,s3
    80002fc8:	588c                	lw	a1,48(s1)
    80002fca:	00005517          	auipc	a0,0x5
    80002fce:	58650513          	addi	a0,a0,1414 # 80008550 <etext+0x550>
    80002fd2:	d28fd0ef          	jal	800004fa <printf>
                setkilled(p);
    80002fd6:	8526                	mv	a0,s1
    80002fd8:	977ff0ef          	jal	8000294e <setkilled>
    80002fdc:	69a2                	ld	s3,8(sp)
    80002fde:	bde1                	j	80002eb6 <usertrap+0xf0>
  asm volatile("csrr %0, scause" : "=r" (x) );
    80002fe0:	142025f3          	csrr	a1,scause
        printf("usertrap(): unexpected scause 0x%lx pid=%d\n", r_scause(), p->pid);
    80002fe4:	5890                	lw	a2,48(s1)
    80002fe6:	00005517          	auipc	a0,0x5
    80002fea:	5a250513          	addi	a0,a0,1442 # 80008588 <etext+0x588>
    80002fee:	d0cfd0ef          	jal	800004fa <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80002ff2:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80002ff6:	14302673          	csrr	a2,stval
        printf("            sepc=0x%lx stval=0x%lx\n", r_sepc(), r_stval());
    80002ffa:	00005517          	auipc	a0,0x5
    80002ffe:	5be50513          	addi	a0,a0,1470 # 800085b8 <etext+0x5b8>
    80003002:	cf8fd0ef          	jal	800004fa <printf>
        setkilled(p);
    80003006:	8526                	mv	a0,s1
    80003008:	947ff0ef          	jal	8000294e <setkilled>
    8000300c:	b56d                	j	80002eb6 <usertrap+0xf0>
    if(killed(p))
    8000300e:	8526                	mv	a0,s1
    80003010:	963ff0ef          	jal	80002972 <killed>
    80003014:	c511                	beqz	a0,80003020 <usertrap+0x25a>
    80003016:	a011                	j	8000301a <usertrap+0x254>
    80003018:	4901                	li	s2,0
        kexit(-1);
    8000301a:	557d                	li	a0,-1
    8000301c:	fdeff0ef          	jal	800027fa <kexit>
    if(which_dev == 2)
    80003020:	4789                	li	a5,2
    80003022:	e8f91fe3          	bne	s2,a5,80002ec0 <usertrap+0xfa>
        yield();
    80003026:	e88ff0ef          	jal	800026ae <yield>
    8000302a:	bd59                	j	80002ec0 <usertrap+0xfa>
    8000302c:	69a2                	ld	s3,8(sp)
    8000302e:	b7f5                	j	8000301a <usertrap+0x254>
    80003030:	69a2                	ld	s3,8(sp)
    80003032:	b551                	j	80002eb6 <usertrap+0xf0>

0000000080003034 <kerneltrap>:
{
    80003034:	7179                	addi	sp,sp,-48
    80003036:	f406                	sd	ra,40(sp)
    80003038:	f022                	sd	s0,32(sp)
    8000303a:	ec26                	sd	s1,24(sp)
    8000303c:	e84a                	sd	s2,16(sp)
    8000303e:	e44e                	sd	s3,8(sp)
    80003040:	1800                	addi	s0,sp,48
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80003042:	14102973          	csrr	s2,sepc
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80003046:	100024f3          	csrr	s1,sstatus
  asm volatile("csrr %0, scause" : "=r" (x) );
    8000304a:	142027f3          	csrr	a5,scause
    8000304e:	89be                	mv	s3,a5
    if((sstatus & SSTATUS_SPP) == 0)
    80003050:	1004f793          	andi	a5,s1,256
    80003054:	c795                	beqz	a5,80003080 <kerneltrap+0x4c>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80003056:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    8000305a:	8b89                	andi	a5,a5,2
    if(intr_get() != 0)
    8000305c:	eb85                	bnez	a5,8000308c <kerneltrap+0x58>
    if((which_dev = devintr()) == 0){
    8000305e:	cf3ff0ef          	jal	80002d50 <devintr>
    80003062:	c91d                	beqz	a0,80003098 <kerneltrap+0x64>
    if(which_dev == 2 && myproc() != 0)
    80003064:	4789                	li	a5,2
    80003066:	04f50a63          	beq	a0,a5,800030ba <kerneltrap+0x86>
  asm volatile("csrw sepc, %0" : : "r" (x));
    8000306a:	14191073          	csrw	sepc,s2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    8000306e:	10049073          	csrw	sstatus,s1
}
    80003072:	70a2                	ld	ra,40(sp)
    80003074:	7402                	ld	s0,32(sp)
    80003076:	64e2                	ld	s1,24(sp)
    80003078:	6942                	ld	s2,16(sp)
    8000307a:	69a2                	ld	s3,8(sp)
    8000307c:	6145                	addi	sp,sp,48
    8000307e:	8082                	ret
        panic("kerneltrap: not from supervisor mode");
    80003080:	00005517          	auipc	a0,0x5
    80003084:	56050513          	addi	a0,a0,1376 # 800085e0 <etext+0x5e0>
    80003088:	f9cfd0ef          	jal	80000824 <panic>
        panic("kerneltrap: interrupts enabled");
    8000308c:	00005517          	auipc	a0,0x5
    80003090:	57c50513          	addi	a0,a0,1404 # 80008608 <etext+0x608>
    80003094:	f90fd0ef          	jal	80000824 <panic>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80003098:	14102673          	csrr	a2,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    8000309c:	143026f3          	csrr	a3,stval
        printf("scause=0x%lx sepc=0x%lx stval=0x%lx\n", scause, r_sepc(), r_stval());
    800030a0:	85ce                	mv	a1,s3
    800030a2:	00005517          	auipc	a0,0x5
    800030a6:	58650513          	addi	a0,a0,1414 # 80008628 <etext+0x628>
    800030aa:	c50fd0ef          	jal	800004fa <printf>
        panic("kerneltrap");
    800030ae:	00005517          	auipc	a0,0x5
    800030b2:	5a250513          	addi	a0,a0,1442 # 80008650 <etext+0x650>
    800030b6:	f6efd0ef          	jal	80000824 <panic>
    if(which_dev == 2 && myproc() != 0)
    800030ba:	efffe0ef          	jal	80001fb8 <myproc>
    800030be:	d555                	beqz	a0,8000306a <kerneltrap+0x36>
        yield();
    800030c0:	deeff0ef          	jal	800026ae <yield>
    800030c4:	b75d                	j	8000306a <kerneltrap+0x36>

00000000800030c6 <argraw>:
  return strlen(buf);
}

static uint64
argraw(int n)
{
    800030c6:	1101                	addi	sp,sp,-32
    800030c8:	ec06                	sd	ra,24(sp)
    800030ca:	e822                	sd	s0,16(sp)
    800030cc:	e426                	sd	s1,8(sp)
    800030ce:	1000                	addi	s0,sp,32
    800030d0:	84aa                	mv	s1,a0
  struct proc *p = myproc();
    800030d2:	ee7fe0ef          	jal	80001fb8 <myproc>
  switch (n) {
    800030d6:	4795                	li	a5,5
    800030d8:	0497e163          	bltu	a5,s1,8000311a <argraw+0x54>
    800030dc:	048a                	slli	s1,s1,0x2
    800030de:	00006717          	auipc	a4,0x6
    800030e2:	a4270713          	addi	a4,a4,-1470 # 80008b20 <states.0+0x30>
    800030e6:	94ba                	add	s1,s1,a4
    800030e8:	409c                	lw	a5,0(s1)
    800030ea:	97ba                	add	a5,a5,a4
    800030ec:	8782                	jr	a5
  case 0:
    return p->trapframe->a0;
    800030ee:	6d3c                	ld	a5,88(a0)
    800030f0:	7ba8                	ld	a0,112(a5)
  case 5:
    return p->trapframe->a5;
  }
  panic("argraw");
  return -1;
}
    800030f2:	60e2                	ld	ra,24(sp)
    800030f4:	6442                	ld	s0,16(sp)
    800030f6:	64a2                	ld	s1,8(sp)
    800030f8:	6105                	addi	sp,sp,32
    800030fa:	8082                	ret
    return p->trapframe->a1;
    800030fc:	6d3c                	ld	a5,88(a0)
    800030fe:	7fa8                	ld	a0,120(a5)
    80003100:	bfcd                	j	800030f2 <argraw+0x2c>
    return p->trapframe->a2;
    80003102:	6d3c                	ld	a5,88(a0)
    80003104:	63c8                	ld	a0,128(a5)
    80003106:	b7f5                	j	800030f2 <argraw+0x2c>
    return p->trapframe->a3;
    80003108:	6d3c                	ld	a5,88(a0)
    8000310a:	67c8                	ld	a0,136(a5)
    8000310c:	b7dd                	j	800030f2 <argraw+0x2c>
    return p->trapframe->a4;
    8000310e:	6d3c                	ld	a5,88(a0)
    80003110:	6bc8                	ld	a0,144(a5)
    80003112:	b7c5                	j	800030f2 <argraw+0x2c>
    return p->trapframe->a5;
    80003114:	6d3c                	ld	a5,88(a0)
    80003116:	6fc8                	ld	a0,152(a5)
    80003118:	bfe9                	j	800030f2 <argraw+0x2c>
  panic("argraw");
    8000311a:	00005517          	auipc	a0,0x5
    8000311e:	54650513          	addi	a0,a0,1350 # 80008660 <etext+0x660>
    80003122:	f02fd0ef          	jal	80000824 <panic>

0000000080003126 <fetchaddr>:
{
    80003126:	1101                	addi	sp,sp,-32
    80003128:	ec06                	sd	ra,24(sp)
    8000312a:	e822                	sd	s0,16(sp)
    8000312c:	e426                	sd	s1,8(sp)
    8000312e:	e04a                	sd	s2,0(sp)
    80003130:	1000                	addi	s0,sp,32
    80003132:	84aa                	mv	s1,a0
    80003134:	892e                	mv	s2,a1
  struct proc *p = myproc();
    80003136:	e83fe0ef          	jal	80001fb8 <myproc>
  if(addr >= p->sz || addr+sizeof(uint64) > p->sz) // both tests needed, in case of overflow
    8000313a:	653c                	ld	a5,72(a0)
    8000313c:	02f4f663          	bgeu	s1,a5,80003168 <fetchaddr+0x42>
    80003140:	00848713          	addi	a4,s1,8
    80003144:	02e7e463          	bltu	a5,a4,8000316c <fetchaddr+0x46>
  if(copyin(p->pagetable, (char *)ip, addr, sizeof(*ip)) != 0)
    80003148:	46a1                	li	a3,8
    8000314a:	8626                	mv	a2,s1
    8000314c:	85ca                	mv	a1,s2
    8000314e:	6928                	ld	a0,80(a0)
    80003150:	a8bfe0ef          	jal	80001bda <copyin>
    80003154:	00a03533          	snez	a0,a0
    80003158:	40a0053b          	negw	a0,a0
}
    8000315c:	60e2                	ld	ra,24(sp)
    8000315e:	6442                	ld	s0,16(sp)
    80003160:	64a2                	ld	s1,8(sp)
    80003162:	6902                	ld	s2,0(sp)
    80003164:	6105                	addi	sp,sp,32
    80003166:	8082                	ret
    return -1;
    80003168:	557d                	li	a0,-1
    8000316a:	bfcd                	j	8000315c <fetchaddr+0x36>
    8000316c:	557d                	li	a0,-1
    8000316e:	b7fd                	j	8000315c <fetchaddr+0x36>

0000000080003170 <fetchstr>:
{
    80003170:	7179                	addi	sp,sp,-48
    80003172:	f406                	sd	ra,40(sp)
    80003174:	f022                	sd	s0,32(sp)
    80003176:	ec26                	sd	s1,24(sp)
    80003178:	e84a                	sd	s2,16(sp)
    8000317a:	e44e                	sd	s3,8(sp)
    8000317c:	1800                	addi	s0,sp,48
    8000317e:	89aa                	mv	s3,a0
    80003180:	84ae                	mv	s1,a1
    80003182:	8932                	mv	s2,a2
  struct proc *p = myproc();
    80003184:	e35fe0ef          	jal	80001fb8 <myproc>
  if(copyinstr(p->pagetable, buf, addr, max) < 0)
    80003188:	86ca                	mv	a3,s2
    8000318a:	864e                	mv	a2,s3
    8000318c:	85a6                	mv	a1,s1
    8000318e:	6928                	ld	a0,80(a0)
    80003190:	b21fe0ef          	jal	80001cb0 <copyinstr>
    80003194:	00054c63          	bltz	a0,800031ac <fetchstr+0x3c>
  return strlen(buf);
    80003198:	8526                	mv	a0,s1
    8000319a:	ce9fd0ef          	jal	80000e82 <strlen>
}
    8000319e:	70a2                	ld	ra,40(sp)
    800031a0:	7402                	ld	s0,32(sp)
    800031a2:	64e2                	ld	s1,24(sp)
    800031a4:	6942                	ld	s2,16(sp)
    800031a6:	69a2                	ld	s3,8(sp)
    800031a8:	6145                	addi	sp,sp,48
    800031aa:	8082                	ret
    return -1;
    800031ac:	557d                	li	a0,-1
    800031ae:	bfc5                	j	8000319e <fetchstr+0x2e>

00000000800031b0 <argint>:

// Fetch the nth 32-bit system call argument.
void
argint(int n, int *ip)
{
    800031b0:	1101                	addi	sp,sp,-32
    800031b2:	ec06                	sd	ra,24(sp)
    800031b4:	e822                	sd	s0,16(sp)
    800031b6:	e426                	sd	s1,8(sp)
    800031b8:	1000                	addi	s0,sp,32
    800031ba:	84ae                	mv	s1,a1
  *ip = argraw(n);
    800031bc:	f0bff0ef          	jal	800030c6 <argraw>
    800031c0:	c088                	sw	a0,0(s1)
}
    800031c2:	60e2                	ld	ra,24(sp)
    800031c4:	6442                	ld	s0,16(sp)
    800031c6:	64a2                	ld	s1,8(sp)
    800031c8:	6105                	addi	sp,sp,32
    800031ca:	8082                	ret

00000000800031cc <argaddr>:
// Retrieve an argument as a pointer.
// Doesn't check for legality, since
// copyin/copyout will do that.
void
argaddr(int n, uint64 *ip)
{
    800031cc:	1101                	addi	sp,sp,-32
    800031ce:	ec06                	sd	ra,24(sp)
    800031d0:	e822                	sd	s0,16(sp)
    800031d2:	e426                	sd	s1,8(sp)
    800031d4:	1000                	addi	s0,sp,32
    800031d6:	84ae                	mv	s1,a1
  *ip = argraw(n);
    800031d8:	eefff0ef          	jal	800030c6 <argraw>
    800031dc:	e088                	sd	a0,0(s1)
}
    800031de:	60e2                	ld	ra,24(sp)
    800031e0:	6442                	ld	s0,16(sp)
    800031e2:	64a2                	ld	s1,8(sp)
    800031e4:	6105                	addi	sp,sp,32
    800031e6:	8082                	ret

00000000800031e8 <argstr>:
// Fetch the nth word-sized system call argument as a null-terminated string.
// Copies into buf, at most max.
// Returns string length if OK (including nul), -1 if error.
int
argstr(int n, char *buf, int max)
{
    800031e8:	1101                	addi	sp,sp,-32
    800031ea:	ec06                	sd	ra,24(sp)
    800031ec:	e822                	sd	s0,16(sp)
    800031ee:	e426                	sd	s1,8(sp)
    800031f0:	e04a                	sd	s2,0(sp)
    800031f2:	1000                	addi	s0,sp,32
    800031f4:	892e                	mv	s2,a1
    800031f6:	84b2                	mv	s1,a2
  *ip = argraw(n);
    800031f8:	ecfff0ef          	jal	800030c6 <argraw>
  uint64 addr;
  argaddr(n, &addr);
  return fetchstr(addr, buf, max);
    800031fc:	8626                	mv	a2,s1
    800031fe:	85ca                	mv	a1,s2
    80003200:	f71ff0ef          	jal	80003170 <fetchstr>
}
    80003204:	60e2                	ld	ra,24(sp)
    80003206:	6442                	ld	s0,16(sp)
    80003208:	64a2                	ld	s1,8(sp)
    8000320a:	6902                	ld	s2,0(sp)
    8000320c:	6105                	addi	sp,sp,32
    8000320e:	8082                	ret

0000000080003210 <syscall>:
[SYS_memstat] sys_memstat,
};

void
syscall(void)
{
    80003210:	1101                	addi	sp,sp,-32
    80003212:	ec06                	sd	ra,24(sp)
    80003214:	e822                	sd	s0,16(sp)
    80003216:	e426                	sd	s1,8(sp)
    80003218:	e04a                	sd	s2,0(sp)
    8000321a:	1000                	addi	s0,sp,32
  int num;
  struct proc *p = myproc();
    8000321c:	d9dfe0ef          	jal	80001fb8 <myproc>
    80003220:	84aa                	mv	s1,a0
  num = p->trapframe->a7;
    80003222:	05853903          	ld	s2,88(a0)
    80003226:	0a893783          	ld	a5,168(s2)
    8000322a:	0007869b          	sext.w	a3,a5
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
    8000322e:	37fd                	addiw	a5,a5,-1
    80003230:	4755                	li	a4,21
    80003232:	00f76f63          	bltu	a4,a5,80003250 <syscall+0x40>
    80003236:	00369713          	slli	a4,a3,0x3
    8000323a:	00006797          	auipc	a5,0x6
    8000323e:	8fe78793          	addi	a5,a5,-1794 # 80008b38 <syscalls>
    80003242:	97ba                	add	a5,a5,a4
    80003244:	639c                	ld	a5,0(a5)
    80003246:	c789                	beqz	a5,80003250 <syscall+0x40>
    // Use num to lookup the system call function for num, call it,
    // and store its return value in p->trapframe->a0
    p->trapframe->a0 = syscalls[num]();
    80003248:	9782                	jalr	a5
    8000324a:	06a93823          	sd	a0,112(s2)
    8000324e:	a829                	j	80003268 <syscall+0x58>
  } else {
    printf("%d %s: unknown sys call %d\n",
    80003250:	15848613          	addi	a2,s1,344
    80003254:	588c                	lw	a1,48(s1)
    80003256:	00005517          	auipc	a0,0x5
    8000325a:	41250513          	addi	a0,a0,1042 # 80008668 <etext+0x668>
    8000325e:	a9cfd0ef          	jal	800004fa <printf>
            p->pid, p->name, num);
    p->trapframe->a0 = -1;
    80003262:	6cbc                	ld	a5,88(s1)
    80003264:	577d                	li	a4,-1
    80003266:	fbb8                	sd	a4,112(a5)
  }
}
    80003268:	60e2                	ld	ra,24(sp)
    8000326a:	6442                	ld	s0,16(sp)
    8000326c:	64a2                	ld	s1,8(sp)
    8000326e:	6902                	ld	s2,0(sp)
    80003270:	6105                	addi	sp,sp,32
    80003272:	8082                	ret

0000000080003274 <sys_memstat>:
// In kernel/sysproc.c (add at the end of the file)


uint64
sys_memstat(void)
{
    80003274:	81010113          	addi	sp,sp,-2032
    80003278:	7e113423          	sd	ra,2024(sp)
    8000327c:	7e813023          	sd	s0,2016(sp)
    80003280:	7c913c23          	sd	s1,2008(sp)
    80003284:	7f010413          	addi	s0,sp,2032
    80003288:	db010113          	addi	sp,sp,-592
  uint64 info_ptr;
  struct proc *p = myproc();
    8000328c:	d2dfe0ef          	jal	80001fb8 <myproc>
    80003290:	84aa                	mv	s1,a0
  struct proc_mem_stat k_info; // Kernel-space copy of the struct

  argaddr(0, &info_ptr);
    80003292:	fd840593          	addi	a1,s0,-40
    80003296:	4501                	li	a0,0
    80003298:	f35ff0ef          	jal	800031cc <argaddr>

  // 1. Fill in the basic process-wide statistics.
  k_info.pid = p->pid;
    8000329c:	80040793          	addi	a5,s0,-2048
    800032a0:	1781                	addi	a5,a5,-32
    800032a2:	5898                	lw	a4,48(s1)
    800032a4:	dee7a023          	sw	a4,-544(a5)
  k_info.num_resident_pages = p->num_resident;
    800032a8:	00089737          	lui	a4,0x89
    800032ac:	9726                	add	a4,a4,s1
    800032ae:	1b072503          	lw	a0,432(a4) # 891b0 <_entry-0x7ff76e50>
    800032b2:	dea7a423          	sw	a0,-536(a5)
  k_info.num_swapped_pages = p->num_swappped_pages;
    800032b6:	1cc72883          	lw	a7,460(a4)
    800032ba:	df17a623          	sw	a7,-532(a5)
  k_info.next_fifo_seq = p->next_fifo_seq+1;
    800032be:	1c872703          	lw	a4,456(a4)
    800032c2:	2705                	addiw	a4,a4,1
    800032c4:	dee7a823          	sw	a4,-528(a5)
  k_info.num_pages_total = p->sz / PGSIZE;
    800032c8:	64b8                	ld	a4,72(s1)
    800032ca:	00c75693          	srli	a3,a4,0xc
    800032ce:	ded7a223          	sw	a3,-540(a5)

  // 2. Iterate through the process's virtual pages to get per-page stats.
  int page_count = 0;
  for (uint64 va = 0; va < p->sz && page_count < MAX_PAGES_INFO; va += PGSIZE, page_count++) {
    800032d2:	c75d                	beqz	a4,80003380 <sys_memstat+0x10c>
    800032d4:	80040613          	addi	a2,s0,-2048
    800032d8:	1601                	addi	a2,a2,-32
    800032da:	df460613          	addi	a2,a2,-524
    800032de:	4681                	li	a3,0
  int page_count = 0;
    800032e0:	4e01                	li	t3,0
    k_info.pages[page_count].va = va;
    k_info.pages[page_count].state = UNMAPPED;
    k_info.pages[page_count].is_dirty = 0;
    k_info.pages[page_count].seq = -1;
    800032e2:	537d                	li	t1,-1
    800032e4:	00089fb7          	lui	t6,0x89
    800032e8:	df0f8f93          	addi	t6,t6,-528 # 88df0 <_entry-0x7ff77210>
    if (is_res) continue;

    // Is the page swapped?
    for (int i = 0; i < p->num_swappped_pages; i++) {
      if (p->swapped_pages[i].va == va) {
        k_info.pages[page_count].state = SWAPPED;
    800032ec:	4389                	li	t2,2
        k_info.pages[page_count].swap_slot = p->swapped_pages[i].slot;
    800032ee:	62a5                	lui	t0,0x9
    800032f0:	8df28293          	addi	t0,t0,-1825 # 88df <_entry-0x7fff7721>
        k_info.pages[page_count].state = RESIDENT;
    800032f4:	4f05                	li	t5,1
  for (uint64 va = 0; va < p->sz && page_count < MAX_PAGES_INFO; va += PGSIZE, page_count++) {
    800032f6:	6e85                	lui	t4,0x1
    800032f8:	a805                	j	80003328 <sys_memstat+0xb4>
        k_info.pages[page_count].state = RESIDENT;
    800032fa:	01e82223          	sw	t5,4(a6)
        k_info.pages[page_count].is_dirty = p->resident_pages[i].dirty;
    800032fe:	0792                	slli	a5,a5,0x4
    80003300:	97a6                	add	a5,a5,s1
    80003302:	27c7a703          	lw	a4,636(a5)
    80003306:	00e82423          	sw	a4,8(a6)
        k_info.pages[page_count].seq = p->resident_pages[i].seq;
    8000330a:	2787a783          	lw	a5,632(a5)
    8000330e:	00f82623          	sw	a5,12(a6)
  for (uint64 va = 0; va < p->sz && page_count < MAX_PAGES_INFO; va += PGSIZE, page_count++) {
    80003312:	96f6                	add	a3,a3,t4
    80003314:	001e079b          	addiw	a5,t3,1
    80003318:	8e3e                	mv	t3,a5
    8000331a:	0651                	addi	a2,a2,20
    8000331c:	64b8                	ld	a4,72(s1)
    8000331e:	06e6f163          	bgeu	a3,a4,80003380 <sys_memstat+0x10c>
    80003322:	0807a793          	slti	a5,a5,128
    80003326:	cfa9                	beqz	a5,80003380 <sys_memstat+0x10c>
    k_info.pages[page_count].va = va;
    80003328:	8832                	mv	a6,a2
    8000332a:	c214                	sw	a3,0(a2)
    k_info.pages[page_count].state = UNMAPPED;
    8000332c:	00062223          	sw	zero,4(a2)
    k_info.pages[page_count].is_dirty = 0;
    80003330:	00062423          	sw	zero,8(a2)
    k_info.pages[page_count].seq = -1;
    80003334:	00662623          	sw	t1,12(a2)
    k_info.pages[page_count].swap_slot = -1;
    80003338:	00662823          	sw	t1,16(a2)
    for (int i = 0; i < p->num_resident; i++) {
    8000333c:	00a05c63          	blez	a0,80003354 <sys_memstat+0xe0>
    80003340:	27048713          	addi	a4,s1,624
    80003344:	4781                	li	a5,0
      if (p->resident_pages[i].va == va) {
    80003346:	630c                	ld	a1,0(a4)
    80003348:	fad589e3          	beq	a1,a3,800032fa <sys_memstat+0x86>
    for (int i = 0; i < p->num_resident; i++) {
    8000334c:	2785                	addiw	a5,a5,1
    8000334e:	0741                	addi	a4,a4,16
    80003350:	fef51be3          	bne	a0,a5,80003346 <sys_memstat+0xd2>
    for (int i = 0; i < p->num_swappped_pages; i++) {
    80003354:	fb105fe3          	blez	a7,80003312 <sys_memstat+0x9e>
    80003358:	01f48733          	add	a4,s1,t6
    8000335c:	4781                	li	a5,0
      if (p->swapped_pages[i].va == va) {
    8000335e:	630c                	ld	a1,0(a4)
    80003360:	00d58763          	beq	a1,a3,8000336e <sys_memstat+0xfa>
    for (int i = 0; i < p->num_swappped_pages; i++) {
    80003364:	2785                	addiw	a5,a5,1
    80003366:	0741                	addi	a4,a4,16
    80003368:	fef89be3          	bne	a7,a5,8000335e <sys_memstat+0xea>
    8000336c:	b75d                	j	80003312 <sys_memstat+0x9e>
        k_info.pages[page_count].state = SWAPPED;
    8000336e:	00782223          	sw	t2,4(a6)
        k_info.pages[page_count].swap_slot = p->swapped_pages[i].slot;
    80003372:	9796                	add	a5,a5,t0
    80003374:	0792                	slli	a5,a5,0x4
    80003376:	97a6                	add	a5,a5,s1
    80003378:	479c                	lw	a5,8(a5)
    8000337a:	00f82823          	sw	a5,16(a6)
        break;
    8000337e:	bf51                	j	80003312 <sys_memstat+0x9e>
      }
    }
  }

  // 3. Copy the completed structure to the user-provided pointer.
  if (copyout(p->pagetable, info_ptr, (char *)&k_info, sizeof(k_info)) < 0)
    80003380:	6685                	lui	a3,0x1
    80003382:	a1468693          	addi	a3,a3,-1516 # a14 <_entry-0x7ffff5ec>
    80003386:	80040613          	addi	a2,s0,-2048
    8000338a:	1601                	addi	a2,a2,-32
    8000338c:	de060613          	addi	a2,a2,-544
    80003390:	fd843583          	ld	a1,-40(s0)
    80003394:	68a8                	ld	a0,80(s1)
    80003396:	ef2fe0ef          	jal	80001a88 <copyout>
    return -1;

  return 0;
}
    8000339a:	957d                	srai	a0,a0,0x3f
    8000339c:	25010113          	addi	sp,sp,592
    800033a0:	7e813083          	ld	ra,2024(sp)
    800033a4:	7e013403          	ld	s0,2016(sp)
    800033a8:	7d813483          	ld	s1,2008(sp)
    800033ac:	7f010113          	addi	sp,sp,2032
    800033b0:	8082                	ret

00000000800033b2 <sys_exit>:
uint64
sys_exit(void)
{
    800033b2:	1101                	addi	sp,sp,-32
    800033b4:	ec06                	sd	ra,24(sp)
    800033b6:	e822                	sd	s0,16(sp)
    800033b8:	1000                	addi	s0,sp,32
  int n;
  argint(0, &n);
    800033ba:	fec40593          	addi	a1,s0,-20
    800033be:	4501                	li	a0,0
    800033c0:	df1ff0ef          	jal	800031b0 <argint>
  kexit(n);
    800033c4:	fec42503          	lw	a0,-20(s0)
    800033c8:	c32ff0ef          	jal	800027fa <kexit>
  return 0;  // not reached
}
    800033cc:	4501                	li	a0,0
    800033ce:	60e2                	ld	ra,24(sp)
    800033d0:	6442                	ld	s0,16(sp)
    800033d2:	6105                	addi	sp,sp,32
    800033d4:	8082                	ret

00000000800033d6 <sys_getpid>:

uint64
sys_getpid(void)
{
    800033d6:	1141                	addi	sp,sp,-16
    800033d8:	e406                	sd	ra,8(sp)
    800033da:	e022                	sd	s0,0(sp)
    800033dc:	0800                	addi	s0,sp,16
  return myproc()->pid;
    800033de:	bdbfe0ef          	jal	80001fb8 <myproc>
}
    800033e2:	5908                	lw	a0,48(a0)
    800033e4:	60a2                	ld	ra,8(sp)
    800033e6:	6402                	ld	s0,0(sp)
    800033e8:	0141                	addi	sp,sp,16
    800033ea:	8082                	ret

00000000800033ec <sys_fork>:

uint64
sys_fork(void)
{
    800033ec:	1141                	addi	sp,sp,-16
    800033ee:	e406                	sd	ra,8(sp)
    800033f0:	e022                	sd	s0,0(sp)
    800033f2:	0800                	addi	s0,sp,16
  return kfork();
    800033f4:	f81fe0ef          	jal	80002374 <kfork>
}
    800033f8:	60a2                	ld	ra,8(sp)
    800033fa:	6402                	ld	s0,0(sp)
    800033fc:	0141                	addi	sp,sp,16
    800033fe:	8082                	ret

0000000080003400 <sys_wait>:

uint64
sys_wait(void)
{
    80003400:	1101                	addi	sp,sp,-32
    80003402:	ec06                	sd	ra,24(sp)
    80003404:	e822                	sd	s0,16(sp)
    80003406:	1000                	addi	s0,sp,32
  uint64 p;
  argaddr(0, &p);
    80003408:	fe840593          	addi	a1,s0,-24
    8000340c:	4501                	li	a0,0
    8000340e:	dbfff0ef          	jal	800031cc <argaddr>
  return kwait(p);
    80003412:	fe843503          	ld	a0,-24(s0)
    80003416:	d86ff0ef          	jal	8000299c <kwait>
}
    8000341a:	60e2                	ld	ra,24(sp)
    8000341c:	6442                	ld	s0,16(sp)
    8000341e:	6105                	addi	sp,sp,32
    80003420:	8082                	ret

0000000080003422 <sys_sbrk>:

uint64
sys_sbrk(void)
{
    80003422:	715d                	addi	sp,sp,-80
    80003424:	e486                	sd	ra,72(sp)
    80003426:	e0a2                	sd	s0,64(sp)
    80003428:	fc26                	sd	s1,56(sp)
    8000342a:	0880                	addi	s0,sp,80
  uint64 addr;
  int n;

  argint(0, &n);
    8000342c:	fbc40593          	addi	a1,s0,-68
    80003430:	4501                	li	a0,0
    80003432:	d7fff0ef          	jal	800031b0 <argint>
  addr = myproc()->sz;
    80003436:	b83fe0ef          	jal	80001fb8 <myproc>
    8000343a:	6524                	ld	s1,72(a0)

  if (n > 0) {
    8000343c:	fbc42783          	lw	a5,-68(s0)
    80003440:	02f05363          	blez	a5,80003466 <sys_sbrk+0x44>
    if(addr + n < addr || addr + n > TRAPFRAME) // Check for overflow or exceeding max address
    80003444:	97a6                	add	a5,a5,s1
    80003446:	02000737          	lui	a4,0x2000
    8000344a:	177d                	addi	a4,a4,-1 # 1ffffff <_entry-0x7e000001>
    8000344c:	0736                	slli	a4,a4,0xd
    8000344e:	06f76663          	bltu	a4,a5,800034ba <sys_sbrk+0x98>
    80003452:	0697e463          	bltu	a5,s1,800034ba <sys_sbrk+0x98>
      return -1;
    myproc()->sz += n;
    80003456:	b63fe0ef          	jal	80001fb8 <myproc>
    8000345a:	fbc42703          	lw	a4,-68(s0)
    8000345e:	653c                	ld	a5,72(a0)
    80003460:	97ba                	add	a5,a5,a4
    80003462:	e53c                	sd	a5,72(a0)
    80003464:	a019                	j	8000346a <sys_sbrk+0x48>
  } else if (n < 0) {
    80003466:	0007c863          	bltz	a5,80003476 <sys_sbrk+0x54>
  if(growproc(n) < 0) {
    return -1;
  }
  */
  return addr;
}
    8000346a:	8526                	mv	a0,s1
    8000346c:	60a6                	ld	ra,72(sp)
    8000346e:	6406                	ld	s0,64(sp)
    80003470:	74e2                	ld	s1,56(sp)
    80003472:	6161                	addi	sp,sp,80
    80003474:	8082                	ret
    80003476:	f84a                	sd	s2,48(sp)
    80003478:	f44e                	sd	s3,40(sp)
    8000347a:	f052                	sd	s4,32(sp)
    8000347c:	ec56                	sd	s5,24(sp)
    myproc()->sz = uvmdealloc(myproc()->pagetable, myproc()->sz, myproc()->sz + n);
    8000347e:	b3bfe0ef          	jal	80001fb8 <myproc>
    80003482:	05053903          	ld	s2,80(a0)
    80003486:	b33fe0ef          	jal	80001fb8 <myproc>
    8000348a:	04853983          	ld	s3,72(a0)
    8000348e:	b2bfe0ef          	jal	80001fb8 <myproc>
    80003492:	fbc42783          	lw	a5,-68(s0)
    80003496:	6538                	ld	a4,72(a0)
    80003498:	00e78a33          	add	s4,a5,a4
    8000349c:	b1dfe0ef          	jal	80001fb8 <myproc>
    800034a0:	8aaa                	mv	s5,a0
    800034a2:	8652                	mv	a2,s4
    800034a4:	85ce                	mv	a1,s3
    800034a6:	854a                	mv	a0,s2
    800034a8:	baafe0ef          	jal	80001852 <uvmdealloc>
    800034ac:	04aab423          	sd	a0,72(s5)
    800034b0:	7942                	ld	s2,48(sp)
    800034b2:	79a2                	ld	s3,40(sp)
    800034b4:	7a02                	ld	s4,32(sp)
    800034b6:	6ae2                	ld	s5,24(sp)
    800034b8:	bf4d                	j	8000346a <sys_sbrk+0x48>
      return -1;
    800034ba:	54fd                	li	s1,-1
    800034bc:	b77d                	j	8000346a <sys_sbrk+0x48>

00000000800034be <sys_pause>:

uint64
sys_pause(void)
{
    800034be:	7139                	addi	sp,sp,-64
    800034c0:	fc06                	sd	ra,56(sp)
    800034c2:	f822                	sd	s0,48(sp)
    800034c4:	0080                	addi	s0,sp,64
  int n;
  uint ticks0;

  argint(0, &n);
    800034c6:	fcc40593          	addi	a1,s0,-52
    800034ca:	4501                	li	a0,0
    800034cc:	ce5ff0ef          	jal	800031b0 <argint>
  if(n < 0)
    800034d0:	fcc42783          	lw	a5,-52(s0)
    800034d4:	0607c863          	bltz	a5,80003544 <sys_pause+0x86>
    n = 0;
  acquire(&tickslock);
    800034d8:	02266517          	auipc	a0,0x2266
    800034dc:	4f050513          	addi	a0,a0,1264 # 822699c8 <tickslock>
    800034e0:	f48fd0ef          	jal	80000c28 <acquire>
  ticks0 = ticks;
  while(ticks - ticks0 < n){
    800034e4:	fcc42783          	lw	a5,-52(s0)
    800034e8:	c3b9                	beqz	a5,8000352e <sys_pause+0x70>
    800034ea:	f426                	sd	s1,40(sp)
    800034ec:	f04a                	sd	s2,32(sp)
    800034ee:	ec4e                	sd	s3,24(sp)
  ticks0 = ticks;
    800034f0:	00008997          	auipc	s3,0x8
    800034f4:	3a89a983          	lw	s3,936(s3) # 8000b898 <ticks>
    if(killed(myproc())){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
    800034f8:	02266917          	auipc	s2,0x2266
    800034fc:	4d090913          	addi	s2,s2,1232 # 822699c8 <tickslock>
    80003500:	00008497          	auipc	s1,0x8
    80003504:	39848493          	addi	s1,s1,920 # 8000b898 <ticks>
    if(killed(myproc())){
    80003508:	ab1fe0ef          	jal	80001fb8 <myproc>
    8000350c:	c66ff0ef          	jal	80002972 <killed>
    80003510:	ed0d                	bnez	a0,8000354a <sys_pause+0x8c>
    sleep(&ticks, &tickslock);
    80003512:	85ca                	mv	a1,s2
    80003514:	8526                	mv	a0,s1
    80003516:	9c4ff0ef          	jal	800026da <sleep>
  while(ticks - ticks0 < n){
    8000351a:	409c                	lw	a5,0(s1)
    8000351c:	413787bb          	subw	a5,a5,s3
    80003520:	fcc42703          	lw	a4,-52(s0)
    80003524:	fee7e2e3          	bltu	a5,a4,80003508 <sys_pause+0x4a>
    80003528:	74a2                	ld	s1,40(sp)
    8000352a:	7902                	ld	s2,32(sp)
    8000352c:	69e2                	ld	s3,24(sp)
  }
  release(&tickslock);
    8000352e:	02266517          	auipc	a0,0x2266
    80003532:	49a50513          	addi	a0,a0,1178 # 822699c8 <tickslock>
    80003536:	f86fd0ef          	jal	80000cbc <release>
  return 0;
    8000353a:	4501                	li	a0,0
}
    8000353c:	70e2                	ld	ra,56(sp)
    8000353e:	7442                	ld	s0,48(sp)
    80003540:	6121                	addi	sp,sp,64
    80003542:	8082                	ret
    n = 0;
    80003544:	fc042623          	sw	zero,-52(s0)
    80003548:	bf41                	j	800034d8 <sys_pause+0x1a>
      release(&tickslock);
    8000354a:	02266517          	auipc	a0,0x2266
    8000354e:	47e50513          	addi	a0,a0,1150 # 822699c8 <tickslock>
    80003552:	f6afd0ef          	jal	80000cbc <release>
      return -1;
    80003556:	557d                	li	a0,-1
    80003558:	74a2                	ld	s1,40(sp)
    8000355a:	7902                	ld	s2,32(sp)
    8000355c:	69e2                	ld	s3,24(sp)
    8000355e:	bff9                	j	8000353c <sys_pause+0x7e>

0000000080003560 <sys_kill>:

uint64
sys_kill(void)
{
    80003560:	1101                	addi	sp,sp,-32
    80003562:	ec06                	sd	ra,24(sp)
    80003564:	e822                	sd	s0,16(sp)
    80003566:	1000                	addi	s0,sp,32
  int pid;

  argint(0, &pid);
    80003568:	fec40593          	addi	a1,s0,-20
    8000356c:	4501                	li	a0,0
    8000356e:	c43ff0ef          	jal	800031b0 <argint>
  return kkill(pid);
    80003572:	fec42503          	lw	a0,-20(s0)
    80003576:	b68ff0ef          	jal	800028de <kkill>
}
    8000357a:	60e2                	ld	ra,24(sp)
    8000357c:	6442                	ld	s0,16(sp)
    8000357e:	6105                	addi	sp,sp,32
    80003580:	8082                	ret

0000000080003582 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
uint64
sys_uptime(void)
{
    80003582:	1101                	addi	sp,sp,-32
    80003584:	ec06                	sd	ra,24(sp)
    80003586:	e822                	sd	s0,16(sp)
    80003588:	e426                	sd	s1,8(sp)
    8000358a:	1000                	addi	s0,sp,32
  uint xticks;

  acquire(&tickslock);
    8000358c:	02266517          	auipc	a0,0x2266
    80003590:	43c50513          	addi	a0,a0,1084 # 822699c8 <tickslock>
    80003594:	e94fd0ef          	jal	80000c28 <acquire>
  xticks = ticks;
    80003598:	00008797          	auipc	a5,0x8
    8000359c:	3007a783          	lw	a5,768(a5) # 8000b898 <ticks>
    800035a0:	84be                	mv	s1,a5
  release(&tickslock);
    800035a2:	02266517          	auipc	a0,0x2266
    800035a6:	42650513          	addi	a0,a0,1062 # 822699c8 <tickslock>
    800035aa:	f12fd0ef          	jal	80000cbc <release>
  return xticks;
}
    800035ae:	02049513          	slli	a0,s1,0x20
    800035b2:	9101                	srli	a0,a0,0x20
    800035b4:	60e2                	ld	ra,24(sp)
    800035b6:	6442                	ld	s0,16(sp)
    800035b8:	64a2                	ld	s1,8(sp)
    800035ba:	6105                	addi	sp,sp,32
    800035bc:	8082                	ret

00000000800035be <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
    800035be:	7179                	addi	sp,sp,-48
    800035c0:	f406                	sd	ra,40(sp)
    800035c2:	f022                	sd	s0,32(sp)
    800035c4:	ec26                	sd	s1,24(sp)
    800035c6:	e84a                	sd	s2,16(sp)
    800035c8:	e44e                	sd	s3,8(sp)
    800035ca:	e052                	sd	s4,0(sp)
    800035cc:	1800                	addi	s0,sp,48
  struct buf *b;

  initlock(&bcache.lock, "bcache");
    800035ce:	00005597          	auipc	a1,0x5
    800035d2:	0ba58593          	addi	a1,a1,186 # 80008688 <etext+0x688>
    800035d6:	02266517          	auipc	a0,0x2266
    800035da:	40a50513          	addi	a0,a0,1034 # 822699e0 <bcache>
    800035de:	dc0fd0ef          	jal	80000b9e <initlock>

  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
    800035e2:	0226e797          	auipc	a5,0x226e
    800035e6:	3fe78793          	addi	a5,a5,1022 # 822719e0 <bcache+0x8000>
    800035ea:	0226e717          	auipc	a4,0x226e
    800035ee:	65e70713          	addi	a4,a4,1630 # 82271c48 <bcache+0x8268>
    800035f2:	2ae7b823          	sd	a4,688(a5)
  bcache.head.next = &bcache.head;
    800035f6:	2ae7bc23          	sd	a4,696(a5)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    800035fa:	02266497          	auipc	s1,0x2266
    800035fe:	3fe48493          	addi	s1,s1,1022 # 822699f8 <bcache+0x18>
    b->next = bcache.head.next;
    80003602:	893e                	mv	s2,a5
    b->prev = &bcache.head;
    80003604:	89ba                	mv	s3,a4
    initsleeplock(&b->lock, "buffer");
    80003606:	00005a17          	auipc	s4,0x5
    8000360a:	08aa0a13          	addi	s4,s4,138 # 80008690 <etext+0x690>
    b->next = bcache.head.next;
    8000360e:	2b893783          	ld	a5,696(s2)
    80003612:	e8bc                	sd	a5,80(s1)
    b->prev = &bcache.head;
    80003614:	0534b423          	sd	s3,72(s1)
    initsleeplock(&b->lock, "buffer");
    80003618:	85d2                	mv	a1,s4
    8000361a:	01048513          	addi	a0,s1,16
    8000361e:	328010ef          	jal	80004946 <initsleeplock>
    bcache.head.next->prev = b;
    80003622:	2b893783          	ld	a5,696(s2)
    80003626:	e7a4                	sd	s1,72(a5)
    bcache.head.next = b;
    80003628:	2a993c23          	sd	s1,696(s2)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    8000362c:	45848493          	addi	s1,s1,1112
    80003630:	fd349fe3          	bne	s1,s3,8000360e <binit+0x50>
  }
}
    80003634:	70a2                	ld	ra,40(sp)
    80003636:	7402                	ld	s0,32(sp)
    80003638:	64e2                	ld	s1,24(sp)
    8000363a:	6942                	ld	s2,16(sp)
    8000363c:	69a2                	ld	s3,8(sp)
    8000363e:	6a02                	ld	s4,0(sp)
    80003640:	6145                	addi	sp,sp,48
    80003642:	8082                	ret

0000000080003644 <bread>:
}

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
    80003644:	7179                	addi	sp,sp,-48
    80003646:	f406                	sd	ra,40(sp)
    80003648:	f022                	sd	s0,32(sp)
    8000364a:	ec26                	sd	s1,24(sp)
    8000364c:	e84a                	sd	s2,16(sp)
    8000364e:	e44e                	sd	s3,8(sp)
    80003650:	1800                	addi	s0,sp,48
    80003652:	892a                	mv	s2,a0
    80003654:	89ae                	mv	s3,a1
  acquire(&bcache.lock);
    80003656:	02266517          	auipc	a0,0x2266
    8000365a:	38a50513          	addi	a0,a0,906 # 822699e0 <bcache>
    8000365e:	dcafd0ef          	jal	80000c28 <acquire>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
    80003662:	0226e497          	auipc	s1,0x226e
    80003666:	6364b483          	ld	s1,1590(s1) # 82271c98 <bcache+0x82b8>
    8000366a:	0226e797          	auipc	a5,0x226e
    8000366e:	5de78793          	addi	a5,a5,1502 # 82271c48 <bcache+0x8268>
    80003672:	02f48b63          	beq	s1,a5,800036a8 <bread+0x64>
    80003676:	873e                	mv	a4,a5
    80003678:	a021                	j	80003680 <bread+0x3c>
    8000367a:	68a4                	ld	s1,80(s1)
    8000367c:	02e48663          	beq	s1,a4,800036a8 <bread+0x64>
    if(b->dev == dev && b->blockno == blockno){
    80003680:	449c                	lw	a5,8(s1)
    80003682:	ff279ce3          	bne	a5,s2,8000367a <bread+0x36>
    80003686:	44dc                	lw	a5,12(s1)
    80003688:	ff3799e3          	bne	a5,s3,8000367a <bread+0x36>
      b->refcnt++;
    8000368c:	40bc                	lw	a5,64(s1)
    8000368e:	2785                	addiw	a5,a5,1
    80003690:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    80003692:	02266517          	auipc	a0,0x2266
    80003696:	34e50513          	addi	a0,a0,846 # 822699e0 <bcache>
    8000369a:	e22fd0ef          	jal	80000cbc <release>
      acquiresleep(&b->lock);
    8000369e:	01048513          	addi	a0,s1,16
    800036a2:	2da010ef          	jal	8000497c <acquiresleep>
      return b;
    800036a6:	a889                	j	800036f8 <bread+0xb4>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    800036a8:	0226e497          	auipc	s1,0x226e
    800036ac:	5e84b483          	ld	s1,1512(s1) # 82271c90 <bcache+0x82b0>
    800036b0:	0226e797          	auipc	a5,0x226e
    800036b4:	59878793          	addi	a5,a5,1432 # 82271c48 <bcache+0x8268>
    800036b8:	00f48863          	beq	s1,a5,800036c8 <bread+0x84>
    800036bc:	873e                	mv	a4,a5
    if(b->refcnt == 0) {
    800036be:	40bc                	lw	a5,64(s1)
    800036c0:	cb91                	beqz	a5,800036d4 <bread+0x90>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    800036c2:	64a4                	ld	s1,72(s1)
    800036c4:	fee49de3          	bne	s1,a4,800036be <bread+0x7a>
  panic("bget: no buffers");
    800036c8:	00005517          	auipc	a0,0x5
    800036cc:	fd050513          	addi	a0,a0,-48 # 80008698 <etext+0x698>
    800036d0:	954fd0ef          	jal	80000824 <panic>
      b->dev = dev;
    800036d4:	0124a423          	sw	s2,8(s1)
      b->blockno = blockno;
    800036d8:	0134a623          	sw	s3,12(s1)
      b->valid = 0;
    800036dc:	0004a023          	sw	zero,0(s1)
      b->refcnt = 1;
    800036e0:	4785                	li	a5,1
    800036e2:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    800036e4:	02266517          	auipc	a0,0x2266
    800036e8:	2fc50513          	addi	a0,a0,764 # 822699e0 <bcache>
    800036ec:	dd0fd0ef          	jal	80000cbc <release>
      acquiresleep(&b->lock);
    800036f0:	01048513          	addi	a0,s1,16
    800036f4:	288010ef          	jal	8000497c <acquiresleep>
  struct buf *b;

  b = bget(dev, blockno);
  if(!b->valid) {
    800036f8:	409c                	lw	a5,0(s1)
    800036fa:	cb89                	beqz	a5,8000370c <bread+0xc8>
    virtio_disk_rw(b, 0);
    b->valid = 1;
  }
  return b;
}
    800036fc:	8526                	mv	a0,s1
    800036fe:	70a2                	ld	ra,40(sp)
    80003700:	7402                	ld	s0,32(sp)
    80003702:	64e2                	ld	s1,24(sp)
    80003704:	6942                	ld	s2,16(sp)
    80003706:	69a2                	ld	s3,8(sp)
    80003708:	6145                	addi	sp,sp,48
    8000370a:	8082                	ret
    virtio_disk_rw(b, 0);
    8000370c:	4581                	li	a1,0
    8000370e:	8526                	mv	a0,s1
    80003710:	5f1020ef          	jal	80006500 <virtio_disk_rw>
    b->valid = 1;
    80003714:	4785                	li	a5,1
    80003716:	c09c                	sw	a5,0(s1)
  return b;
    80003718:	b7d5                	j	800036fc <bread+0xb8>

000000008000371a <bwrite>:

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
    8000371a:	1101                	addi	sp,sp,-32
    8000371c:	ec06                	sd	ra,24(sp)
    8000371e:	e822                	sd	s0,16(sp)
    80003720:	e426                	sd	s1,8(sp)
    80003722:	1000                	addi	s0,sp,32
    80003724:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    80003726:	0541                	addi	a0,a0,16
    80003728:	2d2010ef          	jal	800049fa <holdingsleep>
    8000372c:	c911                	beqz	a0,80003740 <bwrite+0x26>
    panic("bwrite");
  virtio_disk_rw(b, 1);
    8000372e:	4585                	li	a1,1
    80003730:	8526                	mv	a0,s1
    80003732:	5cf020ef          	jal	80006500 <virtio_disk_rw>
}
    80003736:	60e2                	ld	ra,24(sp)
    80003738:	6442                	ld	s0,16(sp)
    8000373a:	64a2                	ld	s1,8(sp)
    8000373c:	6105                	addi	sp,sp,32
    8000373e:	8082                	ret
    panic("bwrite");
    80003740:	00005517          	auipc	a0,0x5
    80003744:	f7050513          	addi	a0,a0,-144 # 800086b0 <etext+0x6b0>
    80003748:	8dcfd0ef          	jal	80000824 <panic>

000000008000374c <brelse>:

// Release a locked buffer.
// Move to the head of the most-recently-used list.
void
brelse(struct buf *b)
{
    8000374c:	1101                	addi	sp,sp,-32
    8000374e:	ec06                	sd	ra,24(sp)
    80003750:	e822                	sd	s0,16(sp)
    80003752:	e426                	sd	s1,8(sp)
    80003754:	e04a                	sd	s2,0(sp)
    80003756:	1000                	addi	s0,sp,32
    80003758:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    8000375a:	01050913          	addi	s2,a0,16
    8000375e:	854a                	mv	a0,s2
    80003760:	29a010ef          	jal	800049fa <holdingsleep>
    80003764:	c125                	beqz	a0,800037c4 <brelse+0x78>
    panic("brelse");

  releasesleep(&b->lock);
    80003766:	854a                	mv	a0,s2
    80003768:	25a010ef          	jal	800049c2 <releasesleep>

  acquire(&bcache.lock);
    8000376c:	02266517          	auipc	a0,0x2266
    80003770:	27450513          	addi	a0,a0,628 # 822699e0 <bcache>
    80003774:	cb4fd0ef          	jal	80000c28 <acquire>
  b->refcnt--;
    80003778:	40bc                	lw	a5,64(s1)
    8000377a:	37fd                	addiw	a5,a5,-1
    8000377c:	c0bc                	sw	a5,64(s1)
  if (b->refcnt == 0) {
    8000377e:	e79d                	bnez	a5,800037ac <brelse+0x60>
    // no one is waiting for it.
    b->next->prev = b->prev;
    80003780:	68b8                	ld	a4,80(s1)
    80003782:	64bc                	ld	a5,72(s1)
    80003784:	e73c                	sd	a5,72(a4)
    b->prev->next = b->next;
    80003786:	68b8                	ld	a4,80(s1)
    80003788:	ebb8                	sd	a4,80(a5)
    b->next = bcache.head.next;
    8000378a:	0226e797          	auipc	a5,0x226e
    8000378e:	25678793          	addi	a5,a5,598 # 822719e0 <bcache+0x8000>
    80003792:	2b87b703          	ld	a4,696(a5)
    80003796:	e8b8                	sd	a4,80(s1)
    b->prev = &bcache.head;
    80003798:	0226e717          	auipc	a4,0x226e
    8000379c:	4b070713          	addi	a4,a4,1200 # 82271c48 <bcache+0x8268>
    800037a0:	e4b8                	sd	a4,72(s1)
    bcache.head.next->prev = b;
    800037a2:	2b87b703          	ld	a4,696(a5)
    800037a6:	e724                	sd	s1,72(a4)
    bcache.head.next = b;
    800037a8:	2a97bc23          	sd	s1,696(a5)
  }
  
  release(&bcache.lock);
    800037ac:	02266517          	auipc	a0,0x2266
    800037b0:	23450513          	addi	a0,a0,564 # 822699e0 <bcache>
    800037b4:	d08fd0ef          	jal	80000cbc <release>
}
    800037b8:	60e2                	ld	ra,24(sp)
    800037ba:	6442                	ld	s0,16(sp)
    800037bc:	64a2                	ld	s1,8(sp)
    800037be:	6902                	ld	s2,0(sp)
    800037c0:	6105                	addi	sp,sp,32
    800037c2:	8082                	ret
    panic("brelse");
    800037c4:	00005517          	auipc	a0,0x5
    800037c8:	ef450513          	addi	a0,a0,-268 # 800086b8 <etext+0x6b8>
    800037cc:	858fd0ef          	jal	80000824 <panic>

00000000800037d0 <bpin>:

void
bpin(struct buf *b) {
    800037d0:	1101                	addi	sp,sp,-32
    800037d2:	ec06                	sd	ra,24(sp)
    800037d4:	e822                	sd	s0,16(sp)
    800037d6:	e426                	sd	s1,8(sp)
    800037d8:	1000                	addi	s0,sp,32
    800037da:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    800037dc:	02266517          	auipc	a0,0x2266
    800037e0:	20450513          	addi	a0,a0,516 # 822699e0 <bcache>
    800037e4:	c44fd0ef          	jal	80000c28 <acquire>
  b->refcnt++;
    800037e8:	40bc                	lw	a5,64(s1)
    800037ea:	2785                	addiw	a5,a5,1
    800037ec:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    800037ee:	02266517          	auipc	a0,0x2266
    800037f2:	1f250513          	addi	a0,a0,498 # 822699e0 <bcache>
    800037f6:	cc6fd0ef          	jal	80000cbc <release>
}
    800037fa:	60e2                	ld	ra,24(sp)
    800037fc:	6442                	ld	s0,16(sp)
    800037fe:	64a2                	ld	s1,8(sp)
    80003800:	6105                	addi	sp,sp,32
    80003802:	8082                	ret

0000000080003804 <bunpin>:

void
bunpin(struct buf *b) {
    80003804:	1101                	addi	sp,sp,-32
    80003806:	ec06                	sd	ra,24(sp)
    80003808:	e822                	sd	s0,16(sp)
    8000380a:	e426                	sd	s1,8(sp)
    8000380c:	1000                	addi	s0,sp,32
    8000380e:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    80003810:	02266517          	auipc	a0,0x2266
    80003814:	1d050513          	addi	a0,a0,464 # 822699e0 <bcache>
    80003818:	c10fd0ef          	jal	80000c28 <acquire>
  b->refcnt--;
    8000381c:	40bc                	lw	a5,64(s1)
    8000381e:	37fd                	addiw	a5,a5,-1
    80003820:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    80003822:	02266517          	auipc	a0,0x2266
    80003826:	1be50513          	addi	a0,a0,446 # 822699e0 <bcache>
    8000382a:	c92fd0ef          	jal	80000cbc <release>
}
    8000382e:	60e2                	ld	ra,24(sp)
    80003830:	6442                	ld	s0,16(sp)
    80003832:	64a2                	ld	s1,8(sp)
    80003834:	6105                	addi	sp,sp,32
    80003836:	8082                	ret

0000000080003838 <bfree>:
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
    80003838:	1101                	addi	sp,sp,-32
    8000383a:	ec06                	sd	ra,24(sp)
    8000383c:	e822                	sd	s0,16(sp)
    8000383e:	e426                	sd	s1,8(sp)
    80003840:	e04a                	sd	s2,0(sp)
    80003842:	1000                	addi	s0,sp,32
    80003844:	84ae                	mv	s1,a1
  struct buf *bp;
  int bi, m;

  bp = bread(dev, BBLOCK(b, sb));
    80003846:	00d5d79b          	srliw	a5,a1,0xd
    8000384a:	0226f597          	auipc	a1,0x226f
    8000384e:	8725a583          	lw	a1,-1934(a1) # 822720bc <sb+0x1c>
    80003852:	9dbd                	addw	a1,a1,a5
    80003854:	df1ff0ef          	jal	80003644 <bread>
  bi = b % BPB;
  m = 1 << (bi % 8);
    80003858:	0074f713          	andi	a4,s1,7
    8000385c:	4785                	li	a5,1
    8000385e:	00e797bb          	sllw	a5,a5,a4
  bi = b % BPB;
    80003862:	14ce                	slli	s1,s1,0x33
  if((bp->data[bi/8] & m) == 0)
    80003864:	90d9                	srli	s1,s1,0x36
    80003866:	00950733          	add	a4,a0,s1
    8000386a:	05874703          	lbu	a4,88(a4)
    8000386e:	00e7f6b3          	and	a3,a5,a4
    80003872:	c29d                	beqz	a3,80003898 <bfree+0x60>
    80003874:	892a                	mv	s2,a0
    panic("freeing free block");
  bp->data[bi/8] &= ~m;
    80003876:	94aa                	add	s1,s1,a0
    80003878:	fff7c793          	not	a5,a5
    8000387c:	8f7d                	and	a4,a4,a5
    8000387e:	04e48c23          	sb	a4,88(s1)
  log_write(bp);
    80003882:	000010ef          	jal	80004882 <log_write>
  brelse(bp);
    80003886:	854a                	mv	a0,s2
    80003888:	ec5ff0ef          	jal	8000374c <brelse>
}
    8000388c:	60e2                	ld	ra,24(sp)
    8000388e:	6442                	ld	s0,16(sp)
    80003890:	64a2                	ld	s1,8(sp)
    80003892:	6902                	ld	s2,0(sp)
    80003894:	6105                	addi	sp,sp,32
    80003896:	8082                	ret
    panic("freeing free block");
    80003898:	00005517          	auipc	a0,0x5
    8000389c:	e2850513          	addi	a0,a0,-472 # 800086c0 <etext+0x6c0>
    800038a0:	f85fc0ef          	jal	80000824 <panic>

00000000800038a4 <balloc>:
{
    800038a4:	715d                	addi	sp,sp,-80
    800038a6:	e486                	sd	ra,72(sp)
    800038a8:	e0a2                	sd	s0,64(sp)
    800038aa:	fc26                	sd	s1,56(sp)
    800038ac:	0880                	addi	s0,sp,80
  for(b = 0; b < sb.size; b += BPB){
    800038ae:	0226e797          	auipc	a5,0x226e
    800038b2:	7f67a783          	lw	a5,2038(a5) # 822720a4 <sb+0x4>
    800038b6:	0e078263          	beqz	a5,8000399a <balloc+0xf6>
    800038ba:	f84a                	sd	s2,48(sp)
    800038bc:	f44e                	sd	s3,40(sp)
    800038be:	f052                	sd	s4,32(sp)
    800038c0:	ec56                	sd	s5,24(sp)
    800038c2:	e85a                	sd	s6,16(sp)
    800038c4:	e45e                	sd	s7,8(sp)
    800038c6:	e062                	sd	s8,0(sp)
    800038c8:	8baa                	mv	s7,a0
    800038ca:	4a81                	li	s5,0
    bp = bread(dev, BBLOCK(b, sb));
    800038cc:	0226eb17          	auipc	s6,0x226e
    800038d0:	7d4b0b13          	addi	s6,s6,2004 # 822720a0 <sb>
      m = 1 << (bi % 8);
    800038d4:	4985                	li	s3,1
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    800038d6:	6a09                	lui	s4,0x2
  for(b = 0; b < sb.size; b += BPB){
    800038d8:	6c09                	lui	s8,0x2
    800038da:	a09d                	j	80003940 <balloc+0x9c>
        bp->data[bi/8] |= m;  // Mark block in use.
    800038dc:	97ca                	add	a5,a5,s2
    800038de:	8e55                	or	a2,a2,a3
    800038e0:	04c78c23          	sb	a2,88(a5)
        log_write(bp);
    800038e4:	854a                	mv	a0,s2
    800038e6:	79d000ef          	jal	80004882 <log_write>
        brelse(bp);
    800038ea:	854a                	mv	a0,s2
    800038ec:	e61ff0ef          	jal	8000374c <brelse>
  bp = bread(dev, bno);
    800038f0:	85a6                	mv	a1,s1
    800038f2:	855e                	mv	a0,s7
    800038f4:	d51ff0ef          	jal	80003644 <bread>
    800038f8:	892a                	mv	s2,a0
  memset(bp->data, 0, BSIZE);
    800038fa:	40000613          	li	a2,1024
    800038fe:	4581                	li	a1,0
    80003900:	05850513          	addi	a0,a0,88
    80003904:	bf4fd0ef          	jal	80000cf8 <memset>
  log_write(bp);
    80003908:	854a                	mv	a0,s2
    8000390a:	779000ef          	jal	80004882 <log_write>
  brelse(bp);
    8000390e:	854a                	mv	a0,s2
    80003910:	e3dff0ef          	jal	8000374c <brelse>
}
    80003914:	7942                	ld	s2,48(sp)
    80003916:	79a2                	ld	s3,40(sp)
    80003918:	7a02                	ld	s4,32(sp)
    8000391a:	6ae2                	ld	s5,24(sp)
    8000391c:	6b42                	ld	s6,16(sp)
    8000391e:	6ba2                	ld	s7,8(sp)
    80003920:	6c02                	ld	s8,0(sp)
}
    80003922:	8526                	mv	a0,s1
    80003924:	60a6                	ld	ra,72(sp)
    80003926:	6406                	ld	s0,64(sp)
    80003928:	74e2                	ld	s1,56(sp)
    8000392a:	6161                	addi	sp,sp,80
    8000392c:	8082                	ret
    brelse(bp);
    8000392e:	854a                	mv	a0,s2
    80003930:	e1dff0ef          	jal	8000374c <brelse>
  for(b = 0; b < sb.size; b += BPB){
    80003934:	015c0abb          	addw	s5,s8,s5
    80003938:	004b2783          	lw	a5,4(s6)
    8000393c:	04faf863          	bgeu	s5,a5,8000398c <balloc+0xe8>
    bp = bread(dev, BBLOCK(b, sb));
    80003940:	40dad59b          	sraiw	a1,s5,0xd
    80003944:	01cb2783          	lw	a5,28(s6)
    80003948:	9dbd                	addw	a1,a1,a5
    8000394a:	855e                	mv	a0,s7
    8000394c:	cf9ff0ef          	jal	80003644 <bread>
    80003950:	892a                	mv	s2,a0
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80003952:	004b2503          	lw	a0,4(s6)
    80003956:	84d6                	mv	s1,s5
    80003958:	4701                	li	a4,0
    8000395a:	fca4fae3          	bgeu	s1,a0,8000392e <balloc+0x8a>
      m = 1 << (bi % 8);
    8000395e:	00777693          	andi	a3,a4,7
    80003962:	00d996bb          	sllw	a3,s3,a3
      if((bp->data[bi/8] & m) == 0){  // Is block free?
    80003966:	41f7579b          	sraiw	a5,a4,0x1f
    8000396a:	01d7d79b          	srliw	a5,a5,0x1d
    8000396e:	9fb9                	addw	a5,a5,a4
    80003970:	4037d79b          	sraiw	a5,a5,0x3
    80003974:	00f90633          	add	a2,s2,a5
    80003978:	05864603          	lbu	a2,88(a2)
    8000397c:	00c6f5b3          	and	a1,a3,a2
    80003980:	ddb1                	beqz	a1,800038dc <balloc+0x38>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80003982:	2705                	addiw	a4,a4,1
    80003984:	2485                	addiw	s1,s1,1
    80003986:	fd471ae3          	bne	a4,s4,8000395a <balloc+0xb6>
    8000398a:	b755                	j	8000392e <balloc+0x8a>
    8000398c:	7942                	ld	s2,48(sp)
    8000398e:	79a2                	ld	s3,40(sp)
    80003990:	7a02                	ld	s4,32(sp)
    80003992:	6ae2                	ld	s5,24(sp)
    80003994:	6b42                	ld	s6,16(sp)
    80003996:	6ba2                	ld	s7,8(sp)
    80003998:	6c02                	ld	s8,0(sp)
  printf("balloc: out of blocks\n");
    8000399a:	00005517          	auipc	a0,0x5
    8000399e:	d3e50513          	addi	a0,a0,-706 # 800086d8 <etext+0x6d8>
    800039a2:	b59fc0ef          	jal	800004fa <printf>
  return 0;
    800039a6:	4481                	li	s1,0
    800039a8:	bfad                	j	80003922 <balloc+0x7e>

00000000800039aa <bmap>:
// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
// returns 0 if out of disk space.
static uint
bmap(struct inode *ip, uint bn)
{
    800039aa:	7179                	addi	sp,sp,-48
    800039ac:	f406                	sd	ra,40(sp)
    800039ae:	f022                	sd	s0,32(sp)
    800039b0:	ec26                	sd	s1,24(sp)
    800039b2:	e84a                	sd	s2,16(sp)
    800039b4:	e44e                	sd	s3,8(sp)
    800039b6:	1800                	addi	s0,sp,48
    800039b8:	892a                	mv	s2,a0
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
    800039ba:	47ad                	li	a5,11
    800039bc:	02b7e363          	bltu	a5,a1,800039e2 <bmap+0x38>
    if((addr = ip->addrs[bn]) == 0){
    800039c0:	02059793          	slli	a5,a1,0x20
    800039c4:	01e7d593          	srli	a1,a5,0x1e
    800039c8:	00b509b3          	add	s3,a0,a1
    800039cc:	0509a483          	lw	s1,80(s3)
    800039d0:	e0b5                	bnez	s1,80003a34 <bmap+0x8a>
      addr = balloc(ip->dev);
    800039d2:	4108                	lw	a0,0(a0)
    800039d4:	ed1ff0ef          	jal	800038a4 <balloc>
    800039d8:	84aa                	mv	s1,a0
      if(addr == 0)
    800039da:	cd29                	beqz	a0,80003a34 <bmap+0x8a>
        return 0;
      ip->addrs[bn] = addr;
    800039dc:	04a9a823          	sw	a0,80(s3)
    800039e0:	a891                	j	80003a34 <bmap+0x8a>
    }
    return addr;
  }
  bn -= NDIRECT;
    800039e2:	ff45879b          	addiw	a5,a1,-12
    800039e6:	873e                	mv	a4,a5
    800039e8:	89be                	mv	s3,a5

  if(bn < NINDIRECT){
    800039ea:	0ff00793          	li	a5,255
    800039ee:	06e7e763          	bltu	a5,a4,80003a5c <bmap+0xb2>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0){
    800039f2:	08052483          	lw	s1,128(a0)
    800039f6:	e891                	bnez	s1,80003a0a <bmap+0x60>
      addr = balloc(ip->dev);
    800039f8:	4108                	lw	a0,0(a0)
    800039fa:	eabff0ef          	jal	800038a4 <balloc>
    800039fe:	84aa                	mv	s1,a0
      if(addr == 0)
    80003a00:	c915                	beqz	a0,80003a34 <bmap+0x8a>
    80003a02:	e052                	sd	s4,0(sp)
        return 0;
      ip->addrs[NDIRECT] = addr;
    80003a04:	08a92023          	sw	a0,128(s2)
    80003a08:	a011                	j	80003a0c <bmap+0x62>
    80003a0a:	e052                	sd	s4,0(sp)
    }
    bp = bread(ip->dev, addr);
    80003a0c:	85a6                	mv	a1,s1
    80003a0e:	00092503          	lw	a0,0(s2)
    80003a12:	c33ff0ef          	jal	80003644 <bread>
    80003a16:	8a2a                	mv	s4,a0
    a = (uint*)bp->data;
    80003a18:	05850793          	addi	a5,a0,88
    if((addr = a[bn]) == 0){
    80003a1c:	02099713          	slli	a4,s3,0x20
    80003a20:	01e75593          	srli	a1,a4,0x1e
    80003a24:	97ae                	add	a5,a5,a1
    80003a26:	89be                	mv	s3,a5
    80003a28:	4384                	lw	s1,0(a5)
    80003a2a:	cc89                	beqz	s1,80003a44 <bmap+0x9a>
      if(addr){
        a[bn] = addr;
        log_write(bp);
      }
    }
    brelse(bp);
    80003a2c:	8552                	mv	a0,s4
    80003a2e:	d1fff0ef          	jal	8000374c <brelse>
    return addr;
    80003a32:	6a02                	ld	s4,0(sp)
  }

  panic("bmap: out of range");
}
    80003a34:	8526                	mv	a0,s1
    80003a36:	70a2                	ld	ra,40(sp)
    80003a38:	7402                	ld	s0,32(sp)
    80003a3a:	64e2                	ld	s1,24(sp)
    80003a3c:	6942                	ld	s2,16(sp)
    80003a3e:	69a2                	ld	s3,8(sp)
    80003a40:	6145                	addi	sp,sp,48
    80003a42:	8082                	ret
      addr = balloc(ip->dev);
    80003a44:	00092503          	lw	a0,0(s2)
    80003a48:	e5dff0ef          	jal	800038a4 <balloc>
    80003a4c:	84aa                	mv	s1,a0
      if(addr){
    80003a4e:	dd79                	beqz	a0,80003a2c <bmap+0x82>
        a[bn] = addr;
    80003a50:	00a9a023          	sw	a0,0(s3)
        log_write(bp);
    80003a54:	8552                	mv	a0,s4
    80003a56:	62d000ef          	jal	80004882 <log_write>
    80003a5a:	bfc9                	j	80003a2c <bmap+0x82>
    80003a5c:	e052                	sd	s4,0(sp)
  panic("bmap: out of range");
    80003a5e:	00005517          	auipc	a0,0x5
    80003a62:	c9250513          	addi	a0,a0,-878 # 800086f0 <etext+0x6f0>
    80003a66:	dbffc0ef          	jal	80000824 <panic>

0000000080003a6a <iget>:
{
    80003a6a:	7179                	addi	sp,sp,-48
    80003a6c:	f406                	sd	ra,40(sp)
    80003a6e:	f022                	sd	s0,32(sp)
    80003a70:	ec26                	sd	s1,24(sp)
    80003a72:	e84a                	sd	s2,16(sp)
    80003a74:	e44e                	sd	s3,8(sp)
    80003a76:	e052                	sd	s4,0(sp)
    80003a78:	1800                	addi	s0,sp,48
    80003a7a:	892a                	mv	s2,a0
    80003a7c:	8a2e                	mv	s4,a1
  acquire(&itable.lock);
    80003a7e:	0226e517          	auipc	a0,0x226e
    80003a82:	64250513          	addi	a0,a0,1602 # 822720c0 <itable>
    80003a86:	9a2fd0ef          	jal	80000c28 <acquire>
  empty = 0;
    80003a8a:	4981                	li	s3,0
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    80003a8c:	0226e497          	auipc	s1,0x226e
    80003a90:	64c48493          	addi	s1,s1,1612 # 822720d8 <itable+0x18>
    80003a94:	02270697          	auipc	a3,0x2270
    80003a98:	0d468693          	addi	a3,a3,212 # 82273b68 <log>
    80003a9c:	a809                	j	80003aae <iget+0x44>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    80003a9e:	e781                	bnez	a5,80003aa6 <iget+0x3c>
    80003aa0:	00099363          	bnez	s3,80003aa6 <iget+0x3c>
      empty = ip;
    80003aa4:	89a6                	mv	s3,s1
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    80003aa6:	08848493          	addi	s1,s1,136
    80003aaa:	02d48563          	beq	s1,a3,80003ad4 <iget+0x6a>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
    80003aae:	449c                	lw	a5,8(s1)
    80003ab0:	fef057e3          	blez	a5,80003a9e <iget+0x34>
    80003ab4:	4098                	lw	a4,0(s1)
    80003ab6:	ff2718e3          	bne	a4,s2,80003aa6 <iget+0x3c>
    80003aba:	40d8                	lw	a4,4(s1)
    80003abc:	ff4715e3          	bne	a4,s4,80003aa6 <iget+0x3c>
      ip->ref++;
    80003ac0:	2785                	addiw	a5,a5,1
    80003ac2:	c49c                	sw	a5,8(s1)
      release(&itable.lock);
    80003ac4:	0226e517          	auipc	a0,0x226e
    80003ac8:	5fc50513          	addi	a0,a0,1532 # 822720c0 <itable>
    80003acc:	9f0fd0ef          	jal	80000cbc <release>
      return ip;
    80003ad0:	89a6                	mv	s3,s1
    80003ad2:	a015                	j	80003af6 <iget+0x8c>
  if(empty == 0)
    80003ad4:	02098a63          	beqz	s3,80003b08 <iget+0x9e>
  ip->dev = dev;
    80003ad8:	0129a023          	sw	s2,0(s3)
  ip->inum = inum;
    80003adc:	0149a223          	sw	s4,4(s3)
  ip->ref = 1;
    80003ae0:	4785                	li	a5,1
    80003ae2:	00f9a423          	sw	a5,8(s3)
  ip->valid = 0;
    80003ae6:	0409a023          	sw	zero,64(s3)
  release(&itable.lock);
    80003aea:	0226e517          	auipc	a0,0x226e
    80003aee:	5d650513          	addi	a0,a0,1494 # 822720c0 <itable>
    80003af2:	9cafd0ef          	jal	80000cbc <release>
}
    80003af6:	854e                	mv	a0,s3
    80003af8:	70a2                	ld	ra,40(sp)
    80003afa:	7402                	ld	s0,32(sp)
    80003afc:	64e2                	ld	s1,24(sp)
    80003afe:	6942                	ld	s2,16(sp)
    80003b00:	69a2                	ld	s3,8(sp)
    80003b02:	6a02                	ld	s4,0(sp)
    80003b04:	6145                	addi	sp,sp,48
    80003b06:	8082                	ret
    panic("iget: no inodes");
    80003b08:	00005517          	auipc	a0,0x5
    80003b0c:	c0050513          	addi	a0,a0,-1024 # 80008708 <etext+0x708>
    80003b10:	d15fc0ef          	jal	80000824 <panic>

0000000080003b14 <iinit>:
{
    80003b14:	7179                	addi	sp,sp,-48
    80003b16:	f406                	sd	ra,40(sp)
    80003b18:	f022                	sd	s0,32(sp)
    80003b1a:	ec26                	sd	s1,24(sp)
    80003b1c:	e84a                	sd	s2,16(sp)
    80003b1e:	e44e                	sd	s3,8(sp)
    80003b20:	1800                	addi	s0,sp,48
  initlock(&itable.lock, "itable");
    80003b22:	00005597          	auipc	a1,0x5
    80003b26:	bf658593          	addi	a1,a1,-1034 # 80008718 <etext+0x718>
    80003b2a:	0226e517          	auipc	a0,0x226e
    80003b2e:	59650513          	addi	a0,a0,1430 # 822720c0 <itable>
    80003b32:	86cfd0ef          	jal	80000b9e <initlock>
  for(i = 0; i < NINODE; i++) {
    80003b36:	0226e497          	auipc	s1,0x226e
    80003b3a:	5b248493          	addi	s1,s1,1458 # 822720e8 <itable+0x28>
    80003b3e:	02270997          	auipc	s3,0x2270
    80003b42:	03a98993          	addi	s3,s3,58 # 82273b78 <log+0x10>
    initsleeplock(&itable.inode[i].lock, "inode");
    80003b46:	00005917          	auipc	s2,0x5
    80003b4a:	bda90913          	addi	s2,s2,-1062 # 80008720 <etext+0x720>
    80003b4e:	85ca                	mv	a1,s2
    80003b50:	8526                	mv	a0,s1
    80003b52:	5f5000ef          	jal	80004946 <initsleeplock>
  for(i = 0; i < NINODE; i++) {
    80003b56:	08848493          	addi	s1,s1,136
    80003b5a:	ff349ae3          	bne	s1,s3,80003b4e <iinit+0x3a>
}
    80003b5e:	70a2                	ld	ra,40(sp)
    80003b60:	7402                	ld	s0,32(sp)
    80003b62:	64e2                	ld	s1,24(sp)
    80003b64:	6942                	ld	s2,16(sp)
    80003b66:	69a2                	ld	s3,8(sp)
    80003b68:	6145                	addi	sp,sp,48
    80003b6a:	8082                	ret

0000000080003b6c <ialloc>:
{
    80003b6c:	7139                	addi	sp,sp,-64
    80003b6e:	fc06                	sd	ra,56(sp)
    80003b70:	f822                	sd	s0,48(sp)
    80003b72:	0080                	addi	s0,sp,64
  for(inum = 1; inum < sb.ninodes; inum++){
    80003b74:	0226e717          	auipc	a4,0x226e
    80003b78:	53872703          	lw	a4,1336(a4) # 822720ac <sb+0xc>
    80003b7c:	4785                	li	a5,1
    80003b7e:	06e7f063          	bgeu	a5,a4,80003bde <ialloc+0x72>
    80003b82:	f426                	sd	s1,40(sp)
    80003b84:	f04a                	sd	s2,32(sp)
    80003b86:	ec4e                	sd	s3,24(sp)
    80003b88:	e852                	sd	s4,16(sp)
    80003b8a:	e456                	sd	s5,8(sp)
    80003b8c:	e05a                	sd	s6,0(sp)
    80003b8e:	8aaa                	mv	s5,a0
    80003b90:	8b2e                	mv	s6,a1
    80003b92:	893e                	mv	s2,a5
    bp = bread(dev, IBLOCK(inum, sb));
    80003b94:	0226ea17          	auipc	s4,0x226e
    80003b98:	50ca0a13          	addi	s4,s4,1292 # 822720a0 <sb>
    80003b9c:	00495593          	srli	a1,s2,0x4
    80003ba0:	018a2783          	lw	a5,24(s4)
    80003ba4:	9dbd                	addw	a1,a1,a5
    80003ba6:	8556                	mv	a0,s5
    80003ba8:	a9dff0ef          	jal	80003644 <bread>
    80003bac:	84aa                	mv	s1,a0
    dip = (struct dinode*)bp->data + inum%IPB;
    80003bae:	05850993          	addi	s3,a0,88
    80003bb2:	00f97793          	andi	a5,s2,15
    80003bb6:	079a                	slli	a5,a5,0x6
    80003bb8:	99be                	add	s3,s3,a5
    if(dip->type == 0){  // a free inode
    80003bba:	00099783          	lh	a5,0(s3)
    80003bbe:	cb9d                	beqz	a5,80003bf4 <ialloc+0x88>
    brelse(bp);
    80003bc0:	b8dff0ef          	jal	8000374c <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
    80003bc4:	0905                	addi	s2,s2,1
    80003bc6:	00ca2703          	lw	a4,12(s4)
    80003bca:	0009079b          	sext.w	a5,s2
    80003bce:	fce7e7e3          	bltu	a5,a4,80003b9c <ialloc+0x30>
    80003bd2:	74a2                	ld	s1,40(sp)
    80003bd4:	7902                	ld	s2,32(sp)
    80003bd6:	69e2                	ld	s3,24(sp)
    80003bd8:	6a42                	ld	s4,16(sp)
    80003bda:	6aa2                	ld	s5,8(sp)
    80003bdc:	6b02                	ld	s6,0(sp)
  printf("ialloc: no inodes\n");
    80003bde:	00005517          	auipc	a0,0x5
    80003be2:	b4a50513          	addi	a0,a0,-1206 # 80008728 <etext+0x728>
    80003be6:	915fc0ef          	jal	800004fa <printf>
  return 0;
    80003bea:	4501                	li	a0,0
}
    80003bec:	70e2                	ld	ra,56(sp)
    80003bee:	7442                	ld	s0,48(sp)
    80003bf0:	6121                	addi	sp,sp,64
    80003bf2:	8082                	ret
      memset(dip, 0, sizeof(*dip));
    80003bf4:	04000613          	li	a2,64
    80003bf8:	4581                	li	a1,0
    80003bfa:	854e                	mv	a0,s3
    80003bfc:	8fcfd0ef          	jal	80000cf8 <memset>
      dip->type = type;
    80003c00:	01699023          	sh	s6,0(s3)
      log_write(bp);   // mark it allocated on the disk
    80003c04:	8526                	mv	a0,s1
    80003c06:	47d000ef          	jal	80004882 <log_write>
      brelse(bp);
    80003c0a:	8526                	mv	a0,s1
    80003c0c:	b41ff0ef          	jal	8000374c <brelse>
      return iget(dev, inum);
    80003c10:	0009059b          	sext.w	a1,s2
    80003c14:	8556                	mv	a0,s5
    80003c16:	e55ff0ef          	jal	80003a6a <iget>
    80003c1a:	74a2                	ld	s1,40(sp)
    80003c1c:	7902                	ld	s2,32(sp)
    80003c1e:	69e2                	ld	s3,24(sp)
    80003c20:	6a42                	ld	s4,16(sp)
    80003c22:	6aa2                	ld	s5,8(sp)
    80003c24:	6b02                	ld	s6,0(sp)
    80003c26:	b7d9                	j	80003bec <ialloc+0x80>

0000000080003c28 <iupdate>:
{
    80003c28:	1101                	addi	sp,sp,-32
    80003c2a:	ec06                	sd	ra,24(sp)
    80003c2c:	e822                	sd	s0,16(sp)
    80003c2e:	e426                	sd	s1,8(sp)
    80003c30:	e04a                	sd	s2,0(sp)
    80003c32:	1000                	addi	s0,sp,32
    80003c34:	84aa                	mv	s1,a0
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80003c36:	415c                	lw	a5,4(a0)
    80003c38:	0047d79b          	srliw	a5,a5,0x4
    80003c3c:	0226e597          	auipc	a1,0x226e
    80003c40:	47c5a583          	lw	a1,1148(a1) # 822720b8 <sb+0x18>
    80003c44:	9dbd                	addw	a1,a1,a5
    80003c46:	4108                	lw	a0,0(a0)
    80003c48:	9fdff0ef          	jal	80003644 <bread>
    80003c4c:	892a                	mv	s2,a0
  dip = (struct dinode*)bp->data + ip->inum%IPB;
    80003c4e:	05850793          	addi	a5,a0,88
    80003c52:	40d8                	lw	a4,4(s1)
    80003c54:	8b3d                	andi	a4,a4,15
    80003c56:	071a                	slli	a4,a4,0x6
    80003c58:	97ba                	add	a5,a5,a4
  dip->type = ip->type;
    80003c5a:	04449703          	lh	a4,68(s1)
    80003c5e:	00e79023          	sh	a4,0(a5)
  dip->major = ip->major;
    80003c62:	04649703          	lh	a4,70(s1)
    80003c66:	00e79123          	sh	a4,2(a5)
  dip->minor = ip->minor;
    80003c6a:	04849703          	lh	a4,72(s1)
    80003c6e:	00e79223          	sh	a4,4(a5)
  dip->nlink = ip->nlink;
    80003c72:	04a49703          	lh	a4,74(s1)
    80003c76:	00e79323          	sh	a4,6(a5)
  dip->size = ip->size;
    80003c7a:	44f8                	lw	a4,76(s1)
    80003c7c:	c798                	sw	a4,8(a5)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
    80003c7e:	03400613          	li	a2,52
    80003c82:	05048593          	addi	a1,s1,80
    80003c86:	00c78513          	addi	a0,a5,12
    80003c8a:	8cefd0ef          	jal	80000d58 <memmove>
  log_write(bp);
    80003c8e:	854a                	mv	a0,s2
    80003c90:	3f3000ef          	jal	80004882 <log_write>
  brelse(bp);
    80003c94:	854a                	mv	a0,s2
    80003c96:	ab7ff0ef          	jal	8000374c <brelse>
}
    80003c9a:	60e2                	ld	ra,24(sp)
    80003c9c:	6442                	ld	s0,16(sp)
    80003c9e:	64a2                	ld	s1,8(sp)
    80003ca0:	6902                	ld	s2,0(sp)
    80003ca2:	6105                	addi	sp,sp,32
    80003ca4:	8082                	ret

0000000080003ca6 <idup>:
{
    80003ca6:	1101                	addi	sp,sp,-32
    80003ca8:	ec06                	sd	ra,24(sp)
    80003caa:	e822                	sd	s0,16(sp)
    80003cac:	e426                	sd	s1,8(sp)
    80003cae:	1000                	addi	s0,sp,32
    80003cb0:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    80003cb2:	0226e517          	auipc	a0,0x226e
    80003cb6:	40e50513          	addi	a0,a0,1038 # 822720c0 <itable>
    80003cba:	f6ffc0ef          	jal	80000c28 <acquire>
  ip->ref++;
    80003cbe:	449c                	lw	a5,8(s1)
    80003cc0:	2785                	addiw	a5,a5,1
    80003cc2:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    80003cc4:	0226e517          	auipc	a0,0x226e
    80003cc8:	3fc50513          	addi	a0,a0,1020 # 822720c0 <itable>
    80003ccc:	ff1fc0ef          	jal	80000cbc <release>
}
    80003cd0:	8526                	mv	a0,s1
    80003cd2:	60e2                	ld	ra,24(sp)
    80003cd4:	6442                	ld	s0,16(sp)
    80003cd6:	64a2                	ld	s1,8(sp)
    80003cd8:	6105                	addi	sp,sp,32
    80003cda:	8082                	ret

0000000080003cdc <ilock>:
{
    80003cdc:	1101                	addi	sp,sp,-32
    80003cde:	ec06                	sd	ra,24(sp)
    80003ce0:	e822                	sd	s0,16(sp)
    80003ce2:	e426                	sd	s1,8(sp)
    80003ce4:	1000                	addi	s0,sp,32
  if(ip == 0 || ip->ref < 1)
    80003ce6:	cd19                	beqz	a0,80003d04 <ilock+0x28>
    80003ce8:	84aa                	mv	s1,a0
    80003cea:	451c                	lw	a5,8(a0)
    80003cec:	00f05c63          	blez	a5,80003d04 <ilock+0x28>
  acquiresleep(&ip->lock);
    80003cf0:	0541                	addi	a0,a0,16
    80003cf2:	48b000ef          	jal	8000497c <acquiresleep>
  if(ip->valid == 0){
    80003cf6:	40bc                	lw	a5,64(s1)
    80003cf8:	cf89                	beqz	a5,80003d12 <ilock+0x36>
}
    80003cfa:	60e2                	ld	ra,24(sp)
    80003cfc:	6442                	ld	s0,16(sp)
    80003cfe:	64a2                	ld	s1,8(sp)
    80003d00:	6105                	addi	sp,sp,32
    80003d02:	8082                	ret
    80003d04:	e04a                	sd	s2,0(sp)
    panic("ilock");
    80003d06:	00005517          	auipc	a0,0x5
    80003d0a:	a3a50513          	addi	a0,a0,-1478 # 80008740 <etext+0x740>
    80003d0e:	b17fc0ef          	jal	80000824 <panic>
    80003d12:	e04a                	sd	s2,0(sp)
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80003d14:	40dc                	lw	a5,4(s1)
    80003d16:	0047d79b          	srliw	a5,a5,0x4
    80003d1a:	0226e597          	auipc	a1,0x226e
    80003d1e:	39e5a583          	lw	a1,926(a1) # 822720b8 <sb+0x18>
    80003d22:	9dbd                	addw	a1,a1,a5
    80003d24:	4088                	lw	a0,0(s1)
    80003d26:	91fff0ef          	jal	80003644 <bread>
    80003d2a:	892a                	mv	s2,a0
    dip = (struct dinode*)bp->data + ip->inum%IPB;
    80003d2c:	05850593          	addi	a1,a0,88
    80003d30:	40dc                	lw	a5,4(s1)
    80003d32:	8bbd                	andi	a5,a5,15
    80003d34:	079a                	slli	a5,a5,0x6
    80003d36:	95be                	add	a1,a1,a5
    ip->type = dip->type;
    80003d38:	00059783          	lh	a5,0(a1)
    80003d3c:	04f49223          	sh	a5,68(s1)
    ip->major = dip->major;
    80003d40:	00259783          	lh	a5,2(a1)
    80003d44:	04f49323          	sh	a5,70(s1)
    ip->minor = dip->minor;
    80003d48:	00459783          	lh	a5,4(a1)
    80003d4c:	04f49423          	sh	a5,72(s1)
    ip->nlink = dip->nlink;
    80003d50:	00659783          	lh	a5,6(a1)
    80003d54:	04f49523          	sh	a5,74(s1)
    ip->size = dip->size;
    80003d58:	459c                	lw	a5,8(a1)
    80003d5a:	c4fc                	sw	a5,76(s1)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
    80003d5c:	03400613          	li	a2,52
    80003d60:	05b1                	addi	a1,a1,12
    80003d62:	05048513          	addi	a0,s1,80
    80003d66:	ff3fc0ef          	jal	80000d58 <memmove>
    brelse(bp);
    80003d6a:	854a                	mv	a0,s2
    80003d6c:	9e1ff0ef          	jal	8000374c <brelse>
    ip->valid = 1;
    80003d70:	4785                	li	a5,1
    80003d72:	c0bc                	sw	a5,64(s1)
    if(ip->type == 0)
    80003d74:	04449783          	lh	a5,68(s1)
    80003d78:	c399                	beqz	a5,80003d7e <ilock+0xa2>
    80003d7a:	6902                	ld	s2,0(sp)
    80003d7c:	bfbd                	j	80003cfa <ilock+0x1e>
      panic("ilock: no type");
    80003d7e:	00005517          	auipc	a0,0x5
    80003d82:	9ca50513          	addi	a0,a0,-1590 # 80008748 <etext+0x748>
    80003d86:	a9ffc0ef          	jal	80000824 <panic>

0000000080003d8a <iunlock>:
{
    80003d8a:	1101                	addi	sp,sp,-32
    80003d8c:	ec06                	sd	ra,24(sp)
    80003d8e:	e822                	sd	s0,16(sp)
    80003d90:	e426                	sd	s1,8(sp)
    80003d92:	e04a                	sd	s2,0(sp)
    80003d94:	1000                	addi	s0,sp,32
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
    80003d96:	c505                	beqz	a0,80003dbe <iunlock+0x34>
    80003d98:	84aa                	mv	s1,a0
    80003d9a:	01050913          	addi	s2,a0,16
    80003d9e:	854a                	mv	a0,s2
    80003da0:	45b000ef          	jal	800049fa <holdingsleep>
    80003da4:	cd09                	beqz	a0,80003dbe <iunlock+0x34>
    80003da6:	449c                	lw	a5,8(s1)
    80003da8:	00f05b63          	blez	a5,80003dbe <iunlock+0x34>
  releasesleep(&ip->lock);
    80003dac:	854a                	mv	a0,s2
    80003dae:	415000ef          	jal	800049c2 <releasesleep>
}
    80003db2:	60e2                	ld	ra,24(sp)
    80003db4:	6442                	ld	s0,16(sp)
    80003db6:	64a2                	ld	s1,8(sp)
    80003db8:	6902                	ld	s2,0(sp)
    80003dba:	6105                	addi	sp,sp,32
    80003dbc:	8082                	ret
    panic("iunlock");
    80003dbe:	00005517          	auipc	a0,0x5
    80003dc2:	99a50513          	addi	a0,a0,-1638 # 80008758 <etext+0x758>
    80003dc6:	a5ffc0ef          	jal	80000824 <panic>

0000000080003dca <itrunc>:

// Truncate inode (discard contents).
// Caller must hold ip->lock.
void
itrunc(struct inode *ip)
{
    80003dca:	7179                	addi	sp,sp,-48
    80003dcc:	f406                	sd	ra,40(sp)
    80003dce:	f022                	sd	s0,32(sp)
    80003dd0:	ec26                	sd	s1,24(sp)
    80003dd2:	e84a                	sd	s2,16(sp)
    80003dd4:	e44e                	sd	s3,8(sp)
    80003dd6:	1800                	addi	s0,sp,48
    80003dd8:	89aa                	mv	s3,a0
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
    80003dda:	05050493          	addi	s1,a0,80
    80003dde:	08050913          	addi	s2,a0,128
    80003de2:	a021                	j	80003dea <itrunc+0x20>
    80003de4:	0491                	addi	s1,s1,4
    80003de6:	01248b63          	beq	s1,s2,80003dfc <itrunc+0x32>
    if(ip->addrs[i]){
    80003dea:	408c                	lw	a1,0(s1)
    80003dec:	dde5                	beqz	a1,80003de4 <itrunc+0x1a>
      bfree(ip->dev, ip->addrs[i]);
    80003dee:	0009a503          	lw	a0,0(s3)
    80003df2:	a47ff0ef          	jal	80003838 <bfree>
      ip->addrs[i] = 0;
    80003df6:	0004a023          	sw	zero,0(s1)
    80003dfa:	b7ed                	j	80003de4 <itrunc+0x1a>
    }
  }

  if(ip->addrs[NDIRECT]){
    80003dfc:	0809a583          	lw	a1,128(s3)
    80003e00:	ed89                	bnez	a1,80003e1a <itrunc+0x50>
    brelse(bp);
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
    80003e02:	0409a623          	sw	zero,76(s3)
  iupdate(ip);
    80003e06:	854e                	mv	a0,s3
    80003e08:	e21ff0ef          	jal	80003c28 <iupdate>
}
    80003e0c:	70a2                	ld	ra,40(sp)
    80003e0e:	7402                	ld	s0,32(sp)
    80003e10:	64e2                	ld	s1,24(sp)
    80003e12:	6942                	ld	s2,16(sp)
    80003e14:	69a2                	ld	s3,8(sp)
    80003e16:	6145                	addi	sp,sp,48
    80003e18:	8082                	ret
    80003e1a:	e052                	sd	s4,0(sp)
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
    80003e1c:	0009a503          	lw	a0,0(s3)
    80003e20:	825ff0ef          	jal	80003644 <bread>
    80003e24:	8a2a                	mv	s4,a0
    for(j = 0; j < NINDIRECT; j++){
    80003e26:	05850493          	addi	s1,a0,88
    80003e2a:	45850913          	addi	s2,a0,1112
    80003e2e:	a021                	j	80003e36 <itrunc+0x6c>
    80003e30:	0491                	addi	s1,s1,4
    80003e32:	01248963          	beq	s1,s2,80003e44 <itrunc+0x7a>
      if(a[j])
    80003e36:	408c                	lw	a1,0(s1)
    80003e38:	dde5                	beqz	a1,80003e30 <itrunc+0x66>
        bfree(ip->dev, a[j]);
    80003e3a:	0009a503          	lw	a0,0(s3)
    80003e3e:	9fbff0ef          	jal	80003838 <bfree>
    80003e42:	b7fd                	j	80003e30 <itrunc+0x66>
    brelse(bp);
    80003e44:	8552                	mv	a0,s4
    80003e46:	907ff0ef          	jal	8000374c <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    80003e4a:	0809a583          	lw	a1,128(s3)
    80003e4e:	0009a503          	lw	a0,0(s3)
    80003e52:	9e7ff0ef          	jal	80003838 <bfree>
    ip->addrs[NDIRECT] = 0;
    80003e56:	0809a023          	sw	zero,128(s3)
    80003e5a:	6a02                	ld	s4,0(sp)
    80003e5c:	b75d                	j	80003e02 <itrunc+0x38>

0000000080003e5e <iput>:
{
    80003e5e:	1101                	addi	sp,sp,-32
    80003e60:	ec06                	sd	ra,24(sp)
    80003e62:	e822                	sd	s0,16(sp)
    80003e64:	e426                	sd	s1,8(sp)
    80003e66:	1000                	addi	s0,sp,32
    80003e68:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    80003e6a:	0226e517          	auipc	a0,0x226e
    80003e6e:	25650513          	addi	a0,a0,598 # 822720c0 <itable>
    80003e72:	db7fc0ef          	jal	80000c28 <acquire>
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    80003e76:	4498                	lw	a4,8(s1)
    80003e78:	4785                	li	a5,1
    80003e7a:	02f70063          	beq	a4,a5,80003e9a <iput+0x3c>
  ip->ref--;
    80003e7e:	449c                	lw	a5,8(s1)
    80003e80:	37fd                	addiw	a5,a5,-1
    80003e82:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    80003e84:	0226e517          	auipc	a0,0x226e
    80003e88:	23c50513          	addi	a0,a0,572 # 822720c0 <itable>
    80003e8c:	e31fc0ef          	jal	80000cbc <release>
}
    80003e90:	60e2                	ld	ra,24(sp)
    80003e92:	6442                	ld	s0,16(sp)
    80003e94:	64a2                	ld	s1,8(sp)
    80003e96:	6105                	addi	sp,sp,32
    80003e98:	8082                	ret
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    80003e9a:	40bc                	lw	a5,64(s1)
    80003e9c:	d3ed                	beqz	a5,80003e7e <iput+0x20>
    80003e9e:	04a49783          	lh	a5,74(s1)
    80003ea2:	fff1                	bnez	a5,80003e7e <iput+0x20>
    80003ea4:	e04a                	sd	s2,0(sp)
    acquiresleep(&ip->lock);
    80003ea6:	01048793          	addi	a5,s1,16
    80003eaa:	893e                	mv	s2,a5
    80003eac:	853e                	mv	a0,a5
    80003eae:	2cf000ef          	jal	8000497c <acquiresleep>
    release(&itable.lock);
    80003eb2:	0226e517          	auipc	a0,0x226e
    80003eb6:	20e50513          	addi	a0,a0,526 # 822720c0 <itable>
    80003eba:	e03fc0ef          	jal	80000cbc <release>
    itrunc(ip);
    80003ebe:	8526                	mv	a0,s1
    80003ec0:	f0bff0ef          	jal	80003dca <itrunc>
    ip->type = 0;
    80003ec4:	04049223          	sh	zero,68(s1)
    iupdate(ip);
    80003ec8:	8526                	mv	a0,s1
    80003eca:	d5fff0ef          	jal	80003c28 <iupdate>
    ip->valid = 0;
    80003ece:	0404a023          	sw	zero,64(s1)
    releasesleep(&ip->lock);
    80003ed2:	854a                	mv	a0,s2
    80003ed4:	2ef000ef          	jal	800049c2 <releasesleep>
    acquire(&itable.lock);
    80003ed8:	0226e517          	auipc	a0,0x226e
    80003edc:	1e850513          	addi	a0,a0,488 # 822720c0 <itable>
    80003ee0:	d49fc0ef          	jal	80000c28 <acquire>
    80003ee4:	6902                	ld	s2,0(sp)
    80003ee6:	bf61                	j	80003e7e <iput+0x20>

0000000080003ee8 <iunlockput>:
{
    80003ee8:	1101                	addi	sp,sp,-32
    80003eea:	ec06                	sd	ra,24(sp)
    80003eec:	e822                	sd	s0,16(sp)
    80003eee:	e426                	sd	s1,8(sp)
    80003ef0:	1000                	addi	s0,sp,32
    80003ef2:	84aa                	mv	s1,a0
  iunlock(ip);
    80003ef4:	e97ff0ef          	jal	80003d8a <iunlock>
  iput(ip);
    80003ef8:	8526                	mv	a0,s1
    80003efa:	f65ff0ef          	jal	80003e5e <iput>
}
    80003efe:	60e2                	ld	ra,24(sp)
    80003f00:	6442                	ld	s0,16(sp)
    80003f02:	64a2                	ld	s1,8(sp)
    80003f04:	6105                	addi	sp,sp,32
    80003f06:	8082                	ret

0000000080003f08 <ireclaim>:
  for (int inum = 1; inum < sb.ninodes; inum++) {
    80003f08:	0226e717          	auipc	a4,0x226e
    80003f0c:	1a472703          	lw	a4,420(a4) # 822720ac <sb+0xc>
    80003f10:	4785                	li	a5,1
    80003f12:	0ae7fe63          	bgeu	a5,a4,80003fce <ireclaim+0xc6>
{
    80003f16:	7139                	addi	sp,sp,-64
    80003f18:	fc06                	sd	ra,56(sp)
    80003f1a:	f822                	sd	s0,48(sp)
    80003f1c:	f426                	sd	s1,40(sp)
    80003f1e:	f04a                	sd	s2,32(sp)
    80003f20:	ec4e                	sd	s3,24(sp)
    80003f22:	e852                	sd	s4,16(sp)
    80003f24:	e456                	sd	s5,8(sp)
    80003f26:	e05a                	sd	s6,0(sp)
    80003f28:	0080                	addi	s0,sp,64
    80003f2a:	8aaa                	mv	s5,a0
  for (int inum = 1; inum < sb.ninodes; inum++) {
    80003f2c:	84be                	mv	s1,a5
    struct buf *bp = bread(dev, IBLOCK(inum, sb));
    80003f2e:	0226ea17          	auipc	s4,0x226e
    80003f32:	172a0a13          	addi	s4,s4,370 # 822720a0 <sb>
      printf("ireclaim: orphaned inode %d\n", inum);
    80003f36:	00005b17          	auipc	s6,0x5
    80003f3a:	82ab0b13          	addi	s6,s6,-2006 # 80008760 <etext+0x760>
    80003f3e:	a099                	j	80003f84 <ireclaim+0x7c>
    80003f40:	85ce                	mv	a1,s3
    80003f42:	855a                	mv	a0,s6
    80003f44:	db6fc0ef          	jal	800004fa <printf>
      ip = iget(dev, inum);
    80003f48:	85ce                	mv	a1,s3
    80003f4a:	8556                	mv	a0,s5
    80003f4c:	b1fff0ef          	jal	80003a6a <iget>
    80003f50:	89aa                	mv	s3,a0
    brelse(bp);
    80003f52:	854a                	mv	a0,s2
    80003f54:	ff8ff0ef          	jal	8000374c <brelse>
    if (ip) {
    80003f58:	00098f63          	beqz	s3,80003f76 <ireclaim+0x6e>
      begin_op();
    80003f5c:	78c000ef          	jal	800046e8 <begin_op>
      ilock(ip);
    80003f60:	854e                	mv	a0,s3
    80003f62:	d7bff0ef          	jal	80003cdc <ilock>
      iunlock(ip);
    80003f66:	854e                	mv	a0,s3
    80003f68:	e23ff0ef          	jal	80003d8a <iunlock>
      iput(ip);
    80003f6c:	854e                	mv	a0,s3
    80003f6e:	ef1ff0ef          	jal	80003e5e <iput>
      end_op();
    80003f72:	7e6000ef          	jal	80004758 <end_op>
  for (int inum = 1; inum < sb.ninodes; inum++) {
    80003f76:	0485                	addi	s1,s1,1
    80003f78:	00ca2703          	lw	a4,12(s4)
    80003f7c:	0004879b          	sext.w	a5,s1
    80003f80:	02e7fd63          	bgeu	a5,a4,80003fba <ireclaim+0xb2>
    80003f84:	0004899b          	sext.w	s3,s1
    struct buf *bp = bread(dev, IBLOCK(inum, sb));
    80003f88:	0044d593          	srli	a1,s1,0x4
    80003f8c:	018a2783          	lw	a5,24(s4)
    80003f90:	9dbd                	addw	a1,a1,a5
    80003f92:	8556                	mv	a0,s5
    80003f94:	eb0ff0ef          	jal	80003644 <bread>
    80003f98:	892a                	mv	s2,a0
    struct dinode *dip = (struct dinode *)bp->data + inum % IPB;
    80003f9a:	05850793          	addi	a5,a0,88
    80003f9e:	00f9f713          	andi	a4,s3,15
    80003fa2:	071a                	slli	a4,a4,0x6
    80003fa4:	97ba                	add	a5,a5,a4
    if (dip->type != 0 && dip->nlink == 0) {  // is an orphaned inode
    80003fa6:	00079703          	lh	a4,0(a5)
    80003faa:	c701                	beqz	a4,80003fb2 <ireclaim+0xaa>
    80003fac:	00679783          	lh	a5,6(a5)
    80003fb0:	dbc1                	beqz	a5,80003f40 <ireclaim+0x38>
    brelse(bp);
    80003fb2:	854a                	mv	a0,s2
    80003fb4:	f98ff0ef          	jal	8000374c <brelse>
    if (ip) {
    80003fb8:	bf7d                	j	80003f76 <ireclaim+0x6e>
}
    80003fba:	70e2                	ld	ra,56(sp)
    80003fbc:	7442                	ld	s0,48(sp)
    80003fbe:	74a2                	ld	s1,40(sp)
    80003fc0:	7902                	ld	s2,32(sp)
    80003fc2:	69e2                	ld	s3,24(sp)
    80003fc4:	6a42                	ld	s4,16(sp)
    80003fc6:	6aa2                	ld	s5,8(sp)
    80003fc8:	6b02                	ld	s6,0(sp)
    80003fca:	6121                	addi	sp,sp,64
    80003fcc:	8082                	ret
    80003fce:	8082                	ret

0000000080003fd0 <fsinit>:
fsinit(int dev) {
    80003fd0:	1101                	addi	sp,sp,-32
    80003fd2:	ec06                	sd	ra,24(sp)
    80003fd4:	e822                	sd	s0,16(sp)
    80003fd6:	e426                	sd	s1,8(sp)
    80003fd8:	e04a                	sd	s2,0(sp)
    80003fda:	1000                	addi	s0,sp,32
    80003fdc:	892a                	mv	s2,a0
  bp = bread(dev, 1);
    80003fde:	4585                	li	a1,1
    80003fe0:	e64ff0ef          	jal	80003644 <bread>
    80003fe4:	84aa                	mv	s1,a0
  memmove(sb, bp->data, sizeof(*sb));
    80003fe6:	02000613          	li	a2,32
    80003fea:	05850593          	addi	a1,a0,88
    80003fee:	0226e517          	auipc	a0,0x226e
    80003ff2:	0b250513          	addi	a0,a0,178 # 822720a0 <sb>
    80003ff6:	d63fc0ef          	jal	80000d58 <memmove>
  brelse(bp);
    80003ffa:	8526                	mv	a0,s1
    80003ffc:	f50ff0ef          	jal	8000374c <brelse>
  if(sb.magic != FSMAGIC)
    80004000:	0226e717          	auipc	a4,0x226e
    80004004:	0a072703          	lw	a4,160(a4) # 822720a0 <sb>
    80004008:	102037b7          	lui	a5,0x10203
    8000400c:	04078793          	addi	a5,a5,64 # 10203040 <_entry-0x6fdfcfc0>
    80004010:	02f71263          	bne	a4,a5,80004034 <fsinit+0x64>
  initlog(dev, &sb);
    80004014:	0226e597          	auipc	a1,0x226e
    80004018:	08c58593          	addi	a1,a1,140 # 822720a0 <sb>
    8000401c:	854a                	mv	a0,s2
    8000401e:	648000ef          	jal	80004666 <initlog>
  ireclaim(dev);
    80004022:	854a                	mv	a0,s2
    80004024:	ee5ff0ef          	jal	80003f08 <ireclaim>
}
    80004028:	60e2                	ld	ra,24(sp)
    8000402a:	6442                	ld	s0,16(sp)
    8000402c:	64a2                	ld	s1,8(sp)
    8000402e:	6902                	ld	s2,0(sp)
    80004030:	6105                	addi	sp,sp,32
    80004032:	8082                	ret
    panic("invalid file system");
    80004034:	00004517          	auipc	a0,0x4
    80004038:	74c50513          	addi	a0,a0,1868 # 80008780 <etext+0x780>
    8000403c:	fe8fc0ef          	jal	80000824 <panic>

0000000080004040 <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
    80004040:	1141                	addi	sp,sp,-16
    80004042:	e406                	sd	ra,8(sp)
    80004044:	e022                	sd	s0,0(sp)
    80004046:	0800                	addi	s0,sp,16
  st->dev = ip->dev;
    80004048:	411c                	lw	a5,0(a0)
    8000404a:	c19c                	sw	a5,0(a1)
  st->ino = ip->inum;
    8000404c:	415c                	lw	a5,4(a0)
    8000404e:	c1dc                	sw	a5,4(a1)
  st->type = ip->type;
    80004050:	04451783          	lh	a5,68(a0)
    80004054:	00f59423          	sh	a5,8(a1)
  st->nlink = ip->nlink;
    80004058:	04a51783          	lh	a5,74(a0)
    8000405c:	00f59523          	sh	a5,10(a1)
  st->size = ip->size;
    80004060:	04c56783          	lwu	a5,76(a0)
    80004064:	e99c                	sd	a5,16(a1)
}
    80004066:	60a2                	ld	ra,8(sp)
    80004068:	6402                	ld	s0,0(sp)
    8000406a:	0141                	addi	sp,sp,16
    8000406c:	8082                	ret

000000008000406e <readi>:
readi(struct inode *ip, int user_dst, uint64 dst, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    8000406e:	457c                	lw	a5,76(a0)
    80004070:	0ed7e663          	bltu	a5,a3,8000415c <readi+0xee>
{
    80004074:	7159                	addi	sp,sp,-112
    80004076:	f486                	sd	ra,104(sp)
    80004078:	f0a2                	sd	s0,96(sp)
    8000407a:	eca6                	sd	s1,88(sp)
    8000407c:	e0d2                	sd	s4,64(sp)
    8000407e:	fc56                	sd	s5,56(sp)
    80004080:	f85a                	sd	s6,48(sp)
    80004082:	f45e                	sd	s7,40(sp)
    80004084:	1880                	addi	s0,sp,112
    80004086:	8b2a                	mv	s6,a0
    80004088:	8bae                	mv	s7,a1
    8000408a:	8a32                	mv	s4,a2
    8000408c:	84b6                	mv	s1,a3
    8000408e:	8aba                	mv	s5,a4
  if(off > ip->size || off + n < off)
    80004090:	9f35                	addw	a4,a4,a3
    return 0;
    80004092:	4501                	li	a0,0
  if(off > ip->size || off + n < off)
    80004094:	0ad76b63          	bltu	a4,a3,8000414a <readi+0xdc>
    80004098:	e4ce                	sd	s3,72(sp)
  if(off + n > ip->size)
    8000409a:	00e7f463          	bgeu	a5,a4,800040a2 <readi+0x34>
    n = ip->size - off;
    8000409e:	40d78abb          	subw	s5,a5,a3

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    800040a2:	080a8b63          	beqz	s5,80004138 <readi+0xca>
    800040a6:	e8ca                	sd	s2,80(sp)
    800040a8:	f062                	sd	s8,32(sp)
    800040aa:	ec66                	sd	s9,24(sp)
    800040ac:	e86a                	sd	s10,16(sp)
    800040ae:	e46e                	sd	s11,8(sp)
    800040b0:	4981                	li	s3,0
    uint addr = bmap(ip, off/BSIZE);
    if(addr == 0)
      break;
    bp = bread(ip->dev, addr);
    m = min(n - tot, BSIZE - off%BSIZE);
    800040b2:	40000c93          	li	s9,1024
    if(either_copyout(user_dst, dst, bp->data + (off % BSIZE), m) == -1) {
    800040b6:	5c7d                	li	s8,-1
    800040b8:	a80d                	j	800040ea <readi+0x7c>
    800040ba:	020d1d93          	slli	s11,s10,0x20
    800040be:	020ddd93          	srli	s11,s11,0x20
    800040c2:	05890613          	addi	a2,s2,88
    800040c6:	86ee                	mv	a3,s11
    800040c8:	963e                	add	a2,a2,a5
    800040ca:	85d2                	mv	a1,s4
    800040cc:	855e                	mv	a0,s7
    800040ce:	9c7fe0ef          	jal	80002a94 <either_copyout>
    800040d2:	05850363          	beq	a0,s8,80004118 <readi+0xaa>
      brelse(bp);
      tot = -1;
      break;
    }
    brelse(bp);
    800040d6:	854a                	mv	a0,s2
    800040d8:	e74ff0ef          	jal	8000374c <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    800040dc:	013d09bb          	addw	s3,s10,s3
    800040e0:	009d04bb          	addw	s1,s10,s1
    800040e4:	9a6e                	add	s4,s4,s11
    800040e6:	0559f363          	bgeu	s3,s5,8000412c <readi+0xbe>
    uint addr = bmap(ip, off/BSIZE);
    800040ea:	00a4d59b          	srliw	a1,s1,0xa
    800040ee:	855a                	mv	a0,s6
    800040f0:	8bbff0ef          	jal	800039aa <bmap>
    800040f4:	85aa                	mv	a1,a0
    if(addr == 0)
    800040f6:	c139                	beqz	a0,8000413c <readi+0xce>
    bp = bread(ip->dev, addr);
    800040f8:	000b2503          	lw	a0,0(s6)
    800040fc:	d48ff0ef          	jal	80003644 <bread>
    80004100:	892a                	mv	s2,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    80004102:	3ff4f793          	andi	a5,s1,1023
    80004106:	40fc873b          	subw	a4,s9,a5
    8000410a:	413a86bb          	subw	a3,s5,s3
    8000410e:	8d3a                	mv	s10,a4
    80004110:	fae6f5e3          	bgeu	a3,a4,800040ba <readi+0x4c>
    80004114:	8d36                	mv	s10,a3
    80004116:	b755                	j	800040ba <readi+0x4c>
      brelse(bp);
    80004118:	854a                	mv	a0,s2
    8000411a:	e32ff0ef          	jal	8000374c <brelse>
      tot = -1;
    8000411e:	59fd                	li	s3,-1
      break;
    80004120:	6946                	ld	s2,80(sp)
    80004122:	7c02                	ld	s8,32(sp)
    80004124:	6ce2                	ld	s9,24(sp)
    80004126:	6d42                	ld	s10,16(sp)
    80004128:	6da2                	ld	s11,8(sp)
    8000412a:	a831                	j	80004146 <readi+0xd8>
    8000412c:	6946                	ld	s2,80(sp)
    8000412e:	7c02                	ld	s8,32(sp)
    80004130:	6ce2                	ld	s9,24(sp)
    80004132:	6d42                	ld	s10,16(sp)
    80004134:	6da2                	ld	s11,8(sp)
    80004136:	a801                	j	80004146 <readi+0xd8>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80004138:	89d6                	mv	s3,s5
    8000413a:	a031                	j	80004146 <readi+0xd8>
    8000413c:	6946                	ld	s2,80(sp)
    8000413e:	7c02                	ld	s8,32(sp)
    80004140:	6ce2                	ld	s9,24(sp)
    80004142:	6d42                	ld	s10,16(sp)
    80004144:	6da2                	ld	s11,8(sp)
  }
  return tot;
    80004146:	854e                	mv	a0,s3
    80004148:	69a6                	ld	s3,72(sp)
}
    8000414a:	70a6                	ld	ra,104(sp)
    8000414c:	7406                	ld	s0,96(sp)
    8000414e:	64e6                	ld	s1,88(sp)
    80004150:	6a06                	ld	s4,64(sp)
    80004152:	7ae2                	ld	s5,56(sp)
    80004154:	7b42                	ld	s6,48(sp)
    80004156:	7ba2                	ld	s7,40(sp)
    80004158:	6165                	addi	sp,sp,112
    8000415a:	8082                	ret
    return 0;
    8000415c:	4501                	li	a0,0
}
    8000415e:	8082                	ret

0000000080004160 <writei>:
writei(struct inode *ip, int user_src, uint64 src, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    80004160:	457c                	lw	a5,76(a0)
    80004162:	0ed7eb63          	bltu	a5,a3,80004258 <writei+0xf8>
{
    80004166:	7159                	addi	sp,sp,-112
    80004168:	f486                	sd	ra,104(sp)
    8000416a:	f0a2                	sd	s0,96(sp)
    8000416c:	e8ca                	sd	s2,80(sp)
    8000416e:	e0d2                	sd	s4,64(sp)
    80004170:	fc56                	sd	s5,56(sp)
    80004172:	f85a                	sd	s6,48(sp)
    80004174:	f45e                	sd	s7,40(sp)
    80004176:	1880                	addi	s0,sp,112
    80004178:	8aaa                	mv	s5,a0
    8000417a:	8bae                	mv	s7,a1
    8000417c:	8a32                	mv	s4,a2
    8000417e:	8936                	mv	s2,a3
    80004180:	8b3a                	mv	s6,a4
  if(off > ip->size || off + n < off)
    80004182:	00e687bb          	addw	a5,a3,a4
    return -1;
  if(off + n > MAXFILE*BSIZE){
    80004186:	00043737          	lui	a4,0x43
    8000418a:	0cf76963          	bltu	a4,a5,8000425c <writei+0xfc>
    8000418e:	0cd7e763          	bltu	a5,a3,8000425c <writei+0xfc>
    80004192:	e4ce                	sd	s3,72(sp)
    return -1;
  }
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80004194:	0a0b0a63          	beqz	s6,80004248 <writei+0xe8>
    80004198:	eca6                	sd	s1,88(sp)
    8000419a:	f062                	sd	s8,32(sp)
    8000419c:	ec66                	sd	s9,24(sp)
    8000419e:	e86a                	sd	s10,16(sp)
    800041a0:	e46e                	sd	s11,8(sp)
    800041a2:	4981                	li	s3,0
    uint addr = bmap(ip, off/BSIZE);
    if(addr == 0)
      break;
    bp = bread(ip->dev, addr);
    m = min(n - tot, BSIZE - off%BSIZE);
    800041a4:	40000c93          	li	s9,1024
    if(either_copyin(bp->data + (off % BSIZE), user_src, src, m) == -1) {
    800041a8:	5c7d                	li	s8,-1
    800041aa:	a825                	j	800041e2 <writei+0x82>
    800041ac:	020d1d93          	slli	s11,s10,0x20
    800041b0:	020ddd93          	srli	s11,s11,0x20
    800041b4:	05848513          	addi	a0,s1,88
    800041b8:	86ee                	mv	a3,s11
    800041ba:	8652                	mv	a2,s4
    800041bc:	85de                	mv	a1,s7
    800041be:	953e                	add	a0,a0,a5
    800041c0:	91ffe0ef          	jal	80002ade <either_copyin>
    800041c4:	05850663          	beq	a0,s8,80004210 <writei+0xb0>
      brelse(bp);
      break;
    }
    log_write(bp);
    800041c8:	8526                	mv	a0,s1
    800041ca:	6b8000ef          	jal	80004882 <log_write>
    brelse(bp);
    800041ce:	8526                	mv	a0,s1
    800041d0:	d7cff0ef          	jal	8000374c <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    800041d4:	013d09bb          	addw	s3,s10,s3
    800041d8:	012d093b          	addw	s2,s10,s2
    800041dc:	9a6e                	add	s4,s4,s11
    800041de:	0369fc63          	bgeu	s3,s6,80004216 <writei+0xb6>
    uint addr = bmap(ip, off/BSIZE);
    800041e2:	00a9559b          	srliw	a1,s2,0xa
    800041e6:	8556                	mv	a0,s5
    800041e8:	fc2ff0ef          	jal	800039aa <bmap>
    800041ec:	85aa                	mv	a1,a0
    if(addr == 0)
    800041ee:	c505                	beqz	a0,80004216 <writei+0xb6>
    bp = bread(ip->dev, addr);
    800041f0:	000aa503          	lw	a0,0(s5)
    800041f4:	c50ff0ef          	jal	80003644 <bread>
    800041f8:	84aa                	mv	s1,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    800041fa:	3ff97793          	andi	a5,s2,1023
    800041fe:	40fc873b          	subw	a4,s9,a5
    80004202:	413b06bb          	subw	a3,s6,s3
    80004206:	8d3a                	mv	s10,a4
    80004208:	fae6f2e3          	bgeu	a3,a4,800041ac <writei+0x4c>
    8000420c:	8d36                	mv	s10,a3
    8000420e:	bf79                	j	800041ac <writei+0x4c>
      brelse(bp);
    80004210:	8526                	mv	a0,s1
    80004212:	d3aff0ef          	jal	8000374c <brelse>
  }

  if(off > ip->size)
    80004216:	04caa783          	lw	a5,76(s5)
    8000421a:	0327f963          	bgeu	a5,s2,8000424c <writei+0xec>
    ip->size = off;
    8000421e:	052aa623          	sw	s2,76(s5)
    80004222:	64e6                	ld	s1,88(sp)
    80004224:	7c02                	ld	s8,32(sp)
    80004226:	6ce2                	ld	s9,24(sp)
    80004228:	6d42                	ld	s10,16(sp)
    8000422a:	6da2                	ld	s11,8(sp)

  // write the i-node back to disk even if the size didn't change
  // because the loop above might have called bmap() and added a new
  // block to ip->addrs[].
  iupdate(ip);
    8000422c:	8556                	mv	a0,s5
    8000422e:	9fbff0ef          	jal	80003c28 <iupdate>

  return tot;
    80004232:	854e                	mv	a0,s3
    80004234:	69a6                	ld	s3,72(sp)
}
    80004236:	70a6                	ld	ra,104(sp)
    80004238:	7406                	ld	s0,96(sp)
    8000423a:	6946                	ld	s2,80(sp)
    8000423c:	6a06                	ld	s4,64(sp)
    8000423e:	7ae2                	ld	s5,56(sp)
    80004240:	7b42                	ld	s6,48(sp)
    80004242:	7ba2                	ld	s7,40(sp)
    80004244:	6165                	addi	sp,sp,112
    80004246:	8082                	ret
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80004248:	89da                	mv	s3,s6
    8000424a:	b7cd                	j	8000422c <writei+0xcc>
    8000424c:	64e6                	ld	s1,88(sp)
    8000424e:	7c02                	ld	s8,32(sp)
    80004250:	6ce2                	ld	s9,24(sp)
    80004252:	6d42                	ld	s10,16(sp)
    80004254:	6da2                	ld	s11,8(sp)
    80004256:	bfd9                	j	8000422c <writei+0xcc>
    return -1;
    80004258:	557d                	li	a0,-1
}
    8000425a:	8082                	ret
    return -1;
    8000425c:	557d                	li	a0,-1
    8000425e:	bfe1                	j	80004236 <writei+0xd6>

0000000080004260 <namecmp>:

// Directories

int
namecmp(const char *s, const char *t)
{
    80004260:	1141                	addi	sp,sp,-16
    80004262:	e406                	sd	ra,8(sp)
    80004264:	e022                	sd	s0,0(sp)
    80004266:	0800                	addi	s0,sp,16
  return strncmp(s, t, DIRSIZ);
    80004268:	4639                	li	a2,14
    8000426a:	b63fc0ef          	jal	80000dcc <strncmp>
}
    8000426e:	60a2                	ld	ra,8(sp)
    80004270:	6402                	ld	s0,0(sp)
    80004272:	0141                	addi	sp,sp,16
    80004274:	8082                	ret

0000000080004276 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
    80004276:	711d                	addi	sp,sp,-96
    80004278:	ec86                	sd	ra,88(sp)
    8000427a:	e8a2                	sd	s0,80(sp)
    8000427c:	e4a6                	sd	s1,72(sp)
    8000427e:	e0ca                	sd	s2,64(sp)
    80004280:	fc4e                	sd	s3,56(sp)
    80004282:	f852                	sd	s4,48(sp)
    80004284:	f456                	sd	s5,40(sp)
    80004286:	f05a                	sd	s6,32(sp)
    80004288:	ec5e                	sd	s7,24(sp)
    8000428a:	1080                	addi	s0,sp,96
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
    8000428c:	04451703          	lh	a4,68(a0)
    80004290:	4785                	li	a5,1
    80004292:	00f71f63          	bne	a4,a5,800042b0 <dirlookup+0x3a>
    80004296:	892a                	mv	s2,a0
    80004298:	8aae                	mv	s5,a1
    8000429a:	8bb2                	mv	s7,a2
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
    8000429c:	457c                	lw	a5,76(a0)
    8000429e:	4481                	li	s1,0
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    800042a0:	fa040a13          	addi	s4,s0,-96
    800042a4:	49c1                	li	s3,16
      panic("dirlookup read");
    if(de.inum == 0)
      continue;
    if(namecmp(name, de.name) == 0){
    800042a6:	fa240b13          	addi	s6,s0,-94
      inum = de.inum;
      return iget(dp->dev, inum);
    }
  }

  return 0;
    800042aa:	4501                	li	a0,0
  for(off = 0; off < dp->size; off += sizeof(de)){
    800042ac:	e39d                	bnez	a5,800042d2 <dirlookup+0x5c>
    800042ae:	a8b9                	j	8000430c <dirlookup+0x96>
    panic("dirlookup not DIR");
    800042b0:	00004517          	auipc	a0,0x4
    800042b4:	4e850513          	addi	a0,a0,1256 # 80008798 <etext+0x798>
    800042b8:	d6cfc0ef          	jal	80000824 <panic>
      panic("dirlookup read");
    800042bc:	00004517          	auipc	a0,0x4
    800042c0:	4f450513          	addi	a0,a0,1268 # 800087b0 <etext+0x7b0>
    800042c4:	d60fc0ef          	jal	80000824 <panic>
  for(off = 0; off < dp->size; off += sizeof(de)){
    800042c8:	24c1                	addiw	s1,s1,16
    800042ca:	04c92783          	lw	a5,76(s2)
    800042ce:	02f4fe63          	bgeu	s1,a5,8000430a <dirlookup+0x94>
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    800042d2:	874e                	mv	a4,s3
    800042d4:	86a6                	mv	a3,s1
    800042d6:	8652                	mv	a2,s4
    800042d8:	4581                	li	a1,0
    800042da:	854a                	mv	a0,s2
    800042dc:	d93ff0ef          	jal	8000406e <readi>
    800042e0:	fd351ee3          	bne	a0,s3,800042bc <dirlookup+0x46>
    if(de.inum == 0)
    800042e4:	fa045783          	lhu	a5,-96(s0)
    800042e8:	d3e5                	beqz	a5,800042c8 <dirlookup+0x52>
    if(namecmp(name, de.name) == 0){
    800042ea:	85da                	mv	a1,s6
    800042ec:	8556                	mv	a0,s5
    800042ee:	f73ff0ef          	jal	80004260 <namecmp>
    800042f2:	f979                	bnez	a0,800042c8 <dirlookup+0x52>
      if(poff)
    800042f4:	000b8463          	beqz	s7,800042fc <dirlookup+0x86>
        *poff = off;
    800042f8:	009ba023          	sw	s1,0(s7)
      return iget(dp->dev, inum);
    800042fc:	fa045583          	lhu	a1,-96(s0)
    80004300:	00092503          	lw	a0,0(s2)
    80004304:	f66ff0ef          	jal	80003a6a <iget>
    80004308:	a011                	j	8000430c <dirlookup+0x96>
  return 0;
    8000430a:	4501                	li	a0,0
}
    8000430c:	60e6                	ld	ra,88(sp)
    8000430e:	6446                	ld	s0,80(sp)
    80004310:	64a6                	ld	s1,72(sp)
    80004312:	6906                	ld	s2,64(sp)
    80004314:	79e2                	ld	s3,56(sp)
    80004316:	7a42                	ld	s4,48(sp)
    80004318:	7aa2                	ld	s5,40(sp)
    8000431a:	7b02                	ld	s6,32(sp)
    8000431c:	6be2                	ld	s7,24(sp)
    8000431e:	6125                	addi	sp,sp,96
    80004320:	8082                	ret

0000000080004322 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
    80004322:	711d                	addi	sp,sp,-96
    80004324:	ec86                	sd	ra,88(sp)
    80004326:	e8a2                	sd	s0,80(sp)
    80004328:	e4a6                	sd	s1,72(sp)
    8000432a:	e0ca                	sd	s2,64(sp)
    8000432c:	fc4e                	sd	s3,56(sp)
    8000432e:	f852                	sd	s4,48(sp)
    80004330:	f456                	sd	s5,40(sp)
    80004332:	f05a                	sd	s6,32(sp)
    80004334:	ec5e                	sd	s7,24(sp)
    80004336:	e862                	sd	s8,16(sp)
    80004338:	e466                	sd	s9,8(sp)
    8000433a:	e06a                	sd	s10,0(sp)
    8000433c:	1080                	addi	s0,sp,96
    8000433e:	84aa                	mv	s1,a0
    80004340:	8b2e                	mv	s6,a1
    80004342:	8ab2                	mv	s5,a2
  struct inode *ip, *next;

  if(*path == '/')
    80004344:	00054703          	lbu	a4,0(a0)
    80004348:	02f00793          	li	a5,47
    8000434c:	00f70f63          	beq	a4,a5,8000436a <namex+0x48>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
    80004350:	c69fd0ef          	jal	80001fb8 <myproc>
    80004354:	15053503          	ld	a0,336(a0)
    80004358:	94fff0ef          	jal	80003ca6 <idup>
    8000435c:	8a2a                	mv	s4,a0
  while(*path == '/')
    8000435e:	02f00993          	li	s3,47
  if(len >= DIRSIZ)
    80004362:	4c35                	li	s8,13
    memmove(name, s, DIRSIZ);
    80004364:	4cb9                	li	s9,14

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
    if(ip->type != T_DIR){
    80004366:	4b85                	li	s7,1
    80004368:	a879                	j	80004406 <namex+0xe4>
    ip = iget(ROOTDEV, ROOTINO);
    8000436a:	4585                	li	a1,1
    8000436c:	852e                	mv	a0,a1
    8000436e:	efcff0ef          	jal	80003a6a <iget>
    80004372:	8a2a                	mv	s4,a0
    80004374:	b7ed                	j	8000435e <namex+0x3c>
      iunlockput(ip);
    80004376:	8552                	mv	a0,s4
    80004378:	b71ff0ef          	jal	80003ee8 <iunlockput>
      return 0;
    8000437c:	4a01                	li	s4,0
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}
    8000437e:	8552                	mv	a0,s4
    80004380:	60e6                	ld	ra,88(sp)
    80004382:	6446                	ld	s0,80(sp)
    80004384:	64a6                	ld	s1,72(sp)
    80004386:	6906                	ld	s2,64(sp)
    80004388:	79e2                	ld	s3,56(sp)
    8000438a:	7a42                	ld	s4,48(sp)
    8000438c:	7aa2                	ld	s5,40(sp)
    8000438e:	7b02                	ld	s6,32(sp)
    80004390:	6be2                	ld	s7,24(sp)
    80004392:	6c42                	ld	s8,16(sp)
    80004394:	6ca2                	ld	s9,8(sp)
    80004396:	6d02                	ld	s10,0(sp)
    80004398:	6125                	addi	sp,sp,96
    8000439a:	8082                	ret
      iunlock(ip);
    8000439c:	8552                	mv	a0,s4
    8000439e:	9edff0ef          	jal	80003d8a <iunlock>
      return ip;
    800043a2:	bff1                	j	8000437e <namex+0x5c>
      iunlockput(ip);
    800043a4:	8552                	mv	a0,s4
    800043a6:	b43ff0ef          	jal	80003ee8 <iunlockput>
      return 0;
    800043aa:	8a4a                	mv	s4,s2
    800043ac:	bfc9                	j	8000437e <namex+0x5c>
  len = path - s;
    800043ae:	40990633          	sub	a2,s2,s1
    800043b2:	00060d1b          	sext.w	s10,a2
  if(len >= DIRSIZ)
    800043b6:	09ac5463          	bge	s8,s10,8000443e <namex+0x11c>
    memmove(name, s, DIRSIZ);
    800043ba:	8666                	mv	a2,s9
    800043bc:	85a6                	mv	a1,s1
    800043be:	8556                	mv	a0,s5
    800043c0:	999fc0ef          	jal	80000d58 <memmove>
    800043c4:	84ca                	mv	s1,s2
  while(*path == '/')
    800043c6:	0004c783          	lbu	a5,0(s1)
    800043ca:	01379763          	bne	a5,s3,800043d8 <namex+0xb6>
    path++;
    800043ce:	0485                	addi	s1,s1,1
  while(*path == '/')
    800043d0:	0004c783          	lbu	a5,0(s1)
    800043d4:	ff378de3          	beq	a5,s3,800043ce <namex+0xac>
    ilock(ip);
    800043d8:	8552                	mv	a0,s4
    800043da:	903ff0ef          	jal	80003cdc <ilock>
    if(ip->type != T_DIR){
    800043de:	044a1783          	lh	a5,68(s4)
    800043e2:	f9779ae3          	bne	a5,s7,80004376 <namex+0x54>
    if(nameiparent && *path == '\0'){
    800043e6:	000b0563          	beqz	s6,800043f0 <namex+0xce>
    800043ea:	0004c783          	lbu	a5,0(s1)
    800043ee:	d7dd                	beqz	a5,8000439c <namex+0x7a>
    if((next = dirlookup(ip, name, 0)) == 0){
    800043f0:	4601                	li	a2,0
    800043f2:	85d6                	mv	a1,s5
    800043f4:	8552                	mv	a0,s4
    800043f6:	e81ff0ef          	jal	80004276 <dirlookup>
    800043fa:	892a                	mv	s2,a0
    800043fc:	d545                	beqz	a0,800043a4 <namex+0x82>
    iunlockput(ip);
    800043fe:	8552                	mv	a0,s4
    80004400:	ae9ff0ef          	jal	80003ee8 <iunlockput>
    ip = next;
    80004404:	8a4a                	mv	s4,s2
  while(*path == '/')
    80004406:	0004c783          	lbu	a5,0(s1)
    8000440a:	01379763          	bne	a5,s3,80004418 <namex+0xf6>
    path++;
    8000440e:	0485                	addi	s1,s1,1
  while(*path == '/')
    80004410:	0004c783          	lbu	a5,0(s1)
    80004414:	ff378de3          	beq	a5,s3,8000440e <namex+0xec>
  if(*path == 0)
    80004418:	cf8d                	beqz	a5,80004452 <namex+0x130>
  while(*path != '/' && *path != 0)
    8000441a:	0004c783          	lbu	a5,0(s1)
    8000441e:	fd178713          	addi	a4,a5,-47
    80004422:	cb19                	beqz	a4,80004438 <namex+0x116>
    80004424:	cb91                	beqz	a5,80004438 <namex+0x116>
    80004426:	8926                	mv	s2,s1
    path++;
    80004428:	0905                	addi	s2,s2,1
  while(*path != '/' && *path != 0)
    8000442a:	00094783          	lbu	a5,0(s2)
    8000442e:	fd178713          	addi	a4,a5,-47
    80004432:	df35                	beqz	a4,800043ae <namex+0x8c>
    80004434:	fbf5                	bnez	a5,80004428 <namex+0x106>
    80004436:	bfa5                	j	800043ae <namex+0x8c>
    80004438:	8926                	mv	s2,s1
  len = path - s;
    8000443a:	4d01                	li	s10,0
    8000443c:	4601                	li	a2,0
    memmove(name, s, len);
    8000443e:	2601                	sext.w	a2,a2
    80004440:	85a6                	mv	a1,s1
    80004442:	8556                	mv	a0,s5
    80004444:	915fc0ef          	jal	80000d58 <memmove>
    name[len] = 0;
    80004448:	9d56                	add	s10,s10,s5
    8000444a:	000d0023          	sb	zero,0(s10) # fffffffffffff000 <end+0xffffffff7dd8a258>
    8000444e:	84ca                	mv	s1,s2
    80004450:	bf9d                	j	800043c6 <namex+0xa4>
  if(nameiparent){
    80004452:	f20b06e3          	beqz	s6,8000437e <namex+0x5c>
    iput(ip);
    80004456:	8552                	mv	a0,s4
    80004458:	a07ff0ef          	jal	80003e5e <iput>
    return 0;
    8000445c:	4a01                	li	s4,0
    8000445e:	b705                	j	8000437e <namex+0x5c>

0000000080004460 <dirlink>:
{
    80004460:	715d                	addi	sp,sp,-80
    80004462:	e486                	sd	ra,72(sp)
    80004464:	e0a2                	sd	s0,64(sp)
    80004466:	f84a                	sd	s2,48(sp)
    80004468:	ec56                	sd	s5,24(sp)
    8000446a:	e85a                	sd	s6,16(sp)
    8000446c:	0880                	addi	s0,sp,80
    8000446e:	892a                	mv	s2,a0
    80004470:	8aae                	mv	s5,a1
    80004472:	8b32                	mv	s6,a2
  if((ip = dirlookup(dp, name, 0)) != 0){
    80004474:	4601                	li	a2,0
    80004476:	e01ff0ef          	jal	80004276 <dirlookup>
    8000447a:	ed1d                	bnez	a0,800044b8 <dirlink+0x58>
    8000447c:	fc26                	sd	s1,56(sp)
  for(off = 0; off < dp->size; off += sizeof(de)){
    8000447e:	04c92483          	lw	s1,76(s2)
    80004482:	c4b9                	beqz	s1,800044d0 <dirlink+0x70>
    80004484:	f44e                	sd	s3,40(sp)
    80004486:	f052                	sd	s4,32(sp)
    80004488:	4481                	li	s1,0
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    8000448a:	fb040a13          	addi	s4,s0,-80
    8000448e:	49c1                	li	s3,16
    80004490:	874e                	mv	a4,s3
    80004492:	86a6                	mv	a3,s1
    80004494:	8652                	mv	a2,s4
    80004496:	4581                	li	a1,0
    80004498:	854a                	mv	a0,s2
    8000449a:	bd5ff0ef          	jal	8000406e <readi>
    8000449e:	03351163          	bne	a0,s3,800044c0 <dirlink+0x60>
    if(de.inum == 0)
    800044a2:	fb045783          	lhu	a5,-80(s0)
    800044a6:	c39d                	beqz	a5,800044cc <dirlink+0x6c>
  for(off = 0; off < dp->size; off += sizeof(de)){
    800044a8:	24c1                	addiw	s1,s1,16
    800044aa:	04c92783          	lw	a5,76(s2)
    800044ae:	fef4e1e3          	bltu	s1,a5,80004490 <dirlink+0x30>
    800044b2:	79a2                	ld	s3,40(sp)
    800044b4:	7a02                	ld	s4,32(sp)
    800044b6:	a829                	j	800044d0 <dirlink+0x70>
    iput(ip);
    800044b8:	9a7ff0ef          	jal	80003e5e <iput>
    return -1;
    800044bc:	557d                	li	a0,-1
    800044be:	a83d                	j	800044fc <dirlink+0x9c>
      panic("dirlink read");
    800044c0:	00004517          	auipc	a0,0x4
    800044c4:	30050513          	addi	a0,a0,768 # 800087c0 <etext+0x7c0>
    800044c8:	b5cfc0ef          	jal	80000824 <panic>
    800044cc:	79a2                	ld	s3,40(sp)
    800044ce:	7a02                	ld	s4,32(sp)
  strncpy(de.name, name, DIRSIZ);
    800044d0:	4639                	li	a2,14
    800044d2:	85d6                	mv	a1,s5
    800044d4:	fb240513          	addi	a0,s0,-78
    800044d8:	92ffc0ef          	jal	80000e06 <strncpy>
  de.inum = inum;
    800044dc:	fb641823          	sh	s6,-80(s0)
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    800044e0:	4741                	li	a4,16
    800044e2:	86a6                	mv	a3,s1
    800044e4:	fb040613          	addi	a2,s0,-80
    800044e8:	4581                	li	a1,0
    800044ea:	854a                	mv	a0,s2
    800044ec:	c75ff0ef          	jal	80004160 <writei>
    800044f0:	1541                	addi	a0,a0,-16
    800044f2:	00a03533          	snez	a0,a0
    800044f6:	40a0053b          	negw	a0,a0
    800044fa:	74e2                	ld	s1,56(sp)
}
    800044fc:	60a6                	ld	ra,72(sp)
    800044fe:	6406                	ld	s0,64(sp)
    80004500:	7942                	ld	s2,48(sp)
    80004502:	6ae2                	ld	s5,24(sp)
    80004504:	6b42                	ld	s6,16(sp)
    80004506:	6161                	addi	sp,sp,80
    80004508:	8082                	ret

000000008000450a <namei>:

struct inode*
namei(char *path)
{
    8000450a:	1101                	addi	sp,sp,-32
    8000450c:	ec06                	sd	ra,24(sp)
    8000450e:	e822                	sd	s0,16(sp)
    80004510:	1000                	addi	s0,sp,32
  char name[DIRSIZ];
  return namex(path, 0, name);
    80004512:	fe040613          	addi	a2,s0,-32
    80004516:	4581                	li	a1,0
    80004518:	e0bff0ef          	jal	80004322 <namex>
}
    8000451c:	60e2                	ld	ra,24(sp)
    8000451e:	6442                	ld	s0,16(sp)
    80004520:	6105                	addi	sp,sp,32
    80004522:	8082                	ret

0000000080004524 <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
    80004524:	1141                	addi	sp,sp,-16
    80004526:	e406                	sd	ra,8(sp)
    80004528:	e022                	sd	s0,0(sp)
    8000452a:	0800                	addi	s0,sp,16
    8000452c:	862e                	mv	a2,a1
  return namex(path, 1, name);
    8000452e:	4585                	li	a1,1
    80004530:	df3ff0ef          	jal	80004322 <namex>
}
    80004534:	60a2                	ld	ra,8(sp)
    80004536:	6402                	ld	s0,0(sp)
    80004538:	0141                	addi	sp,sp,16
    8000453a:	8082                	ret

000000008000453c <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
    8000453c:	1101                	addi	sp,sp,-32
    8000453e:	ec06                	sd	ra,24(sp)
    80004540:	e822                	sd	s0,16(sp)
    80004542:	e426                	sd	s1,8(sp)
    80004544:	e04a                	sd	s2,0(sp)
    80004546:	1000                	addi	s0,sp,32
  struct buf *buf = bread(log.dev, log.start);
    80004548:	0226f917          	auipc	s2,0x226f
    8000454c:	62090913          	addi	s2,s2,1568 # 82273b68 <log>
    80004550:	01892583          	lw	a1,24(s2)
    80004554:	02492503          	lw	a0,36(s2)
    80004558:	8ecff0ef          	jal	80003644 <bread>
    8000455c:	84aa                	mv	s1,a0
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
    8000455e:	02892603          	lw	a2,40(s2)
    80004562:	cd30                	sw	a2,88(a0)
  for (i = 0; i < log.lh.n; i++) {
    80004564:	00c05f63          	blez	a2,80004582 <write_head+0x46>
    80004568:	0226f717          	auipc	a4,0x226f
    8000456c:	62c70713          	addi	a4,a4,1580 # 82273b94 <log+0x2c>
    80004570:	87aa                	mv	a5,a0
    80004572:	060a                	slli	a2,a2,0x2
    80004574:	962a                	add	a2,a2,a0
    hb->block[i] = log.lh.block[i];
    80004576:	4314                	lw	a3,0(a4)
    80004578:	cff4                	sw	a3,92(a5)
  for (i = 0; i < log.lh.n; i++) {
    8000457a:	0711                	addi	a4,a4,4
    8000457c:	0791                	addi	a5,a5,4
    8000457e:	fec79ce3          	bne	a5,a2,80004576 <write_head+0x3a>
  }
  bwrite(buf);
    80004582:	8526                	mv	a0,s1
    80004584:	996ff0ef          	jal	8000371a <bwrite>
  brelse(buf);
    80004588:	8526                	mv	a0,s1
    8000458a:	9c2ff0ef          	jal	8000374c <brelse>
}
    8000458e:	60e2                	ld	ra,24(sp)
    80004590:	6442                	ld	s0,16(sp)
    80004592:	64a2                	ld	s1,8(sp)
    80004594:	6902                	ld	s2,0(sp)
    80004596:	6105                	addi	sp,sp,32
    80004598:	8082                	ret

000000008000459a <install_trans>:
  for (tail = 0; tail < log.lh.n; tail++) {
    8000459a:	0226f797          	auipc	a5,0x226f
    8000459e:	5f67a783          	lw	a5,1526(a5) # 82273b90 <log+0x28>
    800045a2:	0cf05163          	blez	a5,80004664 <install_trans+0xca>
{
    800045a6:	715d                	addi	sp,sp,-80
    800045a8:	e486                	sd	ra,72(sp)
    800045aa:	e0a2                	sd	s0,64(sp)
    800045ac:	fc26                	sd	s1,56(sp)
    800045ae:	f84a                	sd	s2,48(sp)
    800045b0:	f44e                	sd	s3,40(sp)
    800045b2:	f052                	sd	s4,32(sp)
    800045b4:	ec56                	sd	s5,24(sp)
    800045b6:	e85a                	sd	s6,16(sp)
    800045b8:	e45e                	sd	s7,8(sp)
    800045ba:	e062                	sd	s8,0(sp)
    800045bc:	0880                	addi	s0,sp,80
    800045be:	8b2a                	mv	s6,a0
    800045c0:	0226fa97          	auipc	s5,0x226f
    800045c4:	5d4a8a93          	addi	s5,s5,1492 # 82273b94 <log+0x2c>
  for (tail = 0; tail < log.lh.n; tail++) {
    800045c8:	4981                	li	s3,0
      printf("recovering tail %d dst %d\n", tail, log.lh.block[tail]);
    800045ca:	00004c17          	auipc	s8,0x4
    800045ce:	206c0c13          	addi	s8,s8,518 # 800087d0 <etext+0x7d0>
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    800045d2:	0226fa17          	auipc	s4,0x226f
    800045d6:	596a0a13          	addi	s4,s4,1430 # 82273b68 <log>
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
    800045da:	40000b93          	li	s7,1024
    800045de:	a025                	j	80004606 <install_trans+0x6c>
      printf("recovering tail %d dst %d\n", tail, log.lh.block[tail]);
    800045e0:	000aa603          	lw	a2,0(s5)
    800045e4:	85ce                	mv	a1,s3
    800045e6:	8562                	mv	a0,s8
    800045e8:	f13fb0ef          	jal	800004fa <printf>
    800045ec:	a839                	j	8000460a <install_trans+0x70>
    brelse(lbuf);
    800045ee:	854a                	mv	a0,s2
    800045f0:	95cff0ef          	jal	8000374c <brelse>
    brelse(dbuf);
    800045f4:	8526                	mv	a0,s1
    800045f6:	956ff0ef          	jal	8000374c <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    800045fa:	2985                	addiw	s3,s3,1
    800045fc:	0a91                	addi	s5,s5,4
    800045fe:	028a2783          	lw	a5,40(s4)
    80004602:	04f9d563          	bge	s3,a5,8000464c <install_trans+0xb2>
    if(recovering) {
    80004606:	fc0b1de3          	bnez	s6,800045e0 <install_trans+0x46>
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    8000460a:	018a2583          	lw	a1,24(s4)
    8000460e:	013585bb          	addw	a1,a1,s3
    80004612:	2585                	addiw	a1,a1,1
    80004614:	024a2503          	lw	a0,36(s4)
    80004618:	82cff0ef          	jal	80003644 <bread>
    8000461c:	892a                	mv	s2,a0
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
    8000461e:	000aa583          	lw	a1,0(s5)
    80004622:	024a2503          	lw	a0,36(s4)
    80004626:	81eff0ef          	jal	80003644 <bread>
    8000462a:	84aa                	mv	s1,a0
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
    8000462c:	865e                	mv	a2,s7
    8000462e:	05890593          	addi	a1,s2,88
    80004632:	05850513          	addi	a0,a0,88
    80004636:	f22fc0ef          	jal	80000d58 <memmove>
    bwrite(dbuf);  // write dst to disk
    8000463a:	8526                	mv	a0,s1
    8000463c:	8deff0ef          	jal	8000371a <bwrite>
    if(recovering == 0)
    80004640:	fa0b17e3          	bnez	s6,800045ee <install_trans+0x54>
      bunpin(dbuf);
    80004644:	8526                	mv	a0,s1
    80004646:	9beff0ef          	jal	80003804 <bunpin>
    8000464a:	b755                	j	800045ee <install_trans+0x54>
}
    8000464c:	60a6                	ld	ra,72(sp)
    8000464e:	6406                	ld	s0,64(sp)
    80004650:	74e2                	ld	s1,56(sp)
    80004652:	7942                	ld	s2,48(sp)
    80004654:	79a2                	ld	s3,40(sp)
    80004656:	7a02                	ld	s4,32(sp)
    80004658:	6ae2                	ld	s5,24(sp)
    8000465a:	6b42                	ld	s6,16(sp)
    8000465c:	6ba2                	ld	s7,8(sp)
    8000465e:	6c02                	ld	s8,0(sp)
    80004660:	6161                	addi	sp,sp,80
    80004662:	8082                	ret
    80004664:	8082                	ret

0000000080004666 <initlog>:
{
    80004666:	7179                	addi	sp,sp,-48
    80004668:	f406                	sd	ra,40(sp)
    8000466a:	f022                	sd	s0,32(sp)
    8000466c:	ec26                	sd	s1,24(sp)
    8000466e:	e84a                	sd	s2,16(sp)
    80004670:	e44e                	sd	s3,8(sp)
    80004672:	1800                	addi	s0,sp,48
    80004674:	84aa                	mv	s1,a0
    80004676:	89ae                	mv	s3,a1
  initlock(&log.lock, "log");
    80004678:	0226f917          	auipc	s2,0x226f
    8000467c:	4f090913          	addi	s2,s2,1264 # 82273b68 <log>
    80004680:	00004597          	auipc	a1,0x4
    80004684:	17058593          	addi	a1,a1,368 # 800087f0 <etext+0x7f0>
    80004688:	854a                	mv	a0,s2
    8000468a:	d14fc0ef          	jal	80000b9e <initlock>
  log.start = sb->logstart;
    8000468e:	0149a583          	lw	a1,20(s3)
    80004692:	00b92c23          	sw	a1,24(s2)
  log.dev = dev;
    80004696:	02992223          	sw	s1,36(s2)
  struct buf *buf = bread(log.dev, log.start);
    8000469a:	8526                	mv	a0,s1
    8000469c:	fa9fe0ef          	jal	80003644 <bread>
  log.lh.n = lh->n;
    800046a0:	4d30                	lw	a2,88(a0)
    800046a2:	02c92423          	sw	a2,40(s2)
  for (i = 0; i < log.lh.n; i++) {
    800046a6:	00c05f63          	blez	a2,800046c4 <initlog+0x5e>
    800046aa:	87aa                	mv	a5,a0
    800046ac:	0226f717          	auipc	a4,0x226f
    800046b0:	4e870713          	addi	a4,a4,1256 # 82273b94 <log+0x2c>
    800046b4:	060a                	slli	a2,a2,0x2
    800046b6:	962a                	add	a2,a2,a0
    log.lh.block[i] = lh->block[i];
    800046b8:	4ff4                	lw	a3,92(a5)
    800046ba:	c314                	sw	a3,0(a4)
  for (i = 0; i < log.lh.n; i++) {
    800046bc:	0791                	addi	a5,a5,4
    800046be:	0711                	addi	a4,a4,4
    800046c0:	fec79ce3          	bne	a5,a2,800046b8 <initlog+0x52>
  brelse(buf);
    800046c4:	888ff0ef          	jal	8000374c <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(1); // if committed, copy from log to disk
    800046c8:	4505                	li	a0,1
    800046ca:	ed1ff0ef          	jal	8000459a <install_trans>
  log.lh.n = 0;
    800046ce:	0226f797          	auipc	a5,0x226f
    800046d2:	4c07a123          	sw	zero,1218(a5) # 82273b90 <log+0x28>
  write_head(); // clear the log
    800046d6:	e67ff0ef          	jal	8000453c <write_head>
}
    800046da:	70a2                	ld	ra,40(sp)
    800046dc:	7402                	ld	s0,32(sp)
    800046de:	64e2                	ld	s1,24(sp)
    800046e0:	6942                	ld	s2,16(sp)
    800046e2:	69a2                	ld	s3,8(sp)
    800046e4:	6145                	addi	sp,sp,48
    800046e6:	8082                	ret

00000000800046e8 <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
    800046e8:	1101                	addi	sp,sp,-32
    800046ea:	ec06                	sd	ra,24(sp)
    800046ec:	e822                	sd	s0,16(sp)
    800046ee:	e426                	sd	s1,8(sp)
    800046f0:	e04a                	sd	s2,0(sp)
    800046f2:	1000                	addi	s0,sp,32
  acquire(&log.lock);
    800046f4:	0226f517          	auipc	a0,0x226f
    800046f8:	47450513          	addi	a0,a0,1140 # 82273b68 <log>
    800046fc:	d2cfc0ef          	jal	80000c28 <acquire>
  while(1){
    if(log.committing){
    80004700:	0226f497          	auipc	s1,0x226f
    80004704:	46848493          	addi	s1,s1,1128 # 82273b68 <log>
      sleep(&log, &log.lock);
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGBLOCKS){
    80004708:	4979                	li	s2,30
    8000470a:	a029                	j	80004714 <begin_op+0x2c>
      sleep(&log, &log.lock);
    8000470c:	85a6                	mv	a1,s1
    8000470e:	8526                	mv	a0,s1
    80004710:	fcbfd0ef          	jal	800026da <sleep>
    if(log.committing){
    80004714:	509c                	lw	a5,32(s1)
    80004716:	fbfd                	bnez	a5,8000470c <begin_op+0x24>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGBLOCKS){
    80004718:	4cd8                	lw	a4,28(s1)
    8000471a:	2705                	addiw	a4,a4,1
    8000471c:	0027179b          	slliw	a5,a4,0x2
    80004720:	9fb9                	addw	a5,a5,a4
    80004722:	0017979b          	slliw	a5,a5,0x1
    80004726:	5494                	lw	a3,40(s1)
    80004728:	9fb5                	addw	a5,a5,a3
    8000472a:	00f95763          	bge	s2,a5,80004738 <begin_op+0x50>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    8000472e:	85a6                	mv	a1,s1
    80004730:	8526                	mv	a0,s1
    80004732:	fa9fd0ef          	jal	800026da <sleep>
    80004736:	bff9                	j	80004714 <begin_op+0x2c>
    } else {
      log.outstanding += 1;
    80004738:	0226f797          	auipc	a5,0x226f
    8000473c:	44e7a623          	sw	a4,1100(a5) # 82273b84 <log+0x1c>
      release(&log.lock);
    80004740:	0226f517          	auipc	a0,0x226f
    80004744:	42850513          	addi	a0,a0,1064 # 82273b68 <log>
    80004748:	d74fc0ef          	jal	80000cbc <release>
      break;
    }
  }
}
    8000474c:	60e2                	ld	ra,24(sp)
    8000474e:	6442                	ld	s0,16(sp)
    80004750:	64a2                	ld	s1,8(sp)
    80004752:	6902                	ld	s2,0(sp)
    80004754:	6105                	addi	sp,sp,32
    80004756:	8082                	ret

0000000080004758 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
    80004758:	7139                	addi	sp,sp,-64
    8000475a:	fc06                	sd	ra,56(sp)
    8000475c:	f822                	sd	s0,48(sp)
    8000475e:	f426                	sd	s1,40(sp)
    80004760:	f04a                	sd	s2,32(sp)
    80004762:	0080                	addi	s0,sp,64
  int do_commit = 0;

  acquire(&log.lock);
    80004764:	0226f497          	auipc	s1,0x226f
    80004768:	40448493          	addi	s1,s1,1028 # 82273b68 <log>
    8000476c:	8526                	mv	a0,s1
    8000476e:	cbafc0ef          	jal	80000c28 <acquire>
  log.outstanding -= 1;
    80004772:	4cdc                	lw	a5,28(s1)
    80004774:	37fd                	addiw	a5,a5,-1
    80004776:	893e                	mv	s2,a5
    80004778:	ccdc                	sw	a5,28(s1)
  if(log.committing)
    8000477a:	509c                	lw	a5,32(s1)
    8000477c:	e7b1                	bnez	a5,800047c8 <end_op+0x70>
    panic("log.committing");
  if(log.outstanding == 0){
    8000477e:	04091e63          	bnez	s2,800047da <end_op+0x82>
    do_commit = 1;
    log.committing = 1;
    80004782:	0226f497          	auipc	s1,0x226f
    80004786:	3e648493          	addi	s1,s1,998 # 82273b68 <log>
    8000478a:	4785                	li	a5,1
    8000478c:	d09c                	sw	a5,32(s1)
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
    8000478e:	8526                	mv	a0,s1
    80004790:	d2cfc0ef          	jal	80000cbc <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
    80004794:	549c                	lw	a5,40(s1)
    80004796:	06f04463          	bgtz	a5,800047fe <end_op+0xa6>
    acquire(&log.lock);
    8000479a:	0226f517          	auipc	a0,0x226f
    8000479e:	3ce50513          	addi	a0,a0,974 # 82273b68 <log>
    800047a2:	c86fc0ef          	jal	80000c28 <acquire>
    log.committing = 0;
    800047a6:	0226f797          	auipc	a5,0x226f
    800047aa:	3e07a123          	sw	zero,994(a5) # 82273b88 <log+0x20>
    wakeup(&log);
    800047ae:	0226f517          	auipc	a0,0x226f
    800047b2:	3ba50513          	addi	a0,a0,954 # 82273b68 <log>
    800047b6:	f71fd0ef          	jal	80002726 <wakeup>
    release(&log.lock);
    800047ba:	0226f517          	auipc	a0,0x226f
    800047be:	3ae50513          	addi	a0,a0,942 # 82273b68 <log>
    800047c2:	cfafc0ef          	jal	80000cbc <release>
}
    800047c6:	a035                	j	800047f2 <end_op+0x9a>
    800047c8:	ec4e                	sd	s3,24(sp)
    800047ca:	e852                	sd	s4,16(sp)
    800047cc:	e456                	sd	s5,8(sp)
    panic("log.committing");
    800047ce:	00004517          	auipc	a0,0x4
    800047d2:	02a50513          	addi	a0,a0,42 # 800087f8 <etext+0x7f8>
    800047d6:	84efc0ef          	jal	80000824 <panic>
    wakeup(&log);
    800047da:	0226f517          	auipc	a0,0x226f
    800047de:	38e50513          	addi	a0,a0,910 # 82273b68 <log>
    800047e2:	f45fd0ef          	jal	80002726 <wakeup>
  release(&log.lock);
    800047e6:	0226f517          	auipc	a0,0x226f
    800047ea:	38250513          	addi	a0,a0,898 # 82273b68 <log>
    800047ee:	ccefc0ef          	jal	80000cbc <release>
}
    800047f2:	70e2                	ld	ra,56(sp)
    800047f4:	7442                	ld	s0,48(sp)
    800047f6:	74a2                	ld	s1,40(sp)
    800047f8:	7902                	ld	s2,32(sp)
    800047fa:	6121                	addi	sp,sp,64
    800047fc:	8082                	ret
    800047fe:	ec4e                	sd	s3,24(sp)
    80004800:	e852                	sd	s4,16(sp)
    80004802:	e456                	sd	s5,8(sp)
  for (tail = 0; tail < log.lh.n; tail++) {
    80004804:	0226fa97          	auipc	s5,0x226f
    80004808:	390a8a93          	addi	s5,s5,912 # 82273b94 <log+0x2c>
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
    8000480c:	0226fa17          	auipc	s4,0x226f
    80004810:	35ca0a13          	addi	s4,s4,860 # 82273b68 <log>
    80004814:	018a2583          	lw	a1,24(s4)
    80004818:	012585bb          	addw	a1,a1,s2
    8000481c:	2585                	addiw	a1,a1,1
    8000481e:	024a2503          	lw	a0,36(s4)
    80004822:	e23fe0ef          	jal	80003644 <bread>
    80004826:	84aa                	mv	s1,a0
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
    80004828:	000aa583          	lw	a1,0(s5)
    8000482c:	024a2503          	lw	a0,36(s4)
    80004830:	e15fe0ef          	jal	80003644 <bread>
    80004834:	89aa                	mv	s3,a0
    memmove(to->data, from->data, BSIZE);
    80004836:	40000613          	li	a2,1024
    8000483a:	05850593          	addi	a1,a0,88
    8000483e:	05848513          	addi	a0,s1,88
    80004842:	d16fc0ef          	jal	80000d58 <memmove>
    bwrite(to);  // write the log
    80004846:	8526                	mv	a0,s1
    80004848:	ed3fe0ef          	jal	8000371a <bwrite>
    brelse(from);
    8000484c:	854e                	mv	a0,s3
    8000484e:	efffe0ef          	jal	8000374c <brelse>
    brelse(to);
    80004852:	8526                	mv	a0,s1
    80004854:	ef9fe0ef          	jal	8000374c <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    80004858:	2905                	addiw	s2,s2,1
    8000485a:	0a91                	addi	s5,s5,4
    8000485c:	028a2783          	lw	a5,40(s4)
    80004860:	faf94ae3          	blt	s2,a5,80004814 <end_op+0xbc>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
    80004864:	cd9ff0ef          	jal	8000453c <write_head>
    install_trans(0); // Now install writes to home locations
    80004868:	4501                	li	a0,0
    8000486a:	d31ff0ef          	jal	8000459a <install_trans>
    log.lh.n = 0;
    8000486e:	0226f797          	auipc	a5,0x226f
    80004872:	3207a123          	sw	zero,802(a5) # 82273b90 <log+0x28>
    write_head();    // Erase the transaction from the log
    80004876:	cc7ff0ef          	jal	8000453c <write_head>
    8000487a:	69e2                	ld	s3,24(sp)
    8000487c:	6a42                	ld	s4,16(sp)
    8000487e:	6aa2                	ld	s5,8(sp)
    80004880:	bf29                	j	8000479a <end_op+0x42>

0000000080004882 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
    80004882:	1101                	addi	sp,sp,-32
    80004884:	ec06                	sd	ra,24(sp)
    80004886:	e822                	sd	s0,16(sp)
    80004888:	e426                	sd	s1,8(sp)
    8000488a:	1000                	addi	s0,sp,32
    8000488c:	84aa                	mv	s1,a0
  int i;

  acquire(&log.lock);
    8000488e:	0226f517          	auipc	a0,0x226f
    80004892:	2da50513          	addi	a0,a0,730 # 82273b68 <log>
    80004896:	b92fc0ef          	jal	80000c28 <acquire>
  if (log.lh.n >= LOGBLOCKS)
    8000489a:	0226f617          	auipc	a2,0x226f
    8000489e:	2f662603          	lw	a2,758(a2) # 82273b90 <log+0x28>
    800048a2:	47f5                	li	a5,29
    800048a4:	04c7cd63          	blt	a5,a2,800048fe <log_write+0x7c>
    panic("too big a transaction");
  if (log.outstanding < 1)
    800048a8:	0226f797          	auipc	a5,0x226f
    800048ac:	2dc7a783          	lw	a5,732(a5) # 82273b84 <log+0x1c>
    800048b0:	04f05d63          	blez	a5,8000490a <log_write+0x88>
    panic("log_write outside of trans");

  for (i = 0; i < log.lh.n; i++) {
    800048b4:	4781                	li	a5,0
    800048b6:	06c05063          	blez	a2,80004916 <log_write+0x94>
    if (log.lh.block[i] == b->blockno)   // log absorption
    800048ba:	44cc                	lw	a1,12(s1)
    800048bc:	0226f717          	auipc	a4,0x226f
    800048c0:	2d870713          	addi	a4,a4,728 # 82273b94 <log+0x2c>
  for (i = 0; i < log.lh.n; i++) {
    800048c4:	4781                	li	a5,0
    if (log.lh.block[i] == b->blockno)   // log absorption
    800048c6:	4314                	lw	a3,0(a4)
    800048c8:	04b68763          	beq	a3,a1,80004916 <log_write+0x94>
  for (i = 0; i < log.lh.n; i++) {
    800048cc:	2785                	addiw	a5,a5,1
    800048ce:	0711                	addi	a4,a4,4
    800048d0:	fef61be3          	bne	a2,a5,800048c6 <log_write+0x44>
      break;
  }
  log.lh.block[i] = b->blockno;
    800048d4:	060a                	slli	a2,a2,0x2
    800048d6:	02060613          	addi	a2,a2,32
    800048da:	0226f797          	auipc	a5,0x226f
    800048de:	28e78793          	addi	a5,a5,654 # 82273b68 <log>
    800048e2:	97b2                	add	a5,a5,a2
    800048e4:	44d8                	lw	a4,12(s1)
    800048e6:	c7d8                	sw	a4,12(a5)
  if (i == log.lh.n) {  // Add new block to log?
    bpin(b);
    800048e8:	8526                	mv	a0,s1
    800048ea:	ee7fe0ef          	jal	800037d0 <bpin>
    log.lh.n++;
    800048ee:	0226f717          	auipc	a4,0x226f
    800048f2:	27a70713          	addi	a4,a4,634 # 82273b68 <log>
    800048f6:	571c                	lw	a5,40(a4)
    800048f8:	2785                	addiw	a5,a5,1
    800048fa:	d71c                	sw	a5,40(a4)
    800048fc:	a815                	j	80004930 <log_write+0xae>
    panic("too big a transaction");
    800048fe:	00004517          	auipc	a0,0x4
    80004902:	f0a50513          	addi	a0,a0,-246 # 80008808 <etext+0x808>
    80004906:	f1ffb0ef          	jal	80000824 <panic>
    panic("log_write outside of trans");
    8000490a:	00004517          	auipc	a0,0x4
    8000490e:	f1650513          	addi	a0,a0,-234 # 80008820 <etext+0x820>
    80004912:	f13fb0ef          	jal	80000824 <panic>
  log.lh.block[i] = b->blockno;
    80004916:	00279693          	slli	a3,a5,0x2
    8000491a:	02068693          	addi	a3,a3,32
    8000491e:	0226f717          	auipc	a4,0x226f
    80004922:	24a70713          	addi	a4,a4,586 # 82273b68 <log>
    80004926:	9736                	add	a4,a4,a3
    80004928:	44d4                	lw	a3,12(s1)
    8000492a:	c754                	sw	a3,12(a4)
  if (i == log.lh.n) {  // Add new block to log?
    8000492c:	faf60ee3          	beq	a2,a5,800048e8 <log_write+0x66>
  }
  release(&log.lock);
    80004930:	0226f517          	auipc	a0,0x226f
    80004934:	23850513          	addi	a0,a0,568 # 82273b68 <log>
    80004938:	b84fc0ef          	jal	80000cbc <release>
}
    8000493c:	60e2                	ld	ra,24(sp)
    8000493e:	6442                	ld	s0,16(sp)
    80004940:	64a2                	ld	s1,8(sp)
    80004942:	6105                	addi	sp,sp,32
    80004944:	8082                	ret

0000000080004946 <initsleeplock>:
#include "proc.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
    80004946:	1101                	addi	sp,sp,-32
    80004948:	ec06                	sd	ra,24(sp)
    8000494a:	e822                	sd	s0,16(sp)
    8000494c:	e426                	sd	s1,8(sp)
    8000494e:	e04a                	sd	s2,0(sp)
    80004950:	1000                	addi	s0,sp,32
    80004952:	84aa                	mv	s1,a0
    80004954:	892e                	mv	s2,a1
  initlock(&lk->lk, "sleep lock");
    80004956:	00004597          	auipc	a1,0x4
    8000495a:	eea58593          	addi	a1,a1,-278 # 80008840 <etext+0x840>
    8000495e:	0521                	addi	a0,a0,8
    80004960:	a3efc0ef          	jal	80000b9e <initlock>
  lk->name = name;
    80004964:	0324b023          	sd	s2,32(s1)
  lk->locked = 0;
    80004968:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    8000496c:	0204a423          	sw	zero,40(s1)
}
    80004970:	60e2                	ld	ra,24(sp)
    80004972:	6442                	ld	s0,16(sp)
    80004974:	64a2                	ld	s1,8(sp)
    80004976:	6902                	ld	s2,0(sp)
    80004978:	6105                	addi	sp,sp,32
    8000497a:	8082                	ret

000000008000497c <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
    8000497c:	1101                	addi	sp,sp,-32
    8000497e:	ec06                	sd	ra,24(sp)
    80004980:	e822                	sd	s0,16(sp)
    80004982:	e426                	sd	s1,8(sp)
    80004984:	e04a                	sd	s2,0(sp)
    80004986:	1000                	addi	s0,sp,32
    80004988:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    8000498a:	00850913          	addi	s2,a0,8
    8000498e:	854a                	mv	a0,s2
    80004990:	a98fc0ef          	jal	80000c28 <acquire>
  while (lk->locked) {
    80004994:	409c                	lw	a5,0(s1)
    80004996:	c799                	beqz	a5,800049a4 <acquiresleep+0x28>
    sleep(lk, &lk->lk);
    80004998:	85ca                	mv	a1,s2
    8000499a:	8526                	mv	a0,s1
    8000499c:	d3ffd0ef          	jal	800026da <sleep>
  while (lk->locked) {
    800049a0:	409c                	lw	a5,0(s1)
    800049a2:	fbfd                	bnez	a5,80004998 <acquiresleep+0x1c>
  }
  lk->locked = 1;
    800049a4:	4785                	li	a5,1
    800049a6:	c09c                	sw	a5,0(s1)
  lk->pid = myproc()->pid;
    800049a8:	e10fd0ef          	jal	80001fb8 <myproc>
    800049ac:	591c                	lw	a5,48(a0)
    800049ae:	d49c                	sw	a5,40(s1)
  release(&lk->lk);
    800049b0:	854a                	mv	a0,s2
    800049b2:	b0afc0ef          	jal	80000cbc <release>
}
    800049b6:	60e2                	ld	ra,24(sp)
    800049b8:	6442                	ld	s0,16(sp)
    800049ba:	64a2                	ld	s1,8(sp)
    800049bc:	6902                	ld	s2,0(sp)
    800049be:	6105                	addi	sp,sp,32
    800049c0:	8082                	ret

00000000800049c2 <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
    800049c2:	1101                	addi	sp,sp,-32
    800049c4:	ec06                	sd	ra,24(sp)
    800049c6:	e822                	sd	s0,16(sp)
    800049c8:	e426                	sd	s1,8(sp)
    800049ca:	e04a                	sd	s2,0(sp)
    800049cc:	1000                	addi	s0,sp,32
    800049ce:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    800049d0:	00850913          	addi	s2,a0,8
    800049d4:	854a                	mv	a0,s2
    800049d6:	a52fc0ef          	jal	80000c28 <acquire>
  lk->locked = 0;
    800049da:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    800049de:	0204a423          	sw	zero,40(s1)
  wakeup(lk);
    800049e2:	8526                	mv	a0,s1
    800049e4:	d43fd0ef          	jal	80002726 <wakeup>
  release(&lk->lk);
    800049e8:	854a                	mv	a0,s2
    800049ea:	ad2fc0ef          	jal	80000cbc <release>
}
    800049ee:	60e2                	ld	ra,24(sp)
    800049f0:	6442                	ld	s0,16(sp)
    800049f2:	64a2                	ld	s1,8(sp)
    800049f4:	6902                	ld	s2,0(sp)
    800049f6:	6105                	addi	sp,sp,32
    800049f8:	8082                	ret

00000000800049fa <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
    800049fa:	7179                	addi	sp,sp,-48
    800049fc:	f406                	sd	ra,40(sp)
    800049fe:	f022                	sd	s0,32(sp)
    80004a00:	ec26                	sd	s1,24(sp)
    80004a02:	e84a                	sd	s2,16(sp)
    80004a04:	1800                	addi	s0,sp,48
    80004a06:	84aa                	mv	s1,a0
  int r;
  
  acquire(&lk->lk);
    80004a08:	00850913          	addi	s2,a0,8
    80004a0c:	854a                	mv	a0,s2
    80004a0e:	a1afc0ef          	jal	80000c28 <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
    80004a12:	409c                	lw	a5,0(s1)
    80004a14:	ef81                	bnez	a5,80004a2c <holdingsleep+0x32>
    80004a16:	4481                	li	s1,0
  release(&lk->lk);
    80004a18:	854a                	mv	a0,s2
    80004a1a:	aa2fc0ef          	jal	80000cbc <release>
  return r;
}
    80004a1e:	8526                	mv	a0,s1
    80004a20:	70a2                	ld	ra,40(sp)
    80004a22:	7402                	ld	s0,32(sp)
    80004a24:	64e2                	ld	s1,24(sp)
    80004a26:	6942                	ld	s2,16(sp)
    80004a28:	6145                	addi	sp,sp,48
    80004a2a:	8082                	ret
    80004a2c:	e44e                	sd	s3,8(sp)
  r = lk->locked && (lk->pid == myproc()->pid);
    80004a2e:	0284a983          	lw	s3,40(s1)
    80004a32:	d86fd0ef          	jal	80001fb8 <myproc>
    80004a36:	5904                	lw	s1,48(a0)
    80004a38:	413484b3          	sub	s1,s1,s3
    80004a3c:	0014b493          	seqz	s1,s1
    80004a40:	69a2                	ld	s3,8(sp)
    80004a42:	bfd9                	j	80004a18 <holdingsleep+0x1e>

0000000080004a44 <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
    80004a44:	1141                	addi	sp,sp,-16
    80004a46:	e406                	sd	ra,8(sp)
    80004a48:	e022                	sd	s0,0(sp)
    80004a4a:	0800                	addi	s0,sp,16
  initlock(&ftable.lock, "ftable");
    80004a4c:	00004597          	auipc	a1,0x4
    80004a50:	e0458593          	addi	a1,a1,-508 # 80008850 <etext+0x850>
    80004a54:	0226f517          	auipc	a0,0x226f
    80004a58:	25c50513          	addi	a0,a0,604 # 82273cb0 <ftable>
    80004a5c:	942fc0ef          	jal	80000b9e <initlock>
}
    80004a60:	60a2                	ld	ra,8(sp)
    80004a62:	6402                	ld	s0,0(sp)
    80004a64:	0141                	addi	sp,sp,16
    80004a66:	8082                	ret

0000000080004a68 <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
    80004a68:	1101                	addi	sp,sp,-32
    80004a6a:	ec06                	sd	ra,24(sp)
    80004a6c:	e822                	sd	s0,16(sp)
    80004a6e:	e426                	sd	s1,8(sp)
    80004a70:	1000                	addi	s0,sp,32
  struct file *f;

  acquire(&ftable.lock);
    80004a72:	0226f517          	auipc	a0,0x226f
    80004a76:	23e50513          	addi	a0,a0,574 # 82273cb0 <ftable>
    80004a7a:	9aefc0ef          	jal	80000c28 <acquire>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    80004a7e:	0226f497          	auipc	s1,0x226f
    80004a82:	24a48493          	addi	s1,s1,586 # 82273cc8 <ftable+0x18>
    80004a86:	02270717          	auipc	a4,0x2270
    80004a8a:	1e270713          	addi	a4,a4,482 # 82274c68 <disk>
    if(f->ref == 0){
    80004a8e:	40dc                	lw	a5,4(s1)
    80004a90:	cf89                	beqz	a5,80004aaa <filealloc+0x42>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    80004a92:	02848493          	addi	s1,s1,40
    80004a96:	fee49ce3          	bne	s1,a4,80004a8e <filealloc+0x26>
      f->ref = 1;
      release(&ftable.lock);
      return f;
    }
  }
  release(&ftable.lock);
    80004a9a:	0226f517          	auipc	a0,0x226f
    80004a9e:	21650513          	addi	a0,a0,534 # 82273cb0 <ftable>
    80004aa2:	a1afc0ef          	jal	80000cbc <release>
  return 0;
    80004aa6:	4481                	li	s1,0
    80004aa8:	a809                	j	80004aba <filealloc+0x52>
      f->ref = 1;
    80004aaa:	4785                	li	a5,1
    80004aac:	c0dc                	sw	a5,4(s1)
      release(&ftable.lock);
    80004aae:	0226f517          	auipc	a0,0x226f
    80004ab2:	20250513          	addi	a0,a0,514 # 82273cb0 <ftable>
    80004ab6:	a06fc0ef          	jal	80000cbc <release>
}
    80004aba:	8526                	mv	a0,s1
    80004abc:	60e2                	ld	ra,24(sp)
    80004abe:	6442                	ld	s0,16(sp)
    80004ac0:	64a2                	ld	s1,8(sp)
    80004ac2:	6105                	addi	sp,sp,32
    80004ac4:	8082                	ret

0000000080004ac6 <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
    80004ac6:	1101                	addi	sp,sp,-32
    80004ac8:	ec06                	sd	ra,24(sp)
    80004aca:	e822                	sd	s0,16(sp)
    80004acc:	e426                	sd	s1,8(sp)
    80004ace:	1000                	addi	s0,sp,32
    80004ad0:	84aa                	mv	s1,a0
  acquire(&ftable.lock);
    80004ad2:	0226f517          	auipc	a0,0x226f
    80004ad6:	1de50513          	addi	a0,a0,478 # 82273cb0 <ftable>
    80004ada:	94efc0ef          	jal	80000c28 <acquire>
  if(f->ref < 1)
    80004ade:	40dc                	lw	a5,4(s1)
    80004ae0:	02f05063          	blez	a5,80004b00 <filedup+0x3a>
    panic("filedup");
  f->ref++;
    80004ae4:	2785                	addiw	a5,a5,1
    80004ae6:	c0dc                	sw	a5,4(s1)
  release(&ftable.lock);
    80004ae8:	0226f517          	auipc	a0,0x226f
    80004aec:	1c850513          	addi	a0,a0,456 # 82273cb0 <ftable>
    80004af0:	9ccfc0ef          	jal	80000cbc <release>
  return f;
}
    80004af4:	8526                	mv	a0,s1
    80004af6:	60e2                	ld	ra,24(sp)
    80004af8:	6442                	ld	s0,16(sp)
    80004afa:	64a2                	ld	s1,8(sp)
    80004afc:	6105                	addi	sp,sp,32
    80004afe:	8082                	ret
    panic("filedup");
    80004b00:	00004517          	auipc	a0,0x4
    80004b04:	d5850513          	addi	a0,a0,-680 # 80008858 <etext+0x858>
    80004b08:	d1dfb0ef          	jal	80000824 <panic>

0000000080004b0c <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
    80004b0c:	7139                	addi	sp,sp,-64
    80004b0e:	fc06                	sd	ra,56(sp)
    80004b10:	f822                	sd	s0,48(sp)
    80004b12:	f426                	sd	s1,40(sp)
    80004b14:	0080                	addi	s0,sp,64
    80004b16:	84aa                	mv	s1,a0
  struct file ff;

  acquire(&ftable.lock);
    80004b18:	0226f517          	auipc	a0,0x226f
    80004b1c:	19850513          	addi	a0,a0,408 # 82273cb0 <ftable>
    80004b20:	908fc0ef          	jal	80000c28 <acquire>
  if(f->ref < 1)
    80004b24:	40dc                	lw	a5,4(s1)
    80004b26:	04f05a63          	blez	a5,80004b7a <fileclose+0x6e>
    panic("fileclose");
  if(--f->ref > 0){
    80004b2a:	37fd                	addiw	a5,a5,-1
    80004b2c:	c0dc                	sw	a5,4(s1)
    80004b2e:	06f04063          	bgtz	a5,80004b8e <fileclose+0x82>
    80004b32:	f04a                	sd	s2,32(sp)
    80004b34:	ec4e                	sd	s3,24(sp)
    80004b36:	e852                	sd	s4,16(sp)
    80004b38:	e456                	sd	s5,8(sp)
    release(&ftable.lock);
    return;
  }
  ff = *f;
    80004b3a:	0004a903          	lw	s2,0(s1)
    80004b3e:	0094c783          	lbu	a5,9(s1)
    80004b42:	89be                	mv	s3,a5
    80004b44:	689c                	ld	a5,16(s1)
    80004b46:	8a3e                	mv	s4,a5
    80004b48:	6c9c                	ld	a5,24(s1)
    80004b4a:	8abe                	mv	s5,a5
  f->ref = 0;
    80004b4c:	0004a223          	sw	zero,4(s1)
  f->type = FD_NONE;
    80004b50:	0004a023          	sw	zero,0(s1)
  release(&ftable.lock);
    80004b54:	0226f517          	auipc	a0,0x226f
    80004b58:	15c50513          	addi	a0,a0,348 # 82273cb0 <ftable>
    80004b5c:	960fc0ef          	jal	80000cbc <release>

  if(ff.type == FD_PIPE){
    80004b60:	4785                	li	a5,1
    80004b62:	04f90163          	beq	s2,a5,80004ba4 <fileclose+0x98>
    pipeclose(ff.pipe, ff.writable);
  } else if(ff.type == FD_INODE || ff.type == FD_DEVICE){
    80004b66:	ffe9079b          	addiw	a5,s2,-2
    80004b6a:	4705                	li	a4,1
    80004b6c:	04f77563          	bgeu	a4,a5,80004bb6 <fileclose+0xaa>
    80004b70:	7902                	ld	s2,32(sp)
    80004b72:	69e2                	ld	s3,24(sp)
    80004b74:	6a42                	ld	s4,16(sp)
    80004b76:	6aa2                	ld	s5,8(sp)
    80004b78:	a00d                	j	80004b9a <fileclose+0x8e>
    80004b7a:	f04a                	sd	s2,32(sp)
    80004b7c:	ec4e                	sd	s3,24(sp)
    80004b7e:	e852                	sd	s4,16(sp)
    80004b80:	e456                	sd	s5,8(sp)
    panic("fileclose");
    80004b82:	00004517          	auipc	a0,0x4
    80004b86:	cde50513          	addi	a0,a0,-802 # 80008860 <etext+0x860>
    80004b8a:	c9bfb0ef          	jal	80000824 <panic>
    release(&ftable.lock);
    80004b8e:	0226f517          	auipc	a0,0x226f
    80004b92:	12250513          	addi	a0,a0,290 # 82273cb0 <ftable>
    80004b96:	926fc0ef          	jal	80000cbc <release>
    begin_op();
    iput(ff.ip);
    end_op();
  }
}
    80004b9a:	70e2                	ld	ra,56(sp)
    80004b9c:	7442                	ld	s0,48(sp)
    80004b9e:	74a2                	ld	s1,40(sp)
    80004ba0:	6121                	addi	sp,sp,64
    80004ba2:	8082                	ret
    pipeclose(ff.pipe, ff.writable);
    80004ba4:	85ce                	mv	a1,s3
    80004ba6:	8552                	mv	a0,s4
    80004ba8:	348000ef          	jal	80004ef0 <pipeclose>
    80004bac:	7902                	ld	s2,32(sp)
    80004bae:	69e2                	ld	s3,24(sp)
    80004bb0:	6a42                	ld	s4,16(sp)
    80004bb2:	6aa2                	ld	s5,8(sp)
    80004bb4:	b7dd                	j	80004b9a <fileclose+0x8e>
    begin_op();
    80004bb6:	b33ff0ef          	jal	800046e8 <begin_op>
    iput(ff.ip);
    80004bba:	8556                	mv	a0,s5
    80004bbc:	aa2ff0ef          	jal	80003e5e <iput>
    end_op();
    80004bc0:	b99ff0ef          	jal	80004758 <end_op>
    80004bc4:	7902                	ld	s2,32(sp)
    80004bc6:	69e2                	ld	s3,24(sp)
    80004bc8:	6a42                	ld	s4,16(sp)
    80004bca:	6aa2                	ld	s5,8(sp)
    80004bcc:	b7f9                	j	80004b9a <fileclose+0x8e>

0000000080004bce <filestat>:

// Get metadata about file f.
// addr is a user virtual address, pointing to a struct stat.
int
filestat(struct file *f, uint64 addr)
{
    80004bce:	715d                	addi	sp,sp,-80
    80004bd0:	e486                	sd	ra,72(sp)
    80004bd2:	e0a2                	sd	s0,64(sp)
    80004bd4:	fc26                	sd	s1,56(sp)
    80004bd6:	f052                	sd	s4,32(sp)
    80004bd8:	0880                	addi	s0,sp,80
    80004bda:	84aa                	mv	s1,a0
    80004bdc:	8a2e                	mv	s4,a1
  struct proc *p = myproc();
    80004bde:	bdafd0ef          	jal	80001fb8 <myproc>
  struct stat st;
  
  if(f->type == FD_INODE || f->type == FD_DEVICE){
    80004be2:	409c                	lw	a5,0(s1)
    80004be4:	37f9                	addiw	a5,a5,-2
    80004be6:	4705                	li	a4,1
    80004be8:	04f76263          	bltu	a4,a5,80004c2c <filestat+0x5e>
    80004bec:	f84a                	sd	s2,48(sp)
    80004bee:	f44e                	sd	s3,40(sp)
    80004bf0:	89aa                	mv	s3,a0
    ilock(f->ip);
    80004bf2:	6c88                	ld	a0,24(s1)
    80004bf4:	8e8ff0ef          	jal	80003cdc <ilock>
    stati(f->ip, &st);
    80004bf8:	fb840913          	addi	s2,s0,-72
    80004bfc:	85ca                	mv	a1,s2
    80004bfe:	6c88                	ld	a0,24(s1)
    80004c00:	c40ff0ef          	jal	80004040 <stati>
    iunlock(f->ip);
    80004c04:	6c88                	ld	a0,24(s1)
    80004c06:	984ff0ef          	jal	80003d8a <iunlock>
    if(copyout(p->pagetable, addr, (char *)&st, sizeof(st)) < 0)
    80004c0a:	46e1                	li	a3,24
    80004c0c:	864a                	mv	a2,s2
    80004c0e:	85d2                	mv	a1,s4
    80004c10:	0509b503          	ld	a0,80(s3)
    80004c14:	e75fc0ef          	jal	80001a88 <copyout>
    80004c18:	41f5551b          	sraiw	a0,a0,0x1f
    80004c1c:	7942                	ld	s2,48(sp)
    80004c1e:	79a2                	ld	s3,40(sp)
      return -1;
    return 0;
  }
  return -1;
}
    80004c20:	60a6                	ld	ra,72(sp)
    80004c22:	6406                	ld	s0,64(sp)
    80004c24:	74e2                	ld	s1,56(sp)
    80004c26:	7a02                	ld	s4,32(sp)
    80004c28:	6161                	addi	sp,sp,80
    80004c2a:	8082                	ret
  return -1;
    80004c2c:	557d                	li	a0,-1
    80004c2e:	bfcd                	j	80004c20 <filestat+0x52>

0000000080004c30 <fileread>:

// Read from file f.
// addr is a user virtual address.
int
fileread(struct file *f, uint64 addr, int n)
{
    80004c30:	7179                	addi	sp,sp,-48
    80004c32:	f406                	sd	ra,40(sp)
    80004c34:	f022                	sd	s0,32(sp)
    80004c36:	e84a                	sd	s2,16(sp)
    80004c38:	1800                	addi	s0,sp,48
  int r = 0;

  if(f->readable == 0)
    80004c3a:	00854783          	lbu	a5,8(a0)
    80004c3e:	cfd1                	beqz	a5,80004cda <fileread+0xaa>
    80004c40:	ec26                	sd	s1,24(sp)
    80004c42:	e44e                	sd	s3,8(sp)
    80004c44:	84aa                	mv	s1,a0
    80004c46:	892e                	mv	s2,a1
    80004c48:	89b2                	mv	s3,a2
    return -1;

  if(f->type == FD_PIPE){
    80004c4a:	411c                	lw	a5,0(a0)
    80004c4c:	4705                	li	a4,1
    80004c4e:	04e78363          	beq	a5,a4,80004c94 <fileread+0x64>
    r = piperead(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    80004c52:	470d                	li	a4,3
    80004c54:	04e78763          	beq	a5,a4,80004ca2 <fileread+0x72>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
      return -1;
    r = devsw[f->major].read(1, addr, n);
  } else if(f->type == FD_INODE){
    80004c58:	4709                	li	a4,2
    80004c5a:	06e79a63          	bne	a5,a4,80004cce <fileread+0x9e>
    ilock(f->ip);
    80004c5e:	6d08                	ld	a0,24(a0)
    80004c60:	87cff0ef          	jal	80003cdc <ilock>
    if((r = readi(f->ip, 1, addr, f->off, n)) > 0)
    80004c64:	874e                	mv	a4,s3
    80004c66:	5094                	lw	a3,32(s1)
    80004c68:	864a                	mv	a2,s2
    80004c6a:	4585                	li	a1,1
    80004c6c:	6c88                	ld	a0,24(s1)
    80004c6e:	c00ff0ef          	jal	8000406e <readi>
    80004c72:	892a                	mv	s2,a0
    80004c74:	00a05563          	blez	a0,80004c7e <fileread+0x4e>
      f->off += r;
    80004c78:	509c                	lw	a5,32(s1)
    80004c7a:	9fa9                	addw	a5,a5,a0
    80004c7c:	d09c                	sw	a5,32(s1)
    iunlock(f->ip);
    80004c7e:	6c88                	ld	a0,24(s1)
    80004c80:	90aff0ef          	jal	80003d8a <iunlock>
    80004c84:	64e2                	ld	s1,24(sp)
    80004c86:	69a2                	ld	s3,8(sp)
  } else {
    panic("fileread");
  }

  return r;
}
    80004c88:	854a                	mv	a0,s2
    80004c8a:	70a2                	ld	ra,40(sp)
    80004c8c:	7402                	ld	s0,32(sp)
    80004c8e:	6942                	ld	s2,16(sp)
    80004c90:	6145                	addi	sp,sp,48
    80004c92:	8082                	ret
    r = piperead(f->pipe, addr, n);
    80004c94:	6908                	ld	a0,16(a0)
    80004c96:	3b0000ef          	jal	80005046 <piperead>
    80004c9a:	892a                	mv	s2,a0
    80004c9c:	64e2                	ld	s1,24(sp)
    80004c9e:	69a2                	ld	s3,8(sp)
    80004ca0:	b7e5                	j	80004c88 <fileread+0x58>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
    80004ca2:	02451783          	lh	a5,36(a0)
    80004ca6:	03079693          	slli	a3,a5,0x30
    80004caa:	92c1                	srli	a3,a3,0x30
    80004cac:	4725                	li	a4,9
    80004cae:	02d76963          	bltu	a4,a3,80004ce0 <fileread+0xb0>
    80004cb2:	0792                	slli	a5,a5,0x4
    80004cb4:	0226f717          	auipc	a4,0x226f
    80004cb8:	f5c70713          	addi	a4,a4,-164 # 82273c10 <devsw>
    80004cbc:	97ba                	add	a5,a5,a4
    80004cbe:	639c                	ld	a5,0(a5)
    80004cc0:	c78d                	beqz	a5,80004cea <fileread+0xba>
    r = devsw[f->major].read(1, addr, n);
    80004cc2:	4505                	li	a0,1
    80004cc4:	9782                	jalr	a5
    80004cc6:	892a                	mv	s2,a0
    80004cc8:	64e2                	ld	s1,24(sp)
    80004cca:	69a2                	ld	s3,8(sp)
    80004ccc:	bf75                	j	80004c88 <fileread+0x58>
    panic("fileread");
    80004cce:	00004517          	auipc	a0,0x4
    80004cd2:	ba250513          	addi	a0,a0,-1118 # 80008870 <etext+0x870>
    80004cd6:	b4ffb0ef          	jal	80000824 <panic>
    return -1;
    80004cda:	57fd                	li	a5,-1
    80004cdc:	893e                	mv	s2,a5
    80004cde:	b76d                	j	80004c88 <fileread+0x58>
      return -1;
    80004ce0:	57fd                	li	a5,-1
    80004ce2:	893e                	mv	s2,a5
    80004ce4:	64e2                	ld	s1,24(sp)
    80004ce6:	69a2                	ld	s3,8(sp)
    80004ce8:	b745                	j	80004c88 <fileread+0x58>
    80004cea:	57fd                	li	a5,-1
    80004cec:	893e                	mv	s2,a5
    80004cee:	64e2                	ld	s1,24(sp)
    80004cf0:	69a2                	ld	s3,8(sp)
    80004cf2:	bf59                	j	80004c88 <fileread+0x58>

0000000080004cf4 <filewrite>:
int
filewrite(struct file *f, uint64 addr, int n)
{
  int r, ret = 0;

  if(f->writable == 0)
    80004cf4:	00954783          	lbu	a5,9(a0)
    80004cf8:	10078f63          	beqz	a5,80004e16 <filewrite+0x122>
{
    80004cfc:	711d                	addi	sp,sp,-96
    80004cfe:	ec86                	sd	ra,88(sp)
    80004d00:	e8a2                	sd	s0,80(sp)
    80004d02:	e0ca                	sd	s2,64(sp)
    80004d04:	f456                	sd	s5,40(sp)
    80004d06:	f05a                	sd	s6,32(sp)
    80004d08:	1080                	addi	s0,sp,96
    80004d0a:	892a                	mv	s2,a0
    80004d0c:	8b2e                	mv	s6,a1
    80004d0e:	8ab2                	mv	s5,a2
    return -1;

  if(f->type == FD_PIPE){
    80004d10:	411c                	lw	a5,0(a0)
    80004d12:	4705                	li	a4,1
    80004d14:	02e78a63          	beq	a5,a4,80004d48 <filewrite+0x54>
    ret = pipewrite(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    80004d18:	470d                	li	a4,3
    80004d1a:	02e78b63          	beq	a5,a4,80004d50 <filewrite+0x5c>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
      return -1;
    ret = devsw[f->major].write(1, addr, n);
  } else if(f->type == FD_INODE){
    80004d1e:	4709                	li	a4,2
    80004d20:	0ce79f63          	bne	a5,a4,80004dfe <filewrite+0x10a>
    80004d24:	f852                	sd	s4,48(sp)
    // the maximum log transaction size, including
    // i-node, indirect block, allocation blocks,
    // and 2 blocks of slop for non-aligned writes.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * BSIZE;
    int i = 0;
    while(i < n){
    80004d26:	0ac05a63          	blez	a2,80004dda <filewrite+0xe6>
    80004d2a:	e4a6                	sd	s1,72(sp)
    80004d2c:	fc4e                	sd	s3,56(sp)
    80004d2e:	ec5e                	sd	s7,24(sp)
    80004d30:	e862                	sd	s8,16(sp)
    80004d32:	e466                	sd	s9,8(sp)
    int i = 0;
    80004d34:	4a01                	li	s4,0
      int n1 = n - i;
      if(n1 > max)
    80004d36:	6b85                	lui	s7,0x1
    80004d38:	c00b8b93          	addi	s7,s7,-1024 # c00 <_entry-0x7ffff400>
    80004d3c:	6785                	lui	a5,0x1
    80004d3e:	c007879b          	addiw	a5,a5,-1024 # c00 <_entry-0x7ffff400>
    80004d42:	8cbe                	mv	s9,a5
        n1 = max;

      begin_op();
      ilock(f->ip);
      if ((r = writei(f->ip, 1, addr + i, f->off, n1)) > 0)
    80004d44:	4c05                	li	s8,1
    80004d46:	a8ad                	j	80004dc0 <filewrite+0xcc>
    ret = pipewrite(f->pipe, addr, n);
    80004d48:	6908                	ld	a0,16(a0)
    80004d4a:	204000ef          	jal	80004f4e <pipewrite>
    80004d4e:	a04d                	j	80004df0 <filewrite+0xfc>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
    80004d50:	02451783          	lh	a5,36(a0)
    80004d54:	03079693          	slli	a3,a5,0x30
    80004d58:	92c1                	srli	a3,a3,0x30
    80004d5a:	4725                	li	a4,9
    80004d5c:	0ad76f63          	bltu	a4,a3,80004e1a <filewrite+0x126>
    80004d60:	0792                	slli	a5,a5,0x4
    80004d62:	0226f717          	auipc	a4,0x226f
    80004d66:	eae70713          	addi	a4,a4,-338 # 82273c10 <devsw>
    80004d6a:	97ba                	add	a5,a5,a4
    80004d6c:	679c                	ld	a5,8(a5)
    80004d6e:	cbc5                	beqz	a5,80004e1e <filewrite+0x12a>
    ret = devsw[f->major].write(1, addr, n);
    80004d70:	4505                	li	a0,1
    80004d72:	9782                	jalr	a5
    80004d74:	a8b5                	j	80004df0 <filewrite+0xfc>
      if(n1 > max)
    80004d76:	2981                	sext.w	s3,s3
      begin_op();
    80004d78:	971ff0ef          	jal	800046e8 <begin_op>
      ilock(f->ip);
    80004d7c:	01893503          	ld	a0,24(s2)
    80004d80:	f5dfe0ef          	jal	80003cdc <ilock>
      if ((r = writei(f->ip, 1, addr + i, f->off, n1)) > 0)
    80004d84:	874e                	mv	a4,s3
    80004d86:	02092683          	lw	a3,32(s2)
    80004d8a:	016a0633          	add	a2,s4,s6
    80004d8e:	85e2                	mv	a1,s8
    80004d90:	01893503          	ld	a0,24(s2)
    80004d94:	bccff0ef          	jal	80004160 <writei>
    80004d98:	84aa                	mv	s1,a0
    80004d9a:	00a05763          	blez	a0,80004da8 <filewrite+0xb4>
        f->off += r;
    80004d9e:	02092783          	lw	a5,32(s2)
    80004da2:	9fa9                	addw	a5,a5,a0
    80004da4:	02f92023          	sw	a5,32(s2)
      iunlock(f->ip);
    80004da8:	01893503          	ld	a0,24(s2)
    80004dac:	fdffe0ef          	jal	80003d8a <iunlock>
      end_op();
    80004db0:	9a9ff0ef          	jal	80004758 <end_op>

      if(r != n1){
    80004db4:	02999563          	bne	s3,s1,80004dde <filewrite+0xea>
        // error from writei
        break;
      }
      i += r;
    80004db8:	01448a3b          	addw	s4,s1,s4
    while(i < n){
    80004dbc:	015a5963          	bge	s4,s5,80004dce <filewrite+0xda>
      int n1 = n - i;
    80004dc0:	414a87bb          	subw	a5,s5,s4
    80004dc4:	89be                	mv	s3,a5
      if(n1 > max)
    80004dc6:	fafbd8e3          	bge	s7,a5,80004d76 <filewrite+0x82>
    80004dca:	89e6                	mv	s3,s9
    80004dcc:	b76d                	j	80004d76 <filewrite+0x82>
    80004dce:	64a6                	ld	s1,72(sp)
    80004dd0:	79e2                	ld	s3,56(sp)
    80004dd2:	6be2                	ld	s7,24(sp)
    80004dd4:	6c42                	ld	s8,16(sp)
    80004dd6:	6ca2                	ld	s9,8(sp)
    80004dd8:	a801                	j	80004de8 <filewrite+0xf4>
    int i = 0;
    80004dda:	4a01                	li	s4,0
    80004ddc:	a031                	j	80004de8 <filewrite+0xf4>
    80004dde:	64a6                	ld	s1,72(sp)
    80004de0:	79e2                	ld	s3,56(sp)
    80004de2:	6be2                	ld	s7,24(sp)
    80004de4:	6c42                	ld	s8,16(sp)
    80004de6:	6ca2                	ld	s9,8(sp)
    }
    ret = (i == n ? n : -1);
    80004de8:	034a9d63          	bne	s5,s4,80004e22 <filewrite+0x12e>
    80004dec:	8556                	mv	a0,s5
    80004dee:	7a42                	ld	s4,48(sp)
  } else {
    panic("filewrite");
  }

  return ret;
}
    80004df0:	60e6                	ld	ra,88(sp)
    80004df2:	6446                	ld	s0,80(sp)
    80004df4:	6906                	ld	s2,64(sp)
    80004df6:	7aa2                	ld	s5,40(sp)
    80004df8:	7b02                	ld	s6,32(sp)
    80004dfa:	6125                	addi	sp,sp,96
    80004dfc:	8082                	ret
    80004dfe:	e4a6                	sd	s1,72(sp)
    80004e00:	fc4e                	sd	s3,56(sp)
    80004e02:	f852                	sd	s4,48(sp)
    80004e04:	ec5e                	sd	s7,24(sp)
    80004e06:	e862                	sd	s8,16(sp)
    80004e08:	e466                	sd	s9,8(sp)
    panic("filewrite");
    80004e0a:	00004517          	auipc	a0,0x4
    80004e0e:	a7650513          	addi	a0,a0,-1418 # 80008880 <etext+0x880>
    80004e12:	a13fb0ef          	jal	80000824 <panic>
    return -1;
    80004e16:	557d                	li	a0,-1
}
    80004e18:	8082                	ret
      return -1;
    80004e1a:	557d                	li	a0,-1
    80004e1c:	bfd1                	j	80004df0 <filewrite+0xfc>
    80004e1e:	557d                	li	a0,-1
    80004e20:	bfc1                	j	80004df0 <filewrite+0xfc>
    ret = (i == n ? n : -1);
    80004e22:	557d                	li	a0,-1
    80004e24:	7a42                	ld	s4,48(sp)
    80004e26:	b7e9                	j	80004df0 <filewrite+0xfc>

0000000080004e28 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
    80004e28:	7179                	addi	sp,sp,-48
    80004e2a:	f406                	sd	ra,40(sp)
    80004e2c:	f022                	sd	s0,32(sp)
    80004e2e:	ec26                	sd	s1,24(sp)
    80004e30:	e052                	sd	s4,0(sp)
    80004e32:	1800                	addi	s0,sp,48
    80004e34:	84aa                	mv	s1,a0
    80004e36:	8a2e                	mv	s4,a1
  struct pipe *pi;

  pi = 0;
  *f0 = *f1 = 0;
    80004e38:	0005b023          	sd	zero,0(a1)
    80004e3c:	00053023          	sd	zero,0(a0)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
    80004e40:	c29ff0ef          	jal	80004a68 <filealloc>
    80004e44:	e088                	sd	a0,0(s1)
    80004e46:	c549                	beqz	a0,80004ed0 <pipealloc+0xa8>
    80004e48:	c21ff0ef          	jal	80004a68 <filealloc>
    80004e4c:	00aa3023          	sd	a0,0(s4)
    80004e50:	cd25                	beqz	a0,80004ec8 <pipealloc+0xa0>
    80004e52:	e84a                	sd	s2,16(sp)
    goto bad;
  if((pi = (struct pipe*)kalloc()) == 0)
    80004e54:	cf1fb0ef          	jal	80000b44 <kalloc>
    80004e58:	892a                	mv	s2,a0
    80004e5a:	c12d                	beqz	a0,80004ebc <pipealloc+0x94>
    80004e5c:	e44e                	sd	s3,8(sp)
    goto bad;
  pi->readopen = 1;
    80004e5e:	4985                	li	s3,1
    80004e60:	23352023          	sw	s3,544(a0)
  pi->writeopen = 1;
    80004e64:	23352223          	sw	s3,548(a0)
  pi->nwrite = 0;
    80004e68:	20052e23          	sw	zero,540(a0)
  pi->nread = 0;
    80004e6c:	20052c23          	sw	zero,536(a0)
  initlock(&pi->lock, "pipe");
    80004e70:	00004597          	auipc	a1,0x4
    80004e74:	a2058593          	addi	a1,a1,-1504 # 80008890 <etext+0x890>
    80004e78:	d27fb0ef          	jal	80000b9e <initlock>
  (*f0)->type = FD_PIPE;
    80004e7c:	609c                	ld	a5,0(s1)
    80004e7e:	0137a023          	sw	s3,0(a5)
  (*f0)->readable = 1;
    80004e82:	609c                	ld	a5,0(s1)
    80004e84:	01378423          	sb	s3,8(a5)
  (*f0)->writable = 0;
    80004e88:	609c                	ld	a5,0(s1)
    80004e8a:	000784a3          	sb	zero,9(a5)
  (*f0)->pipe = pi;
    80004e8e:	609c                	ld	a5,0(s1)
    80004e90:	0127b823          	sd	s2,16(a5)
  (*f1)->type = FD_PIPE;
    80004e94:	000a3783          	ld	a5,0(s4)
    80004e98:	0137a023          	sw	s3,0(a5)
  (*f1)->readable = 0;
    80004e9c:	000a3783          	ld	a5,0(s4)
    80004ea0:	00078423          	sb	zero,8(a5)
  (*f1)->writable = 1;
    80004ea4:	000a3783          	ld	a5,0(s4)
    80004ea8:	013784a3          	sb	s3,9(a5)
  (*f1)->pipe = pi;
    80004eac:	000a3783          	ld	a5,0(s4)
    80004eb0:	0127b823          	sd	s2,16(a5)
  return 0;
    80004eb4:	4501                	li	a0,0
    80004eb6:	6942                	ld	s2,16(sp)
    80004eb8:	69a2                	ld	s3,8(sp)
    80004eba:	a01d                	j	80004ee0 <pipealloc+0xb8>

 bad:
  if(pi)
    kfree((char*)pi);
  if(*f0)
    80004ebc:	6088                	ld	a0,0(s1)
    80004ebe:	c119                	beqz	a0,80004ec4 <pipealloc+0x9c>
    80004ec0:	6942                	ld	s2,16(sp)
    80004ec2:	a029                	j	80004ecc <pipealloc+0xa4>
    80004ec4:	6942                	ld	s2,16(sp)
    80004ec6:	a029                	j	80004ed0 <pipealloc+0xa8>
    80004ec8:	6088                	ld	a0,0(s1)
    80004eca:	c10d                	beqz	a0,80004eec <pipealloc+0xc4>
    fileclose(*f0);
    80004ecc:	c41ff0ef          	jal	80004b0c <fileclose>
  if(*f1)
    80004ed0:	000a3783          	ld	a5,0(s4)
    fileclose(*f1);
  return -1;
    80004ed4:	557d                	li	a0,-1
  if(*f1)
    80004ed6:	c789                	beqz	a5,80004ee0 <pipealloc+0xb8>
    fileclose(*f1);
    80004ed8:	853e                	mv	a0,a5
    80004eda:	c33ff0ef          	jal	80004b0c <fileclose>
  return -1;
    80004ede:	557d                	li	a0,-1
}
    80004ee0:	70a2                	ld	ra,40(sp)
    80004ee2:	7402                	ld	s0,32(sp)
    80004ee4:	64e2                	ld	s1,24(sp)
    80004ee6:	6a02                	ld	s4,0(sp)
    80004ee8:	6145                	addi	sp,sp,48
    80004eea:	8082                	ret
  return -1;
    80004eec:	557d                	li	a0,-1
    80004eee:	bfcd                	j	80004ee0 <pipealloc+0xb8>

0000000080004ef0 <pipeclose>:

void
pipeclose(struct pipe *pi, int writable)
{
    80004ef0:	1101                	addi	sp,sp,-32
    80004ef2:	ec06                	sd	ra,24(sp)
    80004ef4:	e822                	sd	s0,16(sp)
    80004ef6:	e426                	sd	s1,8(sp)
    80004ef8:	e04a                	sd	s2,0(sp)
    80004efa:	1000                	addi	s0,sp,32
    80004efc:	84aa                	mv	s1,a0
    80004efe:	892e                	mv	s2,a1
  acquire(&pi->lock);
    80004f00:	d29fb0ef          	jal	80000c28 <acquire>
  if(writable){
    80004f04:	02090763          	beqz	s2,80004f32 <pipeclose+0x42>
    pi->writeopen = 0;
    80004f08:	2204a223          	sw	zero,548(s1)
    wakeup(&pi->nread);
    80004f0c:	21848513          	addi	a0,s1,536
    80004f10:	817fd0ef          	jal	80002726 <wakeup>
  } else {
    pi->readopen = 0;
    wakeup(&pi->nwrite);
  }
  if(pi->readopen == 0 && pi->writeopen == 0){
    80004f14:	2204a783          	lw	a5,544(s1)
    80004f18:	e781                	bnez	a5,80004f20 <pipeclose+0x30>
    80004f1a:	2244a783          	lw	a5,548(s1)
    80004f1e:	c38d                	beqz	a5,80004f40 <pipeclose+0x50>
    release(&pi->lock);
    kfree((char*)pi);
  } else
    release(&pi->lock);
    80004f20:	8526                	mv	a0,s1
    80004f22:	d9bfb0ef          	jal	80000cbc <release>
}
    80004f26:	60e2                	ld	ra,24(sp)
    80004f28:	6442                	ld	s0,16(sp)
    80004f2a:	64a2                	ld	s1,8(sp)
    80004f2c:	6902                	ld	s2,0(sp)
    80004f2e:	6105                	addi	sp,sp,32
    80004f30:	8082                	ret
    pi->readopen = 0;
    80004f32:	2204a023          	sw	zero,544(s1)
    wakeup(&pi->nwrite);
    80004f36:	21c48513          	addi	a0,s1,540
    80004f3a:	fecfd0ef          	jal	80002726 <wakeup>
    80004f3e:	bfd9                	j	80004f14 <pipeclose+0x24>
    release(&pi->lock);
    80004f40:	8526                	mv	a0,s1
    80004f42:	d7bfb0ef          	jal	80000cbc <release>
    kfree((char*)pi);
    80004f46:	8526                	mv	a0,s1
    80004f48:	b15fb0ef          	jal	80000a5c <kfree>
    80004f4c:	bfe9                	j	80004f26 <pipeclose+0x36>

0000000080004f4e <pipewrite>:

int
pipewrite(struct pipe *pi, uint64 addr, int n)
{
    80004f4e:	7159                	addi	sp,sp,-112
    80004f50:	f486                	sd	ra,104(sp)
    80004f52:	f0a2                	sd	s0,96(sp)
    80004f54:	eca6                	sd	s1,88(sp)
    80004f56:	e8ca                	sd	s2,80(sp)
    80004f58:	e4ce                	sd	s3,72(sp)
    80004f5a:	e0d2                	sd	s4,64(sp)
    80004f5c:	fc56                	sd	s5,56(sp)
    80004f5e:	1880                	addi	s0,sp,112
    80004f60:	84aa                	mv	s1,a0
    80004f62:	8aae                	mv	s5,a1
    80004f64:	8a32                	mv	s4,a2
  int i = 0;
  struct proc *pr = myproc();
    80004f66:	852fd0ef          	jal	80001fb8 <myproc>
    80004f6a:	89aa                	mv	s3,a0

  acquire(&pi->lock);
    80004f6c:	8526                	mv	a0,s1
    80004f6e:	cbbfb0ef          	jal	80000c28 <acquire>
  while(i < n){
    80004f72:	0d405263          	blez	s4,80005036 <pipewrite+0xe8>
    80004f76:	f85a                	sd	s6,48(sp)
    80004f78:	f45e                	sd	s7,40(sp)
    80004f7a:	f062                	sd	s8,32(sp)
    80004f7c:	ec66                	sd	s9,24(sp)
    80004f7e:	e86a                	sd	s10,16(sp)
  int i = 0;
    80004f80:	4901                	li	s2,0
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
      wakeup(&pi->nread);
      sleep(&pi->nwrite, &pi->lock);
    } else {
      char ch;
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1){
    80004f82:	f9f40c13          	addi	s8,s0,-97
    80004f86:	4b85                	li	s7,1
    80004f88:	5b7d                	li	s6,-1
      wakeup(&pi->nread);
    80004f8a:	21848d13          	addi	s10,s1,536
      sleep(&pi->nwrite, &pi->lock);
    80004f8e:	21c48c93          	addi	s9,s1,540
    80004f92:	a82d                	j	80004fcc <pipewrite+0x7e>
      release(&pi->lock);
    80004f94:	8526                	mv	a0,s1
    80004f96:	d27fb0ef          	jal	80000cbc <release>
      return -1;
    80004f9a:	597d                	li	s2,-1
    80004f9c:	7b42                	ld	s6,48(sp)
    80004f9e:	7ba2                	ld	s7,40(sp)
    80004fa0:	7c02                	ld	s8,32(sp)
    80004fa2:	6ce2                	ld	s9,24(sp)
    80004fa4:	6d42                	ld	s10,16(sp)
  }
  wakeup(&pi->nread);
  release(&pi->lock);

  return i;
}
    80004fa6:	854a                	mv	a0,s2
    80004fa8:	70a6                	ld	ra,104(sp)
    80004faa:	7406                	ld	s0,96(sp)
    80004fac:	64e6                	ld	s1,88(sp)
    80004fae:	6946                	ld	s2,80(sp)
    80004fb0:	69a6                	ld	s3,72(sp)
    80004fb2:	6a06                	ld	s4,64(sp)
    80004fb4:	7ae2                	ld	s5,56(sp)
    80004fb6:	6165                	addi	sp,sp,112
    80004fb8:	8082                	ret
      wakeup(&pi->nread);
    80004fba:	856a                	mv	a0,s10
    80004fbc:	f6afd0ef          	jal	80002726 <wakeup>
      sleep(&pi->nwrite, &pi->lock);
    80004fc0:	85a6                	mv	a1,s1
    80004fc2:	8566                	mv	a0,s9
    80004fc4:	f16fd0ef          	jal	800026da <sleep>
  while(i < n){
    80004fc8:	05495a63          	bge	s2,s4,8000501c <pipewrite+0xce>
    if(pi->readopen == 0 || killed(pr)){
    80004fcc:	2204a783          	lw	a5,544(s1)
    80004fd0:	d3f1                	beqz	a5,80004f94 <pipewrite+0x46>
    80004fd2:	854e                	mv	a0,s3
    80004fd4:	99ffd0ef          	jal	80002972 <killed>
    80004fd8:	fd55                	bnez	a0,80004f94 <pipewrite+0x46>
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
    80004fda:	2184a783          	lw	a5,536(s1)
    80004fde:	21c4a703          	lw	a4,540(s1)
    80004fe2:	2007879b          	addiw	a5,a5,512
    80004fe6:	fcf70ae3          	beq	a4,a5,80004fba <pipewrite+0x6c>
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1){
    80004fea:	86de                	mv	a3,s7
    80004fec:	01590633          	add	a2,s2,s5
    80004ff0:	85e2                	mv	a1,s8
    80004ff2:	0509b503          	ld	a0,80(s3)
    80004ff6:	be5fc0ef          	jal	80001bda <copyin>
    80004ffa:	05650063          	beq	a0,s6,8000503a <pipewrite+0xec>
      pi->data[pi->nwrite++ % PIPESIZE] = ch;
    80004ffe:	21c4a783          	lw	a5,540(s1)
    80005002:	0017871b          	addiw	a4,a5,1
    80005006:	20e4ae23          	sw	a4,540(s1)
    8000500a:	1ff7f793          	andi	a5,a5,511
    8000500e:	97a6                	add	a5,a5,s1
    80005010:	f9f44703          	lbu	a4,-97(s0)
    80005014:	00e78c23          	sb	a4,24(a5)
      i++;
    80005018:	2905                	addiw	s2,s2,1
    8000501a:	b77d                	j	80004fc8 <pipewrite+0x7a>
    8000501c:	7b42                	ld	s6,48(sp)
    8000501e:	7ba2                	ld	s7,40(sp)
    80005020:	7c02                	ld	s8,32(sp)
    80005022:	6ce2                	ld	s9,24(sp)
    80005024:	6d42                	ld	s10,16(sp)
  wakeup(&pi->nread);
    80005026:	21848513          	addi	a0,s1,536
    8000502a:	efcfd0ef          	jal	80002726 <wakeup>
  release(&pi->lock);
    8000502e:	8526                	mv	a0,s1
    80005030:	c8dfb0ef          	jal	80000cbc <release>
  return i;
    80005034:	bf8d                	j	80004fa6 <pipewrite+0x58>
  int i = 0;
    80005036:	4901                	li	s2,0
    80005038:	b7fd                	j	80005026 <pipewrite+0xd8>
    8000503a:	7b42                	ld	s6,48(sp)
    8000503c:	7ba2                	ld	s7,40(sp)
    8000503e:	7c02                	ld	s8,32(sp)
    80005040:	6ce2                	ld	s9,24(sp)
    80005042:	6d42                	ld	s10,16(sp)
    80005044:	b7cd                	j	80005026 <pipewrite+0xd8>

0000000080005046 <piperead>:

int
piperead(struct pipe *pi, uint64 addr, int n)
{
    80005046:	711d                	addi	sp,sp,-96
    80005048:	ec86                	sd	ra,88(sp)
    8000504a:	e8a2                	sd	s0,80(sp)
    8000504c:	e4a6                	sd	s1,72(sp)
    8000504e:	e0ca                	sd	s2,64(sp)
    80005050:	fc4e                	sd	s3,56(sp)
    80005052:	f852                	sd	s4,48(sp)
    80005054:	f456                	sd	s5,40(sp)
    80005056:	1080                	addi	s0,sp,96
    80005058:	84aa                	mv	s1,a0
    8000505a:	892e                	mv	s2,a1
    8000505c:	8ab2                	mv	s5,a2
  int i;
  struct proc *pr = myproc();
    8000505e:	f5bfc0ef          	jal	80001fb8 <myproc>
    80005062:	8a2a                	mv	s4,a0
  char ch;

  acquire(&pi->lock);
    80005064:	8526                	mv	a0,s1
    80005066:	bc3fb0ef          	jal	80000c28 <acquire>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    8000506a:	2184a703          	lw	a4,536(s1)
    8000506e:	21c4a783          	lw	a5,540(s1)
    if(killed(pr)){
      release(&pi->lock);
      return -1;
    }
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    80005072:	21848993          	addi	s3,s1,536
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80005076:	02f71763          	bne	a4,a5,800050a4 <piperead+0x5e>
    8000507a:	2244a783          	lw	a5,548(s1)
    8000507e:	cf85                	beqz	a5,800050b6 <piperead+0x70>
    if(killed(pr)){
    80005080:	8552                	mv	a0,s4
    80005082:	8f1fd0ef          	jal	80002972 <killed>
    80005086:	e11d                	bnez	a0,800050ac <piperead+0x66>
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    80005088:	85a6                	mv	a1,s1
    8000508a:	854e                	mv	a0,s3
    8000508c:	e4efd0ef          	jal	800026da <sleep>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80005090:	2184a703          	lw	a4,536(s1)
    80005094:	21c4a783          	lw	a5,540(s1)
    80005098:	fef701e3          	beq	a4,a5,8000507a <piperead+0x34>
    8000509c:	f05a                	sd	s6,32(sp)
    8000509e:	ec5e                	sd	s7,24(sp)
    800050a0:	e862                	sd	s8,16(sp)
    800050a2:	a829                	j	800050bc <piperead+0x76>
    800050a4:	f05a                	sd	s6,32(sp)
    800050a6:	ec5e                	sd	s7,24(sp)
    800050a8:	e862                	sd	s8,16(sp)
    800050aa:	a809                	j	800050bc <piperead+0x76>
      release(&pi->lock);
    800050ac:	8526                	mv	a0,s1
    800050ae:	c0ffb0ef          	jal	80000cbc <release>
      return -1;
    800050b2:	59fd                	li	s3,-1
    800050b4:	a0a5                	j	8000511c <piperead+0xd6>
    800050b6:	f05a                	sd	s6,32(sp)
    800050b8:	ec5e                	sd	s7,24(sp)
    800050ba:	e862                	sd	s8,16(sp)
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    800050bc:	4981                	li	s3,0
    if(pi->nread == pi->nwrite)
      break;
    ch = pi->data[pi->nread % PIPESIZE];
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1) {
    800050be:	faf40c13          	addi	s8,s0,-81
    800050c2:	4b85                	li	s7,1
    800050c4:	5b7d                	li	s6,-1
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    800050c6:	05505163          	blez	s5,80005108 <piperead+0xc2>
    if(pi->nread == pi->nwrite)
    800050ca:	2184a783          	lw	a5,536(s1)
    800050ce:	21c4a703          	lw	a4,540(s1)
    800050d2:	02f70b63          	beq	a4,a5,80005108 <piperead+0xc2>
    ch = pi->data[pi->nread % PIPESIZE];
    800050d6:	1ff7f793          	andi	a5,a5,511
    800050da:	97a6                	add	a5,a5,s1
    800050dc:	0187c783          	lbu	a5,24(a5)
    800050e0:	faf407a3          	sb	a5,-81(s0)
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1) {
    800050e4:	86de                	mv	a3,s7
    800050e6:	8662                	mv	a2,s8
    800050e8:	85ca                	mv	a1,s2
    800050ea:	050a3503          	ld	a0,80(s4)
    800050ee:	99bfc0ef          	jal	80001a88 <copyout>
    800050f2:	03650f63          	beq	a0,s6,80005130 <piperead+0xea>
      if(i == 0)
        i = -1;
      break;
    }
    pi->nread++;
    800050f6:	2184a783          	lw	a5,536(s1)
    800050fa:	2785                	addiw	a5,a5,1
    800050fc:	20f4ac23          	sw	a5,536(s1)
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80005100:	2985                	addiw	s3,s3,1
    80005102:	0905                	addi	s2,s2,1
    80005104:	fd3a93e3          	bne	s5,s3,800050ca <piperead+0x84>
  }
  wakeup(&pi->nwrite);  //DOC: piperead-wakeup
    80005108:	21c48513          	addi	a0,s1,540
    8000510c:	e1afd0ef          	jal	80002726 <wakeup>
  release(&pi->lock);
    80005110:	8526                	mv	a0,s1
    80005112:	babfb0ef          	jal	80000cbc <release>
    80005116:	7b02                	ld	s6,32(sp)
    80005118:	6be2                	ld	s7,24(sp)
    8000511a:	6c42                	ld	s8,16(sp)
  return i;
}
    8000511c:	854e                	mv	a0,s3
    8000511e:	60e6                	ld	ra,88(sp)
    80005120:	6446                	ld	s0,80(sp)
    80005122:	64a6                	ld	s1,72(sp)
    80005124:	6906                	ld	s2,64(sp)
    80005126:	79e2                	ld	s3,56(sp)
    80005128:	7a42                	ld	s4,48(sp)
    8000512a:	7aa2                	ld	s5,40(sp)
    8000512c:	6125                	addi	sp,sp,96
    8000512e:	8082                	ret
      if(i == 0)
    80005130:	fc099ce3          	bnez	s3,80005108 <piperead+0xc2>
        i = -1;
    80005134:	89aa                	mv	s3,a0
    80005136:	bfc9                	j	80005108 <piperead+0xc2>

0000000080005138 <ulazymalloc>:
//static int loadseg(pde_t *, uint64, struct inode *, uint, uint);
struct inode* create(char *path, short type, short major, short minor);
uint64 ulazymalloc(pagetable_t pagetable, uint64 va_start, uint64 va_end, int xperm){
uint64 a;

  if(va_end < va_start)
    80005138:	04b66a63          	bltu	a2,a1,8000518c <ulazymalloc+0x54>
uint64 ulazymalloc(pagetable_t pagetable, uint64 va_start, uint64 va_end, int xperm){
    8000513c:	7139                	addi	sp,sp,-64
    8000513e:	fc06                	sd	ra,56(sp)
    80005140:	f822                	sd	s0,48(sp)
    80005142:	f426                	sd	s1,40(sp)
    80005144:	f04a                	sd	s2,32(sp)
    80005146:	e852                	sd	s4,16(sp)
    80005148:	0080                	addi	s0,sp,64
    8000514a:	8a2a                	mv	s4,a0
    8000514c:	8932                	mv	s2,a2
    return va_start;

  va_start = PGROUNDUP(va_start);
    8000514e:	6785                	lui	a5,0x1
    80005150:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    80005152:	95be                	add	a1,a1,a5
    80005154:	77fd                	lui	a5,0xfffff
    80005156:	00f5f4b3          	and	s1,a1,a5
  for(a = va_start; a < va_end; a += PGSIZE){
    8000515a:	02c4fb63          	bgeu	s1,a2,80005190 <ulazymalloc+0x58>
    8000515e:	ec4e                	sd	s3,24(sp)
    80005160:	e456                	sd	s5,8(sp)
    80005162:	e05a                	sd	s6,0(sp)
    pte_t *pte = walk(pagetable, a, 1);
    80005164:	4a85                	li	s5,1
      // In case of failure, we don't have a simple way to deallocate just this segment,
      // so we let kexec handle the full cleanup.
      return 0;
    }
    // Mark as User-accessible with given permissions, but NOT valid (PTE_V=0).
    *pte = PTE_U | xperm;
    80005166:	0106e993          	ori	s3,a3,16
  for(a = va_start; a < va_end; a += PGSIZE){
    8000516a:	6b05                	lui	s6,0x1
    pte_t *pte = walk(pagetable, a, 1);
    8000516c:	8656                	mv	a2,s5
    8000516e:	85a6                	mv	a1,s1
    80005170:	8552                	mv	a0,s4
    80005172:	e1bfb0ef          	jal	80000f8c <walk>
    if(pte == 0){
    80005176:	cd19                	beqz	a0,80005194 <ulazymalloc+0x5c>
    *pte = PTE_U | xperm;
    80005178:	01353023          	sd	s3,0(a0)
  for(a = va_start; a < va_end; a += PGSIZE){
    8000517c:	94da                	add	s1,s1,s6
    8000517e:	ff24e7e3          	bltu	s1,s2,8000516c <ulazymalloc+0x34>
  }
  return va_end;
    80005182:	854a                	mv	a0,s2
    80005184:	69e2                	ld	s3,24(sp)
    80005186:	6aa2                	ld	s5,8(sp)
    80005188:	6b02                	ld	s6,0(sp)
    8000518a:	a801                	j	8000519a <ulazymalloc+0x62>
    return va_start;
    8000518c:	852e                	mv	a0,a1
}
    8000518e:	8082                	ret
  return va_end;
    80005190:	8532                	mv	a0,a2
    80005192:	a021                	j	8000519a <ulazymalloc+0x62>
    80005194:	69e2                	ld	s3,24(sp)
    80005196:	6aa2                	ld	s5,8(sp)
    80005198:	6b02                	ld	s6,0(sp)
}
    8000519a:	70e2                	ld	ra,56(sp)
    8000519c:	7442                	ld	s0,48(sp)
    8000519e:	74a2                	ld	s1,40(sp)
    800051a0:	7902                	ld	s2,32(sp)
    800051a2:	6a42                	ld	s4,16(sp)
    800051a4:	6121                	addi	sp,sp,64
    800051a6:	8082                	ret

00000000800051a8 <flags2perm>:
// map ELF permissions to PTE permission bits.
int flags2perm(int flags)
{
    800051a8:	1141                	addi	sp,sp,-16
    800051aa:	e406                	sd	ra,8(sp)
    800051ac:	e022                	sd	s0,0(sp)
    800051ae:	0800                	addi	s0,sp,16
    800051b0:	87aa                	mv	a5,a0
    int perm = 0;
    if(flags & 0x1)
    800051b2:	0035151b          	slliw	a0,a0,0x3
    800051b6:	8921                	andi	a0,a0,8
      perm = PTE_X;
    if(flags & 0x2)
    800051b8:	0027f713          	andi	a4,a5,2
    800051bc:	c319                	beqz	a4,800051c2 <flags2perm+0x1a>
      perm |= PTE_W;
    800051be:	00456513          	ori	a0,a0,4
    if(flags & ELF_PROG_FLAG_READ)
    800051c2:	8b91                	andi	a5,a5,4
    800051c4:	c399                	beqz	a5,800051ca <flags2perm+0x22>
      perm |= PTE_R;
    800051c6:	00256513          	ori	a0,a0,2
    return perm;
}
    800051ca:	60a2                	ld	ra,8(sp)
    800051cc:	6402                	ld	s0,0(sp)
    800051ce:	0141                	addi	sp,sp,16
    800051d0:	8082                	ret

00000000800051d2 <itoa>:
void
itoa(int n, char *buf, int min_width)
{
    800051d2:	1141                	addi	sp,sp,-16
    800051d4:	e406                	sd	ra,8(sp)
    800051d6:	e022                	sd	s0,0(sp)
    800051d8:	0800                	addi	s0,sp,16
  int i = 0;
  if (n == 0) {
    800051da:	c921                	beqz	a0,8000522a <itoa+0x58>
    buf[i++] = '0';
  } else {
    // Generate digits in reverse order.
    while(n > 0){
    800051dc:	86ae                	mv	a3,a1
      buf[i++] = (n % 10) + '0';
    800051de:	666668b7          	lui	a7,0x66666
    800051e2:	66788893          	addi	a7,a7,1639 # 66666667 <_entry-0x19999999>
    while(n > 0){
    800051e6:	4325                	li	t1,9
    800051e8:	02a05f63          	blez	a0,80005226 <itoa+0x54>
      buf[i++] = (n % 10) + '0';
    800051ec:	03150733          	mul	a4,a0,a7
    800051f0:	9709                	srai	a4,a4,0x22
    800051f2:	41f5579b          	sraiw	a5,a0,0x1f
    800051f6:	9f1d                	subw	a4,a4,a5
    800051f8:	0027179b          	slliw	a5,a4,0x2
    800051fc:	9fb9                	addw	a5,a5,a4
    800051fe:	0017979b          	slliw	a5,a5,0x1
    80005202:	40f507bb          	subw	a5,a0,a5
    80005206:	0307879b          	addiw	a5,a5,48 # fffffffffffff030 <end+0xffffffff7dd8a288>
    8000520a:	00f68023          	sb	a5,0(a3)
      n /= 10;
    8000520e:	882a                	mv	a6,a0
    80005210:	853a                	mv	a0,a4
    while(n > 0){
    80005212:	87b6                	mv	a5,a3
    80005214:	0685                	addi	a3,a3,1
    80005216:	fd034be3          	blt	t1,a6,800051ec <itoa+0x1a>
      buf[i++] = (n % 10) + '0';
    8000521a:	40b786bb          	subw	a3,a5,a1
    8000521e:	2685                	addiw	a3,a3,1
    }
  }

  // Add padding if needed.
  while(i < min_width){
    80005220:	00c6cc63          	blt	a3,a2,80005238 <itoa+0x66>
    80005224:	a081                	j	80005264 <itoa+0x92>
  int i = 0;
    80005226:	4681                	li	a3,0
    80005228:	a031                	j	80005234 <itoa+0x62>
    buf[i++] = '0';
    8000522a:	03000793          	li	a5,48
    8000522e:	00f58023          	sb	a5,0(a1)
    80005232:	4685                	li	a3,1
  while(i < min_width){
    80005234:	06c6d963          	bge	a3,a2,800052a6 <itoa+0xd4>
    80005238:	87b6                	mv	a5,a3
    buf[i++] = '0';
    8000523a:	03000513          	li	a0,48
    8000523e:	00f58733          	add	a4,a1,a5
    80005242:	00a70023          	sb	a0,0(a4)
  while(i < min_width){
    80005246:	0785                	addi	a5,a5,1
    80005248:	0007871b          	sext.w	a4,a5
    8000524c:	fec749e3          	blt	a4,a2,8000523e <itoa+0x6c>
    80005250:	87b6                	mv	a5,a3
    80005252:	4701                	li	a4,0
    80005254:	00c6d563          	bge	a3,a2,8000525e <itoa+0x8c>
    80005258:	fff6071b          	addiw	a4,a2,-1
    8000525c:	9f15                	subw	a4,a4,a3
    8000525e:	2785                	addiw	a5,a5,1
    80005260:	00f706bb          	addw	a3,a4,a5
  }

  buf[i] = '\0';
    80005264:	00d587b3          	add	a5,a1,a3
    80005268:	00078023          	sb	zero,0(a5)

  // Reverse the entire string to get the correct order.
  for(int j = 0; j < i/2; j++){
    8000526c:	4785                	li	a5,1
    8000526e:	02d7d863          	bge	a5,a3,8000529e <itoa+0xcc>
    80005272:	01f6d51b          	srliw	a0,a3,0x1f
    80005276:	9d35                	addw	a0,a0,a3
    80005278:	4015551b          	sraiw	a0,a0,0x1
    8000527c:	87ae                	mv	a5,a1
    8000527e:	15fd                	addi	a1,a1,-1
    80005280:	95b6                	add	a1,a1,a3
    80005282:	4701                	li	a4,0
    char temp = buf[j];
    80005284:	0007c683          	lbu	a3,0(a5)
    buf[j] = buf[i-j-1];
    80005288:	0005c603          	lbu	a2,0(a1)
    8000528c:	00c78023          	sb	a2,0(a5)
    buf[i-j-1] = temp;
    80005290:	00d58023          	sb	a3,0(a1)
  for(int j = 0; j < i/2; j++){
    80005294:	2705                	addiw	a4,a4,1
    80005296:	0785                	addi	a5,a5,1
    80005298:	15fd                	addi	a1,a1,-1
    8000529a:	fea745e3          	blt	a4,a0,80005284 <itoa+0xb2>
  }
}
    8000529e:	60a2                	ld	ra,8(sp)
    800052a0:	6402                	ld	s0,0(sp)
    800052a2:	0141                	addi	sp,sp,16
    800052a4:	8082                	ret
  buf[i] = '\0';
    800052a6:	96ae                	add	a3,a3,a1
    800052a8:	00068023          	sb	zero,0(a3)
  for(int j = 0; j < i/2; j++){
    800052ac:	bfcd                	j	8000529e <itoa+0xcc>

00000000800052ae <strcat>:


char*
strcat(char *dest, const char *src)
{
    800052ae:	1141                	addi	sp,sp,-16
    800052b0:	e406                	sd	ra,8(sp)
    800052b2:	e022                	sd	s0,0(sp)
    800052b4:	0800                	addi	s0,sp,16
    char *d = dest;
    // Move pointer to the end of the destination string.
    while (*d) {
    800052b6:	00054783          	lbu	a5,0(a0)
    800052ba:	c38d                	beqz	a5,800052dc <strcat+0x2e>
    char *d = dest;
    800052bc:	87aa                	mv	a5,a0
        d++;
    800052be:	0785                	addi	a5,a5,1
    while (*d) {
    800052c0:	0007c703          	lbu	a4,0(a5)
    800052c4:	ff6d                	bnez	a4,800052be <strcat+0x10>
    }
    // Copy characters from source to the end of destination.
    while ((*d++ = *src++)) {
    800052c6:	0585                	addi	a1,a1,1
    800052c8:	0785                	addi	a5,a5,1
    800052ca:	fff5c703          	lbu	a4,-1(a1)
    800052ce:	fee78fa3          	sb	a4,-1(a5)
    800052d2:	fb75                	bnez	a4,800052c6 <strcat+0x18>
        ;
    }
    return dest;
}
    800052d4:	60a2                	ld	ra,8(sp)
    800052d6:	6402                	ld	s0,0(sp)
    800052d8:	0141                	addi	sp,sp,16
    800052da:	8082                	ret
    char *d = dest;
    800052dc:	87aa                	mv	a5,a0
    800052de:	b7e5                	j	800052c6 <strcat+0x18>

00000000800052e0 <kexec>:
//
// In kernel/exec.c, replace the existing kexec function

int
kexec(char *path, char **argv)
{
    800052e0:	db010113          	addi	sp,sp,-592
    800052e4:	24113423          	sd	ra,584(sp)
    800052e8:	24813023          	sd	s0,576(sp)
    800052ec:	22913c23          	sd	s1,568(sp)
    800052f0:	23213823          	sd	s2,560(sp)
    800052f4:	23313423          	sd	s3,552(sp)
    800052f8:	21813023          	sd	s8,512(sp)
    800052fc:	ffe6                	sd	s9,504(sp)
    800052fe:	0c80                	addi	s0,sp,592
    80005300:	8c2a                	mv	s8,a0
    80005302:	8cae                	mv	s9,a1
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pagetable_t pagetable = 0, oldpagetable;
  struct proc *p = myproc();
    80005304:	cb5fc0ef          	jal	80001fb8 <myproc>
    80005308:	892a                	mv	s2,a0
  char pid_str[16];
  char swap_path[32];
  safestrcpy(swap_path,"/pgswp",sizeof(swap_path));
    8000530a:	de840493          	addi	s1,s0,-536
    8000530e:	02000613          	li	a2,32
    80005312:	00003597          	auipc	a1,0x3
    80005316:	58658593          	addi	a1,a1,1414 # 80008898 <etext+0x898>
    8000531a:	8526                	mv	a0,s1
    8000531c:	b31fb0ef          	jal	80000e4c <safestrcpy>
  safestrcpy(p->swap_path,swap_path,sizeof(swap_path));
    80005320:	02000613          	li	a2,32
    80005324:	85a6                	mv	a1,s1
    80005326:	00089537          	lui	a0,0x89
    8000532a:	1b450513          	addi	a0,a0,436 # 891b4 <_entry-0x7ff76e4c>
    8000532e:	954a                	add	a0,a0,s2
    80005330:	b1dfb0ef          	jal	80000e4c <safestrcpy>
  itoa(p->pid,pid_str,5);
    80005334:	e0840993          	addi	s3,s0,-504
    80005338:	4615                	li	a2,5
    8000533a:	85ce                	mv	a1,s3
    8000533c:	03092503          	lw	a0,48(s2)
    80005340:	e93ff0ef          	jal	800051d2 <itoa>
  strcat(swap_path,pid_str);
    80005344:	85ce                	mv	a1,s3
    80005346:	8526                	mv	a0,s1
    80005348:	f67ff0ef          	jal	800052ae <strcat>
  uint64 text_start = -1, text_end = 0;
  uint64 data_start = -1, data_end = 0;

  begin_op();
    8000534c:	b9cff0ef          	jal	800046e8 <begin_op>
  // 'create' returns an inode pointer (the on-disk representation).
 ip = create(swap_path, T_FILE, 0, 0);
    80005350:	4681                	li	a3,0
    80005352:	4601                	li	a2,0
    80005354:	4589                	li	a1,2
    80005356:	8526                	mv	a0,s1
    80005358:	0a5000ef          	jal	80005bfc <create>
  if(ip == 0){
    8000535c:	cd51                	beqz	a0,800053f8 <kexec+0x118>
    8000535e:	84aa                	mv	s1,a0
    end_op();
    goto bad;
  }

  // Allocate a 'file' structure (the in-memory handle).
  if((p->swap_file = filealloc()) == 0){
    80005360:	f08ff0ef          	jal	80004a68 <filealloc>
    80005364:	16a93c23          	sd	a0,376(s2)
    80005368:	cd41                	beqz	a0,80005400 <kexec+0x120>
    end_op();
    goto bad;
  }

  // Configure the file handle.
  p->swap_file->type = FD_INODE;
    8000536a:	4789                	li	a5,2
    8000536c:	c11c                	sw	a5,0(a0)
  p->swap_file->ip = ip; // Link the handle to the on-disk inode.
    8000536e:	17893783          	ld	a5,376(s2)
    80005372:	ef84                	sd	s1,24(a5)
  p->swap_file->readable = 1;
    80005374:	17893703          	ld	a4,376(s2)
    80005378:	4785                	li	a5,1
    8000537a:	00f70423          	sb	a5,8(a4)
  p->swap_file->writable = 1;
    8000537e:	17893703          	ld	a4,376(s2)
    80005382:	00f704a3          	sb	a5,9(a4)

  iunlock(ip ); // Unlock the inode; create() returns it locked.
    80005386:	8526                	mv	a0,s1
    80005388:	a03fe0ef          	jal	80003d8a <iunlock>
  end_op();
    8000538c:	bccff0ef          	jal	80004758 <end_op>

  begin_op();
    80005390:	b58ff0ef          	jal	800046e8 <begin_op>

  if((ip = namei(path)) == 0){
    80005394:	8562                	mv	a0,s8
    80005396:	974ff0ef          	jal	8000450a <namei>
    8000539a:	84aa                	mv	s1,a0
    8000539c:	c925                	beqz	a0,8000540c <kexec+0x12c>
    end_op();
    printf("exec checkpoint FAIL: namei failed\n");
    return -1;
  }
  ilock(ip);
    8000539e:	93ffe0ef          	jal	80003cdc <ilock>
   // Read the ELF header.
  if(readi(ip, 0, (uint64)&elf, 0, sizeof(elf)) != sizeof(elf))
    800053a2:	04000713          	li	a4,64
    800053a6:	4681                	li	a3,0
    800053a8:	e5040613          	addi	a2,s0,-432
    800053ac:	4581                	li	a1,0
    800053ae:	8526                	mv	a0,s1
    800053b0:	cbffe0ef          	jal	8000406e <readi>
    800053b4:	04000793          	li	a5,64
    800053b8:	00f51a63          	bne	a0,a5,800053cc <kexec+0xec>
    goto bad;

  if(elf.magic != ELF_MAGIC)
    800053bc:	e5042703          	lw	a4,-432(s0)
    800053c0:	464c47b7          	lui	a5,0x464c4
    800053c4:	57f78793          	addi	a5,a5,1407 # 464c457f <_entry-0x39b3ba81>
    800053c8:	04f70c63          	beq	a4,a5,80005420 <kexec+0x140>

bad:
  if(pagetable)
      proc_freepagetable(pagetable, sz);
  if(ip){
      iunlockput(ip);
    800053cc:	8526                	mv	a0,s1
    800053ce:	b1bfe0ef          	jal	80003ee8 <iunlockput>
      end_op();
    800053d2:	b86ff0ef          	jal	80004758 <end_op>
  }
  return -1;
    800053d6:	557d                	li	a0,-1
}
    800053d8:	24813083          	ld	ra,584(sp)
    800053dc:	24013403          	ld	s0,576(sp)
    800053e0:	23813483          	ld	s1,568(sp)
    800053e4:	23013903          	ld	s2,560(sp)
    800053e8:	22813983          	ld	s3,552(sp)
    800053ec:	20013c03          	ld	s8,512(sp)
    800053f0:	7cfe                	ld	s9,504(sp)
    800053f2:	25010113          	addi	sp,sp,592
    800053f6:	8082                	ret
    end_op();
    800053f8:	b60ff0ef          	jal	80004758 <end_op>
  return -1;
    800053fc:	557d                	li	a0,-1
    800053fe:	bfe9                	j	800053d8 <kexec+0xf8>
    iunlockput(ip); // Clean up the created inode if filealloc fails.
    80005400:	8526                	mv	a0,s1
    80005402:	ae7fe0ef          	jal	80003ee8 <iunlockput>
    end_op();
    80005406:	b52ff0ef          	jal	80004758 <end_op>
  if(pagetable)
    8000540a:	b7c9                	j	800053cc <kexec+0xec>
    end_op();
    8000540c:	b4cff0ef          	jal	80004758 <end_op>
    printf("exec checkpoint FAIL: namei failed\n");
    80005410:	00003517          	auipc	a0,0x3
    80005414:	49050513          	addi	a0,a0,1168 # 800088a0 <etext+0x8a0>
    80005418:	8e2fb0ef          	jal	800004fa <printf>
    return -1;
    8000541c:	557d                	li	a0,-1
    8000541e:	bf6d                	j	800053d8 <kexec+0xf8>
    80005420:	f7ee                	sd	s11,488(sp)
  if((pagetable = proc_pagetable(p)) == 0)
    80005422:	854a                	mv	a0,s2
    80005424:	c9ffc0ef          	jal	800020c2 <proc_pagetable>
    80005428:	8daa                	mv	s11,a0
    8000542a:	34050a63          	beqz	a0,8000577e <kexec+0x49e>
    8000542e:	23413023          	sd	s4,544(sp)
    80005432:	21513c23          	sd	s5,536(sp)
    80005436:	21613823          	sd	s6,528(sp)
    8000543a:	21713423          	sd	s7,520(sp)
    8000543e:	fbea                	sd	s10,496(sp)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80005440:	e8845783          	lhu	a5,-376(s0)
    80005444:	c7fd                	beqz	a5,80005532 <kexec+0x252>
    80005446:	e7042683          	lw	a3,-400(s0)
  uint64 data_start = -1, data_end = 0;
    8000544a:	da043c23          	sd	zero,-584(s0)
    8000544e:	57fd                	li	a5,-1
    80005450:	dcf43423          	sd	a5,-568(s0)
  uint64 text_start = -1, text_end = 0;
    80005454:	dc043023          	sd	zero,-576(s0)
    80005458:	dcf43823          	sd	a5,-560(s0)
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    8000545c:	4d01                	li	s10,0
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    8000545e:	4a81                	li	s5,0
      if(readi(ip, 0, (uint64)&ph, off, sizeof(ph)) != sizeof(ph))
    80005460:	03800b13          	li	s6,56
      if(ph.vaddr % PGSIZE != 0)
    80005464:	6785                	lui	a5,0x1
    80005466:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    80005468:	dcf43c23          	sd	a5,-552(s0)
    8000546c:	a091                	j	800054b0 <kexec+0x1d0>
          if (text_start == -1 || ph.vaddr < text_start) text_start = ph.vaddr;
    8000546e:	dd443823          	sd	s4,-560(s0)
          if (ph.vaddr + ph.memsz > text_end) text_end = ph.vaddr + ph.memsz;
    80005472:	dc043783          	ld	a5,-576(s0)
    80005476:	0137f463          	bgeu	a5,s3,8000547e <kexec+0x19e>
    8000547a:	dd343023          	sd	s3,-576(s0)
      if((ulazymalloc(pagetable, ph.vaddr, ph.vaddr + ph.memsz, flags2perm(ph.flags))) == 0)
    8000547e:	d2bff0ef          	jal	800051a8 <flags2perm>
    80005482:	86aa                	mv	a3,a0
    80005484:	864e                	mv	a2,s3
    80005486:	85d2                	mv	a1,s4
    80005488:	856e                	mv	a0,s11
    8000548a:	cafff0ef          	jal	80005138 <ulazymalloc>
    8000548e:	10050063          	beqz	a0,8000558e <kexec+0x2ae>
      if(ph.vaddr + ph.memsz > sz)
    80005492:	e2843783          	ld	a5,-472(s0)
    80005496:	e4043703          	ld	a4,-448(s0)
    8000549a:	97ba                	add	a5,a5,a4
    8000549c:	00fd7363          	bgeu	s10,a5,800054a2 <kexec+0x1c2>
    800054a0:	8d3e                	mv	s10,a5
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    800054a2:	2a85                	addiw	s5,s5,1
    800054a4:	038b869b          	addiw	a3,s7,56
    800054a8:	e8845783          	lhu	a5,-376(s0)
    800054ac:	08fadd63          	bge	s5,a5,80005546 <kexec+0x266>
      if(readi(ip, 0, (uint64)&ph, off, sizeof(ph)) != sizeof(ph))
    800054b0:	8bb6                	mv	s7,a3
    800054b2:	875a                	mv	a4,s6
    800054b4:	e1840613          	addi	a2,s0,-488
    800054b8:	4581                	li	a1,0
    800054ba:	8526                	mv	a0,s1
    800054bc:	bb3fe0ef          	jal	8000406e <readi>
    800054c0:	0d651763          	bne	a0,s6,8000558e <kexec+0x2ae>
      if(ph.type != ELF_PROG_LOAD)
    800054c4:	e1842783          	lw	a5,-488(s0)
    800054c8:	4705                	li	a4,1
    800054ca:	fce79ce3          	bne	a5,a4,800054a2 <kexec+0x1c2>
      if(ph.memsz < ph.filesz)
    800054ce:	e4043983          	ld	s3,-448(s0)
    800054d2:	e3843783          	ld	a5,-456(s0)
    800054d6:	0af9ec63          	bltu	s3,a5,8000558e <kexec+0x2ae>
      if(ph.vaddr + ph.memsz < ph.vaddr)
    800054da:	e2843a03          	ld	s4,-472(s0)
    800054de:	99d2                	add	s3,s3,s4
    800054e0:	0b49e763          	bltu	s3,s4,8000558e <kexec+0x2ae>
      if(ph.vaddr % PGSIZE != 0)
    800054e4:	dd843783          	ld	a5,-552(s0)
    800054e8:	00fa77b3          	and	a5,s4,a5
    800054ec:	e3cd                	bnez	a5,8000558e <kexec+0x2ae>
      if (ph.flags & ELF_PROG_FLAG_EXEC) { // Text segment
    800054ee:	e1c42503          	lw	a0,-484(s0)
    800054f2:	00e577b3          	and	a5,a0,a4
    800054f6:	cb99                	beqz	a5,8000550c <kexec+0x22c>
          if (text_start == -1 || ph.vaddr < text_start) text_start = ph.vaddr;
    800054f8:	dd043783          	ld	a5,-560(s0)
    800054fc:	577d                	li	a4,-1
    800054fe:	f6e788e3          	beq	a5,a4,8000546e <kexec+0x18e>
    80005502:	f6fa78e3          	bgeu	s4,a5,80005472 <kexec+0x192>
    80005506:	dd443823          	sd	s4,-560(s0)
    8000550a:	b7a5                	j	80005472 <kexec+0x192>
          if (data_start == -1 || ph.vaddr < data_start) data_start = ph.vaddr;
    8000550c:	dc843783          	ld	a5,-568(s0)
    80005510:	577d                	li	a4,-1
    80005512:	00e78763          	beq	a5,a4,80005520 <kexec+0x240>
    80005516:	00fa7763          	bgeu	s4,a5,80005524 <kexec+0x244>
    8000551a:	dd443423          	sd	s4,-568(s0)
    8000551e:	a019                	j	80005524 <kexec+0x244>
    80005520:	dd443423          	sd	s4,-568(s0)
          if (ph.vaddr + ph.memsz > data_end) data_end = ph.vaddr + ph.memsz;
    80005524:	db843783          	ld	a5,-584(s0)
    80005528:	f537fbe3          	bgeu	a5,s3,8000547e <kexec+0x19e>
    8000552c:	db343c23          	sd	s3,-584(s0)
    80005530:	b7b9                	j	8000547e <kexec+0x19e>
  uint64 data_start = -1, data_end = 0;
    80005532:	da043c23          	sd	zero,-584(s0)
    80005536:	57fd                	li	a5,-1
    80005538:	dcf43423          	sd	a5,-568(s0)
  uint64 text_start = -1, text_end = 0;
    8000553c:	dc043023          	sd	zero,-576(s0)
    80005540:	dcf43823          	sd	a5,-560(s0)
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    80005544:	4d01                	li	s10,0
  p->exec_ip = idup(ip);
    80005546:	8526                	mv	a0,s1
    80005548:	f5efe0ef          	jal	80003ca6 <idup>
    8000554c:	16a93823          	sd	a0,368(s2)
  p->num_phdrs = elf.phnum;
    80005550:	e8845783          	lhu	a5,-376(s0)
    80005554:	000899b7          	lui	s3,0x89
    80005558:	99ca                	add	s3,s3,s2
    8000555a:	1ef9a423          	sw	a5,488(s3) # 891e8 <_entry-0x7ff76e18>
  if(readi(ip, 0, (uint64)p->phdrs, elf.phoff, sizeof(struct proghdr) * p->num_phdrs) != sizeof(struct proghdr) * p->num_phdrs)
    8000555e:	0037971b          	slliw	a4,a5,0x3
    80005562:	9f1d                	subw	a4,a4,a5
    80005564:	0037171b          	slliw	a4,a4,0x3
    80005568:	e7042683          	lw	a3,-400(s0)
    8000556c:	00089637          	lui	a2,0x89
    80005570:	1f060613          	addi	a2,a2,496 # 891f0 <_entry-0x7ff76e10>
    80005574:	964a                	add	a2,a2,s2
    80005576:	4581                	li	a1,0
    80005578:	8526                	mv	a0,s1
    8000557a:	af5fe0ef          	jal	8000406e <readi>
    8000557e:	1e89a703          	lw	a4,488(s3)
    80005582:	00371793          	slli	a5,a4,0x3
    80005586:	8f99                	sub	a5,a5,a4
    80005588:	078e                	slli	a5,a5,0x3
    8000558a:	02f50163          	beq	a0,a5,800055ac <kexec+0x2cc>
      proc_freepagetable(pagetable, sz);
    8000558e:	85ea                	mv	a1,s10
    80005590:	856e                	mv	a0,s11
    80005592:	bb5fc0ef          	jal	80002146 <proc_freepagetable>
  if(ip){
    80005596:	22013a03          	ld	s4,544(sp)
    8000559a:	21813a83          	ld	s5,536(sp)
    8000559e:	21013b03          	ld	s6,528(sp)
    800055a2:	20813b83          	ld	s7,520(sp)
    800055a6:	7d5e                	ld	s10,496(sp)
    800055a8:	7dbe                	ld	s11,488(sp)
    800055aa:	b50d                	j	800053cc <kexec+0xec>
  iunlockput(ip);
    800055ac:	8526                	mv	a0,s1
    800055ae:	93bfe0ef          	jal	80003ee8 <iunlockput>
  end_op();
    800055b2:	9a6ff0ef          	jal	80004758 <end_op>
  p = myproc();
    800055b6:	a03fc0ef          	jal	80001fb8 <myproc>
    800055ba:	89aa                	mv	s3,a0
  uint64 oldsz = p->sz;
    800055bc:	653c                	ld	a5,72(a0)
    800055be:	dcf43c23          	sd	a5,-552(s0)
  p->heap_start = sz;
    800055c2:	17a53423          	sd	s10,360(a0)
  sz = PGROUNDUP(sz);
    800055c6:	6485                	lui	s1,0x1
    800055c8:	14fd                	addi	s1,s1,-1 # fff <_entry-0x7ffff001>
    800055ca:	94ea                	add	s1,s1,s10
    800055cc:	77fd                	lui	a5,0xfffff
    800055ce:	8cfd                	and	s1,s1,a5
  if((sz1 = uvmalloc(pagetable, sz, sz + (USERSTACK+1)*PGSIZE, PTE_W)) == 0)
    800055d0:	4691                	li	a3,4
    800055d2:	6609                	lui	a2,0x2
    800055d4:	9626                	add	a2,a2,s1
    800055d6:	85a6                	mv	a1,s1
    800055d8:	856e                	mv	a0,s11
    800055da:	abcfc0ef          	jal	80001896 <uvmalloc>
    800055de:	8d2a                	mv	s10,a0
    800055e0:	e10d                	bnez	a0,80005602 <kexec+0x322>
      proc_freepagetable(pagetable, sz);
    800055e2:	85a6                	mv	a1,s1
    800055e4:	856e                	mv	a0,s11
    800055e6:	b61fc0ef          	jal	80002146 <proc_freepagetable>
  return -1;
    800055ea:	557d                	li	a0,-1
    800055ec:	22013a03          	ld	s4,544(sp)
    800055f0:	21813a83          	ld	s5,536(sp)
    800055f4:	21013b03          	ld	s6,528(sp)
    800055f8:	20813b83          	ld	s7,520(sp)
    800055fc:	7d5e                	ld	s10,496(sp)
    800055fe:	7dbe                	ld	s11,488(sp)
    80005600:	bbe1                	j	800053d8 <kexec+0xf8>
  uvmclear(pagetable, sz-(USERSTACK+1)*PGSIZE);
    80005602:	75f9                	lui	a1,0xffffe
    80005604:	84aa                	mv	s1,a0
    80005606:	95aa                	add	a1,a1,a0
    80005608:	856e                	mv	a0,s11
    8000560a:	c54fc0ef          	jal	80001a5e <uvmclear>
  stackbase = sp - USERSTACK*PGSIZE;
    8000560e:	800d0913          	addi	s2,s10,-2048
    80005612:	80090913          	addi	s2,s2,-2048
  p->text_start = text_start;
    80005616:	000897b7          	lui	a5,0x89
    8000561a:	97ce                	add	a5,a5,s3
    8000561c:	dd043603          	ld	a2,-560(s0)
    80005620:	1cc7a823          	sw	a2,464(a5) # 891d0 <_entry-0x7ff76e30>
  p->text_end = text_end;
    80005624:	dc043683          	ld	a3,-576(s0)
    80005628:	1cd7aa23          	sw	a3,468(a5)
  p->data_start = data_start;
    8000562c:	dc843703          	ld	a4,-568(s0)
    80005630:	1ce7ac23          	sw	a4,472(a5)
  p->data_end = data_end;
    80005634:	db843503          	ld	a0,-584(s0)
    80005638:	1ca7ae23          	sw	a0,476(a5)
  p->stack_top = sp;
    8000563c:	1fa7a223          	sw	s10,484(a5)
  printf("[pid %d] INIT-LAZYMAP text=[0x%lx,0x%lx) data=[0x%lx,0x%lx) heap_start=0x%lx stack_top=0x%lx\n",
    80005640:	88ea                	mv	a7,s10
    80005642:	1689b803          	ld	a6,360(s3)
    80005646:	87aa                	mv	a5,a0
    80005648:	0309a583          	lw	a1,48(s3)
    8000564c:	00003517          	auipc	a0,0x3
    80005650:	27c50513          	addi	a0,a0,636 # 800088c8 <etext+0x8c8>
    80005654:	ea7fa0ef          	jal	800004fa <printf>
  for(argc = 0; argv[argc]; argc++) {
    80005658:	000cb503          	ld	a0,0(s9)
    8000565c:	4a81                	li	s5,0
      ustack[argc] = sp;
    8000565e:	e9040a13          	addi	s4,s0,-368
  for(argc = 0; argv[argc]; argc++) {
    80005662:	c13d                	beqz	a0,800056c8 <kexec+0x3e8>
      sp -= strlen(argv[argc]) + 1;
    80005664:	81ffb0ef          	jal	80000e82 <strlen>
    80005668:	0015079b          	addiw	a5,a0,1
    8000566c:	40f487b3          	sub	a5,s1,a5
      sp -= sp % 16; // riscv sp must be 16-byte aligned
    80005670:	ff07f493          	andi	s1,a5,-16
      if(sp < stackbase)
    80005674:	1124e763          	bltu	s1,s2,80005782 <kexec+0x4a2>
      if(copyout(pagetable, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
    80005678:	8be6                	mv	s7,s9
    8000567a:	000cbb03          	ld	s6,0(s9)
    8000567e:	855a                	mv	a0,s6
    80005680:	803fb0ef          	jal	80000e82 <strlen>
    80005684:	0015069b          	addiw	a3,a0,1
    80005688:	865a                	mv	a2,s6
    8000568a:	85a6                	mv	a1,s1
    8000568c:	856e                	mv	a0,s11
    8000568e:	bfafc0ef          	jal	80001a88 <copyout>
    80005692:	0e054a63          	bltz	a0,80005786 <kexec+0x4a6>
      ustack[argc] = sp;
    80005696:	003a9793          	slli	a5,s5,0x3
    8000569a:	97d2                	add	a5,a5,s4
    8000569c:	e384                	sd	s1,0(a5)
      printf("sp = 0x%lx and sb = 0x%lx\n",sp,stackbase);
    8000569e:	864a                	mv	a2,s2
    800056a0:	85a6                	mv	a1,s1
    800056a2:	00003517          	auipc	a0,0x3
    800056a6:	28650513          	addi	a0,a0,646 # 80008928 <etext+0x928>
    800056aa:	e51fa0ef          	jal	800004fa <printf>
  for(argc = 0; argv[argc]; argc++) {
    800056ae:	0a85                	addi	s5,s5,1
    800056b0:	008c8793          	addi	a5,s9,8
    800056b4:	8cbe                	mv	s9,a5
    800056b6:	008bb503          	ld	a0,8(s7)
    800056ba:	c519                	beqz	a0,800056c8 <kexec+0x3e8>
      if(argc >= MAXARG)
    800056bc:	02000793          	li	a5,32
    800056c0:	fafa92e3          	bne	s5,a5,80005664 <kexec+0x384>
  sz = sz1;
    800056c4:	84ea                	mv	s1,s10
    800056c6:	bf31                	j	800055e2 <kexec+0x302>
  ustack[argc] = 0;
    800056c8:	003a9793          	slli	a5,s5,0x3
    800056cc:	fc078793          	addi	a5,a5,-64
    800056d0:	fd040713          	addi	a4,s0,-48
    800056d4:	97ba                	add	a5,a5,a4
    800056d6:	f007b023          	sd	zero,-256(a5)
  sp -= (argc+1) * sizeof(uint64);
    800056da:	003a9693          	slli	a3,s5,0x3
    800056de:	06a1                	addi	a3,a3,8
    800056e0:	8c95                	sub	s1,s1,a3
  sp -= sp % 16;
    800056e2:	ff04fb13          	andi	s6,s1,-16
  sz = sz1;
    800056e6:	84ea                	mv	s1,s10
  if(sp < stackbase)
    800056e8:	ef2b6de3          	bltu	s6,s2,800055e2 <kexec+0x302>
  if(copyout(pagetable, sp, (char *)ustack, (argc+1)*sizeof(uint64)) < 0)
    800056ec:	e9040613          	addi	a2,s0,-368
    800056f0:	85da                	mv	a1,s6
    800056f2:	856e                	mv	a0,s11
    800056f4:	b94fc0ef          	jal	80001a88 <copyout>
    800056f8:	ee0545e3          	bltz	a0,800055e2 <kexec+0x302>
  p->trapframe->a1 = sp;
    800056fc:	0589b783          	ld	a5,88(s3)
    80005700:	0767bc23          	sd	s6,120(a5)
  for(last=s=path; *s; s++)
    80005704:	000c4703          	lbu	a4,0(s8)
    80005708:	cf11                	beqz	a4,80005724 <kexec+0x444>
    8000570a:	001c0793          	addi	a5,s8,1
      if(*s == '/')
    8000570e:	02f00693          	li	a3,47
    80005712:	a029                	j	8000571c <kexec+0x43c>
  for(last=s=path; *s; s++)
    80005714:	0785                	addi	a5,a5,1
    80005716:	fff7c703          	lbu	a4,-1(a5)
    8000571a:	c709                	beqz	a4,80005724 <kexec+0x444>
      if(*s == '/')
    8000571c:	fed71ce3          	bne	a4,a3,80005714 <kexec+0x434>
          last = s+1;
    80005720:	8c3e                	mv	s8,a5
    80005722:	bfcd                	j	80005714 <kexec+0x434>
  safestrcpy(p->name, last, sizeof(p->name));
    80005724:	4641                	li	a2,16
    80005726:	85e2                	mv	a1,s8
    80005728:	15898513          	addi	a0,s3,344
    8000572c:	f20fb0ef          	jal	80000e4c <safestrcpy>
  oldpagetable = p->pagetable;
    80005730:	0509b503          	ld	a0,80(s3)
  p->num_resident = 0; 
    80005734:	000897b7          	lui	a5,0x89
    80005738:	97ce                	add	a5,a5,s3
    8000573a:	1a07a823          	sw	zero,432(a5) # 891b0 <_entry-0x7ff76e50>
  p->next_fifo_seq = 0;
    8000573e:	1c07a423          	sw	zero,456(a5)
  p->pagetable = pagetable;
    80005742:	05b9b823          	sd	s11,80(s3)
  p->sz = sz;
    80005746:	05a9b423          	sd	s10,72(s3)
  p->trapframe->epc = elf.entry;
    8000574a:	0589b783          	ld	a5,88(s3)
    8000574e:	e6843703          	ld	a4,-408(s0)
    80005752:	ef98                	sd	a4,24(a5)
  p->trapframe->sp = sp;
    80005754:	0589b783          	ld	a5,88(s3)
    80005758:	0367b823          	sd	s6,48(a5)
  proc_freepagetable(oldpagetable, oldsz);
    8000575c:	dd843583          	ld	a1,-552(s0)
    80005760:	9e7fc0ef          	jal	80002146 <proc_freepagetable>
  return argc;
    80005764:	000a851b          	sext.w	a0,s5
    80005768:	22013a03          	ld	s4,544(sp)
    8000576c:	21813a83          	ld	s5,536(sp)
    80005770:	21013b03          	ld	s6,528(sp)
    80005774:	20813b83          	ld	s7,520(sp)
    80005778:	7d5e                	ld	s10,496(sp)
    8000577a:	7dbe                	ld	s11,488(sp)
    8000577c:	b9b1                	j	800053d8 <kexec+0xf8>
    8000577e:	7dbe                	ld	s11,488(sp)
    80005780:	b1b1                	j	800053cc <kexec+0xec>
  sz = sz1;
    80005782:	84ea                	mv	s1,s10
    80005784:	bdb9                	j	800055e2 <kexec+0x302>
    80005786:	84ea                	mv	s1,s10
    80005788:	bda9                	j	800055e2 <kexec+0x302>

000000008000578a <argfd>:

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
{
    8000578a:	7179                	addi	sp,sp,-48
    8000578c:	f406                	sd	ra,40(sp)
    8000578e:	f022                	sd	s0,32(sp)
    80005790:	ec26                	sd	s1,24(sp)
    80005792:	e84a                	sd	s2,16(sp)
    80005794:	1800                	addi	s0,sp,48
    80005796:	892e                	mv	s2,a1
    80005798:	84b2                	mv	s1,a2
  int fd;
  struct file *f;

  argint(n, &fd);
    8000579a:	fdc40593          	addi	a1,s0,-36
    8000579e:	a13fd0ef          	jal	800031b0 <argint>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
    800057a2:	fdc42703          	lw	a4,-36(s0)
    800057a6:	47bd                	li	a5,15
    800057a8:	02e7ea63          	bltu	a5,a4,800057dc <argfd+0x52>
    800057ac:	80dfc0ef          	jal	80001fb8 <myproc>
    800057b0:	fdc42703          	lw	a4,-36(s0)
    800057b4:	00371793          	slli	a5,a4,0x3
    800057b8:	0d078793          	addi	a5,a5,208
    800057bc:	953e                	add	a0,a0,a5
    800057be:	611c                	ld	a5,0(a0)
    800057c0:	c385                	beqz	a5,800057e0 <argfd+0x56>
    return -1;
  if(pfd)
    800057c2:	00090463          	beqz	s2,800057ca <argfd+0x40>
    *pfd = fd;
    800057c6:	00e92023          	sw	a4,0(s2)
  if(pf)
    *pf = f;
  return 0;
    800057ca:	4501                	li	a0,0
  if(pf)
    800057cc:	c091                	beqz	s1,800057d0 <argfd+0x46>
    *pf = f;
    800057ce:	e09c                	sd	a5,0(s1)
}
    800057d0:	70a2                	ld	ra,40(sp)
    800057d2:	7402                	ld	s0,32(sp)
    800057d4:	64e2                	ld	s1,24(sp)
    800057d6:	6942                	ld	s2,16(sp)
    800057d8:	6145                	addi	sp,sp,48
    800057da:	8082                	ret
    return -1;
    800057dc:	557d                	li	a0,-1
    800057de:	bfcd                	j	800057d0 <argfd+0x46>
    800057e0:	557d                	li	a0,-1
    800057e2:	b7fd                	j	800057d0 <argfd+0x46>

00000000800057e4 <fdalloc>:

// Allocate a file descriptor for the given file.
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
    800057e4:	1101                	addi	sp,sp,-32
    800057e6:	ec06                	sd	ra,24(sp)
    800057e8:	e822                	sd	s0,16(sp)
    800057ea:	e426                	sd	s1,8(sp)
    800057ec:	1000                	addi	s0,sp,32
    800057ee:	84aa                	mv	s1,a0
  int fd;
  struct proc *p = myproc();
    800057f0:	fc8fc0ef          	jal	80001fb8 <myproc>
    800057f4:	862a                	mv	a2,a0

  for(fd = 0; fd < NOFILE; fd++){
    800057f6:	0d050793          	addi	a5,a0,208
    800057fa:	4501                	li	a0,0
    800057fc:	46c1                	li	a3,16
    if(p->ofile[fd] == 0){
    800057fe:	6398                	ld	a4,0(a5)
    80005800:	cb19                	beqz	a4,80005816 <fdalloc+0x32>
  for(fd = 0; fd < NOFILE; fd++){
    80005802:	2505                	addiw	a0,a0,1
    80005804:	07a1                	addi	a5,a5,8
    80005806:	fed51ce3          	bne	a0,a3,800057fe <fdalloc+0x1a>
      p->ofile[fd] = f;
      return fd;
    }
  }
  return -1;
    8000580a:	557d                	li	a0,-1
}
    8000580c:	60e2                	ld	ra,24(sp)
    8000580e:	6442                	ld	s0,16(sp)
    80005810:	64a2                	ld	s1,8(sp)
    80005812:	6105                	addi	sp,sp,32
    80005814:	8082                	ret
      p->ofile[fd] = f;
    80005816:	00351793          	slli	a5,a0,0x3
    8000581a:	0d078793          	addi	a5,a5,208
    8000581e:	963e                	add	a2,a2,a5
    80005820:	e204                	sd	s1,0(a2)
      return fd;
    80005822:	b7ed                	j	8000580c <fdalloc+0x28>

0000000080005824 <sys_dup>:

uint64
sys_dup(void)
{
    80005824:	7179                	addi	sp,sp,-48
    80005826:	f406                	sd	ra,40(sp)
    80005828:	f022                	sd	s0,32(sp)
    8000582a:	1800                	addi	s0,sp,48
  struct file *f;
  int fd;

  if(argfd(0, 0, &f) < 0)
    8000582c:	fd840613          	addi	a2,s0,-40
    80005830:	4581                	li	a1,0
    80005832:	4501                	li	a0,0
    80005834:	f57ff0ef          	jal	8000578a <argfd>
    return -1;
    80005838:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0)
    8000583a:	02054363          	bltz	a0,80005860 <sys_dup+0x3c>
    8000583e:	ec26                	sd	s1,24(sp)
    80005840:	e84a                	sd	s2,16(sp)
  if((fd=fdalloc(f)) < 0)
    80005842:	fd843483          	ld	s1,-40(s0)
    80005846:	8526                	mv	a0,s1
    80005848:	f9dff0ef          	jal	800057e4 <fdalloc>
    8000584c:	892a                	mv	s2,a0
    return -1;
    8000584e:	57fd                	li	a5,-1
  if((fd=fdalloc(f)) < 0)
    80005850:	00054d63          	bltz	a0,8000586a <sys_dup+0x46>
  filedup(f);
    80005854:	8526                	mv	a0,s1
    80005856:	a70ff0ef          	jal	80004ac6 <filedup>
  return fd;
    8000585a:	87ca                	mv	a5,s2
    8000585c:	64e2                	ld	s1,24(sp)
    8000585e:	6942                	ld	s2,16(sp)
}
    80005860:	853e                	mv	a0,a5
    80005862:	70a2                	ld	ra,40(sp)
    80005864:	7402                	ld	s0,32(sp)
    80005866:	6145                	addi	sp,sp,48
    80005868:	8082                	ret
    8000586a:	64e2                	ld	s1,24(sp)
    8000586c:	6942                	ld	s2,16(sp)
    8000586e:	bfcd                	j	80005860 <sys_dup+0x3c>

0000000080005870 <sys_read>:

uint64
sys_read(void)
{
    80005870:	7179                	addi	sp,sp,-48
    80005872:	f406                	sd	ra,40(sp)
    80005874:	f022                	sd	s0,32(sp)
    80005876:	1800                	addi	s0,sp,48
  struct file *f;
  int n;
  uint64 p;

  argaddr(1, &p);
    80005878:	fd840593          	addi	a1,s0,-40
    8000587c:	4505                	li	a0,1
    8000587e:	94ffd0ef          	jal	800031cc <argaddr>
  argint(2, &n);
    80005882:	fe440593          	addi	a1,s0,-28
    80005886:	4509                	li	a0,2
    80005888:	929fd0ef          	jal	800031b0 <argint>
  if(argfd(0, 0, &f) < 0)
    8000588c:	fe840613          	addi	a2,s0,-24
    80005890:	4581                	li	a1,0
    80005892:	4501                	li	a0,0
    80005894:	ef7ff0ef          	jal	8000578a <argfd>
    80005898:	87aa                	mv	a5,a0
    return -1;
    8000589a:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    8000589c:	0007ca63          	bltz	a5,800058b0 <sys_read+0x40>
  return fileread(f, p, n);
    800058a0:	fe442603          	lw	a2,-28(s0)
    800058a4:	fd843583          	ld	a1,-40(s0)
    800058a8:	fe843503          	ld	a0,-24(s0)
    800058ac:	b84ff0ef          	jal	80004c30 <fileread>
}
    800058b0:	70a2                	ld	ra,40(sp)
    800058b2:	7402                	ld	s0,32(sp)
    800058b4:	6145                	addi	sp,sp,48
    800058b6:	8082                	ret

00000000800058b8 <sys_write>:

uint64
sys_write(void)
{
    800058b8:	7179                	addi	sp,sp,-48
    800058ba:	f406                	sd	ra,40(sp)
    800058bc:	f022                	sd	s0,32(sp)
    800058be:	1800                	addi	s0,sp,48
  struct file *f;
  int n;
  uint64 p;
  
  argaddr(1, &p);
    800058c0:	fd840593          	addi	a1,s0,-40
    800058c4:	4505                	li	a0,1
    800058c6:	907fd0ef          	jal	800031cc <argaddr>
  argint(2, &n);
    800058ca:	fe440593          	addi	a1,s0,-28
    800058ce:	4509                	li	a0,2
    800058d0:	8e1fd0ef          	jal	800031b0 <argint>
  if(argfd(0, 0, &f) < 0)
    800058d4:	fe840613          	addi	a2,s0,-24
    800058d8:	4581                	li	a1,0
    800058da:	4501                	li	a0,0
    800058dc:	eafff0ef          	jal	8000578a <argfd>
    800058e0:	87aa                	mv	a5,a0
    return -1;
    800058e2:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    800058e4:	0007ca63          	bltz	a5,800058f8 <sys_write+0x40>

  return filewrite(f, p, n);
    800058e8:	fe442603          	lw	a2,-28(s0)
    800058ec:	fd843583          	ld	a1,-40(s0)
    800058f0:	fe843503          	ld	a0,-24(s0)
    800058f4:	c00ff0ef          	jal	80004cf4 <filewrite>
}
    800058f8:	70a2                	ld	ra,40(sp)
    800058fa:	7402                	ld	s0,32(sp)
    800058fc:	6145                	addi	sp,sp,48
    800058fe:	8082                	ret

0000000080005900 <sys_close>:

uint64
sys_close(void)
{
    80005900:	1101                	addi	sp,sp,-32
    80005902:	ec06                	sd	ra,24(sp)
    80005904:	e822                	sd	s0,16(sp)
    80005906:	1000                	addi	s0,sp,32
  int fd;
  struct file *f;

  if(argfd(0, &fd, &f) < 0)
    80005908:	fe040613          	addi	a2,s0,-32
    8000590c:	fec40593          	addi	a1,s0,-20
    80005910:	4501                	li	a0,0
    80005912:	e79ff0ef          	jal	8000578a <argfd>
    return -1;
    80005916:	57fd                	li	a5,-1
  if(argfd(0, &fd, &f) < 0)
    80005918:	02054163          	bltz	a0,8000593a <sys_close+0x3a>
  myproc()->ofile[fd] = 0;
    8000591c:	e9cfc0ef          	jal	80001fb8 <myproc>
    80005920:	fec42783          	lw	a5,-20(s0)
    80005924:	078e                	slli	a5,a5,0x3
    80005926:	0d078793          	addi	a5,a5,208
    8000592a:	953e                	add	a0,a0,a5
    8000592c:	00053023          	sd	zero,0(a0)
  fileclose(f);
    80005930:	fe043503          	ld	a0,-32(s0)
    80005934:	9d8ff0ef          	jal	80004b0c <fileclose>
  return 0;
    80005938:	4781                	li	a5,0
}
    8000593a:	853e                	mv	a0,a5
    8000593c:	60e2                	ld	ra,24(sp)
    8000593e:	6442                	ld	s0,16(sp)
    80005940:	6105                	addi	sp,sp,32
    80005942:	8082                	ret

0000000080005944 <sys_fstat>:

uint64
sys_fstat(void)
{
    80005944:	1101                	addi	sp,sp,-32
    80005946:	ec06                	sd	ra,24(sp)
    80005948:	e822                	sd	s0,16(sp)
    8000594a:	1000                	addi	s0,sp,32
  struct file *f;
  uint64 st; // user pointer to struct stat

  argaddr(1, &st);
    8000594c:	fe040593          	addi	a1,s0,-32
    80005950:	4505                	li	a0,1
    80005952:	87bfd0ef          	jal	800031cc <argaddr>
  if(argfd(0, 0, &f) < 0)
    80005956:	fe840613          	addi	a2,s0,-24
    8000595a:	4581                	li	a1,0
    8000595c:	4501                	li	a0,0
    8000595e:	e2dff0ef          	jal	8000578a <argfd>
    80005962:	87aa                	mv	a5,a0
    return -1;
    80005964:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    80005966:	0007c863          	bltz	a5,80005976 <sys_fstat+0x32>
  return filestat(f, st);
    8000596a:	fe043583          	ld	a1,-32(s0)
    8000596e:	fe843503          	ld	a0,-24(s0)
    80005972:	a5cff0ef          	jal	80004bce <filestat>
}
    80005976:	60e2                	ld	ra,24(sp)
    80005978:	6442                	ld	s0,16(sp)
    8000597a:	6105                	addi	sp,sp,32
    8000597c:	8082                	ret

000000008000597e <sys_link>:

// Create the path new as a link to the same inode as old.
uint64
sys_link(void)
{
    8000597e:	7169                	addi	sp,sp,-304
    80005980:	f606                	sd	ra,296(sp)
    80005982:	f222                	sd	s0,288(sp)
    80005984:	1a00                	addi	s0,sp,304
  char name[DIRSIZ], new[MAXPATH], old[MAXPATH];
  struct inode *dp, *ip;

  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80005986:	08000613          	li	a2,128
    8000598a:	ed040593          	addi	a1,s0,-304
    8000598e:	4501                	li	a0,0
    80005990:	859fd0ef          	jal	800031e8 <argstr>
    return -1;
    80005994:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80005996:	0c054e63          	bltz	a0,80005a72 <sys_link+0xf4>
    8000599a:	08000613          	li	a2,128
    8000599e:	f5040593          	addi	a1,s0,-176
    800059a2:	4505                	li	a0,1
    800059a4:	845fd0ef          	jal	800031e8 <argstr>
    return -1;
    800059a8:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    800059aa:	0c054463          	bltz	a0,80005a72 <sys_link+0xf4>
    800059ae:	ee26                	sd	s1,280(sp)

  begin_op();
    800059b0:	d39fe0ef          	jal	800046e8 <begin_op>
  if((ip = namei(old)) == 0){
    800059b4:	ed040513          	addi	a0,s0,-304
    800059b8:	b53fe0ef          	jal	8000450a <namei>
    800059bc:	84aa                	mv	s1,a0
    800059be:	c53d                	beqz	a0,80005a2c <sys_link+0xae>
    end_op();
    return -1;
  }

  ilock(ip);
    800059c0:	b1cfe0ef          	jal	80003cdc <ilock>
  if(ip->type == T_DIR){
    800059c4:	04449703          	lh	a4,68(s1)
    800059c8:	4785                	li	a5,1
    800059ca:	06f70663          	beq	a4,a5,80005a36 <sys_link+0xb8>
    800059ce:	ea4a                	sd	s2,272(sp)
    iunlockput(ip);
    end_op();
    return -1;
  }

  ip->nlink++;
    800059d0:	04a4d783          	lhu	a5,74(s1)
    800059d4:	2785                	addiw	a5,a5,1
    800059d6:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    800059da:	8526                	mv	a0,s1
    800059dc:	a4cfe0ef          	jal	80003c28 <iupdate>
  iunlock(ip);
    800059e0:	8526                	mv	a0,s1
    800059e2:	ba8fe0ef          	jal	80003d8a <iunlock>

  if((dp = nameiparent(new, name)) == 0)
    800059e6:	fd040593          	addi	a1,s0,-48
    800059ea:	f5040513          	addi	a0,s0,-176
    800059ee:	b37fe0ef          	jal	80004524 <nameiparent>
    800059f2:	892a                	mv	s2,a0
    800059f4:	cd21                	beqz	a0,80005a4c <sys_link+0xce>
    goto bad;
  ilock(dp);
    800059f6:	ae6fe0ef          	jal	80003cdc <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
    800059fa:	854a                	mv	a0,s2
    800059fc:	00092703          	lw	a4,0(s2)
    80005a00:	409c                	lw	a5,0(s1)
    80005a02:	04f71263          	bne	a4,a5,80005a46 <sys_link+0xc8>
    80005a06:	40d0                	lw	a2,4(s1)
    80005a08:	fd040593          	addi	a1,s0,-48
    80005a0c:	a55fe0ef          	jal	80004460 <dirlink>
    80005a10:	02054b63          	bltz	a0,80005a46 <sys_link+0xc8>
    iunlockput(dp);
    goto bad;
  }
  iunlockput(dp);
    80005a14:	854a                	mv	a0,s2
    80005a16:	cd2fe0ef          	jal	80003ee8 <iunlockput>
  iput(ip);
    80005a1a:	8526                	mv	a0,s1
    80005a1c:	c42fe0ef          	jal	80003e5e <iput>

  end_op();
    80005a20:	d39fe0ef          	jal	80004758 <end_op>

  return 0;
    80005a24:	4781                	li	a5,0
    80005a26:	64f2                	ld	s1,280(sp)
    80005a28:	6952                	ld	s2,272(sp)
    80005a2a:	a0a1                	j	80005a72 <sys_link+0xf4>
    end_op();
    80005a2c:	d2dfe0ef          	jal	80004758 <end_op>
    return -1;
    80005a30:	57fd                	li	a5,-1
    80005a32:	64f2                	ld	s1,280(sp)
    80005a34:	a83d                	j	80005a72 <sys_link+0xf4>
    iunlockput(ip);
    80005a36:	8526                	mv	a0,s1
    80005a38:	cb0fe0ef          	jal	80003ee8 <iunlockput>
    end_op();
    80005a3c:	d1dfe0ef          	jal	80004758 <end_op>
    return -1;
    80005a40:	57fd                	li	a5,-1
    80005a42:	64f2                	ld	s1,280(sp)
    80005a44:	a03d                	j	80005a72 <sys_link+0xf4>
    iunlockput(dp);
    80005a46:	854a                	mv	a0,s2
    80005a48:	ca0fe0ef          	jal	80003ee8 <iunlockput>

bad:
  ilock(ip);
    80005a4c:	8526                	mv	a0,s1
    80005a4e:	a8efe0ef          	jal	80003cdc <ilock>
  ip->nlink--;
    80005a52:	04a4d783          	lhu	a5,74(s1)
    80005a56:	37fd                	addiw	a5,a5,-1
    80005a58:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    80005a5c:	8526                	mv	a0,s1
    80005a5e:	9cafe0ef          	jal	80003c28 <iupdate>
  iunlockput(ip);
    80005a62:	8526                	mv	a0,s1
    80005a64:	c84fe0ef          	jal	80003ee8 <iunlockput>
  end_op();
    80005a68:	cf1fe0ef          	jal	80004758 <end_op>
  return -1;
    80005a6c:	57fd                	li	a5,-1
    80005a6e:	64f2                	ld	s1,280(sp)
    80005a70:	6952                	ld	s2,272(sp)
}
    80005a72:	853e                	mv	a0,a5
    80005a74:	70b2                	ld	ra,296(sp)
    80005a76:	7412                	ld	s0,288(sp)
    80005a78:	6155                	addi	sp,sp,304
    80005a7a:	8082                	ret

0000000080005a7c <sys_unlink>:
  return 1;
}

uint64
sys_unlink(void)
{
    80005a7c:	7151                	addi	sp,sp,-240
    80005a7e:	f586                	sd	ra,232(sp)
    80005a80:	f1a2                	sd	s0,224(sp)
    80005a82:	1980                	addi	s0,sp,240
  struct inode *ip, *dp;
  struct dirent de;
  char name[DIRSIZ], path[MAXPATH];
  uint off;

  if(argstr(0, path, MAXPATH) < 0)
    80005a84:	08000613          	li	a2,128
    80005a88:	f3040593          	addi	a1,s0,-208
    80005a8c:	4501                	li	a0,0
    80005a8e:	f5afd0ef          	jal	800031e8 <argstr>
    80005a92:	14054d63          	bltz	a0,80005bec <sys_unlink+0x170>
    80005a96:	eda6                	sd	s1,216(sp)
    return -1;

  begin_op();
    80005a98:	c51fe0ef          	jal	800046e8 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
    80005a9c:	fb040593          	addi	a1,s0,-80
    80005aa0:	f3040513          	addi	a0,s0,-208
    80005aa4:	a81fe0ef          	jal	80004524 <nameiparent>
    80005aa8:	84aa                	mv	s1,a0
    80005aaa:	c955                	beqz	a0,80005b5e <sys_unlink+0xe2>
    end_op();
    return -1;
  }

  ilock(dp);
    80005aac:	a30fe0ef          	jal	80003cdc <ilock>

  // Cannot unlink "." or "..".
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
    80005ab0:	00003597          	auipc	a1,0x3
    80005ab4:	e9858593          	addi	a1,a1,-360 # 80008948 <etext+0x948>
    80005ab8:	fb040513          	addi	a0,s0,-80
    80005abc:	fa4fe0ef          	jal	80004260 <namecmp>
    80005ac0:	10050b63          	beqz	a0,80005bd6 <sys_unlink+0x15a>
    80005ac4:	00003597          	auipc	a1,0x3
    80005ac8:	e8c58593          	addi	a1,a1,-372 # 80008950 <etext+0x950>
    80005acc:	fb040513          	addi	a0,s0,-80
    80005ad0:	f90fe0ef          	jal	80004260 <namecmp>
    80005ad4:	10050163          	beqz	a0,80005bd6 <sys_unlink+0x15a>
    80005ad8:	e9ca                	sd	s2,208(sp)
    goto bad;

  if((ip = dirlookup(dp, name, &off)) == 0)
    80005ada:	f2c40613          	addi	a2,s0,-212
    80005ade:	fb040593          	addi	a1,s0,-80
    80005ae2:	8526                	mv	a0,s1
    80005ae4:	f92fe0ef          	jal	80004276 <dirlookup>
    80005ae8:	892a                	mv	s2,a0
    80005aea:	0e050563          	beqz	a0,80005bd4 <sys_unlink+0x158>
    80005aee:	e5ce                	sd	s3,200(sp)
    goto bad;
  ilock(ip);
    80005af0:	9ecfe0ef          	jal	80003cdc <ilock>

  if(ip->nlink < 1)
    80005af4:	04a91783          	lh	a5,74(s2)
    80005af8:	06f05863          	blez	a5,80005b68 <sys_unlink+0xec>
    panic("unlink: nlink < 1");
  if(ip->type == T_DIR && !isdirempty(ip)){
    80005afc:	04491703          	lh	a4,68(s2)
    80005b00:	4785                	li	a5,1
    80005b02:	06f70963          	beq	a4,a5,80005b74 <sys_unlink+0xf8>
    iunlockput(ip);
    goto bad;
  }

  memset(&de, 0, sizeof(de));
    80005b06:	fc040993          	addi	s3,s0,-64
    80005b0a:	4641                	li	a2,16
    80005b0c:	4581                	li	a1,0
    80005b0e:	854e                	mv	a0,s3
    80005b10:	9e8fb0ef          	jal	80000cf8 <memset>
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80005b14:	4741                	li	a4,16
    80005b16:	f2c42683          	lw	a3,-212(s0)
    80005b1a:	864e                	mv	a2,s3
    80005b1c:	4581                	li	a1,0
    80005b1e:	8526                	mv	a0,s1
    80005b20:	e40fe0ef          	jal	80004160 <writei>
    80005b24:	47c1                	li	a5,16
    80005b26:	08f51863          	bne	a0,a5,80005bb6 <sys_unlink+0x13a>
    panic("unlink: writei");
  if(ip->type == T_DIR){
    80005b2a:	04491703          	lh	a4,68(s2)
    80005b2e:	4785                	li	a5,1
    80005b30:	08f70963          	beq	a4,a5,80005bc2 <sys_unlink+0x146>
    dp->nlink--;
    iupdate(dp);
  }
  iunlockput(dp);
    80005b34:	8526                	mv	a0,s1
    80005b36:	bb2fe0ef          	jal	80003ee8 <iunlockput>

  ip->nlink--;
    80005b3a:	04a95783          	lhu	a5,74(s2)
    80005b3e:	37fd                	addiw	a5,a5,-1
    80005b40:	04f91523          	sh	a5,74(s2)
  iupdate(ip);
    80005b44:	854a                	mv	a0,s2
    80005b46:	8e2fe0ef          	jal	80003c28 <iupdate>
  iunlockput(ip);
    80005b4a:	854a                	mv	a0,s2
    80005b4c:	b9cfe0ef          	jal	80003ee8 <iunlockput>

  end_op();
    80005b50:	c09fe0ef          	jal	80004758 <end_op>

  return 0;
    80005b54:	4501                	li	a0,0
    80005b56:	64ee                	ld	s1,216(sp)
    80005b58:	694e                	ld	s2,208(sp)
    80005b5a:	69ae                	ld	s3,200(sp)
    80005b5c:	a061                	j	80005be4 <sys_unlink+0x168>
    end_op();
    80005b5e:	bfbfe0ef          	jal	80004758 <end_op>
    return -1;
    80005b62:	557d                	li	a0,-1
    80005b64:	64ee                	ld	s1,216(sp)
    80005b66:	a8bd                	j	80005be4 <sys_unlink+0x168>
    panic("unlink: nlink < 1");
    80005b68:	00003517          	auipc	a0,0x3
    80005b6c:	df050513          	addi	a0,a0,-528 # 80008958 <etext+0x958>
    80005b70:	cb5fa0ef          	jal	80000824 <panic>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    80005b74:	04c92703          	lw	a4,76(s2)
    80005b78:	02000793          	li	a5,32
    80005b7c:	f8e7f5e3          	bgeu	a5,a4,80005b06 <sys_unlink+0x8a>
    80005b80:	89be                	mv	s3,a5
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80005b82:	4741                	li	a4,16
    80005b84:	86ce                	mv	a3,s3
    80005b86:	f1840613          	addi	a2,s0,-232
    80005b8a:	4581                	li	a1,0
    80005b8c:	854a                	mv	a0,s2
    80005b8e:	ce0fe0ef          	jal	8000406e <readi>
    80005b92:	47c1                	li	a5,16
    80005b94:	00f51b63          	bne	a0,a5,80005baa <sys_unlink+0x12e>
    if(de.inum != 0)
    80005b98:	f1845783          	lhu	a5,-232(s0)
    80005b9c:	ebb1                	bnez	a5,80005bf0 <sys_unlink+0x174>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    80005b9e:	29c1                	addiw	s3,s3,16
    80005ba0:	04c92783          	lw	a5,76(s2)
    80005ba4:	fcf9efe3          	bltu	s3,a5,80005b82 <sys_unlink+0x106>
    80005ba8:	bfb9                	j	80005b06 <sys_unlink+0x8a>
      panic("isdirempty: readi");
    80005baa:	00003517          	auipc	a0,0x3
    80005bae:	dc650513          	addi	a0,a0,-570 # 80008970 <etext+0x970>
    80005bb2:	c73fa0ef          	jal	80000824 <panic>
    panic("unlink: writei");
    80005bb6:	00003517          	auipc	a0,0x3
    80005bba:	dd250513          	addi	a0,a0,-558 # 80008988 <etext+0x988>
    80005bbe:	c67fa0ef          	jal	80000824 <panic>
    dp->nlink--;
    80005bc2:	04a4d783          	lhu	a5,74(s1)
    80005bc6:	37fd                	addiw	a5,a5,-1
    80005bc8:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    80005bcc:	8526                	mv	a0,s1
    80005bce:	85afe0ef          	jal	80003c28 <iupdate>
    80005bd2:	b78d                	j	80005b34 <sys_unlink+0xb8>
    80005bd4:	694e                	ld	s2,208(sp)

bad:
  iunlockput(dp);
    80005bd6:	8526                	mv	a0,s1
    80005bd8:	b10fe0ef          	jal	80003ee8 <iunlockput>
  end_op();
    80005bdc:	b7dfe0ef          	jal	80004758 <end_op>
  return -1;
    80005be0:	557d                	li	a0,-1
    80005be2:	64ee                	ld	s1,216(sp)
}
    80005be4:	70ae                	ld	ra,232(sp)
    80005be6:	740e                	ld	s0,224(sp)
    80005be8:	616d                	addi	sp,sp,240
    80005bea:	8082                	ret
    return -1;
    80005bec:	557d                	li	a0,-1
    80005bee:	bfdd                	j	80005be4 <sys_unlink+0x168>
    iunlockput(ip);
    80005bf0:	854a                	mv	a0,s2
    80005bf2:	af6fe0ef          	jal	80003ee8 <iunlockput>
    goto bad;
    80005bf6:	694e                	ld	s2,208(sp)
    80005bf8:	69ae                	ld	s3,200(sp)
    80005bfa:	bff1                	j	80005bd6 <sys_unlink+0x15a>

0000000080005bfc <create>:

struct inode*
create(char *path, short type, short major, short minor)
{
    80005bfc:	715d                	addi	sp,sp,-80
    80005bfe:	e486                	sd	ra,72(sp)
    80005c00:	e0a2                	sd	s0,64(sp)
    80005c02:	fc26                	sd	s1,56(sp)
    80005c04:	f84a                	sd	s2,48(sp)
    80005c06:	f44e                	sd	s3,40(sp)
    80005c08:	f052                	sd	s4,32(sp)
    80005c0a:	ec56                	sd	s5,24(sp)
    80005c0c:	e85a                	sd	s6,16(sp)
    80005c0e:	0880                	addi	s0,sp,80
    80005c10:	892e                	mv	s2,a1
    80005c12:	8a2e                	mv	s4,a1
    80005c14:	8ab2                	mv	s5,a2
    80005c16:	8b36                	mv	s6,a3
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
    80005c18:	fb040593          	addi	a1,s0,-80
    80005c1c:	909fe0ef          	jal	80004524 <nameiparent>
    80005c20:	84aa                	mv	s1,a0
    80005c22:	10050763          	beqz	a0,80005d30 <create+0x134>
    return 0;

  ilock(dp);
    80005c26:	8b6fe0ef          	jal	80003cdc <ilock>

  if((ip = dirlookup(dp, name, 0)) != 0){
    80005c2a:	4601                	li	a2,0
    80005c2c:	fb040593          	addi	a1,s0,-80
    80005c30:	8526                	mv	a0,s1
    80005c32:	e44fe0ef          	jal	80004276 <dirlookup>
    80005c36:	89aa                	mv	s3,a0
    80005c38:	c131                	beqz	a0,80005c7c <create+0x80>
    iunlockput(dp);
    80005c3a:	8526                	mv	a0,s1
    80005c3c:	aacfe0ef          	jal	80003ee8 <iunlockput>
    ilock(ip);
    80005c40:	854e                	mv	a0,s3
    80005c42:	89afe0ef          	jal	80003cdc <ilock>
    if(type == T_FILE && (ip->type == T_FILE || ip->type == T_DEVICE))
    80005c46:	4789                	li	a5,2
    80005c48:	02f91563          	bne	s2,a5,80005c72 <create+0x76>
    80005c4c:	0449d783          	lhu	a5,68(s3)
    80005c50:	37f9                	addiw	a5,a5,-2
    80005c52:	17c2                	slli	a5,a5,0x30
    80005c54:	93c1                	srli	a5,a5,0x30
    80005c56:	4705                	li	a4,1
    80005c58:	00f76d63          	bltu	a4,a5,80005c72 <create+0x76>
  ip->nlink = 0;
  iupdate(ip);
  iunlockput(ip);
  iunlockput(dp);
  return 0;
}
    80005c5c:	854e                	mv	a0,s3
    80005c5e:	60a6                	ld	ra,72(sp)
    80005c60:	6406                	ld	s0,64(sp)
    80005c62:	74e2                	ld	s1,56(sp)
    80005c64:	7942                	ld	s2,48(sp)
    80005c66:	79a2                	ld	s3,40(sp)
    80005c68:	7a02                	ld	s4,32(sp)
    80005c6a:	6ae2                	ld	s5,24(sp)
    80005c6c:	6b42                	ld	s6,16(sp)
    80005c6e:	6161                	addi	sp,sp,80
    80005c70:	8082                	ret
    iunlockput(ip);
    80005c72:	854e                	mv	a0,s3
    80005c74:	a74fe0ef          	jal	80003ee8 <iunlockput>
    return 0;
    80005c78:	4981                	li	s3,0
    80005c7a:	b7cd                	j	80005c5c <create+0x60>
  if((ip = ialloc(dp->dev, type)) == 0){
    80005c7c:	85ca                	mv	a1,s2
    80005c7e:	4088                	lw	a0,0(s1)
    80005c80:	eedfd0ef          	jal	80003b6c <ialloc>
    80005c84:	892a                	mv	s2,a0
    80005c86:	cd15                	beqz	a0,80005cc2 <create+0xc6>
  ilock(ip);
    80005c88:	854fe0ef          	jal	80003cdc <ilock>
  ip->major = major;
    80005c8c:	05591323          	sh	s5,70(s2)
  ip->minor = minor;
    80005c90:	05691423          	sh	s6,72(s2)
  ip->nlink = 1;
    80005c94:	4785                	li	a5,1
    80005c96:	04f91523          	sh	a5,74(s2)
  iupdate(ip);
    80005c9a:	854a                	mv	a0,s2
    80005c9c:	f8dfd0ef          	jal	80003c28 <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
    80005ca0:	4705                	li	a4,1
    80005ca2:	02ea0463          	beq	s4,a4,80005cca <create+0xce>
  if(dirlink(dp, name, ip->inum) < 0)
    80005ca6:	00492603          	lw	a2,4(s2)
    80005caa:	fb040593          	addi	a1,s0,-80
    80005cae:	8526                	mv	a0,s1
    80005cb0:	fb0fe0ef          	jal	80004460 <dirlink>
    80005cb4:	06054263          	bltz	a0,80005d18 <create+0x11c>
  iunlockput(dp);
    80005cb8:	8526                	mv	a0,s1
    80005cba:	a2efe0ef          	jal	80003ee8 <iunlockput>
  return ip;
    80005cbe:	89ca                	mv	s3,s2
    80005cc0:	bf71                	j	80005c5c <create+0x60>
    iunlockput(dp);
    80005cc2:	8526                	mv	a0,s1
    80005cc4:	a24fe0ef          	jal	80003ee8 <iunlockput>
    return 0;
    80005cc8:	bf51                	j	80005c5c <create+0x60>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
    80005cca:	00492603          	lw	a2,4(s2)
    80005cce:	00003597          	auipc	a1,0x3
    80005cd2:	c7a58593          	addi	a1,a1,-902 # 80008948 <etext+0x948>
    80005cd6:	854a                	mv	a0,s2
    80005cd8:	f88fe0ef          	jal	80004460 <dirlink>
    80005cdc:	02054e63          	bltz	a0,80005d18 <create+0x11c>
    80005ce0:	40d0                	lw	a2,4(s1)
    80005ce2:	00003597          	auipc	a1,0x3
    80005ce6:	c6e58593          	addi	a1,a1,-914 # 80008950 <etext+0x950>
    80005cea:	854a                	mv	a0,s2
    80005cec:	f74fe0ef          	jal	80004460 <dirlink>
    80005cf0:	02054463          	bltz	a0,80005d18 <create+0x11c>
  if(dirlink(dp, name, ip->inum) < 0)
    80005cf4:	00492603          	lw	a2,4(s2)
    80005cf8:	fb040593          	addi	a1,s0,-80
    80005cfc:	8526                	mv	a0,s1
    80005cfe:	f62fe0ef          	jal	80004460 <dirlink>
    80005d02:	00054b63          	bltz	a0,80005d18 <create+0x11c>
    dp->nlink++;  // for ".."
    80005d06:	04a4d783          	lhu	a5,74(s1)
    80005d0a:	2785                	addiw	a5,a5,1
    80005d0c:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    80005d10:	8526                	mv	a0,s1
    80005d12:	f17fd0ef          	jal	80003c28 <iupdate>
    80005d16:	b74d                	j	80005cb8 <create+0xbc>
  ip->nlink = 0;
    80005d18:	04091523          	sh	zero,74(s2)
  iupdate(ip);
    80005d1c:	854a                	mv	a0,s2
    80005d1e:	f0bfd0ef          	jal	80003c28 <iupdate>
  iunlockput(ip);
    80005d22:	854a                	mv	a0,s2
    80005d24:	9c4fe0ef          	jal	80003ee8 <iunlockput>
  iunlockput(dp);
    80005d28:	8526                	mv	a0,s1
    80005d2a:	9befe0ef          	jal	80003ee8 <iunlockput>
  return 0;
    80005d2e:	b73d                	j	80005c5c <create+0x60>
    return 0;
    80005d30:	89aa                	mv	s3,a0
    80005d32:	b72d                	j	80005c5c <create+0x60>

0000000080005d34 <sys_open>:

uint64
sys_open(void)
{
    80005d34:	7131                	addi	sp,sp,-192
    80005d36:	fd06                	sd	ra,184(sp)
    80005d38:	f922                	sd	s0,176(sp)
    80005d3a:	0180                	addi	s0,sp,192
  int fd, omode;
  struct file *f;
  struct inode *ip;
  int n;

  argint(1, &omode);
    80005d3c:	f4c40593          	addi	a1,s0,-180
    80005d40:	4505                	li	a0,1
    80005d42:	c6efd0ef          	jal	800031b0 <argint>
  if((n = argstr(0, path, MAXPATH)) < 0)
    80005d46:	08000613          	li	a2,128
    80005d4a:	f5040593          	addi	a1,s0,-176
    80005d4e:	4501                	li	a0,0
    80005d50:	c98fd0ef          	jal	800031e8 <argstr>
    80005d54:	87aa                	mv	a5,a0
    return -1;
    80005d56:	557d                	li	a0,-1
  if((n = argstr(0, path, MAXPATH)) < 0)
    80005d58:	0a07c363          	bltz	a5,80005dfe <sys_open+0xca>
    80005d5c:	f526                	sd	s1,168(sp)

  begin_op();
    80005d5e:	98bfe0ef          	jal	800046e8 <begin_op>

  if(omode & O_CREATE){
    80005d62:	f4c42783          	lw	a5,-180(s0)
    80005d66:	2007f793          	andi	a5,a5,512
    80005d6a:	c3dd                	beqz	a5,80005e10 <sys_open+0xdc>
    ip = create(path, T_FILE, 0, 0);
    80005d6c:	4681                	li	a3,0
    80005d6e:	4601                	li	a2,0
    80005d70:	4589                	li	a1,2
    80005d72:	f5040513          	addi	a0,s0,-176
    80005d76:	e87ff0ef          	jal	80005bfc <create>
    80005d7a:	84aa                	mv	s1,a0
    if(ip == 0){
    80005d7c:	c549                	beqz	a0,80005e06 <sys_open+0xd2>
      end_op();
      return -1;
    }
  }

  if(ip->type == T_DEVICE && (ip->major < 0 || ip->major >= NDEV)){
    80005d7e:	04449703          	lh	a4,68(s1)
    80005d82:	478d                	li	a5,3
    80005d84:	00f71763          	bne	a4,a5,80005d92 <sys_open+0x5e>
    80005d88:	0464d703          	lhu	a4,70(s1)
    80005d8c:	47a5                	li	a5,9
    80005d8e:	0ae7ee63          	bltu	a5,a4,80005e4a <sys_open+0x116>
    80005d92:	f14a                	sd	s2,160(sp)
    iunlockput(ip);
    end_op();
    return -1;
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
    80005d94:	cd5fe0ef          	jal	80004a68 <filealloc>
    80005d98:	892a                	mv	s2,a0
    80005d9a:	c561                	beqz	a0,80005e62 <sys_open+0x12e>
    80005d9c:	ed4e                	sd	s3,152(sp)
    80005d9e:	a47ff0ef          	jal	800057e4 <fdalloc>
    80005da2:	89aa                	mv	s3,a0
    80005da4:	0a054b63          	bltz	a0,80005e5a <sys_open+0x126>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if(ip->type == T_DEVICE){
    80005da8:	04449703          	lh	a4,68(s1)
    80005dac:	478d                	li	a5,3
    80005dae:	0cf70363          	beq	a4,a5,80005e74 <sys_open+0x140>
    f->type = FD_DEVICE;
    f->major = ip->major;
  } else {
    f->type = FD_INODE;
    80005db2:	4789                	li	a5,2
    80005db4:	00f92023          	sw	a5,0(s2)
    f->off = 0;
    80005db8:	02092023          	sw	zero,32(s2)
  }
  f->ip = ip;
    80005dbc:	00993c23          	sd	s1,24(s2)
  f->readable = !(omode & O_WRONLY);
    80005dc0:	f4c42783          	lw	a5,-180(s0)
    80005dc4:	0017f713          	andi	a4,a5,1
    80005dc8:	00174713          	xori	a4,a4,1
    80005dcc:	00e90423          	sb	a4,8(s2)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
    80005dd0:	0037f713          	andi	a4,a5,3
    80005dd4:	00e03733          	snez	a4,a4
    80005dd8:	00e904a3          	sb	a4,9(s2)

  if((omode & O_TRUNC) && ip->type == T_FILE){
    80005ddc:	4007f793          	andi	a5,a5,1024
    80005de0:	c791                	beqz	a5,80005dec <sys_open+0xb8>
    80005de2:	04449703          	lh	a4,68(s1)
    80005de6:	4789                	li	a5,2
    80005de8:	08f70d63          	beq	a4,a5,80005e82 <sys_open+0x14e>
    itrunc(ip);
  }

  iunlock(ip);
    80005dec:	8526                	mv	a0,s1
    80005dee:	f9dfd0ef          	jal	80003d8a <iunlock>
  end_op();
    80005df2:	967fe0ef          	jal	80004758 <end_op>

  return fd;
    80005df6:	854e                	mv	a0,s3
    80005df8:	74aa                	ld	s1,168(sp)
    80005dfa:	790a                	ld	s2,160(sp)
    80005dfc:	69ea                	ld	s3,152(sp)
}
    80005dfe:	70ea                	ld	ra,184(sp)
    80005e00:	744a                	ld	s0,176(sp)
    80005e02:	6129                	addi	sp,sp,192
    80005e04:	8082                	ret
      end_op();
    80005e06:	953fe0ef          	jal	80004758 <end_op>
      return -1;
    80005e0a:	557d                	li	a0,-1
    80005e0c:	74aa                	ld	s1,168(sp)
    80005e0e:	bfc5                	j	80005dfe <sys_open+0xca>
    if((ip = namei(path)) == 0){
    80005e10:	f5040513          	addi	a0,s0,-176
    80005e14:	ef6fe0ef          	jal	8000450a <namei>
    80005e18:	84aa                	mv	s1,a0
    80005e1a:	c11d                	beqz	a0,80005e40 <sys_open+0x10c>
    ilock(ip);
    80005e1c:	ec1fd0ef          	jal	80003cdc <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
    80005e20:	04449703          	lh	a4,68(s1)
    80005e24:	4785                	li	a5,1
    80005e26:	f4f71ce3          	bne	a4,a5,80005d7e <sys_open+0x4a>
    80005e2a:	f4c42783          	lw	a5,-180(s0)
    80005e2e:	d3b5                	beqz	a5,80005d92 <sys_open+0x5e>
      iunlockput(ip);
    80005e30:	8526                	mv	a0,s1
    80005e32:	8b6fe0ef          	jal	80003ee8 <iunlockput>
      end_op();
    80005e36:	923fe0ef          	jal	80004758 <end_op>
      return -1;
    80005e3a:	557d                	li	a0,-1
    80005e3c:	74aa                	ld	s1,168(sp)
    80005e3e:	b7c1                	j	80005dfe <sys_open+0xca>
      end_op();
    80005e40:	919fe0ef          	jal	80004758 <end_op>
      return -1;
    80005e44:	557d                	li	a0,-1
    80005e46:	74aa                	ld	s1,168(sp)
    80005e48:	bf5d                	j	80005dfe <sys_open+0xca>
    iunlockput(ip);
    80005e4a:	8526                	mv	a0,s1
    80005e4c:	89cfe0ef          	jal	80003ee8 <iunlockput>
    end_op();
    80005e50:	909fe0ef          	jal	80004758 <end_op>
    return -1;
    80005e54:	557d                	li	a0,-1
    80005e56:	74aa                	ld	s1,168(sp)
    80005e58:	b75d                	j	80005dfe <sys_open+0xca>
      fileclose(f);
    80005e5a:	854a                	mv	a0,s2
    80005e5c:	cb1fe0ef          	jal	80004b0c <fileclose>
    80005e60:	69ea                	ld	s3,152(sp)
    iunlockput(ip);
    80005e62:	8526                	mv	a0,s1
    80005e64:	884fe0ef          	jal	80003ee8 <iunlockput>
    end_op();
    80005e68:	8f1fe0ef          	jal	80004758 <end_op>
    return -1;
    80005e6c:	557d                	li	a0,-1
    80005e6e:	74aa                	ld	s1,168(sp)
    80005e70:	790a                	ld	s2,160(sp)
    80005e72:	b771                	j	80005dfe <sys_open+0xca>
    f->type = FD_DEVICE;
    80005e74:	00e92023          	sw	a4,0(s2)
    f->major = ip->major;
    80005e78:	04649783          	lh	a5,70(s1)
    80005e7c:	02f91223          	sh	a5,36(s2)
    80005e80:	bf35                	j	80005dbc <sys_open+0x88>
    itrunc(ip);
    80005e82:	8526                	mv	a0,s1
    80005e84:	f47fd0ef          	jal	80003dca <itrunc>
    80005e88:	b795                	j	80005dec <sys_open+0xb8>

0000000080005e8a <sys_mkdir>:

uint64
sys_mkdir(void)
{
    80005e8a:	7175                	addi	sp,sp,-144
    80005e8c:	e506                	sd	ra,136(sp)
    80005e8e:	e122                	sd	s0,128(sp)
    80005e90:	0900                	addi	s0,sp,144
  char path[MAXPATH];
  struct inode *ip;

  begin_op();
    80005e92:	857fe0ef          	jal	800046e8 <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
    80005e96:	08000613          	li	a2,128
    80005e9a:	f7040593          	addi	a1,s0,-144
    80005e9e:	4501                	li	a0,0
    80005ea0:	b48fd0ef          	jal	800031e8 <argstr>
    80005ea4:	02054363          	bltz	a0,80005eca <sys_mkdir+0x40>
    80005ea8:	4681                	li	a3,0
    80005eaa:	4601                	li	a2,0
    80005eac:	4585                	li	a1,1
    80005eae:	f7040513          	addi	a0,s0,-144
    80005eb2:	d4bff0ef          	jal	80005bfc <create>
    80005eb6:	c911                	beqz	a0,80005eca <sys_mkdir+0x40>
    end_op();
    return -1;
  }
  iunlockput(ip);
    80005eb8:	830fe0ef          	jal	80003ee8 <iunlockput>
  end_op();
    80005ebc:	89dfe0ef          	jal	80004758 <end_op>
  return 0;
    80005ec0:	4501                	li	a0,0
}
    80005ec2:	60aa                	ld	ra,136(sp)
    80005ec4:	640a                	ld	s0,128(sp)
    80005ec6:	6149                	addi	sp,sp,144
    80005ec8:	8082                	ret
    end_op();
    80005eca:	88ffe0ef          	jal	80004758 <end_op>
    return -1;
    80005ece:	557d                	li	a0,-1
    80005ed0:	bfcd                	j	80005ec2 <sys_mkdir+0x38>

0000000080005ed2 <sys_mknod>:

uint64
sys_mknod(void)
{
    80005ed2:	7135                	addi	sp,sp,-160
    80005ed4:	ed06                	sd	ra,152(sp)
    80005ed6:	e922                	sd	s0,144(sp)
    80005ed8:	1100                	addi	s0,sp,160
  struct inode *ip;
  char path[MAXPATH];
  int major, minor;

  begin_op();
    80005eda:	80ffe0ef          	jal	800046e8 <begin_op>
  argint(1, &major);
    80005ede:	f6c40593          	addi	a1,s0,-148
    80005ee2:	4505                	li	a0,1
    80005ee4:	accfd0ef          	jal	800031b0 <argint>
  argint(2, &minor);
    80005ee8:	f6840593          	addi	a1,s0,-152
    80005eec:	4509                	li	a0,2
    80005eee:	ac2fd0ef          	jal	800031b0 <argint>
  if((argstr(0, path, MAXPATH)) < 0 ||
    80005ef2:	08000613          	li	a2,128
    80005ef6:	f7040593          	addi	a1,s0,-144
    80005efa:	4501                	li	a0,0
    80005efc:	aecfd0ef          	jal	800031e8 <argstr>
    80005f00:	02054563          	bltz	a0,80005f2a <sys_mknod+0x58>
     (ip = create(path, T_DEVICE, major, minor)) == 0){
    80005f04:	f6841683          	lh	a3,-152(s0)
    80005f08:	f6c41603          	lh	a2,-148(s0)
    80005f0c:	458d                	li	a1,3
    80005f0e:	f7040513          	addi	a0,s0,-144
    80005f12:	cebff0ef          	jal	80005bfc <create>
  if((argstr(0, path, MAXPATH)) < 0 ||
    80005f16:	c911                	beqz	a0,80005f2a <sys_mknod+0x58>
    end_op();
    return -1;
  }
  iunlockput(ip);
    80005f18:	fd1fd0ef          	jal	80003ee8 <iunlockput>
  end_op();
    80005f1c:	83dfe0ef          	jal	80004758 <end_op>
  return 0;
    80005f20:	4501                	li	a0,0
}
    80005f22:	60ea                	ld	ra,152(sp)
    80005f24:	644a                	ld	s0,144(sp)
    80005f26:	610d                	addi	sp,sp,160
    80005f28:	8082                	ret
    end_op();
    80005f2a:	82ffe0ef          	jal	80004758 <end_op>
    return -1;
    80005f2e:	557d                	li	a0,-1
    80005f30:	bfcd                	j	80005f22 <sys_mknod+0x50>

0000000080005f32 <sys_chdir>:

uint64
sys_chdir(void)
{
    80005f32:	7135                	addi	sp,sp,-160
    80005f34:	ed06                	sd	ra,152(sp)
    80005f36:	e922                	sd	s0,144(sp)
    80005f38:	e14a                	sd	s2,128(sp)
    80005f3a:	1100                	addi	s0,sp,160
  char path[MAXPATH];
  struct inode *ip;
  struct proc *p = myproc();
    80005f3c:	87cfc0ef          	jal	80001fb8 <myproc>
    80005f40:	892a                	mv	s2,a0
  
  begin_op();
    80005f42:	fa6fe0ef          	jal	800046e8 <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = namei(path)) == 0){
    80005f46:	08000613          	li	a2,128
    80005f4a:	f6040593          	addi	a1,s0,-160
    80005f4e:	4501                	li	a0,0
    80005f50:	a98fd0ef          	jal	800031e8 <argstr>
    80005f54:	04054363          	bltz	a0,80005f9a <sys_chdir+0x68>
    80005f58:	e526                	sd	s1,136(sp)
    80005f5a:	f6040513          	addi	a0,s0,-160
    80005f5e:	dacfe0ef          	jal	8000450a <namei>
    80005f62:	84aa                	mv	s1,a0
    80005f64:	c915                	beqz	a0,80005f98 <sys_chdir+0x66>
    end_op();
    return -1;
  }
  ilock(ip);
    80005f66:	d77fd0ef          	jal	80003cdc <ilock>
  if(ip->type != T_DIR){
    80005f6a:	04449703          	lh	a4,68(s1)
    80005f6e:	4785                	li	a5,1
    80005f70:	02f71963          	bne	a4,a5,80005fa2 <sys_chdir+0x70>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
    80005f74:	8526                	mv	a0,s1
    80005f76:	e15fd0ef          	jal	80003d8a <iunlock>
  iput(p->cwd);
    80005f7a:	15093503          	ld	a0,336(s2)
    80005f7e:	ee1fd0ef          	jal	80003e5e <iput>
  end_op();
    80005f82:	fd6fe0ef          	jal	80004758 <end_op>
  p->cwd = ip;
    80005f86:	14993823          	sd	s1,336(s2)
  return 0;
    80005f8a:	4501                	li	a0,0
    80005f8c:	64aa                	ld	s1,136(sp)
}
    80005f8e:	60ea                	ld	ra,152(sp)
    80005f90:	644a                	ld	s0,144(sp)
    80005f92:	690a                	ld	s2,128(sp)
    80005f94:	610d                	addi	sp,sp,160
    80005f96:	8082                	ret
    80005f98:	64aa                	ld	s1,136(sp)
    end_op();
    80005f9a:	fbefe0ef          	jal	80004758 <end_op>
    return -1;
    80005f9e:	557d                	li	a0,-1
    80005fa0:	b7fd                	j	80005f8e <sys_chdir+0x5c>
    iunlockput(ip);
    80005fa2:	8526                	mv	a0,s1
    80005fa4:	f45fd0ef          	jal	80003ee8 <iunlockput>
    end_op();
    80005fa8:	fb0fe0ef          	jal	80004758 <end_op>
    return -1;
    80005fac:	557d                	li	a0,-1
    80005fae:	64aa                	ld	s1,136(sp)
    80005fb0:	bff9                	j	80005f8e <sys_chdir+0x5c>

0000000080005fb2 <sys_exec>:

uint64
sys_exec(void)
{
    80005fb2:	7105                	addi	sp,sp,-480
    80005fb4:	ef86                	sd	ra,472(sp)
    80005fb6:	eba2                	sd	s0,464(sp)
    80005fb8:	1380                	addi	s0,sp,480
  char path[MAXPATH], *argv[MAXARG];
  int i;
  uint64 uargv, uarg;

  argaddr(1, &uargv);
    80005fba:	e2840593          	addi	a1,s0,-472
    80005fbe:	4505                	li	a0,1
    80005fc0:	a0cfd0ef          	jal	800031cc <argaddr>
  if(argstr(0, path, MAXPATH) < 0) {
    80005fc4:	08000613          	li	a2,128
    80005fc8:	f3040593          	addi	a1,s0,-208
    80005fcc:	4501                	li	a0,0
    80005fce:	a1afd0ef          	jal	800031e8 <argstr>
    80005fd2:	87aa                	mv	a5,a0
    return -1;
    80005fd4:	557d                	li	a0,-1
  if(argstr(0, path, MAXPATH) < 0) {
    80005fd6:	0e07c063          	bltz	a5,800060b6 <sys_exec+0x104>
    80005fda:	e7a6                	sd	s1,456(sp)
    80005fdc:	e3ca                	sd	s2,448(sp)
    80005fde:	ff4e                	sd	s3,440(sp)
    80005fe0:	fb52                	sd	s4,432(sp)
    80005fe2:	f756                	sd	s5,424(sp)
    80005fe4:	f35a                	sd	s6,416(sp)
    80005fe6:	ef5e                	sd	s7,408(sp)
  }
  memset(argv, 0, sizeof(argv));
    80005fe8:	e3040a13          	addi	s4,s0,-464
    80005fec:	10000613          	li	a2,256
    80005ff0:	4581                	li	a1,0
    80005ff2:	8552                	mv	a0,s4
    80005ff4:	d05fa0ef          	jal	80000cf8 <memset>
  for(i=0;; i++){
    if(i >= NELEM(argv)){
    80005ff8:	84d2                	mv	s1,s4
  memset(argv, 0, sizeof(argv));
    80005ffa:	89d2                	mv	s3,s4
    80005ffc:	4901                	li	s2,0
      goto bad;
    }
    if(fetchaddr(uargv+sizeof(uint64)*i, (uint64*)&uarg) < 0){
    80005ffe:	e2040a93          	addi	s5,s0,-480
      break;
    }
    argv[i] = kalloc();
    if(argv[i] == 0)
      goto bad;
    if(fetchstr(uarg, argv[i], PGSIZE) < 0)
    80006002:	6b05                	lui	s6,0x1
    if(i >= NELEM(argv)){
    80006004:	02000b93          	li	s7,32
    if(fetchaddr(uargv+sizeof(uint64)*i, (uint64*)&uarg) < 0){
    80006008:	00391513          	slli	a0,s2,0x3
    8000600c:	85d6                	mv	a1,s5
    8000600e:	e2843783          	ld	a5,-472(s0)
    80006012:	953e                	add	a0,a0,a5
    80006014:	912fd0ef          	jal	80003126 <fetchaddr>
    80006018:	02054663          	bltz	a0,80006044 <sys_exec+0x92>
    if(uarg == 0){
    8000601c:	e2043783          	ld	a5,-480(s0)
    80006020:	c7a1                	beqz	a5,80006068 <sys_exec+0xb6>
    argv[i] = kalloc();
    80006022:	b23fa0ef          	jal	80000b44 <kalloc>
    80006026:	85aa                	mv	a1,a0
    80006028:	00a9b023          	sd	a0,0(s3)
    if(argv[i] == 0)
    8000602c:	cd01                	beqz	a0,80006044 <sys_exec+0x92>
    if(fetchstr(uarg, argv[i], PGSIZE) < 0)
    8000602e:	865a                	mv	a2,s6
    80006030:	e2043503          	ld	a0,-480(s0)
    80006034:	93cfd0ef          	jal	80003170 <fetchstr>
    80006038:	00054663          	bltz	a0,80006044 <sys_exec+0x92>
    if(i >= NELEM(argv)){
    8000603c:	0905                	addi	s2,s2,1
    8000603e:	09a1                	addi	s3,s3,8
    80006040:	fd7914e3          	bne	s2,s7,80006008 <sys_exec+0x56>
    kfree(argv[i]);

  return ret;

 bad:
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80006044:	100a0a13          	addi	s4,s4,256
    80006048:	6088                	ld	a0,0(s1)
    8000604a:	cd31                	beqz	a0,800060a6 <sys_exec+0xf4>
    kfree(argv[i]);
    8000604c:	a11fa0ef          	jal	80000a5c <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80006050:	04a1                	addi	s1,s1,8
    80006052:	ff449be3          	bne	s1,s4,80006048 <sys_exec+0x96>
  return -1;
    80006056:	557d                	li	a0,-1
    80006058:	64be                	ld	s1,456(sp)
    8000605a:	691e                	ld	s2,448(sp)
    8000605c:	79fa                	ld	s3,440(sp)
    8000605e:	7a5a                	ld	s4,432(sp)
    80006060:	7aba                	ld	s5,424(sp)
    80006062:	7b1a                	ld	s6,416(sp)
    80006064:	6bfa                	ld	s7,408(sp)
    80006066:	a881                	j	800060b6 <sys_exec+0x104>
      argv[i] = 0;
    80006068:	0009079b          	sext.w	a5,s2
    8000606c:	e3040593          	addi	a1,s0,-464
    80006070:	078e                	slli	a5,a5,0x3
    80006072:	97ae                	add	a5,a5,a1
    80006074:	0007b023          	sd	zero,0(a5)
  int ret = kexec(path, argv);
    80006078:	f3040513          	addi	a0,s0,-208
    8000607c:	a64ff0ef          	jal	800052e0 <kexec>
    80006080:	892a                	mv	s2,a0
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80006082:	100a0a13          	addi	s4,s4,256
    80006086:	6088                	ld	a0,0(s1)
    80006088:	c511                	beqz	a0,80006094 <sys_exec+0xe2>
    kfree(argv[i]);
    8000608a:	9d3fa0ef          	jal	80000a5c <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    8000608e:	04a1                	addi	s1,s1,8
    80006090:	ff449be3          	bne	s1,s4,80006086 <sys_exec+0xd4>
  return ret;
    80006094:	854a                	mv	a0,s2
    80006096:	64be                	ld	s1,456(sp)
    80006098:	691e                	ld	s2,448(sp)
    8000609a:	79fa                	ld	s3,440(sp)
    8000609c:	7a5a                	ld	s4,432(sp)
    8000609e:	7aba                	ld	s5,424(sp)
    800060a0:	7b1a                	ld	s6,416(sp)
    800060a2:	6bfa                	ld	s7,408(sp)
    800060a4:	a809                	j	800060b6 <sys_exec+0x104>
  return -1;
    800060a6:	557d                	li	a0,-1
    800060a8:	64be                	ld	s1,456(sp)
    800060aa:	691e                	ld	s2,448(sp)
    800060ac:	79fa                	ld	s3,440(sp)
    800060ae:	7a5a                	ld	s4,432(sp)
    800060b0:	7aba                	ld	s5,424(sp)
    800060b2:	7b1a                	ld	s6,416(sp)
    800060b4:	6bfa                	ld	s7,408(sp)
}
    800060b6:	60fe                	ld	ra,472(sp)
    800060b8:	645e                	ld	s0,464(sp)
    800060ba:	613d                	addi	sp,sp,480
    800060bc:	8082                	ret

00000000800060be <sys_pipe>:

uint64
sys_pipe(void)
{
    800060be:	7139                	addi	sp,sp,-64
    800060c0:	fc06                	sd	ra,56(sp)
    800060c2:	f822                	sd	s0,48(sp)
    800060c4:	f426                	sd	s1,40(sp)
    800060c6:	0080                	addi	s0,sp,64
  uint64 fdarray; // user pointer to array of two integers
  struct file *rf, *wf;
  int fd0, fd1;
  struct proc *p = myproc();
    800060c8:	ef1fb0ef          	jal	80001fb8 <myproc>
    800060cc:	84aa                	mv	s1,a0

  argaddr(0, &fdarray);
    800060ce:	fd840593          	addi	a1,s0,-40
    800060d2:	4501                	li	a0,0
    800060d4:	8f8fd0ef          	jal	800031cc <argaddr>
  if(pipealloc(&rf, &wf) < 0){
    800060d8:	fc840593          	addi	a1,s0,-56
    800060dc:	fd040513          	addi	a0,s0,-48
    800060e0:	d49fe0ef          	jal	80004e28 <pipealloc>
    800060e4:	08054c63          	bltz	a0,8000617c <sys_pipe+0xbe>
      printf("pipealloc failed\n");
      return -1;
  }
  fd0 = -1;
    800060e8:	57fd                	li	a5,-1
    800060ea:	fcf42223          	sw	a5,-60(s0)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
    800060ee:	fd043503          	ld	a0,-48(s0)
    800060f2:	ef2ff0ef          	jal	800057e4 <fdalloc>
    800060f6:	fca42223          	sw	a0,-60(s0)
    800060fa:	0a054363          	bltz	a0,800061a0 <sys_pipe+0xe2>
    800060fe:	fc843503          	ld	a0,-56(s0)
    80006102:	ee2ff0ef          	jal	800057e4 <fdalloc>
    80006106:	fca42023          	sw	a0,-64(s0)
    8000610a:	08054163          	bltz	a0,8000618c <sys_pipe+0xce>
    fileclose(rf);
    fileclose(wf);
    printf("Fd alloc failed\n");
    return -1;
  }
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    8000610e:	4691                	li	a3,4
    80006110:	fc440613          	addi	a2,s0,-60
    80006114:	fd843583          	ld	a1,-40(s0)
    80006118:	68a8                	ld	a0,80(s1)
    8000611a:	96ffb0ef          	jal	80001a88 <copyout>
    8000611e:	00054f63          	bltz	a0,8000613c <sys_pipe+0x7e>
     copyout(p->pagetable, fdarray+sizeof(fd0), (char *)&fd1, sizeof(fd1)) < 0){
    80006122:	4691                	li	a3,4
    80006124:	fc040613          	addi	a2,s0,-64
    80006128:	fd843583          	ld	a1,-40(s0)
    8000612c:	95b6                	add	a1,a1,a3
    8000612e:	68a8                	ld	a0,80(s1)
    80006130:	959fb0ef          	jal	80001a88 <copyout>
    80006134:	87aa                	mv	a5,a0
    fileclose(rf);
    fileclose(wf);
    printf("copyout failed\n");
    return -1;
  }
  return 0;
    80006136:	4501                	li	a0,0
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    80006138:	0807d363          	bgez	a5,800061be <sys_pipe+0x100>
    p->ofile[fd0] = 0;
    8000613c:	fc442783          	lw	a5,-60(s0)
    80006140:	078e                	slli	a5,a5,0x3
    80006142:	0d078793          	addi	a5,a5,208
    80006146:	97a6                	add	a5,a5,s1
    80006148:	0007b023          	sd	zero,0(a5)
    p->ofile[fd1] = 0;
    8000614c:	fc042783          	lw	a5,-64(s0)
    80006150:	078e                	slli	a5,a5,0x3
    80006152:	0d078793          	addi	a5,a5,208
    80006156:	97a6                	add	a5,a5,s1
    80006158:	0007b023          	sd	zero,0(a5)
    fileclose(rf);
    8000615c:	fd043503          	ld	a0,-48(s0)
    80006160:	9adfe0ef          	jal	80004b0c <fileclose>
    fileclose(wf);
    80006164:	fc843503          	ld	a0,-56(s0)
    80006168:	9a5fe0ef          	jal	80004b0c <fileclose>
    printf("copyout failed\n");
    8000616c:	00003517          	auipc	a0,0x3
    80006170:	85c50513          	addi	a0,a0,-1956 # 800089c8 <etext+0x9c8>
    80006174:	b86fa0ef          	jal	800004fa <printf>
    return -1;
    80006178:	557d                	li	a0,-1
    8000617a:	a091                	j	800061be <sys_pipe+0x100>
      printf("pipealloc failed\n");
    8000617c:	00003517          	auipc	a0,0x3
    80006180:	81c50513          	addi	a0,a0,-2020 # 80008998 <etext+0x998>
    80006184:	b76fa0ef          	jal	800004fa <printf>
      return -1;
    80006188:	557d                	li	a0,-1
    8000618a:	a815                	j	800061be <sys_pipe+0x100>
    if(fd0 >= 0)
    8000618c:	fc442783          	lw	a5,-60(s0)
    80006190:	0007c863          	bltz	a5,800061a0 <sys_pipe+0xe2>
      p->ofile[fd0] = 0;
    80006194:	078e                	slli	a5,a5,0x3
    80006196:	0d078793          	addi	a5,a5,208
    8000619a:	97a6                	add	a5,a5,s1
    8000619c:	0007b023          	sd	zero,0(a5)
    fileclose(rf);
    800061a0:	fd043503          	ld	a0,-48(s0)
    800061a4:	969fe0ef          	jal	80004b0c <fileclose>
    fileclose(wf);
    800061a8:	fc843503          	ld	a0,-56(s0)
    800061ac:	961fe0ef          	jal	80004b0c <fileclose>
    printf("Fd alloc failed\n");
    800061b0:	00003517          	auipc	a0,0x3
    800061b4:	80050513          	addi	a0,a0,-2048 # 800089b0 <etext+0x9b0>
    800061b8:	b42fa0ef          	jal	800004fa <printf>
    return -1;
    800061bc:	557d                	li	a0,-1
}
    800061be:	70e2                	ld	ra,56(sp)
    800061c0:	7442                	ld	s0,48(sp)
    800061c2:	74a2                	ld	s1,40(sp)
    800061c4:	6121                	addi	sp,sp,64
    800061c6:	8082                	ret
	...

00000000800061d0 <kernelvec>:
.globl kerneltrap
.globl kernelvec
.align 4
kernelvec:
        # make room to save registers.
        addi sp, sp, -256
    800061d0:	7111                	addi	sp,sp,-256

        # save caller-saved registers.
        sd ra, 0(sp)
    800061d2:	e006                	sd	ra,0(sp)
        # sd sp, 8(sp)
        sd gp, 16(sp)
    800061d4:	e80e                	sd	gp,16(sp)
        sd tp, 24(sp)
    800061d6:	ec12                	sd	tp,24(sp)
        sd t0, 32(sp)
    800061d8:	f016                	sd	t0,32(sp)
        sd t1, 40(sp)
    800061da:	f41a                	sd	t1,40(sp)
        sd t2, 48(sp)
    800061dc:	f81e                	sd	t2,48(sp)
        sd a0, 72(sp)
    800061de:	e4aa                	sd	a0,72(sp)
        sd a1, 80(sp)
    800061e0:	e8ae                	sd	a1,80(sp)
        sd a2, 88(sp)
    800061e2:	ecb2                	sd	a2,88(sp)
        sd a3, 96(sp)
    800061e4:	f0b6                	sd	a3,96(sp)
        sd a4, 104(sp)
    800061e6:	f4ba                	sd	a4,104(sp)
        sd a5, 112(sp)
    800061e8:	f8be                	sd	a5,112(sp)
        sd a6, 120(sp)
    800061ea:	fcc2                	sd	a6,120(sp)
        sd a7, 128(sp)
    800061ec:	e146                	sd	a7,128(sp)
        sd t3, 216(sp)
    800061ee:	edf2                	sd	t3,216(sp)
        sd t4, 224(sp)
    800061f0:	f1f6                	sd	t4,224(sp)
        sd t5, 232(sp)
    800061f2:	f5fa                	sd	t5,232(sp)
        sd t6, 240(sp)
    800061f4:	f9fe                	sd	t6,240(sp)

        # call the C trap handler in trap.c
        call kerneltrap
    800061f6:	e3ffc0ef          	jal	80003034 <kerneltrap>

        # restore registers.
        ld ra, 0(sp)
    800061fa:	6082                	ld	ra,0(sp)
        # ld sp, 8(sp)
        ld gp, 16(sp)
    800061fc:	61c2                	ld	gp,16(sp)
        # not tp (contains hartid), in case we moved CPUs
        ld t0, 32(sp)
    800061fe:	7282                	ld	t0,32(sp)
        ld t1, 40(sp)
    80006200:	7322                	ld	t1,40(sp)
        ld t2, 48(sp)
    80006202:	73c2                	ld	t2,48(sp)
        ld a0, 72(sp)
    80006204:	6526                	ld	a0,72(sp)
        ld a1, 80(sp)
    80006206:	65c6                	ld	a1,80(sp)
        ld a2, 88(sp)
    80006208:	6666                	ld	a2,88(sp)
        ld a3, 96(sp)
    8000620a:	7686                	ld	a3,96(sp)
        ld a4, 104(sp)
    8000620c:	7726                	ld	a4,104(sp)
        ld a5, 112(sp)
    8000620e:	77c6                	ld	a5,112(sp)
        ld a6, 120(sp)
    80006210:	7866                	ld	a6,120(sp)
        ld a7, 128(sp)
    80006212:	688a                	ld	a7,128(sp)
        ld t3, 216(sp)
    80006214:	6e6e                	ld	t3,216(sp)
        ld t4, 224(sp)
    80006216:	7e8e                	ld	t4,224(sp)
        ld t5, 232(sp)
    80006218:	7f2e                	ld	t5,232(sp)
        ld t6, 240(sp)
    8000621a:	7fce                	ld	t6,240(sp)

        addi sp, sp, 256
    8000621c:	6111                	addi	sp,sp,256

        # return to whatever we were doing in the kernel.
        sret
    8000621e:	10200073          	sret
    80006222:	00000013          	nop
    80006226:	00000013          	nop
    8000622a:	00000013          	nop

000000008000622e <plicinit>:
// the riscv Platform Level Interrupt Controller (PLIC).
//

void
plicinit(void)
{
    8000622e:	1141                	addi	sp,sp,-16
    80006230:	e406                	sd	ra,8(sp)
    80006232:	e022                	sd	s0,0(sp)
    80006234:	0800                	addi	s0,sp,16
  // set desired IRQ priorities non-zero (otherwise disabled).
  *(uint32*)(PLIC + UART0_IRQ*4) = 1;
    80006236:	0c000737          	lui	a4,0xc000
    8000623a:	4785                	li	a5,1
    8000623c:	d71c                	sw	a5,40(a4)
  *(uint32*)(PLIC + VIRTIO0_IRQ*4) = 1;
    8000623e:	c35c                	sw	a5,4(a4)
}
    80006240:	60a2                	ld	ra,8(sp)
    80006242:	6402                	ld	s0,0(sp)
    80006244:	0141                	addi	sp,sp,16
    80006246:	8082                	ret

0000000080006248 <plicinithart>:

void
plicinithart(void)
{
    80006248:	1141                	addi	sp,sp,-16
    8000624a:	e406                	sd	ra,8(sp)
    8000624c:	e022                	sd	s0,0(sp)
    8000624e:	0800                	addi	s0,sp,16
  int hart = cpuid();
    80006250:	d35fb0ef          	jal	80001f84 <cpuid>
  
  // set enable bits for this hart's S-mode
  // for the uart and virtio disk.
  *(uint32*)PLIC_SENABLE(hart) = (1 << UART0_IRQ) | (1 << VIRTIO0_IRQ);
    80006254:	0085171b          	slliw	a4,a0,0x8
    80006258:	0c0027b7          	lui	a5,0xc002
    8000625c:	97ba                	add	a5,a5,a4
    8000625e:	40200713          	li	a4,1026
    80006262:	08e7a023          	sw	a4,128(a5) # c002080 <_entry-0x73ffdf80>

  // set this hart's S-mode priority threshold to 0.
  *(uint32*)PLIC_SPRIORITY(hart) = 0;
    80006266:	00d5151b          	slliw	a0,a0,0xd
    8000626a:	0c2017b7          	lui	a5,0xc201
    8000626e:	97aa                	add	a5,a5,a0
    80006270:	0007a023          	sw	zero,0(a5) # c201000 <_entry-0x73dff000>
}
    80006274:	60a2                	ld	ra,8(sp)
    80006276:	6402                	ld	s0,0(sp)
    80006278:	0141                	addi	sp,sp,16
    8000627a:	8082                	ret

000000008000627c <plic_claim>:

// ask the PLIC what interrupt we should serve.
int
plic_claim(void)
{
    8000627c:	1141                	addi	sp,sp,-16
    8000627e:	e406                	sd	ra,8(sp)
    80006280:	e022                	sd	s0,0(sp)
    80006282:	0800                	addi	s0,sp,16
  int hart = cpuid();
    80006284:	d01fb0ef          	jal	80001f84 <cpuid>
  int irq = *(uint32*)PLIC_SCLAIM(hart);
    80006288:	00d5151b          	slliw	a0,a0,0xd
    8000628c:	0c2017b7          	lui	a5,0xc201
    80006290:	97aa                	add	a5,a5,a0
  return irq;
}
    80006292:	43c8                	lw	a0,4(a5)
    80006294:	60a2                	ld	ra,8(sp)
    80006296:	6402                	ld	s0,0(sp)
    80006298:	0141                	addi	sp,sp,16
    8000629a:	8082                	ret

000000008000629c <plic_complete>:

// tell the PLIC we've served this IRQ.
void
plic_complete(int irq)
{
    8000629c:	1101                	addi	sp,sp,-32
    8000629e:	ec06                	sd	ra,24(sp)
    800062a0:	e822                	sd	s0,16(sp)
    800062a2:	e426                	sd	s1,8(sp)
    800062a4:	1000                	addi	s0,sp,32
    800062a6:	84aa                	mv	s1,a0
  int hart = cpuid();
    800062a8:	cddfb0ef          	jal	80001f84 <cpuid>
  *(uint32*)PLIC_SCLAIM(hart) = irq;
    800062ac:	00d5179b          	slliw	a5,a0,0xd
    800062b0:	0c201737          	lui	a4,0xc201
    800062b4:	97ba                	add	a5,a5,a4
    800062b6:	c3c4                	sw	s1,4(a5)
}
    800062b8:	60e2                	ld	ra,24(sp)
    800062ba:	6442                	ld	s0,16(sp)
    800062bc:	64a2                	ld	s1,8(sp)
    800062be:	6105                	addi	sp,sp,32
    800062c0:	8082                	ret

00000000800062c2 <free_desc>:
}

// mark a descriptor as free.
static void
free_desc(int i)
{
    800062c2:	1141                	addi	sp,sp,-16
    800062c4:	e406                	sd	ra,8(sp)
    800062c6:	e022                	sd	s0,0(sp)
    800062c8:	0800                	addi	s0,sp,16
  if(i >= NUM)
    800062ca:	479d                	li	a5,7
    800062cc:	04a7ca63          	blt	a5,a0,80006320 <free_desc+0x5e>
    panic("free_desc 1");
  if(disk.free[i])
    800062d0:	0226f797          	auipc	a5,0x226f
    800062d4:	99878793          	addi	a5,a5,-1640 # 82274c68 <disk>
    800062d8:	97aa                	add	a5,a5,a0
    800062da:	0187c783          	lbu	a5,24(a5)
    800062de:	e7b9                	bnez	a5,8000632c <free_desc+0x6a>
    panic("free_desc 2");
  disk.desc[i].addr = 0;
    800062e0:	00451693          	slli	a3,a0,0x4
    800062e4:	0226f797          	auipc	a5,0x226f
    800062e8:	98478793          	addi	a5,a5,-1660 # 82274c68 <disk>
    800062ec:	6398                	ld	a4,0(a5)
    800062ee:	9736                	add	a4,a4,a3
    800062f0:	00073023          	sd	zero,0(a4) # c201000 <_entry-0x73dff000>
  disk.desc[i].len = 0;
    800062f4:	6398                	ld	a4,0(a5)
    800062f6:	9736                	add	a4,a4,a3
    800062f8:	00072423          	sw	zero,8(a4)
  disk.desc[i].flags = 0;
    800062fc:	00071623          	sh	zero,12(a4)
  disk.desc[i].next = 0;
    80006300:	00071723          	sh	zero,14(a4)
  disk.free[i] = 1;
    80006304:	97aa                	add	a5,a5,a0
    80006306:	4705                	li	a4,1
    80006308:	00e78c23          	sb	a4,24(a5)
  wakeup(&disk.free[0]);
    8000630c:	0226f517          	auipc	a0,0x226f
    80006310:	97450513          	addi	a0,a0,-1676 # 82274c80 <disk+0x18>
    80006314:	c12fc0ef          	jal	80002726 <wakeup>
}
    80006318:	60a2                	ld	ra,8(sp)
    8000631a:	6402                	ld	s0,0(sp)
    8000631c:	0141                	addi	sp,sp,16
    8000631e:	8082                	ret
    panic("free_desc 1");
    80006320:	00002517          	auipc	a0,0x2
    80006324:	6b850513          	addi	a0,a0,1720 # 800089d8 <etext+0x9d8>
    80006328:	cfcfa0ef          	jal	80000824 <panic>
    panic("free_desc 2");
    8000632c:	00002517          	auipc	a0,0x2
    80006330:	6bc50513          	addi	a0,a0,1724 # 800089e8 <etext+0x9e8>
    80006334:	cf0fa0ef          	jal	80000824 <panic>

0000000080006338 <virtio_disk_init>:
{
    80006338:	1101                	addi	sp,sp,-32
    8000633a:	ec06                	sd	ra,24(sp)
    8000633c:	e822                	sd	s0,16(sp)
    8000633e:	e426                	sd	s1,8(sp)
    80006340:	e04a                	sd	s2,0(sp)
    80006342:	1000                	addi	s0,sp,32
  initlock(&disk.vdisk_lock, "virtio_disk");
    80006344:	00002597          	auipc	a1,0x2
    80006348:	6b458593          	addi	a1,a1,1716 # 800089f8 <etext+0x9f8>
    8000634c:	0226f517          	auipc	a0,0x226f
    80006350:	a4450513          	addi	a0,a0,-1468 # 82274d90 <disk+0x128>
    80006354:	84bfa0ef          	jal	80000b9e <initlock>
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    80006358:	100017b7          	lui	a5,0x10001
    8000635c:	4398                	lw	a4,0(a5)
    8000635e:	2701                	sext.w	a4,a4
    80006360:	747277b7          	lui	a5,0x74727
    80006364:	97678793          	addi	a5,a5,-1674 # 74726976 <_entry-0xb8d968a>
    80006368:	14f71863          	bne	a4,a5,800064b8 <virtio_disk_init+0x180>
     *R(VIRTIO_MMIO_VERSION) != 2 ||
    8000636c:	100017b7          	lui	a5,0x10001
    80006370:	43dc                	lw	a5,4(a5)
    80006372:	2781                	sext.w	a5,a5
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    80006374:	4709                	li	a4,2
    80006376:	14e79163          	bne	a5,a4,800064b8 <virtio_disk_init+0x180>
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    8000637a:	100017b7          	lui	a5,0x10001
    8000637e:	479c                	lw	a5,8(a5)
    80006380:	2781                	sext.w	a5,a5
     *R(VIRTIO_MMIO_VERSION) != 2 ||
    80006382:	12e79b63          	bne	a5,a4,800064b8 <virtio_disk_init+0x180>
     *R(VIRTIO_MMIO_VENDOR_ID) != 0x554d4551){
    80006386:	100017b7          	lui	a5,0x10001
    8000638a:	47d8                	lw	a4,12(a5)
    8000638c:	2701                	sext.w	a4,a4
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    8000638e:	554d47b7          	lui	a5,0x554d4
    80006392:	55178793          	addi	a5,a5,1361 # 554d4551 <_entry-0x2ab2baaf>
    80006396:	12f71163          	bne	a4,a5,800064b8 <virtio_disk_init+0x180>
  *R(VIRTIO_MMIO_STATUS) = status;
    8000639a:	100017b7          	lui	a5,0x10001
    8000639e:	0607a823          	sw	zero,112(a5) # 10001070 <_entry-0x6fffef90>
  *R(VIRTIO_MMIO_STATUS) = status;
    800063a2:	4705                	li	a4,1
    800063a4:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    800063a6:	470d                	li	a4,3
    800063a8:	dbb8                	sw	a4,112(a5)
  uint64 features = *R(VIRTIO_MMIO_DEVICE_FEATURES);
    800063aa:	10001737          	lui	a4,0x10001
    800063ae:	4b18                	lw	a4,16(a4)
  features &= ~(1 << VIRTIO_RING_F_INDIRECT_DESC);
    800063b0:	c7ffe6b7          	lui	a3,0xc7ffe
    800063b4:	75f68693          	addi	a3,a3,1887 # ffffffffc7ffe75f <end+0xffffffff45d899b7>
  *R(VIRTIO_MMIO_DRIVER_FEATURES) = features;
    800063b8:	8f75                	and	a4,a4,a3
    800063ba:	100016b7          	lui	a3,0x10001
    800063be:	d298                	sw	a4,32(a3)
  *R(VIRTIO_MMIO_STATUS) = status;
    800063c0:	472d                	li	a4,11
    800063c2:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    800063c4:	07078793          	addi	a5,a5,112
  status = *R(VIRTIO_MMIO_STATUS);
    800063c8:	439c                	lw	a5,0(a5)
    800063ca:	0007891b          	sext.w	s2,a5
  if(!(status & VIRTIO_CONFIG_S_FEATURES_OK))
    800063ce:	8ba1                	andi	a5,a5,8
    800063d0:	0e078a63          	beqz	a5,800064c4 <virtio_disk_init+0x18c>
  *R(VIRTIO_MMIO_QUEUE_SEL) = 0;
    800063d4:	100017b7          	lui	a5,0x10001
    800063d8:	0207a823          	sw	zero,48(a5) # 10001030 <_entry-0x6fffefd0>
  if(*R(VIRTIO_MMIO_QUEUE_READY))
    800063dc:	43fc                	lw	a5,68(a5)
    800063de:	2781                	sext.w	a5,a5
    800063e0:	0e079863          	bnez	a5,800064d0 <virtio_disk_init+0x198>
  uint32 max = *R(VIRTIO_MMIO_QUEUE_NUM_MAX);
    800063e4:	100017b7          	lui	a5,0x10001
    800063e8:	5bdc                	lw	a5,52(a5)
    800063ea:	2781                	sext.w	a5,a5
  if(max == 0)
    800063ec:	0e078863          	beqz	a5,800064dc <virtio_disk_init+0x1a4>
  if(max < NUM)
    800063f0:	471d                	li	a4,7
    800063f2:	0ef77b63          	bgeu	a4,a5,800064e8 <virtio_disk_init+0x1b0>
  disk.desc = kalloc();
    800063f6:	f4efa0ef          	jal	80000b44 <kalloc>
    800063fa:	0226f497          	auipc	s1,0x226f
    800063fe:	86e48493          	addi	s1,s1,-1938 # 82274c68 <disk>
    80006402:	e088                	sd	a0,0(s1)
  disk.avail = kalloc();
    80006404:	f40fa0ef          	jal	80000b44 <kalloc>
    80006408:	e488                	sd	a0,8(s1)
  disk.used = kalloc();
    8000640a:	f3afa0ef          	jal	80000b44 <kalloc>
    8000640e:	87aa                	mv	a5,a0
    80006410:	e888                	sd	a0,16(s1)
  if(!disk.desc || !disk.avail || !disk.used)
    80006412:	6088                	ld	a0,0(s1)
    80006414:	0e050063          	beqz	a0,800064f4 <virtio_disk_init+0x1bc>
    80006418:	0226f717          	auipc	a4,0x226f
    8000641c:	85873703          	ld	a4,-1960(a4) # 82274c70 <disk+0x8>
    80006420:	cb71                	beqz	a4,800064f4 <virtio_disk_init+0x1bc>
    80006422:	cbe9                	beqz	a5,800064f4 <virtio_disk_init+0x1bc>
  memset(disk.desc, 0, PGSIZE);
    80006424:	6605                	lui	a2,0x1
    80006426:	4581                	li	a1,0
    80006428:	8d1fa0ef          	jal	80000cf8 <memset>
  memset(disk.avail, 0, PGSIZE);
    8000642c:	0226f497          	auipc	s1,0x226f
    80006430:	83c48493          	addi	s1,s1,-1988 # 82274c68 <disk>
    80006434:	6605                	lui	a2,0x1
    80006436:	4581                	li	a1,0
    80006438:	6488                	ld	a0,8(s1)
    8000643a:	8bffa0ef          	jal	80000cf8 <memset>
  memset(disk.used, 0, PGSIZE);
    8000643e:	6605                	lui	a2,0x1
    80006440:	4581                	li	a1,0
    80006442:	6888                	ld	a0,16(s1)
    80006444:	8b5fa0ef          	jal	80000cf8 <memset>
  *R(VIRTIO_MMIO_QUEUE_NUM) = NUM;
    80006448:	100017b7          	lui	a5,0x10001
    8000644c:	4721                	li	a4,8
    8000644e:	df98                	sw	a4,56(a5)
  *R(VIRTIO_MMIO_QUEUE_DESC_LOW) = (uint64)disk.desc;
    80006450:	4098                	lw	a4,0(s1)
    80006452:	08e7a023          	sw	a4,128(a5) # 10001080 <_entry-0x6fffef80>
  *R(VIRTIO_MMIO_QUEUE_DESC_HIGH) = (uint64)disk.desc >> 32;
    80006456:	40d8                	lw	a4,4(s1)
    80006458:	08e7a223          	sw	a4,132(a5)
  *R(VIRTIO_MMIO_DRIVER_DESC_LOW) = (uint64)disk.avail;
    8000645c:	649c                	ld	a5,8(s1)
    8000645e:	0007869b          	sext.w	a3,a5
    80006462:	10001737          	lui	a4,0x10001
    80006466:	08d72823          	sw	a3,144(a4) # 10001090 <_entry-0x6fffef70>
  *R(VIRTIO_MMIO_DRIVER_DESC_HIGH) = (uint64)disk.avail >> 32;
    8000646a:	9781                	srai	a5,a5,0x20
    8000646c:	08f72a23          	sw	a5,148(a4)
  *R(VIRTIO_MMIO_DEVICE_DESC_LOW) = (uint64)disk.used;
    80006470:	689c                	ld	a5,16(s1)
    80006472:	0007869b          	sext.w	a3,a5
    80006476:	0ad72023          	sw	a3,160(a4)
  *R(VIRTIO_MMIO_DEVICE_DESC_HIGH) = (uint64)disk.used >> 32;
    8000647a:	9781                	srai	a5,a5,0x20
    8000647c:	0af72223          	sw	a5,164(a4)
  *R(VIRTIO_MMIO_QUEUE_READY) = 0x1;
    80006480:	4785                	li	a5,1
    80006482:	c37c                	sw	a5,68(a4)
    disk.free[i] = 1;
    80006484:	00f48c23          	sb	a5,24(s1)
    80006488:	00f48ca3          	sb	a5,25(s1)
    8000648c:	00f48d23          	sb	a5,26(s1)
    80006490:	00f48da3          	sb	a5,27(s1)
    80006494:	00f48e23          	sb	a5,28(s1)
    80006498:	00f48ea3          	sb	a5,29(s1)
    8000649c:	00f48f23          	sb	a5,30(s1)
    800064a0:	00f48fa3          	sb	a5,31(s1)
  status |= VIRTIO_CONFIG_S_DRIVER_OK;
    800064a4:	00496913          	ori	s2,s2,4
  *R(VIRTIO_MMIO_STATUS) = status;
    800064a8:	07272823          	sw	s2,112(a4)
}
    800064ac:	60e2                	ld	ra,24(sp)
    800064ae:	6442                	ld	s0,16(sp)
    800064b0:	64a2                	ld	s1,8(sp)
    800064b2:	6902                	ld	s2,0(sp)
    800064b4:	6105                	addi	sp,sp,32
    800064b6:	8082                	ret
    panic("could not find virtio disk");
    800064b8:	00002517          	auipc	a0,0x2
    800064bc:	55050513          	addi	a0,a0,1360 # 80008a08 <etext+0xa08>
    800064c0:	b64fa0ef          	jal	80000824 <panic>
    panic("virtio disk FEATURES_OK unset");
    800064c4:	00002517          	auipc	a0,0x2
    800064c8:	56450513          	addi	a0,a0,1380 # 80008a28 <etext+0xa28>
    800064cc:	b58fa0ef          	jal	80000824 <panic>
    panic("virtio disk should not be ready");
    800064d0:	00002517          	auipc	a0,0x2
    800064d4:	57850513          	addi	a0,a0,1400 # 80008a48 <etext+0xa48>
    800064d8:	b4cfa0ef          	jal	80000824 <panic>
    panic("virtio disk has no queue 0");
    800064dc:	00002517          	auipc	a0,0x2
    800064e0:	58c50513          	addi	a0,a0,1420 # 80008a68 <etext+0xa68>
    800064e4:	b40fa0ef          	jal	80000824 <panic>
    panic("virtio disk max queue too short");
    800064e8:	00002517          	auipc	a0,0x2
    800064ec:	5a050513          	addi	a0,a0,1440 # 80008a88 <etext+0xa88>
    800064f0:	b34fa0ef          	jal	80000824 <panic>
    panic("virtio disk kalloc");
    800064f4:	00002517          	auipc	a0,0x2
    800064f8:	5b450513          	addi	a0,a0,1460 # 80008aa8 <etext+0xaa8>
    800064fc:	b28fa0ef          	jal	80000824 <panic>

0000000080006500 <virtio_disk_rw>:
  return 0;
}

void
virtio_disk_rw(struct buf *b, int write)
{
    80006500:	711d                	addi	sp,sp,-96
    80006502:	ec86                	sd	ra,88(sp)
    80006504:	e8a2                	sd	s0,80(sp)
    80006506:	e4a6                	sd	s1,72(sp)
    80006508:	e0ca                	sd	s2,64(sp)
    8000650a:	fc4e                	sd	s3,56(sp)
    8000650c:	f852                	sd	s4,48(sp)
    8000650e:	f456                	sd	s5,40(sp)
    80006510:	f05a                	sd	s6,32(sp)
    80006512:	ec5e                	sd	s7,24(sp)
    80006514:	e862                	sd	s8,16(sp)
    80006516:	1080                	addi	s0,sp,96
    80006518:	89aa                	mv	s3,a0
    8000651a:	8b2e                	mv	s6,a1
  uint64 sector = b->blockno * (BSIZE / 512);
    8000651c:	00c52b83          	lw	s7,12(a0)
    80006520:	001b9b9b          	slliw	s7,s7,0x1
    80006524:	1b82                	slli	s7,s7,0x20
    80006526:	020bdb93          	srli	s7,s7,0x20

  acquire(&disk.vdisk_lock);
    8000652a:	0226f517          	auipc	a0,0x226f
    8000652e:	86650513          	addi	a0,a0,-1946 # 82274d90 <disk+0x128>
    80006532:	ef6fa0ef          	jal	80000c28 <acquire>
  for(int i = 0; i < NUM; i++){
    80006536:	44a1                	li	s1,8
      disk.free[i] = 0;
    80006538:	0226ea97          	auipc	s5,0x226e
    8000653c:	730a8a93          	addi	s5,s5,1840 # 82274c68 <disk>
  for(int i = 0; i < 3; i++){
    80006540:	4a0d                	li	s4,3
    idx[i] = alloc_desc();
    80006542:	5c7d                	li	s8,-1
    80006544:	a095                	j	800065a8 <virtio_disk_rw+0xa8>
      disk.free[i] = 0;
    80006546:	00fa8733          	add	a4,s5,a5
    8000654a:	00070c23          	sb	zero,24(a4)
    idx[i] = alloc_desc();
    8000654e:	c19c                	sw	a5,0(a1)
    if(idx[i] < 0){
    80006550:	0207c563          	bltz	a5,8000657a <virtio_disk_rw+0x7a>
  for(int i = 0; i < 3; i++){
    80006554:	2905                	addiw	s2,s2,1
    80006556:	0611                	addi	a2,a2,4 # 1004 <_entry-0x7fffeffc>
    80006558:	05490c63          	beq	s2,s4,800065b0 <virtio_disk_rw+0xb0>
    idx[i] = alloc_desc();
    8000655c:	85b2                	mv	a1,a2
  for(int i = 0; i < NUM; i++){
    8000655e:	0226e717          	auipc	a4,0x226e
    80006562:	70a70713          	addi	a4,a4,1802 # 82274c68 <disk>
    80006566:	4781                	li	a5,0
    if(disk.free[i]){
    80006568:	01874683          	lbu	a3,24(a4)
    8000656c:	fee9                	bnez	a3,80006546 <virtio_disk_rw+0x46>
  for(int i = 0; i < NUM; i++){
    8000656e:	2785                	addiw	a5,a5,1
    80006570:	0705                	addi	a4,a4,1
    80006572:	fe979be3          	bne	a5,s1,80006568 <virtio_disk_rw+0x68>
    idx[i] = alloc_desc();
    80006576:	0185a023          	sw	s8,0(a1)
      for(int j = 0; j < i; j++)
    8000657a:	01205d63          	blez	s2,80006594 <virtio_disk_rw+0x94>
        free_desc(idx[j]);
    8000657e:	fa042503          	lw	a0,-96(s0)
    80006582:	d41ff0ef          	jal	800062c2 <free_desc>
      for(int j = 0; j < i; j++)
    80006586:	4785                	li	a5,1
    80006588:	0127d663          	bge	a5,s2,80006594 <virtio_disk_rw+0x94>
        free_desc(idx[j]);
    8000658c:	fa442503          	lw	a0,-92(s0)
    80006590:	d33ff0ef          	jal	800062c2 <free_desc>
  int idx[3];
  while(1){
    if(alloc3_desc(idx) == 0) {
      break;
    }
    sleep(&disk.free[0], &disk.vdisk_lock);
    80006594:	0226e597          	auipc	a1,0x226e
    80006598:	7fc58593          	addi	a1,a1,2044 # 82274d90 <disk+0x128>
    8000659c:	0226e517          	auipc	a0,0x226e
    800065a0:	6e450513          	addi	a0,a0,1764 # 82274c80 <disk+0x18>
    800065a4:	936fc0ef          	jal	800026da <sleep>
  for(int i = 0; i < 3; i++){
    800065a8:	fa040613          	addi	a2,s0,-96
    800065ac:	4901                	li	s2,0
    800065ae:	b77d                	j	8000655c <virtio_disk_rw+0x5c>
  }

  // format the three descriptors.
  // qemu's virtio-blk.c reads them.

  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    800065b0:	fa042503          	lw	a0,-96(s0)
    800065b4:	00451693          	slli	a3,a0,0x4

  if(write)
    800065b8:	0226e797          	auipc	a5,0x226e
    800065bc:	6b078793          	addi	a5,a5,1712 # 82274c68 <disk>
    800065c0:	00451713          	slli	a4,a0,0x4
    800065c4:	0a070713          	addi	a4,a4,160
    800065c8:	973e                	add	a4,a4,a5
    800065ca:	01603633          	snez	a2,s6
    800065ce:	c710                	sw	a2,8(a4)
    buf0->type = VIRTIO_BLK_T_OUT; // write the disk
  else
    buf0->type = VIRTIO_BLK_T_IN; // read the disk
  buf0->reserved = 0;
    800065d0:	00072623          	sw	zero,12(a4)
  buf0->sector = sector;
    800065d4:	01773823          	sd	s7,16(a4)

  disk.desc[idx[0]].addr = (uint64) buf0;
    800065d8:	6398                	ld	a4,0(a5)
    800065da:	9736                	add	a4,a4,a3
  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    800065dc:	0a868613          	addi	a2,a3,168 # 100010a8 <_entry-0x6fffef58>
    800065e0:	963e                	add	a2,a2,a5
  disk.desc[idx[0]].addr = (uint64) buf0;
    800065e2:	e310                	sd	a2,0(a4)
  disk.desc[idx[0]].len = sizeof(struct virtio_blk_req);
    800065e4:	6390                	ld	a2,0(a5)
    800065e6:	00d60833          	add	a6,a2,a3
    800065ea:	4741                	li	a4,16
    800065ec:	00e82423          	sw	a4,8(a6)
  disk.desc[idx[0]].flags = VRING_DESC_F_NEXT;
    800065f0:	4585                	li	a1,1
    800065f2:	00b81623          	sh	a1,12(a6)
  disk.desc[idx[0]].next = idx[1];
    800065f6:	fa442703          	lw	a4,-92(s0)
    800065fa:	00e81723          	sh	a4,14(a6)

  disk.desc[idx[1]].addr = (uint64) b->data;
    800065fe:	0712                	slli	a4,a4,0x4
    80006600:	963a                	add	a2,a2,a4
    80006602:	05898813          	addi	a6,s3,88
    80006606:	01063023          	sd	a6,0(a2)
  disk.desc[idx[1]].len = BSIZE;
    8000660a:	0007b883          	ld	a7,0(a5)
    8000660e:	9746                	add	a4,a4,a7
    80006610:	40000613          	li	a2,1024
    80006614:	c710                	sw	a2,8(a4)
  if(write)
    80006616:	001b3613          	seqz	a2,s6
    8000661a:	0016161b          	slliw	a2,a2,0x1
    disk.desc[idx[1]].flags = 0; // device reads b->data
  else
    disk.desc[idx[1]].flags = VRING_DESC_F_WRITE; // device writes b->data
  disk.desc[idx[1]].flags |= VRING_DESC_F_NEXT;
    8000661e:	8e4d                	or	a2,a2,a1
    80006620:	00c71623          	sh	a2,12(a4)
  disk.desc[idx[1]].next = idx[2];
    80006624:	fa842603          	lw	a2,-88(s0)
    80006628:	00c71723          	sh	a2,14(a4)

  disk.info[idx[0]].status = 0xff; // device writes 0 on success
    8000662c:	00451813          	slli	a6,a0,0x4
    80006630:	02080813          	addi	a6,a6,32
    80006634:	983e                	add	a6,a6,a5
    80006636:	577d                	li	a4,-1
    80006638:	00e80823          	sb	a4,16(a6)
  disk.desc[idx[2]].addr = (uint64) &disk.info[idx[0]].status;
    8000663c:	0612                	slli	a2,a2,0x4
    8000663e:	98b2                	add	a7,a7,a2
    80006640:	03068713          	addi	a4,a3,48
    80006644:	973e                	add	a4,a4,a5
    80006646:	00e8b023          	sd	a4,0(a7)
  disk.desc[idx[2]].len = 1;
    8000664a:	6398                	ld	a4,0(a5)
    8000664c:	9732                	add	a4,a4,a2
    8000664e:	c70c                	sw	a1,8(a4)
  disk.desc[idx[2]].flags = VRING_DESC_F_WRITE; // device writes the status
    80006650:	4689                	li	a3,2
    80006652:	00d71623          	sh	a3,12(a4)
  disk.desc[idx[2]].next = 0;
    80006656:	00071723          	sh	zero,14(a4)

  // record struct buf for virtio_disk_intr().
  b->disk = 1;
    8000665a:	00b9a223          	sw	a1,4(s3)
  disk.info[idx[0]].b = b;
    8000665e:	01383423          	sd	s3,8(a6)

  // tell the device the first index in our chain of descriptors.
  disk.avail->ring[disk.avail->idx % NUM] = idx[0];
    80006662:	6794                	ld	a3,8(a5)
    80006664:	0026d703          	lhu	a4,2(a3)
    80006668:	8b1d                	andi	a4,a4,7
    8000666a:	0706                	slli	a4,a4,0x1
    8000666c:	96ba                	add	a3,a3,a4
    8000666e:	00a69223          	sh	a0,4(a3)

  __sync_synchronize();
    80006672:	0330000f          	fence	rw,rw

  // tell the device another avail ring entry is available.
  disk.avail->idx += 1; // not % NUM ...
    80006676:	6798                	ld	a4,8(a5)
    80006678:	00275783          	lhu	a5,2(a4)
    8000667c:	2785                	addiw	a5,a5,1
    8000667e:	00f71123          	sh	a5,2(a4)

  __sync_synchronize();
    80006682:	0330000f          	fence	rw,rw

  *R(VIRTIO_MMIO_QUEUE_NOTIFY) = 0; // value is queue number
    80006686:	100017b7          	lui	a5,0x10001
    8000668a:	0407a823          	sw	zero,80(a5) # 10001050 <_entry-0x6fffefb0>

  // Wait for virtio_disk_intr() to say request has finished.
  while(b->disk == 1) {
    8000668e:	0049a783          	lw	a5,4(s3)
    sleep(b, &disk.vdisk_lock);
    80006692:	0226e917          	auipc	s2,0x226e
    80006696:	6fe90913          	addi	s2,s2,1790 # 82274d90 <disk+0x128>
  while(b->disk == 1) {
    8000669a:	84ae                	mv	s1,a1
    8000669c:	00b79a63          	bne	a5,a1,800066b0 <virtio_disk_rw+0x1b0>
    sleep(b, &disk.vdisk_lock);
    800066a0:	85ca                	mv	a1,s2
    800066a2:	854e                	mv	a0,s3
    800066a4:	836fc0ef          	jal	800026da <sleep>
  while(b->disk == 1) {
    800066a8:	0049a783          	lw	a5,4(s3)
    800066ac:	fe978ae3          	beq	a5,s1,800066a0 <virtio_disk_rw+0x1a0>
  }

  disk.info[idx[0]].b = 0;
    800066b0:	fa042903          	lw	s2,-96(s0)
    800066b4:	00491713          	slli	a4,s2,0x4
    800066b8:	02070713          	addi	a4,a4,32
    800066bc:	0226e797          	auipc	a5,0x226e
    800066c0:	5ac78793          	addi	a5,a5,1452 # 82274c68 <disk>
    800066c4:	97ba                	add	a5,a5,a4
    800066c6:	0007b423          	sd	zero,8(a5)
    int flag = disk.desc[i].flags;
    800066ca:	0226e997          	auipc	s3,0x226e
    800066ce:	59e98993          	addi	s3,s3,1438 # 82274c68 <disk>
    800066d2:	00491713          	slli	a4,s2,0x4
    800066d6:	0009b783          	ld	a5,0(s3)
    800066da:	97ba                	add	a5,a5,a4
    800066dc:	00c7d483          	lhu	s1,12(a5)
    int nxt = disk.desc[i].next;
    800066e0:	854a                	mv	a0,s2
    800066e2:	00e7d903          	lhu	s2,14(a5)
    free_desc(i);
    800066e6:	bddff0ef          	jal	800062c2 <free_desc>
    if(flag & VRING_DESC_F_NEXT)
    800066ea:	8885                	andi	s1,s1,1
    800066ec:	f0fd                	bnez	s1,800066d2 <virtio_disk_rw+0x1d2>
  free_chain(idx[0]);

  release(&disk.vdisk_lock);
    800066ee:	0226e517          	auipc	a0,0x226e
    800066f2:	6a250513          	addi	a0,a0,1698 # 82274d90 <disk+0x128>
    800066f6:	dc6fa0ef          	jal	80000cbc <release>
}
    800066fa:	60e6                	ld	ra,88(sp)
    800066fc:	6446                	ld	s0,80(sp)
    800066fe:	64a6                	ld	s1,72(sp)
    80006700:	6906                	ld	s2,64(sp)
    80006702:	79e2                	ld	s3,56(sp)
    80006704:	7a42                	ld	s4,48(sp)
    80006706:	7aa2                	ld	s5,40(sp)
    80006708:	7b02                	ld	s6,32(sp)
    8000670a:	6be2                	ld	s7,24(sp)
    8000670c:	6c42                	ld	s8,16(sp)
    8000670e:	6125                	addi	sp,sp,96
    80006710:	8082                	ret

0000000080006712 <virtio_disk_intr>:

void
virtio_disk_intr()
{
    80006712:	1101                	addi	sp,sp,-32
    80006714:	ec06                	sd	ra,24(sp)
    80006716:	e822                	sd	s0,16(sp)
    80006718:	e426                	sd	s1,8(sp)
    8000671a:	1000                	addi	s0,sp,32
  acquire(&disk.vdisk_lock);
    8000671c:	0226e497          	auipc	s1,0x226e
    80006720:	54c48493          	addi	s1,s1,1356 # 82274c68 <disk>
    80006724:	0226e517          	auipc	a0,0x226e
    80006728:	66c50513          	addi	a0,a0,1644 # 82274d90 <disk+0x128>
    8000672c:	cfcfa0ef          	jal	80000c28 <acquire>
  // we've seen this interrupt, which the following line does.
  // this may race with the device writing new entries to
  // the "used" ring, in which case we may process the new
  // completion entries in this interrupt, and have nothing to do
  // in the next interrupt, which is harmless.
  *R(VIRTIO_MMIO_INTERRUPT_ACK) = *R(VIRTIO_MMIO_INTERRUPT_STATUS) & 0x3;
    80006730:	100017b7          	lui	a5,0x10001
    80006734:	53bc                	lw	a5,96(a5)
    80006736:	8b8d                	andi	a5,a5,3
    80006738:	10001737          	lui	a4,0x10001
    8000673c:	d37c                	sw	a5,100(a4)

  __sync_synchronize();
    8000673e:	0330000f          	fence	rw,rw

  // the device increments disk.used->idx when it
  // adds an entry to the used ring.

  while(disk.used_idx != disk.used->idx){
    80006742:	689c                	ld	a5,16(s1)
    80006744:	0204d703          	lhu	a4,32(s1)
    80006748:	0027d783          	lhu	a5,2(a5) # 10001002 <_entry-0x6fffeffe>
    8000674c:	04f70863          	beq	a4,a5,8000679c <virtio_disk_intr+0x8a>
    __sync_synchronize();
    80006750:	0330000f          	fence	rw,rw
    int id = disk.used->ring[disk.used_idx % NUM].id;
    80006754:	6898                	ld	a4,16(s1)
    80006756:	0204d783          	lhu	a5,32(s1)
    8000675a:	8b9d                	andi	a5,a5,7
    8000675c:	078e                	slli	a5,a5,0x3
    8000675e:	97ba                	add	a5,a5,a4
    80006760:	43dc                	lw	a5,4(a5)

    if(disk.info[id].status != 0)
    80006762:	00479713          	slli	a4,a5,0x4
    80006766:	02070713          	addi	a4,a4,32 # 10001020 <_entry-0x6fffefe0>
    8000676a:	9726                	add	a4,a4,s1
    8000676c:	01074703          	lbu	a4,16(a4)
    80006770:	e329                	bnez	a4,800067b2 <virtio_disk_intr+0xa0>
      panic("virtio_disk_intr status");

    struct buf *b = disk.info[id].b;
    80006772:	0792                	slli	a5,a5,0x4
    80006774:	02078793          	addi	a5,a5,32
    80006778:	97a6                	add	a5,a5,s1
    8000677a:	6788                	ld	a0,8(a5)
    b->disk = 0;   // disk is done with buf
    8000677c:	00052223          	sw	zero,4(a0)
    wakeup(b);
    80006780:	fa7fb0ef          	jal	80002726 <wakeup>

    disk.used_idx += 1;
    80006784:	0204d783          	lhu	a5,32(s1)
    80006788:	2785                	addiw	a5,a5,1
    8000678a:	17c2                	slli	a5,a5,0x30
    8000678c:	93c1                	srli	a5,a5,0x30
    8000678e:	02f49023          	sh	a5,32(s1)
  while(disk.used_idx != disk.used->idx){
    80006792:	6898                	ld	a4,16(s1)
    80006794:	00275703          	lhu	a4,2(a4)
    80006798:	faf71ce3          	bne	a4,a5,80006750 <virtio_disk_intr+0x3e>
  }

  release(&disk.vdisk_lock);
    8000679c:	0226e517          	auipc	a0,0x226e
    800067a0:	5f450513          	addi	a0,a0,1524 # 82274d90 <disk+0x128>
    800067a4:	d18fa0ef          	jal	80000cbc <release>
}
    800067a8:	60e2                	ld	ra,24(sp)
    800067aa:	6442                	ld	s0,16(sp)
    800067ac:	64a2                	ld	s1,8(sp)
    800067ae:	6105                	addi	sp,sp,32
    800067b0:	8082                	ret
      panic("virtio_disk_intr status");
    800067b2:	00002517          	auipc	a0,0x2
    800067b6:	30e50513          	addi	a0,a0,782 # 80008ac0 <etext+0xac0>
    800067ba:	86afa0ef          	jal	80000824 <panic>
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
