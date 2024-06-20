Received: from out-172.mta1.migadu.com (out-172.mta1.migadu.com [95.215.58.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57DE11AC769;
	Thu, 20 Jun 2024 12:51:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718887900; cv=none; b=PE0Kl1Q/mhqXRidrzkXkco+3tQ5wzeNCPJX9nbZjpHSuj9k+/RVSCoAtt66WZ+VF1ehsvYESO6nR3yR+VKFHLyNh9QnQSzKQnLvStrU7U0z6wvAhwZSfMklG3vyBtO4V7jdJvpyCUQX1eKSXhvnu/Fx8z4b4h14LWuCwhEWhwGE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718887900; c=relaxed/simple;
	bh=rn/xKc0QZnyQyw1/MqaN1bPzDjoef8kwv0cOwEoNu/w=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=j7wFVlxtSQs3d+VgCYefGZ90cNibM/5fiuJn/tuVHXiV5kyrSWYxDYrVRGY8g80DWPmwIE8M2/oLivckzouoH8tPPDU4jn5xf/hBj+/vNsN/vUmPt1XRsZ1Z/lE9L0avLFRSnq6y9P4LD0mTOxSqXZlYHnhMCQceSEVl8b4OSwE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=vdbygXFK; arc=none smtp.client-ip=95.215.58.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="vdbygXFK"
X-Envelope-To: youling.tang@linux.dev
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1718887895;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=QYG5eZDYkp3gQEsRvvA/OGgggUaYoDnBXE/aW0ZGwlc=;
	b=vdbygXFKDLP5mcwftryurjdr7XS4npos/O6d5YOpYhNsbfR7vuGfv/poNO4LwGlkTgg3BF
	p1ETUDD5j+to2eaXmEo/HJrmZQN5s8fTgQpzdgilrwRlAmT2I2Qtq3AU3kseP6/hJ4aHUN
	r6wtsAoBf7WSU6zv5035ZYaUXiUocR0=
X-Envelope-To: linux-bcachefs@vger.kernel.org
X-Envelope-To: linux-kernel@vger.kernel.org
X-Envelope-To: tangyouling@kylinos.cn
Date: Thu, 20 Jun 2024 08:51:30 -0400
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: Youling Tang <youling.tang@linux.dev>
Cc: linux-bcachefs@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Youling Tang <tangyouling@kylinos.cn>
Subject: Re: [PATCH] bcachefs: fix alignment of VMA for memory mapped files
 on THP
Message-ID: <myw2h2mm7725gegy6pbqf4qpzghrfypnlbn4z6rh6idwfjzpjc@chzxxg47sw77>
References: <20240620012242.106698-1-youling.tang@linux.dev>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240620012242.106698-1-youling.tang@linux.dev>
X-Migadu-Flow: FLOW_OUT

On Thu, Jun 20, 2024 at 09:22:42AM +0800, Youling Tang wrote:
> From: Youling Tang <tangyouling@kylinos.cn>
> 
> With CONFIG_READ_ONLY_THP_FOR_FS, the Linux kernel supports using THPs
> for read-only mmapped files, such as shared libraries. However, the
> kernel makes no attempt to actually align those mappings on 2MB
> boundaries, which makes it impossible to use those THPs most of the
> time. This issue applies to general file mapping THP as well as
> existing setups using CONFIG_READ_ONLY_THP_FOR_FS. This is easily
> fixed by using thp_get_unmapped_area for the unmapped_area function
> in bcachefs, which is what ext2, ext4, fuse, xfs and btrfs all use.
> 
> Similar to commit b0c582233a85 ("btrfs: fix alignment of VMA for
> memory mapped files on THP").
> 
> Signed-off-by: Youling Tang <tangyouling@kylinos.cn>

Thanks - applied
