Received: from mail-pf1-f180.google.com (mail-pf1-f180.google.com [209.85.210.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 921B3215F42
	for <linux-bcachefs@vger.kernel.org>; Sat,  4 Oct 2025 04:31:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759552272; cv=none; b=NRuDYlF0g/hKhKYKc7391jORwnuWRKu4cCN3GQE/ePl/McVt/Hoc5yzTAjEx358huFxBsGgWLqUztDGgsjO/8D/M37xZzrGThdc08LSy+5gX9i90bSePteLV52PZEfyagqOYg6l36uzFXhx+dD5Q3Z2A5gS2uGJ9VkL4mmCOWEA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759552272; c=relaxed/simple;
	bh=enoINwlA9+PevoMLkOQfPIAcWmrKh+doHnEubrvsPIw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=QHH8dDd+pCfBUG//30kYWBVdV2XQCtBXtFQGMOfO2r9iMMpRKKOHEnqGwIYOppBzGrwDkbzgQPO/pyk5NfZDmq57faWHqU8HJnAVHjpv8wzCUEIUz/SSmTcpDaEhgJQvniQo2bJgo4zCwF2Kz0oLz4a7MN4D2WbUdpOoHa5dt/0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=nNluNx03; arc=none smtp.client-ip=209.85.210.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="nNluNx03"
Received: by mail-pf1-f180.google.com with SMTP id d2e1a72fcca58-7811fa91774so2420115b3a.0
        for <linux-bcachefs@vger.kernel.org>; Fri, 03 Oct 2025 21:31:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1759552268; x=1760157068; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=StwDBKa8ZRSfrd7VD6MhCNqBvOmQ/m+xhmau3mnSCHE=;
        b=nNluNx03FQ5vYhQMHrgA8/vPRPScDDajqnNVNYS0jm2ld3ie4869R/szYqKIg4i/K/
         6D60GvxXCvd+Mgebdcs2V9VIuXLGqaEwGASbNLRHMgst39FzOMCwd15sw9IjO6QgzBUb
         DLzi+mBRzyB6m6bRfnyO/O+23K4JlPsOS3FHDy6wh6ZXJZao0/H4lhzi4vxRSkfBYema
         KfjLNVY5NMtsqvagPTAVR2iKsktEj+nQZO3YvkyAFbXp9DhpCDq9Wc8OKqa8qqCeEsl5
         mVhlR5h1uul5mfBU7AsBEZX2znYqX15CcE5N7xSPnXmyH56GiSHlUBGMJiHCEccQ+wF9
         N1ZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759552268; x=1760157068;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=StwDBKa8ZRSfrd7VD6MhCNqBvOmQ/m+xhmau3mnSCHE=;
        b=ugxvNW86CXJctkZS6i/mRWLV5MYaXDk5vmFbuaiuKIP2LlpChAx1+6zHK5yV6snJUU
         O/wnhZuKIxxPjjVPP0QABLzEfiDcx1oLoukguPko0AYXDiT2/AKrDXTaZGsNkuuYehGj
         Put1JRP+XmUWhQd7Ehvg286+cDSt725yzLwEvtqJzI8JVYp+02gqPByyYfH2MLLFJUpD
         Z4PqceTvKLfwtwVu+YTeMUwbQjhOJkLYNJLcNV9aqNezE4rbGYrIC8wkSiu965e5qW+g
         /LbSK07wBPgbwSZnUYkqgYm34Fws1jI1JM021GjNdLtDYzN5rvvuCVwxkt7x+7M/sfFF
         v0xA==
X-Forwarded-Encrypted: i=1; AJvYcCVgMpImo+6ITlVpyjEkvoImT5RYitNPoAbB3iUFCNOkVgKrU6pTit/XOfSpnY1u1AnlyWnogcCNtlLm3nzUww==@vger.kernel.org
X-Gm-Message-State: AOJu0YzT3A9bV8/FbHEwJUKjgcIfS+yhVyHQLHPNurVXfpkvJtSK8AtQ
	LKaCjIhKqBONCftcpdm0Wjc2btiFiffSccu+hmwQ+kFOBAps3wAqybS6
X-Gm-Gg: ASbGnctiUCBhplpWlFeHB1X4P5E4IMalKC26xgSYvzkAKQyeACZiP4lAWuafhq+HMOb
	rGGan3NGOfvyNtAbjc9so6NYEVyTrKjwlkweMHbdpxll27TpmpzpL7MFFCVqZjA68y0Nsx8Wpka
	Gf3brvKk1X3xXjTdaKkgWOOduuH0VowVR6x//kfH38mCk3zykjJxB5guldGD8fqnoLIXxZMnP00
	yQnuK2IzrDkEsXCcAWE3ch0ndCbjWC/4bYYeaun81RsBfZ9yRDAReDC36PWVdsPN9BTSlqnJnoz
	b4DYHJ1bVDGALQbDRPQAnyqWYcePcurT6CxJ/1L7/BnoesfTXOUXVSjRvjUW186sLlm/ZHLDQTC
	WBJALgKGO1JRNPAlQBN7rzvUQjlzJffie949Exxm1nRNY6OqoYwulkvWbrFOnbBQJKD3hnL4=
X-Google-Smtp-Source: AGHT+IGFVdu0idHFioNc6W6G3QpB4+em7I6xbQXdwjM7auYWjIP5jrn2CpWgS3aswdOPecIYETyQ3A==
X-Received: by 2002:a05:6a20:72a8:b0:2f6:cabe:a7b3 with SMTP id adf61e73a8af0-32b62107c29mr7468985637.50.1759552267731;
        Fri, 03 Oct 2025 21:31:07 -0700 (PDT)
Received: from [10.0.2.15] ([157.50.90.152])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-78b01fb1b73sm6413167b3a.28.2025.10.03.21.31.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 03 Oct 2025 21:31:07 -0700 (PDT)
Message-ID: <9a7072cb-840f-472a-9e22-a5252e52ef48@gmail.com>
Date: Sat, 4 Oct 2025 10:01:00 +0530
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] fs: doc: Fix typos
To: Carlos Maiolino <cem@kernel.org>
Cc: Kent Overstreet <kent.overstreet@linux.dev>,
 Jonathan Corbet <corbet@lwn.net>, David Howells <dhowells@redhat.com>,
 Paulo Alcantara <pc@manguebit.org>, Alexander Viro
 <viro@zeniv.linux.org.uk>, Christian Brauner <brauner@kernel.org>,
 Jan Kara <jack@suse.cz>, linux-bcachefs@vger.kernel.org,
 linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-xfs@vger.kernel.org, netfs@lists.linux.dev,
 linux-fsdevel@vger.kernel.org,
 linux-kernel-mentees@lists.linuxfoundation.org, skhan@linuxfoundation.org,
 david.hunter.linux@gmail.com
References: <DrG_H24-pk-ha8vkOEHoZYVXyMFA60c_g4l7cZX4Z7lnKQIM4FjdI_qS-UIpFxa-t7T_JDAOSqKjew7M0wmYYw==@protonmail.internalid>
 <20251001083931.44528-1-bhanuseshukumar@gmail.com>
 <kp4tzf7hvtorldoktxelrvway6w4v4idmu5q3egeaacs7eg2tz@dovkk323ir3b>
 <yms8llJZQiWYVxnbeWEQJ0B_S6JRxR0LQKB1FwVe0Tw66ezuA-H1qZVCyuCUDtsw7s7h4jHTwTh98XivLW3vvw==@protonmail.internalid>
 <425ef7bd-011c-4b05-99fe-2b0e3313c3ce@gmail.com>
 <6t4scagcatuba7hjy4aib5hqfgyhc4wofegr2jrl34wwa7fsyq@5uwpzmpixm7o>
Content-Language: en-US
From: Bhanu Seshu Kumar Valluri <bhanuseshukumar@gmail.com>
In-Reply-To: <6t4scagcatuba7hjy4aib5hqfgyhc4wofegr2jrl34wwa7fsyq@5uwpzmpixm7o>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 03/10/25 21:22, Carlos Maiolino wrote:
> On Wed, Oct 01, 2025 at 07:19:13PM +0530, Bhanu Seshu Kumar Valluri wrote:
>> On 01/10/25 17:32, Carlos Maiolino wrote:
>>> On Wed, Oct 01, 2025 at 02:09:31PM +0530, Bhanu Seshu Kumar Valluri wrote:
>>>> Fix typos in doc comments
>>>>
>>>> Signed-off-by: Bhanu Seshu Kumar Valluri <bhanuseshukumar@gmail.com>
>>>
>>> Perhaps would be better to split this into subsystem-specific patches?
>>>
>>> This probably needs to be re-sent anyway as bcachefs was removed from
>>> mainline.
>>>
>> I just did a google search and understood about frozen state of bcachefs
>> in linux kernel since 6.17 release onward. It is going to be maintained
>> externally.
>>
>> Thanks for your comment. I will resend the patch excluding bcachefs.
> 
> It's not only bcachefs. But most of subsystems and documents you touch
> have different maintainers, so beyond removing bcachefs bits, I'd
> suggest looking at MAINTAINERS file and send specific patches targeting
> each subsystem. It makes maintainer's lives easier, at least for me.
> 
> 
>>
>> Thanks.
>>
>>
Hi,
Thank you for the suggestion. I will split it.

Regards,
Bhanu Seshu Kumar Valluri
