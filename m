Received: from mail-ot1-f50.google.com (mail-ot1-f50.google.com [209.85.210.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF2688286A;
	Thu, 18 Jul 2024 23:15:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721344549; cv=none; b=M60yX+gRaUEdZjm9WRJIe/ufm/RIwrTAZwu1HRYoUkbwTTbylq3g7yqb5P1OU1rYgJw34w/GoB1fCDP7y8fq4vUqIc6G9v3slyVD6eAOkfgNUBY2ODl06W1RU5vskJ8cTUyR/sSDWNc4VLBTMO4OjRSHWeZBGTUoTkZEe/PvkQM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721344549; c=relaxed/simple;
	bh=bCSx+225gG4G7sVhE9CNpQZcsPEeRrTT3+TaUa61mAw=;
	h=From:Date:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=ejFpYbnyZdjH0iE6aRNVXJ/m0c279H2imjhSLjiLzW4hX92OPDtiEk32Hz0Vd7tf1hcbOhd0IxWy48bZnoGnxaL7/MmK9crNbObg0RDYiFjEbslKRQ2XRmoZemiMM0LGBTYY2FdyIv2vTcRVIsTt2QXpQ0jkQONuo0qjjaDF9a4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=CImOvTLf; arc=none smtp.client-ip=209.85.210.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="CImOvTLf"
Received: by mail-ot1-f50.google.com with SMTP id 46e09a7af769-708e75d8d7cso803422a34.3;
        Thu, 18 Jul 2024 16:15:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1721344547; x=1721949347; darn=vger.kernel.org;
        h=mime-version:references:message-id:in-reply-to:subject:cc:to:date
         :from:from:to:cc:subject:date:message-id:reply-to;
        bh=uxOZz/15ozKbSUIwYlNdXKjDgxxKmqYrbVX1sr7AdH0=;
        b=CImOvTLfOCa/gkFRw+nWhb7ORbESmGdGPUCNGPlsQBJBepbZXAOkO63346Twz5Rl/U
         ZzuFg778LV02Mv8FdhOqkP1OYpNL+2xje9K+Ai7K/IP7PItmZk2RaT2H9P1pls2mHfU4
         UByHLf9ijcexLmuLh9Q0defRd3wSm1sE4T0soMON8QGF9Ltv/6F77ep9Xj5wkNox647F
         rPQCqqocQYterXwjkSsh4WftTKD/VKCyp54RP3moBdQ3r49ip51XUIxIAyKB7wHu2obQ
         pAvJjQLnA037uf1gaKAaJC83dxrW0lRACkQbA1W7viG3eA0atB2Lh2DtU1wsat9PRb6Y
         EO8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1721344547; x=1721949347;
        h=mime-version:references:message-id:in-reply-to:subject:cc:to:date
         :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=uxOZz/15ozKbSUIwYlNdXKjDgxxKmqYrbVX1sr7AdH0=;
        b=lwxJZfBPabrOocWVHUbOFUuzyvEe1KSGyqk86ZUaBVHfP35aZciLWuKNd7UOyU5N5n
         CA8o+FuB2H7+ETFuL5WEIyMBzz21UdEkVFMWcErCG16HXRfddV5PJMYVcBOHZec59h0d
         4XENcNJPz4YFAaHEiq0aYA0Ta6sLHig2v0j2hgu4XFF1LKvwWGYJf1ZM3d8Q8dz7+Qa2
         gsw0+eoz2b2d2skolZxNWmMISAa2skhzDyjNt1BD1Vu9XmEGbFIP/fCdU0QtG55AzYZU
         NZ7CrLWL9y/BUK/i8IHL8QAiIM0dRpCgkd4Dp2Y5xuEmdNbAcM+MhXVSJhyOCLjWUl/R
         acSQ==
X-Forwarded-Encrypted: i=1; AJvYcCWgeN4i+eRNJ9As6Ln6FiC8GN3ULWz8O3rkRZeVkemvslvwn2L3mpl+hhn2dDDZcbNyuC76mJ3p+WisPHPHAqbj1lpCanRq4z9Gj56GO80PUegzmMt5Ub5krEkpq40yp8+FogL8a9PmCrO54EE=
X-Gm-Message-State: AOJu0Yw9cEILlC6LXCXWsQGg6L6W7POlWetu19q5LZYgwQGWfVQn3bPF
	Ezop3LyGJVOjBG2k19tGwwIWXqnrs0++qm6Rd7IhsSkORYAMYvWOjmkFth36
X-Google-Smtp-Source: AGHT+IHt8TxOUKWyQeyNwJLOh4+y96EAbfVRpzFBh8iz/HWr2GUDag9K0g/z1D9OQh34aZMaz2Hmrg==
X-Received: by 2002:a05:6870:95aa:b0:25e:65f:a530 with SMTP id 586e51a60fabf-260d95055a6mr4266035fac.41.1721344546832;
        Thu, 18 Jul 2024 16:15:46 -0700 (PDT)
Received: from [2800:150:146:48c:a5d5:83a7:6227:2aa6] ([2800:150:146:48c:a5d5:83a7:6227:2aa6])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-70cff4b5a3fsm82288b3a.71.2024.07.18.16.15.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 Jul 2024 16:15:46 -0700 (PDT)
From: Camila Alvarez Inostroza <cam.alvarez.i@gmail.com>
X-Google-Original-From: Camila Alvarez Inostroza <calvarez@macbook-pro-de-camila.local>
Date: Thu, 18 Jul 2024 19:15:42 -0400 (-04)
To: Kent Overstreet <kent.overstreet@linux.dev>
cc: Camila Alvarez Inostroza <cam.alvarez.i@gmail.com>, 
    syzbot+4093905737cf289b6b38@syzkaller.appspotmail.com, 
    Brian Foster <bfoster@redhat.com>, linux-bcachefs@vger.kernel.org, 
    linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
Subject: Re: [PATCH] bcachefs: WARNING in bch2_fs_journal_stop
In-Reply-To: <6cysckb2o54lmg27htyr67mogkprkqjfipmws27fp4rhe3wxwm@edgdbatbeahw>
Message-ID: <f3814333-2f49-5563-0673-a3d3cb8354cf@macbook-pro-de-camila.local>
References: <20240717220237.1246673-1-cam.alvarez.i@gmail.com> <e2oi7a4jj4gjhzcp66rygr5d6wqlock6c5jvuwszxuej3hldmd@tnvbf45nbx2x> <6d42612b-1c20-0484-ce9f-eac509e6740d@macbook-pro-de-camila.local> <f6lmsdtntfs3ot4jc2waizihayhipszr3iuro3tzyjgbfvjwuw@ms4foq466yiz>
 <d25b7319-5b16-da76-6f07-226d1da11e16@macbook-pro-de-camila.local> <6cysckb2o54lmg27htyr67mogkprkqjfipmws27fp4rhe3wxwm@edgdbatbeahw>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="0-2087885870-1721344545=:84246"

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--0-2087885870-1721344545=:84246
Content-Type: text/plain; charset=US-ASCII; format=flowed



On Thu, 18 Jul 2024, Kent Overstreet wrote:

> On Thu, Jul 18, 2024 at 06:49:02PM GMT, Camila Alvarez Inostroza wrote:
>>
>>
>> On Thu, 18 Jul 2024, Kent Overstreet wrote:
>>
>>> On Thu, Jul 18, 2024 at 06:42:55PM GMT, Camila Alvarez Inostroza wrote:
>>>>
>>>>
>>>> On Thu, 18 Jul 2024, Kent Overstreet wrote:
>>>>
>>>>> On Wed, Jul 17, 2024 at 06:02:39PM GMT, Camila Alvarez wrote:
>>>>>> last_seq and last_empty_seq suffered from an off by one error when the
>>>>>> journal has no entries.
>>>>>>
>>>>>> The indexes were fixed and an assertion is added to check that the
>>>>>> last_empty_seq is always kept under the next valid seq number.
>>>>>
>>>>> oh nice. I'm going to need to stare at this some more, I still feel like
>>>>> this code needs to be clearer and less fiddly.
>>>>>
>>>> Sure! Please let me know if there's anything I can do to help.
>>>
>>> I'm just applying it - the warning you added gave me warm fuzzies.
>>>
>>> I'll let you know if anything pops up in the CI (and I should give you
>>> an account so you can point it at your own branches; email me a username
>>> and ssh key)
>>>
>> Should I give you the info in this same thread or in a separate email?
>
> doesn't matter, ssh pubkeys aren't secrets
>
I've attached my pubkey. You can use calvarez as my username. Thanks
--0-2087885870-1721344545=:84246
Content-Type: application/x-mspublisher; name=id_rsa.pub
Content-Transfer-Encoding: BASE64
Content-ID: <04561a5f-892a-e9df-33c5-fb18ac27d4d2@macbook-pro-de-camila.local>
Content-Description: 
Content-Disposition: attachment; filename=id_rsa.pub

c3NoLXJzYSBBQUFBQjNOemFDMXljMkVBQUFBREFRQUJBQUFCQVFDMG5XeGRm
SFVJUG9GZnkxUjhMeHBTTld2VUhPMHNiQkRFekJCY1VnNm5CZElPTlVaYUtq
ektGUG9aRXN0RG9UNTc4N1djMGQvRy8ycCtxbGVDRGVVUkNrU0J2MTlOTGds
SGw2MktjYkJZUU9PT2dJS2ZpNDVaT0RBMjJXdm9BWER0aHdlSXJtY2tlNjI1
RzNCa2hlaVR5d3E4ZXJiclVqMEJGdjBNOHFDN3kxZzBBd1pFVjRsZFE5ODFH
anB4cGJDTlVEVjEwZ2pTa1Bua3F0ZXBVbDkzZDIwT3U0UFpYZW54UENaQ3Nx
Qjl1R2lDNUgyR3d1R3JRVFFOcUFaVVdwcFBuRnlHQUc0aGZzNHJEaFR2VjBh
Y0o1MWRFcituY2RBTks1M0FERW1JMWVwWlMrLzBUZ1lxRGV6N3l0OW5zMkZy
bEI2aWVFVitOeUV4c25hWkpKeWYgY2FsdmFyZXpATWFjQm9vay1Qcm8tZGUt
Q2FtaWxhLmxvY2FsCg==

--0-2087885870-1721344545=:84246--
