Received: from mail-ed1-f46.google.com (mail-ed1-f46.google.com [209.85.208.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF77B2D60C
	for <linux-bcachefs@vger.kernel.org>; Sun, 25 Aug 2024 23:08:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724627324; cv=none; b=V9wnf98RoK3fzvroEG9dj5e7qsG7ZXniHYeySQh+kLc/jQHcxR5KqtHk1Yd5+lQegwva2jy1TN37XZBjG+YBVRMBCLLLuPEI25kz9+0vlC6iFyhIbns0H4LfxnwahO1taadPftaIhTB5Dda7+veNPdKRCgzvJPslnalNHfon4JE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724627324; c=relaxed/simple;
	bh=l1YnkZD2b0dlszMvh2LxAMWIMItwhBTGkPXuJ21BGMg=;
	h=Content-Type:Mime-Version:Subject:From:In-Reply-To:Date:Cc:
	 Message-Id:References:To; b=VUEIngKrAL2imLauKVHwHIqZJJrwY6ctAI/IUttI7dR9phIxsHXTpx5/y9w75Jbdz1vpkFK3JD5mTH0VVBAigCju7DzDCCmuGHqTuHxAJybA857NFAEuekSTZJLpMfx0hNmxBNwkDkQ2BslKYIno6zcuYO3ECtXUX3R8KF/jRcI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=toblux.com; spf=none smtp.mailfrom=toblux.com; dkim=pass (2048-bit key) header.d=toblux-com.20230601.gappssmtp.com header.i=@toblux-com.20230601.gappssmtp.com header.b=e7fqHKUX; arc=none smtp.client-ip=209.85.208.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=toblux.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=toblux.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=toblux-com.20230601.gappssmtp.com header.i=@toblux-com.20230601.gappssmtp.com header.b="e7fqHKUX"
Received: by mail-ed1-f46.google.com with SMTP id 4fb4d7f45d1cf-5bebc865578so610990a12.0
        for <linux-bcachefs@vger.kernel.org>; Sun, 25 Aug 2024 16:08:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toblux-com.20230601.gappssmtp.com; s=20230601; t=1724627321; x=1725232121; darn=vger.kernel.org;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=UytFMOOHKEBtcJvg+LbBTbaOOhRRX+APlfie5Ku5YlA=;
        b=e7fqHKUXsM8+9iPtlkplNMSoBzzY5LVaB5sKOLEGh8zEnwBIVKYVcovLHO4VbGzdpC
         8F6CAuBWMncesrtRQaSjsMziipRoauPOd66EvU1XvbYc92IOOPhVfc6vpejhS9e1Hlgm
         XLj4dS8zOgkFyYaQaF03PV5Q4kie2ieLwsydHWDdIEklY/SiojH75YseejCbeAWO8qZi
         PcMHJy2knWrGWSX3+y0l8cXuDuavhiZ+XpV1UuxNaf/J33utwT7L+RQOV45uTqPt4Ci1
         5oIzVV5R4xhBnhn1UUDEvvr7cjjn6iV2APS9NdAWwYOFD3ni/4oqLfycjkE0atzUdN7Y
         crSQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1724627321; x=1725232121;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=UytFMOOHKEBtcJvg+LbBTbaOOhRRX+APlfie5Ku5YlA=;
        b=jgPOI9Ku3MYoOVb02eIvulioac09qDiTlcrN9K2p/FIBT7oz5rHfLVulOseHnlR8eX
         o4L7SXANW67HHcZxet2L68egQ+JWjK7KVk8zV23sfsyA7kC1D6r4I/Moov/q0NSUFXIp
         tUmFzYvWdaQn8w5UrCXxWZxgV8TpgCG6CQL9leS6GOwO2BvrO1HZ9P2tHGK17KRQtenQ
         p6TUWzmKqO9ZQ+rS8uRArK7MbsfBdHLHcfhiUDTOPz9j39xYwqPhdsn7+/OJsDWrIgfx
         V3ndDp+xSxFKwFZMtOg4z08jkw83RRB1tQ4z56A2Qb5KR3e4S0QfV5d/ZlSvFDAVwOys
         jigg==
X-Forwarded-Encrypted: i=1; AJvYcCUEgzWPqVpCXEgtI1NrECLlLZYKgCrNCk+ZllCLWr7UKBETr0x0OHw/Is/8yXoFc/lWfJNcxyefNjjLV4zMUA==@vger.kernel.org
X-Gm-Message-State: AOJu0YxkytXKyM3O+W9LxeYHD6yxGD4xrpezELr1trv/p4H70/GQ3jsK
	moe4XTVH8LY7MOXtBNwAgUg1J1Ro54NqrKRPmo/B3i0+ALg2CaO4pe5rishxCNM=
X-Google-Smtp-Source: AGHT+IEiITXZLqaa7yIM0q+pllK1uJpD3DSQHbZ9hsgKwqYF2Nyf/Q7/+ImG6j5NEdF2OoGqNUTNeg==
X-Received: by 2002:a17:906:6a13:b0:a79:a1b2:1a5e with SMTP id a640c23a62f3a-a86a54da3ecmr273582566b.10.1724627321003;
        Sun, 25 Aug 2024 16:08:41 -0700 (PDT)
Received: from smtpclient.apple ([2001:a61:1050:bb01:8cae:d35d:b93e:b368])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a868f436607sm586796366b.105.2024.08.25.16.08.40
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 25 Aug 2024 16:08:40 -0700 (PDT)
Content-Type: text/plain;
	charset=us-ascii
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3776.700.51\))
Subject: Re: [PATCH] bcachefs: Annotate bch_replicas_entry_{v0,v1} with
 __counted_by()
From: Thorsten Blum <thorsten.blum@toblux.com>
In-Reply-To: <b7eqkyfv4nvxlserwuknw73y4c4n25b2i36xfsn4cfhjg4yc2n@oawo2z4ye6lo>
Date: Mon, 26 Aug 2024 01:08:29 +0200
Cc: Kees Cook <kees@kernel.org>,
 "Gustavo A. R. Silva" <gustavoars@kernel.org>,
 linux-bcachefs@vger.kernel.org,
 LKML <linux-kernel@vger.kernel.org>,
 linux-hardening@vger.kernel.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <6B15FD73-8FD5-4180-9190-FA8ABF7E88BB@toblux.com>
References: <20240825133601.24036-2-thorsten.blum@toblux.com>
 <cqyrlfpjprkwdteljmtcnl3z2etzitvodrlv7v57tuizvklpcx@gg7dbstowwd6>
 <4911B345-A37E-4FB9-9339-83029033EE4D@toblux.com>
 <b7eqkyfv4nvxlserwuknw73y4c4n25b2i36xfsn4cfhjg4yc2n@oawo2z4ye6lo>
To: Kent Overstreet <kent.overstreet@linux.dev>
X-Mailer: Apple Mail (2.3776.700.51)

On 26. Aug 2024, at 00:56, Kent Overstreet <kent.overstreet@linux.dev> =
wrote:
> On Sun, Aug 25, 2024 at 10:41:55PM GMT, Thorsten Blum wrote:
>> On 25. Aug 2024, at 20:43, Kent Overstreet =
<kent.overstreet@linux.dev> wrote:
>>> On Sun, Aug 25, 2024 at 03:36:02PM GMT, Thorsten Blum wrote:
>>>> Add the __counted_by compiler attribute to the flexible array =
members
>>>> devs to improve access bounds-checking via CONFIG_UBSAN_BOUNDS and
>>>> CONFIG_FORTIFY_SOURCE.
>>>>=20
>>>> Increment nr_devs before adding a new device to the devs array and
>>>> adjust the array indexes accordingly.
>>>=20
>>> The nr_devs changes are pretty gross - please add a helper for that
>>=20
>> How about a macro in replicas_format.h like this:
>>=20
>> #define replicas_entry_add_dev(e, d) ({
>> 	(e)->nr_devs++;
>> 	(e)->devs[(e)->nr_devs - 1] =3D (d);
>> })
>=20
> Does it need to be a macro?

It could also be two functions, one for each struct.

Which one do you prefer?=
