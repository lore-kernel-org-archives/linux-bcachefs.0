Received: from mail-wm1-f41.google.com (mail-wm1-f41.google.com [209.85.128.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CCA3425761
	for <linux-bcachefs@vger.kernel.org>; Sat,  8 Jun 2024 09:24:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717838694; cv=none; b=APa+itlpq+7Bsyqd0jf5yxo1yZmRQBoVWU6pktqGcizPIfGTKQwLPPSEs6uIe7ojNPBtHg9k2kMMOJLUqoN+r8wmyZt55hNdBEbwpgaYdbd30b8OS13Xin5loNeHbvnuUvC+AhFXLOZC9LlHS3FUCd8m1hvpr8ahwotimrM9Z4c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717838694; c=relaxed/simple;
	bh=eREF+70Bo9MAeTtMFw2Qq5+V0AV1RRcwko+EsTYI7L4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=kKGuYcegu6w7Gjo1c1TijKsTSMP8etqdwvLUwy7qTivyX2SFWG5u93MpxUHQYuUCLjds/yqv+DrYnP6OThbhb72bLoLDWe2p3eJF5melCSgfo3KfHTn15YkP4VNqeREZPJmhtbd0Aouw8MLUQ0xaUM4cnkUt7+lwkVo39xsKrGA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Afs6aDEf; arc=none smtp.client-ip=209.85.128.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Afs6aDEf"
Received: by mail-wm1-f41.google.com with SMTP id 5b1f17b1804b1-42147970772so17528055e9.0
        for <linux-bcachefs@vger.kernel.org>; Sat, 08 Jun 2024 02:24:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1717838691; x=1718443491; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=BPSpXau6wdva3hIXfxLz8N0Xw9KgIlBhZkV9jJSuC3g=;
        b=Afs6aDEfedRROMPeaOewNwCN2+FdlYa4clJmH8tT9iRjixRaZhsmWlT87TEwzVLUk9
         4z4d5lDODZxpWaucnSPoRfk4unneS/+lU7MSlxI6hxq4Fz7BYMaPc0zs3shNG39kHimI
         wmTN5tOisqmOsBbDApvSjLH3Rst9kX/cF7qpqJ4wheSzkOe/ZHMO2UDAszI5YJup2Db3
         z8GGtHA7mQOdlTPwscZV9sdU5+0xSrzUUTZWwI/QmiLW6BOEkP6dzrZHSpEMau/TaHI7
         oYfo+ZadsbqcfvKHuL+EndBUZTi73oSy4m9M3Bj7Zqjas8lpj19YZ5UrKkdJ4X1UWhF5
         306w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1717838691; x=1718443491;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=BPSpXau6wdva3hIXfxLz8N0Xw9KgIlBhZkV9jJSuC3g=;
        b=v9QZL5f76CMYV60Wzr5YxuI20x24uImI3eBWpQbNI0I9uMc49h4MyIr3rc5P5qRDOa
         KfSWPoAEtwjLTn+Jj5A+mmgRQ6JPThkOzZmXbbEXEZME7B2ge596s/Ve4WJLbKnB2sfi
         MmreCTDTBeT7QGqmdPcDCfTB3OWQ6kcEVsJhwJt7MvqwXPBWsgrGqWKEg23jTT9+515i
         DOC0YtZ4SIJ2ShKxnjqrDUxGPs5OyTy7yMFKqv3/9M5py2HuycvP4urIWjYZORwHWYcv
         91WVVAsAdj++i4Ilo9KzjXPYoRrXhJhrBLEKs9Bl39ji/7zRj8OM1QfltbHFPVZNFrFr
         tYmg==
X-Gm-Message-State: AOJu0YzHClD/ia0D+oxWTPfC5O/vwOxzS4+sNbLeBVQ7Vbyi+mVa+yYH
	OwhMlxnPIJg3wM3K/90Wx7Em2m1Ch4Qx1n/0+JT8G66hL5bbVSw3
X-Google-Smtp-Source: AGHT+IHlsw1WbJ13w5U2gbIP4G8w+Tc92o8L04BE7jrV6FRqFEhEjlbF0WYYfTsRvdQ6hoaggaqm9Q==
X-Received: by 2002:a05:600c:4f16:b0:41b:f979:e19b with SMTP id 5b1f17b1804b1-42164a3b161mr34816525e9.39.1717838690939;
        Sat, 08 Jun 2024 02:24:50 -0700 (PDT)
Received: from f (cst-prg-24-228.cust.vodafone.cz. [46.135.24.228])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4217c59be82sm14807855e9.0.2024.06.08.02.24.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 08 Jun 2024 02:24:50 -0700 (PDT)
Date: Sat, 8 Jun 2024 11:24:37 +0200
From: Mateusz Guzik <mjguzik@gmail.com>
To: Kent Overstreet <kent.overstreet@linux.dev>
Cc: linux-bcachefs@vger.kernel.org
Subject: Re: long stalls when creating 20 directory trees of 1 million inodes
 in parallel
Message-ID: <ngsytb3begcqgyfc5tiqjqdj6fp7kdeiwvd2jfq7ahwge2dr7c@fjcawnco7ssk>
References: <nyu645ylcfo4go5bb7jyam7jvcohtjol2qz6n4kpcfdsaom4y6@yawhqfyzyudk>
 <CAGudoHFM1c2QMtbJMFCRw1YUk4p-_0GQBn9MfyFfNdxJbZqQeg@mail.gmail.com>
 <y3qdwfh7gjs6ykedg4ehrbwsiktabbtgoqloka5nnj5oatkh5k@7evginr2jhsf>
 <CAGudoHEsFHMG5UYpSyobp1zpm-eOpKdx=b7kL9NFG3_VKE8+Zg@mail.gmail.com>
 <ln4mfb5iv4kxxjcpm67szq24g6dxfdk36fsxb7shojmhg2fkf2@izeciivj46yw>
 <CAGudoHGeak9cnG+qE6=zoqbg5KiOZG+aMHksmbvwWTATKhWm-w@mail.gmail.com>
 <CAGudoHFyJ64SDwUTijSrqeDjXBO3MfFx8D8-DoMaPFEQmzzLDw@mail.gmail.com>
 <wvpgfberqgnidhzymc5gxsa45vwtrcto45ppcx6bprar5bkg4u@6tmfvbp5xeac>
 <CAGudoHFDFgAq2--dEubAV4w2ZqdqNY56SdAmmvy1nF8Z5bX6kA@mail.gmail.com>
 <jsrnek56sgp3stom6nmkfkacsva3iphl2hbmohece2htyrtt7l@hlbezgwrf3hk>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <jsrnek56sgp3stom6nmkfkacsva3iphl2hbmohece2htyrtt7l@hlbezgwrf3hk>

On Fri, Jun 07, 2024 at 02:10:05PM -0400, Kent Overstreet wrote:
> Does the following patch help? I think the hammering on the key cache
> lock may be correlated with the key cache being mostly empty (and it
> looks like the shrinker code is behaving badly and trying very hard to
> free from a mostly empty cache)
> 
> [snip the patch]

I see you committed the patch along with some other stuff.

I git pulled to 46eb7b6c7420c2313bde44ab8f74f303b042e754 ("bcachefs: add
might_sleep() annotations for fsck_err()").

For me the problem is still there.

This time around I populated the fs and *rebooted*, then did walktrees
test in a loop. So the first run has 0 state cached.

It looked like this:
# while true; do sh walktrees /testfs 20; done
3.17s user 605.22s system 1409% cpu 43.150 total
2.77s user 887.92s system 693% cpu 2:08.34 total
3.05s user 726.20s system 777% cpu 1:33.77 total
3.19s user 600.90s system 1476% cpu 40.904 total
3.10s user 956.80s system 599% cpu 2:40.19 total
3.15s user 575.78s system 1331% cpu 43.464 total
3.30s user 865.48s system 1386% cpu 1:02.64 total
2.79s user 470.09s system 1404% cpu 33.666 total
2.78s user 884.00s system 718% cpu 2:03.36 total
2.95s user 568.63s system 1439% cpu 39.714 total
3.02s user 964.90s system 729% cpu 2:12.72 total
2.95s user 829.68s system 703% cpu 1:58.44 total
2.77s user 597.92s system 1486% cpu 40.403 total

So the time varies wildly and there is tons of off cpu time -- with 20
workers eating 100% cpu for the duration it would be 2000%.

I also started seeing splats in dmesg (example at the end of the mail).

That is to say I would suggest you also leave it running in a loop.
Expected setting is that it approaches complete CPU usage for the period
and takes in the ballpark of 40s (well shorter on your hw, but you get
the idea).

It may be there is something in my config which makes this easier to run
into, you can find it here:
https://people.freebsd.org/~mjg/.linux-crap/.config

[everything that's built is =y, as in no modules, usable with direct
boot with kvm without kernel-specific initrd]

trace:
[  135.911692] btree trans held srcu lock (delaying memory reclaim) for 23 seconds
[  135.911712] WARNING: CPU: 4 PID: 1011 at fs/bcachefs/btree_iter.c:2996 bch2_trans_srcu_unlock+0x108/0x120
[  135.911732] Modules linked in:
[  135.911735] CPU: 4 PID: 1011 Comm: walktree Not tainted 6.10.0-rc2-00019-g46eb7b6c7420 #25
[  135.911737] Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS rel-1.16.1-0-g3208b098f51a-prebuilt.qemu.org 04/01/2014
[  135.911739] RIP: 0010:bch2_trans_srcu_unlock+0x108/0x120
[  135.911741] Code: 6e 8d 47 01 48 c7 c7 10 84 25 9f 48 b8 cf f7 53 e3 a5 9b c4 20 48 29 ca 48 d1 ea 48 f7 e2 48 89 d6 48 c1 ee 04 e8 68 61 a1 ff <0f> 0b e9 68 ff ff ff 0f 0b e9 77 ff ff ff 66 2e 0f 1f 84 00 00
00
[  135.911743] RSP: 0018:ff8d1078010d3b08 EFLAGS: 00010286
[  135.911746] RAX: 0000000000000000 RBX: ff4d738ec7d78000 RCX: 0000000000000027
[  135.911747] RDX: ff4d739427221788 RSI: 0000000000000001 RDI: ff4d739427221780
[  135.911748] RBP: ff4d73903b2c0000 R08: 0000000000000000 R09: 0000000000000003
[  135.911749] R10: ff8d1078010d39a8 R11: ff4d73943fd8a8a8 R12: fffffffffffff77a
[  135.911750] R13: ff4d738ec7d78000 R14: ff4d738e33d40780 R15: ff4d738ec7d78000
[  135.911751] FS:  00007fee88948740(0000) GS:ff4d739427200000(0000) knlGS:0000000000000000
[  135.911753] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  135.911754] CR2: 00007f3273d214e0 CR3: 0000000667376006 CR4: 0000000000371ef0
[  135.911758] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[  135.911759] DR3: 0000000000000000 DR6: 00000000fffe07f0 DR7: 0000000000000400
[  135.911760] Call Trace:
[  135.911766]  <TASK>
[  135.911769]  ? __warn+0x80/0x120
[  135.911773]  ? bch2_trans_srcu_unlock+0x108/0x120
[  135.911775]  ? report_bug+0x164/0x190
[  135.911779]  ? handle_bug+0x3c/0x80
[  135.911782]  ? exc_invalid_op+0x17/0x70
[  135.911784]  ? asm_exc_invalid_op+0x1a/0x20
[  135.911789]  ? bch2_trans_srcu_unlock+0x108/0x120
[  135.911791]  ? bch2_trans_srcu_unlock+0x108/0x120
[  135.911792]  ? bch2_trans_begin+0xf8/0x5d0
[  135.911794]  bch2_trans_begin+0x56b/0x5d0
[  135.911796]  bch2_lookup+0x77/0x180
[  135.911801]  __lookup_slow+0x82/0x130
[  135.911808]  walk_component+0xdb/0x150
[  135.911811]  path_lookupat+0x6a/0x1a0
[  135.911813]  filename_lookup+0xcc/0x1c0
[  135.911816]  ? _raw_spin_unlock+0xe/0x30
[  135.911819]  ? list_lru_add+0xb3/0x100
[  135.911822]  ? from_kgid_munged+0x12/0x30
[  135.911825]  vfs_statx+0x80/0x1b0
[  135.911829]  vfs_fstatat+0x85/0xb0
[  135.911831]  __do_sys_newfstatat+0x26/0x60
[  135.911835]  ? syscall_exit_to_user_mode+0x5b/0x1e0
[  135.911837]  ? clear_bhb_loop+0x45/0xa0
[  135.911838]  do_syscall_64+0x57/0x160
[  135.911842]  entry_SYSCALL_64_after_hwframe+0x76/0x7e
[  135.911845] RIP: 0033:0x7fee88a4275a
[  135.911848] Code: 48 89 f2 b9 00 01 00 00 48 89 fe bf 9c ff ff ff e9 0b 00 00 00 66 2e 0f 1f 84 00 00 00 00 00 90 41 89 ca b8 06 01 00 00 0f 05 <3d> 00 f0 ff ff 77 07 31 c0 c3 0f 1f 40 00 48 8b 15 71 a6 0d 00
f7
[  135.911849] RSP: 002b:00007fff556a8a18 EFLAGS: 00000246 ORIG_RAX: 0000000000000106
[  135.911851] RAX: ffffffffffffffda RBX: 00007fff556a8ac0 RCX: 00007fee88a4275a
[  135.911852] RDX: 00007fff556a8a30 RSI: 00007fff556a8ac0 RDI: 00000000ffffff9c
[  135.911853] RBP: 0000000000000263 R08: 0000000000000000 R09: 0000000000000064
[  135.911855] R10: 0000000000000000 R11: 0000000000000246 R12: 00007fff556a8a30
[  135.911856] R13: 000055ef2c27f013 R14: 00000000000003e8 R15: 00000000000002df
[  135.911858]  </TASK>


