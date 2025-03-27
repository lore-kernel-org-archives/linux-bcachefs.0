Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8733C2192E1;
	Thu, 27 Mar 2025 18:09:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743098964; cv=none; b=m37yHiFJduOFPzopv527LQRGETy6SD6O1CudJm9wxTkN3Ii9kgKElvdqAtkQZSWwhwzBHrzYBg5GhfjEpvtFrtdMOI2EVb9QeGAybe98WCvKbe2gn14EIZEZsZQ1IXxl+AX8eei86YOvZn/yIuIhqS8J/ERku3DvGqeEybGqcrY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743098964; c=relaxed/simple;
	bh=Z5ugAbxZh3x3GNeJqdDv2ia0Z0MhHrrnSc9GQAk1F3c=;
	h=Date:From:To:Cc:Subject:Message-Id:In-Reply-To:References:
	 Mime-Version:Content-Type; b=o3f35n4ngfELlCf7LTpqvqEKaHR9cs14VQ2m7UkCEgUGrhYXgNJFruTrqAmHc93jUHYK+ybT45sNbaOfMb3+/g6FeLip4BeOML/SNaGvvb+f5+cdHzi063USITwQOgeZmbw0gXQFRqgJJYuCraDl8DswCeg5bQD+ozFc0jnMlAk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=POgjIecv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="POgjIecv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BCDF2C4CEDD;
	Thu, 27 Mar 2025 18:09:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1743098963;
	bh=Z5ugAbxZh3x3GNeJqdDv2ia0Z0MhHrrnSc9GQAk1F3c=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=POgjIecvYMh/CdvZ0u4ipe9d0n8QVKOvwvm5XkqbERrOFZQRBuUgQRsjMjYcJR3WY
	 iPjcZh1rjONz3rTJSJbyBecZLJMT+bWy07QKJ81Zo9qc3Awtkhf4eg62C5YapwNgnB
	 fiQ75wSqby0UJlhT4nGpVLmS7NbhN85794/h6osI=
Date: Thu, 27 Mar 2025 11:09:23 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Kent Overstreet <kent.overstreet@linux.dev>
Cc: linux-bcachefs@vger.kernel.org, linux-kernel@vger.kernel.org, Kuan-Wei
 Chiu <visitorckw@gmail.com>
Subject: Re: [PATCH] lib/sort.c: Add _nonatomic() variants with
 cond_resched()
Message-Id: <20250327110923.41e281e75fcf5b1152a55a64@linux-foundation.org>
In-Reply-To: <20250326152606.2594920-1-kent.overstreet@linux.dev>
References: <20250326152606.2594920-1-kent.overstreet@linux.dev>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Wed, 26 Mar 2025 11:26:06 -0400 Kent Overstreet <kent.overstreet@linux.dev> wrote:

> bcachefs calls sort() during recovery to sort all keys it found in the
> journal, and this may be very large - gigabytes on large machines.
> 
> This has been causing "task blocked" warnings, so needs a
> cond_resched().

I assume this has been happening for a while, so a cc:stable is appropriate?
