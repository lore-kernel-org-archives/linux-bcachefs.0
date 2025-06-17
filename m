Received: from mail-lj1-f173.google.com (mail-lj1-f173.google.com [209.85.208.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6536253F28
	for <linux-bcachefs@vger.kernel.org>; Tue, 17 Jun 2025 14:56:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750172179; cv=none; b=tSeYGywDxJyMIZE6r3pX3xTXg6tQ4PiXPQD+/y1z/yVPUif9EtJk0we1gK+IauKbqm9hvDyboFmthAzc1tBZaEd6CP+cKi9FzIpZfavgQ3s+R058+PK4oQKQ3bbuUhI2ofcDhtyoI3x0Zs26iBJESNIsQlm6395SgACEyWF65zk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750172179; c=relaxed/simple;
	bh=gV4DJ+lL/om03MXcXqS/UHC7yofM5m3b8Xka6Bu2AO8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=JQngKaXDPfLH1CWC/1sbWnx3ac6xv8ZpAtaQMSay3tP/T+DiNB9DQopoI6KrV+PQHrGkJX1TT6lUIyAdf4vmTxMm/8Yrg7w8PV14UzuEhp+3n2xKzhKtlvGc40rsguR7kiGxDxwEXq/aNsGZa3GByzr3NYjcevXJlRGAsd6HqVU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ho7vWd55; arc=none smtp.client-ip=209.85.208.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ho7vWd55"
Received: by mail-lj1-f173.google.com with SMTP id 38308e7fff4ca-32918fe5334so53548851fa.1
        for <linux-bcachefs@vger.kernel.org>; Tue, 17 Jun 2025 07:56:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1750172176; x=1750776976; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=g/58cyerKIrPENNnMiGeRWubbnaxbktVEBpqtUFfVao=;
        b=ho7vWd55zWahQAe9mZgc2an+p7DTCLjK0Rbu6uy5uEVKWUSb+d49lSfUD9GDyh0fw6
         mZtmUBgeVS0x5xFkhDWQh37t4gRO+bl+Ba0tV0uf9MqCb8lUmsYlmPn/DH7or/EMCCYl
         Vu+7360dwhWFbkNGRTb5v651A0R3ajm5PMoyprT7DUW0e0hyQZEQHr6c4V5DX08inC4Y
         KccA3F46QaetvIWny3xNgkN/9tAX/htFII41y5l7IpJi+gt0RmF43XzalXnVjSxTHBHy
         Dj3rS0QS8EKOKcMEf5wABDH9l3UY3CmYP5JldSO0BaA6FD9tiERnfdaRMVL8CSZ2sI3L
         GxXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750172176; x=1750776976;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=g/58cyerKIrPENNnMiGeRWubbnaxbktVEBpqtUFfVao=;
        b=IKo3BRgj+XfiAgITO7wcsJOYhwsoiz3AUTYv+lBTPM7gumJ91lqTwO9Odln2GKhr6M
         rRWIUvyPysuwC/p69VKZkpe3w5xjAHlPZHmcHdXUOCrjhQOAqsySDCegSF+5uKma34rW
         jUbA2YvkeBP1TDFqCE5fvwS1VYehk/ajGNHZTRbQmiZx3dKYHvzA4HmqEdmqQdN/IWWY
         liSc6ToA8PcpszgLHgTABYFAJla91vWhJzIW+ROt2ybXS/ZlRcofkz9h1EG8F2ugJVol
         S2ALnUFKsf4X5E8RC5H1wzeMeFo3vuEAYXbbhVYH8HyLMJnbRW3Sb3M/iHiIfWf6ATgw
         CtnA==
X-Gm-Message-State: AOJu0YyKjqFmGI0eCoA4KzlcGEG6p5FlEAvFf6X9fr3n8AUJrgPfVZyh
	CKZ5G3LYlrgQRDxc3ftddnFXHFWRdGew+x2rrE7KsWVsv847pFA54RWV1y8pSR+J7MoFqV02exA
	pFUmTpRehoBwIyadIlz7wBKV446yUqGc=
X-Gm-Gg: ASbGncsDv/jhswx5uJ5UG5I7Kchbcd19gZmohoQmcw2zqnwFCsJqQaWZDj6bw75+KAm
	k2P4ojVJSLmhm+EOhEbaJ7Fz48gVHbbaIOw4c4rti3DkDsnfbF2BKo/opImExGB09Cq+2RdxCH/
	H3UGcXDckNNpz3k+DNJxOnIAWKGEm958mmYUbg4+9USQ==
X-Google-Smtp-Source: AGHT+IFfQWlILoLjQ1htLTHkvk0RnqWGOY9sfhQsr5vQH2idsIDzR//qvv/3MKTs1raSMOumD8t3h1SuR+DtXLmc3A4=
X-Received: by 2002:a05:651c:305a:b0:32b:7389:583 with SMTP id
 38308e7fff4ca-32b73890aaamr4580941fa.17.1750172175625; Tue, 17 Jun 2025
 07:56:15 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250617134120.102668-1-sunjunchao2870@gmail.com> <vigtvcnui66u4h2btagyohhsg5zvvuxmk5snidenqs353dwiwm@sxex5z7pnwkg>
In-Reply-To: <vigtvcnui66u4h2btagyohhsg5zvvuxmk5snidenqs353dwiwm@sxex5z7pnwkg>
From: Julian Sun <sunjunchao2870@gmail.com>
Date: Tue, 17 Jun 2025 22:56:03 +0800
X-Gm-Features: AX0GCFtAJqQKfr3bJGGO5CDWJbjMyoJDl4PKwTvWuKtJysiFg6Pyc6JeXt3x0O4
Message-ID: <CAHB1Nais7Hgu+oQSjptXj1w8c6CJPqJhYrah-wVASCCL_+oODw@mail.gmail.com>
Subject: Re: [PATCH] bcachefs: Return EROFS for BCH_IOCTL_DATA ioctl requests
 in ro mount mode.
To: Kent Overstreet <kent.overstreet@linux.dev>
Cc: linux-bcachefs@vger.kernel.org, 
	syzbot+56edda805363e0a093b8@syzkaller.appspotmail.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Jun 17, 2025 at 10:04=E2=80=AFPM Kent Overstreet
<kent.overstreet@linux.dev> wrote:
>
> On Tue, Jun 17, 2025 at 09:41:20PM +0800, Julian Sun wrote:
> > Recently, syzkaller reported the following issue:
> >
> > BUG: kernel NULL pointer dereference, address: 0000000000000000
> > Call Trace:
> >  <TASK>
> >  mempool_alloc_noprof+0x1a7/0x510 mm/mempool.c:402
> >  bch2_btree_update_start+0x549/0x1480 fs/bcachefs/btree_update_interior=
.c:1194
> >  bch2_btree_node_rewrite+0x17e/0x1120 fs/bcachefs/btree_update_interior=
.c:2208
> >  bch2_move_btree+0x6f0/0xc70 fs/bcachefs/move.c:1093
> >  bch2_scan_old_btree_nodes+0x95/0x240 fs/bcachefs/move.c:1215
> >  bch2_data_job+0x646/0x910 fs/bcachefs/move.c:1354
> >  bch2_data_thread+0x8f/0x1d0 fs/bcachefs/chardev.c:315
> >  kthread+0x711/0x8a0 kernel/kthread.c:464
> >  ret_from_fork+0x3fc/0x770 arch/x86/kernel/process.c:148
> >  ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245
> >
> > This is because after commit d4d71b58e513 ("bcachefs: RO mounts now use=
 less memory"),
> > read-only mounts no longer initialize btree_interior_update_pool, which=
 is required for
> > processing BCH_IOCTL_DATA requests.
>
> Alan already gave me a better fix for this. You pretty much never want
> to just check if the filesystem is ro or rw - that would be racy, that
> can change at any time. If you need the filesystem to be rw, you do it
> by getting a write ref (which may fail).
>
> Just checking SB_RDONLY here would be "technically" correct since we
> only need the mempool, which is's never deallocated until filesystem
> teardown, and the interior update path should get its own ref on
> c->writes before doing anything serious.
>
> But it's bad form, because then other code changes might go "ok, we've
> checked that we're RW, we're safe" - but we're actually not.
>
> And, I'm just now noticing that bch2_btree_update_start() actually does
> not get a ref on c->writes, so we might want to fix that - or move.c
> needs to be getting a write ref, or both.
>
> c->writes is a percpu refcount, so it's dirt cheap, there's generally
> zero downside to taking a ref even if an upper layer already has one.
> The only exception is if it's an internal operation that needs to run
> when we're going RO - but we have a flag for that,
> BCH_TRANS_COMMIT_no_check_rw, which bch2_btree_update_start() can check.
>
> The other consideration with write refs is that we don't want to be
> holding them for an unbounded duration, because that will block going RO
> - so I think bch2_ioctl_data() actually wasn't the best place for this,
> we should be checking if we're RW in move.c, every time we kick off an
> op.

Thanks for your detailed explanation, this makes sense to me.

--=20
Julian Sun <sunjunchao2870@gmail.com>
