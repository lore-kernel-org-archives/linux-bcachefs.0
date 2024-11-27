Received: from mail-oa1-f51.google.com (mail-oa1-f51.google.com [209.85.160.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A0ACE191F75
	for <linux-bcachefs@vger.kernel.org>; Wed, 27 Nov 2024 21:59:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732744761; cv=none; b=fkCwxm5QL/a2g3BR3qgvPoXzUkTsD7MCY5LYqGSX/tnhh/YTY9zpeEbjclMuuh7E6BeWJwM+ZLZe7a3p+lpLfNutCl/fczYS7M92DeTxjz3EJSYt+9UBczBIvgfv8Y5qcGTRho9Pu0Yu4TKk8DN8C0yBJejc+OEfvV/ZX0Axnz0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732744761; c=relaxed/simple;
	bh=EpyCOs+Z6zkty7izlchz1P6j2Gr7jr27psSLsCj9icE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=b4pIYHU9cXCiUN8kzKBdBtEHp6yB/FCQy/l/0DCtaAiGtAdxGr/0M8jLQCA3141CpYcyIaIVmxz+lDAR6n+bU8KDkvzeV4igwVkHHzd3F5PEs5wa9Ds5CBG117ugczt2hnQFMoBob1QI3wLiR8Ask4f00rYHJaWzzbKb8mBAWVQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=rhcPvC+T; arc=none smtp.client-ip=209.85.160.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="rhcPvC+T"
Received: by mail-oa1-f51.google.com with SMTP id 586e51a60fabf-296b0d23303so138448fac.2
        for <linux-bcachefs@vger.kernel.org>; Wed, 27 Nov 2024 13:59:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1732744759; x=1733349559; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=12XoOV+ch7FCQfE6NT5kyo9s5lIlHBLbYoEQq9a6XfA=;
        b=rhcPvC+TBOFBCsI8SzBGFRmLT5HbxCN4237pKjoaN98bV0dF46hdVm0VKAxvgwX0kE
         QjtBUwyy0dWU+dsSbLKqbIjkCZCMPmEL7MATJxuBj0ODITDEgFLAVd182zBmuiSzxwTs
         nqwi4PehfHfTzAR8fOD1ARX7XEyvkD/jSFFIn9uqOYAvqOLK6mK9kBrEOOr4dUaWiVqs
         u8SEAtjOIBVgmh6xv/e/OIP0F17nl6s8+wLgV56c3GkYsdv5u0EBXAiDCpY2bNiUnRjp
         hs/ueh0xNU+n0ikmHlKYxBfB8dIaC7ptIRXVw8O3apCe/xmPkR5RnqVR+xjfOXBt5yOK
         AL2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732744759; x=1733349559;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=12XoOV+ch7FCQfE6NT5kyo9s5lIlHBLbYoEQq9a6XfA=;
        b=PvqdzS9/LJ9XXOl7CJ4ybULxvMRsrzQ1ChMHUV7JfeLV1p6ij9i2S3uULv2WNUQtvb
         RRjozYN1HXiqvnTsdQ3KIWcNsMqkhuFZTjMCGIZZmi/baehHRnik7Mlzdrs43qNO0QW0
         ZluERiDPLwjibWu9xn4KyZwJvvPgFkNumHZ6kuU7Prjk5CGVvJN22EFIoaq0vfVQ9SAW
         scYr/Be2zwyge92txV+BPfoTinEGjnpOx8/tKu1Q2lfMAUSsqpXhzL+01ShZPpVKtV+p
         SJuHJw3RnpKck5TQvjb+NI88jZC47Cyv+t5ksliIi2Acw0n6HR8cnYPK+YVfEnzOJnn5
         PU/A==
X-Forwarded-Encrypted: i=1; AJvYcCW2GTSBMJOC1n+QmnI7VpfyiuazPWICGMIBmxR1QcCwc2bmRnbgBZSO1hbKUtg7p5fBb/Pxgg7N5htTYQQepQ==@vger.kernel.org
X-Gm-Message-State: AOJu0Yykd6MgjTe40T+kVQCC3GB5YBZ7kWf6YKMKcQ54Ug7AsziNm7x/
	IA4PXGPx/oDQU/BTERFzZJIrlHuOMRorYXk5l6PbGclyBhjpNWp8iC2SINbIAWg=
X-Gm-Gg: ASbGnctmQrmBYN81vqK2EX7NO2DqkeMRjpFfo+t9oXYAcIY9EyujfTeUC2q9O0DsMIw
	18wxAG5wqujrZM7seFTeRo30dOzHTUxUglBpsNDw2MpHuoBTZjFbH/hALZtiEH91bTS/CVZW43D
	wVooz7laOvIv3ilnk//PwgDYXEgTYkrjUN9lW2Mq6lvCBYFUHT3yPv3arHj02fKydhBjHGHH3bU
	h/3OLIA4CqzxgMggYTRMvnNQxNYlpc1oxR06SP0Y4uvHg==
X-Google-Smtp-Source: AGHT+IGYQ3xEulXjbu30BXlZ0Yu1r2OXM2Ccr9z7cb2HBdSqRoErM0v/jPNzqRHD5gtEaEL9CcuTTA==
X-Received: by 2002:a05:6870:4688:b0:296:a768:9ef9 with SMTP id 586e51a60fabf-29dc4386588mr4340872fac.42.1732744758803;
        Wed, 27 Nov 2024 13:59:18 -0800 (PST)
Received: from [192.168.1.116] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 586e51a60fabf-29de902d0a3sm48093fac.20.2024.11.27.13.59.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 27 Nov 2024 13:59:18 -0800 (PST)
Message-ID: <97465113-ea1a-4cee-9235-d6900158aa74@kernel.dk>
Date: Wed, 27 Nov 2024 14:59:17 -0700
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: bcachefs: suspicious mm pointer in struct dio_write
To: Kent Overstreet <kent.overstreet@linux.dev>
Cc: Jann Horn <jannh@google.com>, linux-bcachefs@vger.kernel.org,
 kernel list <linux-kernel@vger.kernel.org>,
 Pavel Begunkov <asml.silence@gmail.com>, io-uring <io-uring@vger.kernel.org>
References: <CAG48ez21ZtMJ6gcUND6bLV6XD6b--CXmKSRjKq+D33jhRh1LPw@mail.gmail.com>
 <69510752-d6f9-4cf1-b93d-dcd249d911ef@kernel.dk>
 <3ajlmjyqz6aregccuysq3juhxrxy5zzgdrufrfwjfab55cv2aa@oneydwsnucnj>
 <CAG48ez2y+6dJq2ghiMesKjZ38Rm7aHc7hShWJDbBL0Baup-HyQ@mail.gmail.com>
 <k7nnmegjogf4h5ubos7a6c4cveszrvu25g5zunoownil3klpok@jnotdc7q6ic2>
 <4f7e45b6-c237-404a-a4c0-4929fa3f1c4b@kernel.dk>
 <tt4mrwkwh74tc26nkkeaypci74pcmvupqcdljavlimefeitntc@6tit5kojq5ha>
 <3c24016e-a24c-4b7f-beca-990ef0d91bfe@kernel.dk>
 <hrx6kaqeyqdchmv24xivrooyimackqx5mxm6vlvj3y5gusxgno@gjsbtm76unrs>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <hrx6kaqeyqdchmv24xivrooyimackqx5mxm6vlvj3y5gusxgno@gjsbtm76unrs>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 11/27/24 2:58 PM, Kent Overstreet wrote:
>>> By the way, did the lifetime issue that was causing umount/remount to
>>> fail ever get resolved? I've currently got no test coverage for
>>> io_uring, would be nice to flip that back on.
>>
>> Nope, I do have an updated branch since then, but it's still sitting
>> waiting on getting a bit more love. I suspect it'll be done for 6.14.
> 
> Alright - if you want to ping me when that's ready, along with any other
> knobs I should flip on for io_uring support, I'll flip io_uring back on
> in my test infrastructure at that time.

Will do, thanks.

-- 
Jens Axboe
