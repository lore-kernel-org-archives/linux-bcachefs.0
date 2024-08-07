Received: from mail-oo1-f53.google.com (mail-oo1-f53.google.com [209.85.161.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF5901E495;
	Wed,  7 Aug 2024 03:04:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722999888; cv=none; b=ZaLlFTIaVETXwMrJJgblJoA6mkkvWaeEbuNfTPXCBaMj1Nh5priqk4ghXNloyEdDl63vuqsxKhwYS9LKX4ODTkTpnylaZF+iSyqCDSoUIGXS9sJ4XqwH1Oat8i4mjd1/8i8RsqTY6JNIk+pF5i3zrlfAMky4Qlp4e4X0urDnNsw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722999888; c=relaxed/simple;
	bh=P/Ogoc9mfokfR33KwO+zNgH4b6ZwTbSg/UDQ4EHBWu4=;
	h=From:Date:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=SZxy41fIrbYYEYr2xCs9jeWJIpsa7j39B9st0ZQjuB/E0PXRtJ+6TkDk/nY9+Sc7GrgqNA2RN8yJbUb8Xawyt1/5Bv9hRsYSCtHNVeY2vrQPDIHqRwBBlj0VBnV+005EGbvl8T+O+uc8UXAZ/WEyQ0JHlg2dAF76fjYzLyBthL8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=eipDai9x; arc=none smtp.client-ip=209.85.161.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="eipDai9x"
Received: by mail-oo1-f53.google.com with SMTP id 006d021491bc7-5d5e97b84fbso669918eaf.1;
        Tue, 06 Aug 2024 20:04:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1722999886; x=1723604686; darn=vger.kernel.org;
        h=mime-version:references:message-id:in-reply-to:subject:cc:to:date
         :from:from:to:cc:subject:date:message-id:reply-to;
        bh=qgj9IyuUsHvnQokc+OT1y0kANHSJMZKkxAO6bdOH0M8=;
        b=eipDai9xn+yBLWJ8456oPtCpifge0oaspQctL+ZfGupkGX1PMyvevBTc3i9z4eGRgf
         g34MfLehHvHGs1uyxd5smhJ28jDKkDvIzsC5GzbgLeyR96o+FKDEjxI7oETctHguD2FP
         uUe6wFlUXaUvDQ2nTaA1nzlwPmsmPlEgaR3jWr1lT+MtxVG/zKvTHZ1eZpszeEKS2RFq
         YH39QwfLZStAEGPjeVhfWDw29FTf9YxPmWqqFSLSSAohXe58XdtAADAvAwp+AeyXXS6E
         e6TL1VF2NU+lu+OvQCr69adcIDDo2tfxp+hSaqEu6D5zTHYEcTJj9cAQOZMDSs8/wxkw
         Ch6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1722999886; x=1723604686;
        h=mime-version:references:message-id:in-reply-to:subject:cc:to:date
         :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=qgj9IyuUsHvnQokc+OT1y0kANHSJMZKkxAO6bdOH0M8=;
        b=r//xlvhnCziIs/4YVIBSohbAOyLsKbN6GY7SYA1vSKRtnPgpU02RpI+Uq8SZQWtGHh
         T48MS/eJe6IPyaDDQTX4tgLj2U12UXmMWmeGM2zHYEGrcH1oGvxN0LRYKc73fiLfKlNU
         VsT6OrW6WzYdgA5MLV6zXIaDhoMCsddzeT357fzUDk4y1ngRPS+rq9MNwgsUJwABfzr5
         RQ6UT59jR6wboQ+RkQXEWHc2Er6662ZcjyfGU4fi6+A8Qbm3jyiFPdoqSohvyKN8g3hS
         MlWlwDFl4VmFf7ltEgeGZOKKknM50BYyTbgWRIkP34eVweG8q0iFFjRlxcdvp3VrmsH+
         MFlA==
X-Forwarded-Encrypted: i=1; AJvYcCUisjNKOEgaUcFAV7rAmLsMpovrIepT29Z+makr4LWtrrv2OVDG2gfIFwNobGoRruRTSd7hcEZKWF6HiDAt8BMdaBO7xGl04H8UpxHOWxLdi54nBei+5upSE8nbEEMJtzNLdUqk2BZOQBilN4I=
X-Gm-Message-State: AOJu0YyadqTr1IvQzHXDDPDyk7SHowmVZF+77rGLl6IQQjoXaBgD+Xyc
	h7SuHdNGuvbZbQegPaHACzTSATehzoOp/aJhq48so6RNUvVizmrI
X-Google-Smtp-Source: AGHT+IEpl+WQJAIpFxSbG+4QbALxx98N/LKP+YzSaDW9urNDJHTZ9uPJQG5rCXvBPK5tW/tuUDMFOQ==
X-Received: by 2002:a05:6870:9a20:b0:25d:f8fa:b535 with SMTP id 586e51a60fabf-26891aa8695mr22417266fac.6.1722999885761;
        Tue, 06 Aug 2024 20:04:45 -0700 (PDT)
Received: from [192.168.7.110] ([190.196.138.8])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7106ecfd057sm7539849b3a.160.2024.08.06.20.04.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 06 Aug 2024 20:04:45 -0700 (PDT)
From: Camila Alvarez Inostroza <cam.alvarez.i@gmail.com>
X-Google-Original-From: Camila Alvarez Inostroza <calvarez@macbook-pro-de-camila.local>
Date: Tue, 6 Aug 2024 23:04:39 -0400 (-04)
To: Kent Overstreet <kent.overstreet@linux.dev>
cc: Camila Alvarez <cam.alvarez.i@gmail.com>, 
    Brian Foster <bfoster@redhat.com>, linux-bcachefs@vger.kernel.org, 
    linux-kernel@vger.kernel.org, 
    syzbot+1e515cab343dbe5aa38a@syzkaller.appspotmail.com
Subject: Re: [PATCH] bcachefs: WARNING in bch2_trans_srcu_unlock
In-Reply-To: <brefgiw6mbvnpg5dmxhuwmoxfrh6upw3zslzn6qa6lfvbvhgi4@7vzwd55illrn>
Message-ID: <e3ef2cea-4c39-b28f-d349-04e0ce8bb16f@macbook-pro-de-camila.local>
References: <20240724010759.1631178-1-cam.alvarez.i@gmail.com> <brefgiw6mbvnpg5dmxhuwmoxfrh6upw3zslzn6qa6lfvbvhgi4@7vzwd55illrn>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII; format=flowed



On Fri, 2 Aug 2024, Kent Overstreet wrote:

> On Tue, Jul 23, 2024 at 09:08:00PM GMT, Camila Alvarez wrote:
>> bch2_extent_fallocate should not return -BCH_ERR_transaction_restart_nested when there are no buckets available.
>> Returning -BCH_ERR_transaction_restart_nested causes the sector allocation to retry even if there's no space available.
>
> It seems like you're saying this fixes a livelock, but I don't see that:
> if we return operation_blocked, the closure_sync we do before we return
> will still wait.
>
> More explanation?
>
Yes, sorry for the delay. The closure_sync will still wait, but even after 
waiting there's no space left.
I think the issue is that we're trying to allocate a bucket when none are 
available:
closure_wait(&c->freelist_wait, cl);

journal_write_done is called at some point:
bch2_do_discard(c)
closure_wake_up(&c->freelist_wait)
...

That apparently doesn't free any buckets (should we add some sort of 
assertion to notify us when this happens?), so there is still no space 
left, so bch2_bucket_alloc_trans keeps returning -BCH_ERR_freelist_empty.
With this bch2_alloc_sectors_start_trans return 
-BCH_err_bucket_alloc_blocked, which bch2_extent_fallocate turns into 
-BCH_ERR_transaction_restart_nested.

Finally __bchfs_fallocate sees the error as BCH_ERR_transaction_restart, 
so it tries again.
The issue is that the journal never discards any buckets so it just keeps 
retrying indefinitely.

I've been thinking, and maybe we don't want to just keep __bchfs_fallocate 
from retrying, but would prefer to control how many times it does.

Does all of this make any sense to you?


>>
>> Reported-by: syzbot+1e515cab343dbe5aa38a@syzkaller.appspotmail.com
>> Signed-off-by: Camila Alvarez <cam.alvarez.i@gmail.com>
>> ---
>>  fs/bcachefs/io_misc.c | 2 --
>>  1 file changed, 2 deletions(-)
>>
>> diff --git a/fs/bcachefs/io_misc.c b/fs/bcachefs/io_misc.c
>> index 82f9170dab3f..b5b92ef030df 100644
>> --- a/fs/bcachefs/io_misc.c
>> +++ b/fs/bcachefs/io_misc.c
>> @@ -90,8 +90,6 @@ int bch2_extent_fallocate(struct btree_trans *trans,
>>  				opts.data_replicas,
>>  				opts.data_replicas,
>>  				BCH_WATERMARK_normal, 0, &cl, &wp);
>> -		if (bch2_err_matches(ret, BCH_ERR_operation_blocked))
>> -			ret = -BCH_ERR_transaction_restart_nested;
>>  		if (ret)
>>  			goto err;
>>
>> --
>> 2.34.1
>>
>
