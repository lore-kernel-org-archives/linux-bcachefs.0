Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A647221F04;
	Mon, 17 Mar 2025 15:15:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742224507; cv=none; b=ft3ogKtXNSr9mFDuNZdDFhPpcu29bBQOZOr5K0ibGAKJeiy8Yj6TOHY1WKAs5BfXSXSHGvDD0nuXh7FTlTpsF3jWP+Nnjcx1bMC0eEbDHO0CXn1kM2BCs1BBuMPR0GDq7bjJg6VCN/Rkv0JvcxzWYfOdbG5VlG3QQfoovO44tXg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742224507; c=relaxed/simple;
	bh=9xE/ZZFAhbUdXemL+vvPekfXt864Auu6rMm4NZH2MIc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=EPw1DAP/I93IYQT7amGqIr8s95+UO+CeJqXgPFZEdTldv6Qx3BVQ5yX74X/4vYHU+lRElwOxi+jAZtEwfec1DWinwfq+6dhtPIzf62+sR5fBRu4V6jv2d6GVmIwak6rz2f0vxOA25j4KZdBHbUJ3hOfaER3Ten8Ptl3Lsav8n5w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=uZljwjN/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="uZljwjN/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 487E3C4CEE9;
	Mon, 17 Mar 2025 15:15:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1742224506;
	bh=9xE/ZZFAhbUdXemL+vvPekfXt864Auu6rMm4NZH2MIc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=uZljwjN/RNTCBEqtKOwk1ZI5S/0fAt2dCVakzDyZo54+f8aKpzphcKQ8BKmUwLxN6
	 FqVtb/de3AJO45AihTs/lxI0BxBleXyrQVIU4xNi4p9YcDOlWwYUMf7e5M94MRAztU
	 4DHEQ62ILF18aKdi9ygCrqLVdvdHpichufjweffrZV41aBwvnDferKllyWoEHQlWbz
	 9oMsK7lGfjql+dF0owDdZqwx14AdUFaTi9OsKHIoGUYBPTJwK3lOoRXv5vP+4Vr0u6
	 cj+8QT8Dv16EFvMZkhqmeCL0KIfhs/vHdqqhCFN7sKhjWOTzZoyl32KLZhDf0+VaJZ
	 KVkAS9KJhU+mA==
Date: Mon, 17 Mar 2025 09:15:04 -0600
From: Keith Busch <kbusch@kernel.org>
To: Kent Overstreet <kent.overstreet@linux.dev>
Cc: Christoph Hellwig <hch@infradead.org>, Jens Axboe <axboe@kernel.dk>,
	linux-bcachefs@vger.kernel.org, linux-block@vger.kernel.org,
	Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH 13/14] block: Allow REQ_FUA|REQ_READ
Message-ID: <Z9g8eO4Ngvagw2XP@kbusch-mbp.dhcp.thefacebook.com>
References: <510692e2-b83c-45bc-8d9d-08f7a172ffe6@kernel.dk>
 <5ymzmc3u3ar7p4do5xtrmlmddpzhkqse2gfharr3nrhvdexiiq@p3hszkhipbgr>
 <0712e91f-2342-41ef-baad-3f2348f47ed6@kernel.dk>
 <ycsdpbpm4jbyc6tbixj3ujricqg3pszpfpjltb25b3qxl47tti@b2oydmcmf2a6>
 <ad32deb6-daad-4aa8-8366-2013b08e394f@kernel.dk>
 <fy5lq7bxyr64f7oiypo343s57nujafjue2bcl72ovwszbzasxk@k6jhr6asqtmx>
 <Z9e6dFm_qtW29sVe@infradead.org>
 <fhhgjnhmk72vpruhgftwq3lzfmylbhn6cuajj6saikee2zuqjp@54yfyxu35yiz>
 <Z9guJ2VxvqAmm9o9@kbusch-mbp.dhcp.thefacebook.com>
 <ro2padvzarj6v2bsh6xlsz36qs67z6ubomsvaw77dw4elfqqu7@4acij7zk6g7z>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ro2padvzarj6v2bsh6xlsz36qs67z6ubomsvaw77dw4elfqqu7@4acij7zk6g7z>

On Mon, Mar 17, 2025 at 10:49:55AM -0400, Kent Overstreet wrote:
> But we do absolutely require checking for transient read errors, and we
> will miss things and corrupt data unnecessarily without FUA reads that
> bypass the controller cache.

Read FUA doesn't "bypass the controller cache". This is a "flush cache
first, then read the result" operation. That description seems
consistent for nvme, ata, and scsi.

You are only interested in the case where the read doesn't overlap with
any dirty cache, so the "flush" part isn't a factor. Okay fine, but I'm
still curious if you have actually seen a case where read data was
corrupt in cache but correct with FUA?
