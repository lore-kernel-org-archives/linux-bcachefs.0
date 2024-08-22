Received: from out-185.mta0.migadu.com (out-185.mta0.migadu.com [91.218.175.185])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2FC1936AE0
	for <linux-bcachefs@vger.kernel.org>; Thu, 22 Aug 2024 03:05:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.185
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724295944; cv=none; b=DUBklB4zRGuaKpEdrrJtzyvyDOGz6vikzERmsc+wNkqOQRpr5Nfm+rVjyglYkjjua0DjwC/gYVAwKYo+7ZMbgIgMm4kJbN2elUVivB/cOdyG/Y4JwKHoRlUOjMRzXucidJa3F58DGq45dEDXl18L3ty8+rhQxvfuM7zfvAOhxLI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724295944; c=relaxed/simple;
	bh=UFV+r/FdDgjmW/Bs3itLM9/eqc9N3lhVHlLcntS/llo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ew0RpnqsXEWQCZj+wIKDM6AdhkKtGiednvKaU2dn5JrwfUYl2tnzWkbXD1WJIrRxZQOj637UVFe1KmU6bfRhLkF2/Hk40ayvYteDn8hSuDbGqo63MQZoF2tJHe1ynWXwNhaRafE+ud6wNMg2fio1w49SgzMxoekoOsdZQpJgrQc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=cwZslOGy; arc=none smtp.client-ip=91.218.175.185
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="cwZslOGy"
Date: Wed, 21 Aug 2024 23:05:33 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1724295940;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=UFV+r/FdDgjmW/Bs3itLM9/eqc9N3lhVHlLcntS/llo=;
	b=cwZslOGyirUAR9ZcVxcEKObuJvktMNy0hQ8PG6LXId88ja1V6nHba1rIpeQCTIbcqxPAmq
	J6EYd8MBJ4xsZX4DCgJydqrkfqD3mskPOUvbFvPwLQEMnZcWY7HfdeOLjb10tJoX18+Jc1
	nnScoGPbA4erBr8AJ1DH1dTrDyQn0e4=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: syzbot <syzbot+e199425e3ce5a18d178c@syzkaller.appspotmail.com>
Cc: bfoster@redhat.com, linux-bcachefs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
Subject: Re: [syzbot] [bcachefs?] WARNING in __virt_to_phys (5)
Message-ID: <bipsafpqx46wlf3pqexkf55goprxj6zkj3sw3cv22n5ybtb5ql@wxtb4xjdfraf>
References: <000000000000983fad061fe3df80@google.com>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <000000000000983fad061fe3df80@google.com>
X-Migadu-Flow: FLOW_OUT

#syz fix: bcachefs: Fix freeing of error pointers
