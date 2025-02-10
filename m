Received: from mail-qt1-f182.google.com (mail-qt1-f182.google.com [209.85.160.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8754824FC07
	for <linux-bcachefs@vger.kernel.org>; Mon, 10 Feb 2025 16:54:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739206487; cv=none; b=NuFbMa9T5jPC672uMJAtSZPUCjfKyA44dIWakp1Gk1HkkIBkxnesxOQ+e1DWF7v0DrVFvCXCF1+zRnr0JkGy2tmmA7koRYTy5YuM6pMMbOUiFw2x7rCoJOhYxPw/otWUh1DOxJvV6FPY6IZKZbIPacqs016M3cCbiHgTK4Zu2z0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739206487; c=relaxed/simple;
	bh=4uZCZVZ1UVoG/ZpS0oGh2JjKXvOi43TkE2KOTid6w6s=;
	h=Content-Type:Mime-Version:Subject:From:In-Reply-To:Date:Cc:
	 Message-Id:References:To; b=SZTI81BSZMM1aEndTeGZ56VWcQL+04ZmakUeiit7qwjQ4I3Elw/Le9qIzxCzOizHMYYmsaI/MQ3vS+U+LWJC6Czn1ptIYkWpA03lHtXyrooyFrm4Hj+YbTUEqLb3n9icKErEI9xdzmlChTZZKYwgosTT1EuMa8N1dLO1TpKNXUc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=lMZ3UJg7; arc=none smtp.client-ip=209.85.160.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="lMZ3UJg7"
Received: by mail-qt1-f182.google.com with SMTP id d75a77b69052e-47182317174so21744241cf.2
        for <linux-bcachefs@vger.kernel.org>; Mon, 10 Feb 2025 08:54:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1739206484; x=1739811284; darn=vger.kernel.org;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=9zFBKMg9K9GlnZoEFAFiNs8HgLe6VZNR+V2jQ4sE2AM=;
        b=lMZ3UJg7VvD598GDQgB/bZjemGF/Wkj3s5bZtcLk+3kq7oyoU2H57kaFX4DW2k+vJ4
         YktOageOk/Z95Dv9hKx0w7b+5gCpY2ReOkQWfPDIhp+4FI7IMpSz1olA2M8zNhDXzU1s
         rXACzneXmKuEiZ7Pxna466kdYTmMaR2ZGyLlK92CT+HLJGg8Ttx9KlobsvGw+cu5QDA8
         d0wHLkayRGWeOHFElmKZvdbZJE6rtuJ3os2W2t+qOAB6qHCAQOAC2BJZNVMOJ0fpBJhq
         8Y4FwVWqdvjQgzD4IqpknFOvXKVvWVyOq+U/0BwL/wuiREb14t8k01dVb+8Hf/MqOLJU
         ybtw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739206484; x=1739811284;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=9zFBKMg9K9GlnZoEFAFiNs8HgLe6VZNR+V2jQ4sE2AM=;
        b=qBNy4dEH0/WrJQAaL5is+UhDA3ooBkvcD/0KscYMUoqePQex3+cgd98OqOkp8LnQoY
         kUgUCJASYZl5JRgrGGA9D26/t/pkwga1oQrCkJPwtf4uVBb/4g6Q6AGgaH8f+GEwd4Vt
         zq4NtXMfDDpjfWMbkbzXtLsFxiH3waukFqZ5FQjxZSf4l54EK4I7H5X3D63XTWy6P1j7
         FXAjYGCfkGvy2YNjXbCPs8IfYIg60+je733ZFrvin1HZS09vGjrGxsa+yu5NjJo5Cn+Y
         rN+ty/DGMtP4znmpnMXFuNGEm2U4ZWK3sj3bTZZ34LThseRf0WVxX2H2thjg+VvP9GAU
         KjYg==
X-Gm-Message-State: AOJu0Yzbj6eXfKyohHfbWNsRbm6jqpJg3fZbHcXkTi6/ArcRbAao64sr
	TDKOcSwHF5dEtggcU/Rf+yhDeI3/i944stxcgFKXFfpyU/fBpHWwQweR6g/QIVU=
X-Gm-Gg: ASbGncseMpXhqsNUwU4JyWuSmNA0Uwe1mK63oh04ra04WjlJicX8WNgbq/jcuzJFFYp
	dbLqD65ecDAYtDCC2OdbWhzxJ1c50gqoNUIpAumcWgDOlh00d7CPcfN9YM+LmpYzxbEkWnRjPqT
	+SWd3zP6UksqkCIYUWTdDM8G/cz99utxBhHVwd4SNlelteGP+uMoBFfDDyO8DWND6lbG4cos/At
	B1VP4fI5XkiVt6I9JZ2CiH27Mg6X+gcfMmZxBtLP1SLT40d5TXYaOHCMoS/8axEoOXW+tGDYhs=
X-Google-Smtp-Source: AGHT+IGhsLEPpsvWiBklA9hNvhrsKDb1ln9Qn3FSrBb8kAzv+LPc2dZWdsWSvz/5DSy2t+WfwnqRDw==
X-Received: by 2002:a05:6214:da6:b0:6d8:97ea:4362 with SMTP id 6a1803df08f44-6e4456f7480mr202862166d6.38.1739206484373;
        Mon, 10 Feb 2025 08:54:44 -0800 (PST)
Received: from smtpclient.apple ([2402:d0c0:11:86::1])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-6e43fd17799sm45369726d6.2.2025.02.10.08.54.42
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 10 Feb 2025 08:54:43 -0800 (PST)
Content-Type: text/plain;
	charset=us-ascii
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3826.400.131.1.6\))
Subject: Re: [PATCH] bcachefs: Fix use after free
From: Alan Huang <mmpgouride@gmail.com>
In-Reply-To: <glle55a36q4zzr72fa7a2n7gkp6z6xq26usmuxrojwlyctfxz7@mzhqlaumf64g>
Date: Tue, 11 Feb 2025 00:54:29 +0800
Cc: linux-bcachefs@vger.kernel.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <65D10A49-9A37-4844-9DE7-838205FF375C@gmail.com>
References: <20250210030422.711912-1-mmpgouride@gmail.com>
 <20250210030422.711912-2-mmpgouride@gmail.com>
 <glle55a36q4zzr72fa7a2n7gkp6z6xq26usmuxrojwlyctfxz7@mzhqlaumf64g>
To: Kent Overstreet <kent.overstreet@linux.dev>
X-Mailer: Apple Mail (2.3826.400.131.1.6)

On Feb 11, 2025, at 00:28, Kent Overstreet <kent.overstreet@linux.dev> =
wrote:
>=20
> On Mon, Feb 10, 2025 at 11:04:22AM +0800, Alan Huang wrote:
>> acc->k.data should be used with the lock hold:
>=20
> <snipped>
>=20
>>=20
>> Signed-off-by: Alan Huang <mmpgouride@gmail.com>
>=20
>=20
> Test this with lockdep (you know how to edit the lists of tests the CI
> runs, right?

The lockdep test group is in the tests lists.

Or you mean add tests in the lockdep group ?=20

>=20
> mark_lock usage is a giant mess, and calling percpu_down_read()
> recursively by accident will mostly work, until it doesn't.
>=20
>> ---
>> fs/bcachefs/disk_accounting.h | 2 ++
>> 1 file changed, 2 insertions(+)
>>=20
>> diff --git a/fs/bcachefs/disk_accounting.h =
b/fs/bcachefs/disk_accounting.h
>> index 5360cbb3ec29..f4372cafea2e 100644
>> --- a/fs/bcachefs/disk_accounting.h
>> +++ b/fs/bcachefs/disk_accounting.h
>> @@ -210,11 +210,13 @@ static inline void =
bch2_accounting_mem_read_counters(struct bch_accounting_mem *
>> static inline void bch2_accounting_mem_read(struct bch_fs *c, struct =
bpos p,
>>    u64 *v, unsigned nr)
>> {
>> + percpu_down_read(&c->mark_lock);
>> struct bch_accounting_mem *acc =3D &c->accounting;
>> unsigned idx =3D eytzinger0_find(acc->k.data, acc->k.nr, =
sizeof(acc->k.data[0]),
>>       accounting_pos_cmp, &p);
>>=20
>> bch2_accounting_mem_read_counters(acc, idx, v, nr, false);
>> + percpu_up_read(&c->mark_lock);
>> }
>>=20
>> static inline struct bversion journal_pos_to_bversion(struct =
journal_res *res, unsigned offset)
>> --=20
>> 2.47.0
>>=20

