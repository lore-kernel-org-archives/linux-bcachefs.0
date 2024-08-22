Received: from out-180.mta0.migadu.com (out-180.mta0.migadu.com [91.218.175.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 312B31CEAAD
	for <linux-bcachefs@vger.kernel.org>; Thu, 22 Aug 2024 17:03:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724346220; cv=none; b=edb7S3fN1uMMsn6UtYzIL9ShUxTYCXSmJ+njPqHT9Zzuu7JCbN2hSu/NH+joZEDmw5LrPCRgQppDP/XIpCaz40DMa8KrIgJrUgo04D2/0OY0dx/+QIwVwDFdqsy2F/bNE0YILlL6c537dCNzXmKGsPR3Ta2vfY+23vSGBhsCWVI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724346220; c=relaxed/simple;
	bh=qIyac7FRZS17y5NyPP/vvfgIoZ3YGywcMPcNzGHXg3s=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=b860bjKVBuEvVwZ8439roai5+ejfLt1uKprT5knQp/N3H5amt+Fy/9tOEmhRYS/TfRfbqbxjHHdWNdgIXsEHVHTyJmXrGGHLPIgB7UngrVKNrqZORJNOudSe529jbUmjE8/aEu+iwNbwREz+LQbrAoBSe714ocIF7u5tSd4wTsA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=cWsUuwCy; arc=none smtp.client-ip=91.218.175.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="cWsUuwCy"
Date: Thu, 22 Aug 2024 13:03:26 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1724346217;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=qIyac7FRZS17y5NyPP/vvfgIoZ3YGywcMPcNzGHXg3s=;
	b=cWsUuwCyz6krZfkVXeehDGmiJ6iJkj5Gmo7QbhaeA/I7+90djUxmLAOzC/Mv1kltMJqPbU
	EcKebeZd6j18OkMp0OFTBe1k1HgYd0s7ilSIwDuWiKOI7UC1neL3zP7bBjdlOAG9Rjq+/Y
	QwQ7RE8KO3+SqrUT0Iu/Blt40rQ6zxY=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: syzbot <syzbot+3b2968fa4953885dd66a@syzkaller.appspotmail.com>
Cc: bfoster@redhat.com, linux-bcachefs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
Subject: Re: [syzbot] [bcachefs?] KMSAN: uninit-value in bch2_alloc_v4_invalid
Message-ID: <uccadzeipuxw6a73hykhax3bgeb3ih3yquozf2zplpayyqjef6@ik2oghxmlaqa>
References: <000000000000633dce06194879ad@google.com>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <000000000000633dce06194879ad@google.com>
X-Migadu-Flow: FLOW_OUT

#syz invalid
