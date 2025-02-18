Received: from mail-qk1-f171.google.com (mail-qk1-f171.google.com [209.85.222.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1EAD022DFF1;
	Tue, 18 Feb 2025 12:17:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739881022; cv=none; b=bIjVAxe6WQip9KmAiaDDqHm4li348/2+46t4eTuvaO/6Fz8XTwu8x/MfASUYgyhBf2eLAgsUYae9OW3DR3EI9CTHHHhIOozexh/aNcl/sqL0EqQ2rQT7ZAAbnEY9rGYB22tPgmwD7D5bHQ9AOCmJEhQR9mNaQK7gTBNFVx5LMLA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739881022; c=relaxed/simple;
	bh=/AzQb30OOP2Y/Cyju7Hx/qEr867cl3qE/8gM99+gnZ4=;
	h=Content-Type:Mime-Version:Subject:From:In-Reply-To:Date:Cc:
	 Message-Id:References:To; b=LqOb8VE85bopFJx6Mk1i1ftkJfVkIGpAmQU8YZ5ZlHXQKTrWKuN/7YBLMRZbaWMqxZu/FW7KIu5eUf1RKQRVS6qErLr3uIeyOTvKngrZUArLd7RBh/Oa6d9UXzjIYKeUK3qEKYGcs1Y8+ZZNb+8go9pnz2jo2pkqBD2NVXQXBIw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=S549E8xM; arc=none smtp.client-ip=209.85.222.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="S549E8xM"
Received: by mail-qk1-f171.google.com with SMTP id af79cd13be357-7c0819d8ebcso430203885a.2;
        Tue, 18 Feb 2025 04:17:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1739881020; x=1740485820; darn=vger.kernel.org;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=94WjMlwBeMhqPjiS2ysQkSO3XWSoqcMcB1ehVgKIhdg=;
        b=S549E8xMs3PTFhPdrEYteBSPyNP4lhErqJNV2RbxTZJ0KLFe0XJqrFfdNYsvCoS8sM
         nk2gr9KVF+EFZaVRLo/YC4U3QUfbahjz50lA+rMJz3asiThWBunv8LLRQTLq1ZwhzQGH
         npYrUsvitQ0lK8TU0Fg4ifvM/c9t7jI2fsk4Yw/wtNg+GXrI7WjL+0fQHsmhelGY0BMF
         Tgd/SYXQbb9Y4xTEYOW+7Foi8YrV/C5bsJfgITRnRzkfY3XUeL8WACww4StrJ4ZuhpB3
         uHEJ9gSkWzUTVV8Aok2N0WOyq1UYG4Q8d9GviyaFvWmUjRsXYLGVrIkBnwPY3qQSAOse
         fASA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739881020; x=1740485820;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=94WjMlwBeMhqPjiS2ysQkSO3XWSoqcMcB1ehVgKIhdg=;
        b=ggL052Z97K2k4SWWtW4wLjlaFJFX8V7S0Zni8TeG+HV+cEBePkZI4h0tBhKiAKIylx
         NHyZc99S8IEbeqQJ0nLt+nlAImokc8HcEEOf+4ftUMvPk4TW/T6XpmYkVIemxIEoECpj
         vE9hHXnyi2QKcGE5Qq4lVD9ru7HVNED1w8v5rNz1TM8m6qYtOfUiv371S5ZwntCm/G+v
         VhLOb6q77NojQo7ca6wx308lVGXH1F96jhkTMnmuOQCvMgN8QRMYpG0+xM596j1LBtju
         TsEynZ8pgIQRxeZ0mkEj6qWGgSsB+oXMnzk6yu9JMzwLCiW6siHbIGJaviT6ccGv/UhQ
         p3/A==
X-Forwarded-Encrypted: i=1; AJvYcCVmxoq8dl2POe5Rn29iY90SErQyaztY0ZftwRWRBSreNgkEoQekdhiOmE7nI7cDYckByhSWgd++VrGr6j9sIw==@vger.kernel.org, AJvYcCWmxys+0aBTdhSFmAdnSn0hGyRhTDCsbIjWSdQzX0r+Sju/3zM1/VBLE4h+ukpgr9mSRQdRNOFpy3qigBg5@vger.kernel.org
X-Gm-Message-State: AOJu0YygiS59hMv49XotT2UEDcMfzQYysLmgnIHj0E4KK4hY5P8+ybrg
	NVknHu96GsIWydCBWA0HrcQIzhjj76RLrcVKloObAOG2K2TDJ4oz
X-Gm-Gg: ASbGnctm50j9NfVML8+lC+87kHEtVI1tBSV4LmDQhTl0Fzwqt1Ux6096XtCsed+Upzp
	d3dtIemjEETq/k9YRxb+2RCAZAa4xnIy1B8z5+s7aAiHSFUFoWvDNI7P8Yr3E72vZgJV0c/unLN
	a/kVTxYO0VFwRW+XpDHBfGjvbp47gY2zPHzigThF41DN8PYuHfhTmPLXcD/xBnoddpjoKacH2/k
	TNisX05rJAzHIHe0qBojCxf7KYgMd87/NELKWjwU0WoS96H43MzOj0A/uqpMJuI5gn6AvVOWjU=
X-Google-Smtp-Source: AGHT+IF1xdUiIX6SUXIQVTTsOeNV/e/Qk1hPYhapW6udf+cOK5U9s486ezIrSHhNrJ31mmeMN9qHLw==
X-Received: by 2002:a05:620a:46a1:b0:7c0:7a8a:c0e3 with SMTP id af79cd13be357-7c08a9d8cb1mr1575218485a.26.1739881019814;
        Tue, 18 Feb 2025 04:16:59 -0800 (PST)
Received: from smtpclient.apple ([2402:d0c0:11:86::1])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-7c0b186f723sm25936085a.82.2025.02.18.04.16.53
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 18 Feb 2025 04:16:59 -0800 (PST)
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
In-Reply-To: <CAMgjq7D_gf6Kcp3e0wLDCboHUHXpjzMsFagC83gqmAn_dvuejQ@mail.gmail.com>
Date: Tue, 18 Feb 2025 20:16:40 +0800
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
Message-Id: <ACDD48FA-728B-45A4-896E-B4A28E586EAF@gmail.com>
References: <675d01e9.050a0220.37aaf.00be.GAE@google.com>
 <67af8747.050a0220.21dd3.004c.GAE@google.com>
 <20250214152358.7ba29d10229e2155c0899774@linux-foundation.org>
 <CAMgjq7DQm+nwTWMdWQ66WW84O6YnhRQvZEjaY3EeXZ5-iKXo-A@mail.gmail.com>
 <CAMgjq7AqZaRuu+udJd7MyU2n3eF7wKX8bjDugFrdHYd2Lq=EXQ@mail.gmail.com>
 <751557A5-5417-497D-95FF-62E7CFCCDC59@gmail.com>
 <CAMgjq7D_gf6Kcp3e0wLDCboHUHXpjzMsFagC83gqmAn_dvuejQ@mail.gmail.com>
To: Kairui Song <ryncsn@gmail.com>
X-Mailer: Apple Mail (2.3826.400.131.1.6)

On Feb 18, 2025, at 19:40, Kairui Song <ryncsn@gmail.com> wrote:
>=20
> On Tue, Feb 18, 2025 at 2:09=E2=80=AFAM Alan Huang =
<mmpgouride@gmail.com> wrote:
>>=20
>> On Feb 18, 2025, at 01:12, Kairui Song <ryncsn@gmail.com> wrote:
>>>=20
>>> On Mon, Feb 17, 2025 at 12:13=E2=80=AFAM Kairui Song =
<ryncsn@gmail.com> wrote:
>>>>=20
>>>> On Sat, Feb 15, 2025 at 7:24=E2=80=AFAM Andrew Morton =
<akpm@linux-foundation.org> wrote:
>>>>>=20
>>>>> On Fri, 14 Feb 2025 10:11:19 -0800 syzbot =
<syzbot+38a0cbd267eff2d286ff@syzkaller.appspotmail.com> wrote:
>>>>>=20
>>>>>> syzbot has found a reproducer for the following issue on:
>>>>>=20
>>>>> Thanks.  I doubt if bcachefs is implicated in this?
>>>>>=20
>>>>>> HEAD commit:    128c8f96eb86 Merge tag 'drm-fixes-2025-02-14' of =
https://g..
>>>>>> git tree:       upstream
>>>>>> console output: =
https://syzkaller.appspot.com/x/log.txt?x=3D148019a4580000
>>>>>> kernel config:  =
https://syzkaller.appspot.com/x/.config?x=3Dc776e555cfbdb82d
>>>>>> dashboard link: =
https://syzkaller.appspot.com/bug?extid=3D38a0cbd267eff2d286ff
>>>>>> compiler:       Debian clang version 15.0.6, GNU ld (GNU Binutils =
for Debian) 2.40
>>>>>> syz repro:      =
https://syzkaller.appspot.com/x/repro.syz?x=3D12328bf8580000
>>>>>>=20
>>>>>> Downloadable assets:
>>>>>> disk image (non-bootable): =
https://storage.googleapis.com/syzbot-assets/7feb34a89c2a/non_bootable_dis=
k-128c8f96.raw.xz
>>>>>> vmlinux: =
https://storage.googleapis.com/syzbot-assets/a97f78ac821e/vmlinux-128c8f96=
.xz
>>>>>> kernel image: =
https://storage.googleapis.com/syzbot-assets/f451cf16fc9f/bzImage-128c8f96=
.xz
>>>>>> mounted in repro: =
https://storage.googleapis.com/syzbot-assets/a7da783f97cf/mount_3.gz
>>>>>>=20
>>>>>> IMPORTANT: if you fix the issue, please add the following tag to =
the commit:
>>>>>> Reported-by: =
syzbot+38a0cbd267eff2d286ff@syzkaller.appspotmail.com
>>>>>>=20
>>>>>> ------------[ cut here ]------------
>>>>>> WARNING: CPU: 0 PID: 5459 at mm/list_lru.c:96 =
lock_list_lru_of_memcg+0x39e/0x4d0 mm/list_lru.c:96
>>>>>=20
>>>>>       VM_WARN_ON(!css_is_dying(&memcg->css));
>>>>=20
>>>> I'm checking this, when last time this was triggered, it was caused =
by
>>>> a list_lru user did not initialize the memcg list_lru properly =
before
>>>> list_lru reclaim started, and fixed by:
>>>> =
https://lore.kernel.org/all/20241222122936.67501-1-ryncsn@gmail.com/T/
>>>>=20
>>>> This shouldn't be a big issue, maybe there are leaks that will be
>>>> fixed upon reparenting, and this new added sanity check might be =
too
>>>> lenient, I'm not 100% sure though.
>>>>=20
>>>> Unfortunately I couldn't reproduce the issue locally with the
>>>> reproducer yet. will keep the test running and see if it can hit =
this
>>>> WARN_ON.
>>>=20
>>> So far I am still unable to trigger this VM_WARN_ON using the
>>> reproducer, and I'm seeing many other random crashes.
>>>=20
>>> But after I changed the .config a bit adding more debug configs
>>> (SLAB_FREELIST_HARDENED, DEBUG_PAGEALLOC), following crash showed up
>>> and will be triggered immediately after I start the test:
>>>=20
>>> [ T1242] BUG: unable to handle page fault for address: =
ffff888054c60000
>>> [ T1242] #PF: supervisor read access in kernel mode
>>> [ T1242] #PF: error_code(0x0000) - not-present page
>>> [ T1242] PGD 19e01067 P4D 19e01067 PUD 19e04067 PMD 7fc5c067 PTE
>>> 800fffffab39f060
>>> [ T1242] Oops: Oops: 0000 [#1] PREEMPT SMP DEBUG_PAGEALLOC KASAN PTI
>>> [ T1242] CPU: 1 UID: 0 PID: 1242 Comm: kworker/1:1H Not tainted
>>> 6.14.0-rc2-00185-g128c8f96eb86 #2
>>> [ T1242] Hardware name: Red Hat KVM/RHEL-AV, BIOS
>>> 1.16.0-4.module+el8.8.0+664+0a3d6c83 04/01/2014
>>> [ T1242] Workqueue: bcachefs_btree_read_complete =
btree_node_read_work
>>> [ T1242] RIP: 0010:validate_bset_keys+0xae3/0x14f0
>>> [ T6058] bcachefs (loop2): empty btree root xattrs
>>> [ T1242] Code: 49 39 df 0f 87 fc 09 00 00 e8 79 54 a8 fd 41 0f b7 c6
>>> 48 8b 4c 24 68 48 8d 04 c1 4c 29 f8 48 c1 e8 03 89 c1 48 89 de 4c 89
>>> ff <f3> 48 a5 48 8b bc 24 c8 00 00 08
>>> [ T1242] RSP: 0018:ffffc900070a72c0 EFLAGS: 00010206
>>> [ T1242] RAX: 000000000000ec0f RBX: ffff888054c20110 RCX: =
0000000000006c31
>>> [ T1242] RDX: 0000000000000000 RSI: ffff888054c60000 RDI: =
ffff888054c5ff90
>>> [ T1242] RBP: ffffc900070a7570 R08: ffff888065e001af R09: =
1ffff1100cbc0035
>>> [ T1242] R10: dffffc0000000000 R11: ffffed100cbc0036 R12: =
ffff888054c2009e
>>> [ T1242] R13: dffffc0000000000 R14: 000000000000ec0f R15: =
ffff888054c200a0
>>> [ T1242] FS:  0000000000000000(0000) GS:ffff88807ea00000(0000)
>>> knlGS:0000000000000000
>>> [ T1242] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
>>> [ T1242] CR2: ffff888054c60000 CR3: 000000006cea6000 CR4: =
00000000000006f0
>>> [ T1242] DR0: 0000000000000000 DR1: 0000000000000000 DR2: =
0000000000000000
>>> [ T1242] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: =
0000000000000400
>>> [ T1242] Call Trace:
>>> [ T1242]  <TASK>
>>> [ T1242]  bch2_btree_node_read_done+0x1d20/0x53a0
>>> [ T1242]  btree_node_read_work+0x54d/0xdc0
>>> [ T1242]  process_scheduled_works+0xaf8/0x17f0
>>> [ T1242]  worker_thread+0x89d/0xd60
>>> [ T1242]  kthread+0x722/0x890
>>> [ T1242]  ret_from_fork+0x4e/0x80
>>> [ T1242]  ret_from_fork_asm+0x1a/0x30
>>> [ T1242]  </TASK>
>>> [ T1242] Modules linked in:
>>> [ T1242] ---[ end trace 0000000000000000 ]---
>>> [ T1242] RIP: 0010:validate_bset_keys+0xae3/0x14f0
>>> [ T1242] Code: 49 39 df 0f 87 fc 09 00 00 e8 79 54 a8 fd 41 0f b7 c6
>>> 48 8b 4c 24 68 48 8d 04 c1 4c 29 f8 48 c1 e8 03 89 c1 48 89 de 4c 89
>>> ff <f3> 48 a5 48 8b bc 24 c8 00 00 08
>>> [ T1242] RSP: 0018:ffffc900070a72c0 EFLAGS: 00010206
>>> [ T1242] RAX: 000000000000ec0f RBX: ffff888054c20110 RCX: =
0000000000006c31
>>> [ T1242] RDX: 0000000000000000 RSI: ffff888054c60000 RDI: =
ffff888054c5ff90
>>> [ T1242] RBP: ffffc900070a7570 R08: ffff888065e001af R09: =
1ffff1100cbc0035
>>> [ T1242] R10: dffffc0000000000 R11: ffffed100cbc0036 R12: =
ffff888054c2009e
>>> [ T1242] R13: dffffc0000000000 R14: 000000000000ec0f R15: =
ffff888054c200a0
>>> [ T1242] FS:  0000000000000000(0000) GS:ffff88807ea00000(0000)
>>> knlGS:0000000000000000
>>> [ T1242] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
>>> [ T1242] CR2: ffff888054c60000 CR3: 000000006cea6000 CR4: =
00000000000006f0
>>> [ T1242] DR0: 0000000000000000 DR1: 0000000000000000 DR2: =
0000000000000000
>>> [ T1242] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: =
0000000000000400
>>> [ T1242] Kernel panic - not syncing: Fatal exception
>>> [ T1242] Kernel Offset: disabled
>>> [ T1242] Rebooting in 86400 seconds..
>>>=20
>>> It's caused by the memmove_u64s_down in validate_bset_keys of
>>> fs/bcachefs/btree_io.c:
>>> -> memmove_u64s_down(k, bkey_p_next(k), (u64 *) vstruct_end(i) - =
(u64 *) k);
>>=20
>>=20
>> Might need this.
>>=20
>> diff --git a/fs/bcachefs/btree_io.c b/fs/bcachefs/btree_io.c
>> index e71b278672b6..fb53174cb735 100644
>> --- a/fs/bcachefs/btree_io.c
>> +++ b/fs/bcachefs/btree_io.c
>> @@ -997,7 +997,7 @@ static int validate_bset_keys(struct bch_fs *c, =
struct btree *b,
>>                }
>> got_good_key:
>>                le16_add_cpu(&i->u64s, -next_good_key);
>> -               memmove_u64s_down(k, bkey_p_next(k), (u64 *) =
vstruct_end(i) - (u64 *) k);
>> +               memmove_u64s_down(k, bkey_p_next(k), (u64 *) =
vstruct_end(i) - (u64 *) bkey_p_next(k));
>>                set_btree_node_need_rewrite(b);
>>        }
>> fsck_err:
>>=20
>=20
> Thanks, but this didn't fix everything. I think the problem is more
> complex, syzbot seems to be trying to mount damaged bcachefs (on
> purpose I think), so the vstruct_end(i) is already returning an offset
> that is out of border.

Could you try this (I need to go out now):

diff --git a/fs/bcachefs/btree_io.c b/fs/bcachefs/btree_io.c
index e71b278672b6..80a0094be356 100644
--- a/fs/bcachefs/btree_io.c
+++ b/fs/bcachefs/btree_io.c
@@ -997,7 +997,7 @@ static int validate_bset_keys(struct bch_fs *c, =
struct btree *b,
                }
 got_good_key:
                le16_add_cpu(&i->u64s, -next_good_key);
-               memmove_u64s_down(k, bkey_p_next(k), (u64 *) =
vstruct_end(i) - (u64 *) k);
+               memmove_u64s_down(k, (u64 *) k + next_good_key, (u64 *) =
vstruct_end(i) - (u64 *) k);
                set_btree_node_need_rewrite(b);
        }
 fsck_err:

>=20
> I retriggered it and print some more debug info: i->_data is
> ffff88806d5c00a0, i->u64s is 60928, and the faulting address is
> ffff88806d600000.


