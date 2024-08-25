Received: from mail-ed1-f46.google.com (mail-ed1-f46.google.com [209.85.208.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3EAB71547C0
	for <linux-bcachefs@vger.kernel.org>; Sun, 25 Aug 2024 20:42:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724618531; cv=none; b=GT2yrF56sHqJWMY8ohigZRwJrv+f4IvD7XAUuX5f5mX7EBk44N4nMTHkC8qMmvi5i9BaTTukNtCuzO6zGYDn8ZB02tHLimdkWGf/TZbnnzwNbko0yoZi1d89dzDffI0YJLfHJF4BctHu/lzf8WyGB67d8KLMdjLCuZP1iTNZjDk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724618531; c=relaxed/simple;
	bh=r3xn1fjXtcTZl8edBo8zoh5Fcl6d/czsBH6iAELNJsM=;
	h=Content-Type:Mime-Version:Subject:From:In-Reply-To:Date:Cc:
	 Message-Id:References:To; b=WCcNn7gEhymuHzJ2W/yCLhkLWc89VbAiT6VwrA6jAw3EcdItPvWDnqlon3pF94M4D2y96AVR1D0MDF1F0eYGpWOJDF18SZZsyJ18+THLb+Bhnzw1mFymWQJWdbfH3syu/U4qta1nLJgPa8qsR0NNjL9Ruwi45ZUsfaX6vHDJgzQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=toblux.com; spf=none smtp.mailfrom=toblux.com; dkim=pass (2048-bit key) header.d=toblux-com.20230601.gappssmtp.com header.i=@toblux-com.20230601.gappssmtp.com header.b=RdNqJj6G; arc=none smtp.client-ip=209.85.208.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=toblux.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=toblux.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=toblux-com.20230601.gappssmtp.com header.i=@toblux-com.20230601.gappssmtp.com header.b="RdNqJj6G"
Received: by mail-ed1-f46.google.com with SMTP id 4fb4d7f45d1cf-5bef259a71fso512681a12.1
        for <linux-bcachefs@vger.kernel.org>; Sun, 25 Aug 2024 13:42:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toblux-com.20230601.gappssmtp.com; s=20230601; t=1724618527; x=1725223327; darn=vger.kernel.org;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=/I5eaIhTOuu7Bwecqwb9kbtmtPB9TsVLIgYezcaQD2U=;
        b=RdNqJj6G0JBBTa4j6XpgmjkWnFFYI9JJeSfEV3/aDn3l5UWD7lUgMVyWmU9EUhPTEk
         Hk6rpUNhSNAJXM6TipH1vRgZsyvLSY4p4HCp4c3PW4QDZmwj1kKP2KsP1n3rrI4QjJ84
         zdmoI/2L2euvfJeOqVPoPgRuxooFuLo3jqnblDiuvfgnys0uaRRxR/GWtdqQnv0qYbjL
         rVmiklFNZ6J1h12rHtrdHQuVCu6aolCrjzbufLvzR2z/FfcXdxkXm3gUuL3x9uhFFJ+1
         qh01b/KnnyotM5UUzf9a0w+ehWFfEXh5V5BVcbqsAdNDSf9f8ahkS/jptARJN6UlJL/r
         1L9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1724618527; x=1725223327;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=/I5eaIhTOuu7Bwecqwb9kbtmtPB9TsVLIgYezcaQD2U=;
        b=c+he1s7b01Buiu8nKIxTSClgwXGTcSr34WKOmGRUIx5eDC6NgxPsqWCyglEJlLtdr7
         lgLL95rMsb58Woq/1vv0ELpM/XvK4Uh6sK2LiX9CzpMavyw2R6EzSu21ZFdz/HGNus7H
         4LYBd3NodYIxKv6yjNvo54ck6cjf6T6/cHfJWAz1joaYjakTGksCHEk34V/eQAtUq65o
         DKyOUviTq59u+t6m0Fa1zY4s1DDUcGCKEjvG7pQkr7YqW7qDkbpkutOQgVQ8MIbM6CzM
         wLOLevpjPX1GEU2ds3J9rDtsVSdSCUui0grxKpaSg5ITRU+9QKtIfsYWG+e/4twUulBu
         Th2w==
X-Forwarded-Encrypted: i=1; AJvYcCV6VcHYbakBoL2vVC4rQ9js6/x32w3WdunksLZzAfQJwVIG5zJJyMPMblgNCsERBnGDoXkq6EnzpqrE7/N7ZQ==@vger.kernel.org
X-Gm-Message-State: AOJu0Yy8aPhogY+F/nTZxWgzt+DWZ6ZGX4ShEjkpV7iGwM31GUmClcD2
	rny3Q2pFUY2Jmg1vkDUXYt54ZWL0ZkDT6jJZKdwAsxcIxnQQT11oc+9BWf41MfSzorRDj+mHmH7
	N
X-Google-Smtp-Source: AGHT+IGWrOtzUcJg5h8Rm7rriW5rbRJGNmxlSzv+N7+hdFaqRxfoh1QPwhLdabW+elDyhtoxJ8W/Gw==
X-Received: by 2002:a17:907:daa:b0:a80:79ff:6aa9 with SMTP id a640c23a62f3a-a86a54bbc5bmr299121066b.8.1724618527335;
        Sun, 25 Aug 2024 13:42:07 -0700 (PDT)
Received: from smtpclient.apple ([2001:a61:1050:bb01:8cae:d35d:b93e:b368])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a868f48a5ffsm579976266b.177.2024.08.25.13.42.06
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 25 Aug 2024 13:42:06 -0700 (PDT)
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
In-Reply-To: <cqyrlfpjprkwdteljmtcnl3z2etzitvodrlv7v57tuizvklpcx@gg7dbstowwd6>
Date: Sun, 25 Aug 2024 22:41:55 +0200
Cc: Kees Cook <kees@kernel.org>,
 "Gustavo A. R. Silva" <gustavoars@kernel.org>,
 linux-bcachefs@vger.kernel.org,
 linux-kernel@vger.kernel.org,
 linux-hardening@vger.kernel.org
Content-Transfer-Encoding: 7bit
Message-Id: <4911B345-A37E-4FB9-9339-83029033EE4D@toblux.com>
References: <20240825133601.24036-2-thorsten.blum@toblux.com>
 <cqyrlfpjprkwdteljmtcnl3z2etzitvodrlv7v57tuizvklpcx@gg7dbstowwd6>
To: Kent Overstreet <kent.overstreet@linux.dev>
X-Mailer: Apple Mail (2.3776.700.51)

On 25. Aug 2024, at 20:43, Kent Overstreet <kent.overstreet@linux.dev> wrote:
> On Sun, Aug 25, 2024 at 03:36:02PM GMT, Thorsten Blum wrote:
>> Add the __counted_by compiler attribute to the flexible array members
>> devs to improve access bounds-checking via CONFIG_UBSAN_BOUNDS and
>> CONFIG_FORTIFY_SOURCE.
>> 
>> Increment nr_devs before adding a new device to the devs array and
>> adjust the array indexes accordingly.
> 
> The nr_devs changes are pretty gross - please add a helper for that

How about a macro in replicas_format.h like this:

#define replicas_entry_add_dev(e, d) ({
	(e)->nr_devs++;
	(e)->devs[(e)->nr_devs - 1] = (d);
})

Thanks,
Thorsten
