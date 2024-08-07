Received: from relay5.mymailcheap.com (relay5.mymailcheap.com [159.100.241.64])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BEFE3250EC
	for <linux-bcachefs@vger.kernel.org>; Wed,  7 Aug 2024 05:37:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=159.100.241.64
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723009069; cv=none; b=m15E8tWqL/r5rttY8KirrlQVsMG2JKQFlDPwW9F/zMTlYI+SllzN27pnrC9O+5RJ0XWpT40p4Kbk31Ei9lCLvbetFYlGXmfPhy6lzTod+pK8rncYoHTL4oNHiM2XFS/6FjnZIVZpTnDMhqkYDgHQFkE5kyHGnfZBL7SyZqTZwKY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723009069; c=relaxed/simple;
	bh=JxLD5Pj6TRm51mrCNciNUEu8Pd6b36XkTfO+Y2CUoRQ=;
	h=Message-ID:Date:MIME-Version:To:From:Subject:Content-Type; b=dTEJBs1QWXUKF6PZZmnhLgmnJ1zukJ+gh0ePcXCO7nKlAkg7iMoA+B2LOXcr+AZ3z2iHj73j9uApKUCRVfox2UoZEAeTNEnKLGj/AipTO9U8S/oweHvlsyJWdjgCdVx92022cuzT6ZNI3K4spXxzX9SBVLFH8PyzPAg2pNS4Xig=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=pavinjoseph.com; spf=pass smtp.mailfrom=pavinjoseph.com; dkim=pass (1024-bit key) header.d=pavinjoseph.com header.i=@pavinjoseph.com header.b=V7xePBsa; arc=none smtp.client-ip=159.100.241.64
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=pavinjoseph.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=pavinjoseph.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=pavinjoseph.com header.i=@pavinjoseph.com header.b="V7xePBsa"
Received: from relay4.mymailcheap.com (relay4.mymailcheap.com [137.74.80.155])
	by relay5.mymailcheap.com (Postfix) with ESMTPS id AAF1420C63
	for <linux-bcachefs@vger.kernel.org>; Wed,  7 Aug 2024 05:37:38 +0000 (UTC)
Received: from nf2.mymailcheap.com (nf2.mymailcheap.com [54.39.180.165])
	by relay4.mymailcheap.com (Postfix) with ESMTPS id 535D5202E4
	for <linux-bcachefs@vger.kernel.org>; Wed,  7 Aug 2024 05:37:31 +0000 (UTC)
Received: from mail20.mymailcheap.com (mail20.mymailcheap.com [51.83.111.147])
	by nf2.mymailcheap.com (Postfix) with ESMTPSA id 67320400B0
	for <linux-bcachefs@vger.kernel.org>; Wed,  7 Aug 2024 05:37:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=pavinjoseph.com;
	s=default; t=1723009049;
	bh=JxLD5Pj6TRm51mrCNciNUEu8Pd6b36XkTfO+Y2CUoRQ=;
	h=Date:To:From:Subject:From;
	b=V7xePBsaOu0YYlDv11/DAQvW+VTARkFGiMrlrbpkbNkDe4huMZVNJXNcv76A+8M2A
	 xA0j/4qkfrcu2sm5o6H17SzlHnNAD3BaLQQ5Uquf2/JhHhq6fs9KKodsMIUGAgo6HO
	 8Zvv1xCXOYfzEA9e3D4FMr6GrTTVvhzd3DdL9/FY=
Received: from [10.66.66.8] (unknown [139.59.64.216])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mail20.mymailcheap.com (Postfix) with ESMTPSA id B9FDA41059
	for <linux-bcachefs@vger.kernel.org>; Wed,  7 Aug 2024 05:37:24 +0000 (UTC)
Message-ID: <28759521-d0ef-4f56-ad3d-3f07ad670adf@pavinjoseph.com>
Date: Wed, 7 Aug 2024 11:07:22 +0530
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Content-Language: en-US
To: linux-bcachefs@vger.kernel.org
From: Pavin Joseph <me@pavinjoseph.com>
Subject: Status of rebalance and scrub support
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
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
X-Rspamd-Queue-Id: 67320400B0

Hello everyone,

Is there an ETA available for full rebalance and scrub support?

I recently migrated from btrfs to bcachefs and so far it has been great, 
mostly due to the performance improvements on pinning metadata to faster 
drives. But as I started off with 2+1+1 TB background target drives with 
replicas=2 that had around 70% usage and then added 4+1 TB drives 
recently, my disk usage are all messed up without a rebalance.

I also perform weekly scrubs on my btrfs and zfs pools, so feeling a bit 
naked here without it!

Thank you for the awesome work on bcachefs!

Kind regards,
Pavin Joseph.
