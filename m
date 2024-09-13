Received: from mail-ot1-f51.google.com (mail-ot1-f51.google.com [209.85.210.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 948B82B9C6;
	Fri, 13 Sep 2024 15:39:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726241966; cv=none; b=VA+xPouuXtZEQnjXna2BsvEwVfJiO5V9t6VRCnue77Io+XvmCIgcY/dINe1nizrkZ5oWBNnkt0hxrNU6SSD6yxFYntTBycKVpgfjBOmHyGO/Ro0hGtbJsgkRA+MM4y2dIyh94gsn3Gs5YQu1tdjRvSydKNSuVV7PuMBNgR2mUt0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726241966; c=relaxed/simple;
	bh=tVkTgk+LeTaa5RpxrUvJK0VmFnJFAl1Lszvb2A/94Hs=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=mrCTCv96UsNsu9WGtWN1rVoj9TmbHwHe2qTsooWDmuzRKtHmgAHv9pbANX8SaunpPLsg8lOD1QRzm8cYZFZhinDAwL9c+xesxt91rn3MnzwtLbkd+6szuNiH7lZXYJGaYk128FU+4xH/cMi0v4hQF4teGv9AHc0dmm2A2mCGxdc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=jCkXYRzP; arc=none smtp.client-ip=209.85.210.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="jCkXYRzP"
Received: by mail-ot1-f51.google.com with SMTP id 46e09a7af769-709340f1cb1so254676a34.3;
        Fri, 13 Sep 2024 08:39:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1726241964; x=1726846764; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=tVkTgk+LeTaa5RpxrUvJK0VmFnJFAl1Lszvb2A/94Hs=;
        b=jCkXYRzPPvWMiyAB1rWPQf5XixPQ3toeYY4qIbFXsDJyTRUUEYLIhcWzF6pRIcRzJq
         XPPrQx7ztT3XNesWtlPrsfsZ4kp4tcif6E3CUs0k++L6vik/STbWsEsR/tmLyB5b+yOR
         z4VnfFVs1H10EKT0B9hq2PdWFj8TPbRbzsxsHw9znhi7fM+iFZuufbhp8wy56PsV6ePv
         vgAdZTzGpvt0tDgON1F23mLjyWheAcY0rCvsrM8vXRLwno45vi5xiKULKtUDg0TWLWbO
         D2U/eIXO0Iv7QvJUHSCie4F56HQ7ZMHrhmV+itfHtZLEyCMQ7Y3zQ53Dgc0oDYyVxNOp
         sRMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1726241964; x=1726846764;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=tVkTgk+LeTaa5RpxrUvJK0VmFnJFAl1Lszvb2A/94Hs=;
        b=ueaX0hFlm9sbElNubIvKuUWC6kZuH95JYozXk0kSIpVG8VTnkzLfEAc6Ql1G3HoOEP
         Nct12tmn8EtYoJ5m9Y8zICyqQANF1ZfXX64zMsimXn5Zhomy2omXf0+4PrHxCxABeq7y
         G4qglPfIdYdT6GnNqS37TCPnosxBG6HqFIw1jPOFGWjIDhFXSBHKPkOaOs/8ur0RZCwl
         bXhDskoaZ6XoaqL23p+uwErtKNylhT3UIVFofev7RfJdhMVIvka92f11fnCTMXwpO1qy
         X6+8bVAFGKd/+M7Jl71d8F4+Flkjrostla342y5guT8Pq/bxiJVatboqxJuKJl9fHryW
         Hdqw==
X-Forwarded-Encrypted: i=1; AJvYcCVaupt1YDhOrMzOtdnA5kcqNL8wDJ5LMdKUuJZIp7II8yBvP9lUw03plpm7K9pzPpGQwNzB8DCrdk1oYCHrww==@vger.kernel.org, AJvYcCVh6h7jmM6UfkS7J5JjREz2eK7oKyzXMi448nXN4KKpOaL6BcOonB7ZsYLA2GExYeE+AqrA5Z3NvqS8@vger.kernel.org, AJvYcCXwWXi3vLq8KPxxWnjUUPuSCr8IpHSeME2vnk22KFxWpVt2ltRyWF33Gsp1Fu5FngJXKLgR9+uLoFY2Tymw@vger.kernel.org
X-Gm-Message-State: AOJu0YyLGGYPiACsB1shCurjpUg9SRDFepKJvCq4iYCmcaWzGcp2Uxwe
	vp+m8ECwLgXF32fOkPL6mIYXQ/Vx1ffJRYCR/FuV6tTn+0OhAMl0
X-Google-Smtp-Source: AGHT+IG9tEow0/ffMRBLGDbvZjNd48PgUXS2fL1HCRd1QL3UHQ60Ee0i8iP9mguf0Vh8UsoT/0KBMQ==
X-Received: by 2002:a05:6830:90d:b0:710:e987:2659 with SMTP id 46e09a7af769-71116c67ac7mr2287118a34.22.1726241964635;
        Fri, 13 Sep 2024 08:39:24 -0700 (PDT)
Received: from ?IPV6:2603:8080:7400:36da:dff5:4180:2562:4c1e? ([2603:8080:7400:36da:dff5:4180:2562:4c1e])
        by smtp.gmail.com with ESMTPSA id 006d021491bc7-5e1bf2f5bc4sm2863461eaf.38.2024.09.13.08.39.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 13 Sep 2024 08:39:23 -0700 (PDT)
Message-ID: <d3e30736-4396-4a53-afbc-243a2f64c909@gmail.com>
Date: Fri, 13 Sep 2024 10:39:22 -0500
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] docs:fs:fixed some spelling mistakes in the bcachefs
 coding style page
To: Dennis Lam <dennis.lamerice@gmail.com>
Cc: kent.overstreet@linux.dev, corbet@lwn.net,
 linux-bcachefs@vger.kernel.org, linux-doc@vger.kernel.org,
 linux-kernel@vger.kernel.org
References: <20240906195720.40315-1-dennis.lamerice@gmail.com>
 <200ce66b-845f-4f20-8838-619646f5f44d@gmail.com>
 <CAGZfcd=MZbt94__wek3v5e5DUfLZbgZ2uyw6i+gRWRXXrbDX3A@mail.gmail.com>
Content-Language: en-US
From: Carlos Bilbao <carlos.bilbao.osdev@gmail.com>
In-Reply-To: <CAGZfcd=MZbt94__wek3v5e5DUfLZbgZ2uyw6i+gRWRXXrbDX3A@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

On 9/11/24 19:17, Dennis Lam wrote:

> On Wed, Sep 11, 2024 at 4:03 PM Carlos Bilbao
> <carlos.bilbao.osdev@gmail.com> wrote:
>> Hello,
>>
>> On 9/6/24 14:57, Dennis Lam wrote:
>>> ---
>>
>> Change the subject, it needs spaces to be readable:
>>
>> "docs: fs: fixed spelling mistakes [...]"
>>
>> Also, you need a body in the commit which includes an explanation of what
>> the patch does (even if it is almost the same as the Subject) and your
>> signature. See: https://docs.kernel.org/process/submitting-patches.html
>>
> Thanks for the response, I'll be sure to send a new better formatted patch.


Awesome! Feel free to CC me :)


>
> Dennis


Thanks, Carlos

