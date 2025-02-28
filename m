Received: from smtpbgau2.qq.com (smtpbgau2.qq.com [54.206.34.216])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CEED21BEF82;
	Fri, 28 Feb 2025 05:37:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=54.206.34.216
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740721070; cv=none; b=ImbLS0y2NU5mXFpZ1BiDENHh8h6Bk9TbYzaNpPK4WxiNGqg1DSK0HmuxmyzspxzwbUqi4osO3xZsT5uU16hpXJ19HEmrxBcBD7wi6mXIU3T/jCDSZDgA7R1Mjs+u4uIksK6EUafK/g5P6cZBUdOPY1KTVaN6oSUYs4vznB+ZGQg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740721070; c=relaxed/simple;
	bh=EA4My43wV+5AeO1WKhaa9PtLtgh+AvWkwFeiGVXixx8=;
	h=From:Content-Type:Mime-Version:Subject:Message-Id:Date:Cc:To; b=E/gUVT4C3O2htHg2V/Pg/fxP1+s81ZegO3IpmdRnlr4cRjAggRAhgJSvgxJKV/pm59+3JDlSTQat0/9IQ623nvrzJ+odZCB+d6NchjyM3FHbAEYXF3Wx/58QY7ILXwopxpEvAQHZCuRZFJYbqbJx1t+PONo/iNvo9LolhknhG5c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=m.fudan.edu.cn; spf=pass smtp.mailfrom=m.fudan.edu.cn; dkim=pass (1024-bit key) header.d=m.fudan.edu.cn header.i=@m.fudan.edu.cn header.b=eUi9771N; arc=none smtp.client-ip=54.206.34.216
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=m.fudan.edu.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=m.fudan.edu.cn
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=m.fudan.edu.cn header.i=@m.fudan.edu.cn header.b="eUi9771N"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=m.fudan.edu.cn;
	s=sorc2401; t=1740721046;
	bh=zej3l/VhWayOFDJihQNo4c7f+zl1RMZdXx+5GGEqHNM=;
	h=From:Mime-Version:Subject:Message-Id:Date:To;
	b=eUi9771NanvazT5ScOtRAESr0vtO3kyYsRnYCHRX4Uy8IsEAzdK8Ib34Msfy2Yqp4
	 LiNJ4lJpPqqimu09pR/aZ8DknymnUVK3kyb8lzyJVquZP0W42/89tVafH6AF+cghv7
	 t7HZaImjD4rUOW4OSyQsY2tuMFT4VeHrQuJQUnls=
X-QQ-mid: bizesmtpsz15t1740721041tq2cp8
X-QQ-Originating-IP: QLvO+yBLxLyi55liIgGjNbdRSHKp8uoEU1FYx7yq+k4=
Received: from smtpclient.apple ( [202.120.235.76])
	by bizesmtp.qq.com (ESMTP) with 
	id ; Fri, 28 Feb 2025 13:37:19 +0800 (CST)
X-QQ-SSF: 0000000000000000000000000000000
X-QQ-GoodBg: 0
X-BIZMAIL-ID: 1641597565874851230
From: Kun Hu <huk23@m.fudan.edu.cn>
Content-Type: text/plain;
	charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3818.100.11.1.3\))
Subject: [Bug] missing bounds check for k->u64s=0 in validate_bset_keys:999
Message-Id: <BB5BB1E2-2146-4F79-8EE9-0DCFA5F0D381@m.fudan.edu.cn>
Date: Fri, 28 Feb 2025 13:37:08 +0800
Cc: linux-bcachefs@vger.kernel.org,
 linux-kernel@vger.kernel.org,
 syzkaller@googlegroups.com,
 "jjtan24@m.fudan.edu.cn" <jjtan24@m.fudan.edu.cn>,
 baishuoran@hrbeu.edu.cn
To: Kent Overstreet <kent.overstreet@linux.dev>
X-Mailer: Apple Mail (2.3818.100.11.1.3)
X-QQ-SENDSIZE: 520
Feedback-ID: bizesmtpsz:m.fudan.edu.cn:qybglogicsvrgz:qybglogicsvrgz8a-1
X-QQ-XMAILINFO: MPAlP4yRn0xg5GJlyD8fNxPdgXaOixYmVrbtBKEgcUxmzame/MrBix07
	Ru5Kxs+RxFdGzeK3crmQtn5KZcP4PkP5uvAnqPAALSTUb6PKoHwpgSunQ0g1kq8XYEYNqVB
	LKEIIU0xDJIYqqYsJHcauj7aSIfNx7EK36wtPGvycBros0fxSZ15X1pqgkDSONHl/TyWeYs
	ylP5m2YyP2271skYtMoIMViunxMfvec5b9vU1tkjtsEe9tIT85mfCS4nP1SuUXNd+NkZVjl
	IYhKO8YG564g36usgwTkSXFn+38gGTEMB3KYt/YmwwlvrL7mLh075xCo7x6Z00q42b1rU0L
	PSYjVe2gRtv9CFXM1Y3rwfn2xbE5QUEIVKE3i30Fn+yoOk+oPA0A+prhzyQFXx6VAFNwn6A
	7jlVf3axLwwQg21xiQeELKhjPLpuRF0eISF/KuJUdwiNn8ks33745CyDYGMfDmH1M2YcXOn
	Wa/eaM1uo2Qr2V/lHsoZVELKpnH/KaXofvk7u3L5cVFvewP3Jqp/uFaO5zesgJIvBTtSW3Q
	yniC7dHrcKJ5KcoglQaUAXkGIodmgH40XWNupgprEeX3BsCbnZeKDOusaoBoQ3jcrd1Cojt
	e4YM8JFFEo3RSZ1zMzMBA3aoWAPO6gy9CJZspVMzup4GrS64Nk0+ZvztEuHPXODhadOO0es
	HtQhRmVImR+Mb8ACJSAhZwXvFD+2KwMDOfdvhcIZ01NvxMTMFePrri4i3+fcUKj5rBb1Xiy
	cSaECSbMOiAJHA6VuTJpuEqW7yRiwkLCwngFXts8eVUIp98ayqPyP46fEsgkX/17xaEYqyl
	8dfodAtx2c8iTcJYAHCPYVoylxbdUv0Wb3z4AG8z+faKP0rqvd89RNJ692nQa1Ut6+e6ZWg
	NdruVC1GF64faX0cNvn7+08r1IYi2zhKWfVBmpCfxsXYdeFgYlRojTcf+OOSwv49Ldv3+Us
	ekltYtMLdrsRgxHy0dO6PINeUIlfWG55FmPc=
X-QQ-XMRINFO: MPJ6Tf5t3I/ycC2BItcBVIA=
X-QQ-RECHKSPAM: 0

Hi Kent,

When using our customized Syzkaller to fuzz the latest Linux kernel, the =
following crash (82th)
was triggered.

HEAD commit: d082ecbc71e9e0bf49883ee4afd435a77a5101b6
git tree: upstream
Output: =
https://github.com/pghk13/Kernel-Bug/blob/main/0225_6.14rc2/82-KASAN_%20sl=
ab-out-of-bounds%20Read%20in%20mapping_try_invalidate/output_on_6.14rc4
Kernel config: =
https://github.com/pghk13/Kernel-Bug/blob/main/0225_6.14rc2/config_6.14rc4=
.txt
C reproducer: =
https://github.com/pghk13/Kernel-Bug/blob/main/0225_6.14rc2/82-KASAN_%20sl=
ab-out-of-bounds%20Read%20in%20mapping_try_invalidate/repro.c
Syzlang reproducer: =
https://github.com/pghk13/Kernel-Bug/blob/main/0225_6.14rc2/82-KASAN_%20sl=
ab-out-of-bounds%20Read%20in%20mapping_try_invalidate/repro.syz

The file images in the repro are randomly constructed by syzkaller. =
According to the report, this issue points to line 999 in the =
validate_bset_keys function. Based on multiple reproductions of the =
issue, the problem appears to occur when parsing corrupted btree nodes =
(where k->u64s might be 0). The memmove_u64s_down operation attempts to =
shift subsequent data forward, but the calculation of vstruct_end(i) =
might be out of bounds when handling such invalid nodes. This could lead =
to heap memory corruption, potentially causing subsequently allocated =
memory to contain invalid pointers.

Our knowledge of the kernel is somewhat limited, and we'd appreciate it =
if you could determine if there is such an issue. If this issue doesn't =
have an impact, please ignore it =E2=98=BA.

If you fix this issue, please add the following tag to the commit:
Reported-by: Kun Hu <huk23@m.fudan.edu.cn>, Jiaji Qin =
<jjtan24@m.fudan.edu.cn>, Shuoran Bai <baishuoran@hrbeu.edu.cn>

=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
kernel BUG at arch/x86/mm/physaddr.c:28!
Oops: invalid opcode: 0000 [#1] PREEMPT SMP KASAN NOPTI
CPU: 3 UID: 0 PID: 57 Comm: kworker/3:1H Not tainted 6.14.0-rc4 #1
Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS =
1.13.0-1ubuntu1.1 04/01/2014
Workqueue: bcachefs_btree_read_complete btree_node_read_work
RIP: 0010:__phys_addr+0xdc/0x150
Code: ff 48 d3 eb 48 89 de e8 22 76 4f 00 48 85 db 75 13 e8 d8 73 4f 00 =
4c 89 e0 5b 5d 41 5c 41 5d e9 e5 c0 a5 ff e8 c5 73 4f 00 90 <0f> 0b e8 =
bd 73 4f 00 48 c7 c0 10 a0 fa 8d 48 ba 00 00 00 00 00 fc
RSP: 0018:ffffc9000071efe8 EFLAGS: 00010246
RAX: 0000000000000000 RBX: 000000000000000e RCX: ffffffff816a7fa2
RDX: 000077800000000e RSI: ffff8880412ac900 RDI: 0000000000000002
RBP: 000000008000000e R08: 0000000000000000 R09: fffffbfff2de6d9f
R10: fffffbfff2de6d9e R11: 0000000000000001 R12: 000077800000000e
R13: 0000000000000000 R14: ffffc9000071f048 R15: ffff888075c2a140
FS:  0000000000000000(0000) GS:ffff88807ef00000(0000) =
knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f955b82c15d CR3: 000000006f1e0000 CR4: 0000000000750ef0
PKRU: 55555554
Call Trace:
 <TASK>
 qlist_free_all+0x68/0x130
 kasan_quarantine_reduce+0x168/0x1c0
 __kasan_slab_alloc+0x67/0x90
 __kmalloc_node_track_caller_noprof+0x1c5/0x5f0
 krealloc_noprof+0x2a7/0x390
 bch2_printbuf_make_room+0x1be/0x2e0
 bch2_prt_printf+0x18b/0x4d0
 __btree_err+0x16c/0x950
 validate_bset_keys+0xd79/0x18d0
 bch2_btree_node_read_done+0x2223/0x5340
 btree_node_read_work+0xa7e/0x1cc0
 process_scheduled_works+0x5c0/0x1aa0
 worker_thread+0x59f/0xcf0
 kthread+0x42a/0x880
 ret_from_fork+0x48/0x80
 ret_from_fork_asm+0x1a/0x30
 </TASK>
Modules linked in:
---[ end trace 0000000000000000 ]---
RIP: 0010:__phys_addr+0xdc/0x150
Code: ff 48 d3 eb 48 89 de e8 22 76 4f 00 48 85 db 75 13 e8 d8 73 4f 00 =
4c 89 e0 5b 5d 41 5c 41 5d e9 e5 c0 a5 ff e8 c5 73 4f 00 90 <0f> 0b e8 =
bd 73 4f 00 48 c7 c0 10 a0 fa 8d 48 ba 00 00 00 00 00 fc
RSP: 0018:ffffc9000071efe8 EFLAGS: 00010246
RAX: 0000000000000000 RBX: 000000000000000e RCX: ffffffff816a7fa2
RDX: 000077800000000e RSI: ffff8880412ac900 RDI: 0000000000000002
RBP: 000000008000000e R08: 0000000000000000 R09: fffffbfff2de6d9f
R10: fffffbfff2de6d9e R11: 0000000000000001 R12: 000077800000000e
R13: 0000000000000000 R14: ffffc9000071f048 R15: ffff888075c2a140
FS:  0000000000000000(0000) GS:ffff88807ef00000(0000) =
knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f955b82c15d CR3: 000000006f1e0000 CR4: 0000000000750ef0
PKRU: 55555554
2025/02/26 11:21:55 reproducing crash 'KASAN: slab-out-of-bounds Read in =
mapping_try_invalidate': final repro crashed as (corrupted=3Dfalse):
  u64s 11 type btree_ptr_v2 SPOS_MAX len 0 ver 0: seq c6c25c03258c59c5 =
written 1032 min_key POS_MIN durability: 1 ptr: 0:27:0 gen 0 =20
  node offset 0/1032 bset u64s 33578 bset byte offset 160: bad k->u64s 0 =
(min 3 max 253), fixing
------------[ cut here ]------------
kernel BUG at arch/x86/mm/physaddr.c:28!
Oops: invalid opcode: 0000 [#1] PREEMPT SMP KASAN NOPTI
CPU: 3 UID: 0 PID: 57 Comm: kworker/3:1H Not tainted 6.14.0-rc4 #1
Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS =
1.13.0-1ubuntu1.1 04/01/2014
Workqueue: bcachefs_btree_read_complete btree_node_read_work
RIP: 0010:__phys_addr+0xdc/0x150
Code: ff 48 d3 eb 48 89 de e8 22 76 4f 00 48 85 db 75 13 e8 d8 73 4f 00 =
4c 89 e0 5b 5d 41 5c 41 5d e9 e5 c0 a5 ff e8 c5 73 4f 00 90 <0f> 0b e8 =
bd 73 4f 00 48 c7 c0 10 a0 fa 8d 48 ba 00 00 00 00 00 fc
RSP: 0018:ffffc9000071efe8 EFLAGS: 00010246
RAX: 0000000000000000 RBX: 000000000000000e RCX: ffffffff816a7fa2
RDX: 000077800000000e RSI: ffff8880412ac900 RDI: 0000000000000002
RBP: 000000008000000e R08: 0000000000000000 R09: fffffbfff2de6d9f
R10: fffffbfff2de6d9e R11: 0000000000000001 R12: 000077800000000e
R13: 0000000000000000 R14: ffffc9000071f048 R15: ffff888075c2a140
FS:  0000000000000000(0000) GS:ffff88807ef00000(0000) =
knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f955b82c15d CR3: 000000006f1e0000 CR4: 0000000000750ef0
PKRU: 55555554
Call Trace:
 <TASK>
 qlist_free_all+0x68/0x130
 kasan_quarantine_reduce+0x168/0x1c0
 __kasan_slab_alloc+0x67/0x90
 __kmalloc_node_track_caller_noprof+0x1c5/0x5f0
 krealloc_noprof+0x2a7/0x390
 bch2_printbuf_make_room+0x1be/0x2e0
 bch2_prt_printf+0x18b/0x4d0
 __btree_err+0x16c/0x950
 validate_bset_keys+0xd79/0x18d0
 bch2_btree_node_read_done+0x2223/0x5340
 btree_node_read_work+0xa7e/0x1cc0
 process_scheduled_works+0x5c0/0x1aa0
 worker_thread+0x59f/0xcf0
 kthread+0x42a/0x880
 ret_from_fork+0x48/0x80
 ret_from_fork_asm+0x1a/0x30
 </TASK>
Modules linked in:
---[ end trace 0000000000000000 ]---
RIP: 0010:__phys_addr+0xdc/0x150
Code: ff 48 d3 eb 48 89 de e8 22 76 4f 00 48 85 db 75 13 e8 d8 73 4f 00 =
4c 89 e0 5b 5d 41 5c 41 5d e9 e5 c0 a5 ff e8 c5 73 4f 00 90 <0f> 0b e8 =
bd 73 4f 00 48 c7 c0 10 a0 fa 8d 48 ba 00 00 00 00 00 fc
RSP: 0018:ffffc9000071efe8 EFLAGS: 00010246
RAX: 0000000000000000 RBX: 000000000000000e RCX: ffffffff816a7fa2
RDX: 000077800000000e RSI: ffff8880412ac900 RDI: 0000000000000002
RBP: 000000008000000e R08: 0000000000000000 R09: fffffbfff2de6d9f
R10: fffffbfff2de6d9e R11: 0000000000000001 R12: 000077800000000e
R13: 0000000000000000 R14: ffffc9000071f048 R15: ffff888075c2a140
FS:  0000000000000000(0000) GS:ffff88807ef00000(0000) =
knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f955b82c15d CR3: 000000006f1e0000 CR4: 0000000000750ef0
PKRU: 55555554
(base) qjj@syzkaller109:~/go1.22.1_projects/go_projects/syzkaller$ exit
exit

Script done on 2025-02-26 18:17:09+08:00 [COMMAND_EXIT_CODE=3D"0"]

---------------
thanks,
Kun Hu=
