Received: from szxga04-in.huawei.com (szxga04-in.huawei.com [45.249.212.190])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 142E7DDAB;
	Tue, 22 Oct 2024 01:34:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.190
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729560891; cv=none; b=DNGMIdqKakon8UkyaUIgibdUpW86Tco3Bo83ZIPiSF0Ti8RhEeyWOzPvlMd+E1QeCAm/9e2EtIUoaDfqFQGXpqlkHlPWsaU5MYzRLZH6t22ApQjkdEDY+OfXupygxpf607+DRyBi+fJRi22suox3lhi9TbQpvbmoCsKRItMlqaU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729560891; c=relaxed/simple;
	bh=U1t5H9KMAGplXd+4dfjgkmnyOonoucwRr1r/MWt1X7s=;
	h=Content-Type:Message-ID:Date:MIME-Version:Subject:To:References:
	 From:In-Reply-To; b=jvUWMoKCFqcAh83isnlGvcRrE7dYpUZs63tjN5/pwZJlbBnGuFOAOQQsRGBGTmle0WlrN9sQ3nOxv2kTBNVvvXrHOFyzslnUi8DfwiOiYRVWfbSyGYQqMJpYUqNLNlmvChc4rNvHd42uDvVfAB5VzIag1lZ8bWyCmuPQaWW2JgY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.190
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.163.17])
	by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4XXZSY2z8jz2Fb7s;
	Tue, 22 Oct 2024 09:33:17 +0800 (CST)
Received: from dggpeml500022.china.huawei.com (unknown [7.185.36.66])
	by mail.maildlp.com (Postfix) with ESMTPS id CB8E61A0188;
	Tue, 22 Oct 2024 09:34:38 +0800 (CST)
Received: from [10.67.111.104] (10.67.111.104) by
 dggpeml500022.china.huawei.com (7.185.36.66) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Tue, 22 Oct 2024 09:34:38 +0800
Content-Type: multipart/mixed;
	boundary="------------rJdxhcEMxXilpbky7mxxYNYR"
Message-ID: <d72c960b-b524-4c8a-9809-7885aaf6a904@huawei.com>
Date: Tue, 22 Oct 2024 09:34:36 +0800
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [syzbot] [bcachefs?] UBSAN: shift-out-of-bounds in
 bch2_alloc_to_text
To: syzbot <syzbot+7f45fa9805c40db3f108@syzkaller.appspotmail.com>,
	<kent.overstreet@linux.dev>, <linux-bcachefs@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, <syzkaller-bugs@googlegroups.com>
References: <6715f84b.050a0220.10f4f4.003e.GAE@google.com>
Content-Language: en-US
From: Hongbo Li <lihongbo22@huawei.com>
In-Reply-To: <6715f84b.050a0220.10f4f4.003e.GAE@google.com>
X-ClientProxiedBy: dggems706-chm.china.huawei.com (10.3.19.183) To
 dggpeml500022.china.huawei.com (7.185.36.66)

--------------rJdxhcEMxXilpbky7mxxYNYR
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit

#syz test: 
git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git 
c964ced77262

On 2024/10/21 14:44, syzbot wrote:
> Hello,
> 
> syzbot found the following issue on:
> 
> HEAD commit:    c964ced77262 Merge tag 'for-linus' of git://git.kernel.org..
> git tree:       upstream
> console output: https://syzkaller.appspot.com/x/log.txt?x=12d9745f980000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=cfbd94c114a3d407
> dashboard link: https://syzkaller.appspot.com/bug?extid=7f45fa9805c40db3f108
> compiler:       Debian clang version 15.0.6, GNU ld (GNU Binutils for Debian) 2.40
> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=12637887980000
> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=12a1e830580000
> 
> Downloadable assets:
> disk image (non-bootable): https://storage.googleapis.com/syzbot-assets/7feb34a89c2a/non_bootable_disk-c964ced7.raw.xz
> vmlinux: https://storage.googleapis.com/syzbot-assets/e937ef58569a/vmlinux-c964ced7.xz
> kernel image: https://storage.googleapis.com/syzbot-assets/f1df9880ca4b/bzImage-c964ced7.xz
> mounted in repro: https://storage.googleapis.com/syzbot-assets/00439b875347/mount_0.gz
> 
> IMPORTANT: if you fix the issue, please add the following tag to the commit:
> Reported-by: syzbot+7f45fa9805c40db3f108@syzkaller.appspotmail.com
> 
> bcachefs (loop0): fatal error - emergency read only
> bcachefs (loop0): insufficient writeable journal devices available: have 0, need 1
> rw journal devs: loop0
> ------------[ cut here ]------------
> UBSAN: shift-out-of-bounds in fs/bcachefs/alloc_background.h:165:13
> shift exponent 129 is too large for 32-bit type 'unsigned int'
> CPU: 0 UID: 0 PID: 5104 Comm: syz-executor159 Not tainted 6.12.0-rc3-syzkaller-00087-gc964ced77262 #0
> Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.3-debian-1.16.3-2~bpo12+1 04/01/2014
> Call Trace:
>   <TASK>
>   __dump_stack lib/dump_stack.c:94 [inline]
>   dump_stack_lvl+0x241/0x360 lib/dump_stack.c:120
>   ubsan_epilogue lib/ubsan.c:231 [inline]
>   __ubsan_handle_shift_out_of_bounds+0x3c8/0x420 lib/ubsan.c:468
>   data_type_movable fs/bcachefs/alloc_background.h:165 [inline]
>   alloc_lru_idx_fragmentation fs/bcachefs/alloc_background.h:171 [inline]
>   bch2_alloc_to_text+0xc79/0xce0 fs/bcachefs/alloc_background.c:369
>   __bch2_bkey_fsck_err+0x1c8/0x280 fs/bcachefs/error.c:454
>   bch2_alloc_v4_validate+0x931/0xef0 fs/bcachefs/alloc_background.c:259
>   bch2_btree_node_read_done+0x3e7e/0x5e90 fs/bcachefs/btree_io.c:1223
>   btree_node_read_work+0x68b/0x1260 fs/bcachefs/btree_io.c:1327
>   bch2_btree_node_read+0x2433/0x2a10
>   __bch2_btree_root_read fs/bcachefs/btree_io.c:1753 [inline]
>   bch2_btree_root_read+0x617/0x7a0 fs/bcachefs/btree_io.c:1775
>   read_btree_roots+0x296/0x840 fs/bcachefs/recovery.c:524
>   bch2_fs_recovery+0x2585/0x39c0 fs/bcachefs/recovery.c:854
>   bch2_fs_start+0x356/0x5b0 fs/bcachefs/super.c:1036
>   bch2_fs_get_tree+0xd68/0x1710 fs/bcachefs/fs.c:2174
>   vfs_get_tree+0x90/0x2b0 fs/super.c:1800
>   do_new_mount+0x2be/0xb40 fs/namespace.c:3507
>   do_mount fs/namespace.c:3847 [inline]
>   __do_sys_mount fs/namespace.c:4055 [inline]
>   __se_sys_mount+0x2d6/0x3c0 fs/namespace.c:4032
>   do_syscall_x64 arch/x86/entry/common.c:52 [inline]
>   do_syscall_64+0xf3/0x230 arch/x86/entry/common.c:83
>   entry_SYSCALL_64_after_hwframe+0x77/0x7f
> RIP: 0033:0x7f7b61a11dea
> Code: d8 64 89 02 48 c7 c0 ff ff ff ff eb a6 e8 5e 04 00 00 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 49 89 ca b8 a5 00 00 00 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 b8 ff ff ff f7 d8 64 89 01 48
> RSP: 002b:00007ffff7f9a888 EFLAGS: 00000282 ORIG_RAX: 00000000000000a5
> RAX: ffffffffffffffda RBX: 00007ffff7f9a8a0 RCX: 00007f7b61a11dea
> RDX: 00000000200058c0 RSI: 0000000020000100 RDI: 00007ffff7f9a8a0
> RBP: 0000000000000004 R08: 00007ffff7f9a8e0 R09: 00000000000058c6
> R10: 0000000000000000 R11: 0000000000000282 R12: 0000000000000000
> R13: 00007ffff7f9a8e0 R14: 0000000000000003 R15: 0000000001000000
>   </TASK>
> ---[ end trace ]---
> 
> 
> ---
> This report is generated by a bot. It may contain errors.
> See https://goo.gl/tpsmEJ for more information about syzbot.
> syzbot engineers can be reached at syzkaller@googlegroups.com.
> 
> syzbot will keep track of this issue. See:
> https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
> 
> If the report is already addressed, let syzbot know by replying with:
> #syz fix: exact-commit-title
> 
> If you want syzbot to run the reproducer, reply with:
> #syz test: git://repo/address.git branch-or-commit-hash
> If you attach or paste a git patch, syzbot will apply it before testing.
> 
> If you want to overwrite report's subsystems, reply with:
> #syz set subsystems: new-subsystem
> (See the list of subsystem names on the web dashboard)
> 
> If the report is a duplicate of another one, reply with:
> #syz dup: exact-subject-of-another-report
> 
> If you want to undo deduplication, reply with:
> #syz undup
> 
--------------rJdxhcEMxXilpbky7mxxYNYR
Content-Type: text/plain; charset="UTF-8";
	name="0001-bcachefs-Fix-shift-out-of-bounds-in-bch2_alloc_to_te.patch"
Content-Disposition: attachment;
	filename*0="0001-bcachefs-Fix-shift-out-of-bounds-in-bch2_alloc_to_te.pa";
	filename*1="tch"
Content-Transfer-Encoding: base64

RnJvbSAxN2ZkMzY2MDkxZDEwNDcwMmFmNWIwNjk5YWM3M2IwNmQwYjU3NjE5IE1vbiBTZXAg
MTcgMDA6MDA6MDAgMjAwMQ0KRnJvbTogSG9uZ2JvIExpIDxsaWhvbmdibzIyQGh1YXdlaS5j
b20+DQpEYXRlOiBNb24sIDIxIE9jdCAyMDI0IDE1OjM1OjA5ICswODAwDQpTdWJqZWN0OiBb
UEFUQ0hdIGJjYWNoZWZzOiBGaXggc2hpZnQtb3V0LW9mLWJvdW5kcyBpbiBiY2gyX2FsbG9j
X3RvX3RleHQNCg0KVGhlIHN5emJvdCBmb3VuZCB0aGUgZm9sbG93aW5nIGlzc3VlOg0KYGBg
DQotLS0tLS0tLS0tLS1bIGN1dCBoZXJlIF0tLS0tLS0tLS0tLS0NClVCU0FOOiBzaGlmdC1v
dXQtb2YtYm91bmRzIGluIGZzL2JjYWNoZWZzL2FsbG9jX2JhY2tncm91bmQuaDoxNjU6MTMN
CnNoaWZ0IGV4cG9uZW50IDEyOSBpcyB0b28gbGFyZ2UgZm9yIDMyLWJpdCB0eXBlICd1bnNp
Z25lZCBpbnQnDQoNCkNhbGwgVHJhY2U6DQogPFRBU0s+DQogX19kdW1wX3N0YWNrIGxpYi9k
dW1wX3N0YWNrLmM6OTQgW2lubGluZV0NCiBkdW1wX3N0YWNrX2x2bCsweDI0MS8weDM2MCBs
aWIvZHVtcF9zdGFjay5jOjEyMA0KIHVic2FuX2VwaWxvZ3VlIGxpYi91YnNhbi5jOjIzMSBb
aW5saW5lXQ0KIF9fdWJzYW5faGFuZGxlX3NoaWZ0X291dF9vZl9ib3VuZHMrMHgzYzgvMHg0
MjAgbGliL3Vic2FuLmM6NDY4DQogZGF0YV90eXBlX21vdmFibGUgZnMvYmNhY2hlZnMvYWxs
b2NfYmFja2dyb3VuZC5oOjE2NSBbaW5saW5lXQ0KIGFsbG9jX2xydV9pZHhfZnJhZ21lbnRh
dGlvbiBmcy9iY2FjaGVmcy9hbGxvY19iYWNrZ3JvdW5kLmg6MTcxIFtpbmxpbmVdDQogYmNo
Ml9hbGxvY190b190ZXh0KzB4Yzc5LzB4Y2UwIGZzL2JjYWNoZWZzL2FsbG9jX2JhY2tncm91
bmQuYzozNjkNCiBfX2JjaDJfYmtleV9mc2NrX2VycisweDFjOC8weDI4MCBmcy9iY2FjaGVm
cy9lcnJvci5jOjQ1NA0KIGJjaDJfYWxsb2NfdjRfdmFsaWRhdGUrMHg5MzEvMHhlZjAgZnMv
YmNhY2hlZnMvYWxsb2NfYmFja2dyb3VuZC5jOjI1OQ0KIC4uLg0KYGBgDQoNCkluIGJjaDJf
YWxsb2NfdjRfdmFsaWRhdGUsIGJjYWNoZWZzIGRvZXNuJ3QgY2hlY2sgdGhlIGludmFsaWQN
CmRhdGFfdHlwZSBpbiBzd2l0Y2gtY2FzZS4gQW5kIHRoaXMgd2lsbCBjYXVzZSBzaGlmdC1v
dXQtb2YtYm91bmRzDQplcnJvciBmb3IgaW52YWxpZCBkYXRhX3R5cGUuIFRoaXMgY2FuIGJl
IGVhc2lseSBhdm9pZGVkIGJ5IGFkZGluZw0KdGhlIGRlZmF1bHQgYnJhbmNoIGluIHN3aXRj
aCBzdGF0ZW1lbnQgZm9yIGhhbmRsaW5nIHRoZSBkYXRhX3R5cGUuDQoNClJlcG9ydGVkLWJ5
OiBzeXpib3QrN2Y0NWZhOTgwNWM0MGRiM2YxMDhAc3l6a2FsbGVyLmFwcHNwb3RtYWlsLmNv
bQ0KQ2xvc2VzOiBodHRwczovL3N5emthbGxlci5hcHBzcG90LmNvbS9idWc/ZXh0aWQ9N2Y0
NWZhOTgwNWM0MGRiM2YxMDgNCkZpeGVzOiA3MWFiYTU5MDI5N2UgKCJiY2FjaGVmczogQWx3
YXlzIGNoZWNrIGFsbG9jIGRhdGEgdHlwZSIpDQpTaWduZWQtb2ZmLWJ5OiBIb25nYm8gTGkg
PGxpaG9uZ2JvMjJAaHVhd2VpLmNvbT4NCi0tLQ0KIGZzL2JjYWNoZWZzL2FsbG9jX2JhY2tn
cm91bmQuYyB8IDQgKysrKw0KIDEgZmlsZSBjaGFuZ2VkLCA0IGluc2VydGlvbnMoKykNCg0K
ZGlmZiAtLWdpdCBhL2ZzL2JjYWNoZWZzL2FsbG9jX2JhY2tncm91bmQuYyBiL2ZzL2JjYWNo
ZWZzL2FsbG9jX2JhY2tncm91bmQuYw0KaW5kZXggNmUxNjFmOGZmZThkLi4wOWZmNDFjYWM1
ZjggMTAwNjQ0DQotLS0gYS9mcy9iY2FjaGVmcy9hbGxvY19iYWNrZ3JvdW5kLmMNCisrKyBi
L2ZzL2JjYWNoZWZzL2FsbG9jX2JhY2tncm91bmQuYw0KQEAgLTMxNCw2ICszMTQsMTAgQEAg
aW50IGJjaDJfYWxsb2NfdjRfdmFsaWRhdGUoc3RydWN0IGJjaF9mcyAqYywgc3RydWN0IGJr
ZXlfc19jIGssDQogCQlicmVhazsNCiAJY2FzZSBCQ0hfREFUQV9zdHJpcGU6DQogCQlicmVh
azsNCisJZGVmYXVsdDoNCisJCWJrZXlfZnNja19lcnJfb24odHJ1ZSwgYywgYWxsb2Nfa2V5
X2RhdGFfdHlwZV9iYWQsDQorCQkJCSAidW5rbm93biBkYXRhIHR5cGUgJXUiLCBhLmRhdGFf
dHlwZSk7DQorCQlicmVhazsNCiAJfQ0KIGZzY2tfZXJyOg0KIAlyZXR1cm4gcmV0Ow0KLS0g
DQoyLjM0LjENCg==

--------------rJdxhcEMxXilpbky7mxxYNYR--
