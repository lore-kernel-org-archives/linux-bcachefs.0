Received: from vps01.wiesinger.com (vps01.wiesinger.com [46.36.37.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EEEFE7462
	for <linux-bcachefs@vger.kernel.org>; Wed, 22 Jan 2025 06:51:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=46.36.37.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737528671; cv=none; b=UWZhxbYkQ7cekMmbNE4noUtxk55tG1lfN3srUHSbkNv8uvTS+oN9O+BZ+/py5LD7D8bfxjUkdzX1+QS0dQRLe+pPZMki53Yacvx09+lPkM8568oSglsqGmWR0lDVeQmWVfFazS0GNmohNHPznfaUiPTOcnKf65FDe79yzb/wqqY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737528671; c=relaxed/simple;
	bh=M4aU1EP4ZglF9mlxIt+biABpnipjscs5N23uECkQ4Ik=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Kh2anaXK7jidqrEe5U6L/6S5LKhGDJRtlRH62poZuuoVBk03dk6YZqCds9INl7P7MILn4PdxdsJ5nKMTXe0yYud/MiMZi5YFY0iCI8pLJ2zBBxns7eDeyGXvgGSDFZiqA33jfjuqvVZLfLF38oMGSpjgCMkhHx5TwAK0Cx6IVQM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=wiesinger.com; spf=pass smtp.mailfrom=wiesinger.com; dkim=pass (4096-bit key) header.d=wiesinger.com header.i=@wiesinger.com header.b=zVPvX6MI; arc=none smtp.client-ip=46.36.37.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=wiesinger.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wiesinger.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key) header.d=wiesinger.com header.i=@wiesinger.com header.b="zVPvX6MI"
Received: from wiesinger.com (wiesinger.com [84.112.177.114])
	by vps01.wiesinger.com (Postfix) with ESMTPS id D9B669F29F;
	Wed, 22 Jan 2025 07:51:05 +0100 (CET)
Received: from [192.168.0.63] ([192.168.0.63])
	(authenticated bits=0)
	by wiesinger.com (8.18.1/8.18.1) with ESMTPSA id 50M6p4bk201424
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NO);
	Wed, 22 Jan 2025 07:51:05 +0100
DKIM-Filter: OpenDKIM Filter v2.11.0 wiesinger.com 50M6p4bk201424
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=wiesinger.com;
	s=default; t=1737528665;
	bh=rQeGZ2MX2aO4Yzt05IP3WTNV5dZ7TJGRnjHGYLRJ3DM=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=zVPvX6MIV9PUK99g3ZrAEdxKXqCS+4UXfNFtFM/2OAercFgWlpAN7HWkG+C0BiTEI
	 CVfsYA44PKVliNUMwtbRcVb3SnDjkPQbHRpL4eLiWwwz6vIvrYIcioUhpYKr2cpVcO
	 /id5VWl9rGqYMiGsg7F0UItClOr1GoKKWvp3sNZs5ePa7zMH78BOHbTegNEKMi5rwR
	 QlcYhobRFDUFuIyCfwEwBjj8ZNCMmqojwECpQviuXh25sLMDE4uZfnRKW4kCdJAWU3
	 22+tAlV8mmmuWoqkWn/kt5YgJc4VoFCkYfTOx1PQGBzvpRSqsHRcTCMikpw6nXKyIZ
	 CFtl6hQXIH1QPfQ2D1cTH0l2TdnvOcI3lv0KyMgiu4n0LbEfKaqYj1+qHQoTPO7PAV
	 8cceaq+hhS2EBx0ySnfAYppV8YykUXhDb8SBocfd+sUkgRGD+WEKqGS5G7iDanS/eH
	 JSuvsHUxJFbPnzPwom+DbSMKIKdSl8kIvFN9UwwgQfMLn/zl85KhZ12XMwnG24e8fC
	 bmJoPOxsakzToNcDQItOtu2hTSfehBYGg3LIxnt4fzkzoil1XmsLNTaJLzCGh7JRqM
	 tjp9v1+tpZsU5Kx/hcekAXFpA0GmDJ+uAjB3i+fvTQ5LO3IHv0gjJpvwZqLG90qCo2
	 uWpVnbcOZZbAjXu60tVcPrdM=
Message-ID: <a9f73879-cc08-45d9-9a3c-fb1f853739b9@wiesinger.com>
Date: Wed, 22 Jan 2025 07:51:04 +0100
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Betterbird (Windows)
Subject: Re: Corrupt bcachefs can't be transferred into a consistent state
Content-Language: en-US
To: Kent Overstreet <kent.overstreet@linux.dev>
Cc: linux-bcachefs@vger.kernel.org
References: <aa613c37-153c-43e4-b68e-9d50744be7de@wiesinger.com>
 <ppqn3gvkjjsbg4sprijlqbldkuetnaco5orl4wxapsydee65g5@3nwlodfwjwcx>
From: Gerhard Wiesinger <lists@wiesinger.com>
In-Reply-To: <ppqn3gvkjjsbg4sprijlqbldkuetnaco5orl4wxapsydee65g5@3nwlodfwjwcx>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 05.09.2024 06:29, Kent Overstreet wrote:
> On Sun, Sep 01, 2024 at 02:01:25PM GMT, Gerhard Wiesinger wrote:
>> Hello,
>>
>> I'm having some Fedora Linux VMs (actual versions, latest updates) in a
>> virtual test infrastructure on Virtualbox. There I run different VMs with
>> different filesystems (ext4, xfs, zfs, bcachefs and btrfs).
>>
>> I had a hardware problem on the underlying hardware where around 1000 4k
>> blocks could not be read anymore. I migrated with ddrescure the whole disk
>> which worked well.
>>
>> Of course I was expecting some data loss in the VMs but wanted to get them
>> in a consistent state.
>>
>> The following file systems got very easy in a consistent state with the
>> corresponding repair/scrub tools of the filesystems:
>> - ext4
>> - xfs
>> - zfs
>>
>> Unfortunately 2 filesystem can't get into a state, where the filesystem
>> repair tools report "everything fine" (of course with some loss data, but
>> that's fine):
>> - btrfs
>> - bcachefs
>>
>> commands run with bcachefs (git version):
>> git log -n1 | head -n1
>> commit 1e058db4b603f8992b781b4654b48221dd04407a
>> ./bcachefs version
>> 1.12.0
>>
>> But bcachefs never got into a consistent state, also with newer versions.
>> Also check with older versions (1.7.0) run for a long time.
>>
>> To reproduce the problem I created a new filesystem and copied some files
>> there:
>> mkfs.bcachefs -f /dev/sdb
>> time cp -Rap /usr /mnt
>>
>> Afterwards I created a (quick&dirty) script "corrupt_device.sh" to corrupt
>> the device in the same manner as the original failure (1000 4k blocks will
>> be randomly overwritten).
>> Script: see below
>>
>> ~/corrupt_device.sh
>> ./bcachefs fsck -pf /dev/sdb
>> ./bcachefs fsck -pfR /dev/sdb
>>
>> Result: It can be reproduced, that bcachefs can't be brought into a
>> consistent state even after several runs of the repair.
>>
>> You can also try to reproduce it and create a testcase out of it.
>>
>> Any ideas how to repair and what can be done to get it into a consistent
>> state?
> If you've got a filesystem you want data off of - send me a metadata
> dump (join the IRC channel, send it via magic wormhole) and I'll debug.
>
> We still haven't comprehensively torture tested all the repair paths
> (which is probably the biggest reason it's still marked as
> experimental); all the repair paths are there, but there's still bugs to
> shake out.
>
> Thanks for the test - I'll try to make use of it when I'm working in
> that area again.

Did you find the time for using the test and fix the issues?

As bcachefs gets more stable I think we should focus on such 
"destroy&repair" test cases to get consistent again and get trust.

Thnx.

Ciao,

Gerhard


