Received: from mail-ej1-f43.google.com (mail-ej1-f43.google.com [209.85.218.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2823925DCE5
	for <linux-bcachefs@vger.kernel.org>; Mon, 24 Mar 2025 15:25:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742829950; cv=none; b=FBl2Qvq72b5XMG0KzLfYJ4wZSG9HXod+GOL0PMtavDY2XJl8UsfuBbakkBxLkFfF2RCK4Rp5LLu1WSWBJCDm4WSC24c8S+AbNxpHh6MlMphJyseMMXdI/zFprFZDbtbAAM5J4UxAah07tCCC3vNdIOSqf9+D5642bq+FdhefYrs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742829950; c=relaxed/simple;
	bh=THvuo9R1bR3ctTaSbVZmsy70OKsoPZoOXWzzmhO0jFg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=cOr9cyWWwV0O4EHFb2XReUIdsUQvz79k6JC+N5npPhiNHzxk5Rp9RbfpIaWzCv9vsRCy3umBiyOtxeLwTdFgprEIrir/xuietYysvUfBePLD8f6ca8fCX/Q3ypsgAbjKHPm2Pws62OzPT6MNEOqXQHyDaXarzdmCgdWPJvNJJTc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=hajdamowicz.info; spf=pass smtp.mailfrom=hajdamowicz.info; dkim=pass (2048-bit key) header.d=hajdamowicz-info.20230601.gappssmtp.com header.i=@hajdamowicz-info.20230601.gappssmtp.com header.b=0mcyRRxg; arc=none smtp.client-ip=209.85.218.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=hajdamowicz.info
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=hajdamowicz.info
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hajdamowicz-info.20230601.gappssmtp.com header.i=@hajdamowicz-info.20230601.gappssmtp.com header.b="0mcyRRxg"
Received: by mail-ej1-f43.google.com with SMTP id a640c23a62f3a-ac297cbe017so998910666b.0
        for <linux-bcachefs@vger.kernel.org>; Mon, 24 Mar 2025 08:25:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=hajdamowicz-info.20230601.gappssmtp.com; s=20230601; t=1742829943; x=1743434743; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=ufsbq1opz5aB5K6ISbyLAl9UTWrK6qKePpljvXLg4eE=;
        b=0mcyRRxg9yrlviMNSTy/YpCerzgcB9KMIAC7VzECMlLNMyOecBj3TmxO8GssJqVwdp
         9PGFxrrB0ITkIvp+TdZKORCXruvbK1rr2IkmCBFESbIDMBJGDkoMV3DZTxZLIbnia93N
         3YNIDgUaAsMkNd/o0Gvw3R1BF4LEYiMVS2ljYtKo5OHmtwQNcurTAsWlhnXLOJygrnn4
         Z42RGf72e7xYzTfo3BH63tvRxNpZ6UQ48b3DgmKtyRB6jiB56IEYAIVQRC5SA0YKC4wQ
         PCZNyadPsd1cSx1WmwC26eg6wCFDhB/vUk06/PyTTwflpbLwt1PK1O6TlWeedKxEt/w7
         TnDA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1742829943; x=1743434743;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ufsbq1opz5aB5K6ISbyLAl9UTWrK6qKePpljvXLg4eE=;
        b=Nc+PsYRWuF0QoZgJQFrd+HgblO3BQo66Uphbz8taiWvcwqgDdj8wTzKWJcIFvrMiJd
         53IfFCxqNudrRJ1r3G9n9kRNRfAvtQTg8evK7/v2dRrasz7LMOvBwcCSBMSNySw3ej9R
         Jl0hv6osriyYKL1iSqLJZiaN8wjI4oNsN7Dy1c/+sV+PeFhCxvgmrTVkOEXAoiwSl3O1
         5jvR8vFE6NV+15k29oZ2gw0p2H1mTI4dARe9qLSZkIR2bl+Lzy+V2p0MbePlAPNlVjA6
         NE2K6/zVqviu8mAfGEJm6xJlLIUfibgUsmH3MJx6FaKvL4C8BsmwRrVZu8ojN3c+4FTH
         viKA==
X-Gm-Message-State: AOJu0Yz67tfsoHiuvR8xRXUKyndvhScM8l6xM1bnMzi8S4VLmLzGGtKf
	rG3/sTKIYEhjQeIMK7e5nvCTcOwUl3lKPa9cEt6shjgjsYIsqcyRxCAXU0C1+gc=
X-Gm-Gg: ASbGnctTyoktMrTdXTNreNB0NbPCSskUpfY3XlGo5CZ64UwzBHuJE6+OkY3YSfoK0od
	bkNc8HhKlpxKolZKEAKmUjblfW4pL5t5EtQD0al5QWG6BEwOsZ8NEdonn2tzgI4mS28GZrTCL+Z
	pNXPL39xxdW2SAYFtaIzRjBnX2ugJbRTOXQzx6Kdkc55oHrM9vCKuDB1QWyeKJujR8eSe/sKbGk
	qM6AMaIrwDtJSNeBXhiyxIbeKHU4QHAYsyO3T4/goJMfcOo+B0VammVOhPssxYO0d8Unpiiu/Xg
	YYtY6V4L7P2tmlRqiFv/qQ44yFerpNj6RaBeOjOvV2qlGoQ1ISWqLg==
X-Google-Smtp-Source: AGHT+IG7+W0ML2HHZYpAN0kGnQ6ilgL9PfxDSHcJ2m6wfGAY7XEdvyED4xDk1vV4bU5nMCFOD1Aoyw==
X-Received: by 2002:a17:907:daa:b0:ac2:4f30:5033 with SMTP id a640c23a62f3a-ac3f0172286mr1365459166b.15.1742829943037;
        Mon, 24 Mar 2025 08:25:43 -0700 (PDT)
Received: from [192.168.1.81] ([80.68.228.5])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-ac3efd23c7bsm701370366b.150.2025.03.24.08.25.41
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 24 Mar 2025 08:25:42 -0700 (PDT)
Message-ID: <fe46f2b3-ae9d-49bc-a5a0-2db5817505b2@hajdamowicz.info>
Date: Mon, 24 Mar 2025 16:25:41 +0100
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: errors compiling bcachefs-tools v1.20.0 on debian 12
To: John Stoffel <john@stoffel.org>, =?UTF-8?Q?Malte_Schr=C3=B6der?=
 <malte.schroeder@tnxip.de>
Cc: linux-bcachefs@vger.kernel.org
References: <20250311201518.3573009-1-kent.overstreet@linux.dev>
 <26584.35900.850011.320586@quad.stoffel.home>
 <26584.36927.6100.282713@quad.stoffel.home>
 <66bf47fc-643e-4e6b-ab6d-492024fdd2e7@tnxip.de>
 <26585.57291.760395.430511@quad.stoffel.home>
 <3e765804-93b5-4102-8d31-0c91d44c726c@tnxip.de>
 <26586.53721.541198.490221@quad.stoffel.home>
Content-Language: en-US
From: Krzysztof Hajdamowicz <krzysztof@hajdamowicz.info>
In-Reply-To: <26586.53721.541198.490221@quad.stoffel.home>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

W dniu 19.03.2025 o 15:16, John Stoffel pisze:
>>>>>> "Malte" == Malte Schröder <malte.schroeder@tnxip.de> writes:
>> On 18/03/2025 22:04, John Stoffel wrote:
>>>>>>>> "Malte" == Malte Schröder <malte.schroeder@tnxip.de> writes:
>>>> Libs in Debian 12/Bookworm are too old for bcachefs-tools. I think
>>>> someone pulled it of by forcing some libs from Trixie, but that caused
>>>> other things to break.

I am one of the people that butchered bcachefs-tools to work on my 
Bookworm/Proxmox 8 machine.

The recent version of bcachefs-tools require liburcu in version 0.14 and 
higher.
Debian Bookworm uses 0.13, while Debian Trixie has 0.14.
I asked debian-backports team if they could backport it [1].
In response, I was informed that newer package uses 64bit time_t;
This makes it incompatible with Bookworm and a patch would be needed to 
address that.

As my risk factor for this machine is higher than usual, I've created a 
setup with:

  * LXC container initially set up with Bookworm, containing all build
    dependencies.
  * I recompiled liburcu8t64 from Trixie to Bookworm
  * The package was then force-installed - rendering dpkg package
    database with conflicting dependencies.
    apt-cache rdepends shows that xfs and glusterfs depends on working
    liburcu.
    Since I do not use either of them, this is something I can live with.
  * Then I built bcachefs-tools
  * The resulting bcachefs binary and liburcu8t64 packages were copied
    to the target system.
  * Finally, I force-installed them, leaving the dpkg database with
    broken dependencies.

1: https://lists.debian.org/debian-backports/2025/01/msg00003.html
>>> So what is the best Linux distro to use to compile bcachefs-tools?

There is none until you transfer compiled binary with its dependencies.
# ldd bcachefs-tools/bcachefs
     linux-vdso.so.1 (0x0000749f55207000)
     liburcu.so.8 => /lib/x86_64-linux-gnu/liburcu.so.8 (0x0000749f54db5000)
     libblkid.so.1 => /lib/x86_64-linux-gnu/libblkid.so.1 
(0x0000749f54d5e000)
     libuuid.so.1 => /lib/x86_64-linux-gnu/libuuid.so.1 (0x0000749f54d54000)
     libsodium.so.23 => /lib/x86_64-linux-gnu/libsodium.so.23 
(0x0000749f54cfa000)
     libz.so.1 => /lib/x86_64-linux-gnu/libz.so.1 (0x0000749f54cdb000)
     liblz4.so.1 => /lib/x86_64-linux-gnu/liblz4.so.1 (0x0000749f54cb3000)
     libzstd.so.1 => /lib/x86_64-linux-gnu/libzstd.so.1 (0x0000749f54bf7000)
     libudev.so.1 => /lib/x86_64-linux-gnu/libudev.so.1 (0x0000749f54bc9000)
     libkeyutils.so.1 => /lib/x86_64-linux-gnu/libkeyutils.so.1 
(0x0000749f54bc2000)
     libaio.so.1 => /lib/x86_64-linux-gnu/libaio.so.1 (0x0000749f54bbd000)
     libgcc_s.so.1 => /lib/x86_64-linux-gnu/libgcc_s.so.1 
(0x0000749f54b9d000)
     libc.so.6 => /lib/x86_64-linux-gnu/libc.so.6 (0x0000749f549ba000)
     /lib64/ld-linux-x86-64.so.2 (0x0000749f55209000)
     libpthread.so.0 => /lib/x86_64-linux-gnu/libpthread.so.0 
(0x0000749f549b5000)

>> I'd recommend you join #bcache at OFTC. This kind of things has been
>> and still is discussed there and people have found solutions that
>> worked for them regarding -tools vs Bookworm. My personal "solution"
>> was to upgrade to Trixie.
> Is there a base OS (Fedora?) that people use for development

As far as I know, most of bcachefs development happens on Nix.
> which I can use to cross build a package for Debian?
I would suggest upgrading to Trixie. I can't as Proxmox is not 
compatible with Trixie yet.
