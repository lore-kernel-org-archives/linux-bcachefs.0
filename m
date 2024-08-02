Received: from mail-pg1-f173.google.com (mail-pg1-f173.google.com [209.85.215.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F05E17BA4;
	Fri,  2 Aug 2024 01:51:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722563517; cv=none; b=iM8l/SqN03m0mVi8laqYR/VPw5VYWF+z2CO4hEl0wGASIwyLNFQaB7FGg/Bc+WqjXkAn0aSESeIbFtH/SUbqGa0E5kgDfex/ggXRGE/IoBEW0/seUxX3Q1QOZJzm6ldMuFdoQ+Um2fG+nbynFBBhS18nfXE43of8rm578vxk3jQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722563517; c=relaxed/simple;
	bh=JBNnV0uADYTtfu4slxKNJ6KUj/8oHz+XS9o+5CxrYYk=;
	h=From:Date:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=DuWKHy16k73hX5U+v9wFgphvb++hSuHihepT/Cw4/wevFjY62XKxh3zDci/eVgik2/MwShslkbSknsG6XNmN1R2u8jtCJbW3k1Sk2akitfypca47wzGTaoGsmldPFGHm58Av+FMIIXu8XE0xRKrzL0BRzjgOf3lZgQJJA269uXw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=CQsDUdi/; arc=none smtp.client-ip=209.85.215.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="CQsDUdi/"
Received: by mail-pg1-f173.google.com with SMTP id 41be03b00d2f7-7a18ba4143bso5569793a12.2;
        Thu, 01 Aug 2024 18:51:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1722563515; x=1723168315; darn=vger.kernel.org;
        h=mime-version:references:message-id:in-reply-to:subject:cc:to:date
         :from:from:to:cc:subject:date:message-id:reply-to;
        bh=QDmCkGOySC7BUzlBEXHv44zk9Dp2wAsf6i4H4rN57ZM=;
        b=CQsDUdi/aSjE9NZuT0Jdj3GXIFir4oV+o8LMlc2ytcNrKzSB9j5fIAffdeb8xkvpFm
         afUpUmilzwHJiBO4PP7Rkcjc88eeNoMvyp6XO3q1a0xD7MDY0/Ja+SBJ1Ds0n/iKFieA
         TXjU/EEpOdtIZuhhTF4AO0bjFGs/85GRDU1Dz9DI6pPtl7Bh7fE6PJSrPlzQcw8BVOt2
         z/SrQotuZXpHW0DNOzQ8ar+Pl87914Fv+A+paoN5oqGMke0HuEDtDjXpZCN/7yLUoWVk
         cjfQ+aEy2dWbXab9W4cjaF7WUju8LuGpMqgDImJ7HP3dEUCZ52nWu39LsXM6+gaogMGt
         5g1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1722563515; x=1723168315;
        h=mime-version:references:message-id:in-reply-to:subject:cc:to:date
         :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=QDmCkGOySC7BUzlBEXHv44zk9Dp2wAsf6i4H4rN57ZM=;
        b=XxPbfkoAL0r+XdospWVjiHxsA6d3W3+9a/XbyVJHeUoW00ZdDQ9Nyuc0x1frRh3IEQ
         FZlU3bxEsRDUvL5myFgODnh0DNlJ2iPxTU8W3AYgNc3V7/vPSsoplp9NKaFSNorosOXm
         3XxfwBTvMJUiZPpQgLXx/dE2CAuq0yUqnqF40vOJT1lxp9tQlvCqiAwd8gOuStISVxxO
         tybI97vMI3zSETpsR/vIoTNjDoJKHbLescbNKlvfTpkstjxzN7Q7RigDlAb5QsRppL57
         Hy2LSF97I2BhsRSl9SM5BeNDgDCdDAYXV4qWBiRkF2btcPfokFweLz4fFVGnvmHz4xqJ
         Mo2g==
X-Forwarded-Encrypted: i=1; AJvYcCUVSDbGBBX39B56QdTRGi32/8fvuOEX0D/TV2I/xh6sszM9pVlMjH1pSaYtKXZm95WgRNRNF9ZZtDcFAZkqFQ==@vger.kernel.org, AJvYcCUbRhLr0df2NEsXcltwHqdUDwZXHH6M/xakW1qAtWeGPVj75T9VtVSjhI49wjpWVtomYeDT87sT7EO1357T@vger.kernel.org
X-Gm-Message-State: AOJu0YznNzuCMzrG0Zm9tgc27tTC9ci9m+o2ju8JpuYLzS0OeV3O4T5W
	PYAu3J64ASVTNegT0DA6cjIyTBUypVv4WqlzM/cqXvL3mn3LYXZp
X-Google-Smtp-Source: AGHT+IE5ADnY+cIlrpWgFEOUgeDHEI30PQdtkXR/15P0nbEwGZyeetr65PqA8GXLIwnRGe4x0Licnw==
X-Received: by 2002:a05:6a20:8404:b0:1c4:d438:7dd2 with SMTP id adf61e73a8af0-1c6995ccd9dmr3425796637.32.1722563515263;
        Thu, 01 Aug 2024 18:51:55 -0700 (PDT)
Received: from [192.168.7.110] ([190.196.134.53])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-2cfdc406481sm4104020a91.2.2024.08.01.18.51.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 01 Aug 2024 18:51:54 -0700 (PDT)
From: Camila Alvarez Inostroza <cam.alvarez.i@gmail.com>
X-Google-Original-From: Camila Alvarez Inostroza <calvarez@macbook-pro-de-camila.local>
Date: Thu, 1 Aug 2024 21:51:50 -0400 (-04)
To: Camila Alvarez Inostroza <cam.alvarez.i@gmail.com>
cc: Kent Overstreet <kent.overstreet@linux.dev>, 
    syzbot+4093905737cf289b6b38@syzkaller.appspotmail.com, 
    Brian Foster <bfoster@redhat.com>, linux-bcachefs@vger.kernel.org, 
    linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
Subject: Re: [PATCH] bcachefs: WARNING in bch2_fs_journal_stop
In-Reply-To: <f3814333-2f49-5563-0673-a3d3cb8354cf@macbook-pro-de-camila.local>
Message-ID: <7252b968-829b-bc32-6832-8bc132009c64@macbook-pro-de-camila.local>
References: <20240717220237.1246673-1-cam.alvarez.i@gmail.com> <e2oi7a4jj4gjhzcp66rygr5d6wqlock6c5jvuwszxuej3hldmd@tnvbf45nbx2x> <6d42612b-1c20-0484-ce9f-eac509e6740d@macbook-pro-de-camila.local> <f6lmsdtntfs3ot4jc2waizihayhipszr3iuro3tzyjgbfvjwuw@ms4foq466yiz>
 <d25b7319-5b16-da76-6f07-226d1da11e16@macbook-pro-de-camila.local> <6cysckb2o54lmg27htyr67mogkprkqjfipmws27fp4rhe3wxwm@edgdbatbeahw> <f3814333-2f49-5563-0673-a3d3cb8354cf@macbook-pro-de-camila.local>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII; format=flowed



On Thu, 18 Jul 2024, Camila Alvarez Inostroza wrote:

>
>
> On Thu, 18 Jul 2024, Kent Overstreet wrote:
>
>> On Thu, Jul 18, 2024 at 06:49:02PM GMT, Camila Alvarez Inostroza wrote:
>>> 
>>> 
>>> On Thu, 18 Jul 2024, Kent Overstreet wrote:
>>> 
>>>> On Thu, Jul 18, 2024 at 06:42:55PM GMT, Camila Alvarez Inostroza wrote:
>>>>> 
>>>>> 
>>>>> On Thu, 18 Jul 2024, Kent Overstreet wrote:
>>>>> 
>>>>>> On Wed, Jul 17, 2024 at 06:02:39PM GMT, Camila Alvarez wrote:
>>>>>>> last_seq and last_empty_seq suffered from an off by one error when the
>>>>>>> journal has no entries.
>>>>>>> 
>>>>>>> The indexes were fixed and an assertion is added to check that the
>>>>>>> last_empty_seq is always kept under the next valid seq number.
>>>>>> 
>>>>>> oh nice. I'm going to need to stare at this some more, I still feel 
>>>>>> like
>>>>>> this code needs to be clearer and less fiddly.
>>>>>> 
>>>>> Sure! Please let me know if there's anything I can do to help.
>>>> 
>>>> I'm just applying it - the warning you added gave me warm fuzzies.
>>>> 
>>>> I'll let you know if anything pops up in the CI (and I should give you
>>>> an account so you can point it at your own branches; email me a username
>>>> and ssh key)
>>>> 
>>> Should I give you the info in this same thread or in a separate email?
>> 
>> doesn't matter, ssh pubkeys aren't secrets
>> 
> I've attached my pubkey. You can use calvarez as my username. Thanks
Hi, just wondering if you had any time to take a look at this patch.
Please let me know if you have any comments!
