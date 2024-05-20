Received: from mail-oa1-f50.google.com (mail-oa1-f50.google.com [209.85.160.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8EF0DF51;
	Mon, 20 May 2024 02:42:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716172978; cv=none; b=dY+d8VkbZsd11F1Iklpx376IZNaxH1VvOo0PHWOqDrEPW3t5torS3LGovWam7e3VPCNAJQ4MsWi9Ou0rHkRnGJh3tH85DLaX4vBKSl10rPan7c5klH7fKDmS5ojNlSazJKSpyF+2TkhjoCdOgpZR9289UIbiBQwpKkchzT5WDfY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716172978; c=relaxed/simple;
	bh=u8M29W93CLZk7xFCZDRHfyzapkR9x06WPG1ULAlSECw=;
	h=From:Date:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=okoaDjEt5bflGJtyGMUyB01fLgQ81Lzkyu1d1qVfrn4XHV658n7QeBr8gZwfc6N17nROGK1ydlpR/jKBpC7+Vlh3+wnp152GNv67R5dUYnlB4dMILfYkZ4PLTXaUZ/Yhm96XbJoYtbLnFf9wbAtjywEdNVIUxkSKFR6OcAVhgyw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=c21GpFSB; arc=none smtp.client-ip=209.85.160.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="c21GpFSB"
Received: by mail-oa1-f50.google.com with SMTP id 586e51a60fabf-23d3d092a1bso1761333fac.1;
        Sun, 19 May 2024 19:42:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1716172976; x=1716777776; darn=vger.kernel.org;
        h=mime-version:references:message-id:in-reply-to:subject:cc:to:date
         :from:from:to:cc:subject:date:message-id:reply-to;
        bh=tr1T7/XjuQtJAqIemXjuLBVV4b7VY8GatTsfPNLXx4Y=;
        b=c21GpFSBH/ZaUJgQWp6iniMqns0RdzMsJsdv4upSUPNjvmBiK4C4c8b3UMoWcylo65
         4eRPaLvDbb4FIyWOOZIe2L6TsdA2e3HN+IOqF4TEdyOo1Oy0xHgOfzwRJDrXWA+Un7ii
         +g8UJvWNGKyNvnoo+5CVdFSfC8kuGUeCFEbp81LYv4SUrS505PkhuSySqe0KXxttmjC+
         HScU0l48dCByDkRNdirOQUy8OaxPcmEzR76c2nmL+Dapx52r726uKQxJn6ZMVh8vbRlf
         7IqHGqK/cSFPFsB4AXEnjK0H/Nvq83hf6CVH3PL/6QRLuo8UueIkwhZLp9gC244+MHDg
         qJ4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1716172976; x=1716777776;
        h=mime-version:references:message-id:in-reply-to:subject:cc:to:date
         :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=tr1T7/XjuQtJAqIemXjuLBVV4b7VY8GatTsfPNLXx4Y=;
        b=U9pWyIYKt7YQLR+HH32AVUIwN3MhxXkBMEsvVB2LAaRjqRQ6YfyqCEf4TyvQ6g+wiC
         v3QKbJW4LzNBFalGu+yCdxLMQsQ/8n/nHOUCU9iKH79DMKazNqAcGJpgnIE4r9Z2Rexo
         Yy5WJ43h5TR6z7AHMs/V9smpOvx+25tlMznXCYx62p2lKNfC8j+A2Yr/5tglZakCaDwv
         UvWyaXVI+YwaD1UhZihxHGTpfjI7nGEAUFCdU/ZMOUyGTKTOPlpx8PtnQqBVRKEDLbdD
         ho0Zme00Xg9mC0+GMw5Nf+NWnH+9XR6CBwl8iiuoA2l68k7Gn0yM80nCkHaafUOOtXiU
         HTag==
X-Forwarded-Encrypted: i=1; AJvYcCXMaXesKPX+hGM4YhTYRo42YR64z/6a3qwQ4R5xljhisipvJLSR75wzK2tdWXN/qb0iA88K2cX82mH5g7l89FfSrZCEZrE4qK4wjFV2oKWejLrYyv6UDIcMxxogAe0b6OJK1PrI9WczYIdDtBI=
X-Gm-Message-State: AOJu0Yzg8SPfCUbfgc8LmAQi4roY3W34xdBdYvQn3dBjlYsVB38gzmfV
	IFoOy3LO5SJrQfeHUlVzGPRFCZOQ4cDVXOOPQqyEJLUvvftj0SV/
X-Google-Smtp-Source: AGHT+IGFCXVEvzoq9XyGC88P+7whkiD3/8oI+PvChhcLN5Tw7aYEULIzaHp9hLUHxfDb3mO0nLV3pA==
X-Received: by 2002:a05:6870:4191:b0:233:2f5f:9e1 with SMTP id 586e51a60fabf-24172fc5112mr33193967fac.54.1716172975788;
        Sun, 19 May 2024 19:42:55 -0700 (PDT)
Received: from [192.168.7.110] ([190.196.103.34])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-6f4d2a81c8csm18122707b3a.70.2024.05.19.19.42.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 19 May 2024 19:42:55 -0700 (PDT)
From: Camila Alvarez Inostroza <cam.alvarez.i@gmail.com>
X-Google-Original-From: Camila Alvarez Inostroza <calvarez@macbook-pro-de-camila.local>
Date: Sun, 19 May 2024 22:42:52 -0400 (-04)
To: Kent Overstreet <kent.overstreet@linux.dev>
cc: Camila Alvarez <cam.alvarez.i@gmail.com>, 
    Brian Foster <bfoster@redhat.com>, linux-bcachefs@vger.kernel.org, 
    linux-kernel@vger.kernel.org, 
    syzbot+10b936c5eaee2819b49b@syzkaller.appspotmail.com
Subject: Re: [PATCH] bcachefs: fix last_seq and last_empty_seq in
 bch2_fs_journal_start()
In-Reply-To: <c7qpzaeqhyvkbgaplvazj6steii5ayta7gtidmy24u7gfnnkuc@nhc2swhzmuff>
Message-ID: <69dde6ef-69d3-047c-c1b2-64ac51ac0302@macbook-pro-de-camila.local>
References: <20240516031919.592696-1-cam.alvarez.i@gmail.com> <c7qpzaeqhyvkbgaplvazj6steii5ayta7gtidmy24u7gfnnkuc@nhc2swhzmuff>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII; format=flowed



On Sun, 19 May 2024, Kent Overstreet wrote:

> On Wed, May 15, 2024 at 11:19:20PM -0400, Camila Alvarez wrote:
>> Values were left as the next possible sequence number when there were no
>> entries.
>>
>> The fix involves updating the last_seq initial value and
>> setting last_empty_seq to cur_seq - 1.
>
> I think this is correct, but we should try to come up with some better
> assertions or something to make the code clearer; we don't want off by
> ones to lurk so easily.
>
> Could you give it some thought?
>
You're right. I think the code is written in a confusing way. In 
particular it seems that cur_seq - 1 is used all over the place.
I believe we can abstract cur_seq - 1 in an independent variable (since 
it represents the actual last sequence number), that should make it 
clearer.
I'll share an updated version of the patch.
Thanks for the response!
>>
>> Reported-by: syzbot+10b936c5eaee2819b49b@syzkaller.appspotmail.com
>> Signed-off-by: Camila Alvarez <cam.alvarez.i@gmail.com>
>> ---
>>  fs/bcachefs/journal.c | 4 ++--
>>  1 file changed, 2 insertions(+), 2 deletions(-)
>>
>> diff --git a/fs/bcachefs/journal.c b/fs/bcachefs/journal.c
>> index adec8e1ea73e..3835c458eec9 100644
>> --- a/fs/bcachefs/journal.c
>> +++ b/fs/bcachefs/journal.c
>> @@ -1196,7 +1196,7 @@ int bch2_fs_journal_start(struct journal *j, u64 cur_seq)
>>  	struct journal_replay *i, **_i;
>>  	struct genradix_iter iter;
>>  	bool had_entries = false;
>> -	u64 last_seq = cur_seq, nr, seq;
>> +	u64 last_seq = cur_seq - 1, nr, seq;
>>
>>  	genradix_for_each_reverse(&c->journal_entries, iter, _i) {
>>  		i = *_i;
>> @@ -1256,7 +1256,7 @@ int bch2_fs_journal_start(struct journal *j, u64 cur_seq)
>>  	}
>>
>>  	if (!had_entries)
>> -		j->last_empty_seq = cur_seq;
>> +		j->last_empty_seq = cur_seq - 1;
>>
>>  	spin_lock(&j->lock);
>>
>> --
>> 2.34.1
>>
>
