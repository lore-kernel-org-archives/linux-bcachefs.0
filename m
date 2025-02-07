Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3377223C8C3
	for <linux-bcachefs@vger.kernel.org>; Fri,  7 Feb 2025 21:50:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738965026; cv=none; b=s/jwGlKvMRFdgSdwPOhDl7OrnupOQzJwDI/iM/Qf8s4U+S5nvv2Gwf93MKIotbnTmTfnF3WVhlkkROIsJ906g96qCtOCgrZ4Giy1TKsuE7ZxJPuQZq6BIwcMr3ZnieRelRlKHr8R5DF5h58CPwxLFwioa5HnEmDKR8RlpfncUT8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738965026; c=relaxed/simple;
	bh=DaiuwdXV+e5Udz/gDTYrC6Cm/Dr7M9iTNsCd5vdoSwQ=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=uDrJUKw0ktlDYFEtWfVglcz2os+pI3aQGIymCnJ+eZDOXFhWQ4SVlByfQu0UQaLp9zVAJKijb2x+UL4T34K70Cj7svQHryumJxBt2rCrBYolqqCs65sta0Ptf5ZZWIymSQEt2DhCYmtbBkZfsU1W38nqGdMwK9P5mQLMEHiUng4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=fgRmdMR5; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="fgRmdMR5"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1738965023;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Wt/rhXICuGKPz6p+qSVDOoOIpUebsnzqpQhWZ7aI0s4=;
	b=fgRmdMR56bPKO+a5eKrijsyQt5xqOgzoSPtvN2ywMrJv+MxkPYbwWTGZLxsTVJUjtPqwEl
	oBAAsPgTJPIrs9aPDVuq3b7Iuhq0VPxpzxDXgjRg6KfkV5oqmffm3vWOMHT4/Axx3AMF5h
	FdoNKHNgPOFgxJ8BScRkCateISsakyA=
Received: from mail-pl1-f198.google.com (mail-pl1-f198.google.com
 [209.85.214.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-492-4maRqld0NXGlFH4CKBh38w-1; Fri, 07 Feb 2025 16:50:21 -0500
X-MC-Unique: 4maRqld0NXGlFH4CKBh38w-1
X-Mimecast-MFC-AGG-ID: 4maRqld0NXGlFH4CKBh38w
Received: by mail-pl1-f198.google.com with SMTP id d9443c01a7336-21f5067e443so20717035ad.0
        for <linux-bcachefs@vger.kernel.org>; Fri, 07 Feb 2025 13:50:17 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738965017; x=1739569817;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Wt/rhXICuGKPz6p+qSVDOoOIpUebsnzqpQhWZ7aI0s4=;
        b=BZEC5tl1C/tOb/o9Ai8MfWxbJUB4aAilvkImZGQQ9o3i2mMB9Lt9w63xDUMbCiFV4t
         qDlZOdK5vpwPElvnOTBm/MnT9OKxr96u3BIg+GzC0KXgRCwUoPn0/Vu5xkHPuoliDk1m
         vzdzhrwC2m8hIAGVr9j+b+JyriHSzBGOFprJeJR6a+NdVEXisPWuGJnE5OTEyoMOV93U
         P0fStxSO5+p06ISBZBUXGpMBKzYGtvDtrADdG1p8q+KnvlGocsI6c4SUEWI92pebWN7c
         254zfuoTvEyWsFbNC09SpyOPjkGSaGeMGRHPgf7Sjg63eRIEjC00mB5sy9jVsMSWGWwp
         xfjw==
X-Forwarded-Encrypted: i=1; AJvYcCUM3zWlwoPVbP1amM1iVJtQqrrIrJF1kAR5kvFihtsVAZX8y39b9DAAGwG/mcypPGFMisMohdBCHI+vxmzM2w==@vger.kernel.org
X-Gm-Message-State: AOJu0YwiufvNAlrS0YZFngkGlbZxY3jMmOIScl7tuUMWvzlAcz7Qjbtt
	58Th+3kpx+KZLaP9daYmm9Uzj5UYEE8WPx5n8cldp2vnD7tYND7qHDF5ZecqSTwGn//gfRW/f+n
	TmIuTYnKiVfJu5ySfXF4j7/ywusdmg4o0H1zlIIE6OG8Cmm80wZc1QIfGI88G5pdyY0nUvMCSbW
	sceWW8MUpjuORHTfi8eFSl12bfS1jj0wvIKuDNZKM=
X-Gm-Gg: ASbGncsdeQdQlyMS7EnaDW+ojZXyt9rVfeU/rATkqoqblO13yfx0Zj6mx8Gyu89RlxQ
	tYPDbpuGfjO1+MXW2Bt6oXxSszL9/FX++HQeZ6LFfsyE8ErW7qiP5uJve2fCN
X-Received: by 2002:a17:903:1108:b0:21f:4c8b:c4de with SMTP id d9443c01a7336-21f4e7428e7mr75240125ad.42.1738965016960;
        Fri, 07 Feb 2025 13:50:16 -0800 (PST)
X-Google-Smtp-Source: AGHT+IGMvuVYzR38ErU+ifgu+mCfqp/ihxTEzre+fWzUScLMCCUFSChUFoi8+zuc1opaccCYbwst09rlbD+RHdPBbw4=
X-Received: by 2002:a17:903:1108:b0:21f:4c8b:c4de with SMTP id
 d9443c01a7336-21f4e7428e7mr75239895ad.42.1738965016621; Fri, 07 Feb 2025
 13:50:16 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250128163859.1883260-1-agruenba@redhat.com> <yoxmbxirfwr6tpl4lp3jnnb26ef3omhjna5b7p4d6522xvmnco@3eajr5hkfmhp>
In-Reply-To: <yoxmbxirfwr6tpl4lp3jnnb26ef3omhjna5b7p4d6522xvmnco@3eajr5hkfmhp>
From: Andreas Gruenbacher <agruenba@redhat.com>
Date: Fri, 7 Feb 2025 22:50:05 +0100
X-Gm-Features: AWEUYZmF6nIf5aRYDSSXBkpBUfXVGKwt-1ffEK-4nKvj6uOlvVkZ8k7qSvT4pQk
Message-ID: <CAHc6FU5DDKga1ma72Dnvsj23DLJ3GyMd-CM0qx83EKhvo5p2ow@mail.gmail.com>
Subject: Re: [PATCH 00/21] bcachefs: eytzinger code
To: Kent Overstreet <kent.overstreet@linux.dev>
Cc: Shuah Khan <shuah@kernel.org>, linux-bcachefs@vger.kernel.org, 
	linux-kselftest@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Feb 7, 2025 at 7:56=E2=80=AFPM Kent Overstreet
<kent.overstreet@linux.dev> wrote:
> On Tue, Jan 28, 2025 at 05:38:37PM +0100, Andreas Gruenbacher wrote:
> > Kent, to continue our discussion from last November, I've gone through
> > more parts of the eytzinger code and as a result, here are some patches
> > for you to consider.
> >
> > What I've not looked at are the eytzinger_to_inorder and
> > inorder_to_eytzinger functions, as well as the implementation of sort.
> > Those functions could use a bit more documentation, but the code iself
> > looks reasonable.
> >
> >
> > Shuah, I've also had a quick look at converting the tests into kernel
> > selftests, but that hasn't gone very far because of the lack of support
> > for basic functions like __fls(), __ffs(), ffz(), and
> > rounddown_pow_of_two() in selftests.  Are there any plans for making
> > those kinds of primitives generally available to selftests?
>
> Ping on this patchset - can you throw up a git repo that's ready to be
> applied directly, and have you run the test that failed yourself to
> confirm the fix?

Did you miss this message?

  https://lore.kernel.org/linux-bcachefs/20250130103400.1899121-1-agruenba@=
redhat.com/

The test results at:

  https://evilpiepirate.org/~testdashboard/ci?user=3Dkmo&branch=3Deytzinger

are still for the initial version, but I've applied the fix right away:

  https://git.kernel.org/pub/scm/linux/kernel/git/agruen/linux.git/log/?h=
=3Dbcachefs

On top of that, I've got a small patch that adds eytzinger0_find self
tests. That patch still needs testing before I can post it, though.

Oh, and let me warn you about "bcachefs: Run the eytzinger tests on
modprobe" again: this really is FOR DEBUGGING ONLY, so please do not
merge.

Thanks,
Andreas



> Also, I'll make an exception for this patchset if need be, but fyi:
> in the future I'm getting out of the game of running tests for people.
>
> Either run ktest locally, or get redhat to chip in on the cluster and
> I'll give you CI access (and I highly reccomend that option, it'll get
> you quick feedback with a nice dashboard and you can use it for non
> bcachefs work as well).
>

