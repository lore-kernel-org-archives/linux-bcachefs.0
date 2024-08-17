Received: from relay-us1.mymailcheap.com (relay-us1.mymailcheap.com [51.81.35.219])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 38CFDCA6B
	for <linux-bcachefs@vger.kernel.org>; Sat, 17 Aug 2024 17:26:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=51.81.35.219
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723915580; cv=none; b=BOp7vLMxyg8HgZ09NuzSpH4AovOCTQgVabOwZGFnOh/xLM0za3+3uVNr/rI057Rv8OA5+npXXGbDUB1MAn6VVum7lVRGbKsQd/nOAV6EmpLNPjoasInWrGH4izvn88BwCq0cKJLzjQrhG6NNDg8734SsnbP1s1z1veUiWvQ2oSY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723915580; c=relaxed/simple;
	bh=b3LrJvDioxzTQCSty8zRlBH7+tWyHXUZwu6BxK2RX48=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:References:
	 In-Reply-To:Content-Type; b=isoM8twMQl0ItF82A7Pv7zg5sweqyesoksr+vgahUU8sEnumzrwmrrDmyBH6mGmO+jBFOh5SWYaGvNqKly/haje9Kve+pj8FN23VpDozDudgHBQVXHFMRlrNPzRkXRSLT6zmji8zDM3w40a0ldXSyWSVPCzYqSuvguWO7iF+n/o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=pavinjoseph.com; spf=pass smtp.mailfrom=pavinjoseph.com; dkim=pass (1024-bit key) header.d=pavinjoseph.com header.i=@pavinjoseph.com header.b=HWltj36j; arc=none smtp.client-ip=51.81.35.219
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=pavinjoseph.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=pavinjoseph.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=pavinjoseph.com header.i=@pavinjoseph.com header.b="HWltj36j"
Received: from relay5.mymailcheap.com (relay5.mymailcheap.com [159.100.248.207])
	by relay-us1.mymailcheap.com (Postfix) with ESMTPS id 09E2F20423
	for <linux-bcachefs@vger.kernel.org>; Sat, 17 Aug 2024 17:17:45 +0000 (UTC)
Received: from relay2.mymailcheap.com (relay2.mymailcheap.com [217.182.66.162])
	by relay5.mymailcheap.com (Postfix) with ESMTPS id 621EC2613B
	for <linux-bcachefs@vger.kernel.org>; Sat, 17 Aug 2024 17:17:36 +0000 (UTC)
Received: from nf2.mymailcheap.com (nf2.mymailcheap.com [54.39.180.165])
	by relay2.mymailcheap.com (Postfix) with ESMTPS id 59C7F3E8D0
	for <linux-bcachefs@vger.kernel.org>; Sat, 17 Aug 2024 19:17:28 +0200 (CEST)
Received: from mail20.mymailcheap.com (mail20.mymailcheap.com [51.83.111.147])
	by nf2.mymailcheap.com (Postfix) with ESMTPSA id 56E38400AD
	for <linux-bcachefs@vger.kernel.org>; Sat, 17 Aug 2024 17:17:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=pavinjoseph.com;
	s=default; t=1723915046;
	bh=b3LrJvDioxzTQCSty8zRlBH7+tWyHXUZwu6BxK2RX48=;
	h=Date:Subject:From:To:References:In-Reply-To:From;
	b=HWltj36jUnGmd+RlMyqGq5RjRkGckZgFRa32YYrbL/XHnE5IgYXr9bhL6iI8qXDPW
	 VA/KS1qHp27jbHxCWWctx34qVwjXF5kF82gyGe3Rbhn9JZIvelrqJFGpDoAybi4yYT
	 5eOHPBg0LRN203q2s6vHftIqVuqvXup4sBXTQziQ=
Received: from [10.66.66.8] (unknown [139.59.64.216])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mail20.mymailcheap.com (Postfix) with ESMTPSA id 8F946404BF
	for <linux-bcachefs@vger.kernel.org>; Sat, 17 Aug 2024 17:17:20 +0000 (UTC)
Message-ID: <c76f1900-de04-422e-b6eb-12453d982ddf@pavinjoseph.com>
Date: Sat, 17 Aug 2024 22:47:18 +0530
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: Status of rebalance and scrub support
From: Pavin Joseph <me@pavinjoseph.com>
To: linux-bcachefs@vger.kernel.org
References: <28759521-d0ef-4f56-ad3d-3f07ad670adf@pavinjoseph.com>
Content-Language: en-US
In-Reply-To: <28759521-d0ef-4f56-ad3d-3f07ad670adf@pavinjoseph.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: nf2.mymailcheap.com
X-Spamd-Result: default: False [-0.09 / 10.00];
	MIME_GOOD(-0.10)[text/plain];
	XM_UA_NO_VERSION(0.01)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	ARC_NA(0.00)[];
	RCVD_COUNT_ONE(0.00)[1];
	ASN(0.00)[asn:16276, ipnet:51.83.0.0/16, country:FR];
	MIME_TRACE(0.00)[0:+];
	RCVD_TLS_ALL(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	FROM_HAS_DN(0.00)[];
	PREVIOUSLY_DELIVERED(0.00)[linux-bcachefs@vger.kernel.org];
	FROM_EQ_ENVFROM(0.00)[];
	TO_DN_NONE(0.00)[];
	RCPT_COUNT_ONE(0.00)[1]
X-Rspamd-Action: no action
X-Rspamd-Queue-Id: 56E38400AD

Gentle ping, anyone? 🥺

On 8/7/24 11:07 AM, Pavin Joseph wrote:
> Hello everyone,
> 
> Is there an ETA available for full rebalance and scrub support?
> 
> I recently migrated from btrfs to bcachefs and so far it has been great, 
> mostly due to the performance improvements on pinning metadata to faster 
> drives. But as I started off with 2+1+1 TB background target drives with 
> replicas=2 that had around 70% usage and then added 4+1 TB drives 
> recently, my disk usage are all messed up without a rebalance.
> 
> I also perform weekly scrubs on my btrfs and zfs pools, so feeling a bit 
> naked here without it!
> 
> Thank you for the awesome work on bcachefs!
> 
> Kind regards,
> Pavin Joseph.
