Received: from out-189.mta1.migadu.com (out-189.mta1.migadu.com [95.215.58.189])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 090E21BF32F
	for <linux-bcachefs@vger.kernel.org>; Fri, 16 Aug 2024 16:46:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.189
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723826779; cv=none; b=HeLvYTnqB8HuAc6r7sSxL/a5kXTbuc49Tkiia89rT8um82fI6GLVnV6p0x6QhnbutmcJxMzZiwwclwBk6KupQzfgYSgzlm82sbuUeKmrthVbSBNVVvvh8Tf6osVYj7fXo39PaRpR711kN/CemmGt3XmuYIvKnmN9mjBi6WPIrUk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723826779; c=relaxed/simple;
	bh=bU2IaS/hTCl1NmYRI7l6+I/h8qUdzwaDtTWZRiPJI+Y=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=sPJDwnvOEvakUzUiSq3sSa0XytKI7KINfEVh54cAVoGEB6q6d5u279/R4OoUg8hWfCHJz26JNf3iCFMxyf1SBupxrh/zBKJoo+HKFkbgC7qYJrsy6FtIbjePA8cFGWpjU8q1dY4quGo31MPbFt5k8dARSUcxFTUsEswzLkyVLDE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=XsGPhToj; arc=none smtp.client-ip=95.215.58.189
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="XsGPhToj"
Date: Fri, 16 Aug 2024 12:46:12 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1723826776;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=bU2IaS/hTCl1NmYRI7l6+I/h8qUdzwaDtTWZRiPJI+Y=;
	b=XsGPhTojZfgEcRScZdykGS1iezva3QytiyTJtqHPtSXTW0BCamxSOI3Ob1ga0B82BZ8SVQ
	BroytceydKLC2qFteS6xEldn4hVCR20SDVdaZ6a6hN591z7zJnAaXBXW7d/duEu0Q95HDF
	mIN1aY9Xx0n1aTjG0O4vHKbVjRobP34=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: syzbot <syzbot+95e40eae71609e40d851@syzkaller.appspotmail.com>
Cc: linux-bcachefs@vger.kernel.org, linux-kernel@vger.kernel.org, 
	syzkaller-bugs@googlegroups.com
Subject: Re: [syzbot] [bcachefs?] WARNING in discard_new_inode
Message-ID: <g7rfawl5ehyevqoz6rscvf6wew5l5ds2bn4mfapivv2jtkrk7b@ytj5eldr43cu>
References: <0000000000005bb657061fc9e31e@google.com>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0000000000005bb657061fc9e31e@google.com>
X-Migadu-Flow: FLOW_OUT

#syz fix: bcachefs fix incorrect i_state usage
