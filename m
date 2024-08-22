Received: from out-183.mta0.migadu.com (out-183.mta0.migadu.com [91.218.175.183])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C84471CEAC2
	for <linux-bcachefs@vger.kernel.org>; Thu, 22 Aug 2024 17:02:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.183
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724346156; cv=none; b=f+JTRbXAKpnsfpVqcr77VF87kJjFJg9pxFTzoAXN9RRtuzMFTzZcpP601EU8mUpblbEpMCURzFLxg9A10ZL2+IGw5c5Hu3/sTGpsnmPW8gP3HfRszEAEOMnxXw206YPqe4w5wDHoNOx7G0GzStZ2tBRZXK7btFROa49KNhFYi5s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724346156; c=relaxed/simple;
	bh=qIyac7FRZS17y5NyPP/vvfgIoZ3YGywcMPcNzGHXg3s=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=tXg1Uu1JaLmpOaZExd9JvzMl+Tnqc8Xnp8FJkxFcf6i5TAbuCVX3lHyU28OS6yU02HjhUTfLD+2xdd4INGDljVJAkeoaXepEMMjQWmk1LGo3IU+KqdAGHIlVypH2KYLrH6P61euDbiTl/YYjAWUkeMhGtIsbHWdTxyxTyvOmnQM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=YaxTWi0t; arc=none smtp.client-ip=91.218.175.183
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="YaxTWi0t"
Date: Thu, 22 Aug 2024 13:02:29 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1724346152;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=qIyac7FRZS17y5NyPP/vvfgIoZ3YGywcMPcNzGHXg3s=;
	b=YaxTWi0t6a5jVk1najdsgZnJrk5AH6br7mkeZI6EyC1ZM8FlkHUGtEXpwHs+GAtw64/doV
	ObgErcRIxXhvW9e658LQLjNqlQLJ1YK4hgw2RikDlsHT6AOOT5JI/rgrhZDKl4/PlSMYB+
	Hi94Wg6vIdwwOkUXJg/c8ewIv17ngiM=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: syzbot <syzbot+bf2bce2ed29ab7d6e95d@syzkaller.appspotmail.com>
Cc: bfoster@redhat.com, linux-bcachefs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
Subject: Re: [syzbot] [bcachefs?] KMSAN: uninit-value in bch2_xattr_invalid
Message-ID: <652rjq2oqu5q7nebul3nj4l7xkbsyr7j3axswoyxesso5mebg7@sxmqayml7czz>
References: <000000000000544d68061a40dfa5@google.com>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <000000000000544d68061a40dfa5@google.com>
X-Migadu-Flow: FLOW_OUT

#syz invalid
