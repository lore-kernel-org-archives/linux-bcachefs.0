Received: from mail-pl1-f177.google.com (mail-pl1-f177.google.com [209.85.214.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 846E37E0E9;
	Thu, 18 Jul 2024 22:49:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721342948; cv=none; b=uwGI7u/OR+GedpL27jC8FFDvLLUzKftsW6CEBcrft6YzHv8J0Sr3o8cB8m+VFatfKqe2cCIa5P0c6qJH91Qdf3ifM01YzgjeYDfoSN8Z9HKdyMnUk+5UNKPKB51MP5pk63Yf6IGSjD7ZGViPy3/TTEh0EZwsI3e7Xs4KKd1BkmY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721342948; c=relaxed/simple;
	bh=uD3q8I8IHhQdfXasm0txZk2g5DNLtoFRUSvHEB1mq80=;
	h=From:Date:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=plrRB1PHJdmOvs7iIq/0MivZ2tCAxge3DJbLHsBUvCliHB3rabqlsmYnfL7NnYr3alcKTe2L9Z7jGwSK/zivTwAnCPtz4A8wCDopbZRL8iF/8UJtGENj7x4UObyTPu/C4wBRVq6Ix4EJtRE2aNuajXsvSmvVv4W719Z+c0Oxpk0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=hibO0Szu; arc=none smtp.client-ip=209.85.214.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="hibO0Szu"
Received: by mail-pl1-f177.google.com with SMTP id d9443c01a7336-1fd65aaac27so30905ad.1;
        Thu, 18 Jul 2024 15:49:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1721342947; x=1721947747; darn=vger.kernel.org;
        h=mime-version:references:message-id:in-reply-to:subject:cc:to:date
         :from:from:to:cc:subject:date:message-id:reply-to;
        bh=uD3q8I8IHhQdfXasm0txZk2g5DNLtoFRUSvHEB1mq80=;
        b=hibO0SzuUQbB2BAzdw24sW4pIjl2g4Agu9fz56jyxa8JznDOlzlrJkFNrPkxztmNrK
         qcpQavMdJTKhSU1mhbUQW4vl7Y/tmdVuxNlQWLTJgCOcszmQTHk2vL4E1L9G9LMk17Ct
         egeh9eu1pwBBhCXx0n3FXVniv/ldegnJrGWkaqhG/sAbGrys4Ay7lb9BayWL/0vhtlmZ
         gG+DRLcUUWkq/lwhzmK/0ffa8ExMb7ghCupD2EDBPwHjGnFHDptix9e8B/LqGpxM9Is6
         Iu6ZAIBczWQW6kmIEZbHj4gqf8odxfK4iiXku1YyZu2zBssJfsJBF94cOMrApWfVFz2J
         GALQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1721342947; x=1721947747;
        h=mime-version:references:message-id:in-reply-to:subject:cc:to:date
         :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=uD3q8I8IHhQdfXasm0txZk2g5DNLtoFRUSvHEB1mq80=;
        b=D3Omp42qVxLFmmIopBHZc0SaArtDxcm7FzIcfIli6nWCjbyd04fnVANCteEprqcWEV
         /L4KGYPjW2jKxeTyfGSVoaNYCgEuVg8T4jwMxpXuyd1+MS3VetgP+Lm4xbflXO47ARcJ
         euv7ia3cUbND5Kxk3cRz7lGHn4mfViJymUpc9HTZ9N5cyVRpTlLK3gNaaHy098SYP1p8
         YxS4gbVEt1tgvjF+rSUOoP8L7ukZvEvr8PSQsv0MJ47nbvUuZk+ke5qPnEp+OYgOtkTI
         Mi+QTSJ+4bSXJaSf7K7Qec91wOG03Vh3OeVVCp9xwNIXMncdRZ+RtIuz1Uongd6wZIvZ
         T0lg==
X-Forwarded-Encrypted: i=1; AJvYcCWn6ODkMQMDDOUIh4YHEvdJlAyMaP0EfLvPcHQ0FXEXK7qxnWfOJXSgLWIns3jWEMOh2OTcxxlSEI/S4oo3InQ4kBS+XiN+fZr+GmPzHBrV+iFvE7nHgmhBUgrPXjG7w+KIS936XtGIq71YaNA=
X-Gm-Message-State: AOJu0YwPS0W7ptjR7FymLnoVorEO3AUJJlLUfDZkCuYz1Q2ZZL61rCYc
	uCnPl8n7EqOAbWcnS4oDiWjSqumRmK8cb66QRj3yu3oQhWF0tV4OJv2DPA5x
X-Google-Smtp-Source: AGHT+IH1GI5LZ/Pv0VaDcsCEvtonGa30o6/CJUx9RkyFl8ArHI5pFPu/xVq03MMPIBuK1eRcUw/QNw==
X-Received: by 2002:a17:902:c948:b0:1f9:ad91:f8d0 with SMTP id d9443c01a7336-1fc5b59fbc1mr66358085ad.8.1721342946601;
        Thu, 18 Jul 2024 15:49:06 -0700 (PDT)
Received: from [2800:150:146:48c:a5d5:83a7:6227:2aa6] ([2800:150:146:48c:a5d5:83a7:6227:2aa6])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-1fd64d071basm924185ad.122.2024.07.18.15.49.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 Jul 2024 15:49:05 -0700 (PDT)
From: Camila Alvarez Inostroza <cam.alvarez.i@gmail.com>
X-Google-Original-From: Camila Alvarez Inostroza <calvarez@macbook-pro-de-camila.local>
Date: Thu, 18 Jul 2024 18:49:02 -0400 (-04)
To: Kent Overstreet <kent.overstreet@linux.dev>
cc: Camila Alvarez Inostroza <cam.alvarez.i@gmail.com>, 
    syzbot+4093905737cf289b6b38@syzkaller.appspotmail.com, 
    Brian Foster <bfoster@redhat.com>, linux-bcachefs@vger.kernel.org, 
    linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
Subject: Re: [PATCH] bcachefs: WARNING in bch2_fs_journal_stop
In-Reply-To: <f6lmsdtntfs3ot4jc2waizihayhipszr3iuro3tzyjgbfvjwuw@ms4foq466yiz>
Message-ID: <d25b7319-5b16-da76-6f07-226d1da11e16@macbook-pro-de-camila.local>
References: <20240717220237.1246673-1-cam.alvarez.i@gmail.com> <e2oi7a4jj4gjhzcp66rygr5d6wqlock6c5jvuwszxuej3hldmd@tnvbf45nbx2x> <6d42612b-1c20-0484-ce9f-eac509e6740d@macbook-pro-de-camila.local>
 <f6lmsdtntfs3ot4jc2waizihayhipszr3iuro3tzyjgbfvjwuw@ms4foq466yiz>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII; format=flowed



On Thu, 18 Jul 2024, Kent Overstreet wrote:

> On Thu, Jul 18, 2024 at 06:42:55PM GMT, Camila Alvarez Inostroza wrote:
>>
>>
>> On Thu, 18 Jul 2024, Kent Overstreet wrote:
>>
>>> On Wed, Jul 17, 2024 at 06:02:39PM GMT, Camila Alvarez wrote:
>>>> last_seq and last_empty_seq suffered from an off by one error when the
>>>> journal has no entries.
>>>>
>>>> The indexes were fixed and an assertion is added to check that the
>>>> last_empty_seq is always kept under the next valid seq number.
>>>
>>> oh nice. I'm going to need to stare at this some more, I still feel like
>>> this code needs to be clearer and less fiddly.
>>>
>> Sure! Please let me know if there's anything I can do to help.
>
> I'm just applying it - the warning you added gave me warm fuzzies.
>
> I'll let you know if anything pops up in the CI (and I should give you
> an account so you can point it at your own branches; email me a username
> and ssh key)
>
Should I give you the info in this same thread or in a separate email?
