Received: from mail-yw1-f177.google.com (mail-yw1-f177.google.com [209.85.128.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA85626E6F2
	for <linux-bcachefs@vger.kernel.org>; Wed, 15 Oct 2025 08:20:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760516438; cv=none; b=QR47LgXmfp7t3U5VxSeWnloYdxECp9j9pzemcfnsU/d1e2fEkA+1KGHWujMyfap4RNOw3xWeB7t8idCvYoWxzIt2BzctIRb43OIJwfU5wP3Ntyfc+F7M/icqLT+XYYeaJOKJ4zUp2LZEQatgf42gHVL//5ks+DT4UFhPnYwkPBE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760516438; c=relaxed/simple;
	bh=ujMLqWA/AaU+bOG0VYggNI6i6amNpMlNzvpKsAy+smU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=BwFyiWSfet0Z+mvhTUEuSmaTANb6m31p7+hT4yW3Z4ZgGwioNQY66uiBCa1aa8GQs0pX7/PYjohGUKejs2dtMGBNQnKq5E3HSP/ibxJ4ZF7WyorCP++lsmaKY88BZzwOPmhzUoQb/Vyt+bJdoEC2j91b61BbWElabVfbD7hjvSk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ee.vjti.ac.in; spf=none smtp.mailfrom=ee.vjti.ac.in; dkim=pass (1024-bit key) header.d=vjti.ac.in header.i=@vjti.ac.in header.b=U5xX7NHU; arc=none smtp.client-ip=209.85.128.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ee.vjti.ac.in
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=ee.vjti.ac.in
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=vjti.ac.in header.i=@vjti.ac.in header.b="U5xX7NHU"
Received: by mail-yw1-f177.google.com with SMTP id 00721157ae682-7501c24a731so74902977b3.3
        for <linux-bcachefs@vger.kernel.org>; Wed, 15 Oct 2025 01:20:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=vjti.ac.in; s=google; t=1760516433; x=1761121233; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ujMLqWA/AaU+bOG0VYggNI6i6amNpMlNzvpKsAy+smU=;
        b=U5xX7NHUSnwtbB5023z2Z8h4XhfK+4LbYzQZ/u6Rznr/XpZBxUmQ/ISnfQlFuj4tgK
         +1k6ZEJ9qaMk0CtsrDXKVQ/mz9Nz5whRbo/xdDtHqoMc+JcJJNgJpN4ts0QhBAMsOSPq
         4vfsDwPqvpXoG8ZTCFP+kJlPVpr9cljr+86ME=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760516433; x=1761121233;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ujMLqWA/AaU+bOG0VYggNI6i6amNpMlNzvpKsAy+smU=;
        b=U3VkrJdcL+cYjwA6AqLECCeokKZ/OQYc7IbqsZ8fsxcCPwjx3ch8Um6UmW9M8NXq1l
         chRCs6+7g4eUv1Fvut5yfh/yxe+pigjCmJy5lNZqXBmv95KIlS0exnOK+vxXllnKGlHS
         s1hh9CfjT50cLz35o4y3ECdHr4lUoIke4R4ZnaogmLISJNw/zWhnwHwzgXWecG+PoSIS
         hV7EQK5Iqt8Z7ZhtRgN1NoxrQJdZHj2qe+xPvZqVUeoXfKt3RDUWcZf8A53bZ6vQvxNf
         Y/7U3iCX5mQMi+As8uvPIHMEjOdKo0VSFfG7u0rXb2Wu2fL7XamHPRTU9okJmSTV3p3+
         vlEg==
X-Gm-Message-State: AOJu0Yych3QgQw/ZXtrEFv0s4JLcw5hKjeZLrmiPdVlPdnclTYb2fBac
	Yjki6H8h+nKEXV8Wi7WNt0fgXsU4PaXFubO1KvYBJ4yEWbh8r8inwD+Nu6O8r5+mo0HPOjahuSI
	qxOBZZAjpPIRHivKXwthnWVWbRUDmbN7sGGLBqWFfyw==
X-Gm-Gg: ASbGncuF1dx4nD+acNduPdUDqMz+9QmKaiQ/DHfUVx3t9z+jXZRkLzbjtN/hDg9mYpw
	79zKlo5jA+GhQQxd27m9FttG1pWMcsmBHOyqRpdqBVxaxzdPJeYkey/W3soZ74GfCi77X2GebU3
	miM0iuDpl/3ZValRFN48emLKBXa2TQ+i6huNA099aKn9Yqe1c5ByBvDq2tAgh7Oq+7ZYkbmNfo8
	L0BsVJUiBkElPkUikccGKrSAbHT7Jz7ozGj
X-Google-Smtp-Source: AGHT+IGmrzcWBjp6jhCquKjpdoKoFojf89c4KOE6qlCTGev4ZOzdOefYSCZAWaNAZ+NXKPXbzuB3TzL6GadGRgU9k5c=
X-Received: by 2002:a53:d892:0:b0:600:39b9:b14d with SMTP id
 956f58d0204a3-63ccb903543mr17998198d50.38.1760516433682; Wed, 15 Oct 2025
 01:20:33 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251005160518.10000-1-ssranevjti@gmail.com> <CANNWa05YhQ9Ycr13e3SOYgD=cms5iskSENUwXUgk0T8zkMy97Q@mail.gmail.com>
 <nsj65dhgvhta45hng2ouj2vq4hclu52bdvlkvpzbucgmkqmacb@w4g5qzmqr5of> <CANNWa04Mei+hLsZ5JkCfejgiByJgu8e1Euy--ypT_ZmWuvvHeQ@mail.gmail.com>
In-Reply-To: <CANNWa04Mei+hLsZ5JkCfejgiByJgu8e1Euy--ypT_ZmWuvvHeQ@mail.gmail.com>
From: SHAURYA RANE <ssrane_b23@ee.vjti.ac.in>
Date: Wed, 15 Oct 2025 13:50:20 +0530
X-Gm-Features: AS18NWCM2xJ9KaYeRMppoYhB_wWzCV-2W-2W3aW3R8r_os6gn3Y_Ptp_zxbiXn4
Message-ID: <CANNWa05W9C-Lb6TcqanAM_RNeAzDBdyL=c8AEqS9udRF3YX3pg@mail.gmail.com>
Subject: Re: [PATCH] bcachefs:fix use-after-free in __bch2_bkey_fsck_err
To: Kent Overstreet <kent.overstreet@linux.dev>
Cc: linux-bcachefs@vger.kernel.org, linux-kernel@vger.kernel.org, 
	syzbot+55c84106264e92ea9ada@syzkaller.appspotmail.com, 
	syzbot+564efbe31172fe908429@syzkaller.appspotmail.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Thanks for the feedback. I=E2=80=99ve tested the patch locally as well usin=
g
kselftest, and it passed successfully.



On Mon, Oct 6, 2025 at 3:16=E2=80=AFPM SHAURYA RANE <ssrane_b23@ee.vjti.ac.=
in> wrote:
>
> Thanks for the feedback. I=E2=80=99ve tested the patch locally as well us=
ing kselftest, and it passed successfully.
>
> Best regards,
> Shaurya Rane
>
> On Sun, 5 Oct 2025, 23:35 Kent Overstreet, <kent.overstreet@linux.dev> wr=
ote:
>>
>> On Sun, Oct 05, 2025 at 09:38:25PM +0530, SHAURYA RANE wrote:
>> > #syz test:
>> > https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git mas=
ter
>>
>> Instead of having syzbot test your code, please try the ktest syzbot
>> reproducer test:
>>
>> https://evilpiepirate.org/git/ktest.git/
>>
>> build-test-kernel run -I ~/ktest/tests/syzbot-repro.ktest <bug-id>
>>
>> I get very nervous when people send me patches they've never run
>> themselves. Always try to have eyes on what your code is doing, try to
>> look with your eyes and see that it's doing what you think it's doing :)
