Received: from mail-pf1-f171.google.com (mail-pf1-f171.google.com [209.85.210.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D57CD26AD4;
	Mon, 21 Oct 2024 15:00:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729522827; cv=none; b=agiGYOyMkXJUG1gGETXh5Mq/t6RcfDKT5wgsVxgECgJ2XrlJVsU5+adHAbnfPCWzFsddJS1NurJuxLU2hZjdXisjInLoO0L+25N1H+3Q84/LNMq5twjvh/4qNEy3TOMyRmgCOwxgv61UBzUhu7AIb4fyIbe2VZndR1XCYHZ2c4Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729522827; c=relaxed/simple;
	bh=pEfKWsFTW4FYaTDGRuCUeH7Kc/Wh8WFIHAE028fHyAg=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=I2zeEVGI1HVOEU/YvgnfPvuzvh9qQ3sRPk60G+pwNB8mo3ur39CfrNhSzkx8HNLcw4508iMqLqRQaTLHXmE1oKiD75ljKvtDnp3qnmuXQHQaeCoCcALkyt7VIkxKkEcdNeCp3bWCW3nDAC7xloOoET0AyqNlI6mSer7bx6pQOaU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=S8cY1uVq; arc=none smtp.client-ip=209.85.210.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="S8cY1uVq"
Received: by mail-pf1-f171.google.com with SMTP id d2e1a72fcca58-71e681bc315so2924234b3a.0;
        Mon, 21 Oct 2024 08:00:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1729522823; x=1730127623; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=RSAIOiWwIxBudP7zxML2M02m9mK4Z7nv2h4A6V98HKE=;
        b=S8cY1uVqDxVA+cj9UFAsxwx2Jt4UoEtLKRQBlde1R3fAOGrTQ8/ZSKBf00Fh0gpja/
         3IUKvm6HtWaCTeaNXnpKDjJJkZ6zIdZnTFRQPLtNYX3x1WZC+7VEO5bVXdFSaB9KvN8t
         ch0ufZp4UyTZjfjvOydrBBwDi5PfDAl9XqQxs7QzV/KAEBdV1Wp+fEcU9syB1aeSNLcl
         dL4HONyN+LDh28NHC0uL5j/WIeUDxv7LjLokgD+UapI7PRkrEO843JJV6ABTF9puZNbl
         wxIAAyY4+np3y0AiWMt+/9pVBiFW6L+6CKOkNOZMYFQVCrmSstmNIlEs5gNhKD00v72u
         4cew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729522823; x=1730127623;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=RSAIOiWwIxBudP7zxML2M02m9mK4Z7nv2h4A6V98HKE=;
        b=WH7cBH5z9XFR9ym0Qd+YWn+w/H15zkQMYIxmEXJp13kz6ekdC+ZwgFqsm/rxiiUvb7
         kL5OReuo00JlT5AptBEbKUVv/qBeKeWbEi6B+o7lGEYtlNABXote3qjOov9vpqOPPKYS
         twFdpLHJN2V/j+RXQA8j0w3unpa5q40KSUU3pLt/1GLaWjkN6998sVj85PAy1h2LNjKi
         lGyn5Psot6W5gnRenRQOcJGIuheeB0PHo2ngOd0HBjHpkTUi6RXBEBz6FEJk7OoaIuLA
         kFHIVGzDvZy/bt/AlC1ayCOpdjAdgSFOeETNvVyxShyDwKJQw1IZfS4FkaaFC4JsHMSh
         z4PQ==
X-Forwarded-Encrypted: i=1; AJvYcCUooxtacE8zuyK48V1Fsjt9yaLwShDLL2kQc7GN6Kl15jMSYysvVUSWag8QwPTFM1RXlW7sFw5X35l0LR+x@vger.kernel.org, AJvYcCXf/Dmo6wk8rWLVR+UvwUrwLEcOSRwYM7WqoYs1T5WMaqehpy+1NvaRFtR0MYd+WLoLZkK193GaGZtbKf8sSw==@vger.kernel.org
X-Gm-Message-State: AOJu0Yz8YbA+mD87UpN9eC7ym3Ck1sHf6KRvN5H0RlDEq+6nUx+AAqSf
	Abu5PP2S9A79TUpS5i+fXiN+WJRqHrVoH2zUbydCl2HSDNC0EFnzqP4p0B+sb69wDTJRHBunM8H
	lfb94WoA1T6CatSpE9XBbjIQhSt4=
X-Google-Smtp-Source: AGHT+IEQrIFcJCd39MJGH/OmL70uE7OgnIieisdNAd7R0SqAMScaNNPq5ec8nilSDk6yXIHOff3OhSuE9vOHH5+dmeY=
X-Received: by 2002:a05:6a00:1d15:b0:71e:591d:cb4c with SMTP id
 d2e1a72fcca58-71e8fd43bc5mr29388132b3a.1.1729522822525; Mon, 21 Oct 2024
 08:00:22 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20241021140949.29204-1-aha310510@gmail.com> <656AA7DA-D2FB-447A-9491-781880D79A4B@gmail.com>
In-Reply-To: <656AA7DA-D2FB-447A-9491-781880D79A4B@gmail.com>
From: Jeongjun Park <aha310510@gmail.com>
Date: Tue, 22 Oct 2024 00:00:12 +0900
Message-ID: <CAO9qdTEyduW6U7OsaK8tPLW6jQVgVSYPvszNRXUVxjwjAY4eVA@mail.gmail.com>
Subject: Re: [PATCH] bcachefs: fix shift oob in alloc_lru_idx_fragmentation
To: Alan Huang <mmpgouride@gmail.com>
Cc: Kent Overstreet <kent.overstreet@linux.dev>, linux-bcachefs@vger.kernel.org, 
	LKML <linux-kernel@vger.kernel.org>, 
	syzbot+7f45fa9805c40db3f108@syzkaller.appspotmail.com
Content-Type: text/plain; charset="UTF-8"

Alan Huang <mmpgouride@gmail.com> wrote:
>
> On Oct 21, 2024, at 22:09, Jeongjun Park <aha310510@gmail.com> wrote:
> >
> > The size of a.data_type is set abnormally large, causing shift-out-of-bounds.
> > To fix this, we need to add validation on a.data_type in
> > alloc_lru_idx_fragmentation().
> >
> > Reported-by: syzbot+7f45fa9805c40db3f108@syzkaller.appspotmail.com
> > Fixes: 260af1562ec1 ("bcachefs: Kill alloc_v4.fragmentation_lru")
> > Signed-off-by: Jeongjun Park <aha310510@gmail.com>
> > ---
> > fs/bcachefs/alloc_background.h       | 3 +++
> > fs/bcachefs/disk_accounting_format.h | 2 ++
> > 2 files changed, 5 insertions(+)
> >
> > diff --git a/fs/bcachefs/alloc_background.h b/fs/bcachefs/alloc_background.h
> > index f8e87c6721b1..66a334e2edcd 100644
> > --- a/fs/bcachefs/alloc_background.h
> > +++ b/fs/bcachefs/alloc_background.h
> > @@ -168,6 +168,9 @@ static inline bool data_type_movable(enum bch_data_type type)
> > static inline u64 alloc_lru_idx_fragmentation(struct bch_alloc_v4 a,
> >   struct bch_dev *ca)
> > {
> > + if (a.data_type > BCH_DATA_TYPE_MAX)
> > + return 0;
> > +
> > if (!data_type_movable(a.data_type) ||
> >    !bch2_bucket_sectors_fragmented(ca, a))
> > return 0;
> > diff --git a/fs/bcachefs/disk_accounting_format.h b/fs/bcachefs/disk_accounting_format.h
> > index 7b6e6c97e6aa..0232bc9f590d 100644
> > --- a/fs/bcachefs/disk_accounting_format.h
> > +++ b/fs/bcachefs/disk_accounting_format.h
> > @@ -72,6 +72,8 @@ enum bch_data_type {
> > BCH_DATA_NR
> > };
> >
> > +#define BCH_DATA_TYPE_MAX 10
>
> Use BCH_DATA_NR instead.

Thanks for letting us know. It's a simple change, so we'll send out a v2 patch
right away.

Regards,

Jeongjun Park

>
> > +
> > static inline bool data_type_is_empty(enum bch_data_type type)
> > {
> > switch (type) {
> > --
> >
>
