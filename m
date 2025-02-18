Received: from mail-lj1-f171.google.com (mail-lj1-f171.google.com [209.85.208.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF88D26FDAD;
	Tue, 18 Feb 2025 17:47:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739900856; cv=none; b=XzP2jAKLHc0F/BG4Ec+5UGCMq3nS7XmBPaHRMrx5OYJdkD5wnrqaLGKiJnuvjbkT+nWKKmU2/GF1RizOETdRMPkZoYFIS7ZoCoOYefEmUt1dQja6wuGasRP1aYBcsTn5n6CBByjkZEr6C7koUa8PCC3KWT5BvL07N8wUpjJOIVA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739900856; c=relaxed/simple;
	bh=+Bg55nmBfLf8Qdd1KELsskS4IcCbk6o6IruPkIqloS0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=E8Rfk81yrL9GzKw1zp6M6SYipXwyNbzKgNO5EyhO46Cbts6wZI1ixbaiz6D/nDQP4j+lBZOY6CxxKIN3EmqANtz4TsPoaAKNmujblQSeyeI+MMISr3SN23TVUp2VarVeqUndG8vrIaeTz9lrBzpF8KHG0tsu7++IJlJFmSaNQ+Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=RBZM9NYs; arc=none smtp.client-ip=209.85.208.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="RBZM9NYs"
Received: by mail-lj1-f171.google.com with SMTP id 38308e7fff4ca-30615661f98so58510081fa.2;
        Tue, 18 Feb 2025 09:47:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1739900852; x=1740505652; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=SgckB2Y+yFM1/cblCDJaHeqi/9gqi+M3MJs4Dx3/ZyQ=;
        b=RBZM9NYs1kjMpX7vs5kx5NPlHtfLpw170cwyLO9yE+emT4BO9rZ5D9ADip7FjCNAFu
         GGkGhcjr0E/eCf/j/lYiQdAo6Wd4SZDtzHVZFiiBiT7Zbrp0BLiOwMxxGfE73LvM1QLc
         pb+a6Eu7c14Yllye0ftatnLOyLeEH3QV4VYnJlm/1vkTs9noljTkzrzsUzLx8wFlayZp
         KcwLAYI6p5jLKAxHWXBKKjBu+aaUi9VRnNpQ+BrBX/KipCzRWcT4XwcTbqnyiu2H4Pr1
         GQj9leiugq9rgBsZatQ3QmXt2GtLklCg8H51Zl1AnsMGslF9MHCBwL/HaRphSjyNuW6d
         PppQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739900852; x=1740505652;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=SgckB2Y+yFM1/cblCDJaHeqi/9gqi+M3MJs4Dx3/ZyQ=;
        b=Btig4LHy5dv9vJFN3Dk9D4Sob1AzQLe6MNu3W9HoG3lDNDY056JArd0VCFSjc78uVP
         61N9s7E509tekDiIphK1IUNYnMpg/JPQ4Yf5iQFKlJTnu5fEJAP+l/bmkDDw954NsJ8h
         IE4vWv0STs8aUfWLrVIPvE0BHF+VpGUqA3iSinfMC2c8MNT40rLa+/AeaWICbEVrfa86
         7AYT4/b4BOeuWwkTgryhmQtPDmLqkYMJr8jpD0g72KaanqgUasMsKEdAlqU9I6t7EWKy
         rdRi4g1R6ZNuvkJ23hUX3umrIPHhKOPuchpu02sJjurzBTJKDTe2wLBCfzoDwp9XLN7k
         7OGQ==
X-Forwarded-Encrypted: i=1; AJvYcCW3/5iWvopLYLXClbE83jGRRB0z243sWO4P3IosoBsuWdgZ1QDTOP7MLywQm5NrGQx7n+HV/3C/OhTnu9vjog==@vger.kernel.org, AJvYcCWEJy9aNwAbLyQE5u3HBaeDw07fm4nXKEOcwmnQCwbHVpVlo32foJqwfOW9r8ts5g6dvvHndC3EswqGWRlg@vger.kernel.org
X-Gm-Message-State: AOJu0YzStW2UXzzBzHxPsbuzbG8nblGgySBnzB58Z/S7gX0+C4vtSUC9
	8XIIbXDhSodT0BIZ6IxC3FLAsi+uE87yMUJv/75+QnVKbHiwVEDVIH4WjdpEJ6c0wuSr31waAQI
	Fh400JC8MybB5AyMuHfAN6JdKUnY=
X-Gm-Gg: ASbGncuzMTdLVEO2Wg9ZNA2HwONqOlz9rcemeIpzjQfPXDIPp/0+91dGp8TqfkXr8EU
	2DN5F4EWU6x+C4905VdHKqvsSwF8jtlYjFvLFqQx42ai/CyHzfXVtXs8hCUWD/HznSVJRiPA2
X-Google-Smtp-Source: AGHT+IHq/+Flge0nazq0vz/7JiaP9G0o2HZQu1xUqjJ5gAVNRbeMxPiT7XoLBi8SBAhbJkRs+UP75P9CcVKPEeWqI6A=
X-Received: by 2002:a2e:9bd4:0:b0:308:e521:592 with SMTP id
 38308e7fff4ca-30927b197b0mr40755971fa.30.1739900851498; Tue, 18 Feb 2025
 09:47:31 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <675d01e9.050a0220.37aaf.00be.GAE@google.com> <67af8747.050a0220.21dd3.004c.GAE@google.com>
 <20250214152358.7ba29d10229e2155c0899774@linux-foundation.org>
 <CAMgjq7DQm+nwTWMdWQ66WW84O6YnhRQvZEjaY3EeXZ5-iKXo-A@mail.gmail.com>
 <CAMgjq7AqZaRuu+udJd7MyU2n3eF7wKX8bjDugFrdHYd2Lq=EXQ@mail.gmail.com>
 <751557A5-5417-497D-95FF-62E7CFCCDC59@gmail.com> <CAMgjq7D_gf6Kcp3e0wLDCboHUHXpjzMsFagC83gqmAn_dvuejQ@mail.gmail.com>
 <ACDD48FA-728B-45A4-896E-B4A28E586EAF@gmail.com>
In-Reply-To: <ACDD48FA-728B-45A4-896E-B4A28E586EAF@gmail.com>
From: Kairui Song <ryncsn@gmail.com>
Date: Wed, 19 Feb 2025 01:47:15 +0800
X-Gm-Features: AWEUYZne6vkVYNKAQZIOMXWQLp3S4-ZOtZ2RIvqWz_-G9DsbT4hQkyWbr8MtolQ
Message-ID: <CAMgjq7Dxv4JwebBtR18_9TpNX_7ej5HXEN1s1sitB+H+4rCE-Q@mail.gmail.com>
Subject: Re: [syzbot] [mm?] [bcachefs?] WARNING in lock_list_lru_of_memcg
To: Alan Huang <mmpgouride@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, kent.overstreet@linux.dev, 
	syzbot <syzbot+38a0cbd267eff2d286ff@syzkaller.appspotmail.com>, 
	linux-bcachefs@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Feb 18, 2025 at 8:17=E2=80=AFPM Alan Huang <mmpgouride@gmail.com> w=
rote:
>
> On Feb 18, 2025, at 19:40, Kairui Song <ryncsn@gmail.com> wrote:
> >
> > On Tue, Feb 18, 2025 at 2:09=E2=80=AFAM Alan Huang <mmpgouride@gmail.co=
m> wrote:
> >>
> >> On Feb 18, 2025, at 01:12, Kairui Song <ryncsn@gmail.com> wrote:
> >>>
> >>> On Mon, Feb 17, 2025 at 12:13=E2=80=AFAM Kairui Song <ryncsn@gmail.co=
m> wrote:
> >>>>
> >>>> On Sat, Feb 15, 2025 at 7:24=E2=80=AFAM Andrew Morton <akpm@linux-fo=
undation.org> wrote:
> >>>>>
> >>>>> On Fri, 14 Feb 2025 10:11:19 -0800 syzbot <syzbot+38a0cbd267eff2d28=
6ff@syzkaller.appspotmail.com> wrote:
> >>>>>
> >>>>>> syzbot has found a reproducer for the following issue on:
> >>>>>
> >>>>> Thanks.  I doubt if bcachefs is implicated in this?
> >>>>>
> >>>>>> HEAD commit:    128c8f96eb86 Merge tag 'drm-fixes-2025-02-14' of h=
ttps://g..
> >>>>>> git tree:       upstream
> >>>>>> console output: https://syzkaller.appspot.com/x/log.txt?x=3D148019=
a4580000
> >>>>>> kernel config:  https://syzkaller.appspot.com/x/.config?x=3Dc776e5=
55cfbdb82d
> >>>>>> dashboard link: https://syzkaller.appspot.com/bug?extid=3D38a0cbd2=
67eff2d286ff
> >>>>>> compiler:       Debian clang version 15.0.6, GNU ld (GNU Binutils =
for Debian) 2.40
> >>>>>> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=3D1232=
8bf8580000
> >>>>>>
> >>>>>> Downloadable assets:
> >>>>>> disk image (non-bootable): https://storage.googleapis.com/syzbot-a=
ssets/7feb34a89c2a/non_bootable_disk-128c8f96.raw.xz
> >>>>>> vmlinux: https://storage.googleapis.com/syzbot-assets/a97f78ac821e=
/vmlinux-128c8f96.xz
> >>>>>> kernel image: https://storage.googleapis.com/syzbot-assets/f451cf1=
6fc9f/bzImage-128c8f96.xz
> >>>>>> mounted in repro: https://storage.googleapis.com/syzbot-assets/a7d=
a783f97cf/mount_3.gz
> >>>>>>
> >>>>>> IMPORTANT: if you fix the issue, please add the following tag to t=
he commit:
> >>>>>> Reported-by: syzbot+38a0cbd267eff2d286ff@syzkaller.appspotmail.com
> >>>>>>
> >>>>>> ------------[ cut here ]------------
> >>>>>> WARNING: CPU: 0 PID: 5459 at mm/list_lru.c:96 lock_list_lru_of_mem=
cg+0x39e/0x4d0 mm/list_lru.c:96
> >>>>>
> >>>>>       VM_WARN_ON(!css_is_dying(&memcg->css));
> >>>>
> >>>> I'm checking this, when last time this was triggered, it was caused =
by
> >>>> a list_lru user did not initialize the memcg list_lru properly befor=
e
> >>>> list_lru reclaim started, and fixed by:
> >>>> https://lore.kernel.org/all/20241222122936.67501-1-ryncsn@gmail.com/=
T/
> >>>>
> >>>> This shouldn't be a big issue, maybe there are leaks that will be
> >>>> fixed upon reparenting, and this new added sanity check might be too
> >>>> lenient, I'm not 100% sure though.
> >>>>
> >>>> Unfortunately I couldn't reproduce the issue locally with the
> >>>> reproducer yet. will keep the test running and see if it can hit thi=
s
> >>>> WARN_ON.
> >>>
> >>> So far I am still unable to trigger this VM_WARN_ON using the
> >>> reproducer, and I'm seeing many other random crashes.
> >>>
> >>> But after I changed the .config a bit adding more debug configs
> >>> (SLAB_FREELIST_HARDENED, DEBUG_PAGEALLOC), following crash showed up
> >>> and will be triggered immediately after I start the test:
> >>>
> >>> [ T1242] BUG: unable to handle page fault for address: ffff888054c600=
00
> >>> [ T1242] #PF: supervisor read access in kernel mode
> >>> [ T1242] #PF: error_code(0x0000) - not-present page
> >>> [ T1242] PGD 19e01067 P4D 19e01067 PUD 19e04067 PMD 7fc5c067 PTE
> >>> 800fffffab39f060
> >>> [ T1242] Oops: Oops: 0000 [#1] PREEMPT SMP DEBUG_PAGEALLOC KASAN PTI
> >>> [ T1242] CPU: 1 UID: 0 PID: 1242 Comm: kworker/1:1H Not tainted
> >>> 6.14.0-rc2-00185-g128c8f96eb86 #2
> >>> [ T1242] Hardware name: Red Hat KVM/RHEL-AV, BIOS
> >>> 1.16.0-4.module+el8.8.0+664+0a3d6c83 04/01/2014
> >>> [ T1242] Workqueue: bcachefs_btree_read_complete btree_node_read_work
> >>> [ T1242] RIP: 0010:validate_bset_keys+0xae3/0x14f0
> >>> [ T6058] bcachefs (loop2): empty btree root xattrs
> >>> [ T1242] Code: 49 39 df 0f 87 fc 09 00 00 e8 79 54 a8 fd 41 0f b7 c6
> >>> 48 8b 4c 24 68 48 8d 04 c1 4c 29 f8 48 c1 e8 03 89 c1 48 89 de 4c 89
> >>> ff <f3> 48 a5 48 8b bc 24 c8 00 00 08
> >>> [ T1242] RSP: 0018:ffffc900070a72c0 EFLAGS: 00010206
> >>> [ T1242] RAX: 000000000000ec0f RBX: ffff888054c20110 RCX: 00000000000=
06c31
> >>> [ T1242] RDX: 0000000000000000 RSI: ffff888054c60000 RDI: ffff888054c=
5ff90
> >>> [ T1242] RBP: ffffc900070a7570 R08: ffff888065e001af R09: 1ffff1100cb=
c0035
> >>> [ T1242] R10: dffffc0000000000 R11: ffffed100cbc0036 R12: ffff888054c=
2009e
> >>> [ T1242] R13: dffffc0000000000 R14: 000000000000ec0f R15: ffff888054c=
200a0
> >>> [ T1242] FS:  0000000000000000(0000) GS:ffff88807ea00000(0000)
> >>> knlGS:0000000000000000
> >>> [ T1242] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> >>> [ T1242] CR2: ffff888054c60000 CR3: 000000006cea6000 CR4: 00000000000=
006f0
> >>> [ T1242] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 00000000000=
00000
> >>> [ T1242] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 00000000000=
00400
> >>> [ T1242] Call Trace:
> >>> [ T1242]  <TASK>
> >>> [ T1242]  bch2_btree_node_read_done+0x1d20/0x53a0
> >>> [ T1242]  btree_node_read_work+0x54d/0xdc0
> >>> [ T1242]  process_scheduled_works+0xaf8/0x17f0
> >>> [ T1242]  worker_thread+0x89d/0xd60
> >>> [ T1242]  kthread+0x722/0x890
> >>> [ T1242]  ret_from_fork+0x4e/0x80
> >>> [ T1242]  ret_from_fork_asm+0x1a/0x30
> >>> [ T1242]  </TASK>
> >>> [ T1242] Modules linked in:
> >>> [ T1242] ---[ end trace 0000000000000000 ]---
> >>> [ T1242] RIP: 0010:validate_bset_keys+0xae3/0x14f0
> >>> [ T1242] Code: 49 39 df 0f 87 fc 09 00 00 e8 79 54 a8 fd 41 0f b7 c6
> >>> 48 8b 4c 24 68 48 8d 04 c1 4c 29 f8 48 c1 e8 03 89 c1 48 89 de 4c 89
> >>> ff <f3> 48 a5 48 8b bc 24 c8 00 00 08
> >>> [ T1242] RSP: 0018:ffffc900070a72c0 EFLAGS: 00010206
> >>> [ T1242] RAX: 000000000000ec0f RBX: ffff888054c20110 RCX: 00000000000=
06c31
> >>> [ T1242] RDX: 0000000000000000 RSI: ffff888054c60000 RDI: ffff888054c=
5ff90
> >>> [ T1242] RBP: ffffc900070a7570 R08: ffff888065e001af R09: 1ffff1100cb=
c0035
> >>> [ T1242] R10: dffffc0000000000 R11: ffffed100cbc0036 R12: ffff888054c=
2009e
> >>> [ T1242] R13: dffffc0000000000 R14: 000000000000ec0f R15: ffff888054c=
200a0
> >>> [ T1242] FS:  0000000000000000(0000) GS:ffff88807ea00000(0000)
> >>> knlGS:0000000000000000
> >>> [ T1242] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> >>> [ T1242] CR2: ffff888054c60000 CR3: 000000006cea6000 CR4: 00000000000=
006f0
> >>> [ T1242] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 00000000000=
00000
> >>> [ T1242] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 00000000000=
00400
> >>> [ T1242] Kernel panic - not syncing: Fatal exception
> >>> [ T1242] Kernel Offset: disabled
> >>> [ T1242] Rebooting in 86400 seconds..
> >>>
> >>> It's caused by the memmove_u64s_down in validate_bset_keys of
> >>> fs/bcachefs/btree_io.c:
> >>> -> memmove_u64s_down(k, bkey_p_next(k), (u64 *) vstruct_end(i) - (u64=
 *) k);
> >>
> >>
> >> Might need this.
> >>
> >> diff --git a/fs/bcachefs/btree_io.c b/fs/bcachefs/btree_io.c
> >> index e71b278672b6..fb53174cb735 100644
> >> --- a/fs/bcachefs/btree_io.c
> >> +++ b/fs/bcachefs/btree_io.c
> >> @@ -997,7 +997,7 @@ static int validate_bset_keys(struct bch_fs *c, st=
ruct btree *b,
> >>                }
> >> got_good_key:
> >>                le16_add_cpu(&i->u64s, -next_good_key);
> >> -               memmove_u64s_down(k, bkey_p_next(k), (u64 *) vstruct_e=
nd(i) - (u64 *) k);
> >> +               memmove_u64s_down(k, bkey_p_next(k), (u64 *) vstruct_e=
nd(i) - (u64 *) bkey_p_next(k));
> >>                set_btree_node_need_rewrite(b);
> >>        }
> >> fsck_err:
> >>
> >
> > Thanks, but this didn't fix everything. I think the problem is more
> > complex, syzbot seems to be trying to mount damaged bcachefs (on
> > purpose I think), so the vstruct_end(i) is already returning an offset
> > that is out of border.
>
> Could you try this (I need to go out now):
>
> diff --git a/fs/bcachefs/btree_io.c b/fs/bcachefs/btree_io.c
> index e71b278672b6..80a0094be356 100644
> --- a/fs/bcachefs/btree_io.c
> +++ b/fs/bcachefs/btree_io.c
> @@ -997,7 +997,7 @@ static int validate_bset_keys(struct bch_fs *c, struc=
t btree *b,
>                 }
>  got_good_key:
>                 le16_add_cpu(&i->u64s, -next_good_key);
> -               memmove_u64s_down(k, bkey_p_next(k), (u64 *) vstruct_end(=
i) - (u64 *) k);
> +               memmove_u64s_down(k, (u64 *) k + next_good_key, (u64 *) v=
struct_end(i) - (u64 *) k);
>                 set_btree_node_need_rewrite(b);
>         }
>  fsck_err:
>
> >
> > I retriggered it and print some more debug info: i->_data is
> > ffff88806d5c00a0, i->u64s is 60928, and the faulting address is
> > ffff88806d600000.
>

Hi Alan

This didn't help either. If I wasn't very wrong about this, the
problem is that the content of the `struct bset` is corrupted (not
exactly sure how this happens, but should be related to the damaged
bcachefs image from syzbot), so calculations based on that won't be
helpful.

If I add a print before the memmove_u64s_down, like this:
pr_err("DEBUG: k: 0x%lx - 0x%lx, len %ld", (unsigned long)k, (unsigned
long)bkey_p_next(k), bkey_p_next(k) - k);
pr_err("DEBUG: i: 0x%lx - 0x%lx, len %ld", (unsigned long)i->start,
(unsigned long)vstruct_end(i), i->u64s);
pr_err("DEBUG: next_good_key * 8: %ld, k + next_good_key: 0x%lx",
       next_good_key * sizeof(u64*), (u64 *) k + next_good_key);
le16_add_cpu(&i->u64s, -next_good_key);
pr_err("DEBUG: copying 0x%lx from 0x%lx, len %ld",
       k, (u64 *) k + next_good_key, (u64 *) vstruct_end(i) - (u64 *) k);
memmove_u64s_down(k, (u64 *) k + next_good_key, (u64 *) vstruct_end(i)
- (u64 *) k);

Then I got:
[   57.100623][ T1222] bcachefs: validate_bset_keys() DEBUG: k:
0xffff88806f2200a0 - 0xffff88806f220110, len 2
[   57.101323][ T1222] bcachefs: validate_bset_keys() DEBUG: i:
0xffff88806f2200a0 - 0xffff88806f2970a0, len 60928
[   57.101990][ T1222] bcachefs: validate_bset_keys() DEBUG:
next_good_key * 8: 3976, k + next_good_key: 0xffff88806f221028
[   57.102712][ T1222] bcachefs: validate_bset_keys() DEBUG: copying
0xffff88806f2200a0 from 0xffff88806f221028, len 60431
[   57.103437][ T1222] BUG: unable to handle page fault for address:
ffff88806f260000

`struct bset i` spawns an invalid area.
