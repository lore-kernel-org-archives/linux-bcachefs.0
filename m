Received: from mail-pl1-f171.google.com (mail-pl1-f171.google.com [209.85.214.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E985A2E62BE;
	Tue, 24 Jun 2025 17:32:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750786326; cv=none; b=sNr9FDn1ywCJ+SCGCfDMMFYRW1K22T0P+KTrn08MIwymqb7+rURmHGkulv/DrlIbcdm50hbhtmUCr7gb8zWH0MBVsc99QqPEFhmO3DogTsk4hFeOvLE5t5Cip9tqMe3iQ9ZqLw/L2DgYKQu0Vbhh5CpGCOs7L4HcJI5kCfV1RIo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750786326; c=relaxed/simple;
	bh=MkMVRzH6B8JkynhJ+tzxzhs5H1wVoQ+sGOr6zlDs15g=;
	h=Content-Type:Mime-Version:Subject:From:In-Reply-To:Date:Cc:
	 Message-Id:References:To; b=S6A7SEo7ANHO/04wS6fwl8+4Btkaq+qrz3RFh556qmRqoqb/bVr/jJMWceIByIbFhITs6rEITXyoSi3TN3CTUdA2EOWr930iULowrhX3mAnIfNcWEPcfGlhUXdF3xSfWqy4Bb9ZWCCYXWYb8OzoeEYXuchiF96kkbNNO+4VF8Cw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=RzTKDPq4; arc=none smtp.client-ip=209.85.214.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="RzTKDPq4"
Received: by mail-pl1-f171.google.com with SMTP id d9443c01a7336-23636167afeso60559795ad.3;
        Tue, 24 Jun 2025 10:32:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1750786324; x=1751391124; darn=vger.kernel.org;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=FsGzqWWnR4Y26m2B6AT3zOMnGpuESkyDGh2hafVcYl0=;
        b=RzTKDPq4T4bjJzry3YSHfsSTSf7D3zIDqrkLV33r9y+T0d33b8GvuEgOJexq1mVlrY
         iN6/NJc9yXxNSSd1FCg4+12XDpg3PMb2fHIgfiJd79hUGkxX8Nha26vAReLj8UNQs/LY
         C2wW1wt+vkdLCwVS/JnnJ+NWB5y7OMwqdpVPAFOFP7/FYBqh7miXn6JeSuqT1fPeDak0
         BhqD2zfXF+nr3xf5w6j5nIbUvIn4QOg1gzv9Hgyj4jUs7rvbFCAAOvhv7b+dl2aWXD5U
         xWi33P79fqLfWc7OCJQDFjzLZ97PDdADndKW6+rXQVQINv9IRrKqvoEJiafwh80IcikB
         +fFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750786324; x=1751391124;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=FsGzqWWnR4Y26m2B6AT3zOMnGpuESkyDGh2hafVcYl0=;
        b=mt6GW42UhsIoFWxaYAB+OCpLeBdwPpckIqefh7HczUf3Yh0uW0veyoXz36RKf1iGCV
         +6lsc14k9Ce3vEDVTG2bYYvMPGUU/xgFfb85z0CKAlQ6QQoT4bmuG9uMsbSmF1XND6w8
         be/KVSh5nERsrCAl/3gMkr+7OFh5j1RsoNa2EQexKu0doO1+qCjNyHzgaKVLYC0eUx/V
         gXhhggT/Q/I0YVqi2nRgDaOQd4Ct27RIQ5C+YNLkKhdEmUp6YP1Qy+tmvcWv1v4JKkx7
         vyLJhE7ellQbV3NCrsid9nc6rxrqzRiGlmnnAd0tPVJ5sFXgBniA33vMTQtaWo7tjEVv
         oI0w==
X-Forwarded-Encrypted: i=1; AJvYcCUVzbWy/U/qTFvYTGlEXZWVYvp120+8fX61mImqKxVpUiKFrbd7xhYtKxOiNJnjQOvsegFLFSAei6K/x7HdEA==@vger.kernel.org, AJvYcCUZsc/bZE6jclhSUqzyw7w8k6WltZ2Nuxi/emzJKDoekJUu/K5S3TrRmU7H/TW9gNN4M6ri/ha1a3kOajTZ@vger.kernel.org
X-Gm-Message-State: AOJu0YwlkEcEo6MsadfXjGujwEdmBP4idbsPkyU4I9ZWHx82HmOuCiX7
	Ipi4pt1wQCsCNFLsECa144AMDCb8OuEb83nJucIn/mqxRnTWMzo0BKGITefVjw==
X-Gm-Gg: ASbGncu9szTG3tWg/hV7nsBZ/jWHkSjjRRhKsIS/2m39xU3Je+sBeg6eygraCEw98FF
	mS4p0pyVl9dzr5lxzpX2+90qenGmmsRJsDgoG/ysR0edCHOEgM79C8jUkHY1n/7v+TOPLxNOyJl
	tlREq5VwhHObrv8iWHxIeOyalFlABh7arz/CiyoZ9YnXx2cnq8Iq+zMy05Um4XLbxIkboE2FQn2
	4ChePwkn6KRgAaoig17tR8FiIZWXOK/o2ul9NTtwQx9ADlx5T5lOnZEzeycFuCZ1r8eSeulcUa9
	a5edM7DmlzVgApZvNQm67Qxt9OiFXyg6Ybd48bn3GcSihA==
X-Google-Smtp-Source: AGHT+IGxJ4+GI30utHJuEh5+BFK0aG7kpbrvHL15PsQs7LuCCGIfAqOxTUrShAy5bKyQSTnqVED+kA==
X-Received: by 2002:a17:903:1aac:b0:234:aa98:7d3e with SMTP id d9443c01a7336-2382403df49mr2545345ad.29.1750786324111;
        Tue, 24 Jun 2025 10:32:04 -0700 (PDT)
Received: from smtpclient.apple ([2402:d0c0:11:86::1])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-237d86c5a7dsm113199515ad.201.2025.06.24.10.32.01
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 24 Jun 2025 10:32:03 -0700 (PDT)
Content-Type: text/plain;
	charset=utf-8
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3826.500.181.1.5\))
Subject: Re: [syzbot] Monthly bcachefs report (Jun 2025)
From: Alan Huang <mmpgouride@gmail.com>
In-Reply-To: <tbin6tz26snfbzztmhixz236hkyezv35honrdzzpi3rkgu4toq@kahnaeehxnul>
Date: Wed, 25 Jun 2025 01:31:48 +0800
Cc: syzbot <syzbot+listdc301befec0a5cb43b3e@syzkaller.appspotmail.com>,
 linux-bcachefs@vger.kernel.org,
 linux-kernel@vger.kernel.org,
 syzkaller-bugs@googlegroups.com
Content-Transfer-Encoding: quoted-printable
Message-Id: <A1DDE301-FA03-4804-BD70-7C57A921D0F1@gmail.com>
References: <685a562f.a00a0220.2e5631.005e.GAE@google.com>
 <tbin6tz26snfbzztmhixz236hkyezv35honrdzzpi3rkgu4toq@kahnaeehxnul>
To: Kent Overstreet <kent.overstreet@linux.dev>
X-Mailer: Apple Mail (2.3826.500.181.1.5)

On Jun 25, 2025, at 00:36, Kent Overstreet <kent.overstreet@linux.dev> =
wrote:
>=20
> On Tue, Jun 24, 2025 at 12:39:27AM -0700, syzbot wrote:
>> Hello bcachefs maintainers/developers,
>>=20
>> This is a 31-day syzbot report for the bcachefs subsystem.
>> All related reports/information can be found at:
>> https://syzkaller.appspot.com/upstream/s/bcachefs
>>=20
>> During the period, 15 new issues were detected and 8 were fixed.
>> In total, 102 issues are still open and 190 have already been fixed.
>>=20
>> Some of the still happening issues:
>=20
> Most of these are not terribly concerning, but...
>=20
>>=20
>> Ref  Crashes Repro Title
>> <1>  30829   Yes   INFO: task hung in bch2_copygc_stop
>>                   =
https://syzkaller.appspot.com/bug?extid=3Dc6fd966ebbdea1e8ff08
>> <2>  7874    Yes   INFO: task hung in __closure_sync
>>                   =
https://syzkaller.appspot.com/bug?extid=3D7bf808f7fe4a6549f36e
>> <3>  3875    Yes   WARNING in bch2_trans_srcu_unlock
>>                   =
https://syzkaller.appspot.com/bug?extid=3D1e515cab343dbe5aa38a
>> <4>  1497    Yes   INFO: task hung in __bch2_fs_stop
>>                   =
https://syzkaller.appspot.com/bug?extid=3D6d3e28b33490b3085412
>> <5>  1236    Yes   INFO: task hung in bch2_journal_reclaim_thread (2)
>>                   =
https://syzkaller.appspot.com/bug?extid=3D820dc3b465c69f766a57
>> <6>  442     Yes   WARNING in bch2_trans_put
>=20
>=20
> this one
>=20
>>                   =
https://syzkaller.appspot.com/bug?extid=3D291aef749c5cbb9ca2fd
>> <7>  361     Yes   kernel panic: trans should be locked, unlocked by =
bch2_btree_update_start
>=20
> we want these locking bugs gone.
>=20
> ok this one is a bug users hit - I thought locking was fully sorted in
> 6.16, but apparently not.
>=20
> Previously, the locking bugs (especially in 6.14) were showing up in
> bch2_dev_metadata_drop(), which uses old style btree node iterators =
that
> do a DFS btree walk.
>=20
> Modern code just walks one level of the btree at a time, using
> bch2_btree_iter_peek() - there's much less special purpose code and
> strange corner cases this way.
>=20
> So it looks like this is another instance of that - bch2_move_btree() =
is
> using the old bch2_btree_iter_peek_node() code.
>=20
> Perhaps it's time to just delete all that stuff.
>=20
> bch2_move_btree() can probably be deleted and replaced with a call to
> bch2_move_data_btree() - that's part of the main data move path, and =
it
> recently gained the ability to walk keys in interior btree nodes.
>=20
> Looking at the stace, we have
> [   91.068473][ T5330] Kernel panic - not syncing: trans should be =
locked, unlocked by bch2_btree_update_start+0x1700/0x1dc0
> [   91.074232][ T5330] CPU: 0 UID: 0 PID: 5330 Comm: syz.0.0 Not =
tainted 6.16.0-rc1-syzkaller-00203-g4774cfe3543a #0 PREEMPT(full)=20
> [   91.079637][ T5330] Hardware name: QEMU Standard PC (Q35 + ICH9, =
2009), BIOS 1.16.3-debian-1.16.3-2~bpo12+1 04/01/2014
> [   91.085068][ T5330] Call Trace:
> [   91.086510][ T5330]  <TASK>
> [   91.087883][ T5330]  dump_stack_lvl+0x99/0x250
> [   91.090102][ T5330]  ? __asan_memcpy+0x40/0x70
> [   91.092501][ T5330]  ? __pfx_dump_stack_lvl+0x10/0x10
> [   91.095374][ T5330]  ? __pfx__printk+0x10/0x10
> [   91.097423][ T5330]  panic+0x2db/0x790
> [   91.099118][ T5330]  ? bch2_btree_update_start+0x1700/0x1dc0
> [   91.101917][ T5330]  ? bch2_move_btree+0x44e/0xc60
> [   91.104349][ T5330]  ? __pfx_panic+0x10/0x10
> [   91.106602][ T5330]  ? __closure_wake_up+0xa2/0xb0
> [   91.109239][ T5330]  ? bch2_btree_update_free+0x39e/0x3f0
> [   91.111867][ T5330]  ? bch2_btree_update_start+0x1700/0x1dc0
> [   91.114541][ T5330]  =
bch2_trans_unlocked_or_in_restart_error+0xb0/0x110
> [   91.117731][ T5330]  bch2_path_get+0x108c/0x1540
> [   91.120398][ T5330]  ? bch2_btree_node_rewrite+0x17e/0x1120
> [   91.123155][ T5330]  ? __pfx_bch2_btree_update_start+0x10/0x10
> [   91.125844][ T5330]  ? bch2_move_btree+0x44e/0xc60
> [   91.128330][ T5330]  ? __pfx_bch2_path_get+0x10/0x10
> [   91.131060][ T5330]  ? rcu_is_watching+0x15/0xb0
> [   91.135248][ T5330]  ? bch2_trans_downgrade+0x228/0x360
> [   91.137691][ T5330]  ? rcu_is_watching+0x15/0xb0
> [   91.139975][ T5330]  ? __bch2_btree_path_downgrade+0x35a/0x5e0
> [   91.143245][ T5330]  ? bch2_trans_node_iter_init+0x2d7/0x5e0
> [   91.146160][ T5330]  bch2_trans_node_iter_init+0x348/0x5e0
>=20
> So the real bug is that we're in a restart when we call
> bch2_trans_node_iter_init(), meaning we didn't call bch2_trans_begin()
> after we got a restart error.

We call bch2_trans_unlock() even If bch2_btree_reserve_get() at line =
1289 in bch2_btree_update_start returns error
After that, we return the error. See below.

>=20
> I do not see the bug on a cursory glance, but the code is trickier =
that
> it should be.
>=20
> We're aiming to get rid of this sort of open coded restart handling =
and
> bch2_trans_begin(0 calls; modern code generally uses lockrestart_do(),
> commit_do(), or a looping macro that does the restart handling itself =
-
> e.g. for_each_btree_key()
>=20
>        for (btree =3D start.btree;                                     =
                                                                         =
                     =20
>             btree <=3D min_t(unsigned, end.btree, btree_id_nr_alive(c) =
- 1);                                                                 =20=

>             btree ++) {                                                =
                                                                         =
                        =20
>                stats->pos =3D BBPOS(btree, POS_MIN);                   =
                                                                         =
    =20
>=20
>                if (!bch2_btree_id_root(c, btree)->b)                   =
                                                                         =
          =20
>                        continue;                                       =
                                                                         =
                         =20
>=20
>                bch2_trans_node_iter_init(trans, &iter, btree, POS_MIN, =
0, 0,                                                              =20
>                                          BTREE_ITER_prefetch);         =
                                                                         =
            =20
> retry:                                                                 =
                                                                         =
                            =20
>                ret =3D 0;                                              =
                                                                         =
                             =20
>                while (bch2_trans_begin(trans),                         =
                                                                         =
           =20
>                       (b =3D bch2_btree_iter_peek_node(trans, &iter)) =
&&                                                                       =
  =20
>                       !(ret =3D PTR_ERR_OR_ZERO(b))) {                 =
                                                                         =
      =20
>                        if (kthread && kthread_should_stop())           =
                                                                         =
       =20
>                                break;                                  =
                                                                         =
                          =20
>=20
>                        if ((cmp_int(btree, end.btree) ?:               =
                                                                         =
              =20
>                             bpos_cmp(b->key.k.p, end.pos)) > 0)        =
                                                                         =
      =20
>                                break;                                  =
                                                                         =
                          =20
>=20
>                        stats->pos =3D BBPOS(iter.btree_id, iter.pos);  =
                                                                         =
       =20
>=20
>                        if (!pred(c, arg, b, &io_opts, &data_opts))     =
                                                                         =
        =20
>                                goto next;                              =
                                                                         =
                        =20
>=20
>                        ret =3D bch2_btree_node_rewrite(trans, &iter, =
b, 0, 0) ?: ret;                                                         =
   =20
>                        if (bch2_err_matches(ret, =
BCH_ERR_transaction_restart))                                            =
               =20
>                                continue;                               =
                                                                         =
                         =20
>                        if (ret)                                        =
                                                                         =
                             =20
>                                break;     =20

Here, we break since it=E2=80=99s not a restart, so at this time, =
trans->locked is false.


>                                                                        =
                                                        =20
> next:                                                                  =
                                                                         =
                           =20
>                        bch2_btree_iter_next_node(trans, &iter);        =
                                                                         =
      =20
>                }                                                       =
                                                                         =
                              =20
>                if (bch2_err_matches(ret, BCH_ERR_transaction_restart)) =
                                                                  =20
>                        goto retry;                                     =
                                                                         =
                         =20
>=20
>                bch2_trans_iter_exit(trans, &iter);                     =
                                                                         =
            =20
>=20
>                if (kthread && kthread_should_stop())                   =
                                                                         =
       =20
>                        break;                                          =
                                                                         =
                          =20
>        }


