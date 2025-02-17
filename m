Received: from mail-qt1-f170.google.com (mail-qt1-f170.google.com [209.85.160.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D29B17DE2D;
	Mon, 17 Feb 2025 18:09:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739815783; cv=none; b=u3iQxiLOvZPlC0sQRQSNMHrKcrP024dbiGGPu6ZxySD2J3LX0SDCWnhderqrN4thVPy/LTsUdpS8Iy3A7GnM1Q24N3dtq4ibYtVVWaW+1AdQZ96+S05r8FUaugzlpvuvndhpVohqaOqkfkFvVy9HLTv9Un12qxjadFoKznM5pwo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739815783; c=relaxed/simple;
	bh=hrECPnQjvkNFaLkB3vTdWo3+U8QZaG1Avwkchi8qhXk=;
	h=Content-Type:Mime-Version:Subject:From:In-Reply-To:Date:Cc:
	 Message-Id:References:To; b=fj0goPCfdi57judf8105cv3RtCTQOoJmOfcDpO3cJUq01pjG/P+4ZVfxBLztjRbnGuNnzHPoc0zpVLclmVar7Xyo9k5RjIK8+guQdrEgg+w2rxQierru8G+jN55Rc8czFDi229drBGbmYrLLKLrID3sVN0cjAAbe8NIfMT/iYhg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=OjZgsUZf; arc=none smtp.client-ip=209.85.160.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="OjZgsUZf"
Received: by mail-qt1-f170.google.com with SMTP id d75a77b69052e-471c8bcb4a9so35693361cf.2;
        Mon, 17 Feb 2025 10:09:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1739815781; x=1740420581; darn=vger.kernel.org;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=hBvfsEoCpRp8ZXnjv3d99RtE+foKSh1IThRWfJK/Q1Y=;
        b=OjZgsUZfR3gA9oJa89YIDni9eXJ4wiou2mN2LHca5VzCs9W7D9OipcsmoBnh0lnA0t
         ayY5YFjxG/T4pCz4Ea/DjdpSC/DrWSEgp/IgYWUjXNf2oDhTTnNqThwJs/DZSyQDUswF
         t3mKkwor4LRNx30boAzSuWrN9Ye4tqxsIpZnjhA0lY88EPSQr/I9YlymXuTMf+a6hU6a
         Ms2qAfSFNtEjc85LuZ1sVQ/xn53aMTHWKy4syMjOJLrHocJJH/3AfBEAYwuveLnhJ90B
         jeiNR8Nf7l+QYLPvlw3ZpIswuvhhL2XW6eXPs+brnzXIxj2YPKgx+WEY5rgA8Hf4KMBs
         51iQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739815781; x=1740420581;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=hBvfsEoCpRp8ZXnjv3d99RtE+foKSh1IThRWfJK/Q1Y=;
        b=fAZVI39ZlNK6YusO7fJO1An7OKxDMAlPNHdWt/anE7kbCPcSin5SveZHqsGinCiYgq
         bCAJLIREXVzWL+2eXYRZuW8r92fzC04o++wltkwXvspiDQxcwvYaeeeEjfxjEDnw4eU2
         ISwi1BBROhMwk7TL+Qgd5t7NagdtYuXqxfcAqXUAJ1wHFFdNr4DwYCUs3ZQxERjOfyiE
         opV+yroZ4InpfRooZcwzDLL4AIGQUZ1/vXCaqZHfG3RilWeTQUN3ioJk/kMYEDgqZDgl
         nknU3T0KZRnj19Bcy9k+14JpDx4uXWbKQYn5ffCUsU8rQY2yL4rPDSVoweY+cB1alfeq
         oDlg==
X-Forwarded-Encrypted: i=1; AJvYcCUAPH3B4+XvL64S1aEPR58mgEaI3BbEe/Kb6qDj1uz/utkudg205y7AP+AoZrhN9IAf6iVCxfFy4rPZqEKC@vger.kernel.org, AJvYcCUP1tGVugxvYHNbi/D4hJIYkT3TMplqOtDOjSwwyP9AADnANVKyaNRIAzS8ApKKsnnvPU+zuzV0akR+wngQew==@vger.kernel.org
X-Gm-Message-State: AOJu0YyEtiYFS68pdSVoVjQiQi1FxSPFtOPZZKKuMotQTUYWy4zrWpDJ
	cRyfc7hPcENUE8p4ox/mkUkCxJ6gG8h3yLX1bF4pwF+CjBVryu+y
X-Gm-Gg: ASbGncuqw3TEvyLR8b7j4w23J9VJqu0qcOwPNWAmVKc1yZjZRa6IkntOEyjda/TCIxq
	ds0Kt6Tvssnv3u+N5s0oOIW7ZoYl5ONPiHaFPuR0kFbU5qs04qbzZXGmkavvQAaIGaxH2Dm1b7G
	enmsvmVTVXJ5iMklhesYSQoQVM6+hzPxGj2gd5m2c/T74O0oWu4+RrGV3ZawR6S7fDAZBVbvRnI
	MFFB6OL+s4fvyLat75FLZ12e7KixYxTlPBS1Hb1ajSJsQ7DjkJcfoD2p98yoDU6pMJg3bw45P8=
X-Google-Smtp-Source: AGHT+IGhJsLlaMGVyjQKswJlt4842mDizRXe8sPXgfti6SvtW3a0UatpCKcesp5hYfUDlG6jGkBP1A==
X-Received: by 2002:ad4:5f0a:0:b0:6e6:6aa5:2326 with SMTP id 6a1803df08f44-6e66ccdadc1mr131234836d6.24.1739815780925;
        Mon, 17 Feb 2025 10:09:40 -0800 (PST)
Received: from smtpclient.apple ([2402:d0c0:11:86::1])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-6e65d9f31fdsm54379876d6.69.2025.02.17.10.09.34
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 17 Feb 2025 10:09:40 -0800 (PST)
Content-Type: text/plain;
	charset=utf-8
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3826.400.131.1.6\))
Subject: Re: [syzbot] [mm?] [bcachefs?] WARNING in lock_list_lru_of_memcg
From: Alan Huang <mmpgouride@gmail.com>
In-Reply-To: <CAMgjq7AqZaRuu+udJd7MyU2n3eF7wKX8bjDugFrdHYd2Lq=EXQ@mail.gmail.com>
Date: Tue, 18 Feb 2025 02:09:21 +0800
Cc: Andrew Morton <akpm@linux-foundation.org>,
 kent.overstreet@linux.dev,
 syzbot <syzbot+38a0cbd267eff2d286ff@syzkaller.appspotmail.com>,
 chengming.zhou@linux.dev,
 hannes@cmpxchg.org,
 linux-bcachefs@vger.kernel.org,
 linux-kernel@vger.kernel.org,
 linux-mm@kvack.org,
 mhocko@suse.com,
 muchun.song@linux.dev,
 roman.gushchin@linux.dev,
 sashal@kernel.org,
 shakeel.butt@linux.dev,
 syzkaller-bugs@googlegroups.com,
 willy@infradead.org,
 yuzhao@google.com,
 zhengqi.arch@bytedance.com
Content-Transfer-Encoding: quoted-printable
Message-Id: <751557A5-5417-497D-95FF-62E7CFCCDC59@gmail.com>
References: <675d01e9.050a0220.37aaf.00be.GAE@google.com>
 <67af8747.050a0220.21dd3.004c.GAE@google.com>
 <20250214152358.7ba29d10229e2155c0899774@linux-foundation.org>
 <CAMgjq7DQm+nwTWMdWQ66WW84O6YnhRQvZEjaY3EeXZ5-iKXo-A@mail.gmail.com>
 <CAMgjq7AqZaRuu+udJd7MyU2n3eF7wKX8bjDugFrdHYd2Lq=EXQ@mail.gmail.com>
To: Kairui Song <ryncsn@gmail.com>
X-Mailer: Apple Mail (2.3826.400.131.1.6)

On Feb 18, 2025, at 01:12, Kairui Song <ryncsn@gmail.com> wrote:
>=20
> On Mon, Feb 17, 2025 at 12:13=E2=80=AFAM Kairui Song =
<ryncsn@gmail.com> wrote:
>>=20
>> On Sat, Feb 15, 2025 at 7:24=E2=80=AFAM Andrew Morton =
<akpm@linux-foundation.org> wrote:
>>>=20
>>> On Fri, 14 Feb 2025 10:11:19 -0800 syzbot =
<syzbot+38a0cbd267eff2d286ff@syzkaller.appspotmail.com> wrote:
>>>=20
>>>> syzbot has found a reproducer for the following issue on:
>>>=20
>>> Thanks.  I doubt if bcachefs is implicated in this?
>>>=20
>>>> HEAD commit:    128c8f96eb86 Merge tag 'drm-fixes-2025-02-14' of =
https://g..
>>>> git tree:       upstream
>>>> console output: =
https://syzkaller.appspot.com/x/log.txt?x=3D148019a4580000
>>>> kernel config:  =
https://syzkaller.appspot.com/x/.config?x=3Dc776e555cfbdb82d
>>>> dashboard link: =
https://syzkaller.appspot.com/bug?extid=3D38a0cbd267eff2d286ff
>>>> compiler:       Debian clang version 15.0.6, GNU ld (GNU Binutils =
for Debian) 2.40
>>>> syz repro:      =
https://syzkaller.appspot.com/x/repro.syz?x=3D12328bf8580000
>>>>=20
>>>> Downloadable assets:
>>>> disk image (non-bootable): =
https://storage.googleapis.com/syzbot-assets/7feb34a89c2a/non_bootable_dis=
k-128c8f96.raw.xz
>>>> vmlinux: =
https://storage.googleapis.com/syzbot-assets/a97f78ac821e/vmlinux-128c8f96=
.xz
>>>> kernel image: =
https://storage.googleapis.com/syzbot-assets/f451cf16fc9f/bzImage-128c8f96=
.xz
>>>> mounted in repro: =
https://storage.googleapis.com/syzbot-assets/a7da783f97cf/mount_3.gz
>>>>=20
>>>> IMPORTANT: if you fix the issue, please add the following tag to =
the commit:
>>>> Reported-by: syzbot+38a0cbd267eff2d286ff@syzkaller.appspotmail.com
>>>>=20
>>>> ------------[ cut here ]------------
>>>> WARNING: CPU: 0 PID: 5459 at mm/list_lru.c:96 =
lock_list_lru_of_memcg+0x39e/0x4d0 mm/list_lru.c:96
>>>=20
>>>        VM_WARN_ON(!css_is_dying(&memcg->css));
>>=20
>> I'm checking this, when last time this was triggered, it was caused =
by
>> a list_lru user did not initialize the memcg list_lru properly before
>> list_lru reclaim started, and fixed by:
>> =
https://lore.kernel.org/all/20241222122936.67501-1-ryncsn@gmail.com/T/
>>=20
>> This shouldn't be a big issue, maybe there are leaks that will be
>> fixed upon reparenting, and this new added sanity check might be too
>> lenient, I'm not 100% sure though.
>>=20
>> Unfortunately I couldn't reproduce the issue locally with the
>> reproducer yet. will keep the test running and see if it can hit this
>> WARN_ON.
>=20
> So far I am still unable to trigger this VM_WARN_ON using the
> reproducer, and I'm seeing many other random crashes.
>=20
> But after I changed the .config a bit adding more debug configs
> (SLAB_FREELIST_HARDENED, DEBUG_PAGEALLOC), following crash showed up
> and will be triggered immediately after I start the test:
>=20
> [ T1242] BUG: unable to handle page fault for address: =
ffff888054c60000
> [ T1242] #PF: supervisor read access in kernel mode
> [ T1242] #PF: error_code(0x0000) - not-present page
> [ T1242] PGD 19e01067 P4D 19e01067 PUD 19e04067 PMD 7fc5c067 PTE
> 800fffffab39f060
> [ T1242] Oops: Oops: 0000 [#1] PREEMPT SMP DEBUG_PAGEALLOC KASAN PTI
> [ T1242] CPU: 1 UID: 0 PID: 1242 Comm: kworker/1:1H Not tainted
> 6.14.0-rc2-00185-g128c8f96eb86 #2
> [ T1242] Hardware name: Red Hat KVM/RHEL-AV, BIOS
> 1.16.0-4.module+el8.8.0+664+0a3d6c83 04/01/2014
> [ T1242] Workqueue: bcachefs_btree_read_complete btree_node_read_work
> [ T1242] RIP: 0010:validate_bset_keys+0xae3/0x14f0
> [ T6058] bcachefs (loop2): empty btree root xattrs
> [ T1242] Code: 49 39 df 0f 87 fc 09 00 00 e8 79 54 a8 fd 41 0f b7 c6
> 48 8b 4c 24 68 48 8d 04 c1 4c 29 f8 48 c1 e8 03 89 c1 48 89 de 4c 89
> ff <f3> 48 a5 48 8b bc 24 c8 00 00 08
> [ T1242] RSP: 0018:ffffc900070a72c0 EFLAGS: 00010206
> [ T1242] RAX: 000000000000ec0f RBX: ffff888054c20110 RCX: =
0000000000006c31
> [ T1242] RDX: 0000000000000000 RSI: ffff888054c60000 RDI: =
ffff888054c5ff90
> [ T1242] RBP: ffffc900070a7570 R08: ffff888065e001af R09: =
1ffff1100cbc0035
> [ T1242] R10: dffffc0000000000 R11: ffffed100cbc0036 R12: =
ffff888054c2009e
> [ T1242] R13: dffffc0000000000 R14: 000000000000ec0f R15: =
ffff888054c200a0
> [ T1242] FS:  0000000000000000(0000) GS:ffff88807ea00000(0000)
> knlGS:0000000000000000
> [ T1242] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [ T1242] CR2: ffff888054c60000 CR3: 000000006cea6000 CR4: =
00000000000006f0
> [ T1242] DR0: 0000000000000000 DR1: 0000000000000000 DR2: =
0000000000000000
> [ T1242] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: =
0000000000000400
> [ T1242] Call Trace:
> [ T1242]  <TASK>
> [ T1242]  bch2_btree_node_read_done+0x1d20/0x53a0
> [ T1242]  btree_node_read_work+0x54d/0xdc0
> [ T1242]  process_scheduled_works+0xaf8/0x17f0
> [ T1242]  worker_thread+0x89d/0xd60
> [ T1242]  kthread+0x722/0x890
> [ T1242]  ret_from_fork+0x4e/0x80
> [ T1242]  ret_from_fork_asm+0x1a/0x30
> [ T1242]  </TASK>
> [ T1242] Modules linked in:
> [ T1242] ---[ end trace 0000000000000000 ]---
> [ T1242] RIP: 0010:validate_bset_keys+0xae3/0x14f0
> [ T1242] Code: 49 39 df 0f 87 fc 09 00 00 e8 79 54 a8 fd 41 0f b7 c6
> 48 8b 4c 24 68 48 8d 04 c1 4c 29 f8 48 c1 e8 03 89 c1 48 89 de 4c 89
> ff <f3> 48 a5 48 8b bc 24 c8 00 00 08
> [ T1242] RSP: 0018:ffffc900070a72c0 EFLAGS: 00010206
> [ T1242] RAX: 000000000000ec0f RBX: ffff888054c20110 RCX: =
0000000000006c31
> [ T1242] RDX: 0000000000000000 RSI: ffff888054c60000 RDI: =
ffff888054c5ff90
> [ T1242] RBP: ffffc900070a7570 R08: ffff888065e001af R09: =
1ffff1100cbc0035
> [ T1242] R10: dffffc0000000000 R11: ffffed100cbc0036 R12: =
ffff888054c2009e
> [ T1242] R13: dffffc0000000000 R14: 000000000000ec0f R15: =
ffff888054c200a0
> [ T1242] FS:  0000000000000000(0000) GS:ffff88807ea00000(0000)
> knlGS:0000000000000000
> [ T1242] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [ T1242] CR2: ffff888054c60000 CR3: 000000006cea6000 CR4: =
00000000000006f0
> [ T1242] DR0: 0000000000000000 DR1: 0000000000000000 DR2: =
0000000000000000
> [ T1242] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: =
0000000000000400
> [ T1242] Kernel panic - not syncing: Fatal exception
> [ T1242] Kernel Offset: disabled
> [ T1242] Rebooting in 86400 seconds..
>=20
> It's caused by the memmove_u64s_down in validate_bset_keys of
> fs/bcachefs/btree_io.c:
> -> memmove_u64s_down(k, bkey_p_next(k), (u64 *) vstruct_end(i) - (u64 =
*) k);


Might need this.

diff --git a/fs/bcachefs/btree_io.c b/fs/bcachefs/btree_io.c
index e71b278672b6..fb53174cb735 100644
--- a/fs/bcachefs/btree_io.c
+++ b/fs/bcachefs/btree_io.c
@@ -997,7 +997,7 @@ static int validate_bset_keys(struct bch_fs *c, =
struct btree *b,
                }
 got_good_key:
                le16_add_cpu(&i->u64s, -next_good_key);
-               memmove_u64s_down(k, bkey_p_next(k), (u64 *) =
vstruct_end(i) - (u64 *) k);
+               memmove_u64s_down(k, bkey_p_next(k), (u64 *) =
vstruct_end(i) - (u64 *) bkey_p_next(k));
                set_btree_node_need_rewrite(b);
        }
 fsck_err:

>=20
> The bkey_p_next(k) is RSI: ffff888054c60000 and it's causing an out of
> border access.
> (u64 *) vstruct_end(i) - (u64 *) k is RCX: 0000000000006c31, if added
> to RDI this should cause an out of border write as well.
>=20
> This seems to indicate there is an out of border memory modification?
> And maybe it corrupted other subsystems? The slight change to .config
> changed the layout so it's causing a fault, maybe previously this just
> went on silently.
> I don't know much about bcachefs, will be grateful if bcachefs people
> could help have a look.
>=20

