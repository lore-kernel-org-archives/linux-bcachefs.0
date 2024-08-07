Received: from mail-il1-f178.google.com (mail-il1-f178.google.com [209.85.166.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F38412C81F
	for <linux-bcachefs@vger.kernel.org>; Wed,  7 Aug 2024 15:42:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723045336; cv=none; b=cEiX7xZ7ps+IxjkoSAXyNuO6ahr1VbJ1I0GnP2TH/bHxPssPAFKZCmCZmI/Witf+sOEM3MrksOMMDcXHmVx+DeDtFxPjFCPoAR6H+fwWpTMYAlY8S4Xit7o4ElO1gk0tb/so36eMxoy4lRqJH538LEkQmhZ4yAnypmv3/UFcyDc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723045336; c=relaxed/simple;
	bh=p7PVqR202pLZcsTbDjLFYNgJzn0bloqG+abqcVgvaJU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=pQEkR6I2a8sKJNqzMmNAiPRVlfrUTJY/jfBArylt6ltw1I2sHCT9xxaS/1KLSA0zIT9FmmGrHkVQE5okS5fHcx5EMw2JdSOlg9a0PU0qKCqFRNaE7iNWDvc+oBn6KzQzYbRwOFSDQrbwNDd7V/niLvUZSPL4vqXv5Sk/FMkWF8I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Lhy9+T+I; arc=none smtp.client-ip=209.85.166.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Lhy9+T+I"
Received: by mail-il1-f178.google.com with SMTP id e9e14a558f8ab-39b3c36d429so1256015ab.1
        for <linux-bcachefs@vger.kernel.org>; Wed, 07 Aug 2024 08:42:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1723045334; x=1723650134; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=DuwHjHFvIH5yzRbowDpjPZeGCKe893MON8qjCHt6NA8=;
        b=Lhy9+T+I9SlgQZCWx24/UGQHRvTeLwvMIeRMfwswfx5SfSSA3ytbsYDKCEyGTdLHOv
         WorBAKpn+AFeEMMni3W6jXM+vSCA9v1f5gUrWZ/me/iGSDGAwRJw/BWSleH/ZOhVlCMd
         YFWmO8cMjBgCh/ZZv51O7qVoSyNoSdohO0CUE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723045334; x=1723650134;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=DuwHjHFvIH5yzRbowDpjPZeGCKe893MON8qjCHt6NA8=;
        b=Mgk3/IR1rNJQzuNY0yN1vFGdMM/k2VwIgu21tvHIYzzqdki4hlN3D4Vmmfz+AtFMQo
         oSuruBbBX8LSWOyVjxV+icosGeCDoHSpaSeuT2J/2OUlNUqn7KOkCfOAuLboaMksdug0
         OooOt/OBK+M9JEfX4LdfHMM6EUJeLBm5WOYe9qiBDoUFb7fSxkkPLqbLE32uTmlfGKbD
         bFKanGZYhfnenfCaU60OmiPp5qk10gqvIdDxTjut0lBal5lmFGVlECWvD+X3hY8uPsAC
         9K5UnC8QY2goGQeetRuZ2GmF7AOuHiAuwz4aAikpFoVEzpcvSgodasR0GCsmOjilutZi
         5mHg==
X-Forwarded-Encrypted: i=1; AJvYcCV4Lx0g2jSRmVXxv778eSoEM+7aulPaQCdMo5d8qBhiTVeYigWQ/Mu2U7oJbi3LgYRtU086DJ5nkpCb2w92mOmZV0cU1/7wvCZaWiPlusI=
X-Gm-Message-State: AOJu0Yyl/tyS+uDMAULBxSsnne8sFGpJhPjbUMdcbf8S4EBh94k0R3uu
	u1m8CnkkZroxQSfZqjNxnE/Anncy4J/GcIA+9u4lBF4ZfQWdNarXgpgVrsPTwTY=
X-Google-Smtp-Source: AGHT+IENm7ilj2AMmEwQJYpawRWrkgTZs3Cq1oL1+5AjSJCsF6nenoG7T6ZS8wtXFNT1iOwrbP88qQ==
X-Received: by 2002:a05:6e02:1b0f:b0:38e:cdf9:8878 with SMTP id e9e14a558f8ab-39b1fc6194bmr121613445ab.5.1723045333621;
        Wed, 07 Aug 2024 08:42:13 -0700 (PDT)
Received: from [192.168.1.128] ([38.175.170.29])
        by smtp.gmail.com with ESMTPSA id e9e14a558f8ab-39b20ab4f73sm45805565ab.39.2024.08.07.08.42.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 07 Aug 2024 08:42:13 -0700 (PDT)
Message-ID: <2dfa76a7-eeae-4b05-bfcd-684ae7ade963@linuxfoundation.org>
Date: Wed, 7 Aug 2024 09:42:12 -0600
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] Fix a spelling error in a doc of bcachefs
To: Xiaxi Shen <shenxiaxi26@gmail.com>, kent.overstreet@linux.dev,
 corbet@lwn.net
Cc: javier.carrasco.cruz@gmail.com,
 "open list:BCACHEFS" <linux-bcachefs@vger.kernel.org>,
 "open list:DOCUMENTATION" <linux-doc@vger.kernel.org>,
 open list <linux-kernel@vger.kernel.org>,
 Shuah Khan <skhan@linuxfoundation.org>
References: <20240807071005.16329-1-shenxiaxi26@gmail.com>
Content-Language: en-US
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20240807071005.16329-1-shenxiaxi26@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 8/7/24 01:10, Xiaxi Shen wrote:

Missing commit message --

> Signed-off-by: Xiaxi Shen <shenxiaxi26@gmail.com>
> ---
>   Documentation/filesystems/bcachefs/CodingStyle.rst | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/Documentation/filesystems/bcachefs/CodingStyle.rst b/Documentation/filesystems/bcachefs/CodingStyle.rst
> index 0c45829a4899..01de555e21d8 100644
> --- a/Documentation/filesystems/bcachefs/CodingStyle.rst
> +++ b/Documentation/filesystems/bcachefs/CodingStyle.rst
> @@ -175,7 +175,7 @@ errors in our thinking by running our code and seeing what happens. If your
>   time is being wasted because your tools are bad or too slow - don't accept it,
>   fix it.
>   
> -Put effort into your documentation, commmit messages, and code comments - but
> +Put effort into your documentation, commit messages, and code comments - but
>   don't go overboard. A good commit message is wonderful - but if the information
>   was important enough to go in a commit message, ask yourself if it would be
>   even better as a code comment.

thanks,
-- Shuah
