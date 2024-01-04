Received: from mail-lj1-f178.google.com (mail-lj1-f178.google.com [209.85.208.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9FE1E200A5
	for <linux-bcachefs@vger.kernel.org>; Thu,  4 Jan 2024 07:43:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=dubeyko.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=dubeyko.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=dubeyko-com.20230601.gappssmtp.com header.i=@dubeyko-com.20230601.gappssmtp.com header.b="jiGStf/U"
Received: by mail-lj1-f178.google.com with SMTP id 38308e7fff4ca-2cd08f0c12aso2487161fa.0
        for <linux-bcachefs@vger.kernel.org>; Wed, 03 Jan 2024 23:43:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=dubeyko-com.20230601.gappssmtp.com; s=20230601; t=1704354236; x=1704959036; darn=vger.kernel.org;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=W1yThAJfEzlOfxwivhZ6fEV4ArFBKNTkjUY01E38OUc=;
        b=jiGStf/U7sX4wckOBg9k33xpGzJ9DrwzXWvS45Z2RXFld+hTex5hJS7xvPdh1PgzF1
         76ycvdFQjGQyhMSQO2bLfxTumXACLdyzi+dmu3QVzTQ9Ij2rbnqpEF534wtj1fGEptPp
         1V4E9EyjzAqS+7ImTJdZKCFbBs4Yc1XYopGrjxKWXyzJTaV277AcK+15pEyou34kuCXV
         RAj67/9ErT8ET/r3XiANnONFwJBLvU0i1sslCtAniIKTxw9KWe3YHEShNsfUxZ6ffsux
         URQxyq2ATNdtO9WyIjB6FB2G0igeXzPB3BiLme6fyJWBMXJDIy/H2Zs/jdWiS01Q/VkW
         6D+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1704354236; x=1704959036;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=W1yThAJfEzlOfxwivhZ6fEV4ArFBKNTkjUY01E38OUc=;
        b=TuS989uw7Rt8RrQTIyzHtxFUzmjxI0wVB9XegBU9X7RD0zNqnFx+jTjIuV+gUUcinn
         kCeUOOMmKquegnsOKapn/ILu8qv2v//Q8GJjPc6VJPrFVq6Aky0HK5Xy0a5312+MUNsE
         iiewkNXNi9eJ0ZSTX9okAm5RGCm7xoaqF96G961uBd7raB7CpDopWVcbl8iPQuorST+y
         nKmX2b6+VJwtHWRo7lR6CnUAXWLrLknRXw0v3kByCpE417PeJHDA6wicGwYzNxz9jdcE
         ignToKQwlFR9wRVgwpP7AJR5slOsi3zoFU/aOevL5OEfPRk9rCWwYAe8AIDmOnItDXUM
         jpbA==
X-Gm-Message-State: AOJu0Yy09AudkOoRCmfcpyMM75ZwTpe0NWOLCAYp2Qcua03ciLRuBL2z
	eYJ3/QYYwxvLKgAy32wwSLAy+v3dRdZZPQ==
X-Google-Smtp-Source: AGHT+IFosEy9Q4acYcwWdLKciqfLUnI9EMQ7EDAWnAxSzSS/1EmOsbOqZAxSr7g9TgtWbWJSvMfREg==
X-Received: by 2002:a2e:9d84:0:b0:2cd:1d26:232 with SMTP id c4-20020a2e9d84000000b002cd1d260232mr71013ljj.2.1704354236372;
        Wed, 03 Jan 2024 23:43:56 -0800 (PST)
Received: from smtpclient.apple ([2a00:1370:81a4:169c:b9b3:d30e:5f66:5758])
        by smtp.gmail.com with ESMTPSA id k10-20020a2e920a000000b002ccad70dacfsm5345916ljg.26.2024.01.03.23.43.55
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 03 Jan 2024 23:43:55 -0800 (PST)
Content-Type: text/plain;
	charset=utf-8
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3696.120.41.1.4\))
Subject: Re: [LSF/MM/BPF TOPIC] bcachefs
From: Viacheslav Dubeyko <slava@dubeyko.com>
In-Reply-To: <cgivkso5ugccwkhtd5rh3d6rkoxdrra3hxgxhp5e5m45kn623s@f6hd3iajb3zg>
Date: Thu, 4 Jan 2024 10:43:49 +0300
Cc: lsf-pc@lists.linux-foundation.org,
 linux-bcachefs@vger.kernel.org,
 linux-fsdevel@vger.kernel.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <D7F7675E-B615-48DC-B4D8-63B867B25887@dubeyko.com>
References: <i6ugxvkuz7fsnfoqlnmtjyy2owfyr4nlkszdxkexxixxbafhqa@mbsiiiw2jwqi>
 <3EB6181B-2BEA-49BE-A290-AFDE21FFD55F@dubeyko.com>
 <mpvktfgmdhcjohcwg24ssxli3nrv2nu6ev6hyvszabyik2oiam@axba2nsiovyx>
 <74751256-EA58-4EBB-8CA9-F1DD5E2F23FA@dubeyko.com>
 <cgivkso5ugccwkhtd5rh3d6rkoxdrra3hxgxhp5e5m45kn623s@f6hd3iajb3zg>
To: Kent Overstreet <kent.overstreet@linux.dev>
X-Mailer: Apple Mail (2.3696.120.41.1.4)



> On Jan 3, 2024, at 8:52 PM, Kent Overstreet =
<kent.overstreet@linux.dev> wrote:
>=20
> On Wed, Jan 03, 2024 at 10:39:50AM +0300, Viacheslav Dubeyko wrote:
>>=20
>>=20
>>> On Jan 2, 2024, at 7:05 PM, Kent Overstreet =
<kent.overstreet@linux.dev> wrote:
>>>=20
>>> On Tue, Jan 02, 2024 at 11:02:59AM +0300, Viacheslav Dubeyko wrote:
>>>>=20
>>>>=20
>>>>> On Jan 2, 2024, at 1:56 AM, Kent Overstreet =
<kent.overstreet@linux.dev> wrote:
>>>>>=20
>>>>> LSF topic: bcachefs status & roadmap
>>>>>=20
>>>>=20
>>>> <skipped>
>>>>=20
>>>>>=20
>>>>> A delayed allocation for btree nodes mode is coming, which is the =
main
>>>>> piece needed for ZNS support
>>>>>=20
>>>>=20
>>>> I could miss some emails. But have you shared the vision of ZNS =
support
>>>> architecture for the case of bcachefs already? It will be =
interesting to hear
>>>> the high-level concept.
>>>=20
>>> There's not a whole lot to it. bcache/bcachefs allocation is already
>>> bucket based, where the model is that we allocate a bucket, then =
write
>>> to it sequentially and never overwrite until the whole bucket is =
reused.
>>>=20
>>> The main exception has been btree nodes, which are log structured =
and
>>> typically smaller than a bucket; that doesn't break the "no =
overwrites"
>>> property ZNS wants, but it does mean writes within a bucket aren't
>>> happening sequentially.
>>>=20
>>> So I'm adding a mode where every time we do a btree node write we =
write
>>> out the whole node to a new location, instead of appending at an
>>> existing location. It won't be as efficient for random updates =
across a
>>> large working set, but in practice that doesn't happen too much; =
average
>>> btree write size has always been quite high on any filesystem I've
>>> looked at.
>>>=20
>>> Aside from that, it's mostly just plumbing and integration; bcachefs =
on
>>> ZNS will work pretty much just the same as bcachefs on regular block =
devices.
>>=20
>> I assume that you are aware about limited number of open/active zones
>> on ZNS device. It means that you can open for write operations
>> only N zones simultaneously (for example, 14 zones for the case of =
WDC
>> ZNS device). Can bcachefs survive with such limitation? Can you limit =
the number
>> of buckets for write operations?
>=20
> Yes, open/active zones correspond to write points in the bcachefs
> allocator. The default number of write points is 32 for user writes =
plus
> a few for internal ones, but it's not a problem to run with fewer.
>=20

Frankly speaking, the 14 open/active zones limitation is extreme case.
Samsung provides bigger number for available open/active zones in ZNS =
SSD.
Even WDC made some promise to increase this number. But what=E2=80=99s =
the minimal
possible number of write pointers that can give opportunity for bcachefs =
still work
and survive in the environment of limited number of open/active zones?

So, does this change from default 32 write pointers to smaller number =
require
modification of file system driver logic (or maybe even on-disk layout)?
Or this is configurable parameter of file system? Is it internal =
configuration parameter
or end-user can configure the number of write pointers?

I see from documentation that expected size of the bucket is 128KB - =
8MB.
Will 256MB - 2GB bucket size being digested by bcachefs without any =
modifications?
Or it could require some modification of logic (or even on-disk layout)? =
It=E2=80=99s pretty
significant bucket size change for my taste.

Thanks,
Slava.


