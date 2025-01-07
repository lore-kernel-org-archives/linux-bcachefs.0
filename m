Received: from mail-lj1-f176.google.com (mail-lj1-f176.google.com [209.85.208.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F41401F37C5
	for <linux-bcachefs@vger.kernel.org>; Tue,  7 Jan 2025 15:02:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736262136; cv=none; b=Op835rGgt0qpPzjNjWGm02v1q1KCnK15OhwIzJR1JdM9m0qy4iWfVwDONPsoW/2CvYUDIZ+ZFcMPAyvdbrj7Dcn06DOudOpYeUr5gPRRTnVzVw2hKd32FKoj6IMdIIM6v9nLDz+LigXsQa2LwYVv/p3AoRSU+nr1igjK0FrQ2hg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736262136; c=relaxed/simple;
	bh=qn54r7b/FPvqG+wIWbKHM+U2+Iy6nU1wZqTzHTYLfX8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ZDoOVII74qDjFEf5JvSWIxDMPsFMG+TNEXcvN296Fbgv/5X9aSJOmcZ4l/kYmR8YxmnmAf90eYAAv4YrDJ720A9I6OJYR314gJt1tJ5nBIuk8Q+h3PN+7HLVdVV4+VYcn1EHBGqISwwMlp7JJm8MhxjST/fod0nFjd/kaNff9ms=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=r3OwLkH3; arc=none smtp.client-ip=209.85.208.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="r3OwLkH3"
Received: by mail-lj1-f176.google.com with SMTP id 38308e7fff4ca-3003c0c43c0so175482261fa.1
        for <linux-bcachefs@vger.kernel.org>; Tue, 07 Jan 2025 07:02:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1736262131; x=1736866931; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=B4NFkD0rEkCSEXl+KvjNag5xKUayGF3vAjhwLPDSB24=;
        b=r3OwLkH3b7wB1KWIw0z+JXmz2PPWqEAVZiovTHbUqZY6n6bZVzOcA6Fvarxgd0oU+K
         26BCJHLLuQnNhXnFxU82p45NV01G5UIEkOQ3ku9K2Jwh0roHPiDtM3IxqMbmC/7eLLFD
         DrW/eAfepQ51/U6kwamz+pHX+iikBaZzCz6yobm3/Dl3WDAzo7u8XHsrpH6mGdLgAFpX
         uM+pf0Gi7hVpuNVZnCpICOQUagCUDpIyWhkttqoNOD1No2GOizgXAm3seR2zZXBQMIjC
         jx8CMYRyoz1s25ipnZS40XX8H66S0x9qu5WPH9tObDMqHq0AkaK0qm5jvDakxMqrHPm3
         FHXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736262131; x=1736866931;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=B4NFkD0rEkCSEXl+KvjNag5xKUayGF3vAjhwLPDSB24=;
        b=nQbt0cr4YpJ+FEMWENZ0Ob1O/9djxi6MrnO3YniC6o9xB40IMAMk4RE63E2h/IV8mR
         eIQAd9zT/Vh9gyQ8OBtqQStlfUVOOLGvyNnzUizi6VDXcLWPb6r65dHBdcyDNI4+eUXI
         fQjyRSRezC+InIARsDshLXkNETtP3WE4SIjJoZIYz+Xw5tlT7rrhTzIDLfLQVmkQDK6X
         6nOjfj3IrF5naN6uxrGqPMJdtrZ5JowB508tKM6BKnmlLQV90REukQLpQrGyQrOP+Y7w
         feEs+phWVB/mkmbzsk494Rn/lEuzfsGa1o4N6sKNPRWoiGBekj91vSffZfSyVaf81acq
         y0qw==
X-Forwarded-Encrypted: i=1; AJvYcCXmHCiF8+JN6eW/nzjdQE2DTq5ClfqaMYnsPqOaHRMsneubnomL4/KFOiAeIzvFbISjSgrIMdOY8OPKuZi52g==@vger.kernel.org
X-Gm-Message-State: AOJu0YyXdvYMEIlyrgSNlZwwjo/jkg4OqWLx2WNXapsjkv7rnUPmDMoh
	8sSqr+B/+9zBI6v0Kq/iPHRnEbV6kHqd+d1Ny1dJ2AEyKp91GVaKmSCWccDgNc5+fnAIspd25B3
	UUhUhmQU8/JSpCGZ0Z9A7pbf2YG5YF0yPmsmuXTIb8+puReqBgQ==
X-Gm-Gg: ASbGnct6HA3vu7sNSRcJb9+547pHRp4mQWb5nguPQM56lHYlClaZSSi2OhkILC+vamx
	dyAPznM4QiXutTKRHA9oIBuOozJ/fzZEX1R87ECjJqPqCLtEbyswL8dDkkHOHQhrswQyo
X-Google-Smtp-Source: AGHT+IH77BZtNxs56HxjJevmIWr110IXTMZWvZwh3ineB+d6k9t8VaK9SeeHC/nFvCt6ylQ/U3p48bJi/cpm2SmP53s=
X-Received: by 2002:a05:651c:546:b0:300:3fef:a9e8 with SMTP id
 38308e7fff4ca-30468608a62mr224707231fa.28.1736262130601; Tue, 07 Jan 2025
 07:02:10 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <AOAA*AACIqMsH7SiGMkHgaoE.1.1734695024950.Hmail.3014218099@tju.edu.cn>
 <Z2V21UH_3FuNDoa1@casper.infradead.org> <3gs6aqeby2ymbuhdw3lytsdcl5qigg6ekzox6uejosfodr4xau@dtks66rjrnxa>
In-Reply-To: <3gs6aqeby2ymbuhdw3lytsdcl5qigg6ekzox6uejosfodr4xau@dtks66rjrnxa>
From: Dmitry Vyukov <dvyukov@google.com>
Date: Tue, 7 Jan 2025 16:01:59 +0100
X-Gm-Features: AbW1kvYGtu-nxsDjN_tT475qykNBzxAuFhFNxMVVDDEWF4en7ds5ZIp0f7s23VM
Message-ID: <CACT4Y+bE4j4xtua2egPNhzSomO5k=MVT-xN8NNmWUy_vGM=T+A@mail.gmail.com>
Subject: Re: Kernel bug: "general protection fault in bch2_btree_path_traverse_one"
To: Kent Overstreet <kent.overstreet@linux.dev>
Cc: Matthew Wilcox <willy@infradead.org>, Haichi Wang <wanghaichi@tju.edu.cn>, 
	dave.hansen@linux.intel.com, brauner@kernel.org, hpa@zytor.com, 
	viro@zeniv.linux.org.uk, linux-fsdevel@vger.kernel.org, tglx@linutronix.de, 
	bp@alien8.de, linux-bcachefs@vger.kernel.org, linux-kernel@vger.kernel.org, 
	luto@kernel.org, x86@kernel.org, mingo@redhat.com, jack@suse.cz, 
	syzkaller@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

On Fri, 20 Dec 2024 at 16:01, Kent Overstreet <kent.overstreet@linux.dev> wrote:
>
> On Fri, Dec 20, 2024 at 01:53:25PM +0000, Matthew Wilcox wrote:
> > On Fri, Dec 20, 2024 at 07:43:44PM +0800, Haichi Wang wrote:
> > > Dear Linux maintainers and reviewers:
> > > We are reporting a Linux kernel bug titled **general protection fault in bch2_btree_path_traverse_one**, discovered using a modified version of Syzkaller.
> >
> > No, you aren't.  This is a terrible bug report, and you seem to have
> > sent several with the same defects.  First, read:
> >
> > https://blog.regehr.org/archives/2037
> >
> > Then, specifically to reporting a kernel bug *LOOK AT HOW OTHER PEOPLE
> > DO IT*.  Your email includes lots of stuff that is of no help and
> > doesn't include the most important thing -- the kernel logs from around
> > the time of the failure.
> >
> > > ### Affected Files
> > > The affected files, as obtained from the VM log, are listed below. The corresponding maintainers were identified using `./scripts/get_maintainer.pl`:
> > > fs/bcachefs/btree_update_interior.c
> > > fs/bcachefs/alloc_foreground.c
> > > fs/bcachefs/btree_iter.c
> > > fs/bcachefs/btree_trans_commit.c
> > > fs/namespace.c
> > > arch/x86/entry/common.c
> > > fs/bcachefs/recovery.c
> > > fs/bcachefs/recovery_passes.c
> > > fs/bcachefs/super.c
> > > fs/bcachefs/fs.c
> > > fs/super.c
> >
> > This is useless.
> >
> > > ### Kernel Versions
> > > - **Kernel Version Tested:** v6.12-rc6:59b723cd2adbac2a34fc8e12c74ae26ae45bf230
> > > - **Latest Kernel Version Reproduced On:** f44d154d6e3d633d4c49a5d6a8aed0e4684ae25e
> >
> > Useful
> >
> > > ### Environment Details
> > > - **QEMU Version:** QEMU emulator version 4.2.1 (Debian 1:4.2-3ubuntu6.29)
> > > - **GCC Version:** gcc (Ubuntu 11.4.0-2ubuntu1~20.04) 11.4.0
> > > - **Syzkaller Version:** 2b3ef1577cde5da4fd1f7ece079731e140351177
> >
> > Useful
> >
> > > ### Attached Files
> > > We have attached the following files to assist in reproducing and diagnosing the bug:
> > > - **Bug Title:** `bugtitle`
> > > - **Bug Report:** `report`
> > > - **Machine Information:** `machineInfo`
> > > - **Kernel Config:** `config`
> > > - **Compiled Kernel Image:** `vmlinux`
> >
> > You didn't attach these things, but please don't.
> >
> > We want the stacktrace.  Preferably passed through
> > scripts/decode_stacktrace.sh so we get nice symbols.
>
> I'm not at all clear on why we need a syzbot copycat project - why not
> just work with those guys and contribute whatever improvements you have
> there?
>
> I've been doing some work with the syzbot folks on ktest integration so
> I can reproduce syzbot bugs in a single command - I'm not going to redo
> that work for a second backend.

Can't +1 this more :)

Forking projects is not that useful.
