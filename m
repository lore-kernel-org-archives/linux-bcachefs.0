Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8058163
	for <linux-bcachefs@vger.kernel.org>; Sun, 24 Nov 2024 23:33:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732491210; cv=none; b=r9B6QVjZEGCyQm4rM1AV7u/04/ScTTbJp1GGGSemyaNasOZui9FWJneUzd2bgO4wS411qGt6TlE5KseHi+F2XlFoqK7EcfMcaZdLRv5D02t3s5A21oEc3cl3EN2hvuCfyLLfLeHzaUC+1NtS3STZknhALASReAbtWTXa04jeG2M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732491210; c=relaxed/simple;
	bh=VW34+SqsG3c3BT1/TEDL1gUL4fcVrWsomkKh1gtAlyg=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Uq2pXz0KD4Zffc+a1a/eXLvzgUV5W1GZcQbWB8AhhgSl7yxr0MNpPb8Ruzo98vXLKhj/6KjhzqvRKrbTf12XVaiSUojAH1Qm08c+/NIh1Pz8qfTPGoV/jUbg9qaTG86sHQHuqkBoK+ojnlOsPksfzg1t5yIOpjqm6NLg2Ebn8Y4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=a6CRIR4y; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="a6CRIR4y"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1732491205;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=3bQU8JKZP5su/9bCYxKNOWG/3W4z6AQA2bqgrC6ye5Q=;
	b=a6CRIR4yyitQ3+G6TROMMrRoMGoJg4yMomENiH7LdUq51qZ4Lp9R6VTME03lzOzYTtBwXf
	bnJpgkv0egOQmNva8wg5cM1P//NNPlUN+oKOO2MYlvK+tB+JWLh6iMyk+/ODYsuDUhiq22
	/iVHTZnTiDfXOnBxxOl28gDChfklZUo=
Received: from mail-pf1-f197.google.com (mail-pf1-f197.google.com
 [209.85.210.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-35-9vTuWpeoOBy-GXkiNRU7Wg-1; Sun, 24 Nov 2024 18:33:22 -0500
X-MC-Unique: 9vTuWpeoOBy-GXkiNRU7Wg-1
X-Mimecast-MFC-AGG-ID: 9vTuWpeoOBy-GXkiNRU7Wg
Received: by mail-pf1-f197.google.com with SMTP id d2e1a72fcca58-7250863ae6dso465450b3a.0
        for <linux-bcachefs@vger.kernel.org>; Sun, 24 Nov 2024 15:33:22 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732491202; x=1733096002;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=3bQU8JKZP5su/9bCYxKNOWG/3W4z6AQA2bqgrC6ye5Q=;
        b=syA1ONK2grCOPLauJ0aL77FKqEAP/lrN/Jr/KCTwLr6lYMX8331Br2Vx4KOjXDY4Zh
         HP/PWxaiKWZi91dBehZa9qKksn+okfsvMyaWMEM2hRCDyh0ZnMCZtpbZY0xhhQ3/mwe3
         +yqHAh96H7yiJqRRy7QRx/CKMylsTyf5H9+3VjKFW5Tofl9a9BQnygd2IV5YWV0iV+pR
         UCq0x6A++C3P3ztW56T9FgT4V0vUoVWJqeZliiz/bkkxd8fAWSf19MTF8l8tm6yO4Vcc
         tqzzJYrENmR4V8FK7jf18QBBFpn8zjkasnEa9ihSbAtgc1n25gmDXiXitOT8qtgWlO8Q
         nEqA==
X-Gm-Message-State: AOJu0YwTfx6H2/e9aQy5yTd/DSFPPgsGog8I5AnTuC/6RYK04L0zkCO4
	1QadJjjXClib9UV0bysk223BIBpjaXvGBysmQUi9S5BE2PB34u6G3TY0RMFEJBnIqgazv56sCI/
	7TlKesQsZITauK9i33xN+8rhN/PIQPDKe17gY5eb/G4u9qHHOsFjhYTzfl7m7Yg/6mj806Znf/f
	HKWWYqW8DcqzQJStwx6ZvM1KEc22MwM4117jzqnTc=
X-Gm-Gg: ASbGncuJ/9Pj5ECUTOY/83Iolib9Q16OwVhPc8UGaCJ117+weYJITV2UwETffVuS4Qb
	JtBuPMJ/GG6cdUYCm9YnezhTPdaFrUg==
X-Received: by 2002:a17:902:f705:b0:20b:fd73:32bb with SMTP id d9443c01a7336-2129f730378mr161266705ad.2.1732491201793;
        Sun, 24 Nov 2024 15:33:21 -0800 (PST)
X-Google-Smtp-Source: AGHT+IFp+vWPK09XM/Vjnio53TOhBBrx+gkMgse/of/Gw1qmqxwR49EqyAVZ9lGwWOxYaaaJBMgHXppOBxA/30bzdoY=
X-Received: by 2002:a17:902:f705:b0:20b:fd73:32bb with SMTP id
 d9443c01a7336-2129f730378mr161266505ad.2.1732491201531; Sun, 24 Nov 2024
 15:33:21 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20241124131147.1057922-1-agruenba@redhat.com> <atjh756n4ykf6syi3uxzb6mdxsfdbpfya5mx77bfcxgzl6proj@mrqvwcmdhd62>
In-Reply-To: <atjh756n4ykf6syi3uxzb6mdxsfdbpfya5mx77bfcxgzl6proj@mrqvwcmdhd62>
From: Andreas Gruenbacher <agruenba@redhat.com>
Date: Mon, 25 Nov 2024 00:33:10 +0100
Message-ID: <CAHc6FU78Lphf2CkfK_kBKDegqm0af7NzTh0V1myc_+mQUXYjFg@mail.gmail.com>
Subject: Re: [PATCH] bcachefs: eytzinger1_{next,prev} cleanup
To: Kent Overstreet <kent.overstreet@linux.dev>
Cc: linux-bcachefs@vger.kernel.org, 
	Andreas Gruenbacher <andreas.gruenbacher@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sun, Nov 24, 2024 at 8:24=E2=80=AFPM Kent Overstreet
<kent.overstreet@linux.dev> wrote:
> On Sun, Nov 24, 2024 at 02:11:47PM +0100, Andreas Gruenbacher wrote:
> > From: Andreas Gruenbacher <andreas.gruenbacher@gmail.com>
> >
> > In this place in the code, eytzinger1_next() is trying to move the
> > lowest child on the left, which is equivalent to doubling i until the
> > next doubling would cause it to be greater than size.  This is
> > implemented by shifting i to the left so that the most significant bits
> > of both numbers align, and then shifting i right by one if it is greate=
r
> > than size.
> >
> > The code accidentally computes the most significant bit of (size + 1)
> > instead of size.  This happens to be harmless because in that case, the
> > right shifting will compensate, but it is confusing and unnecessary.
> >
> > Likewise, eytzinger1_prev() is trying to move the lowest child on the
> > right.  The same applies here.
> >
> > Signed-off-by: Andreas Gruenbacher <agruenba@redhat.com>
>
> Looks correct. There's eytzinger tests in fs/bcachefs/util.c, could you
> run those?

Hmm, this actually breaks the following tests in util.c:

BUG_ON(eytzinger1_prev(0, size) !=3D eytzinger1_last(size));
BUG_ON(eytzinger0_prev(-1, size) !=3D eytzinger0_last(size));

The inverse tests are fine:

BUG_ON(eytzinger1_next(0, size) !=3D eytzinger1_first(size));
BUG_ON(eytzinger0_next(-1, size) !=3D eytzinger0_first(size));

And so are all the other tests.

Are those identities actually relevant, or are they just a
peculiarity? Do they justify an additional addition in
eytzinger1_prev()?

Note that these tests rely on the behavior of __fls(0), which is
undefined. On x86_64, __fls(0) returns (long unsigned int)-1.

Thanks,
Andreas

