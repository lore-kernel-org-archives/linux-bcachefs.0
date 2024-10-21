Received: from mail-pg1-f175.google.com (mail-pg1-f175.google.com [209.85.215.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F01815666C;
	Mon, 21 Oct 2024 15:29:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729524554; cv=none; b=A2oiqBOwT+FJ0B9F+Y//bnsAOyJK09UwqTFRFLE0Y9FCB5burvr/ThSeyEwRIsynfvdocs4VJ7Vk7AepLwQRdvyDNsmrj/xFLrhFpP8lkGYGyleC739xsHWoMO0a1QfPPbyxCpvYb1j+XNv9+eBWj3pFzPyW9xibEc7EUkEWa0o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729524554; c=relaxed/simple;
	bh=djjbLzgO5ZMu5YQoFhWKRk/U8zzfkcKjEWieuZBAClY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ttgqfbeq09/8Ijyi5mN8DD6IQt9cqqSlTKovHOfp51v+FHl+9ZZ51D3RyDiXxmCCvkciVDXXQR2O4fr2lLIwm/reg3HadVLcuiUkE/Wleo7Xfnr8ENRTMS4EKW+LFMYPwvAWe5UxwuWuEAn8DLda6GeFWLKH/WJSZQd1hak14o0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=IO7rNIDL; arc=none smtp.client-ip=209.85.215.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="IO7rNIDL"
Received: by mail-pg1-f175.google.com with SMTP id 41be03b00d2f7-7ea8ecacf16so3143942a12.1;
        Mon, 21 Oct 2024 08:29:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1729524551; x=1730129351; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=OxtlyOqwd5QS2va759UuCoBJi2MrqRuIrYTgMMaR/b4=;
        b=IO7rNIDLWncvvdsXHPxdrnY5GcTg+G44GfCr7yChLpvrERFfVHseljB1GfTkH7CNdk
         /JF+KT3xIdLDwsNFoN7VID1YswBba4axz3PUn9+qAKDcbHHMHCb/PKkxcpMbbUwcBMkh
         c6IHS69fhVp30KQslcfwGVN9yYyEm12VKlI87UbR1cPjACRVH7KcVficCZKPZyNjnz1B
         W5RsEd3BE0/PzQHM3Rr4yzQ3mkc5EYY6okWJTcDBBPLY3DScB/BK0i4RTPtoZzLSuR4d
         U2hIE4RnyCcDkfrxRjq9OYffCFsAzYDb1yvd39LYPHjv3i1KWb8itQA+vjtVA8YApmAo
         kbHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729524551; x=1730129351;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=OxtlyOqwd5QS2va759UuCoBJi2MrqRuIrYTgMMaR/b4=;
        b=Rz9iXDdvlBg4+DdyzvzeJ1xMcZnH8N7HAaV5NjZdW669t5KKZO8wPLWwh+t/JXV21m
         vkQ5q/xR9OMYoqWoNZk5MyEo8VBfxYuUtJJoH4VjcKOKemt6tGfccaPzy/vsFeZBO5tQ
         8vwD21KWFBsv4Lh+ZEyb3tOE/Fl11vdvrK4kc+T2sAbM0s3rP5TvOff59q/O2necYiA+
         AKT8wrOkCVcZBrzWRXj6So3Gj7VXoZryR/SQRkcbl03knLyA9in8TttNEIVN368HoDK/
         aSTdoDCqbPtf539WKx9VhvS6g3ExaK72S//rwvIAXwU0bpxKmp3atXSysjU5TG0/QUIi
         QUrQ==
X-Forwarded-Encrypted: i=1; AJvYcCW0sSN5brhAUc6CouIPp3nKgxYsEPef5DkErMmoTi6ZjrGM0FgoNgE5UGbxi94l2Np2SbbzqYGW2oWNUQf9fA==@vger.kernel.org, AJvYcCXqRKIg402sYT2bNF90mXfOD8ygavZqvQt2P96HJbz7erAhZzuU7bNZkLk/NZO6xQTDkLXnFXH/M6Ts590i@vger.kernel.org
X-Gm-Message-State: AOJu0Ywdb5NQTlW4GbxVj4E3lJIWnAQg8envCZLGl+BZsp3qHC3SBQDs
	NEL5gAoXYH2v3mYYxfWwMBf6yqibMsf3EMNuQ2cFWNs7wlIs/H739LbZAMwx/9SHGocoCIJunZU
	LS7lKsx3573qvYv7/N7zOTJyoN3g=
X-Google-Smtp-Source: AGHT+IFAHg5lxUbwjuA68v6eKNTB7ETnc5cSGTv3ajBN8pBqKTJGGulmN6cIpeuwYwUVOLdoIKqdrrR2BgDFamzakSw=
X-Received: by 2002:a05:6300:4041:b0:1d9:2bed:c7e8 with SMTP id
 adf61e73a8af0-1d92c56cd8dmr18534677637.35.1729524551544; Mon, 21 Oct 2024
 08:29:11 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20241021151036.34383-1-aha310510@gmail.com> <E6F9687B-700A-4A02-8A7F-4C9ED648D746@gmail.com>
In-Reply-To: <E6F9687B-700A-4A02-8A7F-4C9ED648D746@gmail.com>
From: Jeongjun Park <aha310510@gmail.com>
Date: Tue, 22 Oct 2024 00:29:01 +0900
Message-ID: <CAO9qdTHjjJ53F0Vw=SSnLka1B5QLD1Sj6ZRM6g=AFtiLGKQ-+A@mail.gmail.com>
Subject: Re: [PATCH v2] bcachefs: fix shift oob in alloc_lru_idx_fragmentation
To: Alan Huang <mmpgouride@gmail.com>
Cc: Kent Overstreet <kent.overstreet@linux.dev>, linux-bcachefs@vger.kernel.org, 
	LKML <linux-kernel@vger.kernel.org>, 
	syzbot+7f45fa9805c40db3f108@syzkaller.appspotmail.com
Content-Type: text/plain; charset="UTF-8"

Alan Huang <mmpgouride@gmail.com> wrote:
>
> On Oct 21, 2024, at 23:10, Jeongjun Park <aha310510@gmail.com> wrote:
> >
> > The size of a.data_type is set abnormally large, causing shift-out-of-bounds.
> > To fix this, we need to add validation on a.data_type in
> > alloc_lru_idx_fragmentation().
> >
> > Reported-by: syzbot+7f45fa9805c40db3f108@syzkaller.appspotmail.com
> > Fixes: 260af1562ec1 ("bcachefs: Kill alloc_v4.fragmentation_lru")
> > Signed-off-by: Jeongjun Park <aha310510@gmail.com>
> > ---
> > fs/bcachefs/alloc_background.h | 3 +++
> > 1 file changed, 3 insertions(+)
> >
> > diff --git a/fs/bcachefs/alloc_background.h b/fs/bcachefs/alloc_background.h
> > index f8e87c6721b1..91eb96b19a76 100644
> > --- a/fs/bcachefs/alloc_background.h
> > +++ b/fs/bcachefs/alloc_background.h
> > @@ -168,6 +168,9 @@ static inline bool data_type_movable(enum bch_data_type type)
> > static inline u64 alloc_lru_idx_fragmentation(struct bch_alloc_v4 a,
> >      struct bch_dev *ca)
> > {
> > + if (a.data_type > BCH_DATA_NR)
>
> This should be  >= ?

Oh, that's right. I checked it myself and it's the maximum value + 1, so
I think I should use >=.

Thanks for letting me know!

Regards,

Jeongjun Park

>
> > + return 0;
> > +
> > if (!data_type_movable(a.data_type) ||
> >    !bch2_bucket_sectors_fragmented(ca, a))
> > return 0;
> > --
>
